header : lorom

incsrc headers/header.asm
incsrc headers/mmxheader.asm
incsrc ../exSprites/busterHeader.asm
incsrc ../exSprites/chargedBusterHeader.asm

org !mmxFreeSpace

db "ST","AR"			;
dw end-start-$01		;Rats tag que protegen tu data del LM
dw end-start-$01^$FFFF		;

start:

	JML mmxInit
	JML mmxCode
	JML mmxDamage
	JML mmxHeal
	JML mmxThrowItem
	
;Callable Routines	
mmxInit:
	PHB
	PHK
	PLB
	PHA
	PHX
	PHY
	JSR initMain
	PLY
	PLX
	PLA
	PLB
	RTL
	
	
mmxCode:
	PHB
	PHK
	PLB
	PHA
	PHX
	PHY
	JSR main
	PLY
	PLX
	PLA
	PLB
	RTL

;A = Damage
mmxDamage:
	PHA
	LDA !mmxDeathTimer
	BEQ +
	PLA
	RTL
+
	LDA $01,s
	CMP #$20
	BEQ ++
	
	LDA $1497
	BEQ +
	PLA
	RTL
	
+
	LDA !mmxDamTimer
	BEQ +
	PLA
	RTL
	
+
++
	LDA #$04
	STA $1DF9

	LDA !mmxCurrentHp
	SEC
	SBC $01,s
	BEQ .kill
	BPL +
.kill
	LDA !mmxDeadMaxTime
	STA !mmxDeathTimer
	
	LDA #$2A
	STA $1DFB
	LDA #$01
	STA $7FB001
	
	LDA #$00
+
	STA !mmxCurrentHp
	STA !mmxShowedHp
	
	LDA #$0B
	STA !mmxDamTimer 

	
	LDA $76
	STA !mmxDamDir
	PLA
	RTL
	
;A = Heal Amount
mmxHeal:

	ADC !mmxCurrentHp
	CMP #$20
	BCC +

	LDA #$20
	
+
	STA !mmxCurrentHp

	RTL
	
mmxThrowItem:

	JSL $01ACF9
	LDA $148D
	EOR $14
	AND #$07
	BEQ + 
	RTL
+
;Spawn a normal sprite.
	;Replace !SpriteNumber with the number of the sprite.
	LDA $186C,x
	BNE .EndSpawn
	JSL $02A9DE
	BMI .EndSpawn

	LDA #$01
	STA $14C8,y
	
	PHX
	TYX
	LDA !mmxHealSprite	; This the sprite number to spawn.
	STA $7FAB9E,x
	PLX
	
	LDA $00
	STA $00E4,y
	LDA $01
	STA $14E0,y
	
	LDA $02
	STA $00D8,y
	LDA $03
	STA $14D4,y
	
	PHX
	TYX
	JSL $07F7D2
	JSL $01ACF9
	LDA $148D
	EOR $14
	AND #$07
	BEQ +
	LDA #$0C
	STA $7FAB10,x
	PLX
	
	LDA #$A7
	STA $1570,y
	RTL
+
	LDA #$08
	STA $7FAB10,x
	
	PLX
.EndSpawn
	RTL
	
;Internal Routines
initMain:
	LDA #$FF
	STA $78
	JSR gfxChange
	JSR paletteChange

	LDA #$01
	STA $19 ;to use the Suit mario must be big
	
	LDA !mmxSpecialStart ;If player start from a midway or start of level reload all hp
	BNE +
	
	LDA !mmxHPMAX
	STA !mmxCurrentHp
+
	LDA !mmxCurrentHp 
	STA !mmxShowedHp ;hp showed = current hp
	
	LDA #$00
	STA !mmxConLastSt ;reset all variables
	STA !mmxBusterTimer
	STA !mmxChargeLevel
	STA !mmxDeathTimer
	STA !mmxDamDir
	STA !mmxBulletNum
	STA !mmxDamTimer
	STA !mmxWallJumpTimer
	STA !mmxConLastSt2
	STA !mmxWallJumpFlag
	STA !mmxLastBlocked
	STA !mmxBlockedCount
	STA !mmxYSpeedAdder
	STA !mmxYSpriteAdder
	STA !mmxYSpriteAdder+$01
	STA !mmxYFloor
	STA !mmxYFloor+$01
	STA $77
	
	LDA !mmxBusterMaxTime
	STA !mmxBusterTimer
	RTS


main:
	JSR hpBar
	JSR gfxChange
	JSR paletteChange
	LDA !mmxDeathTimer
	BEQ +
	JSR dead
	RTS
+
	JSR damage
	JSR busterTimer
	JSR charge
	JSR wallJump
	JSR hpUp
	LDA $15
	STA !mmxConLastSt
	LDA $0DA2
	STA !mmxConLastSt2

	RTS
	
hpUp:
	LDA $14
	AND #$03
	BNE +

	LDA !mmxShowedHp
	CMP !mmxCurrentHp
	BCS +
	INC A
	STA !mmxShowedHp
	CMP !mmxCurrentHp
	BNE ++
	LDA #$2F
	STA $1DF9
	RTS
++
	LDA #$2E
	STA $1DF9
+
	RTS
		
wallJump:

	LDA !mmxWallJumpFlag
	BPL +
	RTS
+
	LDA !mmxBlockedCount
	BPL +
	LDA #$00
	STA !mmxBlockedCount
	RTS
+

	LDA $7D
	BPL +
	RTS
+

	LDA $76
	TAX
	
	LDA !mmxWallJumpFlag
	BNE .init

	LDA $77
	AND .checker,x
	CMP .compare,x
	BNE +
	
	LDA #$04
	STA !mmxBlockedCount
	
	LDA #$01
	STA !mmxWallJumpFlag
	BRA ++
.init
	LDA $77
	AND .checker,x
	CMP .compare,x
	BNE ++

	LDA #$04
	STA !mmxBlockedCount
	
	LDA #$01
	STA !mmxWallJumpFlag
++
	LDA !mmxBlockedCount
	BEQ +
	DEC A
	STA !mmxBlockedCount
	
	LDA $15
	AND .compare,x
	BEQ +
	
	LDA #$10
	STA $7D
	
	LDA #$27
	STA $13E0
	
	LDA $0DA2
	AND #$80
	BEQ .ret	
	
	LDA !mmxConLastSt2
	AND #$80
	BNE .ret
	
	LDA #$B0
	STA $7D
	
	LDA .xSpeed,x
	STA $7B
	
+
	LDA #$00
	STA !mmxWallJumpFlag
.ret
	RTS
.checker
	db $06,$05
.compare
	db $02,$01
.xSpeed
	db $10,$F0
	
dead:
	LDX #$0B
.loop
	STZ $17F0,x
	DEX
	BPL .loop
	
	STZ $7B
	STZ $7D
	LDA #$FF
	STA $0DAA
	LDA !mmxDeathTimer
	BEQ +
	CMP !mmxDeadMaxTime
	BNE .con
	JSR deadBalls
.con
	LDA #$FF
	STA $78
	LDA !mmxDeathTimer
	DEC A
	STA !mmxDeathTimer
	BNE +
	LDA #$0B
	STA $0100
+
	RTS
	
velde: db $00,$FC,$F8,$F4,$F0,$EC,$E8,$E4,$E0,$DC,$D8,$D4
veliz: db $00,$04,$08,$0C,$10,$14,$18,$1C,$20,$24,$28,$2C
frame: db $30,$00,$30,$00,$30,$00,$30,$00,$30,$00,$30,$00
damage:
	LDA !mmxDamTimer
	BPL +
	LDA #$00
	STA !mmxDamTimer
	RTS
+
	BNE + 
	RTS
+
	TAX
	DEC A
	STA !mmxDamTimer
	CPX #$01
	BNE +
	LDA !mmxNoDamTimer
	STA $1497
	STZ $7D
+
	STZ $0DAA

	LDA #$FF
	STA $0DAA
	LDA frame,x
	STA $13E0
	
	LDA !mmxDamDir
	STA $76
	BEQ .izq
	LDA $77
	AND #$01
	BNE .ret
	
	LDA $77
	AND #$02
	BNE +
	LDA velde,x
	STA $7B
	RTS
+
	STZ $7B
	RTS
.izq
	LDA $77
	AND #$01
	BNE .ret
	LDA $77
	AND #$02
	BNE +
	LDA veliz,x
	STA $7B
	RTS
+
	STZ $7B
	RTS
.ret
	RTS
	
deadBalls:

	LDY #$13
.loop
	JSR summonDeadBall
	DEY
	CPY #$08
	BCS .loop

	RTS
	
summonDeadBall:
	LDA !mmxDeadBalls ; \ Custom cluster sprite 09.
	STA $1892,y ; /
	
	REP #$20
	LDA $96
	CLC
	ADC #$0008
	STA $00
	SEP #$20
	
	LDA $94
	STA $1E16,y	; | Store into X pos.
	LDA $95
	STA $1E3E,y
	
	LDA $00
	STA $1E02,y ; | Store into Y pos.
	LDA $01
	STA $1E2A,y
	
	LDA #$00
	STA $0F72,y
	STA $0F9A,y
	
	LDA #$04
	STA $1E7A,y
	
	JSL $01ACF9
	LDA $148D
	EOR $14
	AND #$03
	STA $0FAE,y
	STA $1E8E,y
	
	LDA .xspeed,y
	STA $0F5E,y
	
	LDA .yspeed,y
	STA $0F86,y
	
	LDA #$01 ; \ Run cluster sprite routine.
	STA $18B8 ; /

	RTS ; Return.
	
.xspeed
	db $00,$00,$00,$00,$00,$00,$00,$00,$20,$16,$00,$EA,$E0,$EA,$00,$16,$00,$10,$00,$F0
.yspeed
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$16,$20,$16,$00,$EA,$E0,$EA,$10,$00,$F0,$00

	
shootChargedBuster:

	LDY #$06
.ExtraLoop
	LDA $170B,y
	BEQ .Extra1
	RTS
.Extra1

	LDA #$06
	STA $149C
	
	LDA #$17
	STA $1DFC

	LDA !mmxChargedBuster
	STA $170B,y
	
	LDA $76
	ASL
	TAX
	
	REP #$20
	LDA $94
	CLC
	ADC .xAdder,x
	STA $00
	
	
	LDA $96
	CLC
	ADC #$000E
	STA $02
	SEP #$20
	
	LDA $00
	STA $171F,y
	LDA $01
	STA $1733,y
	
	LDA $02
	STA $1715,y
	LDA $03
	STA $1729,y
	
	LDX $76
	LDA .xSpeed,x
	CLC
	ADC $7B
	STA $00
	
	CPX #$01
	BNE +
	
	LDA $00
	CMP .xSpeed,x
	BCS +++
	CMP .xMaxSpeed,x
	BCC ++
	LDA .xMaxSpeed,x
	STA $00
	BRA ++
+++
	LDA .xSpeed,x
	STA $00
	BRA ++
	
+
	LDA $00
	CMP .xSpeed,x
	BCC +++
	CMP .xMaxSpeed,x
	BCS ++
	LDA .xMaxSpeed,x
	STA $00
	BRA ++
+++
	LDA .xSpeed,x
	STA $00
++
	LDA $00
	STA $1747,y
	LDA .dir,x
	STA !chargedBusterDirection,y
	LDA #$04
	STA !chargedBusterFrameTimer,y
	
	LDA !mmxYSpeedAdder
	STA $173D,y
	
	RTS
	
	
.xSpeed db $C0,$40
.xMaxSpeed db $A0,$60
.dir db $40,$00
.xAdder dw $FFF5,$000B
	
shootBuster:

	LDA $149C
	BEQ +

	RTS
	
+

	LDY #$09
.ExtraLoop
	LDA $170B,y
	BEQ .Extra1
	DEY
	CPY #$07
	BCS .ExtraLoop
	RTS
.Extra1

	LDA #$06
	STA $149C
	
	LDA #$06
	STA $1DFC

	LDA !mmxCommonBuster
	STA $170B,y
	
	LDA $76
	ASL
	TAX
	
	REP #$20
	LDA $94
	CLC
	ADC .xAdder,x
	STA $00
	
	
	LDA $96
	CLC
	ADC #$0012
	STA $02
	SEP #$20
	
	LDA $00
	STA $171F,y
	LDA $01
	STA $1733,y
	
	LDA $02
	STA $1715,y
	LDA $03
	STA $1729,y
	
	
	LDX $76
	LDA .xSpeed,x
	CLC
	ADC $7B
	STA $00
	
	CPX #$01
	BNE +
	
	LDA $00
	CMP .xSpeed,x
	BCS +++
	CMP .xMaxSpeed,x
	BCC ++
	LDA .xMaxSpeed,x
	STA $00
	BRA ++
+++
	LDA .xSpeed,x
	STA $00
	BRA ++
	
+
	LDA $00
	CMP .xSpeed,x
	BCC +++
	CMP .xMaxSpeed,x
	BCS ++
	LDA .xMaxSpeed,x
	STA $00
	BRA ++
+++
	LDA .xSpeed,x
	STA $00
++
	LDA $00
	STA $1747,y
	LDA .dir,x
	STA !busterDirection,y
	LDA #$00
	STA !busterFrameTimer,y
	
	LDA !mmxYSpeedAdder
	STA $173D,y
	
	RTS
.xSpeed db $D0,$30
.dir db $40,$00
.xAdder dw $FFFD,$000B
.xMaxSpeed db $B0,$50
	
charge:
	
	LDA $15
	AND #$40
	BEQ ++

	LDA !mmxConLastSt
	AND #$40
	BNE +
	
	LDA !mmxBusterMaxTime
	STA !mmxBusterTimer
	JSR shootBuster
	
+
	RTS
++
	LDA !mmxChargeLevel
	BEQ +
	JSR shootChargedBuster
+
	LDA #$00
	STA !mmxBusterTimer
	STA !mmxChargeLevel
	RTS
	
busterTimer:

	LDA !mmxBusterTimer
	BEQ +
	DEC A
	STA !mmxBusterTimer
	BNE +
	
	LDA #$01
	STA !mmxChargeLevel
	
+
	RTS
	
	
paletteChange:

	LDA !mmxChargeLevel
	BEQ +

	LDA $14
	AND #$03
	BNE +
	
	JSR chargePal
	
	RTS
+
	JSR normalPal
	RTS
	
lowbyte1: db $5F,$1D,$43,$72,$C0,$00,$20,$06,$DF,$11
highbyte1: db $63,$58,$56,$7F,$30,$69,$7A,$6F,$35,$00
lowbt1: db $FF,$00,$71,$9B,$7F
higbt1:	db $7F,$00,$0D,$1E,$3B
	
normalPal:

	LDA #$01  
	STA !marioPal  
	LDX #$09 
.loop  
	LDA lowbyte1,x  
	STA !marioPalLow,x  
	LDA highbyte1,x  
	STA !marioPalHigh,x  
	DEX  
	BPL .loop 
	
	LDA !paletteNumber
	STA $00
	CLC
	ADC #$05 ;putthe number of colors that you will change-1
	CMP #$80
	BCC +
	RTS
+
	STA !paletteNumber
	DEC A
	TAX
	LDY #$04 ;putthe number of colors that you will change-1
.loop1
	LDA cargas,y
	STA !paletteDestiny,x

	LDA lowbt1,y
	STA !paletteLow,x

	LDA higbt1,y
	STA !paletteHigh,x

	DEY
	DEX
	BMI +
	CPX $00
	BCS .loop1
+
	
	RTS 
	
lowbyte2: db $FF,$FF,$FF,$FF,$80,$E5,$FF,$FF,$DF,$11
highbyte2: db $FF,$FF,$FF,$FF,$7D,$61,$FF,$FF,$35,$00
cargas: db $81,$82,$83,$84,$85
lowbt2: db $FF,$86,$FF,$FF,$FF
higbt2:	db $7F,$66,$FF,$FF,$FF
	
chargePal:

	LDA #$01  
	STA !marioPal  
	LDX #$09 
.loop  
	LDA lowbyte2,x  
	STA !marioPalLow,x  
	LDA highbyte2,x  
	STA !marioPalHigh,x  
	DEX  
	BPL .loop 
	
	LDA !paletteNumber
	STA $00
	CLC
	ADC #$05 ;putthe number of colors that you will change-1
	CMP #$80
	BCC +
	RTS
+
	STA !paletteNumber
	DEC A
	TAX
	LDY #$04 ;putthe number of colors that you will change-1
.loop1
	LDA cargas,y
	STA !paletteDestiny,x

	LDA lowbt2,y
	STA !paletteLow,x

	LDA higbt2,y
	STA !paletteHigh,x

	DEY
	DEX
	BMI +
	CPX $00
	BCS .loop1
+
	
	RTS 
	
gfxChange:

	LDA #$01
	STA !marioNormalCustomGFXOn 
	
	PHB
	PLA 
	STA !marioNormalCustomGFXBnk 
	
	REP #$20
	
	LDA GFXPointer
	STA !marioNormalCustomGFXRec 
	
	SEP #$20

	RTS
	
GFXPointer:
	dw resource
	
resource:	
	incbin bins/mmxSuit.bin

;Display Hp Bar
hpBar:

	LDA !mmxShowedHp ;Load Hp that must be Showed in X
	TAX
	
	LDA .frameEnd,x
	STA $00 ;$00 = End of Loop
	
	LDA .frameStart,x ;X = Start Value
	TAX
	
.loop

	LDA .oam,x ; Load OAM Slot in Y
	TAY
	
	LDA !mmxHPBarX
	CLC
	ADC .xPos,x
	STA $0200,y ;Load tiles
	
	LDA !mmxHPBarY
	CLC
	ADC .yPos,x
	STA $0201,y
	
	LDA .tiles,x
	STA $0202,y
	
	LDA .prop,x
	STA $0203,y
	
	TYA
	LSR
	LSR	
	TAY
	LDA .size,x
	STA $0420,y
	
	DEX
	CPX #$FF
	BEQ +
	CPX $0000 ;Next
	BCS .loop	
+

	RTS
	
.frameStart
	db $05,$0D,$13,$1B,$21,$29,$2F,$37
	db $3D,$45,$4B,$53,$59,$61,$67,$6F
	db $75,$7D,$83,$8B,$91,$99,$9F,$A7
	db $AD,$B5,$BB,$C3,$C9,$D1,$D7,$DF
	db $E5
	
.frameEnd
	db $00,$06,$0E,$14,$1C,$22,$2A,$30
	db $38,$3E,$46,$4C,$54,$5A,$62,$68
	db $70,$76,$7E,$84,$8C,$92,$9A,$A0
	db $A8,$AE,$B6,$BC,$C4,$CA,$D2,$D8
	db $E0

.tiles
	db $24,$20,$20,$20,$20,$22 ;0
	db $24,$20,$20,$20,$20,$22,$71,$71 ;1
	db $24,$30,$20,$20,$20,$22 ;2
	db $24,$30,$20,$20,$20,$22,$70,$70 ;3
	db $24,$42,$20,$20,$20,$22 ;4
	db $24,$42,$20,$20,$20,$22,$71,$71 ;5
	db $24,$40,$20,$20,$20,$22 ;6
	db $24,$40,$20,$20,$20,$22,$70,$70 ;7
	
	db $24,$50,$20,$20,$20,$22 ;8
	db $24,$50,$20,$20,$20,$22,$71,$71 ;9
	db $24,$50,$30,$20,$20,$22 ;10
	db $24,$50,$30,$20,$20,$22,$70,$70 ;11
	db $24,$50,$42,$20,$20,$22 ;12
	db $24,$50,$42,$20,$20,$22,$71,$71 ;13
	db $24,$50,$40,$20,$20,$22 ;14
	db $24,$50,$40,$20,$20,$22,$70,$70 ;15
	
	db $24,$50,$50,$20,$20,$22 ;16
	db $24,$50,$50,$20,$20,$22,$71,$71 ;17
	db $24,$50,$50,$30,$20,$22 ;18
	db $24,$50,$50,$30,$20,$22,$70,$70 ;19
	db $24,$50,$50,$42,$20,$22 ;20
	db $24,$50,$50,$42,$20,$22,$71,$71 ;21
	db $24,$50,$50,$40,$20,$22 ;22
	db $24,$50,$50,$40,$20,$22,$70,$70 ;23
	
	db $24,$50,$50,$50,$20,$22 ;24
	db $24,$50,$50,$50,$20,$22,$71,$71 ;25
	db $24,$50,$50,$50,$30,$22 ;26
	db $24,$50,$50,$50,$30,$22,$70,$70 ;27
	db $24,$50,$50,$50,$42,$22 ;28
	db $24,$50,$50,$50,$42,$22,$71,$71 ;29
	db $24,$50,$50,$50,$40,$22 ;30
	db $24,$50,$50,$50,$40,$22,$70,$70 ;31
	
	db $24,$50,$50,$50,$50,$22 ;32
	
.yPos
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$F8,$F8
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$F8,$F8
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$F0,$F0
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$F0,$F0
	
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$E8,$E8
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$E8,$E8
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$E0,$E0
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$E0,$E0
	
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$D8,$D8
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$D8,$D8
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$D0,$D0
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$D0,$D0
	
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$C8,$C8
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$C8,$C8
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$C0,$C0
	db $00,$F0,$E0,$D0,$C0,$B0
	db $00,$F0,$E0,$D0,$C0,$B0,$C0,$C0
	
	db $00,$F0,$E0,$D0,$C0,$B0
	
.xPos
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	db $00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$08
	
	db $00,$00,$00,$00,$00,$00
	
.prop
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	db $3E,$3E,$3E,$3E,$3E,$3E
	db $3E,$3E,$3E,$3E,$3E,$3E,$3E,$7E
	
	db $3E,$3E,$3E,$3E,$3E,$3E
	
.size
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	db $02,$02,$02,$02,$02,$02
	db $02,$02,$02,$02,$02,$02,$00,$00
	
	db $02,$02,$02,$02,$02,$02
	
.oam
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	db $08,$0C,$10,$14,$18,$1C
	db $08,$0C,$10,$14,$18,$1C,$00,$04
	
	db $08,$0C,$10,$14,$18,$1C
	
end:


