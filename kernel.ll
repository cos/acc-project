; ModuleID = 'kernel.cl'
target datalayout = "e-p:32:32-i64:64:64-f64:64:64-n1:8:16:32:64"
target triple = "ptx32"

define ptx_kernel void @kernel(float* nocapture %input, float* nocapture %output) nounwind noinline {
entry:
  %0 = tail call i32 @llvm.ptx.read.ntid.x() nounwind
  %1 = tail call i32 @llvm.ptx.read.ctaid.x() nounwind
  %2 = tail call i32 @llvm.ptx.read.tid.x() nounwind
  %mul.i = mul nsw i32 %1, %0
  %add.i = add nsw i32 %mul.i, %2
  ret void
}

declare i32 @llvm.ptx.read.ctaid.x() nounwind readnone

declare i32 @llvm.ptx.read.ntid.x() nounwind readnone

declare i32 @llvm.ptx.read.tid.x() nounwind readnone

!opencl.kernels = !{!0}

!0 = metadata !{void (float*, float*)* @kernel}
!1 = metadata !{metadata !"float", metadata !2}
!2 = metadata !{metadata !"omnipotent char", metadata !3}
!3 = metadata !{metadata !"Simple C/C++ TBAA"}
