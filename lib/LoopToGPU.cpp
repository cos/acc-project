//===-- LoopToGPU.cpp - Loop unroller pass -------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This pass convertes pre-annotated loops to a GPU kernels.  It works best when loops have
// been canonicalized by the -indvars pass.
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "loop-to-gpu"
#include "llvm/IntrinsicInst.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/CodeMetrics.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/UnrollLoop.h"
#include "llvm/Target/TargetData.h"
#include <climits>
#include "llvm/Support/IRReader.h"
#include "llvm/LLVMContext.h"
#include "llvm/Module.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Support/InstIterator.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Support/raw_ostream.h"


using namespace llvm;

namespace {
  class LoopToGPU : public LoopPass {
  public:
    static char ID; // Pass ID, replacement for typeid
    LoopToGPU() : LoopPass(ID) {
    }

    bool runOnLoop(Loop *L, LPPassManager &LPM);
		
    /// This transformation requires natural loop information & requires that
    /// loop preheaders be inserted into the CFG...
    ///
    virtual void getAnalysisUsage(AnalysisUsage &AU) const {
      AU.addRequired<LoopInfo>();
      AU.addPreserved<LoopInfo>();
      AU.addRequiredID(LoopSimplifyID);
      AU.addPreservedID(LoopSimplifyID);
      AU.addRequiredID(LCSSAID);
      AU.addPreservedID(LCSSAID);
      AU.addRequired<ScalarEvolution>();
      AU.addPreserved<ScalarEvolution>();
      // FIXME: Loop unroll requires LCSSA. And LCSSA requires dom info.
      // If loop unroll does not preserve dom info then LCSSA pass on next
      // loop will receive invalid dom info.
      // For now, recreate dom info, if loop is unrolled.
      AU.addPreserved<DominatorTree>();
    }
  };
}

char LoopToGPU::ID = 0;
static RegisterPass<LoopToGPU> X("loop-to-gpu",
                            "Transform loop to GPU kernel");


bool LoopToGPU::runOnLoop(Loop *L, LPPassManager &LPM) {

	BasicBlock *theHeader = L->getHeader();
//	errs() << "The loop: F[" << theHeader->getParent()->getName() << "] Loop %" << theHeader->getName() << "\n";
	Function *hostFunction = theHeader->getParent();
	Module *hostModule = hostFunction->getParent(); errs() << *hostModule;
	SMDiagnostic Err;
	LLVMContext &Context = getGlobalContext();
	Module* originalModule = llvm::ParseIRFile("../gpu.original.ll", Err, Context);
	if (!originalModule) {
//		Err.print("load problem: ", errs());
		return 1;
	}
	
	//
	// MODULE-LEVEL CLONING
	//
	// adapted from CloneModule.cpp
	//
	
	Module *New = hostModule;
	Module *M = originalModule;
	ValueToValueMapTy VMap;
	
	// Copy all of the dependent libraries over.
  for (Module::lib_iterator I = M->lib_begin(), E = M->lib_end(); I != E; ++I)
    New->addLibrary(*I);
	
	// Loop over all of the global variables, making corresponding globals in the
  // new module.  Here we add them to the VMap and to the new Module.  We
  // don't worry about attributes or initializers, they will come later.
  //
	for (Module::const_global_iterator I = M->global_begin(), E = M->global_end();
       I != E; ++I) {
    GlobalVariable *GV = new GlobalVariable(*New, 
                                            I->getType()->getElementType(),
                                            I->isConstant(), I->getLinkage(),
                                            (Constant*) 0, I->getName(),
                                            (GlobalVariable*) 0,
                                            I->isThreadLocal(),
                                            I->getType()->getAddressSpace());
    GV->copyAttributesFrom(I);
    VMap[I] = GV;
  }
	
	Function *originalMain;
	
	Function *gpuFunction;
	
	// Loop over the functions in the module, making external functions as before
  for (Module::const_iterator I = M->begin(), E = M->end(); I != E; ++I) {
		if(I->getName() == "main") {
			originalMain = &cast<Function>(*I);
		} else
		{
    Function *NF =
		Function::Create(cast<FunctionType>(I->getType()->getElementType()),
										 I->getLinkage(), I->getName(), New);
    NF->copyAttributesFrom(I);
			if(NF->getName().find("gpu") < NF->getName().size()) 
				gpuFunction = NF;

    VMap[I] = NF;
		}
  }

	
	// Loop over the aliases in the module
  for (Module::const_alias_iterator I = M->alias_begin(), E = M->alias_end();
       I != E; ++I) {
    GlobalAlias *GA = new GlobalAlias(I->getType(), I->getLinkage(),
                                      I->getName(), NULL, New);
    GA->copyAttributesFrom(I);
    VMap[I] = GA;
  }
	
	// Now that all of the things that global variable initializer can refer to
  // have been created, loop through and copy the global variable referrers
  // over...  We also set the attributes on the global now.
  //
  for (Module::const_global_iterator I = M->global_begin(), E = M->global_end();
       I != E; ++I) {
    GlobalVariable *GV = cast<GlobalVariable>(VMap[I]);
    if (I->hasInitializer())
      GV->setInitializer(MapValue(I->getInitializer(), VMap));
  }
	
	// Similarly, copy over function bodies now...
  //
  for (Module::const_iterator I = M->begin(), E = M->end(); I != E; ++I) {
		if(I->getName() != "main") {
			Function *F = cast<Function>(VMap[I]);
			if (!I->isDeclaration()) {
				Function::arg_iterator DestI = F->arg_begin();
				for (Function::const_arg_iterator J = I->arg_begin(); J != I->arg_end();
						 ++J) {
					DestI->setName(J->getName());
					VMap[J] = DestI++;
				}
				
				SmallVector<ReturnInst*, 8> Returns;  // Ignore returns cloned.
				CloneFunctionInto(F, I, VMap, /*ModuleLevelChanges=*/true, Returns);
			}
		}
	}
	
//	errs() << *hostModule;
	
	//
	// END MODULE-LEVEL CLONING
	//
	
	//
	// START ADAPT HOST FUNCTION
	//
	
	L->getExitBlock()->moveBefore(L->getHeader());
																			
	BasicBlock *forCond, *forBody, *forInc, *forEnd;

	forEnd = L->getExitBlock();
	for (Function::iterator i = hostFunction->begin(), e = hostFunction->end(); i != e; ++i) {
		// Print out the name of the basic block if it has one, and then the
		// number of instructions that it contains
		if(L->contains(i)) {
			if(i->getName() == "for.cond") 
				forCond = i;
			if(i->getName() == "for.body") 
				forBody = i;
			if(i->getName() == "for.inc") 
				forInc = i;			
		}
	}
	
	L->getExitBlock()->removePredecessor(forCond);
	
	// get the iterator and size values from the host function
	BasicBlock::iterator i = forCond->begin();	
	Value *iteratorValue = i->getOperand(0);
	++i;
	Value *sizeValue = i->getOperand(0);	
	
	// get the values withing the loop that have been initialized outside of it
	std::vector<Value*> forInData;
	for (BasicBlock::iterator i = forBody->begin(), e = forBody->end(); i != e; ++i) {
		for (User::op_iterator v = i->op_begin(), ve = i->op_end(); v != ve; ++v) {
			
			if(Instruction *vi = dyn_cast<Instruction>(*v))
				if(!L->contains(vi->getParent()) && vi != iteratorValue) {
					forInData.push_back(vi);
				}
		}
	}
	
	std::sort(forInData.begin(), forInData.end());
	std::vector<Value*>::iterator new_end = std::unique(forInData.begin(), forInData.end()); 
	std::vector<Value*> forInDataUnique;
	for (std::vector<Value*>::iterator it = forInData.begin(); it != new_end; ++it)
	{
		forInDataUnique.push_back(cast<Instruction>(*it));
//		errs() << *cast<Instruction>(*it) << '\n';
	}
	
	Instruction *oldTerminator = L->getLoopPredecessor()->getTerminator();
	
	LoadInst *loadForSize = new LoadInst(sizeValue, "", oldTerminator);	
	forInDataUnique.push_back(loadForSize);
	
//	for (std::vector<Value*>::iterator it = forInDataUnique.begin(); it != forInDataUnique.end(); ++it)
//	{
//		errs() << *cast<Instruction>(*it) << '\n';
//	}
	
//	
//		for (Function::iterator i = gpuFunction->begin(), e = gpuFunction->end(); i != e; ++i) {
//			// Print out the name of the basic block if it has one, and then the
//			// number of instructions that it contains
//					errs() << "Basic block (name=" << i->getName() << ") has "
//					<< i->size() << " instructions." << " : \n" << *i << "\n";
//		}
	
//	CallInst *callGpuInstr = 
	CallInst::Create(gpuFunction, forInDataUnique, "", oldTerminator);
	
	for (BasicBlock::iterator i = L->getExitBlock()->begin(), e = L->getExitBlock()->end(); i != e;) {
			// The next statement works since operator<<(ostream&,...)
			// is overloaded for Instruction&
		Instruction* I = i;
		i++;
		I->removeFromParent();
//					errs() << *I << "\n";
		I->insertBefore(oldTerminator);
	}
	
	oldTerminator->eraseFromParent();
	
//
// END ADAPT HOST FUNCTION
// 
	
//
// GENERATE THE KERNEL
//
	
	Module* kernelModule = llvm::ParseIRFile("../kernel.ll", Err, Context);
	if (!kernelModule) {
		Err.print("load problem: ", errs());
		return 1;
	}

	Function *kernelFunction = kernelModule->getFunction("kernel");
	Instruction *kernelTerminator = kernelFunction->back().getTerminator();
	
	Instruction *kernelI = kernelTerminator->getPrevNode();
	
	ValueToValueMapTy KVMap;	
	
	for (BasicBlock::iterator I = forBody->begin(), e = forBody->end(); I != e; ++I) {
		if(dyn_cast<TerminatorInst>(I))
			continue;
		Instruction *ourI = I->clone();
		
		if (I->hasName())
			ourI->setName(I->getName());
		ourI->insertBefore(kernelTerminator);		
		KVMap[&(cast<Instruction>(*I))] = ourI;                // Add instruction map to value.
	}
	
	KVMap[iteratorValue] = kernelI; // map "i" to "add.i"
	llvm::Function::arg_iterator arguments = kernelFunction->arg_begin();
	KVMap[forInDataUnique[0]] = arguments++;
	KVMap[forInDataUnique[1]] = arguments;
	
	for (BasicBlock::iterator II = kernelFunction->back().begin(), e = kernelFunction->back().end(); II != e; ++II) {
		Instruction *I = &(cast<Instruction>(*II));
		RemapInstruction(I, KVMap, RF_IgnoreMissingEntries);
//		errs() << *I << "\n";	
	}
	
	// replace indirection for add.i
	for (Value::use_iterator i = kernelI->use_begin(), e = kernelI->use_end(); i != e; ++i) {
		Instruction *ii = cast<Instruction>(*i);
		BasicBlock::iterator iii(ii);
		ReplaceInstWithValue(ii->getParent()->getInstList(), iii, kernelI);
	}
	
	std::string Error;
  raw_fd_ostream kernelOutput("kernel.ll", Error);
	
	kernelOutput << *kernelModule;

//	errs() << *kernelModule;
//
// END GENERATE THE KERNEL
//

	
//
// REMOVE THE FOR LOOP
//

	forEnd->dropAllReferences();
	forInc->dropAllReferences();
	forCond->dropAllReferences();
	forBody->dropAllReferences();

	forEnd->eraseFromParent();	
	forInc->eraseFromParent();	
	forCond->eraseFromParent();
	forBody->eraseFromParent();

//	errs()<< *hostModule;
	LPM.deleteLoopFromQueue(L);
	
//	forCond->removeFromParent();
//	forBody->removeFromParent();
//	forInc->removeFromParent();
//	forEnd->removeFromParent();

	
//	errs() << "Exit block: \n" << *(L->getExitBlock());
	
	
	// blk is a pointer to a BasicBlock instance
//	for (BasicBlock::iterator i = blk->begin(), e = blk->end(); i != e; ++i)
//		// The next statement works since operator<<(ostream&,...)
//		// is overloaded for Instruction&
//		errs() << *i << "\n";
//	
	
//	
//	// func is a pointer to a Function instance
//	BasicBlock *exitBlock;
//	for (Function::iterator i = hostFunction->begin(), e = hostFunction->end(); i != e; ++i) {
//		// Print out the name of the basic block if it has one, and then the
//		// number of instructions that it contains
////		errs() << "Basic block (name=" << i->getName() << ") has "
////		<< i->size() << " instructions." << " : \n" << *i << "\n";
//		exitBlock = i;
//	}
//	
//	// F is a pointer to a Function instance
//	Instruction *firstInstruction = &(hostFunction->getEntryBlock().getInstList().front());	
//	SmallPtrSet<Instruction*, 100> instrs;
//	
//	for (inst_iterator I = inst_begin(originalMain), E = inst_end(originalMain); I != E; ++I) {
//		if(I->getName().endswith("GPU")) {
//			Instruction *ourI = I->clone();
//			if (I->hasName())
//				ourI->setName(I->getName());
//			
//			ourI->insertBefore(firstInstruction);		
//			VMap[&cast<Instruction>(*I)] = ourI;                // Add instruction map to value.
//			
//			for (Value::use_iterator i = I->use_begin(), e = I->use_end(); i != e; ++i) {
//				instrs.insert(cast<Instruction>(*i));
//				for (Value::use_iterator i2 = i->use_begin(), e2 = i->use_end(); i2 != e2; ++i2) {   
//					instrs.insert(cast<Instruction>(*i2));					
//					for (Value::use_iterator i3 = i2->use_begin(), e3 = i2->use_end(); i3 != e3; ++i3) {   
//					instrs.insert(cast<Instruction>(*i3));
//					}
//				}
//			}
//		}
//	}
////	Instruction *lastInstruction = &(hostFunction->getExitBlock().getInstList().back());	
//	
//	
//	Instruction *lastInstruction = &(exitBlock->getInstList().back());	
//	
//	for (inst_iterator I = inst_begin(originalMain), E = inst_end(originalMain); I != E; ++I) {
//		Instruction *II = &(cast<Instruction>(*I));
//		if(instrs.count(II)) {
//			Instruction *ourI = I->clone();
//			if (I->hasName())
//				ourI->setName(I->getName()+"GPU");
//			ourI->insertBefore(lastInstruction);		
//			VMap[&(cast<Instruction>(*I))] = ourI;                // Add instruction map to value.
//		}
//	}
//	for (SmallPtrSet<Instruction*,100>::const_iterator I = instrs.begin(), E = instrs.end(); I != E; ++I) {
//		RemapInstruction(&(cast<Instruction>(*VMap[*I])), VMap, RF_IgnoreMissingEntries);
//		errs() << cast<Instruction>(*VMap[*I]) << "\n";	
//	}
//	
//	for (Function::iterator i = hostFunction->begin(), e = hostFunction->end(); i != e; ++i) {
//		// Print out the name of the basic block if it has one, and then the
//		// number of instructions that it contains
//				errs() << "Basic block (name=" << i->getName() << ") has "
//				<< i->size() << " instructions." << " : \n" << *i << "\n";
//	}
	
  return false;
}

