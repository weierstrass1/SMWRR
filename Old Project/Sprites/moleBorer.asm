PRINT "INIT ",pc
incsrc sprites\header.asm
incsrc parches\headers\mmxheader.asm
incsrc exSprites\chargedBusterHeader.asm
incsrc exSprites\busterHeader.asm
;Point to the current frame
!FramePointer = $C2,x

;Point to the current frame on the animation
!AnFramePointer = $1504,x

;Point to the current animation
!AnPointer = $1510,x

;Time for the next frame change
!AnimationTimer = $1540,x

!GlobalFlipper = $1534,x

!LocalFlipper = $1570,x

!currentHp = $151C,x

!palTimer = $154C,x

!deadTimer = $1564,x

!stop = $1594,x

!deadMaxTime = #$61
!cluster = #$0C 
!explosion = #$0F

!maxHp = #$14

STZ !deadTimer
STZ !stop
STZ !palTimer

LDA !maxHp
STA !currentHp

LDA #$01
STA !GlobalFlipper
STA !LocalFlipper

STZ !FramePointer
STZ !AnPointer
STZ !AnFramePointer
LDA #$03
STA !AnimationTimer

LDA #$14
STA $B6,x

RTL

PRINT "MAIN ",pc

PHB
PHK
PLB
JSR SpriteCode
PLB
RTL

;===================================
;Sprite Function
;===================================

Return:
	RTS

SpriteCode:

	JSR dead
	LDA $00
	BNE +
	JSR Graphics ;graphic routine
+
	LDA $14C8,x			;\
	CMP #$08			; | If sprite dead,
	BNE Return			;/ Return.

	LDA $9D				;\
	BNE Return			;/ If locked, return.
	JSL !SUB_OFF_SCREEN_X0
	
	LDA !stop
	BEQ +
	LDA !deadTimer
	BNE +
	JSR InvHumo
	JSR checkBuster
	JSR checkChargedBuster
	JSR InteractionWithMario
	PHX
	JSR breakBlocks
	PLX
	JSR GraphicManager ;manage the frames of the sprite and decide what frame show
	JSR shake
	JSL $018022
	RTS
+
	JSR startRun
	RTS
	
startRun:

	REP #$20
	LDA $96
	CMP #$0120
	SEP #$20
	BCC +
	LDA #$01
	STA !stop
+
	RTS
	
dead:
	STZ $00
	LDA !deadTimer
	BEQ .ret
	TAY
	CMP #$01
	BNE +
	STZ $14C8,x	
+
	LDA .deadTable00,y
	STA $00
	LDA !deadTimer
	AND #$01
	STA !palTimer
	JSR Explosion
.ret
	RTS
.deadTable00 	
		db $00,$00,$01,$00,$01,$00,$01,$00,$01,$00,$01,$00,$01,$00,$01,$00
		db $00,$01,$00,$00,$01,$00,$00,$01,$00,$00,$00,$01,$00,$00,$00,$01
		db $00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00
		db $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00
		db $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		db $00
		
Explosion:
	LDA $14
	AND #$07
	BEQ +
	RTS
+
	LDY #$04
.loop
	
	LDA $1892,y
	BEQ +
	JMP .next
+
	LDA !explosion
	STA $1892,y
	
	LDA #$1A
	STA $1DFC
	
	LDA #$00
	STA $0FAE,y
	STA $1E8E,y
	STA $0F86,y
	LDA #$01
	STA $1E7A,y
	
	JSL !spriteFirstX
	
	JSL $01ACF9	
	LDA $148D
	AND #$01
	SEC
	SBC #$01
	STA $05
	BMI +
	JSL $01ACF9	
	LDA $148D
	AND #$1F
	STA $04
	BRA ++
+
	JSL $01ACF9	
	LDA $148D
	ORA #$E0
	STA $04
++	
	JSL $01ACF9	
	LDA $148D
	AND #$01
	SEC
	SBC #$01
	STA $07
	BMI +
	JSL $01ACF9	
	LDA $148D
	AND #$0F
	STA $06
	BRA ++
+
	JSL $01ACF9	
	LDA $148D
	ORA #$E0
	STA $06
++	
	
	REP #$20
	
	LDA $00
	CLC
	ADC $04
	STA $00
	
	LDA $02
	CLC
	ADC $06
	STA $02
	SEP #$20
	
	LDA $00
	STA $1E16,y
	
	LDA $01
	STA $1E3E,y
	
	LDA $02
	STA $1E02,y
	LDA $03
	STA $1E2A,y
	BRA .quit
	
.next	
	DEY
	BMI .ret
	JMP .loop
.quit
	
	LDA #$01 ; \ Run cluster sprite routine.
	STA $18B8
.ret
	RTS
		
InvHumo:
	LDA !currentHp
	BEQ +
	RTS
+
	LDA $14
	AND #$07
	BEQ +
	RTS
+
	LDY #$07
.loop
	
	LDA $1892,y
	BEQ +
	JMP .next
+
	LDA !cluster
	STA $1892,y
	
	LDA #$00
	STA $0F72,y
	
	LDA #$04
	STA $1E66,y
	
	JSL !spriteFirstX
	
	JSL $01ACF9	
	LDA $148D
	AND #$01
	SEC
	SBC #$01
	STA $05
	BMI +
	JSL $01ACF9	
	LDA $148D
	AND #$1F
	STA $04
	BRA ++
+
	JSL $01ACF9	
	LDA $148D
	ORA #$E0
	STA $04
++	
	JSL $01ACF9	
	LDA $148D
	AND #$01
	SEC
	SBC #$01
	STA $07
	BMI +
	JSL $01ACF9	
	LDA $148D
	AND #$0F
	STA $06
	BRA ++
+
	JSL $01ACF9	
	LDA $148D
	ORA #$E0
	STA $06
++	
	
	REP #$20
	
	LDA $00
	CLC
	ADC $04
	STA $00
	
	LDA $02
	CLC
	ADC $06
	STA $02
	SEP #$20
	
	LDA $00
	STA $1E16,y
	
	LDA $01
	STA $1E3E,y
	
	LDA $02
	STA $1E02,y
	LDA $03
	STA $1E2A,y
	BRA .quit
	
.next	
	DEY
	CPY #$05
	BCC .ret
	JMP .loop
.quit
	
	LDA #$01 ; \ Run cluster sprite routine.
	STA $18B8
.ret
	RTS
	
breakBlocks:

	LDA $E4,x
	STA $0C
	LDA $14E0,x
	STA $0D
	LDA $D8,x
	STA $0E
	LDA $14D4,x
	STA $0F
	
	LDA !GlobalFlipper
	ASL ;2
	ASL ;4
	ASL ;8
	ASL ;10
	ORA !FramePointer
	ASL
	TAY
	
	LDA #$00
	STA $01
	LDA !AnimationTimer
	ASL
	ASL
	STA $00
	
	LDA #$00
	PHA ;$09,s
	REP #$20
	
	LDA $0C
	CLC
	ADC .xPos,y
	CLC
	ADC #$FFF4
	CLC
	ADC $00
	PHA	;$07,s
	
	LDA $0E
	CLC
	ADC .yPos,y
	CLC
	ADC #$FFEC
	CLC
	ADC $00
	PHA	;$05,s
	
	LDA #$0020
	PHA ;$03,s
	
	SEP #$20
.xloop

	REP #$20
	LDA #$0020
	PHA ;$01,s
	SEP #$20
	
.yloop
		REP #$20
		LDA $07,s
		CLC
		ADC $03,s
		AND #$FFF0
		STA $9A
		
		LDA $05,s
		CLC
		ADC $01,s
		AND #$FFF0
		STA $98
		SEP #$20
	
		JSL !blockInfo
		REP #$20
		LDA $02
		CMP #$0051
		BEQ .killEmpty
		CMP #$0141
		BEQ .killEmpty
		CMP #$0052
		BEQ .killBlack
		CMP #$0144
		BEQ .killBlack
		BRA .next
.killEmpty
		SEP #$20
		LDA #$01
		STA $09,s
		REP #$10
		LDX #$2735
		JSR ChangeMap16
		SEP #$10

		BRA .next
.killBlack
		SEP #$20
		LDA #$01
		STA $09,s
		REP #$10
		LDX #$2708
		JSR ChangeMap16
		SEP #$10
.next
		REP #$20
		LDA $01,s
		CLC
		ADC #$FFF0
		STA $01,s
		SEP #$20
		BPL .yloop
	REP #$20
	LDA $03,s
	CLC
	ADC #$FFF0
	STA $03,s
	PLA
	SEP #$20
	BPL .xloop
	
	
	LDA $07,s
	BEQ +
	
	REP #$20
	LDA $05,s
	CLC
	ADC #$0010
	AND #$FFF0
	STA $9A
		
	LDA $03,s
	CLC
	ADC #$0010
	AND #$FFF0
	STA $98
	SEP #$20
	
	PHB
	LDA #$02
	PHA
	PLB
	LDA #$00             ; Set to 01 for rainbow explosion.
	JSL $028663
	PLB
	
+
	
	REP #$20
	PLA
	PLA
	PLA
	SEP #$20
	PLA
	RTS
	
.xPos	dw $FFC2,$FFC6,$FFBC,$FFC0,$FFC8,$FFCC,$FFEA,$FFEE,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dw $0030,$0034,$0036,$003A,$0026,$002A,$0002,$0006
.yPos	dw $0004,$0000,$FFF4,$FFF0,$FFD0,$FFCC,$FFC4,$FFC0,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000
		dw $0004,$0000,$FFF4,$FFF0,$FFD0,$FFCC,$FFC4,$FFC0

shake:

	LDA $14
	AND #$03
	ASL
	TAY

	REP #$20
	LDA $1464
	CLC
	ADC .yAdder,y
	STA $1464
	SEP #$20

	RTS
.yAdder dw $0001,$FFFF,$FFFF,$0001 
	
;===================================
;Graphic Manager
;===================================	
GraphicManager:

	;if !AnimationTimer is Zero go to the next frame
	LDA !AnimationTimer
	BEQ ChangeFrame
	RTS

ChangeFrame:

	;Load the animation pointer X2
	LDA !AnPointer
	
	REP #$30
	AND #$00FF
	TAY
	
	
	LDA !AnFramePointer
	CLC
	ADC EndPositionAnim,y
	TAY
	SEP #$30
	
	LDA AnimationsFrames,y
	STA !FramePointer
	
	LDA AnimationsNFr,y
	STA !AnFramePointer
	
	LDA AnimationsTFr,y
	STA !AnimationTimer
	
	LDA !GlobalFlipper
	EOR AnimationsFlips,y
	STA !LocalFlipper
	
	RTS	


;===================================
;Animation
;===================================
EndPositionAnim:
	dw $0000

AnimationsFrames:
runFrames:
	db $00,$01,$02,$03,$04,$05,$06,$07,$04,$05,$02,$03

AnimationsNFr:
runNext:
	db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$00

AnimationsTFr:
runTimes:
	db $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03

AnimationsFlips:
runFlip:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00


;===================================
;Interaction
;===================================
checkChargedBuster:
	LDA !AnPointer
	CMP #$08
	BEQ .ret

	LDY #$06

.loop
	PHX
	LDA $170B,y
	CMP !mmxChargedBuster
	BNE .next
	
	LDA $1715,y
	STA $00
	LDA $1729,y
	STA $01
	
	LDA $171F,y
	STA $0C
	LDA $1733,y
	STA $0D
	
	JSR InteractionWithchargedBuster
	
.next
	PLX
.ret
	RTS

InteractionWithchargedBuster:
	PHY
	LDA !FramePointer
	TAY
	LDA TotalHitboxes,y
	BPL +
	PLY
	RTS
+
	LDA !LocalFlipper
	TAY
	LDA !FramePointer
	CLC
	ADC FlipAdder,y
	REP #$30
	AND #$00FF
	CLC
	ASL
	TAY ;load the frame pointer on X
	
	LDA StartPositionHitboxes,y
	STA $08
	
	LDA EndPositionHitboxes,y
	STA $0A
	
	LDA #$0000 ;load y disp of mario on $04
	STA $04
	
	LDA $00
	CLC
	ADC $04
	STA $04 ;$04 is position + ydisp
	BPL +
	LDA #$0000 ;if $04 is negative then change it to 0
+
	STA $04 
	
	LDA $04
	CLC
	ADC #$000E
	STA $06 ;$06 = bottom
	
	LDA $06
	BPL +
	SEP #$20
	PLY
	RTS
+

	SEP #$20
	
	LDA $E4,x
	STA $00
	LDA $14E0,x
	STA $01
	
	LDA $D8,x
	STA $02
	LDA $14D4,x
	STA $03
	
	REP #$30
	
	LDY $0008
	
.loop

	LDA $00
	CLC
	ADC FramesHitboxXDisp,y
	STA $0E
	CLC
	ADC FramesHitboxWidth,y
	BMI .next ;if x + xdisp + width < xMario || x + xdisp + width < 0 then goto next
	CMP $0C
	BCC .next
	
	LDA $0E
	BPL +
	STZ $000E ;if x+xdisp < 0 then x+xdisp = 0
+
	
	LDA $0C
	CLC
	ADC #$000E
	CMP $0E
	BCC .next ;if xMario + widthMario < x+xdisp then goto next
	
	LDA $02
	CLC
	ADC FramesHitboxYDisp,y
	STA $0E
	CLC
	ADC FramesHitboxHeigth,y
	BMI .next
	CMP $04
	BCC .next ;if y + ydisp + height < yMario + ydispMario || y + ydisp + height < 0 then goto next

	LDA $0E
	BPL +
	STZ $000E ;if y + ydisp < 0 then y + ydisp = 0
+	
	LDA $06
	CMP $0E
	BCC .next ;if yMario + ydispMario + heigthMario < y + ydisp then gotonext
	
	STY $000E
	SEP #$30
	PLY
	JSR damageB ;make action of this hitbox
	PHY
	REP #$30
	LDY $000E
.next
	DEY
	DEY
	BMI .ret
	CPY $0A
	BCS .loop
.ret	
	SEP #$30
	PLY
RTS

damageB:

	JSL !chargedBusterKill
	
	LDA !palTimer
	BNE +

	REP #$20
	LDA $0E
	CMP $08
	SEP #$20
	BEQ +
	
	LDA #$04
	STA !palTimer
	
	LDA !currentHp
	BEQ .dead
	SEC
	SBC #$04
	STA !currentHp
	BEQ .dead
	BMI .dead
+
	RTS
.dead
	STZ !currentHp
	LDA $14E0,x
	PHA
	LDA $E4,x
	PHA
	REP #$20
	PLA
	CMP #$08F0
	SEP #$20
	BCC +
	STZ !palTimer
	LDA !deadMaxTime
	STA !deadTimer
+
	
	RTS

checkBuster:
	LDA !AnPointer
	CMP #$08
	BEQ .ret

	LDY #$09

.loop
	PHX
	LDA $170B,y
	CMP !mmxCommonBuster
	BNE .next
	
	LDA $1715,y
	STA $00
	LDA $1729,y
	STA $01
	
	LDA $171F,y
	STA $0C
	LDA $1733,y
	STA $0D
	
	JSR InteractionWithBuster
	
.next
	PLX
	DEY
	CPY #$07
	BPL .loop
.ret
	RTS

InteractionWithBuster:
	PHY
	LDA !FramePointer
	TAY
	LDA TotalHitboxes,y
	BPL +
	PLY
	RTS
+
	LDA !LocalFlipper
	TAY
	LDA !FramePointer
	CLC
	ADC FlipAdder,y
	REP #$30
	AND #$00FF
	CLC
	ASL
	TAY ;load the frame pointer on X
	
	LDA StartPositionHitboxes,y
	STA $08
	
	LDA EndPositionHitboxes,y
	STA $0A
	
	LDA #$0000 ;load y disp of mario on $04
	STA $04
	
	LDA $00
	CLC
	ADC $04
	STA $04 ;$04 is position + ydisp
	BPL +
	LDA #$0000 ;if $04 is negative then change it to 0
+
	STA $04 
	
	LDA $04
	CLC
	ADC #$0006
	STA $06 ;$06 = bottom
	
	LDA $06
	BPL +
	SEP #$20
	PLY
	RTS
+

	SEP #$20
	
	LDA $E4,x
	STA $00
	LDA $14E0,x
	STA $01
	
	LDA $D8,x
	STA $02
	LDA $14D4,x
	STA $03
	
	REP #$30
	
	LDY $0008
	
.loop

	LDA $00
	CLC
	ADC FramesHitboxXDisp,y
	STA $0E
	CLC
	ADC FramesHitboxWidth,y
	BMI .next ;if x + xdisp + width < xMario || x + xdisp + width < 0 then goto next
	CMP $0C
	BCC .next
	
	LDA $0E
	BPL +
	STZ $000E ;if x+xdisp < 0 then x+xdisp = 0
+
	
	LDA $0C
	CLC
	ADC #$0006
	CMP $0E
	BCC .next ;if xMario + widthMario < x+xdisp then goto next
	
	LDA $02
	CLC
	ADC FramesHitboxYDisp,y
	STA $0E
	CLC
	ADC FramesHitboxHeigth,y
	BMI .next
	CMP $04
	BCC .next ;if y + ydisp + height < yMario + ydispMario || y + ydisp + height < 0 then goto next

	LDA $0E
	BPL +
	STZ $000E ;if y + ydisp < 0 then y + ydisp = 0
+	
	LDA $06
	CMP $0E
	BCC .next ;if yMario + ydispMario + heigthMario < y + ydisp then gotonext
	
	STY $000E
	SEP #$30
	PLY
	JSR damageS ;make action of this hitbox
	PHY
	REP #$30
	LDY $000E
.next
	DEY
	DEY
	BMI .ret
	CPY $0A
	BCS .loop
.ret	
	SEP #$30
	PLY
RTS

damageS:

	JSL !busterKill	
	
	LDA !palTimer
	BNE +
	
	REP #$20
	LDA $0E
	CMP $08
	SEP #$20
	BEQ +
	
	LDA #$04
	STA !palTimer
	
	LDA !currentHp
	BEQ .dead
	DEC A
	STA !currentHp
	BEQ .dead
+
	RTS
.dead
	LDA $14E0,x
	PHA
	LDA $E4,x
	PHA
	REP #$20
	PLA
	CMP #$08F0
	SEP #$20
	BCC +
	STZ !palTimer
	LDA !deadMaxTime
	STA !deadTimer
+
	RTS

InteractionWithMario:

	LDA !FramePointer
	TAY
	LDA TotalHitboxes,y
	BPL +
	RTS
+
	LDA !LocalFlipper
	TAY
	LDA !FramePointer
	CLC
	ADC FlipAdder,y
	REP #$30
	AND #$00FF
	CLC
	ASL
	TAY ;load the frame pointer on X
	
	LDA StartPositionHitboxes,y
	STA $08
	
	LDA EndPositionHitboxes,y
	STA $0A
	
	LDA #$000C ;load y disp of mario on $04
	STA $04
	
	LDA $19
	BEQ +
	LDA #$0004 ;if mario is big the y disp is 4
	STA $04
+
	LDA $96
	CLC
	ADC $04
	STA $04 ;$04 is position + ydisp
	BPL +
	LDA #$0000 ;if $04 is negative then change it to 0
+
	STA $04 
	
	LDA $04
	CLC
	ADC #$0014
	STA $06 ;$06 = bottom
	LDA $19
	BEQ +
	LDA $06
	CLC
	ADC #$0008
	STA $06 ;if mario is big then add 8 to bottom 
+	
	LDA $187A
	BEQ +
	LDA $06
	CLC
	ADC #$0010 ;if mario is riding yoshi then add 16 to bottom
	STA $06
+
	LDA $06
	BPL +
	SEP #$20
	RTS
+

	SEP #$20
	
	LDA $E4,x
	STA $00
	LDA $14E0,x
	STA $01
	
	LDA $D8,x
	STA $02
	LDA $14D4,x
	STA $03
	
	REP #$30
	
	LDY $08
	
.loop

	LDA $00
	CLC
	ADC FramesHitboxXDisp,y
	STA $0E
	CLC
	ADC FramesHitboxWidth,y
	BMI .next ;if x + xdisp + width < xMario || x + xdisp + width < 0 then goto next
	CMP $94
	BCC .next
	
	LDA $0E
	BPL +
	STZ $000E ;if x+xdisp < 0 then x+xdisp = 0
+
	
	LDA $94
	CLC
	ADC #$0010
	CMP $0E
	BCC .next ;if xMario + widthMario < x+xdisp then goto next
	
	LDA $02
	CLC
	ADC FramesHitboxYDisp,y
	STA $0E
	CLC
	ADC FramesHitboxHeigth,y
	BMI .next
	CMP $04
	BCC .next ;if y + ydisp + height < yMario + ydispMario || y + ydisp + height < 0 then goto next

	LDA $0E
	BPL +
	STZ $000E ;if y + ydisp < 0 then y + ydisp = 0
+	
	LDA $06
	CMP $0E
	BCC .next ;if yMario + ydispMario + heigthMario < y + ydisp then gotonext
	
	PHY
	LDA FramesHitboxAction,y
	STA $0E
	SEP #$30
	TXY
	LDX #$00
	JSR ($000E,x) ;make action of this hitbox
	REP #$30
	PLY
.next
	DEY
	DEY
	BMI .ret
	CPY $0A
	BCS .loop
.ret	
	SEP #$30
RTS

hurt:
	TYX
	
	LDA #$20
	JSL !mmxDamage
	
	RTS
;===================================
;Actions
;===================================
;===================================
;Graphic Routine
;===================================
FlipAdder: db $00,$08
Graphics:
	REP #$10
	LDY #$0000
	SEP #$10

	JSL !GET_DRAW_INFO
	LDA $06
	BEQ .cont ;if the sprite is off-screen don't draw it
	RTS
.cont

	STZ $0F
	LDA !palTimer
	BEQ +
	LDA #$02
	STA $0F
+
	PHX
	LDA !LocalFlipper
	PHA
	LDA !FramePointer
	PLX
	CLC
	ADC FlipAdder,x
	REP #$30

	AND #$00FF
	ASL
	TAX
	
	LDA EndPositionFrames,x
	STA $0D
	
	LDA StartPositionFrames,x
	TAX
	SEP #$20

.loop
	LDA FramesXDisp,x 
	CLC
	ADC $00
	STA $0300,y ;load the tile X position

	LDA FramesYDisp,x
	CLC
	ADC $01
	STA $0301,y ;load the tile Y position

	LDA FramesPropertie,x
	ORA $64
	ORA $0F
	STA $0303,y ;load the tile Propertie

	LDA FramesTile,x
	STA $0302,y ;load the tile

	INY
	INY
	INY
	INY ;next slot

	DEX
	BMI +
	CPX $0D
	BCS .loop ;if Y < 0 exit to loop
+
	SEP #$10
	PLX
	
	LDA !FramePointer
	TAY
	LDA FramesTotalTiles,y ;load the total of tiles on $0E
	LDY #$02 ;load the size
	JSL $01B7B3 ;call the oam routine
	RTS
	
;===================================
;Frames
;===================================
FramesTotalTiles:

	db $15,$15,$16,$16,$1A,$1A,$19,$19,$15,$15,$16,$16,$1A,$1A,$19,$19

StartPositionFrames:
	dw $0015,$002B,$0042,$0059,$0074,$008F,$00A9,$00C3,$00D9,$00EF,$0106,$011D,$0138,$0153,$016D,$0187

EndPositionFrames:
	dw $0000,$0016,$002C,$0043,$005A,$0075,$0090,$00AA,$00C4,$00DA,$00F0,$0107,$011E,$0139,$0154,$016E

TotalHitboxes:
	db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02

StartPositionHitboxes:
	dw $0004,$000A,$0010,$0016,$001C,$0022,$0028,$002E,$0034,$003A,$0040,$0046,$004C,$0052,$0058,$005E

EndPositionHitboxes:
	dw $0000,$0006,$000C,$0012,$0018,$001E,$0024,$002A,$0030,$0036,$003C,$0042,$0048,$004E,$0054,$005A

FramesXDisp:
frame1XDisp:
	db $E8,$E6,$E6,$F6,$F6,$06,$06,$16,$16,$F8,$08,$10,$CC,$CC,$BC,$BC,$FB,$FB,$DB,$DB,$EB,$EB
frame2XDisp:
	db $E8,$E6,$E6,$F6,$F6,$06,$06,$16,$16,$F8,$08,$10,$FB,$FB,$DB,$DB,$EB,$EB,$CC,$BC,$CC,$BC
frame3XDisp:
	db $E8,$E6,$E6,$F6,$F6,$06,$06,$16,$16,$F8,$08,$10,$FE,$EE,$EE,$D6,$D6,$DE,$DE,$C7,$B7,$C7,$B7
frame4XDisp:
	db $E8,$E6,$E6,$F6,$F6,$06,$06,$16,$16,$F8,$08,$10,$D6,$D6,$E6,$E6,$EE,$EE,$FE,$C7,$B7,$B7,$C7
frame5XDisp:
	db $E8,$D2,$DA,$D2,$E2,$D2,$E6,$E6,$F6,$F6,$06,$06,$16,$16,$F8,$08,$10,$03,$E6,$F6,$DE,$EE,$E6,$D6,$C6,$C6,$D6
frame6XDisp:
	db $E8,$E2,$D2,$D2,$DA,$E6,$E6,$F6,$F6,$06,$06,$16,$16,$F8,$08,$10,$03,$E6,$F6,$DE,$EE,$D2,$E6,$D6,$C6,$C6,$D6
frame7XDisp:
	db $E8,$ED,$EE,$E6,$E6,$F6,$F6,$06,$06,$16,$16,$F8,$08,$10,$F3,$F9,$F9,$FE,$00,$01,$F6,$06,$06,$E3,$E9,$E9
frame8XDisp:
	db $E8,$ED,$EE,$F3,$E3,$E6,$E6,$F6,$F6,$06,$06,$16,$16,$F8,$08,$10,$FE,$00,$01,$F9,$E9,$F9,$E9,$06,$06,$F6
frame1FlipXXDisp:
	db $18,$1A,$1A,$0A,$0A,$FA,$FA,$EA,$EA,$08,$F8,$F0,$34,$34,$44,$44,$05,$05,$25,$25,$15,$15
frame2FlipXXDisp:
	db $18,$1A,$1A,$0A,$0A,$FA,$FA,$EA,$EA,$08,$F8,$F0,$05,$05,$25,$25,$15,$15,$34,$44,$34,$44
frame3FlipXXDisp:
	db $18,$1A,$1A,$0A,$0A,$FA,$FA,$EA,$EA,$08,$F8,$F0,$02,$12,$12,$2A,$2A,$22,$22,$39,$49,$39,$49
frame4FlipXXDisp:
	db $18,$1A,$1A,$0A,$0A,$FA,$FA,$EA,$EA,$08,$F8,$F0,$2A,$2A,$1A,$1A,$12,$12,$02,$39,$49,$49,$39
frame5FlipXXDisp:
	db $18,$2E,$26,$2E,$1E,$2E,$1A,$1A,$0A,$0A,$FA,$FA,$EA,$EA,$08,$F8,$F0,$FD,$1A,$0A,$22,$12,$1A,$2A,$3A,$3A,$2A
frame6FlipXXDisp:
	db $18,$1E,$2E,$2E,$26,$1A,$1A,$0A,$0A,$FA,$FA,$EA,$EA,$08,$F8,$F0,$FD,$1A,$0A,$22,$12,$2E,$1A,$2A,$3A,$3A,$2A
frame7FlipXXDisp:
	db $18,$13,$12,$1A,$1A,$0A,$0A,$FA,$FA,$EA,$EA,$08,$F8,$F0,$0D,$07,$07,$02,$00,$FF,$0A,$FA,$FA,$1D,$17,$17
frame8FlipXXDisp:
	db $18,$13,$12,$0D,$1D,$1A,$1A,$0A,$0A,$FA,$FA,$EA,$EA,$08,$F8,$F0,$02,$00,$FF,$07,$17,$07,$17,$FA,$FA,$0A


FramesYDisp:
frame1yDisp:
	db $00,$EE,$FE,$EE,$FE,$EE,$F6,$EE,$F6,$00,$00,$00,$09,$F9,$09,$F9,$F6,$FE,$FE,$06,$FE,$06
frame2yDisp:
	db $00,$ED,$FD,$ED,$FD,$ED,$F5,$ED,$F5,$00,$00,$00,$F5,$FD,$FD,$05,$FD,$05,$08,$08,$F8,$F8
frame3yDisp:
	db $00,$EE,$FE,$EE,$FE,$EE,$F6,$EE,$F6,$00,$00,$00,$F1,$F1,$F9,$F1,$F9,$F1,$F9,$FC,$FC,$EC,$EC
frame4yDisp:
	db $00,$ED,$FD,$ED,$FD,$ED,$F5,$ED,$F5,$00,$00,$00,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$FB,$FB,$EB,$EB
frame5yDisp:
	db $00,$D9,$D9,$E9,$E9,$C9,$EE,$FE,$EE,$FE,$EE,$F6,$EE,$F6,$00,$00,$00,$F1,$E9,$E9,$D9,$D9,$C9,$C9,$C9,$D9,$D9
frame6yDisp:
	db $00,$E8,$E8,$D8,$D8,$ED,$FD,$ED,$FD,$ED,$F5,$ED,$F5,$00,$00,$00,$F0,$E8,$E8,$D8,$D8,$C8,$C8,$C8,$C8,$D8,$D8
frame7yDisp:
	db $00,$E2,$DA,$EE,$FE,$EE,$FE,$EE,$F6,$EE,$F6,$00,$00,$00,$CA,$C9,$B9,$F1,$E1,$D9,$C9,$C9,$B9,$CA,$B9,$C9
frame8yDisp:
	db $00,$E1,$D9,$C9,$C9,$ED,$FD,$ED,$FD,$ED,$F5,$ED,$F5,$00,$00,$00,$F0,$E0,$D8,$C8,$C8,$B8,$B8,$C8,$B8,$C8
frame1FlipXyDisp:
	db $00,$EE,$FE,$EE,$FE,$EE,$F6,$EE,$F6,$00,$00,$00,$09,$F9,$09,$F9,$F6,$FE,$FE,$06,$FE,$06
frame2FlipXyDisp:
	db $00,$ED,$FD,$ED,$FD,$ED,$F5,$ED,$F5,$00,$00,$00,$F5,$FD,$FD,$05,$FD,$05,$08,$08,$F8,$F8
frame3FlipXyDisp:
	db $00,$EE,$FE,$EE,$FE,$EE,$F6,$EE,$F6,$00,$00,$00,$F1,$F1,$F9,$F1,$F9,$F1,$F9,$FC,$FC,$EC,$EC
frame4FlipXyDisp:
	db $00,$ED,$FD,$ED,$FD,$ED,$F5,$ED,$F5,$00,$00,$00,$F0,$F8,$F0,$F8,$F0,$F8,$F0,$FB,$FB,$EB,$EB
frame5FlipXyDisp:
	db $00,$D9,$D9,$E9,$E9,$C9,$EE,$FE,$EE,$FE,$EE,$F6,$EE,$F6,$00,$00,$00,$F1,$E9,$E9,$D9,$D9,$C9,$C9,$C9,$D9,$D9
frame6FlipXyDisp:
	db $00,$E8,$E8,$D8,$D8,$ED,$FD,$ED,$FD,$ED,$F5,$ED,$F5,$00,$00,$00,$F0,$E8,$E8,$D8,$D8,$C8,$C8,$C8,$C8,$D8,$D8
frame7FlipXyDisp:
	db $00,$E2,$DA,$EE,$FE,$EE,$FE,$EE,$F6,$EE,$F6,$00,$00,$00,$CA,$C9,$B9,$F1,$E1,$D9,$C9,$C9,$B9,$CA,$B9,$C9
frame8FlipXyDisp:
	db $00,$E1,$D9,$C9,$C9,$ED,$FD,$ED,$FD,$ED,$F5,$ED,$F5,$00,$00,$00,$F0,$E0,$D8,$C8,$C8,$B8,$B8,$C8,$B8,$C8


FramesPropertie:
frame1Properties:
	db $29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$28,$28,$28,$29,$29,$29,$29,$29,$29
frame2Properties:
	db $29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$28,$28,$28
frame3Properties:
	db $29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$28,$28,$28
frame4Properties:
	db $29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$28,$28,$28
frame5Properties:
	db $29,$29,$29,$29,$29,$28,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$B9,$29,$29,$29,$29,$28,$28,$28,$28,$29
frame6Properties:
	db $29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$B9,$29,$29,$29,$29,$28,$28,$28,$28,$28,$29
frame9Properties:
	db $29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$28,$29,$28,$29,$29,$29,$28,$28,$29,$29,$28,$28
frame8Properties:
	db $29,$29,$29,$28,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$29,$28,$28,$28,$28,$29,$28
frame1FlipXProperties:
	db $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$68,$68,$68,$69,$69,$69,$69,$69,$69
frame2FlipXProperties:
	db $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$68,$68,$68
frame3FlipXProperties:
	db $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$68,$68,$68
frame4FlipXProperties:
	db $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$68,$68,$68
frame5FlipXProperties:
	db $69,$69,$69,$69,$69,$68,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$F9,$69,$69,$69,$69,$68,$68,$68,$68,$69
frame6FlipXProperties:
	db $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$F9,$69,$69,$69,$69,$68,$68,$68,$68,$68,$69
frame9FlipXProperties:
	db $69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$68,$69,$68,$69,$69,$69,$68,$68,$69,$69,$68,$68
frame8FlipXProperties:
	db $69,$69,$69,$68,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$69,$68,$68,$68,$68,$69,$68


FramesTile:
frame1Tiles:
	db $80,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$82,$84,$85,$65,$A8,$EA,$C0,$C7,$D7,$C0,$D0,$C2,$D2
frame2Tiles:
	db $A0,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$A2,$A4,$A5,$C7,$D7,$C0,$D0,$C2,$D2,$65,$EA,$A8,$C0
frame3Tiles:
	db $80,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$82,$84,$85,$C5,$C3,$D3,$C0,$D0,$C1,$D1,$65,$EA,$A8,$C0
frame4Tiles:
	db $A0,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$A2,$A4,$A5,$C0,$D0,$C2,$D2,$C3,$D3,$C5,$65,$EA,$C0,$A8
frame5Tiles:
	db $80,$BC,$BD,$DC,$DE,$07,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$82,$84,$85,$C8,$DC,$DE,$BB,$BD,$07,$A8,$C0,$EA,$65
frame6Tiles:
	db $A0,$DE,$DC,$BC,$BD,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$A2,$A4,$A5,$C8,$DC,$DE,$BB,$BD,$07,$07,$A8,$C0,$EA,$65
frame7Tiles:
	db $80,$E5,$4E,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$82,$84,$85,$05,$65,$A8,$E8,$E5,$4E,$48,$05,$EA,$EC,$C0,$EA
frame8Tiles:
	db $A0,$E5,$4E,$05,$EC,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$A2,$A4,$A5,$E8,$E5,$4E,$65,$EA,$A8,$C0,$05,$EA,$48
frame1FlipXTiles:
	db $80,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$82,$84,$85,$65,$A8,$EA,$C0,$C7,$D7,$C0,$D0,$C2,$D2
frame2FlipXTiles:
	db $A0,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$A2,$A4,$A5,$C7,$D7,$C0,$D0,$C2,$D2,$65,$EA,$A8,$C0
frame3FlipXTiles:
	db $80,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$82,$84,$85,$C5,$C3,$D3,$C0,$D0,$C1,$D1,$65,$EA,$A8,$C0
frame4FlipXTiles:
	db $A0,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$A2,$A4,$A5,$C0,$D0,$C2,$D2,$C3,$D3,$C5,$65,$EA,$C0,$A8
frame5FlipXTiles:
	db $80,$BC,$BD,$DC,$DE,$07,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$82,$84,$85,$C8,$DC,$DE,$BB,$BD,$07,$A8,$C0,$EA,$65
frame6FlipXTiles:
	db $A0,$DE,$DC,$BC,$BD,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$A2,$A4,$A5,$C8,$DC,$DE,$BB,$BD,$07,$07,$A8,$C0,$EA,$65
frame7FlipXTiles:
	db $80,$E5,$4E,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$82,$84,$85,$05,$65,$A8,$E8,$E5,$4E,$48,$05,$EA,$EC,$C0,$EA
frame8FlipXTiles:
	db $A0,$E5,$4E,$05,$EC,$87,$A7,$89,$A9,$8B,$9B,$8D,$9D,$A2,$A4,$A5,$E8,$E5,$4E,$65,$EA,$A8,$C0,$05,$EA,$48


FramesHitboxXDisp:
frame1HitboxXDisp:
	dw $FFF0,$FFF4,$FFC2
frame2HitboxXDisp:
	dw $FFF0,$FFF4,$FFC2
frame3HitboxXDisp:
	dw $FFF0,$FFF4,$FFBC
frame4HitboxXDisp:
	dw $FFF0,$FFF4,$FFBC
frame5HitboxXDisp:
	dw $FFF0,$FFF4,$FFCC
frame6HitboxXDisp:
	dw $FFF0,$FFF4,$FFCC
frame7HitboxXDisp:
	dw $FFF0,$FFF4,$FFEE
frame8HitboxXDisp:
	dw $FFF0,$FFF4,$FFEE
frame1FlipXHitboxXDisp:
	dw $FFF6,$FFFE,$0034
frame2FlipXHitboxXDisp:
	dw $FFF6,$FFFE,$0034
frame3FlipXHitboxXDisp:
	dw $FFF6,$FFFE,$003A
frame4FlipXHitboxXDisp:
	dw $FFF6,$FFFE,$003A
frame5FlipXHitboxXDisp:
	dw $FFF6,$FFFE,$002A
frame6FlipXHitboxXDisp:
	dw $FFF6,$FFFE,$002A
frame7FlipXHitboxXDisp:
	dw $FFF6,$FFFE,$0006
frame8FlipXHitboxXDisp:
	dw $FFF6,$FFFE,$0006


FramesHitboxYDisp:
frame1HitboxyDisp:
	dw $FFF8,$FFF4,$0002
frame2HitboxyDisp:
	dw $FFF8,$FFF4,$0000
frame3HitboxyDisp:
	dw $FFF8,$FFF4,$FFF4
frame4HitboxyDisp:
	dw $FFF8,$FFF4,$FFF4
frame5HitboxyDisp:
	dw $FFF8,$FFF4,$FFD0
frame6HitboxyDisp:
	dw $FFF8,$FFF4,$FFD0
frame7HitboxyDisp:
	dw $FFF8,$FFF4,$FFC2
frame8HitboxyDisp:
	dw $FFF8,$FFF4,$FFC0
frame1FlipXHitboxyDisp:
	dw $FFF8,$FFF4,$0002
frame2FlipXHitboxyDisp:
	dw $FFF8,$FFF4,$0000
frame3FlipXHitboxyDisp:
	dw $FFF8,$FFF4,$FFF4
frame4FlipXHitboxyDisp:
	dw $FFF8,$FFF4,$FFF4
frame5FlipXHitboxyDisp:
	dw $FFF8,$FFF4,$FFD0
frame6FlipXHitboxyDisp:
	dw $FFF8,$FFF4,$FFD0
frame7FlipXHitboxyDisp:
	dw $FFF8,$FFF4,$FFC2
frame8FlipXHitboxyDisp:
	dw $FFF8,$FFF4,$FFC0


FramesHitboxWidth:
frame1HitboxWith:
	dw $002A,$001E,$001A
frame2HitboxWith:
	dw $002A,$001E,$001A
frame3HitboxWith:
	dw $002A,$001E,$001A
frame4HitboxWith:
	dw $002A,$001E,$001A
frame5HitboxWith:
	dw $002A,$001E,$001A
frame6HitboxWith:
	dw $002A,$001E,$001A
frame7HitboxWith:
	dw $002A,$001E,$001C
frame8HitboxWith:
	dw $002A,$001E,$001C
frame1FlipXHitboxWith:
	dw $002A,$001E,$001A
frame2FlipXHitboxWith:
	dw $002A,$001E,$001A
frame3FlipXHitboxWith:
	dw $002A,$001E,$001A
frame4FlipXHitboxWith:
	dw $002A,$001E,$001A
frame5FlipXHitboxWith:
	dw $002A,$001E,$001A
frame6FlipXHitboxWith:
	dw $002A,$001E,$001A
frame7FlipXHitboxWith:
	dw $002A,$001E,$001C
frame8FlipXHitboxWith:
	dw $002A,$001E,$001C


FramesHitboxHeigth:
frame1HitboxHeigth:
	dw $0018,$0004,$0010
frame2HitboxHeigth:
	dw $0018,$0004,$0012
frame3HitboxHeigth:
	dw $0018,$0004,$0010
frame4HitboxHeigth:
	dw $0018,$0004,$0010
frame5HitboxHeigth:
	dw $0018,$0004,$0010
frame6HitboxHeigth:
	dw $0018,$0004,$0010
frame7HitboxHeigth:
	dw $0018,$0004,$0010
frame8HitboxHeigth:
	dw $0018,$0004,$0010
frame1FlipXHitboxHeigth:
	dw $0018,$0004,$0010
frame2FlipXHitboxHeigth:
	dw $0018,$0004,$0012
frame3FlipXHitboxHeigth:
	dw $0018,$0004,$0010
frame4FlipXHitboxHeigth:
	dw $0018,$0004,$0010
frame5FlipXHitboxHeigth:
	dw $0018,$0004,$0010
frame6FlipXHitboxHeigth:
	dw $0018,$0004,$0010
frame7FlipXHitboxHeigth:
	dw $0018,$0004,$0010
frame8FlipXHitboxHeigth:
	dw $0018,$0004,$0010


FramesHitboxAction:
frame1HitboxAction:
	dw hurt,hurt,hurt
frame2HitboxAction:
	dw hurt,hurt,hurt
frame3HitboxAction:
	dw hurt,hurt,hurt
frame4HitboxAction:
	dw hurt,hurt,hurt
frame5HitboxAction:
	dw hurt,hurt,hurt
frame6HitboxAction:
	dw hurt,hurt,hurt
frame7HitboxAction:
	dw hurt,hurt,hurt
frame8HitboxAction:
	dw hurt,hurt,hurt
frame1FlipXHitboxAction:
	dw hurt,hurt,hurt
frame2FlipXHitboxAction:
	dw hurt,hurt,hurt
frame3FlipXHitboxAction:
	dw hurt,hurt,hurt
frame4FlipXHitboxAction:
	dw hurt,hurt,hurt
frame5FlipXHitboxAction:
	dw hurt,hurt,hurt
frame6FlipXHitboxAction:
	dw hurt,hurt,hurt
frame7FlipXHitboxAction:
	dw hurt,hurt,hurt
frame8FlipXHitboxAction:
	dw hurt,hurt,hurt

;The code itself.

PrematureEnd:
	PLX
	PLY
	PLB
	PLP
	RTS
ChangeMap16:
	PHP
	SEP #$20
	PHB
	PHY
	LDA #$00
	PHA
	PLB
	REP #$30
	PHX
	LDA $9A
	STA $0C
	LDA $98
	STA $0E
	LDA #$0000
	SEP #$20
	LDA $5B
	STA $09
	LDA $1933
	BEQ SkipShift
	LSR $09
SkipShift:
	LDY $0E
	LDA $09
	AND #$01
	BEQ LeaveXY
	LDA $9B
	STA $00
	LDA $99
	STA $9B
	LDA $00
	STA $99
	LDY $0C
LeaveXY:
	CPY #$0200
	BCS PrematureEnd
	LDA $1933
	ASL A
	TAX
	LDA $BEA8,x
	STA $65
	LDA $BEA9,x
	STA $66
	STZ $67
	LDA $1925
	ASL A
	TAY
	LDA [$65],y
	STA $04
	INY
	LDA [$65],y
	STA $05
	STZ $06
	LDA $9B
	STA $07
	ASL A
	CLC
	ADC $07
	TAY
	LDA [$04],y
	STA $6B
	STA $6E
	INY
	LDA [$04],y
	STA $6C
	STA $6F
	LDA #$7E
	STA $6D
	INC A
	STA $70
	LDA $09
	AND #$01
	BEQ SwitchXY
	LDA $99		
	LSR A
	LDA $9B
	AND #$01
	BRA CurrentXY
SwitchXY:
	LDA $9B
	LSR A
	LDA $99
CurrentXY:
	ROL A
	ASL A
	ASL A
	ORA #$20
	STA $04
	CPX #$0000
	BEQ NoAdd
	CLC
	ADC #$10
	STA $04
NoAdd:
	LDA $98
	AND #$F0
	CLC
	ASL A
	ROL A
	STA $05
	ROL A
	AND #$03
	ORA $04
	STA $06
	LDA $9A
	AND #$F0
	REP 3 : LSR A
	STA $04
	LDA $05
	AND #$C0
	ORA $04
	STA $07
	REP #$20
	LDA $09
	AND #$0001
	BNE LayerSwitch
	LDA $1A
	SEC
	SBC #$0080
	TAX
	LDY $1C
	LDA $1933
	BEQ CurrentLayer
	LDX $1E
	LDA $20
	SEC
	SBC #$0080
	TAY
	BRA CurrentLayer
LayerSwitch: 
	LDX $1A
	LDA $1C
	SEC
	SBC #$0080
	TAY
	LDA $1933
	BEQ CurrentLayer
	LDA $1E
	SEC
	SBC #$0080
	TAX
	LDY $20
CurrentLayer:
	STX $08
	STY $0A
	LDA $98
	AND #$01F0
	STA $04
	LDA $9A
	REP 4 : LSR A
	AND #$000F
	ORA $04
	TAY
	PLA
	SEP #$20
	STA [$6B],y
	XBA
	STA [$6E],y
	XBA
	REP #$20
	ASL A
	TAY
	PHK
	PER $0006
	PEA $804C
	JML $00C0FB
	PLY
	PLB
	PLP
	RTS
