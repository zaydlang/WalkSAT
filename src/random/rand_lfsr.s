.ifndef rand_lfsr
.cpu arm7tdmi
.section .iwram, "ax", %progbits
.arm
.align 2
.global rand_lfsr
.type   rand_lfsr, STT_OBJECT

@------------------------------------------------------------------------------
@ private u32 lfsr;
@------------------------------------------------------------------------------
@ Description: The linear feedback shift register used for randomness:
@ https://stackoverflow.com/questions/7602919/how-do-i-generate-random-numbers-without-rand-function
@------------------------------------------------------------------------------

rand_lfsr:
    .space 4

.size rand_lfsr, .-rand_lfsr
.endif
