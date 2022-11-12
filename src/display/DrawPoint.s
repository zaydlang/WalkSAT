.ifndef DisplayInit
.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DisplayInit
.type   DisplayInit, STT_FUNC

.include "../inc/util/memory.inc"

@------------------------------------------------------------------------------
@ void DrawPoint(u32 x, u32 y, u16 index)
@------------------------------------------------------------------------------
@ Description: Sets the specified color index in PRAM to the given color
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = x
@ r1 = y
@ r2 = The color to use
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

.arm
DrawPoint:
    mov r3, #240
    mla r0, r3, r1, r0
    ldr r3, =MEM_VRAM
    lsl r0, #1
    str r2, [r3, r0]

    bx lr

.size DrawPoint, .-DrawPoint
.endif
