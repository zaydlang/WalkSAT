.section .iwram,"ax",%progbits

;------------------------------------------------------------------------------
; struct State {
;     bool variables[256] : u8
;     size_t num_variables : u32
; }
;------------------------------------------------------------------------------
; Description: Represents a 3SAT state
;------------------------------------------------------------------------------

.macro StateGetVarValue this, result, index
    ldrb result, [this, index]
.endm

.macro StateSetVarValue this, value, index
    strb result, [this, index]
.endm

.macro StateGetNumVariables this, result
    ldr result, [this, #256]
.endm

.macro StateSetNumVariables this, value
    str result, [this, #256]
.endm

;------------------------------------------------------------------------------
; void StateInit(State *this, size_t num_variables)
;------------------------------------------------------------------------------
; Description: Generates a state with randomly assigned varaibles
;------------------------------------------------------------------------------
; Parameters:
; r0 = this
; r1 = The number of variables
;------------------------------------------------------------------------------
; Returns:
; None.
;------------------------------------------------------------------------------

StateInit:
    push {r4, lr}

    ; Save this
    mov r4, r0

    mov r2, #0
    StateInit_SetVarLoop:
        mov r0, #2
        bl GetRandomNumberRanged
        StateSetVarValue r4, r0

        add r2, #1
        cmp r2, r1
        bne StateInit_SetVarLoop

    StateSetNumVariables r4, r1

    pop {r4, pc}
