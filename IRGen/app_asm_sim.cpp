// Задание 4, п.5*: симуляция без генерации IR - только вызовы эмулирующих
// инструкции функций (поток управления исполняется прямо на PC).
// Использование: app_asm_sim program.s
#include "app_asm_common.h"
#include "app_asm_runtime.h"
extern "C" {
#include "../sim.h"
}
#include <chrono>
#include <cstdio>
#include <cstring>

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "[ERROR] Need 1 argument: file with assembler code\n");
    return 1;
  }
  AsmProgram p;
  std::string err;
  if (!p.load(argv[1], err)) { fprintf(stderr, "[ERROR] %s\n", err.c_str()); return 1; }
  printf("#[FILE]: %s, instructions: %zu, labels: %zu\n",
         argv[1], p.instrs.size(), p.labels.size());

  asm_reset_stats();
  simInit();

  uint64_t steps = 0;
  uint32_t pc = 0;
  auto t0 = std::chrono::steady_clock::now();
#define SIM_EXIT goto done
  while (pc < p.instrs.size()) {
    const AsmProgram::Instr &I = p.instrs[pc];
    ++steps;
    switch (I.op) {
      case AsmProgram::OP_MOVi:    do_MOVi(I.ops[0], I.ops[1]); break;
      case AsmProgram::OP_ADD:     do_ADD(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_ADDi:    do_ADDi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_SUB:     do_SUB(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_SUBi:    do_SUBi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_MUL:     do_MUL(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_MULi:    do_MULi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_SHL:     do_SHL(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_SHR:     do_SHR(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_AND:     do_AND(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_ANDi:    do_ANDi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_OR:      do_OR(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_ORi:     do_ORi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_XOR:     do_XOR(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_LD:      do_LD(I.ops[0], I.ops[1]); break;
      case AsmProgram::OP_ST:      do_ST(I.ops[0], I.ops[1]); break;
      case AsmProgram::OP_FADD:    do_FADD(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_FSUB:    do_FSUB(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_FMUL:    do_FMUL(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_FMULi:   do_FMULi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_FMULADD: do_FMULADD(I.ops[0], I.ops[1], I.ops[2], I.ops[3]); break;
      case AsmProgram::OP_FTCI:    do_FTCI(I.ops[0], I.ops[1]); break;
      case AsmProgram::OP_CMPEQi:  do_CMPEQi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_CMPGEi:  do_CMPGEi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_CMPLTi:  do_CMPLTi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_FCMPLTi: do_FCMPLTi(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_PUT_PIXEL: do_PUT_PIXEL(I.ops[0], I.ops[1], I.ops[2]); break;
      case AsmProgram::OP_FLUSH:   do_FLUSH(); break;
      case AsmProgram::OP_BR_COND:
        pc = REG_FILE[I.ops[0]] != 0 ? I.ops[1] : I.ops[2];
        continue;
      case AsmProgram::OP_BR: pc = I.ops[0]; continue;
      case AsmProgram::OP_EXIT: SIM_EXIT;
    }
    ++pc;
  }
done:
  auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(
      std::chrono::steady_clock::now() - t0).count();
  asm_sim_finish();

  uint64_t dhash = 0xcbf29ce484222325ULL;
  for (uint32_t i = 0; i < DS_WORDS; ++i) { dhash ^= DS[i]; dhash *= 1099511628211ULL; }
  printf("#[SIM] steps: %llu, pixels: %llu, pixel-hash: 0x%016llx, data-hash: 0x%016llx, time: %lld ms\n",
         (unsigned long long)steps, (unsigned long long)asm_pixel_count,
         (unsigned long long)asm_pixel_hash, (unsigned long long)dhash, (long long)ms);
  return 0;
}
