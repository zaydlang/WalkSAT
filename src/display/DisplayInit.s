.ifndef DisplayInit

.include "../inc/util/mmio.inc"
.include "../inc/util/swi.inc"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DisplayInit
.type   DisplayInit, STT_FUNC

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
    ldr r1, =0x0404 @ REG_DISPCNT Mode 4 (Bitmap) + BG2 ENABLE
    str r1, [r0]
    
    # load address of palette ram
    ldr r0, =#0x05000000

    add r0, #4

    # green and red
    ldr r1, =#0x4FEC319F
    str r1, [r0], #4

    # gold
    ldr r1, =0x0000035F
    str r1, [r0], #4

    # white and black
    ldr r1, =#0x00007FFF
    strh r1, [r0], #4

    pop {r4}
    bx lr

.size DisplayInit, .-DisplayInit
.endif
