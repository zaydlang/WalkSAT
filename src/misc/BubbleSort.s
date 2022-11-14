.ifndef BubbleSort

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global BubbleSort
.type   BubbleSort, STT_FUNC

@------------------------------------------------------------------------------
@ void BubbleSort(u32 *array)
@------------------------------------------------------------------------------
@ Description: Sorts an array that has 50 elements in it
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = Pointer to the array
@------------------------------------------------------------------------------
@ Returns:
@ None
@------------------------------------------------------------------------------

BubbleSort:
    push {r4, r5}

    @ Since I've been writing awful assembly for the past few hours, the last thing
    @ I want to do is implement (and debug) a proper sorting algorithm in assembly.
    @ So instead I will do bubble sort.

    mov r1, #0 @ the iteration variable for BubbleSort_OuterLoop

    BubbleSort_OuterLoop:
        mov r2, #0 @ the iteration variable for BubbleSort_InnerLoop

        BubbleSort_InnerLoop:
            ldr r3, [r0, r2, lsl #2]
            add r4, r2, #1
            ldr r5, [r0, r4, lsl #2]
            cmp r3, r5
            strle r3, [r0, r4, lsl #2]
            strle r5, [r0, r2, lsl #2]

            add r2, #1
            add r3, r2, r1
            cmp r3, #50
            bne BubbleSort_InnerLoop

        add r1, #1
        cmp r1, #50
        bne BubbleSort_OuterLoop    
    
    pop {r4, r5}
    bx lr

.size BubbleSort, .-BubbleSort
.endif
