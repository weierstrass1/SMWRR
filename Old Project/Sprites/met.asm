PRINT "INIT ",pc

incsrc sprites\header.asm
incsrc parches\headers\mmxheader.asm
incsrc exSprites\chargedBusterHeader.asm
incsrc exSprites\busterHeader.asm

;###############################
!HP = #$02 ;here put the HP of the sprite, use a value between 1-7F
;###############################

;###############################
!Bullet = #$10 
;###############################

STZ $1510,x ;frame

STZ $C2,x ;estado, 0 = oculto, 1 = esconderse, 2 = levantarse, 3 = caminar

LDA #$04
STA $163E,x ;timer de frames

STZ $1594,x ;timer de paleta

LDA #$40
STA $1534,x ;timer escondido

LDA #$01
STA $157C,x

LDA !HP
STA $1528,x ;HP del sprite

STZ $151C,x ;puede levantarse

STZ $1FD6,x ;1 = dispara, 0 = camina

STZ $1602,x

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
	JSR timerPal
	JSR colisionMario
	JSR detectarBala
	JSR detectChargedBuster
	JSR colisionPared
	JSR timer1534
	JSR cambiosDeEstado
	JSR direccionGrafica
	JSL $01802A
    RTS
	
;===================================
;graphic manager
;===================================

direccionGrafica:

	LDA $163E,x
	BNE .ret
	
	LDA $1510,x
	CMP #$0C
	BCS .exp
	
	LDA #$04
	STA $163E,x
	
	LDA $C2,x
	CMP #$02
	BCS +
	JSR grEst0 ;estar oculto
	RTS
+
	BNE +
	JSR grEst2 ;levantarse
	RTS
+
	JSR grEst3 ;caminar
	RTS
	
.exp
	JSR explosion
.ret
	RTS
	
next0: db $00,$00,$01,$02,$03,$04,$05,$03,$04,$05,$05,$05
grEst0:

	LDA $1510,x
	TAY
	
	LDA next0,y
	STA $1510,x

	RTS

next2: db $03,$04,$03,$04,$05,$06,$07,$07,$07,$07,$07,$07
grEst2:
	LDA $1510,x
	TAY
	
	LDA next2,y
	STA $1510,x

	RTS

next3: db $03,$04,$03,$04,$05,$06,$07,$08,$09,$0A,$07,$07
grEst3:
	LDA $1510,x
	TAY
	
	LDA next3,y
	STA $1510,x

	RTS
	
nextE: db $0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0C,$0D,$0E,$0F,$10,$11,$12,$13,$14,$15
timeE: db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$03,$03,$03,$03,$03,$03	
explosion: 

	STZ $B6,x
	STZ $AA,x
	LDA $1510,x
	TAY
	
	LDA nextE,y
	STA $1510,x
	
	LDA $1510,x
	CMP #$15
	BCS .kill
	
	LDA timeE,y
	STA $163E,x
	
	RTS
.kill
	STZ $14C8,x	
	RTS
;===================================
;movement
;===================================
direccionar:

	LDA $E4,x
	STA $00 ;carga el low byte en 00
	
	LDA $14E0,x
	STA $01 ;carga el high byte en 01
	
	REP #$20
	
	LDA $00
	CLC
	ADC #$000C ;le suma una cantidad para referenciar el centro del sprite
	CMP $94 ;compara la posicion del centro del sprite con la posicion de mario
	SEP #$20
	BCC + ;si mario esta a la derecha pone la direccion en derecha sino izquierda
	
	LDA #$01
	STA $157C,x ;direccion izquierda
	RTS
+
	STZ $157C,x ;direccion derecha
	RTS
	
timer1534:

	LDA $1534,x
	BEQ .ret
	
	DEC $1534,x
.ret
	RTS

cambiosDeEstado:
	LDA $1510,x
	CMP #$0C
	BCS .ret
	JSR direccionar
	LDA $C2,x
	BNE +
	JSR est0 ;estar oculto
	RTS
+
	CMP #$01
	BNE +
	JSR est1 ;esconderse
	RTS
+
	CMP #$02
	BNE +
	JSR est2 ;levantarse
	RTS
+
	JSR est3 ;caminar
.ret
	RTS
	
;estar oculto
est0:
	STZ $B6,x

	LDA $1534,x ;checkea si esta el timer de esconderse puesto
	BNE +
	
	LDA $1602,x
	BNE .par
	
	LDA $76
	CMP $157C,x ;checkea la direccion de mario
	BNE .cambio
.par
	STZ $151C,x
	
	LDA $1534,x
	BNE +
	
	LDA #$01
	STA $1FD6,x
	LDA #$02
	STA $C2,x
+	
	RTS
	
.cambio
	LDA $151C,x
	BEQ .ret
	LDA #$02
	STA $C2,x ;si mario no esta mirando hacia met y el timer no esta puesto, se pasa al estado 2 levantarse
	RTS
.ret
	LDA #$30
	STA $1534,x
	LDA #$01
	STA $151C,x
	RTS
	
;esconderse
est1:
	STZ $B6,x
	LDA $1510,x ;si el frame es 0, pasa al estado 0 y pone el timer para estar escondido
	BNE .ret
	
	STZ $C2,x
	JSL $01ACF9
	LDA $148D
	ORA #$4F
	STA $1534,x
.ret
	RTS
;levantarse
est2:
	STZ $B6,x
	LDA $1602,x
	BNE .par
	
	
	LDA $76
	CMP $157C,x ;checkea la direccion de mario
	BNE +
	
.par
	
	LDA $1FD6,x
	BNE .cont
	
	LDA #$01
	STA $C2,x ;si mario esta viendo hacia met entonces se vuelve a esconder
	RTS
.cont

	LDA $1510,x
	CMP #$07
	BCC .ret
	
	JSR invocar
	
	LDA #$01 ;si el frame es 5 o mas met se pone a caminar
	STA $C2,x		
	RTS
	
+
	LDA $1510,x
	CMP #$07
	BCC .ret
	LDA #$03 ;si el frame es 5 o mas met se pone a caminar
	STA $C2,x	
.ret
	RTS
	
;caminar
est3:
	LDA $1602,x
	BNE .par
	
	LDA $76
	CMP $157C,x ;checkea la direccion de mario
	BNE +
.par
	STZ $B6,x
	LDA #$01
	STA $C2,x ;si mario esta viendo hacia met entonces se vuelve a esconder
	RTS
	
+	
	LDA $1510,x ;si el frame es menor que 6 retorna
	CMP #$08
	BCC .ret
	
	LDA $157C,x
	BEQ + ;si la direccion es derecha camina hacia la derecha, sino hacia la izquierda
	
	LDA #$E8
	STA $B6,x	
	RTS
+
	LDA #$18
	STA $B6,x
.ret
	RTS
	

;===================================
;interaction
;===================================

colisionPared:
	STZ $1602,x
	LDA $E4,x
	STA $00
	
	LDA $14E0,x
	STA $01
	
	LDA $D8,x
	STA $02
	
	LDA $14D4,x
	STA $03
	
	LDA $157C,x ;checkea la direccion de mario
	BEQ +

	REP #$20
	LDA $00
	CLC
	ADC #$0004
	AND #$FFF0
	STA $9A
	
	LDA $02
	CLC
	ADC #$0008
	AND #$FFF0
	STA $98
	
	SEP #$20
	
	JSL !blockInfo
	REP #$20
	LDA $02
	AND #$0140
	CMP #$0140
	SEP #$20
	BNE ++
	LDA #$01
	STA $1602,x
++
	
	RTS
+

	REP #$20
	LDA $00
	CLC
	ADC #$0014
	AND #$FFF0
	STA $9A
	
	LDA $02
	CLC
	ADC #$0008
	AND #$FFF0
	STA $98
	
	SEP #$20
	
	JSL !blockInfo
	REP #$20
	LDA $02
	AND #$0140
	CMP #$0140
	SEP #$20
	BNE +
	LDA #$01
	STA $1602,x
+
	RTS
	
;detecta la colision con mario	
colisionMario:
	
	LDA $1510,x
	CMP #$0C
	BCS .ret

	JSL !spriteFirstX

	JSL !marioSecond
	
	REP #$20
	LDA #$0012
	STA $08
	LDA #$0008
	STA $0A
	LDA #$0008
	STA $0C
	LDA #$001A
	STA $0E
	SEP #$20

	JSL !contact
	BCC .ret
	JSR daniarMario
.ret
	RTS
	
daniarMario:
	LDA $1497
	BNE .ret	

	LDA #$02
	JSL !mmxDamage
.ret
	RTS
	
detectChargedBuster:
	LDA $1510,x
	CMP #$0C
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

	LDA $1510,x
	CMP #$02
	BCS +
	JSL !chargedBusterKill
	BRA ++
+
	LDA #$01
	STA $1528,x
	JSR daniar
++
.next
	PLX
	
.ret
	RTS
	
;busca la bala que esta colisionando con el sprite
detectarBala:
	LDA $1510,x
	CMP #$0C
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
	LDA #$0010
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
daniar:
	
	LDA $1510,x
	CMP #$02
	BCC .ret
	
	LDA $1594,x 
	BNE .ret
	
	LDA $00
	CMP #$07
	BEQ .startDeath
	LDA #$04
	STA $1594,x 
	DEC $1528,x
	LDA $1528,x
	BEQ .startDeath
	RTS	
	
.startDeath
	LDA #$0C
	STA $1510,x
	LDA #$01
	STA $163E,x
	LDA #$2C
	STA $1DF9
	RTS
.ret
	LDA $00
	STA $0E95,y
	
	LDA #$00
	STA $0EB5,y
	STA $1747,y
	RTS
	
;===================================
;spawn
;===================================

invocar:

	LDY #$04
.loop
	LDA $1892,y
	BNE .next
	
	LDA !Bullet
	STA $1892,y
	
	LDA $E4,x
	STA $08
	
	LDA $14E0,x
	STA $09
	
	LDA $D8,x
	STA $0A
	
	LDA $14D4,x
	STA $0B
	
	LDA $157C,x
	REP #$20
	BEQ +
	
	LDA $08
	CLC
	ADC #$0004
	BRA .cont
+
	LDA $08
	CLC
	ADC #$000C
.cont	
	STA $08
	SEC
	SBC $94
	SEC
	SBC #$0008
	STA $00
	
	LDA $0A
	CLC
	ADC #$0009
	STA $0A
	SEC
	SBC $96
	SEC
	SBC #$0010
	STA $02
	
	SEP #$20
	
	LDA #$20
	JSL !aiming

	JSR setearCosas
	
	LDA #$01 ; \ Run cluster sprite routine.
	STA $18B8
	RTS
.next
	DEY
	BPL .loop
	RTS

setearCosas:
	LDA $00
	STA $0F72,y
	
	LDA $02
	STA $0F5E,y
	
	LDA $08
	STA $1E16,y
	
	LDA $09
	STA $1E3E,y
	
	LDA $0A
	STA $1E02,y
	
	LDA $0B
	STA $1E2A,y
	
	LDA #$00
	STA $0F86,y
	STA $1E52,y
	STA $1E66,y
	RTS
			

;====================================================
;================Graphics Routine====================
;====================================================

props:	db $27,$27 ;f1
		db $27,$27 ;f2
		db $27,$27 ;f1
		db $27,$27 ;f2
		db $27,$67,$27,$27 ;f3
		db $27,$67,$27,$27 ;f4
		db $27,$67,$27,$27 ;f3
		db $27,$67,$27,$27 ;f4
		db $27,$27,$67,$67 ;f7
		db $27,$27,$27,$27 ;f6
		db $27,$27,$27,$27 ;f7
		db $27,$27,$27,$27 ;f6
		db $2C,$6C,$AC,$EC ;ex1
		db $2C,$6C,$AC,$EC ;ex2
		db $2C,$6C,$AC,$EC ;ex1
		db $2C,$6C,$2C,$6C ;ex3
		db $2C,$6C,$2C,$6C ;ex4
		db $2C,$6C,$2C,$6C ;ex5
		db $2C,$6C,$2C,$6C ;ex6
		db $2C,$6C,$2C,$6C ;ex7
		db $2C,$6C ;ex8

tiles: 	db $00,$40 ;f1
		db $02,$60 ;f2
		db $00,$40 ;f1
		db $02,$60 ;f2
		db $04,$41,$67,$69 ;f3
		db $20,$61,$47,$49 ;f4
		db $04,$41,$67,$69 ;f3
		db $20,$61,$47,$49 ;f4
		db $22,$43,$6A,$6C ;f5
		db $24,$63,$4B,$4C ;f6
		db $26,$28,$45,$6E ;f7
		db $24,$63,$4B,$4C ;f6
		db $63,$63,$63,$63 ;ex1
		db $C2,$C2,$C2,$C2 ;ex2
		db $63,$63,$63,$63 ;ex1
		db $C4,$C4,$E0,$E0 ;ex3
		db $C6,$C6,$E2,$E2 ;ex4
		db $C8,$C8,$E4,$E4 ;ex5
		db $CA,$CA,$E6,$E6 ;ex6
		db $CC,$CC,$E8,$E8 ;ex7
		db $CE,$CE ;ex8
		
xDisp: 	db $08,$F8 ;f1
		db $08,$F8 ;f2
		db $08,$F8 ;f1
		db $08,$F8 ;f2
		db $08,$F8,$08,$F8 ;f3
		db $08,$F8,$08,$F8 ;f4
		db $08,$F8,$08,$F8 ;f3
		db $08,$F8,$08,$F8 ;f4
		db $08,$F8,$F8,$08 ;f5
		db $08,$F8,$08,$00 ;f6
		db $08,$F8,$08,$F8 ;f7
		db $08,$F8,$08,$00 ;f6
		db $00,$08,$00,$08 ;ex1
		db $F8,$08,$F8,$08 ;ex2
		db $00,$08,$00,$08 ;ex1
		db $F8,$08,$F8,$08 ;ex3
		db $F8,$08,$F8,$08 ;ex4
		db $F8,$08,$F8,$08 ;ex5
		db $F8,$08,$F8,$08 ;ex6
		db $F8,$08,$F8,$08 ;ex7
		db $F8,$08 ;ex8
		db $00,$10 ;f1
		db $00,$10 ;f2
		db $00,$10 ;f1
		db $00,$10 ;f2
		db $00,$10,$00,$10 ;f3
		db $00,$10,$00,$10 ;f4
		db $00,$10,$00,$10 ;f3
		db $00,$10,$00,$10 ;f4
		db $00,$10,$10,$00 ;f5
		db $00,$10,$00,$08 ;f6
		db $00,$10,$00,$10 ;f7
		db $00,$10,$00,$08 ;f6
		db $00,$08,$00,$08 ;ex1
		db $F8,$08,$F8,$08 ;ex2
		db $00,$08,$00,$08 ;ex1
		db $F8,$08,$F8,$08 ;ex3
		db $F8,$08,$F8,$08 ;ex4
		db $F8,$08,$F8,$08 ;ex5
		db $F8,$08,$F8,$08 ;ex6
		db $F8,$08,$F8,$08 ;ex7
		db $F8,$08 ;ex8
		
yDisp:	db $00,$00 ;f1
		db $00,$00 ;f2
		db $00,$00 ;f1
		db $00,$00 ;f2
		db $00,$00,$F0,$F0 ;f3
		db $00,$00,$F0,$F0 ;f4
		db $00,$00,$F0,$F0 ;f3
		db $00,$00,$F0,$F0 ;f4
		db $00,$00,$F0,$F0 ;f5
		db $00,$00,$F0,$F0 ;f6
		db $00,$00,$F0,$F0 ;f7
		db $00,$00,$F0,$F0 ;f6
		db $F8,$F8,$00,$00 ;ex1
		db $F0,$F0,$00,$00 ;ex2
		db $F8,$F8,$00,$00 ;ex1
		db $F0,$F0,$00,$00 ;ex3
		db $F0,$F0,$00,$00 ;ex4
		db $F0,$F0,$00,$00 ;ex5
		db $F0,$F0,$00,$00 ;ex6
		db $F0,$F0,$00,$00 ;ex7
		db $F0,$F0 ;ex8
		
tilesT: db $01,$01,$01,$01,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$01
TamanT: db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$00,$02,$00,$02,$02,$02,$02,$02,$02		
iniPosT: db $01,$03,$05,$07,$0B,$0F,$13,$17,$1B,$1F,$23,$27,$2B,$2F,$33,$37,$3B,$3F,$43,$47,$49
finPosT: db $00,$02,$04,$06,$08,$0C,$10,$14,$18,$1C,$20,$24,$28,$2C,$30,$34,$38,$3C,$40,$44,$48
;########################################################################
Graphics:
	JSL !GET_DRAW_INFO

	LDA $06 ;si la posicion no es valida retorna
	BEQ +
	RTS
+
	PHX
	
	STZ $02	
	LDA #$FF
	STA $0D
	
	LDA $1510,x
	CMP #$0C
	BCS .cont0
	
	LDA $1594,x ;si el timer de paleta es distinto de 0 usa la paleta F, sino la paleta A
	BEQ +
	LDA #$05
	STA $02
	LDA #$F1
	STA $0D 
+	
	
	LDA $157C,x
	BEQ .cont ;si esta mirando hacia la derecha no voltea nada, sino voltea hacia la izquierda
.cont0	
	LDA #$01
	STA $04 
	STZ $03
	BRA +
.cont
	LDA #$40
	STA $03
	STZ $04
+	
	LDA $1510,x
	TAX ;pone el puntero en x

	LDA finPosT,x
	STA $0A ;pone la posicion final a la que debe llegar
	
	LDA tilesT,x
	STA $0B ;pone la cantidad de tiles que debe usar
	
	LDA TamanT,x
	STA $0C ;pone el tamanio de los tiles

	LDA iniPosT,x
	TAX ;pone la posicion inicial que debe usar
	
.loop

	LDA $04
	BNE +
	LDA xDisp,x
	BRA .setX
+	
	PHX
	TXA
	CLC
	ADC #$4A
	TAX
	LDA xDisp,x
	PLX
.setX
	CLC
	ADC $00
	STA $0300,y
	
	LDA $01
	CLC
	ADC yDisp,x
	STA $0301,y

	LDA tiles,x
	STA $0302,y

	LDA props,x
	AND #$BF
	STA $05
	
	LDA props,x
	EOR $03
	AND #$40
	ORA $05
	AND $0D
	ORA $02
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
