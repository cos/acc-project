//===- ScalarReplAggregates.cpp - Scalar Replacement of Aggregates --------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file was developed by the LLVM research group and is distributed under
// the University of Illinois Open Source License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// 
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "scalarrepl"
#include "llvm/Transforms/Scalar.h"
#include "llvm/DerivedTypes.h"
#include "llvm/Function.h"
#include "llvm/Module.h"
#include "llvm/Instructions.h"
#include "llvm/LLVMContext.h"
#include "llvm/Pass.h"
#include "llvm/Analysis/Dominators.h"
#include "llvm/Target/TargetData.h"
#include "llvm/Transforms/Utils/PromoteMemToReg.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"

#include "llvm/Support/InstIterator.h"
#include "llvm/User.h"
#include "llvm/Value.h"
#include "llvm/Constants.h"
#include "llvm/Type.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

using namespace llvm;

STATISTIC(NumExpanded,  "Number of aggregate allocas broken up");
STATISTIC(NumPromoted,  "Number of scalar allocas promoted to register");

namespace {
  //--------------------------------------------------------------------------//
  // class SROA: Scalar Replacement of Aggregates function pass.
  // 
  // The main entry point is runOnFunction.
  // The pass is registered using the declaration of a static global
  // variable (X) below.
  //--------------------------------------------------------------------------//
  
  struct SROA : public FunctionPass {
    static char ID;             // Pass identification
    
    SROA() : FunctionPass(ID) { } 
    
    // Entry point for the overall scalar-replacement pass
    bool runOnFunction(Function &F);
    
    // Promotes allocas to registers, which can enable more scalar replacement
    bool performPromotion(Function &F);
    
    // Entry point for the scalar-replacement transformation itself
    SmallVector<AllocaInst*, 10>* performScalarRepl(Function &F, SmallVector<AllocaInst*, 10> *allocas);
    
    // getAnalysisUsage - This pass does not require any passes, but we know it
    // will not alter the CFG, so say so.
    virtual void getAnalysisUsage(AnalysisUsage &AU) const {
      AU.addRequired<DominatorTree>();
      AU.setPreservesCFG();
    }
    
  private:
    bool isCleanLoadFromPointer(LoadInst *Inst, Value *P);
    bool isCleanStoreToPointer(StoreInst *Inst, Value *P);
    bool isAllocationPromotable(AllocaInst *AI);
    bool isConstantIndexStartingFromZero(GetElementPtrInst *Inst);  
    bool U1(GetElementPtrInst *I);
    bool U2(ICmpInst *I);
    bool isAllocationExpandable(AllocaInst *AI);
    void expandAllocation(AllocaInst *AI, SmallVector<AllocaInst*, 10>* allocas);
    SmallVector<AllocaInst*, 10>* populate(Function &F);
    bool areUsesSafe(Instruction *I, SmallVector<PHINode*, 3>* phiSafeList);
    bool U4(PHINode* , SmallVector<PHINode*, 3>* phiSafeList);
    bool fixUses(Instruction* AI, unsigned offset, Value* newAlloca, SmallVector<PHINode*, 3>* processedPhis);
    void cleanUnusedAllocas(Function &F);
  };
}

//--------------------------------------------------------------------------//
// Register the pass so it is accessible from the command line,
// via the pass manager.
//--------------------------------------------------------------------------//
char SROA::ID = 0;
static RegisterPass<SROA> X("scalarrepl-cos",
                            "Cosmin's Scalar Replacement of Aggregates");

//----------------------------------------------------------------------------//
// 
// Function runOnFunction:
// Entry point for the overall ScalarReplAggregates function pass.
// This function is provided to you.
// 
//----------------------------------------------------------------------------//

bool SROA::runOnFunction(Function &F) {
  bool Changed = performPromotion(F);
  
  // the initial set of allocas
  SmallVector<AllocaInst*, 10> *allocas = populate(F);
  
  // worklist approach, while there are unprocessed struct allocas
  while (!allocas->empty()) {
    // try to perform scalar replacement on them and get the 
    // new set of allocas (struct members of expanded ones)
    allocas = performScalarRepl(F, allocas);
    if (allocas == NULL) break;  // if no aggregate was expanded, we're finished
    Changed = true;
    // try a promotion, but if no promotion is made, there can still
    // be newly added aggregates to be expanded
    performPromotion(F); 
  }
  
  // just a light cleanup. not necessary as we rely on a post -dce 
  if(Changed)
    cleanUnusedAllocas(F);
  
  return Changed;
}


//----------------------------------------------------------------------------//
// Function isCleanLoadFromPointer:
// Checks whether the LoadInst is a non-volatile load from the pointer.
//----------------------------------------------------------------------------//

bool SROA::isCleanLoadFromPointer(LoadInst *Inst, Value *P) {
  if(Inst->isVolatile())
    return false;
  
  return Inst->getPointerOperand() == P;
}

//----------------------------------------------------------------------------//
// Function isCleanStoreToPointer:
// Checks whether the LoadInst is a non-volatile load from the pointer
// and the pointer is not actually written back in.
//----------------------------------------------------------------------------//

bool SROA::isCleanStoreToPointer(StoreInst *Inst, Value *P) {
  if(Inst->isVolatile())
    return false;
  
  //  for(unsigned i = 0; i< Inst->getNumOperands(); i++) 
  //    if(i != Inst->getPointerOperandIndex() && Inst->getOperand(i) == P) 
  //      return false;
  //TODO: fix this
  
  return Inst->getPointerOperand() == P;
}


//----------------------------------------------------------------------------//
// Function isAllocationPromotable:
// Checks whether a specific allocation is promotable.
//----------------------------------------------------------------------------//
bool SROA::isAllocationPromotable(AllocaInst *AI) {
  // it should be scalar
  Type *t = AI->getAllocatedType();
  if(!t->isPointerTy() && !t->isDoubleTy() && !t->isIntegerTy())
    return false;
  
  errs() << "Checking AllocaInst: " << *AI << "\n";
  
  // iterate over the Users of the allocation(pointer)
  
  for (Value::use_iterator i = AI->use_begin(), e = AI->use_end(); i != e; ++i) { 
    Instruction *I = dyn_cast<Instruction>(*i);
    errs() << "  checking ... " << *I << "\n";
    // if it is a load or a store
    // check that our pointer is exactly in the pointerOperand position
    // and it is not volatile
    if (LoadInst *Inst = dyn_cast<LoadInst>(*i))
      if(isCleanLoadFromPointer(Inst, AI))
        continue;
    
    if (StoreInst *Inst = dyn_cast<StoreInst>(*i))
      if(isCleanStoreToPointer(Inst, AI))
        continue;
    return false;
  }
  return true;
}



//----------------------------------------------------------------------------//
// Function performPromotion:
// Promote allocas to registers, which can enable more scalar replacement.
//----------------------------------------------------------------------------//

bool SROA::performPromotion(Function &F) {
  DominatorTree &DT = getAnalysis<DominatorTree>();
  
  
  std::vector<AllocaInst*> Allocas;
  
  // iterate over the instructions in the entry BasicBlock
  // AllocaInst can only live here
  BasicBlock &BB = F.getEntryBlock();  // Get the entry node for the function  
  
  for (BasicBlock::iterator i = (&BB)->begin(), e = (&BB)->end(); i != e; ++i)
    if (AllocaInst *AI = dyn_cast<AllocaInst>(i)) 
      if(isAllocationPromotable(AI)) {
        NumPromoted ++;
        Allocas.push_back(AI); // gather promotable AllocaInst
      }
  
  if(!Allocas.empty()) { // if there are any, promote them
    PromoteMemToReg(Allocas, DT); 
    return true;
  } else
    return false;
}

//----------------------------------------------------------------------------//
// Function isConstantIndexStartingFromZero:
// Checks that the GEP is of the form: getelementptr ptr, 0, constant
//----------------------------------------------------------------------------//

bool SROA::isConstantIndexStartingFromZero(GetElementPtrInst *Inst) {
  // two indices
  if(Inst->getNumIndices() != 2) 
    return false;
  
  // the first is zero
  if(ConstantInt *OP = dyn_cast<ConstantInt>(Inst->getOperand(1)))
    if(!OP->isZero())
      return false;
  
  // the second is constant
  if(!isa<ConstantInt>(Inst->getOperand(2))) 
    return false;
  
  return true;
}

//----------------------------------------------------------------------------//
// Function areUsesSafe:
// Condition U1, mostly as specified
// I've relaxed it to allow PHI node uses. Seems safe. Otherwise, might need 
// to areUsesSafe on it.
//----------------------------------------------------------------------------//
bool SROA::U1(GetElementPtrInst *I) {
  errs() << "GEP: " << *I << "\n";
  
  if (GetElementPtrInst *Inst = dyn_cast<GetElementPtrInst>(I)) {    
    if(!isConstantIndexStartingFromZero(Inst))
      return false;
    for (Value::use_iterator i = Inst->use_begin(), e = Inst->use_end(); i != e; ++i) {    
      Instruction *I = dyn_cast<Instruction>(*i);
      errs() << "  checking ... " << *I << "\n";
      
      if (GetElementPtrInst *GEPInst = dyn_cast<GetElementPtrInst>(*i)) 
        if(U1(GEPInst))
          continue;
      
      if (LoadInst *LInst = dyn_cast<LoadInst>(*i))
        if(isCleanLoadFromPointer(LInst, Inst))
          continue;
      
      if (StoreInst *SInst = dyn_cast<StoreInst>(*i))
        if(isCleanStoreToPointer(SInst, Inst))
          continue;
      
      if(isa<PHINode>(*i))
        continue;
      
      errs() << "Failed on ... "<< *I << "\n";
      return false;
    }
    return true;
  } else
    return false;
}

bool SROA::U2(ICmpInst *I) {
  if(Constant *V = dyn_cast<Constant>(I->getOperand(0)))
    if(V->isNullValue()) return true;
  
  if(Constant *V = dyn_cast<Constant>(I->getOperand(1)))
    if(V->isNullValue()) return true;  
  return false;
}

//----------------------------------------------------------------------------//
// Function areUsesSafe:
// Condition U4: are phi accesses safe?
//----------------------------------------------------------------------------//
bool SROA::U4(PHINode *I, SmallVector<PHINode*, 3>* phiSafeList) {
  errs() << "Phi: " << *I << "\n";
  return areUsesSafe(I, phiSafeList);
}

//----------------------------------------------------------------------------//
// Function areUsesSafe:
// Checks whether the uses of Instruction (of pointer type struct) 
// are safe to be replaced with accesses to individual members
//----------------------------------------------------------------------------//
bool SROA::areUsesSafe(Instruction *I, SmallVector<PHINode*, 3>* phiSafeList) {
  for (Value::use_iterator i = I->use_begin(), e = I->use_end(); i != e; ++i) {    
    if (GetElementPtrInst *Inst = dyn_cast<GetElementPtrInst>(*i)) 
      if (U1(Inst)) {
        continue;
      } else
        return false;
    
    if (ICmpInst *Inst = dyn_cast<ICmpInst>(*i)) 
      if(U2(Inst))
        continue;
    
    if(PHINode *Inst = dyn_cast<PHINode>(*i))
    {
      if(std::find(phiSafeList->begin(), phiSafeList->end(), Inst)!=phiSafeList->end())
        continue;
      phiSafeList->push_back(Inst);
      if(U4(Inst, phiSafeList))
        continue;
    }
    
    return false;
  }
  return true;
}

//----------------------------------------------------------------------------//
// Function isAllocationExpandable:
// Checks whether a specific allocation is promotable.
//----------------------------------------------------------------------------//
bool SROA::isAllocationExpandable(AllocaInst *AI) {
  errs()<< "Processing ... " << *AI << "\n\n";
  if(!AI->getAllocatedType()->isStructTy())
    return false;
  
  SmallVector<PHINode*, 3>* phiSafeList = new SmallVector<PHINode* , 3>;
  
  return areUsesSafe(AI, phiSafeList);
}

//----------------------------------------------------------------------------//
// Function fixUses:
// replaces all "GEP OrigInst, 0, offset" with use of newValue
// it also recursively solves PHI accesses
//----------------------------------------------------------------------------//
bool SROA::fixUses(Instruction* OrigInst, unsigned offset, Value* newValue, SmallVector<PHINode*, 3>* processedPhis) {
  bool valueUsed = false;
  for (Value::use_iterator ii = OrigInst->use_begin(), e = OrigInst->use_end(); ii != e; ++ii) {
    if (GetElementPtrInst *Inst = dyn_cast<GetElementPtrInst>(*ii)) {
      if(dyn_cast<ConstantInt>(Inst->getOperand(2))->getZExtValue() == offset) {
        // replace GEP with newValue
        BasicBlock::iterator ii(Inst);
        ReplaceInstWithValue(Inst->getParent()->getInstList(), ii, newValue);
        valueUsed = true;
      }
    }
    if (PHINode *Inst = dyn_cast<PHINode>(*ii)) {
      errs() << "PHI: " << *Inst << "\n";
      
      // if we already seen this phi
      if(std::find(processedPhis->begin(), processedPhis->end(), Inst)!=processedPhis->end())
        continue;
      
      processedPhis->push_back(Inst);
      
      Type *T = newValue->getType();
      unsigned noIncoming = Inst->getNumIncomingValues();
      PHINode *newPhi = PHINode::Create(T, 0, "", Inst);
      bool changedDownstream = fixUses(Inst, offset, newPhi, processedPhis);
      if(changedDownstream) {
        ConstantInt *zeroConstant = ConstantInt::get(Type::getInt32Ty(OrigInst->getContext()), 0);        
        ConstantInt *offsetConstant = ConstantInt::get(Type::getInt32Ty(OrigInst->getContext()), offset);
        Value *offsets[2] = {zeroConstant, offsetConstant};
        
        for(unsigned i=0;i<noIncoming;i++) {
          errs() << "\nblabla\n" << i << "\n\n";
          Value *incoming = Inst->getIncomingValue(i);
          if(incoming == OrigInst) {
            newPhi->addIncoming(newValue, Inst->getIncomingBlock(i));
          } else {
            Value *newValueForOtherBranch;
            if(Instruction *Incoming = dyn_cast<Instruction>(incoming)) {
              newValueForOtherBranch = GetElementPtrInst::Create(incoming, offsets);
              cast<Instruction>(newValueForOtherBranch)->insertAfter(Incoming);
            } else 
                newValueForOtherBranch = Constant::getNullValue(T);
            
            newPhi->addIncoming(newValueForOtherBranch, Inst->getIncomingBlock(i));
          }
        }
        valueUsed = true;
      }
      if(newPhi->getNumIncomingValues()==0)
        newPhi->eraseFromParent();
    }
  }
  return valueUsed;
}

//----------------------------------------------------------------------------//
// Function expandAllocation:
// The function expands an indivicual alloca and puts all generated struct
// allocas in newAllocas, i.e., it adds them to the worklist
//----------------------------------------------------------------------------//

void SROA::expandAllocation(AllocaInst *AI, SmallVector<AllocaInst*, 10>* newAllocas) {
  NumExpanded ++;
  
  // Get the type of the sturct alloca
  StructType *T = cast<StructType>(AI->getAllocatedType());
  
  // For each of its members
  for(unsigned i=0 ; i< T->getNumElements() ; i++) { 
    
    // get the memeber's type and create a new alloca for it
    Type *TT = T->getElementType(i);
    AllocaInst *ai = new AllocaInst(TT);
    ai->insertBefore(AI);    
    
    // update all uses of this member to the new alloca
    bool allocaUsed = fixUses(AI, i, ai, new SmallVector<PHINode*, 3>());
    allocaUsed = true;
    
    if(allocaUsed) {
    // if the new alloca is of struct type, add it to the worklist
      if(TT->isStructTy())
        newAllocas->push_back(ai);
    } else {
    // if there were no uses, remove the new alloca
      ai->eraseFromParent();
      delete ai;
    }
  }
}

//----------------------------------------------------------------------------//
// Function populate:
// This function generates the initial set of allocas, i.e., 
// all initial allocas
//----------------------------------------------------------------------------//
SmallVector<AllocaInst*, 10>* SROA::populate(Function &F) {
  SmallVector<AllocaInst*, 10> *allocas = new SmallVector<AllocaInst*, 10>();
  // iterate over the instructions in the entry BasicBlock
  // AllocaInst can only live here
  BasicBlock &BB = F.getEntryBlock();
  for (BasicBlock::iterator i = (&BB)->begin(), e = (&BB)->end(); i != e; ++i)
    if (AllocaInst *AI = dyn_cast<AllocaInst>(i))
      allocas->push_back(AI);
  return allocas;
}


//----------------------------------------------------------------------------//
// Function cleanUnusedAllocas:
// Not really needed. Just wanted to do a bit of cleanup before -dce
//----------------------------------------------------------------------------//
void SROA::cleanUnusedAllocas(Function &F) {
  // iterate over the instructions in the entry BasicBlock
  // and remove unused allocas
  BasicBlock &BB = F.getEntryBlock();
  for (BasicBlock::iterator i = (&BB)->begin(), e = (&BB)->end(); i != e;)
    if (AllocaInst *AI = dyn_cast<AllocaInst>(i))
      if(AI->getNumUses() == 0) {
        i++;
        AI->eraseFromParent();
      }
      else 
        ++i;
      else 
        ++i;
}


//----------------------------------------------------------------------------//
// Function performScalarRepl:
// Entry point for a single pass of the scalar-replacement transformation itself.
// returns null if nothing is expanded
//----------------------------------------------------------------------------//

SmallVector<AllocaInst*, 10>* SROA::performScalarRepl(Function &F, SmallVector<AllocaInst*, 10> *allocas) {
  bool expandedSome = false;
  SmallVector<AllocaInst*, 10> *newAllocas = new SmallVector<AllocaInst*, 10>();
  
  for(SmallVector<AllocaInst*, 10>::iterator i = allocas->begin(), e = allocas->end(); i != e; ++i) {
    if(isAllocationExpandable(*i)) {
      errs() << "\n\nExpandable\n\n";
      expandAllocation(*i, newAllocas);
      expandedSome = true;
    }
  }
  
  if(expandedSome)
    return newAllocas;
  else
    return NULL;
}
