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
  struct SimpleStruct *PS = &SS;
  int i;
  while(i>10) {
    printf("testSimple: %d\n", PS->M);    
    i++;
    if(i>5) 
      PS = &S;  
  }

PS->M = 10;
printf("testSimple: %d %f\n", PS->M, PS->X);
return 0;
}
