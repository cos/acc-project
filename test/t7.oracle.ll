; ModuleID = 't7.oracle.bc'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-macosx10.7.3"

%struct.SimpleStruct = type { i32, double }

@.str = private unnamed_addr constant [16 x i8] c"testSimple: %d\0A\00"
@.str1 = private unnamed_addr constant [19 x i8] c"testSimple: %d %f\0A\00"

define i32 @main(i32 %argc, i8** %argv) nounwind ssp {
  %S = alloca %struct.SimpleStruct, align 8
  %SS = alloca %struct.SimpleStruct, align 8
  br label %1

; <label>:1                                       ; preds = %10, %0
  %PS.0 = phi %struct.SimpleStruct* [ %SS, %0 ], [ %PS.1, %10 ]
  %i.0 = phi i32 [ undef, %0 ], [ %7, %10 ]
  %2 = icmp sgt i32 %i.0, 10
  br i1 %2, label %3, label %11

; <label>:3                                       ; preds = %1
  %4 = getelementptr inbounds %struct.SimpleStruct* %PS.0, i32 0, i32 0
  %5 = load i32* %4, align 4
  %6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([16 x i8]* @.str, i32 0, i32 0), i32 %5)
  %7 = add nsw i32 %i.0, 1
  %8 = icmp sgt i32 %7, 5
  br i1 %8, label %9, label %10

; <label>:9                                       ; preds = %3
  br label %10

; <label>:10                                      ; preds = %9, %3
  %PS.1 = phi %struct.SimpleStruct* [ %S, %9 ], [ %PS.0, %3 ]
  br label %1

; <label>:11                                      ; preds = %1
  %12 = getelementptr inbounds %struct.SimpleStruct* %PS.0, i32 0, i32 0
  store i32 10, i32* %12, align 4
  %13 = getelementptr inbounds %struct.SimpleStruct* %PS.0, i32 0, i32 0
  %14 = load i32* %13, align 4
  %15 = getelementptr inbounds %struct.SimpleStruct* %PS.0, i32 0, i32 1
  %16 = load double* %15, align 8
  %17 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([19 x i8]* @.str1, i32 0, i32 0), i32 %14, double %16)
  ret i32 0
}

declare i32 @printf(i8*, ...)
