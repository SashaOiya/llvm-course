#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>

#define TRACE_EV_SIZE 16UL
#define TRACE_BUF_EV 131072UL
#define TRACE_FLUSH_EVERY (1UL << 20)

static int trace_fd = -1;
static uint64_t trace_buf[TRACE_BUF_EV][2];
static size_t trace_buf_len = 0;
static uint64_t trace_total = 0;
static struct timeval t0;
static int trace_init_done = 0;

static void trace_flush(void) {
  if (trace_fd < 0 || trace_buf_len == 0)
    return;
  const char *p = (const char *)trace_buf;
  size_t bytes = trace_buf_len * TRACE_EV_SIZE;
  while (bytes > 0) {
    ssize_t n = write(trace_fd, p, bytes);
    if (n < 0) {
      if (errno == EINTR)
        continue;
      return;
    }
    p += n;
    bytes -= (size_t)n;
  }
  trace_buf_len = 0;
}

static void trace_quit(int sig) {
  (void)sig;
  if (trace_init_done) {
    trace_flush();
    if (trace_fd >= 0)
      close(trace_fd);
    struct timeval t1;
    gettimeofday(&t1, NULL);
    double dt = (double)(t1.tv_sec - t0.tv_sec) +
                (double)(t1.tv_usec - t0.tv_usec) / 1e6;
    fprintf(stderr, "[trace] total events: %llu, time: %.2fs, rate: %.1f Mev/s\n",
            (unsigned long long)trace_total, dt,
            dt > 0 ? (double)trace_total / dt / 1e6 : 0.0);
  }
  _exit(0);
}

static void trace_init(void) {
  trace_init_done = 1;
  const char *path = getenv("TRACE_FILE");
  if (!path || !*path)
    path = "trace.bin";
  trace_fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
  if (trace_fd < 0) {
    fprintf(stderr, "[trace] cannot open '%s': %s\n", path, strerror(errno));
    exit(1);
  }
  unsigned char hdr[16] = "LLVMTR01";
  uint64_t ev_size = TRACE_EV_SIZE;
  memcpy(hdr + 8, &ev_size, 8);
  (void)write(trace_fd, hdr, 16);
  gettimeofday(&t0, NULL);
  signal(SIGINT, trace_quit);
  signal(SIGTERM, trace_quit);
  signal(SIGHUP, trace_quit);
}

__attribute__((noinline)) void traceLogger(uint64_t user_id,
                                           uint64_t operand_id) {
  if (!trace_init_done)
    trace_init();
  if (trace_buf_len == TRACE_BUF_EV)
    trace_flush();
  trace_buf[trace_buf_len][0] = user_id;
  trace_buf[trace_buf_len][1] = operand_id;
  trace_buf_len++;
  trace_total++;
  if ((trace_total & (TRACE_FLUSH_EVERY - 1)) == 0)
    trace_flush();
}
