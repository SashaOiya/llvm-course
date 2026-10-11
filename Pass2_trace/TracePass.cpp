// TracePass.cpp
//
// Инструментирующий LLVM Pass (New Pass Manager, плагин для clang).
//
// Задание 2: собрать в рантайме трассу использования IR-инструкций
// (User <- Operand) приложения app.c на -O2/-Os.
//
// Что делает Pass:
//   1. Работает только над модулем, скомпилированным из app.c
//      (проверка source file name модуля заканчивается на "app.c").
//   2. Присваивает каждой инструкции стабильный числовой id и пишет
//      статическую карту id -> (opcode, function, печать инструкции)
//      в файл из переменной окружения TRACE_MAP (по умолчанию trace_map.txt).
//   3. Для каждой НЕ-phi инструкции-пользователя (User) и каждого её
//      операнда-инструкции (Operand) вставляет перед User вызов
//          void traceLogger(uint64 user_id, uint64 operand_id)
//      определённый в trace.c. В рантайме при каждом исполнении User
//      этот вызов пишет пару (user_id, operand_id) в бинарный файл
//      TRACE_FILE (см. trace.c).

#include "llvm/ADT/DenseMap.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/Passes/OptimizationLevel.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/raw_ostream.h"

#include <cstdlib>
#include <string>
#include <vector>

using namespace llvm;

namespace {

const char *mapFilePath() {
  const char *p = getenv("TRACE_MAP");
  return (p && *p) ? p : "trace_map.txt";
}

struct TraceInstrPass : public PassInfoMixin<TraceInstrPass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
    StringRef src = M.getSourceFileName();
    if (!src.ends_with("app.c")) {
      outs() << "[TracePass] module '" << src << "' skipped\n";
      return PreservedAnalyses::all();
    }
    outs() << "[TracePass] instrumenting module '" << src << "'\n";

    LLVMContext &Ctx = M.getContext();
    Type *i64Ty = Type::getInt64Ty(Ctx);
    FunctionType *logTy =
        FunctionType::get(Type::getVoidTy(Ctx), {i64Ty, i64Ty}, false);
    FunctionCallee traceLogger = M.getOrInsertFunction("traceLogger", logTy);

    // --- 1. Стабильные id для всех инструкций функций app.c ---
    DenseMap<const Instruction *, uint64_t> Ids;
    uint64_t nextId = 1;
    for (Function &F : M) {
      if (F.isDeclaration())
        continue;
      for (BasicBlock &BB : F)
        for (Instruction &I : BB)
          Ids[&I] = nextId++;
    }
    outs() << "[TracePass] assigned " << (nextId - 1) << " ids\n";

    // --- 2. Статическая карта id -> описание инструкции ---
    std::error_code EC;
    raw_fd_ostream map(mapFilePath(), EC,
                       sys::fs::OF_Text);
    if (EC) {
      errs() << "[TracePass] cannot open map file: " << EC.message() << "\n";
    } else {
      map << "# trace static map, module: " << src << "\n";
      map << "# columns: id<TAB>is_phi<TAB>opcode<TAB>function<TAB>print\n";
      for (Function &F : M) {
        if (F.isDeclaration())
          continue;
        for (BasicBlock &BB : F) {
          for (Instruction &I : BB) {
            std::string s;
            raw_string_ostream sos(s);
            I.print(sos, true);
            std::string one;
            for (char c : sos.str())
              one += (c == '\t' || c == '\n') ? ' ' : c;
            map << Ids[&I] << '\t' << (isa<PHINode>(I) ? 1 : 0) << '\t'
                << I.getOpcodeName() << '\t' << F.getName() << '\t' << one
                << '\n';
          }
        }
      }
    }

    // --- 3. Инструментирование: traceLogger(user_id, operand_id) ---
    // Пропускаем User'ов, являющихся phi-инструкциями (по условию задания).
    // Операнд учитываем только если это инструкция (не константа/аргумент/блок).
    IRBuilder<> builder(Ctx);
    for (Function &F : M) {
      if (F.isDeclaration())
        continue;
      std::vector<Instruction *> users;
      for (BasicBlock &BB : F)
        for (Instruction &I : BB)
          if (!isa<PHINode>(I))
            users.push_back(&I);

      for (Instruction *U : users) {
        uint64_t uid = Ids[U];
        for (Use &Op : U->operands()) {
          if (auto *Operand = dyn_cast<Instruction>(Op.get())) {
            builder.SetInsertPoint(U);
            Value *args[] = {ConstantInt::get(i64Ty, uid),
                             ConstantInt::get(i64Ty, Ids[Operand])};
            builder.CreateCall(traceLogger, args);
          }
        }
      }
    }

    outs() << "[TracePass] done\n";
    return PreservedAnalyses::none();
  }
};

} // namespace

PassPluginLibraryInfo getPassPluginInfo() {
  const auto callback = [](PassBuilder &PB) {
    // Инструментируем уже оптимизированный IR (конец пайплайна -O2/-Os),
    // чтобы трасса соответствовала реально исполняемому коду.
    PB.registerOptimizerLastEPCallback(
        [](ModulePassManager &MPM, OptimizationLevel) {
          MPM.addPass(TraceInstrPass{});
          return true;
        });
  };
  return {LLVM_PLUGIN_API_VERSION, "TraceInstrPass", "0.1", callback};
}

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getPassPluginInfo();
}
