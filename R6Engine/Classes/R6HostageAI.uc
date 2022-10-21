//================================================================================
// R6HostageAI.
//================================================================================
class R6HostageAI extends R6AIController
	Native;

enum eHostageOrder {
	HOrder_None,
	HOrder_ComeWithMe,
	HOrder_StayHere,
	HOrder_Surrender,
	HOrder_GotoExtraction
};

struct OrderInfo
{
	var bool m_bOrderedByRainbow;
	var R6Pawn m_pawn1;
	var eHostageOrder m_eOrder;
	var float m_fTime;
	var Actor m_actor;
};

enum EStartingPosition {
	POS_Stand,
	POS_Kneel,
	POS_Prone,
	POS_Foetus,
	POS_Crouch,
	POS_Random
};

const C_iKeepDistanceFromPawn= 105;

struct ThreatInfo
{
	var int m_id;
	var int m_iThreatLevel;
	var Pawn m_pawn;
	var Actor m_actorExt;
	var int m_bornTime;
	var Vector m_originalLocation;
	var name m_state;
};

struct PlaySndInfo
{
	var int m_iLastTime;
	var int m_iInBetweenTime;
};

var EStartingPosition m_eTransitionPosition;
var int m_iNotGuardedSince;
var int m_iLastHearNoiseTime;
var const int c_iDistanceMax;
var const int c_iDistanceCatchUp;
var const int c_iDistanceToStartToRun;
var int m_iPlayReaction1;
var int m_iPlayReaction2;
var int m_iWaitingTime;
var int m_iFacingTime;
var int m_lastUpdatePaceTime;
var int m_iNbOrder;
var const int c_iCowardModifier;
var const int c_iNormalModifier;
var const int c_iBraveModifier;
var const int c_iWoundedModifier;
var const int c_iGasModifier;
var const int c_iEnemyNotVisibleTime;
var const int c_iCautiousLastHearNoiseTime;
var const int c_iRunForCoverOfGrenadeMinDist;
var int m_iDbgRoll;
var bool m_bForceToStayHere;
var bool m_bRunningToward;
var bool m_bRunToRainbowSuccess;
var bool m_bStopDoTransition;
var bool m_bNeedToRunToCatchUp;
var bool m_bSlowedPace;
var bool m_bFollowIncreaseDistance;
var bool m_bLatentFnStopped;
var bool m_bDbgIgnoreThreat;
var bool m_bDbgIgnoreRainbow;
var bool m_bDbgRoll;
var bool m_bool;
var bool bThreatShowLog;
var bool m_bFirstTimeClarkComment;
var float m_float;
var R6Hostage m_pawn;
var R6HostageMgr m_mgr;
var R6HostageVoices m_VoicesManager;
var R6Pawn m_pawnToFollow;
var R6Pawn m_lastSeenPawn;
var Actor m_runAwayOfGrenade;
var R6Terrorist m_terrorist;
var R6Pawn m_escort;
var Actor m_pGotoToExtractionZone;
var R6EngineWeapon DefaultWeapon;
var name m_threatGroupName;
var name m_runForCoverStateToGoOnFailure;
var name m_runForCoverStateToGoOnSuccess;
var name m_reactToGrenadeStateToReturn;
var name m_name;
var Class<R6EngineWeapon> DefaultWeaponClass;
var RandomTweenNum m_AITickTime;
var ThreatInfo m_threatInfo;
var Vector m_vReactionDirection;
var OrderInfo m_aOrderInfo[2];
var RandomTweenNum m_RunForCoverMinTween;
var RandomTweenNum m_scareToDeathTween;
var RandomTweenNum m_stayBlindedTweenTime;
var Vector m_vMoveToDest;
var Rotator m_rotator;
var Vector m_vectorTemp;
var PlaySndInfo m_aPlaySndInfo[12];

event PostBeginPlay ()
{
	local int i;

	Super.PostBeginPlay();
	m_mgr=R6HostageMgr(Level.GetHostageMgr());
//	assert (12 >= m_mgr.11);
	i=0;
JL0039:
	if ( i < 12 )
	{
		m_aPlaySndInfo[i].m_iInBetweenTime=1;
		i++;
		goto JL0039;
	}
/*	m_aPlaySndInfo[m_mgr.6].m_iInBetweenTime=5;
	m_aPlaySndInfo[m_mgr.1].m_iInBetweenTime=2;*/
}

function Possess (Pawn aPawn)
{
	local int i;

	Super.Possess(aPawn);
	m_pawn=R6Hostage(Pawn);
	m_VoicesManager=R6HostageVoices(R6AbstractGameInfo(Level.Game).GetHostageVoicesMgr(Level.m_eHostageVoices,m_pawn.bIsFemale));
	if ( GetStateName() != 'Configuration' )
	{
		GotoState('Configuration');
	}
}

function Tick (float fDeltaTime)
{
	Super.Tick(fDeltaTime);
	if ( m_iNbOrder > 0 )
	{
		Order_Process();
	}
}

auto state Configuration
{
	function BeginState ()
	{
	}

	function EndState ()
	{
		m_threatGroupName=GetThreatGroupName();
		m_iNotGuardedSince=0;
	}

JL0000:
Begin:
	if (  !m_pawn.m_bInitFinished )
	{
		Sleep(1.00);
//		goto JL0000;
	}
	GetRandomTweenNum(m_pawn.m_waitingGoCrouchTween);
	GetRandomTweenNum(m_AITickTime);
	if ( m_pawn.m_bPoliceManMp1 )
	{
		m_pawn.m_sightRadiusTween.m_fMin=500.00;
		m_pawn.m_sightRadiusTween.m_fMax=1000.00;
	}
	Pawn.SightRadius=GetRandomTweenNum(m_pawn.m_sightRadiusTween);
	GetRandomTweenNum(m_pawn.m_updatePaceTween);
	GetRandomTweenNum(m_RunForCoverMinTween);
	FocalPoint=m_pawn.Location + vector(m_pawn.Rotation);
	if ( m_pawn.m_bStartAsCivilian )
	{
		CivInit();
	}
	else
	{
//		m_pawn.SetStandWalkingAnim(1,True);
		if ( IsGuarded(True) )
		{
//			SetPawnPosition(m_pawn.m_ePosition);
JL0135:
			if (  !Level.Game.m_bGameStarted )
			{
				Sleep(0.50);
//				goto JL0135;
			}
//			SetStateGuarded(m_pawn.m_ePosition,m_mgr.0);
		}
		else
		{
			SetFreed(True);
//			SetPawnPosition(4);
JL018D:
			if (  !Level.Game.m_bGameStarted )
			{
				Sleep(0.50);
//				goto JL018D;
			}
			GotoState('Freed');
		}
	}
}

function PawnDied ()
{
	StopFollowingPawn(False);
	Super.PawnDied();
}

function SetFreed (bool bFreed)
{
	m_pawn.m_bFreed=bFreed;
	m_bIgnoreBackupBump=False;
	if ( m_pawn.m_bFreed )
	{
		m_pawn.setFrozen(False);
//		m_iNotGuardedSince=0;
//		m_iLastHearNoiseTime=0;
	}
	else
	{
	}
	if ( m_pawn.m_bFreed && (m_pawn.m_ePersonality == 3) )
	{
//		m_pawn.m_ePersonality=1;
	}
}

function SetPawnPosition (EStartingPosition ePos)
{
	if ( ePos == 5 )
	{
		if ( Rand(100) <= 50 )
		{
//			ePos=1;
		}
		else
		{
//			ePos=0;
		}
	}
//	m_pawn.m_ePosition=ePos;
	switch (ePos)
	{
/*		case 4:
		m_pawn.GotoCrouch();
		break;
		case 1:
		m_pawn.GotoKneel();
		break;
		case 3:
		m_pawn.GotoFoetus();
		break;
		case 2:
		m_pawn.GotoProne();
		break;
		default:
		m_pawn.GotoStand();*/
	}
}

function SetPace (eMovementPace ePace)
{
	if ( Pawn.m_bTryToUnProne )
	{
//		ePace=1;
	}
	else
	{
		if ( Pawn.bTryToUncrouch )
		{
			if ( (m_pawn.m_eMovementPace == 3) || (ePace == 3) )
			{
//				ePace=3;
			}
			else
			{
//				ePace=2;
			}
		}
	}
//	m_pawn.m_eMovementPace=ePace;
//	CheckPaceForInjury(m_pawn.m_eMovementPace);
}

function SetStateGuarded (EStartingPosition ePos, int iHstSndEvent)
{
/*	if ( iHstSndEvent != m_mgr.0 )
	{
		ProcessPlaySndInfo(iHstSndEvent);
	}*/
	ResetThreatInfo("SetStateGuarded");
	m_pawn.setFrozen(False);
	m_eTransitionPosition=ePos;
	GotoState('Guarded');
}

function SetStateFollowingPawn (R6Pawn runTo, bool bFreed, int iHstSndEvent)
{
/*	if ( iHstSndEvent != m_mgr.0 )
	{
		ProcessPlaySndInfo(iHstSndEvent);
	}*/
	SetFreed(bFreed);
	m_pawnToFollow=R6Rainbow(runTo).Escort_GetPawnToFollow(True);
	m_bRunningToward=True;
	SetThreatState('FollowingPawn');
	GotoState(m_threatInfo.m_state);
}

function int Roll (int iMax)
{
	local int iRoll;

	iRoll=Rand(iMax) + 1;
	switch (m_pawn.m_ePersonality)
	{
/*		case 0:
		iRoll += c_iCowardModifier;
		break;
		case 1:
		iRoll += c_iNormalModifier;
		break;
		case 2:
		iRoll += c_iBraveModifier;
		break;
		default:*/
	}
	if ( m_pawn.m_eHealth == 1 )
	{
		iRoll -= c_iWoundedModifier;
	}
	if ( (m_pawn.m_eEffectiveGrenade == 2) || (m_pawn.m_eEffectiveGrenade == 3) )
	{
		iRoll -= c_iGasModifier;
	}
	if ( m_bDbgRoll )
	{
		Log("m_bDbgRoll: " $ string(m_iDbgRoll));
		iRoll=m_iDbgRoll;
	}
	iRoll=FClamp(iRoll,0.00,100.00);
	return iRoll;
}

function Rotator GetRandomTurn90 ()
{
	local Rotator rRot;

	rRot=Pawn.Rotation;
	if ( Rand(100) < 50 )
	{
		rRot.Yaw -= 16383;
	}
	else
	{
		rRot.Yaw += 16383;
	}
	return rRot;
}

function bool CanReturnToNormalState ()
{
	local R6Rainbow aR6Rainbow;
	local R6Pawn P;
	local int numFriend;
	local int numEnemy;

	numFriend=0;
	numEnemy=0;
	foreach VisibleCollidingActors(Class'R6Pawn',P,Pawn.SightRadius,m_pawn.Location)
	{
		if ( m_pawn.IsEnemy(P) && P.IsAlive() )
		{
			if ( P.IsFighting() || P.m_bIsKneeling )
			{
				return False;
			}
			numEnemy++;
		}
		if ( m_pawn.IsFriend(P) && P.IsAlive() )
		{
			if ( P.IsFighting() )
			{
				return False;
			}
			numFriend++;
		}
	}
	if ( Level.TimeSeconds < m_iLastHearNoiseTime + c_iCautiousLastHearNoiseTime )
	{
		return False;
	}
	if ( (numFriend == 0) || (numEnemy == 0) )
	{
		return True;
	}
	return False;
}

function ReturnToNormalState (optional bool bNoTimer)
{
	if ( IsGuarded(bNoTimer) )
	{
//		SetStateGuarded(1,m_mgr.0);
	}
	else
	{
		GotoState('Freed');
	}
}

function SeePlayer (Pawn P)
{
	local R6Pawn seen;

	if ( m_bDbgIgnoreThreat )
	{
		return;
	}
	seen=R6Pawn(P);
	if ( Rand(2) == 0 )
	{
		return;
	}
	if ( seen == None )
	{
		return;
	}
	if (  !seen.IsAlive() || seen.m_bIsKneeling )
	{
		return;
	}
	if ( m_pawn.m_bCivilian )
	{
		m_lastSeenPawn=None;
		return;
	}
	else
	{
		if ( m_pawn.m_bFreed )
		{
			if ( m_pawn.IsFriend(seen) && (m_lastSeenPawn == None) )
			{
				m_lastSeenPawn=seen;
			}
			else
			{
				if ( m_pawn.IsEnemy(seen) )
				{
					m_lastSeenPawn=seen;
				}
			}
		}
		else
		{
			if ( (m_lastSeenPawn != seen) && m_pawn.IsFriend(seen) )
			{
				m_vReactionDirection=seen.Location;
			}
			m_lastSeenPawn=seen;
		}
	}
}

function SeePlayerMgr ()
{
	if (  !m_lastSeenPawn.IsAlive() )
	{
		return;
	}
//	ProcessThreat(m_lastSeenPawn,0);
	m_lastSeenPawn=None;
}

event HearNoise (float fLoudness, Actor NoiseMaker, ENoiseType eType)
{
	local Actor aGrenade;

	if ( m_pawn.m_bDontHearPlayer && R6Pawn(NoiseMaker.Instigator).m_bIsPlayer )
	{
		return;
	}
	if ( m_bDbgIgnoreThreat )
	{
		return;
	}
	if (  !(eType == 2) || (eType == 3) || (eType == 4) )
	{
		return;
	}
	if ( IsInTemporaryState() )
	{
		return;
	}
	m_iLastHearNoiseTime=Level.TimeSeconds;
	ProcessThreat(NoiseMaker,eType);
}

function bool CanConsiderThreat (R6Pawn aPawn, Actor aThreat, name considerThreat)
{
	if ( considerThreat == 'IsEnemySound' )
	{
		return m_pawn.IsEnemy(aPawn);
	}
	else
	{
		if ( considerThreat == 'CanSeeFriend' )
		{
			return  !m_bForceToStayHere;
		}
	}
	m_pawn.logWarning("CanConsiderThreat: failed to find the threat=" $ string(considerThreat));
	return False;
}

function R6Rainbow GetRainbowWhoEscortThisPawn (R6Pawn follow)
{
	if ( follow.m_ePawnType == 1 )
	{
		return R6Rainbow(follow).Escort_GetPawnToFollow(False);
	}
	else
	{
		if ( follow.m_ePawnType == 3 )
		{
			return R6Hostage(follow).m_escortedByRainbow;
		}
	}
	m_pawn.logWarning("GetRainbowTeamFromPawn unknow type of pawn" $ string(follow));
	return None;
}

function Order_ProcessGotoExtraction (Actor aZone)
{
	if ( m_pawn.m_bExtracted ||  !m_pawn.IsAlive() )
	{
		return;
	}
	ResetThreatInfo("GotoExtraction");
	m_pGotoToExtractionZone=aZone;
	m_vMoveToDest=aZone.Location;
	SetFreed(True);
	m_bIgnoreBackupBump=True;
	GotoState('GotoExtraction');
}

function Order_ProcessFollowMe (R6Pawn follow, bool bOrderedByRainbow)
{
	local R6Rainbow rainbowToFollow;

	ResetThreatInfo("ProcessFollowMe");
//	m_pawn.SetStandWalkingAnim(1,True);
	if ( m_pawn.m_ePersonality == 3 )
	{
		SetFreed(True);
	}
	rainbowToFollow=GetRainbowWhoEscortThisPawn(follow);
	if ( (m_pawn.m_escortedByRainbow != None) && (rainbowToFollow != m_pawn.m_escortedByRainbow) )
	{
		m_pawn.m_escortedByRainbow.Escort_RemoveHostage(m_pawn,True);
	}
	m_pawn.m_escortedByRainbow=rainbowToFollow;
	if ( m_pawn.m_escortedByRainbow.Escort_AddHostage(m_pawn,False,bOrderedByRainbow) )
	{
		GotoState('FollowingPawn');
	}
	else
	{
		Order_ProcessStayHere(False);
	}
}

function StopFollowingPawn (bool bOrderedByRainbow)
{
//	m_pawn.SetStandWalkingAnim(0,False);
	if ( m_pawn.m_escortedByRainbow == None )
	{
		return;
	}
	m_pawn.m_escortedByRainbow.Escort_RemoveHostage(m_pawn, !m_pawn.IsAlive(),bOrderedByRainbow);
	m_pawnToFollow=None;
	m_bRunningToward=False;
}

function Order_ProcessStayHere (bool bOrderedByRainbow)
{
	ResetThreatInfo("ProcessStayHere");
	StopMoving();
	m_bForceToStayHere=True;
	StopFollowingPawn(bOrderedByRainbow);
	GotoState('Freed');
}

function DispatchOrder (int iOrder, optional R6Pawn orderFrom)
{
	switch (iOrder)
	{
/*		case 1:
		Order_FollowMe(orderFrom,True);
		break;
		case 2:
		Order_StayHere(True);
		break;
		default:
		m_pawn.logWarning("unknow eHostageCircumstantialAction " $ string(iOrder));*/
	}
}

function bool CanStopMoving (bool bCheckIfShouldMove)
{
	local R6HostageAI hostageAI;
	local int iDistance;

	if ( m_pawnToFollow == None )
	{
		return True;
	}
	if ( bCheckIfShouldMove )
	{
		iDistance=c_iDistanceMax;
	}
	else
	{
		iDistance=c_iDistanceCatchUp;
	}
	if ( m_bFollowIncreaseDistance || m_bSlowedPace || m_pawnToFollow.m_bIsClimbingLadder )
	{
		iDistance += iDistance / 2;
	}
	if ( VSize(m_pawnToFollow.Location - Pawn.Location) < iDistance )
	{
		return True;
	}
	if ( m_pawnToFollow.m_eMovementPace == 1 )
	{
		if ( VSize(m_pawnToFollow.m_collisionBox.Location - Pawn.Location) < iDistance )
		{
			return True;
		}
	}
	if ( (m_pawn.m_escortedByRainbow != None) && (m_pawn.m_escortedByRainbow.m_aEscortedHostage[0] == m_pawn) )
	{
		if ( bCheckIfShouldMove )
		{
			m_pawn.m_escortedByRainbow.Escort_UpdateCloserToLead();
			if ( m_pawn.m_escortedByRainbow.m_aEscortedHostage[0] == m_pawn )
			{
				return False;
			}
			else
			{
				return True;
			}
		}
		else
		{
			return False;
		}
	}
	hostageAI=R6HostageAI(m_pawnToFollow.Controller);
	if ( (hostageAI != None) && (hostageAI.MoveTarget != None) || bCheckIfShouldMove &&  !m_bRunningToward )
	{
		return False;
	}
	else
	{
		if ( (m_pawn.m_escortedByRainbow != None) && m_pawn.m_escortedByRainbow.Escort_IsPawnCloseToMe(m_pawn,iDistance) )
		{
			return True;
		}
	}
	return False;
}

function bool IsInCrouchedPosture ()
{
	return Super.IsInCrouchedPosture() || (m_pawn.m_ePosition == 1) || (m_pawn.m_ePosition == 3);
}

function bool IsGuarded (optional bool bNoTimer, optional bool bMustSeeMe)
{
	local R6Pawn P;

	if ( m_pawn.m_ePersonality == 3 )
	{
		return True;
	}
	foreach VisibleCollidingActors(Class'R6Pawn',P,Pawn.SightRadius,m_pawn.Location)
	{
		if ( m_pawn.IsEnemy(P) && P.IsAlive() &&  !P.m_bIsKneeling )
		{
			if ( bMustSeeMe )
			{
				if ( R6AIController(P.Controller) != None )
				{
					if ( R6AIController(P.Controller).CanSee(Pawn) )
					{
						m_iNotGuardedSince=0;
						return True;
					}
				}
				else
				{
					if ( CanSee(P) )
					{
						m_iNotGuardedSince=0;
						return True;
					}
				}
			}
			else
			{
				m_iNotGuardedSince=0;
				return True;
			}
		}
	}
	if ( bNoTimer )
	{
		return False;
	}
	if ( m_iNotGuardedSince == 0 )
	{
		m_iNotGuardedSince=Level.TimeSeconds;
		GetRandomTweenNum(m_pawn.m_stayCautiousGuardedStateTime);
	}
	else
	{
		if ( m_iNotGuardedSince + m_pawn.m_stayCautiousGuardedStateTime.m_fResult < Level.TimeSeconds )
		{
			return False;
		}
	}
	return True;
}

state Guarded
{
	function BeginState ()
	{
		if ( m_pawn.m_escortedByRainbow != None )
		{
			StopFollowingPawn(False);
		}
		StopMoving();
		Focus=None;
		FocalPoint=m_pawn.Location + vector(m_pawn.Rotation);
		m_vReactionDirection=vect(0.00,0.00,0.00);
		m_iNotGuardedSince=0;
		m_iWaitingTime=0;
		SetFreed(False);
		m_pawn.setFrozen(False);
		if (  !m_pawn.isKneeling() || m_pawn.isStandingHandUp() )
		{
			SetPawnPosition(m_eTransitionPosition);
		}
		SetTimer(0.10,True);
		if ( (m_pawn.m_ePosition == 0) &&  !m_pawn.isStandingHandUp() )
		{
			m_pawn.PlayWaiting();
		}
		m_iPlayReaction1=0;
		m_lastSeenPawn=None;
		m_bForceToStayHere=False;
	}

	function EndState ()
	{
		SetTimer(0.00,False);
	}

	function Timer ()
	{
		if ( m_iWaitingTime >= 20 )
		{
			if (  !IsGuarded() )
			{
				GotoState('Freed');
			}
			m_iWaitingTime=0;
		}
		m_iWaitingTime++;
		if ( m_lastSeenPawn != None )
		{
			SeePlayerMgr();
		}
		if ( m_iPlayReaction1 != 0 )
		{
			if ( m_iPlayReaction1 >= m_iPlayReaction2 )
			{
//				ProcessPlaySndInfo(m_mgr.1);
				m_pawn.PlayReaction();
				m_iPlayReaction1=0;
				m_iPlayReaction2=0;
			}
			else
			{
				m_iPlayReaction1++;
			}
		}
	}

}

state GoGuarded_Foetus
{
	function BeginState ()
	{
		SetThreatState('Guarded_foetus');
//		ProcessPlaySndInfo(m_mgr.7);
		GotoState(m_threatInfo.m_state);
	}

}

state Guarded_foetus extends Guarded
{
	function BeginState ()
	{
		Focus=None;
		StopMoving();
//		if (! m_pawn.GetStateName() != 'Foetus' ) goto JL0023;
	JL0023:
//		SetPawnPosition(3);
	}

	function Timer ()
	{
		if ( CanReturnToNormalState() )
		{
			GotoState('Guarded_foetus','End');
		}
		else
		{
			GotoState('Guarded_foetus','Begin');
		}
	}

End:
	ResetThreatInfo("foetus end");
	SetTimer(0.00,False);
	ReturnToNormalState(True);
Begin:
	SetTimer(GetRandomTweenNum(m_pawn.m_stayInFoetusTime),True);
}

state GoGuarded_frozen
{
	function BeginState ()
	{
//		ProcessPlaySndInfo(m_mgr.6);
		GotoState('Guarded_frozen');
	}

}

state Guarded_frozen extends Guarded
{
	function BeginState ()
	{
		StopMoving();
		Focus=None;
		if (  !m_pawn.m_bFrozen )
		{
			m_pawn.GotoFrozen();
		}
	}

	function Timer ()
	{
		m_pawn.setFrozen(False);
		GotoState('Guarded_foetus');
	}

End:
	m_pawn.setFrozen(False);
	SetTimer(0.00,False);
	if ( CanReturnToNormalState() )
	{
		ReturnToNormalState();
	}
	else
	{
		GotoState('Guarded_foetus');
	}
Begin:
	SetTimer(GetRandomTweenNum(m_pawn.m_stayFrozenTime),True);
}

state Freed
{
	function BeginState ()
	{
		StopMoving();
		SetFreed(True);
		m_lastSeenPawn=None;
		m_pawn.m_bAvoidFacingWalls=True;
//		SetPawnPosition(4);
		m_iWaitingTime=GetRandomTweenNum(m_pawn.m_changeOrientationTween);
		m_iFacingTime=Level.TimeSeconds;
	}

	function EndState ()
	{
		SetTimer(0.00,False);
		m_lastSeenPawn=None;
		m_iWaitingTime=0;
		m_pawn.m_bAvoidFacingWalls=m_pawn.Default.m_bAvoidFacingWalls;
	}

	function Timer ()
	{
		if ( (m_iFacingTime + m_iWaitingTime < Level.TimeSeconds) &&  !m_pawn.m_bPostureTransition )
		{
			m_iFacingTime=Level.TimeSeconds;
			m_iWaitingTime=GetRandomTweenNum(m_pawn.m_changeOrientationTween);
			ChangeOrientationTo(GetRandomTurn90());
		}
		if ( m_lastSeenPawn != None )
		{
			SeePlayerMgr();
		}
	}

JL0000:
Begin:
	if (  !m_pawn.bWantsToCrouch && m_pawn.bIsCrouched )
	{
		Sleep(0.10);
//		goto JL0000;
	}
	SetTimer(m_AITickTime.m_fResult,True);
}

function SetStatePaceTransition (EStartingPosition ePos)
{
	m_eTransitionPosition=ePos;
	GotoState('FollowingPaceTransition');
}

state FollowingPaceTransition
{
	function BeginState ()
	{
		StopMoving();
	}

Begin:
	if ( m_pawn.m_bIsProne )
	{
//		SetPawnPosition(4);
		Sleep(0.30);
//		SetPace(2);
		if ( m_eTransitionPosition == 0 )
		{
//			SetPawnPosition(0);
			Sleep(0.30);
//			SetPace(4);
		}
	}
	else
	{
		if ( (m_eTransitionPosition == 2) &&  !m_pawn.m_bIsProne )
		{
			if (  !m_pawn.bIsCrouched )
			{
//				SetPawnPosition(4);
				Sleep(0.30);
			}
//			SetPawnPosition(2);
			Sleep(0.40);
//			SetPace(1);
		}
		else
		{
			SetPawnPosition(m_eTransitionPosition);
		}
	}
//	R6SetMovement(m_pawn.m_eMovementPace);
	GotoState('FollowingPawn');
}

function bool SetMovementPace (bool bStartingToMove)
{
	local eMovementPace eOldMovementPace;
	local eMovementPace eNewMovementPace;
	local R6Pawn follow;
	local bool bStopMoving;

	if ( (m_pawnToFollow == None) || m_pawn.m_bPostureTransition )
	{
		return False;
	}
	if ( m_bNeedToRunToCatchUp )
	{
		if ( (m_pawn.m_eMovementPace == 2) || (m_pawn.m_eMovementPace == 3) )
		{
			if (  !m_pawnToFollow.bIsCrouched &&  !m_pawnToFollow.m_bIsProne )
			{
//				m_pawn.m_ePosition=0;
				m_pawn.setCrouch(False);
//				SetPace(5);
			}
			else
			{
				if ( m_pawn.m_eMovementPace == 2 )
				{
//					SetPace(3);
				}
			}
		}
		else
		{
			if ( m_pawn.m_eMovementPace == 4 )
			{
//				SetPace(5);
			}
		}
		return False;
	}
	if ( m_bRunningToward )
	{
//		SetPace(5);
		return False;
	}
//	eOldMovementPace=m_pawn.m_eMovementPace;
	if ( (MoveTarget != None) || bStartingToMove )
	{
		follow=m_pawnToFollow;
		m_iWaitingTime=0;
		if (  !m_pawnToFollow.IsMovingForward() &&  !m_pawn.m_bIsProne )
		{
			if ( m_pawnToFollow.bIsWalking )
			{
				m_bSlowedPace=True;
			}
			else
			{
				follow=None;
				if ( m_pawnToFollow.bIsCrouched )
				{
					m_bSlowedPace=True;
//					SetPace(2);
				}
				else
				{
					m_bSlowedPace=False;
//					SetPace(4);
				}
				return False;
			}
		}
		else
		{
			m_bSlowedPace=False;
		}
	}
	else
	{
		if ( (m_pawn.m_escortedByRainbow != None) && (m_pawn.m_escortedByRainbow.m_aEscortedHostage[0] != None) )
		{
			follow=m_pawnToFollow;
			m_iWaitingTime++;
			if ( m_iWaitingTime >= m_pawn.m_waitingGoCrouchTween.m_fResult )
			{
				follow=None;
				if (  !m_pawn.bIsCrouched &&  !m_pawn.m_bIsProne )
				{
//					SetPawnPosition(4);
				}
			}
		}
		else
		{
			return False;
		}
	}
	if ( follow != None )
	{
//		SetPace(follow.m_eMovementPace);
	}
	if ( eOldMovementPace != m_pawn.m_eMovementPace )
	{
		if ( (m_pawn.m_eMovementPace == 1) &&  !m_pawn.m_bIsProne )
		{
//			SetPace(eOldMovementPace);
//			SetStatePaceTransition(2);
			return True;
		}
		else
		{
			if ( m_pawn.m_bIsProne && (m_pawn.m_eMovementPace != 1) )
			{
				if ( (m_pawn.m_eMovementPace == 3) || (m_pawn.m_eMovementPace == 2) )
				{
//					SetPace(eOldMovementPace);
//					SetStatePaceTransition(4);
				}
				else
				{
//					SetPace(eOldMovementPace);
//					SetStatePaceTransition(0);
				}
				return True;
			}
		}
		if ( (m_pawn.m_eMovementPace == 2) || (m_pawn.m_eMovementPace == 3) )
		{
//			SetPawnPosition(4);
			bStopMoving=True;
		}
		else
		{
			if ( m_pawn.m_eMovementPace != 1 )
			{
//				m_pawn.m_ePosition=0;
				m_pawn.setCrouch(False);
			}
		}
		if ( (m_pawn.m_eMovementPace == 2) || (m_pawn.m_eMovementPace == 4) )
		{
			if ( (VSize(m_pawnToFollow.Location - Pawn.Location) > c_iDistanceToStartToRun) && (m_pawn.m_eHealth != 1) )
			{
				m_bNeedToRunToCatchUp=True;
				if ( m_pawn.m_eMovementPace == 2 )
				{
//					SetPace(3);
				}
				else
				{
//					SetPace(5);
				}
			}
		}
//		R6SetMovement(m_pawn.m_eMovementPace);
		return bStopMoving;
	}
	return False;
}

function FollowPawnFailed ()
{
	ResetThreatInfo("FollowPawnFailed");
	Order_StayHere(False);
	ReturnToNormalState(True);
}

state FollowingPawn
{
	function BeginState ()
	{
		if ( m_pawn.m_bCivilian || m_pawn.m_bPoliceManMp1 )
		{
			CivInit();
		}
		else
		{
			MoveTarget=None;
			Focus=None;
			m_lastSeenPawn=None;
			SetFreed(True);
			m_bSlowedPace=False;
		}
	}

	function EndState ()
	{
		SetTimer(0.00,False);
		Focus=None;
	}

	event bool NotifyBump (Actor Other)
	{
		m_lastUpdatePaceTime=0;
		m_bFollowIncreaseDistance=True;
		return Super.NotifyBump(Other);
	}

	function Timer ()
	{
		local bool bUpdateMove;
		local bool bFound;
		local R6Pawn P;
		local R6RainbowTeam Team;
		local float fSleep;
		local bool bCanWalkTo;

		if ( m_lastSeenPawn != None )
		{
			SeePlayerMgr();
		}
		if ( m_bStopDoTransition || m_pawn.m_bPostureTransition || m_r6pawn.m_bIsClimbingLadder || (Physics == 2) || (Physics == 12) )
		{
			return;
		}
		if ( Level.TimeSeconds - m_lastUpdatePaceTime > m_pawn.m_updatePaceTween.m_fResult )
		{
			if ( SetMovementPace(False) )
			{
				m_bStopDoTransition=True;
				StopMoving();
				Focus=None;
				return;
			}
			else
			{
				m_lastUpdatePaceTime=Level.TimeSeconds;
				GetRandomTweenNum(m_pawn.m_updatePaceTween);
			}
		}
		if ( (m_pawnToFollow == None) || (MoveTarget == None) )
		{
			return;
		}
		bUpdateMove=False;
		if ( m_bRunningToward &&  !m_pawnToFollow.IsAlive() )
		{
			m_pawnToFollow=R6Rainbow(m_pawnToFollow).Escort_FindRainbow(m_pawn);
			if ( m_pawnToFollow == None )
			{
				m_bLatentFnStopped=True;
			}
			else
			{
				m_pawnToFollow=R6Rainbow(m_pawnToFollow).Escort_GetPawnToFollow(True);
			}
			bUpdateMove=True;
		}
		else
		{
			if ( CanStopMoving(False) )
			{
				bUpdateMove=True;
				m_bLatentFnStopped=True;
				m_lastUpdatePaceTime=Level.TimeSeconds;
				m_bNeedToRunToCatchUp=False;
				if ( m_bRunningToward )
				{
					m_bRunToRainbowSuccess=True;
				}
			}
			else
			{
				if ( MoveTarget.IsA('R6Pawn') && (MoveTarget != m_pawnToFollow) )
				{
					bUpdateMove=True;
				}
			}
		}
		if ( bUpdateMove )
		{
			MoveTarget=None;
		}
	}

Begin:
	Sleep(RandRange(0.10,0.50));
JL0013:
	if ( m_pawn.m_bPostureTransition )
	{
		Sleep(0.10);
//		goto JL0013;
	}
	if ( m_bRunningToward &&  !m_pawn.isStanding() || (m_pawn.m_ePosition == 3) || (m_pawn.m_ePosition == 1) || m_pawn.isStandingHandUp() )
	{
//		SetPawnPosition(0);
JL00A1:
		if (  !m_pawn.m_bPostureTransition )
		{
			Sleep(0.10);
//			goto JL00A1;
		}
JL00C0:
		if ( m_pawn.m_bPostureTransition )
		{
			Sleep(0.10);
//			goto JL00C0;
		}
	}
	if ( m_bRunningToward )
	{
		m_pawn.m_escortedByRainbow=GetRainbowWhoEscortThisPawn(m_pawnToFollow);
	}
	m_bRunToRainbowSuccess=False;
	m_bNeedToRunToCatchUp=False;
	m_bStopDoTransition=False;
MovingSetDefault:
	m_lastUpdatePaceTime=Level.TimeSeconds;
	SetTimer(m_AITickTime.m_fMin,True);
	m_pawn.bCanWalkOffLedges=m_pawn.Default.bCanWalkOffLedges;
Moving:
	if ( m_bStopDoTransition )
	{
		Focus=None;
		StopMoving();
		m_bStopDoTransition=False;
JL0179:
		if ( m_pawn.m_bPostureTransition )
		{
			Sleep(0.10);
//			goto JL0179;
		}
	}
WaitForClimbing:
	if ( m_pawn.m_Ladder != None )
	{
		StopMoving();
		Disable('Timer');
		if ( (Abs(m_pawnToFollow.Location.Z - Pawn.Location.Z) < 80) || m_pawnToFollow.m_bIsClimbingLadder )
		{
			Sleep(0.50);
			if ( m_pawn.m_escortedByRainbow != None )
			{
				m_pawn.m_escortedByRainbow.Escort_UpdateCloserToLead();
			}
			if ( actorReachable(m_pawnToFollow) )
			{
				m_pawn.m_Ladder=None;
				Enable('Timer');
				goto ('EndClimbLadder');
			}
			goto ('WaitForClimbing');
		}
		else
		{
			FindPathToward(m_pawnToFollow,True);
			if (  !RouteCacheWithOtherLadder(m_pawn.m_Ladder) || actorReachable(m_pawnToFollow) )
			{
				m_pawn.m_Ladder=None;
				Enable('Timer');
				goto ('EndClimbLadder');
			}
			NextLabel='None';
			MoveTarget=m_pawn.m_Ladder;
//			R6PreMoveToward(MoveTarget,MoveTarget,4);
			MoveToward(MoveTarget);
			if ( m_eMoveToResult == 1 )
			{
				if ( (m_pawn.m_Ladder != None) &&  !R6LadderVolume(m_pawn.m_Ladder.MyLadder).IsAvailable(Pawn) )
				{
					FindNearbyWaitSpot(m_pawn.m_Ladder,m_vTargetPosition);
					m_pawn.m_Ladder=None;
					if ( m_pawn.bIsCrouched || m_pawn.m_bIsProne )
					{
//						R6PreMoveTo(m_vTargetPosition,Location,2);
					}
					else
					{
//						R6PreMoveTo(m_vTargetPosition,Location,4);
					}
					MoveToPosition(m_vTargetPosition,rotator(Location - m_vTargetPosition));
					StopMoving();
					Sleep(0.50);
					goto ('WaitForClimbing');
				}
				MoveTarget=m_pawn.m_Ladder;
				if ( CanClimbLadders(m_pawn.m_Ladder) )
				{
					NextState=GetStateName();
					GotoState('ApproachLadder');
				}
			}
			Sleep(0.50);
			goto ('WaitForClimbing');
		}
	}
EndClimbLadder:
	if (  !CanStopMoving(True) )
	{
		m_bFollowIncreaseDistance=False;
		m_lastUpdatePaceTime=Level.TimeSeconds;
		if ( SetMovementPace(True) )
		{
			m_bStopDoTransition=True;
			StopMoving();
			Focus=None;
			goto ('Moving');
		}
		m_bLatentFnStopped=False;
		if (  !actorReachable(m_pawnToFollow) )
		{
			goto ('bLocked');
		}
		else
		{
			MoveTarget=m_pawnToFollow;
		}
	}
	else
	{
		if ( m_bRunningToward )
		{
			m_bRunToRainbowSuccess=True;
			goto ('endRunning');
		}
	}
	if ( MoveTarget != None )
	{
		MoveTarget=m_pawnToFollow;
		Destination=MoveTarget.Location + Normal(MoveTarget.Location - Pawn.Location) *  -105;
		Focus=None;
		FocalPoint=MoveTarget.Location;
		MoveTo(Destination);
		if ( m_bLatentFnStopped )
		{
			if ( (m_pawnToFollow == None) || m_bRunToRainbowSuccess )
			{
				goto ('endRunning');
			}
			StopMoving();
		}
	}
	else
	{
		if ( m_pawnToFollow.m_bIsClimbingLadder )
		{
			if ( m_pawn.m_escortedByRainbow != None )
			{
				m_pawn.m_escortedByRainbow.Escort_UpdateCloserToLead();
			}
			Sleep(0.50);
		}
		if (  !m_pawn.IsStationary() )
		{
			Pawn.Acceleration=vect(0.00,0.00,0.00);
			Pawn.Velocity=vect(0.00,0.00,0.00);
		}
		Sleep(m_AITickTime.m_fMin);
	}
	goto ('Moving');
bLocked:
	if ( 33.00 < Abs(m_pawnToFollow.Location.Z - m_pawnToFollow.CollisionHeight - m_pawn.Location.Z - m_pawn.CollisionHeight) )
	{
		m_pawn.bCanWalkOffLedges=True;
	}
	MoveTarget=None;
	if ( FindBestPathToward(m_pawnToFollow,True) )
	{
		if ( MoveTarget == m_pawnToFollow )
		{
			Destination=MoveTarget.Location + Normal(MoveTarget.Location - Pawn.Location) *  -105;
			if ( pointReachable(Destination) )
			{
				Focus=None;
				FocalPoint=MoveTarget.Location;
				MoveTo(Destination);
				StopMoving();
				MoveTarget=None;
			}
			else
			{
				goto ('UseMoveToward');
			}
		}
		else
		{
UseMoveToward:
			SetTimer(0.00,False);
//			R6PreMoveToward(MoveTarget,MoveTarget,m_pawn.m_eMovementPace);
			if ( (VSize(m_pawnToFollow.Location - Pawn.Location) > c_iDistanceToStartToRun) && (m_pawn.m_eHealth != 1) )
			{
				if ( m_pawn.m_eMovementPace == 4 )
				{
//					SetPace(5);
				}
				else
				{
					if ( (m_pawn.m_eMovementPace == 2) || (m_pawn.m_eMovementPace == 1) )
					{
//						SetPace(3);
					}
				}
			}
			MoveToward(MoveTarget);
		}
	}
	if ( m_pawn.m_Ladder != None )
	{
		m_bool=actorReachable(m_pawn.m_Ladder);
	}
	else
	{
		m_bool=actorReachable(m_pawnToFollow);
	}
	if ( (MoveTarget == None) && (m_pawn.m_Ladder == None) )
	{
		Destination=m_pawnToFollow.Location + Normal(m_pawnToFollow.Location - Pawn.Location) *  -105;
		MoveTo(Destination);
		StopMoving();
		Sleep(0.50);
		if (  !m_bool && (FindPathTo(m_pawnToFollow.Location,True) == None) )
		{
			goto ('bLocked');
		}
		else
		{
			goto ('MovingSetDefault');
		}
	}
	else
	{
		if (  !m_bool )
		{
			if ( (MoveTarget != None) && (m_pawn.m_Ladder == None) && MoveTarget.IsA('R6Ladder') )
			{
				if ( (DistanceTo(MoveTarget) < 50) && (Abs(MoveTarget.Location.Z - Pawn.Location.Z) > 40) )
				{
					m_pawn.m_Ladder=R6Ladder(MoveTarget).m_pOtherFloor;
					FindNearbyWaitSpot(R6Ladder(MoveTarget).m_pOtherFloor,m_vTargetPosition);
					m_pawn.m_Ladder=None;
//					R6PreMoveTo(m_vTargetPosition,Location,4);
					MoveToPosition(m_vTargetPosition,rotator(Location - m_vTargetPosition));
					StopMoving();
					if ( m_pawn.m_escortedByRainbow != None )
					{
						m_pawn.m_escortedByRainbow.Escort_UpdateCloserToLead();
					}
				}
			}
			goto ('bLocked');
		}
		else
		{
			MoveTarget=m_pawnToFollow;
			goto ('MovingSetDefault');
		}
	}
endRunning:
	if ( m_bRunningToward )
	{
		StopMoving();
		m_bRunningToward=False;
		if ( m_bRunToRainbowSuccess )
		{
			ResetThreatInfo("runningToward success");
			Order_FollowMe(m_pawnToFollow,False);
		}
		else
		{
			ResetThreatInfo("runningToward failed");
			ReturnToNormalState(True);
		}
	}
}

event bool CanOpenDoor (R6IORotatingDoor Door)
{
	return  !Door.m_bIsDoorLocked;
}

event OpenDoorFailed ()
{
	if ( m_pawn.m_bCivilian )
	{
		GotoState('CivStayHere');
	}
	else
	{
		if ( m_pawn.m_bFreed )
		{
			FollowPawnFailed();
		}
		else
		{
//			SetStateGuarded(1,m_mgr.0);
		}
	}
}

function SetStateRunForCover (Pawn runAwayOfPawn, name successState, name failureState, Actor Grenade)
{
	Enemy=runAwayOfPawn;
	m_runAwayOfGrenade=Grenade;
	m_runForCoverStateToGoOnSuccess=successState;
	m_runForCoverStateToGoOnFailure=failureState;
	if ( IsRunForCoverPossible(Enemy) )
	{
//		ProcessPlaySndInfo(m_mgr.3);
		SetThreatState('RunForCover');
		GotoState(m_threatInfo.m_state);
	}
	else
	{
		ResetThreatInfo("run for cover failed ");
		m_runAwayOfGrenade=None;
		GotoState(m_runForCoverStateToGoOnFailure);
	}
}

function bool IsAwayOfGrenade (Actor Grenade)
{
	if ( VSize(Pawn.Location - Grenade.Location) > c_iRunForCoverOfGrenadeMinDist )
	{
		return True;
	}
	if ( FastTrace(Grenade.Location) )
	{
		return False;
	}
	else
	{
		return True;
	}
}

function bool IsRunForCoverPossible (Pawn runAwayOf)
{
	local Pawn aPreviousEnemy;
	local bool bResult;

	aPreviousEnemy=Enemy;
	Enemy=runAwayOf;
	bResult=MakePathToRun();
	Enemy=aPreviousEnemy;
	return bResult;
}

state RunForCover
{
	function BeginState ()
	{
		if (  !m_pawn.isStanding() )
		{
//			SetPawnPosition(0);
		}
		SetTimer(m_AITickTime.m_fResult,True);
		m_lastSeenPawn=None;
		Focus=None;
	}

	function EndState ()
	{
		SetTimer(0.00,False);
		m_runAwayOfGrenade=None;
	}

	function Timer ()
	{
		if ( m_lastSeenPawn != None )
		{
			SeePlayerMgr();
		}
	}

	function StopRunForCover ()
	{
		StopMoving();
		Enemy=None;
		m_runAwayOfGrenade=None;
		ResetThreatInfo("StopRunForCover");
	}

	function EnemyNotVisible ()
	{
		if ( m_runAwayOfGrenade != None )
		{
			if ( IsAwayOfGrenade(m_runAwayOfGrenade) )
			{
				StopRunForCover();
				GotoState(m_runForCoverStateToGoOnSuccess);
			}
			return;
		}
		if ( Level.TimeSeconds - LastSeenTime > c_iEnemyNotVisibleTime )
		{
			if ( (R6Pawn(Enemy) != None) && (R6Pawn(Enemy).Controller != None) && R6Pawn(Enemy).Controller.CanSee(Pawn) )
			{
				LastSeenTime=Level.TimeSeconds;
				return;
			}
			StopRunForCover();
			GotoState(m_runForCoverStateToGoOnSuccess);
		}
	}

	function bool IsRunForCoverSuccessfull ()
	{
		local bool bResult;

		if ( m_runAwayOfGrenade != None )
		{
			bResult=IsAwayOfGrenade(m_runAwayOfGrenade);
		}
		else
		{
			if ( Enemy != None )
			{
				bResult= !R6Pawn(Enemy).Controller.CanSee(Pawn);
			}
			else
			{
				bResult=True;
			}
		}
		return bResult;
	}

	event OpenDoorFailed ()
	{
		StopRunForCover();
		GotoState(m_runForCoverStateToGoOnFailure);
	}

JL0000:
Begin:
	if ( m_pawn.m_bPostureTransition )
	{
		Sleep(0.10);
//		goto JL0000;
	}
//	SetPace(5);
ChooseDestination:
	if ( Enemy == None )
	{
		StopRunForCover();
		GotoState(m_runForCoverStateToGoOnSuccess);
	}
	if (  !IsRunForCoverPossible(Enemy) )
	{
		if ( IsRunForCoverSuccessfull() )
		{
			StopRunForCover();
			GotoState(m_runForCoverStateToGoOnSuccess);
		}
		else
		{
			StopRunForCover();
			GotoState(m_runForCoverStateToGoOnFailure);
		}
	}
RunToDestination:
//	FollowPath(m_pawn.m_eMovementPace,'ReturnToPath',False);
	goto ('ChooseDestination');
ReturnToPath:
//	FollowPath(m_pawn.m_eMovementPace,'ReturnToPath',True);
	goto ('ChooseDestination');
}

function bool IsBumpBackUpStateFinish ()
{
	local R6Pawn aBumpPawn;

	aBumpPawn=R6Pawn(m_BumpedBy);
	if ( m_fLastBump + 4.00 < Level.TimeSeconds )
	{
		return True;
	}
	Focus=None;
	if ( aBumpPawn.Velocity == vect(0.00,0.00,0.00) )
	{
		return True;
	}
	if ( DistanceTo(m_BumpedBy) > c_iDistanceBumpBackUp )
	{
		return True;
	}
	if ( (m_pawnToFollow != None) && (DistanceTo(m_pawnToFollow) > c_iDistanceCatchUp) )
	{
		return True;
	}
	return False;
}

function BumpBackUpStateFinished ()
{
//	SetStateGuarded(1,m_mgr.0);
}

function CivInit ()
{
	if ( m_pawn.m_escortedByRainbow != None )
	{
		StopFollowingPawn(False);
	}
//	m_pawn.SetStandWalkingAnim(0,True);
//	m_pawn.m_eHandsUpType=0;
	m_pawn.m_bCivilian=True;
	m_pawn.setFrozen(False);
//	SetPawnPosition(m_pawn.m_ePosition);
	switch (m_pawn.m_eCivPatrol)
	{
/*		case 1:
		GotoState('CivPatrolPath');
		break;
		case 2:
		GotoState('CivPatrolArea');
		break;
		default:
		GotoState('CivGuardPoint');*/
	}
}

function ResetThreatInfo (string sz)
{
//	m_threatInfo=m_mgr.getDefaulThreatInfo();
}

function SetThreatState (name threatState)
{
	m_threatInfo.m_state=threatState;
}

function name GetThreatGroupName ()
{
	if ( m_pawn.m_bCivilian )
	{
		return m_mgr.c_ThreatGroup_HstBait;
	}
	else
	{
		if ( m_pawn.m_bFreed && (m_pawn.m_escortedByRainbow != None) )
		{
			return m_mgr.c_ThreatGroup_HstEscorted;
		}
		else
		{
			if ( m_pawn.m_ePersonality == 3 )
			{
				return m_mgr.c_ThreatGroup_HstBait;
			}
			else
			{
				if ( m_pawn.m_bFreed )
				{
					return m_mgr.c_ThreatGroup_HstFreed;
				}
				else
				{
					return m_mgr.c_ThreatGroup_HstGuarded;
				}
			}
		}
	}
}

function ProcessThreat (Actor P, ENoiseType eType)
{
	local R6Pawn R6Pawn;
	local int iDistanceFromThreat;
	local ThreatInfo ThreatInfo;
	local bool bNewThreat;
	local name stateName;
	local name GroupName;

	GroupName=GetThreatGroupName();
	if ( GroupName != m_threatGroupName )
	{
		ResetThreatInfo("new threat group: " $ string(GroupName));
		m_threatGroupName=GroupName;
	}
	bNewThreat=False;
/*	if ( m_mgr.GetThreatInfoFromThreat(GroupName,m_pawn,P,eType,ThreatInfo) )
	{
		if ( ThreatInfo.m_iThreatLevel > m_threatInfo.m_iThreatLevel )
		{
			m_threatInfo=ThreatInfo;
			bNewThreat=True;
		}
	}*/
	if ( bNewThreat )
	{
		stateName=m_mgr.GetReaction(GroupName,m_threatInfo.m_iThreatLevel,Roll(100));
		if ( 'BaitPlayReaction' == stateName )
		{
//			ProcessPlaySndInfo(m_mgr.6);
			ResetThreatInfo("BaitPlayReaction");
		}
		else
		{
			if ( 'GuardedPlayReaction' == stateName )
			{
				if ( m_iPlayReaction1 == 0 )
				{
					m_iPlayReaction1=1;
					m_iPlayReaction2=RandRange(0.00,2.00);
				}
				ResetThreatInfo("GuardedPlayReaction");
			}
			else
			{
				if ( 'HearShootingReaction' == stateName )
				{
//					ProcessPlaySndInfo(m_mgr.1);
					ResetThreatInfo("HearShootingReaction");
				}
				else
				{
					if ( stateName != m_mgr.m_noReactionName )
					{
						GotoState(stateName);
					}
				}
			}
		}
	}
}

state Civilian
{
	ignores  SeePlayerMgr;

	function BeginState ()
	{
	}

	function EndState ()
	{
		StopMoving();
	}

}

state CivPatrolArea extends Civilian
{
	function BeginState ()
	{
	}

Begin:
//	SetPace(4);
AtDestination:
	m_vTargetPosition=m_pawn.m_DZone.FindRandomPointInArea();
	MoveTarget=FindPathTo(m_vTargetPosition,True);
	if ( MoveTarget != None )
	{
//		FollowPathTo(m_vTargetPosition,m_pawn.m_eMovementPace);
	}
	Sleep(GetRandomTweenNum(m_pawn.m_patrolAreaWaitTween));
	FinishAnim();
	goto ('AtDestination');
}

state CivGuardPoint extends Civilian
{
	function BeginState ()
	{
		if ( m_pawn.m_bPoliceManMp1 && m_pawn.m_bPoliceManHasWeapon )
		{
			m_pawn.ServerGivesWeaponToClient("R63rdWeapons.NormalSubMP5A4",1);
			m_pawn.SetToNormalWeapon();
			if ( m_pawn.EngineWeapon == None )
			{
				logX("No weapon!!!!");
			}
			m_pawn.EngineWeapon.GotoState('BringWeaponUp');
			m_pawn.PlayWeaponAnimation();
		}
	}

	function SeePlayer (Pawn P)
	{
		local R6Pawn seen;

		if ( m_pawn.m_bPoliceManMp1 && m_pawn.m_bPoliceManCanSeeRainbows )
		{
			seen=R6Pawn(P);
			if ( seen == None )
			{
				return;
			}
			if ( P.m_ePawnType == 1 )
			{
				m_pawn.PlayAnim(m_pawn.m_NocsSeeRainbowsName);
				GotoState('WaitForSomeTime');
			}
		}
	}

Begin:
	ChangeOrientationTo(m_pawn.m_DZone.Rotation);
	FinishRotation();
}

state WaitForSomeTime
{
Begin:
	Sleep(RandRange(5.00,10.00));
	GotoState('CivGuardPoint');
}

state CivPatrolPath extends Civilian
{
	function BeginState ()
	{
		if ( R6DZonePath(m_pawn.m_DZone) == None )
		{
			GotoState('CivGuardPoint');
		}
	}

	function int GetWaitingTime ()
	{
		local int ITemp;

		ITemp=GetRandomTweenNum(m_pawn.m_patrolAreaWaitTween);
		return Rand(ITemp + 1) + ITemp;
	}

	function int GetFacingTime ()
	{
		local int ITemp;

		ITemp=GetRandomTweenNum(m_pawn.m_changeOrientationTween);
		return Rand(ITemp + 1) + ITemp;
	}

	function bool IsGoingBack ()
	{
		return False;
	}

	function PickDestination ()
	{
		local Rotator R;
		local int iDistance;

		R.Yaw=Rand(32767) * 2;
		iDistance=Rand(m_pawn.m_currentNode.m_fRadius);
//		m_vTargetPosition=m_pawn.m_currentNode.Location + R * iDistance;
	}

	event OpenDoorFailed ()
	{
		m_pawn.m_currentNode=None;
		GotoState('CivPatrolPath');
	}

	function SetToNextNode ()
	{
		local R6DZonePathNode firstnode;
		local R6DZonePath Path;
		local int Index;

		MoveTarget=None;
		firstnode=m_pawn.m_currentNode;
		Path=R6DZonePath(m_pawn.m_DZone);
	JL0034:
		if ( MoveTarget == None )
		{
			if (  !Path.m_bCycle )
			{
				Index=Path.GetNodeIndex(m_pawn.m_currentNode);
				if ( Index == 0 )
				{
					m_pawn.m_bPatrolForward=True;
				}
				if ( Index == Path.m_aNode.Length - 1 )
				{
					m_pawn.m_bPatrolForward=False;
				}
			}
			if ( m_pawn.m_bPatrolForward )
			{
				m_pawn.m_currentNode=Path.GetNextNode(m_pawn.m_currentNode);
			}
			else
			{
				m_pawn.m_currentNode=Path.GetPreviousNode(m_pawn.m_currentNode);
			}
			if ( firstnode == m_pawn.m_currentNode )
			{
				GotoState('CivGuardPoint');
				return;
			}
			MoveTarget=FindPathToward(m_pawn.m_currentNode,True);
			goto JL0034;
		}
	}

Begin:
	if ( m_pawn.m_currentNode == None )
	{
		m_pawn.m_currentNode=R6DZonePath(m_pawn.m_DZone).FindNearestNode(Pawn);
		if ( m_pawn.m_currentNode == None )
		{
			GotoState('CivGuardPoint');
		}
		MoveTarget=FindPathToward(m_pawn.m_currentNode,True);
		if ( MoveTarget == None )
		{
			SetToNextNode();
		}
	}
//	SetPace(4);
FindPathToNode:
	PickDestination();
//	FollowPathTo(m_vTargetPosition,m_pawn.m_eMovementPace);
ReachedTheNode:
	if ( m_pawn.m_currentNode.bDirectional )
	{
		ChangeOrientationTo(GetRandomTurn90());
		FinishRotation();
	}
	if ( m_pawn.m_currentNode.m_bWait )
	{
		m_iWaitingTime=GetWaitingTime();
		m_iFacingTime=GetFacingTime();
		if ( m_iFacingTime < m_iWaitingTime )
		{
			Sleep(m_iFacingTime);
			ChangeOrientationTo(GetRandomTurn90());
			Sleep(m_iWaitingTime - m_iFacingTime);
			FinishRotation();
		}
		else
		{
			Sleep(m_iWaitingTime);
		}
		if ( IsGoingBack() )
		{
			m_pawn.m_bPatrolForward= !m_pawn.m_bPatrolForward;
		}
	}
	SetToNextNode();
	Focus=m_pawn.m_currentNode;
	FinishAnim();
	FinishRotation();
	goto ('FindPathToNode');
}

function Order_ProcessSurrender (Pawn terro)
{
	local name stateName;

	m_terrorist=R6Terrorist(terro);
	if ( m_pawn.m_bCivilian || m_pawn.m_bPoliceManMp1 )
	{
		goto JL007C;
	}
	if ( m_pawn.m_escortedByRainbow == None )
	{
//		ProcessPlaySndInfo(m_mgr.2);
		R6TerroristAI(m_terrorist.Controller).HostageSurrender(self);
	}
JL007C:
}

function SetStateEscorted (R6Pawn escort, Vector Destination, bool bSurrender)
{
	m_escort=escort;
	m_vMoveToDest=Destination;
	m_pawn.setFrozen(False);
	if ( bSurrender )
	{
		SetThreatState('EscortedByEnemy');
		SetFreed(False);
	}
	m_bForceToStayHere=False;
//	SetPace(4);
	m_pawn.m_bEscorted=True;
	GotoState('EscortedByEnemy');
}

state EscortedByEnemy
{
	function BeginState ()
	{
	}

	function EndState ()
	{
		SetTimer(0.00,False);
//		m_pawn.SetStandWalkingAnim(1,False);
	}

	function EscortIsOver (bool bSuccess)
	{
		m_pawn.m_bEscorted=False;
		m_escort=None;
		if ( m_terrorist != None )
		{
			R6TerroristAI(m_terrorist.Controller).EscortIsOver(self,bSuccess);
			m_terrorist=None;
		}
		ResetThreatInfo("EscortIsOver");
		if ( m_pawn.m_bFreed )
		{
			GotoState('Freed');
		}
		else
		{
			if ( IsInCrouchedPosture() )
			{
//				SetStateGuarded(1,m_mgr.0);
			}
			else
			{
//				SetStateGuarded(0,m_mgr.0);
			}
		}
	}

JL0000:
Begin:
	if ( m_pawn.m_bPostureTransition )
	{
		Sleep(0.10);
//		goto JL0000;
	}
	if ( m_pawn.isStandingHandUp() )
	{
//		m_pawn.m_eHandsUpType=0;
		m_pawn.SetAnimTransition(m_mgr.ANIM_eStandHandUpToDown,'None');
	}
	else
	{
		if (  !m_pawn.isStanding() )
		{
//			SetPawnPosition(0);
		}
	}
JL0081:
	if ( m_pawn.m_bPostureTransition )
	{
		Sleep(0.10);
//		goto JL0081;
	}
	if ( m_vMoveToDest == Pawn.Location )
	{
		goto ('StartWaiting');
	}
	if ( m_escort.m_ePawnType == 2 )
	{
//		m_pawn.SetStandWalkingAnim(0,True);
	}
	else
	{
//		m_pawn.SetStandWalkingAnim(1,True);
	}
	MoveTarget=FindPathTo(m_vMoveToDest,True);
	if ( MoveTarget == None )
	{
		EscortIsOver(False);
	}
//	FollowPathTo(m_vMoveToDest,m_pawn.m_eMovementPace);
StartWaiting:
	StopMoving();
	EscortIsOver(True);
}

state CivStayHere extends Civilian
{
	function BeginState ()
	{
		StopMoving();
		ResetThreatInfo("CivStayHere");
	}

}

state GoCivScareToDeath
{
	function BeginState ()
	{
		StopMoving();
//		SetPawnPosition(3);
		m_bForceToStayHere=True;
//		ProcessPlaySndInfo(m_mgr.7);
		SetThreatState('CivScareToDeath');
		GotoState(m_threatInfo.m_state);
	}

}

state CivScareToDeath extends Civilian
{
	function BeginState ()
	{
	}

Begin:
	Sleep(GetRandomTweenNum(m_scareToDeathTween));
	ResetThreatInfo("CivScareToDeath is over");
	m_bForceToStayHere=False;
//	SetPawnPosition(1);
	GotoState('CivStayHere');
}

state CivRunForCover
{
	function BeginState ()
	{
		if ( m_pawn.m_bPoliceManMp1 )
		{
			GotoState('CivGuardPoint');
		}
		else
		{
			GotoState('GoCivScareToDeath');
		}
	}

}

state CivRunTowardRainbow
{
	function BeginState ()
	{
		if ( m_pawn.m_bCivilian || m_pawn.m_bPoliceManMp1 )
		{
			CivInit();
		}
		else
		{
//			SetStateFollowingPawn(R6Pawn(m_threatInfo.m_pawn),True,m_mgr.4);
		}
	}

}

state CivSurrender
{
	function BeginState ()
	{
		if ( m_pawn.m_bCivilian || m_pawn.m_bPoliceManMp1 )
		{
			CivInit();
		}
		else
		{
			if ( m_terrorist != None )
			{
//				ProcessPlaySndInfo(m_mgr.2);
				R6TerroristAI(m_terrorist.Controller).HostageSurrender(self);
			}
			else
			{
//				SetStateGuarded(5,m_mgr.2);
			}
		}
	}

}

function string Order_GetLog (OrderInfo Info)
{
	local string szOutput;
	local string szOrder;
	local string szPawn;

	switch (Info.m_eOrder)
	{
/*		case 1:
		szOrder="follow";
		break;
		case 2:
		szOrder="stay";
		break;
		case 3:
		szOrder="surrender";
		break;
		case 4:
		szOrder="extraction";
		break;
		default:
		szOrder="none";
		break;*/
	}
	if ( Info.m_pawn1 != None )
	{
		szPawn="" $ string(Info.m_pawn1.Name);
	}
	else
	{
		szPawn="none";
	}
	szOutput="Order: " $ szOrder $ " pawn: " $ szPawn $ " time: " $ string(Info.m_fTime);
	return szOutput;
}

function OrderInfo Order_Pop ()
{
	local int i;
	local int LastIndex;
	local OrderInfo OrderInfo;

	if ( m_iNbOrder == 0 )
	{
		return OrderInfo;
	}
	OrderInfo=m_aOrderInfo[0];
	LastIndex=2 - 1;
	i=0;
JL0030:
	if ( i < LastIndex )
	{
		m_aOrderInfo[i]=m_aOrderInfo[i + 1];
		i++;
		goto JL0030;
	}
//	m_aOrderInfo[LastIndex].m_eOrder=0;
	m_aOrderInfo[LastIndex].m_fTime=0.00;
	m_aOrderInfo[LastIndex].m_pawn1=None;
	m_iNbOrder--;
	return OrderInfo;
}

function Order_Add (eHostageOrder eOrder, R6Pawn aPawn, optional bool bOrderedByRainbow, optional Actor anActor)
{
	local OrderInfo OrderInfo;

JL0000:
	if ( m_iNbOrder >= 2 )
	{
		OrderInfo=Order_Pop();
		goto JL0000;
	}
	m_aOrderInfo[m_iNbOrder].m_eOrder=eOrder;
	m_aOrderInfo[m_iNbOrder].m_pawn1=aPawn;
	m_aOrderInfo[m_iNbOrder].m_fTime=Level.TimeSeconds;
	m_aOrderInfo[m_iNbOrder].m_bOrderedByRainbow=bOrderedByRainbow;
	m_aOrderInfo[m_iNbOrder].m_actor=anActor;
	m_iNbOrder++;
	if (  !m_pawn.m_bPostureTransition )
	{
		Order_Process();
	}
}

function bool IsInTemporaryState ()
{
	return m_pawn.m_bPostureTransition || m_r6pawn.m_bIsClimbingLadder || (Physics == 2) || (Physics == 12) || IsInState('BumpBackUp') || IsInState('OpenDoor');
}

function Order_Process ()
{
	local OrderInfo OrderInfo;

	if ( (m_iNbOrder == 0) || IsInTemporaryState() || m_pawn.m_bExtracted || m_pawn.m_bCivilian )
	{
		return;
	}
	OrderInfo=Order_Pop();
	switch (OrderInfo.m_eOrder)
	{
/*		case 1:
		Order_ProcessFollowMe(OrderInfo.m_pawn1,OrderInfo.m_bOrderedByRainbow);
		break;
		case 2:
		Order_ProcessStayHere(OrderInfo.m_bOrderedByRainbow);
		break;
		case 3:
		Order_ProcessSurrender(R6Terrorist(OrderInfo.m_pawn1));
		break;
		case 4:
		Order_ProcessGotoExtraction(OrderInfo.m_actor);
		break;
		default:       */
	}
}

function Order_GotoExtraction (Actor aZone)
{
//	Order_Add(4,None,False,aZone);
}

function Order_StayHere (bool bOrderedByRainbow)
{
//	Order_Add(2,None,bOrderedByRainbow);
}

function bool Order_canFollowMe ()
{
	return m_pawn.m_escortedByRainbow == None;
}

function Order_FollowMe (R6Pawn aPawn, bool bOrderedByRainbow)
{
//	Order_Add(1,aPawn,bOrderedByRainbow);
}

function Order_Surrender (R6Pawn aPawn)
{
//	Order_Add(3,aPawn);
}

state OpenDoor
{
	ignores  HearNoise, SeePlayer, SeePlayerMgr;

}

function bool RouteCacheWithOtherLadder (R6Ladder Ladder)
{
	local int i;
	local R6Ladder testLadder;

JL0000:
	if ( (i < 16) && (RouteCache[i] != None) )
	{
		testLadder=R6Ladder(RouteCache[i]);
		if ( (testLadder != None) && (Ladder.m_pOtherFloor == testLadder) )
		{
			return True;
		}
		i++;
		goto JL0000;
	}
	return False;
}

function CheckNeedToClimbLadder ()
{
	if ( m_pawnToFollow == None )
	{
		return;
	}
	FindPathToward(m_pawnToFollow,True);
	if ( (m_pawn.m_Ladder != None) &&  !RouteCacheWithOtherLadder(m_pawn.m_Ladder) || actorReachable(m_pawnToFollow) )
	{
		m_pawn.m_Ladder=None;
		GotoState(NextState,NextLabel);
	}
}

function bool CanClimbLadders (R6Ladder Ladder)
{
	local int i;

	if (  !R6LadderVolume(Ladder.MyLadder).IsAvailable(Pawn) )
	{
		return False;
	}
	if ( m_pawn.m_bAutoClimbLadders && (MoveTarget == Ladder) )
	{
JL004C:
		if ( (i < 16) && (RouteCache[i] != None) )
		{
			if ( RouteCache[i] == Ladder.m_pOtherFloor )
			{
				return True;
			}
			i++;
			goto JL004C;
		}
	}
	return False;
}

function PlaySoundAffectedByGrenade (EGrenadeType eType)
{
	switch (eType)
	{
		case GTYPE_TearGas:
		m_VoicesManager.PlayHostageVoices(m_pawn,HV_EntersGas);
		break;
		case GTYPE_Smoke:
		m_VoicesManager.PlayHostageVoices(m_pawn,HV_EntersSmoke);
		break;
		default:
	}
}

function AIAffectedByGrenade (Actor aGrenade, EGrenadeType eType)
{
	if ( eType == GTYPE_Smoke )
	{
		goto JL0062;
	}
	if ( eType == GTYPE_TearGas )
	{
		m_pawn.SetNextPendingAction(PENDING_Coughing);
	}
	else
	{
		if ( (eType == GTYPE_FlashBang) || (eType == GTYPE_BreachingCharge) )
		{
			SetStateReactToGrenade(GetStateName());
		}
	}
JL0062:
}

function PlaySoundDamage (Pawn instigatedBy)
{
	if ( (m_pawn.m_eHealth <= 1) &&  !m_pawn.m_bPoliceManMp1 )
	{
//		ProcessPlaySndInfo(m_mgr.10);
	}
	if ( m_pawn.IsFriend(instigatedBy) && m_bFirstTimeClarkComment )
	{
		if ( m_pawn.m_eHealth <= 1 )
		{
			m_bFirstTimeClarkComment=False;
			m_VoicesManager.PlayHostageVoices(R6Pawn(instigatedBy),HV_ClarkReprimand);
		}
	}
	else
	{
		if ( instigatedBy.Controller != None )
		{
			instigatedBy.Controller.PlaySoundInflictedDamage(m_pawn);
		}
	}
}

function SetStateReactToGrenade (name stateToReturn)
{
	if ( stateToReturn != 'ReactToGrenade' )
	{
		m_reactToGrenadeStateToReturn=stateToReturn;
	}
	GotoState('ReactToGrenade');
}

state ReactToGrenade
{
	function BeginState ()
	{
	}

Begin:
	Sleep(RandRange(0.10,0.30));
	if ( (m_pawn.m_eEffectiveGrenade == 3) || (m_pawn.m_eEffectiveGrenade == 4) )
	{
		StopMoving();
//		m_pawn.SetNextPendingAction(PENDING_Blinded);
		GetRandomTweenNum(m_stayBlindedTweenTime);
		Sleep(m_stayBlindedTweenTime.m_fResult);
		goto ('End');
	}
End:
	GotoState(m_reactToGrenadeStateToReturn);
}

state GoHstFreedButSeeEnemy
{
	function BeginState ()
	{
		if ( IsInCrouchedPosture() )
		{
//			SetStateGuarded(1,m_mgr.2);
		}
		else
		{
//			SetStateGuarded(0,m_mgr.2);
		}
		ResetThreatInfo("GoHstFreedButSeeEnemy");
	}

}

state GoHstRunTowardRainbow
{
	function BeginState ()
	{
//		SetStateFollowingPawn(R6Pawn(m_threatInfo.m_pawn),True,m_mgr.5);
	}

}

state GoHstRunForCover
{
	function BeginState ()
	{
		if ( m_pawn.m_bPoliceManMp1 )
		{
			CivInit();
		}
		else
		{
			SetFreed(True);
			SetStateRunForCover(m_threatInfo.m_pawn,'Freed','Guarded_foetus',m_threatInfo.m_actorExt);
		}
	}

}

state DbgHostage
{
	function BeginState ()
	{
		StopMoving();
	}

}

function SetStateExtracted ()
{
	m_pawn.m_bExtracted=True;
	m_iNbOrder=0;
	ResetThreatInfo("extracted");
	if ( (Rand(2) == 1) || m_pawn.m_bCivilian )
	{
//		SetPawnPosition(0);
	}
	else
	{
//		SetPawnPosition(4);
	}
	GotoState('Extracted');
}

function bool ProcessPlaySndInfo (int iSndEvent)
{
	local int i;
	local int iSndIndex;
	local bool bPlay;

	if ( m_pawn.m_bCivilian && (iSndEvent == 6) )
	{
		if ( m_pawn.m_bPoliceManMp1 )
		{
			return True;
		}
		iSndEvent=1;
	}
	i=iSndEvent;
	if ( m_aPlaySndInfo[i].m_iLastTime == 0 )
	{
		bPlay=True;
	}
	else
	{
		if ( Level.TimeSeconds - m_aPlaySndInfo[i].m_iLastTime > m_aPlaySndInfo[i].m_iInBetweenTime )
		{
			bPlay=True;
		}
	}
	if ( bPlay )
	{
		m_aPlaySndInfo[i].m_iLastTime=Level.TimeSeconds;
		iSndIndex=m_mgr.GetHostageSndEvent(iSndEvent,m_pawn);
//		m_VoicesManager.PlayHostageVoices(m_pawn,m_mgr.GetHostageVoices(iSndIndex));
	}
	else
	{
	}
	return bPlay;
}

state GotoExtraction
{
	function BeginState ()
	{
		if (  !m_pawn.isStanding() )
		{
//			SetPawnPosition(0);
		}
		Focus=None;
	}

JL0000:
Begin:
	if ( m_pawn.m_bPostureTransition )
	{
		Sleep(0.10);
//		goto JL0000;
	}
	if ( m_pawn.m_escortedByRainbow != None )
	{
		Sleep(0.30);
		StopFollowingPawn(False);
//		m_pawn.SetStandWalkingAnim(1,True);
	}
RunToDestination:
	Focus=None;
	if ( m_vMoveToDest != m_pGotoToExtractionZone.Location )
	{
		m_vMoveToDest=m_pGotoToExtractionZone.Location;
	}
	if ( VSize(Pawn.Location - m_vMoveToDest) < 100 )
	{
		StopMoving();
		GotoState('Freed');
	}
//	SetPace(5);
	m_vTargetPosition=m_vMoveToDest;
	if ( pointReachable(m_vTargetPosition) )
	{
		Focus=None;
		FocalPoint=m_vTargetPosition;
		MoveTo(m_vTargetPosition);
		StopMoving();
		MoveTarget=None;
	}
	else
	{
		MoveTarget=FindPathTo(m_vTargetPosition,True);
		if ( MoveTarget != None )
		{
//			FollowPath(m_pawn.m_eMovementPace,'ReturnToPath',False);
		}
		else
		{
//			R6PreMoveToward(m_pGotoToExtractionZone,m_pGotoToExtractionZone,m_pawn.m_eMovementPace);
			MoveToward(m_pGotoToExtractionZone);
			Sleep(1.00);
		}
	}
	goto ('RunToDestination');
ReturnToPath:
//	FollowPath(m_pawn.m_eMovementPace,'ReturnToPath',True);
	goto ('RunToDestination');
}

state Extracted
{
	ignores  R6DamageAttitudeTo;

	function BeginState ()
	{
		m_pawn.m_bAvoidFacingWalls=True;
		Focus=None;
		m_bIgnoreBackupBump=False;
	}

	function AIAffectedByGrenade (Actor aGrenade, EGrenadeType eType)
	{
	}

	function Timer ()
	{
		m_iWaitingTime=GetRandomTweenNum(m_pawn.m_changeOrientationTween);
		SetTimer(m_iWaitingTime,False);
		ChangeOrientationTo(GetRandomTurn90());
	}

Begin:
	Sleep(Rand(2));
	StopMoving();
	m_bForceToStayHere=True;
	StopFollowingPawn(False);
	m_iWaitingTime=GetRandomTweenNum(m_pawn.m_changeOrientationTween);
	SetTimer(m_iWaitingTime,False);
}

defaultproperties
{
    c_iDistanceMax=190
    c_iDistanceCatchUp=160
    c_iDistanceToStartToRun=350
    c_iCowardModifier=-40
    c_iBraveModifier=40
    c_iWoundedModifier=20
    c_iGasModifier=20
    c_iEnemyNotVisibleTime=5
    c_iCautiousLastHearNoiseTime=5
    c_iRunForCoverOfGrenadeMinDist=500
    m_bFirstTimeClarkComment=True
    m_AITickTime=(m_fMin=-171972256.00,m_fMax=1.50375042780667156E31,m_fResult=0.00)
    m_RunForCoverMinTween=(m_fMin=0.00,m_fMax=1.5251421283995885E31,m_fResult=0.00)
    m_scareToDeathTween=(m_fMin=0.00,m_fMax=1.53009388855673002E31,m_fResult=0.00)
    m_stayBlindedTweenTime=(m_fMin=0.00,m_fMax=1.52276525934564418E31,m_fResult=0.00)
    c_iDistanceBumpBackUp=90
    bIsPlayer=True
}
