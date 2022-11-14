.ifndef DrawHex

.include "../inc/display/font.inc"
.include "../inc/util/mmio.inc"
.include "../inc/util/swi.inc"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DrawHex
.type   DrawHex, STT_FUNC

@------------------------------------------------------------------------------
@ void DrawHex(u32 hex, u32 x, u32 y, u8 color)
@------------------------------------------------------------------------------
@ Description: Draws a hex number to screen
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = the hex number to display
@ r1 = x position to start at
@ r2 = y position to start at
@ r3 = the color to use
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

DrawHex:
    push {r0 - r12, lr}
    ldr r5, =HEX_FONT

    ldr r9, =#0x06000000
    ldr r4, =#240
    mla r1, r4, r2, r1
    add r9, r1
    
    mov r2, #0x8
    DrawHex_Number:
        and r4, r0, #0xF0000000
        lsr r4, #28

        mov r10, #0x8
        lsl r6, r4, #0x3
        add r6, r5

        DrawHex_NibbleLoop:
            ldrb r7, [r6], #0x1

            mov r11, #0x8
            DrawHex_Row:
                eor r12, r12

                ands r8, r7, #0x1
                lsr r7, #0x1

                orrne r12, r3, lsl #0x8

                ands r8, r7, #0x1
                lsr r7, #0x1

                orrne r12, r3

                strh r12, [r9, r11]

                subs r11, #0x2
                bne DrawHex_Row
            
            add r9, #240
            subs r10, #0x1
            bne DrawHex_NibbleLoop
        
        ldr r10, =#1912
        sub r9, r10
        lsl r0, #0x4
        subs r2, #0x1
        bne DrawHex_Number
    
    pop {r0 - r12, pc}

.size DrawHex, .-DrawHex
.endif
