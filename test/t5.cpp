#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

// if branch

int main(int argc, char** argv)
{
    int size= 1024000;
    float data[size];                     // original data set given to device
    float results[size];

    bool runOnGPU = true;
    for(int i=0; i< size; i++)
    {
			if(data[i]>10)
	      results[i]= data[i]*data[i];
    }
    
    return 0;
}
