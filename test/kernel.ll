; ModuleID = '../kernel.ll'
target datalayout = "e-p:32:32-i64:64:64-f64:64:64-n1:8:16:32:64"
target triple = "ptx32"

define ptx_kernel void @kernel(float* nocapture %input, float* nocapture %output) nounwind noinline {
entry:
  %0 = tail call i32 @llvm.ptx.read.ntid.x() nounwind
  %1 = tail call i32 @llvm.ptx.read.ctaid.x() nounwind
  %2 = tail call i32 @llvm.ptx.read.tid.x() nounwind
  %mul.i = mul nsw i32 %1, %0
  %add.i = add nsw i32 %mul.i, %2
  br label %for.body

for.body:                                         ; preds = %entry
  %arrayidx = getelementptr inbounds float* %input, i32 %add.i
  %3 = load float* %arrayidx, align 4
  %cmp2 = fcmp ogt float %3, 1.000000e+01
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %arrayidx3 = getelementptr inbounds float* %input, i32 %add.i
  %4 = load float* %arrayidx3, align 4
  %arrayidx4 = getelementptr inbounds float* %input, i32 %add.i
  %5 = load float* %arrayidx4, align 4
  %mul = fmul float %4, %5
  %arrayidx5 = getelementptr inbounds float* %output, i32 %add.i
  store float %mul, float* %arrayidx5, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  ret void
}

declare i32 @llvm.ptx.read.ctaid.x() nounwind readnone

declare i32 @llvm.ptx.read.ntid.x() nounwind readnone

declare i32 @llvm.ptx.read.tid.x() nounwind readnone

!opencl.kernels = !{!0}

!0 = metadata !{void (float*, float*)* @kernel}
