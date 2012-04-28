; ModuleID = 'gpu.original.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.7.0"

%struct._cl_device_id = type opaque
%struct._cl_context = type opaque
%struct._cl_command_queue = type opaque
%struct._cl_program = type opaque
%struct._cl_kernel = type opaque
%struct._cl_mem = type opaque
%struct._cl_platform_id = type opaque

define i32 @main(i32 %argc, i8** %argv) uwtable ssp {
entry:
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
  store i32 %argc, i32* %argc.addr, align 4
  store i8** %argv, i8*** %argv.addr, align 8
  store i32 0, i32* %i, align 4
  store i32 1024000, i32* %count, align 4
  %call = call i32 @clGetDeviceIDs(%struct._cl_platform_id* null, i64 4, i32 1, %struct._cl_device_id** %device_id, i32* null)
  store i32 %call, i32* %err, align 4
  ret i32 0
}

declare i32 @clGetDeviceIDs(%struct._cl_platform_id*, i64, i32, %struct._cl_device_id**, i32*)
