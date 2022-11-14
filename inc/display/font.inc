.ifndef __FONT_INC__
__FONT_INC__:

@ these fonts are virtually the same
HEX_FONT:
DEC_FONT:
    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b00011100
    .byte 0b00000100
    .byte 0b00000100
    .byte 0b00000100
    .byte 0b00000100
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000000

@ yes, HEX_FONT overflows into TEXT_FONT. now i dont have to copy paste
@ characters A-F.

TEXT_FONT:
    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01011110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00000100
    .byte 0b00000100
    .byte 0b01000100
    .byte 0b01000100
    .byte 0b01111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000110
    .byte 0b01011000
    .byte 0b01100000
    .byte 0b01100000
    .byte 0b01011000
    .byte 0b01000110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01100110
    .byte 0b01011010
    .byte 0b01001010
    .byte 0b01001010
    .byte 0b01001010
    .byte 0b01001010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01100010
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01001010
    .byte 0b01001010
    .byte 0b01000110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b00111100
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b00111100
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000010
    .byte 0b01111100
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b01000000
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b00111100
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01001010
    .byte 0b01000100
    .byte 0b00111010
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111100
    .byte 0b01000010
    .byte 0b01111100
    .byte 0b01100000
    .byte 0b01011000
    .byte 0b01000110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b01000000
    .byte 0b01111110
    .byte 0b00000010
    .byte 0b00000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01111110
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00001000
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b01111110
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01000010
    .byte 0b01000010
    .byte 0b00100100
    .byte 0b00100100
    .byte 0b00100100
    .byte 0b00011000
    .byte 0b00000000

    .byte 0b00000000
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01010010
    .byte 0b01111110
    .byte 0b00000000

@ im probably not going to use x-z so i won't make them

.endif
