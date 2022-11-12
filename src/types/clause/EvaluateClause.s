.ifndef EvaluateClause
.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global EvaluateClause
.type   EvaluateClause, STT_FUNC

.include "../inc/types/clause.inc"
.include "../inc/types/state.inc"
.include "../inc/types/variable.inc"
.include "../src/random/GetRandomNumberRanged.s"

@------------------------------------------------------------------------------
@ bool EvaluateClause(Clause *this, State *state)
@------------------------------------------------------------------------------
@ Description: Evaluates a clause, returning true or false based on the
@ clause's result
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = A pointer to this
@ r1 = A pointer to the Variable state to use for evaluating the Clause
@------------------------------------------------------------------------------
@ Returns:
@ r0 = 1 if the Clause passes, 0 otherwise.
@------------------------------------------------------------------------------

EvaluateClause:
    push {r4}

    mov r2, #0
    EvaluateClause_Loop:
        ClauseGetVarId r0, r3, r2
        StateGetVarValue r1, r3, r3
        ClauseGetVarNegation r0, r4, r2

        @ If this variable's value matches its negation state, then we know that
        @ the whole expression will evaluate to true, so we can skip the rest of
        @ the evaluation and just return true for the whole function
        cmp r4, r3
        moveq r0, #1
        popeq {r4}
        bxeq lr

        add r2, #1
        cmp r2, #3
        bne EvaluateClause_Loop
    
    @ If we never broke out early, we know that every variable evaluated to false,
    @ and since we're orring all variables together, the clause also evaluated to
    @ false
    mov r0, #0
    pop {r4}
    bx lr

.size EvaluateClause, .-EvaluateClause
.endif
