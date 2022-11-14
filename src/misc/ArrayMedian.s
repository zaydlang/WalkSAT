.ifndef ArrayMedian

.include "../src/misc/BubbleSort.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global ArrayMedian
.type   ArrayMedian, STT_FUNC

@------------------------------------------------------------------------------
@ void ArrayMedian(u32 *array)
@------------------------------------------------------------------------------
@ Description: Calculates the median of the array with 50 elements in it
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = Pointer to the array
@ r1 = The length of the array
@------------------------------------------------------------------------------
@ Returns:
@ The median
@------------------------------------------------------------------------------

ArrayMedian:
    push {r4, lr}

    mov r4, r0
    bl BubbleSort
    
    lsr r1, #1
    ldr r0, [r4, r1, lsl #2]
    add r1, #1
    ldr r1, [r4, r1, lsl #2]
    add r0, r1 @ Take the average
    lsr r0, #1

    pop {r4, pc}

.size ArrayMedian, .-ArrayMedian
.endif
