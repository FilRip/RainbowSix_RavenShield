//================================================================================
// R6TerroristAI.
//================================================================================
class R6TerroristAI extends R6AIController
	Native;

enum EDefCon {
	DEFCON_0,
	DEFCON_1,
	DEFCON_2,
	DEFCON_3,
	DEFCON_4,
	DEFCON_5
};

enum EEngageReaction {
	EREACT_Random,
	EREACT_AimedFire,
	EREACT_SprayFire,
	EREACT_RunAway,
	EREACT_Surrender
};

enum EFollowMode {
	FMODE_Hostage,
	FMODE_Path
};

enum EEventState {
	EVSTATE_DefaultState,
	EVSTATE_RunAway,
	EVSTATE_Attack,
	EVSTATE_FindHostage,
	EVSTATE_AttackHostage
};

enum EReactionStatus {
	REACTION_HearAndSeeAll,
	REACTION_SeeHostage,
	REACTION_HearBullet,
	REACTION_SeeRainbow,
	REACTION_Grenade,
	REACTION_HearAndSeeNothing
};

enum EAttackMode {
	ATTACK_NotEngaged,
	ATTACK_AimedFire,
	ATTACK_SprayFire,
	ATTACK_SprayFireNoStop,
	ATTACK_SprayFireMove
};

var EEngageReaction m_eEngageReaction;
var EReactionStatus m_eReactionStatus;
var EEventState m_eStateForEvent;
var EAttackMode m_eAttackMode;
var EFollowMode m_eFollowMode;
var byte m_wBadMoveCount;
var int m_iCurrentGroupID;
var int m_iTerroristInGroup;
var int m_iRainbowInCombat;
var int m_iChanceToDetectShooter;
var int m_iRandomNumber;
var int m_iStateVariable;
var int m_iFollowYaw;
var bool m_bHearInvestigate;
var bool m_bSeeHostage;
var bool m_bHearThreat;
var bool m_bSeeRainbow;
var bool m_bHearGrenade;
var bool m_bPreciseMove;
var bool m_bCanFailMovingTo;
var bool m_bFireShort;
var bool m_bInPathMode;
var bool m_bWaiting;
var bool m_bAlreadyHeardSound;
var bool m_bHeardGrenade;
var bool m_bCalledForBackup;
var float m_fWaitingTime;
var float m_fFacingTime;
var float m_fSearchTime;
var float m_fPawnDistance;
var float m_fFollowDist;
var float m_fLastBumpedTime;
var R6TerroristAI m_TerroristLeader;
var R6Terrorist m_pawn;
var R6TerroristMgr m_Manager;
var R6TerroristVoices m_VoicesManager;
var R6ActionSpot m_pActionSpot;
var NavigationPoint m_aLastNode[10];
var R6Pawn m_huntedPawn;
var R6Hostage m_Hostage;
var R6HostageAI m_HostageAI;
var R6DeploymentZone m_ZoneToEscort;
var R6Pawn m_pawnToFollow;
var Actor m_aMovingToDestination;
var R6Pawn m_LastBumped;
var R6DZonePath m_path;
var R6DZonePathNode m_currentNode;
var R6InteractiveObject m_TriggeredIO;
var name m_stateAfterMovingTo;
var name m_labelAfterMovingTo;
var name m_PatrolCurrentLabel;
var array<R6TerroristAI> m_listAvailableBackup;
var Vector m_vThreatLocation;
var Vector m_vHostageReactionDirection;
var Vector m_vMovingDestination;
var Rotator m_rStandRotation;
var Vector m_vSpawningPosition;
var Rotator m_rSpawningRotation;
var string m_sDebugString;
const C_NumberOfNodeRemembered= 10;
const C_WaitingForEnemyTime= 15;
const C_HostageSearchTime= 15;
const C_HostageReactionSearchTime= 15;
const C_DefaultSearchTime= 30;
const C_MaxDistanceForActionSpot= 2000;

native(1820) final function NavigationPoint GetNextRandomNode ();

native(1821) final function CallBackupForAttack (Vector vDestination, eMovementPace ePace);

native(1823) final function CallBackupForInvestigation (Vector vDestination, eMovementPace ePace);

native(1822) final function bool MakeBackupList ();

native(1824) final function Vector FindBetterShotLocation (Pawn PTarget);

native(1827) final function bool HaveAClearShot (Vector vStart, Pawn PTarget);

native(1828) final function bool CallVisibleTerrorist ();

native(1829) final function bool IsAttackSpotStillValid ();

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	m_VoicesManager=R6TerroristVoices(R6AbstractGameInfo(Level.Game).GetTerroristVoicesMgr(Level.m_eTerroristVoices));
}

state test
{
Begin:
//	SetReactionStatus(5,0);
	m_rStandRotation=m_pawn.Rotation;
	goto ('RandomRotation');
RandomRotation:
	m_rStandRotation.Yaw=Rand(32767) * 4;
	logX("Yaw: " $ string(m_rStandRotation.Yaw));
	ChangeOrientationTo(m_rStandRotation);
	Sleep(2.00);
	goto ('RandomRotation');
Sequence:
	Sleep(2.00);
	goto ('Sequence');
}

function LogTerroState ()
{
	local R6PlayerController C;

	foreach AllActors(Class'R6PlayerController',C)
	{
		if ( C.CheatManager != None )
		{
			R6CheatManager(C.CheatManager).LogTerro(m_pawn);
		}
		else
		{
		}
	}
}

function bool CanClimbLadders (R6Ladder Ladder)
{
	local int i;
	local bool bResult;

	if ( m_pawn.m_bAutoClimbLadders && ((MoveTarget == Ladder) || (Pawn.Anchor == Ladder)) )
	{
JL003D:
		if ( (i < 16) && (RouteCache[i] != None) )
		{
			if ( RouteCache[i] == Ladder.m_pOtherFloor )
			{
				bResult=True;
			}
			if ( bResult && (RouteCache[i] == Ladder) )
			{
				return False;
			}
			i++;
			goto JL003D;
		}
	}
	return bResult;
}

function bool CanSafelyChangeState ()
{
	return Pawn.IsAlive() &&  !m_bCantInterruptIO && (Pawn.Physics != 12) && (Pawn.Physics != 11) &&  !m_pawn.m_bIsKneeling;
}

function R6DamageAttitudeTo (Pawn instigatedBy, eKillResult eKillFromTable, eStunResult eStunFromTable, Vector vBulletMomentum)
{
	if ( IsAnEnemy(R6Pawn(instigatedBy)) )
	{
		if ( m_eReactionStatus <= 3 )
		{
			GotoStateEngageByThreat(instigatedBy.Location);
		}
	}
	if ( m_pawn.EngineWeapon != None )
	{
		m_pawn.EngineWeapon.SetAccuracyOnHit();
	}
}

function PlaySoundDamage (Pawn instigatedBy)
{
//	m_VoicesManager.PlayTerroristVoices(m_pawn,0);
	switch (m_pawn.m_eHealth)
	{
/*		case 2:
		case 3:
		if ( instigatedBy.Controller != None )
		{
			instigatedBy.Controller.PlaySoundInflictedDamage(m_pawn);
		}
		break;
		default:*/
	}
}

function SetReactionStatus (EReactionStatus eNewStatus, EEventState eState)
{
	m_bHearInvestigate=False;
	m_bSeeHostage=False;
	m_bHearThreat=False;
	m_bSeeRainbow=False;
	m_bHearGrenade=False;
	if ( eNewStatus < 5 )
	{
		Enable('HearNoise');
	}
	else
	{
		Disable('HearNoise');
	}
	if ( eNewStatus < 4 )
	{
		Enable('SeePlayer');
	}
	else
	{
		Disable('SeePlayer');
	}
	switch (eNewStatus)
	{
/*		case 0:
		m_bHearInvestigate=True;
		case 1:
		m_bSeeHostage=True;
		case 2:
		m_bHearThreat=True;
		case 3:
		m_bSeeRainbow=True;
		case 4:
		m_bHearGrenade=True;
		case 5:
		break;
		default:*/
	}
	m_eReactionStatus=eNewStatus;
	m_eStateForEvent=eState;
	if ( m_eStateForEvent != 0 )
	{
		Enable('EnemyNotVisible');
	}
	else
	{
		Disable('EnemyNotVisible');
	}
}

function ChangeDefCon (EDefCon eNewDefCon)
{
	switch (eNewDefCon)
	{
/*		case 1:
		m_pawn.RotationRate.Yaw=70000;
		break;
		case 2:
		m_pawn.RotationRate.Yaw=60000;
		break;
		case 3:
		m_pawn.RotationRate.Yaw=50000;
		break;
		case 4:
		m_pawn.RotationRate.Yaw=40000;
		break;
		case 5:
		m_pawn.RotationRate.Yaw=30000;
		break;
		default:                   */
	}
//	m_pawn.m_eDefCon=eNewDefCon;
	if ( eNewDefCon <= 2 )
	{
		m_pawn.m_bWantsHighStance=True;
	}
	else
	{
		m_pawn.m_bWantsHighStance=False;
	}
	m_pawn.PlayMoving();
}

function SetActionSpot (R6ActionSpot pNewSpot)
{
	if ( m_pActionSpot != None )
	{
		m_pActionSpot.m_pCurrentUser=None;
	}
	m_pActionSpot=pNewSpot;
	if ( m_pActionSpot != None )
	{
		m_pActionSpot.m_pCurrentUser=m_pawn;
	}
}

function SetEnemy (Pawn newEnemy)
{
	Enemy=newEnemy;
	LastSeenTime=Level.TimeSeconds;
	if ( Enemy != None )
	{
		LastSeenPos=Enemy.Location;
	}
}

function int GetKillingHostageChance ()
{
	local int iChance;

	if ( UseRandomHostage() )
	{
		iChance=40;
	}
	else
	{
		iChance=m_pawn.m_DZone.m_HostageShootChance;
	}
	if ( m_pawn.m_iDiffLevel == 1 )
	{
		iChance -= 20;
	}
	if ( m_pawn.m_iDiffLevel == 3 )
	{
		iChance += 20;
	}
	return iChance;
}

event SeePlayer (Pawn seen)
{
	local R6Pawn r6seen;
	local R6Hostage hostage;
	local R6HostageAI hostageAI;

	r6seen=R6Pawn(seen);
	if ( r6seen == None )
	{
		return;
	}
	if ( m_eStateForEvent == 4 )
	{
		if ( r6seen.IsAlive() && IsAnHostage(r6seen) )
		{
			SetEnemy(r6seen);
			GotoStateAimedFire();
		}
		return;
	}
	if (  !m_pawn.m_bHearNothing &&  !r6seen.IsAlive() )
	{
		if ( CheckForInteraction() )
		{
			return;
		}
		if (  !m_bAlreadyHeardSound )
		{
			GotoSeeADead(r6seen.Location);
		}
	}
	if ( m_bSeeRainbow && IsAnEnemy(r6seen) )
	{
//		ReconThreatCheck(seen,0);
		EngageBySight(r6seen);
	}
	else
	{
		if ( m_bSeeHostage && IsAnHostage(r6seen) )
		{
			hostage=R6Hostage(r6seen);
			if ( UseRandomHostage() )
			{
				m_Hostage=hostage;
			}
			else
			{
				if (  !IsAssigned(hostage) )
				{
					if ( IsMyHostage(hostage) )
					{
						m_Manager.AssignHostageTo(hostage,self);
//						m_VoicesManager.PlayTerroristVoices(m_pawn,9);
					}
					else
					{
//						m_VoicesManager.PlayTerroristVoices(m_pawn,12);
						GotoStateFindHostage(hostage);
					}
				}
				else
				{
					hostageAI=R6HostageAI(hostage.Controller);
					if ( (hostageAI.m_vReactionDirection != vect(0.00,0.00,0.00)) && (m_vHostageReactionDirection == vect(0.00,0.00,0.00)) )
					{
						m_vHostageReactionDirection=hostageAI.m_vReactionDirection;
						hostageAI.m_vReactionDirection=vect(0.00,0.00,0.00);
//						GotoPointAndSearch(m_vHostageReactionDirection,4,False,15.00,m_pawn.m_eDefCon);
					}
				}
			}
		}
	}
}

function ReconThreatCheck (Actor aThreat, ENoiseType eType)
{
	local R6Pawn aPawn;

	aPawn=R6Pawn(aThreat);
	if ( eType == 0 )
	{
		if ( (aPawn != None) && m_pawn.IsEnemy(aPawn) )
		{
			R6AbstractGameInfo(Level.Game).PawnSeen(aPawn,m_pawn);
		}
	}
	else
	{
		if ( (eType == 2) || m_pawn.IsEnemy(aThreat.Instigator) && aThreat.IsA('R6Weapon') )
		{
			R6AbstractGameInfo(Level.Game).PawnHeard(aThreat.Instigator,m_pawn);
		}
	}
}

function bool UseRandomHostage ()
{
	return Level.GameTypeUseNbOfTerroristToSpawn(Level.Game.m_eGameTypeFlag);
}

function AssignNearHostage ()
{
	local R6Hostage hostage;

	foreach VisibleCollidingActors(Class'R6Hostage',hostage,500.00,Pawn.Location)
	{
		m_Hostage=hostage;
	}
}

event HearNoise (float Loudness, Actor NoiseMaker, ENoiseType eType)
{
	local R6Hostage hostage;
	local R6Pawn pPawn;

	if ( m_pawn.m_bHearNothing || m_pawn.m_bDontHearPlayer && R6Pawn(NoiseMaker.Instigator).m_bIsPlayer )
	{
		return;
	}
//	ReconThreatCheck(NoiseMaker,eType);
	if ( m_bHearInvestigate && (eType == 1) )
	{
		hostage=R6Hostage(NoiseMaker.Instigator);
		if ( hostage != None )
		{
			if ( IsAssigned(hostage) )
			{
				return;
			}
		}
		if (  !m_bAlreadyHeardSound )
		{
			m_bAlreadyHeardSound=True;
//			m_VoicesManager.PlayTerroristVoices(m_pawn,13);
		}
//		GotoPointAndSearch(NoiseMaker.Location,4,True,30.00,2);
	}
	else
	{
		if ( m_bHearThreat && (eType == 2) )
		{
			if ( m_iChanceToDetectShooter < 80 )
			{
				m_iChanceToDetectShooter += 20;
			}
			if ( Rand(100) + 1 < m_iChanceToDetectShooter )
			{
				EngageBySight(NoiseMaker.Instigator);
			}
			else
			{
				if (  !IsInState('EngageByThreat') )
				{
					GotoStateEngageByThreat(NoiseMaker.Instigator.Location);
				}
			}
		}
		else
		{
			if ( m_bHearGrenade && (eType == 3) )
			{
				if ( (ShortestAngle2D(rotator(NoiseMaker.Location - Pawn.Location).Yaw,Pawn.Rotation.Yaw) < 16000) || (ShortestAngle2D(rotator(NoiseMaker.Instigator.Location - Pawn.Location).Yaw,Pawn.Rotation.Yaw) < 16000) )
				{
					if (  !m_bHeardGrenade )
					{
						m_VoicesManager.PlayTerroristVoices(m_pawn,TV_Grenade);
						m_bHeardGrenade=True;
					}
					ReactToGrenade(NoiseMaker.Location);
				}
			}
			else
			{
				if ( m_bHearInvestigate && (eType == 4) )
				{
					pPawn=R6Pawn(NoiseMaker.Instigator);
					if ( (pPawn != None) &&  !pPawn.m_bTerroSawMeDead )
					{
						pPawn.m_bTerroSawMeDead=True;
//						GotoPointAndSearch(NoiseMaker.Location,4,True,30.00);
					}
					else
					{
//						ChangeDefCon(2);
					}
				}
			}
		}
	}
}

event EnemyNotVisible ()
{
	local Vector vDir;
	local Vector vTest;

	switch (m_eStateForEvent)
	{
/*		case 0:
		break;
		case 1:
		if ( (Level.TimeSeconds - LastSeenTime > 2) && CanSafelyChangeState() )
		{
			GotoState('WaitForEnemy');
		}
		break;
		case 3:
		FocalPoint=LastSeenPos;
		GotoState('FindHostage','Pursues');
		break;
		case 2:
		if ( m_eAttackMode == 4 )
		{
			return;
		}
		FocalPoint=LastSeenPos;
		Focus=None;
		if ( (m_eAttackMode == 3) && m_pawn.m_bAllowLeave )
		{
			m_vMovingDestination=LastSeenPos;
			if ( VSize(Pawn.Location - m_vMovingDestination) > Pawn.CollisionRadius * 2 )
			{
				if ( pointReachable(m_vMovingDestination) )
				{
					GotoState('Attack','SprayFireMove');
				}
				else
				{
					vDir=Normal(m_vMovingDestination - m_pawn.Location);
					vTest=vDir Cross vect(0.00,0.00,1.00) * 200;
					if ( pointReachable(m_vMovingDestination + vTest) )
					{
						m_vMovingDestination=m_vMovingDestination + vTest;
						GotoState('Attack','SprayFireMove');
					}
					else
					{
						if ( pointReachable(m_vMovingDestination - vTest) )
						{
							m_vMovingDestination=m_vMovingDestination - vTest;
							GotoState('Attack','SprayFireMove');
						}
					}
				}
			}
			return;
		}
		if ( m_pawn.m_ePersonality == 5 )
		{
			GotoState('Sniping','LostTrackOfEnemy');
		}
		else
		{
			GotoStateLostSight(LastSeenPos);
		}
		break;
		default:
		Disable('EnemyNotVisible');  */
	}
}

function GotoBumpBackUpState (name returnState)
{
	if (  !m_pawn.m_bIsKneeling &&  !CanSafelyChangeState() )
	{
		return;
	}
	Super.GotoBumpBackUpState(returnState);
}

state BumpBackUp
{
	function BeginState ()
	{
//		SetReactionStatus(m_eReactionStatus,m_eStateForEvent);
		Super.BeginState();
	}

	function EndState ()
	{
		Focus=None;
		Super.EndState();
	}

	function bool GetReacheablePoint (out Vector vTarget, bool bNoFail)
	{
		local Actor HitActor;
		local Vector vHitLocation;
		local Vector vHitNormal;
		local Vector vExtent;

		if ( MoveRight() )
		{
//			vTarget=Pawn.Location + c_iDistanceBumpBackUp * (vector(m_vBumpedByVelocity) + rot(0,16384,0));
		}
		else
		{
//			vTarget=Pawn.Location + c_iDistanceBumpBackUp * (vector(m_vBumpedByVelocity) - rot(0,16384,0));
		}
		vExtent.X=Pawn.CollisionRadius;
		vExtent.Y=vExtent.Y;
		vExtent.Z=Pawn.CollisionHeight;
		HitActor=R6Trace(vHitLocation,vHitNormal,vTarget,Pawn.Location,1 | 2,vExtent);
		if ( HitActor != None )
		{
//			vTarget=vHitLocation + c_iDistanceBumpBackUp * vector(m_vBumpedByVelocity);
		}
		return True;
	}

}

state ApproachLadder
{
	function BeginState ()
	{
//		SetReactionStatus(m_eReactionStatus,m_eStateForEvent);
		Super.BeginState();
	}

	function EndState ()
	{
		Focus=None;
		Super.EndState();
	}

}

state WaitToClimbLadder
{
	function BeginState ()
	{
//		SetReactionStatus(m_eReactionStatus,m_eStateForEvent);
		Super.BeginState();
	}

	function EndState ()
	{
		Focus=None;
		Super.EndState();
	}

}

function SetGunDirection (Actor aTarget)
{
	local Rotator rDirection;
	local Vector vDirection;
	local Coords cTarget;
	local Vector vTarget;

	if ( aTarget != None )
	{
		if ( aTarget == Enemy )
		{
			vTarget=LastSeenPos;
		}
		else
		{
			cTarget=aTarget.GetBoneCoords('R6 Spine');
			vTarget=cTarget.Origin;
		}
		vDirection=vTarget - m_pawn.GetFiringStartPoint();
		rDirection=rotator(vDirection);
		m_pawn.m_wWantedAimingPitch=rDirection.Pitch / 256;
		m_pawn.m_rFiringRotation=rDirection;
	}
	else
	{
		m_pawn.m_wWantedAimingPitch=0;
		m_pawn.m_rFiringRotation=m_pawn.Rotation;
	}
}

function bool IsAnEnemy (R6Pawn Other)
{
	if ( m_pawn.m_bDontSeePlayer && Other.m_bIsPlayer )
	{
		return False;
	}
	if ( m_pawn.IsEnemy(Other) && Other.IsAlive() )
	{
		return True;
	}
	return False;
}

function bool IsAnHostage (R6Pawn Other)
{
	if ( m_pawn.IsNeutral(Other) && Other.IsAlive() )
	{
		return True;
	}
	return False;
}

function bool IsAssigned (R6Hostage hostage)
{
	return m_Manager.IsHostageAssigned(hostage);
}

function bool IsMyHostage (R6Hostage hostage)
{
	local bool bResult;
	local R6DZonePoint zonePoint;
	local Actor HitActor;
	local Vector vHitLocation;
	local Vector vHitNormal;

	zonePoint=R6DZonePoint(m_pawn.m_DZone);
	if ( zonePoint != None )
	{
		HitActor=m_pawn.R6Trace(vHitLocation,vHitNormal,hostage.Location,zonePoint.Location,1 | 2);
		if ( HitActor == hostage )
		{
			bResult=True;
		}
	}
	else
	{
		bResult=m_pawn.m_DZone.IsPointInZone(m_pawn.Location) && m_pawn.m_DZone.IsPointInZone(hostage.Location);
	}
	return bResult;
}

function StartFiring ()
{
	if (  !Pawn.m_bDroppedWeapon && (Pawn.EngineWeapon != None) )
	{
		if (  !Pawn.EngineWeapon.HasAmmo() )
		{
			return;
		}
		if ( Enemy != None )
		{
			Target=Enemy;
		}
		bFire=1;
		Pawn.EngineWeapon.GotoState('NormalFire');
	}
	m_pawn.PlayWeaponAnimation();
}

function StopFiring ()
{
	bFire=0;
	m_pawn.PlayWeaponAnimation();
}

function AIReloadWeapon ()
{
	Pawn.EngineWeapon.GotoState('None');
	m_pawn.m_wWantedAimingPitch=0;
	if ( Pawn.EngineWeapon.m_eWeaponType == 5 )
	{
		Pawn.EngineWeapon.FullCurrentClip();
	}
	else
	{
		m_pawn.m_ePlayerIsUsingHands=HANDS_None;
		m_pawn.ServerSwitchReloadingWeapon(True);
		m_pawn.ReloadWeapon();
	}
	m_pawn.PlayWeaponAnimation();
}

function float GetMaxCoverDistance ()
{
	switch (m_pawn.m_ePersonality)
	{
/*		case 0:
		return 2000.00;
		break;
		case 1:
		return 1600.00;
		break;
		case 2:
		return 1200.00;
		break;
		case 3:
		return 800.00;
		break;
		case 4:
		return 400.00;
		break;
		case 5:
		return 0.00;
		break;
		default:  */
	}
	return 0.00;
}

function bool SetLowestSnipingStance (optional Actor aTarget)
{
	local Vector vStart;
	local Vector vTarget;

	vStart=m_pawn.Location;
	vStart.Z=m_pawn.Location.Z - m_pawn.CollisionHeight + 15;
	if ( aTarget != None )
	{
		vTarget=aTarget.Location;
	}
	else
	{
		vTarget=vStart + vector(m_pawn.Rotation) * 500;
	}
	if ( FastTrace(vStart,vTarget) )
	{
		m_pawn.m_bWantsToProne=True;
		m_pawn.bWantsToCrouch=False;
		return True;
	}
	vStart.Z=m_pawn.Location.Z - m_pawn.CollisionHeight + 70;
	if ( aTarget != None )
	{
		vTarget=aTarget.Location;
	}
	else
	{
		vTarget=vStart + vector(m_pawn.Rotation) * 500;
	}
	if ( FastTrace(vStart,vTarget) )
	{
		m_pawn.m_bWantsToProne=False;
		m_pawn.bWantsToCrouch=True;
		return True;
	}
	if ( aTarget != None )
	{
		vStart.Z=m_pawn.Location.Z - m_pawn.CollisionHeight + 135;
		vTarget=aTarget.Location;
		if ( FastTrace(vStart,vTarget) )
		{
			m_pawn.m_bWantsToProne=False;
			m_pawn.bWantsToCrouch=False;
			return True;
		}
		return False;
	}
	m_pawn.m_bWantsToProne=False;
	m_pawn.bWantsToCrouch=False;
	return True;
}

function ReactToGrenade (Vector vGrenadeLocation)
{
	local Vector vDestination;
	local float fDistance;
	local float fTemp;
	local int i;
	local NavigationPoint aDest;

//	ChangeDefCon(1);
	if ( VSize(m_pawn.Location - vGrenadeLocation) > 600 )
	{
		return;
	}
	fDistance=RandRange(400.00,1000.00);
	i=0;
JL004A:
	if ( i < 10 )
	{
		m_aLastNode[i]=None;
		i++;
		goto JL004A;
	}
	aDest=GetNextRandomNode();
	i=0;
JL007D:
	if ( (VSize(aDest.Location - vGrenadeLocation) < fDistance) && (i < 10) )
	{
		i++;
		aDest=GetNextRandomNode();
		goto JL007D;
	}
//	SetReactionStatus(4,0);
	m_aMovingToDestination=aDest;
	if (  !IsInState('TransientStateCode') )
	{
		GotoState('TransientStateCode','RunFromGrenade');
	}
}

function PlaySoundAffectedByGrenade (EGrenadeType eType)
{
	switch (eType)
	{
/*		case GTYPE_TearGas:
		m_VoicesManager.PlayTerroristVoices(m_pawn,7);
		break;
		case GTYPE_Smoke:
		m_VoicesManager.PlayTerroristVoices(m_pawn,6);
		break;
		default:   */
	}
}

function AIAffectedByGrenade (Actor aGrenade, EGrenadeType eType)
{
//	ChangeDefCon(2);
	m_pawn.m_vGrenadeLocation=aGrenade.Location;
	if ( eType == GTYPE_TearGas )
	{
		if ( CanSafelyChangeState() )
		{
			m_pawn.bWantsToCrouch=False;
//			m_pawn.SetNextPendingAction(PENDING_Coughing);
			ReactToGrenade(m_pawn.m_vGrenadeLocation);
		}
	}
	else
	{
		if ( (eType == GTYPE_FlashBang) || (eType == GTYPE_BreachingCharge) )
		{
			if (  !m_bCantInterruptIO &&  !CanSafelyChangeState() )
			{
				return;
			}
//			m_pawn.SetNextPendingAction(PENDING_Blinded);
			GotoState('TransientStateCode','RecoverFromFlash');
		}
		else
		{
			if ( CanSafelyChangeState() )
			{
				ReactToGrenade(m_pawn.m_vGrenadeLocation);
			}
		}
	}
}

state TransientStateCode
{
	function BeginState ()
	{
//		SetReactionStatus(m_eReactionStatus,0);
	}

RunFromGrenade:
Begin:
	StopMoving();
	switch (m_pawn.m_iDiffLevel)
	{
/*		case 1:
		Sleep(1.00);
		break;
		case 2:
		Sleep(0.50);
		break;
		case 3:
		break;
		default:  */
	}
//	GotoStateMovingTo("RunFromGrenade",PACE_Run,True,m_aMovingToDestination,,'TransientStateCode','AfterRunFromGrenade',True);
AfterRunFromGrenade:
	m_bHeardGrenade=False;
	if ( Enemy == None )
	{
		Sleep(3.00);
	}
	goto ('ResumeAction');
RecoverFromFlash:
	Disable('HearNoise');
	Disable('SeePlayer');
	StopMoving();
	Sleep(5.00);
	if ( m_bCantInterruptIO )
	{
		CheckForInteraction();
	}
ResumeAction:
	if ( Enemy != None )
	{
		GotoState('Attack');
	}
	else
	{
		GotoStateNoThreat();
	}
}

function GotoSeeADead (Vector vDeadLocation)
{
	m_vThreatLocation=vDeadLocation;
	GotoState('SeeADead');
}

state SeeADead
{
	function BeginState ()
	{
//		SetReactionStatus(0,0);
	}

	function EndState ()
	{
		m_pawn.m_wWantedHeadYaw=0;
	}

Begin:
//	ChangeDefCon(2);
	SetActionSpot(FindPlaceToFire(None,m_vThreatLocation,2000.00));
	if ( m_pActionSpot != None )
	{
//		GotoStateMovingTo("SeeADead:FireSpot",PACE_Run,True,m_pActionSpot,,'SeeADead','AtSpot');
	}
AtSpot:
	StopMoving();
	if ( m_pActionSpot != None )
	{
		ChangeOrientationTo(m_pActionSpot.Rotation);
	}
	else
	{
		Focus=None;
		FocalPoint=m_vThreatLocation;
	}
	if ( (m_pActionSpot == None) || (m_pActionSpot.m_eFire == 2) )
	{
		Pawn.bWantsToCrouch=True;
	}
	m_fSearchTime=Level.TimeSeconds + 30;
Wait:
	if ( m_fSearchTime < Level.TimeSeconds )
	{
//		GotoStateEngageBySound(m_vThreatLocation,4,30.00);
	}
	Sleep(RandRange(1.00,3.00));
	m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,10000.00) / 256;
	Sleep(RandRange(0.50,1.50));
	m_pawn.m_wWantedHeadYaw=0;
	goto ('Wait');
}

event GotoPointAndSearch (Vector vDestination, eMovementPace ePace, bool bCallBackup, optional float fSearchTime, optional EDefCon eNewDefCon)
{
	if (  !CanSafelyChangeState() )
	{
		return;
	}
	if ( bCallBackup )
	{
		if ( MakeBackupList() )
		{
			CallBackupForInvestigation(vDestination,ePace);
		}
	}
	if ( eNewDefCon != 0 )
	{
//		ChangeDefCon(eNewDefCon);
	}
	else
	{
//		ChangeDefCon(1);
	}
	if ( fSearchTime == 0 )
	{
		fSearchTime=30.00;
	}
//	GotoStateEngageBySound(vDestination,ePace,fSearchTime);
}

event GotoPointToAttack (Vector vDestination, Actor PTarget)
{
	if (  !CanSafelyChangeState() )
	{
		return;
	}
	if ( m_InteractionObject != None )
	{
		m_bCalledForBackup=True;
		m_vThreatLocation=vDestination;
		Target=PTarget;
		m_InteractionObject.StopInteractionWithEndingActions();
		return;
	}
	if ( CheckForInteraction() )
	{
		return;
	}
	m_pawn.m_bPawnSpecificAnimInProgress=False;
//	ChangeDefCon(1);
	m_vThreatLocation=vDestination;
	Target=PTarget;
	SetActionSpot(None);
	m_StateAfterInteraction='MovingToAttack';
	GotoState('MovingToAttack');
}

state MovingToAttack
{
	function BeginState ()
	{
//		SetReactionStatus(3,0);
	}

Begin:
	if ( m_pActionSpot == None )
	{
		SetActionSpot(FindPlaceToFire(Target,m_vThreatLocation,2000.00));
	}
	if ( m_pActionSpot != None )
	{
		m_pActionSpot.m_pCurrentUser=m_pawn;
//		GotoStateMovingTo("MovingToAttackActionSpot",PACE_Run,True,m_pActionSpot,,'MovingToAttack','AtActionSpot');
	}
	else
	{
//		GotoStateMovingTo("MovingToAttackThreat",PACE_Run,True,,m_vThreatLocation,'MovingToAttack','AtPosition');
	}
AtActionSpot:
	MoveToPosition(m_pActionSpot.Location,rotator(Target.Location - m_pActionSpot.Location));
	if ( m_pActionSpot.m_eFire == 2 )
	{
		m_pawn.bWantsToCrouch=True;
	}
	else
	{
		m_pawn.bWantsToCrouch=False;
	}
	goto ('Wait');
AtPosition:
	FocalPoint=Target.Location;
Wait:
	Sleep(30.00);
	Sleep(RandRange(1.00,3.00));
//	GotoStateEngageBySound(m_vThreatLocation,4,30.00);
}

function GotoStateLostSight (Vector vLastSeen)
{
	m_vThreatLocation=vLastSeen;
	GotoState('LostSight');
}

state LostSight
{
	function BeginState ()
	{
//		SetReactionStatus(3,0);
	}

Begin:
	if ( Enemy != None )
	{
		m_vTargetPosition=FindBetterShotLocation(Enemy);
		R6PreMoveTo(m_vTargetPosition,Enemy.Location,PACE_Run);
		MoveTo(m_vTargetPosition,Enemy);
		Focus=None;
		FocalPoint=Enemy.Location;
		goto ('AtBetterLocation');
	}
AtBetterLocation:
	SetActionSpot(FindPlaceToFire(None,m_vThreatLocation,2000.00));
	if ( m_pActionSpot != None )
	{
		m_pActionSpot.m_pCurrentUser=m_pawn;
//		GotoStateMovingTo("LostSightActionSpot",PACE_Run,True,m_pActionSpot,,'LostSight','AtActionSpot');
	}
	m_pawn.bWantsToCrouch=True;
	FocalPoint=m_vThreatLocation;
	goto ('Waiting');
AtActionSpot:
	MoveToPosition(m_pActionSpot.Location,rotator(m_pActionSpot.Location - m_vThreatLocation));
	if ( (m_pActionSpot.m_eFire == 2) || (m_pActionSpot.m_eCover == 2) )
	{
		m_pawn.bWantsToCrouch=True;
	}
	else
	{
		m_pawn.bWantsToCrouch=False;
	}
Waiting:
	Sleep(RandRange(0.00,3.00));
	if ( Pawn.EngineWeapon.NumberOfBulletsLeftInClip() < 0.50 * Pawn.EngineWeapon.GetClipCapacity() )
	{
//		SetReactionStatus(5,0);
		AIReloadWeapon();
JL01C9:
		if ( m_pawn.m_bReloadingWeapon )
		{
			Sleep(0.10);
//			goto JL01C9;
		}
//		SetReactionStatus(0,0);
	}
//	GotoStateEngageBySound(m_vThreatLocation,5,30.00);
}

function EngageBySight (Pawn aPawn)
{
	SetEnemy(aPawn);
	Target=aPawn;
	GotoState('PrecombatAction');
}

function EEngageReaction GetEngageReaction (Pawn pEnemy, int iNbTerro, int iNbRainbow)
{
	local bool bOutnumbered;

	if ( m_eEngageReaction != 0 )
	{
		return m_eEngageReaction;
	}
	if ( Pawn.m_bDroppedWeapon || (Pawn.EngineWeapon == None) )
	{
		return EREACT_Surrender;
	}
	if ( m_pawn.m_ePersonality == 5 )
	{
		return EREACT_AimedFire;
	}
	m_iRandomNumber=Rand(100) + 1;
	switch (m_pawn.m_ePersonality)
	{
/*		case 0:
		m_iRandomNumber -= 40;
		break;
		case 1:
		m_iRandomNumber -= 20;
		break;
		case 2:
		break;
		case 3:
		m_iRandomNumber += 20;
		break;
		case 4:
		m_iRandomNumber += 40;
		break;
		default:    */
	}
	if ( (m_iTerroristInGroup + 1) * 2 < m_iRainbowInCombat )
	{
		bOutnumbered=True;
	}
	if ( bOutnumbered )
	{
		if ( m_iRandomNumber >= 81 )
		{
			return EREACT_AimedFire;
		}
		if ( m_iRandomNumber >= 41 )
		{
			return EREACT_SprayFire;
		}
		if ( m_iRandomNumber >= 11 )
		{
			return EREACT_RunAway;
		}
		else
		{
			if ( VSize(Pawn.Location - pEnemy.Location) < 1000 )
			{
				return EREACT_Surrender;
			}
			else
			{
				return EREACT_RunAway;
			}
		}
	}
	else
	{
		if ( m_iRandomNumber >= 61 )
		{
			return EREACT_AimedFire;
		}
		if ( m_iRandomNumber >= 11 )
		{
			return EREACT_SprayFire;
		}
		else
		{
			return EREACT_RunAway;
		}
	}
	return EREACT_Surrender;
}

function bool CheckForInteraction ()
{
	local Actor aGoal;

	if ( m_TriggeredIO != None )
	{
		m_bCantInterruptIO=True;
//		SetReactionStatus(5,0);
		if ( m_TriggeredIO.m_Anchor != None )
		{
			aGoal=m_TriggeredIO.m_Anchor;
		}
		else
		{
			aGoal=m_TriggeredIO;
		}
//		GotoStateMovingTo("InteractionObject",PACE_Run,False,aGoal,,'PrecombatAction','InteractiveObject',True);
		return True;
	}
	if ( Pawn.m_bDroppedWeapon || (m_pawn.EngineWeapon == None) )
	{
		return False;
	}
	if (  !UseRandomHostage() )
	{
		m_Hostage=m_pawn.m_DZone.GetClosestHostage(m_pawn.Location);
	}
	if ( (m_Hostage != None) &&  !m_Hostage.m_bExtracted )
	{
		if ( Rand(100) < GetKillingHostageChance() )
		{
			GotoStateAttackHostage(m_Hostage);
			return True;
		}
	}
	return False;
}

state PrecombatAction
{
	function BeginState ()
	{
//		SetReactionStatus(5,0);
	}

Begin:
	m_pawn.m_bSkipTick=False;
//	ChangeDefCon(1);
	CheckForInteraction();
	goto ('AfterInteraction');
InteractiveObject:
	StopMoving();
JL002B:
	if ( m_TriggeredIO.m_InteractionOwner != None )
	{
		if (  !m_TriggeredIO.m_InteractionOwner.Pawn.IsAlive() )
		{
			m_TriggeredIO.m_InteractionOwner=None;
		}
		else
		{
			Sleep(0.50);
		}
//		goto JL002B;
	}
	m_TriggeredIO.PerformAction(m_pawn);
	m_TriggeredIO=None;
	Sleep(1.00);
	if ( Enemy == None )
	{
		GotoStateNoThreat();
	}
AfterInteraction:
	if ( m_pawn.m_bIsKneeling || m_pawn.m_bIsUnderArrest )
	{
		GotoState('Surrender');
	}
	StopMoving();
	LastSeenTime=Level.TimeSeconds;
	LastSeenPos=Enemy.Location;
	if (  !Pawn.m_bDroppedWeapon && (Pawn.EngineWeapon != None) )
	{
		if ( m_eAttackMode != 0 )
		{
			if ( m_eAttackMode == 4 )
			{
//				m_eAttackMode=3;
			}
			GotoState('Attack');
		}
	}
	if ( MakeBackupList() )
	{
		if ( AIPlayCallBackup(Enemy) )
		{
			Sleep(1.00);
			CallBackupForAttack(Enemy.Location,PACE_Run);
//			FinishAnim(m_pawn.16);
		}
		else
		{
			CallBackupForAttack(Enemy.Location,PACE_Run);
		}
	}
Grenade:
	if ( m_pawn.m_bHaveAGrenade )
	{
		GotoStateThrowingGrenade('PrecombatAction','Reaction');
	}
Reaction:
	if ( R6RainbowAI(Enemy.Controller) != None )
	{
		m_iRainbowInCombat=R6RainbowAI(Enemy.Controller).m_TeamManager.m_iMemberCount;
	}
	else
	{
		if ( R6PlayerController(Enemy.Controller) != None )
		{
			m_iRainbowInCombat=R6PlayerController(Enemy.Controller).m_TeamManager.m_iMemberCount;
		}
	}
	switch (GetEngageReaction(Enemy,m_iTerroristInGroup,m_iRainbowInCombat))
	{
/*		case 1:
		PlayAttackVoices();
		GotoStateAimedFire();
		break;
		case 2:
		PlayAttackVoices();
		GotoStateSprayFire();
		break;
		case 3:
		m_VoicesManager.PlayTerroristVoices(m_pawn,TV_RunAway);
		GotoState('RunAway');
		break;
		case 4:
		m_VoicesManager.PlayTerroristVoices(m_pawn,TV_Surrender);
		GotoState('Surrender');
		break;
		default: */
	}
}

function PlayAttackVoices ()
{
	local int iAngle;

	if ( ShortestAngle2D(Enemy.Rotation.Yaw,m_pawn.Rotation.Yaw) > 13000 )
	{
		if ( m_pawn.m_eDefCon >= 3 )
		{
			m_VoicesManager.PlayTerroristVoices(m_pawn,TV_SeesRainbow_LowAlert);
		}
		else
		{
			m_VoicesManager.PlayTerroristVoices(m_pawn,TV_SeesRainbow_HighAlert);
		}
	}
}

function PawnDied ()
{
	if ( (m_path != None) &&  !Level.m_bIsResettingLevel )
	{
//		m_path.InformTerroTeam(5,self);
	}
	Super.PawnDied();
}

auto state Configuration
{
Begin:
	m_pawn=R6Terrorist(Pawn);
	m_pawn.m_controller=self;
	m_Manager=R6TerroristMgr(Level.GetTerroristMgr());
JL003A:
	if (  !m_pawn.m_bInitFinished )
	{
		Sleep(0.50);
//		goto JL003A;
	}
	m_vSpawningPosition=m_pawn.Location;
	m_rSpawningRotation=m_pawn.Rotation;
//	m_eEngageReaction=m_pawn.m_DZone.m_eEngageReaction;
//	ChangeDefCon(m_pawn.m_eDefCon);
	if ( m_pawn.m_eStrategy == 0 )
	{
		m_path=R6DZonePath(m_pawn.m_DZone);
		assert (m_path != None);
		if ( m_path.m_aNode.Length < 2 )
		{
//			m_pawn.m_eStrategy=2;
		}
	}
	if ( UseRandomHostage() )
	{
		AssignNearHostage();
	}
	m_TriggeredIO=m_pawn.m_DZone.m_InteractiveObject;
	GotoStateNoThreat();
}

function bool AIPlayCallBackup (Actor pEnemy)
{
	local int iShootingChance;
	local int iAnimID;

	if ( VSize(Pawn.Location - pEnemy.Location) < 400 )
	{
		iShootingChance=100;
	}
	else
	{
		switch (m_pawn.m_iDiffLevel)
		{
/*			case 1:
			iShootingChance=50;
			break;
			case 2:
			iShootingChance=70;
			break;
			case 3:
			iShootingChance=90;
			break;
			default:             */
		}
	}
	if ( Rand(100) < iShootingChance )
	{
		iAnimID=0;
	}
	else
	{
		iAnimID=1;
	}
//	m_pawn.SetNextPendingAction(PENDING_Blinded4,iAnimID);
//	m_VoicesManager.PlayTerroristVoices(m_pawn,8);
	if ( iAnimID == 0 )
	{
		return False;
	}
	return True;
}

function DispatchOrder (int iOrder, R6Pawn pSource)
{
	switch (iOrder)
	{
/*		case m_pawn.1:
		SecureTerrorist(pSource);
		break;
		default:
		assert (False);   */
	}
}

function GotoStateThrowingGrenade (name nNextState, name nNextLabel)
{
	NextState=nNextState;
	NextLabel=nNextLabel;
	GotoState('ThrowingGrenade');
}

state ThrowingGrenade
{
	function BeginState ()
	{
//		SetReactionStatus(5,0);
		Focus=Enemy;
	}

	function EndState ()
	{
		Focus=None;
		FocalPoint=Enemy.Location;
	}

	function CheckDistance ()
	{
		local Vector vDir;
		local float fDist;

		vDir=Enemy.Location - m_pawn.Location;
		fDist=VSize(vDir);
		if ( fDist > 1500 )
		{
			vDir=Normal(vDir);
			vDir=m_pawn.Location + vDir * (fDist - 1400);
//			GotoStateMovingTo("ThrowingGrenade",PACE_Run,True,,vDir,'ThrowingGrenade','Throw');
		}
	}

	event bool NotifyBump (Actor Other)
	{
		return True;
	}

Begin:
	CheckDistance();
Throw:
	if ( VSize(Enemy.Location - m_pawn.Location) > 1500 )
	{
		goto ('Exit');
	}
	Target=Enemy;
	StopMoving();
	if ( m_pawn.bIsCrouched )
	{
		m_pawn.bWantsToCrouch=False;
		Sleep(0.10);
	}
	FinishRotation();
	m_pawn.SetToGrenade();
	m_pawn.PlayWeaponAnimation();
//	m_pawn.SetNextPendingAction(PENDING_Blinded0);
//	FinishAnim(m_pawn.16);
	m_pawn.SetToNormalWeapon();
	m_pawn.PlayWeaponAnimation();
	Sleep(2.00);
Exit:
	GotoState(NextState,NextLabel);
}

function GotoStateNoThreat ()
{
	if ( m_pawn.IsAlive() )
	{
		GotoState('NoThreat');
	}
	else
	{
		GotoState('Dead');
	}
}

state NoThreat
{
	function BeginState ()
	{
//		SetReactionStatus(0,0);
	}

Begin:
	if ( m_pawn.m_bIsKneeling || m_pawn.m_bIsUnderArrest )
	{
		GotoState('Surrender');
	}
	Pawn.SetMovementPhysics();
//	m_eAttackMode=0;
	m_pawn.m_bSprayFire=False;
	StopMoving();
	if ( m_pawn.m_ePersonality != 5 )
	{
		m_pawn.bWantsToCrouch=False;
		m_pawn.m_bIsSniping=False;
	}
	else
	{
		m_pawn.m_bIsSniping=True;
		m_pawn.m_bCanProne=True;
		m_pawn.m_bAllowLeave=False;
	}
	m_pawn.m_bSkipTick=True;
	m_pawn.m_bIsKneeling=False;
	m_pawn.m_bIsUnderArrest=False;
	m_bAlreadyHeardSound=False;
	m_TerroristLeader=None;
	m_iCurrentGroupID=0;
	m_HostageAI=None;
	SetEnemy(None);
	m_iChanceToDetectShooter=0;
	SetActionSpot(None);
	if (  !UseRandomHostage() )
	{
		m_Hostage=None;
	}
	if ( m_pawn.m_eDefCon <= 2 )
	{
//		ChangeDefCon(2);
	}
	m_iRandomNumber=0;
JL016B:
	if ( m_iRandomNumber < 10 )
	{
		m_aLastNode[m_iRandomNumber]=None;
		m_iRandomNumber++;
//		goto JL016B;
	}
JL018E:
	if (  !Level.Game.m_bGameStarted )
	{
		Sleep(0.50);
//		goto JL018E;
	}
	if ( Pawn.m_bDroppedWeapon || (Pawn.EngineWeapon == None) || Pawn.EngineWeapon.GunIsFull() )
	{
		goto ('ChooseState');
	}
Reload:
//	SetReactionStatus(5,0);
JL020B:
	if (  !Pawn.EngineWeapon.GunIsFull() )
	{
		Sleep(0.10);
		AIReloadWeapon();
JL0236:
		if ( m_pawn.m_bReloadingWeapon )
		{
			Sleep(0.10);
//			goto JL0236;
		}
//		goto JL020B;
	}
//	SetReactionStatus(0,0);
ChooseState:
	switch (m_pawn.m_eStrategy)
	{
/*		case 0:
		GotoState('PatrolPath');
		break;
		case 1:
		GotoState('PatrolArea');
		break;
		case 2:
		GotoState('GuardPoint');
		break;
		case 3:
		GotoState('HuntRainbow');
		break;
		case 4:
		GotoState('test');
		default:   */
	}
}

function GotoStateMovingTo (string sDebugString, eMovementPace ePace, bool bCanFail, optional Actor aMoveTarget, optional Vector vDestination, optional name stateAfter, optional name labelAfter, optional bool bDontCheckLeave, optional bool bPreciseMove)
{
	local Vector vHitNormal;

	if ( (aMoveTarget == None) && (vDestination == vect(0.00,0.00,0.00)) )
	{
		logX("Call to GotoStateMovingTo with no aMoveTarget or vDestination");
		GotoState(stateAfter,labelAfter);
	}
	CheckPaceForInjury(ePace);
	m_aMovingToDestination=aMoveTarget;
	if ( m_aMovingToDestination != None )
	{
		m_vMovingDestination=m_aMovingToDestination.Location;
	}
	else
	{
		if ( Trace(m_vMovingDestination,vHitNormal,vDestination - vect(0.00,0.00,200.00),vDestination) != None )
		{
			m_vMovingDestination.Z += 80;
		}
		else
		{
			m_vMovingDestination=vDestination;
		}
	}
	m_bCanFailMovingTo=bCanFail;
//	m_pawn.m_eMovementPace=ePace;
	m_stateAfterMovingTo=stateAfter;
	m_labelAfterMovingTo=labelAfter;
	m_bPreciseMove=bPreciseMove;
	if (  !bDontCheckLeave &&  !m_pawn.m_bAllowLeave &&  !m_pawn.m_DZone.IsPointInZone(m_vMovingDestination) )
	{
		m_vMovingDestination=m_pawn.m_DZone.FindClosestPointTo(m_vMovingDestination);
	}
	GotoState('MovingTo');
	m_sDebugString=sDebugString;
}

state MovingTo
{
	function BeginState ()
	{
//		SetReactionStatus(m_eReactionStatus,m_eStateForEvent);
		if ( m_pawn.m_eMovementPace == 5 )
		{
			m_pawn.m_ePlayerIsUsingHands=HANDS_Both;
			m_pawn.PlayWeaponAnimation();
		}
	}

	function EndState ()
	{
		if ( m_pawn.m_eMovementPace == 5 )
		{
			m_pawn.m_ePlayerIsUsingHands=HANDS_None;
			m_pawn.PlayWeaponAnimation();
		}
		SetTimer(0.00,False);
		m_pawn.m_wWantedHeadYaw=0;
	}

	event bool NotifyBump (Actor Other)
	{
		local R6Pawn aPawn;

		aPawn=R6Pawn(Other);
		if ( aPawn != None )
		{
			if ( aPawn.m_ePawnType == 1 )
			{
				GotoState('MovingTo','Exit');
			}
			else
			{
				if ( aPawn.m_ePawnType == 2 )
				{
					if ( aPawn != m_LastBumped )
					{
						m_LastBumped=aPawn;
						m_fLastBumpedTime=Level.TimeSeconds;
					}
					else
					{
						if ( Level.TimeSeconds > m_fLastBumpedTime + 0.30 + RandRange(0.10,0.30) )
						{
							if ( m_bCanFailMovingTo && (m_LastBumped.Velocity == vect(0.00,0.00,0.00)) )
							{
								GotoState('MovingTo','Exit');
							}
							else
							{
								if ( m_bCantInterruptIO && (R6TerroristAI(aPawn.Controller) != None) )
								{
									R6TerroristAI(aPawn.Controller).GotoBumpBackUpState(aPawn.Controller.GetStateName());
								}
								GotoState('MovingTo','WaitLastBumped');
							}
							return True;
						}
					}
				}
			}
		}
		return False;
	}

	function bool GetReacheablePoint (out Vector vTarget)
	{
		local Vector vDirection;
		local float fTemp;

		vDirection=Pawn.Location - m_LastBumped.Location;
		vDirection.Z=0.00;
		vDirection=Normal(vDirection) * Pawn.CollisionRadius * 4;
		vTarget=Pawn.Location + vDirection;
		if ( pointReachable(vTarget) )
		{
			return True;
		}
		fTemp= -vDirection.X;
		vDirection.X=vDirection.Y;
		vDirection.Y=fTemp;
		vTarget=Pawn.Location + vDirection;
		if ( pointReachable(vTarget) )
		{
			return True;
		}
		vDirection.X= -vDirection.X;
		vDirection.Y= -vDirection.Y;
		vTarget=Pawn.Location + vDirection;
		if ( pointReachable(vTarget) )
		{
			return True;
		}
		return False;
	}

	event Timer ()
	{
		m_iStateVariable++;
		switch (m_iStateVariable)
		{
/*			case 4:
			m_iStateVariable=0;
			case 0:
			case 2:
			m_pawn.m_wWantedHeadYaw=0;
			SetTimer(RandRange(1.00,2.00),False);
			break;
			case 1:
			m_pawn.m_wWantedHeadYaw=RandRange(3500.00,10000.00) / 256;
			SetTimer(RandRange(0.50,1.50),False);
			break;
			case 3:
			m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,-3500.00) / 256;
			SetTimer(RandRange(0.50,1.50),False);
			break;
			default:   */
		}
	}

Begin:
	m_iRandomNumber=0;
	m_wBadMoveCount=0;
	if ( VSize(m_vMovingDestination - Pawn.Location) < 10.00 )
	{
		goto ('Exit');
	}
	if ( m_pawn.m_eMovementPace == 4 )
	{
		if ( Rand(2) == 0 )
		{
			m_iStateVariable=0;
		}
		else
		{
			m_iStateVariable=2;
		}
		SetTimer(RandRange(1.00,2.00),False);
	}
	if ( m_pawn.bWantsToCrouch )
	{
		m_pawn.bWantsToCrouch=False;
		Sleep(0.10);
	}
	m_iRandomNumber=0;
PathFinding:
	if ( (m_aMovingToDestination != None) && actorReachable(m_aMovingToDestination) || pointReachable(m_vMovingDestination) )
	{
		goto ('EndPath');
	}
	if ( m_aMovingToDestination != None )
	{
		MoveTarget=FindPathToward(m_aMovingToDestination);
	}
	else
	{
		MoveTarget=FindPathTo(m_vMovingDestination,True);
	}
	if ( MoveTarget == None )
	{
		Sleep(0.50);
		goto ('Exit');
	}
	if ( (m_iRandomNumber == 0) && (m_pawn.m_eDefCon > 2) )
	{
		m_iRandomNumber=1;
		FocalPoint=MoveTarget.Location;
		FinishRotation();
	}
//	R6PreMoveTo(MoveTarget.Location,MoveTarget.Location,m_pawn.m_eMovementPace);
	MoveToward(MoveTarget);
	if ( m_eMoveToResult == 2 )
	{
		m_wBadMoveCount++;
		if ( m_bCanFailMovingTo && (m_wBadMoveCount > 2) )
		{
			goto ('Exit');
		}
	}
	else
	{
		m_wBadMoveCount=0;
	}
	goto ('PathFinding');
EndPath:
	if ( (m_iRandomNumber == 0) && (m_pawn.m_eDefCon > 2) )
	{
		m_iRandomNumber=1;
		FocalPoint=m_vMovingDestination;
		FinishRotation();
	}
//	R6PreMoveTo(m_vMovingDestination,m_vMovingDestination,m_pawn.m_eMovementPace);
	if ( m_aMovingToDestination != None )
	{
		MoveToward(m_aMovingToDestination);
	}
	else
	{
		MoveTo(m_vMovingDestination);
	}
Exit:
	if (  !m_bCanFailMovingTo )
	{
		if ( m_aMovingToDestination != None )
		{
			if ( VSize(m_vMovingDestination - Pawn.Location) > Pawn.CollisionRadius + m_aMovingToDestination.CollisionRadius + 10.00 )
			{
				goto ('Begin');
			}
		}
		else
		{
			if ( VSize(m_vMovingDestination - Pawn.Location) > Pawn.CollisionRadius * 2.00 )
			{
				goto ('Begin');
			}
		}
	}
	StopMoving();
	GotoState(m_stateAfterMovingTo,m_labelAfterMovingTo);
WaitLastBumped:
	if ( GetReacheablePoint(m_vTargetPosition) )
	{
		m_sDebugString="Bumped away";
//		R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,m_pawn.m_eMovementPace);
		MoveTo(m_vTargetPosition);
	}
	StopMoving();
	if ( MoveTarget != None )
	{
		FocalPoint=MoveTarget.Location;
	}
	m_sDebugString="WaitLastBumped";
	if ( m_bCanFailMovingTo )
	{
		Sleep(RandRange(0.00,2.00));
	}
	m_LastBumped=None;
	m_sDebugString="";
	goto ('Begin');
}

event GotoStateEngageByThreat (Vector vThreathLocation)
{
	if (  !CanSafelyChangeState() )
	{
		return;
	}
	m_vThreatLocation=vThreathLocation;
	m_fSearchTime=Level.TimeSeconds + 20;
	GotoState('EngageByThreat');
}

state EngageByThreat
{
	function BeginState ()
	{
//		SetReactionStatus(3,0);
	}

	function EndState ()
	{
		m_pawn.bRotateToDesired=True;
		m_pawn.bPhysicsAnimUpdate=True;
		m_pawn.m_wWantedHeadYaw=0;
	}

Begin:
	Sleep(RandRange(0.10,0.20));
//	ChangeDefCon(1);
	SetActionSpot(FindPlaceToTakeCover(m_vThreatLocation,2000.00));
	if ( m_pActionSpot != None )
	{
//		GotoStateMovingTo("ThreatActionSpot",PACE_Run,True,m_pActionSpot,,'EngageByThreat','ReachedCover');
	}
	else
	{
		if (  !m_pawn.m_bPreventCrouching )
		{
			Pawn.bWantsToCrouch=True;
		}
		Focus=None;
		FocalPoint=m_vThreatLocation;
		StopMoving();
//		SetReactionStatus(2,0);
		goto ('Wait');
	}
ReachedCover:
	if ( m_pActionSpot.m_eCover != 0 )
	{
		if ( m_pActionSpot.m_eCover == 1 )
		{
			m_r6pawn.bWantsToCrouch=False;
		}
		else
		{
			m_r6pawn.bWantsToCrouch=True;
		}
	}
	else
	{
		if ( m_pActionSpot.m_eFire == 1 )
		{
			m_r6pawn.bWantsToCrouch=False;
		}
		else
		{
			m_r6pawn.bWantsToCrouch=True;
		}
	}
	MoveToPosition(m_pActionSpot.Location,m_pActionSpot.Rotation);
	Focus=None;
	FocalPoint=m_vThreatLocation;
	StopMoving();
//	SetReactionStatus(2,0);
Wait:
	if ( m_fSearchTime < Level.TimeSeconds )
	{
		GotoStateNoThreat();
	}
	if ( Rand(3) == 0 )
	{
		m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,10000.00) / 256;
		Sleep(RandRange(1.00,2.50));
	}
	m_pawn.m_wWantedHeadYaw=0;
	Sleep(RandRange(1.00,5.00));
	goto ('Wait');
}

function GotoStateEngageBySound (Vector vInvestigateDestination, eMovementPace ePace, float fSearchTime)
{
	m_vThreatLocation=vInvestigateDestination;
//	m_pawn.m_eMovementPace=ePace;
	m_fSearchTime=Level.TimeSeconds + fSearchTime;
	GotoState('EngageBySound');
}

state EngageBySound
{
	function BeginState ()
	{
//		SetReactionStatus(0,0);
		m_pawn.m_bAvoidFacingWalls=True;
	}

	function EndState ()
	{
		m_vHostageReactionDirection=vect(0.00,0.00,0.00);
		m_pawn.m_wWantedHeadYaw=0;
		m_pawn.m_bAvoidFacingWalls=False;
	}

	function Vector ChooseARandomPoint ()
	{
		SetActionSpot(FindInvestigationPoint(m_iCurrentGroupID,2000.00));
		if ( m_pActionSpot == None )
		{
			return GetNextRandomNode().Location;
		}
		m_pActionSpot.m_iLastInvestigateID=m_iCurrentGroupID;
		return m_pActionSpot.Location;
	}

Begin:
	StopMoving();
	Focus=None;
	FocalPoint=m_vThreatLocation;
	FinishRotation();
	Sleep(RandRange(0.25,0.50));
	m_pawn.TurnAwayFromNearbyWalls();
	Sleep(RandRange(0.25,1.00));
	if ( m_fSearchTime < Level.TimeSeconds )
	{
		goto ('Exit');
	}
	if (  !m_pawn.m_bAllowLeave )
	{
		goto ('GoCloserAndLook');
	}
	SetActionSpot(FindInvestigationPoint(m_iCurrentGroupID,2000.00,True,m_vThreatLocation));
	if ( m_pActionSpot != None )
	{
		m_pActionSpot.m_iLastInvestigateID=m_iCurrentGroupID;
//		GotoStateMovingTo("SoundActionSpot",m_pawn.m_eMovementPace,True,m_pActionSpot,,'EngageBySound','AtDestination');
	}
	else
	{
//		GotoStateMovingTo("SoundThreatLocation",m_pawn.m_eMovementPace,True,,m_vThreatLocation,'EngageBySound','AtDestination');
	}
AtDestination:
//	m_pawn.m_eMovementPace=4;
	goto ('AtRandomPoint');
WaitHere:
	if ( m_fSearchTime < Level.TimeSeconds )
	{
		goto ('Exit');
	}
	if ( Rand(4) == 0 )
	{
		ChangeOrientationTo(ChooseRandomDirection(50));
		Sleep(RandRange(2.00,4.00));
	}
	if ( Rand(2) == 0 )
	{
		m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,10000.00) / 256;
		Sleep(RandRange(1.00,2.50));
		m_pawn.m_wWantedHeadYaw=0;
	}
	Sleep(RandRange(1.00,4.00));
	goto ('WaitHere');
ChooseDestination:
	if ( m_fSearchTime < Level.TimeSeconds )
	{
		goto ('Exit');
	}
	Destination=ChooseARandomPoint();
//	GotoStateMovingTo("EBSRndPoint",m_pawn.m_eMovementPace,True,,Destination,'EngageBySound','AtRandomPoint');
AtRandomPoint:
	if ( m_pActionSpot != None )
	{
		ChangeOrientationTo(m_pActionSpot.Rotation);
	}
	if ( Rand(2) == 0 )
	{
		m_pawn.m_wWantedHeadYaw=RandRange(5000.00,10000.00) / 256;
		Sleep(RandRange(1.00,2.50));
		m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,-5000.00) / 256;
		Sleep(RandRange(1.00,2.50));
	}
	else
	{
		m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,-5000.00) / 256;
		Sleep(RandRange(1.00,2.50));
		m_pawn.m_wWantedHeadYaw=RandRange(5000.00,10000.00) / 256;
		Sleep(RandRange(1.00,2.50));
	}
	m_pawn.m_wWantedHeadYaw=0;
	goto ('ChooseDestination');
GoCloserAndLook:
//	GotoStateMovingTo("EBSThreatLoc",m_pawn.m_eMovementPace,True,,m_vThreatLocation,'EngageBySound','AtClosest');
AtClosest:
	FocalPoint=m_vThreatLocation;
	FinishRotation();
	Sleep(RandRange(3.00,5.00));
Exit:
	GotoStateNoThreat();
}

function SecureTerrorist (R6Pawn pOther)
{
	ChangeOrientationTo(rotator(Pawn.Location - pOther.Location));
	SetEnemy(pOther);
	GotoState('Surrender','Secure');
}

state Surrender
{
	ignores  GotoPointAndSearch;

	function BeginState ()
	{
//		SetReactionStatus(5,0);
	}

	function EscortIsOver (R6HostageAI hostageAI, bool bSuccess)
	{
		m_Manager.RemoveHostageAssignment(m_Hostage);
	}

	function AIAffectedByGrenade (Actor aGrenade, EGrenadeType eType)
	{
	}

Begin:
	StopMoving();
	FinishRotation();
	if ( m_pawn.m_bIsUnderArrest || m_pawn.m_bIsKneeling )
	{
//		stop
	}
	m_pawn.m_bPreventWeaponAnimation=True;
//	m_pawn.SetNextPendingAction(PENDING_Blinded1);
	Sleep(0.33);
//	m_pawn.SetNextPendingAction(PENDING_DropWeapon);
//	FinishAnim(m_pawn.16);
//	m_pawn.SetNextPendingAction(PENDING_Blinded2);
JL008A:
	if (  !m_pawn.m_bIsKneeling )
	{
		Sleep(1.00);
//		goto JL008A;
	}
	R6AbstractGameInfo(Level.Game).RemoveTerroFromList(m_pawn);
	R6AbstractGameInfo(Level.Game).PawnSecure(m_pawn);
//	stop
Secure:
	FinishRotation();
	m_pawn.m_bIsUnderArrest=True;
	R6AbstractGameInfo(Level.Game).PawnSecure(m_pawn);
	m_pawn.SetCollision(False,False,False);
//	m_pawn.SetNextPendingAction(PENDING_Blinded3);
}

state RunAway
{
	function BeginState ()
	{
//		SetReactionStatus(5,1);
	}

	event GotoPointToAttack (Vector vDestination, Actor PTarget)
	{
	}

Begin:
	if ( Pawn.bIsCrouched )
	{
		m_pawn.bWantsToCrouch=False;
		Sleep(0.10);
	}
ChooseDestination:
	if (  !MakePathToRun() || (RouteGoal == None) )
	{
		GotoStateSprayFire();
	}
//	GotoStateMovingTo("AttackReloadCover",PACE_Run,True,RouteGoal,,'RunAway','ChooseDestination');
	goto ('ChooseDestination');
}

state WaitForEnemy
{
	function BeginState ()
	{
//		SetReactionStatus(3,0);
	}

	function EndState ()
	{
		m_pawn.m_bAvoidFacingWalls=False;
		Focus=None;
		FocalPoint=Enemy.Location;
	}

	function SeePlayer (Pawn seen)
	{
		if ( IsAnEnemy(R6Pawn(seen)) )
		{
			SetEnemy(seen);
			if ( Rand(2) == 0 )
			{
				GotoStateSprayFire();
			}
			else
			{
				GotoStateAimedFire();
			}
		}
	}

	function Timer ()
	{
		GotoStateNoThreat();
	}

Begin:
	Focus=Enemy;
	FocalPoint=LastSeenPos;
	StopMoving();
	if (  !m_pawn.m_bPreventCrouching )
	{
		Pawn.bWantsToCrouch=True;
	}
	SetTimer(10.00,False);
	m_pawn.m_bAvoidFacingWalls=True;
Wait:
}

function GotoStateAimedFire ()
{
//	m_eAttackMode=1;
	m_pawn.m_bSprayFire=False;
	GotoState('Attack');
}

function GotoStateSprayFire ()
{
	m_pawn.m_bSprayFire=True;
	if ( (m_eAttackMode == 0) && (Rand(2) == 0) )
	{
//		m_eAttackMode=3;
	}
	else
	{
//		m_eAttackMode=2;
	}
	GotoState('Attack');
}

state Attack
{
	function BeginState ()
	{
//		SetReactionStatus(4,2);
		if ( Pawn.IsAlive() && (Pawn.m_bDroppedWeapon || (Pawn.EngineWeapon == None)) )
		{
			m_pawn.ServerForceKillResult(4);
			m_pawn.R6TakeDamage(1000,1000,m_pawn,m_pawn.Location,vect(0.00,0.00,0.00),0);
		}
		if ( m_eAttackMode == 0 )
		{
			GotoStateNoThreat();
			return;
		}
		m_pawn.m_bEngaged=True;
		m_pawn.PlayWaiting();
		Focus=Enemy;
		m_sDebugString="";
	}

	function EndState ()
	{
		m_pawn.m_bEngaged=False;
		m_pawn.m_wWantedAimingPitch=0;
		StopFiring();
		Focus=None;
		if ( Enemy != None )
		{
			FocalPoint=Enemy.Location;
		}
		m_sDebugString="";
	}

	function bool NeedToReload ()
	{
		if ( Pawn.EngineWeapon.NumberOfBulletsLeftInClip() == 0 )
		{
			return True;
		}
		if ( (Pawn.EngineWeapon.m_eWeaponType == 5) && (Pawn.EngineWeapon.NumberOfBulletsLeftInClip() < Pawn.EngineWeapon.GetClipCapacity() - 50) )
		{
			return True;
		}
		return False;
	}

	function FindNextEnemy ()
	{
		local R6Pawn aPawn;

		if ( Enemy != None )
		{
			FocalPoint=Enemy.Location;
		}
		SetEnemy(None);
		foreach VisibleCollidingActors(Class'R6Pawn',aPawn,5000.00,m_pawn.Location)
		{
			if ( m_pawn.IsEnemy(aPawn) && aPawn.IsAlive() )
			{
				SetEnemy(aPawn);
				Focus=Enemy;
				return;
			}
		}
		if ( m_eAttackMode == 3 )
		{
			if ( pointReachable(LastSeenPos) )
			{
				m_vMovingDestination=LastSeenPos;
				GotoState('Attack','SprayFireMove');
			}
		}
		else
		{
			GotoStateLostSight(LastSeenPos);
		}
	}

	event bool NotifyBump (Actor Other)
	{
		return True;
	}

Begin:
	if ( m_pawn.m_eEffectiveGrenade != 0 )
	{
		ReactToGrenade(m_pawn.m_vGrenadeLocation);
	}
	m_sDebugString="Begin";
	StopMoving();
	m_bFireShort=False;
	if ( m_pActionSpot != None )
	{
		m_iRandomNumber=Rand(100);
		if ( m_iRandomNumber < 60 )
		{
			m_bFireShort=True;
		}
		else
		{
			if ( m_iRandomNumber < 80 )
			{
				SetActionSpot(None);
			}
			else
			{
				goto ('MoveToFireSpot');
			}
		}
	}
	if (  !m_pawn.m_bPreventCrouching &&  !Pawn.bIsCrouched && (Rand(3) == 0) )
	{
		Pawn.bWantsToCrouch=True;
		Sleep(0.10);
	}
	Target=Enemy;
	m_sDebugString="FinishRotation2";
	FinishRotation();
ReactionTime:
	switch (m_pawn.m_iDiffLevel)
	{
/*		case 1:
		Sleep(1.00);
		break;
		case 2:
		Sleep(0.50);
		break;
		case 3:
		break;
		default:    */
	}
	CallVisibleTerrorist();
Fire:
	if ( (m_eAttackMode != 3) || CanSee(Enemy) )
	{
		Focus=Enemy;
	}
	m_sDebugString="Fire";
	if ( NeedToReload() )
	{
		goto ('Reload');
	}
	if ( m_eAttackMode == 4 )
	{
		SetGunDirection(None);
		if ( VSize(Pawn.Location - Destination) < Pawn.CollisionRadius * 2 )
		{
			StopMoving();
//			m_eAttackMode=3;
		}
	}
	else
	{
		if ( (Enemy == None) ||  !R6Pawn(Enemy).IsAlive() )
		{
			if ( m_pawn.m_ePersonality == 5 )
			{
				GotoStateNoThreat();
			}
			else
			{
				FindNextEnemy();
			}
		}
		m_sDebugString="CheckLineOfSight";
		if ( (Enemy != None) &&  !HaveAClearShot(m_pawn.GetFiringStartPoint(),Enemy) )
		{
			if ( m_pawn.m_ePersonality == 5 )
			{
				SetLowestSnipingStance(Enemy);
				Sleep(0.20);
				goto ('Fire');
			}
			else
			{
				m_vTargetPosition=FindBetterShotLocation(Enemy);
				R6PreMoveTo(m_vTargetPosition,Enemy.Location,PACE_Run);
				MoveTo(m_vTargetPosition,Enemy);
				FocalPoint=Enemy.Location;
				goto ('Fire');
			}
		}
		SetGunDirection(Enemy);
JL02FB:
		if ( (Enemy != None) && Enemy.IsAlive() && (m_pawn.m_wWantedAimingPitch != (m_pawn.m_iCurrentAimingPitch & 65535) / 256) )
		{
			m_sDebugString="SettingPitch";
			Sleep(0.05);
//			goto JL02FB;
		}
	}
	if ( m_eAttackMode == 1 )
	{
JL037C:
		if (  !IsReadyToFire(Enemy) )
		{
			m_sDebugString="ReadyToFire";
			Sleep(0.20);
//			goto JL037C;
		}
	}
	if ( (m_pawn.m_eEffectiveGrenade == 3) || (m_pawn.m_eEffectiveGrenade == 4) || (m_pawn.m_eEffectiveGrenade == 2) )
	{
		Sleep(0.50);
		goto ('ReactionTime');
	}
	m_sDebugString="FinishRotation";
	FinishRotation();
	if ( m_eAttackMode == 1 )
	{
		StartFiring();
		m_sDebugString="AimedFiring";
		if ( Pawn.EngineWeapon.GetRateOfFire() == 2 )
		{
			Sleep(RandRange(0.40,1.00));
		}
		else
		{
			Sleep(0.20);
		}
		StopFiring();
	}
	else
	{
		if ( Pawn.EngineWeapon.GetRateOfFire() == 2 )
		{
			StartFiring();
			m_sDebugString="FiringAuto";
			Sleep(RandRange(0.20,1.50));
			StopFiring();
			SetGunDirection(Target);
			m_sDebugString="StopFiring";
			Sleep(RandRange(0.00,0.50));
		}
		else
		{
			m_iRandomNumber=Rand(4) + 2;
JL0528:
			if ( m_iRandomNumber > 0 )
			{
				StartFiring();
				m_sDebugString="FiringSingle";
				Sleep(RandRange(0.10,0.20));
				StopFiring();
				SetGunDirection(Target);
				m_iRandomNumber--;
//				goto JL0528;
			}
			m_sDebugString="StopFiring2";
			Sleep(RandRange(0.00,0.50));
		}
	}
	if ( m_bFireShort )
	{
		m_bFireShort=False;
		goto ('MoveToFireSpot');
	}
	goto ('ReactionTime');
Reload:
	m_sDebugString="Reload";
//	SetReactionStatus(5,0);
	if ( m_eAttackMode > 2 )
	{
//		m_eAttackMode=2;
	}
	if ( (m_pawn.m_ePersonality != 5) && (Enemy != None) )
	{
		SetActionSpot(FindPlaceToTakeCover(Enemy.Location,GetMaxCoverDistance()));
		if ( m_pActionSpot != None )
		{
//			GotoStateMovingTo("AttackReloadCover",PACE_Run,True,m_pActionSpot,,'Attack','AtCover');
AtCover:
//			SetReactionStatus(5,0);
			MoveToPosition(m_pActionSpot.Location,m_pActionSpot.Rotation);
			Focus=Enemy;
			m_sDebugString="FinishRotation3";
			FinishRotation();
		}
		if (  !m_pawn.m_bPreventCrouching &&  !Pawn.bIsCrouched && (Rand(2) == 0) )
		{
			Pawn.bWantsToCrouch=True;
		}
	}
	Target=None;
	StopMoving();
	AIReloadWeapon();
JL0710:
	if ( m_pawn.m_bReloadingWeapon )
	{
		m_sDebugString="Reloading";
		Sleep(0.10);
//		goto JL0710;
	}
	Target=Enemy;
	SetGunDirection(Target);
	m_sDebugString="EndReloading";
	Sleep(0.40);
//	SetReactionStatus(4,2);
	goto ('Fire');
SprayFireMove:
	m_sDebugString="SprayFireMove";
//	SetReactionStatus(3,2);
//	m_eAttackMode=4;
	if ( VSize(m_vMovingDestination - m_pawn.Location) > 100.00 )
	{
//		R6PreMoveTo(m_vMovingDestination,m_vMovingDestination,4);
		Pawn.SetPhysics(PHYS_Walking);
		Destination=m_vMovingDestination;
		Pawn.Acceleration=Normal(Destination - Pawn.Location) * m_pawn.m_fWalkingSpeed;
	}
	goto ('Fire');
MoveToFireSpot:
	if ( IsAttackSpotStillValid() )
	{
		GotoStateMovingTo("AttackFireSpot",PACE_Run,True,m_pActionSpot,m_vThreatLocation,'Attack','AtFireSpot');
	}
	else
	{
		goto ('Fire');
	}
AtFireSpot:
	MoveToPosition(m_pActionSpot.Location,rotator(m_pActionSpot.Location - Enemy.Location));
	Focus=Enemy;
	if ( m_pActionSpot.m_eFire == 2 )
	{
		m_pawn.bWantsToCrouch=True;
	}
	goto ('Fire');
}

function GotoStateAttackHostage (R6Pawn hostage)
{
	SetEnemy(hostage);
//	m_eAttackMode=1;
	m_pawn.m_bSprayFire=False;
	GotoState('AttackHostage');
}

state AttackHostage extends Attack
{
Begin:
	if ( (R6Hostage(Enemy) == None) || R6Hostage(Enemy).m_bExtracted )
	{
		FindNextEnemy();
	}
	if (  !R6Pawn(Enemy).IsAlive() || CanSee(Enemy) )
	{
		GotoStateAimedFire();
	}
//	SetReactionStatus(3,4);
//	GotoStateMovingTo("Chase hostage",PACE_Run,True,Enemy,,'AttackHostage','Begin');
}

state GuardPoint
{
	function BeginState ()
	{
//		SetReactionStatus(0,0);
	}

	function EndState ()
	{
		m_pawn.m_wWantedHeadYaw=0;
	}

Begin:
//	GotoStateMovingTo("GuardPoint",PACE_Walk,True,,m_vSpawningPosition,'GuardPoint','StartWaiting',,True);
StartWaiting:
	StopMoving();
	ChangeOrientationTo(m_rSpawningRotation);
	FinishRotation();
	if ( m_pawn.m_ePersonality == 5 )
	{
		GotoState('Sniping');
	}
	if (  !m_pawn.m_bPreventCrouching && (m_pawn.m_eStartingStance == 2) )
	{
		Pawn.bWantsToCrouch=True;
	}
	else
	{
		Pawn.bWantsToCrouch=False;
	}
Waiting:
	if ( Rand(3) == 0 )
	{
		m_iRandomNumber=Rand(2);
		if ( m_iRandomNumber == 0 )
		{
			m_iRandomNumber=-1;
		}
		m_pawn.m_wWantedHeadYaw=RandRange(m_iRandomNumber * 5000,m_iRandomNumber * 10000) / 256;
		Sleep(RandRange(1.00,1.50));
		m_iRandomNumber *= -1;
		m_pawn.m_wWantedHeadYaw=RandRange(m_iRandomNumber * 5000,m_iRandomNumber * 10000) / 256;
		Sleep(RandRange(1.25,1.75));
	}
	else
	{
		m_pawn.m_wWantedHeadYaw=RandRange(5000.00,10000.00) / 256;
		if ( Rand(2) == 0 )
		{
			m_pawn.m_wWantedHeadYaw= -m_pawn.m_wWantedHeadYaw;
		}
		Sleep(RandRange(1.00,1.50));
	}
	m_pawn.m_wWantedHeadYaw=0;
	Sleep(RandRange(2.00,6.00));
	goto ('Waiting');
}

state Sniping
{
	function BeginState ()
	{
//		SetReactionStatus(0,0);
	}

	event SeePlayer (Pawn seen)
	{
		local R6Pawn r6seen;

		r6seen=R6Pawn(seen);
		if ( r6seen == None )
		{
			return;
		}
		if ( m_bSeeRainbow && IsAnEnemy(r6seen) )
		{
//			ReconThreatCheck(r6seen,0);
			if ( VSize(seen.Location - m_pawn.Location) < 500 )
			{
				m_pawn.m_bWantsToProne=False;
				if (  !m_pawn.m_bPreventCrouching && (Rand(4) != 0) )
				{
					m_pawn.bWantsToCrouch=True;
				}
			}
			SetEnemy(r6seen);
			Target=Enemy;
			if ( MakeBackupList() )
			{
				CallBackupForAttack(Enemy.Location,PACE_Run);
			}
//			ChangeDefCon(1);
			GotoStateAimedFire();
		}
	}

	event HearNoise (float Loudness, Actor NoiseMaker, ENoiseType eType)
	{
		if ( m_pawn.m_bDontHearPlayer && R6Pawn(NoiseMaker.Instigator).m_bIsPlayer )
		{
			return;
		}
//		ReconThreatCheck(NoiseMaker,eType);
		if ( m_pawn.IsNeutral(NoiseMaker.Instigator) )
		{
			return;
		}
		if ( m_bHearInvestigate && (eType == 1) || m_bHearThreat && (eType == 2) )
		{
//			GotoPointAndSearch(NoiseMaker.Location,4,True,30.00,2);
			if ( m_bHearThreat && (eType == 2) )
			{
				if ( m_iChanceToDetectShooter < 80 )
				{
					m_iChanceToDetectShooter += 20;
				}
				if ( m_pawn.IsEnemy(NoiseMaker.Instigator) )
				{
					if ( Rand(100) + 1 < m_iChanceToDetectShooter )
					{
						SetEnemy(NoiseMaker.Instigator);
						GotoStateAimedFire();
					}
				}
			}
			else
			{
				if ( VSize(NoiseMaker.Location - m_pawn.Location) < 500 )
				{
					m_pawn.m_bWantsToProne=False;
					if (  !m_pawn.m_bPreventCrouching && (Rand(4) != 0) )
					{
						m_pawn.bWantsToCrouch=True;
					}
					FocalPoint=NoiseMaker.Location;
					GotoState('Sniping','CheckBehind');
				}
			}
		}
		else
		{
			if ( m_bHearGrenade && (eType == 3) )
			{
				if (  !m_bHeardGrenade )
				{
//					m_VoicesManager.PlayTerroristVoices(m_pawn,5);
					m_bHeardGrenade=True;
				}
				ReactToGrenade(NoiseMaker.Location);
			}
		}
	}

Begin:
	if ( R6DZonePoint(m_pawn.m_DZone) == None )
	{
		SetLowestSnipingStance();
	}
	else
	{
		switch (R6DZonePoint(m_pawn.m_DZone).m_eStance)
		{
/*			case 1:
			m_pawn.m_bWantsToProne=False;
			m_pawn.bWantsToCrouch=False;
			break;
			case 2:
			m_pawn.m_bWantsToProne=False;
			m_pawn.bWantsToCrouch=True;
			break;
			case 3:
			m_pawn.m_bWantsToProne=True;
			m_pawn.bWantsToCrouch=False;
			break;
			default:    */
		}
	}
//	stop
LostTrackOfEnemy:
	Sleep(RandRange(3.00,7.00));
	ChangeOrientationTo(m_pawn.m_DZone.Rotation);
	FinishRotation();
	GotoStateNoThreat();
CheckBehind:
	FinishRotation();
	Sleep(RandRange(1.00,3.00));
	ChangeOrientationTo(m_pawn.Rotation + rot(0,10000,0));
	Sleep(RandRange(1.00,2.00));
	ChangeOrientationTo(m_pawn.Rotation + rot(0,-20000,0));
	Sleep(RandRange(1.00,2.00));
	ChangeOrientationTo(m_pawn.m_DZone.Rotation);
	FinishRotation();
	GotoStateNoThreat();
}

function HostageSurrender (R6HostageAI hostageAI)
{
	local Vector vDestination;

	if ( UseRandomHostage() )
	{
		return;
	}
	m_HostageAI=hostageAI;
	m_Hostage=hostageAI.m_pawn;
	m_Manager.AssignHostageTo(m_Hostage,self);
	m_ZoneToEscort=m_Manager.FindNearestZoneForHostage(m_pawn);
	if ( m_ZoneToEscort == None )
	{
		m_ZoneToEscort=m_pawn.m_DZone;
	}
	vDestination=m_ZoneToEscort.FindRandomPointInArea();
	m_HostageAI.SetStateEscorted(m_pawn,vDestination,True);
//	GotoStateFollowPawn(R6Pawn(m_HostageAI.Pawn),0,100.00);
}

function EscortIsOver (R6HostageAI hostageAI, bool bSuccess)
{
	if ( bSuccess )
	{
		m_Manager.AssignHostageToZone(m_Hostage,m_ZoneToEscort);
		GotoStateNoThreat();
	}
	else
	{
		m_Manager.RemoveHostageAssignment(m_Hostage);
//		GotoStateEngageBySound(m_Hostage.Location,5,10.00);
	}
}

function GotoStateFindHostage (R6Hostage hostage)
{
	m_Hostage=hostage;
	m_HostageAI=R6HostageAI(hostage.Controller);
	m_Manager.AssignHostageTo(hostage,self);
	GotoState('FindHostage');
}

state FindHostage
{
	function BeginState ()
	{
//		SetReactionStatus(2,3);
	}

	function EndState ()
	{
		Focus=None;
		FocalPoint=Enemy.Location;
	}

	event bool NotifyBump (Actor Other)
	{
		if ( Other == Enemy )
		{
			GotoState('FindHostage','Begin');
		}
		return Global.NotifyBump(Other);
	}

Begin:
	StopMoving();
	SetEnemy(m_Hostage);
	LastSeenTime=Level.TimeSeconds;
	LastSeenPos=Enemy.Location;
	Focus=m_Hostage;
AskToSurrender:
	m_HostageAI.Order_Surrender(m_pawn);
	Pawn.PlayAnim('StandYellAlarm');
	FinishAnim();
	m_iRandomNumber=Rand(100);
	if ( m_iRandomNumber < 50 )
	{
		Sleep(2.00);
		goto ('AskToSurrender');
	}
	else
	{
		if ( m_iRandomNumber < 90 )
		{
			goto ('Pursues');
		}
		else
		{
			goto ('AimedFire');
		}
	}
Pursues:
	if ( CanSee(m_Hostage) && m_Hostage.IsAlive() )
	{
		if ( actorReachable(Enemy) )
		{
			MoveTarget=Enemy;
		}
		else
		{
			MoveTarget=FindPathToward(Enemy);
		}
		if ( MoveTarget == None )
		{
			Sleep(1.00);
		}
		else
		{
//			R6PreMoveTo(MoveTarget.Location,MoveTarget.Location,5);
			MoveToward(MoveTarget);
		}
		goto ('Pursues');
	}
	else
	{
		if ( pointReachable(LastSeenPos) )
		{
			Destination=LastSeenPos;
		}
		else
		{
			MoveTarget=FindPathTo(LastSeenPos);
			Destination=MoveTarget.Location;
		}
//		R6PreMoveTo(Destination,Destination,5);
		MoveTo(Destination);
//		GotoStateEngageBySound(LastSeenPos,5,15.00);
	}
AimedFire:
	GotoStateAimedFire();
}

function GotoStateFollowPawn (R6Pawn followedpawn, EFollowMode eMode, float fDist, optional int iYaw)
{
	m_pawnToFollow=followedpawn;
	m_eFollowMode=eMode;
	m_fFollowDist=fDist;
	m_iFollowYaw=iYaw;
	GotoState('FollowPawn');
}

state FollowPawn
{
	function BeginState ()
	{
//		SetReactionStatus(m_eReactionStatus,m_eStateForEvent);
	}

	function EndState ()
	{
		Focus=None;
	}

	function Vector GetFollowDestination ()
	{
		local float fDist;
		local Vector vDir;
		local Vector vTargetPos;
		local Rotator rOrientation;

		if ( m_iFollowYaw == 0 )
		{
			vTargetPos=m_pawnToFollow.Location + Normal(Pawn.Location - m_pawnToFollow.Location) * m_fFollowDist;
		}
		else
		{
			rOrientation.Yaw=m_pawnToFollow.Rotation.Yaw + m_iFollowYaw;
			vTargetPos=m_pawnToFollow.Location - vector(rOrientation) * m_fFollowDist;
		}
		FindSpot(vTargetPos);
		return vTargetPos;
	}

Moving:
Begin:
	if (  !m_pawnToFollow.IsAlive() )
	{
		GotoStateNoThreat();
	}
	m_fPawnDistance=DistanceTo(m_pawnToFollow);
	if ( m_fPawnDistance < m_fFollowDist + Pawn.CollisionRadius )
	{
		StopMoving();
		if ( (m_eFollowMode == 1) && R6Terrorist(m_pawnToFollow).m_controller.m_bWaiting )
		{
			GotoState('PatrolPath','ReachedNode');
		}
		Sleep(0.20);
		goto ('Moving');
	}
	m_vMovingDestination=GetFollowDestination();
//	m_pawn.m_eMovementPace=4;
	if (  !pointReachable(m_vMovingDestination) )
	{
		MoveTarget=FindPathTo(m_vMovingDestination);
		if ( MoveTarget != None )
		{
			m_vMovingDestination=MoveTarget.Location;
		}
	}
	if ( m_fPawnDistance > 500.00 )
	{
//		m_pawn.m_eMovementPace=5;
	}
//	R6PreMoveTo(m_vMovingDestination,m_vMovingDestination,m_pawn.m_eMovementPace);
	MoveTo(m_vMovingDestination);
	goto ('Moving');
}

state PatrolArea
{
	function BeginState ()
	{
//		SetReactionStatus(0,0);
		m_pawn.m_bAvoidFacingWalls=True;
	}

	function EndState ()
	{
		m_pawn.m_wWantedHeadYaw=0;
		m_pawn.m_bAvoidFacingWalls=False;
	}

Begin:
//	m_pawn.m_eMovementPace=4;
ChooseDestination:
	m_vTargetPosition=m_pawn.m_DZone.FindRandomPointInArea();
//	GotoStateMovingTo("PatrolArea",PACE_Walk,True,,m_vTargetPosition,'PatrolArea','AtDestination');
AtDestination:
	if ( Rand(3) != 0 )
	{
		if ( Rand(2) == 0 )
		{
			m_pawn.m_wWantedHeadYaw=RandRange(5000.00,10000.00) / 256;
			Sleep(RandRange(1.00,2.50));
			m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,-5000.00) / 256;
			Sleep(RandRange(1.00,2.50));
		}
		else
		{
			m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,-5000.00) / 256;
			Sleep(RandRange(1.00,2.50));
			m_pawn.m_wWantedHeadYaw=RandRange(5000.00,10000.00) / 256;
			Sleep(RandRange(1.00,2.50));
		}
		m_pawn.m_wWantedHeadYaw=0;
	}
	Sleep(RandRange(1.00,2.00));
	goto ('ChooseDestination');
}

function float GetWaitingTime ()
{
	local float fTemp;

	switch (m_pawn.m_eDefCon)
	{
/*		case 1:
		fTemp=1.00;
		break;
		case 2:
		fTemp=2.00;
		break;
		case 3:
		fTemp=3.00;
		break;
		case 4:
		fTemp=4.00;
		break;
		case 5:
		fTemp=5.00;
		break;
		default:   */
	}
	return RandRange(fTemp,fTemp + fTemp);
}

function float GetFacingTime ()
{
	local int fTemp;

	switch (m_pawn.m_eDefCon)
	{
/*		case 1:
		fTemp=1;
		break;
		case 2:
		fTemp=2;
		break;
		case 3:
		fTemp=3;
		break;
		case 4:
		fTemp=4;
		break;
		case 5:
		fTemp=5;
		break;
		default:    */
	}
	return RandRange(fTemp,fTemp + fTemp);
}

function bool IsGoingBack ()
{
	local int ITemp;

	switch (m_pawn.m_eDefCon)
	{
/*		case 1:
		ITemp=30;
		break;
		case 2:
		ITemp=25;
		break;
		case 3:
		ITemp=20;
		break;
		case 4:
		ITemp=10;
		break;
		case 5:
		ITemp=0;
		break;
		default:     */
	}
	return Rand(100) + 1 < ITemp;
}

function Rotator ChooseRandomDirection (int iLookBackChance)
{
	local int ITemp;

	switch (m_pawn.m_eDefCon)
	{
/*		case 1:
		ITemp=25;
		break;
		case 2:
		ITemp=20;
		break;
		case 3:
		ITemp=15;
		break;
		case 4:
		ITemp=10;
		break;
		case 5:
		ITemp=5;
		break;
		default:          */
	}
	return Super.ChooseRandomDirection(ITemp);
}

function ReachedTheNode ()
{
	m_bWaiting=True;
//	m_path.InformTerroTeam(1,self);
}

function FinishedWaiting ()
{
	m_bWaiting=True;
//	m_path.InformTerroTeam(2,self);
}

function GotoNode (Vector VPosition)
{
	m_bWaiting=False;
//	GotoStateMovingTo("GotoNode",PACE_Walk,True,,VPosition,'PatrolPath','ReachedNode',True);
}

function FollowLeader (R6Terrorist Leader, Vector VOffset)
{
	m_bWaiting=False;
//	GotoStateFollowPawn(Leader,1,VSize(VOffset),rotator(VOffset).Yaw);
}

function WaitAtNode (float fWaitingTime, float fFacingTime, Rotator rOrientation)
{
	m_bWaiting=False;
	m_fWaitingTime=fWaitingTime;
	m_fFacingTime=fFacingTime;
	m_rStandRotation=rOrientation;
	GotoState('PatrolPath','WaitingAtNode');
}

state PatrolPath
{
	function BeginState ()
	{
//		SetReactionStatus(0,0);
	}

	function EndState ()
	{
		m_pawn.m_wWantedHeadYaw=0;
		m_pawn.m_bAvoidFacingWalls=False;
//		m_pawn.ClearChannel(m_pawn.16);
	}

Begin:
	if ( m_PatrolCurrentLabel != 'None' )
	{
		goto (m_PatrolCurrentLabel);
	}
	FinishedWaiting();
//	stop
ReachedNode:
	m_PatrolCurrentLabel='ReachedNode';
	ReachedTheNode();
//	stop
WaitingAtNode:
	m_PatrolCurrentLabel='WaitingAtNode';
	StopMoving();
	ChangeOrientationTo(m_rStandRotation);
	FinishRotation();
	if ( m_currentNode.bDirectional )
	{
		m_pawn.m_wWantedAimingPitch=m_currentNode.Rotation.Pitch / 256;
	}
	else
	{
		m_pawn.m_bAvoidFacingWalls=True;
	}
	if ( m_currentNode.m_AnimToPlay != 'None' )
	{
		if ( Rand(100) < m_currentNode.m_AnimChance )
		{
			if ( m_currentNode.m_SoundToPlay != None )
			{
//				m_pawn.PlayVoices(m_currentNode.m_SoundToPlay,6,15);
			}
			m_pawn.m_szSpecialAnimName=m_currentNode.m_AnimToPlay;
//			m_pawn.SetNextPendingAction(PENDING_Blinded5);
//			FinishAnim(m_pawn.16);
		}
	}
	if ( (m_fWaitingTime > 0) && (m_pawn.m_eDefCon <= 2) )
	{
		if (  !m_pawn.m_bPreventCrouching && (Rand(2) == 0) )
		{
			m_pawn.bWantsToCrouch=True;
		}
	}
	if ( m_fFacingTime < m_fWaitingTime )
	{
		Sleep(m_fFacingTime);
		m_pawn.m_wWantedAimingPitch=0;
		ChangeOrientationTo(ChooseRandomDirection(-1));
		Sleep(m_fWaitingTime - m_fFacingTime);
		FinishRotation();
	}
	else
	{
		if (  !m_currentNode.bDirectional && (Rand(3) != 0) )
		{
			if ( Rand(2) == 0 )
			{
				m_pawn.m_wWantedHeadYaw=RandRange(5000.00,10000.00) / 256;
				Sleep(m_fWaitingTime / 3);
				m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,-5000.00) / 256;
				Sleep(m_fWaitingTime / 3);
			}
			else
			{
				m_pawn.m_wWantedHeadYaw=RandRange(-10000.00,-5000.00) / 256;
				Sleep(m_fWaitingTime / 3);
				m_pawn.m_wWantedHeadYaw=RandRange(5000.00,10000.00) / 256;
				Sleep(m_fWaitingTime / 3);
			}
			m_pawn.m_wWantedHeadYaw=0;
			Sleep(m_fWaitingTime / 3);
		}
		else
		{
			Sleep(m_fWaitingTime);
		}
		m_pawn.m_wWantedAimingPitch=0;
	}
	FinishedWaiting();
	m_pawn.m_bAvoidFacingWalls=False;
	m_pawn.bWantsToCrouch=False;
}

state HuntRainbow
{
	function BeginState ()
	{
//		SetReactionStatus(0,0);
	}

	function R6Pawn GetClosestEnemy ()
	{
		local R6Pawn aEnemy;
		local R6Pawn aClosestEnemy;
		local float fDist;
		local float fBestDist;

		foreach DynamicActors(Class'R6Pawn',aEnemy)
		{
			if ( m_pawn.IsEnemy(aEnemy) && aEnemy.IsAlive() )
			{
				fDist=VSize(aEnemy.Location - Pawn.Location);
				if ( (fDist < fBestDist) || (fBestDist == 0) )
				{
					fBestDist=fDist;
					aClosestEnemy=aEnemy;
				}
			}
		}
		return aClosestEnemy;
	}

FindNewEnemy:
Begin:
	if ( (m_huntedPawn != None) &&  !m_huntedPawn.IsAlive() )
	{
		m_huntedPawn=None;
	}
	if ( m_huntedPawn == None )
	{
		SetEnemy(GetClosestEnemy());
	}
	else
	{
		SetEnemy(m_huntedPawn);
	}
nextNode:
	if ( (R6Pawn(Enemy) != None) && R6Pawn(Enemy).IsAlive() )
	{
		MoveTarget=FindPathToward(Enemy);
		if ( MoveTarget != None )
		{
//			GotoStateMovingTo("HuntRainbow",PACE_Walk,True,MoveTarget,,'HuntRainbow','nextNode',True);
		}
	}
	Sleep(1.00);
	goto ('FindNewEnemy');
}

function bool CanInteractWithObjects (R6InteractiveObject o)
{
	if ( (m_InteractionObject == None) && (m_pawn != None) && m_pawn.IsAlive() && (m_eReactionStatus == 0) && (m_pawn.m_eDefCon >= 3) && (m_pawn.m_eStrategy != 3) )
	{
		return True;
	}
	return False;
}

function PerformAction_StopInteraction ()
{
	if ( m_bCalledForBackup || (m_InteractionObject.m_SeePlayerPawn != None) || (m_InteractionObject.m_HearNoiseNoiseMaker != None) )
	{
//		ChangeDefCon(2);
	}
	Super.PerformAction_StopInteraction();
	if ( m_bCalledForBackup &&  !m_bCantInterruptIO )
	{
		m_bCalledForBackup=False;
		m_InteractionObject=None;
		GotoPointToAttack(m_vThreatLocation,Target);
	}
}

state PA_PlayAnim
{
	function EndState ()
	{
//		m_pawn.SetNextPendingAction(PENDING_Blinded7);
		Super.EndState();
	}

Begin:
	m_pawn.m_szSpecialAnimName=m_AnimName;
//	m_pawn.SetNextPendingAction(PENDING_Blinded5);
//	FinishAnim(m_pawn.16);
//	AnimBlendToAlpha(m_pawn.16,0.00,0.50);
	m_pawn.m_ePlayerIsUsingHands=HANDS_None;
	m_pawn.PlayWeaponAnimation();
	m_pawn.m_bPawnSpecificAnimInProgress=False;
	m_InteractionObject.FinishAction();
}

state PA_LoopAnim
{
	function BeginState ()
	{
		m_fSearchTime=Level.TimeSeconds + m_fLoopAnimTime;
		Super.BeginState();
	}

	function EndState ()
	{
//		m_pawn.SetNextPendingAction(PENDING_Blinded7);
		Super.EndState();
	}

Begin:
	m_pawn.m_szSpecialAnimName=m_AnimName;
//	m_pawn.SetNextPendingAction(PENDING_Blinded6);
	if ( m_fLoopAnimTime != 0.00 )
	{
		Sleep(m_fLoopAnimTime);
	}
	else
	{
//		stop
	}
	m_InteractionObject.FinishAction();
}

defaultproperties
{
    bIsPlayer=True
}
