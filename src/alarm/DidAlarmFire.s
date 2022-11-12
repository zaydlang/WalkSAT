.ifndef DidAlarmFire
.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DidAlarmFire
.type   DidAlarmFire, STT_FUNC

@------------------------------------------------------------------------------
@ bool DidAlarmFire(void)
@------------------------------------------------------------------------------
@ Description: Returns whether or not the alarm has fired or not
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

DidAlarmFire:
    ldr r0, =alarm_fired
    ldr r0, [r0]
    bx lr

.size DidAlarmFire, .-DidAlarmFire
.endif
