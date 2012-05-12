LEVEL = ..

## change or use make TARGET=inputfilename

include ./Makefile.common

## Other choices: test or comparecfe (these will be provided later)
default: clean test
TESTOPTS = # -verify -indvars

all: clean test_all
SRCS=$(wildcard *.c)

DBGS=$(SRCS:.c=.diff)
test_all: $(DBGS)

.PRECIOUS: %.ll

%.diff : %.test.ll %.expected.ll %.test.kernel.ll
	$(if $(shell diff diff -I 'ModuleID' $^) , diffmerge $^ , echo OK)

%.ll: %.bc
	$(LLVMDIS) -f $<
	
%.llvm.bc: %.c
	$(LLVMGCC) -arch i386 -S -emit-llvm -o - $< | $(LLVMAS) > $@	
	
%.llvm.bc: %.cpp
	$(LLVMGCC) -arch i386 -S -emit-llvm -o - $< | $(LLVMAS) > $@	

%.test.bc: %.llvm.bc
	$(LLVMOPT) $(TESTOPTS) < $< | \
	$(LLVMOPT) -load $(DYLIB) -loop-to-gpu > $@
	$(LLVMDIS) -f $@
	
%.test.kernel.ll: %.test.bc
	mv kernel.ll $@
	open $@

%.original.bc: %.llvm.bc
	$(LLVMOPT) $(TESTOPTS) < $< | \
	$(LLVMOPT) -load $(DYLIB) > $@

clean:
	$(RM) -f *.bc *.diff *.test.ll *.original.ll *.llvm.ll
