PRINT "INIT ",pc
incsrc sprites\header.asm
;Point to the current frame
!FramePointer = $C2,x

;Point to the current frame on the animation
!AnFramePointer = $1504,x

;Point to the current animation
!AnPointer = $1510,x

;Time for the next frame change
!AnimationTimer = $1540,x


STZ !FramePointer
STZ !AnPointer
STZ !AnFramePointer
LDA #$01
STA !AnimationTimer

PHB
PHK
PLB
JSR Graphics
PLB

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
	
	
	JSR GraphicManager ;manage the frames of the sprite and decide what frame show
	
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

	LDA !FramePointer
	CMP #$07
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
	
	
	
	RTS	


;===================================
;Animation
;===================================
EndPositionAnim:
	dw $0000

AnimationsFrames:
explosionFrames:
	db $00,$01,$00,$02,$03,$04,$05,$06,$07

AnimationsNFr:
explosionNext:
	db $01,$02,$03,$04,$05,$06,$07,$08,$00

AnimationsTFr:
explosionTimes:
	db $02,$03,$02,$04,$04,$04,$04,$04,$04

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
	LDA FrameSizes,y
	STA $00
	LDA FramesTotalTiles,y ;load the total of tiles on $0E
	LDY $0000 ;load the size
	JSL $01B7B3 ;call the oam routine
	RTS
	
;===================================
;Frames
;===================================
FramesTotalTiles:

	db $03,$03,$03,$03,$03,$03,$03,$01
	
FrameSizes:
	db $00,$02,$02,$02,$02,$02,$02,$02

StartPositionFrames:
	dw $0003,$0007,$000B,$000F,$0013,$0017,$001B,$001D

EndPositionFrames:
	dw $0000,$0004,$0008,$000C,$0010,$0014,$0018,$001C

FramesXDisp:
exp1XDisp:
	db $00,$08,$08,$00
exp2XDisp:
	db $F8,$08,$F8,$08
exp3XDisp:
	db $F8,$F8,$08,$08
exp4XDisp:
	db $F8,$08,$F8,$08
exp5XDisp:
	db $F8,$08,$F8,$08
exp6XDisp:
	db $F8,$08,$F8,$08
exp7XDisp:
	db $F8,$08,$F8,$08
exp8XDisp:
	db $F8,$08


FramesYDisp:
exp1yDisp:
	db $00,$00,$08,$08
exp2yDisp:
	db $F8,$F8,$08,$08
exp3yDisp:
	db $F8,$08,$08,$F8
exp4yDisp:
	db $F6,$F6,$06,$06
exp5yDisp:
	db $F4,$F4,$04,$04
exp6yDisp:
	db $F0,$F0,$00,$00
exp7yDisp:
	db $EE,$EE,$FE,$FE
exp8yDisp:
	db $F2,$F2


FramesPropertie:
exp1Properties:
	db $3C,$7C,$FC,$BC
exp2Properties:
	db $3C,$7C,$BC,$FC
exp3Properties:
	db $3C,$3C,$7C,$7C
exp4Properties:
	db $3C,$7C,$3C,$7C
exp5Properties:
	db $3C,$7C,$3C,$7C
exp6Properties:
	db $3C,$7C,$3C,$7C
exp7Properties:
	db $3C,$7C,$3C,$7C
exp8Properties:
	db $3C,$7C


FramesTile:
exp1Tiles:
	db $63,$63,$63,$63
exp2Tiles:
	db $C2,$C2,$C2,$C2
exp3Tiles:
	db $C4,$E0,$E0,$C4
exp4Tiles:
	db $C6,$C6,$E2,$E2
exp5Tiles:
	db $C8,$C8,$E4,$E4
exp6Tiles:
	db $CA,$CA,$E6,$E6
exp7Tiles:
	db $CC,$CC,$E8,$E8
exp8Tiles:
	db $CE,$CE


