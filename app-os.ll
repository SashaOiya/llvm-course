; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noreturn nounwind optsize uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = alloca [120 x [120 x float]], align 16
  %2 = alloca [120 x [120 x float]], align 16
  call void @llvm.lifetime.start.p0(i64 57600, ptr nonnull %1) #6
  call void @llvm.lifetime.start.p0(i64 57600, ptr nonnull %2) #6
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(57600) %1, i8 0, i64 57600, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(57600) %2, i8 0, i64 57600, i1 false), !tbaa !5
  %3 = getelementptr inbounds i8, ptr %1, i64 49368
  br label %4

4:                                                ; preds = %0, %150
  %5 = phi i32 [ %26, %150 ], [ 30, %0 ]
  %6 = phi i32 [ %30, %150 ], [ 90, %0 ]
  %7 = phi i32 [ %63, %150 ], [ 2, %0 ]
  %8 = phi i32 [ %151, %150 ], [ 1, %0 ]
  br label %9

9:                                                ; preds = %17, %4
  %10 = phi i64 [ 44, %4 ], [ %18, %17 ]
  br label %11

11:                                               ; preds = %11, %9
  %12 = phi i64 [ 0, %9 ], [ %15, %11 ]
  %13 = add i64 %12, 44
  %14 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %10, i64 %13
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %14, align 16, !tbaa !5
  %15 = add nuw i64 %12, 4
  %16 = icmp eq i64 %15, 32
  br i1 %16, label %17, label %11, !llvm.loop !9

17:                                               ; preds = %11
  %18 = add nuw nsw i64 %10, 1
  %19 = icmp eq i64 %18, 76
  br i1 %19, label %20, label %9, !llvm.loop !13

20:                                               ; preds = %17
  %21 = add nsw i32 %7, %5
  %22 = add i32 %8, %6
  %23 = icmp slt i32 %21, 4
  %24 = tail call i32 @llvm.smax.i32(i32 %21, i32 4)
  %25 = icmp sgt i32 %21, 115
  %26 = tail call i32 @llvm.smin.i32(i32 %24, i32 115)
  %27 = icmp slt i32 %22, 4
  %28 = tail call i32 @llvm.smax.i32(i32 %22, i32 4)
  %29 = icmp sgt i32 %22, 115
  %30 = tail call i32 @llvm.smin.i32(i32 %28, i32 115)
  %31 = zext nneg i32 %26 to i64
  %32 = add nsw i64 %31, -4
  %33 = add nuw nsw i32 %26, 5
  %34 = zext nneg i32 %30 to i64
  %35 = add nsw i64 %34, -4
  %36 = add nuw nsw i32 %30, 5
  %37 = zext nneg i32 %36 to i64
  %38 = zext nneg i32 %33 to i64
  br label %39

39:                                               ; preds = %20, %46
  %40 = phi i64 [ %35, %20 ], [ %47, %46 ]
  br label %41

41:                                               ; preds = %39, %41
  %42 = phi i64 [ %32, %39 ], [ %44, %41 ]
  %43 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %40, i64 %42
  store float 1.000000e+00, ptr %43, align 4, !tbaa !5
  %44 = add nuw nsw i64 %42, 1
  %45 = icmp eq i64 %44, %38
  br i1 %45, label %46, label %41, !llvm.loop !14

46:                                               ; preds = %41
  %47 = add nuw nsw i64 %40, 1
  %48 = icmp eq i64 %47, %37
  br i1 %48, label %49, label %39, !llvm.loop !15

49:                                               ; preds = %46
  %50 = sub nsw i32 0, %7
  %51 = select i1 %23, i32 %50, i32 %7
  %52 = sub nsw i32 0, %51
  %53 = sub nsw i32 0, %8
  %54 = select i1 %27, i32 %53, i32 %8
  %55 = sub nsw i32 0, %54
  br label %56

56:                                               ; preds = %49, %56
  %57 = phi i64 [ 0, %49 ], [ %60, %56 ]
  %58 = mul nuw nsw i64 %57, 480
  %59 = getelementptr i8, ptr %3, i64 %58
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %59, i8 0, i64 48, i1 false), !tbaa !5
  %60 = add nuw nsw i64 %57, 1
  %61 = icmp eq i64 %60, 12
  br i1 %61, label %62, label %56, !llvm.loop !16

62:                                               ; preds = %56
  %63 = select i1 %25, i32 %52, i32 %51
  br label %64

64:                                               ; preds = %62, %90
  %65 = phi i64 [ 1, %62 ], [ %67, %90 ]
  %66 = add nsw i64 %65, -1
  %67 = add nuw nsw i64 %65, 1
  %68 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %65, i64 1
  %69 = load float, ptr %68, align 4, !tbaa !5
  br label %70

70:                                               ; preds = %64, %70
  %71 = phi float [ %69, %64 ], [ %84, %70 ]
  %72 = phi i64 [ 1, %64 ], [ %82, %70 ]
  %73 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %66, i64 %72
  %74 = load float, ptr %73, align 4, !tbaa !5
  %75 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %67, i64 %72
  %76 = load float, ptr %75, align 4, !tbaa !5
  %77 = fadd float %74, %76
  %78 = add nsw i64 %72, -1
  %79 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %65, i64 %78
  %80 = load float, ptr %79, align 4, !tbaa !5
  %81 = fadd float %77, %80
  %82 = add nuw nsw i64 %72, 1
  %83 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %65, i64 %82
  %84 = load float, ptr %83, align 4, !tbaa !5
  %85 = fadd float %81, %84
  %86 = tail call float @llvm.fmuladd.f32(float %71, float -4.000000e+00, float %85)
  %87 = tail call float @llvm.fmuladd.f32(float %86, float 0x3FC3333340000000, float %71)
  %88 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %65, i64 %72
  store float %87, ptr %88, align 4, !tbaa !5
  %89 = icmp eq i64 %82, 119
  br i1 %89, label %90, label %70, !llvm.loop !17

90:                                               ; preds = %70
  %91 = icmp eq i64 %67, 119
  br i1 %91, label %92, label %64, !llvm.loop !18

92:                                               ; preds = %90, %102
  %93 = phi i64 [ %103, %102 ], [ 1, %90 ]
  br label %94

94:                                               ; preds = %92, %94
  %95 = phi i64 [ 1, %92 ], [ %100, %94 ]
  %96 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %93, i64 %95
  %97 = load float, ptr %96, align 4, !tbaa !5
  %98 = fmul float %97, 0x3FEFBE76C0000000
  %99 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %93, i64 %95
  store float %98, ptr %99, align 4, !tbaa !5
  %100 = add nuw nsw i64 %95, 1
  %101 = icmp eq i64 %100, 119
  br i1 %101, label %102, label %94, !llvm.loop !19

102:                                              ; preds = %94
  %103 = add nuw nsw i64 %93, 1
  %104 = icmp eq i64 %103, 119
  br i1 %104, label %105, label %92, !llvm.loop !20

105:                                              ; preds = %102, %147
  %106 = phi i64 [ %148, %147 ], [ 0, %102 ]
  %107 = trunc i64 %106 to i32
  %108 = mul i32 %107, 3
  br label %109

109:                                              ; preds = %105, %144
  %110 = phi i64 [ 0, %105 ], [ %145, %144 ]
  %111 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %106, i64 %110
  %112 = load float, ptr %111, align 4, !tbaa !5
  %113 = fcmp olt float %112, 0.000000e+00
  %114 = select i1 %113, float 0.000000e+00, float %112
  %115 = fcmp ogt float %114, 1.000000e+00
  %116 = select i1 %115, float 1.000000e+00, float %114
  %117 = fmul float %116, 2.550000e+02
  %118 = fptosi float %117 to i32
  %119 = icmp sgt i32 %118, 128
  %120 = shl nsw i32 %118, 1
  %121 = sub nsw i32 510, %120
  %122 = select i1 %119, i32 %121, i32 %120
  %123 = sub nsw i32 255, %118
  %124 = tail call i32 @llvm.smax.i32(i32 %122, i32 0)
  %125 = tail call i32 @llvm.umin.i32(i32 %124, i32 255)
  %126 = shl i32 %118, 16
  %127 = shl nuw nsw i32 %125, 8
  %128 = or disjoint i32 %127, %126
  %129 = or i32 %123, %128
  %130 = or i32 %129, -16777216
  %131 = trunc i64 %110 to i32
  %132 = mul i32 %131, 3
  br label %133

133:                                              ; preds = %109, %141
  %134 = phi i32 [ 0, %109 ], [ %142, %141 ]
  %135 = add nuw nsw i32 %134, %108
  br label %136

136:                                              ; preds = %133, %136
  %137 = phi i32 [ 0, %133 ], [ %139, %136 ]
  %138 = add nuw nsw i32 %137, %132
  tail call void @simPutPixel(i32 noundef %138, i32 noundef %135, i32 noundef %130) #7
  %139 = add nuw nsw i32 %137, 1
  %140 = icmp eq i32 %139, 3
  br i1 %140, label %141, label %136, !llvm.loop !21

141:                                              ; preds = %136
  %142 = add nuw nsw i32 %134, 1
  %143 = icmp eq i32 %142, 3
  br i1 %143, label %144, label %133, !llvm.loop !22

144:                                              ; preds = %141
  %145 = add nuw nsw i64 %110, 1
  %146 = icmp eq i64 %145, 120
  br i1 %146, label %147, label %109, !llvm.loop !23

147:                                              ; preds = %144
  %148 = add nuw nsw i64 %106, 1
  %149 = icmp eq i64 %148, 120
  br i1 %149, label %150, label %105, !llvm.loop !24

150:                                              ; preds = %147
  %151 = select i1 %29, i32 %55, i32 %54
  tail call void (...) @simFlush() #7
  br label %4
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #2

; Function Attrs: optsize
declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: optsize
declare void @simFlush(...) local_unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #4

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #5

attributes #0 = { noreturn nounwind optsize uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { optsize "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nounwind }
attributes #7 = { nounwind optsize }

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
!20 = distinct !{!20, !10}
!21 = distinct !{!21, !10}
!22 = distinct !{!22, !10}
!23 = distinct !{!23, !10}
!24 = distinct !{!24, !10}
