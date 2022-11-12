.ifndef DisplayInit
.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DisplayInit
.type   DisplayInit, STT_FUNC

.include "../inc/util/mmio.inc"
.include "../inc/util/swi.inc"

@------------------------------------------------------------------------------
@ void DisplayInit(void)
@------------------------------------------------------------------------------
@ Description: Initializes the PPU registers for an empty bitmap
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

DisplayInit:
    push {r4}
    ldr r0, =REG_DISPCNT
    ldr r1, =0x0404 @ REG_DISPCNT Mode 3 (Bitmap) + BG2 ENABLE
    str r1, [r0]

    pop {r4}
    bx lr

.size DisplayInit, .-DisplayInit
.endif
