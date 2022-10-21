//================================================================================
// R6Hostage.
//================================================================================
class R6Hostage extends R6Pawn
	Native
	Abstract
	NotPlaceable;

enum EGroupAnimType {
	eGroupAnim_none,
	eGroupAnim_transition,
	eGroupAnim_wait,
	eGroupAnim_reaction
};

enum EPlayAnimType {
	ePlayType_Default,
	ePlayType_Random
};

struct AnimInfo
{
	var name m_name;
	var int m_id;
	var float m_fRate;
	var EPlayAnimType m_ePlayType;
	var EGroupAnimType m_eGroupAnim;
};

enum EStandWalkingAnim {
	eStandWalkingAnim_default,
	eStandWalkingAnim_scared
};

enum ECivPatrolType {
	CIVPATROL_None,
	CIVPATROL_Path,
	CIVPATROL_Area,
	CIVPATROL_Point
};

enum EStartingPosition {
	POS_Stand,
	POS_Kneel,
	POS_Prone,
	POS_Foetus,
	POS_Crouch,
	POS_Random
};

enum EHandsUpType {
	HANDSUP_none,
	HANDSUP_kneeling,
	HANDSUP_standing
};

struct STRepHostageAnim
{
	var EStandWalkingAnim m_eRepStandWalkingAnim;
	var bool m_bRepPlayMoving;
};

var(Personality) EHostagePersonality m_ePersonality;
var(StartingPosition) EStartingPosition m_ePosition;
var ECivPatrolType m_eCivPatrol;
var EHandsUpType m_eHandsUpType;
var byte m_bRepWaitAnimIndex;
var byte m_bSavedRepWaitAnimIndex;
var int m_iIndex;
var bool m_bInitFinished;
var bool m_bStartAsCivilian;
var bool m_bCivilian;
var bool m_bPatrolForward;
var bool m_bPoliceManMp1;
var bool m_bPoliceManHasWeapon;
var bool m_bPoliceManCanSeeRainbows;
var bool m_bIsKneeling;
var bool m_bIsFoetus;
var bool m_bFrozen;
var bool m_bReactionAnim;
var bool m_bCrouchToScaredStandBegin;
var bool m_bFreed;
var bool m_bEscorted;
var bool m_bExtracted;
var bool m_bFeedbackExtracted;
var R6DeploymentZone m_DZone;
var R6DZonePathNode m_currentNode;
var R6HostageMgr m_mgr;
var R6HostageAI m_controller;
var R6Rainbow m_escortedByRainbow;
var name m_NocsWaitingName;
var name m_NocsSeeRainbowsName;
var name m_globalState;
var(StayInThisState) RandomTweenNum m_stayInFoetusTime;
var(StayInThisState) RandomTweenNum m_stayFrozenTime;
var(StayInThisState) RandomTweenNum m_stayProneTime;
var(StayInThisState) RandomTweenNum m_stayCautiousGuardedStateTime;
var() RandomTweenNum m_patrolAreaWaitTween;
var() RandomTweenNum m_changeOrientationTween;
var() RandomTweenNum m_sightRadiusTween;
var() RandomTweenNum m_updatePaceTween;
var() RandomTweenNum m_waitingGoCrouchTween;
var STRepHostageAnim m_eSavedRepHostageAnim;
var STRepHostageAnim m_eCurrentRepHostageAnim;
var string m_szUsedTemplate;

replication
{
	reliable if ( Role == Role_Authority )
		m_ePosition,m_eHandsUpType,m_bRepWaitAnimIndex,m_bIsKneeling,m_bIsFoetus,m_bFrozen,m_bFreed,m_bEscorted,m_bExtracted,m_escortedByRainbow,m_eCurrentRepHostageAnim;
}

simulated function Tick (float fDeltaTime)
{
	if ( Role < Role_Authority )
	{
		if ( (m_eSavedRepHostageAnim.m_bRepPlayMoving != m_eCurrentRepHostageAnim.m_bRepPlayMoving) || (m_eSavedRepHostageAnim.m_eRepStandWalkingAnim != m_eCurrentRepHostageAnim.m_eRepStandWalkingAnim) )
		{
			SetStandWalkingAnim(m_eCurrentRepHostageAnim.m_eRepStandWalkingAnim,m_eCurrentRepHostageAnim.m_bRepPlayMoving);
			m_eSavedRepHostageAnim=m_eCurrentRepHostageAnim;
		}
		if ( m_bSavedRepWaitAnimIndex != m_bRepWaitAnimIndex )
		{
			m_bSavedRepWaitAnimIndex=m_bRepWaitAnimIndex;
			SetAnimInfo(m_bRepWaitAnimIndex);
		}
	}
	UpdateVisualEffects(fDeltaTime);
}

simulated event bool GetReticuleInfo (Pawn ownerReticule, out string szName)
{
	szName="";
	return ownerReticule.IsFriend(self) || ownerReticule.IsNeutral(self);
}

event FinishInitialization ()
{
	if ( Controller != None )
	{
		UnPossessed();
	}
	Controller=Spawn(ControllerClass);
	Controller.Possess(self);
	Controller.m_PawnRepInfo.m_PawnType=m_ePawnType;
	Controller.m_PawnRepInfo.m_bSex=bIsFemale;
	if ( m_SoundRepInfo != None )
	{
		m_SoundRepInfo.m_PawnRepInfo=Controller.m_PawnRepInfo;
	}
	m_controller=R6HostageAI(Controller);
}

function logAnim (string sz)
{
}

function bool HasBumpPriority (R6Pawn bumpedBy)
{
	if (  !bumpedBy.m_bIsPlayer && R6AIController(bumpedBy.Controller).IsInState('BumpBackUp') )
	{
		return False;
	}
	if ( IsFriend(bumpedBy) &&  !bumpedBy.IsStationary() )
	{
		return False;
	}
	return True;
}

simulated event AnimEnd (int iChannel)
{
	local bool bPreviousPostureTransition;

	bPreviousPostureTransition=m_bPostureTransition;
	Super.AnimEnd(iChannel);
	if ( iChannel == 0 )
	{
		if ( (Physics != 12) &&  !m_bPawnSpecificAnimInProgress )
		{
			if ( m_eEffectiveGrenade == 2 )
			{
//				SetNextPendingAction(PENDING_Coughing);
			}
			else
			{
				if ( (m_eEffectiveGrenade == 3) || (m_eEffectiveGrenade == 4) )
				{
//					SetNextPendingAction(PENDING_Blinded);
				}
			}
		}
	}
	else
	{
		if ( (iChannel == 16) && m_bPawnSpecificAnimInProgress )
		{
			m_bPawnSpecificAnimInProgress=False;
			if ( m_eEffectiveGrenade == 2 )
			{
//				SetNextPendingAction(PENDING_Coughing);
			}
			else
			{
				if ( (m_eEffectiveGrenade == 3) || (m_eEffectiveGrenade == 4) )
				{
//					SetNextPendingAction(PENDING_Blinded);
				}
			}
		}
	}
	if ( bPreviousPostureTransition &&  !m_bPostureTransition )
	{
		if ( m_bCrouchToScaredStandBegin )
		{
			AnimNotify_CrouchToScaredStandEnd();
		}
		m_bPostureTransition=False;
		m_bReactionAnim=False;
		R6ResetAnimBlendParams(1);
		PlayMoving();
		PlayWaiting();
	}
}

simulated event PlaySpecialPendingAction (EPendingAction eAction)
{
	if ( eAction == 38 )
	{
		if ( Role != Role_Authority )
		{
			SetAnimInfo(m_iPendingActionInt[m_iLocalCurrentActionIndex]);
		}
	}
	else
	{
		Super.PlaySpecialPendingAction(eAction);
	}
}

simulated event SetAnimInfo (int ID)
{
	local AnimInfo AnimInfo;

	if ( m_mgr == None )
	{
		return;
	}
//	AnimInfo=m_mgr.GetAnimInfo(ID);
	if ( (AnimInfo.m_eGroupAnim == 1) && m_bReactionAnim )
	{
		goto JL0090;
	}
	if ( m_bPostureTransition && (AnimInfo.m_eGroupAnim != 1) )
	{
		if ( Level.NetMode == NM_Client )
		{
			m_bPostureTransition=False;
		}
		else
		{
			return;
		}
	}
JL0090:
	if ( (Role == Role_Authority) && (Level.NetMode != 0) )
	{
		if ( AnimInfo.m_eGroupAnim == 2 )
		{
			m_bRepWaitAnimIndex=ID;
		}
		else
		{
//			SetNextPendingAction(PENDING_Blinded8,ID);
		}
	}
	if ( (AnimInfo.m_eGroupAnim == 3) || (AnimInfo.m_eGroupAnim == 1) )
	{
		m_bPostureTransition=True;
		AnimBlendParams(1,1.00,0.30,0.00);
		PlayAnim(AnimInfo.m_name,1.00,0.20,1);
		m_bReactionAnim=AnimInfo.m_eGroupAnim == 3;
	}
	else
	{
		R6LoopAnim(AnimInfo.m_name);
	}
}

simulated function SetAnimTransition (int iAnimToPlay, name pawnStateToGo)
{
	local AnimInfo AnimInfo;

	SetAnimInfo(iAnimToPlay);
	if (  !m_bUseRagdoll )
	{
		GotoState(pawnStateToGo);
	}
}

simulated event PostBeginPlay ()
{
	local int i;

	if ( Level.Game != None )
	{
//		assert (Default.m_iTeam == R6AbstractGameInfo(Level.Game).0);
	}
	m_globalState=GetStateName();
	Super.PostBeginPlay();
	SetPhysics(PHYS_Walking);
	AttachCollisionBox(1);
	m_mgr=R6HostageMgr(Level.GetHostageMgr());
}

simulated event PostNetBeginPlay ()
{
	Super.PostNetBeginPlay();
	switch (m_ePosition)
	{
		case POS_Crouch:
		GotoCrouch();
		break;
		case POS_Kneel:
		GotoKneel();
		break;
		case POS_Foetus:
		GotoFoetus();
		break;
		case POS_Prone:
		GotoProne();
		break;
		default:
		GotoStand();
		break;
	}
}

function setFrozen (bool bFreeze)
{
	m_bFrozen=bFreeze;
}

function setCrouch (bool bIsCrouch)
{
	bWantsToCrouch=bIsCrouch;
	if ( bWantsToCrouch )
	{
		if ( Level.NetMode != 3 )
		{
			m_eHandsUpType=HANDSUP_none;
		}
	}
}

function setProne (bool bIsProne)
{
	m_bWantsToProne=bIsProne;
}

function bool isStanding ()
{
	return GetStateName() == m_globalState;
}

function bool isStandingHandUp ()
{
	return m_eHandsUpType == HANDSUP_standing;
}

function bool isFoetus ()
{
	return m_bIsFoetus;
}

function bool isKneeling ()
{
	return m_bIsKneeling;
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGoup)
{
	local eHealth ePreviousHealth;
	local int iResult;
	local int iSndIndex;

	if ( m_bExtracted )
	{
		return 0;
	}
	ePreviousHealth=m_eHealth;
	iResult=Super.R6TakeDamage(iKillValue,iStunValue,instigatedBy,vHitLocation,vMomentum,iBulletToArmorModifier,iBulletGoup);
	if ( (ePreviousHealth != m_eHealth) && (1 <= m_eHealth) )
	{
		if ( m_controller != None )
		{
			m_controller.SetMovementPace(False);
		}
		if ( m_escortedByRainbow != None )
		{
			m_escortedByRainbow.Escort_UpdateTeamSpeed();
		}
		PlayMoving();
	}
	return iResult;
}

function PlayWeaponAnimation ()
{
	if ( m_bPoliceManMp1 )
	{
		Super.PlayWeaponAnimation();
	}
}

function ResetWeaponAnimation ()
{
}

simulated function SetStandWalkingAnim (EStandWalkingAnim eAnim, bool bUpdatePlayMoving)
{
	m_eCurrentRepHostageAnim.m_eRepStandWalkingAnim=eAnim;
	m_eCurrentRepHostageAnim.m_bRepPlayMoving=bUpdatePlayMoving;
	if ( eAnim == 0 )
	{
		SetDefaultWalkAnim();
		m_fWalkingSpeed=134.00;
	}
	else
	{
		m_standWalkForwardName='ScaredStandWalkForward';
		m_standWalkBackName='ScaredStandWalkBack';
		m_standWalkLeftName='ScaredStandWalkLeft';
		m_standWalkRightName='ScaredStandWalkRight';
		m_standTurnLeftName='ScaredStandTurnLeft';
		m_standTurnRightName='ScaredStandTurnRight';
		m_standDefaultAnimName='ScaredStand_nt';
		m_standClimb64DefaultAnimName='ScaredStandClimb64Up';
		m_standClimb96DefaultAnimName='ScaredStandClimb96Up';
		m_fWalkingSpeed=Default.m_fWalkingSpeed;
	}
	m_hurtStandWalkLeftName=m_standWalkLeftName;
	m_hurtStandWalkRightName=m_standWalkRightName;
	if ( bUpdatePlayMoving )
	{
		PlayMoving();
	}
}

function PlayReaction ()
{
	local int Result;

	if ( m_bFrozen || m_bReactionAnim )
	{
		return;
	}
	if ( isStandingHandUp() )
	{
		Result=Rand(100);
		if ( Result < 33 )
		{
			SetAnimInfo(m_mgr.ANIM_eStandHandUpReact01);
		}
		else
		{
			if ( Result < 66 )
			{
				SetAnimInfo(m_mgr.ANIM_eStandHandUpReact02);
			}
			else
			{
				SetAnimInfo(m_mgr.ANIM_eStandHandUpReact03);
			}
		}
	}
}

simulated function PlayWaiting ()
{
	local int animIndex;
	local int Result;

	if ( m_bPostureTransition )
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
	if ( m_bIsKneeling )
	{
		Result=Rand(100);
		if ( m_bFrozen )
		{
			SetAnimInfo(m_mgr.ANIM_eKneelFreeze);
		}
		else
		{
			if ( m_bCivilian )
			{
				if ( m_bPoliceManMp1 )
				{
					R6LoopAnim(m_NocsWaitingName);
				}
				else
				{
					if ( Result < 50 )
					{
						SetAnimInfo(m_mgr.ANIM_eFoetusWait01);
					}
					else
					{
						SetAnimInfo(m_mgr.ANIM_eFoetusWait02);
					}
				}
			}
			else
			{
				if ( Result < 33 )
				{
					SetAnimInfo(m_mgr.ANIM_eKneelWait01);
				}
				else
				{
					if ( Result < 66 )
					{
						SetAnimInfo(m_mgr.ANIM_eKneelWait02);
					}
					else
					{
						SetAnimInfo(m_mgr.ANIM_eKneelWait03);
					}
				}
			}
		}
		return;
	}
	else
	{
		if ( m_bIsFoetus )
		{
			Result=Rand(100);
			if ( Result < 50 )
			{
				SetAnimInfo(m_mgr.ANIM_eFoetusWait01);
			}
			else
			{
				SetAnimInfo(m_mgr.ANIM_eFoetusWait02);
			}
			return;
		}
		else
		{
			if ( m_bIsProne )
			{
				SetAnimInfo(m_mgr.ANIM_eProneWaitBreathe);
				return;
			}
			else
			{
				if ( bWantsToCrouch || bIsCrouched )
				{
					if ( bWantsToCrouch && bIsCrouched )
					{
						if ( Rand(5) < 1 )
						{
							SetAnimInfo(m_mgr.ANIM_eCrouchWait02);
						}
						else
						{
							SetAnimInfo(m_mgr.ANIM_eCrouchWait01);
						}
					}
					return;
				}
			}
		}
	}
	if (  !m_bFreed )
	{
		if ( m_bFrozen )
		{
			SetAnimInfo(m_mgr.ANIM_eStandHandUpFreeze);
			if ( Level.NetMode != 3 )
			{
				m_eHandsUpType=HANDSUP_standing;
			}
		}
		else
		{
			if ( m_bEscorted )
			{
				if ( m_bPoliceManMp1 )
				{
					R6LoopAnim(m_NocsWaitingName);
				}
				else
				{
					SetAnimInfo(m_mgr.ANIM_eStandWaitShiftWeight);
				}
			}
			else
			{
				if ( m_eHandsUpType == HANDSUP_none )
				{
					SetAnimTransition(m_mgr.ANIM_eStandHandDownToUp,'None');
					if ( Level.NetMode != 3 )
					{
						m_eHandsUpType=HANDSUP_standing;
					}
				}
				else
				{
					if ( m_eHandsUpType == HANDSUP_standing )
					{
						if ( m_bCivilian )
						{
							if ( Rand(100) < 60 )
							{
								SetAnimInfo(m_mgr.ANIM_eScaredStandWait02);
							}
							else
							{
								SetAnimInfo(m_mgr.ANIM_eScaredStandWait01);
							}
						}
						else
						{
							SetAnimInfo(m_mgr.ANIM_eStandHandUpWait01);
						}
					}
				}
			}
		}
	}
	else
	{
		if ( m_eHandsUpType == HANDSUP_standing )
		{
			SetAnimTransition(m_mgr.ANIM_eStandHandUpToDown,'None');
			if ( Level.NetMode != 3 )
			{
				m_eHandsUpType=HANDSUP_none;
			}
		}
		else
		{
			if ( m_escortedByRainbow != None )
			{
				if ( Physics == 11 )
				{
					SetAnimInfo(m_mgr.ANIM_eStandWaitShiftWeight);
				}
				else
				{
					if ( Rand(5) < 1 )
					{
						SetAnimTransition(m_mgr.ANIM_eScaredStandWait02,'None');
					}
					else
					{
						SetAnimTransition(m_mgr.ANIM_eScaredStandWait01,'None');
					}
				}
			}
			else
			{
				if ( Rand(100) < 75 )
				{
					SetAnimInfo(m_mgr.ANIM_eStandWaitShiftWeight);
				}
				else
				{
					SetAnimInfo(m_mgr.ANIM_eStandWaitCough);
				}
			}
		}
	}
}

simulated event GotoStand ()
{
	setCrouch(False);
	GotoState('None');
}

simulated event GotoCrouch ()
{
	GotoState('Crouching');
}

simulated event GotoKneel ()
{
	setCrouch(False);
	if ( Level.NetMode != 3 )
	{
		m_eHandsUpType=HANDSUP_kneeling;
	}
	if ( m_bPoliceManMp1 )
	{
		GotoState('Kneeling');
	}
	else
	{
		SetAnimTransition(m_mgr.ANIM_eStandToKneel,'Kneeling');
	}
}

simulated event GotoFoetus ()
{
	setCrouch(False);
	if ( Level.NetMode != 3 )
	{
		m_eHandsUpType=HANDSUP_none;
	}
	SetAnimTransition(m_mgr.ANIM_eStandToFoetus,'Foetus');
}

simulated event GotoProne ()
{
	GotoState('Prone');
}

function GotoFrozen ()
{
	setFrozen(True);
	SetAnimInfo(m_mgr.ANIM_eStandHandUpFreeze);
	if ( Level.NetMode != 3 )
	{
		m_eHandsUpType=HANDSUP_standing;
	}
}

function AnimNotify_CrouchToScaredStandEnd ()
{
	m_bCrouchToScaredStandBegin=False;
	setCrouch(False);
}

function AnimNotify_CrouchToScaredStandBegin ()
{
	m_bCrouchToScaredStandBegin=True;
}

function PlayDuck ()
{
}

simulated function PlayCrouchToProne (optional bool bForcedByClient)
{
	SetAnimInfo(m_mgr.ANIM_eCrouchToProne);
}

simulated state Crouching
{
	simulated function BeginState ()
	{
		if ( m_bIsProne )
		{
			setProne(False);
		}
		if (  !bWantsToCrouch ||  !bIsCrouched )
		{
			setCrouch(True);
		}
	}

	simulated event GotoCrouch ()
	{
	}

	simulated event GotoFoetus ()
	{
		SetAnimTransition(m_mgr.ANIM_eFoetus_nt,'Foetus');
		setCrouch(False);
	}

	simulated event GotoStand ()
	{
		SetAnimTransition(m_mgr.ANIM_eCrouchToScaredStand,'None');
	}

	simulated event GotoProne ()
	{
		GotoState('Prone');
	}

	simulated event GotoKneel ()
	{
		SetAnimTransition(m_mgr.ANIM_eKneelWait01,'Kneeling');
	}

}

simulated state Kneeling
{
	simulated function BeginState ()
	{
		m_bIsKneeling=True;
		if ( Level.NetMode != 3 )
		{
			m_eHandsUpType=HANDSUP_kneeling;
		}
		setCrouch(False);
	}

	simulated function EndState ()
	{
		if ( Level.NetMode != 3 )
		{
			m_eHandsUpType=HANDSUP_none;
		}
		m_bIsKneeling=False;
	}

	simulated function PlayReaction ()
	{
		local int Result;

		if ( m_bFrozen || m_bReactionAnim )
		{
			return;
		}
		Result=Rand(100);
		if ( Result < 33 )
		{
			SetAnimInfo(m_mgr.ANIM_eKneelReact01);
		}
		else
		{
			if ( Result < 66 )
			{
				SetAnimInfo(m_mgr.ANIM_eKneelReact02);
			}
			else
			{
				SetAnimInfo(m_mgr.ANIM_eKneelReact03);
			}
		}
	}

	simulated function GotoFrozen ()
	{
		setFrozen(True);
		SetAnimInfo(m_mgr.ANIM_eKneelFreeze);
	}

	simulated event GotoStand ()
	{
		SetAnimTransition(m_mgr.ANIM_eKneelToStand,'None');
	}

	simulated event GotoKneel ()
	{
	}

	simulated event GotoFoetus ()
	{
		SetAnimTransition(m_mgr.ANIM_eKneelToFoetus,'Foetus');
	}

	simulated event GotoProne ()
	{
		SetAnimTransition(m_mgr.ANIM_eKneelToProne,'Prone');
	}

	simulated event GotoCrouch ()
	{
		SetAnimTransition(m_mgr.ANIM_eKneelToCrouch,'Crouching');
	}

}

simulated function PlayProneToCrouch (optional bool bForcedByClient)
{
	SetAnimInfo(m_mgr.ANIM_eProneToCrouch);
	if ( Level.NetMode == NM_Client )
	{
		m_bWantsToProne=False;
		bWantsToCrouch=True;
	}
}

simulated state Prone
{
	simulated function BeginState ()
	{
		if (  !m_bWantsToProne ||  !m_bIsProne )
		{
			setProne(True);
		}
	}

	simulated event GotoStand ()
	{
		SetAnimTransition(m_mgr.ANIM_eProneToCrouch,'Crouching');
	}

	simulated event GotoKneel ()
	{
	}

	simulated event GotoFoetus ()
	{
	}

	simulated event GotoProne ()
	{
	}

	simulated event GotoCrouch ()
	{
		GotoState('Crouching');
	}

}

simulated state Foetus
{
	simulated event GotoStand ()
	{
		SetAnimTransition(m_mgr.ANIM_eFoetusToStand,'None');
	}

	simulated event GotoKneel ()
	{
		SetAnimTransition(m_mgr.ANIM_eFoetusToKneel,'Kneeling');
	}

	simulated event GotoFoetus ()
	{
	}

	simulated event GotoCrouch ()
	{
		SetAnimTransition(m_mgr.ANIM_eFoetusToCrouch,'Crouching');
	}

	simulated event GotoProne ()
	{
		SetAnimTransition(m_mgr.ANIM_eFoetusToProne,'Prone');
	}

	simulated function BeginState ()
	{
		m_bIsFoetus=True;
	}

	simulated function EndState ()
	{
		m_bIsFoetus=False;
	}

}

simulated function PlayCoughing ()
{
	local name animName;

	if ( m_bIsClimbingLadder )
	{
		return;
	}
	m_bPawnSpecificAnimInProgress=True;
	if ( m_bIsProne )
	{
		AnimBlendParams(16,1.00,,,'R6 Pelvis');
		animName='ProneGazed';
	}
	else
	{
		AnimBlendParams(16,1.00,,,'R6 Spine2');
		animName='Gazed';
	}
	PlayAnim(animName,1.00,0.50,16);
}

simulated function PlayBlinded ()
{
	local name animName;

	if ( m_bIsClimbingLadder )
	{
		return;
	}
	m_bPawnSpecificAnimInProgress=True;
	if ( m_bIsProne )
	{
		AnimBlendParams(16,1.00,,,'R6 Pelvis');
		animName='ProneBlinded';
	}
	else
	{
		AnimBlendParams(16,1.00,,,'R6 Spine2');
		animName='Blinded';
	}
	PlayAnim(animName,1.00,0.50,16);
}

simulated function bool CanBeAffectedByGrenade (Actor aGrenade, EGrenadeType eType)
{
	local bool bAffected;

	bAffected=Super.CanBeAffectedByGrenade(aGrenade,eType);
	if (  !bAffected )
	{
		return False;
	}
	if ( IsInState('Foetus') || m_bPostureTransition )
	{
		return False;
	}
	return True;
}

simulated function PlayDoorAnim (R6IORotatingDoor Door)
{
	local bool bOpensTowardsPawn;

	m_bPawnSpecificAnimInProgress=True;
	AnimBlendParams(16,1.00,,,'R6 Spine2');
	bOpensTowardsPawn=Door.DoorOpenTowardsActor(self);
	if ( bOpensTowardsPawn )
	{
		PlayAnim('StandDoorPull',1.00,0.20,16);
	}
	else
	{
		PlayAnim('StandDoorPush',1.00,0.20,16);
	}
}

event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	if (  !IsAlive() || m_bExtracted || IsEnemy(PlayerController.Pawn) )
	{
		Query.iHasAction=0;
	}
	else
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
		if ( m_controller.Order_canFollowMe() )
		{
//			Query.textureIcon=Texture'HostageFollowMe';
//			Query.iPlayerActionID=m_controller.1;
//			Query.iTeamActionID=m_controller.1;
//			Query.iTeamActionIDList[0]=m_controller.1;
		}
		else
		{
//			Query.textureIcon=Texture'HostageStayHere';
/*			Query.iPlayerActionID=m_controller.2;
			Query.iTeamActionID=m_controller.2;
			Query.iTeamActionIDList[0]=m_controller.2;*/
		}
/*		Query.iTeamActionIDList[1]=m_controller.0;
		Query.iTeamActionIDList[2]=m_controller.0;
		Query.iTeamActionIDList[3]=m_controller.0;*/
	}
}

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
/*		case m_controller.1:
		return Localize("RDVOrder","Order_FollowMe","R6Menu");
		case m_controller.2:
		return Localize("RDVOrder","Order_StayHere","R6Menu");
		default:*/
	}
	return "";
}

function EnteredExtractionZone (R6AbstractExtractionZone Zone)
{
	if (  !m_bCivilian &&  !m_bPoliceManMp1 )
	{
		if ( m_controller != None )
		{
			m_controller.SetStateExtracted();
		}
	}
}

function bool ProcessBuildDeathMessage (Pawn Killer, out string szPlayerName)
{
	if ( Killer.m_ePawnType == 1 )
	{
		m_bSuicideType=6;
	}
	else
	{
		if ( Killer.m_ePawnType == 2 )
		{
			m_bSuicideType=7;
		}
		else
		{
			m_bSuicideType=5;
		}
	}
	return True;
}

event Vector EyePosition ()
{
	local Vector vEyeHeight;

	if ( bIsCrouched )
	{
		vEyeHeight.Z=30.00;
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
				vEyeHeight.Z=25.00;
			}
			else
			{
				if ( m_bIsFoetus )
				{
					vEyeHeight.Z=-60.00;
				}
				else
				{
					vEyeHeight.Z=65.00;
				}
			}
		}
	}
	return vEyeHeight;
}

function SetToNormalWeapon ()
{
	EngineWeapon=GetWeaponInGroup(1);
	if ( EngineWeapon == None )
	{
		logX("SetToNormalWeapon-No weapon!!!");
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

defaultproperties
{
    m_ePersonality=1
    m_iIndex=-1
    m_bPatrolForward=True
    m_stayInFoetusTime=(m_fMin=0.00,m_fMax=1.5261324804310168E31,m_fResult=0.00)
    m_stayFrozenTime=(m_fMin=0.00,m_fMax=1.51721931214816206E31,m_fResult=0.00)
    m_stayProneTime=(m_fMin=0.00,m_fMax=1.52316142433673189E31,m_fResult=0.00)
    m_stayCautiousGuardedStateTime=(m_fMin=0.00,m_fMax=1.52811318449387341E31,m_fResult=0.00)
    m_patrolAreaWaitTween=(m_fMin=0.00,m_fMax=1.52118072027387528E31,m_fResult=0.00)
    m_changeOrientationTween=(m_fMin=0.00,m_fMax=1.5261324804310168E31,m_fResult=0.00)
    m_sightRadiusTween=(m_fMin=0.00,m_fMax=1.56457051865082786E31,m_fResult=2.00)
    m_updatePaceTween=(m_fMin=0.00,m_fMax=1.51920001621101867E31,m_fResult=2.71702111476066495E23)
    m_waitingGoCrouchTween=(m_fMin=0.00,m_fMax=1.52217107230530359E31,m_fResult=0.00)
    m_bAutoClimbLadders=True
    m_bAvoidFacingWalls=False
    m_fWalkingSpeed=250.00
    m_fWalkingBackwardStrafeSpeed=100.00
    m_fRunningSpeed=400.00
    m_fRunningBackwardStrafeSpeed=320.00
    m_fCrouchedWalkingSpeed=125.00
    m_fCrouchedWalkingBackwardStrafeSpeed=100.00
    m_fCrouchedRunningSpeed=250.00
    m_fCrouchedRunningBackwardStrafeSpeed=250.00
    m_standRunBackName=ScaredStandWalkBack
    m_standWalkBackName=ScaredStandWalkBack
    m_standFallName=ScaredStandFall
    m_standLandName=ScaredStandLand
    m_crouchFallName=crouchFall
    m_crouchWalkForwardName=CrouchRunForward
    m_standStairWalkUpName=StandStairWalkUp
    m_standStairWalkUpBackName=StandStairWalkUp
    m_standStairWalkDownName=StandStairWalkDown
    m_standStairWalkDownBackName=StandStairWalkDown
    m_standStairWalkDownRightName=StandWalkRight
    m_standStairRunUpName=StandStairRunUp
    m_standStairRunUpBackName=StandStairRunUp
    m_standStairRunUpRightName=StandWalkRight
    m_standStairRunDownName=StandStairRunDown
    m_standStairRunDownBackName=StandStairRunDown
    m_standStairRunDownRightName=StandWalkRight
    m_crouchStairWalkDownName=CrouchStairWalkDown
    m_crouchStairWalkDownBackName=CrouchStairWalkUp
    m_crouchStairWalkDownRightName=CrouchWalkRight
    m_crouchStairWalkUpName=CrouchStairWalkUp
    m_crouchStairWalkUpBackName=CrouchStairWalkDown
    m_crouchStairWalkUpRightName=CrouchWalkRight
    m_crouchStairRunUpName=CrouchStairWalkUp
    m_crouchStairRunDownName=CrouchStairWalkDown
    m_crouchDefaultAnimName=Crouch_nt
    m_standDefaultAnimName=Stand_nt
    m_ePawnType=3
    m_bMakesTrailsWhenProning=True
    ControllerClass=Class'R6HostageAI'
    CollisionHeight=80.00
    RotationRate=(Pitch=4096,Yaw=45000,Roll=0)
}
/*
    KParams=KarmaParamsSkel'KarmaParamsSkel17'
*/
