#!/usr/bin/env python3
"""Анализ трассы использования IR-инструкций (User <- Operand).

Вход:
  --map   статическая карта (id -> opcode), пишется Pass'ом (TRACE_MAP)
  --trace бинарная трасса: пары (uint64 user_id, uint64 operand_id)
Алгоритм:
  1. Каждое событие трассы превращается в символ "<user_opcode><-<operand_opcode>"
     (или только user_opcode при --user-only).
  2. По потоку символов считаются все частые паттерны (n-граммы) для длин
     окна 1..5 с пересекающимися окнами.
  3. Выдаётся отчёт: топ паттернов каждой длины с количеством, долей
     и накопленным покрытием топ-10.
"""
import argparse
import collections
import struct
import sys

MAGIC = b"LLVMTR01"


def load_map(path):
    ids = {}
    with open(path, encoding="utf-8", errors="replace") as f:
        for ln in f:
            ln = ln.rstrip("\n")
            if not ln or ln.startswith("#"):
                continue
            parts = ln.split("\t")
            if len(parts) < 5:
                continue
            ids[int(parts[0])] = {
                "is_phi": parts[1] == "1",
                "opcode": parts[2],
                "func": parts[3],
                "print": parts[4],
            }
    return ids


def read_events(path, limit=0, step=1):
    rec = struct.Struct("<QQ")
    n = 0
    with open(path, "rb") as f:
        if f.read(8) != MAGIC:
            sys.exit(f"[analyze] bad magic in {path}")
        (evs,) = struct.unpack("<Q", f.read(8))
        if evs != 16:
            sys.exit(f"[analyze] unexpected event size {evs}")
        while True:
            chunk = f.read(rec.size * 65536)
            if not chunk:
                break
            for i in range(len(chunk) // rec.size):
                u, o = rec.unpack_from(chunk, i * rec.size)
                n += 1
                if step <= 1 or (n - 1) % step == 0:
                    yield u, o
                if limit and n >= limit:
                    return


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--map", default="trace_map.txt")
    ap.add_argument("--trace", default="trace.bin")
    ap.add_argument("--limit", type=int, default=0,
                    help="анализировать не более N событий (0 = все)")
    ap.add_argument("--step", type=int, default=1,
                    help="брать каждое step-е событие (сэмплирование)")
    ap.add_argument("--top", type=int, default=20)
    ap.add_argument("--user-only", action="store_true",
                    help="символ = только opcode пользователя")
    ap.add_argument("--window", type=int, default=5, choices=range(1, 6),
                    help="максимальная длина окна (1..5)")
    args = ap.parse_args()

    ids = load_map(args.map)
    n = args.window
    counter = [collections.Counter() for _ in range(n + 1)]
    example = [dict() for _ in range(n + 1)]
    users = collections.Counter()
    deq = collections.deque(maxlen=n)
    total = 0
    unknown = 0

    for u, o in read_events(args.trace, args.limit, args.step):
        ui, oi = ids.get(u), ids.get(o)
        if ui is None or oi is None:
            unknown += 1
            continue
        uop, oop = ui["opcode"], oi["opcode"]
        sym = uop if args.user_only else f"{uop}<-{oop}"
        users[uop] += 1
        deq.append(sym)
        L = len(deq)
        for k in range(1, L + 1):
            key = tuple(deq)[L - k:]
            counter[k][key] += 1
            if key not in example[k]:
                example[k][key] = (ui, oi)
        total += 1
        if total % 5000000 == 0:
            print(f"  ... processed {total} events", file=sys.stderr)

    out = sys.stdout
    out.write("=== Отчёт: частые паттерны использования IR-инструкций ===\n")
    out.write(f"map:   {args.map}\n")
    out.write(f"trace: {args.trace}\n")
    out.write(f"limit: {args.limit or 'all'}  step: {args.step}  "
              f"символ: {'user opcode' if args.user_only else 'user<-operand opcode'}\n")
    out.write(f"всего событий: {total}, неизвестных id: {unknown}, "
              f"разных user-opcode: {len(users)}\n\n")

    out.write("-- Топ исполнявшихся user-инструкций (динамически, n=1 без операнда) --\n")
    for op, cnt in users.most_common(10):
        out.write(f"   {op:12s} {cnt:12d}  {100.0 * cnt / max(total, 1):6.2f}%\n")
    out.write("\n")

    for k in range(1, n + 1):
        wins = max(total - k + 1, 0)
        top = counter[k].most_common(args.top)
        cov = sum(c for _, c in counter[k].most_common(10))
        prec = 100.0 * cov / max(wins, 1)
        out.write(f"--- Паттерны длины окна {k} "
                  f"(всего окон: {wins}, разных паттернов: {len(counter[k])}) ---\n")
        if wins == 0:
            out.write("   (нет данных)\n\n")
            continue
        cum = 0.0
        for i, (pat, cnt) in enumerate(top, 1):
            pct = 100.0 * cnt / wins
            cum += pct
            pat_s = "  ".join(pat) if k > 1 else pat[0]
            out.write(f"  #{i:<3d} {pat_s:<32s} {cnt:12d}  {pct:6.3f}%  "
                      f"cum(top-{min(args.top, len(top))}): {cum:6.3f}%\n")
            if k == 1:
                ui, _oi = example[k][pat]
                out.write(f"         пример: {ui['print']}\n")
        out.write(f"   топ-10 покрывает {prec:.2f}% всех окон\n\n")


if __name__ == "__main__":
    main()
