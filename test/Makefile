LEVEL = ..

## change or use make TARGET=inputfilename

include ./Makefile.common

## Other choices: test or comparecfe (these will be provided later)
default: clean test
TESTOPTS = -verify -indvars

all: clean test_all
SRCS=$(wildcard *.c)

DBGS=$(SRCS:.c=.diff)
test_all: $(DBGS)

.PRECIOUS: %.ll

%.diff : %.test.ll %.expected.ll
	$(if $(shell diff diff -I 'ModuleID' $^) , diffmerge $^ , echo OK)

%.ll: %.bc
	$(LLVMDIS) -f $<
	
%.llvm.bc: %.c
	$(LLVMGCC) -S -emit-llvm -o - $< | $(LLVMAS) > $@	
	
%.llvm.bc: %.cpp
	$(LLVMGCC) -S -emit-llvm -o - $< | $(LLVMAS) > $@	

%.test.bc: %.llvm.bc
	$(LLVMOPT) $(TESTOPTS) < $< | \
	$(LLVMOPT) -load $(DYLIB) -loop-to-gpu > $@

%.original.bc: %.llvm.bc
	$(LLVMOPT) $(TESTOPTS) < $< | \
	$(LLVMOPT) -load $(DYLIB) > $@

clean:
	$(RM) -f *.bc *.diff *.test.ll *.original.ll *.llvm.ll