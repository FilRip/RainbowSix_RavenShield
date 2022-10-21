//================================================================================
// R6Terrorist.
//================================================================================
class R6Terrorist extends R6Pawn
	Native
	Abstract
	NotPlaceable;

enum eWeaponType {
	WT_Pistol,
	WT_Sub,
	WT_Assault,
	WT_ShotGun,
	WT_Sniper,
	WT_LMG,
	WT_Grenade,
	WT_Gadget
};

enum ENetworkSpecialAnim {
	NWA_NonValid,
	NWA_Playing,
	NWA_Looping
};

enum ETerroPersonality {
	PERSO_Coward,
	PERSO_DeskJockey,
	PERSO_Normal,
	PERSO_Hardened,
	PERSO_SuicideBomber,
	PERSO_Sniper
};

enum EDefCon {
	DEFCON_0,
	DEFCON_1,
	DEFCON_2,
	DEFCON_3,
	DEFCON_4,
	DEFCON_5
};

enum EStrategy {
	STRATEGY_PatrolPath,
	STRATEGY_PatrolArea,
	STRATEGY_GuardPoint,
	STRATEGY_Hunt,
	STRATEGY_Test
};

enum ETerroristCircumstantialAction {
	CAT_None,
	CAT_Secure
};

var() EDefCon m_eDefCon;
var() ETerroPersonality m_ePersonality;
var() EStrategy m_eStrategy;
var() EStance m_eStartingStance;
var EHeadAttachmentType m_eHeadAttachmentType;
var ETerroristType m_eTerroType;
var ENetworkSpecialAnim m_eSpecialAnimValid;
var() byte m_wWantedAimingPitch;
var() byte m_wWantedHeadYaw;
var() int m_iGroupID;
var() int m_iCurrentAimingPitch;
var() int m_iCurrentHeadYaw;
var() int m_iDiffLevel;
var bool m_bBoltActionRifle;
var() bool m_bHaveAGrenade;
var bool m_bInitFinished;
var() bool m_bAllowLeave;
var bool m_bPreventCrouching;
var(Debug) bool m_bHearNothing;
var() bool m_bSprayFire;
var bool m_bPreventWeaponAnimation;
var() bool m_bIsUnderArrest;
var bool m_bPatrolForward;
var bool m_bEnteringView;
var float m_fPlayerCAStartTime;
var R6THeadAttachment m_HeadAttachment;
var Actor m_Radio;
var R6TerroristAI m_controller;
var R6DeploymentZone m_DZone;
var name m_szSpecialAnimName;
var() Rotator m_rFiringRotation;
var() string m_szUsedTemplate;
var() string m_szPrimaryWeapon;
var() string m_szGrenadeWeapon;
var() string m_szGadget;

replication
{
	reliable if ( Role == Role_Authority )
		m_eDefCon,m_eSpecialAnimValid,m_bSprayFire,m_bPreventWeaponAnimation,m_bIsUnderArrest,m_szSpecialAnimName;
	reliable if ( Role == Role_Authority )
		m_wWantedAimingPitch,m_wWantedHeadYaw;
}

simulated event Destroyed ()
{
	Super.Destroyed();
	if ( m_HeadAttachment != None )
	{
		m_HeadAttachment.Destroy();
		m_HeadAttachment=None;
	}
}

function Rotator GetFiringRotation ()
{
	return m_rFiringRotation;
}

simulated function PostBeginPlay ()
{
	local Vector vTagLocation;
	local Rotator rTagRotator;

	if ( Level.Game != None )
	{
//		assert (Default.m_iTeam == R6AbstractGameInfo(Level.Game).1);
	}
	Super.PostBeginPlay();
	SetMovementPhysics();
}

function SetToNormalWeapon ()
{
	EngineWeapon=GetWeaponInGroup(1);
	if ( EngineWeapon == None )
	{
		EngineWeapon=GetWeaponInGroup(2);
	}
	EngineWeapon.RemoteRole=ROLE_SimulatedProxy;
	if ( EngineWeapon != None )
	{
		AttachWeapon(EngineWeapon,'TagRightHand');
		EngineWeapon.WeaponInitialization(self);
		m_pBulletManager.SetBulletParameter(EngineWeapon);
	}
}

function SetToGrenade ()
{
	if (  !EngineWeapon.m_bUseMicroAnim && (EngineWeapon.m_eWeaponType != 0) )
	{
		AttachWeapon(EngineWeapon,'TagLeftHand');
	}
	EngineWeapon=GetWeaponInGroup(3);
	EngineWeapon.bHidden=False;
	AttachWeapon(EngineWeapon,'TagRightHand');
}

event FinishInitialization ()
{
	CommonInit();
}

function CommonInit ()
{
	local float fFactor;
	local R6EngineWeapon aGrenade;

	if ( Controller != None )
	{
		UnPossessed();
	}
	Controller=Spawn(ControllerClass);
	Controller.Possess(self);
	if ( m_szPrimaryWeapon != "" )
	{
		ServerGivesWeaponToClient(m_szPrimaryWeapon,1);
		SetToNormalWeapon();
	}
	if ( m_szGrenadeWeapon != "" )
	{
		ServerGivesWeaponToClient(m_szGrenadeWeapon,3);
		m_bHaveAGrenade=True;
		aGrenade=GetWeaponInGroup(3);
		aGrenade.RemoteRole=ROLE_SimulatedProxy;
		aGrenade.bHidden=True;
	}
	Controller.m_PawnRepInfo.m_PawnType=m_ePawnType;
	Controller.m_PawnRepInfo.m_bSex=bIsFemale;
	if ( m_SoundRepInfo != None )
	{
		m_SoundRepInfo.m_PawnRepInfo=Controller.m_PawnRepInfo;
	}
	if ( EngineWeapon != None )
	{
		if ( (EngineWeapon.m_eWeaponType == 4) && EngineWeapon.IsA('R6BoltActionSniperRifle') )
		{
			m_bBoltActionRifle=True;
		}
		EngineWeapon.m_bUnlimitedClip=True;
		EngineWeapon.SetTerroristNbOfClips(1);
	}
	if ( (m_szGadget != "") && (Level.NetMode != 1) )
	{
		R6AbstractWeapon(EngineWeapon).R6SetGadget(Class<R6AbstractGadget>(DynamicLoadObject(m_szGadget,Class'Class')));
		R6AbstractWeapon(EngineWeapon).m_SelectedWeaponGadget.ActivateGadget(True,True);
	}
	if ( m_eHeadAttachmentType != 3 )
	{
		m_HeadAttachment=Spawn(Class'R6THeadAttachment');
/*		if ( m_HeadAttachment.SetAttachmentStaticMesh(m_eHeadAttachmentType,m_eTerroType) )
		{
			m_HeadAttachment.SetOwner(self);
			AttachToBone(m_HeadAttachment,'R6 Head');
			m_bHaveGasMask=m_eHeadAttachmentType == 2;
		}
		else
		{
			m_HeadAttachment.Destroy();
			m_HeadAttachment=None;
		}*/
	}
	AttachCollisionBox(2);
	if ( R6AbstractGameInfo(Level.Game) != None )
	{
		m_iDiffLevel=R6AbstractGameInfo(Level.Game).m_iDiffLevel;
		if ( m_iDiffLevel == 0 )
		{
			m_iDiffLevel=2;
		}
		switch (m_iDiffLevel)
		{
/*			case 1:
			fFactor=0.40;
			break;
			case 2:
			fFactor=0.70;
			break;
			case 3:
			fFactor=1.25;
			break;
			default: */
		}
		m_fSkillAssault *= fFactor;
		m_fSkillDemolitions *= fFactor;
		m_fSkillElectronics *= fFactor;
		m_fSkillSniper *= fFactor;
		m_fSkillStealth *= fFactor;
		m_fSkillSelfControl *= fFactor;
		m_fSkillLeadership *= fFactor;
		m_fSkillObservation *= fFactor;
	}
}

simulated function SetMovementPhysics ()
{
	SetPhysics(PHYS_Walking);
}

simulated function AnimateStandTurning ()
{
	if ( m_bDroppedWeapon || (EngineWeapon == None) || (m_eDefCon > 3) )
	{
		TurnLeftAnim='RelaxTurnLeft';
		TurnRightAnim='RelaxTurnRight';
	}
	else
	{
		TurnLeftAnim=m_standTurnLeftName;
		TurnRightAnim=m_standTurnRightName;
	}
}

simulated function AnimateWalking ()
{
	if ( m_bDroppedWeapon || (EngineWeapon == None) || (m_eDefCon > 3) )
	{
		m_fWalkingSpeed=116.00;
		MovementAnims[0]='RelaxWalkForward';
		MovementAnims[1]=m_standWalkLeftName;
		MovementAnims[2]='RelaxWalkForward';
		MovementAnims[3]=m_standWalkRightName;
	}
	else
	{
		if ( m_eHealth == 1 )
		{
			m_fWalkingSpeed=120.00;
			MovementAnims[0]='HurtStandWalkForward';
			MovementAnims[1]=m_standWalkLeftName;
			MovementAnims[2]='HurtStandWalkBack';
			MovementAnims[3]=m_standWalkRightName;
		}
		else
		{
			m_fWalkingSpeed=170.00;
			MovementAnims[0]=m_standWalkForwardName;
			MovementAnims[1]=m_standWalkLeftName;
			MovementAnims[2]=m_standWalkBackName;
			MovementAnims[3]=m_standWalkRightName;
		}
	}
}

simulated function AnimateRunning ()
{
	local name nFoward;

	nFoward='StandRunSubGunForward';
	if (  !m_bDroppedWeapon && (EngineWeapon != None) )
	{
		switch (EngineWeapon.m_eWeaponType)
		{
/*			case 1:
			if ( EngineWeapon.m_bUseMicroAnim )
			{
				nFoward='StandRunHandGun';
			}
			break;
			case 0:
			nFoward='StandRunHandGun';
			break;
			default:
			break;*/
		}
	}
	else
	{
		nFoward='StandRunHandGun';
	}
	MovementAnims[0]=nFoward;
	MovementAnims[1]='StandRunLeft';
	MovementAnims[2]='StandWalkBack';
	MovementAnims[3]='StandRunRight';
}

simulated function AnimateWalkingUpStairs ()
{
	Super.AnimateWalkingUpStairs();
	if ( m_bDroppedWeapon || (EngineWeapon == None) || (m_eDefCon > 3) )
	{
		MovementAnims[0]='RelaxStairUp';
	}
}

simulated function AnimateWalkingDownStairs ()
{
	Super.AnimateWalkingDownStairs();
	if ( m_bDroppedWeapon || (EngineWeapon == None) || (m_eDefCon > 3) )
	{
		MovementAnims[0]='RelaxStairDown';
	}
}

simulated function PlayWaiting ()
{
	local name Anim;
	local EDefCon EDefCon;

	if ( m_bDroppedWeapon || (EngineWeapon == None) )
	{
//		EDefCon=5;
	}
	else
	{
		EDefCon=m_eDefCon;
	}
	if ( Physics == 2 )
	{
		PlayFalling();
		return;
	}
	if ( m_bIsUnderArrest )
	{
		PlayArrestWaiting();
		return;
	}
	if ( m_bIsKneeling )
	{
		PlayKneelWaiting();
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
	if ( m_bIsClimbingLadder )
	{
		AnimateStoppedOnLadder();
		return;
	}
	switch (EDefCon)
	{
/*		case 1:
		case 2:
		case 3:
		SetRandomWaiting(6,True);
		switch (m_bRepPlayWaitAnim)
		{
			case 0:
			Anim='StandWaitLookFarSubGun01';
			break;
			case 1:
			Anim='StandWaitLookFarSubGun02';
			break;
			case 2:
			Anim='StandWaitResightSubGun';
			break;
			case 3:
			Anim='StandWaitStiffLegsSubGun';
			break;
			case 4:
			Anim='StandWaitStiffNeckSubGun';
			break;
			default:
			Anim='StandWaitWipeNoseSubGun';
		}
		break;
		case 4:
		case 5:
		SetRandomWaiting(14);
		switch (m_bRepPlayWaitAnim)
		{
			case 0:
			Anim='RelaxWaitBreathe';
			break;
			case 1:
			Anim='RelaxWaitBend';
			break;
			case 2:
			Anim='RelaxWaitCrackNeck';
			break;
			case 3:
			Anim='RelaxWaitLookAround01';
			break;
			case 4:
			Anim='RelaxWaitLookAround02';
			break;
			case 5:
			Anim='RelaxWaitLookFar';
			break;
			case 6:
			Anim='RelaxWaitPickShoe';
			break;
			case 7:
			Anim='RelaxWaitScratchNose';
			break;
			case 8:
			Anim='RelaxWaitShiftWeight01';
			break;
			case 9:
			Anim='RelaxWaitShiftWeight02';
			break;
			case 10:
			Anim='RelaxWaitShiftWeight03';
			break;
			case 11:
			Anim='RelaxWaitShuffle';
			break;
			case 12:
			Anim='RelaxWaitSlapFly';
			break;
			default:
			Anim='RelaxWaitStretch';
			break;
		}
		break;
		default: */
	}
	R6LoopAnim(Anim,1.00);
}

simulated function PlayCrouchWaiting ()
{
	local name Anim;

	SetRandomWaiting(6);
	switch (m_bRepPlayWaitAnim)
	{
/*		case 0:
		Anim='CrouchWaitBreatheSubGun01';
		break;
		case 1:
		Anim='CrouchWaitBreatheSubGun02';
		break;
		case 2:
		Anim='CrouchWaitLookAroundSubGun';
		break;
		case 3:
		Anim='CrouchWaitLookAtSubGun';
		break;
		case 4:
		Anim='CrouchWaitRepositionSubGun';
		break;
		default:
		Anim='CrouchWaitStiffNeckSubGun';*/
	}
	R6LoopAnim(Anim,1.00);
}

simulated function PlayProneWaiting ()
{
	R6LoopAnim('ProneWaitBreathe',1.00);
}

simulated function PlayKneelWaiting ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	R6LoopAnim('Kneel_nt',0.01);
}

simulated function PlayArrestWaiting ()
{
	local name Anim;

	m_ePlayerIsUsingHands=HANDS_Both;
	SetRandomWaiting(4);
	switch (m_bRepPlayWaitAnim)
	{
/*		case 0:
		Anim='KneelArrestWait01';
		break;
		default:
		Anim='KneelArrestWait02';*/
	}
	R6LoopAnim(Anim,1.00);
}

simulated function PlayDuck ()
{
	local name Anim;

	if ( EngineWeapon.m_bUseMicroAnim )
	{
		Anim='CrouchMicroHigh_nt';
	}
	else
	{
		if ( EngineWeapon.m_eWeaponType == 0 )
		{
			Anim='CrouchHandGunHigh_nt';
		}
		else
		{
			Anim='CrouchSubGunHigh_nt';
		}
	}
	R6LoopAnim(Anim);
}

function ResetArrest ()
{
	if ( IsAlive() )
	{
		AnimBlendToAlpha(16,0.00,0.50);
		m_ePlayerIsUsingHands=HANDS_None;
		PlayWeaponAnimation();
		m_bPawnSpecificAnimInProgress=False;
		m_bIsUnderArrest=False;
		PlayWaiting();
		SetCollision(True,True,True);
	}
}

event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	if ( m_bIsKneeling && IsAlive() )
	{
		Query.iHasAction=1;
		if ( fDistance < m_fCircumstantialActionRange )
		{
			Query.iInRange=1;
		}
		else
		{
			Query.iInRange=0;
		}
//		Query.textureIcon=Texture'HandcuffTerrorist';
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
		Query.iHasAction=0;
	}
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
/*		case 1:
		return Localize("RDVOrder","Order_Secure","R6Menu");
		default:*/
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
	m_fPlayerCAStartTime=Level.TimeSeconds;
}

function ReleaseGrenade ()
{
	if (  !IsAlive() )
	{
		return;
	}
	m_rFiringRotation=m_controller.GetGrenadeDirection(m_controller.Enemy);
	EngineWeapon.ThrowGrenade();
	EngineWeapon.bHidden=True;
	m_bHaveAGrenade=False;
}

function EndGrenade ()
{
}

simulated event AnimEnd (int iChannel)
{
	if ( (iChannel == 16) && (m_eSpecialAnimValid != 2) )
	{
		AnimBlendToAlpha(16,0.00,0.50);
		m_ePlayerIsUsingHands=HANDS_None;
		PlayWeaponAnimation();
		m_bPawnSpecificAnimInProgress=False;
		if ( Level.NetMode != 3 )
		{
//			m_eSpecialAnimValid=0;
		}
	}
	Super.AnimEnd(iChannel);
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGoup)
{
	local int iResult;

	iResult=Super.R6TakeDamage(iKillValue,iStunValue,instigatedBy,vHitLocation,vMomentum,iBulletToArmorModifier,iBulletGoup);
	ChangeAnimation();
	return iResult;
}

function bool IsFighting ()
{
	if ( m_bIsKneeling )
	{
		return False;
	}
	if ( m_bIsFiringWeapon == 1 )
	{
		return True;
	}
	if ( IsAlive() && Controller.IsInState('Attack') )
	{
		return True;
	}
	return False;
}

function R6TerroristMgr GetManager ()
{
	return R6TerroristMgr(Level.GetTerroristMgr());
}

simulated function AnimateCrouchRunning ()
{
}

simulated function AnimateCrouchRunningUpStairs ()
{
}

simulated function AnimateCrouchRunningDownStairs ()
{
}

event EndOfGrenadeEffect (EGrenadeType eType)
{
	if ( eType == 2 )
	{
//		SetNextPendingAction(PENDING_StopCoughing);
	}
}

function StartHunting ()
{
	if (  !m_DZone.m_bHuntDisallowed )
	{
//		m_eStrategy=3;
		m_controller.GotoStateNoThreat();
	}
}

simulated function PlayMoving ()
{
	m_ePlayerIsUsingHands=HANDS_None;
	Super.PlayMoving();
}

simulated event ReceivedWeapons ()
{
	EngineWeapon=GetWeaponInGroup(1);
	if ( EngineWeapon == None )
	{
		EngineWeapon=GetWeaponInGroup(2);
	}
	if ( EngineWeapon != None )
	{
		R6AbstractWeapon(EngineWeapon).CreateWeaponEmitters();
	}
	PlayWeaponAnimation();
}

simulated function bool GetNormalWeaponAnimation (out STWeaponAnim stAnim)
{
	stAnim.bBackward=False;
	stAnim.bPlayOnce=False;
	stAnim.fTweenTime=0.30;
	stAnim.fRate=1.00;
	stAnim.nBlendName='R6 Spine';
	if ( m_bPreventWeaponAnimation || m_bPawnSpecificAnimInProgress || m_bIsKneeling || m_bIsClimbingLadder )
	{
		return False;
	}
	m_ePlayerIsUsingHands=HANDS_None;
	if ( m_bIsProne )
	{
		stAnim.nAnimToPlay='Prone_nt';
	}
	else
	{
		if ( m_bDroppedWeapon || (EngineWeapon == None) )
		{
			stAnim.nBlendName='R6 R Clavicle';
			stAnim.nAnimToPlay='Relax_nt';
		}
		else
		{
			if ( bIsCrouched )
			{
				if ( m_bUseHighStance && (m_eDefCon <= 3) )
				{
					if ( EngineWeapon.m_bUseMicroAnim )
					{
						stAnim.nAnimToPlay='CrouchMicroHigh_nt';
					}
					else
					{
						if ( EngineWeapon.m_eWeaponType == 0 )
						{
							stAnim.nAnimToPlay='CrouchHandGunHigh_nt';
						}
						else
						{
							stAnim.nAnimToPlay='CrouchSubGunHigh_nt';
						}
					}
				}
				else
				{
					if ( EngineWeapon.m_bUseMicroAnim )
					{
						stAnim.nAnimToPlay='CrouchMicroLow_nt';
					}
					else
					{
						if ( EngineWeapon.m_eWeaponType == 0 )
						{
							stAnim.nAnimToPlay='CrouchHandGunLow_nt';
						}
						else
						{
							stAnim.nAnimToPlay='CrouchSubGunLow_nt';
						}
					}
				}
			}
			else
			{
				if ( m_bUseHighStance )
				{
					if ( m_bSprayFire )
					{
						if ( EngineWeapon.m_bUseMicroAnim )
						{
							stAnim.nAnimToPlay='StandMicroMid_nt';
						}
						else
						{
							if ( EngineWeapon.m_eWeaponType == 0 )
							{
								stAnim.nAnimToPlay='StandHandGunHigh_nt';
							}
							else
							{
								stAnim.nAnimToPlay='StandSubGunMid_nt';
							}
						}
					}
					else
					{
						if ( EngineWeapon.m_bUseMicroAnim )
						{
							stAnim.nAnimToPlay='StandMicroHigh_nt';
						}
						else
						{
							if ( EngineWeapon.m_eWeaponType == 0 )
							{
								stAnim.nAnimToPlay='StandHandGunHigh_nt';
							}
							else
							{
								stAnim.nAnimToPlay='StandSubGunHigh_nt';
							}
						}
					}
				}
				else
				{
					if ( m_eDefCon <= 3 )
					{
						if ( EngineWeapon.m_bUseMicroAnim )
						{
							stAnim.nAnimToPlay='StandMicroLow_nt';
						}
						else
						{
							if ( EngineWeapon.m_eWeaponType == 0 )
							{
								stAnim.nAnimToPlay='StandHandGunLow_nt';
							}
							else
							{
								stAnim.nAnimToPlay='StandSubGunLow_nt';
							}
						}
					}
					else
					{
						if ( m_eDefCon <= 4 )
						{
							stAnim.nBlendName='R6 R Clavicle';
							if ( EngineWeapon.m_bUseMicroAnim )
							{
								stAnim.nAnimToPlay='RelaxMicro_nt';
							}
							else
							{
								if ( EngineWeapon.m_eWeaponType == 0 )
								{
									stAnim.nAnimToPlay='RelaxHandGun_nt';
								}
								else
								{
									stAnim.nAnimToPlay='RelaxSubGun_nt';
								}
							}
						}
						else
						{
							if ( EngineWeapon.m_bUseMicroAnim || (EngineWeapon.m_eWeaponType == 0) )
							{
								m_ePlayerIsUsingHands=HANDS_Both;
							}
							else
							{
								stAnim.nAnimToPlay='RelaxSubGunShoulder_nt';
								stAnim.nBlendName='R6 R Clavicle';
								m_ePlayerIsUsingHands=HANDS_Left;
							}
						}
					}
				}
			}
		}
	}
	return True;
}

simulated function bool GetFireWeaponAnimation (out STWeaponAnim stAnim)
{
	local eWeaponType eWT;

	stAnim.bBackward=False;
	stAnim.bPlayOnce=EngineWeapon.GetRateOfFire() == 0;
	stAnim.fRate=1.00;
	stAnim.fTweenTime=0.05;
	stAnim.nBlendName='R6 Spine';
	if ( m_bIsProne )
	{
		if ( m_bBoltActionRifle )
		{
			stAnim.nAnimToPlay='ProneFireAndBoltRifle';
		}
		else
		{
			stAnim.nAnimToPlay='ProneFire';
		}
	}
	else
	{
		if ( EngineWeapon.m_bUseMicroAnim && m_bSprayFire &&  !bIsCrouched )
		{
			stAnim.nAnimToPlay='StandSprayFireMicro';
		}
		else
		{
//			eWT=EngineWeapon.m_eWeaponType;
			if ( EngineWeapon.m_bUseMicroAnim )
			{
				stAnim.fTweenTime=0.10;
				stAnim.fRate=3.00;
//				eWT=0;
			}
			if ( (eWT == 4) &&  !m_bBoltActionRifle )
			{
//				eWT=1;
			}
			switch (eWT)
			{
/*				case 3:
				if ( bIsCrouched )
				{
					stAnim.nAnimToPlay='CrouchFireShotgun';
				}
				else
				{
					if ( m_bSprayFire )
					{
						stAnim.nAnimToPlay='StandSprayFireShotgun';
					}
					else
					{
						stAnim.nAnimToPlay='StandFireShotGun';
					}
				}
				break;
				case 0:
				if ( bIsCrouched )
				{
					stAnim.nAnimToPlay='CrouchFireHandGun';
				}
				else
				{
					stAnim.nAnimToPlay='StandFireHandGun';
				}
				break;
				case 5:
				if ( bIsCrouched )
				{
					stAnim.nAnimToPlay='CrouchFireLmg';
				}
				else
				{
					stAnim.nAnimToPlay='StandFireLmg';
				}
				break;
				case 4:
				if ( bIsCrouched )
				{
					stAnim.nAnimToPlay='CrouchFireAndBoltRifle';
				}
				else
				{
					stAnim.nAnimToPlay='StandFireAndBoltRifle';
				}
				break;
				default: */
			}
			if ( bIsCrouched )
			{
				stAnim.nAnimToPlay='CrouchFireSubGun';
			}
			else
			{
				if ( m_bSprayFire )
				{
					stAnim.nAnimToPlay='StandSprayFireSubGun';
				}
				else
				{
					stAnim.nAnimToPlay='StandFireSubGun';
				}
			}
			goto JL0289;
		}
	}
JL0289:
	return True;
}

simulated function bool GetReloadWeaponAnimation (out STWeaponAnim stAnim)
{
	local eWeaponType eWT;

	m_bWeaponTransition=True;
	m_ePlayerIsUsingHands=HANDS_None;
	stAnim.bBackward=False;
	stAnim.bPlayOnce=True;
	stAnim.fRate=1.00;
	stAnim.fTweenTime=0.10;
	stAnim.nBlendName='R6 Spine2';
	if ( m_bIsProne )
	{
		stAnim.nAnimToPlay='ProneReloadSubGun';
	}
	else
	{
//		eWT=EngineWeapon.m_eWeaponType;
		if ( EngineWeapon.m_bUseMicroAnim )
		{
//			eWT=0;
		}
		if ( (eWT == 3) &&  !EngineWeapon.IsA('R6PumpShotgun') )
		{
//			eWT=1;
		}
		switch (eWT)
		{
/*			case 0:
			if ( bIsCrouched )
			{
				stAnim.nAnimToPlay='CrouchReloadHandGun';
			}
			else
			{
				stAnim.nAnimToPlay='StandReloadHandGun';
			}
			break;
			case 3:
			if ( bIsCrouched )
			{
				stAnim.nAnimToPlay='CrouchReloadShotGun';
			}
			else
			{
				stAnim.nAnimToPlay='StandReloadShotGun';
			}
			break;
			default: */
		}
		if ( bIsCrouched )
		{
			stAnim.nAnimToPlay='CrouchReloadSubGun';
		}
		else
		{
			stAnim.nAnimToPlay='StandReloadSubGun';
		}
		goto JL0175;
	}
JL0175:
	return True;
}

event Vector EyePosition ()
{
	local Vector vEyeHeight;

	if ( bIsCrouched )
	{
		vEyeHeight.Z=40.00;
	}
	else
	{
		if ( m_bIsProne )
		{
			vEyeHeight.Z=0.00;
		}
		else
		{
			if ( m_bIsKneeling )
			{
				vEyeHeight.Z=20.00;
			}
			else
			{
				vEyeHeight.Z=70.00;
			}
		}
	}
	return vEyeHeight;
}

event StartCrouch (float HeightAdjust)
{
	SetWalking(True);
	Super.StartCrouch(HeightAdjust);
}

event EndCrouch (float fHeight)
{
	if ( m_eMovementPace == 5 )
	{
		SetWalking(False);
	}
	Super.EndCrouch(fHeight);
}

simulated event PlaySpecialPendingAction (EPendingAction eAction)
{
	switch (eAction)
	{
/*		case 2:
		StopCoughing();
		break;
		case 30:
		PlayThrowGrenade();
		break;
		case 31:
		PlaySurrender();
		break;
		case 32:
		PlayKneeling();
		break;
		case 33:
		PlayArrest();
		break;
		case 34:
		PlayCallBackup();
		break;
		case 35:
		PlaySpecialAnim();
		break;
		case 36:
		LoopSpecialAnim();
		break;
		case 37:
		StopSpecialAnim();
		break;
		default:
		Super.PlaySpecialPendingAction(eAction);  */
	}
}

simulated function PlayCoughing ()
{
	if ( m_bIsClimbingLadder )
	{
		return;
	}
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	AnimBlendParams(16,1.00,,,'R6 Spine2');
	PlayAnim('StandGazed_c',1.00,0.50,16);
	m_bPawnSpecificAnimInProgress=True;
	AnimBlendParams(16 + 1,1.00,,,'R6 Spine2');
	LoopAnim('StandGazedWalkForward',1.00,0.50,16 + 1);
}

simulated function StopCoughing ()
{
	AnimBlendToAlpha(16 + 1,0.00,0.50);
}

simulated function PlayBlinded ()
{
	if ( m_bIsClimbingLadder )
	{
		return;
	}
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	AnimBlendParams(16,1.00,,,'R6 Spine2');
	if ( bIsCrouched || m_bIsProne )
	{
		PlayAnim('CrouchBlinded',1.00,0.50,16);
	}
	else
	{
		PlayAnim('StandBlinded',1.00,0.50,16);
	}
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlaySurrender ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	ClearChannel(16);
	if ( m_bDroppedWeapon || (EngineWeapon == None) || (m_eDefCon > 3) )
	{
		PlayAnim('RelaxToSurrender',1.00,0.20,16);
	}
	else
	{
		PlayAnim('StandToSurrender',1.00,0.20,16);
	}
	AnimBlendToAlpha(16,1.00,0.10);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlayKneeling ()
{
	m_bIsKneeling=True;
	ClearChannel(16);
	PlayAnim('SurrenderToKneel',1.00,0.00,16);
	AnimBlendToAlpha(16,1.00,0.10);
	m_bPawnSpecificAnimInProgress=True;
	PlayWaiting();
	PlayMoving();
}

simulated function PlayArrest ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	AnimBlendParams(16,1.00);
	PlayAnim('KneelArrest',1.00,0.00,16);
	m_bPawnSpecificAnimInProgress=True;
	PlayWaiting();
}

simulated function PlayCallBackup ()
{
	local name nAnimName;
	local bool bOldEngaged;

	switch (m_iPendingActionInt[m_iLocalCurrentActionIndex])
	{
/*		case 0:
		nAnimName='StandYellAlarm';
		break;
		case 1:
		nAnimName='StandYellAlarm';
		break;
		default:*/
	}
	if ( m_iPendingActionInt[m_iLocalCurrentActionIndex] == 0 )
	{
		bOldEngaged=m_bEngaged;
		m_bEngaged=True;
		PlayWaiting();
		m_bEngaged=bOldEngaged;
		m_ePlayerIsUsingHands=HANDS_None;
		PlayWeaponAnimation();
		AnimBlendParams(16,1.00,,,'R6 Head');
		PlayAnim(nAnimName,1.00,0.50,16);
		m_bPawnSpecificAnimInProgress=True;
	}
	else
	{
		m_ePlayerIsUsingHands=HANDS_Both;
		PlayWeaponAnimation();
		AnimBlendParams(16,1.00);
		PlayAnim(nAnimName,1.00,0.50,16);
		m_bPawnSpecificAnimInProgress=True;
	}
}

simulated function PlayThrowGrenade ()
{
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	AnimBlendParams(16,1.00);
	PlayAnim('StandThrowGrenade',1.00,0.50,16);
	m_bPawnSpecificAnimInProgress=True;
}

simulated function PlayDoorAnim (R6IORotatingDoor Door)
{
	local bool bOpensTowardsPawn;
	local float fRate;

	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	ClearChannel(16);
	AnimBlendParams(16,1.00,,,'R6 Spine2');
	bOpensTowardsPawn=Door.DoorOpenTowardsActor(self);
	if ( m_iPendingActionInt[m_iLocalCurrentActionIndex] == 0 )
	{
		if ( bOpensTowardsPawn )
		{
			PlayAnim('StandDoorPull',1.00,0.10,16);
		}
		else
		{
			PlayAnim('StandDoorPush',1.00,0.10,16);
		}
	}
	else
	{
		PlayAnim('StandDoorUnlock',1.00,0.10,16);
	}
	m_bPawnSpecificAnimInProgress=True;
}

simulated event PlaySpecialAnim ()
{
	if ( Level.NetMode != 3 )
	{
//		m_eSpecialAnimValid=1;
	}
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	AnimBlendParams(16,1.00);
	PlayAnim(m_szSpecialAnimName,1.00,0.50,16);
	m_bPawnSpecificAnimInProgress=True;
}

simulated event LoopSpecialAnim ()
{
	if ( Level.NetMode != 3 )
	{
//		m_eSpecialAnimValid=2;
	}
	m_ePlayerIsUsingHands=HANDS_Both;
	PlayWeaponAnimation();
	AnimBlendParams(16,1.00);
	LoopAnim(m_szSpecialAnimName,1.00,0.50,16);
	m_bPawnSpecificAnimInProgress=True;
}

simulated event StopSpecialAnim ()
{
	if ( Level.NetMode != 3 )
	{
//		m_eSpecialAnimValid=0;
	}
	m_ePlayerIsUsingHands=HANDS_None;
	PlayWeaponAnimation();
	AnimBlendToAlpha(16,0.00,0.50);
	m_bPawnSpecificAnimInProgress=False;
}

function AffectedByGrenade (Actor aGrenade, EGrenadeType eType)
{
	Super.AffectedByGrenade(aGrenade,eType);
	if ( (eType == 2) && m_bHaveGasMask )
	{
//		m_controller.m_VoicesManager.PlayTerroristVoices(self,3);
	}
}

defaultproperties
{
    m_eDefCon=2
    m_ePersonality=2
    m_eStrategy=2
    m_iDiffLevel=2
    m_bPatrolForward=True
    m_szPrimaryWeapon="R63rdWeapons.NormalSubHKMP5A4"
    m_bCanClimbObject=True
    m_bAutoClimbLadders=True
    m_bAvoidFacingWalls=False
    m_bCanArmBomb=True
    m_bCanFireNeutrals=True
    m_fWalkingSpeed=120.00
    m_fWalkingBackwardStrafeSpeed=518.00
    m_fRunningSpeed=518.00
    m_fCrouchedWalkingSpeed=87.00
    m_fCrouchedWalkingBackwardStrafeSpeed=87.00
    m_fCrouchedRunningSpeed=518.00
    m_fCrouchedRunningBackwardStrafeSpeed=518.00
    m_standStairWalkUpName=StandStairWalkUp
    m_standStairWalkUpBackName=StandWalkBack
    m_standStairWalkUpRightName=StandWalkRight
    m_standStairWalkDownName=StandStairWalkDown
    m_standStairWalkDownBackName=StandWalkBack
    m_standStairWalkDownRightName=StandWalkRight
    m_standStairRunUpName=StandStairRunUp
    m_standStairRunUpBackName=StandStairRunUp
    m_standStairRunUpRightName=StandRunRight
    m_standStairRunDownName=StandStairRunDown
    m_standStairRunDownBackName=StandStairRunDown
    m_standStairRunDownRightName=StandRunRight
    m_crouchStairWalkDownName=CrouchWalkForward
    m_crouchStairWalkDownBackName=CrouchWalkBack
    m_crouchStairWalkDownRightName=CrouchWalkRight
    m_crouchStairWalkUpName=CrouchWalkForward
    m_crouchStairWalkUpBackName=CrouchWalkBack
    m_crouchStairWalkUpRightName=CrouchWalkRight
    m_standDefaultAnimName=Relax_nt
    m_ePawnType=2
    m_iTeam=1
    m_bCanProne=False
    CrouchRadius=40.00
    m_fHeartBeatFrequency=65.00
    ControllerClass=Class'R6TerroristAI'
    m_wTickFrequency=2
    m_bReticuleInfo=False
    m_bSkipTick=True
    CollisionRadius=40.00
    CollisionHeight=85.00
    NetUpdateFrequency=10.00
    KParams=KarmaParamsSkel'KarmaParamsSkel22'
}
