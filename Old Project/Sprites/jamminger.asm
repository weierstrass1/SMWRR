PRINT "INIT ",pc

incsrc sprites\header.asm
incsrc parches\headers\mmxheader.asm
incsrc exSprites\chargedBusterHeader.asm
incsrc exSprites\busterHeader.asm

;###############################
!HP = #$02 ;here put the HP of the sprite, use a value between 1-7F
;###############################

STZ $1510,x ;frame helice
STZ $1504,x ;frame cara
STZ $163E,x ;timer de frame

STZ $1534,x ;timer de risa o de subida cuando daña a mario
STZ $1594,x ;timer de paleta

STZ $C2,x ;Estado. 0= moverse, 1= subir cuando golpea a mario, 2 = reir

LDA !HP
STA $1528,x ;HP del sprite

LDA $D8,x
STA $00
LDA $14D4,x
STA $01

REP #$20
LDA $00
CLC
ADC !mmxYSpriteAdder
STA $00
SEP #$20
LDA $00
STA $D8,x
LDA $01
STA $14D4,x
+
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
	JSR direccionGraficaHelice
	JSR direccionGraficaCara
	JSR colisionMario
	JSR detectChargedBuster
	JSR detectarBala
	JSR timerPal
	JSR decisionMovimiento
	JSR timer1534
	JSR direccionMovimiento
	LDA $AA,x
	CLC
	ADC !mmxYSpeedAdder
	STA $AA,x
	JSL $01801A
	JSL $018022
    RTS
;====================================================
;================direccion Grafica===================
;====================================================
;dirige los frames de la helice
retDGH:
	RTS
direccionGraficaHelice:
	LDA $163E,x
	BNE retDGH
	
	LDA $1510,x
	CMP #$05
	BCS ExplotaDG
	JSR DGHeliceNormal
	RTS
ExplotaDG:
	JSR DGExplosion
	RTS
;dirige los frames de la cara
retDGC:
	RTS
direccionGraficaCara:
	LDA $13
	AND #$03
	BNE retDGC
	
	LDA $C2,x
	CMP #$02
	BNE normalCaraDG
	JSR DGCaraReir
	RTS
normalCaraDG:
	JSR DGCaraNormal
	RTS

;dirige la helice cuando el sprite esta vivo
nextCara1510: db $01,$02,$03,$04,$00
DGHeliceNormal:
	LDA #$02
	STA $163E,x
	
	LDA $1510,x
	TAY 
	
	LDA nextCara1510,y
	STA $1510,x
RTS
;dirige los frames de la explosion cuando muere

timeExp: db $00,$00,$00,$00,$00,$01,$02,$03,$03,$03,$03,$03,$03,$03
nextExp1510: db $05,$05,$05,$05,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E
DGExplosion:
	LDA $1510,x
	TAY
	
	LDA nextExp1510,y
	STA $1510,x
	CMP #$0E
	BEQ .kill
	
	LDA timeExp,y
	STA $163E,x

	RTS
	
.kill
	STZ $14C8,x
	
	RTS
;dirige los frames de la cara cuando no rie
CarF1:
	LDA #$01
	STA $1504,x
	RTS
DGCaraNormal:
	LDA $1504,x
	CMP #$03
	BEQ CarF1
	STZ $1504,x
RTS
;dirige los frames de la cara cuando rie
DGCaraReir:
	INC $1504,x
	LDA $1504,x
	CMP #$04
	BNE retDGCR
	STZ $1504,x
retDGCR:
RTS
;====================================================
;================direccion Movimiento================
;====================================================
;decide que movimiento hacer
decisionMovimiento:
	LDA $C2,x
	BNE .mov1
	JSR decEstado0
	RTS
.mov1
	LDA $C2,x
	CMP #$01
	BNE .mov2
	JSR decEstado1
	RTS
.mov2
	JSR decEstado2
	RTS
;dirige el movimiento del sprite dependiendo de C2
direccionMovimiento:
	LDA $1510,x
	CMP #$05
	BCC .mov
	STZ $B6,x
	STZ $AA,x
	RTS
.mov
	LDA $C2,x
	BNE .mov1
	JSR movEstado0
	RTS
.mov1
	LDA $C2,x
	CMP #$01
	BNE .mov2
	JSR movEstado1
	RTS
.mov2
	JSR movEstado2
	RTS
	
;decide el movimiento cuando esta en estado 0
decEstado0:
	STZ $C2,x
	RTS
;actualiza el timer
retT1534:
	RTS
timer1534:
	LDA $1534,x
	BEQ retT1534
	DEC $1534,x
	RTS
;decide el movimiento cuando esta en estado 1
decEstado1:
	LDA #$01
	STA $C2,x
	
	LDA $1534,x
	BNE .ret
	LDA #$02
	STA $C2,x
	LDA #$60
	STA $1534,x
.ret
	RTS
;decide el movimiento cuando esta en estado 2
decEstado2:
	LDA #$02
	STA $C2,x
	
	LDA $1534,x
	BNE .ret
	STZ $C2,x
.ret
	RTS
	
;mueve al sprite cuando esta en estado 0
;moverse normal
movEstado0:
	JSR ME0X
	JSR ME0Y
	RTS

Xvel: 	db $00,$06,$0C,$0C,$12,$18,$1E,$24,$2A,$30,$38,$40,$48,$50,$50,$50
		db $B0,$B0,$B0,$B0,$B0,$B8,$C0,$C8,$D0,$D6,$DC,$E2,$E8,$EE,$F4,$FA
;ve el movimiento horizontal en el estado 0
ME0X:
	LDA $E4,x
	STA $00
	LDA $14E0,x
	STA $01
	
	REP #$20
	LDA $94
	CLC
	ADC #$0008
	SEC
	SBC $00	
	BPL .Xcont0
	CMP #$FF00 
	BEQ .MaxIzqVel
	BCC .MaxIzqVel
.Xcont0
	CMP #$000E
	BCS .cont1
	SEP #$20
	LDA #$FC
	STA $B6,x
	RTS
.cont1
	CMP #$0100
	BMI .Xcont2
	BCS .MaxDerVel
.Xcont2
	LSR
	LSR
	LSR
	LSR ;obtain te high byte of the xSpeed
	AND #$001F
	SEP #$20
	TAY
	
	LDA Xvel,y
	STA $B6,x
	
	RTS

.MaxDerVel
	SEP #$20
	LDA #$50
	STA $B6,x
	RTS
.MaxIzqVel
	SEP #$20
	LDA #$B0
	STA $B6,x
	RTS
Yvel: 	db $00,$08,$10,$18,$20,$28,$30,$38,$40,$48,$50,$58,$60,$68,$70,$70
		db $90,$90,$90,$98,$A0,$A8,$B0,$B8,$C0,$C8,$D0,$D8,$E0,$E8,$F0,$F8
;ve el movimiento horizontal en el estado 0
ME0Y:
	LDA $D8,x
	STA $00
	LDA $14D4,x
	STA $01
	
	REP #$20
	LDA $96
	CLC
	ADC #$0020
	SEC
	SBC $00	
	BPL .Ycont0
	CMP #$FF00 
	BEQ .MaxArVel
	BCC .MaxArVel
.Ycont0
	CMP #$000D
	BCS .cont1
	SEP #$20
	LDA #$F8
	STA $AA,x
	RTS
.cont1
	CMP #$0100
	BMI .Ycont2
	BCS .MaxAbVel
.Ycont2
	LSR
	LSR
	LSR
	LSR ;obtain te high byte of the xSpeed
	AND #$001F
	SEP #$20
	TAY
	
	LDA Yvel,y
	STA $AA,x
	
	RTS

.MaxAbVel
	SEP #$20
	LDA #$70
	STA $AA,x
	RTS
.MaxArVel
	SEP #$20
	LDA #$90
	STA $AA,x
	RTS
	
;mueve al sprite cuando esta en estado 1
;subir cuando golpea a mario
movEstado1:
	LDA #$04
	STA $B6,x
	LDA #$D8
	STA $AA,x
	RTS
;mueve al sprite cuando esta en estado 2
;reirse
movEstado2:
	STZ $B6,x
	STZ $AA,x
	RTS

;====================================================
;================colision============================
;====================================================
;detecta la colision con mario	
colisionMario:
	
	LDA $1510,x
	CMP #$05
	BCS .ret

	JSL !spriteFirstX

	JSL !marioSecond
	
	REP #$20
	LDA #$0018
	STA $08
	LDA #$000E
	STA $0A
	LDA #$000A
	STA $0C
	LDA #$0028
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
	LDA #$01
	STA $C2,x
	LDA #$20
	STA $1534,x
	STZ $B6,x
	LDA #$D0
	STA $AA,x
	JSL $01801A
	JSL $018022	
	
	LDA #$02
	JSL !mmxDamage
	RTS
	
;revisa la colision con todas las balas posibles
detectChargedBuster:
	LDA $1510,x
	CMP #$05
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
	LDA #$0018
	STA $08
	LDA #$000E
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

	LDA #$01
	STA $1528,x
	JSR daniar
	
.next
	PLX
	
.ret
	RTS

detectarBala:
	LDA $1510,x
	CMP #$05
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
	LDA #$0018
	STA $08
	LDA #$000E
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

	JSR daniar

.ret
	RTS
;actualiza el timer de la paleta qu pone blanco al sprite
retTPal:
	RTS
timerPal:
	LDA $1594,x 
	BEQ retTPal
	DEC $1594,x 
	RTS
;dania al sprite
nextf:	db $01,$02,$03,$04,$FF
		db $07,$07,$08,$09,$FF
;dania al sprite
daniar:
	
	LDA $1594,x 
	BNE .ret
	LDA #$04
	STA $1594,x 
	DEC $1528,x
	LDA $1528,x
	BEQ .startDeath
	RTS	
.startDeath
	LDA #$05
	STA $1510,x
	LDA #$01
	STA $163E,x
	LDA #$1A
	STA $1DFC
	
	JSL !spriteFirstX
	
	REP #$20
	LDA $00
	CLC
	ADC #$0008
	STA $00
	
	LDA $02
	CLC
	ADC #$0008
	STA $02
	SEP #$20
	
	JSL !mmxThrowItem
	
.ret
	RTS
	
;====================================================
;================Graphics Routine====================
;====================================================
Graphics:
	JSL !GET_DRAW_INFO
	LDA $06
	BEQ .cont1
	RTS
.cont1
	LDA $1510,x
	CMP #$05
	BCS .exp
	
	LDA #$23
	STA $0D
	LDA $1594,x
	BEQ .cont
	LDA #$29
	STA $0D
.cont
	JSR GRHelice
	JSR GRCara

	LDY #$02
	LDA #$03
	JSL $01B7B3
	RTS
.exp
	JSR GRExplosion
	RTS

;Tables for Frames:
;###############  Tables for HeliceFrame1   #############
PROPERTIES_HeliceFrame1: 	db $23,$63 ;f1
							db $23,$63 ;f2
							db $23,$63 ;f3
							db $23,$63 ;f4
							db $23,$63 ;f5
							
TILEMAP_HeliceFrame1: 		db $2A,$2A ;f1
							db $0C,$0E ;f2
							db $2C,$2E ;f3
							db $0E,$0C ;f4
							db $2E,$2C ;f5
							
XDISP_HeliceFrame1: 		db $00,$0F ;f1
							db $00,$0F ;f2
							db $00,$0F ;f3
							db $00,$0F ;f4
							db $00,$0F ;f5
							
;y =F0
iniPosH: db $01,$03,$05,$07,$09 
finPosH: db $00,$02,$04,$06,$08
;########################################################################
GRHelice:

	PHX
	LDA $1510,x
	TAX

	LDA finPosH,x
	STA $0A

	LDA iniPosH,x
	TAX

.loop
	LDA $00
	CLC
	ADC XDISP_HeliceFrame1,x
	STA $0300,y

	LDA $01
	CLC
	ADC #$F0
	STA $0301,y

	LDA TILEMAP_HeliceFrame1,x
	STA $0302,y

	LDA PROPERTIES_HeliceFrame1,x
	ORA $0D
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
	RTS

;###############  Tables for CaraFrame1   #############
PROPERTIES_CaraFrame1: 	db $23,$63 ;f1
						db $23,$63 ;f2
						db $23,$63 ;f3
						db $23,$63 ;f2
						
TILEMAP_CaraFrame1: 	db $06,$06 ;f1
						db $08,$08 ;f2
						db $0A,$0A ;f3
						db $08,$08 ;f2
						
XDISP_CaraFrame1: 		db $00,$0F ;f1
						db $00,$0F ;f2
						db $00,$0F ;f3
						db $00,$0F ;f2
	
;Y = 00	
iniPosC: db $01,$03,$05,$07 
finPosC: db $00,$02,$04,$06
;########################################################################
GRCara:
	PHX
	LDA $1504,x
	TAX

	LDA finPosC,x
	STA $0A

	LDA iniPosC,x
	TAX

.loop
	LDA $00
	CLC
	ADC XDISP_CaraFrame1,x
	STA $0300,y

	LDA $01
	STA $0301,y

	LDA TILEMAP_CaraFrame1,x
	STA $0302,y

	LDA PROPERTIES_CaraFrame1,x
	ORA $0D
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
	RTS

;###############  Tables for FrameEx1   #############
PROPERTIES_FrameEx1:	db $2C,$6C,$AC,$EC ;ex1
						db $2C,$6C,$AC,$EC ;ex2
						db $2C,$6C,$AC,$EC ;ex1
						db $2C,$6C,$2C,$6C ;ex3
						db $2C,$6C,$2C,$6C ;ex4
						db $2C,$6C,$2C,$6C ;ex5
						db $2C,$6C,$2C,$6C ;ex6
						db $2C,$6C,$2C,$6C ;ex7
						db $2C,$6C ;ex8

TILEMAP_FrameEx1:	db $63,$63,$63,$63 ;ex1
					db $C2,$C2,$C2,$C2 ;ex2
					db $63,$63,$63,$63 ;ex1
					db $C4,$C4,$E0,$E0 ;ex3
					db $C6,$C6,$E2,$E2 ;ex4
					db $C8,$C8,$E4,$E4 ;ex5
					db $CA,$CA,$E6,$E6 ;ex6
					db $CC,$CC,$E8,$E8 ;ex7
					db $CE,$CE ;ex8
						
XDISP_FrameEx1: 		db $08,$10,$08,$10 ;f1
						db $00,$10,$00,$10 ;f2
						db $08,$10,$08,$10 ;f1
						db $00,$10,$00,$10 ;f3
						db $00,$10,$00,$10 ;f4
						db $00,$10,$00,$10 ;f5
						db $00,$10,$00,$10 ;f6
						db $00,$10,$00,$10 ;f7
						db $00,$10 ;f8
						
YDISP_FrameEx1: 		db $F8,$F8,$00,$00 ;f1
						db $F0,$F0,$00,$00 ;f2
						db $F8,$F8,$00,$00 ;f1
						db $F0,$F0,$00,$00 ;f3
						db $F0,$F0,$00,$00 ;f4
						db $F0,$F0,$00,$00 ;f5
						db $F0,$F0,$00,$00 ;f6
						db $F0,$F0,$00,$00 ;f7
						db $F0,$F0 ;f8
tilesExp: db $03,$03,$03,$03,$03,$03,$03,$03,$01	
TamanExp: db $00,$02,$00,$02,$02,$02,$02,$02,$02		
iniPosExp: db $03,$07,$0B,$0F,$13,$17,$1B,$1F,$21	
finPosExp: db $00,$04,$08,$0C,$10,$14,$18,$1C,$20		
;########################################################################
GRExplosion:
	PHX
	LDA $1510,x
	SEC
	SBC #$05
	TAX

	LDA finPosExp,x
	STA $0A
	
	LDA tilesExp,x
	STA $0B
	
	LDA TamanExp,x
	STA $0C

	LDA iniPosExp,x
	TAX

.loop
	LDA $00
	CLC
	ADC XDISP_FrameEx1,x
	STA $0300,y

	LDA $01
	CLC
	ADC YDISP_FrameEx1,x
	STA $0301,y

	LDA TILEMAP_FrameEx1,x
	STA $0302,y

	LDA PROPERTIES_FrameEx1,x
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