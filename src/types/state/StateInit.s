.ifndef StateInit

.include "../inc/types/state.inc"
.include "../src/random/GetRandomNumberRanged.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global StateInit
.type   StateInit, STT_FUNC

@------------------------------------------------------------------------------
@ void StateInit(State *this, size_t num_variables)
@------------------------------------------------------------------------------
@ Description: Generates a state with randomly assigned varaibles
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = this
@ r1 = The number of variables
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

StateInit:
    push {r4, lr}

    @ Save this
    mov r4, r0

    mov r2, #0
    StateInit_SetVarLoop:
        mov r0, #2

        push {r1, r2}
        bl GetRandomNumberRanged
        pop {r1, r2}

        StateSetVarValue r4, r0, r2

        add r2, #1
        cmp r2, r1
        bne StateInit_SetVarLoop

    StateSetNumVariables r4, r1

    pop {r4, pc}

.size StateInit, .-StateInit
.endif
