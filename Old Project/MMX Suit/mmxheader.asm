;Routines
!mmxFreeSpace = $3E8000
!mmxInit = !mmxFreeSpace+$08
!mmxCode = !mmxInit+$04
!mmxDamage = !mmxCode+04
!mmxHeal = !mmxDamage+$04
!mmxThrowItem = !mmxHeal+$04

;Constants
!mmxHPMAX = #$20
!mmxNoDamTimer = #$60
!mmxCommonBuster = #$13
!mmxChargedBuster = #$14
!mmxDeadBalls = #$0B
!mmxBusterMaxTime = #$40
!mmxDeadMaxTime = #$80
!mmxHPBarX = #$08
!mmxHPBarY = #$50
!mmxWallJumpMaxTime = #$10
!mmxHealSprite = #$A4

;Variables
!mmxCurrentHp = $7F0B44 ;current hp of player
!mmxShowedHp = !mmxCurrentHp+$01 ;hp showed on the UI
!mmxConLastSt = !mmxShowedHp+$01 ;last state of the control
!mmxBusterTimer = !mmxConLastSt+$01 ;timer to charge buster
!mmxChargeLevel = !mmxBusterTimer+$01 ;0 = buster not charged, 1 = start animation of charge, 2 = charged
!mmxSpecialStart = !mmxChargeLevel+$01 ;0 = at the level with the original mmx intro, 1 = normal start
!mmxDeathTimer = !mmxSpecialStart+$01 ;timer to make dead animation
!mmxDamDir = !mmxDeathTimer+$01 ;what direction had the player when recieved damage
!mmxBulletNum = !mmxDamDir+$01 ;number of bullets on the screen
!mmxDamTimer = !mmxBulletNum+$01 ; 
!mmxWallJumpTimer = !mmxDamTimer+$01
!mmxWallJumpFlag = !mmxWallJumpTimer+$01
!mmxConLastSt2 = !mmxWallJumpTimer+$01
!mmxLastBlocked = !mmxConLastSt2+$01
!mmxBlockedCount = !mmxLastBlocked+$01
!mmxYSpeedAdder = !mmxBlockedCount+$01
!mmxYSpriteAdder = !mmxYSpeedAdder+$01
!mmxYFloor = !mmxYSpriteAdder+$02
!mmxBeeHelixX = !mmxYFloor+$02
