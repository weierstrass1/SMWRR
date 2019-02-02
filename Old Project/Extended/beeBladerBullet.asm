header : lorom

incsrc beeBladerBulletHeader.asm
incsrc ../parches/headers/mmxheader.asm

org !beeBladerBulletFreeSpace

db "ST","AR"			;
dw end-start-$01		;Rats tag que protegen tu data del LM
dw end-start-$01^$FFFF		

start:

	JML beeBladerBulletCode

beeBladerBulletCode:

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

	JSR detectHigh
	JSR Graphics ;graphic routine

	LDA $9D				;\
	BNE Return			;/ If locked, return.
	
	JSR InteractionWithMario
	JSR GraphicManager ;manage the frames of the sprite and decide what frame show
	
	RTS
	
detectHigh:

	LDA !AnPointer
	BNE +
	
	LDA $1715,x
	STA $02
	LDA $1729,x
	STA $03
	
	REP #$20
	LDA $02
	CMP #$0088	
	SEP #$20
	BCC +
	
	LDA #$88
	STA $1715,x
	STZ $173D,x
	STZ $1747,x
	
	LDA #$01
	STA !FramePointer
	LDA #$02
	STA !AnPointer
	LDA #$04
	STA !AnimationTimer
+
	RTS
	
;===================================
;Graphic Manager
;===================================	
GraphicManager:

	;if !AnimationTimer is Zero go to the next frame
	LDA !AnimationTimer
	BEQ ChangeFrame
	DEC A
	STA !AnimationTimer
	RTS

ChangeFrame:

	LDA !FramePointer
	CMP #$04
	BNE +
	STZ $170B,x
	RTS
+
	LDA #$04
	STA !AnimationTimer
	;Load the animation pointer X2
	LDA !AnPointer
	BEQ +
	
	STZ $173D,x
	STZ $1747,x

	LDA !FramePointer
	INC A
	STA !FramePointer
	
+
	
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
	db $01,$02,$03,$04

AnimationsTFr:
normalTimes:
	db $04
deadTimes:
	db $04,$04,$04,$04


;===================================
;Interaction
;===================================
marioHeigth: dw $0011,$001A,$000B,$000D,$0021,$002A
marioYDisp: dw	$000E,$0005,$0014,$0012,$000E,$0005
InteractionWithMario:

	LDA !FramePointer
	TAY
	LDA TotalHitboxes,y
	BPL +
	RTS
+
	STZ $00
	LDA $19
	BEQ +
	LDA #$02
	STA $00
+
	LDA $73
	BEQ +
	LDA #$04
	ORA $00
	STA $00	
+
	LDA $187A
	CMP #$01
	BNE +
	LDA #$08
	ORA $00
	STA $00
+
	LDY $0000
	
	REP #$20
	LDA $96
	CLC
	ADC marioYDisp,y
	STA $04
	CLC
	ADC marioHeigth,y
	STA $06
	BPL +
	SEP #$20
	RTS
+
	
	LDA $04
	BPL +
	LDA #$0000
	STA $04
+
	SEP #$20
	
	LDA $171F,x
	STA $00
	LDA $1733,x
	STA $01
	
	LDA $1715,x
	STA $02
	LDA $1729,x
	STA $03	
	
	LDA !FramePointer
	REP #$30
	AND #$00FF
	ASL
	TAY ;load the frame pointer on Y
	
	LDA StartPositionHitboxes,y
	STA $08
	
	LDA EndPositionHitboxes,y
	STA $0A

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
	LDA #$0000
	STA $000E ;if x+xdisp < 0 then x+xdisp = 0
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
	LDA #$0000
	STA $000E ;if y + ydisp < 0 then y + ydisp = 0
+	
	LDA $06
	CMP $0E
	BCC .next ;if yMario + ydispMario + heigthMario < y + ydisp then gotonext
	
	PHY
	SEP #$30
	JSR hurt ;make action of this hitbox
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
	LDA #$01
	JSL !mmxDamage
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
	
	LDA $171F,x
	STA $0A
	LDA $1733,x
	STA $0B
	
	LDA $1715,x
	STA $0C
	LDA $1729,x
	STA $0D
	
	STZ $07
	STZ $09
	
	LDA .oamStuff,x
	STA $00
	STZ $01
	
	PHX
	
	PHX
	LDA !FramePointer
	TAX 
	LDA FrameSizes,x
	PLX
	PHA ;$01,s
	
	LDA !FramePointer
	
	REP #$30

	AND #$00FF
	ASL
	TAX
	
	LDA EndPositionFrames,x
	STA $0E
	
	LDA StartPositionFrames,x
	TAX
	
	LDA $0C
	CLC
	ADC #$FFF0
	STA $0C
	SEP #$20
	
	LDY $0000
	
.loop

	STZ $07
	LDA FramesXDisp,x 
	STA $06
	BPL +
	LDA #$FF
	STA $07
+
	STZ $09
	LDA FramesYDisp,x
	STA $08
	BPL +
	LDA #$FF
	STA $09
+	
	REP #$20
	LDA $0A
	CLC
	ADC $06
	STA $00
	
	LDA $0C
	CLC
	ADC $08
	STA $02
	SEP #$20
	
	LDA $01,s
	STA $04
	
	PHY
	SEP #$10
	JSL getDrawInfo200
	REP #$10
	PLY
	LDA $06
	BNE .next

	LDA $00
	STA $0200,y ;load the tile X position

	LDA $02
	STA $0201,y ;load the tile Y position

	LDA FramesPropertie,x
	ORA $64
	STA $0203,y ;load the tile Propertie

	LDA FramesTile,x
	STA $0202,y ;load the tile

	PHY
	REP #$20
	TYA
	LSR
	LSR	
	TAY
	SEP #$20
	LDA $04;ponemos el tamano del grafico con su modalidad
	STA $0420,y
	PLY
	
.next
	INY
	INY
	INY
	INY ;next slot

	DEX
	BMI +
	CPX $0E
	BCS .loop ;if Y < 0 exit to loop
+
	SEP #$10
	PLA
	PLX
	RTS
	
.oamStuff db $70,80,$70,80,$70,80,$70,80,$70,80
	
;===================================
;Frames
;===================================
FramesTotalTiles:

	db $00,$01,$03,$00,$00
	
FrameSizes:
	db $00,$00,$00,$00,$00

StartPositionFrames:
	dw $0000,$0002,$0006,$0007,$0008

EndPositionFrames:
	dw $0000,$0001,$0003,$0007,$0008

TotalHitboxes:
	db $00,$00,$00,$FF,$FF

StartPositionHitboxes:
	dw $0000,$0002,$0004,$0006,$0008

EndPositionHitboxes:
	dw $0000,$0002,$0004,$0006,$0008

FramesXDisp:
f1XDisp:
	db $00
f2XDisp:
	db $F9,$00
f3XDisp:
	db $F9,$F9,$00,$00
f4XDisp:
	db $FC
f5XDisp:
	db $FC


FramesYDisp:
f1yDisp:
	db $00
f2yDisp:
	db $00,$00
f3yDisp:
	db $F8,$00,$F8,$00
f4yDisp:
	db $00
f5yDisp:
	db $00


FramesPropertie:
f1Properties:
	db $26
f2Properties:
	db $26,$66
f3Properties:
	db $26,$26,$66,$66
f4Properties:
	db $26
f5Properties:
	db $26


FramesTile:
f1Tiles:
	db $A5
f2Tiles:
	db $B5,$B5
f3Tiles:
	db $A7,$B7,$A7,$B7
f4Tiles:
	db $A6
f5Tiles:
	db $B6


FramesHitboxXDisp:
f1HitboxXDisp:
	dw $0000
f2HitboxXDisp:
	dw $FFFC
f3HitboxXDisp:
	dw $FFFC
f4HitboxXDisp:
	dw $FFFF
f5HitboxXDisp:
	dw $FFFF


FramesHitboxYDisp:
f1HitboxyDisp:
	dw $FFF6
f2HitboxyDisp:
	dw $FFF6
f3HitboxyDisp:
	dw $FFFE
f4HitboxyDisp:
	dw $FFFF
f5HitboxyDisp:
	dw $FFFF


FramesHitboxWidth:
f1HitboxWith:
	dw $0004
f2HitboxWith:
	dw $0008
f3HitboxWith:
	dw $0008
f4HitboxWith:
	dw $FFFF
f5HitboxWith:
	dw $FFFF


FramesHitboxHeigth:
f1HitboxHeigth:
	dw $0004
f2HitboxHeigth:
	dw $0004
f3HitboxHeigth:
	dw $0008
f4HitboxHeigth:
	dw $FFFF
f5HitboxHeigth:
	dw $FFFF


FramesHitboxAction:
f1HitboxAction:
	dw hurt
f2HitboxAction:
	dw hurt
f3HitboxAction:
	dw hurt
f4HitboxAction:
	dw $FFFF
f5HitboxAction:
	dw $FFFF

getDrawInfo200:
	PHY
	LDA $04
	STA $05
	STZ $06
	REP #$20
	
	LDA $00
	SEC
	SBC $1A
	STA $00
	
	CMP #$0100
	BCC ++
	
	CMP #$FFF1
	BCS +
	
	SEP #$20
	LDA #$01
	STA $06
	PLY
	RTL
+
	LDY $05
	INY
	STY $04
++
	LDA $02
	SEC
	SBC $1C
	STA $02
	
	CMP #$00F0
	BCS ++	

	CMP #$00E0
	BCS +
	SEP #$20
	PLY
	RTL
	
++
	CMP #$FFF1
	BCS ++
	
	SEP #$20
	LDA #$01
	STA $06
	PLY
	RTL
+
	LDY $05
	INY
	STY $04
++
	SEP #$20
	PLY
	RTL
end:
