.ifndef WalkSatIterateOnce
.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global WalkSatIterateOnce
.type   WalkSatIterateOnce, STT_FUNC

.include "../inc/types/variable.inc"
.include "../src/types/clause/EvaluateClause.s"
.include "../src/types/clause/GetRandomVarIdFromClause.s"
.include "../src/walksat/passing_clause_list.s"

@------------------------------------------------------------------------------
@ void WalkSatIterateOnce(Clause *clauses, int number_of_clauses, State *state)
@------------------------------------------------------------------------------
@ Description: Runs WalkSAT once on the list of clauses, and updates state 
@              by flipping a random variable from a random failing clause.
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = A pointer to a list of clauses
@ r1 = The number of clauses in the above list
@ r2 = A pointer to the variable state to modify
@------------------------------------------------------------------------------
@ Returns:
@ r0 = 1 if all clauses succeed, 0 otherwise
@------------------------------------------------------------------------------

WalkSatIterateOnce:
    push {r4 - r9, lr}

    @ r3 = Number of passing clauses we have found so far
    @ r4 = Address of clause we are operating on
    @ r5 = Address of clause after the last clause we operate on.
    @ r6 = Address in passing_clause_list that we are writing the result to
    @ r7 = Saving r1 for later
    @ r8 = Saving r2 for later
    mov r3, #0
    mov r4, r0
    mov r5, #CLAUSE_SIZE
    mla r5, r1, r5, r0
    ldr r6, =passing_clause_list
    mov r7, r1
    mov r8, r2
    mov r9, r0

    WalkSatIterateOnce_ClauseEvaluationLoop:
        mov r0, r4
        mov r1, r2

        push {r1 - r3}
        bl EvaluateClause
        pop {r1 - r3}

        strb r0, [r6], #1
        add r3, r0

        add r4, #CLAUSE_SIZE
        cmp r4, r5
        bne WalkSatIterateOnce_ClauseEvaluationLoop

    @ Get the number of failing clauses, and generate a random number
    subs r1, r7, r3
    moveq r0, #1
    popeq {r4 - r9, pc}
    mov r0, r1

    push {r1}
    bl GetRandomNumberRanged
    pop {r1}
    add r1, r0, #1

    @ Use that random number to select a random failing clause by
    @ iterating through passing_clause_list till we find the failing
    @ clause we selected.

    mov r3, #0
    ldr r2, =passing_clause_list
    WalkSatIterateOnce_FindRandomFailingClauseLoop:
        ldrb r0, [r2], #1

        cmp r0, #0
        subeqs r1, #1
        addne r3, #1
        bne WalkSatIterateOnce_FindRandomFailingClauseLoop

    @ r0 now contains the index of the failing clause we wish to modify.
    @ All that's left is to modify the variable state.

    push {r1}
    mov r2, #CLAUSE_SIZE
    mla r0, r3, r2, r9
    bl GetRandomVarIdFromClause
    pop {r1}
    
    VariableStateGetVariable r8, r1, r0
    eor r1, #1
    VariableStateSetVariable r8, r1, r0

    mov r0, #0
    pop {r4 - r9, pc}

.size WalkSatIterateOnce, .-WalkSatIterateOnce
.endif
