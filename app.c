#include "sim.h"
#include <stdint.h>

#define WIDTH 256
#define HEIGHT 256
#define SUB_STEPS 8

void app(void) {
  static float u[HEIGHT][WIDTH];
  static float next_u[HEIGHT][WIDTH];

  int32_t y = 0;
  int32_t x = 0;
  int32_t step = 0;

  for (y = 0; y < HEIGHT; ++y) {
    for (x = 0; x < WIDTH; ++x) {
      u[y][x] = 0.0f;
      next_u[y][x] = 0.0f;
    }
  }

  for (y = HEIGHT / 2 - 12; y < HEIGHT / 2 + 12; ++y) {
    for (x = WIDTH / 2 - 12; x < WIDTH / 2 + 12; ++x) {
      u[y][x] = 100.0f;
      next_u[y][x] = 100.0f;
    }
  }

  while (1) {
    for (step = 0; step < SUB_STEPS; ++step) {
      for (y = 1; y < HEIGHT - 1; ++y) {
        for (x = 1; x < WIDTH - 1; ++x) {
          if (y >= HEIGHT / 2 - 12 && y < HEIGHT / 2 + 12 &&
              x >= WIDTH / 2 - 12 && x < WIDTH / 2 + 12) {
            next_u[y][x] = 100.0f;
          } else {
            float alpha = 0.22f;
            next_u[y][x] =
                u[y][x] + alpha * (u[y + 1][x] + u[y - 1][x] + u[y][x + 1] +
                                   u[y][x - 1] - 4.0f * u[y][x]);
          }
        }
      }

      for (y = 1; y < HEIGHT - 1; ++y) {
        for (x = 1; x < WIDTH - 1; ++x) {
          u[y][x] = next_u[y][x];
        }
      }
    }

    for (y = 0; y < HEIGHT; ++y) {
      for (x = 0; x < WIDTH; ++x) {
        float norm = u[y][x] / 100.0f;
        if (norm < 0.0f)
          norm = 0.0f;
        if (norm > 1.0f)
          norm = 1.0f;

        int32_t r = 0;
        int32_t g = 0;
        int32_t b = 0;

        if (norm < 0.5f) {
          r = (int32_t)(norm * 2.0f * 255.0f);
          g = 0;
          b = (int32_t)((0.5f - norm) * 2.0f * 255.0f);
        } else {
          r = 255;
          g = (int32_t)((norm - 0.5f) * 2.0f * 255.0f);
          b = 0;
        }

        uint32_t argb = (0xFFU << 24) | ((uint32_t)r << 16) |
                        ((uint32_t)g << 8) | (uint32_t)b;
        simPutPixel(y, x, argb);
      }
    }

    simFlush();
  }
}
