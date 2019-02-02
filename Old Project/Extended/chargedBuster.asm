header : lorom

incsrc chargedBusterHeader.asm
incsrc ../parches/headers/mmxheader.asm

org !chargedBusterFreeSpace

db "ST","AR"			;
dw end-start-$01		;Rats tag que protegen tu data del LM
dw end-start-$01^$FFFF		

start:

	JML chargedBusterCode
	JML chargedBusterKill
	
;Callable Routines	
chargedBusterCode:

	PHB
	PHK
	PLB
	JSR main
	PLB

	RTL
	
chargedBusterKill:

	LDA !chargedBusterDirection,y
	AND #$03
	CMP #$02
	BCS +
	
	LDA !chargedBusterDirection,y
	AND #$40
	ORA #$02
	STA !chargedBusterDirection,y
	
	LDA #$00
	STA $173D,y
	STA $1747,y
	
	LDA #$04
	STA !chargedBusterFrameTimer,y
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
	LDA !chargedBusterFrameTimer,x
	BEQ +
	DEC A
	STA !chargedBusterFrameTimer,x
+
	RTS
	
grManager:

	LDA !chargedBusterFrameTimer,x
	BNE .ret
	
	LDA #$04
	STA !chargedBusterFrameTimer,x
	
	LDA !chargedBusterDirection,x
	AND #$03
	CMP #$01
	BNE +
	
	LDA #$00
	BRA ++
+
	INC A 
	CMP #$04
	BCS .dead
++
	STA $00
	CMP #$03
	BNE +
	LDA #$08
	STA !chargedBusterFrameTimer,x
+
	
	LDA !chargedBusterDirection,x
	AND #$40
	ORA $00
	STA !chargedBusterDirection,x
.ret
	RTS
.dead
	LDA !mmxBulletNum
	BEQ +
	DEC A
	STA !mmxBulletNum
	
+
	STZ $170B,x
	RTS
	
	
frame: db $67,$69,$6B,$6D
graphics:

	LDA $171F,x
	STA $00
	LDA $1733,x
	STA $01
	
	LDA !chargedBusterDirection,x
	AND #$40
	LSR
	LSR
	LSR 
	LSR
	STA $0E
	LDA !chargedBusterDirection,x
	AND #$03
	ORA $0E
	ASL
	TAY
	
	REP #$20
	
	LDA $00
	CLC
	ADC .xAdder,y
	STA $00
	
	SEP #$20
	
	LDA $1715,x
	STA $02
	LDA $1729,x
	STA $03
	
	LDA #$02
	STA $04
	JSL getDrawInfo200
	LDA $06
	BNE .dead

	LDA #$3C
	TAY
	
	LDA $00
	STA $0200,y
	LDA $02
	STA $0201,y
	
	LDA !chargedBusterDirection,x
	AND #$03
	PHY
	TAY
	LDA frame,y
	PLY
	STA $0202,y
	
	LDA !chargedBusterDirection,x
	AND #$40
	ORA #$2E
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
	
.xAdder: dw $0000,$0000,$0000,$0010,$0000,$0000,$0000,$FFF0
	
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