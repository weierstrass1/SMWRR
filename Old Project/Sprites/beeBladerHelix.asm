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


LDA $E4,x
STA $00
LDA $14E0,x
STA $01

REP #$20
LDA $00
CLC
ADC #$0008
STA $00
SEP #$20

LDA $00
STA $E4,x
LDA $01
STA $14E0,x

STZ !FramePointer
STZ !AnPointer
STZ !AnFramePointer
LDA #$04
STA !AnimationTimer

TXA
STA !mmxBeeHelixX

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
rotateFrames:
	db $00,$01,$02,$03,$00,$03,$02,$01

AnimationsNFr:
rotateNext:
	db $01,$02,$03,$04,$05,$06,$07,$00

AnimationsTFr:
rotateTimes:
	db $01,$01,$01,$01,$01,$01,$01,$01

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
	LDY #$02 ;load the size
	JSL $01B7B3 ;call the oam routine
	RTS
	
;===================================
;Frames
;===================================
FramesTotalTiles:

	db $09,$05,$01,$05

StartPositionFrames:
	dw $0009,$000F,$0011,$0017

EndPositionFrames:
	dw $0000,$000A,$0010,$0012

FramesXDisp:
f1XDisp:
	db $0E,$1E,$3E,$2E,$E2,$D2,$F2,$C2,$00,$00
f2XDisp:
	db $10,$00,$00,$E0,$F0,$00
f3XDisp:
	db $00,$00
f4XDisp:
	db $F0,$00,$00,$20,$10,$00


FramesYDisp:
f1yDisp:
	db $05,$05,$05,$05,$05,$05,$05,$05,$00,$01
f2yDisp:
	db $00,$00,$00,$00,$00,$01
f3yDisp:
	db $00,$01
f4yDisp:
	db $00,$00,$00,$00,$00,$01


FramesPropertie:
f1Properties:
	db $36,$36,$36,$36,$36,$36,$76,$76,$36,$B6
f2Properties:
	db $36,$36,$36,$36,$36,$B6
f3Properties:
	db $36,$B6
f4Properties:
	db $76,$36,$76,$76,$76,$B6


FramesTile:
f1Tiles:
	db $44,$45,$46,$45,$45,$45,$44,$46,$EE,$8C
f2Tiles:
	db $48,$04,$4E,$06,$08,$8C
f3Tiles:
	db $EE,$8C
f4Tiles:
	db $48,$04,$4E,$06,$08,$8C


