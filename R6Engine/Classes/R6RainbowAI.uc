//================================================================================
// R6RainbowAI.
//================================================================================
class R6RainbowAI extends R6AIController
	Native;

enum eCoverDirection {
	COVER_Left,
	COVER_Center,
	COVER_Right,
	COVER_None
};

enum ePawnOrientation {
	PO_Front,
	PO_FrontRight,
	PO_Right,
	PO_Left,
	PO_FrontLeft,
	PO_Back,
	PO_PeekLeft,
	PO_PeekRight
};

enum eFormation {
	FORM_SingleFile,
	FORM_SingleFileWallBothSides,
	FORM_SingleFileWallRight,
	FORM_SingleFileWallLeft,
	FORM_SingleFileNoWalls,
	FORM_OrientedSingleFile,
	FORM_Diamond
};

enum eRoomLayout {
	ROOM_OpensCenter,
	ROOM_OpensLeft,
	ROOM_OpensRight,
	ROOM_None
};

enum eDeviceAnimToPlay {
	BA_ArmBomb,
	BA_DisarmBomb,
	BA_Keypad,
	BA_PlantDevice,
	BA_Keyboard
};

var eFormation m_eFormation;
var ePawnOrientation m_ePawnOrientation;
var eRoomLayout m_eCurrentRoomLayout;
var eCoverDirection m_eCoverDirection;
var int m_iStateProgress;
var int m_iTurn;
var int m_iWaitCounter;
var int m_iActionUseGadgetGroup;
var bool m_bTeamMateHasBeenKilled;
var bool m_bIsCatchingUp;
var bool m_bIsMovingBackwards;
var bool m_bSlowedPace;
var bool m_bAlreadyWaiting;
var bool m_bReactToNoise;
var bool m_bUseStaggeredFormation;
var bool m_bWeaponsDry;
var bool m_bAimingWeaponAtEnemy;
var bool m_bEnteredRoom;
var bool m_bIndividualAttacks;
var bool m_bStateFlag;
var bool m_bReorganizationPending;
var float m_fLastReactionToGas;
var float m_fGrenadeDangerRadius;
var float m_fAttackTimerRate;
var float m_fAttackTimerCounter;
var float m_fFiringAttackTimer;
var R6Rainbow m_pawn;
var R6RainbowTeam m_TeamManager;
var R6Rainbow m_TeamLeader;
var R6Rainbow m_PaceMember;
var Actor m_NextMoveTarget;
var R6IORotatingDoor m_RotatingDoor;
var Actor m_ActionTarget;
var Actor m_DesiredTarget;
var R6CommonRainbowVoices m_CommonMemberVoicesMgr;
var name m_PostFindPathToState;
var name m_PostLockPickState;
var Vector m_vLocationOnTarget;
var Vector m_vGrenadeLocation;
var Vector m_vDesiredLocation;
var Vector m_vNoiseFocalPoint;
var Vector m_vPreEntryPositions[2];

native(2202) final function Vector GetTargetPosition ();

native(2203) final function Vector GetLadderPosition ();

native(2204) final function Vector GetGuardPosition ();

native(2205) final function Vector GetEntryPosition (bool bInsideRoom);

native(2206) final function Vector CheckEnvironment ();

native(2207) final function SetOrientation (optional ePawnOrientation eOverrideOrientation);

native(2219) final function LookAroundRoom (bool bIsLeadingRoomEntry);

native(2221) final function Actor FindSafeSpot ();

native(2222) final function bool AClearShotIsAvailable (Pawn PTarget, Vector vStart);

native(2223) final function bool ClearToSnipe (Vector vStart, Rotator rSnipingDir);

function Possess (Pawn aPawn)
{
	Super.Possess(aPawn);
	m_pawn=R6Rainbow(aPawn);
	m_pawn.bRotateToDesired=True;
	PlayerReplicationInfo=None;
	aPawn.PlayerReplicationInfo=None;
}

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( Role == Role_Authority )
	{
		m_CommonMemberVoicesMgr=R6CommonRainbowVoices(R6AbstractGameInfo(Level.Game).GetCommonRainbowMemberVoicesMgr());
	}
}

function UpdatePosture ()
{
	if (  !m_PaceMember.m_bPostureTransition && ((m_PaceMember.m_bIsProne != Pawn.m_bIsProne) || (m_PaceMember.bIsCrouched != Pawn.bIsCrouched)) )
	{
		if ( m_PaceMember.m_bIsProne &&  !m_PaceMember.m_bIsSniping )
		{
			Pawn.m_bWantsToProne=True;
		}
		else
		{
			if ( m_PaceMember.bIsCrouched )
			{
				Pawn.bWantsToCrouch=True;
				Pawn.m_bWantsToProne=False;
			}
			else
			{
				Pawn.bWantsToCrouch=False;
				Pawn.m_bWantsToProne=False;
			}
		}
	}
}

function bool PostureHasChanged ()
{
	if ( Pawn.m_bIsProne != Pawn.m_bWantsToProne )
	{
		return True;
	}
	if ( Pawn.m_bIsProne )
	{
		return False;
	}
	if ( Pawn.bIsCrouched != Pawn.bWantsToCrouch )
	{
		return True;
	}
	return False;
}

function R6SetMovement (eMovementPace ePace)
{
	local bool bIndependantPace;

	if ( ePace == 0 )
	{
		bIndependantPace=False;
		if ( (m_PaceMember == None) || (m_TeamLeader == None) )
		{
			return;
		}
		UpdatePosture();
//		m_pawn.m_eMovementPace=m_PaceMember.m_eMovementPace;
	}
	else
	{
		bIndependantPace=True;
		if (  !Pawn.m_bIsProne && (ePace == 1) )
		{
			Pawn.m_bWantsToProne=True;
		}
		else
		{
			if ( Pawn.m_bIsProne && (ePace != 1) )
			{
				Pawn.m_bWantsToProne=False;
				Pawn.bWantsToCrouch=True;
			}
			else
			{
				if ( Pawn.bIsCrouched )
				{
					if ( (ePace == 4) || (ePace == 5) )
					{
						Pawn.bWantsToCrouch=False;
					}
				}
				else
				{
					if ( (ePace == 2) || (ePace == 3) )
					{
						Pawn.bWantsToCrouch=True;
					}
				}
			}
		}
//		m_pawn.m_eMovementPace=ePace;
	}
	if ( (m_TeamLeader == None) || bIndependantPace )
	{
		if ( (m_pawn.m_eMovementPace == 4) || (m_pawn.m_eMovementPace == 2) )
		{
			Pawn.SetWalking(True);
		}
		else
		{
			if ( (m_pawn.m_eMovementPace == 5) || (m_pawn.m_eMovementPace == 3) )
			{
				Pawn.SetWalking(False);
			}
		}
		return;
	}
	if (  !m_PaceMember.IsMovingForward() &&  !Pawn.m_bIsProne )
	{
		if ( m_PaceMember.bIsWalking )
		{
			m_bSlowedPace=True;
		}
		else
		{
			if ( m_PaceMember.bIsCrouched )
			{
				m_bSlowedPace=True;
//				m_pawn.m_eMovementPace=2;
			}
			else
			{
				m_bSlowedPace=False;
//				m_pawn.m_eMovementPace=4;
			}
		}
	}
	else
	{
		m_bSlowedPace=False;
	}
	if ( (m_pawn.m_eHealth == 1) &&  !m_bIsMovingBackwards )
	{
		Pawn.SetWalking(True);
	}
	else
	{
		if ( (m_pawn.m_eMovementPace == 4) || (m_pawn.m_eMovementPace == 2) )
		{
			if (  !m_bSlowedPace && (DistanceTo(m_PaceMember) > 2 * GetFormationDistance()) &&  !m_TeamManager.m_bTeamIsSeparatedFromLeader )
			{
				Pawn.SetWalking(False);
			}
			else
			{
				Pawn.SetWalking(True);
			}
		}
		else
		{
			if ( (m_pawn.m_eMovementPace == 5) || (m_pawn.m_eMovementPace == 3) )
			{
				Pawn.SetWalking(False);
			}
		}
	}
}

function R6PreMoveTo (Vector vTargetPosition, Vector vFocus, optional eMovementPace ePace)
{
	if ( Pawn.m_bTryToUnProne )
	{
//		ePace=1;
	}
	else
	{
		if ( Pawn.bTryToUncrouch )
		{
//			ePace=2;
		}
	}
	R6SetMovement(ePace);
	Focus=None;
	FocalPoint=vFocus;
	Destination=vTargetPosition;
}

function R6PreMoveToward (Actor Target, Actor pFocus, optional eMovementPace ePace)
{
	if ( Pawn.m_bTryToUnProne )
	{
//		ePace=1;
	}
	else
	{
		if ( Pawn.bTryToUncrouch )
		{
//			ePace=2;
		}
	}
	R6SetMovement(ePace);
	Focus=None;
	FocalPoint=pFocus.Location;
	Destination=Target.Location;
}

function ResetStateProgress ()
{
	m_iStateProgress=0;
}

function bool CanClimbLadders (R6Ladder Ladder)
{
	if ( m_TeamManager.m_bTeamIsSeparatedFromLeader )
	{
		return True;
	}
	else
	{
		return R6Pawn(Pawn).m_bAutoClimbLadders;
	}
}

function bool CanSeeGrenade (Vector vGrenadeLocation)
{
	local Vector vDir;

	vDir=vGrenadeLocation - Pawn.Location;
	vDir.Z=0.00;
	if ( VSize(vDir) < 100 )
	{
		return True;
	}
	vDir=vGrenadeLocation - Pawn.Location;
	if ( Normal(vDir) Dot vector(Pawn.Rotation) - Pawn.PeripheralVision > 0 )
	{
		if ( FastTrace(Pawn.Location,vGrenadeLocation) )
		{
			return True;
		}
	}
	return False;
}

function FragGrenadeInProximity (Vector vGrenadeLocation, float fTimeLeft, float fGrenadeDangerRadius)
{
	if ( m_pawn.m_bIsClimbingLadder || IsInState('RunAwayFromGrenade') )
	{
		return;
	}
	if ( CanSeeGrenade(vGrenadeLocation) )
	{
		m_TeamManager.GrenadeInProximity(m_pawn,vGrenadeLocation,fTimeLeft,fGrenadeDangerRadius);
	}
}

function ReactToFragGrenade (Vector vGrenadeLocation, float fTimeLeft, float fGrenadeDangerRadius)
{
	if ( m_pawn.m_bIsClimbingLadder || (Pawn.Physics == 11) || (VSize(vGrenadeLocation - Pawn.Location) > fGrenadeDangerRadius) )
	{
		return;
	}
	m_vGrenadeLocation=vGrenadeLocation;
	m_fGrenadeDangerRadius=fGrenadeDangerRadius;
	GotoState('RunAwayFromGrenade');
	SetTimer(fTimeLeft,False);
}

function PlaySoundAffectedByGrenade (EGrenadeType eType)
{
	switch (eType)
	{
/*		case GTYPE_Smoke:
		if ( m_TeamManager.m_bLeaderIsAPlayer || m_TeamManager.m_bPlayerHasFocus )
		{
			m_CommonMemberVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_EntersSmoke);
		}
		else
		{
			m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_pawn,19);
		}
		break;
		case GTYPE_TearGas:
		if ( m_TeamManager.m_bLeaderIsAPlayer || m_TeamManager.m_bPlayerHasFocus )
		{
			m_CommonMemberVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_EntersGas);
		}
		else
		{
			m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_pawn,20);
			if ( m_TeamManager.m_bPlayerHasFocus || Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
			{
				if ( m_TeamManager.m_bFirstTimeInGas )
				{
					m_TeamManager.m_MultiCoopMemberVoicesMgr.PlayRainbowTeamVoices(m_pawn,10);
					m_TeamManager.m_bFirstTimeInGas=False;
					m_TeamManager.SetTimer(60.00,False);
				}
			}
		}
		break;
		default:  */
	}
}

function AIAffectedByGrenade (Actor aGrenade, EGrenadeType eType)
{
	if ( eType == GTYPE_TearGas )
	{
		if ( m_pawn.m_bPawnSpecificAnimInProgress )
		{
			m_fLastReactionToGas=Level.TimeSeconds;
		}
		else
		{
			m_TeamManager.GasGrenadeInProximity(m_pawn);
			if ( m_fLastReactionToGas < Level.TimeSeconds - 2.00 )
			{
				m_fLastReactionToGas=Level.TimeSeconds;
//				m_pawn.SetNextPendingAction(PENDING_Coughing);
			}
		}
	}
	else
	{
		if ( eType == GTYPE_FlashBang )
		{
			if ( IsFacing(aGrenade) && m_pawn.IsStationary() )
			{
//				m_pawn.SetNextPendingAction(PENDING_Blinded);
			}
		}
	}
}

function PlaySoundInflictedDamage (Pawn DeadPawn)
{
	switch (R6Pawn(DeadPawn).m_ePawnType)
	{
/*		case 2:
		if ( m_TeamManager.m_bLeaderIsAPlayer || m_TeamManager.m_bPlayerHasFocus )
		{
			m_CommonMemberVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_TerroristDown);
		}
		else
		{
			if ( (m_TeamManager.m_OtherTeamVoicesMgr != None) && m_pawn.m_bIsSniping )
			{
				m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_pawn,2);
			}
		}
		break;
		default:    */
	}
}

function PlaySoundActionCompleted (eDeviceAnimToPlay eAnimToPlay)
{
	if ( Level.NetMode == NM_Standalone )
	{
		if (  !m_TeamManager.m_bLeaderIsAPlayer &&  !m_TeamManager.m_bPlayerHasFocus )
		{
			switch (eAnimToPlay)
			{
/*				case 2:
				m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_pawn,9);
				break;
				case 3:
				m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_pawn,1);
				break;
				case 4:
				m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_pawn,3);
				break;
				default:    */
			}
		}
	}
	if ( (Level.NetMode != 0) || m_TeamManager.m_bPlayerHasFocus )
	{
		switch (eAnimToPlay)
		{
/*			case 2:
			m_TeamManager.m_MultiCoopMemberVoicesMgr.PlayRainbowTeamVoices(m_pawn,9);
			break;
			case 3:
			m_TeamManager.m_MultiCoopMemberVoicesMgr.PlayRainbowTeamVoices(m_pawn,1);
			break;
			case 4:
			m_TeamManager.m_MultiCoopMemberVoicesMgr.PlayRainbowTeamVoices(m_pawn,3);
			break;
			default:    */
		}
	}
}

function PlaySoundCurrentAction (ERainbowTeamVoices eVoices)
{
	if ( m_TeamManager.m_bLeaderIsAPlayer || m_TeamManager.m_bPlayerHasFocus )
	{
		if ( m_TeamManager.m_bPlayerHasFocus || Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
		{
//			m_TeamManager.m_MultiCoopMemberVoicesMgr.PlayRainbowTeamVoices(m_pawn,eVoices);
		}
		else
		{
			if ( eVoices == 5 )
			{
//				m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_pawn,23);
			}
		}
	}
	else
	{
//		m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_pawn,eVoices);
	}
}

function PlaySoundDamage (Pawn instigatedBy)
{
//	m_CommonMemberVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_TakeWound);
	if ( m_TeamManager.m_bLeaderIsAPlayer || m_TeamManager.m_bPlayerHasFocus )
	{
		switch (m_pawn.m_eHealth)
		{
/*			case 2:
			case 3:
			if ( m_TeamManager.m_iMemberCount > 1 )
			{
				m_CommonMemberVoicesMgr.PlayCommonRainbowVoices(m_pawn,CRV_GoesDown);
				if ( m_TeamManager.m_bLeaderIsAPlayer )
				{
					m_TeamManager.m_PlayerVoicesMgr.PlayRainbowPlayerVoices(m_TeamManager.m_Team[0],42);
				}
				else
				{
					m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_TeamManager.m_Team[0],13);
				}
			}
			break;
			case 1:
			if ( instigatedBy != None )
			{
				switch (R6Pawn(instigatedBy).m_ePawnType)
				{
					case 1:
					m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_pawn,24);
					break;
					case 2:
					m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_pawn,17);
					break;
					default:
				}
			}
			break;
			default:      */
		}
	}
	else
	{
		switch (m_pawn.m_eHealth)
		{
/*			case 2:
			case 3:
			if ( (m_TeamManager.m_OtherTeamVoicesMgr != None) && (m_TeamManager.m_iMemberCount > 0) )
			{
				m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_TeamManager.m_Team[0],3);
			}
			break;
			case 1:
			if ( (instigatedBy != None) && (R6Pawn(instigatedBy).m_ePawnType == 1) )
			{
				m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_pawn,4);
			}
			break;
			default:   */
		}
	}
}

state RunAwayFromGrenade
{
	function BeginState ()
	{
		m_bIgnoreBackupBump=True;
	}

	function EndState ()
	{
		m_TeamManager.m_bGrenadeInProximity=False;
		SetTimer(0.00,False);
		StopMoving();
		m_bIgnoreBackupBump=False;
	}

	event Timer ()
	{
		m_TeamManager.GrenadeThreatIsOver();
	}

	function Vector SafeLocation ()
	{
		local Vector vDir;
		local Vector vLocation;

		vDir=Normal(Pawn.Location - m_vGrenadeLocation);
		vLocation=m_vGrenadeLocation + (m_fGrenadeDangerRadius + 600) * vDir;
		vLocation.Z=Pawn.Location.Z;
		if ( pointReachable(vLocation) )
		{
			return vLocation;
		}
		vLocation=m_vGrenadeLocation - (m_fGrenadeDangerRadius + 600) * vDir;
		vLocation.Z=Pawn.Location.Z;
		if ( pointReachable(vLocation) )
		{
			return vLocation;
		}
		return vect(0.00,0.00,0.00);
	}

Begin:
//	m_TeamManager.SetTeamState(3);
	m_vTargetPosition=SafeLocation();
	EnsureRainbowIsArmed();
	if ( m_vTargetPosition != vect(0.00,0.00,0.00) )
	{
		goto ('RunToDirectly');
	}
FindPathAway:
	MoveTarget=FindSafeSpot();
	if ( MoveTarget != None )
	{
		if ( NeedToOpenDoor(MoveTarget) )
		{
			m_pawn.PlayDoorAnim(m_pawn.m_Door.m_RotatingDoor);
			Sleep(0.50);
//			m_pawn.ServerPerformDoorAction(m_pawn.m_Door.m_RotatingDoor,m_pawn.m_Door.m_RotatingDoor.1);
		}
//		R6PreMoveToward(MoveTarget,MoveTarget,5);
		MoveToward(MoveTarget);
		if ( m_eMoveToResult == 2 )
		{
			Sleep(0.50);
		}
		if ( VSize(m_vGrenadeLocation - Pawn.Location) > m_fGrenadeDangerRadius + 300 )
		{
			goto ('Wait');
		}
		goto ('FindPathAway');
	}
	goto ('Wait');
RunToDirectly:
//	R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,5);
	MoveTo(m_vTargetPosition);
Wait:
	StopMoving();
//	m_TeamManager.SetTeamState(2);
	Sleep(2.00);
	goto ('Wait');
}

state BumpBackUp
{
	event bool NotifyBump (Actor Other)
	{
		local R6Pawn thisPawn;

		thisPawn=R6Pawn(Other);
		if ( thisPawn == None )
		{
			return False;
		}
		if ( thisPawn.m_iID <= R6Pawn(m_BumpedBy).m_iID )
		{
			m_BumpedBy=thisPawn;
			GotoState('BumpBackUp');
			return True;
		}
		return False;
	}

	function Vector GetTargetLocation (bool bRight, optional int iTry)
	{
		local Rotator rOffset;
		local R6Pawn bumpedBy;

		bumpedBy=R6Pawn(m_BumpedBy);
		if ( bumpedBy.m_bIsClimbingLadder && (bumpedBy.Location.Z - Pawn.Location.Z > 100) )
		{
			return Pawn.Location - c_iDistanceBumpBackUp * bumpedBy.OnLadder.LookDir;
		}
		switch (iTry)
		{
/*			case 0:
			rOffset=rot(0,16384,0);
			break;
			case 1:
			rOffset=rot(0,8192,0);
			break;
			case 2:
			rOffset=rot(0,4096,0);
			break;
			case 3:
			rOffset=rot(0,0,0);
			break;
			case 4:
			rOffset=rot(0,-4096,0);
			break;
			case 5:
			rOffset=rot(0,-8192,0);
			break;
			case 6:
			rOffset=rot(0,-16384,0);
			break;
			default:     */
		}
		if ( bRight )
		{
//			return Pawn.Location + c_iDistanceBumpBackUp * (rotator(m_vBumpedByVelocity) + rOffset);
		}
		else
		{
//			return Pawn.Location + c_iDistanceBumpBackUp * (rotator(m_vBumpedByVelocity) - rOffset);
		}
	}

	function bool GetReacheablePoint (out Vector vTarget, bool bNoFail)
	{
		local Actor HitActor;
		local Vector vHitLocation;
		local Vector vHitNormal;
		local Vector vExtent;
		local bool bMoveRight;
		local int i;

		bMoveRight=MoveRight();
		vTarget=GetTargetLocation(bMoveRight);
		vExtent.X=Pawn.CollisionRadius;
		vExtent.Y=vExtent.X;
		vExtent.Z=Pawn.CollisionHeight;
		HitActor=R6Trace(vHitLocation,vHitNormal,vTarget,Pawn.Location,1,vExtent);
		if ( HitActor != None )
		{
//			vTarget=vHitLocation + c_iDistanceBumpBackUp * vector(m_vBumpedByVelocity);
		}
	JL00BC:
		if ( (R6Trace(vHitLocation,vHitNormal,vTarget - vect(0.00,0.00,200.00),vTarget,1) == None) && (i < 6) )
		{
			i++;
			vTarget=GetTargetLocation(bMoveRight,i);
			goto JL00BC;
		}
		return True;
	}

}

state WaitForPaceMember
{
Begin:
	Sleep(1.00);
	if ( Abs(m_PaceMember.Location.Z - Pawn.Location.Z) < 30 )
	{
		GotoState('FollowLeader');
	}
	else
	{
		goto ('Begin');
	}
}

function bool CanBeSeen (Pawn seen)
{
	local Vector vSightDir;

	vSightDir=Normal(Pawn.Location - seen.Location);
/*	if ( seen.GetViewRotation() Dot vSightDir < Pawn.PeripheralVision )
	{
		return False;
	}*/
	return True;
}

function SetEnemy (Pawn newEnemy)
{
	if (  !m_pawn.m_bIsSniping )
	{
		m_TeamManager.RainbowIsEngagingEnemy();
	}
	Enemy=newEnemy;
	LastSeenTime=Level.TimeSeconds;
	if ( Enemy != None )
	{
		LastSeenPos=Enemy.Location;
	}
}

function PlayVoiceTerroristSpotted (R6Terrorist aTerro)
{
	if (  !aTerro.m_bEnteringView && (m_TeamManager.m_bLeaderIsAPlayer || m_TeamManager.m_bPlayerHasFocus) )
	{
		if ( m_bIsMovingBackwards )
		{
//			m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_pawn,1);
		}
		else
		{
//			m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_pawn,0);
		}
		aTerro.m_bEnteringView=True;
	}
}

event SeePlayer (Pawn seen)
{
	local R6Pawn aPawn;

	aPawn=R6Pawn(seen);
	if ( m_pawn.IsEnemy(seen) && (aPawn.EngineWeapon != None) )
	{
		if ( m_TeamManager == None )
		{
			return;
		}
		if ( aPawn.m_bIsKneeling ||  !aPawn.IsAlive() )
		{
			if (  !R6Terrorist(aPawn).m_bIsUnderArrest )
			{
				m_TeamManager.TeamSpottedSurrenderedTerrorist(aPawn);
			}
			return;
		}
		if ( aPawn.m_bDontKill )
		{
			return;
		}
		if ( m_TeamManager.m_eMovementMode == 2 )
		{
			if (  !CanBeSeen(seen) )
			{
				PlayVoiceTerroristSpotted(R6Terrorist(aPawn));
				return;
			}
//			m_TeamManager.m_eMovementMode=0;
		}
		else
		{
			if ( m_TeamManager.m_eMovementMode == 1 )
			{
				if ( CanBeSeen(seen) )
				{
//					m_TeamManager.m_eMovementMode=0;
				}
				else
				{
					if (  !Pawn.EngineWeapon.m_bIsSilenced )
					{
						PlayVoiceTerroristSpotted(R6Terrorist(aPawn));
						return;
					}
				}
			}
		}
		if ( Enemy != None )
		{
			return;
		}
		if ( m_bWeaponsDry )
		{
			return;
		}
		if ( AClearShotIsAvailable(seen,m_pawn.GetFiringStartPoint()) && (Pawn.EngineWeapon.m_eWeaponType != 6) )
		{
			if (  !m_bIndividualAttacks || m_TeamManager.EngageEnemyIfNotAlreadyEngaged(m_pawn,aPawn) )
			{
				m_pawn.m_bEngaged=True;
				SetEnemy(seen);
				Target=Enemy;
				Enable('EnemyNotVisible');
			}
		}
	}
	else
	{
		if ( (aPawn.m_ePawnType == 3) && aPawn.IsAlive() &&  !R6Hostage(aPawn).m_bExtracted && (R6Hostage(aPawn).m_escortedByRainbow == None) )
		{
			m_TeamManager.m_HostageToRescue=aPawn;
		}
	}
}

function bool IsANeutralPawnNoise (Actor aNoiseMaker)
{
	local Pawn aPawn;

	aPawn=Pawn(aNoiseMaker);
	if ( aPawn == None )
	{
		aPawn=aNoiseMaker.Instigator;
	}
	if ( aPawn == None )
	{
		return False;
	}
	return m_pawn.IsNeutral(aPawn);
}

event HearNoise (float Loudness, Actor aNoiseMaker, ENoiseType eType)
{
	if ( m_TeamManager == None )
	{
		return;
	}
	if ( IsANeutralPawnNoise(aNoiseMaker) )
	{
		return;
	}
	m_TeamManager.TeamHearNoise(aNoiseMaker);
	if ( m_TeamManager.m_eMovementMode == 0 )
	{
		return;
	}
	if ( (eType == 2) || (eType == 3) )
	{
		if ( R6Pawn(aNoiseMaker.Owner).m_ePawnType != 1 )
		{
//			m_TeamManager.m_eMovementMode=0;
		}
	}
}

event EnemyNotVisible ()
{
	if ( Level.TimeSeconds - LastSeenTime < 0.50 )
	{
		return;
	}
	StopFiring();
	EndAttack();
	Disable('EnemyNotVisible');
}

function IsBeingAttacked (Pawn attacker)
{
	if ( m_pawn.IsEnemy(attacker) )
	{
		if ( Enemy == None )
		{
			m_pawn.ResetBoneRotation();
			Pawn.DesiredRotation=rotator(attacker.Location - Pawn.Location);
			Focus=attacker;
			Enemy=attacker;
		}
	}
}

function bool EnemyIsAThreat ()
{
	if ( Enemy == None )
	{
		return False;
	}
	if ( R6Pawn(Enemy).m_bIsKneeling ||  !R6Pawn(Enemy).IsAlive() )
	{
		return False;
	}
	return True;
}

function SetGunDirection (Actor aTarget)
{
	local Rotator rDirection;
	local Vector vDirection;
	local Coords cTarget;
	local Vector vTarget;

	if ( aTarget != None )
	{
		if ( aTarget == self )
		{
			vTarget=aTarget.Location;
		}
		else
		{
			if ( aTarget == Enemy )
			{
				vTarget=LastSeenPos;
				m_bAimingWeaponAtEnemy=True;
			}
			else
			{
				cTarget=aTarget.GetBoneCoords('R6 Spine');
				vTarget=cTarget.Origin;
			}
		}
		if ( aTarget == self )
		{
			rDirection=aTarget.Rotation;
		}
		else
		{
			vDirection=vTarget - m_pawn.GetFiringStartPoint();
			rDirection=rotator(vDirection);
		}
		m_pawn.m_u8DesiredPitch=(rDirection.Pitch & 65535) / 256;
		if ( aTarget == Enemy )
		{
			m_pawn.m_u8DesiredYaw=(rDirection.Yaw - Pawn.Rotation.Yaw & 65535) / 256;
		}
		else
		{
			m_pawn.m_u8DesiredYaw=0;
		}
		m_pawn.m_rFiringRotation=rDirection;
	}
	else
	{
		m_bAimingWeaponAtEnemy=False;
		m_pawn.m_u8DesiredPitch=0;
		m_pawn.m_u8DesiredYaw=0;
		m_pawn.m_rFiringRotation=m_pawn.Rotation;
	}
}

function EndAttack ()
{
	m_pawn.m_bEngaged=False;
	m_TeamManager.DisEngageEnemy(Pawn,Enemy);
	Enemy=None;
	Target=None;
	if ( IsMoving(Pawn) )
	{
		if ( MoveTarget != None )
		{
			Focus=MoveTarget;
		}
	}
}

function StartFiring ()
{
	if ( Pawn.EngineWeapon != None )
	{
		if ( Enemy != None )
		{
			Target=Enemy;
		}
		SetRotation(Pawn.Rotation);
		bFire=1;
		Pawn.EngineWeapon.GotoState('NormalFire');
	}
}

function StopFiring ()
{
	bFire=0;
}

function bool PreEntryRoomIsAcceptablyLarge ()
{
	if ( m_TeamManager.m_eMovementMode == 2 )
	{
		return False;
	}
	if ( m_TeamManager.m_Door == None )
	{
		m_TeamManager.m_Door=m_pawn.m_Door;
	}
	if ( (m_TeamManager.m_Door == None) || (m_TeamManager.m_Door.m_CorrespondingDoor == None) )
	{
		return False;
	}
	if ( m_TeamManager.m_Door.m_CorrespondingDoor.m_eRoomLayout == 3 )
	{
		return False;
	}
	return True;
}

function bool PostEntryRoomIsAcceptablyLarge ()
{
	if ( m_TeamManager.m_eMovementMode == 2 )
	{
		return False;
	}
	if ( m_TeamManager.m_Door == None )
	{
		m_TeamManager.m_Door=m_pawn.m_Door;
	}
	if ( m_TeamManager.m_Door == None )
	{
		return False;
	}
	if ( m_TeamManager.m_Door.m_eRoomLayout == 3 )
	{
		return False;
	}
	return True;
}

function float GetLeadershipReactionTime ()
{
	local float fDelay;

	fDelay=2.00 - m_pawn.GetSkill(SKILL_Leadership) * 2.00;
	fDelay=FClamp(fDelay,0.00,2.00);
	return fDelay;
}

function bool OnRightSideOfDoor (Actor aTarget)
{
	local Vector vDir;
	local Vector vResult;

	if ( aTarget == None )
	{
		return False;
	}
	vDir=Normal(Pawn.Location - aTarget.Location);
	vResult=vDir Cross vector(aTarget.Rotation);
	if ( vResult.Z < 0 )
	{
		return True;
	}
	else
	{
		return False;
	}
}

function ResetGadgetGroup ()
{
	m_iActionUseGadgetGroup=0;
}

function bool AimingAt (Pawn Enemy)
{
	local Vector vDir;

	vDir=Normal(Enemy.Location - Pawn.Location);
	if ( vDir Dot vector(Pawn.Rotation + m_pawn.m_rRotationOffset) > 0.50 )
	{
		return True;
	}
	else
	{
		return False;
	}
}

event AttackTimer ()
{
	if ( m_pawn.m_iCurrentWeapon > 2 )
	{
		return;
	}
	m_pawn.m_bReloadToFullAmmo=False;
	if ( m_bWeaponsDry )
	{
		if ( Enemy != None )
		{
			StopFiring();
			EndAttack();
		}
		return;
	}
	if (  !m_pawn.m_bChangingWeapon && (Pawn.EngineWeapon.NumberOfBulletsLeftInClip() == 0) )
	{
		RainbowReloadWeapon();
		if ( bFire == 1 )
		{
			StopFiring();
			EndAttack();
		}
	}
	if ( m_pawn.m_bReloadingWeapon || m_pawn.m_bChangingWeapon )
	{
		return;
	}
	if ( (Enemy != None) && (R6Pawn(Enemy).m_bIsKneeling ||  !R6Pawn(Enemy).IsAlive()) )
	{
		EndAttack();
	}
	if ( bFire == 0 )
	{
		if ( Enemy != None )
		{
			Focus=Enemy;
			Target=Enemy;
			if ( AimingAt(Enemy) )
			{
				if ( m_pawn.IsStationary() &&  !IsReadyToFire(Enemy) )
				{
					return;
				}
//				Pawn.EngineWeapon.SetRateOfFire(2);
				StartFiring();
			}
		}
	}
	else
	{
		StopFiring();
		if (  !EnemyIsAThreat() )
		{
			EndAttack();
		}
	}
}

event StopAttack ()
{
	StopFiring();
	if (  !EnemyIsAThreat() )
	{
		EndAttack();
	}
}

function SetFocusToDoorKnob (R6IORotatingDoor aDoor)
{
	if ( aDoor == None )
	{
		return;
	}
	if ( aDoor.m_bTreatDoorAsWindow )
	{
		SetLocation(aDoor.Location - 30 * vector(aDoor.Rotation));
	}
	else
	{
		SetLocation(aDoor.Location - 128 * vector(aDoor.Rotation));
	}
	Focus=self;
}

state LockPickDoor
{
	function BeginState ()
	{
		m_pawn.m_bAvoidFacingWalls=False;
		m_bIgnoreBackupBump=True;
	}

	function EndState ()
	{
		m_pawn.m_bAvoidFacingWalls=True;
		m_bIgnoreBackupBump=False;
		if ( m_pawn.m_bIsLockPicking )
		{
			m_pawn.m_bIsLockPicking=False;
			m_pawn.m_bPostureTransition=False;
//			m_pawn.AnimBlendToAlpha(m_pawn.1,0.00,0.50);
			m_pawn.m_ePlayerIsUsingHands=HANDS_None;
		}
		if ( m_pawn.m_bWeaponIsSecured &&  !m_pawn.m_bWeaponTransition )
		{
//			m_pawn.m_eEquipWeapon=1;
			m_pawn.PlayWeaponAnimation();
		}
		if ( m_RotatingDoor.m_bIsDoorLocked )
		{
//			m_pawn.ServerPerformDoorAction(m_RotatingDoor,m_RotatingDoor.15);
		}
	}

Begin:
	m_vTargetPosition=m_pawn.m_Door.Location + 20 * vector(m_pawn.m_Door.Rotation);
	SetLocation(m_RotatingDoor.Location - 128 * vector(m_RotatingDoor.Rotation));
	MoveToPosition(m_vTargetPosition,rotator(Location - Pawn.Location));
	Focus=self;
	FinishRotation();
//	m_pawn.SetNextPendingAction(PENDING_StopCoughing7);
//	FinishAnim(m_pawn.14);
//	m_pawn.SetNextPendingAction(PENDING_Coughing9);
	m_pawn.m_bIsLockPicking=True;
	Sleep(0.10);
	m_RotatingDoor.PlayLockPickSound();
	if ( m_pawn.m_bHasLockPickKit )
	{
		Sleep((m_RotatingDoor.m_fUnlockBaseTime - 2.00) * (2.00 - m_pawn.ArmorSkillEffect()));
	}
	else
	{
		Sleep(m_RotatingDoor.m_fUnlockBaseTime * (2.00 - m_pawn.ArmorSkillEffect()));
	}
//	m_pawn.ServerPerformDoorAction(m_RotatingDoor,m_RotatingDoor.13);
	m_pawn.m_bIsLockPicking=False;
//	m_pawn.AnimBlendToAlpha(m_pawn.1,0.00,0.50);
	m_pawn.m_ePlayerIsUsingHands=HANDS_None;
	Sleep(1.00);
//	m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
//	FinishAnim(m_pawn.14);
End:
	GotoState(m_PostLockPickState);
}

function GotoLockPickState (R6IORotatingDoor Door)
{
	m_RotatingDoor=Door;
	if ( m_RotatingDoor == None )
	{
		return;
	}
	m_PostLockPickState=GetStateName();
//	m_TeamManager.SetTeamState(8);
	GotoState('LockPickDoor');
}

function RainbowCannotCompleteOrders ()
{
	m_TeamManager.ActionCompleted(False);
	m_iStateProgress=0;
	NextState='None';
	GotoState('HoldPosition');
}

function bool CanThrowGrenadeIntoRoom (R6Door aDoor, optional Vector vTestTarget)
{
	local Vector vTarget;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local Actor HitActor;

	if (  !m_pawn.EngineWeapon.HasBulletType('R6FragGrenade') )
	{
		return True;
	}
	if ( vTestTarget == vect(0.00,0.00,0.00) )
	{
		vTarget=aDoor.Location - 400 * vector(aDoor.Rotation);
	}
	else
	{
		vTarget=vTestTarget;
	}
	HitActor=Trace(vHitLocation,vHitNormal,vTarget,aDoor.Location - 96 * vector(aDoor.Rotation),False,vect(20.00,20.00,40.00));
	if ( HitActor == None )
	{
		return True;
	}
	return False;
}

state PerformAction
{
	function BeginState ()
	{
		m_pawn.m_bAvoidFacingWalls=False;
		m_bIndividualAttacks=False;
		m_iTurn=0;
		m_bEnteredRoom=False;
		if ( (m_ActionTarget != None) && m_ActionTarget.IsA('R6Door') )
		{
			m_TeamManager.m_Door=R6Door(m_ActionTarget);
			m_RotatingDoor=m_TeamManager.m_Door.m_RotatingDoor;
		}
		else
		{
			m_RotatingDoor=None;
		}
	}

	function EndState ()
	{
		if ( m_iStateProgress == 14 )
		{
			m_iStateProgress=0;
		}
		SetTimer(0.00,False);
		m_pawn.m_u8DesiredYaw=0;
		m_pawn.m_bThrowGrenadeWithLeftHand=False;
		m_pawn.m_bAvoidFacingWalls=True;
		m_bIgnoreBackupBump=False;
		m_bIndividualAttacks=True;
	}

	function Timer ()
	{
		m_iTurn++;
		LookAroundRoom(True);
	}

	function Vector FindFloorBelowActor (Actor Target)
	{
		local Vector vHitLocation;
		local Vector vHitNormal;

		Trace(vHitLocation,vHitNormal,Target.Location - vect(0.00,0.00,200.00),Target.Location,False);
		vHitLocation.Z += Pawn.CollisionHeight;
		return vHitLocation;
	}

Begin:
	StopMoving();
	m_pawn.ResetBoneRotation();
	Sleep(GetLeadershipReactionTime());
	if ( m_ActionTarget == None )
	{
		goto ('ReinitAction');
	}
	switch (m_iStateProgress)
	{
/*		case 0:
		goto ('PrepareForAction');
		break;
		case 1:
		goto ('FindActionTarget');
		break;
		case 2:
		goto ('MoveToActionTarget');
		break;
		case 3:
		goto ('PreEntry');
		break;
		case 4:
		goto ('WaitForZuluGoCode');
		break;
		case 5:
		case 6:
		goto ('performDoorAction');
		break;
		case 7:
		case 8:
		goto ('PerformGrenadeAction');
		break;
		case 9:
		case 10:
		goto ('PerformClearAction');
		break;
		case 11:
		goto ('UpdateStatus');
		break;
		case 12:
		goto ('ReinitAction');
		break;
		default:
		goto ('WaitForTeamAI');    */
	}
PrepareForAction:
//	m_TeamManager.SetTeamState(3);
	if ( CanWalkTo(m_ActionTarget.Location) || actorReachable(m_ActionTarget) )
	{
		goto ('MoveToActionTarget');
	}
	m_iStateProgress=1;
FindActionTarget:
	if (  !CanWalkTo(m_ActionTarget.Location) &&  !actorReachable(m_ActionTarget) )
	{
		if ( (m_RotatingDoor != None) && m_RotatingDoor.m_bTreatDoorAsWindow )
		{
			FindPathToTargetLocation(FindFloorBelowActor(m_ActionTarget));
		}
		else
		{
			FindPathToTargetLocation(m_ActionTarget.Location,m_ActionTarget);
		}
	}
	m_iStateProgress=2;
MoveToActionTarget:
	if (  !m_RotatingDoor.m_bIsDoorLocked && ((m_TeamManager.m_iTeamAction & 64) > 0) )
	{
		SwitchWeapon(m_iActionUseGadgetGroup);
	}
	m_bIgnoreBackupBump=True;
	if ( (m_RotatingDoor != None) && (m_TeamManager.m_iTeamAction == 32) && m_RotatingDoor.DoorOpenTowardsActor(m_ActionTarget) &&  !PreEntryRoomIsAcceptablyLarge() )
	{
		if ( m_RotatingDoor.m_bIsOpeningClockWise )
		{
			m_vTargetPosition=m_ActionTarget.Location - 85 * vector(m_ActionTarget.Rotation) + 85 * vector(m_ActionTarget.Rotation + rot(0,16384,0));
		}
		else
		{
			m_vTargetPosition=m_ActionTarget.Location - 85 * vector(m_ActionTarget.Rotation) - 85 * vector(m_ActionTarget.Rotation + rot(0,16384,0));
		}
//		R6PreMoveTo(m_vTargetPosition,m_RotatingDoor.Location,4);
		MoveTo(m_vTargetPosition,m_RotatingDoor);
		MoveToPosition(m_vTargetPosition,rotator(m_RotatingDoor.Location - Pawn.Location));
	}
	else
	{
//		R6PreMoveToward(m_ActionTarget,m_ActionTarget,4);
		MoveToward(m_ActionTarget);
		MoveToPosition(m_ActionTarget.Location,m_ActionTarget.Rotation);
	}
	StopMoving();
	Sleep(0.50);
UnlockDoor:
	if ( m_RotatingDoor.m_bIsDoorLocked )
	{
		GotoLockPickState(m_RotatingDoor);
	}
//	m_TeamManager.SetTeamState(3);
	if ( (m_TeamManager.m_iTeamAction & 64) > 0 )
	{
		SwitchWeapon(m_iActionUseGadgetGroup);
	}
	else
	{
		EnsureRainbowIsArmed();
	}
JL03CA:
	if (  !m_TeamManager.LastMemberIsStationary() )
	{
		Sleep(0.50);
//		goto JL03CA;
	}
	m_bIgnoreBackupBump=False;
	m_iStateProgress=3;
PreEntry:
	if ( (m_pawn.m_Door == m_ActionTarget) && m_RotatingDoor.m_bTreatDoorAsWindow )
	{
		m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
		m_iStateProgress=4;
		goto ('WaitForZuluGoCode');
	}
	if ( m_RotatingDoor != None )
	{
		ForceCurrentDoor(R6Door(m_ActionTarget));
		m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
	}
	if ( PreEntryRoomIsAcceptablyLarge() )
	{
		m_vTargetPosition=GetEntryPosition(False);
		if ( m_vTargetPosition != vect(0.00,0.00,0.00) )
		{
//			R6PreMoveTo(m_vTargetPosition,m_RotatingDoor.Location,4);
			MoveTo(m_vTargetPosition);
			MoveToPosition(m_vTargetPosition,rotator(m_TeamManager.m_Door.m_CorrespondingDoor.Location - m_vTargetPosition));
			StopMoving();
		}
	}
	m_iStateProgress=4;
WaitForZuluGoCode:
	if ( m_TeamManager.m_bCAWaitingForZuluGoCode )
	{
//		m_TeamManager.SetTeamState(1);
		Sleep(0.50);
		goto ('WaitForZuluGoCode');
	}
	m_iStateProgress=5;
performDoorAction:
	if ( ((m_TeamManager.m_iTeamAction & 16) > 0) || ((m_TeamManager.m_iTeamAction & 32) > 0) )
	{
		if ( m_RotatingDoor != None )
		{
			if ( m_RotatingDoor.m_bIsDoorClosed )
			{
				Focus=m_RotatingDoor;
				if ( m_TeamManager.m_Door == None )
				{
					m_TeamManager.m_Door=R6Door(m_ActionTarget);
				}
				SetFocusToDoorKnob(m_RotatingDoor);
				Sleep(1.50);
			}
JL05F1:
			if (  !m_TeamManager.LastMemberIsStationary() )
			{
				Sleep(0.50);
//				goto JL05F1;
			}
			if ( ((m_TeamManager.m_iTeamAction & 16) > 0) && m_RotatingDoor.m_bIsDoorClosed )
			{
				m_iStateProgress=6;
				if ( m_RotatingDoor.m_bTreatDoorAsWindow )
				{
//					m_TeamManager.SetTeamState(11);
				}
				else
				{
//					m_TeamManager.SetTeamState(9);
				}
				m_pawn.PlayDoorAnim(m_RotatingDoor);
				Sleep(0.50);
//				m_pawn.ServerPerformDoorAction(m_RotatingDoor,m_RotatingDoor.1);
JL06B8:
				if ( m_RotatingDoor.m_bIsDoorClosed )
				{
					if (  !m_RotatingDoor.m_bInProcessOfOpening )
					{
						Sleep(1.00);
						goto ('performDoorAction');
					}
					else
					{
						Sleep(0.20);
					}
//					goto JL06B8;
				}
			}
			else
			{
				if ( ((m_TeamManager.m_iTeamAction & 32) > 0) &&  !m_RotatingDoor.m_bIsDoorClosed )
				{
					m_iStateProgress=6;
					if ( m_RotatingDoor.m_bTreatDoorAsWindow )
					{
//						m_TeamManager.SetTeamState(12);
					}
					else
					{
//						m_TeamManager.SetTeamState(10);
					}
					m_pawn.PlayDoorAnim(m_RotatingDoor);
					Sleep(0.50);
//					m_pawn.ServerPerformDoorAction(m_RotatingDoor,m_RotatingDoor.5);
JL07A7:
					if ( m_RotatingDoor.m_iCurrentOpening != 0 )
					{
						Sleep(0.50);
//						goto JL07A7;
					}
				}
				else
				{
					if ( m_iStateProgress < 6 )
					{
						RainbowCannotCompleteOrders();
					}
				}
			}
		}
		else
		{
			m_TeamManager.ActionCompleted(False);
			goto ('ReinitAction');
		}
	}
	m_iStateProgress=7;
PerformGrenadeAction:
	if ( m_iStateProgress == 8 )
	{
		Sleep(1.00);
		m_iStateProgress=9;
		goto ('PerformClearAction');
	}
	if ( (m_TeamManager.m_iTeamAction & 64) > 0 )
	{
//		m_TeamManager.SetTeamState(14);
		Disable('NotifyBump');
		m_vLocationOnTarget=m_ActionTarget.Location + 450 * vector(m_ActionTarget.Rotation);
		SetLocation(m_vLocationOnTarget);
		if (  !CanThrowGrenadeIntoRoom(R6Door(m_ActionTarget).m_CorrespondingDoor) )
		{
			m_TeamManager.ResetGrenadeAction();
//			m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_pawn,7);
			SwitchWeapon(1);
			Sleep(1.00);
			m_iStateProgress=9;
			goto ('PerformClearAction');
		}
		Focus=self;
		Target=self;
		FinishRotation();
		SetRotation(m_ActionTarget.Rotation);
		SetGunDirection(Target);
		SetGrenadeParameters(PreEntryRoomIsAcceptablyLarge());
		m_pawn.PlayWeaponAnimation();
//		FinishAnim(m_pawn.14);
//		m_pawn.m_eRepGrenadeThrow=0;
		SetGunDirection(None);
		Enable('NotifyBump');
		m_iStateProgress=8;
		SwitchWeapon(1);
		Sleep(m_pawn.EngineWeapon.GetExplosionDelay());
	}
	m_iStateProgress=9;
PerformClearAction:
	if ( (m_TeamManager.m_iTeamAction & 128) > 0 )
	{
//		m_TeamManager.SetTeamState(13);
		if ( m_TeamManager.m_Door == None )
		{
			m_TeamManager.m_Door=R6Door(m_ActionTarget);
		}
//		m_eCurrentRoomLayout=m_TeamManager.m_Door.m_eRoomLayout;
		if ( m_iStateProgress == 9 )
		{
			m_vTargetPosition=m_TeamManager.m_Door.Location;
//			R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,5);
			MoveToPosition(m_vTargetPosition,m_TeamManager.m_Door.Rotation);
			m_TeamManager.EnteredRoom(m_pawn);
			m_vTargetPosition=m_TeamManager.m_Door.m_CorrespondingDoor.Location;
//			R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,5);
			MoveToPosition(m_vTargetPosition,m_TeamManager.m_Door.Rotation);
			StopMoving();
			m_iStateProgress=10;
		}
		if ( m_pawn.m_iID == m_TeamManager.m_iMemberCount - 1 )
		{
			m_iStateProgress=11;
			SetTimer(1.00,True);
			LookAroundRoom(True);
			Sleep(1.50);
			goto ('UpdateStatus');
		}
		if ( PostEntryRoomIsAcceptablyLarge() )
		{
			m_vTargetPosition=GetEntryPosition(True);
			SetLocation(FocalPoint);
		}
		else
		{
			FindNearbyWaitSpot(m_TeamManager.m_Door.m_CorrespondingDoor,m_vTargetPosition);
			SetLocation(m_vTargetPosition + 60 * (m_vTargetPosition - Pawn.Location));
		}
//		R6PreMoveTo(m_vTargetPosition,Location,5);
		MoveToPosition(m_vTargetPosition,rotator(Location - m_vTargetPosition));
		StopMoving();
		SetTimer(1.00,True);
		LookAroundRoom(True);
		m_iStateProgress=11;
		Sleep(3.00);
	}
	else
	{
		m_iStateProgress=11;
	}
UpdateStatus:
	if ( m_TeamManager.RainbowIsEngaging() )
	{
		Sleep(0.50);
		goto ('UpdateStatus');
	}
	if ( (m_TeamManager.m_iTeamAction & 128) > 0 )
	{
		m_TeamManager.ActionCompleted(True);
		m_iStateProgress=12;
		if ( (m_TeamManager.m_Door != None) && (m_pawn.m_iID == m_TeamManager.m_iMemberCount - 1) )
		{
			m_vTargetPosition=m_TeamManager.m_Door.m_CorrespondingDoor.Location - 96 * vector(m_TeamManager.m_Door.m_CorrespondingDoor.Rotation);
			SetLocation(m_TeamManager.m_Door.Location + 200 * vector(m_TeamManager.m_Door.Rotation));
//			R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
			MoveTo(m_vTargetPosition,self);
		}
	}
	else
	{
		m_TeamManager.ActionCompleted(True);
		m_iStateProgress=12;
	}
ReinitAction:
	m_ActionTarget=None;
	m_iStateProgress=13;
WaitForTeamAI:
	Sleep(1.00);
	if ( NextState != 'None' )
	{
		m_iStateProgress=14;
		GotoState(NextState);
	}
	GotoState('HoldPosition');
}

state FindPathToTarget
{
	function EndState ()
	{
		SetTimer(0.00,False);
	}

	function Timer ()
	{
		if ( CanThrowGrenade(Pawn.Location,True,False) )
		{
			SetTimer(0.00,False);
			StopMoving();
			GotoState('TeamMoveTo','Action');
		}
	}

Begin:
	if ( m_TeamManager.m_iTeamAction == 320 )
	{
		SetTimer(0.30,True);
	}
	if ( m_DesiredTarget != None )
	{
		MoveTarget=FindPathToward(m_DesiredTarget,True);
	}
	else
	{
		MoveTarget=FindPathTo(m_vDesiredLocation,True);
	}
	if ( MoveTarget != None )
	{
		if ( NeedToOpenDoor(MoveTarget) )
		{
			m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
			MoveToPosition(m_pawn.m_Door.Location,m_pawn.m_Door.Rotation);
			Pawn.Acceleration=vect(0.00,0.00,0.00);
			SetFocusToDoorKnob(m_pawn.m_Door.m_RotatingDoor);
			Sleep(1.00);
			GotoStateLeadRoomEntry();
		}
		m_TargetLadder=R6Ladder(MoveTarget);
		if ( (m_pawn.m_Ladder != None) && (m_TargetLadder != None) && (m_pawn.m_Ladder != m_TargetLadder) )
		{
			m_TeamManager.InstructTeamToClimbLadder(R6LadderVolume(m_pawn.m_Ladder.MyLadder),True,m_pawn.m_iID);
		}
//		R6PreMoveToward(MoveTarget,MoveTarget,4);
		MoveToward(MoveTarget);
		if ( m_DesiredTarget != None )
		{
			if ( actorReachable(m_DesiredTarget) )
			{
				goto ('End');
			}
		}
		else
		{
			if ( pointReachable(m_vDesiredLocation) )
			{
				goto ('End');
			}
		}
		goto ('Begin');
	}
	else
	{
		if ( m_TeamManager.m_iTeamAction != 0 )
		{
			if (  !m_TeamManager.m_bGrenadeInProximity )
			{
				RainbowCannotCompleteOrders();
			}
		}
	}
End:
//	R6PreMoveTo(m_vDesiredLocation,m_vDesiredLocation,4);
	MoveTo(m_vDesiredLocation);
	GotoState(m_PostFindPathToState);
}

function FindPathToTargetLocation (Vector vTarget, optional Actor aTarget)
{
//	m_TeamManager.SetTeamState(3);
	m_DesiredTarget=aTarget;
	m_vDesiredLocation=vTarget;
	m_PostFindPathToState=GetStateName();
	GotoState('FindPathToTarget');
}

function ReInitEntryPositions ()
{
	m_vPreEntryPositions[0]=vect(0.00,0.00,0.00);
	m_vPreEntryPositions[1]=vect(0.00,0.00,0.00);
}

state RoomEntry
{
	function BeginState ()
	{
		m_pawn.ResetBoneRotation();
		m_pawn.m_bAvoidFacingWalls=False;
		m_bReactToNoise=True;
		m_bEnteredRoom=False;
		m_bIndividualAttacks=False;
		m_iTurn=0;
		ReInitEntryPositions();
	}

	function EndState ()
	{
		m_pawn.m_bAvoidFacingWalls=True;
		m_bReactToNoise=False;
		if ( m_iStateProgress == 5 )
		{
			m_iStateProgress=0;
		}
		m_bIndividualAttacks=True;
		SetTimer(0.00,False);
		m_pawn.m_u8DesiredYaw=0;
	}

	function Timer ()
	{
		m_iTurn++;
		LookAroundRoom(False);
	}

	function bool HasEnteredRoom (R6Pawn member)
	{
		if ( VSize(member.Location - m_TeamManager.m_Door.Location) < VSize(member.Location - m_TeamManager.m_Door.m_CorrespondingDoor.Location) )
		{
			return False;
		}
		else
		{
			return True;
		}
	}

	function SetMemberFocus ()
	{
		if ( PreEntryRoomIsAcceptablyLarge() )
		{
			if ( m_pawn.m_iID == 3 )
			{
				if ( m_TeamManager.m_bTeamIsSeparatedFromLeader )
				{
					SetLocation(Pawn.Location - 300 * vector(m_TeamManager.m_Door.Rotation));
				}
				else
				{
					SetLocation(m_TeamManager.m_Door.Location - 300 * vector(m_TeamManager.m_Door.Rotation));
				}
				Focus=self;
			}
			else
			{
				if ( (m_pawn.m_iID == 2) && ( !m_TeamLeader.m_bIsPlayer || m_TeamLeader.m_bIsPlayer &&  !m_TeamManager.m_bTeamIsSeparatedFromLeader) )
				{
					SetLocation(Pawn.Location - 300 * Normal(m_TeamManager.m_Door.Location - Pawn.Location) - 200 * vector(m_TeamManager.m_Door.Rotation));
					Focus=self;
				}
				else
				{
					SetFocusToDoorKnob(m_TeamManager.m_Door.m_RotatingDoor);
				}
			}
		}
		else
		{
			if ( m_pawn.m_iID == m_TeamManager.m_iMemberCount - 1 )
			{
				SetLocation(Pawn.Location - 200 * Normal(m_TeamManager.m_Door.Location - Pawn.Location));
				Focus=self;
			}
			else
			{
				SetFocusToDoorKnob(m_TeamManager.m_Door.m_RotatingDoor);
			}
		}
	}

	function Vector GetSingleFilePosition ()
	{
		local Vector vDir;

		vDir=m_PaceMember.Location - Pawn.Location;
		return m_PaceMember.Location - GetFormationDistance() * Normal(vDir);
	}

	function CoverRear ()
	{
		if ( m_TeamManager.m_iTeamAction == 0 )
		{
			SetLocation(Pawn.Location + Pawn.Location - FocalPoint);
			Focus=self;
		}
	}

	function float DistanceToLocation (Vector vTarget)
	{
		return VSize(Pawn.Location - vTarget);
	}

	function eMovementPace GetRoomEntryPace (bool bRun)
	{
		local eMovementPace ePace;
		local bool bCrouchedEntry;

		if ( m_TeamLeader.m_bIsPlayer )
		{
			if ( m_TeamManager.m_bTeamIsSeparatedFromLeader )
			{
				bCrouchedEntry=m_PaceMember.bIsCrouched;
			}
			else
			{
				bCrouchedEntry=m_TeamLeader.bIsCrouched;
			}
		}
		else
		{
			bCrouchedEntry=m_TeamManager.m_eMovementSpeed == 2;
		}
		if ( bCrouchedEntry )
		{
			if ( bRun )
			{
//				ePace=3;
			}
			else
			{
//				ePace=2;
			}
		}
		else
		{
			if ( bRun )
			{
//				ePace=5;
			}
			else
			{
//				ePace=4;
			}
		}
		return ePace;
	}

Begin:
	switch (m_iStateProgress)
	{
/*		case 0:
		goto ('GetIntoPosition');
		break;
		case 1:
		goto ('WaitForGo');
		break;
		case 2:
		goto ('PassDoor');
		break;
		case 3:
		goto ('EnterRoom');
		break;
		default:
		goto ('WaitOnLeader');   */
	}
GetIntoPosition:
	if ( m_TeamManager.m_Door.m_RotatingDoor == None )
	{
		GotoState('FollowLeader');
	}
	if ( m_TeamManager.m_Door.m_CorrespondingDoor == None )
	{
		GotoState('FollowLeader');
	}
	if ( PreEntryRoomIsAcceptablyLarge() )
	{
		m_vTargetPosition=GetEntryPosition(False);
		if ( m_vTargetPosition != Pawn.Location )
		{
			if (  !CanWalkTo(m_vTargetPosition) &&  !pointReachable(m_vTargetPosition) )
			{
				FindPathToTargetLocation(m_vTargetPosition);
			}
			else
			{
				if ( (m_vPreEntryPositions[0] != vect(0.00,0.00,0.00)) && (DistanceToLocation(m_vPreEntryPositions[0]) < DistanceToLocation(m_vTargetPosition)) )
				{
					if ( (m_vPreEntryPositions[1] == vect(0.00,0.00,0.00)) || (DistanceToLocation(m_vPreEntryPositions[0]) < DistanceToLocation(m_vPreEntryPositions[1])) )
					{
//						R6PreMoveTo(m_vPreEntryPositions[0],m_vPreEntryPositions[0],GetRoomEntryPace(False));
					}
					MoveTo(m_vPreEntryPositions[0]);
					if ( m_vPreEntryPositions[1] != vect(0.00,0.00,0.00) )
					{
//						R6PreMoveTo(m_vPreEntryPositions[1],m_vPreEntryPositions[1],GetRoomEntryPace(False));
						MoveTo(m_vPreEntryPositions[1]);
					}
				}
				else
				{
					if ( (m_vPreEntryPositions[1] != vect(0.00,0.00,0.00)) && (DistanceToLocation(m_vPreEntryPositions[1]) < DistanceToLocation(m_vTargetPosition)) )
					{
//						R6PreMoveTo(m_vPreEntryPositions[1],m_vPreEntryPositions[1],GetRoomEntryPace(False));
						MoveTo(m_vPreEntryPositions[1]);
					}
				}
//				R6PreMoveTo(m_vTargetPosition,m_TeamManager.m_Door.m_RotatingDoor.Location,GetRoomEntryPace(False));
				MoveTo(m_vTargetPosition);
				MoveToPosition(m_vTargetPosition,rotator(m_TeamManager.m_Door.m_CorrespondingDoor.Location - m_vTargetPosition));
			}
		}
	}
	Pawn.Acceleration=vect(0.00,0.00,0.00);
	m_iStateProgress=1;
WaitForGo:
	SetMemberFocus();
	StopMoving();
	if ( m_TeamLeader.m_bIsPlayer &&  !HasEnteredRoom(m_PaceMember) ||  !m_TeamLeader.m_bIsPlayer &&  !R6RainbowAI(m_PaceMember.Controller).m_bEnteredRoom )
	{
		if (  !PreEntryRoomIsAcceptablyLarge() && (DistanceTo(m_PaceMember) > GetFormationDistance()) )
		{
			m_vTargetPosition=GetSingleFilePosition();
			if (  !pointReachable(m_vTargetPosition) )
			{
				FindPathToTargetLocation(m_PaceMember.Location,m_PaceMember);
			}
//			R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,GetRoomEntryPace(False));
			MoveTo(m_vTargetPosition);
		}
		else
		{
			if ( (m_pawn.m_iID == 2) && HasEnteredRoom(m_TeamLeader) )
			{
				Focus=m_TeamManager.m_Door;
			}
			Sleep(0.50);
		}
		goto ('WaitForGo');
	}
	m_iStateProgress=2;
PassDoor:
	Sleep(0.20);
	if (  !PostEntryRoomIsAcceptablyLarge() )
	{
		m_TeamManager.EndRoomEntry();
		GotoState('FollowLeader');
	}
//	m_eCurrentRoomLayout=m_TeamManager.m_Door.m_eRoomLayout;
	m_vTargetPosition=m_TeamManager.m_Door.Location;
//	R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,GetRoomEntryPace(True));
	MoveToPosition(m_vTargetPosition,rotator(m_vTargetPosition - Pawn.Location));
	m_TeamManager.EnteredRoom(m_pawn);
	m_vTargetPosition=m_TeamManager.m_Door.m_CorrespondingDoor.Location;
//	R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,GetRoomEntryPace(True));
	MoveToPosition(m_vTargetPosition,rotator(m_vTargetPosition - Pawn.Location));
	m_iStateProgress=3;
	if ( m_PaceMember.m_bIsPlayer )
	{
		m_TeamManager.GetPlayerDirection();
	}
EnterRoom:
	m_vTargetPosition=GetEntryPosition(True);
	SetLocation(FocalPoint);
//	R6PreMoveTo(m_vTargetPosition,Location,GetRoomEntryPace(True));
	MoveToPosition(m_vTargetPosition,rotator(Location - m_vTargetPosition));
	SetTimer(1.00,True);
	LookAroundRoom(False);
	m_iStateProgress=4;
	Sleep(0.50);
WaitOnLeader:
	StopMoving();
	Sleep(0.50);
	if ( m_eCoverDirection == 3 )
	{
		CoverRear();
	}
	if ( IsMoving(m_PaceMember) && (DistanceTo(m_PaceMember) > 200) || (DistanceTo(m_PaceMember) > 300) )
	{
		if ( m_eCoverDirection == 3 )
		{
			CoverRear();
		}
		m_iStateProgress=5;
		GotoState('FollowLeader');
	}
	else
	{
		goto ('WaitOnLeader');
	}
}

state HoldPosition
{
	function BeginState ()
	{
		m_bReactToNoise=True;
	}

	function EndState ()
	{
		m_bReactToNoise=False;
		SetTimer(0.00,False);
	}

	function Timer ()
	{
		m_iWaitCounter++;
	}

Begin:
//	m_TeamManager.SetTeamState(2);
	Focus=None;
	m_iWaitCounter=0;
	Pawn.Acceleration=vect(0.00,0.00,0.00);
	SetTimer(1.00,True);
	Sleep(1.00);
Hold:
	VerifyWeaponInventory();
	EnsureRainbowIsArmed();
	if (  !Pawn.bIsCrouched &&  !Pawn.m_bIsProne && (m_iWaitCounter > 8.00) )
	{
		Pawn.bWantsToCrouch=True;
		Sleep(0.50);
	}
	if ( NeedToReload() )
	{
		RainbowReloadWeapon();
	}
	Sleep(1.00);
	if ( NextState != 'None' )
	{
		GotoState(NextState);
	}
	goto ('Hold');
}

function SwitchWeapon (int f)
{
	local R6AbstractWeapon NewWeapon;

	if ( f == m_pawn.m_iCurrentWeapon )
	{
		return;
	}
	Pawn.R6MakeNoise(SNDTYPE_Equipping);
	NewWeapon=R6AbstractWeapon(m_pawn.GetWeaponInGroup(f));
	if ( NewWeapon != None )
	{
		if ( Level.NetMode == NM_Standalone )
		{
			m_pawn.EngineWeapon.GotoState('None');
		}
		m_pawn.m_iCurrentWeapon=f;
		m_pawn.GetWeapon(NewWeapon);
		m_pawn.m_bChangingWeapon=True;
		if ( m_pawn.m_SoundRepInfo != None )
		{
			m_pawn.m_SoundRepInfo.m_CurrentWeapon=f - 1;
		}
		m_pawn.PlayWeaponAnimation();
	}
}

state TeamSecureTerrorist
{
	function BeginState ()
	{
		m_pawn.ResetBoneRotation();
		m_pawn.m_bAvoidFacingWalls=False;
		m_bIgnoreBackupBump=True;
		m_bStateFlag=False;
	}

	function EndState ()
	{
		m_bIgnoreBackupBump=False;
		if (  !m_bStateFlag )
		{
			m_pawn.m_bPostureTransition=False;
//			m_pawn.AnimBlendToAlpha(m_pawn.1,0.00,0.50);
			m_pawn.m_ePlayerIsUsingHands=HANDS_None;
			m_pawn.PlayWeaponAnimation();
			R6Terrorist(m_ActionTarget).ResetArrest();
		}
		if ( m_pawn.m_bWeaponIsSecured &&  !m_pawn.m_bWeaponTransition )
		{
//			m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
		}
	}

Begin:
	if (  !R6Pawn(m_ActionTarget).IsAlive() )
	{
		goto ('End');
	}
	if ( m_pawn.m_iID == 1 )
	{
		Sleep(GetLeadershipReactionTime());
	}
//	m_TeamManager.SetTeamState(3);
	if (  !CanWalkTo(m_ActionTarget.Location) &&  !actorReachable(m_ActionTarget) )
	{
		FindPathToTargetLocation(m_ActionTarget.Location,m_ActionTarget);
	}
DirectMove:
//	R6PreMoveToward(m_ActionTarget,m_ActionTarget,4);
	MoveToward(m_ActionTarget);
	if ( DistanceTo(m_ActionTarget) > 100 )
	{
		goto ('Begin');
	}
	Focus=m_ActionTarget;
	StopMoving();
	Sleep(0.50);
JL00D8:
	if ( m_TeamManager.m_bCAWaitingForZuluGoCode )
	{
//		m_TeamManager.SetTeamState(1);
		Sleep(0.50);
//		goto JL00D8;
	}
Secure:
	Disable('SeePlayer');
	if ( R6Terrorist(m_ActionTarget).m_bIsUnderArrest )
	{
		RainbowCannotCompleteOrders();
	}
//	m_TeamManager.SetTeamState(17);
//	m_pawn.SetNextPendingAction(PENDING_StopCoughing7);
//	FinishAnim(m_pawn.14);
//	R6Terrorist(m_ActionTarget).m_controller.DispatchOrder(R6Terrorist(m_ActionTarget).1,m_pawn);
JL018E:
	if (  !R6Terrorist(m_ActionTarget).PawnHaveFinishedRotation() )
	{
		Sleep(0.10);
//		goto JL018E;
	}
//	m_pawn.SetNextPendingAction(PENDING_StopCoughing9);
//	FinishAnim(m_pawn.1);
	m_bStateFlag=True;
//	m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
//	FinishAnim(m_pawn.14);
End:
	if ( m_pawn.m_iID == 0 )
	{
		m_TeamManager.m_SurrenderedTerrorist=None;
		GotoState('Patrol');
	}
	else
	{
		m_TeamManager.MoveTeamToCompleted(True);
	}
}

function bool TooCloseToThrowGrenade (Vector vPawnLocation)
{
	local R6EngineWeapon weapon;
	local float fKillRadius;
	local float fExplosionRadius;

	weapon=m_pawn.GetWeaponInGroup(m_iActionUseGadgetGroup);
	if ( weapon == None )
	{
		return False;
	}
	if ( VSize(vPawnLocation - m_vLocationOnTarget) < weapon.GetSaveDistanceToThrow() )
	{
		return True;
	}
	return False;
}

function bool CanThrowGrenade (Vector vPawnLocation, bool bTraceActors, bool bCheckTooClose)
{
	local Vector vDir;
	local Vector vTargetLoc;
	local float fDist;
	local Actor HitActor;
	local Vector vHitLocation;
	local Vector vHitNormal;
	local int iTraceFlags;

	vDir=m_vLocationOnTarget - vPawnLocation;
	fDist=VSize(vDir);
	if ( fDist > 1500 )
	{
		return False;
	}
	if ( bCheckTooClose && TooCloseToThrowGrenade(vPawnLocation) )
	{
		return False;
	}
	vTargetLoc=m_vLocationOnTarget;
	vTargetLoc.Z += 15;
	if ( bTraceActors )
	{
		iTraceFlags=1;
	}
	iTraceFlags=iTraceFlags | 4;
	HitActor=R6Trace(vHitLocation,vHitNormal,vTargetLoc,vPawnLocation,iTraceFlags,vect(20.00,20.00,10.00));
	if ( (HitActor != None) && (VSize(vHitLocation - vTargetLoc) > 30) )
	{
		return False;
	}
	return True;
}

function bool ClearThrowIsAvailable (Vector vTarget)
{
	local Actor HitActor;
	local Vector vHitLocation;
	local Vector vHitNormal;

	HitActor=Pawn.R6Trace(vHitLocation,vHitNormal,vTarget + vect(0.00,0.00,40.00),Pawn.Location,1 | 4,vect(30.00,30.00,15.00));
	if ( HitActor == None )
	{
		return True;
	}
	if ( HitActor.IsA('R6Pawn') )
	{
		return False;
	}
	return True;
}

function ResetTeamMoveTo ()
{
	local int iWeapon;

	m_iStateProgress=0;
	SetTimer(0.00,False);
	if ( m_pawn.m_bInteractingWithDevice )
	{
		m_pawn.m_bInteractingWithDevice=False;
		m_pawn.m_bPostureTransition=False;
//		m_pawn.AnimBlendToAlpha(m_pawn.1,0.00,0.50);
		m_pawn.m_ePlayerIsUsingHands=HANDS_None;
		if ( R6IOObject(m_ActionTarget) != None )
		{
//			R6IOObject(m_ActionTarget).PerformSoundAction(1);
		}
	}
	if ( m_pawn.m_bWeaponIsSecured &&  !m_pawn.m_bWeaponTransition )
	{
//		m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
		m_pawn.PlayWeaponAnimation();
	}
	m_pawn.m_iCurrentWeapon=FClamp(m_pawn.m_iCurrentWeapon,1.00,4.00);
	VerifyWeaponInventory();
	EnsureRainbowIsArmed();
}

state TeamMoveTo
{
	function BeginState ()
	{
		m_pawn.ResetBoneRotation();
		m_pawn.m_bAvoidFacingWalls=False;
		m_iStateProgress=0;
	}

	function SetUpTeamMoveTo ()
	{
		SetTimer(0.00,False);
		m_vTargetPosition=m_TeamManager.m_vActionLocation;
		if ( ((m_TeamManager.m_iTeamAction & 64) > 0) && (m_iStateProgress == 0) )
		{
			m_iStateProgress=1;
			if (  !CanThrowGrenade(Pawn.Location,False,True) )
			{
				if ( TooCloseToThrowGrenade(Pawn.Location) && FindRandomNavPointToThrowGrenade() )
				{
					m_iStateProgress=2;
				}
				else
				{
					m_vTargetPosition=m_vLocationOnTarget;
					m_vTargetPosition.Z += Pawn.CollisionHeight;
					SetTimer(0.30,True);
				}
			}
			else
			{
				m_vTargetPosition=Pawn.Location;
			}
		}
	}

	function EndState ()
	{
		SetTimer(0.00,False);
		m_pawn.m_bAvoidFacingWalls=m_pawn.Default.m_bAvoidFacingWalls;
		ResetTeamMoveTo();
	}

	function bool FindRandomNavPointToThrowGrenade ()
	{
		local Actor Actor;
		local int i;
		local int iSize;
		local Vector vLocationList[10];
		local int iLocationListIndex;
		local int iDistance;

	JL0000:
		if ( i < 10 )
		{
			Actor=FindRandomDest(True);
			if (  !Actor.IsA('R6Ladder') && (Abs(Actor.Location.Z - Pawn.Location.Z) < 400) )
			{
				if ( CanThrowGrenade(Actor.Location,False,True) )
				{
					m_vTargetPosition=Actor.Location;
					return True;
				}
				else
				{
					if ( TooCloseToThrowGrenade(Actor.Location) )
					{
						vLocationList[iLocationListIndex]=Actor.Location;
						iLocationListIndex++;
					}
				}
			}
			i++;
			goto JL0000;
		}
		if ( iLocationListIndex > 0 )
		{
			i=0;
			i=0;
	JL00F1:
			if ( i < iLocationListIndex )
			{
				if ( VSize(vLocationList[i] - Pawn.Location) > iDistance )
				{
					if ( CanThrowGrenade(vLocationList[i],False,False) )
					{
						iDistance=VSize(vLocationList[i] - Pawn.Location);
						m_vTargetPosition=vLocationList[i];
					}
				}
				++i;
				goto JL00F1;
			}
			return True;
		}
		return False;
	}

	function Timer ()
	{
		if ( (m_TeamManager.m_iTeamAction & 64) > 0 )
		{
			if ( CanThrowGrenade(Pawn.Location,True,False) )
			{
				SetTimer(0.00,False);
				StopMoving();
				GotoState('TeamMoveTo','Action');
			}
		}
	}

Begin:
	if ( ((m_TeamManager.m_iTeamAction & 64) > 0) && (m_vLocationOnTarget == vect(0.00,0.00,0.00)) )
	{
		goto ('End');
	}
	StopMoving();
JL003D:
	if ( m_TeamManager.m_bCAWaitingForZuluGoCode )
	{
//		m_TeamManager.SetTeamState(1);
		Sleep(0.50);
//		goto JL003D;
	}
	SetUpTeamMoveTo();
	Sleep(GetLeadershipReactionTime());
MoveTowardTarget:
//	m_TeamManager.SetTeamState(3);
	if ( (m_TeamManager.m_iTeamAction & 2048) > 0 )
	{
		if (  !actorReachable(m_ActionTarget) )
		{
			FindPathToTargetLocation(m_ActionTarget.Location,m_ActionTarget);
		}
	}
	else
	{
		if (  !pointReachable(m_vTargetPosition) )
		{
			FindPathToTargetLocation(m_vTargetPosition);
		}
	}
FinalMove:
	if ( (m_TeamManager.m_iTeamAction & 2048) > 0 )
	{
JL0102:
		if ( DistanceTo(m_ActionTarget) > 100 )
		{
//			R6PreMoveToward(m_ActionTarget,m_ActionTarget,4);
			MoveToward(m_ActionTarget);
//			goto JL0102;
		}
	}
	else
	{
//		R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
		MoveTo(m_vTargetPosition);
		if ( (m_TeamManager.m_iTeamAction != 0) && (m_eMoveToResult == 2) )
		{
			m_TeamManager.MoveTeamToCompleted(False);
			RainbowCannotCompleteOrders();
		}
	}
Action:
	if ( (m_TeamManager.m_iTeamAction & 64) > 0 )
	{
//		m_TeamManager.SetTeamState(14);
		if ( CanThrowGrenade(Pawn.Location,False,False) )
		{
			if (  !ClearThrowIsAvailable(m_vLocationOnTarget) )
			{
				m_vTargetPosition=Pawn.Location + 300 * Normal(m_vLocationOnTarget - Pawn.Location);
//				R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
				MoveTo(m_vTargetPosition);
			}
			SetTimer(0.00,False);
			Disable('NotifyBump');
			StopMoving();
			Sleep(0.20);
			SetLocation(m_vLocationOnTarget);
			Focus=self;
			Target=self;
			SwitchWeapon(m_iActionUseGadgetGroup);
//			FinishAnim(m_pawn.14);
			SetRotation(Pawn.Rotation);
			SetGunDirection(Target);
			m_pawn.m_bThrowGrenadeWithLeftHand=False;
//			m_pawn.m_eGrenadeThrow=1;
//			m_pawn.m_eRepGrenadeThrow=1;
			m_pawn.PlayWeaponAnimation();
//			FinishAnim(m_pawn.14);
//			m_pawn.m_eRepGrenadeThrow=0;
			m_vLocationOnTarget=vect(0.00,0.00,0.00);
			m_iStateProgress=0;
			Enable('NotifyBump');
			SwitchWeapon(1);
//			FinishAnim(m_pawn.14);
		}
		else
		{
			SetTimer(0.30,True);
			m_vTargetPosition=m_vLocationOnTarget;
			m_vTargetPosition.Z += Pawn.CollisionHeight;
			Sleep(0.20);
			goto ('Begin');
		}
		Sleep(1.00);
	}
	else
	{
		if ( ((m_TeamManager.m_iTeamAction & 4096) > 0) || ((m_TeamManager.m_iTeamAction & 8192) > 0) )
		{
			if ( m_eMoveToResult == 1 )
			{
				if ( (m_TeamManager.m_iTeamAction & 4096) > 0 )
				{
					if (  !R6IOObject(m_ActionTarget).m_bIsActivated )
					{
						RainbowCannotCompleteOrders();
					}
//					m_TeamManager.SetTeamState(15);
				}
				else
				{
//					m_TeamManager.SetTeamState(16);
				}
				m_vTargetPosition=m_ActionTarget.Location - (Pawn.CollisionRadius + m_ActionTarget.CollisionRadius + 10) * vector(m_ActionTarget.Rotation);
//				R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
				MoveToPosition(m_vTargetPosition,rotator(m_ActionTarget.Location - m_vTargetPosition));
				Focus=m_ActionTarget;
				FinishRotation();
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing7);
//				FinishAnim(m_pawn.14);
//				m_pawn.m_eDeviceAnim=R6IOObject(m_ActionTarget).m_eAnimToPlay;
//				m_pawn.SetNextPendingAction(PENDING_Coughing8);
//				R6IOObject(m_ActionTarget).PerformSoundAction(0);
				m_pawn.m_bInteractingWithDevice=True;
				Sleep(R6IOObject(m_ActionTarget).GetTimeRequired(m_pawn));
				R6IOObject(m_ActionTarget).ToggleDevice(m_pawn);
//				R6IOObject(m_ActionTarget).PerformSoundAction(2);
//				PlaySoundActionCompleted(R6IOObject(m_ActionTarget).m_eAnimToPlay);
//				m_pawn.AnimBlendToAlpha(m_pawn.1,0.00,0.50);
				m_pawn.m_bInteractingWithDevice=False;
				m_pawn.m_ePlayerIsUsingHands=HANDS_None;
				m_pawn.PlayWeaponAnimation();
				Sleep(1.00);
//				m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
//				FinishAnim(m_pawn.14);
			}
			else
			{
				RainbowCannotCompleteOrders();
			}
		}
		else
		{
			if ( (m_TeamManager.m_iTeamAction & 2048) > 0 )
			{
				if ( R6Hostage(m_ActionTarget).m_escortedByRainbow != None )
				{
//					R6Hostage(m_ActionTarget).m_controller.DispatchOrder(R6Hostage(m_ActionTarget).m_controller.2);
				}
				else
				{
//					R6Hostage(m_ActionTarget).m_controller.DispatchOrder(R6Hostage(m_ActionTarget).m_controller.1,m_pawn);
				}
			}
			Sleep(1.00);
		}
	}
	if ( m_pawn.m_iID == 0 )
	{
		m_TeamManager.ActionCompleted(True);
	}
	m_TeamManager.RestoreTeamOrder();
End:
	if ( m_pawn.m_iID == 0 )
	{
		GotoState('Patrol');
	}
	else
	{
		m_TeamManager.MoveTeamToCompleted(True);
		NextState='None';
		GotoState('HoldPosition');
	}
}

state WaitForTeam
{
	function BeginState ()
	{
		m_bReactToNoise=True;
	}

	function EndState ()
	{
		m_bReactToNoise=False;
	}

Begin:
	if ( m_TeamManager.m_iMemberCount == 1 )
	{
		goto ('Wait');
	}
	if ( m_TeamManager.m_PlanActionPoint != None )
	{
		m_vTargetPosition=m_pawn.m_Ladder.Location;
		if ( m_TeamManager.m_PlanActionPoint == m_pawn.m_Ladder )
		{
			m_TeamManager.ActionPointReached();
		}
JL007B:
		if ( VSize(m_vTargetPosition - Pawn.Location) < 300 )
		{
			if ( m_TeamManager.m_PlanActionPoint == None )
			{
//				goto JL01B0;
			}
			if ( (m_pawn.m_Door != None) && m_pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed && NextActionPointIsThroughDoor(m_TeamManager.m_PlanActionPoint) )
			{
//				goto JL01B0;
			}
			if ( (m_TeamManager.m_PlanActionPoint == m_pawn.m_Ladder) ||  !actorReachable(m_TeamManager.m_PlanActionPoint) || (m_TeamManager.m_eNextAPAction != 0) )
			{
				goto ('FindNearbySpot');
			}
//			R6PreMoveToward(m_TeamManager.m_PlanActionPoint,m_TeamManager.m_PlanActionPoint,GetTeamPace());
			MoveToward(m_TeamManager.m_PlanActionPoint);
			m_TeamManager.ActionPointReached();
//			goto JL007B;
		}
JL01B0:
	}
	else
	{
FindNearbySpot:
		FindNearbyWaitSpot(m_pawn.m_Ladder,m_vTargetPosition);
		if ( m_vTargetPosition != vect(0.00,0.00,0.00) )
		{
//			R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,GetTeamPace());
			MoveTo(m_vTargetPosition);
		}
	}
Wait:
	Sleep(1.00);
	if ( m_TeamManager.TeamHasFinishedClimbingLadder() )
	{
		m_pawn.m_Ladder=None;
		if ( m_TeamManager.m_bAllTeamsHold )
		{
			m_TeamManager.AITeamHoldPosition();
		}
		else
		{
			GotoState('Patrol');
		}
	}
	else
	{
		goto ('Wait');
	}
}

function eMovementPace GetTeamPace ()
{
	local eMovementPace ePace;

	switch (m_TeamManager.m_eMovementSpeed)
	{
/*		case 0:
		if ( m_TeamManager.AtLeastOneMemberIsWounded() )
		{
			ePace=4;
		}
		else
		{
			ePace=5;
		}
		break;
		case 1:
		ePace=4;
		break;
		case 2:
		ePace=2;
		break;
		default:
		ePace=4;   */
	}
//	m_pawn.m_eMovementPace=ePace;
	return ePace;
}

function bool NextActionPointIsThroughDoor (Actor nextActionPoint)
{
	local Vector vDir;
	local float fResult;

	if ( nextActionPoint == None )
	{
		return False;
	}
	if ( m_pawn.m_Door == None )
	{
		return False;
	}
	if ( m_pawn.m_Door.m_RotatingDoor.m_bTreatDoorAsWindow )
	{
		return False;
	}
	if ( VSize(nextActionPoint.Location - m_pawn.m_Door.Location) > VSize(nextActionPoint.Location - m_pawn.m_Door.m_CorrespondingDoor.Location) )
	{
		return True;
	}
	return False;
}

function SetGrenadeParameters (bool bPeeking, optional bool bThrowOverhand)
{
	if ( bPeeking )
	{
		if ( OnRightSideOfDoor(m_ActionTarget) )
		{
			m_pawn.m_bThrowGrenadeWithLeftHand=True;
//			m_pawn.m_eGrenadeThrow=4;
//			m_pawn.m_eRepGrenadeThrow=4;
		}
		else
		{
			m_pawn.m_bThrowGrenadeWithLeftHand=False;
//			m_pawn.m_eGrenadeThrow=5;
//			m_pawn.m_eRepGrenadeThrow=5;
		}
	}
	else
	{
		if ( bThrowOverhand )
		{
			m_pawn.m_bThrowGrenadeWithLeftHand=False;
//			m_pawn.m_eGrenadeThrow=1;
//			m_pawn.m_eRepGrenadeThrow=1;
		}
		else
		{
			m_pawn.m_bThrowGrenadeWithLeftHand=False;
//			m_pawn.m_eGrenadeThrow=2;
//			m_pawn.m_eRepGrenadeThrow=2;
		}
	}
}

function ConfirmLadderActionPointWasReached (R6Ladder Ladder)
{
	if ( (m_pawn.m_ePawnType == 1) && (m_pawn.m_iID == 0) )
	{
		if ( Ladder == m_TeamManager.m_PlanActionPoint )
		{
			m_TeamManager.ActionPointReached();
		}
	}
}

function bool TargetIsLadderToClimb (R6Ladder Target)
{
	if ( (Target == None) || (m_pawn.m_Ladder == None) )
	{
		return False;
	}
	if ( m_pawn.m_Ladder == Target )
	{
		return False;
	}
	if ( Target.MyLadder != m_pawn.m_Ladder.MyLadder )
	{
		return False;
	}
	return True;
}

state Patrol
{
	function BeginState ()
	{
		m_pawn.m_bAvoidFacingWalls=False;
		m_iWaitCounter=0;
		m_pawn.m_bCanProne=False;
		m_bReactToNoise=True;
		m_bStateFlag=False;
	}

	function EndState ()
	{
		m_pawn.m_bAvoidFacingWalls=m_pawn.Default.m_bAvoidFacingWalls;
		SetTimer(0.00,False);
		m_pawn.m_bThrowGrenadeWithLeftHand=False;
		m_bIgnoreBackupBump=False;
		m_pawn.m_bCanProne=m_pawn.Default.m_bCanProne;
		m_bReactToNoise=False;
		if ( m_bStateFlag )
		{
			m_TeamManager.ActionNodeCompleted();
		}
	}

	function bool CornerMovement ()
	{
		local Vector PathA;
		local Vector PathB;

		PathA=Normal(MoveTarget.Location - Pawn.Location);
		PathB=Normal(m_NextMoveTarget.Location - MoveTarget.Location);
		if ( PathA Dot PathB < 0.71 )
		{
			return True;
		}
		return False;
	}

	function DispatchInteractions ()
	{
		local Actor actionTarget;

		actionTarget=CheckForPossibleInteractions();
		if ( actionTarget != None )
		{
			if ( (MoveTarget != None) && (VSize(MoveTarget.Location - actionTarget.Location) < VSize(Pawn.Location - actionTarget.Location)) && ActorReachableFromLocation(actionTarget,MoveTarget.Location) )
			{
				return;
			}
			if ( actionTarget.IsA('R6IOBomb') )
			{
				m_TeamManager.ReorganizeTeamToInteractWithDevice(4096,actionTarget);
			}
			else
			{
				if ( actionTarget.IsA('R6IODevice') )
				{
					m_TeamManager.ReorganizeTeamToInteractWithDevice(8192,actionTarget);
				}
				else
				{
					if ( actionTarget.IsA('R6Terrorist') )
					{
						m_ActionTarget=actionTarget;
						GotoState('TeamSecureTerrorist');
					}
					else
					{
						if ( actionTarget.IsA('R6Hostage') )
						{
							if ( R6Hostage(actionTarget).IsAlive() &&  !R6Hostage(actionTarget).m_bCivilian )
							{
								if (  !m_TeamManager.m_bLeaderIsAPlayer )
								{
//									m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowTeamVoices(m_pawn,4);
								}
//								R6Hostage(actionTarget).m_controller.DispatchOrder(R6Hostage(actionTarget).m_controller.1,m_pawn);
							}
							m_TeamManager.m_HostageToRescue=None;
						}
					}
				}
			}
		}
	}

	function Timer ()
	{
		m_iWaitCounter++;
		if ( (MoveTarget != None) && (m_NextMoveTarget != None) &&  !ActionIsGrenade(m_TeamManager.m_ePlanAction) )
		{
			if ( (Enemy == None) && (DistanceTo(MoveTarget) < 200) )
			{
				if ( CornerMovement() && (m_NextMoveTarget != None) )
				{
					Focus=m_NextMoveTarget;
					FocalPoint=m_NextMoveTarget.Location;
				}
			}
		}
		if ( m_bTeamMateHasBeenKilled )
		{
			m_bTeamMateHasBeenKilled=False;
			Pawn.Acceleration=vect(0.00,0.00,0.00);
			NextState='Patrol';
			GotoState('HoldPosition');
			return;
		}
		if ( m_iWaitCounter % 10 == 0 )
		{
			DispatchInteractions();
		}
	}

	function bool ConfirmActionPointReached ()
	{
		if ( VSize(MoveTarget.Location - Pawn.Location) < 100 )
		{
			return True;
		}
		return False;
	}

	function bool IsCloseEnoughToInteractWith (Actor actionTarget)
	{
		if ( actionTarget == None )
		{
			return False;
		}
		if ( (DistanceTo(actionTarget) < 500) && (Abs(Pawn.Location.Z - actionTarget.Location.Z) < 100) )
		{
			return True;
		}
		return False;
	}

	function Actor CheckForPossibleInteractions ()
	{
		local int i;
		local R6InteractiveObject aIntActor;
		local R6Terrorist terro;

		i=0;
	JL0007:
		if ( i < m_TeamManager.m_InteractiveObjectList.Length )
		{
			aIntActor=m_TeamManager.m_InteractiveObjectList[i];
			if ( aIntActor != None )
			{
				if ( R6IOObject(aIntActor).m_bIsActivated && IsCloseEnoughToInteractWith(aIntActor) )
				{
					return aIntActor;
				}
			}
			i++;
			goto JL0007;
		}
		if ( m_TeamManager.m_HostageToRescue != None )
		{
			if ( IsCloseEnoughToInteractWith(m_TeamManager.m_HostageToRescue) )
			{
				return m_TeamManager.m_HostageToRescue;
			}
		}
		if ( m_TeamManager.m_SurrenderedTerrorist != None )
		{
			terro=R6Terrorist(m_TeamManager.m_SurrenderedTerrorist);
			if ( IsCloseEnoughToInteractWith(terro) &&  !terro.m_bIsUnderArrest )
			{
				return terro;
			}
		}
		return None;
	}

	function bool ActionIsGrenade (EPlanAction eAPAction)
	{
		if ( (eAPAction == 1) || (eAPAction == 2) || (eAPAction == 3) || (eAPAction == 4) )
		{
			return True;
		}
		return False;
	}

	function Actor GetFocus ()
	{
		if ( Enemy == None )
		{
			return MoveTarget;
		}
		return Enemy;
	}

Begin:
	SetTimer(0.10,True);
	MoveTarget=m_TeamManager.m_PlanActionPoint;
	if ( (MoveTarget != None) && ConfirmActionPointReached() )
	{
		m_TeamManager.ActionPointReached();
	}
	if ( m_TeamManager.m_bPendingSnipeUntilGoCode )
	{
		m_TeamManager.ReOrganizeTeamForSniping();
		m_TeamManager.SnipeUntilGoCode();
	}
	if ( m_bReorganizationPending )
	{
		ReorganizeTeamAsNeeded();
	}
	if ( Pawn.m_bIsProne )
	{
		Pawn.m_bWantsToProne=False;
		Sleep(1.00);
	}
	if (  !m_pawn.IsStationary() && SniperChangeToSecondaryWeapon() )
	{
		Sleep(0.50);
	}
PickActionPoint:
	VerifyWeaponInventory();
	EnsureRainbowIsArmed();
	if ( m_TeamManager.m_iMemberCount > 1 )
	{
JL00F3:
		if ( DistanceTo(m_TeamManager.m_Team[m_TeamManager.m_iMemberCount - 1]) > 800 )
		{
			Sleep(0.50);
//			goto JL00F3;
		}
	}
	MoveTarget=m_TeamManager.m_PlanActionPoint;
	if ( (MoveTarget != None) || (m_TeamManager.m_ePlanAction != 0) )
	{
		DispatchInteractions();
		m_iWaitCounter=0;
		if ( m_TeamManager.m_ePlanAction != 5 )
		{
			if ( SniperChangeToSecondaryWeapon() )
			{
				Sleep(0.50);
			}
		}
	}
	else
	{
		if ( m_iWaitCounter > 30 )
		{
			SniperChangeToPrimaryWeapon();
			if (  !Pawn.bIsCrouched && (m_TeamManager.m_eGoCode == 4) )
			{
				Pawn.bWantsToCrouch=True;
				Sleep(0.50);
			}
		}
	}
	if ( NeedToReload() )
	{
		if (  !Pawn.bIsCrouched )
		{
			Pawn.bWantsToCrouch=True;
		}
		RainbowReloadWeapon();
		StopMoving();
JL0238:
		if ( m_pawn.m_bReloadingWeapon )
		{
			Sleep(0.20);
//			goto JL0238;
		}
	}
	if ( MoveTarget == None )
	{
		if ( m_TeamManager.m_ePlanAction == 5 )
		{
			m_TeamManager.SnipeUntilGoCode();
		}
		Sleep(0.10);
		goto ('FormationAroundDoor');
	}
	if ( m_TeamManager.m_eNextAPAction == 0 )
	{
		m_NextMoveTarget=m_TeamManager.PreviewNextActionPoint();
	}
	else
	{
		m_NextMoveTarget=None;
		if ( m_TeamManager.m_eNextAPAction == 6 )
		{
			m_TeamManager.ReOrganizeTeamForBreachDoor();
		}
		else
		{
			if ( m_TeamManager.m_eNextAPAction == 5 )
			{
				m_TeamManager.ReOrganizeTeamForSniping();
			}
			else
			{
				if ( ActionIsGrenade(m_TeamManager.m_eNextAPAction) )
				{
					m_TeamManager.ReOrganizeTeamForGrenade(m_TeamManager.m_eNextAPAction);
				}
			}
		}
	}
MoveToActionPoint:
	MoveTarget=m_TeamManager.m_PlanActionPoint;
	if ( MoveTarget == m_pawn.m_Door )
	{
		m_TeamManager.ActionPointReached();
		goto ('DoorsAndLadders');
	}
//	m_TeamManager.SetTeamState(3);
	if ( (m_pawn.m_Door != None) && m_pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed && NextActionPointIsThroughDoor(MoveTarget) )
	{
		goto ('DoorsAndLadders');
	}
	if ( TargetIsLadderToClimb(R6Ladder(MoveTarget)) )
	{
		goto ('DoorsAndLadders');
	}
	if ( !CanWalkTo(MoveTarget.Location) && !actorReachable(MoveTarget) )
	{
		goto ('BlockedFindPath');
	}
//	R6PreMoveToward(MoveTarget,GetFocus(),GetTeamPace());
	MoveToward(MoveTarget,GetFocus());
	if ( ConfirmActionPointReached() )
	{
		if ( MoveTarget.IsA('R6Door') )
		{
			ForceCurrentDoor(R6Door(MoveTarget));
		}
		m_TeamManager.ActionPointReached();
		goto ('DoorsAndLadders');
	}
	else
	{
		goto ('MoveToActionPoint');
	}
BlockedFindPath:
	MoveTarget=FindPathToward(m_TeamManager.m_PlanActionPoint,True);
	if ( MoveTarget != None )
	{
//		R6PreMoveToward(MoveTarget,GetFocus(),GetTeamPace());
		MoveToward(MoveTarget,GetFocus());
		if ( ConfirmActionPointReached() && MoveTarget.IsA('R6Door') )
		{
			ForceCurrentDoor(R6Door(MoveTarget));
		}
		goto ('DoorsAndLadders');
	}
	else
	{
//		R6PreMoveToward(m_TeamManager.m_PlanActionPoint,m_TeamManager.m_PlanActionPoint,GetTeamPace());
		MoveToward(m_TeamManager.m_PlanActionPoint);
		Sleep(1.00);
	}
DoorsAndLadders:
	m_NextMoveTarget=m_TeamManager.PreviewNextActionPoint();
	if ( (m_TeamManager.m_ePlanAction == 0) && (m_pawn.m_Door != None) && (NextActionPointIsThroughDoor(m_NextMoveTarget) || NextActionPointIsThroughDoor(m_TeamManager.m_PlanActionPoint)) && m_pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed )
	{
		if ( (m_TeamManager.m_PlanActionPoint == m_pawn.m_Door) || (m_NextMoveTarget == m_pawn.m_Door) )
		{
//			R6PreMoveToward(m_pawn.m_Door,m_pawn.m_Door,GetTeamPace());
			MoveToward(m_pawn.m_Door);
			m_TeamManager.ActionPointReached();
		}
		if (  !m_TeamManager.m_bEntryInProgress || (m_TeamManager.m_Door != m_pawn.m_Door) )
		{
			m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
		}
		SetFocusToDoorKnob(m_pawn.m_Door.m_RotatingDoor);
		GotoStateLeadRoomEntry();
	}
	m_TargetLadder=R6Ladder(MoveTarget);
	if ( TargetIsLadderToClimb(m_TargetLadder) )
	{
		MoveTarget=m_pawn.m_Ladder;
		NextState='WaitForTeam';
		m_TeamManager.TeamLeaderIsClimbingLadder();
		GotoState('ApproachLadder');
	}
FormationAroundDoor:
	if ( (m_TeamManager.m_ePlanAction == 0) && (m_TeamManager.m_eGoCode == 4) )
	{
		goto ('PerformPlanningAction');
	}
	if (  !m_TeamManager.m_bEntryInProgress && (m_pawn.m_Door != None) && m_pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed )
	{
		if ( m_pawn.m_Door.m_RotatingDoor.m_bIsDoorLocked )
		{
			GotoLockPickState(m_pawn.m_Door.m_RotatingDoor);
		}
		Sleep(1.00);
		m_NextMoveTarget=m_TeamManager.PreviewNextActionPoint();
		m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
		if ( PreEntryRoomIsAcceptablyLarge() )
		{
			m_vTargetPosition=GetEntryPosition(False);
			if ( m_vTargetPosition != vect(0.00,0.00,0.00) )
			{
//				R6PreMoveTo(m_vTargetPosition,m_pawn.m_Door.m_RotatingDoor.Location,GetTeamPace());
				MoveTo(m_vTargetPosition);
				MoveToPosition(m_vTargetPosition,rotator(m_pawn.m_Door.m_CorrespondingDoor.Location - m_vTargetPosition));
			}
		}
		StopMoving();
		SetFocusToDoorKnob(m_pawn.m_Door.m_RotatingDoor);
		FinishRotation();
	}
PerformPlanningAction:
	if ( ActionIsGrenade(m_TeamManager.m_ePlanAction) )
	{
		if ( m_TeamManager.m_bSkipAction )
		{
			m_TeamManager.ActionNodeCompleted();
			if ( (m_pawn.m_Door != None) && m_pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed && NextActionPointIsThroughDoor(m_TeamManager.m_PlanActionPoint) )
			{
				m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
				SetFocusToDoorKnob(m_pawn.m_Door.m_RotatingDoor);
				GotoStateLeadRoomEntry();
			}
			goto ('PickActionPoint');
		}
		if ( m_iActionUseGadgetGroup == 0 )
		{
			m_TeamManager.ReOrganizeTeamForGrenade(m_TeamManager.m_ePlanAction);
		}
		if ( m_pawn.m_iCurrentWeapon != m_iActionUseGadgetGroup )
		{
			SwitchWeapon(m_iActionUseGadgetGroup);
//			FinishAnim(m_pawn.14);
		}
		m_bIgnoreBackupBump=True;
		m_ActionTarget=m_pawn.m_Door;
		if ( (m_pawn.m_Door != None) && m_pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed )
		{
			m_RotatingDoor=m_pawn.m_Door.m_RotatingDoor;
			SetFocusToDoorKnob(m_RotatingDoor);
			FinishRotation();
			m_pawn.PlayDoorAnim(m_RotatingDoor);
			Sleep(0.50);
//			m_pawn.ServerPerformDoorAction(m_RotatingDoor,m_RotatingDoor.1);
JL0B05:
			if ( m_RotatingDoor.m_bIsDoorClosed )
			{
				if (  !m_RotatingDoor.m_bInProcessOfOpening )
				{
					Sleep(1.00);
					goto ('PerformPlanningAction');
				}
				else
				{
					Sleep(0.10);
				}
//				goto JL0B05;
			}
		}
		if ( m_ActionTarget != None )
		{
			if (  !PreEntryRoomIsAcceptablyLarge() )
			{
//				R6PreMoveToward(m_ActionTarget,m_pawn.m_Door.m_CorrespondingDoor,GetTeamPace());
				MoveToward(m_ActionTarget,m_pawn.m_Door.m_CorrespondingDoor);
				StopMoving();
			}
			if (  !CanThrowGrenadeIntoRoom(m_pawn.m_Door.m_CorrespondingDoor,m_TeamManager.m_vPlanActionLocation) )
			{
				m_TeamManager.ActionNodeCompleted();
				goto ('PostThrowGrenade');
			}
		}
		else
		{
			if (  !ClearThrowIsAvailable(m_TeamManager.m_vPlanActionLocation) )
			{
				m_vTargetPosition=Pawn.Location + 300 * Normal(m_TeamManager.m_vPlanActionLocation - Pawn.Location);
//				R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
				MoveTo(m_vTargetPosition);
				StopMoving();
				Sleep(1.00);
			}
		}
		if ( m_TeamManager.m_vPlanActionLocation != vect(0.00,0.00,0.00) )
		{
			m_vLocationOnTarget=m_TeamManager.m_vPlanActionLocation;
			SetLocation(m_vLocationOnTarget);
		}
		else
		{
			SetLocation(Pawn.Location + 100 * vector(Pawn.Rotation));
		}
		Target=self;
		Focus=self;
		FinishRotation();
		SetRotation(Pawn.Rotation);
		SetGunDirection(Target);
		SetGrenadeParameters((m_ActionTarget != None) && PreEntryRoomIsAcceptablyLarge(),True);
		m_bStateFlag=True;
		m_pawn.PlayWeaponAnimation();
//		FinishAnim(m_pawn.14);
//		m_pawn.m_eRepGrenadeThrow=0;
		ResetGadgetGroup();
		m_TeamManager.ActionNodeCompleted();
		m_bStateFlag=False;
		SetGunDirection(None);
PostThrowGrenade:
		m_bIgnoreBackupBump=False;
		SwitchWeapon(1);
//		FinishAnim(m_pawn.14);
		Sleep(m_pawn.EngineWeapon.GetExplosionDelay());
		if ( (m_pawn.m_Door != None) && (NextActionPointIsThroughDoor(m_TeamManager.m_PlanActionPoint) || (m_TeamManager.m_PlanActionPoint == m_pawn.m_Door) && NextActionPointIsThroughDoor(m_TeamManager.PreviewNextActionPoint())) )
		{
			m_iStateProgress=3;
			GotoState('LeadRoomEntry','EnterRoomBegin');
		}
	}
	else
	{
		if ( MoveTarget == None )
		{
			if ( m_TeamManager.m_eGoCode == 4 )
			{
//				m_TeamManager.SetTeamState(2);
			}
			else
			{
//				m_TeamManager.SetTeamState(1);
			}
			StopMoving();
			Sleep(1.00);
		}
	}
	if ( m_TeamManager.m_bEntryInProgress && (m_TeamManager.m_eGoCode == 4) && (m_TeamManager.m_PlanActionPoint != None) )
	{
		m_TeamManager.RainbowHasLeftDoor(m_pawn);
	}
	if ( m_TeamManager.m_eNextAPAction == 0 )
	{
		m_TeamManager.RestoreTeamOrder();
	}
	goto ('PickActionPoint');
}

function DetonateBreach ()
{
	m_iStateProgress=3;
	GotoState('DetonateBreachingCharge');
}

state PlaceBreachingCharge
{
	function BeginState ()
	{
		m_pawn.m_bAvoidFacingWalls=False;
		Focus=m_TeamManager.m_BreachingDoor;
	}

	function EndState ()
	{
		m_pawn.m_bAvoidFacingWalls=m_pawn.Default.m_bAvoidFacingWalls;
		m_bIgnoreBackupBump=False;
		if ( m_iStateProgress == 3 )
		{
			m_TeamManager.ActionNodeCompleted();
			m_iStateProgress=0;
		}
	}

	function R6Door GetDoorPathNode ()
	{
		local float fDistA;
		local float fDistB;

		fDistA=VSize(m_TeamManager.m_BreachingDoor.m_DoorActorA.Location - Pawn.Location);
		fDistB=VSize(m_TeamManager.m_BreachingDoor.m_DoorActorB.Location - Pawn.Location);
		if ( fDistA < fDistB )
		{
			return m_TeamManager.m_BreachingDoor.m_DoorActorA;
		}
		else
		{
			return m_TeamManager.m_BreachingDoor.m_DoorActorB;
		}
	}

	function DetonateBreach ()
	{
		if ( m_iStateProgress < 1 )
		{
			return;
		}
		Global.DetonateBreach();
	}

Begin:
	if ( m_TeamManager.m_BreachingDoor == None )
	{
		goto ('WaitToDetonate');
	}
	m_ActionTarget=GetDoorPathNode();
	switch (m_iStateProgress)
	{
/*		case 0:
		goto ('GetIntoPosition');
		break;
		case 1:
		goto ('MoveAwayFromDoor');
		break;
		default:
		goto ('WaitToDetonate');   */
	}
GetIntoPosition:
//	m_TeamManager.SetTeamState(3);
//	R6PreMoveToward(m_ActionTarget,m_TeamManager.m_BreachingDoor,GetTeamPace());
	MoveToward(m_ActionTarget,m_TeamManager.m_BreachingDoor);
	ForceCurrentDoor(R6Door(m_ActionTarget));
	StopMoving();
	Focus=m_pawn.m_Door.m_CorrespondingDoor;
	Sleep(0.50);
	if ( DistanceTo(m_ActionTarget) > 30 )
	{
		m_vTargetPosition=Pawn.Location - 60 * vector(Pawn.Rotation);
//		R6PreMoveTo(m_vTargetPosition,m_TeamManager.m_BreachingDoor.Location,4);
		MoveTo(m_vTargetPosition,m_TeamManager.m_BreachingDoor);
		Sleep(0.50);
		goto ('GetIntoPosition');
	}
	m_bIgnoreBackupBump=True;
	m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
//	m_TeamManager.SetTeamState(20);
	SwitchWeapon(m_iActionUseGadgetGroup);
	Sleep(0.20);
//	FinishAnim(m_pawn.14);
	m_pawn.PlayBreachDoorAnimation();
//	FinishAnim(m_pawn.1);
	Pawn.EngineWeapon.NPCPlaceCharge(m_TeamManager.m_BreachingDoor);
	m_iStateProgress=1;
//	PlaySoundCurrentAction(7);
	Sleep(2.50);
	m_bIgnoreBackupBump=False;
MoveAwayFromDoor:
	m_vTargetPosition=GetEntryPosition(False);
	if ( m_vTargetPosition != m_pawn.m_Door.Location )
	{
		if ( m_pawn.bIsCrouched )
		{
//			R6PreMoveTo(m_vTargetPosition,m_pawn.m_Door.m_RotatingDoor.Location,2);
		}
		else
		{
//			R6PreMoveTo(m_vTargetPosition,m_pawn.m_Door.m_RotatingDoor.Location,4);
		}
		MoveTo(m_vTargetPosition);
		MoveToPosition(m_vTargetPosition,rotator(m_pawn.m_Door.m_CorrespondingDoor.Location - m_vTargetPosition));
	}
	else
	{
		m_vTargetPosition=m_pawn.m_Door.Location - 100 * vector(m_pawn.m_Door.Rotation);
		if ( m_pawn.bIsCrouched )
		{
//			R6PreMoveTo(m_vTargetPosition,m_pawn.m_Door.m_RotatingDoor.Location,2);
		}
		else
		{
//			R6PreMoveTo(m_vTargetPosition,m_pawn.m_Door.m_RotatingDoor.Location,4);
		}
		MoveTo(m_vTargetPosition);
	}
	StopMoving();
	SetFocusToDoorKnob(m_pawn.m_Door.m_RotatingDoor);
	FinishRotation();
	if ( m_TeamManager.m_eGoCode == 4 )
	{
		Sleep(1.00);
		DetonateBreach();
	}
	m_TeamManager.PlayWaitingGoCode(m_TeamManager.m_eGoCode);
	m_iStateProgress=2;
WaitToDetonate:
//	m_TeamManager.SetTeamState(1);
	Sleep(0.20);
	goto ('WaitToDetonate');
}

state DetonateBreachingCharge
{
Begin:
	ResetStateProgress();
	if ( (m_TeamManager.m_BreachingDoor == None) ||  !m_TeamManager.m_BreachingDoor.ShouldBeBreached() )
	{
		goto ('End');
	}
JL003F:
	if ( m_TeamManager.m_bTeamIsHoldingPosition )
	{
		Sleep(0.50);
//		goto JL003F;
	}
	Pawn.EngineWeapon.NPCDetonateCharge();
End:
	SwitchWeapon(1);
	Sleep(0.50);
//	FinishAnim(m_pawn.14);
	if ( m_TeamManager.m_PlanActionPoint == m_ActionTarget )
	{
		m_TeamManager.ActionPointReached();
	}
	m_TeamManager.m_BreachingDoor=None;
	ResetGadgetGroup();
	if ( m_TeamManager.m_bTeamIsHoldingPosition )
	{
		GotoState('HoldPosition');
	}
	MoveTarget=m_TeamManager.m_PlanActionPoint;
	if ( NextActionPointIsThroughDoor(MoveTarget) )
	{
		m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
		GotoStateLeadRoomEntry();
	}
	else
	{
		m_TeamManager.EndRoomEntry();
		GotoState('Patrol');
	}
}

function GotoStateLeadRoomEntry ()
{
	ResetStateProgress();
	GotoState('LeadRoomEntry');
}

function ForceCurrentDoor (R6Door aDoor)
{
	if ( aDoor == None )
	{
		return;
	}
	m_pawn.m_Door=aDoor;
	m_pawn.m_potentialActionActor=aDoor.m_RotatingDoor;
}

state LeadRoomEntry
{
	function BeginState ()
	{
		m_pawn.m_bAvoidFacingWalls=False;
		m_bIgnoreBackupBump=True;
		m_bEnteredRoom=False;
		m_bIndividualAttacks=False;
		m_iTurn=0;
		m_bStateFlag=False;
	}

	function EndState ()
	{
		m_pawn.m_bAvoidFacingWalls=m_pawn.Default.m_bAvoidFacingWalls;
		m_bIgnoreBackupBump=False;
		m_pawn.m_u8DesiredYaw=0;
		SetTimer(0.00,False);
		if ( m_iStateProgress == 7 )
		{
			m_iStateProgress=0;
		}
		m_bIndividualAttacks=True;
	}

	function Timer ()
	{
		if ( m_iStateProgress >= 5 )
		{
			m_iTurn++;
			LookAroundRoom(True);
		}
		else
		{
			if ( m_pawn.m_iID == 0 )
			{
				if ( DistanceTo(m_TeamManager.m_PlanActionPoint) < 150 )
				{
					m_TeamManager.ActionPointReached();
				}
			}
		}
	}

	function eMovementPace GetRoomEntryPace (bool bRun)
	{
		local eMovementPace ePace;
		local bool bCrouchedEntry;

		if ( (m_TeamLeader != None) && m_TeamLeader.m_bIsPlayer )
		{
			bCrouchedEntry=False;
		}
		else
		{
			bCrouchedEntry=m_TeamManager.m_eMovementSpeed == 2;
		}
		if ( bCrouchedEntry )
		{
			if ( bRun )
			{
//				ePace=3;
			}
			else
			{
//				ePace=2;
			}
		}
		else
		{
			if ( bRun )
			{
//				ePace=5;
			}
			else
			{
//				ePace=4;
			}
		}
		return ePace;
	}

Begin:
	StopMoving();
	if ( m_TeamManager.m_Door == None )
	{
		m_TeamManager.RainbowHasLeftDoor(m_pawn);
		goto ('Completed');
	}
	if (  !m_TeamManager.m_Door.m_RotatingDoor.m_bIsDoorClosed )
	{
		goto ('EnterRoomBegin');
	}
	switch (m_iStateProgress)
	{
/*		case 0:
		goto ('PrepareForRoomEntry');
		break;
		case 1:
		goto ('OpenDoor');
		break;
		case 2:
		goto ('PreEnterRoom');
		break;
		case 3:
		goto ('EnterRoomBegin');
		break;
		case 4:
		goto ('InsideRoom');
		break;
		case 5:
		goto ('EntryFinished');
		break;
		default:
		goto ('Completed');   */
	}
PrepareForRoomEntry:
	if ( m_TeamManager.m_Door == None )
	{
		goto ('EntryFinished');
	}
	if (  !PreEntryRoomIsAcceptablyLarge() )
	{
//		R6PreMoveToward(m_TeamManager.m_Door,m_TeamManager.m_Door,GetRoomEntryPace(False));
		MoveToward(m_TeamManager.m_Door);
	}
	if ( m_TeamManager.m_Door.m_RotatingDoor.m_bIsDoorLocked )
	{
		GotoLockPickState(m_TeamManager.m_Door.m_RotatingDoor);
	}
	StopMoving();
JL0168:
	if (  !m_TeamManager.LastMemberIsStationary() )
	{
		Sleep(0.50);
//		goto JL0168;
	}
	if ( PreEntryRoomIsAcceptablyLarge() )
	{
		m_vTargetPosition=GetEntryPosition(False);
		if ( (VSize(m_vTargetPosition - Pawn.Location) > 30) && (m_vTargetPosition != vect(0.00,0.00,0.00)) )
		{
//			R6PreMoveTo(m_vTargetPosition,m_TeamManager.m_Door.m_RotatingDoor.Location,GetRoomEntryPace(False));
			MoveTo(m_vTargetPosition);
			MoveToPosition(m_vTargetPosition,rotator(m_TeamManager.m_Door.m_CorrespondingDoor.Location - m_vTargetPosition));
			StopMoving();
		}
	}
	m_iStateProgress=1;
OpenDoor:
	if (  !m_TeamManager.m_bLeaderIsAPlayer )
	{
JL025F:
		if ( m_TeamManager.m_eGoCode != 4 )
		{
//			m_TeamManager.SetTeamState(1);
			if ( NeedToReload() )
			{
				RainbowReloadWeapon();
JL0298:
				if ( m_pawn.m_bReloadingWeapon )
				{
					Sleep(0.20);
//					goto JL0298;
				}
			}
			else
			{
				Sleep(0.50);
			}
//			goto JL025F;
		}
	}
//	m_TeamManager.SetTeamState(9);
	SetFocusToDoorKnob(m_TeamManager.m_Door.m_RotatingDoor);
	Sleep(0.50);
	m_pawn.PlayDoorAnim(m_TeamManager.m_Door.m_RotatingDoor);
	Sleep(0.50);
//	m_pawn.ServerPerformDoorAction(m_TeamManager.m_Door.m_RotatingDoor,m_TeamManager.m_Door.m_RotatingDoor.1);
//	m_iStateProgress=2;
JL0374:
PreEnterRoom:
	if ( m_TeamManager.m_Door.m_RotatingDoor.m_bIsDoorClosed )
	{
		if (  !m_TeamManager.m_Door.m_RotatingDoor.m_bInProcessOfOpening )
		{
			Sleep(1.00);
			goto ('OpenDoor');
		}
		else
		{
			Sleep(0.10);
		}
//		goto JL0374;
	}
	if ( m_TeamManager.m_Door == None )
	{
		m_TeamManager.m_Door=R6Door(m_ActionTarget);
	}
	m_iStateProgress=3;
EnterRoomBegin:
	SetTimer(0.20,True);
//	m_TeamManager.SetTeamState(13);
//	m_eCurrentRoomLayout=m_TeamManager.m_Door.m_eRoomLayout;
	m_vTargetPosition=m_TeamManager.m_Door.Location;
//	R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,GetRoomEntryPace(True));
	MoveToPosition(m_vTargetPosition,m_TeamManager.m_Door.Rotation);
	m_TeamManager.EnteredRoom(m_pawn);
	m_vTargetPosition=m_TeamManager.m_Door.m_CorrespondingDoor.Location;
//	R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,GetRoomEntryPace(True));
	MoveToPosition(m_vTargetPosition,m_TeamManager.m_Door.Rotation);
	m_iStateProgress=4;
InsideRoom:
	if ( m_pawn.m_iID == m_TeamManager.m_iMemberCount - 1 )
	{
		m_iStateProgress=5;
		goto ('EntryFinished');
	}
	if ( PostEntryRoomIsAcceptablyLarge() )
	{
		m_vTargetPosition=GetEntryPosition(True);
		SetLocation(FocalPoint);
//		R6PreMoveTo(m_vTargetPosition,Location,GetRoomEntryPace(True));
		MoveToPosition(m_vTargetPosition,rotator(Location - m_vTargetPosition));
	}
	else
	{
		m_bStateFlag=True;
		if ( (m_pawn.m_iID == 0) && (m_TeamManager.m_PlanActionPoint != None) )
		{
			SetTimer(0.00,False);
			if (  !m_TeamManager.m_Door.m_RotatingDoor.m_bBroken )
			{
JL05EF:
				if ( m_TeamManager.m_Door.m_RotatingDoor.m_bInProcessOfOpening )
				{
					Sleep(0.10);
//					goto JL05EF;
				}
			}
JL061E:
			if ( (m_TeamManager.m_PlanActionPoint != None) && (DistanceTo(m_TeamManager.m_Door) < 400) && ((m_pawn.m_Door == None) ||  !m_pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed) && (m_TeamManager.m_ePlanAction == 0) )
			{
				if (  !actorReachable(m_TeamManager.m_PlanActionPoint) )
				{
//					goto JL0746;
				}
//				R6PreMoveToward(m_TeamManager.m_PlanActionPoint,m_TeamManager.m_PlanActionPoint,GetRoomEntryPace(False));
				MoveToward(m_TeamManager.m_PlanActionPoint);
				if ( DistanceTo(m_TeamManager.m_PlanActionPoint) > 100 )
				{
//					goto JL0746;
				}
				m_TeamManager.ActionPointReached();
				Focus=m_TeamManager.m_PlanActionPoint;
//				goto JL061E;
			}
JL0746:
		}
		else
		{
			FindNearbyWaitSpot(m_TeamManager.m_Door.m_CorrespondingDoor,m_vTargetPosition);
			SetLocation(m_vTargetPosition + 60 * (m_vTargetPosition - Pawn.Location));
//			R6PreMoveTo(m_vTargetPosition,Location,GetRoomEntryPace(True));
			MoveToPosition(m_vTargetPosition,rotator(Location - m_vTargetPosition));
		}
	}
	m_iStateProgress=5;
EntryFinished:
	SetTimer(1.00,True);
	LookAroundRoom(True);
	m_TeamManager.RainbowHasLeftDoor(m_pawn);
	m_iStateProgress=6;
	if ( m_pawn.m_iID == m_TeamManager.m_iMemberCount - 1 )
	{
		Sleep(1.50);
	}
	else
	{
		Sleep(3.00);
	}
Completed:
	m_iStateProgress=7;
	if ( m_pawn.m_iID == 0 )
	{
		if (  !m_bStateFlag )
		{
			m_TeamManager.RestoreTeamOrder();
		}
		GotoState('Patrol');
	}
	else
	{
		if ( m_TeamManager.m_iTeamAction != 0 )
		{
			GotoState(GetNextTeamActionState());
		}
		else
		{
			GotoState('FollowLeader');
		}
	}
}

function name GetNextTeamActionState ()
{
	if ( m_pawn.m_iID > 1 )
	{
		return 'FollowLeader';
	}
	if ( (m_TeamManager.m_iTeamAction & 512) > 0 )
	{
		return 'TeamClimbStartNoLeader';
	}
	if ( (m_TeamManager.m_iTeamAction & 1024) > 0 )
	{
		return 'TeamSecureTerrorist';
	}
	if ( ((m_TeamManager.m_iTeamAction & 4096) > 0) || ((m_TeamManager.m_iTeamAction & 8192) > 0) || ((m_TeamManager.m_iTeamAction & 256) > 0) )
	{
		return 'TeamMoveTo';
	}
	if ( ((m_TeamManager.m_iTeamAction & 16) > 0) || ((m_TeamManager.m_iTeamAction & 32) > 0) || ((m_TeamManager.m_iTeamAction & 128) > 0) || ((m_TeamManager.m_iTeamAction & 64) > 0) )
	{
		return 'PerformAction';
	}
	return 'FollowLeader';
}

function VerifyWeaponInventory ()
{
	local int iWeapon;

	if ( m_pawn.EngineWeapon == Pawn.m_WeaponsCarried[m_pawn.m_iCurrentWeapon - 1] )
	{
		return;
	}
	iWeapon=0;
JL003C:
	if ( iWeapon < 4 )
	{
		if ( m_pawn.EngineWeapon == Pawn.m_WeaponsCarried[iWeapon] )
		{
			m_pawn.m_iCurrentWeapon=iWeapon + 1;
			return;
		}
		iWeapon++;
		goto JL003C;
	}
}

function bool EnsureRainbowIsArmed ()
{
	if ( m_pawn.m_bWeaponIsSecured &&  !m_pawn.m_bWeaponTransition )
	{
//		m_pawn.SetNextPendingAction(PENDING_StopCoughing8);
		m_pawn.PlayWeaponAnimation();
		return True;
	}
	if ( m_pawn.m_iCurrentWeapon > 2 )
	{
		if ( Pawn.m_WeaponsCarried[0].HasAmmo() )
		{
			SwitchWeapon(1);
		}
		else
		{
			SwitchWeapon(2);
		}
		return True;
	}
	else
	{
		if ( m_pawn.m_iCurrentWeapon == 2 )
		{
			if ( (Pawn.m_WeaponsCarried[0].m_eWeaponType != 4) && Pawn.m_WeaponsCarried[0].HasAmmo() )
			{
				SwitchWeapon(1);
				return True;
			}
		}
	}
	return False;
}

function bool SniperChangeToPrimaryWeapon ()
{
	if ( Pawn.m_WeaponsCarried[0] == None )
	{
		return False;
	}
	if ( (Pawn.EngineWeapon != None) &&  !m_pawn.m_bChangingWeapon && (Pawn.EngineWeapon == m_pawn.m_WeaponsCarried[1]) && Pawn.m_WeaponsCarried[0].HasAmmo() && (Pawn.m_WeaponsCarried[0].m_eWeaponType == 4) )
	{
		SwitchWeapon(1);
		return True;
	}
	return False;
}

function bool SniperChangeToSecondaryWeapon ()
{
	if ( (Pawn.EngineWeapon != None) &&  !m_pawn.m_bChangingWeapon && (Pawn.EngineWeapon == m_pawn.m_WeaponsCarried[0]) && Pawn.m_WeaponsCarried[1].HasAmmo() && (Pawn.EngineWeapon.m_eWeaponType == 4) )
	{
		SwitchWeapon(2);
		return True;
	}
	return False;
}

state SnipeUntilGoCode
{
	ignores  AttackTimer;

	function BeginState ()
	{
		m_pawn.m_bIsSniping=True;
		m_pawn.m_bAvoidFacingWalls=False;
		m_bStateFlag=False;
	}

	function EndState ()
	{
		m_bIgnoreBackupBump=False;
		m_pawn.m_bIsSniping=False;
		m_pawn.m_bAvoidFacingWalls=True;
		m_TeamManager.CheckTeamEngagingStatus();
	}

	event SeePlayer (Pawn seen)
	{
		local R6Pawn aPawn;

		if (  !m_bStateFlag )
		{
			Global.SeePlayer(seen);
			return;
		}
		if ( m_pawn.IsEnemy(seen) )
		{
			aPawn=R6Pawn(seen);
			if ( aPawn.m_bIsKneeling ||  !aPawn.IsAlive() || (m_TeamManager == None) || (Enemy != None) )
			{
				return;
			}
			if ( AClearShotIsAvailable(seen,m_pawn.GetFiringStartPoint()) )
			{
				if ( m_TeamManager.m_bSniperHold && (m_TeamManager.m_OtherTeamVoicesMgr != None) )
				{
					m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_pawn,ROTV_SniperHasTarget);
				}
				m_pawn.m_bEngaged=True;
				SetEnemy(seen);
				Target=Enemy;
				Enable('EnemyNotVisible');
			}
		}
	}

	event EnemyNotVisible ()
	{
		if ( Level.TimeSeconds - LastSeenTime < 0.50 )
		{
			return;
		}
		if ( m_TeamManager.m_bSniperHold && (m_TeamManager.m_OtherTeamVoicesMgr != None) )
		{
//			m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_pawn,1);
		}
		StopFiring();
		EndAttack();
		Disable('EnemyNotVisible');
	}

	function bool NoiseSourceIsVisible ()
	{
		if ( VSize(m_vNoiseFocalPoint - Pawn.Location) < 200 )
		{
			return False;
		}
		if ( Normal(m_vNoiseFocalPoint - Pawn.Location) Dot vector(Pawn.Rotation) > 0.30 )
		{
			return True;
		}
		return False;
	}

	event Timer ()
	{
		if ( Enemy != None )
		{
			return;
		}
		if ( m_vNoiseFocalPoint != vect(0.00,0.00,0.00) )
		{
			if ( (m_TeamManager.m_iMemberCount == 1) &&  !NoiseSourceIsVisible() && FastTrace(Pawn.Location,m_vNoiseFocalPoint) )
			{
				GotoState('PauseSniping');
			}
			else
			{
				m_vNoiseFocalPoint=vect(0.00,0.00,0.00);
			}
		}
	}

Begin:
	SetTimer(0.50,True);
	Enemy=None;
	Target=Enemy;
	m_TeamManager.CheckTeamEngagingStatus();
	if ( DistanceTo(m_ActionTarget) > 300 )
	{
		if ( SniperChangeToSecondaryWeapon() )
		{
//			FinishAnim(m_pawn.14);
		}
	}
JL0058:
GetIntoPosition:
	if ( DistanceTo(m_ActionTarget) > 40 )
	{
//		R6PreMoveToward(m_ActionTarget,m_ActionTarget,4);
		MoveToward(m_ActionTarget);
		StopMoving();
//		goto JL0058;
	}
	ChangeOrientationTo(m_TeamManager.m_rSnipingDir);
	FinishRotation();
TakePosition:
	if ( SniperChangeToPrimaryWeapon() )
	{
//		FinishAnim(m_pawn.14);
	}
	if ( Pawn.m_bIsProne )
	{
		m_bIgnoreBackupBump=True;
		goto ('LocateEnemy');
	}
	m_vTargetPosition=Pawn.Location - vect(0.00,0.00,60.00);
	if ( ClearToSnipe(m_vTargetPosition,m_TeamManager.m_rSnipingDir) )
	{
		Pawn.bWantsToCrouch=True;
		Sleep(0.50);
		Pawn.m_bWantsToProne=True;
		Sleep(1.50);
	}
	else
	{
		if ( ClearToSnipe(Pawn.Location,m_TeamManager.m_rSnipingDir) )
		{
			Pawn.bWantsToCrouch=True;
			Sleep(1.00);
		}
		else
		{
			Pawn.bWantsToCrouch=False;
			Pawn.m_bWantsToProne=False;
			Sleep(0.50);
		}
	}
	m_pawn.ResetBoneRotation();
	ChangeOrientationTo(m_TeamManager.m_rSnipingDir);
	m_bIgnoreBackupBump=True;
	m_bStateFlag=True;
	Enemy=None;
	m_TeamManager.PlayWaitingGoCode(m_TeamManager.m_eGoCode,True);
LocateEnemy:
	if (  !m_TeamManager.m_bCAWaitingForZuluGoCode )
	{
//		m_TeamManager.SetTeamState(7);
	}
	if ( Enemy == None )
	{
		ChangeOrientationTo(m_TeamManager.m_rSnipingDir);
		Sleep(0.10);
		goto ('LocateEnemy');
	}
EngageEnemy:
	m_TeamManager.CheckTeamEngagingStatus();
	if (  !m_TeamManager.m_bSniperHold && (Enemy != None) )
	{
//		Pawn.EngineWeapon.SetRateOfFire(0);
		Focus=Enemy;
		Target=Enemy;
		FinishRotation();
JL02C3:
		if (  !IsReadyToFire(Enemy) )
		{
			Sleep(0.20);
//			goto JL02C3;
		}
		m_TeamManager.RainbowIsEngagingEnemy();
		StartFiring();
		Sleep(0.20);
		StopFiring();
	}
	if ( NeedToReload() )
	{
		RainbowReloadWeapon();
	}
	if ( Enemy == None )
	{
		goto ('LocateEnemy');
	}
	if (  !R6Pawn(Enemy).IsAlive() )
	{
		if ( m_TeamManager.m_bSniperHold && (m_TeamManager.m_OtherTeamVoicesMgr != None) )
		{
//			m_TeamManager.m_OtherTeamVoicesMgr.PlayRainbowOtherTeamVoices(m_pawn,1);
		}
		m_TeamManager.DisEngageEnemy(Pawn,Enemy);
		Enemy=None;
		m_pawn.ResetBoneRotation();
		goto ('LocateEnemy');
	}
	Sleep(1.00);
	goto ('EngageEnemy');
EndSniping:
	m_pawn.ResetBoneRotation();
	m_bIgnoreBackupBump=False;
	if ( Pawn.m_bWantsToProne )
	{
		Pawn.m_bWantsToProne=False;
		Sleep(1.00);
	}
	Pawn.bWantsToCrouch=False;
WaitForGoCode:
	Sleep(1.00);
	goto ('WaitForGoCode');
Finish:
	if ( m_pawn.m_iID == 0 )
	{
		GotoState('Patrol');
	}
	else
	{
		GotoState('FollowLeader');
	}
}

state PauseSniping
{
Begin:
	StopMoving();
	m_vTargetPosition=m_vNoiseFocalPoint;
	m_vNoiseFocalPoint=vect(0.00,0.00,0.00);
	if ( Pawn.m_bWantsToProne )
	{
		Pawn.m_bWantsToProne=False;
		Sleep(1.00);
	}
	Pawn.bWantsToCrouch=False;
LookAround:
	SetLocation(m_vTargetPosition);
	Focus=self;
	FinishRotation();
Wait:
	Sleep(2.50);
	if ( Enemy != None )
	{
		goto ('Wait');
	}
	GotoState('SnipeUntilGoCode');
}

function CheckNeedToClimbLadder ()
{
	if ( (m_pawn.m_iID == 1) && m_TeamManager.m_bTeamIsSeparatedFromLeader )
	{
		return;
	}
	if ( m_pawn.m_iID == 0 )
	{
		return;
	}
	if ( m_TargetLadder == None )
	{
		return;
	}
	if ( PawnIsOnTheSameEndOfLadderAsMember(m_PaceMember,R6LadderVolume(m_TargetLadder.MyLadder)) )
	{
		m_TeamManager.MemberFinishedClimbingLadder(m_pawn);
	}
}

function bool PawnIsOnTheSameEndOfLadderAsMember (R6Rainbow aRainbow, R6LadderVolume LadderVolume)
{
	local bool bPaceMemberIsAtTopOfLadder;

	if ( LadderVolume == None )
	{
		return True;
	}
	bPaceMemberIsAtTopOfLadder=aRainbow.Location.Z > LadderVolume.Location.Z;
/*	if ( bPaceMemberIsAtTopOfLadder == m_pawn.Location.Z > LadderVolume.Location.Z )
	{
		return True;
	}
	else
	{
		return False;
	}  */
}

state TeamClimbStartNoLeader
{
	function BeginState ()
	{
		m_pawn.m_bAvoidFacingWalls=False;
		m_pawn.m_bCanProne=False;
	}

	function EndState ()
	{
		m_pawn.m_bCanProne=m_pawn.Default.m_bCanProne;
	}

Begin:
//	m_TeamManager.SetTeamState(3);
	MoveTarget=m_TeamManager.m_TeamLadder;
	if ( (MoveTarget == None) ||  !MoveTarget.IsA('R6Ladder') )
	{
		GotoState('HoldPosition');
	}
	m_TargetLadder=R6Ladder(MoveTarget);
	if (  !CanWalkTo(m_TargetLadder.Location) && !actorReachable(m_TargetLadder) )
	{
		FindPathToTargetLocation(m_TargetLadder.Location,m_TargetLadder);
	}
	if ( m_TargetLadder.m_bIsTopOfLadder )
	{
		m_vTargetPosition=m_TargetLadder.Location + 70 * vector(m_TargetLadder.Rotation);
//		R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
		MoveTo(m_vTargetPosition);
	}
	else
	{
		MoveTarget=m_TargetLadder;
//		R6PreMoveToward(MoveTarget,MoveTarget,4);
		MoveToward(MoveTarget);
	}
JL011D:
	if ( m_TeamManager.m_bCAWaitingForZuluGoCode )
	{
//		m_TeamManager.SetTeamState(1);
		Sleep(0.50);
//		goto JL011D;
	}
	MoveTarget=m_TargetLadder;
WaitAtEndForLeader:
//	m_TeamManager.SetTeamState(18);
	NextState='TeamClimbEndNoLeader';
	GotoState('ApproachLadder');
}

state TeamClimbEndNoLeader
{
Begin:
	if ( m_pawn.m_iID == 1 )
	{
		Sleep(GetLeadershipReactionTime());
	}
PickDest:
	FindNearbyWaitSpot(m_pawn.m_Ladder,m_vTargetPosition);
	if ( m_vTargetPosition == vect(0.00,0.00,0.00) )
	{
		goto ('WaitAtEndForTeam');
	}
	else
	{
//		R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
		MoveTo(m_vTargetPosition);
	}
	StopMoving();
WaitAtEndForTeam:
	m_pawn.m_Ladder=None;
	Sleep(1.00);
	NextState='None';
	if (  !m_TeamManager.m_bTeamIsClimbingLadder )
	{
		if ( m_TeamManager.m_iTeamAction != 0 )
		{
			GotoState(GetNextTeamActionState());
		}
		else
		{
			if ( m_TeamManager.m_bTeamIsRegrouping )
			{
				GotoState('FollowLeader');
			}
			else
			{
				GotoState('HoldPosition');
			}
		}
	}
	else
	{
		goto ('WaitAtEndForTeam');
	}
}

state TeamClimbLadder
{
	function BeginState ()
	{
		m_pawn.m_bAvoidFacingWalls=False;
		m_pawn.ResetBoneRotation();
		m_pawn.m_bCanProne=False;
	}

	function EndState ()
	{
		if ( m_iStateProgress == 5 )
		{
			m_iStateProgress=0;
		}
		m_pawn.ResetBoneRotation();
		m_pawn.m_bCanProne=m_pawn.Default.m_bCanProne;
	}

	function SetPawnFocus ()
	{
		local int iMember;
		local Rotator rOffset;

		if ( m_TeamManager.m_bTeamIsSeparatedFromLeader )
		{
			iMember=m_pawn.m_iID - 1;
		}
		else
		{
			iMember=m_pawn.m_iID;
		}
		switch (iMember)
		{
/*			case 1:
			if ( m_pawn.m_Ladder.m_bIsTopOfLadder )
			{
				m_pawn.AimDown();
			}
			else
			{
				m_pawn.AimUp();
			}
			Focus=m_pawn.m_Ladder;
			break;
			case 2:
			SetLocation(m_vTargetPosition + 100 * (m_vTargetPosition - m_pawn.m_Ladder.Location));
			Focus=self;
			break;
			case 3:
			rOffset=rotator(m_vTargetPosition - m_pawn.m_Ladder.Location);
			rOffset += rot(0,8192,0);
			SetLocation(m_vTargetPosition + 100 * rOffset);
			Focus=self;
			break;
			default:
			SetLocation(m_pawn.m_Ladder.Location);  */
		}
	}

	function bool LeadHasStartedClimbing ()
	{
		if ( m_TeamManager.m_bTeamIsSeparatedFromLeader )
		{
			return m_TeamManager.m_Team[1].m_bIsClimbingLadder;
		}
		else
		{
			return m_TeamLeader.m_bIsClimbingLadder;
		}
	}

	function bool NeedToFollowTeam ()
	{
		local R6Rainbow aRainbow;

		if ( m_TeamManager.m_bTeamIsSeparatedFromLeader )
		{
			aRainbow=m_TeamManager.m_Team[1];
		}
		else
		{
			aRainbow=m_TeamLeader;
		}
		if ( (m_TeamManager.m_TeamLadder != None) &&  !PawnIsOnTheSameEndOfLadderAsMember(aRainbow,R6LadderVolume(m_TeamManager.m_TeamLadder.MyLadder)) )
		{
			return False;
		}
		return IsMoving(aRainbow) &&  !aRainbow.m_bIsClimbingLadder;
	}

	function R6Ladder GetLadderMoveTarget ()
	{
		if ( Pawn.Location.Z > m_TeamManager.m_TeamLadder.MyLadder.Location.Z )
		{
			return R6LadderVolume(m_TeamManager.m_TeamLadder.MyLadder).m_TopLadder;
		}
		else
		{
			return R6LadderVolume(m_TeamManager.m_TeamLadder.MyLadder).m_BottomLadder;
		}
	}

Begin:
	switch (m_iStateProgress)
	{
/*		case 0:
		goto ('FollowTeam');
		break;
		case 1:
		goto ('WaitForLeadToStartClimbing');
		break;
		case 2:
		goto ('FormationAroundLadder');
		break;
		case 3:
		goto ('WaitForTurnToClimb');
		break;
		default:
		goto ('ClimbLadder');  */
	}
FollowTeam:
	if ( DistanceTo(m_PaceMember) > GetFormationDistance() + 35 )
	{
		m_vTargetPosition=m_PaceMember.Location + GetFormationDistance() * Normal(Pawn.Location - m_PaceMember.Location);
		if (  !actorReachable(m_PaceMember) )
		{
			FindPathToTargetLocation(m_PaceMember.Location,m_PaceMember);
		}
//		R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
		MoveTo(m_vTargetPosition);
	}
	else
	{
		Sleep(0.50);
	}
	StopMoving();
	if ( NeedToFollowTeam() )
	{
		goto ('FollowTeam');
	}
	m_iStateProgress=1;
WaitForLeadToStartClimbing:
	if ( Abs(m_PaceMember.Location.Z - Pawn.Location.Z) < 80 )
	{
		m_iStateProgress=2;
		goto ('FormationAroundLadder');
	}
	if (  !LeadHasStartedClimbing() )
	{
		Sleep(1.00);
		goto ('WaitForLeadToStartClimbing');
	}
	m_iStateProgress=2;
FormationAroundLadder:
	if ( m_pawn.m_Ladder.m_bSingleFileFormationOnly )
	{
		StopMoving();
		goto ('WaitForTurnToClimb');
	}
	if (  !m_TeamManager.m_bTeamIsSeparatedFromLeader )
	{
		if ( m_pawn.m_Ladder == None )
		{
			m_pawn.m_Ladder=m_TeamLeader.m_Ladder;
		}
	}
	if ( m_pawn.m_Ladder != None )
	{
		m_vTargetPosition=GetLadderPosition();
		if ( pointReachable(m_vTargetPosition) )
		{
//			R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,4);
			MoveTo(m_vTargetPosition);
			StopMoving();
		}
	}
	SetPawnFocus();
	m_iStateProgress=3;
WaitForTurnToClimb:
	if ( (Abs(m_PaceMember.Location.Z - Pawn.Location.Z) < 80) || m_PaceMember.m_bIsClimbingLadder )
	{
		Sleep(1.00);
		goto ('WaitForTurnToClimb');
	}
	m_iStateProgress=4;
ClimbLadder:
	Sleep(0.50);
	m_pawn.ResetBoneRotation();
	MoveTarget=GetLadderMoveTarget();
	if (  !CanWalkTo(MoveTarget.Location) && !actorReachable(MoveTarget) )
	{
		FindPathToTargetLocation(MoveTarget.Location,MoveTarget);
	}
//	R6PreMoveToward(MoveTarget,MoveTarget,4);
	MoveToward(MoveTarget);
	m_iStateProgress=5;
	if ( MoveTarget.IsA('R6Ladder') )
	{
		NextState='FollowLeader';
		NextLabel='Begin';
		GotoState('ApproachLadder');
	}
}

function float GetFormationDistance ()
{
	if ( m_PaceMember != None )
	{
		if ( m_PaceMember.m_bIsProne || (m_PaceMember.Controller != None) && m_PaceMember.Controller.IsInState('SnipeUntilGoCode') )
		{
			return m_TeamManager.m_iFormationDistance * 2;
		}
	}
	return m_TeamManager.m_iFormationDistance;
}

function bool IsBumpBackUpStateFinish ()
{
	local R6Pawn aBumpPawn;

	if ( m_fLastBump + 4.00 < Level.TimeSeconds )
	{
		return True;
	}
	aBumpPawn=R6Pawn(m_BumpedBy);
	Focus=None;
	if ( m_TeamLeader == None )
	{
		return (DistanceTo(m_BumpedBy) > c_iDistanceBumpBackUp + 60) ||  !IsMoving(aBumpPawn);
	}
	else
	{
		return (DistanceTo(m_BumpedBy) > c_iDistanceBumpBackUp + 60) || (DistanceTo(m_PaceMember) > c_iDistanceBumpBackUp + 60) && IsMoving(m_PaceMember) &&  !m_PaceMember.IsInState('BumpBackUp');
	}
}

function BumpBackUpStateFinished ()
{
	GotoState('HoldPosition');
}

function bool IsMoving (Pawn P)
{
	if ( (P == None) || (P.Velocity == vect(0.00,0.00,0.00)) )
	{
		return False;
	}
	else
	{
		return True;
	}
}

function SetNoiseFocus (Vector vSource)
{
	m_vNoiseFocalPoint=vSource;
	if ( m_bReactToNoise )
	{
		SetLocation(m_vNoiseFocalPoint);
		Focus=self;
	}
}

function ResetNoiseFocus ()
{
	m_vNoiseFocalPoint=vect(0.00,0.00,0.00);
}

function bool NeedToReload ()
{
	local float fCutOff;

	if ( m_pawn.m_iCurrentWeapon > 2 )
	{
		return False;
	}
	if ( m_TeamManager.m_eGoCode == 4 )
	{
		fCutOff=0.50;
	}
	else
	{
		fCutOff=0.75;
	}
	if ( (Pawn.EngineWeapon == None) || m_bWeaponsDry || m_pawn.m_bChangingWeapon || m_pawn.m_bReloadingWeapon )
	{
		return False;
	}
	if ( Pawn.EngineWeapon.NumberOfBulletsLeftInClip() == 0 )
	{
		if ( (Enemy == None) && Pawn.EngineWeapon.IsPumpShotGun() )
		{
			m_pawn.m_bReloadToFullAmmo=True;
		}
		return True;
	}
	if ( Enemy != None )
	{
		return False;
	}
	if ( Pawn.EngineWeapon.NumberOfBulletsLeftInClip() <= fCutOff * Pawn.EngineWeapon.GetClipCapacity() )
	{
		if ( Pawn.EngineWeapon.IsPumpShotGun() && (Pawn.EngineWeapon.GetNbOfClips() > 0) )
		{
			m_pawn.m_bReloadToFullAmmo=True;
			return True;
		}
		if ( Pawn.EngineWeapon.HasAtLeastOneFullClip() )
		{
			return True;
		}
	}
	return False;
}

function RainbowReloadWeapon ()
{
	if ( m_bWeaponsDry )
	{
		return;
	}
	if ( m_pawn.m_bReloadingWeapon )
	{
		return;
	}
	if ( Pawn.EngineWeapon.GetNbOfClips() > 0 )
	{
		if ( Enemy != None )
		{
			StopFiring();
			EndAttack();
		}
		m_pawn.m_u8DesiredYaw=0;
		m_pawn.m_u8DesiredPitch=0;
		m_pawn.m_ePlayerIsUsingHands=HANDS_None;
		m_pawn.ServerSwitchReloadingWeapon(True);
		m_pawn.ReloadWeapon();
	}
	else
	{
		if ( (m_pawn.m_iCurrentWeapon == 1) && Pawn.m_WeaponsCarried[1].HasAmmo() )
		{
			SwitchWeapon(2);
		}
		else
		{
			if ( (m_pawn.m_iCurrentWeapon == 2) && Pawn.m_WeaponsCarried[0].HasAmmo() )
			{
				SwitchWeapon(1);
			}
			else
			{
				if (  !m_bWeaponsDry )
				{
					m_bWeaponsDry=True;
					if ( m_TeamManager.m_bLeaderIsAPlayer || m_TeamManager.m_bPlayerHasFocus )
					{
//						m_TeamManager.m_MemberVoicesMgr.PlayRainbowMemberVoices(m_pawn,14);
					}
				}
			}
		}
	}
}

function eMovementPace GetPace (bool bRun)
{
	if ( m_PaceMember.m_bIsProne &&  !m_PaceMember.m_bIsSniping )
	{
		return PACE_Prone;
	}
	else
	{
		if ( m_PaceMember.bIsCrouched )
		{
			if ( bRun )
			{
				return PACE_CrouchRun;
			}
			else
			{
				return PACE_CrouchWalk;
			}
		}
		else
		{
			if ( bRun )
			{
				return PACE_Run;
			}
			else
			{
				return PACE_Walk;
			}
		}
	}
}

function SetRainbowOrientation ()
{
	if ( m_ePawnOrientation != 5 )
	{
		SetOrientation();
	}
	else
	{
		if ( m_bIsMovingBackwards )
		{
			SetOrientation();
		}
		else
		{
			SetOrientation(PO_Front);
		}
	}
}

function ReorganizeTeamAsNeeded ()
{
	if ( m_pawn.m_eHealth != 1 )
	{
		m_bReorganizationPending=False;
		return;
	}
	m_TeamManager.ReOrganizeWoundedMembers();
}

state FollowLeader
{
	function BeginState ()
	{
		m_iWaitCounter=0;
		m_bIsMovingBackwards=False;
//		m_ePawnOrientation=0;
		m_bAlreadyWaiting=False;
		m_vPreviousPosition=vect(0.00,0.00,0.00);
		m_bIgnoreBackupBump=False;
		m_iStateProgress=0;
		m_bReactToNoise=True;
		m_pawn.m_bAvoidFacingWalls=m_pawn.Default.m_bAvoidFacingWalls;
	}

	function EndState ()
	{
		m_bIgnoreBackupBump=False;
		m_bReactToNoise=False;
		if (  !m_TeamManager.m_bGrenadeInProximity )
		{
			SetTimer(0.00,False);
		}
		m_pawn.StopPeeking();
		m_pawn.m_u8DesiredYaw=0;
		if (  !m_TeamManager.m_bLeaderIsAPlayer && m_TeamManager.m_bTeamIsRegrouping && (m_PaceMember == m_TeamLeader) )
		{
			m_TeamManager.TeamIsRegroupingOnLead(False);
		}
	}

	function Timer ()
	{
		m_iWaitCounter++;
		m_iTurn++;
		if ( m_iTurn == 6 )
		{
			m_iTurn=0;
		}
		if ( ((m_pawn.m_iID == 1) || (m_pawn.m_iID == 2)) && IsMoving(Pawn) && (m_ePawnOrientation != 5) )
		{
			CheckEnvironment();
		}
		if ( m_bIsCatchingUp )
		{
			m_pawn.ResetBoneRotation();
		}
		else
		{
			SetRainbowOrientation();
		}
	}

	function bool RainbowShouldWait ()
	{
		local float fDistance;

		if (  !m_bSlowedPace && IsMoving(m_PaceMember) &&  !Pawn.m_bIsProne &&  !Pawn.bIsCrouched )
		{
			return False;
		}
		if ( m_vTargetPosition == m_vPreviousPosition )
		{
			return True;
		}
		fDistance=GetFormationDistance();
		if ( m_bSlowedPace )
		{
			fDistance *= 2;
		}
		if ( m_pawn.m_bIsProne )
		{
			fDistance += 60;
		}
		else
		{
			if (  !m_pawn.m_bIsClimbingStairs )
			{
				fDistance += 35;
			}
		}
		if ( DistanceTo(m_PaceMember,True) < fDistance )
		{
			return True;
		}
		return False;
	}

	function Vector GetNextTargetPosition ()
	{
		local Vector vDir;
		local Rotator rDir;
		local Rotator rOffset;

		if ( m_PaceMember == None )
		{
			return Pawn.Location;
		}
		if ( m_bUseStaggeredFormation && (m_TeamManager.m_eFormation == m_eFormation) && (m_ePawnOrientation != 5) &&  !Pawn.m_bIsProne &&  !m_bSlowedPace )
		{
			rDir=rotator(m_PaceMember.Location - Pawn.Location);
			rOffset=rot(0,2000,0);
			if ( (m_eFormation == 4) || (m_eFormation == 2) )
			{
				if ( m_pawn.m_iID == 1 )
				{
					rDir += rOffset;
				}
				else
				{
					rDir -= rOffset;
				}
				return m_PaceMember.Location - GetFormationDistance() * vector(rDir);
			}
			if ( m_eFormation == 3 )
			{
				if ( m_pawn.m_iID == 1 )
				{
					rDir -= rOffset;
				}
				else
				{
					rDir += rOffset;
				}
				return m_PaceMember.Location - GetFormationDistance() * vector(rDir);
			}
		}
		return m_PaceMember.Location + GetFormationDistance() * Normal(Pawn.Location - m_PaceMember.Location);
	}

	function EngageLadderIfNeeded (R6LadderVolume aVolume)
	{
		if ( m_TargetLadder == None )
		{
			return;
		}
		if (  !PawnIsOnTheSameEndOfLadderAsMember(m_PaceMember,aVolume) )
		{
			m_TeamManager.InstructTeamToClimbLadder(aVolume,True,m_pawn.m_iID);
		}
	}

Begin:
	if ( m_PaceMember == None )
	{
		if ( (m_TeamLeader != None) && (m_TeamManager != None) )
		{
			m_PaceMember=m_TeamManager.m_Team[m_pawn.m_iID - 1];
		}
	}
	m_TeamManager.SetFormation(self);
	SetTimer(1.00,True);
	VerifyWeaponInventory();
	EnsureRainbowIsArmed();
	if (  !m_pawn.IsStationary() && SniperChangeToSecondaryWeapon() )
	{
		Sleep(0.50);
	}
Moving:
	if ( NeedToReload() )
	{
		RainbowReloadWeapon();
	}
	if ( m_bIsCatchingUp )
	{
		m_bIsCatchingUp=False;
	}
	if ( (m_PaceMember == m_TeamLeader) && m_TeamLeader.m_bIsPlayer )
	{
//		m_TeamManager.SetTeamState(4);
	}
	if ( m_bReorganizationPending )
	{
		ReorganizeTeamAsNeeded();
	}
	m_vTargetPosition=GetNextTargetPosition();
	if ( RainbowShouldWait() )
	{
		Pawn.Acceleration=vect(0.00,0.00,0.00);
		if (  !m_bAlreadyWaiting )
		{
			m_iWaitCounter=0;
			m_pawn.ResetBoneRotation();
			m_pawn.StopPeeking();
			EnsureRainbowIsArmed();
			if ( (m_ePawnOrientation == 5) &&  !m_bIsMovingBackwards &&  !Pawn.m_bIsProne )
			{
				Sleep(0.20);
				m_bIsMovingBackwards=True;
				SetLocation(Pawn.Location - 2 * (m_PaceMember.Location - Pawn.Location));
				Focus=self;
			}
			m_bAlreadyWaiting=True;
		}
		if ( VSize(m_TeamLeader.Velocity) == 0 )
		{
			if ( (m_iWaitCounter > 6) &&  !m_TeamManager.m_bTeamIsClimbingLadder )
			{
				if ( SniperChangeToPrimaryWeapon() )
				{
//					FinishAnim(m_pawn.14);
				}
				if (  !Pawn.bIsCrouched &&  !Pawn.m_bIsProne )
				{
					m_pawn.StopPeeking();
					Pawn.bWantsToCrouch=True;
					Sleep(0.20);
				}
			}
		}
		Sleep(0.20);
		goto ('Moving');
	}
	m_vPreviousPosition=m_vTargetPosition;
	if ( m_bAlreadyWaiting )
	{
		m_pawn.StopPeeking();
		Sleep(0.20);
		if ( SniperChangeToSecondaryWeapon() )
		{
			Sleep(0.50);
		}
	}
	m_bAlreadyWaiting=False;
	if (  !CanWalkTo(m_vTargetPosition) && !pointReachable(m_vTargetPosition) )
	{
		goto ('bLocked');
	}
	if ( m_PaceMember == m_TeamLeader )
	{
		m_TeamManager.TeamIsSeparatedFromLead(False);
		m_TeamManager.TeamIsRegroupingOnLead(False);
	}
	if ( (m_ePawnOrientation != 5) || Pawn.m_bIsProne || m_PaceMember.m_bIsProne )
	{
		m_bIsMovingBackwards=False;
//		R6PreMoveTo(m_vTargetPosition,m_vTargetPosition);
		SetLocation(m_vTargetPosition);
	}
	else
	{
		if ( m_PaceMember.IsWalking() && (m_iTurn > 2) && (DistanceTo(m_PaceMember) < GetFormationDistance() + 120) )
		{
			m_bIsMovingBackwards=True;
			SetLocation(Pawn.Location - 2 * (m_PaceMember.Location - Pawn.Location));
//			R6PreMoveTo(m_vTargetPosition,Location,GetPace(True));
		}
		else
		{
			m_bIsMovingBackwards=False;
			SetLocation(m_vTargetPosition);
			if ( m_PaceMember.bIsCrouched && (DistanceTo(m_PaceMember) > GetFormationDistance() + 40) )
			{
//				R6PreMoveTo(m_vTargetPosition,m_vTargetPosition,3);
			}
			else
			{
//				R6PreMoveTo(m_vTargetPosition,m_vTargetPosition);
			}
		}
	}
	if ( PostureHasChanged() )
	{
		Sleep(0.50);
JL0496:
		if ( m_pawn.m_bPostureTransition )
		{
			Sleep(0.50);
//			goto JL0496;
		}
	}
	MoveTo(m_vTargetPosition,self);
	if ( m_eMoveToResult == 2 )
	{
		goto ('bLocked');
	}
	else
	{
		goto ('Moving');
	}
bLocked:
	m_bIsCatchingUp=True;
	if ( m_PaceMember == m_TeamLeader )
	{
		m_TeamManager.TeamIsRegroupingOnLead(True);
JL0502:
		if ( DistanceTo(m_TeamManager.m_Team[m_TeamManager.m_iMemberCount - 1]) > 600 )
		{
			Sleep(0.50);
//			goto JL0502;
		}
	}
	m_pawn.StopPeeking();
//	m_ePawnOrientation=0;
	if ( NeedToReload() )
	{
		RainbowReloadWeapon();
	}
	MoveTarget=FindPathToward(m_PaceMember,True);
	if ( MoveTarget == None )
	{
		m_pawn.logWarning("is at location " $ string(Pawn.Location) $ " and there appear to be insufficient pathnodes...");
		MoveTo(Pawn.Location + Normal(m_PaceMember.Location - Pawn.Location) * 100);
		Sleep(1.00);
		goto ('bLocked');
	}
	if ( MoveTarget == m_PaceMember )
	{
JL063C:
		if ( m_PaceMember.m_bIsClimbingLadder )
		{
			Sleep(1.00);
//			goto JL063C;
		}
		EngageLadderIfNeeded(R6LadderVolume(m_TargetLadder.MyLadder));
	}
	m_TargetLadder=R6Ladder(MoveTarget);
	if ( TargetIsLadderToClimb(m_TargetLadder) )
	{
		m_pawn.m_potentialActionActor=m_TargetLadder.MyLadder;
		m_TeamManager.InstructTeamToClimbLadder(R6LadderVolume(m_TargetLadder.MyLadder),True,m_pawn.m_iID);
	}
	else
	{
		if ( NeedToOpenDoor(MoveTarget) )
		{
			m_TeamManager.RainbowIsInFrontOfAClosedDoor(m_pawn,m_pawn.m_Door);
			MoveToPosition(m_pawn.m_Door.Location,m_pawn.m_Door.Rotation);
			Pawn.Acceleration=vect(0.00,0.00,0.00);
			SetFocusToDoorKnob(m_pawn.m_Door.m_RotatingDoor);
			Sleep(1.00);
			GotoStateLeadRoomEntry();
		}
	}
	if ( m_PaceMember.bIsCrouched )
	{
//		R6PreMoveToward(MoveTarget,MoveTarget,3);
	}
	else
	{
//		R6PreMoveToward(MoveTarget,MoveTarget,5);
	}
	if ( MoveTarget.IsA('R6Ladder') )
	{
		Pawn.bIsWalking=True;
	}
	MoveToward(MoveTarget);
	if (  !CanWalkTo(m_PaceMember.Location) && !actorReachable(m_PaceMember) )
	{
		goto ('bLocked');
	}
	else
	{
		goto ('Moving');
	}
}

function Promote ()
{
	m_TeamLeader=m_TeamManager.m_TeamLeader;
	m_pawn.m_iID--;
	if ( m_TeamLeader == Pawn )
	{
		m_pawn.ResetBoneRotation();
		m_TeamLeader=None;
		if ( m_pawn.m_bIsClimbingLadder )
		{
			return;
		}
		if ( m_TeamManager.m_bTeamIsHoldingPosition )
		{
			GotoState('HoldPosition');
		}
		else
		{
			GotoState('Patrol');
		}
	}
	else
	{
		if (  !m_pawn.m_bIsClimbingLadder &&  !IsInState('RoomEntry') )
		{
			if ( m_TeamManager.m_bTeamIsHoldingPosition )
			{
				GotoState('HoldPosition');
			}
			else
			{
				GotoState('FollowLeader');
			}
		}
	}
}

function Tick (float fDeltaTime)
{
	local Vector vDirection;
	local Rotator rDirection;

	Super.Tick(fDeltaTime);
	if ( Pawn == None )
	{
		return;
	}
	if ( Enemy != None )
	{
		SetGunDirection(Enemy);
	}
	else
	{
		if ( m_bAimingWeaponAtEnemy && (m_pawn.m_fFiringTimer == 0) )
		{
			SetGunDirection(None);
		}
	}
	if ( (m_TeamLeader != None) && (m_TeamManager != None) && (m_pawn.m_iID != 0) )
	{
		m_PaceMember=m_TeamManager.m_Team[m_pawn.m_iID - 1];
	}
}

auto state WaitForGameToStart
{
Begin:
	Sleep(0.50);
	if ( Level.Game.m_bGameStarted && (NextState != 'None') )
	{
		if ( m_pawn.m_iID == 0 )
		{
			Sleep(1.00);
		}
		GotoState(NextState);
	}
	else
	{
		goto ('Begin');
	}
}

state TestBoneRotation
{
Begin:
	Sleep(3.00);
	goto ('Begin');
}

state WatchPlayer
{
	function BeginState ()
	{
		Focus=None;
	}

	function EndState ()
	{
		m_pawn.R6ResetLookDirection();
		Enable('SeePlayer');
	}

Begin:
	m_pawn.R6LoopAnim('StandSubGunHigh_nt');
Wait:
	Sleep(1.00);
	goto ('Wait');
}

defaultproperties
{
    m_bUseStaggeredFormation=True
    m_bIndividualAttacks=True
    m_fAttackTimerRate=0.50
    m_fFiringAttackTimer=0.20
    bIsPlayer=True
}
