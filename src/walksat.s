.section .iwram,"ax",%progbits

;------------------------------------------------------------------------------
; private bool passing_clause_list[256];
;------------------------------------------------------------------------------
; Description: A helper variable to be used by the function WalkSatIterateOnce
;------------------------------------------------------------------------------
passing_clause_list:
.space 256

;------------------------------------------------------------------------------
; void WalkSatIterateOnce(Clause *clauses, int number_of_clauses, State *state)
;------------------------------------------------------------------------------
; Description: Runs WalkSAT once on the list of clauses, and updates state 
;              by flipping a random variable from a random failing clause.
;------------------------------------------------------------------------------
; Parameters:
; r0 = A pointer to a list of clauses
; r1 = The number of clauses in the above list
; r2 = A pointer to the variable state to modify
;------------------------------------------------------------------------------
; Returns:
; None.
;------------------------------------------------------------------------------

WalkSatIterateOnce:
    push {r4 - r8, lr}

    ; r3 = Number of passing clauses we have found so far
    ; r4 = Address of clause we are operating on
    ; r5 = Address of clause after the last clause we operate on.
    ; r6 = Address in passing_clause_list that we are writing the result to
    ; r7 = Saving r1 for later
    ; r8 = Saving r2 for later
    mov r3, #0
    mov r4, r0
    mla r5, r0, r1, CLAUSE_SIZE
    mov r6, =passing_clause_list
    mov r7, r1
    mov r8, r2

    WalkSatIterateOnce_ClauseEvaluationLoop:
        mov r0, r4
        mov r1, r2
        bl EvaluateClause

        str r0, [r6], #1
        add r3, r0

        add r4, CLAUSE_SIZE
        cmp r4, r5
        bne WalkSatIterateOnce_ClauseEvaluationLoop

    ; Get the number of failing clauses, and generate a random number
    sub r1, r7, r3
    mov r0, r1
    bl GetRandomNumber

    ; Use that random number to select a random failing clause by
    ; iterating through passing_clause_list till we find the failing
    ; clause we selected.

    mov r2, =passing_clause_list
    WalkSatIterateOnce_FindRandomFailingClauseLoop:
        ldr r0, [r2], #1

        cmp r0, #0
        subseq r1, #1
        bne WalkSatIterateOnce_FindRandomFailingClauseLoop

    ; r0 now contains the index of the failing clause we wish to modify.
    ; All that's left is to modify the variable state.
    bl GetRandomVarIdFromClause
    VariableStateGetVariable r8, r1, r0
    VariableGetVal r1, 

    pop {r4 - r8, pc}