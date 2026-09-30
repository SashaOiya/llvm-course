; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@app.u = internal unnamed_addr global [256 x [256 x float]] zeroinitializer, align 16
@app.next_u = internal unnamed_addr global [256 x [256 x float]] zeroinitializer, align 16

; Function Attrs: noreturn nounwind optsize uwtable
define dso_local void @app() local_unnamed_addr #0 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(262144) @app.u, i8 0, i64 262144, i1 false), !tbaa !5
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(262144) @app.next_u, i8 0, i64 262144, i1 false), !tbaa !5
  br label %1

1:                                                ; preds = %10, %0
  %2 = phi i64 [ 116, %0 ], [ %11, %10 ]
  br label %3

3:                                                ; preds = %3, %1
  %4 = phi i64 [ 0, %1 ], [ %8, %3 ]
  %5 = add i64 %4, 116
  %6 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %2, i64 %5
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %6, align 16, !tbaa !5
  %7 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %2, i64 %5
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %7, align 16, !tbaa !5
  %8 = add nuw i64 %4, 4
  %9 = icmp eq i64 %8, 24
  br i1 %9, label %10, label %3, !llvm.loop !9

10:                                               ; preds = %3
  %11 = add nuw nsw i64 %2, 1
  %12 = icmp eq i64 %11, 140
  br i1 %12, label %13, label %1, !llvm.loop !13

13:                                               ; preds = %10, %66
  %14 = phi i32 [ %67, %66 ], [ 0, %10 ]
  br label %15

15:                                               ; preds = %13, %53
  %16 = phi i64 [ 1, %13 ], [ %20, %53 ]
  %17 = trunc i64 %16 to i32
  %18 = add i32 %17, -116
  %19 = icmp ult i32 %18, 24
  %20 = add nuw nsw i64 %16, 1
  %21 = add nsw i64 %16, -1
  br label %22

22:                                               ; preds = %15, %48
  %23 = phi i64 [ 1, %15 ], [ %49, %48 ]
  %24 = trunc i64 %23 to i32
  %25 = add i32 %24, -116
  %26 = icmp ult i32 %25, 24
  %27 = and i1 %19, %26
  br i1 %27, label %28, label %30

28:                                               ; preds = %22
  %29 = add nuw nsw i64 %23, 1
  br label %48

30:                                               ; preds = %22
  %31 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %16, i64 %23
  %32 = load float, ptr %31, align 4, !tbaa !5
  %33 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %20, i64 %23
  %34 = load float, ptr %33, align 4, !tbaa !5
  %35 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %21, i64 %23
  %36 = load float, ptr %35, align 4, !tbaa !5
  %37 = fadd float %34, %36
  %38 = add nuw nsw i64 %23, 1
  %39 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %16, i64 %38
  %40 = load float, ptr %39, align 4, !tbaa !5
  %41 = fadd float %37, %40
  %42 = add nsw i64 %23, -1
  %43 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %16, i64 %42
  %44 = load float, ptr %43, align 4, !tbaa !5
  %45 = fadd float %41, %44
  %46 = tail call float @llvm.fmuladd.f32(float %32, float -4.000000e+00, float %45)
  %47 = tail call float @llvm.fmuladd.f32(float %46, float 0x3FCC28F5C0000000, float %32)
  br label %48

48:                                               ; preds = %28, %30
  %49 = phi i64 [ %29, %28 ], [ %38, %30 ]
  %50 = phi float [ 1.000000e+02, %28 ], [ %47, %30 ]
  %51 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %16, i64 %23
  store float %50, ptr %51, align 4
  %52 = icmp eq i64 %49, 255
  br i1 %52, label %53, label %22, !llvm.loop !14

53:                                               ; preds = %48
  %54 = icmp eq i64 %20, 255
  br i1 %54, label %55, label %15, !llvm.loop !15

55:                                               ; preds = %53, %55
  %56 = phi i64 [ %61, %55 ], [ 0, %53 ]
  %57 = shl nuw nsw i64 %56, 10
  %58 = add nuw nsw i64 %57, 1028
  %59 = getelementptr i8, ptr @app.u, i64 %58
  %60 = getelementptr i8, ptr @app.next_u, i64 %58
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(1016) %59, ptr noundef nonnull align 4 dereferenceable(1016) %60, i64 1016, i1 false), !tbaa !5
  %61 = add nuw nsw i64 %56, 1
  %62 = icmp eq i64 %61, 254
  br i1 %62, label %63, label %55, !llvm.loop !16

63:                                               ; preds = %55
  %64 = add nuw nsw i32 %14, 1
  %65 = icmp eq i32 %64, 8
  br i1 %65, label %68, label %66

66:                                               ; preds = %63, %109
  %67 = phi i32 [ %64, %63 ], [ 0, %109 ]
  br label %13, !llvm.loop !17

68:                                               ; preds = %63, %106
  %69 = phi i64 [ %107, %106 ], [ 0, %63 ]
  %70 = trunc i64 %69 to i32
  br label %71

71:                                               ; preds = %68, %93
  %72 = phi i64 [ 0, %68 ], [ %104, %93 ]
  %73 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %69, i64 %72
  %74 = load float, ptr %73, align 4, !tbaa !5
  %75 = fdiv float %74, 1.000000e+02
  %76 = fcmp olt float %75, 0.000000e+00
  %77 = select i1 %76, float 0.000000e+00, float %75
  %78 = fcmp ogt float %77, 1.000000e+00
  %79 = select i1 %78, float 1.000000e+00, float %77
  %80 = fcmp olt float %79, 5.000000e-01
  br i1 %80, label %81, label %88

81:                                               ; preds = %71
  %82 = fsub float 5.000000e-01, %79
  %83 = insertelement <2 x float> poison, float %79, i64 0
  %84 = insertelement <2 x float> %83, float %82, i64 1
  %85 = fmul <2 x float> %84, <float 2.000000e+00, float 2.000000e+00>
  %86 = fmul <2 x float> %85, <float 2.550000e+02, float 2.550000e+02>
  %87 = fptosi <2 x float> %86 to <2 x i32>
  br label %93

88:                                               ; preds = %71
  %89 = fadd float %79, -5.000000e-01
  %90 = fmul float %89, 2.000000e+00
  %91 = fmul float %90, 2.550000e+02
  %92 = fptosi float %91 to i32
  br label %93

93:                                               ; preds = %88, %81
  %94 = phi i32 [ 0, %81 ], [ %92, %88 ]
  %95 = phi <2 x i32> [ %87, %81 ], [ <i32 255, i32 0>, %88 ]
  %96 = extractelement <2 x i32> %95, i64 0
  %97 = shl i32 %96, 16
  %98 = shl i32 %94, 8
  %99 = or i32 %97, %98
  %100 = extractelement <2 x i32> %95, i64 1
  %101 = or i32 %99, %100
  %102 = or i32 %101, -16777216
  %103 = trunc i64 %72 to i32
  tail call void @simPutPixel(i32 noundef %70, i32 noundef %103, i32 noundef %102) #5
  %104 = add nuw nsw i64 %72, 1
  %105 = icmp eq i64 %104, 256
  br i1 %105, label %106, label %71, !llvm.loop !18

106:                                              ; preds = %93
  %107 = add nuw nsw i64 %69, 1
  %108 = icmp eq i64 %107, 256
  br i1 %108, label %109, label %68, !llvm.loop !19

109:                                              ; preds = %106
  tail call void (...) @simFlush() #5
  br label %66
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #1

; Function Attrs: optsize
declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: optsize
declare void @simFlush(...) local_unnamed_addr #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #4

attributes #0 = { noreturn nounwind optsize uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { optsize "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #4 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { nounwind optsize }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = !{!6, !6, i64 0}
!6 = !{!"float", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11, !12}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.isvectorized", i32 1}
!12 = !{!"llvm.loop.unroll.runtime.disable"}
!13 = distinct !{!13, !10}
!14 = distinct !{!14, !10}
!15 = distinct !{!15, !10}
!16 = distinct !{!16, !10}
!17 = distinct !{!17, !10}
!18 = distinct !{!18, !10}
!19 = distinct !{!19, !10}
