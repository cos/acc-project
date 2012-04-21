#include <stdio.h>
#include <stdlib.h>

struct SimpleStruct { int M; double X; };

/* Although this is a trivial case of scalar replacement, it is
 * instructive to study the unoptimized code.  Run "make trivial.llvm.bc",
 * disassemble the resulting file, and study it carefully to understand the
 * LLVM code that is generated.
 */
int
main(int argc, char** argv)
{
  struct SimpleStruct S;
  struct SimpleStruct SS;
  struct SimpleStruct *PS;
  if(argc > 2) 
    PS = &S;
  else {
    PS = &SS;
  }
  
  PS->M = 10;
  PS->X = 0.142857;
  printf("testSimple: %d %f\n", PS->M, PS->X);
  return 0;
}
