.section .ewram,"ax",%progbits

;------------------------------------------------------------------------------
; private u32 graph_low_x_coordinate;
; private u32 graph_high_x_coordinate;
; private u32 graph_low_y_coordinate;
; private u32 graph_high_y_coordinate;
;------------------------------------------------------------------------------
; Description: Variables that dictate what portion of the graph is displayed
;              on screen.
;------------------------------------------------------------------------------

graph_low_x_coordinate:
    .space 4
graph_high_x_coordinate:
    .space 4
graph_low_y_coordinate:
    .space 4
graph_high_y_coordinate:
    .space 4



;------------------------------------------------------------------------------
; void VideoGraphInit(u32 low_x_coordinate, u32 high_x_coordinate,
;                     u32 low_y_coordinate, u32 high_y_coordinate)
;------------------------------------------------------------------------------
; Description: Initializes the PPU registers to display an empty graph to
;              the screen.
;------------------------------------------------------------------------------
; Parameters:
; r0 = The low x coordinate
; r1 = The high x coordinate
; r2 = The low y coordinate
; r3 = The high y coordinate
;------------------------------------------------------------------------------
; Returns:
; None.
;------------------------------------------------------------------------------

VideoGraphInit:
    push {r4}

    ldr r4, =graph_low_x_coordinate
    stmia r4, {r0 - r3}

    ldr r0, =DISPCNT
    ldr r1, =0x0404 ; DISPCNT Mode 4 (Bitmap) + BG2 ENABLE
    str r1, [r0]

    pop {r4}
    bx lr



;------------------------------------------------------------------------------
; void SetColor(u16 index, u16 color)
;------------------------------------------------------------------------------
; Description: Sets the specified color index in PRAM to the given color
;------------------------------------------------------------------------------
; Parameters:
; r0 = The index in PRAM
; r1 = The color to set it to
;------------------------------------------------------------------------------
; Returns:
; None.
;------------------------------------------------------------------------------

SetColor:
    ldr r2, =MEM_PRAM
    add r1, r1
    strh r1, [r2, r0]

    bx lr



;------------------------------------------------------------------------------
; void PlotPoint(u32 x, u32 y, u16 index)
;------------------------------------------------------------------------------
; Description: Sets the specified color index in PRAM to the given color
;------------------------------------------------------------------------------
; Parameters:
; r0 = x
; r1 = y
; r2 = The index in PRAM to use as the color
;------------------------------------------------------------------------------
; Returns:
; None.
;------------------------------------------------------------------------------

PlotPoint:
    push {r4 - r10, lr}

    ldr r4, =graph_low_x_coordinate
    ldmia r4, {r4 - r7}

    mov r10, r2
    
    sub r0, r4, r0
    sub r1, r5, r1
    sub r2, r6, r4
    sub r3, r7, r5
    mul r0, r2
    mul r1, r3

    push {r0 - r3}
    mov r1, #240
    swi SWI_DIV
    mov r8, r0
    pop {r0 - r3}

    push {r0 - r3}
    mov r0, r1
    mov r1, #160
    swi SWI_DIV
    mov r9, r0
    pop {r0 - r3}

    cmp r8, #0
    blt PlotPoint_End
    cmp r8, #240
    bge PlotPoint_End
    cmp r9, #0
    blt PlotPoint_End
    cmp r9, #160
    bge PlotPoint_End

    mov r1, #240
    mla r0, r9, r1, r8

    ldr r1, =MEM_VRAM
    str r10, [r1, r0]

    PlotPoint_End:
        pop {r4 - r10, pc}