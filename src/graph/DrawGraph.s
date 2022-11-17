.ifndef DrawGraph

.include "../inc/util/memory.inc"
.include "../src/display/DrawPoint.s"
.include "../src/graph/DrawGraphAxes.s"
.include "../src/misc/ArrayMax.s"

.cpu arm7tdmi
.section .iwram, "ax"
.arm
.align 2
.global DrawGraph
.type   DrawGraph, STT_FUNC

@------------------------------------------------------------------------------
@ void DrawGraph(void *graph_data, int page, int color_indes)
@------------------------------------------------------------------------------
@ Description: Draws the graph on a given page. The graph must have ten entries
@ in it, and the data must range from 0 to max. The format of graph_data is an
@ array of ten entries, each of which is a number from 0 to max.
@------------------------------------------------------------------------------
@ Parameters:
@ r0 = Pointer to the graph data
@ r1 = The page to draw on. Either 0 or 1.
@ r2 = The color index to use for the graph
@ r3 = The color index to use for the axes
@ r4 = The color index to use for the individual points
@------------------------------------------------------------------------------
@ Returns:
@ None
@------------------------------------------------------------------------------

DrawGraph:
    @ this is probably the most inefficient, most unreadable, messy function in
    @ the entire codebase... ugh

    push {r4 - r12, lr}

    ldr r5, =DrawGraph_spillage
    str r4, [r5]

    mov r10, r1

    push {r0 - r3}
    mov r0, r1
    mov r1, r3
    bl DrawGraphAxes
    pop {r0 - r3}

    push {r0 - r2}
    mov r1, #10
    bl ArrayMax
    mov r9, r0
    pop {r0 - r2}

    @ Load the base address of the graph into r4
    ldr r4, =MEM_VRAM
    mov r3, #0xA000
    mul r1, r3
    add r4, r1

    @ Save r0 and r2 into callee saved registers
    mov r5, r0
    mov r6, r2

    mov r7, #8
    DrawGraph_EntryLoop:
        ldr r1, [r5, r7, lsl #2]
        @ mov r0, #150
        @ mul r1, r0
        
        push {r0, r2, r3}
        @ mov r0, r1
        @ mov r1, r9
        @ swi #0x60000
        @ mov r1, #130
        @ sub r1, r0
        @ add r1, #15
        pop {r0, r2, r3}
        
        mov r0, r7
        mov r2, r6
        
        mov r8, #21
        mul r0, r8
        add r0, #15
        mov r8, #21

        add r11, r7, #1
        ldr r11, [r5, r11, lsl #2]
        sub r11, r1

        push {r7, r9}
        mov r7, r9
        mov r9, r0
        DrawGraph_RowLoop:
            push {r0}

            sub r12, r0, r9

            mul r12, r11, r12
            @ the stack hates me
            push {r0 - r3}
            mov r0, r12
            mov r1, #21
            swi #0x60000
            mov r12, r0
            pop {r0 - r3}
            push {r1}
            add r1, r12
            mov r3, r10
            push {r0 - r3}
                push {r0, r2, r3}
                mov r0, #130
                mul r1, r0
        
                mov r0, r1
                mov r1, r7
                swi #0x60000
                mov r1, #130
                sub r1, r0
                add r1, #15
                pop {r0, r2, r3}
            push {r0 - r3}
            bl DrawPoint
            pop {r0 - r3}
            cmp r8, #0
            bgt DrawGraph_StarDone

            DrawGraph_Star:
                ldr r2, =DrawGraph_spillage
                ldr r2, [r2]
                push {r0 - r3}
                bl DrawPoint
                pop {r0 - r3}
                add r0, #1
                push {r0 - r3}
                bl DrawPoint
                pop {r0 - r3}
                sub r0, #2
                push {r0 - r3}
                bl DrawPoint
                pop {r0 - r3}
                add r0, #1
                add r1, #1
                push {r0 - r3}
                bl DrawPoint
                pop {r0 - r3}
                sub r1, #2
                push {r0 - r3}
                bl DrawPoint
                pop {r0 - r3}
            DrawGraph_StarDone:

            pop {r0 - r3}
            pop {r1}
            pop {r0}

            add r0, #1
            subs r8, #1
            bge DrawGraph_RowLoop
        pop {r7, r9}

        subs r7, #1
        bge DrawGraph_EntryLoop
    
    pop {r4 - r12, pc}

DrawGraph_spillage:
.space 4

.size DrawGraph, .-DrawGraph
.endif
