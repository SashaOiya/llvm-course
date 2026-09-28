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
