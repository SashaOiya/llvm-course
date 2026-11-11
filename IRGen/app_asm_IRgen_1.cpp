// Задание 4, п.3: ASM2IR-генератор - каждая инструкция ISA превращается в вызов
// эмулирующей функции do_*, кроме инструкций потока управления (BR/BR_COND/EXIT),
// которые переводятся в настоящие IR-переходы. Исполнение - ExecutionEngine (JIT).
// Использование: app_asm_IRgen_1 program.s
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

  // экспортируемые в IR глобалы: regFile/data отображаются на нативную память
  ArrayType *regFileTy = ArrayType::get(i32, REG_FILE_SIZE);
  module->getOrInsertGlobal("regFile", regFileTy);
  GlobalVariable *regFileG = module->getNamedGlobal("regFile");
  ArrayType *dataTy = ArrayType::get(i32, DS_WORDS);
  module->getOrInsertGlobal("data", dataTy);
  GlobalVariable *dataG = module->getNamedGlobal("data");

  FunctionType *mainFT = FunctionType::get(builder.getVoidTy(), false);
  Function *mainF = Function::Create(mainFT, Function::ExternalLinkage, "main", module);

  // объявления эмулирующих функций (все - void; арность 3, кроме FLUSH(0))
  auto decl3 = [&](const char *n) {
    return module->getOrInsertFunction(
        n, FunctionType::get(builder.getVoidTy(),
                             {i32, i32, i32}, false));
  };
  FunctionCallee fM = decl3("do_MOVi"), fADD = decl3("do_ADD"), fADDi = decl3("do_ADDi"),
      fSUB = decl3("do_SUB"), fSUBi = decl3("do_SUBi"), fMUL = decl3("do_MUL"),
      fMULi = decl3("do_MULi"), fSHL = decl3("do_SHL"), fSHR = decl3("do_SHR"),
      fAND = decl3("do_AND"), fANDi = decl3("do_ANDi"), fOR = decl3("do_OR"),
      fORi = decl3("do_ORi"), fXOR = decl3("do_XOR"), fLD = decl3("do_LD"),
      fST = decl3("do_ST"), fFADD = decl3("do_FADD"), fFSUB = decl3("do_FSUB"),
      fFMUL = decl3("do_FMUL"), fFMULi = decl3("do_FMULi"),
      fFTCI = decl3("do_FTCI"), fEQ = decl3("do_CMPEQi"), fGE = decl3("do_CMPGEi"),
      fLT = decl3("do_CMPLTi"), fFLT = decl3("do_FCMPLTi"),
      fPX = decl3("do_PUT_PIXEL");
  FunctionCallee fFlush = module->getOrInsertFunction(
      "do_FLUSH", FunctionType::get(builder.getVoidTy(), false));
  FunctionCallee fFMADD = module->getOrInsertFunction(
      "do_FMULADD", FunctionType::get(builder.getVoidTy(), {i32, i32, i32, i32}, false));

  // BB-границы: 0 и все метки; терминирующие инструкции завершают BB
  std::vector<uint32_t> starts{0};
  for (auto &kv : p.labels) starts.push_back(kv.second);
  std::sort(starts.begin(), starts.end());
  starts.erase(std::unique(starts.begin(), starts.end()), starts.end());
  std::map<uint32_t, BasicBlock *> bbAt;
  for (uint32_t s : starts) bbAt[s] = BasicBlock::Create(context, p.labelOf(s), mainF);

  outs() << "\n#[FILE]: " << argv[1] << " BBs:";
  for (uint32_t s : starts) outs() << " " << p.labelOf(s);
  outs() << "\n";

  auto gen3 = [&](FunctionCallee f, const AsmProgram::Instr &I) {
    builder.CreateCall(f, {builder.getInt32(I.ops[0]), builder.getInt32(I.ops[1]),
                           builder.getInt32(I.ops[2])});
  };

  for (size_t i = 0; i < starts.size(); ++i) {
    uint32_t begin = starts[i];
    uint32_t end = (i + 1 < starts.size()) ? starts[i + 1] : (uint32_t)p.instrs.size();
    builder.SetInsertPoint(bbAt[begin]);
    for (uint32_t k = begin; k < end; ++k) {
      const AsmProgram::Instr &I = p.instrs[k];
      switch (I.op) {
        case AsmProgram::OP_MOVi: gen3(fM, I); break;
        case AsmProgram::OP_ADD: gen3(fADD, I); break;
        case AsmProgram::OP_ADDi: gen3(fADDi, I); break;
        case AsmProgram::OP_SUB: gen3(fSUB, I); break;
        case AsmProgram::OP_SUBi: gen3(fSUBi, I); break;
        case AsmProgram::OP_MUL: gen3(fMUL, I); break;
        case AsmProgram::OP_MULi: gen3(fMULi, I); break;
        case AsmProgram::OP_SHL: gen3(fSHL, I); break;
        case AsmProgram::OP_SHR: gen3(fSHR, I); break;
        case AsmProgram::OP_AND: gen3(fAND, I); break;
        case AsmProgram::OP_ANDi: gen3(fANDi, I); break;
        case AsmProgram::OP_OR: gen3(fOR, I); break;
        case AsmProgram::OP_ORi: gen3(fORi, I); break;
        case AsmProgram::OP_XOR: gen3(fXOR, I); break;
        case AsmProgram::OP_LD: gen3(fLD, I); break;
        case AsmProgram::OP_ST: gen3(fST, I); break;
        case AsmProgram::OP_FADD: gen3(fFADD, I); break;
        case AsmProgram::OP_FSUB: gen3(fFSUB, I); break;
        case AsmProgram::OP_FMUL: gen3(fFMUL, I); break;
        case AsmProgram::OP_FMULi: gen3(fFMULi, I); break;
        case AsmProgram::OP_FTCI: gen3(fFTCI, I); break;
        case AsmProgram::OP_CMPEQi: gen3(fEQ, I); break;
        case AsmProgram::OP_CMPGEi: gen3(fGE, I); break;
        case AsmProgram::OP_CMPLTi: gen3(fLT, I); break;
        case AsmProgram::OP_FCMPLTi: gen3(fFLT, I); break;
        case AsmProgram::OP_PUT_PIXEL: gen3(fPX, I); break;
        case AsmProgram::OP_FLUSH: builder.CreateCall(fFlush); break;
        case AsmProgram::OP_FMULADD:
          builder.CreateCall(fFMADD, {builder.getInt32(I.ops[0]), builder.getInt32(I.ops[1]),
                                      builder.getInt32(I.ops[2]), builder.getInt32(I.ops[3])});
          break;
        // ---- поток управления: НЕ эмулируется, генерируются IR-переходы ----
        case AsmProgram::OP_BR_COND: {
          Value *reg = builder.CreateLoad(i32, builder.CreateConstGEP2_32(regFileTy, regFileG, 0, I.ops[0]));
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
    struct { const char *n; void *p; } T[] = {
      {"do_MOVi", (void *)&do_MOVi}, {"do_ADD", (void *)&do_ADD},
      {"do_ADDi", (void *)&do_ADDi}, {"do_SUB", (void *)&do_SUB},
      {"do_SUBi", (void *)&do_SUBi}, {"do_MUL", (void *)&do_MUL},
      {"do_MULi", (void *)&do_MULi}, {"do_SHL", (void *)&do_SHL},
      {"do_SHR", (void *)&do_SHR}, {"do_AND", (void *)&do_AND},
      {"do_ANDi", (void *)&do_ANDi}, {"do_OR", (void *)&do_OR},
      {"do_ORi", (void *)&do_ORi}, {"do_XOR", (void *)&do_XOR},
      {"do_LD", (void *)&do_LD}, {"do_ST", (void *)&do_ST},
      {"do_FADD", (void *)&do_FADD}, {"do_FSUB", (void *)&do_FSUB},
      {"do_FMUL", (void *)&do_FMUL}, {"do_FMULi", (void *)&do_FMULi},
      {"do_FMULADD", (void *)&do_FMULADD}, {"do_FTCI", (void *)&do_FTCI},
      {"do_CMPEQi", (void *)&do_CMPEQi}, {"do_CMPGEi", (void *)&do_CMPGEi},
      {"do_CMPLTi", (void *)&do_CMPLTi}, {"do_FCMPLTi", (void *)&do_FCMPLTi},
      {"do_PUT_PIXEL", (void *)&do_PUT_PIXEL}, {"do_FLUSH", (void *)&do_FLUSH}
    };
    for (auto &e : T) if (fnName == e.n) return e.p;
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

  uint64_t dhash = 0xcbf29ce484222325ULL, hu = 0xcbf29ce484222325ULL, hn = 0xcbf29ce484222325ULL;
  for (uint32_t i = 0; i < DS_WORDS; ++i) {
    uint32_t w = DS[i];
    if (i < 65536) { hu ^= w; hu *= 1099511628211ULL; } else { hn ^= w; hn *= 1099511628211ULL; }
    dhash ^= w; dhash *= 1099511628211ULL;
  }
  outs() << "#[ASM2IR-1] pixels: " << asm_pixel_count
         << ", pixel-hash: " << llvm::format_hex(asm_pixel_hash, 16)
         << ", u-hash: " << llvm::format_hex(hu, 16) << ", next-hash: " << llvm::format_hex(hn, 16) << ", data-hash: " << llvm::format_hex(dhash, 16)
         << ", time: " << ms << " ms\n";
  return 0;
}
