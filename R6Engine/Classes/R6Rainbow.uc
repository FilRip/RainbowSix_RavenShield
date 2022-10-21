//================================================================================
// R6Rainbow.
//================================================================================
class R6Rainbow extends R6Pawn
	Native
	Abstract
	NotPlaceable;

enum eRainbowCircumstantialAction {
	CAR_None,
	CAR_Secure,
	CAR_Free
};

enum eEquipWeapon {
	EQUIP_SecureWeapon,
	EQUIP_EquipWeapon,
	EQUIP_NoWeapon,
	EQUIP_Armed
};

enum eComAnimation {
	COM_None,
	COM_FollowMe,
	COM_Cover,
	COM_Go,
	COM_Regroup,
	COM_Hold
};

enum eLadderSlide {
	SLIDE_Start,
	SLIDE_Sliding,
	SLIDE_End,
	SLIDE_None
};

var byte m_u8DesiredPitch;
var byte m_u8CurrentPitch;
var byte m_u8DesiredYaw;
var byte m_u8CurrentYaw;
var eLadderSlide m_eLadderSlide;
var eEquipWeapon m_eEquipWeapon;
var int m_iOperativeID;
var int m_iCurrentWeapon;
var int m_iKills;
var int m_iBulletsFired;
var int m_iBulletsHit;
var int m_iExtraPrimaryClips;
var int m_iExtraSecondaryClips;
var int m_iRainbowFaceID;
var bool m_bTweenFirstTimeOnly;
var bool m_bHasLockPickKit;
var bool m_bHasDiffuseKit;
var bool m_bHasElectronicsKit;
var bool m_bWeaponIsSecured;
var bool m_bThrowGrenadeWithLeftHand;
var bool m_bIsLockPicking;
var bool m_bReloadToFullAmmo;
var bool m_bScaleGasMaskForFemale;
var bool m_bInitRainbow;
var bool m_bGettingOnLadder;
var bool m_bRainbowIsFemale;
var bool m_bIsSurrended;
var bool m_bIsUnderArrest;
var bool m_bIsBeingArrestedOrFreed;
var Material m_FaceTexture;
var R6GasMask m_GasMask;
var R6AbstractHelmet m_Helmet;
var R6NightVision m_NightVision;
var R6EngineWeapon m_preSwitchWeapon;
var R6Hostage m_aEscortedHostage[4];
var Class<R6GasMask> m_GasMaskClass;
var Class<R6AbstractHelmet> m_HelmetClass;
var Class<R6NightVision> m_NightVisionClass;
var Rotator m_rFiringRotation;
var Plane m_FaceCoords;
var Vector m_vStartLocation;
var string m_szPrimaryWeapon;
var string m_szPrimaryGadget;
var string m_szPrimaryBulletType;
var string m_szSecondaryWeapon;
var string m_szSecondaryGadget;
var string m_szSecondaryBulletType;
var string m_szPrimaryItem;
var string m_szSecondaryItem;
var string m_szSpecialityID;

replication
{
	reliable if ( Role < Role_Authority )
		ServerSetCrouch;
	unreliable if ( Role == Role_Authority )
		ClientQuickResetPeeking;
	reliable if ( Role < Role_Authority )
		ServerSetComAnim,ServerToggleNightVision;
	reliable if ( Role == Role_Authority )
		ClientFinishAnimation;
	reliable if ( Role == Role_Authority )
		m_u8DesiredPitch,m_u8DesiredYaw,m_iExtraPrimaryClips,m_iExtraSecondaryClips,m_iRainbowFaceID,m_bHasLockPickKit,m_bHasDiffuseKit,m_bHasElectronicsKit,m_bRainbowIsFemale;
	reliable if ( Role == Role_Authority )
		m_bIsLockPicking,m_NightVision;
	reliable if ( Role == Role_Authority )
		m_bIsUnderArrest;
}

simulated function ResetOriginalData ()
{
	Super.ResetOriginalData();
	m_bIsSurrended=False;
	m_bIsUnderArrest=False;
	m_bIsBeingArrestedOrFreed=False;
}

simulated event bool GetReticuleInfo (Pawn ownerReticule, out string szName)
{
	if ( m_bIsPlayer )
	{
		if ( Level.NetMode == NM_Standalone )
		{
			szName=m_CharacterName;
		}
		else
		{
			if ( PlayerReplicationInfo != None )
			{
				szName=PlayerReplicationInfo.PlayerName;
			}
			else
			{
				return False;
			}
		}
	}
	else
	{
		if ( m_TeamMemberRepInfo != None )
		{
			szName=m_TeamMemberRepInfo.m_CharacterName;
		}
		else
		{
			szName=m_CharacterName;
		}
	}
	if ( ownerReticule == None )
	{
		return False;
	}
	return ownerReticule.IsFriend(self) || ownerReticule.IsNeutral(self);
}

function IncrementKillCount ()
{
	m_iKills++;
}

function IncrementBulletsFired ()
{
	m_iBulletsFired++;
}

function IncrementRoundsHit ()
{
	m_iBulletsHit++;
}

simulated function StartSliding ()
{
/*	m_eLadderSlide=0;
	SendPlaySound(R6LadderVolume(m_Ladder.MyLadder).m_SlideSound,SLOT_SFX);
	m_eLadderSlide=1;*/
}

simulated function EndSliding ()
{
/*	m_eLadderSlide=2;
	SendPlaySound(R6LadderVolume(m_Ladder.MyLadder).m_SlideSoundStop,SLOT_SFX);
	m_eLadderSlide=3;*/
}

simulated event Destroyed ()
{
	if ( IsLocallyControlled() && (Controller != None) )
	{
		ToggleHeatProperties(False,None,None);
		ToggleNightProperties(False,None,None);
		ToggleScopeProperties(False,None,None);
		if ( R6PlayerController(Controller) != None )
		{
			R6PlayerController(Controller).ResetBlur();
		}
	}
	Super.Destroyed();
	if ( m_Helmet != None )
	{
		m_Helmet.Destroy();
		m_Helmet=None;
	}
	if ( m_NightVision != None )
	{
		m_NightVision.Destroy();
		m_NightVision=None;
	}
	if ( m_GasMask != None )
	{
		m_GasMask.Destroy();
		m_GasMask=None;
	}
}

simulated function SetRainbowFaceTexture ()
{
}

simulated function AttachNightVision ()
{
	m_NightVision=Spawn(m_NightVisionClass,self);
	m_NightVision.bHidden=True;
	AttachToBone(m_NightVision,'R6 Head');
}

simulated event PostBeginPlay ()
{
	if ( Level.Game != None )
	{
//		assert (Default.m_iTeam == R6AbstractGameInfo(Level.Game).2);
	}
	Super.PostBeginPlay();
	SetMovementPhysics();
	if ( Level.NetMode != 3 )
	{
		AttachCollisionBox(2);
		AttachNightVision();
	}
	if ( m_HelmetClass != None )
	{
		m_Helmet=Spawn(m_HelmetClass,self);
		AttachToBone(m_Helmet,'R6 Head');
	}
}

simulated event PostNetBeginPlay ()
{
	if ( Level.NetMode == NM_Client )
	{
		if ( m_bIsPlayer && (PlayerReplicationInfo != None) )
		{
			bIsFemale=PlayerReplicationInfo.bIsFemale;
			m_iOperativeID=PlayerReplicationInfo.iOperativeID;
		}
		else
		{
			bIsFemale=m_bRainbowIsFemale;
			m_iOperativeID=m_iRainbowFaceID;
		}
	}
	if ( (Level.NetMode == NM_Client) || (Level.NetMode == NM_Standalone) )
	{
		SetRainbowFaceTexture();
	}
	Super.PostNetBeginPlay();
	if ( (Level.NetMode == NM_ListenServer) || (Level.NetMode == NM_DedicatedServer) )
	{
		m_TeamMemberRepInfo=Spawn(Class'R6TeamMemberReplicationInfo');
		m_TeamMemberRepInfo.m_iTeam=m_iTeam;
		m_TeamMemberRepInfo.Instigator=self;
		m_TeamMemberRepInfo.m_CharacterName=m_CharacterName;
		m_TeamMemberRepInfo.m_iTeamPosition=m_iID;
	}
	InitializeRainbowAnimations();
}

simulated function InitializeRainbowAnimations ()
{
	if ( Physics == 11 )
	{
//		m_eEquipWeapon=2;
		m_ePlayerIsUsingHands=HANDS_Both;
		PlayAnim('StandLadder_nt');
	}
	else
	{
		if ( m_bIsProne )
		{
			PlayAnim('ProneWaitBreathe');
		}
		else
		{
			if ( bIsCrouched )
			{
				PlayAnim('CrouchWaitBreathe01');
			}
			else
			{
				PlayAnim('StandWaitBreathe');
			}
		}
	}
	PlayWeaponAnimation();
	if ( m_ePeekingMode == 1 )
	{
		if ( m_bPeekingLeft )
		{
			m_fPeeking=m_fPeekingGoal + 1;
		}
		else
		{
			m_fPeeking=m_fPeekingGoal - 1;
		}
	}
}

function PossessedBy (Controller C)
{
	Super.PossessedBy(C);
	if (  !m_bIsPlayer )
	{
		bCanStrafe=False;
	}
	else
	{
		if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
		{
			if ( PlayerReplicationInfo != None )
			{
				bIsFemale=PlayerReplicationInfo.bIsFemale;
				m_iOperativeID=PlayerReplicationInfo.iOperativeID;
				SetRainbowFaceTexture();
			}
		}
	}
}

function UnPossessed ()
{
	if (  !m_bIsClimbingLadder && (m_Ladder != None) )
	{
		R6LadderVolume(m_Ladder.MyLadder).RemoveClimber(self);
		R6LadderVolume(m_Ladder.MyLadder).DisableCollisions(m_Ladder);
	}
	Super.UnPossessed();
}

simulated event AnimEnd (int iChannel)
{
	if ( (m_bIsFiringWeapon > 0) && (EngineWeapon != None) &&  !EngineWeapon.IsA('R6GrenadeWeapon') && (m_ePlayerIsUsingHands != 0) )
	{
		if ( m_bNightVisionAnimation )
		{
			SecureNightVisionGoggles();
		}
	}
	if ( iChannel == 0 )
	{
		m_bInitRainbow=False;
		if ( m_bIsPlayer && m_bSlideEnd )
		{
			m_bSlideEnd=False;
		}
		if ( Physics != 12 )
		{
			PlayWaiting();
		}
	}
	else
	{
		if ( iChannel == 1 )
		{
			if ( m_bPostureTransition &&  !m_bInteractingWithDevice &&  !m_bIsLockPicking )
			{
				if ( m_bNightVisionAnimation )
				{
					SecureNightVisionGoggles();
				}
				m_bSoundChangePosture=False;
				m_bIsLanding=False;
				m_bPostureTransition=False;
				m_ePlayerIsUsingHands=HANDS_None;
				PlayWeaponAnimation();
			}
			if ( bIsCrouched )
			{
				BlendKneeOnGround();
			}
		}
		else
		{
			if ( (iChannel == 16) && m_bPawnSpecificAnimInProgress )
			{
				m_bPawnSpecificAnimInProgress=False;
			}
			else
			{
				if ( iChannel == 15 )
				{
					if (  !m_bIsPlayer && m_bReloadToFullAmmo )
					{
						FinishedReloadingWeapon();
					}
					if ( m_bPlayingComAnimation || m_bNightVisionAnimation )
					{
						m_bPlayingComAnimation=False;
						if ( m_bNightVisionAnimation )
						{
							if ( IsUsingHeartBeatSensor() )
							{
								R6ResetAnimBlendParams(15);
							}
							SecureNightVisionGoggles();
						}
						m_ePlayerIsUsingHands=HANDS_None;
						PlayWeaponAnimation();
					}
				}
				else
				{
					if ( (iChannel == 14) && m_bWeaponTransition )
					{
						m_bWeaponTransition=False;
						if ( Role == Role_Authority )
						{
							if ( m_eGrenadeThrow != 3 )
							{
								PlayWeaponAnimation();
							}
							if ( Level.NetMode != 0 )
							{
								ClientFinishAnimation();
							}
						}
						PlayWeaponAnimation();
					}
				}
			}
		}
	}
}

simulated function SecureNightVisionGoggles ()
{
	m_bNightVisionAnimation=False;
	if ( m_bActivateNightVision )
	{
		m_NightVision.bHidden=False;
		AttachToBone(m_NightVision,'R6 Head');
		if ( m_eArmorType == 3 )
		{
			m_Helmet.SetHelmetStaticMesh(True);
		}
	}
	else
	{
		m_NightVision.bHidden=True;
		if ( (m_eArmorType == 3) &&  !m_bHaveGasMask )
		{
			m_Helmet.SetHelmetStaticMesh(False);
		}
	}
	m_ePlayerIsUsingHands=HANDS_None;
	PlayWeaponAnimation();
}

simulated function PlayActivateNightVisionAnimation ()
{
	m_ePlayerIsUsingHands=HANDS_Left;
	PlayWeaponAnimation();
	m_bActivateNightVision=True;
	AnimBlendParams(15,1.00,,,'R6 L Clavicle');
	m_bNightVisionAnimation=True;
	if ( m_bIsProne )
	{
		PlayAnim('ProneNightVision',1.00,0.20,15);
	}
	else
	{
		PlayAnim('CrouchNightVision',1.00,0.20,15);
	}
}

simulated function PlayDeactivateNightVisionAnimation ()
{
	m_ePlayerIsUsingHands=HANDS_Left;
	PlayWeaponAnimation();
	m_bActivateNightVision=False;
	AnimBlendParams(15,1.00,,,'R6 L Clavicle');
	m_bNightVisionAnimation=True;
	if ( m_bIsProne )
	{
		PlayAnim('ProneNightVision',1.00,0.20,15,True);
	}
	else
	{
		PlayAnim('CrouchNightVision',1.00,0.20,15,True);
	}
}

simulated function GetNightVision ()
{
	if (  !m_bActivateNightVision )
	{
		return;
	}
	AttachToBone(m_NightVision,'TagNightVision');
	m_NightVision.bHidden=False;
}

simulated function RaiseHelmetVisor ()
{
	if (  !m_bActivateNightVision )
	{
		return;
	}
	if ( m_eArmorType == 3 )
	{
		m_Helmet.SetHelmetStaticMesh(True);
	}
}

simulated function ActivateNightVision ()
{
	if (  !m_bActivateNightVision )
	{
		return;
	}
	AttachToBone(m_NightVision,'R6 Head');
}

simulated function RemoveNightVision ()
{
	if ( m_bActivateNightVision )
	{
		return;
	}
	AttachToBone(m_NightVision,'TagNightVision');
	m_NightVision.bHidden=False;
}

simulated function DeactivateNightVision ()
{
	if ( m_bActivateNightVision )
	{
		return;
	}
	if ( (m_eArmorType == 3) &&  !m_bHaveGasMask )
	{
		m_Helmet.SetHelmetStaticMesh(False);
	}
	m_NightVision.bHidden=True;
}

exec function ToggleNightVision ()
{
	if ( (Physics != 1) || m_bIsLanding || m_bPostureTransition )
	{
		return;
	}
	if ( m_bNightVisionAnimation )
	{
		SecureNightVisionGoggles();
	}
	Super.ToggleNightVision();
}

function ServerToggleNightVision (bool bActivateNightVision)
{
	m_bActivateNightVision=bActivateNightVision;
	if ( bActivateNightVision )
	{
//		SetNextPendingAction(PENDING_StopCoughing5);
	}
	else
	{
//		SetNextPendingAction(PENDING_StopCoughing6);
	}
}

function ClientFinishAnimation ()
{
	m_bWeaponTransition=False;
	if ( m_eGrenadeThrow != 3 )
	{
		PlayWeaponAnimation();
	}
}

simulated function float ArmorSkillEffect ()
{
	if ( m_eArmorType == 3 )
	{
		return 0.60;
	}
	else
	{
		if ( m_eArmorType == 2 )
		{
			return 0.80;
		}
	}
	return 1.00;
}

function Vector GetHandLocation ()
{
	if ( m_bThrowGrenadeWithLeftHand )
	{
		return GetBoneCoords('R6 L Hand').Origin;
	}
	else
	{
		return GetBoneCoords('R6 R Hand').Origin;
	}
}

event EndOfGrenadeEffect (EGrenadeType eType)
{
	if ( m_bIsPlayer )
	{
		return;
	}
	if ( eType == 2 )
	{
		R6RainbowAI(Controller).m_TeamManager.GasGrenadeCleared(self);
	}
	else
	{
//		if (! eType == 3 ) goto JL004C;
	}
JL004C:
}

function TurnAwayFromNearbyWalls ()
{
	if ( (Controller == None) || (R6RainbowAI(Controller) == None) )
	{
		return;
	}
	if (  !m_bIsProne &&  !m_bIsClimbingStairs && (R6RainbowAI(Controller).m_eFormation != 1) )
	{
		Super.TurnAwayFromNearbyWalls();
	}
}

simulated function PlayStartClimbing ()
{
	m_bGettingOnLadder=True;
	Super.PlayStartClimbing();
}

simulated function PlayEndClimbing ()
{
	m_bGettingOnLadder=False;
	Super.PlayEndClimbing();
}

simulated function ClimbStairs (Vector vStairDirection)
{
	if (  !m_bIsPlayer && (Controller != None) )
	{
		R6RainbowAI(Controller).m_bUseStaggeredFormation=False;
	}
	Super.ClimbStairs(vStairDirection);
}

simulated function EndClimbStairs ()
{
	if (  !m_bIsPlayer && (Controller != None) )
	{
		R6RainbowAI(Controller).m_bUseStaggeredFormation=True;
	}
	Super.EndClimbStairs();
}

simulated function PlaySecureTerrorist ()
{
	R6ResetAnimBlendParams(13);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	m_bPostureTransition=True;
	AnimBlendParams(1,1.00,0.00,0.00);
	PlayAnim('StandArrest',1.00,0.20,1);
}

simulated function PlayStartSurrender ()
{
	R6ResetAnimBlendParams(16);
	ClearChannel(16);
	AnimBlendParams(16,1.00,,);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayAnim('RelaxToSurrender',1.00,0.20,16);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlaySurrender ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	AnimBlendParams(16,1.00,,);
	PlayAnim('SurrenderWaitBreathe',1.00,0.00,16);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlayEndSurrender ()
{
	AnimBlendParams(16,1.00,,);
	m_ePlayerIsUsingHands=HANDS_None;
	PlayAnim('RelaxToSurrender',1.00,0.20,16,True);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlayArrest ()
{
	ClearChannel(16);
	AnimBlendParams(16,1.00,,);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayAnim('SurrenderToKneel',1.00,0.20,16);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlayArrestKneel ()
{
	AnimBlendParams(16,1.00,,);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayAnim('KneelArrest',1.00,0.20,16);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlayArrestWaiting ()
{
	local name Anim;

	SetRandomWaiting(4);
	switch (m_bRepPlayWaitAnim)
	{
/*		case 0:
		Anim='KneelArrestWait01';
		break;
		default:
		Anim='KneelArrestWait02';*/
	}
	AnimBlendParams(16,1.00,,);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayAnim(Anim,1.00,0.20,16);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlayEndArrest ()
{
	AnimBlendParams(16,1.00,,);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayAnim('KneelArrest',1.00,0.20,16,True);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlaySetFree ()
{
	AnimBlendParams(16,1.00,,);
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayAnim('SurrenderToKneel',1.00,0.20,16,True);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlayPostEndSurrender ()
{
	m_ePlayerIsUsingHands=HANDS_None;
}

simulated function PlayLockPickDoorAnim ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	R6ResetAnimBlendParams(13);
	PlayWeaponAnimation();
	m_bPostureTransition=True;
	AnimBlendParams(1,1.00,0.00,0.00);
	if ( bIsCrouched )
	{
		LoopAnim('CrouchLockPick_c',2.00,0.20,1);
	}
	else
	{
		LoopAnim('StandLockPick_c',2.00,0.20,1);
	}
}

simulated event PlaySpecialPendingAction (EPendingAction eAction)
{
	switch (eAction)
	{
/*		case 15:
		PlayRemoteChargeAnimation();
		break;
		case 17:
		PlayClaymoreAnimation();
		break;
		case 16:
		PlayBreachDoorAnimation();
		break;
		case 19:
		PlayLockPickDoorAnim();
		break;
		case 20:
		PlayCommunicationAnimation(1);
		break;
		case 21:
		PlayCommunicationAnimation(2);
		break;
		case 22:
		PlayCommunicationAnimation(3);
		break;
		case 23:
		PlayCommunicationAnimation(4);
		break;
		case 24:
		PlayCommunicationAnimation(5);
		break;
		case 25:
		PlayActivateNightVisionAnimation();
		break;
		case 26:
		PlayDeactivateNightVisionAnimation();
		break;
		case 27:
		RainbowSecureWeapon();
		break;
		case 28:
		RainbowEquipWeapon();
		break;
		case 29:
		PlaySecureTerrorist();
		break;
		case 40:
		PlayStartSurrender();
		break;
		case 31:
		PlaySurrender();
		break;
		case 39:
		PlayEndSurrender();
		break;
		case 33:
		PlayArrest();
		break;
		case 43:
		PlayArrestKneel();
		break;
		case 44:
		PlayArrestWaiting();
		break;
		case 45:
		PlayEndArrest();
		break;
		case 42:
		PlaySetFree();
		break;
		case 41:
		PlayPostEndSurrender();
		break;
		default:
		Super.PlaySpecialPendingAction(eAction);*/
	}
}

simulated function ResetPawnSpecificAnimation ()
{
	m_ePlayerIsUsingHands=HANDS_None;
	m_bPawnSpecificAnimInProgress=False;
	R6ResetAnimBlendParams(16);
}

simulated function PlayCoughing ()
{
	if ( m_bIsClimbingLadder || m_bWeaponTransition )
	{
		return;
	}
	m_ePlayerIsUsingHands=HANDS_Both;
	m_bPawnSpecificAnimInProgress=True;
	AnimBlendParams(16,1.00,0.50,0.00,'R6 Spine');
	if ( m_bIsProne )
	{
		PlayAnim('ProneGazed',1.00,0.00,16);
	}
	else
	{
		if ( bIsCrouched )
		{
			PlayAnim('CrouchGazed',1.00,0.00,16);
		}
		else
		{
			PlayAnim('StandGazed',1.00,0.00,16);
		}
	}
}

simulated function PlayBlinded ()
{
	if ( m_bIsClimbingLadder || m_bWeaponTransition )
	{
		return;
	}
	m_ePlayerIsUsingHands=HANDS_Both;
	m_bPawnSpecificAnimInProgress=True;
	AnimBlendParams(16,1.00,0.50,0.00,'R6 Spine');
	if ( m_bIsProne )
	{
		PlayAnim('ProneBlinded',1.00,0.00,16);
	}
	else
	{
		if ( bIsCrouched )
		{
			PlayAnim('CrouchBlinded',1.00,0.00,16);
		}
		else
		{
			PlayAnim('StandBlinded',1.00,0.00,16);
		}
	}
}

simulated function SetCommunicationAnimation (eComAnimation eComAnim)
{
	ServerSetComAnim(eComAnim);
}

simulated function ServerSetComAnim (eComAnimation eComAnim)
{
	switch (eComAnim)
	{
/*		case 1:
		SetNextPendingAction(PENDING_StopCoughing0);
		break;
		case 2:
		SetNextPendingAction(PENDING_StopCoughing1);
		break;
		case 3:
		SetNextPendingAction(PENDING_StopCoughing2);
		break;
		case 4:
		SetNextPendingAction(PENDING_StopCoughing3);
		break;
		case 5:
		SetNextPendingAction(PENDING_StopCoughing4);
		break;
		default:*/
	}
}

simulated function PlayCommunicationAnimation (eComAnimation eComAnim)
{
	if ( m_bReloadingWeapon || m_bChangingWeapon )
	{
		return;
	}
	m_ePlayerIsUsingHands=HANDS_Left;
	PlayWeaponAnimation();
	AnimBlendParams(15,1.00,,,'R6 L Clavicle');
	m_bPlayingComAnimation=True;
	switch (eComAnim)
	{
/*		case 1:
		if ( m_bIsProne )
		{
			PlayAnim('ProneComFollowMe',1.00,0.20,15);
		}
		else
		{
			PlayAnim('StandComFollowMe',1.00,0.20,15);
		}
		break;
		case 2:
		if ( m_bIsProne )
		{
			PlayAnim('ProneComCover',1.00,0.20,15);
		}
		else
		{
			PlayAnim('StandComCover',1.00,0.20,15);
		}
		break;
		case 3:
		if ( m_bIsProne )
		{
			PlayAnim('ProneComGo',1.00,0.20,15);
		}
		else
		{
			PlayAnim('StandComGo',1.00,0.20,15);
		}
		break;
		case 4:
		if ( m_bIsProne )
		{
			PlayAnim('ProneComRegroup',1.00,0.20,15);
		}
		else
		{
			PlayAnim('StandComRegroup',1.00,0.20,15);
		}
		break;
		case 5:
		if ( m_bIsProne )
		{
			PlayAnim('ProneComHold',1.00,0.20,15);
		}
		else
		{
			PlayAnim('StandComHold',1.00,0.20,15);
		}
		break;
		default:   */
	}
}

simulated function RainbowSecureWeapon ()
{
	if (  !m_bIsPlayer && (EngineWeapon != None) )
	{
		EngineWeapon.GotoState('PutWeaponDown');
	}
//	m_eEquipWeapon=0;
	PlayWeaponAnimation();
}

simulated function RainbowEquipWeapon ()
{
	if (  !m_bIsPlayer && (EngineWeapon != None) )
	{
		EngineWeapon.GotoState('BringWeaponUp');
	}
//	m_eEquipWeapon=1;
	PlayWeaponAnimation();
}

simulated function bool CheckForPassiveGadget (string aClassName)
{
	if ( aClassName == "PRIMARYMAGS" )
	{
		m_iExtraPrimaryClips++;
		return True;
	}
	else
	{
		if ( aClassName == "SECONDARYMAGS" )
		{
			m_iExtraSecondaryClips++;
			return True;
		}
		else
		{
			if ( aClassName == "LOCKPICKKIT" )
			{
				m_bHasLockPickKit=True;
				return True;
			}
			else
			{
				if ( aClassName == "DIFFUSEKIT" )
				{
					m_bHasDiffuseKit=True;
					return True;
				}
				else
				{
					if ( aClassName == "ELECTRONICKIT" )
					{
						m_bHasElectronicsKit=True;
						return True;
					}
					else
					{
						if ( aClassName == "GASMASK" )
						{
							m_bHaveGasMask=True;
							return True;
						}
						else
						{
							if ( aClassName == "DoubleGadget" )
							{
								if ( GetWeaponInGroup(3) != None )
								{
									GetWeaponInGroup(3).GiveMoreAmmo();
								}
								return True;
							}
						}
					}
				}
			}
		}
	}
	return False;
}

simulated function GiveDefaultWeapon ()
{
	local int iLastAllocated;
	local int i;
	local string szCurrentGadget;
	local string caps_szPrimaryWeapon;
	local string caps_szSecondaryWeapon;
	local string caps_szCurrentGadget;

	if ( (Level.NetMode == NM_Standalone) ||  !m_bIsPlayer )
	{
		caps_szPrimaryWeapon=Caps(m_szPrimaryWeapon);
		if ( (caps_szPrimaryWeapon != "R6WEAPONS.NONE") && (caps_szPrimaryWeapon != "") )
		{
			ServerGivesWeaponToClient(m_szPrimaryWeapon,1,m_szPrimaryBulletType,m_szPrimaryGadget);
		}
		caps_szSecondaryWeapon=Caps(m_szSecondaryWeapon);
		if ( (caps_szSecondaryWeapon != "R6WEAPONS.NONE") && (caps_szSecondaryWeapon != "") )
		{
			ServerGivesWeaponToClient(m_szSecondaryWeapon,2,m_szSecondaryBulletType,m_szSecondaryGadget);
		}
		iLastAllocated=3;
		i=0;
JL00CC:
		if ( i < 2 )
		{
			if ( i == 0 )
			{
				szCurrentGadget=m_szPrimaryItem;
			}
			else
			{
				szCurrentGadget=m_szSecondaryItem;
			}
			caps_szCurrentGadget=Caps(szCurrentGadget);
			if ( (caps_szCurrentGadget != "R6WEAPONGADGETS.NONE") && (caps_szCurrentGadget != "") )
			{
				if ( caps_szCurrentGadget == "PRIMARYMAGS" )
				{
					GetWeaponInGroup(1).AddExtraClip();
				}
				else
				{
					if ( caps_szCurrentGadget == "SECONDARYMAGS" )
					{
						GetWeaponInGroup(2).AddExtraClip();
					}
					else
					{
						if ( caps_szCurrentGadget == "LOCKPICKKIT" )
						{
							m_bHasLockPickKit=True;
						}
						else
						{
							if ( caps_szCurrentGadget == "DIFFUSEKIT" )
							{
								m_bHasDiffuseKit=True;
							}
							else
							{
								if ( caps_szCurrentGadget == "ELECTRONICKIT" )
								{
									m_bHasElectronicsKit=True;
								}
								else
								{
									if ( caps_szCurrentGadget == "GASMASK" )
									{
										m_bHaveGasMask=True;
									}
									else
									{
										if ( (i == 1) && (Caps(m_szPrimaryItem) == Caps(m_szSecondaryItem)) )
										{
											GetWeaponInGroup(3).GiveMoreAmmo();
										}
										else
										{
											ServerGivesWeaponToClient(szCurrentGadget,iLastAllocated);
											iLastAllocated++;
										}
									}
								}
							}
						}
					}
				}
			}
			i++;
			goto JL00CC;
		}
		if ( Controller != None )
		{
			Controller.m_PawnRepInfo.m_PawnType=m_ePawnType;
			Controller.m_PawnRepInfo.m_bSex=bIsFemale;
		}
		ReceivedWeapons();
	}
	if ( m_bHaveGasMask )
	{
		AttachGasMask();
	}
}

simulated function AttachGasMask ()
{
	if ( m_Helmet != None )
	{
		if ( m_eArmorType == 3 )
		{
			m_Helmet.SetHelmetStaticMesh(True);
		}
	}
	if ( m_GasMask == None )
	{
		m_GasMask=Spawn(m_GasMaskClass);
		AttachToBone(m_GasMask,'R6 Head');
	}
	if ( bIsFemale && m_bScaleGasMaskForFemale )
	{
		m_GasMask.DrawScale=1.00;
	}
}

simulated event ReceivedEngineWeapon ()
{
	AttachWeapon(EngineWeapon,EngineWeapon.m_AttachPoint);
	PlayWeaponAnimation();
}

simulated event PlayWeaponAnimation ()
{
	if ( m_bPawnSpecificAnimInProgress && (m_bReloadingWeapon || m_bChangingWeapon || EngineWeapon.bFiredABullet || (m_eGrenadeThrow != 0)) )
	{
		ResetPawnSpecificAnimation();
	}
	Super.PlayWeaponAnimation();
}

simulated event ReceivedWeapons ()
{
	local int i;
	local R6EngineWeapon AWeapon;

	if ( (Level.NetMode != 0) && m_bHaveGasMask )
	{
		AttachGasMask();
	}
	i=1;
JL0031:
	if ( i <= 4 )
	{
		AWeapon=GetWeaponInGroup(i);
		if ( AWeapon != None )
		{
			if ( i == 4 )
			{
				AWeapon.m_HoldAttachPoint=AWeapon.m_HoldAttachPoint2;
			}
			AttachWeapon(AWeapon,AWeapon.m_HoldAttachPoint);
			AWeapon.WeaponInitialization(self);
			if ( IsLocallyControlled() )
			{
				if ( m_bIsPlayer )
				{
					AWeapon.LoadFirstPersonWeapon(self);
				}
				else
				{
					AWeapon.RemoteRole=ROLE_SimulatedProxy;
				}
				if ( i == 1 )
				{
					if ( m_bIsPlayer )
					{
JL00F5:
						if ( m_iExtraPrimaryClips > 0 )
						{
							AWeapon.AddExtraClip();
							m_iExtraPrimaryClips--;
							goto JL00F5;
						}
					}
				}
				if ( i == 2 )
				{
JL0125:
					if ( m_iExtraSecondaryClips > 0 )
					{
						AWeapon.AddExtraClip();
						m_iExtraSecondaryClips--;
						goto JL0125;
					}
				}
			}
		}
		i++;
		goto JL0031;
	}
	if ( IsLocallyControlled() )
	{
		EngineWeapon=GetWeaponInGroup(1);
		if ( EngineWeapon == None )
		{
			EngineWeapon=GetWeaponInGroup(2);
			if ( m_SoundRepInfo != None )
			{
				m_SoundRepInfo.m_CurrentWeapon=1;
			}
		}
		if ( EngineWeapon != None )
		{
			ServerChangedWeapon(None,EngineWeapon);
			if ( m_bIsPlayer )
			{
				EngineWeapon.GotoState('RaiseWeapon');
			}
			else
			{
				EngineWeapon.GotoState('None');
			}
		}
	}
	if ( EngineWeapon != None )
	{
		AttachWeapon(EngineWeapon,EngineWeapon.m_AttachPoint);
	}
	PlayWeaponAnimation();
}

function SetMovementPhysics ()
{
	SetPhysics(PHYS_Walking);
}

simulated function PlayWaiting ()
{
	if ( m_bSlideEnd )
	{
		return;
	}
	if ( m_bInitRainbow )
	{
		return;
	}
	if ( Physics == 2 )
	{
		PlayFalling();
		return;
	}
	if ( m_bIsClimbingLadder )
	{
		AnimateStoppedOnLadder();
		return;
	}
	if ( bIsCrouched )
	{
		PlayCrouchWaiting();
		return;
	}
	if ( m_bIsProne )
	{
		PlayProneWaiting();
		return;
	}
	if (  !m_bNightVisionAnimation )
	{
		m_ePlayerIsUsingHands=HANDS_None;
	}
	if ( (m_fPeeking != 1000.00) || IsPeeking() || (m_u8CurrentYaw != 0) )
	{
		if ( bIsCrouched != bWasCrouched )
		{
			m_bTweenFirstTimeOnly=True;
		}
		if ( m_bTweenFirstTimeOnly )
		{
			PlayPeekingAnim(True);
			m_bTweenFirstTimeOnly=False;
			R6PlayAnim('StandWaitBreathe');
		}
		else
		{
			PlayAnim('StandWaitBreathe');
		}
		return;
	}
	if ( m_bIsPlayer || (m_TrackActor != None) || m_bIsSniping )
	{
		if ( EngineWeapon != None )
		{
			R6PlayAnim('StandWaitBreathe');
		}
		else
		{
			R6PlayAnim('StandSubGunHigh_nt');
		}
		return;
	}
	SetRandomWaiting(12);
	switch (m_bRepPlayWaitAnim)
	{
		case 0:
		R6PlayAnim('StandWaitBreathe');
		break;
		case 1:
		R6PlayAnim('StandWaitCrackNeck');
		break;
		case 2:
		R6PlayAnim('StandWaitLookAround01');
		break;
		case 3:
		R6PlayAnim('StandWaitLookAround02');
		break;
		case 4:
		R6PlayAnim('StandWaitLookBack01');
		break;
		case 5:
		R6PlayAnim('StandWaitLookBack02');
		break;
		case 6:
		R6PlayAnim('StandWaitLookWatch');
		break;
		case 7:
		R6PlayAnim('StandWaitScratchNose');
		break;
		case 8:
		R6PlayAnim('StandWaitShiftWeight');
		break;
		case 9:
		R6PlayAnim('StandWaitUpDown01');
		break;
		case 10:
		R6PlayAnim('StandWaitUpDown02');
		break;
		default:
		R6PlayAnim('StandWaitWipeFace');
		break;
	}
}

simulated event SetAnimAction (name NewAction)
{
	AnimAction=NewAction;
	AnimBlendParams(14,1.00,0.20,0.00,'R6 Spine2');
	PlayAnim(NewAction,1.00,0.00,14);
}

simulated function StopPeeking ()
{
	if ( m_ePeekingMode == 1 )
	{
		SetPeekingInfo(PEEK_none,1000.00);
	}
}

simulated function ClientQuickResetPeeking ()
{
	SetPeekingInfo(PEEK_none,1000.00);
	SetCrouchBlend(0.00);
}

event EndCrouch (float fHeight)
{
	Super.EndCrouch(fHeight);
	EndKneeDown();
}

simulated function PlayDuck ()
{
	PlayCrouchWaiting();
}

simulated function BlendKneeOnGround ()
{
	if ( m_bPostureTransition )
	{
		return;
	}
	AnimBlendParams(1,1.00,0.00,0.00,'R6 R Thigh');
	LoopAnim('Kneel_nt',1.00,0.20,1);
}

simulated function EndKneeDown ()
{
	PlayAnim('CrouchSubGunLow_nt',1.00,0.20,1);
	AnimBlendToAlpha(1,0.00,0.50);
}

event StartCrouch (float HeightAdjust)
{
	Super.StartCrouch(HeightAdjust);
}

simulated function PlayCrouchWaiting ()
{
	if ( Physics == 2 )
	{
		PlayFalling();
		return;
	}
	if (  !m_bNightVisionAnimation )
	{
		m_ePlayerIsUsingHands=HANDS_None;
	}
	if ( (m_fPeeking != 1000.00) || IsPeeking() )
	{
		if ( bIsCrouched != bWasCrouched )
		{
			m_bTweenFirstTimeOnly=True;
		}
		if ( m_bTweenFirstTimeOnly )
		{
			PlayPeekingAnim(True);
			m_bTweenFirstTimeOnly=False;
			R6PlayAnim('CrouchWaitBreathe01');
		}
		else
		{
			PlayAnim('CrouchWaitBreathe01');
		}
		return;
	}
	if ( m_bIsPlayer || (m_TrackActor != None) || m_bIsSniping )
	{
		R6PlayAnim('CrouchWaitBreathe01');
	}
	else
	{
		SetRandomWaiting(5);
		switch (m_bRepPlayWaitAnim)
		{
			case 0:
			R6PlayAnim('CrouchWaitBreathe01');
			break;
			case 1:
			R6PlayAnim('CrouchWaitBreathe02');
			break;
			case 2:
			R6PlayAnim('CrouchWaitCrackNeck');
			break;
			case 3:
			R6PlayAnim('CrouchWaitLookWatch');
			break;
			default:
		}
		R6PlayAnim('CrouchWaitLookUp');
	}
	if ( (Physics != 12) && (m_eEquipWeapon != 2) )
	{
		BlendKneeOnGround();
	}
}

simulated function PlayProneWaiting ()
{
	if ( m_bIsPlayer || (m_TrackActor != None) || m_bIsSniping )
	{
		if ( EngineWeapon == None )
		{
			R6LoopAnim('ProneWaitBreathe');
		}
		else
		{
			if ( EngineWeapon.m_eWeaponType == 5 )
			{
				R6LoopAnim('ProneBipodLMGBreathe');
			}
			else
			{
				if ( EngineWeapon.m_eWeaponType == 4 )
				{
					R6LoopAnim('ProneBipodSniperBreathe');
				}
				else
				{
					R6LoopAnim('ProneWaitBreathe');
				}
			}
		}
	}
	else
	{
		SetRandomWaiting(3);
		switch (m_bRepPlayWaitAnim)
		{
			case 0:
			if ( EngineWeapon == None )
			{
				R6LoopAnim('ProneWaitBreathe');
			}
			else
			{
				if ( EngineWeapon.m_eWeaponType == 5 )
				{
					R6LoopAnim('ProneBipodLMGBreathe');
				}
				else
				{
					if ( EngineWeapon.m_eWeaponType == 4 )
					{
						R6LoopAnim('ProneBipodSniperBreathe');
					}
					else
					{
						R6LoopAnim('ProneWaitBreathe');
					}
				}
			}
			break;
			case 1:
			R6LoopAnim('ProneWaitCrackNeck');
			break;
			default:
		}
		R6LoopAnim('ProneWaitLookAround');
	}
}

function Rotator GetFiringRotation ()
{
	local R6RainbowAI AI;

	if ( m_bIsPlayer )
	{
		return GetViewRotation();
	}
	AI=R6RainbowAI(Controller);
	if ( EngineWeapon.m_eWeaponType == 6 )
	{
		if ( AI.m_vLocationOnTarget != vect(0.00,0.00,0.00) )
		{
			return AI.GetGrenadeDirection(None,AI.m_vLocationOnTarget);
		}
		else
		{
			return Controller.Rotation;
		}
	}
	return m_rFiringRotation;
}

simulated function bool HasPawnSpecificWeaponAnimation ()
{
	if ( (m_eEquipWeapon == 1) || (m_eEquipWeapon == 0) )
	{
		return True;
	}
	return False;
}

simulated function BoltActionSwitchToLeft ()
{
	m_bReAttachToRightHand=True;
	AttachWeapon(EngineWeapon,'TagBoltRifle');
}

simulated function BoltActionSwitchToLeftProne ()
{
	m_bReAttachToRightHand=True;
	AttachWeapon(EngineWeapon,'TagBipodBoltRifle');
}

simulated function BoltActionSwitchToRight ()
{
	m_bReAttachToRightHand=False;
	AttachWeapon(EngineWeapon,'TagRightHand');
}

simulated function SecureWeapon ()
{
	m_bWeaponTransition=False;
	if ( m_eEquipWeapon == 1 )
	{
//		m_eEquipWeapon=3;
		PlayWeaponAnimation();
		return;
	}
	if ( EngineWeapon != None )
	{
		AttachWeapon(EngineWeapon,EngineWeapon.m_HoldAttachPoint);
	}
//	m_eEquipWeapon=2;
}

simulated function EquipWeapon ()
{
	if ( m_eEquipWeapon == 0 )
	{
		return;
	}
	if ( (EngineWeapon.m_eWeaponType == 0) || (EngineWeapon.m_eWeaponType == 7) )
	{
		AttachWeapon(EngineWeapon,EngineWeapon.m_AttachPoint);
	}
	else
	{
		AttachWeapon(EngineWeapon,'TagLeftHand');
	}
}

simulated function EquipHands ()
{
	if ( m_eEquipWeapon == 1 )
	{
		AttachWeapon(EngineWeapon,EngineWeapon.m_AttachPoint);
	}
	else
	{
		if ( m_eEquipWeapon == 0 )
		{
			AttachWeapon(EngineWeapon,'TagLeftHand');
		}
	}
}

function FinishedReloadingWeapon ()
{
	if ( Controller == None )
	{
		return;
	}
	if ( EngineWeapon.IsPumpShotGun() && (Controller.Enemy == None) &&  !EngineWeapon.GunIsFull() && (EngineWeapon.GetNbOfClips() > 0) )
	{
		R6RainbowAI(Controller).RainbowReloadWeapon();
	}
	else
	{
		m_bReloadToFullAmmo=False;
	}
}

simulated function bool GetNormalWeaponAnimation (out STWeaponAnim stAnim)
{
	if ( m_bPlayingComAnimation )
	{
		return False;
	}
	stAnim.bBackward=False;
	stAnim.bPlayOnce=False;
	if ( m_bIsFiringWeapon > 0 )
	{
		stAnim.fTweenTime=0.00;
	}
	else
	{
		stAnim.fTweenTime=0.10;
	}
	stAnim.fRate=1.00;
	if ( IsUsingHeartBeatSensor() )
	{
		stAnim.nBlendName='R6 Spine2';
	}
	else
	{
		stAnim.nBlendName='R6 R Clavicle';
	}
	if ( m_bIsProne )
	{
		if ( (EngineWeapon != None) && (R6AbstractWeapon(EngineWeapon).m_BipodGadget == None) )
		{
			stAnim.nAnimToPlay=EngineWeapon.GetProneWaitAnimName();
		}
		else
		{
			m_ePlayerIsUsingHands=HANDS_Both;
			return False;
		}
	}
	else
	{
		if ( (m_eEquipWeapon == 2) || (EngineWeapon == None) )
		{
			stAnim.nAnimToPlay='StandNoGun_nt';
		}
		else
		{
			if ( m_bUseHighStance )
			{
				stAnim.nAnimToPlay=EngineWeapon.GetHighWaitAnimName();
			}
			else
			{
				stAnim.nAnimToPlay=EngineWeapon.GetWaitAnimName();
			}
		}
	}
	return True;
}

simulated function bool GetFireWeaponAnimation (out STWeaponAnim stAnim)
{
	stAnim.bBackward=False;
	stAnim.bPlayOnce=True;
	stAnim.fRate=1.50;
	stAnim.fTweenTime=0.05;
	stAnim.nBlendName='R6 R Clavicle';
	if ( m_bIsProne )
	{
		stAnim.nAnimToPlay=EngineWeapon.GetProneFiringAnimName();
	}
	else
	{
		stAnim.nAnimToPlay=EngineWeapon.GetFiringAnimName();
	}
	return True;
}

simulated function bool GetReloadWeaponAnimation (out STWeaponAnim stAnim)
{
	if ( m_bIsProne )
	{
		if ( EngineWeapon.NumberOfBulletsLeftInClip() != 0 )
		{
			stAnim.nAnimToPlay=EngineWeapon.GetProneReloadAnimTacticalName();
		}
		else
		{
			stAnim.nAnimToPlay=EngineWeapon.GetProneReloadAnimName();
		}
	}
	else
	{
		if ( EngineWeapon.NumberOfBulletsLeftInClip() != 0 )
		{
			stAnim.nAnimToPlay=EngineWeapon.GetReloadAnimTacticalName();
		}
		else
		{
			stAnim.nAnimToPlay=EngineWeapon.GetReloadAnimName();
		}
	}
	if ( stAnim.nAnimToPlay == m_WeaponAnimPlaying )
	{
		return False;
	}
	m_bWeaponTransition=True;
	m_ePlayerIsUsingHands=HANDS_None;
	stAnim.bBackward=False;
	stAnim.bPlayOnce=True;
	stAnim.fRate=1.00;
	stAnim.fTweenTime=0.10;
	stAnim.nBlendName='R6 Spine2';
	return True;
}

simulated function bool GetChangeWeaponAnimation (out STWeaponAnim stAnim)
{
	m_bWeaponTransition=True;
	m_WeaponAnimPlaying='None';
	stAnim.bBackward=False;
	stAnim.bPlayOnce=True;
	stAnim.fRate=ArmorSkillEffect() * 2.50;
	stAnim.fTweenTime=0.10;
	stAnim.nBlendName='R6 Spine2';
	if ( EngineWeapon == None )
	{
		return False;
	}
	if ( PendingWeapon == None )
	{
		m_bPreviousAnimPlayOnce=False;
		stAnim.nAnimToPlay=m_WeaponAnimPlaying;
		m_eLastUsingHands=m_ePlayerIsUsingHands;
		return True;
	}
	SendPlaySound(EngineWeapon.m_UnEquipSnd,SLOT_SFX,True);
	switch (EngineWeapon.m_eWeaponType)
	{
/*		case 6:
		case 7:
		switch (PendingWeapon.m_eWeaponType)
		{
			case 1:
			case 4:
			case 5:
			case 3:
			case 2:
			if ( bIsCrouched )
			{
				stAnim.nAnimToPlay='CrouchSubGunToGrenade';
			}
			else
			{
				if ( m_bIsProne )
				{
					if ( PendingWeapon.GotBipod() )
					{
						stAnim.nAnimToPlay='ProneBipodSubGunToGrenade';
					}
					else
					{
						stAnim.nAnimToPlay='ProneSubGunToGrenade';
					}
				}
				else
				{
					stAnim.nAnimToPlay='StandSubGunToGrenade';
				}
			}
			stAnim.bBackward=True;
			break;
			case 0:
			if ( m_bIsProne )
			{
				stAnim.nAnimToPlay='ProneHandGunToGrenade';
			}
			else
			{
				stAnim.nAnimToPlay='StandHandGunToGrenade';
			}
			stAnim.bBackward=True;
			break;
			case 7:
			default:
			if ( m_bIsProne )
			{
				stAnim.nAnimToPlay='ProneGrenadeChange';
			}
			else
			{
				stAnim.nAnimToPlay='StandGrenadeChange';
			}
			break;
		}
		break;
		case 0:
		switch (PendingWeapon.m_eWeaponType)
		{
			case 1:
			case 4:
			case 5:
			case 3:
			case 2:
			if ( bIsCrouched )
			{
				stAnim.nAnimToPlay='CrouchSubGunToHandGun';
			}
			else
			{
				if ( m_bIsProne )
				{
					if ( PendingWeapon.GotBipod() )
					{
						stAnim.nAnimToPlay='ProneBipodSubGunToHandGun';
					}
					else
					{
						stAnim.nAnimToPlay='ProneSubGunToHandGun';
					}
				}
				else
				{
					stAnim.nAnimToPlay='StandSubGunToHandGun';
				}
			}
			stAnim.bBackward=True;
			break;
			case 6:
			case 7:
			if ( bIsCrouched )
			{
				stAnim.nAnimToPlay='CrouchHandGunToGrenade';
			}
			else
			{
				if ( m_bIsProne )
				{
					stAnim.nAnimToPlay='ProneHandGunToGrenade';
				}
				else
				{
					stAnim.nAnimToPlay='StandHandGunToGrenade';
				}
			}
			break;
			default:
		}
		break;
		case 1:
		case 4:
		case 5:
		case 3:
		case 2:
		switch (PendingWeapon.m_eWeaponType)
		{
			case 0:
			if ( bIsCrouched )
			{
				stAnim.nAnimToPlay='CrouchSubGunToHandGun';
			}
			else
			{
				if ( m_bIsProne )
				{
					if ( EngineWeapon.GotBipod() )
					{
						stAnim.nAnimToPlay='ProneBipodSubGunToHandGun';
					}
					else
					{
						stAnim.nAnimToPlay='ProneSubGunToHandGun';
					}
				}
				else
				{
					stAnim.nAnimToPlay='StandSubGunToHandGun';
				}
			}
			break;
			case 6:
			case 7:
			if ( bIsCrouched )
			{
				stAnim.nAnimToPlay='CrouchSubGunToGrenade';
			}
			else
			{
				if ( m_bIsProne )
				{
					if ( EngineWeapon.GotBipod() )
					{
						stAnim.nAnimToPlay='ProneBipodSubGunToGrenade';
					}
					else
					{
						stAnim.nAnimToPlay='ProneSubGunToGrenade';
					}
				}
				else
				{
					stAnim.nAnimToPlay='StandSubGunToGrenade';
				}
			}
			break;
			default:
		}
		break;
		default: */
	}
	return True;
}

simulated function bool GetThrowGrenadeAnimation (out STWeaponAnim stAnim)
{
	m_bWeaponTransition=True;
	stAnim.bBackward=False;
	stAnim.bPlayOnce=True;
	stAnim.fRate=ArmorSkillEffect();
	stAnim.fTweenTime=0.10;
	stAnim.nBlendName='R6 R Clavicle';
	m_bThrowGrenadeWithLeftHand=False;
	if ( Level.NetMode != 1 )
	{
		if ( (R6PlayerController(Controller) == None) ||  !R6PlayerController(Controller).Player.IsA('Viewport') )
		{
			if ( m_eGrenadeThrow == 3 )
			{
//				PlaySound(EngineWeapon.m_ReloadSnd,3);
			}
			else
			{
//				PlaySound(EngineWeapon.m_BurstFireStereoSnd,3);
			}
		}
	}
	switch (m_eGrenadeThrow)
	{
/*		case 1:
		if ( m_bIsProne )
		{
			stAnim.nAnimToPlay='ProneThrowGrenade';
		}
		else
		{
			stAnim.nAnimToPlay='StandThrowGrenade';
		}
		break;
		case 2:
		if ( m_bIsProne )
		{
			stAnim.nAnimToPlay='ProneRollGrenade';
		}
		else
		{
			stAnim.nAnimToPlay='StandRollGrenade';
		}
		break;
		case 3:
		if ( m_bIsProne )
		{
			stAnim.nAnimToPlay='PronePullPin';
		}
		else
		{
			stAnim.nAnimToPlay='StandPullPin';
		}
		break;
		case 4:
		if (  !m_bIsPlayer )
		{
			stAnim.nBlendName='R6 Spine';
			stAnim.fTweenTime=0.50;
		}
		m_bThrowGrenadeWithLeftHand=True;
		stAnim.nAnimToPlay='PeekLeftRollGrenade';
		break;
		case 6:
		if (  !m_bIsPlayer )
		{
			stAnim.nBlendName='R6 Spine';
			stAnim.fTweenTime=0.50;
		}
		m_bThrowGrenadeWithLeftHand=True;
		stAnim.nAnimToPlay='PeekLeftThrowGrenade';
		break;
		case 5:
		if (  !m_bIsPlayer )
		{
			stAnim.nBlendName='R6 Spine';
			stAnim.fTweenTime=0.50;
		}
		stAnim.nAnimToPlay='PeekRightRollGrenade';
		break;
		case 7:
		if (  !m_bIsPlayer )
		{
			stAnim.nBlendName='R6 Spine';
			stAnim.fTweenTime=0.50;
		}
		stAnim.nAnimToPlay='PeekRightThrowGrenade';
		break;
		default:*/
	}
	if ( stAnim.nAnimToPlay == m_WeaponAnimPlaying )
	{
		return False;
	}
//	m_eGrenadeThrow=0;
	return True;
}

simulated function bool GetPawnSpecificAnimation (out STWeaponAnim stAnim)
{
	m_bWeaponTransition=True;
	m_bWeaponIsSecured=False;
	m_WeaponAnimPlaying='None';
	stAnim.bPlayOnce=True;
	stAnim.fRate=ArmorSkillEffect() * 1.50;
	stAnim.fTweenTime=0.10;
	stAnim.nBlendName='R6 Spine2';
	stAnim.bBackward=False;
	m_ePlayerIsUsingHands=HANDS_None;
	switch (EngineWeapon.m_eWeaponType)
	{
/*		case 1:
		case 4:
		case 5:
		case 3:
		case 2:
		stAnim.nAnimToPlay='StandSubGun_b';
		break;
		case 0:
		stAnim.nAnimToPlay='StandHandGun_b';
		break;
		case 7:
		default:
		stAnim.nAnimToPlay='StandGrenade_b';
		break;*/
	}
	if ( m_eEquipWeapon == 0 )
	{
		SendPlaySound(EngineWeapon.m_UnEquipSnd,SLOT_SFX,True);
		m_bWeaponIsSecured=True;
		stAnim.bBackward=True;
	}
	else
	{
		SendPlaySound(EngineWeapon.m_EquipSnd,SLOT_SFX,True);
	}
	return True;
}

simulated function GetWeapon (R6AbstractWeapon NewWeapon)
{
	if ( NewWeapon != EngineWeapon )
	{
		if ( Level.NetMode != 3 )
		{
			m_pBulletManager.SetBulletParameter(NewWeapon);
		}
		if ( EngineWeapon != None )
		{
			EngineWeapon.DisableWeaponOrGadget();
			if ( m_bWeaponGadgetActivated == True )
			{
				m_bWeaponGadgetActivated=False;
				R6AbstractWeapon(EngineWeapon).m_SelectedWeaponGadget.ActivateGadget(False);
			}
			PendingWeapon=NewWeapon;
			if (  !m_bIsPlayer )
			{
				m_bChangingWeapon=True;
			}
		}
	}
}

simulated function SubToHand_Step1 ()
{
	m_preSwitchWeapon=EngineWeapon;
	if ( EngineWeapon == None )
	{
		return;
	}
	if ( R6AbstractWeapon(EngineWeapon).m_bHiddenWhenNotInUse )
	{
		EngineWeapon.bHidden=True;
	}
	switch (EngineWeapon.m_eWeaponType)
	{
/*		case 0:
		case 7:
		case 6:
		AttachWeapon(EngineWeapon,EngineWeapon.m_HoldAttachPoint);
		switch (PendingWeapon.m_eWeaponType)
		{
			case 0:
			case 7:
			case 6:
			break;
			case 1:
			case 2:
			case 3:
			case 4:
			case 5:
			AttachWeapon(PendingWeapon,'TagLeftHand');
			break;
			default:
		}
		break;
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		AttachWeapon(EngineWeapon,'TagLeftHand');
		break;
		default:*/
	}
}

simulated function SubToHand_Step2 ()
{
	if ( EngineWeapon == None )
	{
		return;
	}
	PendingWeapon.bHidden=False;
	SendPlaySound(PendingWeapon.m_EquipSnd,SLOT_SFX,True);
	if ( m_preSwitchWeapon != None )
	{
		AttachWeapon(m_preSwitchWeapon,m_preSwitchWeapon.m_HoldAttachPoint);
		if ( Level.NetMode != 1 )
		{
			m_preSwitchWeapon.TurnOffEmitters(True);
		}
		m_preSwitchWeapon=None;
	}
	else
	{
		AttachWeapon(EngineWeapon,EngineWeapon.m_HoldAttachPoint);
		if ( Level.NetMode != 1 )
		{
			EngineWeapon.TurnOffEmitters(True);
		}
	}
	AttachWeapon(PendingWeapon,PendingWeapon.m_AttachPoint);
	if ( Level.NetMode != 1 )
	{
		PendingWeapon.TurnOffEmitters(False);
	}
}

function ChangingWeaponEnd ()
{
	if ( EngineWeapon == None )
	{
		return;
	}
	if ( (Level.NetMode != 0) &&  !bNetOwner && (Role != 4) )
	{
		return;
	}
	m_bChangingWeapon=False;
	if ( Controller.IsA('R6PlayerController') && (R6PlayerController(Controller).bBehindView == False) && (Level.NetMode == NM_Standalone) )
	{
		return;
	}
	EngineWeapon=PendingWeapon;
	if ( Level.NetMode == NM_Standalone )
	{
		PendingWeapon=None;
	}
}

function ChangeProneAttach ()
{
	if ( m_WeaponsCarried[0] != None )
	{
		if ( m_WeaponsCarried[0].m_HoldAttachPoint == m_WeaponsCarried[0].Default.m_HoldAttachPoint )
		{
			m_WeaponsCarried[0].m_HoldAttachPoint='TagBackProne';
		}
		else
		{
			m_WeaponsCarried[0].m_HoldAttachPoint=m_WeaponsCarried[0].Default.m_HoldAttachPoint;
		}
		if ( m_WeaponsCarried[0] != EngineWeapon )
		{
			AttachWeapon(m_WeaponsCarried[0],m_WeaponsCarried[0].m_HoldAttachPoint);
		}
	}
}

event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	local R6Rainbow pInteractor;

	if ( Class'Actor'.static.GetModMgr().IsMissionPack() )
	{
		if ( Query.aQueryOwner.IsA('R6PlayerController') && Query.aQueryTarget.IsA('R6Rainbow') && IsAlive() )
		{
			pInteractor=R6PlayerController(Query.aQueryOwner).m_pawn;
			if ( m_bIsSurrended &&  !m_bIsUnderArrest && (pInteractor.m_iTeam != R6Rainbow(Query.aQueryTarget).m_iTeam) &&  !pInteractor.m_bIsSurrended &&  !pInteractor.m_bIsClimbingLadder )
			{
				Query.iHasAction=1;
				if ( (fDistance < m_fCircumstantialActionRange) && (Abs(Location.Z - pInteractor.Location.Z) < 110) )
				{
					Query.iInRange=1;
				}
				else
				{
					Query.iInRange=0;
				}
//				Query.textureIcon=Texture'HandcuffTerrorist';
				Query.fPlayerActionTimeRequired=0.00;
				Query.bCanBeInterrupted=True;
				Query.iPlayerActionID=1;
				Query.iTeamActionID=1;
				Query.iTeamActionIDList[0]=1;
				Query.iTeamActionIDList[1]=0;
				Query.iTeamActionIDList[2]=0;
				Query.iTeamActionIDList[3]=0;
			}
			else
			{
				if ( m_bIsUnderArrest && (pInteractor.m_iTeam == R6Rainbow(Query.aQueryTarget).m_iTeam) &&  !pInteractor.m_bIsClimbingLadder )
				{
					Query.iHasAction=1;
					if ( (fDistance < m_fCircumstantialActionRange) && (Abs(Location.Z - pInteractor.Location.Z) < 110) )
					{
						Query.iInRange=1;
					}
					else
					{
						Query.iInRange=0;
					}
//					Query.textureIcon=Texture'FreeRainbow';
					Query.fPlayerActionTimeRequired=0.00;
					Query.bCanBeInterrupted=True;
					Query.iPlayerActionID=2;
					Query.iTeamActionID=2;
					Query.iTeamActionIDList[0]=2;
					Query.iTeamActionIDList[1]=0;
					Query.iTeamActionIDList[2]=0;
					Query.iTeamActionIDList[3]=0;
				}
				else
				{
					Query.iHasAction=0;
				}
			}
		}
	}
	else
	{
		Query.iHasAction=0;
	}
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
		case 1:
		return Localize("RDVOrder","Order_Secure","R6Menu");
		case 2:
		return Localize("RDVOrder","Order_Secure","R6Menu");
		default:
	}
	return "";
}

function int R6GetCircumstantialActionProgress (R6AbstractCircumstantialActionQuery Query, Pawn actingPawn)
{
	local name Anim;
	local float fFrame;
	local float fRate;

	actingPawn.GetAnimParams(1,Anim,fFrame,fRate);
	Clamp(fFrame,0,100);
	return fFrame * 100;
}

function R6CircumstantialActionProgressStart (R6AbstractCircumstantialActionQuery Query)
{
}

function ResetArrest ()
{
	AnimBlendToAlpha(16,0.00,0.50);
	m_ePlayerIsUsingHands=HANDS_Both;
	m_bIsUnderArrest=False;
	if ( Level.NetMode == NM_Client )
	{
		R6PlayerController(Controller).ServerStartSurrended();
	}
	R6PlayerController(Controller).GotoState('PlayerSurrended');
	R6PlayerController(Controller).m_fStartSurrenderTime=Level.TimeSeconds;
	m_bIsBeingArrestedOrFreed=False;
	PlayWaiting();
}

function ServerSetCrouch (bool bCrouch)
{
	bWantsToCrouch=bCrouch;
}

function bool HasBumpPriority (R6Pawn bumpedBy)
{
	if ( R6RainbowAI(Controller).m_TeamManager.m_bGrenadeInProximity )
	{
		return True;
	}
	if ( (m_iTeam != bumpedBy.m_iTeam) &&  !bumpedBy.m_bIsPlayer )
	{
		return True;
	}
	if ( (bumpedBy.m_iID <= m_iID) &&  !bumpedBy.IsStationary() )
	{
		return False;
	}
	return True;
}

function UpdateRainbowSkills ()
{
	local int iD5;
	local int iD2;

	if (  !IsAlive() )
	{
		return;
	}
	if ( m_szSpecialityID == "" )
	{
		return;
	}
	iD5=Rand(5) + 1;
	iD2=Rand(2) + 1;
	if ( m_szSpecialityID == "ID_ASSAULT" )
	{
		m_fSkillAssault += (iD5 + 5) / 100.00 * (1 - m_fSkillAssault);
	}
	else
	{
		m_fSkillAssault += (iD2 + 2) / 100.00 * (1 - m_fSkillAssault);
	}
	if ( m_szSpecialityID == "ID_DEMOLITIONS" )
	{
		m_fSkillDemolitions += (iD5 + 5) / 100.00 * (1 - m_fSkillDemolitions);
	}
	else
	{
		if ( FRand() <= 0.20 )
		{
			m_fSkillDemolitions += 0.02 * (1 - m_fSkillDemolitions);
		}
	}
	if ( m_szSpecialityID == "ID_ELECTRONICS" )
	{
		m_fSkillElectronics += (iD5 + 5) / 100.00 * (1 - m_fSkillElectronics);
	}
	else
	{
		if ( FRand() <= 0.20 )
		{
			m_fSkillElectronics += 0.02 * (1 - m_fSkillElectronics);
		}
	}
	if ( m_szSpecialityID == "ID_RECON" )
	{
		m_fSkillStealth += (iD5 + 5) / 100.00 * (1 - m_fSkillStealth);
	}
	else
	{
		if ( FRand() <= 0.20 )
		{
			m_fSkillStealth += 0.02 * (1 - m_fSkillStealth);
		}
	}
	if ( m_szSpecialityID == "ID_SNIPER" )
	{
		m_fSkillSniper += (iD5 + 5) / 100.00 * (1 - m_fSkillSniper);
	}
	else
	{
		if ( FRand() <= 0.20 )
		{
			m_fSkillSniper += 0.02 * (1 - m_fSkillSniper);
		}
	}
	if ( FRand() <= 0.20 )
	{
		m_fSkillSelfControl += 0.02 * (1 - m_fSkillSelfControl);
	}
	if ( FRand() <= 0.20 )
	{
		m_fSkillLeadership += 0.02 * (1 - m_fSkillLeadership);
	}
	if ( FRand() <= 0.20 )
	{
		m_fSkillObservation += 0.02 * (1 - m_fSkillObservation);
	}
}

function bool IsFighting ()
{
	if (  !IsAlive() )
	{
		return False;
	}
	if ( m_bIsFiringWeapon == 1 )
	{
		return True;
	}
	if ( Controller.Enemy != None )
	{
		return True;
	}
	return False;
}

function GrenadeThrow ()
{
	local int iChannel;

	iChannel=GetNotifyChannel();
	if ( iChannel == 15 )
	{
		return;
	}
	if ( Role == Role_Authority )
	{
		EngineWeapon.ThrowGrenade();
	}
	EngineWeapon.bHidden=True;
}

function GrenadeAnimEnd ()
{
	EngineWeapon.bHidden=False;
//	m_eGrenadeThrow=0;
	PlayWeaponAnimation();
}

simulated function Tick (float DeltaTime)
{
	Super.Tick(DeltaTime);
	if ( m_bIsClimbingLadder &&  !bIsWalking && (Acceleration.Z < 0) )
	{
		if ( m_eLadderSlide == 3 )
		{
			StartSliding();
		}
	}
	else
	{
		if ( m_eLadderSlide != 3 )
		{
			EndSliding();
		}
	}
}

function R6RainbowTeam GetTeamMgr ()
{
	if ( Controller == None )
	{
		return None;
	}
	if ( m_bIsPlayer )
	{
		return R6PlayerController(Controller).m_TeamManager;
	}
	else
	{
		return R6RainbowAI(Controller).m_TeamManager;
	}
}

function R6Rainbow Escort_GetPawnToFollow (optional bool bRunningTowardMe)
{
	local R6RainbowTeam Team;

	Team=GetTeamMgr();
	if ( Team != None )
	{
		return Team.Escort_GetPawnToFollow(self,bRunningTowardMe);
	}
}

function bool Escort_AddHostage (R6Hostage hostage, optional bool bNoFeedbackByHostage, optional bool bOrderedByRainbow)
{
	local int i;
	local int totalR6;
	local int r6index;
	local int iSndIndex;

	if ( hostage.m_bCivilian )
	{
		return False;
	}
	i=0;
JL001B:
	if ( (i < 4) && (m_aEscortedHostage[i] != None) )
	{
		if ( m_aEscortedHostage[i] == hostage )
		{
			goto JL005C;
		}
		i++;
		goto JL001B;
	}
JL005C:
	if ( i >= 4 )
	{
		return False;
	}
	m_aEscortedHostage[i]=hostage;
	hostage.m_escortedByRainbow=self;
	Escort_UpdateTeamSpeed();
	Escort_UpdateList();
	if (  !bNoFeedbackByHostage && hostage.IsAlive() )
	{
		if ( m_bIsPlayer )
		{
			if ( bOrderedByRainbow )
			{
				if ( GetTeamMgr().m_PlayerVoicesMgr != None )
				{
//					GetTeamMgr().m_PlayerVoicesMgr.PlayRainbowPlayerVoices(self,38);
				}
			}
			else
			{
				if ( GetTeamMgr().m_PlayerVoicesMgr != None )
				{
//					GetTeamMgr().m_PlayerVoicesMgr.PlayRainbowPlayerVoices(self,40);
				}
			}
			if ( Controller != None )
			{
//				Controller.PlaySoundCurrentAction(4);
			}
		}
		else
		{
			if ( bOrderedByRainbow )
			{
				if ( GetTeamMgr().m_MemberVoicesMgr != None )
				{
//					GetTeamMgr().m_MemberVoicesMgr.PlayRainbowMemberVoices(self,20);
				}
			}
			else
			{
				if ( GetTeamMgr().m_MemberVoicesMgr != None )
				{
//					GetTeamMgr().m_MemberVoicesMgr.PlayRainbowMemberVoices(self,22);
				}
			}
		}
		if ( hostage.m_controller != None )
		{
//			hostage.m_controller.ProcessPlaySndInfo(hostage.m_mgr.8);
		}
	}
	return True;
}

function bool Escort_RemoveHostage (R6Hostage hostage, optional bool bNoFeedbackByHostage, optional bool bOrderedByRainbow)
{
	local int removeIndex;
	local int escortIndex;
	local int r6index;
	local int iSndIndex;
	local R6RainbowTeam teamMgr;

	if ( hostage.m_escortedByRainbow == None )
	{
		return False;
	}
	removeIndex=0;
JL001D:
	if ( (removeIndex < 4) && (m_aEscortedHostage[removeIndex] != None) )
	{
		if ( m_aEscortedHostage[removeIndex] == hostage )
		{
			goto JL005E;
		}
		++removeIndex;
		goto JL001D;
	}
JL005E:
	hostage.m_escortedByRainbow=None;
	if ( (removeIndex >= 4) || (m_aEscortedHostage[removeIndex] != hostage) )
	{
		return False;
	}
	escortIndex=removeIndex;
JL009E:
	if ( (escortIndex < 4) && (m_aEscortedHostage[escortIndex] != None) )
	{
		if ( escortIndex == 4 - 1 )
		{
			m_aEscortedHostage[escortIndex]=None;
		}
		else
		{
			m_aEscortedHostage[escortIndex]=m_aEscortedHostage[escortIndex + 1];
		}
		++escortIndex;
		goto JL009E;
	}
	Escort_UpdateTeamSpeed();
	Escort_UpdateList();
	if ( hostage.IsAlive() &&  !bNoFeedbackByHostage )
	{
		teamMgr=GetTeamMgr();
		if (  !hostage.m_bExtracted )
		{
			if ( bOrderedByRainbow )
			{
				if ( m_bIsPlayer )
				{
					if ( teamMgr.m_PlayerVoicesMgr != None )
					{
//						teamMgr.m_PlayerVoicesMgr.PlayRainbowPlayerVoices(self,39);
					}
				}
				else
				{
					if ( teamMgr.m_MemberVoicesMgr != None )
					{
//						teamMgr.m_MemberVoicesMgr.PlayRainbowMemberVoices(self,21);
					}
				}
			}
			if ( hostage.m_controller != None )
			{
//				hostage.m_controller.ProcessPlaySndInfo(hostage.m_mgr.9);
			}
		}
		else
		{
			if ( Controller != None )
			{
//				Controller.PlaySoundCurrentAction(5);
			}
		}
	}
	return True;
}

function Escort_UpdateCloserToLead ()
{
	local R6HostageAI closerAI;
	local R6HostageAI hostageAI;
	local int Index;
	local int searchIndex;
	local int nbEscortedHostage;
	local R6Hostage hostage;
	local R6Hostage aNewList[8];
	local float fShortestDistance;
	local float fDistance;
	local R6Hostage closerToLead;

	closerToLead=m_aEscortedHostage[0];
	if ( closerToLead != None )
	{
		closerAI=R6HostageAI(closerToLead.Controller);
		if ( closerAI.m_pawnToFollow != None )
		{
			if ( VSize(closerAI.m_pawnToFollow.Location - closerToLead.Location) <= closerAI.c_iDistanceMax )
			{
				return;
			}
			else
			{
				if ( closerAI.m_pawnToFollow.m_eMovementPace == 1 )
				{
					if ( VSize(closerAI.m_pawnToFollow.m_collisionBox.Location - closerToLead.Location) <= closerAI.c_iDistanceMax )
					{
						return;
					}
				}
			}
		}
	}
	if ( m_aEscortedHostage[0] == None )
	{
		return;
	}
	closerToLead=None;
	fShortestDistance=999999.00;
	Index=0;
JL011B:
	if ( (Index < 4) && (m_aEscortedHostage[Index] != None) )
	{
		fDistance=VSize(m_aEscortedHostage[Index].Location - Location);
		if ( fDistance < fShortestDistance )
		{
			fShortestDistance=fDistance;
			closerToLead=m_aEscortedHostage[Index];
		}
		R6HostageAI(m_aEscortedHostage[Index].Controller).m_pawnToFollow=None;
		Index++;
		goto JL011B;
	}
	nbEscortedHostage=Index;
	aNewList[0]=closerToLead;
	R6HostageAI(closerToLead.Controller).m_pawnToFollow=self;
	Index=0;
JL01F3:
	if ( Index < nbEscortedHostage - 1 )
	{
		hostage=None;
		fShortestDistance=999999.00;
		searchIndex=0;
JL021E:
		if ( searchIndex < nbEscortedHostage )
		{
			if ( m_aEscortedHostage[searchIndex] == aNewList[Index] )
			{
				goto JL02D9;
			}
			else
			{
				if ( R6HostageAI(m_aEscortedHostage[searchIndex].Controller).m_pawnToFollow != None )
				{
					goto JL02D9;
				}
				else
				{
					fDistance=VSize(m_aEscortedHostage[searchIndex].Location - aNewList[Index].Location);
					if ( fDistance < fShortestDistance )
					{
						fShortestDistance=fDistance;
						hostage=m_aEscortedHostage[searchIndex];
					}
				}
			}
JL02D9:
			searchIndex++;
			goto JL021E;
		}
		if ( hostage != None )
		{
			R6HostageAI(hostage.Controller).m_pawnToFollow=aNewList[Index];
			aNewList[Index + 1]=hostage;
		}
		Index++;
		goto JL01F3;
	}
	Index=0;
JL033B:
	if ( Index < nbEscortedHostage )
	{
		m_aEscortedHostage[Index]=aNewList[Index];
		Index++;
		goto JL033B;
	}
}

function Escort_UpdateList ()
{
	local int i;
	local int j;
	local R6HostageAI hostageAI;
	local R6Hostage hostage;
	local R6Rainbow newLeadRainbow;
	local R6RainbowTeam teamMgr;

	if ( m_aEscortedHostage[0] == None )
	{
		return;
	}
	if (  !IsAlive() )
	{
		newLeadRainbow=Escort_FindRainbow(m_aEscortedHostage[0]);
		if ( newLeadRainbow == None )
		{
			i=0;
JL003F:
			if ( (i < 4) && (m_aEscortedHostage[i] != None) )
			{
				hostageAI=R6HostageAI(m_aEscortedHostage[i].Controller);
				hostageAI.Order_StayHere(False);
				++i;
				goto JL003F;
			}
		}
		else
		{
			newLeadRainbow=newLeadRainbow.Escort_GetPawnToFollow();
			i=0;
JL00B6:
			if ( (i < 4) && (m_aEscortedHostage[i] != None) )
			{
				hostage=m_aEscortedHostage[i];
				newLeadRainbow.Escort_AddHostage(hostage,True);
				m_aEscortedHostage[i]=None;
				++i;
				goto JL00B6;
			}
		}
		return;
	}
	i=0;
JL011B:
	if ( (i < 4) && (m_aEscortedHostage[i] != None) )
	{
		if (  !m_aEscortedHostage[i].IsAlive() )
		{
			j=i;
JL015F:
			if ( j + 1 < 4 )
			{
				m_aEscortedHostage[j]=m_aEscortedHostage[j + 1];
				j++;
				goto JL015F;
			}
			m_aEscortedHostage[j]=None;
		}
		else
		{
			i++;
		}
		goto JL011B;
	}
	Escort_UpdateCloserToLead();
	i=0;
JL01B9:
	if ( (i < 4) && (m_aEscortedHostage[i] != None) )
	{
		hostageAI=R6HostageAI(m_aEscortedHostage[i].Controller);
		if ( i == 0 )
		{
			hostageAI.m_pawnToFollow=self;
		}
		else
		{
			hostageAI.m_pawnToFollow=m_aEscortedHostage[i - 1];
		}
		++i;
		goto JL01B9;
	}
}

function bool Escort_IsPawnCloseToMe (R6Hostage me, float fMyRadius)
{
	local int Index;
	local R6Hostage H;
	local R6Rainbow Rainbow;
	local bool bSeparated;
	local R6RainbowTeam Team;

	Index=0;
JL0007:
	if ( (Index < 4) && (m_aEscortedHostage[Index] != None) )
	{
		H=m_aEscortedHostage[Index];
		if ( (me != H) && (VSize(H.Location - me.Location) < fMyRadius) )
		{
			return True;
		}
		else
		{
			if ( H.m_eMovementPace == 1 )
			{
				if ( VSize(H.m_collisionBox.Location - me.Location) < fMyRadius )
				{
					return True;
				}
			}
		}
		Index++;
		goto JL0007;
	}
	Team=GetTeamMgr();
	if ( Team == None )
	{
		return True;
	}
	bSeparated=Team.m_bTeamIsSeparatedFromLeader;
	Index=0;
JL0105:
	if ( (Index < 4) && (Team.m_Team[Index] != None) )
	{
		Rainbow=Team.m_Team[Index];
		if ( bSeparated && (Rainbow != self) )
		{
			Index++;
		}
		else
		{
			if ( VSize(Rainbow.Location - me.Location) < fMyRadius )
			{
				return True;
			}
			else
			{
				if ( Rainbow.m_eMovementPace == 1 )
				{
					if ( VSize(Rainbow.m_collisionBox.Location - me.Location) < fMyRadius )
					{
						return True;
					}
				}
			}
			Index++;
		}
		goto JL0105;
	}
	return False;
}

function Escort_UpdateTeamSpeed ()
{
	local R6RainbowTeam Team;

	Team=GetTeamMgr();
	if ( Team != None )
	{
		Team.Escort_UpdateTeamSpeed();
	}
}

function R6Rainbow Escort_FindRainbow (R6Hostage hostage)
{
	local R6Pawn P;
	local R6Hostage H;

	foreach VisibleActors(Class'R6Pawn',P,hostage.SightRadius,hostage.Location)
	{
		if (  !hostage.IsFriend(P) && P.IsAlive() )
		{
			continue;
		}
		else
		{
			if ( P.m_ePawnType == 1 )
			{
				return R6Rainbow(P);
			}
			else
			{
				if ( P.m_ePawnType == 3 )
				{
					if ( (H.m_escortedByRainbow != None) && H.m_escortedByRainbow.IsAlive() )
					{
						return H.m_escortedByRainbow;
					}
				}
			}
		}
	}
	return None;
}

function bool ProcessBuildDeathMessage (Pawn Killer, out string szPlayerName)
{
	if ( Level.NetMode != 0 )
	{
		if ( Killer.m_ePawnType == 2 )
		{
			m_bSuicideType=8;
		}
		if ( (Killer.m_ePawnType == 1) &&  !m_bIsPlayer )
		{
			return False;
		}
	}
	return Super.ProcessBuildDeathMessage(Killer,szPlayerName);
}

function bool CanInteractWithObjects ()
{
	if ( m_bIsProne || m_bChangingWeapon || m_bReloadingWeapon || m_bIsFiringState || m_bIsSurrended || Level.m_bInGamePlanningActive )
	{
		return False;
	}
	return True;
}

defaultproperties
{
    m_eLadderSlide=3
    m_eEquipWeapon=3
    m_iCurrentWeapon=1
    m_bTweenFirstTimeOnly=True
    m_bScaleGasMaskForFemale=True
    m_bInitRainbow=True
    m_GasMaskClass=Class'R6GasMask'
    m_NightVisionClass=Class'R6NightVision'
    m_szSpecialityID="ID_ASSAULT"
    m_eArmorType=3
    m_bCanDisarmBomb=True
    m_bHasArmPatches=True
    m_fSkillAssault=0.85
    m_fSkillDemolitions=0.85
    m_fSkillElectronics=0.85
    m_fSkillSniper=0.85
    m_fSkillStealth=0.85
    m_fSkillSelfControl=0.85
    m_fSkillLeadership=0.85
    m_fSkillObservation=0.85
    m_fWalkingSpeed=250.00
    m_fWalkingBackwardStrafeSpeed=100.00
    m_fRunningSpeed=400.00
    m_fRunningBackwardStrafeSpeed=250.00
    m_fCrouchedWalkingSpeed=125.00
    m_fCrouchedWalkingBackwardStrafeSpeed=50.00
    m_fCrouchedRunningSpeed=250.00
    m_fCrouchedRunningBackwardStrafeSpeed=100.00
    m_fProneSpeed=65.00
    m_fProneStrafeSpeed=35.00
    m_fPeekingGoalModifier=0.35
    m_ePawnType=1
    m_iTeam=2
    bCanStrafe=True
    m_bMakesTrailsWhenProning=True
    PeripheralVision=0.17
    MeleeRange=30.00
    CrouchRadius=38.00
    ControllerClass=Class'R6RainbowAI'
    CollisionRadius=38.00
    CollisionHeight=80.00
    m_fAttachFactor=0.91
}
/*
    KParams=KarmaParamsSkel'R6RainbowRagDoll'
*/

