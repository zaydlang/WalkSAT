.ifndef alarm_fired
.cpu arm7tdmi
.section .iwram, "ax", %progbits
.arm
.align 2
.global alarm_fired
.type   alarm_fired, STT_OBJECT

@------------------------------------------------------------------------------
@ private bool alarm_fired : u8@
@------------------------------------------------------------------------------
@ Description: Dictates whether or not the timer has fired yet or not
@------------------------------------------------------------------------------

alarm_fired:
.space 1

.space 3

.size alarm_fired, .-alarm_fired
.endif
