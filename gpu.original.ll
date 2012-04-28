; ModuleID = 'gpu.original.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.7.0"




%struct._cl_device_id = type opaque
%struct._cl_context = type opaque
%struct._cl_command_queue = type opaque
%struct._cl_program = type opaque
%struct._cl_kernel = type opaque
%struct._cl_mem = type opaque
%struct.__sFILE = type { i8*, i32, i32, i16, i16, %struct.__sbuf, i32, i8*, i32 (i8*)*, i32 (i8*, i8*, i32)*, i64 (i8*, i64, i32)*, i32 (i8*, i8*, i32)*, %struct.__sbuf, %struct.__sFILEX*, i32, [3 x i8], [1 x i8], %struct.__sbuf, i32, i64 }
%struct.__sbuf = type { i8*, i32 }
%struct.__sFILEX = type opaque
%struct._cl_platform_id = type opaque
%struct._cl_event = type opaque

@.str = private unnamed_addr constant [10 x i8] c"kernel.ll\00", align 1
@.str1 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str2 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.str3 = private unnamed_addr constant [43 x i8] c"Error: Failed to set kernel arguments! %d\0A\00", align 1
@.str4 = private unnamed_addr constant [9 x i8] c"Computed\00", align 1

define i32 @main(i32 %argc, i8** %argv) uwtable ssp {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  %data = alloca [1024000 x float], align 16
  %results = alloca [1024000 x float], align 16
  %global = alloca i64, align 8
  %local = alloca i64, align 8
  %err = alloca i32, align 4
  %device_id = alloca %struct._cl_device_id*, align 8
  %context = alloca %struct._cl_context*, align 8
  %commands = alloca %struct._cl_command_queue*, align 8
  %program = alloca %struct._cl_program*, align 8
  %kernel = alloca %struct._cl_kernel*, align 8
  %input = alloca %struct._cl_mem*, align 8
  %output = alloca %struct._cl_mem*, align 8
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  %fp = alloca %struct.__sFILE*, align 8
  %lSize = alloca i64, align 8
  %buffer = alloca i8*, align 8
  %status = alloca i32, align 4
  store i32 0, i32* %retval
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  store i32 0, i32* %i, align 4
  store i32 1024000, i32* %count, align 4
  %call = call i32 @clGetDeviceIDs(%struct._cl_platform_id* null, i64 4, i32 1, %struct._cl_device_id** %device_id, i32* null)
  store i32 %call, i32* %err, align 4
  %call1 = call %struct._cl_context* @clCreateContext(i64* null, i32 1, %struct._cl_device_id** %device_id, void (i8*, i8*, i64, i8*)* null, i8* null, i32* %err)
  store %struct._cl_context* %call1, %struct._cl_context** %context, align 8
  %0 = load %struct._cl_context** %context, align 8
  %1 = load %struct._cl_device_id** %device_id, align 8
  %call2 = call %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context* %0, %struct._cl_device_id* %1, i64 0, i32* %err)
  store %struct._cl_command_queue* %call2, %struct._cl_command_queue** %commands, align 8
  %call3 = call %struct.__sFILE* @"\01_fopen"(i8* getelementptr inbounds ([10 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @.str1, i32 0, i32 0))
  store %struct.__sFILE* %call3, %struct.__sFILE** %fp, align 8
  %2 = load %struct.__sFILE** %fp, align 8
  %call4 = call i64 @ftell(%struct.__sFILE* %2)
  store i64 %call4, i64* %lSize, align 8
  %3 = load %struct._cl_context** %context, align 8
  %call5 = call %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context* %3, i32 1, %struct._cl_device_id** %device_id, i64* %lSize, i8** %buffer, i32* %status, i32* %err)
  store %struct._cl_program* %call5, %struct._cl_program** %program, align 8
  %4 = load %struct._cl_program** %program, align 8
  %call6 = call i32 @clBuildProgram(%struct._cl_program* %4, i32 0, %struct._cl_device_id** null, i8* null, void (%struct._cl_program*, i8*)* null, i8* null)
  store i32 %call6, i32* %err, align 4
  %5 = load %struct._cl_program** %program, align 8
  %call7 = call %struct._cl_kernel* @clCreateKernel(%struct._cl_program* %5, i8* getelementptr inbounds ([7 x i8]* @.str2, i32 0, i32 0), i32* %err)
  store %struct._cl_kernel* %call7, %struct._cl_kernel** %kernel, align 8
  %6 = load %struct._cl_context** %context, align 8
  %7 = load i32* %count, align 4
  %conv = zext i32 %7 to i64
  %mul = mul i64 4, %conv
  %call8 = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %6, i64 4, i64 %mul, i8* null, i32* null)
  store %struct._cl_mem* %call8, %struct._cl_mem** %input, align 8
  %8 = load %struct._cl_context** %context, align 8
  %9 = load i32* %count, align 4
  %conv9 = zext i32 %9 to i64
  %mul10 = mul i64 4, %conv9
  %call11 = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %8, i64 2, i64 %mul10, i8* null, i32* null)
  store %struct._cl_mem* %call11, %struct._cl_mem** %output, align 8
  %10 = load %struct._cl_command_queue** %commands, align 8
  %11 = load %struct._cl_mem** %input, align 8
  %12 = load i32* %count, align 4
  %conv12 = zext i32 %12 to i64
  %mul13 = mul i64 4, %conv12
  %arraydecay = getelementptr inbounds [1024000 x float]* %data, i32 0, i32 0
  %13 = bitcast float* %arraydecay to i8*
  %call14 = call i32 @clEnqueueWriteBuffer(%struct._cl_command_queue* %10, %struct._cl_mem* %11, i32 1, i64 0, i64 %mul13, i8* %13, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call14, i32* %err, align 4
  store i32 0, i32* %err, align 4
  %14 = load %struct._cl_kernel** %kernel, align 8
  %15 = bitcast %struct._cl_mem** %input to i8*
  %call15 = call i32 @clSetKernelArg(%struct._cl_kernel* %14, i32 0, i64 8, i8* %15)
  store i32 %call15, i32* %err, align 4
  %16 = load %struct._cl_kernel** %kernel, align 8
  %17 = bitcast %struct._cl_mem** %output to i8*
  %call16 = call i32 @clSetKernelArg(%struct._cl_kernel* %16, i32 1, i64 8, i8* %17)
  %18 = load i32* %err, align 4
  %or = or i32 %18, %call16
  store i32 %or, i32* %err, align 4
  %19 = load %struct._cl_kernel** %kernel, align 8
  %20 = bitcast i32* %count to i8*
  %call17 = call i32 @clSetKernelArg(%struct._cl_kernel* %19, i32 2, i64 4, i8* %20)
  %21 = load i32* %err, align 4
  %or18 = or i32 %21, %call17
  store i32 %or18, i32* %err, align 4
  %22 = load i32* %err, align 4
  %cmp = icmp ne i32 %22, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %23 = load i32* %err, align 4
  %call19 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([43 x i8]* @.str3, i32 0, i32 0), i32 %23)
  call void @exit(i32 1) noreturn
  unreachable

if.end:                                           ; preds = %entry
  %24 = load %struct._cl_kernel** %kernel, align 8
  %25 = load %struct._cl_device_id** %device_id, align 8
  %26 = bitcast i64* %local to i8*
  %call20 = call i32 @clGetKernelWorkGroupInfo(%struct._cl_kernel* %24, %struct._cl_device_id* %25, i32 4528, i64 8, i8* %26, i64* null)
  store i32 %call20, i32* %err, align 4
  %27 = load i32* %count, align 4
  %conv21 = zext i32 %27 to i64
  store i64 %conv21, i64* %global, align 8
  %28 = load %struct._cl_command_queue** %commands, align 8
  %29 = load %struct._cl_kernel** %kernel, align 8
  %call22 = call i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue* %28, %struct._cl_kernel* %29, i32 1, i64* null, i64* %global, i64* %local, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call22, i32* %err, align 4
  %30 = load %struct._cl_command_queue** %commands, align 8
  %call23 = call i32 @clFinish(%struct._cl_command_queue* %30)
  %31 = load %struct._cl_command_queue** %commands, align 8
  %32 = load %struct._cl_mem** %output, align 8
  %33 = load i32* %count, align 4
  %conv24 = zext i32 %33 to i64
  %mul25 = mul i64 4, %conv24
  %arraydecay26 = getelementptr inbounds [1024000 x float]* %results, i32 0, i32 0
  %34 = bitcast float* %arraydecay26 to i8*
  %call27 = call i32 @clEnqueueReadBuffer(%struct._cl_command_queue* %31, %struct._cl_mem* %32, i32 1, i64 0, i64 %mul25, i8* %34, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %call27, i32* %err, align 4
  %35 = load %struct._cl_mem** %input, align 8
  %call28 = call i32 @clReleaseMemObject(%struct._cl_mem* %35)
  %36 = load %struct._cl_mem** %output, align 8
  %call29 = call i32 @clReleaseMemObject(%struct._cl_mem* %36)
  %37 = load %struct._cl_program** %program, align 8
  %call30 = call i32 @clReleaseProgram(%struct._cl_program* %37)
  %38 = load %struct._cl_kernel** %kernel, align 8
  %call31 = call i32 @clReleaseKernel(%struct._cl_kernel* %38)
  %39 = load %struct._cl_command_queue** %commands, align 8
  %call32 = call i32 @clReleaseCommandQueue(%struct._cl_command_queue* %39)
  %40 = load %struct._cl_context** %context, align 8
  %call33 = call i32 @clReleaseContext(%struct._cl_context* %40)
  %call34 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([9 x i8]* @.str4, i32 0, i32 0))
  ret i32 0
}

declare i32 @clGetDeviceIDs(%struct._cl_platform_id*, i64, i32, %struct._cl_device_id**, i32*)

declare %struct._cl_context* @clCreateContext(i64*, i32, %struct._cl_device_id**, void (i8*, i8*, i64, i8*)*, i8*, i32*)

declare %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context*, %struct._cl_device_id*, i64, i32*)

declare %struct.__sFILE* @"\01_fopen"(i8*, i8*)

declare i64 @ftell(%struct.__sFILE*)

declare %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context*, i32, %struct._cl_device_id**, i64*, i8**, i32*, i32*)

declare i32 @clBuildProgram(%struct._cl_program*, i32, %struct._cl_device_id**, i8*, void (%struct._cl_program*, i8*)*, i8*)

declare %struct._cl_kernel* @clCreateKernel(%struct._cl_program*, i8*, i32*)

declare %struct._cl_mem* @clCreateBuffer(%struct._cl_context*, i64, i64, i8*, i32*)

declare i32 @clEnqueueWriteBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i64, i64, i8*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clSetKernelArg(%struct._cl_kernel*, i32, i64, i8*)

declare i32 @printf(i8*, ...)

declare void @exit(i32) noreturn

declare i32 @clGetKernelWorkGroupInfo(%struct._cl_kernel*, %struct._cl_device_id*, i32, i64, i8*, i64*)

declare i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue*, %struct._cl_kernel*, i32, i64*, i64*, i64*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clFinish(%struct._cl_command_queue*)

declare i32 @clEnqueueReadBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i64, i64, i8*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clReleaseMemObject(%struct._cl_mem*)

declare i32 @clReleaseProgram(%struct._cl_program*)

declare i32 @clReleaseKernel(%struct._cl_kernel*)

declare i32 @clReleaseCommandQueue(%struct._cl_command_queue*)

declare i32 @clReleaseContext(%struct._cl_context*)
