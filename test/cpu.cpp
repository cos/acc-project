
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>


#define SIZE (1024000)


int main(int argc, char** argv)
{

    float data[SIZE];                     // original data set given to device
    float results[SIZE];                 // results returned from device

    int i = 0;
    unsigned int count = SIZE;
    
    for(i=0; i< count; i++)
    {
      results[i]= data[i]*data[i];
    }

    printf("Computed");
    
    return 0;
}

