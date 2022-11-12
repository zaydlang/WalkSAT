.ifndef __STATE_INC__
__STATE_INC__:

.section .iwram,"ax",%progbits

@------------------------------------------------------------------------------
@ struct State {
@     bool variables[256] : u8
@     size_t num_variables : u32
@ }
@------------------------------------------------------------------------------
@ Description: Represents a 3SAT state
@------------------------------------------------------------------------------

.macro StateGetVarValue this, result, index
    ldrb \result, [\this, \index]
.endm

.macro StateSetVarValue this, value, index
    strb \value, [\this, \index]
.endm

.macro StateGetNumVariables this, result
    ldr \result, [\this, #256]
.endm

.macro StateSetNumVariables this, value
    str \value, [\this, #256]
.endm

.endif
