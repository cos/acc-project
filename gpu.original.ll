; ModuleID = 'gpu.cpp'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:32:32-n8:16:32-S128"
target triple = "i386-pc-linux-gnu"

%struct._cl_platform_id = type opaque
%struct._cl_device_id = type opaque
%struct._cl_context = type opaque
%struct._cl_command_queue = type opaque
%struct._cl_program = type opaque
%struct._cl_kernel = type opaque
%struct._cl_mem = type opaque
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i32, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i32, i32, [40 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct._cl_event = type opaque

@.strGPU = private unnamed_addr constant [11 x i8] c"kernel.ptx\00", align 1
@.strGPU1 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.strGPU2 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.strGPU3 = private unnamed_addr constant [10 x i8] c"Computed\0A\00", align 1

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 4
  %data = alloca [1024000 x float], align 4
  %results = alloca [1024000 x float], align 4
  %global = alloca i32, align 4
  %local = alloca i32, align 4
  %err = alloca i32, align 4
  %status = alloca i32, align 4
  %platforms = alloca i32, align 4
  %platform = alloca %struct._cl_platform_id*, align 4
  %device_id = alloca %struct._cl_device_id*, align 4
  %context = alloca %struct._cl_context*, align 4
  %commands = alloca %struct._cl_command_queue*, align 4
  %program = alloca %struct._cl_program*, align 4
  %kernel = alloca %struct._cl_kernel*, align 4
  %input = alloca %struct._cl_mem*, align 4
  %output = alloca %struct._cl_mem*, align 4
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  %fp = alloca %struct._IO_FILE*, align 4
  %lSize = alloca i32, align 4
  %buffer = alloca i8*, align 4
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 4
  store i32 0, i32* %i, align 4
  store i32 1024000, i32* %count, align 4
  %call = call i32 @clGetPlatformIDs(i32 1, %struct._cl_platform_id** %platform, i32* %platforms)
  store i32 %call, i32* %err, align 4
  %0 = load %struct._cl_platform_id** %platform, align 4
  %call1 = call i32 @clGetDeviceIDs(%struct._cl_platform_id* %0, i64 4, i32 1, %struct._cl_device_id** %device_id, i32* null)
  store i32 %call1, i32* %err, align 4
  %call2 = call %struct._cl_context* @clCreateContext(i32* null, i32 1, %struct._cl_device_id** %device_id, void (i8*, i8*, i32, i8*)* null, i8* null, i32* %err)
  store %struct._cl_context* %call2, %struct._cl_context** %context, align 4
  %1 = load %struct._cl_context** %context, align 4
  %2 = load %struct._cl_device_id** %device_id, align 4
  %call3 = call %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context* %1, %struct._cl_device_id* %2, i64 0, i32* %err)
  store %struct._cl_command_queue* %call3, %struct._cl_command_queue** %commands, align 4
  %call4 = call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([11 x i8]* @.strGPU, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @.strGPU1, i32 0, i32 0))
  store %struct._IO_FILE* %call4, %struct._IO_FILE** %fp, align 4
  %3 = load %struct._IO_FILE** %fp, align 4
  %call5 = call i32 @fseek(%struct._IO_FILE* %3, i32 0, i32 2)
  %4 = load %struct._IO_FILE** %fp, align 4
  %call6 = call i32 @ftell(%struct._IO_FILE* %4)
  store i32 %call6, i32* %lSize, align 4
  %5 = load %struct._IO_FILE** %fp, align 4
  call void @rewind(%struct._IO_FILE* %5)
  %6 = load i32* %lSize, align 4
  %call7 = call noalias i8* @malloc(i32 %6) nounwind
  store i8* %call7, i8** %buffer, align 4
  %7 = load i8** %buffer, align 4
  %8 = load i32* %lSize, align 4
  %9 = load %struct._IO_FILE** %fp, align 4
  %call8 = call i32 @fread(i8* %7, i32 1, i32 %8, %struct._IO_FILE* %9)
  %10 = load %struct._IO_FILE** %fp, align 4
  %call9 = call i32 @fclose(%struct._IO_FILE* %10)
  %11 = load %struct._cl_context** %context, align 4
  %call10 = call %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context* %11, i32 1, %struct._cl_device_id** %device_id, i32* %lSize, i8** %buffer, i32* %status, i32* %err)
  store %struct._cl_program* %call10, %struct._cl_program** %program, align 4
  %12 = load %struct._cl_program** %program, align 4
  %call11 = call i32 @clBuildProgram(%struct._cl_program* %12, i32 0, %struct._cl_device_id** null, i8* null, void (%struct._cl_program*, i8*)* null, i8* null)
  store i32 %call11, i32* %err, align 4
  %13 = load %struct._cl_program** %program, align 4
  %call12 = call %struct._cl_kernel* @clCreateKernel(%struct._cl_program* %13, i8* getelementptr inbounds ([7 x i8]* @.strGPU2, i32 0, i32 0), i32* %err)
  store %struct._cl_kernel* %call12, %struct._cl_kernel** %kernel, align 4
  %14 = load %struct._cl_context** %context, align 4
  %15 = load i32* %count, align 4
  %mul = mul i32 4, %15
  %call13 = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %14, i64 4, i32 %mul, i8* null, i32* null)
  store %struct._cl_mem* %call13, %struct._cl_mem** %input, align 4
  %16 = load %struct._cl_context** %context, align 4
  %17 = load i32* %count, align 4
  %mul14 = mul i32 4, %17
  %call15 = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %16, i64 2, i32 %mul14, i8* null, i32* null)
  store %struct._cl_mem* %call15, %struct._cl_mem** %output, align 4
  %18 = load %struct._cl_command_queue** %commands, align 4
  %19 = load %struct._cl_mem** %input, align 4
  %20 = load i32* %count, align 4
  %mul16 = mul i32 4, %20
  %arraydecay = getelementptr inbounds [1024000 x float]* %data, i32 0, i32 0
  %21 = bitcast float* %arraydecay to i8*
  %call17 = call i32 @clEnqueueWriteBuffer(%struct._cl_command_queue* %18, %struct._cl_mem* %19, i32 1, i32 0, i32 %mul16, i8* %21, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call17, i32* %err, align 4
  store i32 0, i32* %err, align 4
  %22 = load %struct._cl_kernel** %kernel, align 4
  %23 = bitcast %struct._cl_mem** %input to i8*
  %call18 = call i32 @clSetKernelArg(%struct._cl_kernel* %22, i32 0, i32 4, i8* %23)
  store i32 %call18, i32* %err, align 4
  %24 = load %struct._cl_kernel** %kernel, align 4
  %25 = bitcast %struct._cl_mem** %output to i8*
  %call19 = call i32 @clSetKernelArg(%struct._cl_kernel* %24, i32 1, i32 4, i8* %25)
  %26 = load i32* %err, align 4
  %or = or i32 %26, %call19
  store i32 %or, i32* %err, align 4
  %27 = load %struct._cl_kernel** %kernel, align 4
  %28 = bitcast i32* %count to i8*
  %call20 = call i32 @clSetKernelArg(%struct._cl_kernel* %27, i32 2, i32 4, i8* %28)
  %29 = load i32* %err, align 4
  %or21 = or i32 %29, %call20
  store i32 %or21, i32* %err, align 4
  %30 = load %struct._cl_kernel** %kernel, align 4
  %31 = load %struct._cl_device_id** %device_id, align 4
  %32 = bitcast i32* %local to i8*
  %call22 = call i32 @clGetKernelWorkGroupInfo(%struct._cl_kernel* %30, %struct._cl_device_id* %31, i32 4528, i32 4, i8* %32, i32* null)
  store i32 %call22, i32* %err, align 4
  %33 = load i32* %count, align 4
  store i32 %33, i32* %global, align 4
  %34 = load %struct._cl_command_queue** %commands, align 4
  %35 = load %struct._cl_kernel** %kernel, align 4
  %call23 = call i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue* %34, %struct._cl_kernel* %35, i32 1, i32* null, i32* %global, i32* %local, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call23, i32* %err, align 4
  %36 = load %struct._cl_command_queue** %commands, align 4
  %call24 = call i32 @clFinish(%struct._cl_command_queue* %36)
  %37 = load %struct._cl_command_queue** %commands, align 4
  %38 = load %struct._cl_mem** %output, align 4
  %39 = load i32* %count, align 4
  %mul25 = mul i32 4, %39
  %arraydecay26 = getelementptr inbounds [1024000 x float]* %results, i32 0, i32 0
  %40 = bitcast float* %arraydecay26 to i8*
  %call27 = call i32 @clEnqueueReadBuffer(%struct._cl_command_queue* %37, %struct._cl_mem* %38, i32 1, i32 0, i32 %mul25, i8* %40, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call27, i32* %err, align 4
  %41 = load %struct._cl_mem** %input, align 4
  %call28 = call i32 @clReleaseMemObject(%struct._cl_mem* %41)
  %42 = load %struct._cl_mem** %output, align 4
  %call29 = call i32 @clReleaseMemObject(%struct._cl_mem* %42)
  %43 = load %struct._cl_program** %program, align 4
  %call30 = call i32 @clReleaseProgram(%struct._cl_program* %43)
  %44 = load %struct._cl_kernel** %kernel, align 4
  %call31 = call i32 @clReleaseKernel(%struct._cl_kernel* %44)
  %45 = load %struct._cl_command_queue** %commands, align 4
  %call32 = call i32 @clReleaseCommandQueue(%struct._cl_command_queue* %45)
  %46 = load %struct._cl_context** %context, align 4
  %call33 = call i32 @clReleaseContext(%struct._cl_context* %46)
  %call34 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([10 x i8]* @.strGPU3, i32 0, i32 0))
  ret i32 0
}

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

declare i32 @printf(i8*, ...)
