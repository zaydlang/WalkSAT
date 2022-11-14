.ifndef DrawPoint

.include "../inc/util/memory.inc"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DrawPoint
.type   DrawPoint, STT_FUNC

@------------------------------------------------------------------------------
@ void DrawPoint(u32 x, u32 y, u16 index, u32 page)
@------------------------------------------------------------------------------
@ Description: Draws a point with a given color on a given page
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = x
@ r1 = y
@ r2 = The color to use
@ r3 = The page to drawn on (0 or 1)
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

.arm
DrawPoint:
    push {r4}

    mov r4, #240
    mla r0, r4, r1, r0
    cmp r3, #1
    addeq r0, #0xA000
    ldr r3, =MEM_VRAM
    strb r2, [r3, r0]

    pop {r4}
    bx lr

.size DrawPoint, .-DrawPoint
.endif
