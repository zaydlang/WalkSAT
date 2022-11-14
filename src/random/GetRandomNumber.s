.ifndef GetRandomNumber

.include "../src/random/rand_lfsr.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global GetRandomNumber
.type   GetRandomNumber, STT_FUNC

@------------------------------------------------------------------------------
@ void GetRandomNumber()
@------------------------------------------------------------------------------
@ Description: Returns a random number from 0 - 65535
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ r0 = A random number from 0 - 65535
@------------------------------------------------------------------------------

GetRandomNumber:
    push {r4}

    ldr r4, =rand_lfsr
    ldr r0, [r4]

    lsr r1, r0, #2
    lsr r2, r0, #3
    lsr r3, r0, #5
    eor r3, r0
    eor r2, r3
    eor r1, r2
    and r1, #1

    lsr r2, r0, #1
    lsl r1, #15
    orr r0, r1, r2

    str r0, [r4]

    pop {r4}
    bx lr

.size GetRandomNumber, .-GetRandomNumber
.endif
