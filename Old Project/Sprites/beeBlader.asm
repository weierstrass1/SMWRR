PRINT "INIT ",pc
incsrc parches\headers\header.asm
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

!accelerationTimer = $1564,x

!MaxAccelerationTimer = #$34
!bullet = #$15

!MaxHp = #$20

!currentHp = $151C,x

!palTimer = $154C,x

STZ !palTimer

LDA !MaxHp
STA !currentHp

STZ $B6,x
STZ $AA,x

LDA !MaxAccelerationTimer 
STA !accelerationTimer

STZ !FramePointer
STZ !AnPointer
STZ !AnFramePointer
LDA #$04
STA !AnimationTimer

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

	JSR Graphics ;graphic routine

	LDA $14C8,x			;\
	CMP #$08			; | If sprite dead,
	BNE Return			;/ Return.

	LDA $9D				;\
	BNE Return			;/ If locked, return.
	JSL !SUB_OFF_SCREEN_X0
	
	JSR checkBuster
	JSR checkChargedBuster
	JSR InteractionWithMario
	JSR shootBullets
	JSR Move
	JSR GraphicManager ;manage the frames of the sprite and decide what frame show
	RTS
	
Move:

	LDA !palTimer
	BEQ +
	LDA #$F8
	STA $B6,x
	BRA ++
+
	STZ $B6,x
++
	JSL $018022
	LDA !accelerationTimer
	AND #$01
	BEQ +
	BRA .upHelix
+
	LDA !accelerationTimer
	TAY
	
	LDA $D8,x
	STA $02
	LDA $14D4,x
	STA $03 
	
	REP #$20
	LDA $02
	CLC
	ADC .yAdder,y
	STA $02
	SEP #$20
	
	LDA $02
	STA $00D8,x
	LDA $03
	STA $14D4,x
	
	LDA !accelerationTimer
	BNE +

	LDA !MaxAccelerationTimer
	STA !accelerationTimer
	
+
.upHelix
	LDA !mmxBeeHelixX
	TAY
	JSL !spriteFirstX
	
	REP #$20
	
	LDA $02
	STA $00D8,y
	LDA $03
	STA $14D4,y
	
	LDA $00
	CLC
	ADC #$FFF8
	STA $00
	
	LDA $02
	CLC
	ADC #$FFD0
	STA $02
	
	SEP #$20
	
	LDA $00
	STA $00E4,y
	LDA $01
	STA $14E0,y
	LDA $02
	STA $00D8,y
	LDA $03
	STA $14D4,y
	
	RTS
	
.yAdder
	dw $0000,$0001,$0001,$0000,$0001,$0000,$0000,$FFFF,$0000,$0000,$FFFF,$0000,$FFFF
	dw $0000,$FFFF,$FFFF,$0000,$FFFF,$0000,$0000,$0001,$0000,$0000,$0001,$0000,$0001
	
shootBullets:

	LDA $14
	AND #$0F
	BEQ +
	RTS
+

	LDY #$01
.ExtraLoop
	LDA $170B,y
	BEQ .Extra1
	DEY
	BPL .ExtraLoop
	RTS
.Extra1
	
	LDA #$01
	STA $1DF9

	LDA !bullet
	STA $170B,y
	
	
	JSL !spriteFirstX
	
	REP #$20
	LDA $00
	CLC
	ADC #$FFE0
	STA $00
	
	LDA $02
	CLC
	ADC #$001C
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
	
	LDA #$70
	STA $173D,y
	LDA #$90
	STA $1747,y
	
	LDA #$00
	STA $1765,y
	STA $176F,y
	STA $1779,y
	LDA #$04
	STA $0DF5,y
	
	RTS
	
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
	
	
	
	RTS	


;===================================
;Animation
;===================================
EndPositionAnim:
	dw $0000,$0001

AnimationsFrames:
normalFrames:
	db $00
deadFrames:
	db $01

AnimationsNFr:
normalNext:
	db $00
deadNext:
	db $00

AnimationsTFr:
normalTimes:
	db $50
deadTimes:
	db $50


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
	LDA !FramePointer
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
	LDA !AnPointer
	CMP #$02
	BEQ +
	
	LDA !palTimer
	BNE +

	JSL !chargedBusterKill
	
	LDA #$04
	STA !palTimer
	
	LDA !currentHp
	SEC
	SBC #$04
	STA !currentHp
	BEQ .dead
	BMI .dead
+
	RTS
.dead
	STZ !palTimer
	
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
	LDA !FramePointer
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

	LDA !AnPointer
	CMP #$02
	BEQ +
	JSL !busterKill	
	
	LDA !palTimer
	BNE +
	
	LDA #$04
	STA !palTimer
	
	LDA !currentHp
	DEC A
	STA !currentHp
	BEQ .dead
+
	RTS
.dead
	STZ !palTimer
	RTS


InteractionWithMario:

	LDA !FramePointer
	TAY
	LDA TotalHitboxes,y
	BPL +
	RTS
+

	LDA !FramePointer
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
	
	LDY $0008
	
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
	
	LDA !AnPointer
	CMP #$02
	BEQ +
	
	LDA #$04
	JSL !mmxDamage
	
+
	RTS
;===================================
;Actions
;===================================
;===================================
;Graphic Routine
;===================================

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
	LDA #$04
	STA $0F
+
	
	PHX
	
	LDA !FramePointer
	
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
	CLC
	ADC $0F
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

	db $1E,$17

StartPositionFrames:
	dw $001E,$0036

EndPositionFrames:
	dw $0000,$001F

TotalHitboxes:
	db $01,$FF

StartPositionHitboxes:
	dw $0002,$0004

EndPositionHitboxes:
	dw $0000,$0004

FramesXDisp:
frame1XDisp:
	db $04,$F2,$D0,$E0,$F0,$00,$10,$20,$30,$D8,$E8,$F8,$08,$18,$28,$D8,$E8,$F8,$08,$18,$28,$30,$38,$F0,$00,$10,$20,$30,$E0,$28,$18
frame2XDisp:
	db $D8,$E8,$F8,$E0,$D0,$E0,$F0,$00,$10,$20,$30,$18,$08,$18,$20,$F8,$F0,$08,$28,$30,$30,$F8,$00,$F8


FramesYDisp:
frame1yDisp:
	db $20,$20,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$00,$00,$00,$00,$00,$00,$10,$10,$10,$10,$10,$10,$10,$00,$E0,$E0,$E0,$E0,$E0,$E0,$20,$20
frame2yDisp:
	db $00,$00,$00,$F0,$F0,$E0,$E0,$E0,$E0,$E0,$E0,$00,$F0,$F0,$F0,$F0,$F0,$00,$00,$00,$F0,$E0,$E0,$F0


FramesPropertie:
frame1Properties:
	db $36,$36,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$77,$37,$37,$37,$37,$77,$37,$37,$77
frame2Properties:
	db $36,$36,$36,$36,$37,$37,$37,$37,$37,$37,$77,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$36,$36,$36


FramesTile:
frame1Tiles:
	db $8A,$8A,$80,$82,$84,$86,$88,$8A,$8C,$A0,$A2,$A4,$A6,$A8,$AA,$AC,$AE,$C0,$C2,$C4,$C6,$C7,$CE,$E0,$E2,$E4,$E6,$C9,$8E,$EE,$EE
frame2Tiles:
	db $82,$84,$86,$80,$80,$8E,$E0,$E2,$E4,$E6,$C9,$E8,$EA,$89,$8A,$85,$84,$EC,$CB,$CC,$8C,$A0,$A1,$9E


FramesHitboxXDisp:
frame1HitboxXDisp:
	dw $FFDC,$FFE8
frame2HitboxXDisp:
	dw $FFFF


FramesHitboxYDisp:
frame1HitboxyDisp:
	dw $FFF0,$FFE8
frame2HitboxyDisp:
	dw $FFFF


FramesHitboxWidth:
frame1HitboxWith:
	dw $005C,$004C
frame2HitboxWith:
	dw $FFFF


FramesHitboxHeigth:
frame1HitboxHeigth:
	dw $0028,$0008
frame2HitboxHeigth:
	dw $FFFF


FramesHitboxAction:
frame1HitboxAction:
	dw hurt,hurt
frame2HitboxAction:
	dw $FFFF


