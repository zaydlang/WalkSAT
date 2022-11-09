.section .iwram,"ax",%progbits

;------------------------------------------------------------------------------
; struct Clause {
;     VariableId vars[3] : u8;
;     bool negations[3]  : u8;
; }
;------------------------------------------------------------------------------
; Description: Represents a clause in 3SAT
;------------------------------------------------------------------------------

.macro ClauseGetVarId this, result, index
    ldrb result, [this, index]
.endm

.macro ClauseSetVarId this, value, index
    strb result, [this, index]
.endm

.macro ClauseGetVarNegation this, result, index
    add index, #3
    ldrb result, [this, index]
    sub index #3
.endm

.macro ClauseSetVarNegation this, value, index
    add index, #3
    strb result, [this, index]
    sub index #3
.endm

.define CLAUSE_SIZE 6

;------------------------------------------------------------------------------
; bool EvaluateClause(Clause *this, State *state)
;------------------------------------------------------------------------------
; Description: Evaluates a clause, returning true or false based on the
; clause's result
;------------------------------------------------------------------------------
; Parameters:
; r0 = A pointer to this
; r1 = A pointer to the Variable state to use for evaluating the Clause
;------------------------------------------------------------------------------
; Returns:
; r0 = 1 if the Clause passes, 0 otherwise.
;------------------------------------------------------------------------------

EvaluateClause:
    push {r4}

    mov r2, #0
    EvaluateClause_Loop:
        ClauseGetVarId r0, r3, r2
        StateGetVarValue r3, r3
        ClauseGetVarNegation r0, r4, r2

        ; If this variable's value matches its negation state, then we know that
        ; the whole expression will evaluate to true, so we can skip the rest of
        ; the evaluation and just return true for the whole function
        cmp r4, r3
        moveq r0, #1
        popeq {r4}
        bxeq lr

        add r2, #1
        cmp r2, #3
        bne EvaluateClause_Loop
    
    ; If we never broke out early, we know that every variable evaluated to false,
    ; and since we're orring all variables together, the clause also evaluated to
    ; false
    mov r0, #0
    pop {r4}
    bx lr

;------------------------------------------------------------------------------
; VariableId GetRandomVarIdFromClause()
;------------------------------------------------------------------------------
; Description: Returns a random variable id that this Clause uses
;------------------------------------------------------------------------------
; Parameters:
; r0 = this
;------------------------------------------------------------------------------
; Returns:
; r0 = The random variable id
;------------------------------------------------------------------------------

GetRandomVarIdFromClause:
    push {r4, lr}

    ; preserve the value of this
    mov r4, r0

    mov r0, #3
    bl GetRandomNumberRanged

    ClauseGetVarId r0, r0, r4

    pop {r4, pc}
    bx lr

;------------------------------------------------------------------------------
; void GenerateRandomClause(Clause this, u32 upper_bound)
;------------------------------------------------------------------------------
; Description: Generates a random clause that uses a random set of variables
;------------------------------------------------------------------------------
; Parameters:
; r0 = this
; r1 = The upper bound for variable ids. e.g. r0 = 20 would mean only variable
;      ids 0 - 19 inclusive get used
;------------------------------------------------------------------------------
; Returns:
; None.
;------------------------------------------------------------------------------

GenerateRandomClause:
    push {r4, lr}

    ; Save this
    mov r4, r0

    mov r2, #0
    GenerateRandomClause_VarIdLoop:
        mov r0, r1
        bl GetRandomNumberRanged
        ClauseSetVarId r4, r0, r2

        add r2, #1
        cmp r2, #3
        bne GenerateRandomClause_VarIdLoop

    mov r2, #0
    GenerateRandomClause_NegationLoop:
        mov r0, #2
        bl GetRandomNumberRanged
        ClauseSetVarNegation r4, r0, r2

        add r2, #1
        cmp r2, #3
        bne GenerateRandomClause_NegationLoop

    pop {r4, pc}