#ifndef APP_ASM_COMMON_H
#define APP_ASM_COMMON_H
// Общий парсер прикладного ассемблера (описание: IRGen/ISA.md).
// Метки - отдельной строкой (один токен); регистры x0..x15;
// константы: десятичные или 0xHEX (в т.ч. биты float).
// Поток управления: BR L; BR_COND rc, Lt [, Lf] (Lf по умолчанию - следующая инструкция).
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <map>
#include <string>
#include <vector>

struct AsmProgram {
  enum Op : uint8_t {
    OP_MOVi, OP_ADD, OP_ADDi, OP_SUB, OP_SUBi, OP_MUL, OP_MULi,
    OP_SHL, OP_SHR, OP_AND, OP_ANDi, OP_OR, OP_ORi, OP_XOR,
    OP_LD, OP_ST,
    OP_FADD, OP_FSUB, OP_FMUL, OP_FMULi, OP_FMULADD, OP_FTCI,
    OP_CMPEQi, OP_CMPGEi, OP_CMPLTi, OP_FCMPLTi,
    OP_BR_COND, OP_BR, OP_PUT_PIXEL, OP_FLUSH, OP_EXIT
  };
  struct Instr {
    Op op;
    std::vector<std::string> toks; // исходные токены (для резолва меток)
    uint32_t ops[4];               // resolved: регистры/иммедиаты/индексы целей
    int n = 0;
    std::string text;
  };
  std::vector<Instr> instrs;
  std::map<std::string, uint32_t> labels; // метка -> индекс инструкции
  std::map<uint32_t, std::string> names;  // индекс -> имя метки

  static bool isCF(Op op) { return op == OP_BR_COND || op == OP_BR || op == OP_EXIT; }

  static bool parseReg(const std::string &t, uint32_t &idx) {
    if (t.size() >= 2 && (t[0] == 'x' || t[0] == 'X')) {
      char *end = nullptr;
      long v = strtol(t.c_str() + 1, &end, 10);
      if (end && *end == '\0' && v >= 0 && v < 16) { idx = (uint32_t)v; return true; }
    }
    return false;
  }

  static bool findOp(const std::string &t, Op &op) {
    struct { const char *n; Op o; } T[] = {
      {"MOVi", OP_MOVi}, {"ADD", OP_ADD}, {"ADDi", OP_ADDi}, {"SUB", OP_SUB},
      {"SUBi", OP_SUBi}, {"MUL", OP_MUL}, {"MULi", OP_MULi}, {"SHL", OP_SHL},
      {"SHR", OP_SHR}, {"AND", OP_AND}, {"ANDi", OP_ANDi}, {"OR", OP_OR},
      {"ORi", OP_ORi}, {"XOR", OP_XOR}, {"LD", OP_LD}, {"ST", OP_ST},
      {"FADD", OP_FADD}, {"FSUB", OP_FSUB}, {"FMUL", OP_FMUL}, {"FMULi", OP_FMULi},
      {"FMULADD", OP_FMULADD}, {"FTCI", OP_FTCI}, {"CMPEQi", OP_CMPEQi},
      {"CMPGEi", OP_CMPGEi}, {"CMPLTi", OP_CMPLTi}, {"FCMPLTi", OP_FCMPLTi},
      {"BR_COND", OP_BR_COND}, {"BR", OP_BR}, {"PUT_PIXEL", OP_PUT_PIXEL},
      {"FLUSH", OP_FLUSH}, {"EXIT", OP_EXIT}
    };
    for (auto &e : T) if (t == e.n) { op = e.o; return true; }
    return false;
  }

  static std::vector<std::string> split(const std::string &line) {
    std::vector<std::string> out;
    std::string cur;
    for (char ch : line) {
      if (ch == ' ' || ch == '\t' || ch == '\r' || ch == ',') {
        if (!cur.empty()) { out.push_back(cur); cur.clear(); }
      } else cur += ch;
    }
    if (!cur.empty()) out.push_back(cur);
    return out;
  }

  bool load(const char *path, std::string &err) {
    std::ifstream in(path);
    if (!in.is_open()) { err = std::string("can't open ") + path; return false; }
    Op op;
    std::string line;
    while (std::getline(in, line)) {
      size_t c = line.find('#');
      if (c != std::string::npos) line = line.substr(0, c);
      auto tk = split(line);
      if (tk.empty()) continue;
      if (tk.size() == 1 && !findOp(tk[0], op)) {
        if (labels.count(tk[0])) { err = "duplicate label " + tk[0]; return false; }
        labels[tk[0]] = (uint32_t)instrs.size();
        names[(uint32_t)instrs.size()] = tk[0];
        continue;
      }
      if (!findOp(tk[0], op)) { err = "unknown opcode '" + tk[0] + "'"; return false; }
      Instr I;
      I.op = op;
      I.text = line;
      I.toks = tk;
      instrs.push_back(I);
    }
    // резолв операндов
    for (auto &I : instrs) {
      if (I.op == OP_BR) {
        if (I.toks.size() != 2 || !labels.count(I.toks[1]))
          { err = "BR: need label: " + I.text; return false; }
        I.ops[I.n++] = labels[I.toks[1]];
        continue;
      }
      if (I.op == OP_BR_COND) {
        uint32_t r;
        if (I.toks.size() < 3 || I.toks.size() > 4 || !parseReg(I.toks[1], r) ||
            !labels.count(I.toks[2]))
          { err = "BR_COND: need reg + labels: " + I.text; return false; }
        I.ops[I.n++] = r;
        I.ops[I.n++] = labels[I.toks[2]];
        if (I.toks.size() == 4) {
          if (!labels.count(I.toks[3])) { err = "BR_COND: bad label: " + I.text; return false; }
          I.ops[I.n++] = labels[I.toks[3]];
        } else {
          I.ops[I.n++] = (uint32_t)((&I - instrs.data()) + 1); // fallthrough
        }
        continue;
      }
      for (size_t k = 1; k < I.toks.size(); ++k) {
        uint32_t v;
        if (parseReg(I.toks[k], v)) I.ops[I.n++] = v;
        else {
          char *end = nullptr;
          unsigned long long vv = strtoull(I.toks[k].c_str(), &end, 0);
          if (!end || *end != '\0') { err = "bad operand '" + I.toks[k] + "' in: " + I.text; return false; }
          I.ops[I.n++] = (uint32_t)vv;
        }
      }
    }
    return true;
  }

  std::string labelOf(uint32_t idx) const {
    auto it = names.find(idx);
    return it == names.end() ? ("bb" + std::to_string(idx)) : it->second;
  }
};
#endif
