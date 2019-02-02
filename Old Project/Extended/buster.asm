header : lorom

incsrc busterHeader.asm
incsrc ../parches/headers/mmxheader.asm

org !busterFreeSpace

db "ST","AR"			;
dw end-start-$01		;Rats tag que protegen tu data del LM
dw end-start-$01^$FFFF		

start:

	JML busterCode
	JML busterKill
	
;Callable Routines	
busterCode:

	PHB
	PHK
	PLB
	JSR main
	PLB

	RTL
	
busterKill:

	LDA !busterDirection,y
	AND #$03
	BNE +
	
	LDA !busterDirection,y
	AND #$40
	ORA #$01
	STA !busterDirection,y
	
	LDA #$00
	STA $173D,y
	STA $1747,y
	LDA #$04
	STA !busterFrameTimer,y
+
	RTL
	
;Internal Routines
main:
	JSR timer
	JSR graphics
	JSR grManager
.ret
	RTS

timer:
	LDA !busterFrameTimer,x
	BEQ +
	DEC A
	STA !busterFrameTimer,x
+
	RTS
	
grManager:
	LDA !busterDirection,x
	AND #$03
	BEQ +
	LDA !busterFrameTimer,x
	BNE +
	
	LDA !busterDirection,x
	AND #$03
	INC A 
	CMP #$04
	BCS .dead
	
	STA $00
	
	LDA !busterDirection,x
	AND #$40
	ORA $00
	STA !busterDirection,x
+
	RTS
.dead
	LDA !mmxBulletNum
	BEQ +
	DEC A
	STA !mmxBulletNum
	
+
	STZ $170B,x
	RTS
	
	
oam: db $38,$30,$34,$38,$30,$34,$38,$30,$34,$38
frame: db $72,$26,$28,$2A
size: db $00,$02,$02,$02
graphics:

	LDA $171F,x
	STA $00
	LDA $1733,x
	STA $01
	
	LDA $1715,x
	STA $02
	LDA $1729,x
	STA $03
	
	LDA !busterDirection,x
	AND #$03
	TAY
	LDA size,y
	STA $04
	JSL getDrawInfo200
	LDA $06
	BNE .dead

	LDA oam,x
	TAY
	
	LDA $00
	STA $0200,y
	LDA $02
	STA $0201,y
	
	LDA !busterDirection,x
	AND #$03
	PHY
	TAY
	LDA frame,y
	PLY
	STA $0202,y
	
	LDA !busterDirection,x
	AND #$40
	ORA #$2C
	STA $0203,y
	
	TYA
	LSR
	LSR	
	TAY
	LDA $04
	STA $0420,y
	
	RTS
.dead

	LDA !mmxBulletNum
	BEQ +
	DEC A
	STA !mmxBulletNum
	
+
	STZ $170B,x
	RTS
	
getDrawInfo200:
	PHY
	LDA $04
	STA $05
	STZ $06
	REP #$20
	
	LDA $00
	SEC
	SBC $1A
	STA $00
	
	CMP #$0100
	BCC ++
	
	CMP #$FFF1
	BCS +
	
	SEP #$20
	LDA #$01
	STA $06
	PLY
	RTL
+
	LDY $05
	INY
	STY $04
++
	LDA $02
	SEC
	SBC $1C
	STA $02
	
	CMP #$00F0
	BCS ++	

	CMP #$00E0
	BCS +
	SEP #$20
	PLY
	RTL
	
++
	CMP #$FFF1
	BCS ++
	
	SEP #$20
	LDA #$01
	STA $06
	PLY
	RTL
+
	LDY $05
	INY
	STY $04
++
	SEP #$20
	PLY
	RTL

end: