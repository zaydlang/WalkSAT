.ifndef  __CLAUSE_INC__
__CLAUSE_INC__:

@------------------------------------------------------------------------------
@ struct Clause {
@     VariableId vars[3] : u8@
@     bool negations[3]  : u8@
@ }
@------------------------------------------------------------------------------
@ Description: Represents a clause in 3SAT
@------------------------------------------------------------------------------

.macro ClauseGetVarId this, result, index
    ldrb \result, [\this, \index]
.endm

.macro ClauseSetVarId this, value, index
    strb \value, [\this, \index]
.endm

.macro ClauseGetVarNegation this, result, index
    add \index, #3
    ldrb \result, [\this, \index]
    sub \index, #3
.endm

.macro ClauseSetVarNegation this, value, index
    add \index, #3
    strb \value, [\this, \index]
    sub \index, #3
.endm

.equ CLAUSE_SIZE, 6

.endif
