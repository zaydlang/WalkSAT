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

    cmp r0, #0
    blt DrawPoint_Done
    cmp r0, #240
    bge DrawPoint_Done
    cmp r1, #0
    blt DrawPoint_Done
    cmp r1, #160
    bge DrawPoint_Done

    mov r4, #240
    mla r0, r4, r1, r0
    cmp r3, #1
    addeq r0, #0xA000
    ldr r3, =MEM_VRAM

    mov r1, #0xFF
    tst r0, #1
    lsleq r1, #8
    subne r0, #1
    lslne r2, #8

    ldrh r4, [r3, r0]
    and r4, r1
    orr r4, r2

    strh r4, [r3, r0]

DrawPoint_Done:
    pop {r4}
    bx lr

.size DrawPoint, .-DrawPoint
.endif
