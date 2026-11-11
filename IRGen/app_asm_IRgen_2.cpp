// Задание 4, п.4: ASM2IR-генератор - для КАЖДОЙ инструкции ISA генерируется
// эквивалентная последовательность LLVM IR (арифметика, память через GEP,
// вещественные через bitcast i32<->f32). Поток управления - как в п.3.
// Исполнение - ExecutionEngine (JIT). Использование: app_asm_IRgen_2 program.s
#include "app_asm_common.h"
#include "app_asm_runtime.h"
extern "C" {
#include "../sim.h"
}

#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include <chrono>
#include <cstring>

using namespace llvm;

static float bitsToF32(uint32_t b) { union { uint32_t u; float f; } x = {b}; return x.f; }

int main(int argc, char *argv[]) {
  if (argc != 2) {
    errs() << "[ERROR] Need 1 argument: file with assembler code\n";
    return 1;
  }
  AsmProgram p;
  std::string err;
  if (!p.load(argv[1], err)) { errs() << "[ERROR] " << err << "\n"; return 1; }

  LLVMContext context;
  Module *module = new Module("top", context);
  IRBuilder<> builder(context);
  Type *i32 = builder.getInt32Ty();
  Type *f32 = builder.getFloatTy();

  // regFile and data - глобалы IR; хранилище отображается на нативные буферы
  // (addGlobalMapping) точно так же, как в примере курса, чтобы исполнение и
  // верификация состояния использовали одну и ту же память
  ArrayType *regFileTy = ArrayType::get(i32, REG_FILE_SIZE);
  module->getOrInsertGlobal("regFile", regFileTy);
  GlobalVariable *regFileG = module->getNamedGlobal("regFile");
  ArrayType *dataTy = ArrayType::get(i32, DS_WORDS);
  module->getOrInsertGlobal("data", dataTy);
  GlobalVariable *dataG = module->getNamedGlobal("data");

  FunctionType *mainFT = FunctionType::get(builder.getVoidTy(), false);
  Function *mainF = Function::Create(mainFT, Function::ExternalLinkage, "main", module);

  // внешние функции: графика и статистика
  FunctionCallee simPutPixelF = module->getOrInsertFunction(
      "simPutPixel", FunctionType::get(builder.getVoidTy(), {i32, i32, i32}, false));
  FunctionCallee simFlushF = module->getOrInsertFunction(
      "simFlush", FunctionType::get(builder.getVoidTy(), false));
  FunctionCallee hashF = module->getOrInsertFunction(
      "asm_pixel_hash_fn", FunctionType::get(builder.getVoidTy(), {i32, i32, i32}, false));

  std::vector<uint32_t> starts{0};
  for (auto &kv : p.labels) starts.push_back(kv.second);
  std::sort(starts.begin(), starts.end());
  starts.erase(std::unique(starts.begin(), starts.end()), starts.end());
  std::map<uint32_t, BasicBlock *> bbAt;
  for (uint32_t s : starts) bbAt[s] = BasicBlock::Create(context, p.labelOf(s), mainF);

  outs() << "\n#[FILE]: " << argv[1] << " BBs:";
  for (uint32_t s : starts) outs() << " " << p.labelOf(s);
  outs() << "\n";

  auto gepReg = [&](uint32_t idx) {
    return builder.CreateConstGEP2_32(regFileTy, regFileG, 0, idx);
  };
  auto loadReg = [&](uint32_t idx) { return builder.CreateLoad(i32, gepReg(idx)); };
  auto storeReg = [&](uint32_t idx, Value *v) { builder.CreateStore(v, gepReg(idx)); };
  auto fImm = [&](uint32_t u) { return ConstantFP::get(f32, bitsToF32(u)); };
  auto asFloat = [&](Value *v) { return builder.CreateBitCast(v, f32); };
  auto asBits = [&](Value *v) { return builder.CreateBitCast(v, i32); };
  auto cmpStore = [&](Value *c, uint32_t d) { storeReg(d, builder.CreateZExt(c, i32)); };
  auto fadd3 = [&](uint32_t d, uint32_t a, uint32_t b) {
    storeReg(d, asBits(builder.CreateFAdd(asFloat(loadReg(a)), asFloat(loadReg(b)))));
  };
  // указатель на слово DS по байтовому адресу в регистре
  auto gepData = [&](uint32_t addrReg) {
    Value *addr = loadReg(addrReg);
    Value *word = builder.CreateLShr(addr, builder.getInt32(2));
    return builder.CreateInBoundsGEP(dataTy, dataG, {builder.getInt32(0), word});
  };

  for (size_t i = 0; i < starts.size(); ++i) {
    uint32_t begin = starts[i];
    uint32_t end = (i + 1 < starts.size()) ? starts[i + 1] : (uint32_t)p.instrs.size();
    builder.SetInsertPoint(bbAt[begin]);
    for (uint32_t k = begin; k < end; ++k) {
      const AsmProgram::Instr &I = p.instrs[k];
      Value *a, *b, *c;
      switch (I.op) {
        case AsmProgram::OP_MOVi: storeReg(I.ops[0], builder.getInt32(I.ops[1])); break;
        case AsmProgram::OP_ADD: storeReg(I.ops[0], builder.CreateAdd(loadReg(I.ops[1]), loadReg(I.ops[2]))); break;
        case AsmProgram::OP_ADDi: storeReg(I.ops[0], builder.CreateAdd(loadReg(I.ops[1]), builder.getInt32(I.ops[2]))); break;
        case AsmProgram::OP_SUB: storeReg(I.ops[0], builder.CreateSub(loadReg(I.ops[1]), loadReg(I.ops[2]))); break;
        case AsmProgram::OP_SUBi: storeReg(I.ops[0], builder.CreateSub(loadReg(I.ops[1]), builder.getInt32(I.ops[2]))); break;
        case AsmProgram::OP_MUL: storeReg(I.ops[0], builder.CreateMul(loadReg(I.ops[1]), loadReg(I.ops[2]))); break;
        case AsmProgram::OP_MULi: storeReg(I.ops[0], builder.CreateMul(loadReg(I.ops[1]), builder.getInt32(I.ops[2]))); break;
        case AsmProgram::OP_SHL: storeReg(I.ops[0], builder.CreateShl(loadReg(I.ops[1]), builder.getInt32(I.ops[2]))); break;
        case AsmProgram::OP_SHR: storeReg(I.ops[0], builder.CreateLShr(loadReg(I.ops[1]), builder.getInt32(I.ops[2]))); break;
        case AsmProgram::OP_AND: storeReg(I.ops[0], builder.CreateAnd(loadReg(I.ops[1]), loadReg(I.ops[2]))); break;
        case AsmProgram::OP_ANDi: storeReg(I.ops[0], builder.CreateAnd(loadReg(I.ops[1]), builder.getInt32(I.ops[2]))); break;
        case AsmProgram::OP_OR: storeReg(I.ops[0], builder.CreateOr(loadReg(I.ops[1]), loadReg(I.ops[2]))); break;
        case AsmProgram::OP_ORi: storeReg(I.ops[0], builder.CreateOr(loadReg(I.ops[1]), builder.getInt32(I.ops[2]))); break;
        case AsmProgram::OP_XOR: storeReg(I.ops[0], builder.CreateXor(loadReg(I.ops[1]), loadReg(I.ops[2]))); break;
        case AsmProgram::OP_LD: storeReg(I.ops[0], builder.CreateLoad(i32, gepData(I.ops[1]))); break;
        case AsmProgram::OP_ST: builder.CreateStore(loadReg(I.ops[1]), gepData(I.ops[0])); break;
        case AsmProgram::OP_FADD: fadd3(I.ops[0], I.ops[1], I.ops[2]); break;
        case AsmProgram::OP_FSUB: storeReg(I.ops[0], asBits(builder.CreateFSub(asFloat(loadReg(I.ops[1])), asFloat(loadReg(I.ops[2]))))); break;
        case AsmProgram::OP_FMUL: storeReg(I.ops[0], asBits(builder.CreateFMul(asFloat(loadReg(I.ops[1])), asFloat(loadReg(I.ops[2]))))); break;
        case AsmProgram::OP_FMULi: storeReg(I.ops[0], asBits(builder.CreateFMul(asFloat(loadReg(I.ops[1])), fImm(I.ops[2])))); break;
        case AsmProgram::OP_FMULADD:
          storeReg(I.ops[0], asBits(builder.CreateFAdd(
              builder.CreateFMul(asFloat(loadReg(I.ops[1])), asFloat(loadReg(I.ops[2]))),
              asFloat(loadReg(I.ops[3])))));
          break;
        case AsmProgram::OP_FTCI:
          storeReg(I.ops[0], builder.CreateFPToSI(asFloat(loadReg(I.ops[1])), i32));
          break;
        case AsmProgram::OP_CMPEQi: cmpStore(builder.CreateICmpEQ(loadReg(I.ops[1]), builder.getInt32(I.ops[2])), I.ops[0]); break;
        case AsmProgram::OP_CMPGEi: cmpStore(builder.CreateICmpSGE(loadReg(I.ops[1]), builder.getInt32(I.ops[2])), I.ops[0]); break;
        case AsmProgram::OP_CMPLTi: cmpStore(builder.CreateICmpSLT(loadReg(I.ops[1]), builder.getInt32(I.ops[2])), I.ops[0]); break;
        case AsmProgram::OP_FCMPLTi: cmpStore(builder.CreateFCmpOLT(asFloat(loadReg(I.ops[1])), fImm(I.ops[2])), I.ops[0]); break;
        case AsmProgram::OP_PUT_PIXEL: {
          a = loadReg(I.ops[0]); b = loadReg(I.ops[1]); c = loadReg(I.ops[2]);
          builder.CreateCall(simPutPixelF, {a, b, c});
          builder.CreateCall(hashF, {a, b, c});
          break;
        }
        case AsmProgram::OP_FLUSH: builder.CreateCall(simFlushF); break;
        // ---- поток управления ----
        case AsmProgram::OP_BR_COND: {
          Value *reg = loadReg(I.ops[0]);
          builder.CreateCondBr(builder.CreateTrunc(reg, builder.getInt1Ty()),
                               bbAt[I.ops[1]], bbAt[I.ops[2]]);
          goto nextBB;
        }
        case AsmProgram::OP_BR: builder.CreateBr(bbAt[I.ops[0]]); goto nextBB;
        case AsmProgram::OP_EXIT: builder.CreateRetVoid(); goto nextBB;
      }
    }
    if (i + 1 < starts.size()) builder.CreateBr(bbAt[starts[i + 1]]); // fallthrough
  nextBB:;
  }

  outs() << "\n#[LLVM IR]:\n";
  module->print(outs(), nullptr);
  outs() << '\n';
  bool verif = verifyFunction(*mainF, &outs());
  outs() << "[VERIFICATION] " << (verif ? "FAIL\n\n" : "OK\n\n");

  outs() << "\n#[Running code]\n";
  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();
  ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module)).create();
  ee->InstallLazyFunctionCreator([](const std::string &fnName) -> void * {
    if (fnName == "simPutPixel") return reinterpret_cast<void *>(&simPutPixel);
    if (fnName == "simFlush") return reinterpret_cast<void *>(&simFlush);
    if (fnName == "asm_pixel_hash_fn") return reinterpret_cast<void *>(&asm_pixel_hash_fn);
    errs() << "[EE] Can't find function " << fnName << "\n";
    return nullptr;
  });
  ee->addGlobalMapping(regFileG, (void *)REG_FILE);
  ee->addGlobalMapping(dataG, (void *)DS);
  ee->finalizeObject();

  asm_reset_stats();
  simInit();
  auto t0 = std::chrono::steady_clock::now();
  ArrayRef<GenericValue> noargs;
  ee->runFunction(mainF, noargs);
  auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
      std::chrono::steady_clock::now() - t0).count();
  outs() << "#[Code was run]\n";
  asm_sim_finish();

  uint32_t *dataPtr = (uint32_t *)ee->getPointerToGlobal(dataG);
  uint64_t dhash = 0xcbf29ce484222325ULL, hu = 0xcbf29ce484222325ULL, hn = 0xcbf29ce484222325ULL;
  for (uint32_t i = 0; i < DS_WORDS; ++i) {
    uint32_t w = dataPtr[i];
    if (i < 65536) { hu ^= w; hu *= 1099511628211ULL; } else { hn ^= w; hn *= 1099511628211ULL; }
    dhash ^= w; dhash *= 1099511628211ULL;
  }
  outs() << "#[ASM2IR-2] pixels: " << asm_pixel_count
         << ", pixel-hash: " << llvm::format_hex(asm_pixel_hash, 16)
         << ", u-hash: " << llvm::format_hex(hu, 16) << ", next-hash: " << llvm::format_hex(hn, 16) << ", data-hash: " << llvm::format_hex(dhash, 16)
         << ", time: " << ms << " ms\n";
  return 0;
}
