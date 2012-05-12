; ModuleID = 't1.test.bc'
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128-n8:16:32-S128"
target triple = "i386-apple-macosx10.7.0"

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

@.str = private unnamed_addr constant [11 x i8] c"kernel.ptx\00", align 1
@.str1 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"kernel\00", align 1
@.str3 = private unnamed_addr constant [13 x i8] c"GPU is done\0A\00", align 1

define i32 @main(i32 %argc, i8** %argv) nounwind ssp {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 4
  %size = alloca i32, align 4
  %saved_stack = alloca i8*
  %runOnGPU = alloca i8, align 1
  %i = alloca i32, align 4
  %cleanup.dest.slot = alloca i32
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 4
  store i32 1024000, i32* %size, align 4
  %0 = load i32* %size, align 4
  %1 = call i8* @llvm.stacksave()
  store i8* %1, i8** %saved_stack
  %vla = alloca float, i32 %0, align 4
  %2 = load i32* %size, align 4
  %vla1 = alloca float, i32 %2, align 4
  store i8 1, i8* %runOnGPU, align 1
  store i32 0, i32* %i, align 4
  %3 = load i32* %size
  call void @_Z3gpuPfS_i(float* %vla, float* %vla1, i32 %3)
  store i32 0, i32* %retval
  store i32 1, i32* %cleanup.dest.slot
  %4 = load i8** %saved_stack
  call void @llvm.stackrestore(i8* %4)
  %5 = load i32* %retval
  ret i32 %5
}

declare i8* @llvm.stacksave() nounwind

declare void @llvm.stackrestore(i8*) nounwind

declare i8* @llvm.stacksave1() nounwind

define void @_Z3gpuPfS_i(float* %data, float* %results, i32 %size) {
entry:
  %data.addr = alloca float*, align 4
  %results.addr = alloca float*, align 4
  %size.addr = alloca i32, align 4
  %globalGPU = alloca i32, align 4
  %localGPU = alloca i32, align 4
  %errGPU = alloca i32, align 4
  %statusGPU = alloca i32, align 4
  %platformsGPU = alloca i32, align 4
  %platformGPU = alloca %struct._cl_platform_id*, align 4
  %device_idGPU = alloca %struct._cl_device_id*, align 4
  %contextGPU = alloca %struct._cl_context*, align 4
  %commandsGPU = alloca %struct._cl_command_queue*, align 4
  %programGPU = alloca %struct._cl_program*, align 4
  %kernelGPU = alloca %struct._cl_kernel*, align 4
  %inputGPU = alloca %struct._cl_mem*, align 4
  %outputGPU = alloca %struct._cl_mem*, align 4
  %fpGPU = alloca %struct._IO_FILE*, align 4
  %lSizeGPU = alloca i32, align 4
  %bufferGPU = alloca i8*, align 4
  store float* %data, float** %data.addr, align 4
  store float* %results, float** %results.addr, align 4
  store i32 %size, i32* %size.addr, align 4
  %call = call i32 @clGetPlatformIDs(i32 1, %struct._cl_platform_id** %platformGPU, i32* %platformsGPU)
  store i32 %call, i32* %errGPU, align 4
  %0 = load %struct._cl_platform_id** %platformGPU, align 4
  %call1 = call i32 @clGetDeviceIDs(%struct._cl_platform_id* %0, i64 4, i32 1, %struct._cl_device_id** %device_idGPU, i32* null)
  store i32 %call1, i32* %errGPU, align 4
  %call2 = call %struct._cl_context* @clCreateContext(i32* null, i32 1, %struct._cl_device_id** %device_idGPU, void (i8*, i8*, i32, i8*)* null, i8* null, i32* %errGPU)
  store %struct._cl_context* %call2, %struct._cl_context** %contextGPU, align 4
  %1 = load %struct._cl_context** %contextGPU, align 4
  %2 = load %struct._cl_device_id** %device_idGPU, align 4
  %call3 = call %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context* %1, %struct._cl_device_id* %2, i64 0, i32* %errGPU)
  store %struct._cl_command_queue* %call3, %struct._cl_command_queue** %commandsGPU, align 4
  %call4 = call %struct._IO_FILE* @fopen(i8* getelementptr inbounds ([11 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @.str1, i32 0, i32 0))
  store %struct._IO_FILE* %call4, %struct._IO_FILE** %fpGPU, align 4
  %3 = load %struct._IO_FILE** %fpGPU, align 4
  %call5 = call i32 @fseek(%struct._IO_FILE* %3, i32 0, i32 2)
  %4 = load %struct._IO_FILE** %fpGPU, align 4
  %call6 = call i32 @ftell(%struct._IO_FILE* %4)
  store i32 %call6, i32* %lSizeGPU, align 4
  %5 = load %struct._IO_FILE** %fpGPU, align 4
  call void @rewind(%struct._IO_FILE* %5)
  %6 = load i32* %lSizeGPU, align 4
  %call7 = call noalias i8* @malloc(i32 %6) nounwind
  store i8* %call7, i8** %bufferGPU, align 4
  %7 = load i8** %bufferGPU, align 4
  %8 = load i32* %lSizeGPU, align 4
  %9 = load %struct._IO_FILE** %fpGPU, align 4
  %call8 = call i32 @fread(i8* %7, i32 1, i32 %8, %struct._IO_FILE* %9)
  %10 = load %struct._IO_FILE** %fpGPU, align 4
  %call9 = call i32 @fclose(%struct._IO_FILE* %10)
  %11 = load %struct._cl_context** %contextGPU, align 4
  %call10 = call %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context* %11, i32 1, %struct._cl_device_id** %device_idGPU, i32* %lSizeGPU, i8** %bufferGPU, i32* %statusGPU, i32* %errGPU)
  store %struct._cl_program* %call10, %struct._cl_program** %programGPU, align 4
  %12 = load %struct._cl_program** %programGPU, align 4
  %call11 = call i32 @clBuildProgram(%struct._cl_program* %12, i32 0, %struct._cl_device_id** null, i8* null, void (%struct._cl_program*, i8*)* null, i8* null)
  store i32 %call11, i32* %errGPU, align 4
  %13 = load %struct._cl_program** %programGPU, align 4
  %call12 = call %struct._cl_kernel* @clCreateKernel(%struct._cl_program* %13, i8* getelementptr inbounds ([7 x i8]* @.str2, i32 0, i32 0), i32* %errGPU)
  store %struct._cl_kernel* %call12, %struct._cl_kernel** %kernelGPU, align 4
  %14 = load %struct._cl_context** %contextGPU, align 4
  %15 = load i32* %size.addr, align 4
  %mul = mul i32 4, %15
  %call13 = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %14, i64 4, i32 %mul, i8* null, i32* null)
  store %struct._cl_mem* %call13, %struct._cl_mem** %inputGPU, align 4
  %16 = load %struct._cl_context** %contextGPU, align 4
  %17 = load i32* %size.addr, align 4
  %mul14 = mul i32 4, %17
  %call15 = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %16, i64 2, i32 %mul14, i8* null, i32* null)
  store %struct._cl_mem* %call15, %struct._cl_mem** %outputGPU, align 4
  %18 = load %struct._cl_command_queue** %commandsGPU, align 4
  %19 = load %struct._cl_mem** %inputGPU, align 4
  %20 = load i32* %size.addr, align 4
  %mul16 = mul i32 4, %20
  %21 = load float** %data.addr, align 4
  %22 = bitcast float* %21 to i8*
  %call17 = call i32 @clEnqueueWriteBuffer(%struct._cl_command_queue* %18, %struct._cl_mem* %19, i32 1, i32 0, i32 %mul16, i8* %22, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call17, i32* %errGPU, align 4
  store i32 0, i32* %errGPU, align 4
  %23 = load %struct._cl_kernel** %kernelGPU, align 4
  %24 = bitcast %struct._cl_mem** %inputGPU to i8*
  %call18 = call i32 @clSetKernelArg(%struct._cl_kernel* %23, i32 0, i32 4, i8* %24)
  store i32 %call18, i32* %errGPU, align 4
  %25 = load %struct._cl_kernel** %kernelGPU, align 4
  %26 = bitcast %struct._cl_mem** %outputGPU to i8*
  %call19 = call i32 @clSetKernelArg(%struct._cl_kernel* %25, i32 1, i32 4, i8* %26)
  %27 = load i32* %errGPU, align 4
  %or = or i32 %27, %call19
  store i32 %or, i32* %errGPU, align 4
  %28 = load %struct._cl_kernel** %kernelGPU, align 4
  %29 = load %struct._cl_device_id** %device_idGPU, align 4
  %30 = bitcast i32* %localGPU to i8*
  %call20 = call i32 @clGetKernelWorkGroupInfo(%struct._cl_kernel* %28, %struct._cl_device_id* %29, i32 4528, i32 4, i8* %30, i32* null)
  store i32 %call20, i32* %errGPU, align 4
  %31 = load i32* %size.addr, align 4
  store i32 %31, i32* %globalGPU, align 4
  %32 = load %struct._cl_command_queue** %commandsGPU, align 4
  %33 = load %struct._cl_kernel** %kernelGPU, align 4
  %call21 = call i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue* %32, %struct._cl_kernel* %33, i32 1, i32* null, i32* %globalGPU, i32* %localGPU, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call21, i32* %errGPU, align 4
  %34 = load %struct._cl_command_queue** %commandsGPU, align 4
  %call22 = call i32 @clFinish(%struct._cl_command_queue* %34)
  %35 = load %struct._cl_command_queue** %commandsGPU, align 4
  %36 = load %struct._cl_mem** %outputGPU, align 4
  %37 = load i32* %size.addr, align 4
  %mul23 = mul i32 4, %37
  %38 = load float** %results.addr, align 4
  %39 = bitcast float* %38 to i8*
  %call24 = call i32 @clEnqueueReadBuffer(%struct._cl_command_queue* %35, %struct._cl_mem* %36, i32 1, i32 0, i32 %mul23, i8* %39, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call24, i32* %errGPU, align 4
  %40 = load %struct._cl_mem** %inputGPU, align 4
  %call25 = call i32 @clReleaseMemObject(%struct._cl_mem* %40)
  %41 = load %struct._cl_mem** %outputGPU, align 4
  %call26 = call i32 @clReleaseMemObject(%struct._cl_mem* %41)
  %42 = load %struct._cl_program** %programGPU, align 4
  %call27 = call i32 @clReleaseProgram(%struct._cl_program* %42)
  %43 = load %struct._cl_kernel** %kernelGPU, align 4
  %call28 = call i32 @clReleaseKernel(%struct._cl_kernel* %43)
  %44 = load %struct._cl_command_queue** %commandsGPU, align 4
  %call29 = call i32 @clReleaseCommandQueue(%struct._cl_command_queue* %44)
  %45 = load %struct._cl_context** %contextGPU, align 4
  %call30 = call i32 @clReleaseContext(%struct._cl_context* %45)
  %call31 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str3, i32 0, i32 0))
  ret void
}

declare void @llvm.stackrestore2(i8*) nounwind

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
