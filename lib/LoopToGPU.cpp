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
	errs() << "The loop: F[" << theHeader->getParent()->getName() << "] Loop %" << theHeader->getName() << "\n";
	Function *theF = theHeader->getParent();
	Module *theM = theF->getParent();
	

	
	SMDiagnostic Err;
	
	LLVMContext &Context = getGlobalContext();
	
	Module* myMod = llvm::ParseIRFile("../gpu.original.ll", Err, Context);
	
	if (!myMod) {
		Err.print("blabla", errs());
		return 1;
	}
	
	for(Module::global_iterator V = myMod->global_begin(), VE = myMod->global_end(); V != VE; ++V) {
		bool isNew = true;
		for(Module::global_iterator V1 = theM->global_begin(), VE1 = theM->global_end(); V1 != VE1; ++V1) {
			errs() << "Name: " << V->getName()<<"\n";
			if(V->getName().compare(V1->getName())==0) {
				errs() << "WE ARE HERE, AT: " << V->getName();
				isNew = false;
			}
			
			
//			if(V1.getParent()==0) 
//				isNew = false
			
		}
		if(isNew) {
			theM->getGlobalList().push_back(V->clone());
		}
	}
	
//	for (Module::iterator F = myMod->begin(), e = myMod->end(); F != e; ++F) {
		
		
		
//		for (Function::iterator B = F->begin(), FE = F->end(); B != FE; ++B) {
//			BasicBlock *Header = L->getHeader();
//			for (BasicBlock::iterator I = B->begin(), BE = B->end(); I != BE; I++) {
////				errs() << *B;
//				Header->getInstList().push_back(I);
//			}
//		}
//	}
	
  return false;
}
