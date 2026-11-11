# Приложение "диффузия тепла" на собственном ISA (описание: IRGen/ISA.md)
# DS: u [0, 262144), next_u [262144, 524288); байтовые адреса.
# Регистры: x0/x1/x2 - индексы циклов, x3 - значение, x4 - 100.0f,
# x5..x9 - временные/условия, x10 - адрес, x11 - 0.5f, x12 - alpha, x13 - кадры.
entry
    MOVi  x4, 0x42C80000       # 100.0f (константа источника тепла)
    MOVi  x11, 0x3F000000      # 0.5f (цветовая граница)
    MOVi  x12, 0x3E6147AE      # alpha = 0.22f
    MOVi  x13, 8               # кадры = 8 (в апп.c - бесконечный цикл)
    MOVi  x0, 0                # addr = 0
    MOVi  x1, 0                # val = 0
    MOVi  x2, 524288           # end = размер DS
init_zero_loop
    CMPGEi x5, x0, x2          # addr >= end?
    BR_COND x5 init_square init_zero_body
init_zero_body
    ST x0, x1                  # *(u32*)(DS+addr) = 0
    ADDi x0, x0, 4
    BR init_zero_loop
init_square
    MOVi  x0, 116              # y = 116
    MOVi  x1, 116              # x = 116
init_square_y
    CMPGEi x5, x0, 140         # y >= 140?
    BR_COND x5 main_loop init_square_x
init_square_x
    CMPGEi x5, x1, 140         # x >= 140?
    BR_COND x5 init_square_next_y init_square_store
init_square_store
    SHL  x8, x0, 10            # y*1024
    SHL  x9, x1, 2             # x*4
    ADD  x10, x8, x9           # addr = y*1024 + x*4
    ST x10, x4                 # u[addr] = 100.0f
    ADDi x10, x10, 262144      # + next_u
    ST x10, x4                 # next_u[addr] = 100.0f
    ADDi x1, x1, 1             # x++
    BR init_square_x
init_square_next_y
    ADDi x0, x0, 1             # y++
    MOVi x1, 116
    BR init_square_y
main_loop
    CMPEQi x5, x13, 0          # кадры кончились?
    BR_COND x5 exit frames_left
frames_left
    MOVi x0, 0                 # step = 0
step_loop
    CMPGEi x5, x0, 8           # step >= 8?
    BR_COND x5 copy_loop step_body
step_body
    MOVi x1, 1                 # y = 1
step_y_loop
    CMPGEi x5, x1, 255         # y >= 255?
    BR_COND x5 step_next step_x_setup
step_x_setup
    MOVi x2, 1                 # x = 1
step_x_loop
    CMPGEi x5, x2, 255         # x >= 255?
    BR_COND x5 step_next_y step_cell
step_cell
    # in_square = (y>=116) & (y<140) & (x>=116) & (x<140)
    CMPGEi x5, x1, 116
    CMPLTi x6, x1, 140
    AND x5, x5, x6
    CMPGEi x6, x2, 116
    CMPLTi x7, x2, 140
    AND x6, x6, x7
    AND x5, x5, x6
    BR_COND x5 step_store100 step_diffuse
step_store100
    SHL  x8, x1, 10            # next_u[y][x] = 100.0f
    SHL  x9, x2, 2
    ADD  x10, x8, x9
    ADDi x10, x10, 262144
    ST x10, x4
    BR step_x_next
step_diffuse
    SHL  x8, x1, 10
    SHL  x9, x2, 2
    ADD  x10, x8, x9           # addr = &u[y][x]
    LD x3, x10                 # u[y][x]
    ADDi x8, x10, 1024         # y+1
    LD x5, x8
    SUBi x8, x10, 1024         # y-1
    LD x6, x8
    FADD x5, x5, x6
    ADDi x8, x10, 4            # x+1
    LD x6, x8
    FADD x5, x5, x6
    SUBi x8, x10, 4            # x-1
    LD x6, x8
    FADD x5, x5, x6            # sum = u[y+1]+u[y-1]+u[y][x+1]+u[y][x-1]
    FMULi x6, x3, 0x40800000   # 4.0f * u[y][x]
    FSUB x5, x5, x6            # lap = sum - 4*u
    FMULADD x5, x5, x12, x3    # next = alpha*lap + u[y][x]
    ADDi x10, x10, 262144      # + next_u
    ST x10, x5                 # next_u[addr] = next
step_x_next
    ADDi x2, x2, 1
    BR step_x_loop
step_next_y
    ADDi x1, x1, 1
    BR step_y_loop
step_next
    ADDi x0, x0, 1
    BR step_loop
copy_loop
    MOVi x0, 0                 # addr u
    MOVi x1, 262144            # addr next_u
copy_body
    CMPGEi x5, x0, 262144      # вся u скопирована?
    BR_COND x5 draw_loop copy_cell
copy_cell
    LD x3, x1                  # val = next_u[addr]
    ST x0, x3                  # u[addr] = val
    ADDi x0, x0, 4
    ADDi x1, x1, 4
    BR copy_body
draw_loop
    MOVi x0, 0                 # y = 0
draw_y_loop
    CMPGEi x5, x0, 256         # y >= 256?
    BR_COND x5 frame_next draw_x_setup
draw_x_setup
    MOVi x2, 0                 # x = 0
draw_x_loop
    CMPGEi x5, x2, 256         # x >= 256?
    BR_COND x5 draw_y_next draw_pixel
draw_pixel
    SHL  x8, x0, 10
    SHL  x9, x2, 2
    ADD  x10, x8, x9
    LD x3, x10                 # u = u[y][x]
    FMULi x3, x3, 0x3C23D70A   # norm = u * 0.01f  (= u/100)
    FCMPLTi x5, x3, 0x3F000000 # norm < 0.5f?
    BR_COND x5 color_lo color_hi
color_lo
    FMULi x6, x3, 0x40000000   # r = (int)(norm*2*255)
    FMULi x6, x6, 0x437F0000
    FTCI x6, x6
    FSUB x7, x11, x3           # b = (int)((0.5-norm)*2*255)
    FMULi x7, x7, 0x40000000
    FMULi x7, x7, 0x437F0000
    FTCI x7, x7
    MOVi x8, 0                 # g = 0
    BR draw_pack
color_hi
    MOVi x6, 255               # r = 255
    FSUB x7, x3, x11           # g = (int)((norm-0.5)*2*255)
    FMULi x7, x7, 0x40000000
    FMULi x7, x7, 0x437F0000
    FTCI x7, x7
    MOVi x8, 0                 # b = 0
draw_pack
    MOVi x9, 0xFF000000        # ARGB = 0xFF<<24 | r<<16 | g<<8 | b
    SHL x10, x6, 16
    OR x9, x9, x10
    SHL x10, x7, 8
    OR x9, x9, x10
    OR x9, x9, x8
    PUT_PIXEL x0, x2, x9       # simPutPixel(y, x, argb)
draw_x_next
    ADDi x2, x2, 1
    BR draw_x_loop
draw_y_next
    ADDi x0, x0, 1
    BR draw_y_loop
frame_next
    SUBi x13, x13, 1
    BR main_loop
exit
    EXIT
