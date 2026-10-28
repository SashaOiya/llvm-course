BUILD_DIR = build
IR_DIR = IR

all: app app-opt app-os

$(BUILD_DIR) $(IR_DIR):
	mkdir -p $@

$(IR_DIR)/%.ll: %.c | $(IR_DIR)
	clang -emit-llvm -S $< -o $@

$(IR_DIR)/app-opt.ll: app.c | $(IR_DIR)
	clang -emit-llvm -S $< -o $@ -O2

$(IR_DIR)/app-os.ll: app.c | $(IR_DIR)
	clang -emit-llvm -S $< -o $@ -Os

full.bc: $(IR_DIR)/start.ll $(IR_DIR)/sim.ll $(IR_DIR)/app.ll
	@command -v llvm-link >/dev/null || { echo "llvm-link not found: install package 'llvm'"; exit 1; }
	llvm-link $^ -o $@

OPT_opt = -O2
OPT_os = -Os

$(BUILD_DIR)/app: $(IR_DIR)/app.ll start.c sim.c | $(BUILD_DIR)
	clang $^ -lSDL2 -o $@

$(BUILD_DIR)/app-%: $(IR_DIR)/app-%.ll start.c sim.c | $(BUILD_DIR)
	clang $^ -lSDL2 -o $@ $(OPT_$*)

app: $(BUILD_DIR)/app
app-opt: $(BUILD_DIR)/app-opt
app-os: $(BUILD_DIR)/app-os

clean:
	rm -rf $(BUILD_DIR) $(IR_DIR) full.bc

.PHONY: all clean app app-opt app-os

# ============================================================================
# Задание 2: инструментирующий Pass, трасса (User <- Operand), паттерны 1..5
# ============================================================================

TRACE_DIR = Pass2_trace
PASS_LIB = $(TRACE_DIR)/libTracePass.so
TRACE_MAP_DIR = $(TRACE_DIR)/maps
TRACE_DATA_DIR = $(TRACE_DIR)/traces
TRACE_REPORT_DIR = $(TRACE_DIR)/reports
TRACE_LIMIT ?= 20000000
TRACE_SECONDS ?= 8
LLVM_CONFIG ?= llvm-config-18

$(TRACE_MAP_DIR) $(TRACE_DATA_DIR) $(TRACE_REPORT_DIR):
	mkdir -p $@

$(PASS_LIB): $(TRACE_DIR)/TracePass.cpp
	clang++ $(shell $(LLVM_CONFIG) --cxxflags) -fPIC -shared $< -o $@

trace-pass-lib: $(PASS_LIB)

# сборка инструментированного приложения: Pass применяется к оптимизированному
# IR (-O2/-Os) в конце пайплайна, но только к модулю app.c
build/app-trace-opt: $(PASS_LIB) app.c sim.c start.c $(TRACE_DIR)/trace.c | $(TRACE_MAP_DIR) $(BUILD_DIR)
	TRACE_MAP=$(TRACE_MAP_DIR)/trace_map_opt.txt clang -O2 -fpass-plugin=$(PASS_LIB) app.c sim.c start.c $(TRACE_DIR)/trace.c -lSDL2 -o $@

build/app-trace-os: $(PASS_LIB) app.c sim.c start.c $(TRACE_DIR)/trace.c | $(TRACE_MAP_DIR) $(BUILD_DIR)
	TRACE_MAP=$(TRACE_MAP_DIR)/trace_map_os.txt clang -Os -fpass-plugin=$(PASS_LIB) app.c sim.c start.c $(TRACE_DIR)/trace.c -lSDL2 -o $@

app-trace-opt: build/app-trace-opt
app-trace-os: build/app-trace-os

# инструментированный IR для просмотра
IR/app-opt-tr.ll: $(PASS_LIB) app.c | $(IR_DIR) $(TRACE_MAP_DIR)
	TRACE_MAP=$(TRACE_MAP_DIR)/trace_map_opt.txt clang -O2 -fpass-plugin=$(PASS_LIB) -emit-llvm -S app.c -o $@

IR/app-os-tr.ll: $(PASS_LIB) app.c | $(IR_DIR) $(TRACE_MAP_DIR)
	TRACE_MAP=$(TRACE_MAP_DIR)/trace_map_os.txt clang -Os -fpass-plugin=$(PASS_LIB) -emit-llvm -S app.c -o $@

trace-ir: IR/app-opt-tr.ll IR/app-os-tr.ll

FORCE:

$(TRACE_DATA_DIR)/trace_opt.bin: build/app-trace-opt FORCE
	$(TRACE_DIR)/run_trace.sh build/app-trace-opt $@ $(TRACE_SECONDS)

$(TRACE_DATA_DIR)/trace_os.bin: build/app-trace-os FORCE
	$(TRACE_DIR)/run_trace.sh build/app-trace-os $@ $(TRACE_SECONDS)

trace-run: $(TRACE_DATA_DIR)/trace_opt.bin $(TRACE_DATA_DIR)/trace_os.bin

$(TRACE_REPORT_DIR)/report_opt.txt: $(TRACE_DATA_DIR)/trace_opt.bin $(TRACE_MAP_DIR)/trace_map_opt.txt $(TRACE_DIR)/analyze.py
	python3 $(TRACE_DIR)/analyze.py --map $(TRACE_MAP_DIR)/trace_map_opt.txt --trace $< --limit $(TRACE_LIMIT) --top 20 > $@
	@echo "report: $@"

$(TRACE_REPORT_DIR)/report_os.txt: $(TRACE_DATA_DIR)/trace_os.bin $(TRACE_MAP_DIR)/trace_map_os.txt $(TRACE_DIR)/analyze.py
	python3 $(TRACE_DIR)/analyze.py --map $(TRACE_MAP_DIR)/trace_map_os.txt --trace $< --limit $(TRACE_LIMIT) --top 20 > $@
	@echo "report: $@"

trace-report: $(TRACE_REPORT_DIR)/report_opt.txt $(TRACE_REPORT_DIR)/report_os.txt

trace-clean:
	rm -rf $(TRACE_MAP_DIR) $(TRACE_DATA_DIR) $(TRACE_REPORT_DIR)

.PHONY: trace-pass-lib app-trace-opt app-trace-os trace-ir trace-run trace-report trace-clean

# ============================================================================
# Задание 3: IR-генератор логического модуля + интерпретация в ExecutionEngine
# ============================================================================

IRGEN_DIR = IRGen
IRGEN_BIN = $(IRGEN_DIR)/app_ir_gen
IRGEN_OBJ = $(BUILD_DIR)/sim_irgen.o
IRGEN_FLAGS ?= -DFRAMES=1

$(IRGEN_OBJ): sim.c sim.h | $(BUILD_DIR)
	$(CC) -c $< -o $@

$(IRGEN_BIN): $(IRGEN_DIR)/app_ir_gen.cpp $(IRGEN_OBJ)
	$(CXX) $(shell $(LLVM_CONFIG) --cxxflags) $(IRGEN_FLAGS) $(IRGEN_DIR)/app_ir_gen.cpp $(IRGEN_OBJ) -lSDL2 -o $@ -Wl,--export-dynamic $(shell $(LLVM_CONFIG) --ldflags --libs --system-libs)

irgen: $(IRGEN_BIN)

# с окном: закрыть вручную (или IRGEN_AUTOQUIT=1)
irgen-run: irgen
	./$(IRGEN_BIN)

# headless: dummy-видео + автозакрытие окна
irgen-run-dummy: irgen
	SDL_VIDEODRIVER=dummy IRGEN_AUTOQUIT=1 ./$(IRGEN_BIN)

.PHONY: irgen irgen-run irgen-run-dummy
