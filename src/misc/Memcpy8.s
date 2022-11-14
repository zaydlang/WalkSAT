.ifndef Memcpy8

.include "../src/random/rand_lfsr.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global Memcpy8
.type   Memcpy8, STT_FUNC

@------------------------------------------------------------------------------
@ void Memcpy8(void* dst, void* src, size_t len)
@------------------------------------------------------------------------------
@ Description: Memcpys a chunk of data by bytes
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = The pointer to dst
@ r1 = The pointer to src
@ r2 = The length to memcpy
@------------------------------------------------------------------------------
@ Returns:
@ Nothing.
@------------------------------------------------------------------------------

Memcpy8:
    Memcpy8_Loop:
        ldrb r3, [r1, r2]
        strb r3, [r0, r2]

        subs r2, #1
        bne Memcpy8_Loop
    
    bx lr

.size Memcpy8, .-Memcpy8
.endif
