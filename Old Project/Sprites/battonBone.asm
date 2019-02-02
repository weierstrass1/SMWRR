PRINT "INIT ",pc

incsrc parches\headers\header.asm
incsrc parches\headers\mmxheader.asm
incsrc exSprites\chargedBusterHeader.asm
incsrc exSprites\busterHeader.asm

;###############################
!cluster = #$0C ;here put the cluster slot
;###############################

LDA #$01
STA $1510,x ;grafico
JSR seleccionar

LDA #$00
STA $C2,x ;accion. 0 = posarse, 1 = perseguir, 2 = subir.

LDA #$20
STA $1528,x ;timer para posarse

LDA #$0A
STA $1540,x ;timer para tirar humo

LDA $D8,x
STA $00
LDA $14D4,x
STA $01

REP #$20
LDA $00
SEC
SBC #$0004
STA $00
SEP #$20

LDA $00
STA $D8,x

LDA $01
STA $14D4,x

LDA #$04
STA $163E,x

JSL $01801A
JSL $018022

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
	JSR Graphics

	LDA $14C8,x			;\
	CMP #$08			; | If sprite dead,
	BNE RETURN			;/ Return.
	LDA $9D				;\
	BNE RETURN			;/ If locked, return.
	JSL !SUB_OFF_SCREEN_X0		; Handle offscreen.
	
	JSR direccionGrafica	
	JSR colisionMario
	JSR detectarBala
	JSR detectChargedBuster
	JSR timerPosado
	JSR desicionMov
	JSR direccionMov
    RTS

;====================================================
;================direccion Grafica===================
;====================================================

;Dirige que frame utilizar en este momento
retDG:
	RTS
direccionGrafica:
	LDA $163E,x
	BNE retDG
	
	LDA $1510,x
	CMP #$11
	BCC noMuriendoDG
	
	INC $1510,x
	
	LDA $1510,x
	CMP #$1A
	BCS morir
	JSR seleccionar
	RTS
morir:
	STZ $14C8,x	
	RTS
	
noMuriendoDG:

	LDA $C2,x
	BNE vuelaDG
	JSR PosarseDG
	JSR seleccionar
	RTS
	
vuelaDG:
	JSR volarDG
	JSR seleccionar
	RTS

Posarseble: db $01,$02,$03,$04,$05,$06,$07,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
;dirige que frame utilizar cuando se esta posando
PosarseDG:

	LDA $1510,x
	TAY
	
	LDA Posarseble,y
	STA $1510,x
	RTS


volartable: db $06,$07,$08,$09,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$10,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$0A
;dirige que frame utilizar cuando esta volando
volarDG:
	
	LDA $1510,x
	TAY
	
	LDA volartable,y
	STA $1510,x
	
	RTS

tiempotiles: db $03,$20,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$01,$02,$02,$02,$02,$02,$02,$02
;selecciona el frame	
seleccionar:

	LDA $1510,x
	TAY
	
	LDA tiempotiles,y
	STA $163E,x
	RTS

;====================================================
;================direccion Movimiento================
;====================================================
;pone el movimiento correspondiente
direccionMov:
	LDA $1510,x
	CMP #$11
	BCC contDMov
	STZ $B6,x
	STZ $AA,x
	JSL $01801A
	JSL $018022
	RTS
contDMov:
	LDA $C2,x
	BNE mov1
	JSR PosarseMov
	RTS
mov1:
	LDA $C2,x
	CMP #$01
	BNE mov2
	JSR perseguirMov
	RTS
mov2:
	JSR subirMov
	RTS
	
;decide el movimiento
desicionMov:
	LDA $C2,x
	BNE mov1des
	JSR cambioEstado0
	RTS
mov1des:
	LDA $C2,x
	CMP #$01
	BNE mov2des
	JSR cambioEstado1
	RTS
mov2des:
	JSR cambioEstado2
	RTS
	
retTP:
	RTS
timerPosado:
	LDA $1528,x
	BEQ retTP
	DEC $1528,x
	RTS
	
cambioEstado0:

	LDA $1528,x
	BNE Est0
	
	LDA $E4,x
	STA $00
	LDA $14E0,x
	STA $01
	
	REP #$20
	LDA $94
	STA $04
	
	LDA #$0050
	STA $08
	LDA #$0050
	STA $0A
	
	JSR detectarCercania
	BCC Est0
	
	LDA #$01
	STA $C2,x
	
	RTS
Est0withTim:
	LDA #$20
	STA $1528,x
Est0:
	STZ $C2,x
	RTS
	
cambioEstado1:
	LDA #$01
	STA $C2,x
	RTS
	
cambioEstado2:
	JSR detectarTecho
	BCC Est2
	JMP Est0withTim
Est2:
	LDA #$02
	STA $C2,x
	RTS
	
;mueve al sprite cuando se esta posando
PosarseMov:
	STZ $B6,x
	STZ $AA,x
	JSL $01801A
	JSL $018022
	RTS
	
;mueve al sprite cuando esta persiguiendo a mario
perseguirMov:

	LDA $1510,x
	CMP #$09
	BCC PosarseMov
	
	JSR invocarHumo

	LDA $D8,x
	STA $00
	LDA $14D4,x
	STA $01
	
	REP #$20
	
	LDA $96
	STA $04
	
	LDA #$0008
	STA $08
	LDA #$0008
	STA $0A
	
	JSR detectarCercania
	BCS movDer
	
	LDA $14D4,x
	CMP $97
	BEQ verLowY
	BCS irAbajo
	JMP irArriba
irAbajo:

	DEC $AA,x
	LDA $AA,x
	BPL movDer
	CMP #$E8
	BCS movDer
	LDA #$E8
	STA $AA,x
	JMP movDer
irArriba:

	INC $AA,x
	LDA $AA,x
	BMI movDer
	CMP #$18
	BCC movDer
	LDA #$18
	STA $AA,x
	JMP movDer
verLowY:
	LDA $D8,x
	CMP $96
	BCS irAbajo
	JMP irArriba
	
movDer:

	LDA $1510,x
	CMP #$09
	BCC PosarseMov

	LDA $E4,x
	STA $00
	LDA $14E0,x
	STA $01
	
	REP #$20	
	
	LDA $94
	STA $04
	
	LDA #$000A
	STA $08
	LDA #$000A
	STA $0A
	
	JSR detectarCercania
	BCC contMovDer
	STZ $B6,x
	JSL $01801A
	JSL $018022
	RTS
contMovDer:
	LDA $14E0,x
	CMP $95
	BEQ verLowX
	BCS irIzq
	BCC irDer
	RTS
irIzq:
	LDA #$F0
	STA $B6,x
	JSL $01801A
	JSL $018022
	RTS
irDer:
	LDA #$10
	STA $B6,x
	JSL $01801A
	JSL $018022
	RTS
verLowX:
	LDA $E4,x
	CMP $94
	BCC irDer
	JMP irIzq
	
;mueve al sprite cuando esta subiendo para buscar pared
subirMov:	
	JSR invocarHumo
	STZ $B6,x
	LDA #$E8
	STA $AA,x
	JSL $01802A
	LDA #$E8
	STA $AA,x
	JSL $01801A
	RTS

;====================================================
;================colision============================
;====================================================

;revisa si esta tocando el techo
detectarTecho:
	LDA $1588,x
	AND #$08
	BEQ sinTec
	STZ $1588,x
	SEC 
	RTS
sinTec:
	STZ $1588,x
	CLC
	RTS
;detecta la colision con mario	
colisionMario:
	
	LDA $1510,x
	CMP #$11
	BCS .ret

	JSL !spriteFirstX

	JSL !marioSecond
	
	REP #$20
	LDA #$000A
	STA $08
	LDA #$000C
	STA $0A
	LDA #$000A
	STA $0C
	LDA #$001E
	STA $0E
	SEP #$20
	
	JSL !contact
	BCC .ret

	LDA $1497
	BNE .ret
	LDA !mmxDamTimer
	BNE .ret
	
	JSR daniarMario
.ret
	RTS

	
daniarMario:
	LDA #$02
	STA $C2,x
	STZ $B6,x
	LDA #$D0
	STA $AA,x
	JSL $01801A
	JSL $018022	
	

	STZ $0F
	REP #$20	
	LDA $00
	CLC
	ADC #$0008
	CMP $04
	SEP #$20
	BCC +
	LDA #$01
	STA $0F
+
	LDA #$02
	JSL !mmxDamage
.ret
	RTS
	
;revisa la colision con todas las balas posibles
detectChargedBuster:
	LDA $1510,x
	CMP #$11
	BCS .ret
	
	LDY #$06
	
	PHX
	LDA $170B,y
	CMP !mmxChargedBuster
	BNE .next
	
	JSL !spriteFirstX

	JSL !extendedSecondY
	
	STZ $09
	
	
	REP #$20
	LDA #$000A
	STA $08
	LDA #$0010
	STA $0A
	LDA #$000E
	STA $0C
	LDA #$000E
	STA $0E
	SEP #$20
	
	JSL !contact
	BCC .next
	
	LDA !chargedBusterDirection,y
	AND #$03
	CMP #$02
	BCS .next

	JSR matar
	
.next
	PLX
	
.ret
	RTS

detectarBala:
	LDA $1510,x
	CMP #$11
	BCS .ret

	LDY #$09

.loop
	PHX
	LDA $170B,y
	CMP !mmxCommonBuster
	BNE .next
	
	JSR colisionExt
	
.next
	PLX
	DEY
	CPY #$07
	BPL .loop
.ret
	RTS
	
;rutina de colision con extended sprites
colisionExt:

	JSL !spriteFirstX

	JSL !extendedSecondY
	
	STZ $09
	
	
	REP #$20
	LDA #$000A
	STA $08
	LDA #$0010
	STA $0A
	LDA #$0006
	STA $0C
	LDA #$0006
	STA $0E
	SEP #$20
	
	JSL !contact
	BCC .ret
	
	LDA !busterDirection,y
	AND #$03
	BNE .ret
	JSL !busterKill

	JSR matar

.ret
	RTS
;pone al sprite en modalidad de muerte
matar:
	LDA #$1A
	STA $1DFC
	LDA #$11
	STA $1510,x
	PHY
	JSR seleccionar
	PLY
	
	RTS

detectarCercania:

	LDA $00
	CLC
	ADC $08
	CMP $04
	BCC .ret
	
	LDA $04
	CLC
	ADC $0A
	CMP $00
	BCC .ret
	
	SEP #$20	
	SEC
	RTS
	
.ret
	SEP #$20
	CLC
	RTS
	
;====================================================
;================invocaciones========================
;====================================================

invocarHumo:
	
	LDA $1540,x
	CMP #$0A
	BCC	contNVHUMO
	LDA #$0A
	STA $1540,x
contNVHUMO:
	LDA $1540,x
	BNE retInvHUmo
	LDA #$0A
	STA $1540,x
	JSR InvHumo
	RTS
retInvHUmo:
	RTS
	
InvHumo:
	LDY #$07
InvHLoop1:
	
	LDA $1892,y
	BNE .next
	
	LDA !cluster
	STA $1892,y
	
	LDA #$00
	STA $0F72,y
	
	LDA #$04
	STA $1E66,y
	
	LDA $E4,x
	STA $1E16,y
	
	LDA $14E0,x
	STA $1E3E,y
	
	LDA $14D4,x
	STA $1E2A,y
	
	LDA $D8,x
	STA $1E02,y
	BRA .quit
	
.next	
	DEY
	CPY #$05
	BCC RetInvH
	JMP InvHLoop1
.quit
	
	LDA #$01 ; \ Run cluster sprite routine.
	STA $18B8
RTS
RetInvH:
	RTS

;====================================================
;================Graphics Routine====================
;====================================================

;Tables for Frames:
;###############  Tables for Frame1   #############
PROPERTIES_Frame1: 	db $24,$64,$24,$64 ;f2
					db $24,$24 ;f4
					db $24,$24 ;f3
					db $24,$24 ;f2
					db $24,$24 ;f1
					db $24,$24 ;f1
					db $24,$24 ;f2
					db $24,$24 ;f3
					db $24,$24 ;f4
					db $24,$64,$24,$64 ;f2
					db $24,$64,$24,$64,$24,$24 ;f6
					db $24,$64,$24,$64 ;f2
					db $24,$64,$24,$64 ;f8
					db $24,$64,$24,$64 ;f9
					db $24,$64,$24,$64 ;f8
					db $24,$64,$24,$64 ;f2
					db $24,$64,$24,$64,$24,$24 ;f6
					db $2C,$6C,$AC,$EC ;ex1
					db $2C,$6C,$AC,$EC ;ex2
					db $2C,$6C,$AC,$EC ;ex1
					db $2C,$6C,$2C,$6C ;ex3
					db $2C,$6C,$2C,$6C ;ex4
					db $2C,$6C,$2C,$6C ;ex5
					db $2C,$6C,$2C,$6C ;ex6
					db $2C,$6C,$2C,$6C ;ex7
					db $2C,$6C ;ex8
					
TILEMAP_Frame1: 	db $8A,$8A,$AA,$AA ;f5
					db $88,$A6 ;f4
					db $A6,$EE ;f3
					db $A6,$86 ;f2
					db $A6,$EC ;f1					
					db $A6,$EC ;f1
					db $A6,$86 ;f2
					db $A6,$EE ;f3
					db $88,$A6 ;f4
					db $8A,$8A,$AA,$AA ;f5
					db $80,$80,$A0,$A0,$82,$A2 ;f6
					db $84,$84,$A4,$A4 ;f7
					db $8C,$8C,$AC,$AC ;f8
					db $8E,$8E,$AE,$AE ;f9
					db $8C,$8C,$AC,$AC ;f8
					db $84,$84,$A4,$A4 ;f7
					db $80,$80,$A0,$A0,$82,$A2 ;f6
					db $63,$63,$63,$63 ;ex1
					db $C2,$C2,$C2,$C2 ;ex2
					db $63,$63,$63,$63 ;ex1
					db $C4,$C4,$E0,$E0 ;ex3
					db $C6,$C6,$E2,$E2 ;ex4
					db $C8,$C8,$E4,$E4 ;ex5
					db $CA,$CA,$E6,$E6 ;ex6
					db $CC,$CC,$E8,$E8 ;ex7
					db $CE,$CE ;ex8
					
XDISP_Frame1: 		db $F8,$08,$F8,$08 ;f5
					db $00,$00 ;f4
					db $00,$00 ;f3
					db $00,$00 ;f2
					db $00,$00 ;f1
					db $00,$00 ;f1
					db $00,$00 ;f2
					db $00,$00 ;f3
					db $00,$00 ;f4
					db $F8,$08,$F8,$08 ;f5
					db $F0,$0F,$F0,$0F,$00,$00 ;f6
					db $F8,$07,$F8,$07 ;f7
					db $F8,$07,$F8,$07 ;f8
					db $F8,$07,$F8,$07 ;f9
					db $F8,$07,$F8,$07 ;f8
					db $F8,$07,$F8,$07 ;f7
					db $F0,$0F,$F0,$0F,$00,$00 ;f6
					db $00,$08,$00,$08 ;ex1
					db $F8,$08,$F8,$08 ;ex2
					db $00,$08,$00,$08 ;ex1
					db $F8,$08,$F8,$08 ;ex3
					db $F8,$08,$F8,$08 ;ex4
					db $F8,$08,$F8,$08 ;ex5
					db $F8,$08,$F8,$08 ;ex6
					db $F8,$08,$F8,$08 ;ex7
					db $F8,$08 ;ex8
					
					
YDISP_Frame1: 		db $00,$00,$10,$10 ;f5
					db $00,$10 ;f4
					db $10,$00 ;f3
					db $10,$00 ;f2
					db $10,$00 ;f1					
					db $10,$00 ;f1
					db $10,$00 ;f2
					db $10,$00 ;f3
					db $00,$10 ;f4
					db $00,$00,$10,$10 ;f5
					db $00,$00,$10,$10,$00,$10 ;f6
					db $00,$00,$10,$10 ;f7
					db $00,$00,$10,$10 ;f8
					db $00,$00,$10,$10 ;f9
					db $00,$00,$10,$10 ;f8
					db $00,$00,$10,$10 ;f7
					db $00,$00,$10,$10,$00,$10 ;f6
					db $00,$00,$08,$08 ;ex1
					db $F8,$F8,$08,$08 ;ex2
					db $00,$00,$08,$08 ;ex1
					db $F8,$F8,$08,$08 ;ex3
					db $F8,$F8,$08,$08 ;ex4
					db $F8,$F8,$08,$08 ;ex5
					db $F8,$F8,$08,$08 ;ex6
					db $F8,$F8,$08,$08 ;ex7
					db $F8,$F8 ;ex8

iniPos: db $03,$05,$07,$09,$0B,$0D,$0F,$11,$13,$17,$1D,$21,$25,$29,$2D,$31,$37,$3B,$3F,$43,$47,$4B,$4F,$53,$57,$59
finPos: db $00,$04,$06,$08,$0A,$0C,$0E,$10,$12,$14,$18,$1E,$22,$26,$2A,$2E,$32,$38,$3C,$40,$44,$48,$4C,$50,$54,$58
tilesF: db $03,$01,$01,$01,$01,$01,$01,$01,$01,$03,$05,$03,$03,$03,$03,$03,$05,$03,$03,$03,$03,$03,$03,$03,$03,$01
Tamani: db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$00,$02,$00,$02,$02,$02,$02,$02,$02

Graphics:

JSL !GET_DRAW_INFO

LDA $06
BEQ .cont
RTS
.cont

PHX

LDA $1510,x
TAX

LDA finPos,x
STA $0A

LDA tilesF,x
STA $0B

LDA Tamani,x
STA $0C

LDA iniPos,x
TAX

.loop
LDA $00
CLC
ADC XDISP_Frame1,x
STA $0300,y

LDA $01
CLC
ADC YDISP_Frame1,x
STA $0301,y

LDA TILEMAP_Frame1,x
STA $0302,y

LDA PROPERTIES_Frame1,x
ORA $64
STA $0303,y

INY
INY
INY
INY

DEX
BMI .quit
CPX $0A
BCS .loop
.quit
PLX

LDY $0C
LDA $0B
JSL $01B7B3
RTS
