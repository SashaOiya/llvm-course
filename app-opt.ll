; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noreturn nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = alloca [120 x [120 x float]], align 16
  %2 = alloca [120 x [120 x float]], align 16
  call void @llvm.lifetime.start.p0(i64 57600, ptr nonnull %1) #6
  call void @llvm.lifetime.start.p0(i64 57600, ptr nonnull %2) #6
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(57600) %1, i8 0, i64 57600, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(57600) %2, i8 0, i64 57600, i1 false), !tbaa !5
  %3 = getelementptr inbounds i8, ptr %1, i64 49368
  %4 = getelementptr inbounds i8, ptr %1, i64 49848
  %5 = getelementptr inbounds i8, ptr %1, i64 50328
  %6 = getelementptr inbounds i8, ptr %1, i64 50808
  %7 = getelementptr inbounds i8, ptr %1, i64 51288
  %8 = getelementptr inbounds i8, ptr %1, i64 51768
  %9 = getelementptr inbounds i8, ptr %1, i64 52248
  %10 = getelementptr inbounds i8, ptr %1, i64 52728
  %11 = getelementptr inbounds i8, ptr %1, i64 53208
  %12 = getelementptr inbounds i8, ptr %1, i64 53688
  %13 = getelementptr inbounds i8, ptr %1, i64 54168
  %14 = getelementptr inbounds i8, ptr %1, i64 54648
  br label %15

15:                                               ; preds = %0, %218
  %16 = phi i32 [ %36, %218 ], [ 30, %0 ]
  %17 = phi i32 [ %39, %218 ], [ 90, %0 ]
  %18 = phi i32 [ %88, %218 ], [ 2, %0 ]
  %19 = phi i32 [ %219, %218 ], [ 1, %0 ]
  br label %20

20:                                               ; preds = %15, %20
  %21 = phi i64 [ 44, %15 ], [ %30, %20 ]
  %22 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %21, i64 44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %22, align 16, !tbaa !5
  %23 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %21, i64 48
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %23, align 16, !tbaa !5
  %24 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %21, i64 52
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %24, align 16, !tbaa !5
  %25 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %21, i64 56
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %25, align 16, !tbaa !5
  %26 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %21, i64 60
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %26, align 16, !tbaa !5
  %27 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %21, i64 64
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %27, align 16, !tbaa !5
  %28 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %21, i64 68
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %28, align 16, !tbaa !5
  %29 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %21, i64 72
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %29, align 16, !tbaa !5
  %30 = add nuw nsw i64 %21, 1
  %31 = icmp eq i64 %30, 76
  br i1 %31, label %32, label %20, !llvm.loop !9

32:                                               ; preds = %20
  %33 = add nsw i32 %18, %16
  %34 = add i32 %19, %17
  %35 = tail call i32 @llvm.smax.i32(i32 %33, i32 4)
  %36 = tail call i32 @llvm.smin.i32(i32 %35, i32 115)
  %37 = tail call i32 @llvm.smax.i32(i32 %34, i32 4)
  %38 = icmp sgt i32 %34, 115
  %39 = tail call i32 @llvm.smin.i32(i32 %37, i32 115)
  %40 = zext nneg i32 %36 to i64
  %41 = add nuw nsw i64 %40, 4
  %42 = zext nneg i32 %39 to i64
  %43 = add nsw i64 %42, -4
  %44 = add nsw i64 %40, -4
  %45 = icmp slt i32 %34, 4
  %46 = icmp sgt i32 %33, 115
  %47 = icmp slt i32 %33, 4
  %48 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %43, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %48, align 4, !tbaa !5
  %49 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %43, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %49, align 4, !tbaa !5
  %50 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %43, i64 %41
  store float 1.000000e+00, ptr %50, align 4, !tbaa !5
  %51 = add nsw i64 %42, -3
  %52 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %51, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %52, align 4, !tbaa !5
  %53 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %51, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %53, align 4, !tbaa !5
  %54 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %51, i64 %41
  store float 1.000000e+00, ptr %54, align 4, !tbaa !5
  %55 = add nsw i64 %42, -2
  %56 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %55, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %56, align 4, !tbaa !5
  %57 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %55, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %57, align 4, !tbaa !5
  %58 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %55, i64 %41
  store float 1.000000e+00, ptr %58, align 4, !tbaa !5
  %59 = add nsw i64 %42, -1
  %60 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %59, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %60, align 4, !tbaa !5
  %61 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %59, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %61, align 4, !tbaa !5
  %62 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %59, i64 %41
  store float 1.000000e+00, ptr %62, align 4, !tbaa !5
  %63 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %42, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %63, align 4, !tbaa !5
  %64 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %42, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %64, align 4, !tbaa !5
  %65 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %42, i64 %41
  store float 1.000000e+00, ptr %65, align 4, !tbaa !5
  %66 = add nuw nsw i64 %42, 1
  %67 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %66, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %67, align 4, !tbaa !5
  %68 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %66, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %68, align 4, !tbaa !5
  %69 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %66, i64 %41
  store float 1.000000e+00, ptr %69, align 4, !tbaa !5
  %70 = add nuw nsw i64 %42, 2
  %71 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %70, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %71, align 4, !tbaa !5
  %72 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %70, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %72, align 4, !tbaa !5
  %73 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %70, i64 %41
  store float 1.000000e+00, ptr %73, align 4, !tbaa !5
  %74 = add nuw nsw i64 %42, 3
  %75 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %74, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %75, align 4, !tbaa !5
  %76 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %74, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %76, align 4, !tbaa !5
  %77 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %74, i64 %41
  store float 1.000000e+00, ptr %77, align 4, !tbaa !5
  %78 = add nuw nsw i64 %42, 4
  %79 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %78, i64 %44
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %79, align 4, !tbaa !5
  %80 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %78, i64 %40
  store <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, ptr %80, align 4, !tbaa !5
  %81 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %78, i64 %41
  store float 1.000000e+00, ptr %81, align 4, !tbaa !5
  %82 = sub nsw i32 0, %18
  %83 = select i1 %47, i32 %82, i32 %18
  %84 = sub nsw i32 0, %83
  %85 = sub nsw i32 0, %19
  %86 = select i1 %45, i32 %85, i32 %19
  %87 = sub nsw i32 0, %86
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %3, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %4, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %5, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %6, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %7, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %8, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %9, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %10, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %11, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %12, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %13, i8 0, i64 48, i1 false), !tbaa !5
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(48) %14, i8 0, i64 48, i1 false), !tbaa !5
  %88 = select i1 %46, i32 %84, i32 %83
  br label %89

89:                                               ; preds = %32, %118
  %90 = phi i64 [ 1, %32 ], [ %92, %118 ]
  %91 = add nsw i64 %90, -1
  %92 = add nuw nsw i64 %90, 1
  %93 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %90, i64 1
  %94 = load float, ptr %93, align 4, !tbaa !5
  %95 = insertelement <4 x float> poison, float %94, i64 3
  br label %96

96:                                               ; preds = %96, %89
  %97 = phi i64 [ 0, %89 ], [ %116, %96 ]
  %98 = phi <4 x float> [ %95, %89 ], [ %110, %96 ]
  %99 = or disjoint i64 %97, 1
  %100 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %91, i64 %99
  %101 = load <4 x float>, ptr %100, align 4, !tbaa !5
  %102 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %92, i64 %99
  %103 = load <4 x float>, ptr %102, align 4, !tbaa !5
  %104 = fadd <4 x float> %101, %103
  %105 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %90, i64 %97
  %106 = load <4 x float>, ptr %105, align 16, !tbaa !5
  %107 = fadd <4 x float> %104, %106
  %108 = or disjoint i64 %97, 2
  %109 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %90, i64 %108
  %110 = load <4 x float>, ptr %109, align 8, !tbaa !5
  %111 = shufflevector <4 x float> %98, <4 x float> %110, <4 x i32> <i32 3, i32 4, i32 5, i32 6>
  %112 = fadd <4 x float> %107, %110
  %113 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %111, <4 x float> <float -4.000000e+00, float -4.000000e+00, float -4.000000e+00, float -4.000000e+00>, <4 x float> %112)
  %114 = tail call <4 x float> @llvm.fmuladd.v4f32(<4 x float> %113, <4 x float> <float 0x3FC3333340000000, float 0x3FC3333340000000, float 0x3FC3333340000000, float 0x3FC3333340000000>, <4 x float> %111)
  %115 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %90, i64 %99
  store <4 x float> %114, ptr %115, align 4, !tbaa !5
  %116 = add nuw i64 %97, 4
  %117 = icmp eq i64 %116, 116
  br i1 %117, label %118, label %96, !llvm.loop !11

118:                                              ; preds = %96
  %119 = extractelement <4 x float> %110, i64 3
  %120 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %91, i64 117
  %121 = load float, ptr %120, align 4, !tbaa !5
  %122 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %92, i64 117
  %123 = load float, ptr %122, align 4, !tbaa !5
  %124 = fadd float %121, %123
  %125 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %90, i64 116
  %126 = load float, ptr %125, align 16, !tbaa !5
  %127 = fadd float %124, %126
  %128 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %90, i64 118
  %129 = load float, ptr %128, align 8, !tbaa !5
  %130 = fadd float %127, %129
  %131 = tail call float @llvm.fmuladd.f32(float %119, float -4.000000e+00, float %130)
  %132 = tail call float @llvm.fmuladd.f32(float %131, float 0x3FC3333340000000, float %119)
  %133 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %90, i64 117
  store float %132, ptr %133, align 4, !tbaa !5
  %134 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %91, i64 118
  %135 = load float, ptr %134, align 8, !tbaa !5
  %136 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %92, i64 118
  %137 = load float, ptr %136, align 8, !tbaa !5
  %138 = fadd float %135, %137
  %139 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %90, i64 117
  %140 = load float, ptr %139, align 4, !tbaa !5
  %141 = fadd float %138, %140
  %142 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %90, i64 119
  %143 = load float, ptr %142, align 4, !tbaa !5
  %144 = fadd float %141, %143
  %145 = tail call float @llvm.fmuladd.f32(float %129, float -4.000000e+00, float %144)
  %146 = tail call float @llvm.fmuladd.f32(float %145, float 0x3FC3333340000000, float %129)
  %147 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %90, i64 118
  store float %146, ptr %147, align 8, !tbaa !5
  %148 = icmp eq i64 %92, 119
  br i1 %148, label %149, label %89, !llvm.loop !14

149:                                              ; preds = %118, %166
  %150 = phi i64 [ %175, %166 ], [ 1, %118 ]
  br label %151

151:                                              ; preds = %159, %149
  %152 = phi i64 [ 0, %149 ], [ %165, %159 ]
  %153 = or disjoint i64 %152, 1
  %154 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %150, i64 %153
  %155 = load <4 x float>, ptr %154, align 4, !tbaa !5
  %156 = fmul <4 x float> %155, <float 0x3FEFBE76C0000000, float 0x3FEFBE76C0000000, float 0x3FEFBE76C0000000, float 0x3FEFBE76C0000000>
  %157 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %150, i64 %153
  store <4 x float> %156, ptr %157, align 4, !tbaa !5
  %158 = icmp eq i64 %152, 112
  br i1 %158, label %166, label %159, !llvm.loop !15

159:                                              ; preds = %151
  %160 = or disjoint i64 %152, 5
  %161 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %150, i64 %160
  %162 = load <4 x float>, ptr %161, align 4, !tbaa !5
  %163 = fmul <4 x float> %162, <float 0x3FEFBE76C0000000, float 0x3FEFBE76C0000000, float 0x3FEFBE76C0000000, float 0x3FEFBE76C0000000>
  %164 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %150, i64 %160
  store <4 x float> %163, ptr %164, align 4, !tbaa !5
  %165 = add nuw nsw i64 %152, 8
  br label %151

166:                                              ; preds = %151
  %167 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %150, i64 117
  %168 = load float, ptr %167, align 4, !tbaa !5
  %169 = fmul float %168, 0x3FEFBE76C0000000
  %170 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %150, i64 117
  store float %169, ptr %170, align 4, !tbaa !5
  %171 = getelementptr inbounds [120 x [120 x float]], ptr %2, i64 0, i64 %150, i64 118
  %172 = load float, ptr %171, align 8, !tbaa !5
  %173 = fmul float %172, 0x3FEFBE76C0000000
  %174 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %150, i64 118
  store float %173, ptr %174, align 8, !tbaa !5
  %175 = add nuw nsw i64 %150, 1
  %176 = icmp eq i64 %175, 119
  br i1 %176, label %177, label %149, !llvm.loop !16

177:                                              ; preds = %166, %215
  %178 = phi i64 [ %216, %215 ], [ 0, %166 ]
  %179 = mul nuw nsw i64 %178, 3
  %180 = trunc i64 %179 to i32
  %181 = trunc i64 %179 to i32
  %182 = add i32 %181, 1
  %183 = trunc i64 %179 to i32
  %184 = add i32 %183, 2
  br label %185

185:                                              ; preds = %177, %185
  %186 = phi i64 [ 0, %177 ], [ %213, %185 ]
  %187 = getelementptr inbounds [120 x [120 x float]], ptr %1, i64 0, i64 %178, i64 %186
  %188 = load float, ptr %187, align 4, !tbaa !5
  %189 = fcmp olt float %188, 0.000000e+00
  %190 = select i1 %189, float 0.000000e+00, float %188
  %191 = fcmp ogt float %190, 1.000000e+00
  %192 = select i1 %191, float 1.000000e+00, float %190
  %193 = fmul float %192, 2.550000e+02
  %194 = fptosi float %193 to i32
  %195 = icmp sgt i32 %194, 128
  %196 = shl nsw i32 %194, 1
  %197 = sub nsw i32 510, %196
  %198 = select i1 %195, i32 %197, i32 %196
  %199 = sub nsw i32 255, %194
  %200 = tail call i32 @llvm.smax.i32(i32 %198, i32 0)
  %201 = tail call i32 @llvm.umin.i32(i32 %200, i32 255)
  %202 = shl i32 %194, 16
  %203 = shl nuw nsw i32 %201, 8
  %204 = or disjoint i32 %203, %202
  %205 = or i32 %199, %204
  %206 = or i32 %205, -16777216
  %207 = mul nuw nsw i64 %186, 3
  %208 = trunc i64 %207 to i32
  tail call void @simPutPixel(i32 noundef %208, i32 noundef %180, i32 noundef %206) #6
  %209 = trunc i64 %207 to i32
  %210 = add i32 %209, 1
  tail call void @simPutPixel(i32 noundef %210, i32 noundef %180, i32 noundef %206) #6
  %211 = trunc i64 %207 to i32
  %212 = add i32 %211, 2
  tail call void @simPutPixel(i32 noundef %212, i32 noundef %180, i32 noundef %206) #6
  tail call void @simPutPixel(i32 noundef %208, i32 noundef %182, i32 noundef %206) #6
  tail call void @simPutPixel(i32 noundef %210, i32 noundef %182, i32 noundef %206) #6
  tail call void @simPutPixel(i32 noundef %212, i32 noundef %182, i32 noundef %206) #6
  tail call void @simPutPixel(i32 noundef %208, i32 noundef %184, i32 noundef %206) #6
  tail call void @simPutPixel(i32 noundef %210, i32 noundef %184, i32 noundef %206) #6
  tail call void @simPutPixel(i32 noundef %212, i32 noundef %184, i32 noundef %206) #6
  %213 = add nuw nsw i64 %186, 1
  %214 = icmp eq i64 %213, 120
  br i1 %214, label %215, label %185, !llvm.loop !17

215:                                              ; preds = %185
  %216 = add nuw nsw i64 %178, 1
  %217 = icmp eq i64 %216, 120
  br i1 %217, label %218, label %177, !llvm.loop !18

218:                                              ; preds = %215
  %219 = select i1 %38, i32 %87, i32 %86
  tail call void (...) @simFlush() #6
  br label %15
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #2

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

declare void @simFlush(...) local_unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.umin.i32(i32, i32) #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #4

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #5

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare <4 x float> @llvm.fmuladd.v4f32(<4 x float>, <4 x float>, <4 x float>) #4

attributes #0 = { noreturn nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #6 = { nounwind }

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
!11 = distinct !{!11, !10, !12, !13}
!12 = !{!"llvm.loop.isvectorized", i32 1}
!13 = !{!"llvm.loop.unroll.runtime.disable"}
!14 = distinct !{!14, !10}
!15 = distinct !{!15, !10, !12, !13}
!16 = distinct !{!16, !10}
!17 = distinct !{!17, !10}
!18 = distinct !{!18, !10}
