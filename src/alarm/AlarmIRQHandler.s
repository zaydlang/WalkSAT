.ifndef AlarmIRQHandler
.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global AlarmIRQHandler
.type   AlarmIRQHandler, STT_FUNC

.include "../src/alarm/alarm_fired.s"

@------------------------------------------------------------------------------
@ void AlarmIRQHandler(void)
@------------------------------------------------------------------------------
@ Description: An IRQ Handler that fires when the alarm goes off. It will set
@              alarm_fired to true.
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

AlarmIRQHandler:
    ldr r0, =REG_TMxCNT
    mov r1, #0
    str r1, [r0, #2]

    ldr r0, =alarm_fired
    mov r1, #1
    str r1, [r0]

    ldr r0, =REG_IF
    ldrh r1, [r0]
    strh r1, [r0]

    bx lr

.size AlarmIRQHandler, .-AlarmIRQHandler
.endif
