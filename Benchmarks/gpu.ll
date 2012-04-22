; ModuleID = 'gpu.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-macosx10.7.3"

%struct.__sFILE = type { i8*, i32, i32, i16, i16, %struct.__sbuf, i32, i8*, i32 (i8*)*, i32 (i8*, i8*, i32)*, i64 (i8*, i64, i32)*, i32 (i8*, i8*, i32)*, %struct.__sbuf, %struct.__sFILEX*, i32, [3 x i8], [1 x i8], %struct.__sbuf, i32, i64 }
%struct.__sFILEX = type opaque
%struct.__sbuf = type { i8*, i32 }
%struct._cl_command_queue = type opaque
%struct._cl_context = type opaque
%struct._cl_device_id = type opaque
%struct._cl_event = type opaque
%struct._cl_kernel = type opaque
%struct._cl_mem = type opaque
%struct._cl_platform_id = type opaque
%struct._cl_program = type opaque

@.str = private unnamed_addr constant [41 x i8] c"Error: Failed to create a device group!\0A\00", align 1
@.str1 = private unnamed_addr constant [44 x i8] c"Error: Failed to create a compute context!\0A\00", align 1
@.str2 = private unnamed_addr constant [45 x i8] c"Error: Failed to create a command commands!\0A\00", align 1
@.str3 = private unnamed_addr constant [10 x i8] c"kernel.ll\00", align 1
@.str4 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@__stderrp = external global %struct.__sFILE*
@.str5 = private unnamed_addr constant [24 x i8] c"Failed to load kernel.\0A\00", align 1
@.str6 = private unnamed_addr constant [34 x i8] c"Error: Failed to build the kernel\00", align 1
@.str7 = private unnamed_addr constant [7 x i8] c"square\00", align 1
@.str8 = private unnamed_addr constant [41 x i8] c"Error: Failed to create compute kernel!\0A\00", align 1
@.str9 = private unnamed_addr constant [42 x i8] c"Error: Failed to allocate device memory!\0A\00", align 1
@.str10 = private unnamed_addr constant [41 x i8] c"Error: Failed to write to source array!\0A\00", align 1
@.str11 = private unnamed_addr constant [43 x i8] c"Error: Failed to set kernel arguments! %d\0A\00", align 1
@.str12 = private unnamed_addr constant [54 x i8] c"Error: Failed to retrieve kernel work group info! %d\0A\00", align 1
@.str13 = private unnamed_addr constant [34 x i8] c"Error: Failed to execute kernel!\0A\00", align 1
@.str14 = private unnamed_addr constant [40 x i8] c"Error: Failed to read output array! %d\0A\00", align 1
@.str15 = private unnamed_addr constant [9 x i8] c"Computed\00", align 1

define i32 @main(i32 %argc, i8** %argv) uwtable ssp {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
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
  %gpu = alloca i32, align 4
  %fp = alloca %struct.__sFILE*, align 8
  %lSize = alloca i64, align 8
  %buffer = alloca i8*, align 8
  %status = alloca i32, align 4
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 0, i32* %i, align 4
  store i32 1024000, i32* %count, align 4
  store i32 0, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %15, %0
  %5 = load i32* %i, align 4
  %6 = load i32* %count, align 4
  %7 = icmp ult i32 %5, %6
  br i1 %7, label %8, label %18

; <label>:8                                       ; preds = %4
  %9 = call i32 @rand()
  %10 = sitofp i32 %9 to float
  %11 = fdiv float %10, 0x41E0000000000000
  %12 = load i32* %i, align 4
  %13 = sext i32 %12 to i64
  %14 = getelementptr inbounds [1024000 x float]* %data, i32 0, i64 %13
  store float %11, float* %14, align 4
  br label %15

; <label>:15                                      ; preds = %8
  %16 = load i32* %i, align 4
  %17 = add nsw i32 %16, 1
  store i32 %17, i32* %i, align 4
  br label %4

; <label>:18                                      ; preds = %4
  store i32 1, i32* %gpu, align 4
  %19 = load i32* %gpu, align 4
  %20 = icmp ne i32 %19, 0
  %21 = select i1 %20, i32 4, i32 2
  %22 = sext i32 %21 to i64
  %23 = call i32 @clGetDeviceIDs(%struct._cl_platform_id* null, i64 %22, i32 1, %struct._cl_device_id** %device_id, i32* null)
  store i32 %23, i32* %err, align 4
  %24 = load i32* %err, align 4
  %25 = icmp ne i32 %24, 0
  br i1 %25, label %26, label %28

; <label>:26                                      ; preds = %18
  %27 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([41 x i8]* @.str, i32 0, i32 0))
  store i32 1, i32* %1
  br label %181

; <label>:28                                      ; preds = %18
  %29 = call %struct._cl_context* @clCreateContext(i64* null, i32 1, %struct._cl_device_id** %device_id, void (i8*, i8*, i64, i8*)* null, i8* null, i32* %err)
  store %struct._cl_context* %29, %struct._cl_context** %context, align 8
  %30 = load %struct._cl_context** %context, align 8
  %31 = icmp ne %struct._cl_context* %30, null
  br i1 %31, label %34, label %32

; <label>:32                                      ; preds = %28
  %33 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([44 x i8]* @.str1, i32 0, i32 0))
  store i32 1, i32* %1
  br label %181

; <label>:34                                      ; preds = %28
  %35 = load %struct._cl_context** %context, align 8
  %36 = load %struct._cl_device_id** %device_id, align 8
  %37 = call %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context* %35, %struct._cl_device_id* %36, i64 0, i32* %err)
  store %struct._cl_command_queue* %37, %struct._cl_command_queue** %commands, align 8
  %38 = load %struct._cl_command_queue** %commands, align 8
  %39 = icmp ne %struct._cl_command_queue* %38, null
  br i1 %39, label %42, label %40

; <label>:40                                      ; preds = %34
  %41 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([45 x i8]* @.str2, i32 0, i32 0))
  store i32 1, i32* %1
  br label %181

; <label>:42                                      ; preds = %34
  %43 = call %struct.__sFILE* @"\01_fopen"(i8* getelementptr inbounds ([10 x i8]* @.str3, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8]* @.str4, i32 0, i32 0))
  store %struct.__sFILE* %43, %struct.__sFILE** %fp, align 8
  %44 = load %struct.__sFILE** %fp, align 8
  %45 = icmp ne %struct.__sFILE* %44, null
  br i1 %45, label %49, label %46

; <label>:46                                      ; preds = %42
  %47 = load %struct.__sFILE** @__stderrp, align 8
  %48 = call i32 (%struct.__sFILE*, i8*, ...)* @fprintf(%struct.__sFILE* %47, i8* getelementptr inbounds ([24 x i8]* @.str5, i32 0, i32 0))
  call void @exit(i32 1) noreturn
  unreachable

; <label>:49                                      ; preds = %42
  %50 = load %struct.__sFILE** %fp, align 8
  %51 = call i32 @fseek(%struct.__sFILE* %50, i64 0, i32 2)
  %52 = load %struct.__sFILE** %fp, align 8
  %53 = call i64 @ftell(%struct.__sFILE* %52)
  store i64 %53, i64* %lSize, align 8
  %54 = load %struct.__sFILE** %fp, align 8
  call void @rewind(%struct.__sFILE* %54)
  %55 = load i64* %lSize, align 8
  %56 = call i8* @malloc(i64 %55)
  store i8* %56, i8** %buffer, align 8
  %57 = load i8** %buffer, align 8
  %58 = load i64* %lSize, align 8
  %59 = load %struct.__sFILE** %fp, align 8
  %60 = call i64 @fread(i8* %57, i64 1, i64 %58, %struct.__sFILE* %59)
  %61 = load %struct.__sFILE** %fp, align 8
  %62 = call i32 @fclose(%struct.__sFILE* %61)
  %63 = load %struct._cl_context** %context, align 8
  %64 = call %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context* %63, i32 1, %struct._cl_device_id** %device_id, i64* %lSize, i8** %buffer, i32* %status, i32* %err)
  store %struct._cl_program* %64, %struct._cl_program** %program, align 8
  %65 = load %struct._cl_program** %program, align 8
  %66 = call i32 @clBuildProgram(%struct._cl_program* %65, i32 0, %struct._cl_device_id** null, i8* null, void (%struct._cl_program*, i8*)* null, i8* null)
  store i32 %66, i32* %err, align 4
  %67 = load i32* %err, align 4
  %68 = icmp ne i32 %67, 0
  br i1 %68, label %69, label %71

; <label>:69                                      ; preds = %49
  %70 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([34 x i8]* @.str6, i32 0, i32 0))
  br label %71

; <label>:71                                      ; preds = %69, %49
  %72 = load %struct._cl_program** %program, align 8
  %73 = call %struct._cl_kernel* @clCreateKernel(%struct._cl_program* %72, i8* getelementptr inbounds ([7 x i8]* @.str7, i32 0, i32 0), i32* %err)
  store %struct._cl_kernel* %73, %struct._cl_kernel** %kernel, align 8
  %74 = load %struct._cl_kernel** %kernel, align 8
  %75 = icmp ne %struct._cl_kernel* %74, null
  br i1 %75, label %76, label %79

; <label>:76                                      ; preds = %71
  %77 = load i32* %err, align 4
  %78 = icmp ne i32 %77, 0
  br i1 %78, label %79, label %81

; <label>:79                                      ; preds = %76, %71
  %80 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([41 x i8]* @.str8, i32 0, i32 0))
  call void @exit(i32 1) noreturn
  unreachable

; <label>:81                                      ; preds = %76
  %82 = load %struct._cl_context** %context, align 8
  %83 = load i32* %count, align 4
  %84 = zext i32 %83 to i64
  %85 = mul i64 4, %84
  %86 = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %82, i64 4, i64 %85, i8* null, i32* null)
  store %struct._cl_mem* %86, %struct._cl_mem** %input, align 8
  %87 = load %struct._cl_context** %context, align 8
  %88 = load i32* %count, align 4
  %89 = zext i32 %88 to i64
  %90 = mul i64 4, %89
  %91 = call %struct._cl_mem* @clCreateBuffer(%struct._cl_context* %87, i64 2, i64 %90, i8* null, i32* null)
  store %struct._cl_mem* %91, %struct._cl_mem** %output, align 8
  %92 = load %struct._cl_mem** %input, align 8
  %93 = icmp ne %struct._cl_mem* %92, null
  br i1 %93, label %94, label %97

; <label>:94                                      ; preds = %81
  %95 = load %struct._cl_mem** %output, align 8
  %96 = icmp ne %struct._cl_mem* %95, null
  br i1 %96, label %99, label %97

; <label>:97                                      ; preds = %94, %81
  %98 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([42 x i8]* @.str9, i32 0, i32 0))
  call void @exit(i32 1) noreturn
  unreachable

; <label>:99                                      ; preds = %94
  %100 = load %struct._cl_command_queue** %commands, align 8
  %101 = load %struct._cl_mem** %input, align 8
  %102 = load i32* %count, align 4
  %103 = zext i32 %102 to i64
  %104 = mul i64 4, %103
  %105 = getelementptr inbounds [1024000 x float]* %data, i32 0, i32 0
  %106 = bitcast float* %105 to i8*
  %107 = call i32 @clEnqueueWriteBuffer(%struct._cl_command_queue* %100, %struct._cl_mem* %101, i32 1, i64 0, i64 %104, i8* %106, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %107, i32* %err, align 4
  %108 = load i32* %err, align 4
  %109 = icmp ne i32 %108, 0
  br i1 %109, label %110, label %112

; <label>:110                                     ; preds = %99
  %111 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([41 x i8]* @.str10, i32 0, i32 0))
  call void @exit(i32 1) noreturn
  unreachable

; <label>:112                                     ; preds = %99
  store i32 0, i32* %err, align 4
  %113 = load %struct._cl_kernel** %kernel, align 8
  %114 = bitcast %struct._cl_mem** %input to i8*
  %115 = call i32 @clSetKernelArg(%struct._cl_kernel* %113, i32 0, i64 8, i8* %114)
  store i32 %115, i32* %err, align 4
  %116 = load %struct._cl_kernel** %kernel, align 8
  %117 = bitcast %struct._cl_mem** %output to i8*
  %118 = call i32 @clSetKernelArg(%struct._cl_kernel* %116, i32 1, i64 8, i8* %117)
  %119 = load i32* %err, align 4
  %120 = or i32 %119, %118
  store i32 %120, i32* %err, align 4
  %121 = load %struct._cl_kernel** %kernel, align 8
  %122 = bitcast i32* %count to i8*
  %123 = call i32 @clSetKernelArg(%struct._cl_kernel* %121, i32 2, i64 4, i8* %122)
  %124 = load i32* %err, align 4
  %125 = or i32 %124, %123
  store i32 %125, i32* %err, align 4
  %126 = load i32* %err, align 4
  %127 = icmp ne i32 %126, 0
  br i1 %127, label %128, label %131

; <label>:128                                     ; preds = %112
  %129 = load i32* %err, align 4
  %130 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([43 x i8]* @.str11, i32 0, i32 0), i32 %129)
  call void @exit(i32 1) noreturn
  unreachable

; <label>:131                                     ; preds = %112
  %132 = load %struct._cl_kernel** %kernel, align 8
  %133 = load %struct._cl_device_id** %device_id, align 8
  %134 = bitcast i64* %local to i8*
  %135 = call i32 @clGetKernelWorkGroupInfo(%struct._cl_kernel* %132, %struct._cl_device_id* %133, i32 4528, i64 8, i8* %134, i64* null)
  store i32 %135, i32* %err, align 4
  %136 = load i32* %err, align 4
  %137 = icmp ne i32 %136, 0
  br i1 %137, label %138, label %141

; <label>:138                                     ; preds = %131
  %139 = load i32* %err, align 4
  %140 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([54 x i8]* @.str12, i32 0, i32 0), i32 %139)
  call void @exit(i32 1) noreturn
  unreachable

; <label>:141                                     ; preds = %131
  %142 = load i32* %count, align 4
  %143 = zext i32 %142 to i64
  store i64 %143, i64* %global, align 8
  %144 = load %struct._cl_command_queue** %commands, align 8
  %145 = load %struct._cl_kernel** %kernel, align 8
  %146 = call i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue* %144, %struct._cl_kernel* %145, i32 1, i64* null, i64* %global, i64* %local, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %146, i32* %err, align 4
  %147 = load i32* %err, align 4
  %148 = icmp ne i32 %147, 0
  br i1 %148, label %149, label %151

; <label>:149                                     ; preds = %141
  %150 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([34 x i8]* @.str13, i32 0, i32 0))
  store i32 1, i32* %1
  br label %181

; <label>:151                                     ; preds = %141
  %152 = load %struct._cl_command_queue** %commands, align 8
  %153 = call i32 @clFinish(%struct._cl_command_queue* %152)
  %154 = load %struct._cl_command_queue** %commands, align 8
  %155 = load %struct._cl_mem** %output, align 8
  %156 = load i32* %count, align 4
  %157 = zext i32 %156 to i64
  %158 = mul i64 4, %157
  %159 = getelementptr inbounds [1024000 x float]* %results, i32 0, i32 0
  %160 = bitcast float* %159 to i8*
  %161 = call i32 @clEnqueueReadBuffer(%struct._cl_command_queue* %154, %struct._cl_mem* %155, i32 1, i64 0, i64 %158, i8* %160, i32 0, %struct._cl_event** null, %struct._cl_event** null)
  store i32 %161, i32* %err, align 4
  %162 = load i32* %err, align 4
  %163 = icmp ne i32 %162, 0
  br i1 %163, label %164, label %167

; <label>:164                                     ; preds = %151
  %165 = load i32* %err, align 4
  %166 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([40 x i8]* @.str14, i32 0, i32 0), i32 %165)
  call void @exit(i32 1) noreturn
  unreachable

; <label>:167                                     ; preds = %151
  %168 = load %struct._cl_mem** %input, align 8
  %169 = call i32 @clReleaseMemObject(%struct._cl_mem* %168)
  %170 = load %struct._cl_mem** %output, align 8
  %171 = call i32 @clReleaseMemObject(%struct._cl_mem* %170)
  %172 = load %struct._cl_program** %program, align 8
  %173 = call i32 @clReleaseProgram(%struct._cl_program* %172)
  %174 = load %struct._cl_kernel** %kernel, align 8
  %175 = call i32 @clReleaseKernel(%struct._cl_kernel* %174)
  %176 = load %struct._cl_command_queue** %commands, align 8
  %177 = call i32 @clReleaseCommandQueue(%struct._cl_command_queue* %176)
  %178 = load %struct._cl_context** %context, align 8
  %179 = call i32 @clReleaseContext(%struct._cl_context* %178)
  %180 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([9 x i8]* @.str15, i32 0, i32 0))
  store i32 0, i32* %1
  br label %181

; <label>:181                                     ; preds = %167, %149, %40, %32, %26
  %182 = load i32* %1
  ret i32 %182
}

declare i32 @rand()

declare i32 @clGetDeviceIDs(%struct._cl_platform_id*, i64, i32, %struct._cl_device_id**, i32*)

declare i32 @printf(i8*, ...)

declare %struct._cl_context* @clCreateContext(i64*, i32, %struct._cl_device_id**, void (i8*, i8*, i64, i8*)*, i8*, i32*)

declare %struct._cl_command_queue* @clCreateCommandQueue(%struct._cl_context*, %struct._cl_device_id*, i64, i32*)

declare %struct.__sFILE* @"\01_fopen"(i8*, i8*)

declare i32 @fprintf(%struct.__sFILE*, i8*, ...)

declare void @exit(i32) noreturn

declare i32 @fseek(%struct.__sFILE*, i64, i32)

declare i64 @ftell(%struct.__sFILE*)

declare void @rewind(%struct.__sFILE*)

declare i8* @malloc(i64)

declare i64 @fread(i8*, i64, i64, %struct.__sFILE*)

declare i32 @fclose(%struct.__sFILE*)

declare %struct._cl_program* @clCreateProgramWithBinary(%struct._cl_context*, i32, %struct._cl_device_id**, i64*, i8**, i32*, i32*)

declare i32 @clBuildProgram(%struct._cl_program*, i32, %struct._cl_device_id**, i8*, void (%struct._cl_program*, i8*)*, i8*)

declare %struct._cl_kernel* @clCreateKernel(%struct._cl_program*, i8*, i32*)

declare %struct._cl_mem* @clCreateBuffer(%struct._cl_context*, i64, i64, i8*, i32*)

declare i32 @clEnqueueWriteBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i64, i64, i8*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clSetKernelArg(%struct._cl_kernel*, i32, i64, i8*)

declare i32 @clGetKernelWorkGroupInfo(%struct._cl_kernel*, %struct._cl_device_id*, i32, i64, i8*, i64*)

declare i32 @clEnqueueNDRangeKernel(%struct._cl_command_queue*, %struct._cl_kernel*, i32, i64*, i64*, i64*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clFinish(%struct._cl_command_queue*)

declare i32 @clEnqueueReadBuffer(%struct._cl_command_queue*, %struct._cl_mem*, i32, i64, i64, i8*, i32, %struct._cl_event**, %struct._cl_event**)

declare i32 @clReleaseMemObject(%struct._cl_mem*)

declare i32 @clReleaseProgram(%struct._cl_program*)

declare i32 @clReleaseKernel(%struct._cl_kernel*)

declare i32 @clReleaseCommandQueue(%struct._cl_command_queue*)

declare i32 @clReleaseContext(%struct._cl_context*)
