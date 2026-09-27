#include <stdint.h>
#include "sim.h"

#define GRID_W 120
#define GRID_H 120
#define SCALE 3

// Непрерывный перевод значения температуры в ARGB-цвет (без switch-case)
static uint32_t thermal_color(float v) {
  if (v < 0.0f) {
    v = 0.0f;
  }
  if (v > 1.0f) {
    v = 1.0f;
  }

  int32_t r = (int32_t)(v * 255.0f);
  int32_t b = 255 - r;
  int32_t g = (r > 128) ? (510 - 2 * r) : (2 * r);

  if (g < 0) {
    g = 0;
  }
  if (g > 255) {
    g = 255;
  }

  return 0xFF000000u | ((uint32_t)r << 16) | ((uint32_t)g << 8) | (uint32_t)b;
}

void app(void) {
  float u[GRID_H][GRID_W];
  float next_u[GRID_H][GRID_W];

  int32_t y;
  int32_t x;
  int32_t dy;
  int32_t dx;
  int32_t sx;
  int32_t sy;
  int32_t vx;
  int32_t vy;

  for (y = 0; y < GRID_H; y = y + 1) {
    for (x = 0; x < GRID_W; x = x + 1) {
      u[y][x] = 0.0f;
      next_u[y][x] = 0.0f;
    }
  }

  sx = 30;
  sy = 90;
  vx = 2;
  vy = 1;

  while (1) {
    // Постоянная плита-источник тепла
    for (y = 44; y < 76; y = y + 1) {
      for (x = 44; x < 76; x = x + 1) {
        u[y][x] = 1.0f;
      }
    }

    // Движущийся точечный источник тепла, отражающийся от границ
    sx = sx + vx;
    sy = sy + vy;
    if (sx < 4) {
      sx = 4;
      vx = -vx;
    }
    if (sx > GRID_W - 5) {
      sx = GRID_W - 5;
      vx = -vx;
    }
    if (sy < 4) {
      sy = 4;
      vy = -vy;
    }
    if (sy > GRID_H - 5) {
      sy = GRID_H - 5;
      vy = -vy;
    }
    for (y = sy - 4; y <= sy + 4; y = y + 1) {
      for (x = sx - 4; x <= sx + 4; x = x + 1) {
        u[y][x] = 1.0f;
      }
    }

    // Постоянный сток-охладитель
    for (y = 102; y < 114; y = y + 1) {
      for (x = 102; x < 114; x = x + 1) {
        u[y][x] = 0.0f;
      }
    }

    // Шаг метода конечных разностей (дискретизация уравнения теплопроводности)
    for (y = 1; y < GRID_H - 1; y = y + 1) {
      for (x = 1; x < GRID_W - 1; x = x + 1) {
        next_u[y][x] =
            u[y][x] + 0.15f * (u[y - 1][x] + u[y + 1][x] + u[y][x - 1] +
                               u[y][x + 1] - 4.0f * u[y][x]);
      }
    }

    // Обновление состояния сетки с учётом рассеяния тепла
    for (y = 1; y < GRID_H - 1; y = y + 1) {
      for (x = 1; x < GRID_W - 1; x = x + 1) {
        u[y][x] = next_u[y][x] * 0.992f;
      }
    }

    // Отрисовка фрейма через интерфейс sim.h: ячейка -> SCALE x SCALE пикселей
    for (y = 0; y < GRID_H; y = y + 1) {
      for (x = 0; x < GRID_W; x = x + 1) {
        uint32_t c = thermal_color(u[y][x]);
        for (dy = 0; dy < SCALE; dy = dy + 1) {
          for (dx = 0; dx < SCALE; dx = dx + 1) {
            simPutPixel(x * SCALE + dx, y * SCALE + dy, (int)c);
          }
        }
      }
    }

    // Вывод готового фрейма на экран
    simFlush();
  }
}
