.ifndef GetRandomNumberRanged

.include "../src/random/GetRandomNumber.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global GetRandomNumberRanged
.type   GetRandomNumberRanged, STT_FUNC

@------------------------------------------------------------------------------
@ void GetRandomNumberRanged()
@------------------------------------------------------------------------------
@ Description: Returns a random number from 0 - <some user defined value>
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = The upper limit for the random number. Must be <= 65535.
@------------------------------------------------------------------------------
@ Returns:
@ r0 = A random number from 0 - <some user defined value>
@------------------------------------------------------------------------------

GetRandomNumberRanged:
    push {lr}

    push {r0}
    bl GetRandomNumber
    pop {r1}

    swi #0x60000 @ division
    mov r0, r1 @ the modulo result

    pop {pc}

.size GetRandomNumberRanged, .-GetRandomNumberRanged
.endif
