.ifndef InitRandom

.include "../src/random/rand_lfsr.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global InitRandom
.type   InitRandom, STT_FUNC

@------------------------------------------------------------------------------
@ void InitRandom()
@------------------------------------------------------------------------------
@ Description: Initializes the LFSR with a seed. 
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = RNG seed
@------------------------------------------------------------------------------
@ Returns:
@ Nothing.
@------------------------------------------------------------------------------

InitRandom:
    ldr r1, =rand_lfsr
    str r0, [r1]

    bx lr

.size InitRandom, .-InitRandom
.endif
