.ifndef DrawDec

.include "../inc/display/font.inc"
.include "../inc/util/mmio.inc"
.include "../inc/util/swi.inc"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DrawDec
.type   DrawDec, STT_FUNC

@------------------------------------------------------------------------------
@ void DrawDec(u32 hex, u32 x, u32 y, u8 color)
@------------------------------------------------------------------------------
@ Description: Draws a decimal number to screen
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = the decimal number to display
@ r1 = x position to start at
@ r2 = y position to start at
@ r3 = the color to use
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

DrawDec:
    push {r0 - r12, lr}

    @ hex font is same as dec font tbh
    ldr r5, =DEC_FONT

    add r1, #64
    ldr r9, =#0x06000000
    ldr r4, =#240
    mla r1, r4, r2, r1
    add r9, r1
    
    mov r2, #0x8
    DrawDec_Number:
        mov r1, #10

        push {r3}
        swi #0x60000
        pop {r3}
        
        lsl r6, r1, #0x3
        add r6, r5

        mov r10, #0x8
        DrawDec_NibbleLoop:
            ldrb r7, [r6], #0x1

            mov r11, #0x8
            DrawDec_Row:
                eor r12, r12

                ands r8, r7, #0x1
                lsr r7, #0x1

                orrne r12, r3, lsl #0x8

                ands r8, r7, #0x1
                lsr r7, #0x1

                orrne r12, r3

                strh r12, [r9, r11]

                subs r11, #0x2
                bne DrawDec_Row
            
            add r9, #240
            subs r10, #0x1
            bne DrawDec_NibbleLoop
        
        ldr r10, =#1928
        sub r9, r10
        subs r2, #0x1
        bne DrawDec_Number
    
    pop {r0 - r12, pc}

.size DrawDec, .-DrawDec
.endif
