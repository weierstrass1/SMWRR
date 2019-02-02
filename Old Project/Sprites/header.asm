!base1 = $0000
!base2 = $0000
!base3 = $800000
!186C = $186C
!15A0 = $15A0
!E4 = $E4
!14E0 = $14E0
!15C4 = $15C4
!1662 = $1662
!D8 = $D8
!14D4 = $14D4
!15EA = $15EA
!167A = $167A
!14C8 = $14C8
!161A = $161A
!7F0B44 = $7F0B44
!7FB080 = $7FB080+$800
!7FB100 = $7FB100+$800
!7FB180 = $7FB180+$800
!7FAD00 = $7FAD00

!Freespace	= $3D8000

!reserveNormalSlot80 = !Freespace+$08
!reserveExtendedSlot80 = !Freespace+$0C
!reserveClusterSlot80 = !Freespace+$10
!reserveNormalSlot64 = !Freespace+$14
!reserveExtendedSlot64 = !Freespace+$18
!reserveClusterSlot64 = !Freespace+$1C
!reserveNormalSlot48 = !Freespace+$20
!reserveExtendedSlot48 = !Freespace+$24
!reserveClusterSlot48 = !Freespace+$28
!reserveNormalSlot32 = !Freespace+$2C
!reserveExtendedSlot32 = !Freespace+$30
!reserveClusterSlot32 = !Freespace+$34
!hidestatusBar = !Freespace+$38
!GET_DRAW_INFO = !Freespace+$3C
!SUB_OFF_SCREEN_X0 = !Freespace+$40
!SUB_OFF_SCREEN_X1 = !Freespace+$44
!SUB_OFF_SCREEN_X2 = !Freespace+$48
!SUB_OFF_SCREEN_X3 = !Freespace+$4C
!SUB_OFF_SCREEN_X4 = !Freespace+$50
!SUB_OFF_SCREEN_X5 = !Freespace+$54
!SUB_OFF_SCREEN_X6 = !Freespace+$58
!SUB_OFF_SCREEN_X7 = !Freespace+$5C
!DynamicRoutine80Start = !Freespace+$60
!DynamicRoutine64Start = !Freespace+$64
!DynamicRoutine48Start = !Freespace+$68
!DynamicRoutine32Start = !Freespace+$6C
!Ping80 = !Freespace+$70
!Ping64 = !Freespace+$74
!Ping48 = !Freespace+$78
!Ping32 = !Freespace+$7C
!aiming = !Ping32+$04
!contact = !aiming+$04
!DrawSmoke = !contact+$04
!blockInfo = !DrawSmoke+$04
!spriteFirstX = !blockInfo+$04
!spriteFirstY = !spriteFirstX+$04
!extendedFirstX = !spriteFirstY+$04
!extendedFirstY = !extendedFirstX+$04
!clusterFirstX = !extendedFirstY+$04
!clusterFirstY = !clusterFirstX+$04
!marioFirst = !clusterFirstY+$04
!spriteSecondX = !marioFirst+$04
!spriteSecondY = !spriteSecondX+$04
!extendedSecondX = !spriteSecondY+$04
!extendedSecondY = !extendedSecondX+$04
!clusterSecondX = !extendedSecondY+$04
!clusterSecondY = !clusterSecondX+$04
!marioSecond = !clusterSecondY+$04
!updatePosition = !marioSecond+$04
!getDrawInfo200 = !updatePosition+$04

;#################################################
;################# Free Rams #####################
;#################################################

!DSXBUFFER = !7F0B44
!SLOTSUSED = $06FE|!base2	;how many slots have been used
!DMAmirror = $06FC|!base2 ;DMAmirror similar to 0D9F in HDMA

;602 free rams

;................7F...............................

;............Palette Stuff........................

;colour destiny 128 bytes
!paletteDestiny = !7FB080
;colour low byte 128 bytes
!paletteLow = !7FB100
;colour high byte 128 bytes
!paletteHigh = !7FB180

;..........Dynamic Sprite Stuff..................

;Vram position 2 bytes
!vrampos = !7FAD00 ;0
;Dynamic Timer 1 byte
!DTimer = !vrampos+$02 ;2
;50% more mode 1 byte
!mode50 = !DTimer+$01 ;3
;If a sprite have a slot must put its signal into 0 every frame 3 bytes
;SP4 second HalF
!dynSiganls1 = !mode50+$01 ;4
;SP4 first half
!dynSiganls2 = !dynSiganls1+$01 ;5
;SP3 secondHalf
!dynSiganls3 = !dynSiganls2+$01 ;6
;Last slot that sent his data, 1 byte
!lastSender = !dynSiganls3+$01 ;7
!firstSlot = !lastSender+$01 ;8
;Dynamic Sprite Resource 48 bytes
!dynSpRec = !firstSlot+$02 ;A
;Dynamic Sprite bank 48 bytes
!dynSpBnk = !dynSpRec+$30 ;3A
;Dynamic Sprite transfer Length 48 bytes
!dynSpLength = !dynSpBnk+$30 ;6A
;Next Slot, if it is #$FF then finish the dynamic transfer, 48 bytes
!nextDynSlot = !dynSpLength+$30 ;9A
;tile relative position, 12 bytes
!tileRelativePositionNormal = !nextDynSlot+$30 ;CA
;tile relative position extended, 10 bytes
!tileRelativePositionExtended = !tileRelativePositionNormal+$0C ;D6
;tile relative position Cluster, 20 bytes
!tileRelativePositionCluster = !tileRelativePositionExtended+$0A ;E0

;...........GFX change Stuff.................

;number of ExGFX Change. Max 10 (A) 1 byte
!GFXNumber = !tileRelativePositionCluster+$14 ;F4
;bnk of the GFX 20 bytes
!GFXBnk = !GFXNumber+$01 ;F5
;Vram Destiny of the GFX 20 bytes
!GFXVram = !GFXBnk+$14 ;109
;resource of the GFX 20 bytes
!GFXRec = !GFXVram+$14 ;11D
;Data length of the GFX 20 bytes
!GFXLenght = !GFXRec+$14 ;131

;..........Palette Change Stuff.............

;number of colours to change. Max 128 (80) 1 byte
!paletteNumber = !GFXLenght+$14 ;145

;.........Mario GFX Change Stuff...........

;activate normal custom gfx change of mario 1 byte 
!marioNormalCustomGFXOn = !paletteNumber+$01 ;146
;bnk of the normal custom gfx change of mario 1 byte 
!marioNormalCustomGFXBnk = !marioNormalCustomGFXOn+$01 ;147
;resource of the normal custom mario GFX 2 bytes 
!marioNormalCustomGFXRec = !marioNormalCustomGFXBnk+$01 ;148
;bnk of the normal custom gfx change of mario 1 byte 
!marioNormalCustomGFXBnkReal = !marioNormalCustomGFXRec+$02 ;14A
;resource of the normal custom mario GFX 2 bytes 
!marioNormalCustomGFXRecReal = !marioNormalCustomGFXBnkReal+$01 ;14B

;........Mario Palette change Stuff........

;activate mario custom Palette 1 byte
!marioPal = !marioNormalCustomGFXRecReal+$02 ;14D
!marioPalLastVal = !marioPal+$01 ;14E
;low Byte of mario custom Palette 10 bytes 
!marioPalLow = !marioPalLastVal+$01 ;14F
;High Byte of mario custom Palette 10 bytes
!marioPalHigh = !marioPalLow+$0A ;159

;........Custom Player Stuff...............

;activate complete custom mario GFX 1 byte - Caution: this use the complete first line of SP1
!marioCustomGFXOn = !marioPalHigh+$0A ;163
;bnk complete custom mario GFX 1 byte
!marioCustomGFXBnk = !marioCustomGFXOn+$01 ;164
;resource complete custom mario GFX 2 byte
!marioCustomGFXRec = !marioCustomGFXBnk+$01 ;165

;.......Optimize Mario DMA Stuff...........

!lastLevelMode = !marioCustomGFXRec+$02
;mario GFX optimizer 2 bytes
!optimizer = !lastLevelMode+$01 ;179
;mario GFX optimizer2 10 bytes
!optimizer2 = !optimizer+$02 ;17A
;mario GFX optimizer3 10 bytes
!optimizer3 = !optimizer2+$0A ;184 bytes
!optimizer4 = !optimizer3+$01
!optimizer5 = !optimizer4+$01
!optimizer6 = !optimizer5+$01

;.......Semi Dynamic Sprites Stuff......... 

;assign a kind of sprite to a SemiDynamic Slot, 4 bytes
!SemiDynamicSlots = !optimizer3+$0A ;18E

;Total Free Rams = 0x192 + 0x180 = 0x312 = 782