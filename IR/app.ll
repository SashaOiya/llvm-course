; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@app.u = internal global [256 x [256 x float]] zeroinitializer, align 16
@app.next_u = internal global [256 x [256 x float]] zeroinitializer, align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @app() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca float, align 4
  %5 = alloca float, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store i32 0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  store i32 0, ptr %1, align 4
  br label %10

10:                                               ; preds = %34, %0
  %11 = load i32, ptr %1, align 4
  %12 = icmp slt i32 %11, 256
  br i1 %12, label %13, label %37

13:                                               ; preds = %10
  store i32 0, ptr %2, align 4
  br label %14

14:                                               ; preds = %30, %13
  %15 = load i32, ptr %2, align 4
  %16 = icmp slt i32 %15, 256
  br i1 %16, label %17, label %33

17:                                               ; preds = %14
  %18 = load i32, ptr %1, align 4
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %19
  %21 = load i32, ptr %2, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds [256 x float], ptr %20, i64 0, i64 %22
  store float 0.000000e+00, ptr %23, align 4
  %24 = load i32, ptr %1, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %25
  %27 = load i32, ptr %2, align 4
  %28 = sext i32 %27 to i64
  %29 = getelementptr inbounds [256 x float], ptr %26, i64 0, i64 %28
  store float 0.000000e+00, ptr %29, align 4
  br label %30

30:                                               ; preds = %17
  %31 = load i32, ptr %2, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, ptr %2, align 4
  br label %14, !llvm.loop !6

33:                                               ; preds = %14
  br label %34

34:                                               ; preds = %33
  %35 = load i32, ptr %1, align 4
  %36 = add nsw i32 %35, 1
  store i32 %36, ptr %1, align 4
  br label %10, !llvm.loop !8

37:                                               ; preds = %10
  store i32 116, ptr %1, align 4
  br label %38

38:                                               ; preds = %62, %37
  %39 = load i32, ptr %1, align 4
  %40 = icmp slt i32 %39, 140
  br i1 %40, label %41, label %65

41:                                               ; preds = %38
  store i32 116, ptr %2, align 4
  br label %42

42:                                               ; preds = %58, %41
  %43 = load i32, ptr %2, align 4
  %44 = icmp slt i32 %43, 140
  br i1 %44, label %45, label %61

45:                                               ; preds = %42
  %46 = load i32, ptr %1, align 4
  %47 = sext i32 %46 to i64
  %48 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %47
  %49 = load i32, ptr %2, align 4
  %50 = sext i32 %49 to i64
  %51 = getelementptr inbounds [256 x float], ptr %48, i64 0, i64 %50
  store float 1.000000e+02, ptr %51, align 4
  %52 = load i32, ptr %1, align 4
  %53 = sext i32 %52 to i64
  %54 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %53
  %55 = load i32, ptr %2, align 4
  %56 = sext i32 %55 to i64
  %57 = getelementptr inbounds [256 x float], ptr %54, i64 0, i64 %56
  store float 1.000000e+02, ptr %57, align 4
  br label %58

58:                                               ; preds = %45
  %59 = load i32, ptr %2, align 4
  %60 = add nsw i32 %59, 1
  store i32 %60, ptr %2, align 4
  br label %42, !llvm.loop !9

61:                                               ; preds = %42
  br label %62

62:                                               ; preds = %61
  %63 = load i32, ptr %1, align 4
  %64 = add nsw i32 %63, 1
  store i32 %64, ptr %1, align 4
  br label %38, !llvm.loop !10

65:                                               ; preds = %38
  br label %66

66:                                               ; preds = %65, %259
  store i32 0, ptr %3, align 4
  br label %67

67:                                               ; preds = %194, %66
  %68 = load i32, ptr %3, align 4
  %69 = icmp slt i32 %68, 8
  br i1 %69, label %70, label %197

70:                                               ; preds = %67
  store i32 1, ptr %1, align 4
  br label %71

71:                                               ; preds = %161, %70
  %72 = load i32, ptr %1, align 4
  %73 = icmp slt i32 %72, 255
  br i1 %73, label %74, label %164

74:                                               ; preds = %71
  store i32 1, ptr %2, align 4
  br label %75

75:                                               ; preds = %157, %74
  %76 = load i32, ptr %2, align 4
  %77 = icmp slt i32 %76, 255
  br i1 %77, label %78, label %160

78:                                               ; preds = %75
  %79 = load i32, ptr %1, align 4
  %80 = icmp sge i32 %79, 116
  br i1 %80, label %81, label %97

81:                                               ; preds = %78
  %82 = load i32, ptr %1, align 4
  %83 = icmp slt i32 %82, 140
  br i1 %83, label %84, label %97

84:                                               ; preds = %81
  %85 = load i32, ptr %2, align 4
  %86 = icmp sge i32 %85, 116
  br i1 %86, label %87, label %97

87:                                               ; preds = %84
  %88 = load i32, ptr %2, align 4
  %89 = icmp slt i32 %88, 140
  br i1 %89, label %90, label %97

90:                                               ; preds = %87
  %91 = load i32, ptr %1, align 4
  %92 = sext i32 %91 to i64
  %93 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %92
  %94 = load i32, ptr %2, align 4
  %95 = sext i32 %94 to i64
  %96 = getelementptr inbounds [256 x float], ptr %93, i64 0, i64 %95
  store float 1.000000e+02, ptr %96, align 4
  br label %156

97:                                               ; preds = %87, %84, %81, %78
  store float 0x3FCC28F5C0000000, ptr %4, align 4
  %98 = load i32, ptr %1, align 4
  %99 = sext i32 %98 to i64
  %100 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %99
  %101 = load i32, ptr %2, align 4
  %102 = sext i32 %101 to i64
  %103 = getelementptr inbounds [256 x float], ptr %100, i64 0, i64 %102
  %104 = load float, ptr %103, align 4
  %105 = load float, ptr %4, align 4
  %106 = load i32, ptr %1, align 4
  %107 = add nsw i32 %106, 1
  %108 = sext i32 %107 to i64
  %109 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %108
  %110 = load i32, ptr %2, align 4
  %111 = sext i32 %110 to i64
  %112 = getelementptr inbounds [256 x float], ptr %109, i64 0, i64 %111
  %113 = load float, ptr %112, align 4
  %114 = load i32, ptr %1, align 4
  %115 = sub nsw i32 %114, 1
  %116 = sext i32 %115 to i64
  %117 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %116
  %118 = load i32, ptr %2, align 4
  %119 = sext i32 %118 to i64
  %120 = getelementptr inbounds [256 x float], ptr %117, i64 0, i64 %119
  %121 = load float, ptr %120, align 4
  %122 = fadd float %113, %121
  %123 = load i32, ptr %1, align 4
  %124 = sext i32 %123 to i64
  %125 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %124
  %126 = load i32, ptr %2, align 4
  %127 = add nsw i32 %126, 1
  %128 = sext i32 %127 to i64
  %129 = getelementptr inbounds [256 x float], ptr %125, i64 0, i64 %128
  %130 = load float, ptr %129, align 4
  %131 = fadd float %122, %130
  %132 = load i32, ptr %1, align 4
  %133 = sext i32 %132 to i64
  %134 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %133
  %135 = load i32, ptr %2, align 4
  %136 = sub nsw i32 %135, 1
  %137 = sext i32 %136 to i64
  %138 = getelementptr inbounds [256 x float], ptr %134, i64 0, i64 %137
  %139 = load float, ptr %138, align 4
  %140 = fadd float %131, %139
  %141 = load i32, ptr %1, align 4
  %142 = sext i32 %141 to i64
  %143 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %142
  %144 = load i32, ptr %2, align 4
  %145 = sext i32 %144 to i64
  %146 = getelementptr inbounds [256 x float], ptr %143, i64 0, i64 %145
  %147 = load float, ptr %146, align 4
  %148 = call float @llvm.fmuladd.f32(float -4.000000e+00, float %147, float %140)
  %149 = call float @llvm.fmuladd.f32(float %105, float %148, float %104)
  %150 = load i32, ptr %1, align 4
  %151 = sext i32 %150 to i64
  %152 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %151
  %153 = load i32, ptr %2, align 4
  %154 = sext i32 %153 to i64
  %155 = getelementptr inbounds [256 x float], ptr %152, i64 0, i64 %154
  store float %149, ptr %155, align 4
  br label %156

156:                                              ; preds = %97, %90
  br label %157

157:                                              ; preds = %156
  %158 = load i32, ptr %2, align 4
  %159 = add nsw i32 %158, 1
  store i32 %159, ptr %2, align 4
  br label %75, !llvm.loop !11

160:                                              ; preds = %75
  br label %161

161:                                              ; preds = %160
  %162 = load i32, ptr %1, align 4
  %163 = add nsw i32 %162, 1
  store i32 %163, ptr %1, align 4
  br label %71, !llvm.loop !12

164:                                              ; preds = %71
  store i32 1, ptr %1, align 4
  br label %165

165:                                              ; preds = %190, %164
  %166 = load i32, ptr %1, align 4
  %167 = icmp slt i32 %166, 255
  br i1 %167, label %168, label %193

168:                                              ; preds = %165
  store i32 1, ptr %2, align 4
  br label %169

169:                                              ; preds = %186, %168
  %170 = load i32, ptr %2, align 4
  %171 = icmp slt i32 %170, 255
  br i1 %171, label %172, label %189

172:                                              ; preds = %169
  %173 = load i32, ptr %1, align 4
  %174 = sext i32 %173 to i64
  %175 = getelementptr inbounds [256 x [256 x float]], ptr @app.next_u, i64 0, i64 %174
  %176 = load i32, ptr %2, align 4
  %177 = sext i32 %176 to i64
  %178 = getelementptr inbounds [256 x float], ptr %175, i64 0, i64 %177
  %179 = load float, ptr %178, align 4
  %180 = load i32, ptr %1, align 4
  %181 = sext i32 %180 to i64
  %182 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %181
  %183 = load i32, ptr %2, align 4
  %184 = sext i32 %183 to i64
  %185 = getelementptr inbounds [256 x float], ptr %182, i64 0, i64 %184
  store float %179, ptr %185, align 4
  br label %186

186:                                              ; preds = %172
  %187 = load i32, ptr %2, align 4
  %188 = add nsw i32 %187, 1
  store i32 %188, ptr %2, align 4
  br label %169, !llvm.loop !13

189:                                              ; preds = %169
  br label %190

190:                                              ; preds = %189
  %191 = load i32, ptr %1, align 4
  %192 = add nsw i32 %191, 1
  store i32 %192, ptr %1, align 4
  br label %165, !llvm.loop !14

193:                                              ; preds = %165
  br label %194

194:                                              ; preds = %193
  %195 = load i32, ptr %3, align 4
  %196 = add nsw i32 %195, 1
  store i32 %196, ptr %3, align 4
  br label %67, !llvm.loop !15

197:                                              ; preds = %67
  store i32 0, ptr %1, align 4
  br label %198

198:                                              ; preds = %256, %197
  %199 = load i32, ptr %1, align 4
  %200 = icmp slt i32 %199, 256
  br i1 %200, label %201, label %259

201:                                              ; preds = %198
  store i32 0, ptr %2, align 4
  br label %202

202:                                              ; preds = %252, %201
  %203 = load i32, ptr %2, align 4
  %204 = icmp slt i32 %203, 256
  br i1 %204, label %205, label %255

205:                                              ; preds = %202
  %206 = load i32, ptr %1, align 4
  %207 = sext i32 %206 to i64
  %208 = getelementptr inbounds [256 x [256 x float]], ptr @app.u, i64 0, i64 %207
  %209 = load i32, ptr %2, align 4
  %210 = sext i32 %209 to i64
  %211 = getelementptr inbounds [256 x float], ptr %208, i64 0, i64 %210
  %212 = load float, ptr %211, align 4
  %213 = fdiv float %212, 1.000000e+02
  store float %213, ptr %5, align 4
  %214 = load float, ptr %5, align 4
  %215 = fcmp olt float %214, 0.000000e+00
  br i1 %215, label %216, label %217

216:                                              ; preds = %205
  store float 0.000000e+00, ptr %5, align 4
  br label %217

217:                                              ; preds = %216, %205
  %218 = load float, ptr %5, align 4
  %219 = fcmp ogt float %218, 1.000000e+00
  br i1 %219, label %220, label %221

220:                                              ; preds = %217
  store float 1.000000e+00, ptr %5, align 4
  br label %221

221:                                              ; preds = %220, %217
  store i32 0, ptr %6, align 4
  store i32 0, ptr %7, align 4
  store i32 0, ptr %8, align 4
  %222 = load float, ptr %5, align 4
  %223 = fcmp olt float %222, 5.000000e-01
  br i1 %223, label %224, label %234

224:                                              ; preds = %221
  %225 = load float, ptr %5, align 4
  %226 = fmul float %225, 2.000000e+00
  %227 = fmul float %226, 2.550000e+02
  %228 = fptosi float %227 to i32
  store i32 %228, ptr %6, align 4
  store i32 0, ptr %7, align 4
  %229 = load float, ptr %5, align 4
  %230 = fsub float 5.000000e-01, %229
  %231 = fmul float %230, 2.000000e+00
  %232 = fmul float %231, 2.550000e+02
  %233 = fptosi float %232 to i32
  store i32 %233, ptr %8, align 4
  br label %240

234:                                              ; preds = %221
  store i32 255, ptr %6, align 4
  %235 = load float, ptr %5, align 4
  %236 = fsub float %235, 5.000000e-01
  %237 = fmul float %236, 2.000000e+00
  %238 = fmul float %237, 2.550000e+02
  %239 = fptosi float %238 to i32
  store i32 %239, ptr %7, align 4
  store i32 0, ptr %8, align 4
  br label %240

240:                                              ; preds = %234, %224
  %241 = load i32, ptr %6, align 4
  %242 = shl i32 %241, 16
  %243 = or i32 -16777216, %242
  %244 = load i32, ptr %7, align 4
  %245 = shl i32 %244, 8
  %246 = or i32 %243, %245
  %247 = load i32, ptr %8, align 4
  %248 = or i32 %246, %247
  store i32 %248, ptr %9, align 4
  %249 = load i32, ptr %1, align 4
  %250 = load i32, ptr %2, align 4
  %251 = load i32, ptr %9, align 4
  call void @simPutPixel(i32 noundef %249, i32 noundef %250, i32 noundef %251)
  br label %252

252:                                              ; preds = %240
  %253 = load i32, ptr %2, align 4
  %254 = add nsw i32 %253, 1
  store i32 %254, ptr %2, align 4
  br label %202, !llvm.loop !16

255:                                              ; preds = %202
  br label %256

256:                                              ; preds = %255
  %257 = load i32, ptr %1, align 4
  %258 = add nsw i32 %257, 1
  store i32 %258, ptr %1, align 4
  br label %198, !llvm.loop !17

259:                                              ; preds = %198
  call void (...) @simFlush()
  br label %66
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare float @llvm.fmuladd.f32(float, float, float) #1

declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) #2

declare void @simFlush(...) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
!16 = distinct !{!16, !7}
!17 = distinct !{!17, !7}
