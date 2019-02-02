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

!GlobalFlipper = $1534,x

!LocalFlipper = $1570,x

!currentHp = $151C,x

!palTimer = $154C,x

!standTimer = $1564,x

!NumProj = $1528,x

!projType = $1594,x

!maxHp = #$10

!standMaxTime = #$80

!spark = #$0D
!misil = #$0E

LDA #$00
STA !GlobalFlipper

LDA !standMaxTime
STA !standTimer

STZ !palTimer

LDA !maxHp
STA !currentHp

STZ !FramePointer
STZ !AnPointer
STZ !AnFramePointer
LDA #$04
STA !AnimationTimer

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
	
	JSR ia
	
	LDA $D8,x
	STA $00
	LDA $14D4,x
	STA $01

	REP #$20
	LDA !mmxYFloor
	BEQ +
	CLC
	ADC #$0004
	LDA $00
	CMP !mmxYFloor
	BCC +
	
	LDA !mmxYFloor
	CLC
	ADC #$0004
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
	
	JSR GraphicManager ;manage the frames of the sprite and decide what frame show
	
	RTS
	
ia:
	LDA !AnPointer
	BNE +
	
	LDA !standTimer
	BNE ++
	
	LDA #$02
	STA !AnPointer
	RTS
++
	JSR lookMario
	RTS
+
	CMP #$02
	BNE +
	
	JSR closeSt
	
	RTS
+
	CMP #$04
	BNE +
	
	JSR attackSt
	
	RTS
+
	CMP #$06
	BNE .ret
	
	LDA !FramePointer
	BNE .ret
	
	LDA !AnimationTimer
	BNE .ret
	
	JSL $01ACF9
	LDA $148D
	EOR $14
	AND #$70
	STA $00
	
	LDA !standMaxTime
	SEC
	SBC $00
	STA !standTimer
	
	LDA #$01
	STA !FramePointer
	STA !AnFramePointer
	STZ !AnPointer
	LDA #$04
	STA !AnimationTimer
	
.ret
	RTS

closeSt:

	LDA !FramePointer
	CMP #$0A
	BNE .ret
	
	LDA !AnimationTimer
	BNE .ret
	
	LDA #$04
	STA !AnPointer
	LDA #$0B
	STA !FramePointer
	STZ !AnFramePointer
	LDA #$02
	STA !AnimationTimer
	
	JSL $01ACF9
	LDA $148D
	EOR $14
	AND #$01
	STA !projType
	
	LDA !projType
	TAY
	LDA projNum,y
	STA !NumProj
.ret
	RTS
	
projNum: db $01,$02
attackSt:
	LDA !AnimationTimer
	BNE .ret

	LDA !FramePointer
	CMP #$0C
	BNE +
	
	LDA !projType
	BEQ ++
	JSR misil
	RTS
++
	JSR spark
	RTS
+

	LDA !FramePointer
	CMP #$0A
	BNE .ret
	
	LDA !NumProj
	DEC A
	STA !NumProj
	BEQ +
	
	LDA #$04
	STA !AnPointer
	LDA #$0B
	STA !FramePointer
	STZ !AnFramePointer
	LDA #$02
	STA !AnimationTimer
	RTS
+
	LDA #$06
	STA !AnPointer
	LDA #$0D
	STA !FramePointer
	STZ !AnFramePointer
	LDA #$04
	STA !AnimationTimer
.ret
	RTS
	
lookMario:
	JSL !spriteFirstX
	
	REP #$20
	LDA $00
	CLC
	ADC #$0008
	STA $00
	
	LDA $94
	CLC
	ADC #$0008
	STA $02
	
	LDA $00
	CMP $02
	SEP #$20
	BCS .left
	LDA #$01
	STA !GlobalFlipper
	RTS
.left
	STZ !GlobalFlipper
	RTS
	
misil:

	LDY #$04
	LDA !NumProj
	ASL
	STA $04
.loop

	LDA $1892,y
	BNE .next
	
	JSR summonMisil
	
	RTS
.next
	DEY
	BPL .loop
.ret
	RTS
	
summonMisil:
	LDA !misil ; \ Custom cluster sprite 09.
	STA $1892,y ; /
	
	JSL !spriteFirstX
	
	PHX
	LDA !GlobalFlipper
	TAX
	LDA .xFlip,x
	TYX
	STA $7F1000,x
	PLX
	PHX
	LDA !GlobalFlipper
	ASL
	ASL
	ORA $04
	TAX
	
	REP #$20
	LDA $00
	CLC
	ADC .xAdder,x
	STA $00
	LDA $02
	CLC
	ADC #$FFF0
	STA $02
	SEP #$20
	PLX
	
	LDA $00
	STA $1E16,y	; | Store into X pos.
	LDA $01
	STA $1E3E,y
	
	LDA $02
	STA $1E02,y ; | Store into Y pos.
	LDA $03
	STA $1E2A,y
	
	LDA #$00
	STA $0F72,y
	STA $0F9A,y ;speed Frac
	STA $0FAE,y ;Frame
	STA $0F86,y  ;YSpeed
	
	PHY
	LDA !GlobalFlipper
	TAY
	LDA .xSpeed,y
	PLY
	STA $0F5E,y
	
	LDA #$09
	STA $1DFC
	
	LDA #$01 ; \ Run cluster sprite routine.
	STA $18B8 ; /

RTS ; Return.
.xAdder: dw $0000,$FFF0,$0000,$0010
.xSpeed: db $C0,$30
.xFlip: db $00,$40

	
spark:

	LDY #$04
	LDA #$02
	STA $04
.loop

	LDA $1892,y
	BNE .next
	
	JSR summonSpark
	
	LDA $04
	DEC A
	DEC A
	STA $04
	BPL .next
	RTS
.next
	DEY
	BPL .loop
.ret
	RTS
	
summonSpark:
	LDA !spark ; \ Custom cluster sprite 09.
	STA $1892,y ; /
	
	JSL !spriteFirstX
	
	PHX
	LDA !GlobalFlipper
	ASL
	ASL
	ORA $04
	TAX
	
	REP #$20
	LDA $00
	CLC
	ADC .xAdder,x
	STA $00
	LDA $02
	CLC
	ADC #$FFF0
	STA $02
	SEP #$20
	
	LDA $00
	STA $1E16,y	; | Store into X pos.
	LDA $01
	STA $1E3E,y
	
	TYX
	LDA $02
	STA $1E02,y ; | Store into Y pos.
	STA $7F1000,x ;Init Y Low
	LDA $03
	STA $1E2A,y
	STA $7F1014,x ;Init Y High
	PLX
	
	LDA #$00
	STA $0F72,y
	STA $0F9A,y ;speed Frac
	STA $0FAE,y ;Frame
	
	PHY
	LDA !GlobalFlipper
	TAY
	LDA .xSpeed,y
	PLY
	STA $0F5E,y
	
	LDA #$30
	STA $0F86,y  ;Speed
	
	LDA #$2D
	STA $1DF9
	
	LDA #$01 ; \ Run cluster sprite routine.
	STA $18B8 ; /

	RTS ; Return.
.xAdder: dw $0000,$FFF0,$0000,$0010
.xSpeed: db $B0,$40
	
;===================================
;Graphic Manager
;===================================	
GraphicManager:

	;if !AnimationTimer is Zero go to the next frame
	LDA !AnimationTimer
	BEQ ChangeFrame
	RTS

ChangeFrame:

	LDA !FramePointer
	CMP #$15
	BNE +
	STZ $14C8,x	
	RTS
+

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
	dw $0000,$0002,$000E,$0012,$0019

AnimationsFrames:
standFrames:
	db $00,$01
openFrames:
	db $00,$01,$02,$03,$04,$05,$04,$06,$07,$08,$09,$0A
attackFrames:
	db $0B,$0C,$0B,$0A
closeFrames:
	db $0D,$05,$04,$03,$02,$01,$00
explosionFrames:
	db $0E,$0F,$0E,$10,$11,$12,$13,$14,$15

AnimationsNFr:
standNext:
	db $01,$00
openNext:
	db $01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0B
attackNext:
	db $01,$02,$03,$03
closeNext:
	db $01,$02,$03,$04,$05,$06,$06
explosionNext:
	db $01,$02,$03,$04,$05,$06,$07,$08,$08

AnimationsTFr:
standTimes:
	db $04,$04
openTimes:
	db $04,$04,$04,$04,$02,$02,$18,$04,$04,$04,$04,$14
attackTimes:
	db $02,$04,$08,$08
closeTimes:
	db $04,$04,$04,$04,$04,$04,$04
explosionTimes:
	db $02,$03,$02,$04,$04,$04,$04,$04,$04

AnimationsFlips:
standFlip:
	db $00,$00
openFlip:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
attackFlip:
	db $00,$00,$00,$00
closeFlip:
	db $00,$00,$00,$00,$00,$00,$00
explosionFlip:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00


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
	LDA !AnPointer
	CMP #$08
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
	LDA #$08
	STA !AnPointer
	LDA #$0E
	STA !FramePointer
	STZ !AnFramePointer
	LDA #$02
	STA !AnimationTimer
	LDA #$2C
	STA $1DC9
	
	JSL !spriteFirstX
	
	REP #$20
	LDA $02
	CLC
	ADC #$FFF0
	STA $00
	SEP #$20
	
	JSL !mmxThrowItem
	
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

	LDA !AnPointer
	CMP #$08
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
	LDA #$08
	STA !AnPointer
	LDA #$0E
	STA !FramePointer
	STZ !AnFramePointer
	LDA #$02
	STA !AnimationTimer
	LDA #$2C
	STA $1DC9
	
	JSL !spriteFirstX
	
	REP #$20
	LDA $02
	CLC
	ADC #$FFF0
	STA $00
	SEP #$20
	
	JSL !mmxThrowItem
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
	CMP #$08
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
FlipAdder: db $00,$16
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
	LDA FramesSizes,y
	STA $00
	LDA FramesTotalTiles,y ;load the total of tiles on $0E
	LDY $0000 ;load the size
	JSL $01B7B3 ;call the oam routine
	RTS
	
;===================================
;Frames
;===================================
FramesTotalTiles:

	db $12,$12,$12,$12,$11,$11,$11,$12,$13,$12,$11,$13,$13,$10,$03,$03,$03,$03,$03,$03,$03,$01,$12,$12,$12,$12,$11,$11,$11,$12,$13,$12,$11,$13,$13,$10,$03,$03,$03,$03,$03,$03,$03,$01
	
FramesSizes:
	db $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$00,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02

StartPositionFrames:
	dw $0012,$0025,$0038,$004B,$005D,$006F,$0081,$0094,$00A8,$00BB,$00CD,$00E1,$00F5,$0106,$010A,$010E,$0112,$0116,$011A,$011E,$0122,$0124,$0137,$014A,$015D,$0170,$0182,$0194,$01A6,$01B9,$01CD,$01E0,$01F2,$0206,$021A,$022B,$022F,$0233,$0237,$023B,$023F,$0243,$0247,$0249

EndPositionFrames:
	dw $0000,$0013,$0026,$0039,$004C,$005E,$0070,$0082,$0095,$00A9,$00BC,$00CE,$00E2,$00F6,$0107,$010B,$010F,$0113,$0117,$011B,$011F,$0123,$0125,$0138,$014B,$015E,$0171,$0183,$0195,$01A7,$01BA,$01CE,$01E1,$01F3,$0207,$021B,$022C,$0230,$0234,$0238,$023C,$0240,$0244,$0248

TotalHitboxes:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

StartPositionHitboxes:
	dw $0000,$0002,$0004,$0006,$0008,$000A,$000C,$000E,$0010,$0012,$0014,$0016,$0018,$001A,$001C,$001E,$0020,$0022,$0024,$0026,$0028,$002A,$002C,$002E,$0030,$0032,$0034,$0036,$0038,$003A,$003C,$003E,$0040,$0042,$0044,$0046,$0048,$004A,$004C,$004E,$0050,$0052,$0054,$0056

EndPositionHitboxes:
	dw $0000,$0002,$0004,$0006,$0008,$000A,$000C,$000E,$0010,$0012,$0014,$0016,$0018,$001A,$001C,$001E,$0020,$0022,$0024,$0026,$0028,$002A,$002C,$002E,$0030,$0032,$0034,$0036,$0038,$003A,$003C,$003E,$0040,$0042,$0044,$0046,$0048,$004A,$004C,$004E,$0050,$0052,$0054,$0056

FramesXDisp:
stand1XDisp:
	db $F2,$02,$12,$00,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$F2,$EA,$F2,$01,$04,$0C,$F9
stand2XDisp:
	db $F2,$02,$12,$00,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$EA,$F2,$F2,$01,$04,$0C,$F9
down1XDisp:
	db $00,$EE,$FE,$0E,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$F2,$EA,$F2,$04,$0C,$01,$F9
down2XDisp:
	db $00,$EE,$FE,$0E,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$F2,$EA,$F2,$04,$0C,$01,$F9
down3XDisp:
	db $F2,$02,$12,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$F2,$EA,$F2,$04,$0C,$01,$F9
down4XDisp:
	db $F2,$02,$12,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$F2,$EA,$F2,$04,$0C,$01,$F9
open1XDisp:
	db $F2,$02,$12,$F3,$F3,$03,$03,$13,$13,$FA,$0A,$E3,$EA,$FA,$02,$F8,$F9,$0D
open2XDisp:
	db $F2,$02,$12,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$E4,$F4,$04,$F8,$08,$06,$16,$0D
open3XDisp:
	db $F2,$02,$12,$F5,$F5,$05,$05,$15,$15,$FC,$0C,$E5,$F9,$FC,$09,$0B,$0E,$1B,$FA,$0D
open4XDisp:
	db $F2,$02,$12,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$E4,$F8,$F4,$04,$08,$06,$16,$0C
open5XDisp:
	db $F2,$02,$12,$F4,$F4,$04,$04,$14,$14,$FB,$0B,$E4,$F8,$F4,$04,$08,$06,$16
attack1XDisp:
	db $F2,$02,$12,$F5,$F5,$05,$05,$15,$15,$FC,$0C,$E5,$F9,$F5,$05,$09,$07,$17,$FA,$FB
attack2XDisp:
	db $F2,$02,$12,$F6,$F6,$06,$06,$16,$16,$FD,$0D,$E6,$FA,$F6,$06,$0A,$08,$18,$FB,$FC
close1XDisp:
	db $F2,$02,$12,$F4,$F4,$04,$04,$E4,$14,$14,$FB,$0B,$EB,$FB,$03,$F9,$FA
exp1XDisp:
	db $00,$08,$08,$00
exp2XDisp:
	db $F8,$08,$F8,$08
exp3XDisp:
	db $F8,$F8,$08,$08
exp4XDisp:
	db $F8,$F8,$08,$08
exp5XDisp:
	db $F8,$F8,$08,$08
exp6XDisp:
	db $F8,$F8,$08,$08
exp7XDisp:
	db $F8,$F8,$08,$08
exp8XDisp:
	db $F8,$08
stand1FlipXXDisp:
	db $0E,$FE,$EE,$00,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$0E,$16,$0E,$FF,$FC,$F4,$07
stand2FlipXXDisp:
	db $0E,$FE,$EE,$00,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$16,$0E,$0E,$FF,$FC,$F4,$07
down1FlipXXDisp:
	db $00,$12,$02,$F2,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$0E,$16,$0E,$FC,$F4,$FF,$07
down2FlipXXDisp:
	db $00,$12,$02,$F2,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$0E,$16,$0E,$FC,$F4,$FF,$07
down3FlipXXDisp:
	db $0E,$FE,$EE,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$0E,$16,$0E,$FC,$F4,$FF,$07
down4FlipXXDisp:
	db $0E,$FE,$EE,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$0E,$16,$0E,$FC,$F4,$FF,$07
open1FlipXXDisp:
	db $0E,$FE,$EE,$0D,$0D,$FD,$FD,$ED,$ED,$06,$F6,$1D,$16,$06,$FE,$08,$07,$F3
open2FlipXXDisp:
	db $0E,$FE,$EE,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$1C,$0C,$FC,$08,$F8,$FA,$EA,$F3
open3FlipXXDisp:
	db $0E,$FE,$EE,$0B,$0B,$FB,$FB,$EB,$EB,$04,$F4,$1B,$07,$04,$F7,$F5,$F2,$E5,$06,$F3
open4FlipXXDisp:
	db $0E,$FE,$EE,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$1C,$08,$0C,$FC,$F8,$FA,$EA,$F4
open5FlipXXDisp:
	db $0E,$FE,$EE,$0C,$0C,$FC,$FC,$EC,$EC,$05,$F5,$1C,$08,$0C,$FC,$F8,$FA,$EA
attack1FlipXXDisp:
	db $0E,$FE,$EE,$0B,$0B,$FB,$FB,$EB,$EB,$04,$F4,$1B,$07,$0B,$FB,$F7,$F9,$E9,$06,$05
attack2FlipXXDisp:
	db $0E,$FE,$EE,$0A,$0A,$FA,$FA,$EA,$EA,$03,$F3,$1A,$06,$0A,$FA,$F6,$F8,$E8,$05,$04
close1FlipXXDisp:
	db $0E,$FE,$EE,$0C,$0C,$FC,$FC,$1C,$EC,$EC,$05,$F5,$15,$05,$FD,$07,$06
exp1FlipXXDisp:
	db $08,$00,$00,$08
exp2FlipXXDisp:
	db $08,$F8,$08,$F8
exp3FlipXXDisp:
	db $08,$08,$F8,$F8
exp4FlipXXDisp:
	db $08,$08,$F8,$F8
exp5FlipXXDisp:
	db $08,$08,$F8,$F8
exp6FlipXXDisp:
	db $08,$08,$F8,$F8
exp7FlipXXDisp:
	db $08,$08,$F8,$F8
exp8FlipXXDisp:
	db $08,$F8


FramesYDisp:
stand1yDisp:
	db $00,$00,$00,$F0,$DD,$ED,$DD,$ED,$DD,$ED,$D5,$D5,$D5,$DD,$E5,$E5,$D5,$D5,$F4
stand2yDisp:
	db $00,$00,$00,$F8,$DE,$EE,$DE,$EE,$DE,$EE,$D6,$D6,$E6,$DE,$E6,$E6,$D6,$D6,$F5
down1yDisp:
	db $FC,$00,$00,$00,$E1,$F1,$E1,$F1,$E1,$F1,$D9,$D9,$D9,$E1,$E9,$D9,$D9,$E9,$F8
down2yDisp:
	db $F3,$00,$00,$00,$E5,$F5,$E5,$F5,$E5,$F5,$DD,$DD,$E5,$E5,$ED,$DD,$DD,$ED,$FC
down3yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$E7,$EF,$EF,$DF,$DF,$EF,$FE
down4yDisp:
	db $00,$00,$00,$E8,$F8,$E8,$F8,$E8,$F8,$E0,$E0,$E8,$F0,$F0,$E0,$E0,$F0,$FF
open1yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E6,$E6,$E6,$FE,$FA,$FA
open2yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$D2,$D3,$E2,$E2,$D2,$D3,$03
open3yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$DA,$D2,$E1,$DA,$D2,$E0,$FE,$FF
open4yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E2,$D2,$D3,$E2,$D2,$D3,$01
open5yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E2,$D2,$D3,$E2,$D2,$D3
attack1yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E2,$D2,$D3,$E2,$D2,$D3,$FE,$FA
attack2yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E2,$D2,$D3,$E2,$D2,$D3,$FE,$FA
close1yDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$F7,$E7,$F7,$DF,$DF,$E6,$E6,$E6,$FE,$FA
exp1yDisp:
	db $F0,$F0,$F8,$F8
exp2yDisp:
	db $E8,$E8,$F8,$F8
exp3yDisp:
	db $E8,$F8,$E8,$F8
exp4yDisp:
	db $E6,$F6,$E6,$F6
exp5yDisp:
	db $E4,$F4,$F4,$E4
exp6yDisp:
	db $E2,$F2,$F2,$E2
exp7yDisp:
	db $DE,$EE,$EE,$DE
exp8yDisp:
	db $E2,$E2
stand1FlipXyDisp:
	db $00,$00,$00,$F0,$DD,$ED,$DD,$ED,$DD,$ED,$D5,$D5,$D5,$DD,$E5,$E5,$D5,$D5,$F4
stand2FlipXyDisp:
	db $00,$00,$00,$F8,$DE,$EE,$DE,$EE,$DE,$EE,$D6,$D6,$E6,$DE,$E6,$E6,$D6,$D6,$F5
down1FlipXyDisp:
	db $FC,$00,$00,$00,$E1,$F1,$E1,$F1,$E1,$F1,$D9,$D9,$D9,$E1,$E9,$D9,$D9,$E9,$F8
down2FlipXyDisp:
	db $F3,$00,$00,$00,$E5,$F5,$E5,$F5,$E5,$F5,$DD,$DD,$E5,$E5,$ED,$DD,$DD,$ED,$FC
down3FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$E7,$EF,$EF,$DF,$DF,$EF,$FE
down4FlipXyDisp:
	db $00,$00,$00,$E8,$F8,$E8,$F8,$E8,$F8,$E0,$E0,$E8,$F0,$F0,$E0,$E0,$F0,$FF
open1FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E6,$E6,$E6,$FE,$FA,$FA
open2FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$D2,$D3,$E2,$E2,$D2,$D3,$03
open3FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$DA,$D2,$E1,$DA,$D2,$E0,$FE,$FF
open4FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E2,$D2,$D3,$E2,$D2,$D3,$01
open5FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E2,$D2,$D3,$E2,$D2,$D3
attack1FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E2,$D2,$D3,$E2,$D2,$D3,$FE,$FA
attack2FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$E7,$F7,$DF,$DF,$F7,$E2,$D2,$D3,$E2,$D2,$D3,$FE,$FA
close1FlipXyDisp:
	db $00,$00,$00,$E7,$F7,$E7,$F7,$F7,$E7,$F7,$DF,$DF,$E6,$E6,$E6,$FE,$FA
exp1FlipXyDisp:
	db $F0,$F0,$F8,$F8
exp2FlipXyDisp:
	db $E8,$E8,$F8,$F8
exp3FlipXyDisp:
	db $E8,$F8,$E8,$F8
exp4FlipXyDisp:
	db $E6,$F6,$E6,$F6
exp5FlipXyDisp:
	db $E4,$F4,$F4,$E4
exp6FlipXyDisp:
	db $E2,$F2,$F2,$E2
exp7FlipXyDisp:
	db $DE,$EE,$EE,$DE
exp8FlipXyDisp:
	db $E2,$E2


FramesPropertie:
stand1Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$79,$79,$39,$39,$39,$39,$39
stand2Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$79,$79,$39,$39,$39,$39,$39
down1Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$79,$79,$39,$39,$39,$39,$39
down2Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$79,$79,$39,$39,$39,$39,$39
down3Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$79,$79,$39,$39,$39,$39,$39
down4Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$79,$79,$39,$39,$39,$39,$39
open1Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39
open2Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$F9,$39,$39,$39,$F9,$39
open3Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$79,$39,$39,$79,$39,$39
open4Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$F9,$39,$39,$F9,$39
open5Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$F9,$39,$39,$F9
attack1Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$F9,$39,$39,$F9,$39,$39
attack2Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$F9,$39,$39,$F9,$39,$39
close1Properties:
	db $39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39,$39
exp1Properties:
	db $3C,$7C,$FC,$BC
exp2Properties:
	db $3C,$7C,$BC,$FC
exp3Properties:
	db $3C,$3C,$7C,$7C
exp4Properties:
	db $3C,$3C,$7C,$7C
exp5Properties:
	db $3C,$3C,$7C,$7C
exp6Properties:
	db $3C,$3C,$7C,$7C
exp7Properties:
	db $3C,$3C,$7C,$7C
exp8Properties:
	db $3C,$7C
stand1FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$39,$39,$79,$79,$79,$79,$79
stand2FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$39,$39,$79,$79,$79,$79,$79
down1FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$39,$39,$79,$79,$79,$79,$79
down2FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$39,$39,$79,$79,$79,$79,$79
down3FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$39,$39,$79,$79,$79,$79,$79
down4FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$39,$39,$79,$79,$79,$79,$79
open1FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79
open2FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$B9,$79,$79,$79,$B9,$79
open3FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$39,$79,$79,$39,$79,$79
open4FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$B9,$79,$79,$B9,$79
open5FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$B9,$79,$79,$B9
attack1FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$B9,$79,$79,$B9,$79,$79
attack2FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$B9,$79,$79,$B9,$79,$79
close1FlipXProperties:
	db $79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79,$79
exp1FlipXProperties:
	db $7C,$3C,$BC,$FC
exp2FlipXProperties:
	db $7C,$3C,$FC,$BC
exp3FlipXProperties:
	db $7C,$7C,$3C,$3C
exp4FlipXProperties:
	db $7C,$7C,$3C,$3C
exp5FlipXProperties:
	db $7C,$7C,$3C,$3C
exp6FlipXProperties:
	db $7C,$7C,$3C,$3C
exp7FlipXProperties:
	db $7C,$7C,$3C,$3C
exp8FlipXProperties:
	db $7C,$3C


FramesTile:
stand1Tiles:
	db $48,$4A,$4C,$56,$40,$60,$42,$62,$20,$22,$80,$82,$76,$74,$8E,$A9,$69,$6A,$46
stand2Tiles:
	db $48,$4A,$4C,$66,$40,$60,$42,$62,$20,$22,$80,$82,$84,$86,$8E,$A9,$69,$6A,$46
down1Tiles:
	db $66,$E0,$E2,$E4,$40,$60,$42,$62,$20,$22,$80,$82,$76,$74,$8E,$69,$6A,$A9,$46
down2Tiles:
	db $56,$E0,$E2,$E4,$40,$60,$42,$62,$20,$22,$80,$82,$86,$74,$8E,$69,$6A,$A9,$46
down3Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$86,$84,$8E,$69,$6A,$A9,$46
down4Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$86,$84,$8E,$69,$6A,$A9,$46
open1Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$C0,$C2,$C3,$46,$64,$E6
open2Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$AB,$25,$7E,$6C,$AB,$25,$CD
open3Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$88,$AD,$25,$88,$AD,$25,$44,$E8
open4Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$7E,$AB,$25,$6C,$AB,$25,$EA
open5Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$7E,$AB,$25,$6C,$AB,$25
attack1Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$7E,$AB,$25,$6C,$AB,$25,$46,$64
attack2Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$7E,$AB,$25,$6C,$AB,$25,$46,$64
close1Tiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$25,$20,$22,$80,$82,$C0,$C2,$C3,$46,$64
exp1Tiles:
	db $63,$63,$63,$63
exp2Tiles:
	db $C2,$C2,$C2,$C2
exp3Tiles:
	db $C4,$E0,$C4,$E0
exp4Tiles:
	db $C6,$E2,$C6,$E2
exp5Tiles:
	db $C8,$E4,$E4,$C8
exp6Tiles:
	db $CA,$E6,$E6,$CA
exp7Tiles:
	db $CC,$E8,$E8,$CC
exp8Tiles:
	db $CE,$CE
stand1FlipXTiles:
	db $48,$4A,$4C,$56,$40,$60,$42,$62,$20,$22,$80,$82,$76,$74,$8E,$A9,$69,$6A,$46
stand2FlipXTiles:
	db $48,$4A,$4C,$66,$40,$60,$42,$62,$20,$22,$80,$82,$84,$86,$8E,$A9,$69,$6A,$46
down1FlipXTiles:
	db $66,$E0,$E2,$E4,$40,$60,$42,$62,$20,$22,$80,$82,$76,$74,$8E,$69,$6A,$A9,$46
down2FlipXTiles:
	db $56,$E0,$E2,$E4,$40,$60,$42,$62,$20,$22,$80,$82,$86,$74,$8E,$69,$6A,$A9,$46
down3FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$86,$84,$8E,$69,$6A,$A9,$46
down4FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$86,$84,$8E,$69,$6A,$A9,$46
open1FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$C0,$C2,$C3,$46,$64,$E6
open2FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$AB,$25,$7E,$6C,$AB,$25,$CD
open3FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$88,$AD,$25,$88,$AD,$25,$44,$E8
open4FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$7E,$AB,$25,$6C,$AB,$25,$EA
open5FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$7E,$AB,$25,$6C,$AB,$25
attack1FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$7E,$AB,$25,$6C,$AB,$25,$46,$64
attack2FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$20,$22,$80,$82,$25,$7E,$AB,$25,$6C,$AB,$25,$46,$64
close1FlipXTiles:
	db $C5,$C7,$C9,$40,$60,$42,$62,$25,$20,$22,$80,$82,$C0,$C2,$C3,$46,$64
exp1FlipXTiles:
	db $63,$63,$63,$63
exp2FlipXTiles:
	db $C2,$C2,$C2,$C2
exp3FlipXTiles:
	db $C4,$E0,$C4,$E0
exp4FlipXTiles:
	db $C6,$E2,$C6,$E2
exp5FlipXTiles:
	db $C8,$E4,$E4,$C8
exp6FlipXTiles:
	db $CA,$E6,$E6,$CA
exp7FlipXTiles:
	db $CC,$E8,$E8,$CC
exp8FlipXTiles:
	db $CE,$CE


FramesHitboxXDisp:
stand1HitboxXDisp:
	dw $FFFA
stand2HitboxXDisp:
	dw $FFFA
down1HitboxXDisp:
	dw $FFFA
down2HitboxXDisp:
	dw $FFFA
down3HitboxXDisp:
	dw $FFFA
down4HitboxXDisp:
	dw $FFFA
open1HitboxXDisp:
	dw $FFFA
open2HitboxXDisp:
	dw $FFFA
open3HitboxXDisp:
	dw $FFFA
open4HitboxXDisp:
	dw $FFFA
open5HitboxXDisp:
	dw $FFFA
attack1HitboxXDisp:
	dw $FFFA
attack2HitboxXDisp:
	dw $FFFA
close1HitboxXDisp:
	dw $FFFA
exp1HitboxXDisp:
	dw $FFFF
exp2HitboxXDisp:
	dw $FFFF
exp3HitboxXDisp:
	dw $FFFF
exp4HitboxXDisp:
	dw $FFFF
exp5HitboxXDisp:
	dw $FFFF
exp6HitboxXDisp:
	dw $FFFF
exp7HitboxXDisp:
	dw $FFFF
exp8HitboxXDisp:
	dw $FFFF
stand1FlipXHitboxXDisp:
	dw $FFFA
stand2FlipXHitboxXDisp:
	dw $FFFA
down1FlipXHitboxXDisp:
	dw $FFFA
down2FlipXHitboxXDisp:
	dw $FFFA
down3FlipXHitboxXDisp:
	dw $FFFA
down4FlipXHitboxXDisp:
	dw $FFFA
open1FlipXHitboxXDisp:
	dw $FFFA
open2FlipXHitboxXDisp:
	dw $FFFA
open3FlipXHitboxXDisp:
	dw $FFFA
open4FlipXHitboxXDisp:
	dw $FFFA
open5FlipXHitboxXDisp:
	dw $FFFA
attack1FlipXHitboxXDisp:
	dw $FFFA
attack2FlipXHitboxXDisp:
	dw $FFFA
close1FlipXHitboxXDisp:
	dw $FFFC
exp1FlipXHitboxXDisp:
	dw $FFFF
exp2FlipXHitboxXDisp:
	dw $FFFF
exp3FlipXHitboxXDisp:
	dw $FFFF
exp4FlipXHitboxXDisp:
	dw $FFFF
exp5FlipXHitboxXDisp:
	dw $FFFF
exp6FlipXHitboxXDisp:
	dw $FFFF
exp7FlipXHitboxXDisp:
	dw $FFFF
exp8FlipXHitboxXDisp:
	dw $FFFF


FramesHitboxYDisp:
stand1HitboxyDisp:
	dw $FFDC
stand2HitboxyDisp:
	dw $FFDE
down1HitboxyDisp:
	dw $FFE2
down2HitboxyDisp:
	dw $FFE6
down3HitboxyDisp:
	dw $FFE8
down4HitboxyDisp:
	dw $FFE8
open1HitboxyDisp:
	dw $FFE6
open2HitboxyDisp:
	dw $FFE6
open3HitboxyDisp:
	dw $FFE6
open4HitboxyDisp:
	dw $FFE6
open5HitboxyDisp:
	dw $FFE6
attack1HitboxyDisp:
	dw $FFE6
attack2HitboxyDisp:
	dw $FFE6
close1HitboxyDisp:
	dw $FFE6
exp1HitboxyDisp:
	dw $FFFF
exp2HitboxyDisp:
	dw $FFFF
exp3HitboxyDisp:
	dw $FFFF
exp4HitboxyDisp:
	dw $FFFF
exp5HitboxyDisp:
	dw $FFFF
exp6HitboxyDisp:
	dw $FFFF
exp7HitboxyDisp:
	dw $FFFF
exp8HitboxyDisp:
	dw $FFFF
stand1FlipXHitboxyDisp:
	dw $FFDC
stand2FlipXHitboxyDisp:
	dw $FFDE
down1FlipXHitboxyDisp:
	dw $FFE2
down2FlipXHitboxyDisp:
	dw $FFE6
down3FlipXHitboxyDisp:
	dw $FFE8
down4FlipXHitboxyDisp:
	dw $FFE8
open1FlipXHitboxyDisp:
	dw $FFE6
open2FlipXHitboxyDisp:
	dw $FFE6
open3FlipXHitboxyDisp:
	dw $FFE6
open4FlipXHitboxyDisp:
	dw $FFE6
open5FlipXHitboxyDisp:
	dw $FFE6
attack1FlipXHitboxyDisp:
	dw $FFE6
attack2FlipXHitboxyDisp:
	dw $FFE6
close1FlipXHitboxyDisp:
	dw $FFE6
exp1FlipXHitboxyDisp:
	dw $FFFF
exp2FlipXHitboxyDisp:
	dw $FFFF
exp3FlipXHitboxyDisp:
	dw $FFFF
exp4FlipXHitboxyDisp:
	dw $FFFF
exp5FlipXHitboxyDisp:
	dw $FFFF
exp6FlipXHitboxyDisp:
	dw $FFFF
exp7FlipXHitboxyDisp:
	dw $FFFF
exp8FlipXHitboxyDisp:
	dw $FFFF


FramesHitboxWidth:
stand1HitboxWith:
	dw $001C
stand2HitboxWith:
	dw $001C
down1HitboxWith:
	dw $001C
down2HitboxWith:
	dw $001C
down3HitboxWith:
	dw $001C
down4HitboxWith:
	dw $001C
open1HitboxWith:
	dw $001C
open2HitboxWith:
	dw $001C
open3HitboxWith:
	dw $001C
open4HitboxWith:
	dw $001C
open5HitboxWith:
	dw $001C
attack1HitboxWith:
	dw $001C
attack2HitboxWith:
	dw $001C
close1HitboxWith:
	dw $001A
exp1HitboxWith:
	dw $FFFF
exp2HitboxWith:
	dw $FFFF
exp3HitboxWith:
	dw $FFFF
exp4HitboxWith:
	dw $FFFF
exp5HitboxWith:
	dw $FFFF
exp6HitboxWith:
	dw $FFFF
exp7HitboxWith:
	dw $FFFF
exp8HitboxWith:
	dw $FFFF
stand1FlipXHitboxWith:
	dw $001C
stand2FlipXHitboxWith:
	dw $001C
down1FlipXHitboxWith:
	dw $001C
down2FlipXHitboxWith:
	dw $001C
down3FlipXHitboxWith:
	dw $001C
down4FlipXHitboxWith:
	dw $001C
open1FlipXHitboxWith:
	dw $001C
open2FlipXHitboxWith:
	dw $001C
open3FlipXHitboxWith:
	dw $001C
open4FlipXHitboxWith:
	dw $001C
open5FlipXHitboxWith:
	dw $001C
attack1FlipXHitboxWith:
	dw $001C
attack2FlipXHitboxWith:
	dw $001C
close1FlipXHitboxWith:
	dw $001A
exp1FlipXHitboxWith:
	dw $FFFF
exp2FlipXHitboxWith:
	dw $FFFF
exp3FlipXHitboxWith:
	dw $FFFF
exp4FlipXHitboxWith:
	dw $FFFF
exp5FlipXHitboxWith:
	dw $FFFF
exp6FlipXHitboxWith:
	dw $FFFF
exp7FlipXHitboxWith:
	dw $FFFF
exp8FlipXHitboxWith:
	dw $FFFF


FramesHitboxHeigth:
stand1HitboxHeigth:
	dw $0034
stand2HitboxHeigth:
	dw $0032
down1HitboxHeigth:
	dw $002E
down2HitboxHeigth:
	dw $002A
down3HitboxHeigth:
	dw $0028
down4HitboxHeigth:
	dw $0028
open1HitboxHeigth:
	dw $002A
open2HitboxHeigth:
	dw $002A
open3HitboxHeigth:
	dw $002A
open4HitboxHeigth:
	dw $002A
open5HitboxHeigth:
	dw $002A
attack1HitboxHeigth:
	dw $002A
attack2HitboxHeigth:
	dw $002A
close1HitboxHeigth:
	dw $002A
exp1HitboxHeigth:
	dw $FFFF
exp2HitboxHeigth:
	dw $FFFF
exp3HitboxHeigth:
	dw $FFFF
exp4HitboxHeigth:
	dw $FFFF
exp5HitboxHeigth:
	dw $FFFF
exp6HitboxHeigth:
	dw $FFFF
exp7HitboxHeigth:
	dw $FFFF
exp8HitboxHeigth:
	dw $FFFF
stand1FlipXHitboxHeigth:
	dw $0034
stand2FlipXHitboxHeigth:
	dw $0032
down1FlipXHitboxHeigth:
	dw $002E
down2FlipXHitboxHeigth:
	dw $002A
down3FlipXHitboxHeigth:
	dw $0028
down4FlipXHitboxHeigth:
	dw $0028
open1FlipXHitboxHeigth:
	dw $002A
open2FlipXHitboxHeigth:
	dw $002A
open3FlipXHitboxHeigth:
	dw $002A
open4FlipXHitboxHeigth:
	dw $002A
open5FlipXHitboxHeigth:
	dw $002A
attack1FlipXHitboxHeigth:
	dw $002A
attack2FlipXHitboxHeigth:
	dw $002A
close1FlipXHitboxHeigth:
	dw $002A
exp1FlipXHitboxHeigth:
	dw $FFFF
exp2FlipXHitboxHeigth:
	dw $FFFF
exp3FlipXHitboxHeigth:
	dw $FFFF
exp4FlipXHitboxHeigth:
	dw $FFFF
exp5FlipXHitboxHeigth:
	dw $FFFF
exp6FlipXHitboxHeigth:
	dw $FFFF
exp7FlipXHitboxHeigth:
	dw $FFFF
exp8FlipXHitboxHeigth:
	dw $FFFF


FramesHitboxAction:
stand1HitboxAction:
	dw hurt
stand2HitboxAction:
	dw hurt
down1HitboxAction:
	dw hurt
down2HitboxAction:
	dw hurt
down3HitboxAction:
	dw hurt
down4HitboxAction:
	dw hurt
open1HitboxAction:
	dw hurt
open2HitboxAction:
	dw hurt
open3HitboxAction:
	dw hurt
open4HitboxAction:
	dw hurt
open5HitboxAction:
	dw hurt
attack1HitboxAction:
	dw hurt
attack2HitboxAction:
	dw hurt
close1HitboxAction:
	dw hurt
exp1HitboxAction:
	dw $FFFF
exp2HitboxAction:
	dw $FFFF
exp3HitboxAction:
	dw $FFFF
exp4HitboxAction:
	dw $FFFF
exp5HitboxAction:
	dw $FFFF
exp6HitboxAction:
	dw $FFFF
exp7HitboxAction:
	dw $FFFF
exp8HitboxAction:
	dw $FFFF
stand1FlipXHitboxAction:
	dw hurt
stand2FlipXHitboxAction:
	dw hurt
down1FlipXHitboxAction:
	dw hurt
down2FlipXHitboxAction:
	dw hurt
down3FlipXHitboxAction:
	dw hurt
down4FlipXHitboxAction:
	dw hurt
open1FlipXHitboxAction:
	dw hurt
open2FlipXHitboxAction:
	dw hurt
open3FlipXHitboxAction:
	dw hurt
open4FlipXHitboxAction:
	dw hurt
open5FlipXHitboxAction:
	dw hurt
attack1FlipXHitboxAction:
	dw hurt
attack2FlipXHitboxAction:
	dw hurt
close1FlipXHitboxAction:
	dw hurt
exp1FlipXHitboxAction:
	dw $FFFF
exp2FlipXHitboxAction:
	dw $FFFF
exp3FlipXHitboxAction:
	dw $FFFF
exp4FlipXHitboxAction:
	dw $FFFF
exp5FlipXHitboxAction:
	dw $FFFF
exp6FlipXHitboxAction:
	dw $FFFF
exp7FlipXHitboxAction:
	dw $FFFF
exp8FlipXHitboxAction:
	dw $FFFF


