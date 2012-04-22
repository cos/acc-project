; ModuleID = 'cpu.cpp'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-macosx10.7.3"

@.str = private unnamed_addr constant [12 x i8] c"\0A\0AThe End\0A\0A\00", align 1

define i32 @main(i32 %argc, i8** %argv) uwtable ssp {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i8**, align 8
  %a = alloca [2048 x i32], align 16
  %b = alloca [2048 x i32], align 16
  %n = alloca i32, align 4
  %c = alloca [2048 x i32], align 16
  %n1 = alloca i32, align 4
  store i32 0, i32* %1
  store i32 %argc, i32* %2, align 4
  store i8** %argv, i8*** %3, align 8
  store i32 0, i32* %n, align 4
  br label %4

; <label>:4                                       ; preds = %14, %0
  %5 = load i32* %n, align 4
  %6 = icmp slt i32 %5, 2048
  br i1 %6, label %7, label %17

; <label>:7                                       ; preds = %4
  %8 = load i32* %n, align 4
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds [2048 x i32]* %a, i32 0, i64 %9
  store i32 1, i32* %10, align 4
  %11 = load i32* %n, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds [2048 x i32]* %b, i32 0, i64 %12
  store i32 2, i32* %13, align 4
  br label %14

; <label>:14                                      ; preds = %7
  %15 = load i32* %n, align 4
  %16 = add nsw i32 %15, 1
  store i32 %16, i32* %n, align 4
  br label %4

; <label>:17                                      ; preds = %4
  store i32 0, i32* %n1, align 4
  br label %18

; <label>:18                                      ; preds = %34, %17
  %19 = load i32* %n1, align 4
  %20 = icmp slt i32 %19, 2048
  br i1 %20, label %21, label %37

; <label>:21                                      ; preds = %18
  %22 = load i32* %n1, align 4
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds [2048 x i32]* %a, i32 0, i64 %23
  %25 = load i32* %24, align 4
  %26 = load i32* %n1, align 4
  %27 = sext i32 %26 to i64
  %28 = getelementptr inbounds [2048 x i32]* %b, i32 0, i64 %27
  %29 = load i32* %28, align 4
  %30 = add nsw i32 %25, %29
  %31 = load i32* %n1, align 4
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [2048 x i32]* %c, i32 0, i64 %32
  store i32 %30, i32* %33, align 4
  br label %34

; <label>:34                                      ; preds = %21
  %35 = load i32* %n1, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, i32* %n1, align 4
  br label %18

; <label>:37                                      ; preds = %18
  %38 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([12 x i8]* @.str, i32 0, i32 0))
  ret i32 0
}

declare i32 @printf(i8*, ...)
