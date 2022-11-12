.ifndef __VARIABLE_INC__
__VARIABLE_INC__:

@------------------------------------------------------------------------------
@ struct Variable {
@     u8 val@
@ }
@------------------------------------------------------------------------------
@ Description: Represents a variable in a WalkSAT problem. Val is boolean.
@------------------------------------------------------------------------------

.macro VariableGetVal this, reg
    ldrb \reg, [\this, #1]
.endm

.macro VariableSetVal this, reg
    strb \reg, [\this, #1]
.endm

@------------------------------------------------------------------------------
@ struct VariableState {
@     Variable state[256]
@ }
@------------------------------------------------------------------------------
@ Description: Represents the current variable state in WalkSAT.  
@------------------------------------------------------------------------------

.macro VariableStateGetVariable this, reg, index
    ldrb \reg, [\this, \index]
.endm

.macro VariableStateSetVariable this, reg, index
    strb \reg, [\this, \index]
.endm

.endif
