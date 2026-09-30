; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@app.u = internal unnamed_addr global [256 x [256 x float]] zeroinitializer, align 16
@app.next_u = internal unnamed_addr global [256 x [256 x float]] zeroinitializer, align 16

; Function Attrs: noreturn nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(262144) @app.u, i8 0, i64 262144, i1 false), !tbaa !5
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(262144) @app.next_u, i8 0, i64 262144, i1 false), !tbaa !5
  br label %1

1:                                                ; preds = %1, %0
  %2 = phi i64 [ 116, %0 ], [ %15, %1 ]
  %3 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %2, i64 116
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %3, align 16, !tbaa !5
  %4 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %2, i64 116
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %4, align 16, !tbaa !5
  %5 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %2, i64 120
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %5, align 16, !tbaa !5
  %6 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %2, i64 120
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %6, align 16, !tbaa !5
  %7 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %2, i64 124
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %7, align 16, !tbaa !5
  %8 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %2, i64 124
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %8, align 16, !tbaa !5
  %9 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %2, i64 128
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %9, align 16, !tbaa !5
  %10 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %2, i64 128
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %10, align 16, !tbaa !5
  %11 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %2, i64 132
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %11, align 16, !tbaa !5
  %12 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %2, i64 132
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %12, align 16, !tbaa !5
  %13 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %2, i64 136
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %13, align 16, !tbaa !5
  %14 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %2, i64 136
  store <4 x float> <float 1.000000e+02, float 1.000000e+02, float 1.000000e+02, float 1.000000e+02>, ptr %14, align 16, !tbaa !5
  %15 = add nuw nsw i64 %2, 1
  %16 = icmp eq i64 %15, 140
  br i1 %16, label %17, label %1, !llvm.loop !9

17:                                               ; preds = %1, %74
  %18 = phi i32 [ %75, %74 ], [ 0, %1 ]
  br label %19

19:                                               ; preds = %17, %57
  %20 = phi i64 [ 1, %17 ], [ %24, %57 ]
  %21 = trunc i64 %20 to i32
  %22 = add i32 %21, -116
  %23 = icmp ult i32 %22, 24
  %24 = add nuw nsw i64 %20, 1
  %25 = add nsw i64 %20, -1
  br label %26

26:                                               ; preds = %19, %52
  %27 = phi i64 [ 1, %19 ], [ %53, %52 ]
  %28 = trunc i64 %27 to i32
  %29 = add i32 %28, -116
  %30 = icmp ult i32 %29, 24
  %31 = and i1 %23, %30
  br i1 %31, label %32, label %34

32:                                               ; preds = %26
  %33 = add nuw nsw i64 %27, 1
  br label %52

34:                                               ; preds = %26
  %35 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %20, i64 %27
  %36 = load float, ptr %35, align 4, !tbaa !5
  %37 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %24, i64 %27
  %38 = load float, ptr %37, align 4, !tbaa !5
  %39 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %25, i64 %27
  %40 = load float, ptr %39, align 4, !tbaa !5
  %41 = fadd float %38, %40
  %42 = add nuw nsw i64 %27, 1
  %43 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %20, i64 %42
  %44 = load float, ptr %43, align 4, !tbaa !5
  %45 = fadd float %41, %44
  %46 = add nsw i64 %27, -1
  %47 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %20, i64 %46
  %48 = load float, ptr %47, align 4, !tbaa !5
  %49 = fadd float %45, %48
  %50 = tail call float @llvm.fmuladd.f32(float %36, float -4.000000e+00, float %49)
  %51 = tail call float @llvm.fmuladd.f32(float %50, float 0x3FCC28F5C0000000, float %36)
  br label %52

52:                                               ; preds = %32, %34
  %53 = phi i64 [ %33, %32 ], [ %42, %34 ]
  %54 = phi float [ 1.000000e+02, %32 ], [ %51, %34 ]
  %55 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %20, i64 %27
  store float %54, ptr %55, align 4
  %56 = icmp eq i64 %53, 255
  br i1 %56, label %57, label %26, !llvm.loop !11

57:                                               ; preds = %52
  %58 = icmp eq i64 %24, 255
  br i1 %58, label %59, label %19, !llvm.loop !12

59:                                               ; preds = %57, %59
  %60 = phi i64 [ %69, %59 ], [ 0, %57 ]
  %61 = shl nuw nsw i64 %60, 10
  %62 = or disjoint i64 %61, 1028
  %63 = getelementptr i8, ptr @app.u, i64 %62
  %64 = getelementptr i8, ptr @app.next_u, i64 %62
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(1016) %63, ptr noundef nonnull align 4 dereferenceable(1016) %64, i64 1016, i1 false), !tbaa !5
  %65 = shl i64 %60, 10
  %66 = add i64 %65, 2052
  %67 = getelementptr i8, ptr @app.u, i64 %66
  %68 = getelementptr i8, ptr @app.next_u, i64 %66
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(1016) %67, ptr noundef nonnull align 4 dereferenceable(1016) %68, i64 1016, i1 false), !tbaa !5
  %69 = add nuw nsw i64 %60, 2
  %70 = icmp eq i64 %69, 254
  br i1 %70, label %71, label %59, !llvm.loop !13

71:                                               ; preds = %59
  %72 = add nuw nsw i32 %18, 1
  %73 = icmp eq i32 %72, 8
  br i1 %73, label %76, label %74

74:                                               ; preds = %71, %117
  %75 = phi i32 [ %72, %71 ], [ 0, %117 ]
  br label %17, !llvm.loop !14

76:                                               ; preds = %71, %114
  %77 = phi i64 [ %115, %114 ], [ 0, %71 ]
  %78 = trunc i64 %77 to i32
  br label %79

79:                                               ; preds = %76, %101
  %80 = phi i64 [ 0, %76 ], [ %112, %101 ]
  %81 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %77, i64 %80
  %82 = load float, ptr %81, align 4, !tbaa !5
  %83 = fdiv float %82, 1.000000e+02
  %84 = fcmp olt float %83, 0.000000e+00
  %85 = select i1 %84, float 0.000000e+00, float %83
  %86 = fcmp ogt float %85, 1.000000e+00
  %87 = select i1 %86, float 1.000000e+00, float %85
  %88 = fcmp olt float %87, 5.000000e-01
  br i1 %88, label %89, label %96

89:                                               ; preds = %79
  %90 = fsub float 5.000000e-01, %87
  %91 = insertelement <2 x float> poison, float %87, i64 0
  %92 = insertelement <2 x float> %91, float %90, i64 1
  %93 = fmul <2 x float> %92, <float 2.000000e+00, float 2.000000e+00>
  %94 = fmul <2 x float> %93, <float 2.550000e+02, float 2.550000e+02>
  %95 = fptosi <2 x float> %94 to <2 x i32>
  br label %101

96:                                               ; preds = %79
  %97 = fadd float %87, -5.000000e-01
  %98 = fmul float %97, 2.000000e+00
  %99 = fmul float %98, 2.550000e+02
  %100 = fptosi float %99 to i32
  br label %101

101:                                              ; preds = %96, %89
  %102 = phi i32 [ 0, %89 ], [ %100, %96 ]
  %103 = phi <2 x i32> [ %95, %89 ], [ <i32 255, i32 0>, %96 ]
  %104 = extractelement <2 x i32> %103, i64 0
  %105 = shl i32 %104, 16
  %106 = shl i32 %102, 8
  %107 = or i32 %105, %106
  %108 = extractelement <2 x i32> %103, i64 1
  %109 = or i32 %107, %108
  %110 = or i32 %109, -16777216
  %111 = trunc i64 %80 to i32
  tail call void @simPutPixel(i32 noundef %78, i32 noundef %111, i32 noundef %110) #5
  %112 = add nuw nsw i64 %80, 1
  %113 = icmp eq i64 %112, 256
  br i1 %113, label %114, label %79, !llvm.loop !15

114:                                              ; preds = %101
  %115 = add nuw nsw i64 %77, 1
  %116 = icmp eq i64 %115, 256
  br i1 %116, label %117, label %76, !llvm.loop !16

117:                                              ; preds = %114
  tail call void (...) @simFlush() #5
  br label %74
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #1

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

declare void @simFlush(...) local_unnamed_addr #2

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #4

attributes #0 = { noreturn nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #4 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { nounwind }

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
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10}
!12 = distinct !{!12, !10}
!13 = distinct !{!13, !10}
!14 = distinct !{!14, !10}
!15 = distinct !{!15, !10}
!16 = distinct !{!16, !10}
