.ifndef passing_clause_list
.cpu arm7tdmi
.section .iwram, "ax", %progbits
.arm
.align 2
.global passing_clause_list
.type   passing_clause_list, STT_OBJECT

@------------------------------------------------------------------------------
@ private bool passing_clause_list[256]
@------------------------------------------------------------------------------
@ Description: A helper variable to be used by the function WalkSatIterateOnce
@------------------------------------------------------------------------------

passing_clause_list:
.space 256

.size passing_clause_list, .-passing_clause_list
.endif
