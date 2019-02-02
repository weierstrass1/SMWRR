PRINT "INIT ",pc

incsrc sprites\header.asm
incsrc parches\headers\mmxheader.asm

!ySpeed = #$F0

!layerYspeed = $1528,x 

!layerYspeedFrac = $151C,x 

!stop = $1504,x

LDA #$01
STA !stop

LDA $D8,x
STA !mmxYFloor
LDA $14D4,x
STA !mmxYFloor+$01

REP #$20
LDA !mmxYFloor
CLC
ADC #$0010
STA !mmxYFloor
SEP #$20

LDA #$00
STA !layerYspeed
STA !layerYspeedFrac

STZ $1510,x ;si esta activado hay velocidad
LDA #$80
STA $C2,x ;puntero de velocidad
RTL

PRINT "MAIN ",pc

PHB		;\
PHK		; | Change the data bank to the one our code is running from.
PLB		; | This is a good practice.
JSR SpriteCode	; | Jump to the sprite's function.
PLB		; | Restore old data bank.
RTL		;/ And return.

;===================================
;Sprite Function
;===================================

RETURN: RTS

SpriteCode:
	LDA $D8,x
	STA !mmxYFloor
	LDA $14D4,x
	STA !mmxYFloor+$01
	REP #$20
	LDA !mmxYFloor
	CLC
	ADC #$FFFC
	STA !mmxYFloor
	SEP #$20

	JSR graficos
	LDA $14C8,x			;\
	CMP #$08			; | If sprite dead,
	BNE RETURN			;/ Return.
	LDA $9D				;\
	BNE RETURN			;/ If locked, return.
	LDA $14D4,x
	BNE +
	LDA #$02
	STA $1510,x
+
	JSR velocidad
	JSL $01801A
	JSR updateLayerPos
	
	LDA $D8,x
	STA $00
	LDA $14D4,x
	STA $01
	
	REP #$20
	LDA $00
	CMP #$01B0
	BCS +
	LDA #$01B0
	STA $00
	SEP #$20
	LDA $00
	STA $D8,x
	LDA $01
	STA $14D4,x
	BRA ++
+
	SEP #$20
++
	JSR colision
	
	LDA $1471
	BEQ .ret
	
	LDA $1510,x
	CMP #$02
	BEQ +
	LDA #$01
	STA $1510,x
	
	LDA !stop
	BNE +
	LDA $13
	AND #$1F
	BNE +
	
	JSL $01ACF9
	LDA $148D
	AND #$01
	BEQ .can7
	LDA #$31
	STA $1DF9
	BRA +
.can7
	LDA #$36
	STA $1DFC
	BRA +
+
	REP #$20
	LDA $02
	SEC
	SBC #$0010
	STA $96
	SEP #$20

.ret
    RTS
;===================================
;Colision
;===================================
vel:	dw $0000,$0001,$0000,$0000,$0000,$FFFF,$0000,$0000,$0000,$0002,$0000,$0000,$0000,$FFFE
		dw $0000,$0004,$0000,$FFFC,$0000,$0004,$0000,$FFFC,$0004,$FFFC,$0004,$FFFC,$0004,$FFFC
velocidad:

	LDA !stop
	BEQ +
	LDA $C2,x
	BNE +
	RTS
+
	LDA $1510,x
	BEQ .ret2
	CMP #$02
	BNE +
	STZ $AA,x
	LDA #$00
	STA !mmxYSpriteAdder
	STA !mmxYSpriteAdder+$01
	STA !layerYspeed
	STA !mmxYSpeedAdder
	LDA #$01
	STA !stop
	RTS
+
	
	LDA #$01
	STA $13F1
	
	LDA !ySpeed
	STA $AA,x
	STA !layerYspeed
	STA !mmxYSpeedAdder
	
	STZ !stop
	
	REP #$20
	LDA #$FEC0
	STA !mmxYSpriteAdder
	SEP #$20
	
	LDA $C2,x
	BEQ .ret
	ASL
	TAY
	
	STZ $13F1
	STZ $AA,x
	STZ !layerYspeed
	LDA #$00
	STA !mmxYSpeedAdder
	STA !mmxYSpriteAdder
	STA !mmxYSpriteAdder+$01
	
	DEC $C2,x
	
	LDA $C2,x
	CMP #$1B
	BCS .ret2

	
	REP #$20
	LDA $1464
	CLC
	ADC vel,y
	STA $1464
	SEP #$20
	RTS
.ret
	STZ !stop
.ret2
	RTS
	
updateLayerPos:

	LDA !layerYspeed
	STA $00
	LDA !layerYspeedFrac
	STA $01
	REP #$20
	LDA $1464
	STA $02
	SEP #$20
	
	JSL !updatePosition
	
	LDA $01
	STA !layerYspeedFrac
	REP #$20
	LDA $02
	STA $1464
	CMP #$0100
	BCS +
	LDA #$0100
	STA $1464
	SEP #$20
	LDA #$01
	STA !stop
	LDA #$00
	STA !mmxYSpeedAdder
	RTS
+
	SEP #$20

	RTS

;===================================
;Colision
;===================================	
colision:
	STZ	$1471
	JSL !spriteFirstX

	JSL !marioSecond
	
	REP #$20
	LDA #$009A
	STA $08
	LDA #$0020
	STA $0A
	LDA #$0008
	STA $0C
	LDA #$0010
	STA $0E
	SEP #$20

	JSL !contact
	BCC .ret
	JSR solido
.ret
	RTS
	
solido:
	STZ $04
	REP #$20
	LDA $96
	CLC
	ADC #$000A
	CMP $02
	BCS +
	
	LDY #$01
	STY $1471
	STY $04

	LDY $7D
	BMI ++
	STZ $7D	
	
	BRA ++
+
	LDA $02
	CLC
	ADC #$001A
	CMP $96
	BCS ++
	
	LDY #$01
	STY $04
	
	LDY $7D
	BEQ +
	BPL ++
+
	STZ $7D
++
	LDY $04
	BNE ++
	
	LDA $00
	CLC
	ADC	#$0050
	CMP $94
	BCC +
	LDY $7B
	BMI ++
	STZ $7B
	BRA ++
+
	LDY $7B
	BPL ++
	STZ $7B
++
	SEP #$20
	RTS
	

;===================================
;Graficos
;===================================

xDisp:	db $00,$10,$20,$38,$30,$40,$50,$58,$60,$70,$80,$90
		db $00,$10,$20,$30,$38,$40,$50,$58,$60,$70,$80,$90
		
yDisp:	db $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10	
		db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20		
		
tiles:	db $44,$45,$45,$A8,$45,$A8,$A8,$A8,$45,$45,$45,$EA
		db $8C,$4E,$C0,$8A,$47,$48,$48,$47,$8A,$C0,$4E,$8C
		
props:	db $36,$36,$36,$36,$36,$36,$36,$36,$36,$36,$36,$36
		db $37,$36,$36,$77,$36,$36,$36,$76,$37,$76,$76,$77
		
oamSt:	db $90,$94,$98,$9C,$A0,$A4,$A8,$AC,$B0,$B4,$B8,$BC
		db $C0,$C4,$C8,$CC,$D0,$D4,$D8,$DC,$E0,$E4,$E8,$EC
		
graficos:

	LDA $E4,x
	STA $0C
	LDA $14E0,x
	STA $0D
	LDA $D8,x
	STA $0E
	LDA $14D4,x
	STA $0F
	
	STZ $09
	STZ $07
	
	PHX
	
	LDY #$17

.loop
	LDA xDisp,y
	STA $08
	
	LDA yDisp,y
	STA $06	
	
	REP #$20
	LDA $0C
	CLC
	ADC $08
	STA $00
	
	LDA $0E
	CLC
	ADC $06
	STA $02
	SEP #$20
	
	LDA #$02
	STA $04
	
	JSL !getDrawInfo200
	LDA $06
	BNE .next
	
	LDA oamSt,y
	TAX

	LDA $00
	STA $0200,x
	LDA $02
	STA $0201,x
	
	LDA tiles,y
	STA $0202,x
	
	LDA props,y
	STA $0203,x
	
	TXA
	LSR
	LSR	
	TAX
	LDA $04;ponemos el tamano del grafico con su modalidad
	STA $0420,x
	
.next
	DEY
	BPL .loop
	
	PLX
	RTS
	

	
	