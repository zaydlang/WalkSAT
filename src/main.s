.include "../src/main/EntryPoint.s"

.cpu arm7tdmi
.section .rom, "ax"
.arm
.align 2
.global main
.type   main, STT_FUNC

.arm
main:
    @ We store the entrypoint in IWRAM. This is because this program is
    @ quite CPU intensive, and code in IWRAM will run the fastest.
    ldr r0, =EntryPoint
    bx r0

.size main, .-main
