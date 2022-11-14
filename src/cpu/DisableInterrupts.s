.ifndef DisableInterrupts

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DisableInterrupts
.type   DisableInterrupts, STT_FUNC

@------------------------------------------------------------------------------
@ void DisableInterrupts()
@------------------------------------------------------------------------------
@ Description: Disables CPU interrupts
@------------------------------------------------------------------------------
@ Parameters:
@ None
@------------------------------------------------------------------------------
@ Returns:
@ Nothing.
@------------------------------------------------------------------------------

DisableInterrupts:
    mrs r0, cpsr
    orr r0, #128
    msr cpsr, r0
    bx lr

.size DisableInterrupts, .-DisableInterrupts
.endif
