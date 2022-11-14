.ifndef AlarmReset

.include "../src/alarm/alarm_fired.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global AlarmReset
.type   AlarmReset, STT_FUNC

@------------------------------------------------------------------------------
@ void AlarmReset(void)
@------------------------------------------------------------------------------
@ Description: Resets the alarm. The alarm will fire in 10 seconds.
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

AlarmReset:
    ldr r0, =alarm_fired
    mov r1, #0
    str r1, [r0]

    ldr r0, =REG_TMxCNT
    ldr r1, =0x83C000
    str r1, [r0], #4

    ldr r1, =0xC4FFF6
    str r1, [r0]

    bx lr

.size AlarmReset, .-AlarmReset
.endif
