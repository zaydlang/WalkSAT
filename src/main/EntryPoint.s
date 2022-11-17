.ifndef EntryPoint

.include "../inc/savetype/sram.inc"
.include "../src/alarm/AlarmInit.s"
.include "../src/alarm/AlarmReset.s"
.include "../src/alarm/DidAlarmFire.s"
.include "../src/display/DisplayInit.s"
.include "../src/display/DrawHex.s"
.include "../src/display/DrawPoint.s"
.include "../src/graph/DrawGraph.s"
.include "../src/main/End.s"
.include "../src/misc/ArrayMedian.s"
.include "../src/misc/Memcpy8.s"
.include "../src/random/InitRandom.s"
.include "../src/types/state/StateInit.s"
.include "../src/walksat/WalkSatGenerateRandomInstance.s"
.include "../src/walksat/WalkSatIterateOnce.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global EntryPoint
.type   EntryPoint, STT_FUNC

@------------------------------------------------------------------------------
@ __attribute__((__noreturn__))
@ void EntryPoint(void)
@------------------------------------------------------------------------------
@ Description: The entrypoint of the program. Does not return.
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ No return.
@------------------------------------------------------------------------------

EntryPoint:
    mov r0, #0
    ldr r1, =#240
    mov r2, #0
    ldr r3, =#160
    bl DisplayInit

    bl AlarmInit

    ldr r0, =#0xACE1
    bl InitRandom

    mov r6, #20
    mov r7, #0x10
    mov r11, #0

    @ comment out to re-calculate the walksat
    b PlotResults

    WalkSatIterateOnce_NLoop:
        mov r4, #0
        mov r5, #0
        ldr r9, =#0x02002000
        mov r12, #0
        
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
                streq r8, [r9, r5, lsl #2]
                @ addeq r12, #4
                bne WalkSatIterateOnce_Loop
            WalkSatIterateOnce_LoopDone:

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
    
    mov r0, #0x0E000000
    ldr r1, =0x02003000
    mov r2, #0x1000
    bl Memcpy8
    
    ldr r0, =0x0E001000
    ldr r1, =0x02004000
    mov r2, #0x1000
    bl Memcpy8

    PlotResults:
        ldr r0, =0x02004000
        ldr r1, =0x0E001000
        mov r2, #0x1000
        bl Memcpy8

        ldr r0, =0x02004000
        mov r1, #0
        mov r2, #3
        mov r3, #6
        mov r4, #4
        bl DrawGraph

        ldr r0, =0x02004000
        ldr r1, =0x0E000000
        mov r2, #0x1000
        bl Memcpy8

        ldr r0, =0x02004000
        mov r1, #1
        mov r2, #2
        mov r3, #6
        mov r4, #4
        bl DrawGraph

    CycleGraphsLoop:
        ldr r0, =REG_KEYINPUT

        WaitForAReleasedLoop:
            ldrh r1, [r0]
            tst r1, #1
            beq WaitForAReleasedLoop
        WaitForAPressedLoop:
            ldrh r1, [r0]
            tst r1, #1
            bne WaitForAPressedLoop
        
        ldr r1, =REG_DISPCNT
        ldrh r2, [r1]
        eor r2, #16
        strh r2, [r1]

        b CycleGraphsLoop

    bl End

.size EntryPoint, .-EntryPoint
.endif
