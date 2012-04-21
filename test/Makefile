LEVEL = ..

## change or use make TARGET=inputfilename
TARGET=trivial

## replace LLVMROOT and LLVMGCC as appropriate
NETID = `cos`
LLVMROOT = /Users/cos/Projects/cs526/llvm
LLVMGCC = clang
LLVMAS  = $(LLVMROOT)/Debug+Asserts/bin/llvm-as
LLVMDIS = $(LLVMROOT)/Debug+Asserts/bin/llvm-dis
LLVMOPT = $(LLVMROOT)/Debug+Asserts/bin/opt

## change library name appropriately for your system
DYLIB   = /Users/cos/Projects/cs526/mp1/Debug+Asserts/lib/MP1.dylib

## Other choices: test or comparecfe (these will be provided later)
default: clean debug
DEBUGOPTS = ## -verify -inline -mem2reg -simplifycfg -mem2reg -globalopt -globaldce -instcombine -adce -instcombine -simplifycfg

all: clean debug_all
SRCS=$(wildcard *.c)
DBGS=$(SRCS:.c=.diff)
debug_all: $(DBGS)

testsimple: debug

debug: $(TARGET).debug.bc

test: $(TARGET).test.bc

oracle: $(TARGET).oracle.bc

compare: $(TARGET).debug.ll $(TARGET).oracle.ll 
	diffmerge $^

comparecfe:$(TARGET).comparecfe.bc


.PRECIOUS: %.ll

%.diff : %.debug.ll %.oracle.ll
	$(if $(shell diff diff -I 'ModuleID' $^) , diffmerge $^ , echo OK)

%.ll: %.bc
	$(LLVMDIS) -f $<


%.llvm.bc: %.c
	$(LLVMGCC) -S -emit-llvm -o - $< | $(LLVMAS) > $@


%.debug.bc: %.llvm.bc
	$(LLVMOPT) $(DEBUGOPTS) < $< | \
	$(LLVMOPT) -load $(DYLIB) -scalarrepl-cos -dce > $@

%.oracle.bc: %.llvm.bc
	$(LLVMOPT) $(DEBUGOPTS) < $< | \
	$(LLVMOPT) -load $(DYLIB) -scalarrepl -dce > $@

%.original.bc: %.llvm.bc
	$(LLVMOPT) $(DEBUGOPTS) < $< | \
	$(LLVMOPT) -load $(DYLIB) > $@

clean:
	$(RM) -f *.debug.bc *.test.bc *.llvm.bc *.comparecfe.bc *.diff *.ll *.oracle.bc
