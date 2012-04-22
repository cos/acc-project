; ModuleID = 'kernel.cl'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-macosx10.7.3"

define void @square(float addrspace(4)* nocapture %input, float addrspace(4)* nocapture %output, i32 %count) nounwind uwtable ssp {
  %1 = tail call i32 (...)* @get_global_id(i32 0) nounwind
  %2 = icmp ult i32 %1, %count
  br i1 %2, label %3, label %9

; <label>:3                                       ; preds = %0
  %4 = sext i32 %1 to i64
  %5 = getelementptr inbounds float addrspace(4)* %input, i64 %4
  %6 = load float addrspace(4)* %5, align 4
  %7 = fmul float %6, %6
  %8 = getelementptr inbounds float addrspace(4)* %output, i64 %4
  store float %7, float addrspace(4)* %8, align 4
  br label %9

; <label>:9                                       ; preds = %3, %0
  ret void
}

declare i32 @get_global_id(...)

!opencl.kernels = !{!0}

!0 = metadata !{void (float addrspace(4)*, float addrspace(4)*, i32)* @square}
