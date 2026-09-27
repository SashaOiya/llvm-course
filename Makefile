all: app app-opt app-os

start.ll: start.c
	clang -emit-llvm -S $^
sim.ll: sim.c
	clang -emit-llvm -S $^
app.ll: app.c
	clang -emit-llvm -S $^
full.bc: start.ll sim.ll app.ll
	llvm-link $^ -o full.bc

app-opt.ll: app.c
	clang -emit-llvm -S $^ -o $@ -O2

app-os.ll: app.c
	clang -emit-llvm -S $^ -o $@ -Os

SDL2_CFLAGS := $(shell pkg-config --cflags sdl2 2>/dev/null)
SDL2_LIBS := $(shell pkg-config --libs sdl2 2>/dev/null)

app: app.ll start.c sim.c
	clang $^ $(SDL2_CFLAGS) $(SDL2_LIBS) -o $@
app-opt: app-opt.ll start.c sim.c
	clang $^ $(SDL2_CFLAGS) $(SDL2_LIBS) -o $@ -O2

LLVM_FLAGS = $(shell llvm-config --cppflags --ldflags --libs)

ir_gen: sim.c IRGen/app_ir_gen.cpp
	clang++ $(LLVM_FLAGS) $^ -lSDL2 -o $@

asm2ir: sim.c IRGen/app_asm_IRgen_1.cpp
	clang++ $(LLVM_FLAGS) $^ -lSDL2 -o $@

asm2fullir: sim.c IRGen/app_asm_IRgen_2.cpp
	clang++ $(LLVM_FLAGS) $^ -lSDL2 -o $@

clean:
	rm -f app app-opt *.ll full.bc ir_gen asm2ir asm2fullir

.PHONY: all clean
