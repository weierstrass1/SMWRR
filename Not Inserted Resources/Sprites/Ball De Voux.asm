;########################################
;########### Editable Constants #########
;########################################
!XRotateSpeedNormal = $08
!XRotateSpeedHard = $10
!XRotateSpeedKaizo = $20
!XRotateFrictionNormal = $01
!XRotateFrictionHard = $02
!XRotateFrictionKaizo = $03
!RotateAnimationSpeedNormal = $08
!RotateAnimationSpeedHard = $06
!RotateAnimationSpeedKaizo = $04
!WalkAnimationSpeedNormal = $06
!WalkAnimationSpeedHard = $04
!WalkAnimationSpeedKaizo = $02
!BounceDivider = #$01
!BounceMinSpeed = #$08

;########################################

	!dp = $0000
	!addr = $0000
    !rom = $800000
	!sa1 = 0
	!gsu = 0
    !sram7000 = $000000
    !sram7008 = $000000
    !ram7F9A7B = $000000
    !ram7FC700 = $000000

if read1($00FFD6) == $15
	sfxrom
	!dp = $6000
	!addr = !dp
	!gsu = 1
elseif read1($00FFD5) == $23
	sa1rom
	!dp = $3000
	!addr = $6000
	!sa1 = 1
    !rom = $000000
    !sram7000 = $2E4000
    !sram7008 = $2E6800
    !ram7F9A7B = $3E127B
    !ram7FC700 = $3DFF00
endif

;########################################
;######## Scratchs Rams [$00,$0F] #######
;########################################
!Scratch0 = $00
!Scratch1 = $01
!Scratch2 = $02
!Scratch3 = $03
!Scratch4 = $04
!Scratch5 = $05
!Scratch6 = $06
!Scratch7 = $07
!Scratch8 = $08
!Scratch9 = $09
!ScratchA = $0A
!ScratchB = $0B
!ScratchC = $0C
!ScratchD = $0D
!ScratchE = $0E
!ScratchF = $0F

;########################################
;############## Counters ################
;########################################
!TrueFrameCounter = $13
!EffectiveFrameCounter = $14

;########################################
;############## Control #################
;########################################
!ButtonPressed_BYETUDLR = $15
!ButtonDown_BYETUDLR = $16
!ButtonPressed_AXLR0000 = $17
!ButtonDown_AXLR0000 = $18

;########################################
;############## Layers ##################
;########################################
!Layer1X = $1A
!Layer1Y = $1C
!Layer2X = $1E
!Layer2Y = $20
!Layer3X = $22
!Layer3Y = $24

;########################################
;############## Player ##################
;########################################
!PlayerX = $94
!PlayerY = $96
!PlayerXSpeed = $7B
!PlayerYSpeed = $7D
!PowerUp = $19
!Lives = $0DBE|!addr
!Coins = $0DBF|!addr
!ItemBox = $0DC2|!addr
!PlayerInAirFlag = $72
!PlayerDuckingFlag = $73
!PlayerClimbingFlag_N00SIFHB = $74
!PlayerWaterFlag = $75
!PlayerDirection = $76
!PlayerBlockedStatus_S00MUDLR = $77
!PlayerHide_DLUCAPLU = $78
!CurrentPlayer = $0DB3|!addr
!CapeImage = $13DF|!addr
!PlayerPose = $13E0|!addr
!PlayerSlope = $13E1|!addr
!SpinjumpTimer = $13E2|!addr
!PlayerWallRunningFlag = $13E3|!addr
!PlayerFrozenFlag = $13FB|!addr
!PlayerCarryingFlag = $1470|!addr
!PlayerCarryingFlagImage = $148F|!addr
!PlayerAnimationTimer = $1496|!addr
!PlayerFlashingTimer = $1497|!addr
!P1PowerUp = $0DB8|!addr
!P2PowerUp = $0DB9|!addr
!P1Lives = $0DB4|!addr
!P2Lives = $0DB5|!addr
!P1Coins = $0DB6|!addr
!P2Coins = $0DB7|!addr
!P1YoshiColor = $0DBA|!addr
!P2YoshiColor = $0DBB|!addr
!P1ItemBox = $0DBC|!addr
!P2ItemBox = $0DBD|!addr

;########################################
;############### Global #################
;########################################
!LockAnimationFlag = $9D
!HScrollEnable = $1411|!addr
!VScrollEnable = $1412|!addr
!HScrollLayer2Type = $1413|!addr
!VScrollLayer2Type = $1414|!addr
!WaterFlag = $85
!SlipperyFlag = $86
!GameMode = $0100|!addr
!TwoPlayersFlag = $0DB2|!addr

;########################################
;################ OAM ###################
;########################################
!TileXPosition200 = $0200|!addr
!TileYPosition200 = $0201|!addr
!TileCode200 = $0202|!addr
!TileProperty200 = $0203|!addr
!TileSize420 = $0420|!addr
!TileXPosition = $0300|!addr
!TileYPosition = $0301|!addr
!TileCode = $0302|!addr
!TileProperty = $0303|!addr
!TileSize460 = $0460|!addr

;########################################
;############### Yoshi ##################
;########################################
!YoshiX = $18B0|!addr
!YoshiY = $18B2|!addr
!YoshiKeyInMouthFlag = $191C|!addr

;########################################
;############## Clusters ################
;########################################
!ClusterNumber = $1892|!addr
!ClusterXLow = $1E16|!addr
!ClusterYLow = $1E02|!addr
!ClusterXHigh = $1E3E|!addr
!ClusterYHigh = $1E2A|!addr
!ClusterMiscTable1 = $0F4A|!addr
!ClusterMiscTable2 = $0F5E|!addr
!ClusterMiscTable3 = $0F72|!addr
!ClusterMiscTable4 = $0F86|!addr
!ClusterMiscTable5 = $0F9A|!addr
!ClusterMiscTable6 = $1E52|!addr
!ClusterMiscTable7 = $1E66|!addr
!ClusterMiscTable8 = $1E7A|!addr
!ClusterMiscTable9 = $1E8E|!addr

;########################################
;############## Extended ################
;########################################
!ExtendedNumber = $170B|!addr
!ExtendedXLow = $171F|!addr
!ExtendedYLow = $1715|!addr
!ExtendedXHigh = $1733|!addr
!ExtendedYHigh = $1729|!addr
!ExtendedXSpeed = $1747|!addr
!ExtendedYSpeed = $173D|!addr
!ExtendedXSpeedAccumulatingFraction = $175B|!addr
!ExtendedYSpeedAccumulatingFraction = $1751|!addr
!ExtendedBehindLayersFlag = $1779|!addr
!ExtendedMiscTable1 = $1765|!addr
!ExtendedMiscTable2 = $176F|!addr

;########################################
;############### Sprites ################
;########################################
!SpriteIndex = $15E9|!addr
!SpriteNumber = $9E
!SpriteStatus = $14C8
!SpriteXLow = $E4
!SpriteYLow = $D8
!SpriteXHigh = $14E0
!SpriteYHigh = $14D4
!SpriteXSpeed = $B6
!SpriteYSpeed = $AA
!SpriteXSpeedAccumulatingFraction = $14F8
!SpriteYSpeedAccumulatingFraction = $14EC
!SpriteDirection = $157C
!SpriteBlockedStatus_ASB0UDLR = $1588
!SpriteHOffScreenFlag = $15A0
!SpriteVOffScreenFlag = $186C
!SpriteHMoreThan4TilesOffScreenFlag = $15C4
!SpriteSlope = $15B8
!SpriteYoshiTongueFlag = $15D0
!SpriteInteractionWithObjectEnable = $15DC
!SpriteIndexOAM = $15EA
!SpriteProperties_YXPPCCCT = $15F6
!SpriteLoadStatus = $161A
!SpriteBehindEscenaryFlag = $1632
!SpriteInLiquidFlag = $164A
!SpriteDecTimer1 = $1540
!SpriteDecTimer2 = $154C
!SpriteDecTimer3 = $1558
!SpriteDecTimer4 = $1564
!SpriteDecTimer5 = $15AC
!SpriteDecTimer6 = $163E
!SpriteDecTimer7 = $1FE2
!SpriteTweaker1656_SSJJCCCC = $1656
!SpriteTweaker1662_DSCCCCCC = $1662
!SpriteTweaker166E_LWCFPPPG = $166E
!SpriteTweaker167A_DPMKSPIS = $167A
!SpriteTweaker1686_DNCTSWYE = $1686
!SpriteTweaker190F_WCDJ5SDP = $190F
!SpriteMiscTable1 = $0DF5|!addr
!SpriteMiscTable2 = $0E0B|!addr
!SpriteMiscTable3 = $C2
!SpriteMiscTable4 = $1504
!SpriteMiscTable5 = $1510
!SpriteMiscTable6 = $151C
!SpriteMiscTable7 = $1528
!SpriteMiscTable8 = $1534
!SpriteMiscTable9 = $1570
!SpriteMiscTable10 = $1594
!SpriteMiscTable11 = $1602
!SpriteMiscTable12 = $160E
!SpriteMiscTable13 = $1626
!SpriteMiscTable14 = $187B
!SpriteMiscTable15 = $1FD6

;########################################
;############### GIEPY ##################
;########################################
!ExtraBits = $7FAB10
!NewCodeFlag = $7FAB1C
!ExtraProp1 = $7FAB28
!ExtraProp2 = $7FAB34
!ExtraByte1 = $7FAB40
!ExtraByte2 = $7FAB4C
!ExtraByte3 = $7FAB58
!ExtraByte4 = $7FAB64
!ShooterExtraByte = $7FAB70
!GeneratorExtraByte = $7FAB78
!ScrollerExtraByte = $7FAB79
!CustomSpriteNumber = $7FAB9E
!ShooterExtraBits = $7FABAA
!GeneratorExtraBits = $7FABB2
!Layer1ExtraBits = $7FABB3
!Layer2ExtraBits = $7FABB4
!SpriteFlags = $7FABB5

if !sa1

!SpriteNumber = $3200
!SpriteYSpeed = $9E
!SpriteXSpeed = $B6
!SpriteMiscTable3 = $D8
!SpriteYLow = $3216
!SpriteXLow = $322C
!SpriteStatus = $3242
!SpriteYHigh = $3258
!SpriteXHigh = $326E
!SpriteYSpeedAccumulatingFraction = $74C8
!SpriteXSpeedAccumulatingFraction = $74DE
!SpriteMiscTable4 = $74F4
!SpriteMiscTable5 = $750A
!SpriteMiscTable6 = $3284
!SpriteMiscTable7 = $329A
!SpriteMiscTable8 = $32B0
!SpriteDecTimer1 = $32C6
!SpriteDecTimer2 = $32DC
!SpriteDecTimer3 = $32F2
!SpriteDecTimer4 = $3308
!SpriteMiscTable9 = $331E
!SpriteDirection = $3334
!SpriteBlockedStatus_ASB0UDLR = $334A
!SpriteMiscTable10 = $3360
!SpriteHOffScreenFlag = $3376
!SpriteDecTimer5 = $338C
!SpriteSlope = $7520
!SpriteHMoreThan4TilesOffScreenFlag = $7536
!SpriteYoshiTongueFlag = $754C
!SpriteInteractionWithObjectEnable = $7562
!SpriteIndexOAM = $33A2
!SpriteProperties_YXPPCCCT = $33B8
!SpriteMiscTable11 = $33CE
!SpriteMiscTable12 = $33E4
!SpriteLoadStatus = $7578
!SpriteMiscTable13 = $758E
!SpriteBehindEscenaryFlag = $75A4
!SpriteDecTimer6 = $33FA
!SpriteInLiquidFlag = $75BA
!SpriteTweaker1656_SSJJCCCC = $75D0
!SpriteTweaker1662_DSCCCCCC = $75EA
!SpriteTweaker166E_LWCFPPPG = $7600
!SpriteTweaker167A_DPMKSPIS = $7616
!SpriteTweaker1686_DNCTSWYE = $762C
!SpriteVOffScreenFlag = $7642
!SpriteMiscTable14 = $3410
!SpriteTweaker190F_WCDJ5SDP = $7658
!SpriteMiscTable15 = $766E
!SpriteDecTimer7 = $7FD6

!ExtraBits = $400040
!NewCodeFlag = $400056
!ExtraProp1 = $400057
!ExtraProp2 = $40006D
!ExtraByte1 = $4000A4
!ExtraByte2 = $4000BA
!ExtraByte3 = $4000D0
!ExtraByte4 = $4000E6
!ShooterExtraByte = $400110
!GeneratorExtraByte = $4000FC
!ScrollerExtraByte = $4000FD
!CustomSpriteNumber = $400083
!ShooterExtraBits = $400099
!GeneratorExtraBits = $4000A1
!Layer1ExtraBits = $4000A2
!Layer2ExtraBits = $4000A3
!SpriteFlags = $400118

endif 

;######################################
;############## Defines ###############
;######################################

!FrameIndex = !SpriteMiscTable1
!AnimationTimer = !SpriteDecTimer1
!AnimationIndex = !SpriteMiscTable2
!AnimationFrameIndex = !SpriteMiscTable3
!LocalFlip = !SpriteMiscTable4
!GlobalFlip = !SpriteDirection
!State = !SpriteMiscTable6
!DifficultLevel = $58

;######################################
;########### Init Routine #############
;######################################
print "INIT ",pc
	LDA #$00
	STA !GlobalFlip,x
	LDA #$00
	STA !FrameIndex,x
	LDA #$FF
	STA !AnimationIndex,x
	LDA #$00
	STA !State,x
	LDA #$00
	STA !DifficultLevel
    ;Here you can write your Init Code
    ;This will be excecuted when the sprite is spawned 
RTL

;######################################
;########## Main Routine ##############
;######################################
print "MAIN ",pc
    PHB
    PHK
    PLB
    JSR SpriteCode
    PLB
RTL

;>Routine: SpriteCode
;>Description: This routine excecute the logic of the sprite
;>RoutineLength: Short
Return:
RTS
SpriteCode:

    JSR GraphicRoutine                  ;Calls the graphic routine and updates sprite graphics

    ;Here you can put code that will be excecuted each frame even if the sprite is locked

    LDA !SpriteStatus,x			        
	CMP #$08                            ;if sprite dead return
	BNE Return	

	LDA !LockAnimationFlag				    
	BNE Return			                    ;if locked animation return.

    JSL SubOffScreen

    JSR InteractMarioSprite
    ;After this routine, if the sprite interact with mario, Carry is Set.

	JSR StateMachine
    ;Here you can write your sprite code routine
    ;This will be excecuted once per frame excepts when 
    ;the animation is locked or when sprite status is not #$08

    JSR AnimationRoutine                ;Calls animation routine and decides the next frame to draw
    
    RTS

;>EndRoutine

;######################################
;######## Sub Routine Space ###########
;######################################

StateMachine:
	LDA !State,x
	ASL
	TAY

	REP #$20
	LDA States,y
	STA !Scratch0
	SEP #$20

	LDX #$00
	JSR ($0000|!dp,x)
RTS

States:
	dw Rotate
	dw Raising
	dw Walk
	dw Flip
	dw Dead

FrictionTable: db !XRotateFrictionNormal,!XRotateFrictionHard,!XRotateFrictionKaizo,$00,-!XRotateFrictionNormal,-!XRotateFrictionHard,-!XRotateFrictionKaizo
ApplyFriction:
	LDA !EffectiveFrameCounter
	AND #$03
	BEQ +
	RTS
+
	LDA !SpriteBlockedStatus_ASB0UDLR,x
	AND #$04
	BNE +
	RTS
+
	LDA !SpriteXSpeed,x
	BNE +
	RTS
+
	LDA !GlobalFlip,x
	CLC
	ASL
	ASL
	ORA !DifficultLevel
	TAY

	LDA !SpriteXSpeed,x
	STA !Scratch0
	CLC
	ADC FrictionTable,y
	STA !SpriteXSpeed,x

	LDA !Scratch0
	BPL +
	LDA !SpriteXSpeed,x
	BMI ++
	STZ !SpriteXSpeed,x
++
	RTS
+
	LDA !SpriteXSpeed,x
	BPL ++
	STZ !SpriteXSpeed,x
++
	RTS

RotateSpeed: db -!XRotateSpeedNormal,-!XRotateSpeedHard,-!XRotateSpeedKaizo,$00,!XRotateSpeedNormal,!XRotateSpeedHard,!XRotateSpeedKaizo
Rotate:
	LDX !SpriteIndex

	LDA !AnimationIndex,x
	BEQ +
	JSR ChangeAnimationFromStart_rotate
	LDA !GlobalFlip,x
	CLC
	ASL
	ASL
	ORA !DifficultLevel
	TAY
	LDA RotateSpeed,y
	STA !SpriteXSpeed,x
+
	LDA !SpriteXSpeed,x
	BNE +
	LDA !SpriteYSpeed,x
	BNE +
	LDA !SpriteBlockedStatus_ASB0UDLR,x
	AND #$04
	BEQ +
	LDA !AnimationFrameIndex,x
	CMP #$04
	BNE +
	JSR ChangeAnimationFromStart_raising
	LDA #$01
	STA !State,x
	RTS
+
	JSR ApplyFriction
	LDA !SpriteBlockedStatus_ASB0UDLR,x
	STA !ScratchF
	LDA !SpriteYSpeed,x
	STA !ScratchE

	JSL $01802A|!rom

	LDA !ScratchF
	EOR !SpriteBlockedStatus_ASB0UDLR,x
	AND #$04
	BEQ +
	LDA !SpriteBlockedStatus_ASB0UDLR,x
	AND #$04
	BEQ +

	LDA !ScratchE
	CMP !BounceMinSpeed
	BCC ++

	LSR !BounceDivider
	STA !Scratch0
	LDA #$00
	SBC !Scratch0
	STA !SpriteYSpeed,x
	RTS
++
	STZ !SpriteYSpeed,x
+
RTS

RaisingXOffset: dw $FFDA,$0026
Raising:
	LDX !SpriteIndex
	LDA !AnimationFrameIndex,x
	CMP #$17
	BNE +
	LDA !AnimationTimer,x
	BNE +
	JSR ChangeAnimationFromStart_walk

	LDA !GlobalFlip,x
	ASL
	TAY

	LDA #$02
	STA !State,x
	LDA !SpriteXHigh,x
	XBA
	LDA !SpriteXLow,x

	REP #$20
	CLC
	ADC RaisingXOffset,y
	STA !Scratch0
	SEP #$20

	LDA !Scratch0
	STA !SpriteXLow,x
	LDA !Scratch1
	STA !SpriteXHigh,x
+
	JSL $01802A|!rom
RTS

WalkXOffset: dw $FFC3,$003D
Walk:
	LDX !SpriteIndex

	LDA !AnimationFrameIndex,x
	CMP #$07
	BNE +
	LDA !AnimationTimer,x
	BNE +

	LDA !GlobalFlip,x
	ASL
	TAY

	LDA !SpriteXHigh,x
	XBA
	LDA !SpriteXLow,x

	REP #$20
	CLC
	ADC WalkXOffset,y
	STA !Scratch0
	SEP #$20

	LDA !Scratch0
	STA !SpriteXLow,x
	LDA !Scratch1
	STA !SpriteXHigh,x
	STZ !SpriteXSpeed,x
+
	JSL $01802A|!rom
RTS

Flip:
	LDX !SpriteIndex

	LDA !AnimationIndex,x
	CMP #$03
	BEQ +
	JSR ChangeAnimationFromStart_flip
	STZ !SpriteXSpeed,x
+

	LDA !AnimationFrameIndex,x
	CMP #$05
	BNE +
	LDA !AnimationTimer,x
	BNE +
	LDA !GlobalFlip,x
	EOR #$01
	STA !GlobalFlip,x
	JSR ChangeAnimationFromStart_walk
	LDA #$02
	STA !State,x
+
RTS

Dead:
	LDX !SpriteIndex
RTS

;Here you can write routines or tables

;Don't Delete or write another >Section Graphics or >End Section
;All code between >Section Graphics and >End Graphics Section will be changed by Dyzen : Sprite Maker
;>Section Graphics
;######################################
;########## Graphics Space ############
;######################################

;This space is for routines used for graphics
;if you don't know enough about asm then
;don't edit them.

;>Routine: GraphicRoutine
;>Description: Updates tiles on the oam map
;results will be visible the next frame.
;>RoutineLength: Short
GraphicRoutine:
	LDA !FrameIndex,x
	CMP #$FF
	BNE +
	RTS
+

    JSL GetDrawInfo                     ;Calls GetDrawInfo to get the free slot and the XDisp and YDisp

    STZ !Scratch3                       ;$02 = Free Slot but in 16bits
    STY !Scratch2


    STZ !Scratch5
    LDA !GlobalFlip,x   
    EOR !LocalFlip,x
    ASL
    STA !Scratch4                       ;$04 = Global Flip but in 16bits

    PHX                                 ;Preserve X
    
    STZ !Scratch7
    LDA !FrameIndex,x
    STA !Scratch6                       ;$06 = Frame Index but in 16bits

    REP #$30                            ;A/X/Y 16bits mode
    LDY !Scratch4                       ;Y = Global Flip
    LDA !Scratch6
    ASL
	CLC
    ADC FramesFlippers,y
    TAX                                 ;X = Frame Index

    LDA FramesLength,x
    CMP #$FFFF
    BNE +
    SEP #$30
    PLX
    RTS
+
    STA !Scratch8

    LDA FramesEndPosition,x
    STA !Scratch4                       ;$04 = End Position + A value used to select a frame version that is flipped

    LDA FramesStartPosition,x           
    TAX                                 ;X = Start Position
    SEP #$20                            ;A 8bits mode
    LDY !Scratch2                       ;Y = Free Slot
    CPY #$00FD
    BCS .return                         ;Y can't be more than #$00FD
-
    LDA Tiles,x
    STA !TileCode,y                     ;Set the Tile code of the tile Y

    LDA Properties,x
    STA !TileProperty,y                 ;Set the Tile property of the tile Y

    LDA !Scratch0
	CLC
	ADC XDisplacements,x
	STA !TileXPosition,y                ;Set the Tile x pos of the tile Y

    LDA !Scratch1
	CLC
	ADC YDisplacements,x
	STA !TileYPosition,y                ;Set the Tile y pos of the tile Y

    PHY
	REP #$20                                 
    TYA
    LSR
    LSR
    TAY                                 ;Y = Y/4 because size directions are not continuous to map 200 and 300
	SEP #$20
    LDA Sizes,x
    STA !TileSize460,y                  ;Set the Tile size of the tile Y
    PLY

    INY
    INY
    INY
    INY                                 ;Next OAM Slot
    CPY #$00FD
    BCS .return                         ;Y can't be more than #$00FD

    DEX
    BMI .return
    CPX !Scratch4                       ;if X < start position or is negative then return
    BCS -                               ;else loop

.return
    SEP #$10
    PLX                                 ;Restore X
    
    LDY #$FF                            ;Allows mode of 8 or 16 bits
    LDA !Scratch8                       ;Load the number of tiles used by the frame
    JSL $01B7B3|!rom                  		;This insert the new tiles into the oam, 
                                        ;A = #$00 => only tiles of 8x8, A = #$02 = only tiles of 16x16, A = #$04 = tiles of 8x8 or 16x16
                                        ;if you select A = #$04 then you must put the sizes of the tiles in !TileSize
RTS
;>EndRoutine

;All words that starts with '@' and finish with '.' will be replaced by Dyzen

;>Table: FramesLengths
;>Description: How many tiles use each frame.
;>ValuesSize: 16
FramesLength:
    dw $0003,$0003,$0005,$0005,$0004,$0008,$0009,$0008,$0008,$000D,$0010,$000D,$000C,$000C,$0009,$0009
	dw $000C,$000E,$0010,$000F,$000E,$000E,$000E,$000F,$000F,$0010,$0011,$0011,$0010,$0010,$0011,$0011
	dw $000E,$000E,$000E,$000E
	dw $0003,$0003,$0005,$0005,$0004,$0008,$0009,$0008,$0008,$000D,$0010,$000D,$000C,$000C,$0009,$0009
	dw $000C,$000E,$0010,$000F,$000E,$000E,$000E,$000F,$000F,$0010,$0011,$0011,$0010,$0010,$0011,$0011
	dw $000E,$000E,$000E,$000E
;>EndTable


;>Table: FramesFlippers
;>Description: Values used to add values to FramesStartPosition and FramesEndPosition
;To use a flipped version of the frames.
;>ValuesSize: 16
FramesFlippers:
    dw $0000,$0048
;>EndTable


;>Table: FramesStartPosition
;>Description: Indicates the index where starts each frame
;>ValuesSize: 16
FramesStartPosition:
    dw $0003,$0007,$000D,$0013,$0018,$0021,$002B,$0034,$003D,$004B,$005C,$006A,$0077,$0084,$008E,$0098
	dw $00A5,$00B4,$00C5,$00D5,$00E4,$00F3,$0102,$0112,$0122,$0133,$0145,$0157,$0168,$0179,$018B,$019D
	dw $01AC,$01BB,$01CA,$01D9
	dw $01DD,$01E1,$01E7,$01ED,$01F2,$01FB,$0205,$020E,$0217,$0225,$0236,$0244,$0251,$025E,$0268,$0272
	dw $027F,$028E,$029F,$02AF,$02BE,$02CD,$02DC,$02EC,$02FC,$030D,$031F,$0331,$0342,$0353,$0365,$0377
	dw $0386,$0395,$03A4,$03B3
;>EndTable

;>Table: FramesEndPosition
;>Description: Indicates the index where end each frame
;>ValuesSize: 16
FramesEndPosition:
    dw $0000,$0004,$0008,$000E,$0014,$0019,$0022,$002C,$0035,$003E,$004C,$005D,$006B,$0078,$0085,$008F
	dw $0099,$00A6,$00B5,$00C6,$00D6,$00E5,$00F4,$0103,$0113,$0123,$0134,$0146,$0158,$0169,$017A,$018C
	dw $019E,$01AD,$01BC,$01CB
	dw $01DA,$01DE,$01E2,$01E8,$01EE,$01F3,$01FC,$0206,$020F,$0218,$0226,$0237,$0245,$0252,$025F,$0269
	dw $0273,$0280,$028F,$02A0,$02B0,$02BF,$02CE,$02DD,$02ED,$02FD,$030E,$0320,$0332,$0343,$0354,$0366
	dw $0378,$0387,$0396,$03A5
;>EndTable


;>Table: Tiles
;>Description: Tiles codes of each tile of each frame
;>ValuesSize: 8
Tiles:
    
Frame0_rotate0_Tiles:
	db $03,$0A,$24,$06
Frame1_rotate1_Tiles:
	db $03,$0A,$06,$05
Frame2_rotate2_Tiles:
	db $03,$0A,$05,$06,$25,$26
Frame3_rotate3_Tiles:
	db $4C,$04,$14,$23,$48,$06
Frame4_rotate4_Tiles:
	db $03,$05,$0A,$06,$34
Frame5_raising0_Tiles:
	db $30,$56,$0D,$4C,$48,$06,$1C,$1C,$0C
Frame6_raising1_Tiles:
	db $4C,$48,$06,$1D,$1C,$0C,$4A,$0E,$0E,$23
Frame7_raising2_Tiles:
	db $4C,$06,$48,$0F,$1C,$0D,$0C,$1C,$44
Frame8_raising3_Tiles:
	db $4C,$48,$06,$0F,$1D,$0F,$1C,$0C,$4E
Frame9_raising4_Tiles:
	db $1C,$1C,$1C,$0C,$4C,$06,$48,$0F,$0F,$0E,$0F,$1D,$1E,$36
Frame10_raising5_Tiles:
	db $1D,$1C,$0C,$18,$30,$0E,$23,$23,$4C,$06,$48,$0F,$0F,$0F,$0E,$0F
	db $36
Frame11_raising6_Tiles:
	db $1C,$0D,$0C,$1C,$44,$4C,$06,$48,$0F,$0F,$0F,$0F,$0F,$18
Frame12_raising7_Tiles:
	db $1D,$1C,$0C,$4E,$4C,$48,$06,$0F,$0F,$0F,$0F,$0F,$18
Frame13_raising8_Tiles:
	db $0E,$1D,$1E,$36,$4C,$48,$06,$0F,$0F,$0F,$0F,$0F,$18
Frame14_raising9_Tiles:
	db $36,$4C,$48,$06,$0F,$0F,$0F,$0F,$0F,$18
Frame15_raising10_Tiles:
	db $4C,$06,$48,$0F,$0F,$0F,$0F,$0F,$1A,$18
Frame16_raising11_Tiles:
	db $22,$1D,$0E,$1E,$4C,$48,$06,$0F,$0F,$0F,$1A,$18,$23
Frame17_raising12_Tiles:
	db $30,$22,$22,$21,$1A,$18,$0E,$57,$1D,$0E,$1D,$1C,$4C,$48,$06
Frame18_raising13_Tiles:
	db $1A,$30,$23,$22,$21,$1F,$0E,$23,$0E,$23,$1D,$1C,$0C,$18,$4C,$48
	db $06
Frame19_raising14_Tiles:
	db $22,$21,$20,$1F,$1A,$1D,$23,$1C,$0D,$0C,$18,$21,$1C,$4C,$06,$48
Frame20_raising15_Tiles:
	db $21,$20,$1F,$21,$1C,$0D,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48
Frame21_raising16_Tiles:
	db $21,$1F,$1F,$21,$1C,$0C,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48
Frame22_raising17_Tiles:
	db $20,$1F,$20,$21,$0D,$0C,$0D,$1C,$1D,$1E,$1A,$18,$4C,$06,$48
Frame23_raising18_Tiles:
	db $21,$20,$1F,$21,$1C,$0D,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48,$33
Frame24_raising19_Tiles:
	db $21,$20,$1F,$21,$1C,$0D,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48,$32
Frame25_walk0_Tiles:
	db $30,$23,$22,$1F,$30,$23,$2E,$1C,$0D,$0C,$1C,$1D,$1E,$18,$4C,$06
	db $48
Frame26_walk1_Tiles:
	db $2C,$31,$22,$30,$23,$30,$23,$1C,$0D,$0C,$1D,$1E,$0E,$23,$18,$4C
	db $48,$06
Frame27_walk2_Tiles:
	db $30,$30,$23,$23,$21,$1F,$2E,$0D,$0D,$0D,$1D,$1E,$0E,$23,$18,$4C
	db $48,$06
Frame28_walk3_Tiles:
	db $21,$21,$21,$1F,$1F,$1A,$1C,$0C,$1C,$0E,$23,$0E,$23,$42,$4C,$06
	db $48
Frame29_walk4_Tiles:
	db $21,$21,$1F,$21,$1A,$0E,$23,$1D,$0C,$1E,$0E,$23,$0F,$42,$4C,$06
	db $48
Frame30_walk5_Tiles:
	db $21,$20,$1F,$22,$23,$1A,$0F,$0E,$23,$1C,$0E,$23,$0E,$23,$40,$4C
	db $48,$06
Frame31_walk6_Tiles:
	db $20,$20,$20,$22,$1A,$0E,$0E,$1C,$0C,$0E,$23,$23,$23,$42,$4C,$06
	db $48,$23
Frame32_walk7_Tiles:
	db $21,$1F,$21,$30,$23,$2E,$1C,$1C,$1C,$0C,$1C,$18,$4C,$06,$48
Frame33_flip0_Tiles:
	db $21,$20,$1F,$21,$1C,$0D,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48
Frame34_flip1_Tiles:
	db $21,$20,$1F,$20,$1A,$0D,$0C,$0C,$0D,$0D,$18,$00,$02,$12,$08
Frame35_flip2_Tiles:
	db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C,$28,$29,$18,$00,$02,$12,$08
Frame0_rotate0_TilesFlipX:
	db $03,$0A,$24,$06
Frame1_rotate1_TilesFlipX:
	db $03,$0A,$06,$05
Frame2_rotate2_TilesFlipX:
	db $03,$0A,$05,$06,$25,$26
Frame3_rotate3_TilesFlipX:
	db $4C,$04,$14,$23,$48,$06
Frame4_rotate4_TilesFlipX:
	db $03,$05,$0A,$06,$34
Frame5_raising0_TilesFlipX:
	db $30,$56,$0D,$4C,$48,$06,$1C,$1C,$0C
Frame6_raising1_TilesFlipX:
	db $4C,$48,$06,$1D,$1C,$0C,$4A,$0E,$0E,$23
Frame7_raising2_TilesFlipX:
	db $4C,$06,$48,$0F,$1C,$0D,$0C,$1C,$44
Frame8_raising3_TilesFlipX:
	db $4C,$48,$06,$0F,$1D,$0F,$1C,$0C,$4E
Frame9_raising4_TilesFlipX:
	db $1C,$1C,$1C,$0C,$4C,$06,$48,$0F,$0F,$0E,$0F,$1D,$1E,$36
Frame10_raising5_TilesFlipX:
	db $1D,$1C,$0C,$18,$30,$0E,$23,$23,$4C,$06,$48,$0F,$0F,$0F,$0E,$0F
	db $36
Frame11_raising6_TilesFlipX:
	db $1C,$0D,$0C,$1C,$44,$4C,$06,$48,$0F,$0F,$0F,$0F,$0F,$18
Frame12_raising7_TilesFlipX:
	db $1D,$1C,$0C,$4E,$4C,$48,$06,$0F,$0F,$0F,$0F,$0F,$18
Frame13_raising8_TilesFlipX:
	db $0E,$1D,$1E,$36,$4C,$48,$06,$0F,$0F,$0F,$0F,$0F,$18
Frame14_raising9_TilesFlipX:
	db $36,$4C,$48,$06,$0F,$0F,$0F,$0F,$0F,$18
Frame15_raising10_TilesFlipX:
	db $4C,$06,$48,$0F,$0F,$0F,$0F,$0F,$1A,$18
Frame16_raising11_TilesFlipX:
	db $22,$1D,$0E,$1E,$4C,$48,$06,$0F,$0F,$0F,$1A,$18,$23
Frame17_raising12_TilesFlipX:
	db $30,$22,$22,$21,$1A,$18,$0E,$57,$1D,$0E,$1D,$1C,$4C,$48,$06
Frame18_raising13_TilesFlipX:
	db $1A,$30,$23,$22,$21,$1F,$0E,$23,$0E,$23,$1D,$1C,$0C,$18,$4C,$48
	db $06
Frame19_raising14_TilesFlipX:
	db $22,$21,$20,$1F,$1A,$1D,$23,$1C,$0D,$0C,$18,$21,$1C,$4C,$06,$48
Frame20_raising15_TilesFlipX:
	db $21,$20,$1F,$21,$1C,$0D,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48
Frame21_raising16_TilesFlipX:
	db $21,$1F,$1F,$21,$1C,$0C,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48
Frame22_raising17_TilesFlipX:
	db $20,$1F,$20,$21,$0D,$0C,$0D,$1C,$1D,$1E,$1A,$18,$4C,$06,$48
Frame23_raising18_TilesFlipX:
	db $21,$20,$1F,$21,$1C,$0D,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48,$33
Frame24_raising19_TilesFlipX:
	db $21,$20,$1F,$21,$1C,$0D,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48,$32
Frame25_walk0_TilesFlipX:
	db $30,$23,$22,$1F,$30,$23,$2E,$1C,$0D,$0C,$1C,$1D,$1E,$18,$4C,$06
	db $48
Frame26_walk1_TilesFlipX:
	db $2C,$31,$22,$30,$23,$30,$23,$1C,$0D,$0C,$1D,$1E,$0E,$23,$18,$4C
	db $48,$06
Frame27_walk2_TilesFlipX:
	db $30,$30,$23,$23,$21,$1F,$2E,$0D,$0D,$0D,$1D,$1E,$0E,$23,$18,$4C
	db $48,$06
Frame28_walk3_TilesFlipX:
	db $21,$21,$21,$1F,$1F,$1A,$1C,$0C,$1C,$0E,$23,$0E,$23,$42,$4C,$06
	db $48
Frame29_walk4_TilesFlipX:
	db $21,$21,$1F,$21,$1A,$0E,$23,$1D,$0C,$1E,$0E,$23,$0F,$42,$4C,$06
	db $48
Frame30_walk5_TilesFlipX:
	db $21,$20,$1F,$22,$23,$1A,$0F,$0E,$23,$1C,$0E,$23,$0E,$23,$40,$4C
	db $48,$06
Frame31_walk6_TilesFlipX:
	db $20,$20,$20,$22,$1A,$0E,$0E,$1C,$0C,$0E,$23,$23,$23,$42,$4C,$06
	db $48,$23
Frame32_walk7_TilesFlipX:
	db $21,$1F,$21,$30,$23,$2E,$1C,$1C,$1C,$0C,$1C,$18,$4C,$06,$48
Frame33_flip0_TilesFlipX:
	db $21,$20,$1F,$21,$1C,$0D,$0C,$1C,$1D,$1E,$1A,$18,$4C,$06,$48
Frame34_flip1_TilesFlipX:
	db $21,$20,$1F,$20,$1A,$0D,$0C,$0C,$0D,$0D,$18,$00,$02,$12,$08
Frame35_flip2_TilesFlipX:
	db $0D,$0D,$0D,$0D,$0C,$0C,$0C,$0C,$28,$29,$18,$00,$02,$12,$08
;>EndTable


;>Table: Properties
;>Description: Properties of each tile of each frame
;>ValuesSize: 8
Properties:
    
Frame0_rotate0_Properties:
	db $2D,$2D,$2D,$2D
Frame1_rotate1_Properties:
	db $2D,$2D,$2D,$2D
Frame2_rotate2_Properties:
	db $2D,$2D,$2D,$2D,$2D,$2D
Frame3_rotate3_Properties:
	db $2D,$2D,$2D,$AD,$2D,$2D
Frame4_rotate4_Properties:
	db $2D,$2D,$2D,$2D,$2D
Frame5_raising0_Properties:
	db $2D,$2D,$AD,$2D,$2D,$2D,$2D,$AD,$2D
Frame6_raising1_Properties:
	db $2D,$2D,$2D,$2D,$AD,$2D,$2D,$2D,$AD,$AD
Frame7_raising2_Properties:
	db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$AD,$2D
Frame8_raising3_Properties:
	db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame9_raising4_Properties:
	db $2D,$6D,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame10_raising5_Properties:
	db $2D,$AD,$2D,$ED,$ED,$AD,$AD,$6D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
	db $2D
Frame11_raising6_Properties:
	db $2D,$2D,$2D,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame12_raising7_Properties:
	db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame13_raising8_Properties:
	db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame14_raising9_Properties:
	db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame15_raising10_Properties:
	db $2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame16_raising11_Properties:
	db $AD,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$AD
Frame17_raising12_Properties:
	db $AD,$AD,$AD,$AD,$2D,$2D,$AD,$2D,$AD,$AD,$AD,$AD,$2D,$2D,$2D
Frame18_raising13_Properties:
	db $2D,$AD,$2D,$AD,$AD,$2D,$AD,$AD,$AD,$AD,$AD,$AD,$2D,$2D,$2D,$2D
	db $2D
Frame19_raising14_Properties:
	db $AD,$AD,$AD,$2D,$2D,$AD,$AD,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame20_raising15_Properties:
	db $AD,$AD,$2D,$2D,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame21_raising16_Properties:
	db $AD,$2D,$2D,$2D,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame22_raising17_Properties:
	db $AD,$2D,$2D,$2D,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame23_raising18_Properties:
	db $AD,$AD,$2D,$2D,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame24_raising19_Properties:
	db $AD,$AD,$2D,$2D,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame25_walk0_Properties:
	db $AD,$AD,$AD,$2D,$2D,$2D,$2D,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D
	db $2D
Frame26_walk1_Properties:
	db $2D,$2D,$AD,$AD,$AD,$2D,$2D,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D
	db $2D,$2D
Frame27_walk2_Properties:
	db $AD,$AD,$AD,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
	db $2D,$2D
Frame28_walk3_Properties:
	db $AD,$AD,$AD,$2D,$2D,$2D,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
	db $2D
Frame29_walk4_Properties:
	db $AD,$AD,$2D,$2D,$2D,$AD,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
	db $2D
Frame30_walk5_Properties:
	db $AD,$AD,$2D,$2D,$2D,$2D,$2D,$AD,$AD,$AD,$2D,$2D,$AD,$AD,$2D,$2D
	db $2D,$2D
Frame31_walk6_Properties:
	db $2D,$2D,$2D,$2D,$2D,$AD,$AD,$AD,$2D,$2D,$AD,$AD,$2D,$2D,$2D,$2D
	db $2D,$2D
Frame32_walk7_Properties:
	db $AD,$2D,$2D,$2D,$2D,$2D,$AD,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D
Frame33_flip0_Properties:
	db $AD,$AD,$2D,$2D,$AD,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame34_flip1_Properties:
	db $AD,$AD,$2D,$2D,$2D,$AD,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D
Frame35_flip2_Properties:
	db $6D,$2D,$6D,$2D,$2D,$6D,$2D,$6D,$2D,$2D,$6D,$2D,$2D,$2D,$2D
Frame0_rotate0_PropertiesFlipX:
	db $6D,$6D,$6D,$6D
Frame1_rotate1_PropertiesFlipX:
	db $6D,$6D,$6D,$6D
Frame2_rotate2_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D,$6D
Frame3_rotate3_PropertiesFlipX:
	db $6D,$6D,$6D,$ED,$6D,$6D
Frame4_rotate4_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D
Frame5_raising0_PropertiesFlipX:
	db $6D,$6D,$ED,$6D,$6D,$6D,$6D,$ED,$6D
Frame6_raising1_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$ED,$6D,$6D,$6D,$ED,$ED
Frame7_raising2_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$ED,$6D
Frame8_raising3_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame9_raising4_PropertiesFlipX:
	db $6D,$2D,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame10_raising5_PropertiesFlipX:
	db $6D,$ED,$6D,$AD,$AD,$ED,$ED,$2D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
	db $6D
Frame11_raising6_PropertiesFlipX:
	db $6D,$6D,$6D,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame12_raising7_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame13_raising8_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame14_raising9_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame15_raising10_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame16_raising11_PropertiesFlipX:
	db $ED,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$ED
Frame17_raising12_PropertiesFlipX:
	db $ED,$ED,$ED,$ED,$6D,$6D,$ED,$6D,$ED,$ED,$ED,$ED,$6D,$6D,$6D
Frame18_raising13_PropertiesFlipX:
	db $6D,$ED,$6D,$ED,$ED,$6D,$ED,$ED,$ED,$ED,$ED,$ED,$6D,$6D,$6D,$6D
	db $6D
Frame19_raising14_PropertiesFlipX:
	db $ED,$ED,$ED,$6D,$6D,$ED,$ED,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame20_raising15_PropertiesFlipX:
	db $ED,$ED,$6D,$6D,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame21_raising16_PropertiesFlipX:
	db $ED,$6D,$6D,$6D,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame22_raising17_PropertiesFlipX:
	db $ED,$6D,$6D,$6D,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame23_raising18_PropertiesFlipX:
	db $ED,$ED,$6D,$6D,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame24_raising19_PropertiesFlipX:
	db $ED,$ED,$6D,$6D,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame25_walk0_PropertiesFlipX:
	db $ED,$ED,$ED,$6D,$6D,$6D,$6D,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D
	db $6D
Frame26_walk1_PropertiesFlipX:
	db $6D,$6D,$ED,$ED,$ED,$6D,$6D,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D
	db $6D,$6D
Frame27_walk2_PropertiesFlipX:
	db $ED,$ED,$ED,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
	db $6D,$6D
Frame28_walk3_PropertiesFlipX:
	db $ED,$ED,$ED,$6D,$6D,$6D,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
	db $6D
Frame29_walk4_PropertiesFlipX:
	db $ED,$ED,$6D,$6D,$6D,$ED,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
	db $6D
Frame30_walk5_PropertiesFlipX:
	db $ED,$ED,$6D,$6D,$6D,$6D,$6D,$ED,$ED,$ED,$6D,$6D,$ED,$ED,$6D,$6D
	db $6D,$6D
Frame31_walk6_PropertiesFlipX:
	db $6D,$6D,$6D,$6D,$6D,$ED,$ED,$ED,$6D,$6D,$ED,$ED,$6D,$6D,$6D,$6D
	db $6D,$6D
Frame32_walk7_PropertiesFlipX:
	db $ED,$6D,$6D,$6D,$6D,$6D,$ED,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D
Frame33_flip0_PropertiesFlipX:
	db $ED,$ED,$6D,$6D,$ED,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame34_flip1_PropertiesFlipX:
	db $ED,$ED,$6D,$6D,$6D,$ED,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D
Frame35_flip2_PropertiesFlipX:
	db $2D,$6D,$2D,$6D,$6D,$2D,$6D,$2D,$6D,$6D,$2D,$6D,$6D,$6D,$6D
;>EndTable
;>Table: XDisplacements
;>Description: X Displacement of each tile of each frame
;>ValuesSize: 8
XDisplacements:
    
Frame0_rotate0_XDisp:
	db $00,$00,$08,$08
Frame1_rotate1_XDisp:
	db $00,$00,$08,$08
Frame2_rotate2_XDisp:
	db $00,$00,$08,$08,$03,$00
Frame3_rotate3_XDisp:
	db $00,$08,$08,$08,$00,$08
Frame4_rotate4_XDisp:
	db $00,$08,$00,$08,$02
Frame5_raising0_XDisp:
	db $0B,$12,$0E,$00,$00,$08,$07,$07,$07
Frame6_raising1_XDisp:
	db $00,$00,$08,$07,$06,$06,$13,$0F,$0A,$12
Frame7_raising2_XDisp:
	db $00,$08,$00,$07,$01,$FE,$00,$00,$03
Frame8_raising3_XDisp:
	db $00,$00,$08,$07,$F9,$00,$F5,$F5,$F3
Frame9_raising4_XDisp:
	db $FD,$FF,$FD,$FD,$00,$08,$00,$07,$00,$F1,$F9,$EC,$F4,$E4
Frame10_raising5_XDisp:
	db $FB,$FB,$FB,$0B,$05,$FF,$07,$05,$00,$08,$00,$07,$00,$F9,$EA,$F2
	db $E1
Frame11_raising6_XDisp:
	db $F7,$F4,$F6,$F6,$F9,$00,$08,$00,$07,$00,$F9,$F2,$EB,$DC
Frame12_raising7_XDisp:
	db $F2,$EF,$EF,$EE,$00,$00,$08,$07,$00,$F9,$F2,$EB,$DC
Frame13_raising8_XDisp:
	db $ED,$E5,$ED,$DB,$00,$00,$08,$07,$00,$F9,$F2,$EB,$DC
Frame14_raising9_XDisp:
	db $D7,$00,$00,$08,$07,$00,$F9,$F2,$EB,$DC
Frame15_raising10_XDisp:
	db $00,$08,$00,$07,$00,$F9,$F2,$EB,$D5,$DC
Frame16_raising11_XDisp:
	db $FE,$04,$00,$0C,$FD,$FD,$05,$F9,$F2,$EB,$D5,$DC,$03
Frame17_raising12_XDisp:
	db $E9,$EF,$F3,$F7,$D5,$DC,$ED,$EB,$F5,$F0,$FA,$FE,$F4,$F4,$FC
Frame18_raising13_XDisp:
	db $D5,$E8,$F0,$EE,$F2,$F5,$E9,$F0,$EF,$F7,$F5,$F9,$FC,$DC,$EF,$EF
	db $F7
Frame19_raising14_XDisp:
	db $DE,$E2,$E3,$E6,$D5,$E5,$EC,$EA,$EB,$EE,$DC,$E3,$EB,$DD,$E5,$DD
Frame20_raising15_XDisp:
	db $DE,$E0,$E4,$E1,$E5,$E7,$EB,$E8,$E3,$EB,$D5,$DC,$D5,$DD,$D5
Frame21_raising16_XDisp:
	db $DE,$E2,$E2,$DF,$E5,$E9,$E9,$E6,$E1,$E9,$D5,$DC,$D3,$DB,$D3
Frame22_raising17_XDisp:
	db $DC,$DF,$DC,$DA,$E3,$E6,$E3,$E1,$DC,$E4,$D5,$DC,$CE,$D6,$CE
Frame23_raising18_XDisp:
	db $DE,$E0,$E4,$E1,$E5,$E7,$EB,$E8,$E3,$EB,$D5,$DC,$D5,$DD,$D5,$D5
Frame24_raising19_XDisp:
	db $DE,$E0,$E4,$E1,$E5,$E7,$EB,$E8,$E3,$EB,$D5,$DC,$D5,$DD,$D5,$D5
Frame25_walk0_XDisp:
	db $04,$0C,$0A,$0E,$09,$11,$FB,$0B,$0C,$0F,$0C,$08,$10,$02,$F9,$01
	db $F9
Frame26_walk1_XDisp:
	db $F0,$FD,$08,$04,$0F,$06,$0E,$0B,$0C,$0F,$0B,$13,$05,$0D,$02,$F4
	db $F4,$FC
Frame27_walk2_XDisp:
	db $E9,$F0,$F1,$F8,$F6,$F9,$DC,$07,$05,$03,$00,$08,$FA,$02,$02,$EB
	db $EB,$F3
Frame28_walk3_XDisp:
	db $E6,$E9,$EC,$EF,$EF,$DD,$FF,$02,$FF,$F9,$01,$F2,$FA,$F7,$E3,$EB
	db $E3
Frame29_walk4_XDisp:
	db $E7,$EA,$EC,$E9,$DD,$EC,$F4,$F2,$F6,$FA,$F1,$F9,$EA,$E3,$DD,$E5
	db $DD
Frame30_walk5_XDisp:
	db $E6,$E7,$EA,$E6,$E8,$DD,$E4,$EB,$F3,$F1,$EE,$F6,$E5,$ED,$D7,$D7
	db $D7,$DF
Frame31_walk6_XDisp:
	db $E2,$E0,$DE,$DB,$DD,$D0,$D7,$DD,$E0,$DB,$D8,$DF,$E3,$C4,$CC,$D4
	db $CC,$DD
Frame32_walk7_XDisp:
	db $DA,$DD,$DA,$D4,$DC,$D2,$CE,$D1,$D4,$D7,$D4,$C5,$C4,$CC,$C4
Frame33_flip0_XDisp:
	db $04,$06,$0A,$07,$0B,$0D,$11,$0E,$09,$11,$FB,$02,$FB,$03,$FB
Frame34_flip1_XDisp:
	db $02,$03,$06,$03,$FA,$0A,$0D,$0D,$0A,$09,$03,$FC,$0C,$0C,$FC
Frame35_flip2_XDisp:
	db $03,$0C,$04,$0A,$05,$09,$05,$09,$FC,$03,$0C,$00,$10,$10,$00
Frame0_rotate0_XDispFlipX:
	db $04,$04,$04,$FC
Frame1_rotate1_XDispFlipX:
	db $04,$04,$FC,$FC
Frame2_rotate2_XDispFlipX:
	db $04,$04,$FC,$FC,$09,$0C
Frame3_rotate3_XDispFlipX:
	db $04,$04,$04,$04,$04,$FC
Frame4_rotate4_XDispFlipX:
	db $04,$FC,$04,$FC,$0A
Frame5_raising0_XDispFlipX:
	db $01,$FA,$FE,$04,$04,$FC,$05,$05,$05
Frame6_raising1_XDispFlipX:
	db $04,$04,$FC,$05,$06,$06,$F1,$FD,$02,$FA
Frame7_raising2_XDispFlipX:
	db $04,$FC,$04,$05,$0B,$0E,$0C,$0C,$01
Frame8_raising3_XDispFlipX:
	db $04,$04,$FC,$05,$13,$0C,$17,$17,$11
Frame9_raising4_XDispFlipX:
	db $0F,$0D,$0F,$0F,$04,$FC,$04,$05,$0C,$1B,$13,$20,$18,$20
Frame10_raising5_XDispFlipX:
	db $11,$11,$11,$F9,$07,$0D,$05,$07,$04,$FC,$04,$05,$0C,$13,$22,$1A
	db $23
Frame11_raising6_XDispFlipX:
	db $15,$18,$16,$16,$0B,$04,$FC,$04,$05,$0C,$13,$1A,$21,$28
Frame12_raising7_XDispFlipX:
	db $1A,$1D,$1D,$16,$04,$04,$FC,$05,$0C,$13,$1A,$21,$28
Frame13_raising8_XDispFlipX:
	db $1F,$27,$1F,$29,$04,$04,$FC,$05,$0C,$13,$1A,$21,$28
Frame14_raising9_XDispFlipX:
	db $2D,$04,$04,$FC,$05,$0C,$13,$1A,$21,$28
Frame15_raising10_XDispFlipX:
	db $04,$FC,$04,$05,$0C,$13,$1A,$21,$2F,$28
Frame16_raising11_XDispFlipX:
	db $0E,$08,$0C,$00,$07,$07,$FF,$13,$1A,$21,$2F,$28,$09
Frame17_raising12_XDispFlipX:
	db $23,$1D,$19,$15,$2F,$28,$1F,$21,$17,$1C,$12,$0E,$10,$10,$08
Frame18_raising13_XDispFlipX:
	db $2F,$24,$1C,$1E,$1A,$17,$23,$1C,$1D,$15,$17,$13,$10,$28,$15,$15
	db $0D
Frame19_raising14_XDispFlipX:
	db $2E,$2A,$29,$26,$2F,$27,$20,$22,$21,$1E,$28,$29,$21,$27,$1F,$27
Frame20_raising15_XDispFlipX:
	db $2E,$2C,$28,$2B,$27,$25,$21,$24,$29,$21,$2F,$28,$2F,$27,$2F
Frame21_raising16_XDispFlipX:
	db $2E,$2A,$2A,$2D,$27,$23,$23,$26,$2B,$23,$2F,$28,$31,$29,$31
Frame22_raising17_XDispFlipX:
	db $30,$2D,$30,$32,$29,$26,$29,$2B,$30,$28,$2F,$28,$36,$2E,$36
Frame23_raising18_XDispFlipX:
	db $2E,$2C,$28,$2B,$27,$25,$21,$24,$29,$21,$2F,$28,$2F,$27,$2F,$37
Frame24_raising19_XDispFlipX:
	db $2E,$2C,$28,$2B,$27,$25,$21,$24,$29,$21,$2F,$28,$2F,$27,$2F,$37
Frame25_walk0_XDispFlipX:
	db $08,$00,$02,$FE,$03,$FB,$09,$01,$00,$FD,$00,$04,$FC,$02,$0B,$03
	db $0B
Frame26_walk1_XDispFlipX:
	db $14,$0F,$04,$08,$FD,$06,$FE,$01,$00,$FD,$01,$F9,$07,$FF,$02,$10
	db $10,$08
Frame27_walk2_XDispFlipX:
	db $23,$1C,$1B,$14,$16,$13,$28,$05,$07,$09,$0C,$04,$12,$0A,$02,$19
	db $19,$11
Frame28_walk3_XDispFlipX:
	db $26,$23,$20,$1D,$1D,$27,$0D,$0A,$0D,$13,$0B,$1A,$12,$0D,$21,$19
	db $21
Frame29_walk4_XDispFlipX:
	db $25,$22,$20,$23,$27,$20,$18,$1A,$16,$12,$1B,$13,$22,$21,$27,$1F
	db $27
Frame30_walk5_XDispFlipX:
	db $26,$25,$22,$26,$24,$27,$28,$21,$19,$1B,$1E,$16,$27,$1F,$2D,$2D
	db $2D,$25
Frame31_walk6_XDispFlipX:
	db $2A,$2C,$2E,$31,$27,$3C,$35,$2F,$2C,$31,$34,$2D,$29,$40,$38,$30
	db $38,$2F
Frame32_walk7_XDispFlipX:
	db $32,$2F,$32,$38,$30,$32,$3E,$3B,$38,$35,$38,$3F,$40,$38,$40
Frame33_flip0_XDispFlipX:
	db $08,$06,$02,$05,$01,$FF,$FB,$FE,$03,$FB,$09,$02,$09,$01,$09
Frame34_flip1_XDispFlipX:
	db $0A,$09,$06,$09,$0A,$02,$FF,$FF,$02,$03,$01,$08,$00,$00,$08
Frame35_flip2_XDispFlipX:
	db $09,$00,$08,$02,$07,$03,$07,$03,$10,$09,$F8,$04,$FC,$FC,$04
;>EndTable
;>Table: YDisplacements
;>Description: Y Displacement of each tile of each frame
;>ValuesSize: 8
YDisplacements:
    
Frame0_rotate0_YDisp:
	db $FC,$0C,$0C,$FE
Frame1_rotate1_YDisp:
	db $FC,$0C,$FE,$FC
Frame2_rotate2_YDisp:
	db $FC,$0C,$FC,$FE,$FC,$00
Frame3_rotate3_YDisp:
	db $FC,$FC,$04,$F9,$0C,$FE
Frame4_rotate4_YDisp:
	db $FC,$FC,$0C,$FE,$09
Frame5_raising0_YDisp:
	db $FC,$FC,$01,$FC,$0C,$FE,$07,$FB,$01
Frame6_raising1_YDisp:
	db $FC,$0C,$FE,$09,$FB,$02,$FB,$F9,$F6,$F6
Frame7_raising2_YDisp:
	db $FC,$FE,$0C,$0D,$08,$01,$FA,$F3,$E7
Frame8_raising3_YDisp:
	db $FC,$0C,$FE,$0D,$09,$0D,$03,$FC,$EE
Frame9_raising4_YDisp:
	db $08,$FB,$FA,$01,$FC,$FE,$0C,$0D,$0D,$0A,$0D,$05,$05,$F8
Frame10_raising5_YDisp:
	db $09,$FB,$02,$F9,$F5,$F5,$F5,$F8,$FC,$FE,$0C,$0D,$0D,$0D,$0B,$0D
	db $FF
Frame11_raising6_YDisp:
	db $08,$01,$FA,$F3,$E7,$FC,$FE,$0C,$0D,$0D,$0D,$0D,$0D,$00
Frame12_raising7_YDisp:
	db $09,$03,$FC,$EE,$FC,$0C,$FE,$0D,$0D,$0D,$0D,$0D,$00
Frame13_raising8_YDisp:
	db $0A,$05,$05,$F8,$FC,$0C,$FE,$0D,$0D,$0D,$0D,$0D,$00
Frame14_raising9_YDisp:
	db $FF,$FC,$0C,$FE,$0D,$0D,$0D,$0D,$0D,$00
Frame15_raising10_YDisp:
	db $FC,$FE,$0C,$0D,$0D,$0D,$0D,$0D,$00,$00
Frame16_raising11_YDisp:
	db $06,$05,$08,$03,$F6,$06,$F8,$0D,$0D,$0D,$00,$00,$07
Frame17_raising12_YDisp:
	db $07,$04,$00,$FC,$00,$00,$08,$0F,$04,$07,$00,$FC,$ED,$FD,$EF
Frame18_raising13_YDisp:
	db $00,$01,$02,$FD,$F9,$F3,$05,$05,$01,$01,$FD,$F9,$F3,$00,$E3,$F3
	db $E5
Frame19_raising14_YDisp:
	db $03,$FE,$F8,$F1,$00,$03,$02,$FE,$F8,$F1,$00,$EB,$EB,$DC,$DE,$EC
Frame20_raising15_YDisp:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED
Frame21_raising16_YDisp:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED
Frame22_raising17_YDisp:
	db $03,$FC,$F5,$EF,$03,$FC,$F5,$EF,$EA,$EA,$00,$00,$DE,$E0,$EE
Frame23_raising18_YDisp:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED,$E0
Frame24_raising19_YDisp:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED,$E0
Frame25_walk0_YDisp:
	db $F7,$F7,$F3,$EE,$EA,$EA,$F9,$02,$FC,$F5,$EF,$EA,$EA,$00,$DD,$DF
	db $ED
Frame26_walk1_YDisp:
	db $F4,$F6,$EC,$F0,$EB,$EA,$EA,$02,$FC,$F5,$F0,$F0,$EC,$EC,$00,$DE
	db $EE,$E0
Frame27_walk2_YDisp:
	db $FC,$F8,$FC,$F8,$F4,$EE,$FE,$01,$FA,$F3,$EE,$EE,$EA,$EA,$00,$DD
	db $ED,$DF
Frame28_walk3_YDisp:
	db $01,$FB,$F5,$EF,$E8,$00,$FD,$F7,$F1,$ED,$ED,$E9,$E9,$FF,$DC,$DE
	db $EC
Frame29_walk4_YDisp:
	db $02,$FC,$F5,$EF,$00,$F7,$F7,$F3,$EE,$F1,$EA,$EA,$EA,$F9,$DD,$DF
	db $ED
Frame30_walk5_YDisp:
	db $02,$FC,$F5,$F0,$EC,$00,$F5,$F0,$F0,$EC,$E9,$E9,$E6,$E6,$F3,$DE
	db $EE,$E0
Frame31_walk6_YDisp:
	db $02,$FB,$F4,$EF,$00,$FD,$F9,$F5,$EF,$EB,$FD,$F9,$EB,$FF,$DD,$DF
	db $ED,$EB
Frame32_walk7_YDisp:
	db $FD,$F7,$F1,$ED,$ED,$FF,$01,$FB,$F5,$EF,$E9,$00,$DC,$DE,$EC
Frame33_flip0_YDisp:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED
Frame34_flip1_YDisp:
	db $02,$FC,$F5,$EE,$00,$02,$FC,$F5,$EE,$E9,$00,$DD,$DF,$E7,$ED
Frame35_flip2_YDisp:
	db $03,$03,$FC,$FC,$F5,$F5,$EE,$EE,$08,$08,$00,$DD,$DF,$E7,$ED
Frame0_rotate0_YDispFlipX:
	db $FC,$0C,$0C,$FE
Frame1_rotate1_YDispFlipX:
	db $FC,$0C,$FE,$FC
Frame2_rotate2_YDispFlipX:
	db $FC,$0C,$FC,$FE,$FC,$00
Frame3_rotate3_YDispFlipX:
	db $FC,$FC,$04,$F9,$0C,$FE
Frame4_rotate4_YDispFlipX:
	db $FC,$FC,$0C,$FE,$09
Frame5_raising0_YDispFlipX:
	db $FC,$FC,$01,$FC,$0C,$FE,$07,$FB,$01
Frame6_raising1_YDispFlipX:
	db $FC,$0C,$FE,$09,$FB,$02,$FB,$F9,$F6,$F6
Frame7_raising2_YDispFlipX:
	db $FC,$FE,$0C,$0D,$08,$01,$FA,$F3,$E7
Frame8_raising3_YDispFlipX:
	db $FC,$0C,$FE,$0D,$09,$0D,$03,$FC,$EE
Frame9_raising4_YDispFlipX:
	db $08,$FB,$FA,$01,$FC,$FE,$0C,$0D,$0D,$0A,$0D,$05,$05,$F8
Frame10_raising5_YDispFlipX:
	db $09,$FB,$02,$F9,$F5,$F5,$F5,$F8,$FC,$FE,$0C,$0D,$0D,$0D,$0B,$0D
	db $FF
Frame11_raising6_YDispFlipX:
	db $08,$01,$FA,$F3,$E7,$FC,$FE,$0C,$0D,$0D,$0D,$0D,$0D,$00
Frame12_raising7_YDispFlipX:
	db $09,$03,$FC,$EE,$FC,$0C,$FE,$0D,$0D,$0D,$0D,$0D,$00
Frame13_raising8_YDispFlipX:
	db $0A,$05,$05,$F8,$FC,$0C,$FE,$0D,$0D,$0D,$0D,$0D,$00
Frame14_raising9_YDispFlipX:
	db $FF,$FC,$0C,$FE,$0D,$0D,$0D,$0D,$0D,$00
Frame15_raising10_YDispFlipX:
	db $FC,$FE,$0C,$0D,$0D,$0D,$0D,$0D,$00,$00
Frame16_raising11_YDispFlipX:
	db $06,$05,$08,$03,$F6,$06,$F8,$0D,$0D,$0D,$00,$00,$07
Frame17_raising12_YDispFlipX:
	db $07,$04,$00,$FC,$00,$00,$08,$0F,$04,$07,$00,$FC,$ED,$FD,$EF
Frame18_raising13_YDispFlipX:
	db $00,$01,$02,$FD,$F9,$F3,$05,$05,$01,$01,$FD,$F9,$F3,$00,$E3,$F3
	db $E5
Frame19_raising14_YDispFlipX:
	db $03,$FE,$F8,$F1,$00,$03,$02,$FE,$F8,$F1,$00,$EB,$EB,$DC,$DE,$EC
Frame20_raising15_YDispFlipX:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED
Frame21_raising16_YDispFlipX:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED
Frame22_raising17_YDispFlipX:
	db $03,$FC,$F5,$EF,$03,$FC,$F5,$EF,$EA,$EA,$00,$00,$DE,$E0,$EE
Frame23_raising18_YDispFlipX:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED,$E0
Frame24_raising19_YDispFlipX:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED,$E0
Frame25_walk0_YDispFlipX:
	db $F7,$F7,$F3,$EE,$EA,$EA,$F9,$02,$FC,$F5,$EF,$EA,$EA,$00,$DD,$DF
	db $ED
Frame26_walk1_YDispFlipX:
	db $F4,$F6,$EC,$F0,$EB,$EA,$EA,$02,$FC,$F5,$F0,$F0,$EC,$EC,$00,$DE
	db $EE,$E0
Frame27_walk2_YDispFlipX:
	db $FC,$F8,$FC,$F8,$F4,$EE,$FE,$01,$FA,$F3,$EE,$EE,$EA,$EA,$00,$DD
	db $ED,$DF
Frame28_walk3_YDispFlipX:
	db $01,$FB,$F5,$EF,$E8,$00,$FD,$F7,$F1,$ED,$ED,$E9,$E9,$FF,$DC,$DE
	db $EC
Frame29_walk4_YDispFlipX:
	db $02,$FC,$F5,$EF,$00,$F7,$F7,$F3,$EE,$F1,$EA,$EA,$EA,$F9,$DD,$DF
	db $ED
Frame30_walk5_YDispFlipX:
	db $02,$FC,$F5,$F0,$EC,$00,$F5,$F0,$F0,$EC,$E9,$E9,$E6,$E6,$F3,$DE
	db $EE,$E0
Frame31_walk6_YDispFlipX:
	db $02,$FB,$F4,$EF,$00,$FD,$F9,$F5,$EF,$EB,$FD,$F9,$EB,$FF,$DD,$DF
	db $ED,$EB
Frame32_walk7_YDispFlipX:
	db $FD,$F7,$F1,$ED,$ED,$FF,$01,$FB,$F5,$EF,$E9,$00,$DC,$DE,$EC
Frame33_flip0_YDispFlipX:
	db $02,$FC,$F5,$EF,$02,$FC,$F5,$EF,$EA,$EA,$00,$00,$DD,$DF,$ED
Frame34_flip1_YDispFlipX:
	db $02,$FC,$F5,$EE,$00,$02,$FC,$F5,$EE,$E9,$00,$DD,$DF,$E7,$ED
Frame35_flip2_YDispFlipX:
	db $03,$03,$FC,$FC,$F5,$F5,$EE,$EE,$08,$08,$00,$DD,$DF,$E7,$ED
;>EndTable
;>Table: Sizes.
;>Description: size of each tile of each frame
;>ValuesSize: 8
Sizes:
    
Frame0_rotate0_Sizes:
	db $02,$02,$00,$02
Frame1_rotate1_Sizes:
	db $02,$02,$02,$02
Frame2_rotate2_Sizes:
	db $02,$02,$02,$02,$00,$00
Frame3_rotate3_Sizes:
	db $02,$00,$00,$00,$02,$02
Frame4_rotate4_Sizes:
	db $02,$02,$02,$02,$00
Frame5_raising0_Sizes:
	db $00,$00,$00,$02,$02,$02,$00,$00,$00
Frame6_raising1_Sizes:
	db $02,$02,$02,$00,$00,$00,$02,$00,$00,$00
Frame7_raising2_Sizes:
	db $02,$02,$02,$00,$00,$00,$00,$00,$02
Frame8_raising3_Sizes:
	db $02,$02,$02,$00,$00,$00,$00,$00,$02
Frame9_raising4_Sizes:
	db $00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00,$00,$02
Frame10_raising5_Sizes:
	db $00,$00,$00,$02,$00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00
	db $02
Frame11_raising6_Sizes:
	db $00,$00,$00,$00,$02,$02,$02,$02,$00,$00,$00,$00,$00,$02
Frame12_raising7_Sizes:
	db $00,$00,$00,$02,$02,$02,$02,$00,$00,$00,$00,$00,$02
Frame13_raising8_Sizes:
	db $00,$00,$00,$02,$02,$02,$02,$00,$00,$00,$00,$00,$02
Frame14_raising9_Sizes:
	db $02,$02,$02,$02,$00,$00,$00,$00,$00,$02
Frame15_raising10_Sizes:
	db $02,$02,$02,$00,$00,$00,$00,$00,$02,$02
Frame16_raising11_Sizes:
	db $00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$02,$02,$00
Frame17_raising12_Sizes:
	db $00,$00,$00,$00,$02,$02,$00,$00,$00,$00,$00,$00,$02,$02,$02
Frame18_raising13_Sizes:
	db $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02
Frame19_raising14_Sizes:
	db $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$02,$00,$00,$02,$02,$02
Frame20_raising15_Sizes:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02
Frame21_raising16_Sizes:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02
Frame22_raising17_Sizes:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02
Frame23_raising18_Sizes:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$00
Frame24_raising19_Sizes:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$00
Frame25_walk0_Sizes:
	db $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02
Frame26_walk1_Sizes:
	db $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02
	db $02,$02
Frame27_walk2_Sizes:
	db $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$02,$02
	db $02,$02
Frame28_walk3_Sizes:
	db $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02
Frame29_walk4_Sizes:
	db $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02
Frame30_walk5_Sizes:
	db $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02
	db $02,$02
Frame31_walk6_Sizes:
	db $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02,$00
Frame32_walk7_Sizes:
	db $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$02,$02,$02,$02
Frame33_flip0_Sizes:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02
Frame34_flip1_Sizes:
	db $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$02,$02,$00,$00,$02
Frame35_flip2_Sizes:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$00,$00,$02
Frame0_rotate0_SizesFlipX:
	db $02,$02,$00,$02
Frame1_rotate1_SizesFlipX:
	db $02,$02,$02,$02
Frame2_rotate2_SizesFlipX:
	db $02,$02,$02,$02,$00,$00
Frame3_rotate3_SizesFlipX:
	db $02,$00,$00,$00,$02,$02
Frame4_rotate4_SizesFlipX:
	db $02,$02,$02,$02,$00
Frame5_raising0_SizesFlipX:
	db $00,$00,$00,$02,$02,$02,$00,$00,$00
Frame6_raising1_SizesFlipX:
	db $02,$02,$02,$00,$00,$00,$02,$00,$00,$00
Frame7_raising2_SizesFlipX:
	db $02,$02,$02,$00,$00,$00,$00,$00,$02
Frame8_raising3_SizesFlipX:
	db $02,$02,$02,$00,$00,$00,$00,$00,$02
Frame9_raising4_SizesFlipX:
	db $00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00,$00,$02
Frame10_raising5_SizesFlipX:
	db $00,$00,$00,$02,$00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00
	db $02
Frame11_raising6_SizesFlipX:
	db $00,$00,$00,$00,$02,$02,$02,$02,$00,$00,$00,$00,$00,$02
Frame12_raising7_SizesFlipX:
	db $00,$00,$00,$02,$02,$02,$02,$00,$00,$00,$00,$00,$02
Frame13_raising8_SizesFlipX:
	db $00,$00,$00,$02,$02,$02,$02,$00,$00,$00,$00,$00,$02
Frame14_raising9_SizesFlipX:
	db $02,$02,$02,$02,$00,$00,$00,$00,$00,$02
Frame15_raising10_SizesFlipX:
	db $02,$02,$02,$00,$00,$00,$00,$00,$02,$02
Frame16_raising11_SizesFlipX:
	db $00,$00,$00,$00,$02,$02,$02,$00,$00,$00,$02,$02,$00
Frame17_raising12_SizesFlipX:
	db $00,$00,$00,$00,$02,$02,$00,$00,$00,$00,$00,$00,$02,$02,$02
Frame18_raising13_SizesFlipX:
	db $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02
Frame19_raising14_SizesFlipX:
	db $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$02,$00,$00,$02,$02,$02
Frame20_raising15_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02
Frame21_raising16_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02
Frame22_raising17_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02
Frame23_raising18_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$00
Frame24_raising19_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$00
Frame25_walk0_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02
Frame26_walk1_SizesFlipX:
	db $02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02
	db $02,$02
Frame27_walk2_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$02,$02
	db $02,$02
Frame28_walk3_SizesFlipX:
	db $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02
Frame29_walk4_SizesFlipX:
	db $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02
Frame30_walk5_SizesFlipX:
	db $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02
	db $02,$02
Frame31_walk6_SizesFlipX:
	db $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02
	db $02,$00
Frame32_walk7_SizesFlipX:
	db $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$02,$02,$02,$02
Frame33_flip0_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02
Frame34_flip1_SizesFlipX:
	db $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$02,$02,$00,$00,$02
Frame35_flip2_SizesFlipX:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$00,$00,$02
;>EndTable

;>End Graphics Section

;Don't Delete or write another >Section Animation or >End Section
;All code between >Section Animations and >End Animations Section will be changed by Dyzen : Sprite Maker
;>Section Animations
;######################################
;########## Animation Space ###########
;######################################

;This space is for routines used for graphics
;if you don't know enough about asm then
;don't edit them.
InitWrapperChangeAnimationFromStart:
	PHB
    PHK
    PLB
	STZ !AnimationIndex,x
	JSR ChangeAnimationFromStart
	PLB
	RTL

ChangeAnimationFromStart_rotate:
	STZ !AnimationIndex,x
	JMP ChangeAnimationFromStart
ChangeAnimationFromStart_raising:
	LDA #$01
	STA !AnimationIndex,x
	JMP ChangeAnimationFromStart
ChangeAnimationFromStart_walk:
	LDA #$02
	STA !AnimationIndex,x
	JMP ChangeAnimationFromStart
ChangeAnimationFromStart_flip:
	LDA #$03
	STA !AnimationIndex,x


ChangeAnimationFromStart:
	STZ !AnimationFrameIndex,x

	STZ !Scratch1
	LDA !AnimationIndex,x
	STA !Scratch0					;$00 = Animation index in 16 bits

	STZ !Scratch3
	LDA !AnimationFrameIndex,x
	STA !Scratch2					;$02 = Animation Frame index in 16 bits

	STZ !Scratch5
	STX !Scratch4					;$04 = sprite index in 16 bits

	REP #$30						;A7X/Y of 16 bits
	LDX !Scratch4					;X = sprite index in 16 bits

	LDA !Scratch0
	ASL
	TAY								;Y = 2*Animation index

	LDA !Scratch2
	CLC
	ADC AnimationIndexer,y
	TAY								;Y = Position of the first frame of the animation + animation frame index

	SEP #$20						;A of 8 bits

	LDA Frames,y
	STA !FrameIndex,x				;New Frame = Frames[New Animation Frame Index]

	LDA Times,y
	STA !AnimationTimer,x			;Time = Times[New Animation Frame Index]

	LDA Flips,y
	STA !LocalFlip,x				;Flip = Flips[New Animation Frame Index]

	LDA !Scratch2
	STA !AnimationFrameIndex,x

	SEP #$10						;X/Y of 8 bits
	LDX !Scratch4					;X = sprite index in 8 bits
RTS
	

;>Routine: AnimationRoutine
;>Description: Decides what will be the next frame.
;>RoutineLength: Short
AnimationRoutine:
    LDA !AnimationTimer,x
    BEQ +

	RTS

+
	STZ !Scratch1
	LDA !AnimationIndex,x
	STA !Scratch0					;$00 = Animation index in 16 bits

	STZ !Scratch3
	LDA !AnimationFrameIndex,x
	STA !Scratch2					;$02 = Animation Frame index in 16 bits

	STZ !Scratch5
	STX !Scratch4					;$04 = sprite index in 16 bits

	REP #$30						;A7X/Y of 16 bits
	LDX !Scratch4					;X = sprite index in 16 bits

	LDA !Scratch0
	ASL
	TAY								;Y = 2*Animation index

	INC !Scratch2					;New Animation Frame Index = Animation Frame Index + 1

	LDA !Scratch2			        ;if Animation Frame index < Animation Lenght then Animation Frame index++
	CMP AnimationLenght,y			;else go to the frame where start the loop.
	BCC +							

	LDA AnimationLastTransition,y
	STA !Scratch2					;New Animation Frame Index = first frame of the loop.

+
	LDA !Scratch2
	CLC
	ADC AnimationIndexer,y
	TAY								;Y = Position of the first frame of the animation + animation frame index

	SEP #$20						;A of 8 bits

	LDA Frames,y
	STA !FrameIndex,x				;New Frame = Frames[New Animation Frame Index]

	LDA Times,y
	STA !AnimationTimer,x			;Time = Times[New Animation Frame Index]

	LDA Flips,y
	STA !LocalFlip,x				;Flip = Flips[New Animation Frame Index]

	LDA !Scratch2
	STA !AnimationFrameIndex,x

	SEP #$10						;X/Y of 8 bits
	LDX !Scratch4					;X = sprite index in 8 bits
RTS
;>EndRoutine

;All words that starts with '>' and finish with '.' will be replaced by Dyzen

AnimationLenght:
	dw $0006,$0018,$0008,$0006

AnimationLastTransition:
	dw $0000,$0017,$0000,$0005

AnimationIndexer:
	dw $0000,$0006,$001E,$0026

Frames:
	
Animation0_rotate_Frames:
	db $00,$01,$00,$02,$03,$04
Animation1_raising_Frames:
	db $03,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$10,$11,$12,$13
	db $14,$15,$16,$15,$17,$18,$17,$14
Animation2_walk_Frames:
	db $19,$1A,$1B,$1C,$1D,$1E,$1F,$20
Animation3_flip_Frames:
	db $21,$22,$23,$23,$22,$21

Times:
	
Animation0_rotate_Times:
	db $08,$08,$08,$08,$08,$08
Animation1_raising_Times:
	db $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04
	db $04,$04,$04,$04,$04,$04,$04,$04
Animation2_walk_Times:
	db $04,$04,$04,$04,$04,$04,$04,$04
Animation3_flip_Times:
	db $04,$04,$04,$04,$04,$04

Flips:
	
Animation0_rotate_Flips:
	db $00,$00,$00,$00,$00,$00
Animation1_raising_Flips:
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
Animation2_walk_Flips:
	db $00,$00,$00,$00,$00,$00,$00,$00
Animation3_flip_Flips:
	db $00,$00,$00,$01,$01,$01

;>End Animations Section

;Don't Delete or write another >Section Hitbox Interaction or >End Section
;All code between >Section Hitboxes Interaction and >End Hitboxes Interaction Section will be changed by Dyzen : Sprite Maker
;>Section Hitboxes Interaction
;######################################
;######## Interaction Space ###########
;######################################

InteractMarioSprite:
	LDA !FrameIndex,x
	CMP #$FF
	BNE +
	RTS
+
	LDA !SpriteTweaker167A_DPMKSPIS,x
	AND #$20
	BNE ProcessInteract      
	TXA                       
	EOR !TrueFrameCounter      			
	AND #$01                	
	ORA !SpriteHOffScreenFlag,x 				
	BEQ ProcessInteract       
ReturnNoContact:
	CLC                       
	RTS
ProcessInteract:
	JSL SubHorzPos
	LDA !ScratchF                  
	CLC                       
	ADC #$50                
	CMP #$A0                
	BCS ReturnNoContact       ; No contact, return 
	JSL SubVertPos         
	LDA !ScratchE                   
	CLC                       
	ADC #$60                
	CMP #$C0                
	BCS ReturnNoContact       ; No contact, return 
	LDA $71    ; \ If animation sequence activated... 
	CMP #$01                ;  | 
	BCS ReturnNoContact       ; / ...no contact, return 
	LDA #$00                ; \ Branch if bit 6 of $0D9B set? 
	BIT $0D9B|!addr               ;  | 
	BVS +           ; / 
	LDA $13F9|!addr ; \ If Mario and Sprite not on same side of scenery... 
	EOR !SpriteBehindEscenaryFlag,x ;  |
+
	BNE ReturnNoContact2
	JSL $03B664|!rom				; MarioClipping
	JSR Interaction

	BCC ReturnNoContact2
	LDA !ScratchE
	CMP #$01
	BNE +
	JSR DefaultAction
+
	SEC
	RTS
ReturnNoContact2:
	CLC
	RTS

Interaction:
    STZ !ScratchE
	LDA !GlobalFlip,x
    EOR !LocalFlip,x
    ASL
	TAY                     ;Y = Flip Adder, used to jump to the frame with the current flip

    LDA !FrameIndex,x
	STA !Scratch4
	STZ !Scratch5

    REP #$20
	LDA !Scratch4
	ASL
	CLC
	ADC HitboxAdder,y
	REP #$10
	TAY

    LDA FrameHitboxesIndexer,y
    TAY
    SEP #$20

-
    LDA FrameHitBoxes,y
    CMP #$FF
    BNE +
    LDA !ScratchE
    BNE ++
	SEP #$10
	LDX !SpriteIndex
    CLC
    RTS
++
	SEP #$10
	LDX !SpriteIndex
    SEC
    RTS
+
    STA !Scratch4
    STZ !Scratch5
    PHY

    REP #$20
    LDA !Scratch4
    ASL
    TAY

    LDA HitboxesStart,y
    TAY
    SEP #$20

	LDA !ScratchE
	AND #$01
	BEQ +

	LDA Hitboxes+5,y
	BNE +

	PLY
    INY
	BRA -

+

	STZ !ScratchA
    LDA Hitboxes+1,y
    STA !Scratch4           ;$04 = Low X Offset
    BPL +
    LDA #$FF
    STA !ScratchA           ;$0A = High X offset
+

	STZ !ScratchB
    LDA Hitboxes+2,y
    STA !Scratch5           ;$05 = Low Y Offset
    BPL +
    LDA #$FF
    STA !ScratchB           ;$0B = High Y Offset
+

    LDA Hitboxes+3,y
    STA !Scratch6           ;$06 = Width

    LDA Hitboxes+4,y
    STA !Scratch7           ;$07 = Height

	PHY
	SEP #$10
	LDX !SpriteIndex

	LDA !SpriteXHigh,x
	XBA
	LDA !SpriteXLow,x
	REP #$20
	PHA
	SEP #$20

	LDA !ScratchA
	XBA
	LDA !Scratch4
	REP #$20
	CLC
	ADC $01,s
	PHA
	SEP #$20
	PLA 
	STA !Scratch4
	PLA
	STA !ScratchA
	PLA
	PLA

	LDA !SpriteYHigh,x
	XBA
	LDA !SpriteYLow,x
	REP #$20
	PHA
	SEP #$20

	LDA !ScratchB
	XBA
	LDA !Scratch5
	REP #$20
	CLC
	ADC $01,s
	PHA
	SEP #$20
	PLA 
	STA !Scratch5
	PLA
	STA !ScratchB
	PLA
	PLA

    JSL $03B72B|!rom
	REP #$10
	BCS ++
	PLY
	BRA +
++
	PLY

    LDA Hitboxes+5,y
	BNE ++

	LDA !ScratchE
	ORA #$01
    STA !ScratchE
	PLY
    INY
    JMP -

++

    STA !ScratchC
    STZ !ScratchD
    REP #$20
    LDA !ScratchC
    ASL
    TAY

    LDA Actions,y
    STA !ScratchC
    SEP #$30
	LDX #$00
    JSR ($000C|!dp,x)
    REP #$10
+
    PLY
    INY
    JMP -


HitboxAdder:
    dw $0000,$0048

FrameHitboxesIndexer:
    dw $0000,$0002,$0004,$0006,$0008,$000A,$000C,$000E,$0010,$0012,$0014,$0016,$0018,$001A,$001C,$001E
	dw $0020,$0023,$0026,$0029,$002C,$002F,$0032,$0035,$0038,$003B,$003F,$0043,$0047,$004B,$004F,$0052
	dw $0055,$0058,$005B,$005E
	dw $0061,$0063,$0065,$0067,$0069,$006B,$006D,$006F,$0071,$0073,$0075,$0077,$0079,$007B,$007D,$007F
	dw $0081,$0084,$0087,$008A,$008D,$0090,$0093,$0096,$0099,$009C,$00A0,$00A4,$00A8,$00AC,$00B0,$00B3
	dw $00B6,$00B9,$00BC,$00BF

FrameHitBoxes:
    db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $00,$FF
	db $01,$02,$FF
	db $03,$04,$FF
	db $05,$06,$FF
	db $07,$08,$FF
	db $09,$0A,$FF
	db $0B,$0C,$FF
	db $0D,$0E,$FF
	db $09,$0A,$FF
	db $09,$0A,$FF
	db $0F,$10,$11,$FF
	db $12,$13,$14,$FF
	db $15,$16,$17,$FF
	db $18,$19,$1A,$FF
	db $1B,$1C,$1D,$FF
	db $1E,$1F,$FF
	db $20,$21,$FF
	db $22,$23,$FF
	db $24,$25,$FF
	db $26,$27,$FF
	db $28,$27,$FF
	
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $29,$FF
	db $2A,$2B,$FF
	db $2C,$2D,$FF
	db $2E,$2F,$FF
	db $30,$31,$FF
	db $32,$33,$FF
	db $34,$35,$FF
	db $36,$37,$FF
	db $32,$33,$FF
	db $32,$33,$FF
	db $38,$39,$3A,$FF
	db $3B,$3C,$3D,$FF
	db $3E,$3F,$40,$FF
	db $41,$42,$43,$FF
	db $44,$45,$46,$FF
	db $47,$48,$FF
	db $49,$4A,$FF
	db $4B,$4C,$FF
	db $4D,$4E,$FF
	db $4F,$50,$FF
	db $51,$50,$FF
	

HitboxesStart:
    dw $0000,$0006,$000C,$0012,$0018,$001E,$0024,$002A,$0030,$0036,$003C,$0042,$0048,$004E,$0054,$005A
	dw $0060,$0066,$006C,$0072,$0078,$007E,$0084,$008A,$0090,$0096,$009C,$00A2,$00A8,$00AE,$00B4,$00BA
	dw $00C0,$00C6,$00CC,$00D2,$00D8,$00DE,$00E4,$00EA,$00F0,$00F6,$00FC,$0102,$0108,$010E,$0114,$011A
	dw $0120,$0126,$012C,$0132,$0138,$013E,$0144,$014A,$0150,$0156,$015C,$0162,$0168,$016E,$0174,$017A
	dw $0180,$0186,$018C,$0192,$0198,$019E,$01A4,$01AA,$01B0,$01B6,$01BC,$01C2,$01C8,$01CE,$01D4,$01DA
	dw $01E0,$01E6

Hitboxes:
    db $01,$03,$FE,$0E,$10,$00
	db $01,$00,$F8,$0E,$10,$00
	db $01,$00,$08,$09,$08,$02
	db $01,$F7,$EF,$0E,$10,$00
	db $01,$F7,$FF,$08,$10,$02
	db $01,$F2,$E5,$0E,$10,$00
	db $01,$F2,$F5,$08,$10,$02
	db $01,$E0,$DE,$0E,$10,$00
	db $01,$E5,$EE,$0B,$17,$02
	db $01,$D8,$DF,$0E,$10,$00
	db $01,$E2,$EF,$0B,$16,$02
	db $01,$D6,$DF,$0E,$10,$00
	db $01,$E1,$EF,$0A,$19,$02
	db $01,$D1,$E0,$0E,$10,$00
	db $01,$DE,$F0,$09,$18,$02
	db $01,$FC,$DF,$0E,$10,$00
	db $01,$02,$BE,$7D,$52,$01
	db $01,$0A,$EB,$06,$25,$02
	db $01,$F7,$E0,$0E,$10,$00
	db $01,$05,$EB,$08,$0D,$02
	db $01,$0D,$EE,$04,$21,$02
	db $01,$EE,$DF,$0E,$10,$00
	db $01,$FA,$F0,$0D,$0D,$02
	db $01,$07,$F7,$04,$19,$02
	db $01,$E6,$DE,$0E,$10,$00
	db $01,$EF,$EF,$13,$0B,$02
	db $01,$02,$F2,$03,$1C,$02
	db $01,$E0,$DF,$0E,$10,$00
	db $01,$EC,$EF,$0C,$0B,$02
	db $01,$E8,$FE,$05,$12,$02
	db $01,$DA,$E0,$0E,$10,$00
	db $01,$E8,$E9,$05,$27,$02
	db $01,$CF,$DF,$0E,$10,$00
	db $01,$DD,$ED,$07,$23,$02
	db $01,$C7,$DE,$0E,$10,$00
	db $01,$D5,$EA,$05,$26,$02
	db $01,$FE,$DF,$0E,$10,$00
	db $01,$08,$EF,$0A,$21,$02
	db $01,$FF,$DF,$0E,$10,$00
	db $01,$05,$EF,$0C,$21,$02
	db $01,$03,$DF,$0E,$10,$00
	db $01,$03,$FE,$0E,$10,$00
	db $01,$06,$F8,$0E,$10,$00
	db $01,$0B,$08,$09,$08,$02
	db $01,$0F,$EF,$0E,$10,$00
	db $01,$15,$FF,$08,$10,$02
	db $01,$14,$E5,$0E,$10,$00
	db $01,$1A,$F5,$08,$10,$02
	db $01,$26,$DE,$0E,$10,$00
	db $01,$24,$EE,$0B,$17,$02
	db $01,$2E,$DF,$0E,$10,$00
	db $01,$27,$EF,$0B,$16,$02
	db $01,$30,$DF,$0E,$10,$00
	db $01,$29,$EF,$0A,$19,$02
	db $01,$35,$E0,$0E,$10,$00
	db $01,$2D,$F0,$09,$18,$02
	db $01,$0A,$DF,$0E,$10,$00
	db $01,$95,$BE,$7D,$52,$01
	db $01,$04,$EB,$06,$25,$02
	db $01,$0F,$E0,$0E,$10,$00
	db $01,$07,$EB,$08,$0D,$02
	db $01,$03,$EE,$04,$21,$02
	db $01,$18,$DF,$0E,$10,$00
	db $01,$0D,$F0,$0D,$0D,$02
	db $01,$09,$F7,$04,$19,$02
	db $01,$20,$DE,$0E,$10,$00
	db $01,$12,$EF,$13,$0B,$02
	db $01,$0F,$F2,$03,$1C,$02
	db $01,$26,$DF,$0E,$10,$00
	db $01,$1C,$EF,$0C,$0B,$02
	db $01,$27,$FE,$05,$12,$02
	db $01,$2C,$E0,$0E,$10,$00
	db $01,$27,$E9,$05,$27,$02
	db $01,$37,$DF,$0E,$10,$00
	db $01,$30,$ED,$07,$23,$02
	db $01,$3F,$DE,$0E,$10,$00
	db $01,$3A,$EA,$05,$26,$02
	db $01,$08,$DF,$0E,$10,$00
	db $01,$02,$EF,$0A,$21,$02
	db $01,$07,$DF,$0E,$10,$00
	db $01,$03,$EF,$0C,$21,$02
	db $01,$03,$DF,$0E,$10,$00
	

Actions:
    dw DefaultAction
	dw flipBox
	dw hurt
	

;This routine will be executed when mario interact with a standar hitbox.
;It will be excecuted if $0E is 1 after execute Interaction routine
DefaultAction:
	JSL $00F5B7|!rom
RTS
    
;>End Hitboxes Interaction Section

;>Action
;### Action flipBox ###
flipBox:
	LDX !SpriteIndex
	LDA #$03
	STA !State,x
;Here you can write your action code
RTS
;>End Action


;>Action
;### Action hurt ###
hurt:
	LDX !SpriteIndex
	JSL $00F5B7|!rom
;Here you can write your action code
RTS
;>End Action
