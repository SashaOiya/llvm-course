9# Задание 2: инструментирующий Pass — трасса (User <- Operand)

## Как собрать и запустить

```sh
make trace-pass-lib             # собрать Pass2_trace/libTracePass.so
make app-trace-opt app-trace-os # инструментированные приложения (-O2 и -Os)
make trace-ir                   # инструментированный IR для просмотра (IR/app-*-tr.ll)

make trace-run TRACE_SECONDS=6  # запустить на 6 с, собрать обе трассы
make trace-report TRACE_LIMIT=20000000   # анализ первых 20M событий

# вручную (окно откроется, если есть дисплей):
TRACE_FILE=Pass2_trace/traces/trace_opt.bin ./build/app-trace-opt
# завершить: Ctrl+C (SIGINT) или kill -TERM — буфер будет сброшен
```

## Результаты (-O2)

За 6 с собрано **422M событий** (71 Mev/s), 138 инструкций в `app()`.
Анализ: 20M событий, 0 неизвестных id.

Топ user-инструкций (доля от всех событий):

| opcode | доля |
|--------|------|
| getelementptr | 30.70% |
| fadd | 15.32% |
| load | 12.76% |
| call (т.ч. llvm.fmuladd) | 10.23% |
| add | 7.74% |
| icmp / br / store / and | по ~5.2% |
| trunc | 2.59% |
