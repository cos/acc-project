; ModuleID = 't7.debug.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-macosx10.7.3"

%struct.SimpleStruct = type { i32, double }

@.str = private unnamed_addr constant [16 x i8] c"testSimple: %d\0A\00"
@.str1 = private unnamed_addr constant [19 x i8] c"testSimple: %d %f\0A\00"

define i32 @main(i32 %argc, i8** %argv) nounwind ssp {
  %1 = alloca i32
  %2 = alloca double
  %S = alloca %struct.SimpleStruct, align 8
  %3 = alloca i32
  %4 = alloca double
  %SS = alloca %struct.SimpleStruct, align 8
  br label %5

; <label>:5                                       ; preds = %17, %0
  %6 = phi i32* [ %3, %0 ], [ %18, %17 ]
  %7 = phi double* [ %4, %0 ], [ %19, %17 ]
  %8 = phi i32* [ %3, %0 ], [ %21, %17 ]
  %9 = phi double* [ %4, %0 ], [ %20, %17 ]
  %PS.0 = phi %struct.SimpleStruct* [ %SS, %0 ], [ %PS.1, %17 ]
  %i.0 = phi i32 [ undef, %0 ], [ %14, %17 ]
  %10 = icmp sgt i32 %i.0, 10
  br i1 %10, label %11, label %22

; <label>:11                                      ; preds = %5
  %12 = load i32* %6, align 4
  %13 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0), i32 %12)
  %14 = add nsw i32 %i.0, 1
  %15 = icmp sgt i32 %14, 5
  br i1 %15, label %16, label %17

; <label>:16                                      ; preds = %11
  br label %17

; <label>:17                                      ; preds = %16, %11
  %18 = phi i32* [ %1, %16 ], [ %8, %11 ]
  %19 = phi double* [ %2, %16 ], [ %9, %11 ]
  %PS.1 = phi %struct.SimpleStruct* [ %S, %16 ], [ %PS.0, %11 ]
  %20 = getelementptr %struct.SimpleStruct* %PS.1, i32 0, i32 1
  %21 = getelementptr %struct.SimpleStruct* %PS.1, i32 0, i32 0
  br label %5

; <label>:22                                      ; preds = %5
  store i32 10, i32* %6, align 4
  %23 = load i32* %6, align 4
  %24 = load double* %7, align 8
  %25 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i32 %23, double %24)
  ret i32 0
}

declare i32 @printf(i8*, ...)
