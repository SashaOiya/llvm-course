#include "app_asm_runtime.h"
#include "../sim.h"
#include <SDL2/SDL.h>
#include <string.h>
#include <string.h>

uint32_t REG_FILE[REG_FILE_SIZE];
uint32_t DS[DS_WORDS];
uint64_t asm_pixel_count = 0;
uint64_t asm_pixel_hash = 0xcbf29ce484222325ULL; /* FNV-1a */

typedef union { uint32_t u; float f; } fbits;

static inline float u2f(uint32_t u) { fbits x; x.u = u; return x.f; }
static inline uint32_t f2u(float f) { fbits x; x.f = f; return x.u; }

void asm_reset_stats(void) {
  asm_pixel_count = 0;
  asm_pixel_hash = 0xcbf29ce484222325ULL;
}

void asm_pixel_hash_fn(uint32_t y, uint32_t x, uint32_t c) {
  ++asm_pixel_count;
  asm_pixel_hash ^= y; asm_pixel_hash *= 1099511628211ULL;
  asm_pixel_hash ^= x; asm_pixel_hash *= 1099511628211ULL;
  asm_pixel_hash ^= c; asm_pixel_hash *= 1099511628211ULL;
}

void do_MOVi(int d, uint32_t imm) { REG_FILE[d] = imm; }
void do_ADD(int d, int a, int b) { REG_FILE[d] = REG_FILE[a] + REG_FILE[b]; }
void do_ADDi(int d, int a, uint32_t imm) { REG_FILE[d] = REG_FILE[a] + imm; }
void do_SUB(int d, int a, int b) { REG_FILE[d] = REG_FILE[a] - REG_FILE[b]; }
void do_SUBi(int d, int a, uint32_t imm) { REG_FILE[d] = REG_FILE[a] - imm; }
void do_MUL(int d, int a, int b) { REG_FILE[d] = REG_FILE[a] * REG_FILE[b]; }
void do_MULi(int d, int a, uint32_t imm) { REG_FILE[d] = REG_FILE[a] * imm; }
void do_SHL(int d, int a, uint32_t imm) { REG_FILE[d] = REG_FILE[a] << imm; }
void do_SHR(int d, int a, uint32_t imm) { REG_FILE[d] = REG_FILE[a] >> imm; }
void do_AND(int d, int a, int b) { REG_FILE[d] = REG_FILE[a] & REG_FILE[b]; }
void do_ANDi(int d, int a, uint32_t imm) { REG_FILE[d] = REG_FILE[a] & imm; }
void do_OR(int d, int a, int b) { REG_FILE[d] = REG_FILE[a] | REG_FILE[b]; }
void do_ORi(int d, int a, uint32_t imm) { REG_FILE[d] = REG_FILE[a] | imm; }
void do_XOR(int d, int a, int b) { REG_FILE[d] = REG_FILE[a] ^ REG_FILE[b]; }

void do_LD(int d, int a) { REG_FILE[d] = DS[REG_FILE[a] >> 2]; }
void do_ST(int a, int b) { DS[REG_FILE[a] >> 2] = REG_FILE[b]; }

void do_FADD(int d, int a, int b) { REG_FILE[d] = f2u(u2f(REG_FILE[a]) + u2f(REG_FILE[b])); }
void do_FSUB(int d, int a, int b) { REG_FILE[d] = f2u(u2f(REG_FILE[a]) - u2f(REG_FILE[b])); }
void do_FMUL(int d, int a, int b) { REG_FILE[d] = f2u(u2f(REG_FILE[a]) * u2f(REG_FILE[b])); }
void do_FMULi(int d, int a, uint32_t imm) { REG_FILE[d] = f2u(u2f(REG_FILE[a]) * u2f(imm)); }
void do_FMULADD(int d, int a, int b, int c) {
  REG_FILE[d] = f2u(u2f(REG_FILE[a]) * u2f(REG_FILE[b]) + u2f(REG_FILE[c]));
}
void do_FTCI(int d, int a) { REG_FILE[d] = (uint32_t)(int32_t)u2f(REG_FILE[a]); }

void do_CMPEQi(int d, int a, uint32_t imm) { REG_FILE[d] = REG_FILE[a] == imm; }
void do_CMPGEi(int d, int a, uint32_t imm) { REG_FILE[d] = (int32_t)REG_FILE[a] >= (int32_t)imm; }
void do_CMPLTi(int d, int a, uint32_t imm) { REG_FILE[d] = (int32_t)REG_FILE[a] < (int32_t)imm; }
void do_FCMPLTi(int d, int a, uint32_t imm) { REG_FILE[d] = u2f(REG_FILE[a]) < u2f(imm); }

void do_PUT_PIXEL(int y, int x, int c) {
  uint32_t py = REG_FILE[y], px = REG_FILE[x], pc = REG_FILE[c];
  simPutPixel(py, px, pc);
  asm_pixel_hash_fn(py, px, pc);
}

void do_FLUSH(void) { simFlush(); }

void asm_sim_finish(void) {
  SDL_Event ev;
  memset(&ev, 0, sizeof ev);
  ev.type = SDL_QUIT;
  SDL_PushEvent(&ev);
  simExit();
}
