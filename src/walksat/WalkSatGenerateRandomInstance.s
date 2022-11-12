.ifndef WalkSatGenerateRandomInstance
.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global WalkSatGenerateRandomInstance
.type   WalkSatGenerateRandomInstance, STT_FUNC

.include "../inc/types/clause.inc"
.include "../src/types/clause/GenerateRandomClause.s"

@------------------------------------------------------------------------------
@ void WalkSatGenerateRandomInstance(Clause *clauses, u32 upper_bound,
@      u32 number_of_clauses)
@------------------------------------------------------------------------------
@ Description: Generates a random instance of WalkSAT
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = A pointer to a list of clauses to be randomly generated
@ r1 = The upper bound for variable ids. e.g. r0 = 20 would mean only variable
@      ids 0 - 19 inclusive get used
@ r2 = The number of clauses to randomly generate
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

WalkSatGenerateRandomInstance:
    push {r4, lr}

    mov r4, r2 @ put r1 into a callee saved register

    WalkSatGenerateRandomInstance_Loop:
        push {r0 - r2}
        bl GenerateRandomClause
        pop {r0 - r2}
        
        add r0, #CLAUSE_SIZE
        subs r4, #1
        bne WalkSatGenerateRandomInstance_Loop

    pop {r4, pc}

.size WalkSatGenerateRandomInstance, .-WalkSatGenerateRandomInstance
.endif
