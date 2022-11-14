.ifndef DrawGraphAxes

.include "../inc/util/memory.inc"
.include "../src/display/DrawPoint.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DrawGraphAxes
.type   DrawGraphAxes, STT_FUNC

@------------------------------------------------------------------------------
@ void DrawGraphAxes(int page, int color_indes)
@------------------------------------------------------------------------------
@ Description: Draws the graph axes on a given page.
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = The page to draw on. Either 0 or 1.
@ r1 = The color index to use for the axes
@------------------------------------------------------------------------------
@ Returns:
@ None
@------------------------------------------------------------------------------

DrawGraphAxes:
    push {r4 - r7, lr}

    mov r4, #14 @ x
    mov r5, #14 @ y
    mov r6, r1
    mov r7, r0

    DrawGraphAxes_YAxisLoop:
        mov r0, r4
        mov r1, r5
        mov r2, r6
        mov r3, r7
        bl DrawPoint

        add r5, #1
        cmp r5, #146
        ble DrawGraphAxes_YAxisLoop

    mov r4, #14 @ x
    mov r5, #146 @ y
    mov r6, r1

    DrawGraphAxes_XAxisLoop:
        mov r0, r4
        mov r1, r5
        mov r2, r6
        mov r3, r7
        bl DrawPoint

        add r4, #1
        cmp r4, #226
        ble DrawGraphAxes_XAxisLoop

    pop {r4 - r7, pc}

.size DrawGraphAxes, .-DrawGraphAxes
.endif
