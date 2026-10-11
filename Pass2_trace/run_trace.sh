#!/usr/bin/env bash
# run_trace.sh <binary> <out.bin> [seconds]
# Запускает приложение (SDL dummy-драйвер, если не задан другой),
# даёт поработать [seconds] секунд и завершает через SIGTERM,
# после чего логгер сбрасывает буфер и закрывает файл.
set -e
BIN=$1
OUT=$2
SECS=${3:-8}
SDL_VIDEODRIVER="${SDL_VIDEODRIVER:-dummy}" TRACE_FILE="$OUT" "$BIN" &
PID=$!
sleep "$SECS"
kill -TERM "$PID" 2>/dev/null || true
wait "$PID" 2>/dev/null || true
SIZE=$(stat -c %s "$OUT")
echo "[run_trace] $OUT: $SIZE bytes"
