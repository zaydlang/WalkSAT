.ifndef AlarmInit

.include "../inc/util/irq.inc"
.include "../src/alarm/AlarmIRQHandler.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global AlarmInit
.type   AlarmInit, STT_FUNC

@------------------------------------------------------------------------------
@ void AlarmInit(void)
@------------------------------------------------------------------------------
@ Description: Initializes the alarm.
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ None.
@------------------------------------------------------------------------------

AlarmInit:
    ldr r0, =AlarmIRQHandler
    ldr r1, =IRQ_VECTOR
    str r0, [r1]

    ldr r0, =REG_IME
    mov r1, #1
    str r1, [r0]

    ldr r0, =REG_IE
    mov r1, #0x10
    str r1, [r0]

    bx lr

.size AlarmInit, .-AlarmInit
.endif
