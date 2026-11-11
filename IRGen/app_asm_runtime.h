#ifndef APP_ASM_RUNTIME_H
#define APP_ASM_RUNTIME_H
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
// Регистровый файл и сегмент данных (см. IRGen/ISA.md)
#define REG_FILE_SIZE 16
#define DS_WORDS 131072 /* 2 * 256 * 256 (u32): u и next_u */
extern uint32_t REG_FILE[REG_FILE_SIZE];
extern uint32_t DS[DS_WORDS];
// статистика исполнения (одинаковая во всех вариантах ASM2IR)
extern uint64_t asm_pixel_count;
extern uint64_t asm_pixel_hash;

// Эмулирующие функции (по одной на инструкцию ISA; поток управления не эмулируется)
void do_MOVi(int d, uint32_t imm);
void do_ADD(int d, int a, int b);
void do_ADDi(int d, int a, uint32_t imm);
void do_SUB(int d, int a, int b);
void do_SUBi(int d, int a, uint32_t imm);
void do_MUL(int d, int a, int b);
void do_MULi(int d, int a, uint32_t imm);
void do_SHL(int d, int a, uint32_t imm);
void do_SHR(int d, int a, uint32_t imm);
void do_AND(int d, int a, int b);
void do_ANDi(int d, int a, uint32_t imm);
void do_OR(int d, int a, int b);
void do_ORi(int d, int a, uint32_t imm);
void do_XOR(int d, int a, int b);
void do_LD(int d, int a);
void do_ST(int a, int b);
void do_FADD(int d, int a, int b);
void do_FSUB(int d, int a, int b);
void do_FMUL(int d, int a, int b);
void do_FMULi(int d, int a, uint32_t imm);
void do_FMULADD(int d, int a, int b, int c);
void do_FTCI(int d, int a);
void do_CMPEQi(int d, int a, uint32_t imm);
void do_CMPGEi(int d, int a, uint32_t imm);
void do_CMPLTi(int d, int a, uint32_t imm);
void do_FCMPLTi(int d, int a, uint32_t imm);
void do_PUT_PIXEL(int y, int x, int c);
void do_FLUSH(void);
void asm_reset_stats(void);
void asm_sim_finish(void); /* SDL_QUIT + simExit */
void asm_pixel_hash_fn(uint32_t y, uint32_t x, uint32_t c);
#ifdef __cplusplus
}
#endif
#endif
