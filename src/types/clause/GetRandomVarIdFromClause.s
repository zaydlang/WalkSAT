.ifndef GetRandomVarIdFromClause

.include "../inc/types/clause.inc"
.include "../inc/types/state.inc"
.include "../inc/types/variable.inc"
.include "../src/random/GetRandomNumberRanged.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global GetRandomVarIdFromClause
.type   GetRandomVarIdFromClause, STT_FUNC

@------------------------------------------------------------------------------
@ VariableId GetRandomVarIdFromClause()
@------------------------------------------------------------------------------
@ Description: Returns a random variable id that this Clause uses
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = this
@------------------------------------------------------------------------------
@ Returns:
@ r0 = The random variable id
@------------------------------------------------------------------------------

GetRandomVarIdFromClause:
    push {r4, lr}

    @ preserve the value of this
    mov r4, r0

    mov r0, #3
    bl GetRandomNumberRanged

    ClauseGetVarId r4, r0, r0

    pop {r4, pc}
    bx lr

.size GetRandomVarIdFromClause, .-GetRandomVarIdFromClause
.endif
