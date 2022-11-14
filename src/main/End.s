.ifndef End

.include "../src/cpu/DisableInterrupts.s"
.include "../src/cpu/StopCPU.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global End
.type   End, STT_FUNC

@------------------------------------------------------------------------------
@ __attribute__((__noreturn__))
@ void End(void)
@------------------------------------------------------------------------------
@ Description: The end of the program. Shuts down execution. Does not return.
@------------------------------------------------------------------------------
@ Parameters:
@ None.
@------------------------------------------------------------------------------
@ Returns:
@ No return.
@------------------------------------------------------------------------------

End:
    bl DisableInterrupts
    bl StopCPU

    b End  @ Should never get here, but just in case, let's loop back to End

.size ArrayMedian, .-ArrayMedian
.endif
