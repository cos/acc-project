
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

// test changing variable names and order

int main(int argc, char** argv)
{
    int size= 1024000;
		float another[size];
    float some[size];                     // original data set given to device

    bool runOnGPU = true;
    for(int i=0; i< size; i++)
    {
      another[i]= some[i]*some[i];
    }
    
    return 0;
}
