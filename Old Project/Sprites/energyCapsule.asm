PRINT "INIT ",pc
incsrc parches\headers\header.asm
incsrc parches\headers\mmxheader.asm
;Point to the current frame
!FramePointer = $C2,x

;Point to the current frame on the animation
!AnFramePointer = $1504,x

;Point to the current animation
!AnPointer = $1510,x

;Time for the next frame change
!AnimationTimer = $1540,x

!noAdder = $1570,x

!smallHeal = #$02
!bigHeal = #$08

LDA $1570,x
CMP #$A7
BEQ +
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

LDA #$04
STA !AnimationTimer
STZ !AnFramePointer

LDA $7FAB10,x
AND #$04
BEQ +
	LDA #$03
	STA !FramePointer
	LDA #$02
	STA !AnPointer
RTL
+
	LDA #$07
	STA !FramePointer
	LDA #$06
	STA !AnPointer
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
	
	JSR InteractionWithMario
	JSR GraphicManager ;manage the frames of the sprite and decide what frame show
	LDA $D8,x
	STA $00
	LDA $14D4,x
	STA $01
	STZ $02
	REP #$20
	LDA !mmxYFloor
	BEQ +
	LDA $00
	CMP !mmxYFloor
	BCC +
	
	SEP #$20
	
	LDA !mmxYFloor
	STA $D8,x
	LDA !mmxYFloor+$01
	STA $14D4,x
	LDA #$04
	STA $02
	BRA ++
+
	SEP #$20
++
	JSL $01802A
	LDA $1588,x
	ORA $02
	STA $1588,x
	JSR checkFloor

	RTS
	
check: db $00,$00,$00,$01,$00,$00,$00,$01
newFrame: db $00,$00,$00,$00,$04,$04,$04,$04
checkFloor:

	LDA !FramePointer
	TAY
	LDA check,y
	BEQ +

	LDA $1588,x
	AND #$04
	BEQ +
	
	LDA newFrame,y
	STA !AnPointer
	STA !FramePointer
	LDA #$02
	STA !AnimationTimer
	STZ !AnFramePointer	
+
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
	dw $0000,$0004,$0005,$0009

AnimationsFrames:
brillarFrames:
	db $00,$01,$02,$01
idleAnFrames:
	db $03
bBrillarFrames:
	db $04,$05,$06,$05
bIdleAnFrames:
	db $07

AnimationsNFr:
brillarNext:
	db $01,$02,$03,$00
idleAnNext:
	db $00
bBrillarNext:
	db $01,$02,$03,$00
bIdleAnNext:
	db $00

AnimationsTFr:
brillarTimes:
	db $02,$02,$02,$02
idleAnTimes:
	db $06
bBrillarTimes:
	db $02,$02,$02,$02
bIdleAnTimes:
	db $06


;===================================
;Interaction
;===================================
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

;===================================
;Actions
;===================================
heal:
	TYX
	LDA !smallHeal
	JSL !mmxHeal
	STZ $14C8,x
	;Put your code for this action here
RTS

bheal:
	TYX
	LDA !bigHeal
	JSL !mmxHeal
	STZ $14C8,x
	;Put your code for this action here
RTS

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
	LDY #$00 ;load the size
	JSL $01B7B3 ;call the oam routine
	RTS
	
;===================================
;Frames
;===================================
FramesTotalTiles:

	db $01,$01,$01,$01,$03,$03,$03,$03

StartPositionFrames:
	dw $0001,$0003,$0005,$0007,$000B,$000F,$0013,$0017

EndPositionFrames:
	dw $0000,$0002,$0004,$0006,$0008,$000C,$0010,$0014

TotalHitboxes:
	db $00,$00,$00,$00,$00,$00,$00,$00

StartPositionHitboxes:
	dw $0000,$0002,$0004,$0006,$0008,$000A,$000C,$000E

EndPositionHitboxes:
	dw $0000,$0002,$0004,$0006,$0008,$000A,$000C,$000E

FramesXDisp:
f1XDisp:
	db $00,$08
f2XDisp:
	db $00,$08
f3XDisp:
	db $00,$08
idleXDisp:
	db $00,$08
bf1XDisp:
	db $00,$00,$08,$08
bf2XDisp:
	db $00,$00,$08,$08
bf3XDisp:
	db $00,$00,$08,$08
bidleXDisp:
	db $00,$00,$08,$08


FramesYDisp:
f1yDisp:
	db $08,$08
f2yDisp:
	db $08,$08
f3yDisp:
	db $08,$08
idleyDisp:
	db $08,$08
bf1yDisp:
	db $02,$0A,$0A,$02
bf2yDisp:
	db $02,$0A,$02,$0A
bf3yDisp:
	db $02,$0A,$02,$0A
bidleyDisp:
	db $02,$0A,$0A,$02


FramesPropertie:
f1Properties:
	db $3C,$7C
f2Properties:
	db $3C,$7C
f3Properties:
	db $3C,$7C
idleProperties:
	db $3C,$7C
bf1Properties:
	db $3C,$BC,$FC,$7C
bf2Properties:
	db $3C,$BC,$7C,$FC
bf3Properties:
	db $3C,$BC,$7C,$FC
bidleProperties:
	db $3C,$BC,$FC,$7C


FramesTile:
f1Tiles:
	db $4A,$4A
f2Tiles:
	db $5A,$5A
f3Tiles:
	db $4B,$4B
idleTiles:
	db $76,$76
bf1Tiles:
	db $4C,$4C,$4C,$4C
bf2Tiles:
	db $5C,$5C,$5C,$5C
bf3Tiles:
	db $4D,$4D,$4D,$4D
bidleTiles:
	db $5B,$5B,$5B,$5B


FramesHitboxXDisp:
f1HitboxXDisp:
	dw $0004
f2HitboxXDisp:
	dw $0004
f3HitboxXDisp:
	dw $0004
idleHitboxXDisp:
	dw $0006
bf1HitboxXDisp:
	dw $0002
bf2HitboxXDisp:
	dw $0002
bf3HitboxXDisp:
	dw $0002
bidleHitboxXDisp:
	dw $0004


FramesHitboxYDisp:
f1HitboxyDisp:
	dw $0008
f2HitboxyDisp:
	dw $0008
f3HitboxyDisp:
	dw $0008
idleHitboxyDisp:
	dw $0008
bf1HitboxyDisp:
	dw $0006
bf2HitboxyDisp:
	dw $0006
bf3HitboxyDisp:
	dw $0006
bidleHitboxyDisp:
	dw $0006


FramesHitboxWidth:
f1HitboxWith:
	dw $0008
f2HitboxWith:
	dw $0008
f3HitboxWith:
	dw $0008
idleHitboxWith:
	dw $0004
bf1HitboxWith:
	dw $000C
bf2HitboxWith:
	dw $000C
bf3HitboxWith:
	dw $000C
bidleHitboxWith:
	dw $0008


FramesHitboxHeigth:
f1HitboxHeigth:
	dw $0008
f2HitboxHeigth:
	dw $0008
f3HitboxHeigth:
	dw $0008
idleHitboxHeigth:
	dw $0008
bf1HitboxHeigth:
	dw $0008
bf2HitboxHeigth:
	dw $0008
bf3HitboxHeigth:
	dw $0008
bidleHitboxHeigth:
	dw $0008


FramesHitboxAction:
f1HitboxAction:
	dw heal
f2HitboxAction:
	dw heal
f3HitboxAction:
	dw heal
idleHitboxAction:
	dw heal
bf1HitboxAction:
	dw bheal
bf2HitboxAction:
	dw bheal
bf3HitboxAction:
	dw bheal
bidleHitboxAction:
	dw bheal


