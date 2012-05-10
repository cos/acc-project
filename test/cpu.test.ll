; ModuleID = 'cpu.test.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.7.0"

%struct._cl_platform_id = type opaque
%struct._cl_device_id = type opaque
%struct._cl_context = type opaque
%struct._cl_command_queue = type opaque
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i32, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i32, i32, [40 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct._cl_program = type opaque
%struct._cl_kernel = type opaque
%struct._cl_mem = type opaque
%struct._cl_event = type opaque

@.str = private unnamed_addr constant [9 x i8] c"Computed\00", align 1
@.strGPU = private unnamed_addr constant [11 x i8] c"kernel.ptx\00", align 1
@.strGPU1 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.strGPU2 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.strGPU3 = private unnamed_addr constant [10 x i8] c"Computed\0A\00", align 1

define i32 @main(i32 %argc, i8** %argv) uwtable ssp {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %data = alloca [1024000 x float], align 16
  %results = alloca [1024000 x float], align 16
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  store i32 0, i32* %i, align 4
  store i32 1024000, i32* %count, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %i, align 4
  %1 = load i32* %count, align 4
  %cmp = icmp ult i32 %0, %1
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %i, align 4
  %idxprom = sext i32 %2 to i64
  %arrayidx = getelementptr inbounds [1024000 x float]* %data, i32 0, i64 %idxprom
  %3 = load float* %arrayidx, align 4
  %4 = load i32* %i, align 4
  %idxprom1 = sext i32 %4 to i64
  %arrayidx2 = getelementptr inbounds [1024000 x float]* %data, i32 0, i64 %idxprom1
  %5 = load float* %arrayidx2, align 4
  %mul = fmul float %3, %5
  %6 = load i32* %i, align 4
  %idxprom3 = sext i32 %6 to i64
  %arrayidx4 = getelementptr inbounds [1024000 x float]* %results, i32 0, i64 %idxprom3
  store float %mul, float* %arrayidx4, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %7 = load i32* %i, align 4
  %inc = add nsw i32 %7, 1
  store i32 %inc, i32* %i, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([9 x i8]* @.str, i32 0, i32 0))
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @main1(i32, i8**)

declare i32 @clGetPlatformIDs(i32, %struct._cl_platform_id**, i32*)

declare i32 @clGetDeviceIDs(%struct._cl_platform_id*, i64, i32, %struct._cl_device_id**, i32*)

declare %struct._cl_context* @clCreateContext(i32*, i32, %struct._cl_device_id**, void (i8*, i8*, i32, i8*)*, i8*, i32*)

declare %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context*, %struct._cl_device_id*, i64, i32*)

declare %struct._IO_FILE* @fopen(i8*, i8*)

declare i32 @fseek(%struct._IO_FILE*, i32, i32)

declare i32 @ftell(%struct._IO_FILE*)

declare void @rewind(%struct._IO_FILE*)

declare noalias i8* @malloc(i32) nounwind

declare i32 @fread(i8*, i32, i32, %struct._IO_FILE*)

declare i32 @fclose(%struct._IO_FILE*)

declare %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context*, i32, %struct._cl_device_id**, i32*, i8**, i32*, i32*)

declare i32 @clBuildProgram(%struct._cl_program*, i32, %struct._cl_device_id**, i8*, void (%struct._cl_program*, i8*)*, i8*)

declare %struct._cl_kernel* @clCreateKernel(%struct._cl_program*, i8*, i32*)

declare %struct._cl_mem* @clCreateBuffer(%struct._cl_context*, i64, i32, i8*, i32*)

declare i32 @clEnqueueWriteBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i32, i32, i8*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clSetKernelArg(%struct._cl_kernel*, i32, i32, i8*)

declare i32 @clGetKernelWorkGroupInfo(%struct._cl_kernel*, %struct._cl_device_id*, i32, i32, i8*, i32*)

declare i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue*, %struct._cl_kernel*, i32, i32*, i32*, i32*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clFinish(%struct._cl_command_queue*)

declare i32 @clEnqueueReadBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i32, i32, i8*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clReleaseMemObject(%struct._cl_mem*)

declare i32 @clReleaseProgram(%struct._cl_program*)

declare i32 @clReleaseKernel(%struct._cl_kernel*)

declare i32 @clReleaseCommandQueue(%struct._cl_command_queue*)

declare i32 @clReleaseContext(%struct._cl_context*)

declare i32 @printf2(i8*, ...)
