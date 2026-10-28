#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"

#include <SDL2/SDL.h>
#include <cstdlib>
#include <cstring>
#include <memory>
#include <vector>

extern "C" {
#include "../sim.h"
}

using namespace llvm;

static constexpr int WIDTH = 256;
static constexpr int HEIGHT = 256;
static constexpr int SUB_STEPS = 8;
static constexpr int SQ_LO = HEIGHT / 2 - 12; // 116
static constexpr int SQ_HI = HEIGHT / 2 + 12; // 140

#ifndef FRAMES
#define FRAMES 1
#endif
static constexpr int FRAME_LIMIT = FRAMES;

int main() {
  LLVMContext ctx;
  Module *module = new Module("app.c", ctx);
  module->setSourceFileName("app.c");

  IRBuilder<> B(ctx);
  Type *i32 = B.getInt32Ty();
  Type *f32 = B.getFloatTy();
  Type *voidTy = B.getVoidTy();

  ArrayType *rowTy = ArrayType::get(f32, WIDTH);
  ArrayType *gridTy = ArrayType::get(rowTy, HEIGHT);
  auto *u = new GlobalVariable(*module, gridTy, false,
                               GlobalValue::InternalLinkage,
                               ConstantAggregateZero::get(gridTy), "u");
  auto *uNext = new GlobalVariable(*module, gridTy, false,
                                   GlobalValue::InternalLinkage,
                                   ConstantAggregateZero::get(gridTy),
                                   "next_u");

  FunctionCallee simPutPixelF = module->getOrInsertFunction(
      "simPutPixel", FunctionType::get(voidTy, {i32, i32, i32}, false));
  FunctionCallee simFlushF = module->getOrInsertFunction(
      "simFlush", FunctionType::get(voidTy, false));

  Function *appF = Function::Create(FunctionType::get(voidTy, false),
                                    Function::ExternalLinkage, "app", module);

  auto *bbEntry = BasicBlock::Create(ctx, "entry", appF);
  auto *bbInitY = BasicBlock::Create(ctx, "init_y", appF);
  auto *bbInitX = BasicBlock::Create(ctx, "init_x", appF);
  auto *bbInitXBack = BasicBlock::Create(ctx, "init_x_back", appF);
  auto *bbSqY = BasicBlock::Create(ctx, "sq_y", appF);
  auto *bbSqX = BasicBlock::Create(ctx, "sq_x", appF);
  auto *bbSqXBack = BasicBlock::Create(ctx, "sq_x_back", appF);
  auto *bbWhile = BasicBlock::Create(ctx, "while", appF);
  auto *bbStep = BasicBlock::Create(ctx, "step", appF);
  auto *bbDiffY = BasicBlock::Create(ctx, "diff_y", appF);
  auto *bbDiffX = BasicBlock::Create(ctx, "diff_x", appF);
  auto *bbDiffSet = BasicBlock::Create(ctx, "diff_set", appF);
  auto *bbDiffCalc = BasicBlock::Create(ctx, "diff_calc", appF);
  auto *bbDiffXTail = BasicBlock::Create(ctx, "diff_x_tail", appF);
  auto *bbDiffXBack = BasicBlock::Create(ctx, "diff_x_back", appF);
  auto *bbCopyY = BasicBlock::Create(ctx, "copy_y", appF);
  auto *bbCopyX = BasicBlock::Create(ctx, "copy_x", appF);
  auto *bbCopyXBack = BasicBlock::Create(ctx, "copy_x_back", appF);
  auto *bbStepBack = BasicBlock::Create(ctx, "step_back", appF);
  auto *bbDrawY = BasicBlock::Create(ctx, "draw_y", appF);
  auto *bbDrawX = BasicBlock::Create(ctx, "draw_x", appF);
  auto *bbDrawThen = BasicBlock::Create(ctx, "draw_then", appF);
  auto *bbDrawElse = BasicBlock::Create(ctx, "draw_else", appF);
  auto *bbDrawMerge = BasicBlock::Create(ctx, "draw_merge", appF);
  auto *bbDrawXBack = BasicBlock::Create(ctx, "draw_x_back", appF);
  auto *bbFlush = BasicBlock::Create(ctx, "flush", appF);
  auto *bbRet = BasicBlock::Create(ctx, "return", appF);

  // u[y][x] = GEP(0, y, x) по глобальному массиву
  auto gepU = [&](GlobalVariable *G, Value *y, Value *x) {
    return B.CreateInBoundsGEP(gridTy, G, {B.getInt32(0), y, x});
  };

  // entry -> первая инициализация
  B.SetInsertPoint(bbEntry);
  B.CreateBr(bbInitY);

  // ---- u = 0; next_u = 0 (двойной цикл y, x: 0..255) ----
  B.SetInsertPoint(bbInitY);
  PHINode *initY = B.CreatePHI(i32, 2);
  B.CreateBr(bbInitX);

  B.SetInsertPoint(bbInitX);
  PHINode *initX = B.CreatePHI(i32, 2);
  B.CreateStore(ConstantFP::get(f32, 0.0f), gepU(u, initY, initX));
  B.CreateStore(ConstantFP::get(f32, 0.0f), gepU(uNext, initY, initX));
  Value *initXNext = B.CreateAdd(initX, B.getInt32(1));
  Value *initXCmp = B.CreateICmpEQ(initXNext, B.getInt32(WIDTH));
  B.CreateCondBr(initXCmp, bbInitXBack, bbInitX);

  B.SetInsertPoint(bbInitXBack);
  Value *initYNext = B.CreateAdd(initY, B.getInt32(1));
  Value *initYCmp = B.CreateICmpEQ(initYNext, B.getInt32(HEIGHT));
  B.CreateCondBr(initYCmp, bbSqY, bbInitY);

  // ---- квадрат 100.0f в центре (y, x: 116..139) ----
  B.SetInsertPoint(bbSqY);
  PHINode *sqY = B.CreatePHI(i32, 2);
  B.CreateBr(bbSqX);

  B.SetInsertPoint(bbSqX);
  PHINode *sqX = B.CreatePHI(i32, 2);
  B.CreateStore(ConstantFP::get(f32, 100.0f), gepU(u, sqY, sqX));
  B.CreateStore(ConstantFP::get(f32, 100.0f), gepU(uNext, sqY, sqX));
  Value *sqXNext = B.CreateAdd(sqX, B.getInt32(1));
  Value *sqXCmp = B.CreateICmpEQ(sqXNext, B.getInt32(SQ_HI));
  B.CreateCondBr(sqXCmp, bbSqXBack, bbSqX);

  B.SetInsertPoint(bbSqXBack);
  Value *sqYNext = B.CreateAdd(sqY, B.getInt32(1));
  Value *sqYCmp = B.CreateICmpEQ(sqYNext, B.getInt32(SQ_HI));
  B.CreateCondBr(sqYCmp, bbWhile, bbSqY);

  // ---- while (кадры) { 8 подшагов диффузии; отрисовка; simFlush(); } ----
  B.SetInsertPoint(bbWhile);
  PHINode *frame = B.CreatePHI(i32, 2);
  B.CreateBr(bbStep);

  B.SetInsertPoint(bbStep);
  PHINode *step = B.CreatePHI(i32, 2);
  B.CreateBr(bbDiffY);

  // диффузия: y, x: 1..254
  B.SetInsertPoint(bbDiffY);
  PHINode *diffY = B.CreatePHI(i32, 2);
  B.CreateBr(bbDiffX);

  B.SetInsertPoint(bbDiffX);
  PHINode *diffX = B.CreatePHI(i32, 2);
  Value *yGe = B.CreateICmpSGE(diffY, B.getInt32(SQ_LO));
  Value *yLt = B.CreateICmpSLT(diffY, B.getInt32(SQ_HI));
  Value *xGe = B.CreateICmpSGE(diffX, B.getInt32(SQ_LO));
  Value *xLt = B.CreateICmpSLT(diffX, B.getInt32(SQ_HI));
  Value *inSq = B.CreateAnd(B.CreateAnd(yGe, yLt), B.CreateAnd(xGe, xLt));
  B.CreateCondBr(inSq, bbDiffSet, bbDiffCalc);

  B.SetInsertPoint(bbDiffSet);
  B.CreateStore(ConstantFP::get(f32, 100.0f), gepU(uNext, diffY, diffX));
  B.CreateBr(bbDiffXTail);

  B.SetInsertPoint(bbDiffCalc);
  Value *u00 = B.CreateLoad(f32, gepU(u, diffY, diffX));
  Value *u10 = B.CreateLoad(
      f32, gepU(u, B.CreateAdd(diffY, B.getInt32(1)), diffX));
  Value *um10 = B.CreateLoad(
      f32, gepU(u, B.CreateSub(diffY, B.getInt32(1)), diffX));
  Value *u01 = B.CreateLoad(
      f32, gepU(u, diffY, B.CreateAdd(diffX, B.getInt32(1))));
  Value *u0m1 = B.CreateLoad(
      f32, gepU(u, diffY, B.CreateSub(diffX, B.getInt32(1))));
  Value *sum = B.CreateFAdd(B.CreateFAdd(u10, um10), B.CreateFAdd(u01, u0m1));
  Value *nxt = B.CreateFAdd(
      u00, B.CreateFMul(ConstantFP::get(f32, 0.22f),
                        B.CreateFSub(sum, B.CreateFMul(u00, ConstantFP::get(f32, 4.0f)))));
  B.CreateStore(nxt, gepU(uNext, diffY, diffX));
  B.CreateBr(bbDiffXTail);

  B.SetInsertPoint(bbDiffXTail);
  Value *diffXNext = B.CreateAdd(diffX, B.getInt32(1));
  Value *diffXCmp = B.CreateICmpEQ(diffXNext, B.getInt32(WIDTH - 1));
  B.CreateCondBr(diffXCmp, bbDiffXBack, bbDiffX);

  B.SetInsertPoint(bbDiffXBack);
  Value *diffYNext = B.CreateAdd(diffY, B.getInt32(1));
  Value *diffYCmp = B.CreateICmpEQ(diffYNext, B.getInt32(HEIGHT - 1));
  B.CreateCondBr(diffYCmp, bbCopyY, bbDiffY);

  // u = next_u (y, x: 1..254)
  B.SetInsertPoint(bbCopyY);
  PHINode *copyY = B.CreatePHI(i32, 2);
  B.CreateBr(bbCopyX);

  B.SetInsertPoint(bbCopyX);
  PHINode *copyX = B.CreatePHI(i32, 2);
  Value *nv = B.CreateLoad(f32, gepU(uNext, copyY, copyX));
  B.CreateStore(nv, gepU(u, copyY, copyX));
  Value *copyXNext = B.CreateAdd(copyX, B.getInt32(1));
  Value *copyXCmp = B.CreateICmpEQ(copyXNext, B.getInt32(WIDTH - 1));
  B.CreateCondBr(copyXCmp, bbCopyXBack, bbCopyX);

  B.SetInsertPoint(bbCopyXBack);
  Value *copyYNext = B.CreateAdd(copyY, B.getInt32(1));
  Value *copyYCmp = B.CreateICmpEQ(copyYNext, B.getInt32(HEIGHT - 1));
  B.CreateCondBr(copyYCmp, bbStepBack, bbCopyY);

  B.SetInsertPoint(bbStepBack);
  Value *stepNext = B.CreateAdd(step, B.getInt32(1));
  Value *stepCmp = B.CreateICmpEQ(stepNext, B.getInt32(SUB_STEPS));
  B.CreateCondBr(stepCmp, bbDrawY, bbStep);

  // отрисовка: нормировка/цвет + simPutPixel (y, x: 0..255)
  B.SetInsertPoint(bbDrawY);
  PHINode *drawY = B.CreatePHI(i32, 2);
  B.CreateBr(bbDrawX);

  B.SetInsertPoint(bbDrawX);
  PHINode *drawX = B.CreatePHI(i32, 2);
  Value *pv = B.CreateLoad(f32, gepU(u, drawY, drawX));
  Value *norm = B.CreateFDiv(pv, ConstantFP::get(f32, 100.0f));
  Value *n1 = B.CreateSelect(B.CreateFCmpOLT(norm, ConstantFP::get(f32, 0.0f)),
                             ConstantFP::get(f32, 0.0f), norm);
  Value *n2 = B.CreateSelect(B.CreateFCmpOGT(n1, ConstantFP::get(f32, 1.0f)),
                             ConstantFP::get(f32, 1.0f), n1);
  Value *low = B.CreateFCmpOLT(n2, ConstantFP::get(f32, 0.5f));
  B.CreateCondBr(low, bbDrawThen, bbDrawElse);

  B.SetInsertPoint(bbDrawThen);
  Value *rThen = B.CreateFPToSI(
      B.CreateFMul(B.CreateFMul(n2, ConstantFP::get(f32, 2.0f)), ConstantFP::get(f32, 255.0f)),
      i32);
  Value *bThen = B.CreateFPToSI(
      B.CreateFMul(B.CreateFMul(B.CreateFSub(ConstantFP::get(f32, 0.5f), n2),
                                ConstantFP::get(f32, 2.0f)),
                   ConstantFP::get(f32, 255.0f)),
      i32);
  B.CreateBr(bbDrawMerge);

  B.SetInsertPoint(bbDrawElse);
  Value *gElse = B.CreateFPToSI(
      B.CreateFMul(B.CreateFMul(B.CreateFSub(n2, ConstantFP::get(f32, 0.5f)),
                                ConstantFP::get(f32, 2.0f)),
                   ConstantFP::get(f32, 255.0f)),
      i32);
  B.CreateBr(bbDrawMerge);

  B.SetInsertPoint(bbDrawMerge);
  PHINode *r = B.CreatePHI(i32, 2);
  PHINode *g = B.CreatePHI(i32, 2);
  PHINode *b = B.CreatePHI(i32, 2);
  Value *argb = B.CreateOr(
      B.CreateOr(B.CreateShl(B.getInt32(0xFF), 24), B.CreateShl(r, 16)),
      B.CreateOr(B.CreateShl(g, 8), b));
  B.CreateCall(simPutPixelF, {drawY, drawX, argb});
  Value *drawXNext = B.CreateAdd(drawX, B.getInt32(1));
  Value *drawXCmp = B.CreateICmpEQ(drawXNext, B.getInt32(WIDTH));
  B.CreateCondBr(drawXCmp, bbDrawXBack, bbDrawX);

  B.SetInsertPoint(bbDrawXBack);
  Value *drawYNext = B.CreateAdd(drawY, B.getInt32(1));
  Value *drawYCmp = B.CreateICmpEQ(drawYNext, B.getInt32(HEIGHT));
  B.CreateCondBr(drawYCmp, bbFlush, bbDrawY);

  // кадр окончен: simFlush(); следующий кадр или выход
  B.SetInsertPoint(bbFlush);
  B.CreateCall(simFlushF);
  Value *frameNext = B.CreateAdd(frame, B.getInt32(1));
  Value *frameCmp = B.CreateICmpEQ(frameNext, B.getInt32(FRAME_LIMIT));
  B.CreateCondBr(frameCmp, bbRet, bbWhile);

  B.SetInsertPoint(bbRet);
  B.CreateRetVoid();

  // ---- связи phi-узлов ----
  initY->addIncoming(B.getInt32(0), bbEntry);
  initY->addIncoming(initYNext, bbInitXBack);
  initX->addIncoming(B.getInt32(0), bbInitY);
  initX->addIncoming(initXNext, bbInitX);

  sqY->addIncoming(B.getInt32(SQ_LO), bbInitXBack);
  sqY->addIncoming(sqYNext, bbSqXBack);
  sqX->addIncoming(B.getInt32(SQ_LO), bbSqY);
  sqX->addIncoming(sqXNext, bbSqX);

  frame->addIncoming(B.getInt32(0), bbSqXBack);
  frame->addIncoming(frameNext, bbFlush);
  step->addIncoming(B.getInt32(0), bbWhile);
  step->addIncoming(stepNext, bbStepBack);

  diffY->addIncoming(B.getInt32(1), bbStep);
  diffY->addIncoming(diffYNext, bbDiffXBack);
  diffX->addIncoming(B.getInt32(1), bbDiffY);
  diffX->addIncoming(diffXNext, bbDiffXTail);

  copyY->addIncoming(B.getInt32(1), bbDiffXBack);
  copyY->addIncoming(copyYNext, bbCopyXBack);
  copyX->addIncoming(B.getInt32(1), bbCopyY);
  copyX->addIncoming(copyXNext, bbCopyX);

  drawY->addIncoming(B.getInt32(0), bbStepBack);
  drawY->addIncoming(drawYNext, bbDrawXBack);
  drawX->addIncoming(B.getInt32(0), bbDrawY);
  drawX->addIncoming(drawXNext, bbDrawMerge);

  r->addIncoming(rThen, bbDrawThen);
  r->addIncoming(B.getInt32(255), bbDrawElse);
  g->addIncoming(B.getInt32(0), bbDrawThen);
  g->addIncoming(gElse, bbDrawElse);
  b->addIncoming(bThen, bbDrawThen);
  b->addIncoming(B.getInt32(0), bbDrawElse);

  // ---- печать сгенерированного IR и проверка ----
  outs() << "; IR generated by IRGen/app_ir_gen.cpp for module 'app.c', FRAMES="
         << FRAME_LIMIT << "\n";
  module->print(outs(), nullptr);
  outs() << "\n";
  outs().flush();
  bool bad = verifyModule(*module, &outs());
  outs().flush();
  outs() << "[VERIFICATION] " << (bad ? "FAIL\n" : "OK\n");

  outs() << "[IRGen] defined functions:";
  for (Function &F : *module)
    if (!F.isDeclaration())
      outs() << " " << F.getName();
  outs() << "\n[IRGen] external functions (forwarded to ExecutionEngine):";
  for (Function &F : *module)
    if (F.isDeclaration())
      outs() << " " << F.getName();
  outs() << "\n";

  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();

  EngineBuilder EB{std::unique_ptr<Module>(module)};
  EB.setEngineKind(EngineKind::Interpreter);
  ExecutionEngine *ee = EB.create();
  if (!ee) {
    errs() << "[EE] failed to create ExecutionEngine\n";
    return EXIT_FAILURE;
  }
  ee->InstallLazyFunctionCreator([](const std::string &fnName) -> void * {
    if (fnName == "simPutPixel")
      return reinterpret_cast<void *>(&simPutPixel);
    if (fnName == "simFlush")
      return reinterpret_cast<void *>(&simFlush);
    errs() << "[EE] unresolved external function: " << fnName << "\n";
    return nullptr;
  });
  ee->finalizeObject();

  simInit();
  outs() << "[EE] running app() in LLVM Interpreter ("
         << FRAME_LIMIT << " frame(s))...\n";
  GenericValue v = ee->runFunction(appF, {});
  outs() << "[EE] app() finished, result: " << v.IntVal << "\n";

  if (getenv("IRGEN_AUTOQUIT")) {
    SDL_Event q;
    std::memset(&q, 0, sizeof(q));
    q.type = SDL_QUIT;
    SDL_PushEvent(&q);
  }
  simExit();
  return EXIT_SUCCESS;
}
