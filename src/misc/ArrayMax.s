.ifndef ArrayMax

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global ArrayMax
.type   ArrayMax, STT_FUNC

@------------------------------------------------------------------------------
@ u32 ArrayMax(u32 *array, size_t length)
@------------------------------------------------------------------------------
@ Description: Returns the maximum element of the array.
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = Pointer to the array
@ r1 = The length of the array
@------------------------------------------------------------------------------
@ Returns:
@ The length of the array
@------------------------------------------------------------------------------

ArrayMax:
    mov r2, #0

    ArrayMax_Loop:
        ldr r3, [r0, r1, lsl #2]
        cmp r3, r2
        movgt r2, r3
        subs r1, #1
        bne ArrayMax_Loop
    
    mov r0, r2
    bx lr

.size ArrayMax, .-ArrayMax
.endif
