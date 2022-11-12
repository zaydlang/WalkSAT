.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global main
.type   main, STT_FUNC

.include "../src/alarm/AlarmInit.s"
.include "../src/alarm/AlarmReset.s"
.include "../src/alarm/DidAlarmFire.s"
.include "../src/cpu/DisableInterrupts.s"
.include "../src/cpu/StopCPU.s"
.include "../src/display/DisplayInit.s"
.include "../src/display/DrawPoint.s"
.include "../src/misc/ArrayMedian.s"
.include "../src/random/InitRandom.s"
.include "../src/types/state/StateInit.s"
.include "../src/walksat/WalkSatGenerateRandomInstance.s"
.include "../src/walksat/WalkSatIterateOnce.s"

main:
    ldr r0, =EntryPoint
    bx r0

.section .iwram,"ax",%progbits

.byte 0x53
.byte 0x52
.byte 0x41
.byte 0x4d
.byte 0x5f
.byte 0x56
.byte 0x31
.byte 0x32
.byte 0x33
.byte 0x00
.space 2

EntryPoint:
    mov r0, #0
    ldr r1, =#240
    mov r2, #0
    ldr r3, =#160
    bl DisplayInit

    bl AlarmInit

    ldr r0, =#0xACE1
    bl InitRandom

    # load address of palette ram
    ldr r0, =#0x05000000

    # white and black
    ldr r1, =#0x00007FFF
    strh r1, [r0], #4

    # green and red
    ldr r1, =#0x4FEC319F
    str r1, [r0], #4

    # gray
    ldr r1, =0x00005294
    str r1, [r0], #4

    mov r6, #20
    mov r7, #0x10
    mov r11, #0

    WalkSatIterateOnce_NLoop:
        mov r4, #0
        mov r5, #0
        ldr r9, =#0x02002000
        
        WalkSatIterateOnce_FiftyLoop:
            ldr r0, =#0x02001000
            mov r1, #20
            bl StateInit

            @ sue me
            ldr r0, =#0x02000100
            mov r1, #20
            mov r2, r6
            bl WalkSatGenerateRandomInstance

            bl AlarmReset
            mov r8, #0
            WalkSatIterateOnce_Loop:
        
                mov r0, r4
                mov r1, #0x10
                mov r2, #0x0
                mov r3, #1
                bl DrawHex

                bl DidAlarmFire
                cmp r0, #1
                beq WalkSatIterateOnce_LoopDone
                ldr r0, =#0x02000100
                mov r1, r6
                ldr r2, =#0x02001000
                bl WalkSatIterateOnce
                cmp r0, #1
                addeq r5, #1
                add r8, #1
                bne WalkSatIterateOnce_Loop
            WalkSatIterateOnce_LoopDone:

            str r8, [r9, r4, lsl #2]

            add r4, #1
            cmp r4, #50
            blt WalkSatIterateOnce_FiftyLoop
        
        mov r0, r9
        mov r1, r5
        bl ArrayMedian
        ldr r8, =#0x02003000
        str r0, [r8, r11]
        ldr r8, =#0x02004000
        str r5, [r8, r11]
    
        mov r0, r5
        mov r1, #0x10
        mov r2, r7
        mov r3, #2
        bl DrawHex
        
        add r7, #8
        add r6, #20
        add r11, #4
        cmp r6, #200
        ble WalkSatIterateOnce_NLoop
    
    ldr r0, =0x02003000
    mov r1, #0x0E000000
    mov r3, #0x1000

    MemcpyLoop:
        ldrb r2, [r0], #1
        strb r2, [r1], #1
        sub r3, #1
        cmp r3, #0
        bne MemcpyLoop
    
    ldr r0, =0x02004000
    ldr r1, =0x0E001000
    mov r3, #0x1000

    MemcpyLoop2ElectricBoogaloo:
        ldrb r2, [r0], #1
        strb r2, [r1], #1
        sub r3, #1
        cmp r3, #0
        bne MemcpyLoop2ElectricBoogaloo

    bl End



@------------------------------------------------------------------------------
@ void End()
@------------------------------------------------------------------------------
@ Description: Stops the program, this is non-recoverable
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ No return.
@------------------------------------------------------------------------------

End:
    bl DisableInterrupts
    bl StopCPU
    b End  @ Should never get here, but just in case....




DrawDec:
    push {r0-r12, lr}

    @ hex font is same as dec font tbh
    ldr r5, =DEC_FONT

    add r1, #64
    ldr r9, =#0x06000000
    ldr r4, =#240
    mla r1, r4, r2, r1
    add r9, r1
    
    mov r2, #0x8
    DrawDec_Number:

        @ and r4, r0, #0xF0000000
        @ lsr r4, #28

        @ mov r10, #0x8
        @ lsl r6, r4, #0x3
        @ add r6, r5


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
    
    pop {r0-r12, pc}



# NAME:       DrawHex()
# PARAMETERS: r0 - hex number to display
#             r1 - x position to start at
#             r2 - y position to start at
#             r3 - the color to use (byte)
# RETURNS:    none. draws the hex number to screen

DrawHex:
    push {r0-r12, lr}
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
    
    pop {r0-r12, pc}


@ these fonts are virtually the same
HEX_FONT:
DEC_FONT:
    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b00011100
    .byte 0b00000100
    .byte 0b00000100
    .byte 0b00000100
    .byte 0b00000100
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000000

# yes, HEX_FONT overflows into TEXT_FONT. now i dont have to copy paste
# characters A-F.

TEXT_FONT:
    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01011110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00000100
    .byte 0b00000100
    .byte 0b01000100
    .byte 0b01000100
    .byte 0b01111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000110
    .byte 0b01011000
    .byte 0b01100000
    .byte 0b01100000
    .byte 0b01011000
    .byte 0b01000110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01100110
    .byte 0b01011010
    .byte 0b01001010
    .byte 0b01001010
    .byte 0b01001010
    .byte 0b01001010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01100010
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01001010
    .byte 0b01001010
    .byte 0b01000110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b00111100
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b00111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000010
    .byte 0b01111100
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b00111100
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01001010
    .byte 0b01000100
    .byte 0b00111010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000010
    .byte 0b01111100
    .byte 0b01100000
    .byte 0b01011000
    .byte 0b01000110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b00100100
    .byte 0b00100100
    .byte 0b00100100
    .byte 0b00011000
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01111110
    .byte 0b00000000

# im probably not going to use x-z so i won't make them