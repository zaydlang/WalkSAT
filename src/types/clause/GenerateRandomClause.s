.ifndef GenerateRandomClause
.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global GenerateRandomClause
.type   GenerateRandomClause, STT_FUNC

.include "../inc/types/clause.inc"
.include "../inc/types/state.inc"
.include "../inc/types/variable.inc"
.include "../src/random/GetRandomNumberRanged.s"

@------------------------------------------------------------------------------
@ void GenerateRandomClause(Clause this, u32 upper_bound)
@------------------------------------------------------------------------------
@ Description: Generates a random clause that uses a random set of variables
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = this
@ r1 = The upper bound for variable ids. e.g. r0 = 20 would mean only variable
@      ids 0 - 19 inclusive get used
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

GenerateRandomClause:
    push {r4, lr}

    @ Save this
    mov r4, r0

    mov r2, #0
    GenerateRandomClause_VarIdLoop:
        mov r0, r1

        push {r1 - r2}
        bl GetRandomNumberRanged
        pop {r1 - r2}

        ClauseSetVarId r4, r0, r2

        add r2, #1
        cmp r2, #3
        bne GenerateRandomClause_VarIdLoop

    mov r2, #0
    GenerateRandomClause_NegationLoop:
        mov r0, #2

        push {r2}
        bl GetRandomNumberRanged
        pop {r2}

        ClauseSetVarNegation r4, r0, r2

        add r2, #1
        cmp r2, #3
        bne GenerateRandomClause_NegationLoop

    pop {r4, pc}

.size GenerateRandomClause, .-GenerateRandomClause
.endif
