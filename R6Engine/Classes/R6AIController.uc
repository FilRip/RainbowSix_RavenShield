//================================================================================
// R6AIController.
//================================================================================
class R6AIController extends AIController
	Native
	Abstract;

enum eMovementPace {
	PACE_None,
	PACE_Prone,
	PACE_CrouchWalk,
	PACE_CrouchRun,
	PACE_Walk,
	PACE_Run
};

var const int c_iDistanceBumpBackUp;
var int m_iCurrentRouteCache;
var bool m_bStateBackupAvoidFacingWalls;
var bool m_bIgnoreBackupBump;
var bool m_bGetOffLadder;
var(Debug) bool bShowLog;
var(Debug) bool bShowInteractionLog;
var bool m_bChangingState;
var bool m_bCantInterruptIO;
var bool m_bMoveTargetAlreadySet;
var float m_fLastBump;
var float m_fLoopAnimTime;
const C_fMaxBumpTime= 1.f;
var R6Pawn m_r6pawn;
var R6Ladder m_TargetLadder;
var Actor m_BumpedBy;
var R6ClimbableObject m_climbingObject;
var R6InteractiveObject m_InteractionObject;
var Actor m_ActorTarget;
var R6IORotatingDoor m_closeDoor;
var name m_bumpBackUpNextState;
var name m_openDoorNextState;
var name m_climbingObjectNextState;
var name m_AnimName;
var name m_StateAfterInteraction;
var Vector m_vTargetPosition;
var Vector m_vPreviousPosition;
var Vector m_vBumpedByLocation;
var Vector m_vBumpedByVelocity;

native(1810) final function bool MakePathToRun ();

native(1811) final function R6ActionSpot FindPlaceToTakeCover (Vector vThreatLocation, float fMaxDistance);

native(1817) final function R6ActionSpot FindPlaceToFire (Actor PTarget, Vector vDestination, float fMaxDistance);

native(1818) final function R6ActionSpot FindInvestigationPoint (int iSearchIndex, float fMaxDistance, optional bool bFromThreat, optional Vector vThreatLocation);

native(1813) final function bool PickActorAdjust (Actor pActor);

native(2201) final function MoveToPosition (Vector VPosition, Rotator rOrientation);

native(1812) final function FollowPath (optional eMovementPace ePace, optional name returnLabel, optional bool bContinuePath);

native(1814) final function FollowPathTo (Vector vDestination, optional eMovementPace ePace, optional Actor aTarget);

native(1815) final function bool CanWalkTo (Vector vDestination, optional bool bDebug);

native(1816) final function Rotator FindGrenadeDirectionToHitActor (Actor aTarget, Vector vTargetLoc, float fGrenadeSpeed);

native(1509) final function bool NeedToOpenDoor (Actor Target);

native(1510) final function GotoOpenDoorState (R6Door navPointToOpenFrom);

native(2209) final function FindNearbyWaitSpot (Actor Node, out Vector vWaitLocation);

native(2220) final function bool ActorReachableFromLocation (Actor Target, Vector vLocation);

function Possess (Pawn aPawn)
{
	Super.Possess(aPawn);
	m_r6pawn=R6Pawn(aPawn);
	m_r6pawn.SetFriendlyFire();
}

function Tick (float fDeltaTime)
{
	Super.Tick(fDeltaTime);
	if ( Pawn != None )
	{
		Pawn.m_bIsFiringWeapon=bFire;
		if ( m_r6pawn.m_TrackActor != None )
		{
			if ( IsActorInView(m_r6pawn.m_TrackActor) )
			{
//				m_r6pawn.UpdatePawnTrackActor();
			}
			else
			{
				m_r6pawn.TurnToFaceActor(m_r6pawn.m_TrackActor);
			}
		}
	}
}

function bool IsActorInView (Actor Actor)
{
	if ( (Actor.Location - Pawn.Location) Dot vector(Pawn.Rotation) < 0 )
	{
		return False;
	}
	else
	{
		return True;
	}
}

function bool IsActorRightOfView (Actor Actor)
{
	if ( (Actor.Location - Pawn.Location) Dot vector(Pawn.Rotation) < 0 )
	{
		return False;
	}
	else
	{
		return True;
	}
}

event R6SetMovement (eMovementPace ePace)
{
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
	if ( (ePace == 4) || (ePace == 2) || (ePace == 1) )
	{
		if (  !Pawn.bIsWalking )
		{
			Pawn.SetWalking(True);
		}
	}
	else
	{
		if ( (ePace == 5) || (ePace == 3) )
		{
			if ( Pawn.bIsWalking )
			{
				Pawn.SetWalking(False);
			}
		}
	}
//	m_r6pawn.m_eMovementPace=ePace;
}

function CheckPaceForInjury (out eMovementPace ePace)
{
	if ( m_r6pawn.m_eHealth == 1 )
	{
		if ( ePace == 3 )
		{
//			ePace=2;
		}
		else
		{
			if ( ePace == 5 )
			{
//				ePace=4;
			}
		}
	}
}

function R6PreMoveTo (Vector vTargetPosition, Vector vFocus, eMovementPace ePace)
{
	CheckPaceForInjury(ePace);
	R6SetMovement(ePace);
	Focus=None;
	FocalPoint=vFocus;
	Destination=vTargetPosition;
}

function R6PreMoveToward (Actor Target, Actor pFocus, eMovementPace ePace)
{
	CheckPaceForInjury(ePace);
	R6SetMovement(ePace);
	Focus=None;
	FocalPoint=pFocus.Location;
	Destination=Target.Location;
}

function int GetFacingDirection ()
{
	local float fStrafeMag;
	local Vector vFocus2D;
	local Vector vLoc2D;
	local Vector vDest2D;
	local Vector vDir;
	local Vector vLookDir;
	local Vector vY;

	if ( FocalPoint == Destination )
	{
		return 0;
	}
	vFocus2D=FocalPoint;
	vFocus2D.Z=0.00;
	vLoc2D=Pawn.Location;
	vLoc2D.Z=0.00;
	vDest2D=Destination;
	vDest2D.Z=0.00;
	vLookDir=Normal(vFocus2D - vLoc2D);
	vDir=Normal(vDest2D - vLoc2D);
	fStrafeMag=vLookDir Dot vDir;
	if ( fStrafeMag < 0.75 )
	{
		if ( fStrafeMag < -0.75 )
		{
			return 32768;
		}
		else
		{
			vY=vLookDir Cross vect(0.00,0.00,1.00);
			if ( vY Dot (vDest2D - vLoc2D) > 0 )
			{
				return 49152;
			}
			else
			{
				return 16384;
			}
		}
	}
	return 0;
}

function bool CanClimbLadders (R6Ladder Ladder)
{
	return m_r6pawn.m_bAutoClimbLadders;
}

function bool CanClimbObject ()
{
	return m_r6pawn.m_bCanClimbObject;
}

function CheckNeedToClimbLadder ();

state WaitToClimbLadder
{
	function BeginState ()
	{
	}

	function EndState ()
	{
	}

	function Vector GetWaitPosition ()
	{
		if ( m_TargetLadder.m_bIsTopOfLadder )
		{
			return m_TargetLadder.Location + 200 * vector(m_TargetLadder.Rotation + rot(0,8192,0));
		}
		else
		{
			return m_TargetLadder.Location - 200 * vector(m_TargetLadder.Rotation + rot(0,8192,0));
		}
	}

Begin:
	Destination=GetWaitPosition();
//	R6PreMoveTo(Destination,m_TargetLadder.Location,4);
	MoveTo(Destination,m_TargetLadder);
	StopMoving();
Wait:
	Sleep(1.00);
	if ( LadderIsAvailable() )
	{
		MoveTarget=m_TargetLadder;
		Sleep(2.00);
		GotoState('ApproachLadder');
	}
	else
	{
		goto ('Wait');
	}
}

function ConfirmLadderActionPointWasReached (R6Ladder Ladder);

function bool LadderIsAvailable ()
{
	local R6LadderVolume ladderVol;

	ladderVol=R6LadderVolume(m_TargetLadder.MyLadder);
	if (  !ladderVol.IsAvailable(Pawn) )
	{
		return False;
	}
	if ( m_TargetLadder.m_bIsTopOfLadder && ladderVol.IsAShortLadder() &&  !ladderVol.SpaceIsAvailableAtBottomOfLadder(True) )
	{
		return False;
	}
	return True;
}

state ApproachLadder
{
	function BeginState ()
	{
		m_TargetLadder=R6Ladder(MoveTarget);
		m_bStateBackupAvoidFacingWalls=m_r6pawn.m_bAvoidFacingWalls;
		m_r6pawn.m_bAvoidFacingWalls=False;
		Pawn.m_bCanProne=False;
	}

	function EndState ()
	{
		Pawn.m_bCanProne=True;
		if ( Pawn.Physics != 11 )
		{
			R6LadderVolume(m_TargetLadder.MyLadder).RemoveClimber(m_r6pawn);
		}
	}

	function bool ReadyToClimbLadder ()
	{
		local R6RainbowAI rainbowAI;

		rainbowAI=R6RainbowAI(m_r6pawn.Controller);
		rainbowAI.m_TeamManager.SetTeamIsClimbingLadder(True);
		if ( ((rainbowAI.m_TeamManager.m_iTeamAction & 512) > 0) && rainbowAI.m_TeamManager.m_bCAWaitingForZuluGoCode )
		{
			return False;
		}
		return True;
	}

Begin:
	Pawn.SetBoneRotation('R6 Spine1',rot(0,0,0),,1.00);
	if ( m_TargetLadder == None )
	{
		GotoState('Dispatcher');
	}
	if (  !LadderIsAvailable() )
	{
		GotoState('WaitToClimbLadder');
	}
	R6LadderVolume(m_TargetLadder.MyLadder).AddClimber(m_r6pawn);
MoveToStartOfLadder:
	CheckNeedToClimbLadder();
//	R6PreMoveToward(m_TargetLadder,m_TargetLadder,4);
	MoveToward(m_TargetLadder);
	if ( DistanceTo(m_TargetLadder) >= 40 )
	{
		StopMoving();
		Sleep(1.00);
		goto ('MoveToStartOfLadder');
	}
	ConfirmLadderActionPointWasReached(m_TargetLadder);
WaitForZuluGoCode:
	if ( m_r6pawn.m_ePawnType == 1 )
	{
		if (  !ReadyToClimbLadder() )
		{
			Sleep(0.50);
			goto ('WaitForZuluGoCode');
		}
	}
Wait:
	Sleep(0.50);
	if (  !m_TargetLadder.m_bIsTopOfLadder )
	{
		Destination=m_TargetLadder.Location;
		Destination.Z=Pawn.Location.Z;
		MoveToPosition(Destination,m_TargetLadder.Rotation);
	}
	else
	{
		Destination=m_TargetLadder.Location + 50 * vector(m_TargetLadder.Rotation);
		Destination.Z=Pawn.Location.Z;
		MoveToPosition(Destination,m_TargetLadder.Rotation + rot(0,32768,0));
	}
	if ( VSize(Pawn.Location - Destination) >= 10 )
	{
		Sleep(1.00);
		goto ('Wait');
	}
	if ( (m_r6pawn.m_potentialActionActor == None) ||  !m_r6pawn.m_potentialActionActor.IsA('R6LadderVolume') )
	{
		MoveTarget=m_TargetLadder;
		goto ('Wait');
	}
	if (  !m_r6pawn.m_bIsClimbingLadder )
	{
		if (  !R6LadderVolume(m_TargetLadder.MyLadder).IsAvailable(Pawn) )
		{
			GotoState('WaitToClimbLadder');
		}
		m_r6pawn.ClimbLadder(LadderVolume(m_r6pawn.m_potentialActionActor));
	}
}

function bool AreClimbingInSameDirection (R6Pawn npcPawn, R6Pawn PlayerPawn)
{
	if ( PlayerPawn.Velocity.Z != 0.00 )
	{
		if ( npcPawn.IsMovingUpLadder() == PlayerPawn.IsMovingUpLadder() )
		{
			return True;
		}
	}
	return False;
}

state BeginClimbingLadder
{
	function BeginState ()
	{
		Pawn.m_bCanProne=False;
		Disable('NotifyBump');
	}

	function EndState ()
	{
		Pawn.m_bCanProne=True;
		m_bMoveTargetAlreadySet=False;
		Pawn.LadderSpeed=Pawn.Default.LadderSpeed;
	}

	event bool NotifyBump (Actor Other)
	{
		local R6Pawn bumpingPawn;

		if (  !Other.IsA('R6Pawn') )
		{
			return False;
		}
		m_BumpedBy=Other;
		bumpingPawn=R6Pawn(Other);
		if ( bumpingPawn.m_bIsClimbingLadder &&  !AreClimbingInSameDirection(m_r6pawn,bumpingPawn) )
		{
			if (  !bumpingPawn.m_bIsPlayer )
			{
				if ( R6AIController(bumpingPawn.Controller).DistanceTo(bumpingPawn.m_Ladder) < DistanceTo(m_r6pawn.m_Ladder) )
				{
					return False;
				}
			}
			Pawn.LadderSpeed=200.00;
			if ( Pawn.Velocity.Z > 0 )
			{
				MoveTarget=R6LadderVolume(Pawn.OnLadder).m_BottomLadder;
			}
			else
			{
				MoveTarget=R6LadderVolume(Pawn.OnLadder).m_TopLadder;
			}
			Pawn.bIsWalking=False;
			m_bGetOffLadder=True;
			return True;
		}
		if (  !bumpingPawn.m_bIsClimbingLadder )
		{
			GotoState('BeginClimbingLadder','BlockedAtTop');
			return True;
		}
	}

Begin:
	if ( Pawn.bIsCrouched )
	{
		Pawn.bWantsToCrouch=False;
	}
	Sleep(0.50);
	if ( Pawn.m_ePawnType == 1 )
	{
//		m_r6pawn.SetNextPendingAction(PENDING_StopCoughing7);
//		FinishAnim(m_r6pawn.14);
		if (  !LadderIsAvailable() )
		{
			m_r6pawn.m_bIsClimbingLadder=False;
			R6LadderVolume(m_TargetLadder.MyLadder).RemoveClimber(m_r6pawn);
			Pawn.SetPhysics(PHYS_Walking);
//			m_r6pawn.SetNextPendingAction(PENDING_StopCoughing8);
			GotoState('WaitToClimbLadder');
		}
	}
	m_r6pawn.m_bIsClimbingLadder=True;
	Pawn.LockRootMotion(1,True);
//	m_r6pawn.SetNextPendingAction(PENDING_StartClimbingLadder);
WaitForStartClimbingAnimToEnd:
	FinishAnim();
StartLadder:
//	m_r6pawn.SetNextPendingAction(PENDING_PostStartClimbingLadder);
//	FinishAnim(m_r6pawn.1);
	Pawn.SetRotation(Pawn.OnLadder.LadderList.Rotation);
	SetRotation(Pawn.OnLadder.LadderList.Rotation);
	Focus=None;
	if ( m_bMoveTargetAlreadySet && (MoveTarget != None) )
	{
		goto ('MoveTowardEndOfLadder');
	}
	if ( m_r6pawn.m_Ladder.m_bIsTopOfLadder )
	{
		Pawn.SetLocation(Pawn.Location + 15 * vector(Pawn.Rotation));
		m_TargetLadder=R6LadderVolume(Pawn.OnLadder).m_BottomLadder;
	}
	else
	{
		if ( m_r6pawn.m_ePawnType != 3 )
		{
			Pawn.SetLocation(Pawn.Location - 20 * vector(Pawn.Rotation));
		}
		m_TargetLadder=R6LadderVolume(Pawn.OnLadder).m_TopLadder;
	}
	MoveTarget=m_TargetLadder;
MoveTowardEndOfLadder:
	Enable('NotifyBump');
	Pawn.Anchor=NavigationPoint(MoveTarget);
	if ( (m_r6pawn.m_ePawnType == 1) && (m_r6pawn.m_eHealth == 0) )
	{
		Pawn.bIsWalking=False;
	}
	MoveToward(MoveTarget);
	if ( m_r6pawn.m_ePawnType == 1 )
	{
		Pawn.bIsWalking=True;
	}
	Sleep(2.00);
	goto ('MoveTowardEndOfLadder');
BlockedAtTop:
	StopMoving();
	Sleep(1.50);
	MoveTarget=m_TargetLadder;
	goto ('MoveTowardEndOfLadder');
}

state EndClimbingLadder
{
	function BeginState ()
	{
		Pawn.Acceleration=vect(0.00,0.00,0.00);
		Disable('NotifyBump');
	}

	function EndState ()
	{
		Pawn.OnLadder=None;
		m_r6pawn.m_bIsClimbingLadder=False;
		Pawn.bCollideWorld=True;
		m_r6pawn.m_bAvoidFacingWalls=m_bStateBackupAvoidFacingWalls;
	}

	function bool NotifyHitWall (Vector HitNormal, Actor Wall)
	{
		return True;
	}

	function ClimbLadderIsOver ()
	{
		local int i;

		m_r6pawn.m_Ladder=None;
		Pawn.OnLadder=None;
	JL0020:
		if ( i < 16 )
		{
			RouteCache[i]=None;
			++i;
			goto JL0020;
		}
	}

Begin:
	if (  !m_r6pawn.m_bIsClimbingLadder )
	{
		goto ('End');
	}
	if ( m_r6pawn.m_Ladder.m_bIsTopOfLadder || Pawn.bIsWalking || (m_r6pawn.m_ePawnType != 1) )
	{
		Pawn.LockRootMotion(1,True);
	}
//	m_r6pawn.SetNextPendingAction(PENDING_EndClimbingLadder);
WaitForEndClimbingAnimToEnd:
	FinishAnim(0);
	m_r6pawn.m_bSlideEnd=False;
	ConfirmLadderActionPointWasReached(m_r6pawn.m_Ladder);
EndClimb:
	m_r6pawn.m_ePlayerIsUsingHands=HANDS_Both;
	Pawn.SetPhysics(PHYS_Walking);
	m_TargetLadder=m_r6pawn.m_Ladder;
	if ( m_r6pawn.m_Ladder.m_bIsTopOfLadder )
	{
//		m_r6pawn.SetNextPendingAction(PENDING_PostEndClimbingLadder);
//		FinishAnim(m_r6pawn.1);
	}
	else
	{
		if ( Pawn.bIsWalking || (m_r6pawn.m_ePawnType != 1) )
		{
//			m_r6pawn.SetNextPendingAction(PENDING_PostEndClimbingLadder);
//			FinishAnim(m_r6pawn.1);
		}
	}
	Focus=Pawn.OnLadder;
	FocalPoint=Pawn.OnLadder.Location;
	MoveTarget=None;
	m_r6pawn.m_bIsClimbingLadder=False;
	if ( Pawn.m_ePawnType == 1 )
	{
//		m_r6pawn.SetNextPendingAction(PENDING_StopCoughing8);
	}
	Enable('NotifyBump');
End:
	if ( m_r6pawn.m_Ladder.m_bIsTopOfLadder )
	{
		Destination=Pawn.Location + 120 * Pawn.OnLadder.LookDir;
//		R6PreMoveTo(Destination,Destination,4);
		MoveTo(Destination);
	}
	else
	{
		Destination=Pawn.Location - 120 * Pawn.OnLadder.LookDir;
//		R6PreMoveTo(Destination,Pawn.OnLadder.Location,4);
		MoveTo(Destination,Pawn.OnLadder);
	}
	StopMoving();
	if ( m_r6pawn.m_ePawnType == 1 )
	{
		if (  !m_bGetOffLadder )
		{
			R6RainbowAI(Pawn.Controller).m_TeamManager.MemberFinishedClimbingLadder(m_r6pawn);
		}
	}
	else
	{
		if ( m_r6pawn.m_ePawnType == 3 )
		{
			ClimbLadderIsOver();
		}
	}
	if ( m_bGetOffLadder )
	{
		m_bGetOffLadder=False;
		GotoState('WaitToClimbLadder');
	}
	else
	{
		if ( NextState != 'None' )
		{
			GotoState(NextState,NextLabel);
		}
		else
		{
			GotoState('Dispatcher');
		}
	}
}

state Dispatcher
{
	function BeginState ()
	{
	}

Begin:
	Sleep(3.00);
	if ( NextState != 'None' )
	{
		GotoState(NextState);
	}
	goto ('Begin');
}

state Dead
{
	ignores  R6DamageAttitudeTo;

	function BeginState ()
	{
		StopMoving();
		SetLocation(Pawn.Location);
	}

}

function PawnDied ()
{
	GotoState('Dead');
}

function StopMoving ()
{
	if ( Pawn == None )
	{
		return;
	}
	Pawn.Acceleration=vect(0.00,0.00,0.00);
	Pawn.Velocity=vect(0.00,0.00,0.00);
	MoveTarget=None;
	Pawn.SetWalking(True);
}

event bool NotifyBump (Actor Other)
{
	if (  !Other.IsA('R6Pawn') )
	{
		return False;
	}
	if ( m_r6pawn.IsStationary() ||  !m_r6pawn.HasBumpPriority(R6Pawn(Other)) )
	{
		if (  !m_bIgnoreBackupBump &&  !IsInState('ApproachLadder') )
		{
			StopMoving();
			m_BumpedBy=Other;
			if ( GetStateName() != 'BumpBackUp' )
			{
				GotoBumpBackUpState(GetStateName());
			}
			else
			{
				GotoBumpBackUpState(m_bumpBackUpNextState);
			}
			return True;
		}
		else
		{
			return False;
		}
	}
	else
	{
		return PickActorAdjust(Other);
	}
}

function bool IsInCrouchedPosture ()
{
	return Pawn.bIsCrouched;
}

function GotoBumpBackUpState (name returnState)
{
	if ( returnState == 'BumpBackUp' )
	{
		return;
	}
	m_bumpBackUpNextState=returnState;
	GotoState('BumpBackUp');
}

function bool IsBumpBackUpStateFinish ()
{
	if ( m_fLastBump + 1.00 < Level.TimeSeconds )
	{
		return True;
	}
	return DistanceTo(m_BumpedBy) >= c_iDistanceBumpBackUp;
}

function BumpBackUpStateFinished ()
{
	Log("ScriptWarning: BumpBackUpStateFinished was not inherited");
}

function float DistanceTo (Actor member, optional bool bIncludeZ)
{
	local Vector vDistance;

	if ( member == None )
	{
		return 0.00;
	}
	vDistance=Pawn.Location - member.Location;
	if (  !bIncludeZ )
	{
		vDistance.Z=0.00;
	}
	return VSize(vDistance);
}

state BumpBackUp
{
	function BeginState ()
	{
	}

	function EndState ()
	{
		StopMoving();
	}

	function bool MoveRight ()
	{
		local Vector vProduct;

		m_vBumpedByLocation=m_BumpedBy.Location;
		m_vBumpedByLocation.Z=Pawn.Location.Z;
		vProduct=Normal(m_BumpedBy.Velocity) Cross Normal(Pawn.Location - m_vBumpedByLocation);
		if ( vProduct.Z > 0 )
		{
			return True;
		}
		return False;
	}

	event bool NotifyBump (Actor Other)
	{
		if ( (Other == m_BumpedBy) || (R6Pawn(Other) != None) && R6Pawn(Other).m_bIsPlayer )
		{
			m_BumpedBy=Other;
			GotoState('BumpBackUp');
			return True;
		}
		return False;
	}

	function bool GetReacheablePoint (out Vector vTarget, bool bNoFail)
	{
		local Rotator rRotation;
		local int iYawIncrement;
		local int iStartingYaw;
		local int iTry;
		local int iTryMax;
		local int iTryOnAQuadrantMax;
		local Vector vDest;

		if ( m_r6pawn.m_ePawnType == 3 )
		{
			iTryMax=7;
		}
		else
		{
			iTryMax=1;
		}
		iStartingYaw=16384;
		iYawIncrement=16384 / 3;
		iTryOnAQuadrantMax=16384 / iYawIncrement + 1;
		if (  !MoveRight() )
		{
			iStartingYaw *= -1;
			iYawIncrement *= -1;
		}
	JL0081:
		if ( iTry < iTryMax )
		{
			if ( iTry < iTryOnAQuadrantMax )
			{
				rRotation.Yaw=iStartingYaw + iYawIncrement * iTry;
			}
			else
			{
				rRotation.Yaw=iStartingYaw + iYawIncrement * (iTry + 1 - iTryOnAQuadrantMax) * -1;
			}
//			vDest=Pawn.Location + c_iDistanceBumpBackUp * (rotator(m_vBumpedByVelocity) + vector(rRotation));
			if ( CanWalkTo(vDest) || bNoFail )
			{
				vTarget=vDest;
				return True;
			}
			++iTry;
			goto JL0081;
		}
		return False;
	}

Begin:
	if ( m_BumpedBy.IsA('R6IORotatingDoor') )
	{
		Disable('NotifyBump');
		goto ('BackupFromDoor');
	}
	else
	{
		if (  !m_BumpedBy.IsA('R6Pawn') )
		{
			Disable('NotifyBump');
			goto ('BackupFromActor');
		}
	}
	m_vBumpedByLocation=m_BumpedBy.Location;
	m_vBumpedByLocation.Z=Pawn.Location.Z;
	m_vBumpedByVelocity=m_BumpedBy.Velocity;
	m_vBumpedByVelocity.Z=Pawn.Velocity.Z;
	if (  !GetReacheablePoint(m_vTargetPosition,False) )
	{
		GetReacheablePoint(m_vTargetPosition,True);
	}
	if ( Pawn.m_bIsProne )
	{
//		R6PreMoveTo(m_vTargetPosition,m_BumpedBy.Location,1);
	}
	else
	{
		if ( m_r6pawn.m_ePawnType == 3 )
		{
			if ( IsInCrouchedPosture() )
			{
//				R6PreMoveTo(m_vTargetPosition,m_BumpedBy.Location,2);
			}
			else
			{
//				R6PreMoveTo(m_vTargetPosition,m_BumpedBy.Location,4);
			}
		}
		else
		{
			if ( (m_r6pawn.m_ePawnType != 1) && IsInCrouchedPosture() )
			{
//				R6PreMoveTo(m_vTargetPosition,m_BumpedBy.Location,3);
			}
			else
			{
				if ( m_r6pawn.m_ePawnType == 1 )
				{
//					R6PreMoveTo(m_vTargetPosition,m_BumpedBy.Location,5);
				}
				else
				{
//					R6PreMoveTo(m_vTargetPosition,m_BumpedBy.Location,4);
				}
			}
		}
	}
	MoveTo(m_vTargetPosition,m_BumpedBy);
	Pawn.Acceleration=vect(0.00,0.00,0.00);
	m_fLastBump=Level.TimeSeconds;
Wait:
	Sleep(0.20);
	if ( IsBumpBackUpStateFinish() )
	{
		goto ('Finish');
	}
	else
	{
		goto ('Wait');
	}
Finish:
	if ( m_bumpBackUpNextState != 'None' )
	{
		if ( m_bumpBackUpNextState == 'ApproachLadder' )
		{
			MoveTarget=m_TargetLadder;
		}
		GotoState(m_bumpBackUpNextState);
	}
	else
	{
		BumpBackUpStateFinished();
	}
BackupFromDoor:
	m_r6pawn.m_bAvoidFacingWalls=False;
	SetLocation(Pawn.Location);
	m_vTargetPosition=R6IORotatingDoor(m_BumpedBy).GetTarget(Pawn,225.00,True);
//	R6PreMoveTo(m_vTargetPosition,Location,m_r6pawn.m_eMovementPace);
	MoveTo(m_vTargetPosition,self);
	Pawn.Acceleration=vect(0.00,0.00,0.00);
	if ( m_bumpBackUpNextState == 'OpenDoor' )
	{
		Sleep(0.20);
	}
	else
	{
		Sleep(1.00);
	}
	goto ('Finish');
BackupFromActor:
	m_r6pawn.m_bAvoidFacingWalls=False;
	SetLocation(Pawn.Location);
	m_vTargetPosition=Pawn.Location - 120 * Normal(m_BumpedBy.Location - Pawn.Location);
	m_vTargetPosition.Z=Pawn.Location.Z;
//	R6PreMoveTo(m_vTargetPosition,Location,m_r6pawn.m_eMovementPace);
	MoveTo(m_vTargetPosition,self);
	Pawn.Acceleration=vect(0.00,0.00,0.00);
	Sleep(1.00);
	goto ('Finish');
}

event bool CanOpenDoor (R6IORotatingDoor Door)
{
	return True;
}

event OpenDoorFailed ()
{
	m_r6pawn.logWarning("should be overwritted. ie: gotostate('doSomethingIfDoorIsLocked')");
}

state OpenDoor
{
	function BeginState ()
	{
	}

	function EndState ()
	{
	}

	function bool NeedToMove (out Vector vDest)
	{
		local Vector vDoorLoc;
		local Vector vSpotToGo;

		if ( m_r6pawn.m_Door == None )
		{
			return False;
		}
		vDoorLoc=m_r6pawn.m_Door.m_RotatingDoor.GetTarget(Pawn,0.00,True);
		vSpotToGo=m_r6pawn.m_Door.m_RotatingDoor.GetTarget(Pawn,75.00,True);
		vDest=vSpotToGo;
		return True;
	}

	function int GetFurthestOffsetFromDoor (Actor Actor)
	{
		return 128 + Actor.CollisionRadius + 10;
	}

Begin:
	if ( m_r6pawn.m_Door == None )
	{
		goto ('End');
	}
	if ( (m_r6pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed == False) || m_r6pawn.m_Door.m_RotatingDoor.m_bInProcessOfOpening )
	{
		goto ('End');
	}
	if ( NeedToMove(m_vTargetPosition) )
	{
		SetLocation(Pawn.Location);
//		R6PreMoveTo(m_vTargetPosition,Location,m_r6pawn.m_eMovementPace);
		MoveToPosition(m_vTargetPosition,m_r6pawn.m_Door.Rotation);
	}
	ChangeOrientationTo(m_r6pawn.m_Door.Rotation);
	FinishRotation();
	if ( (m_r6pawn.m_Door.m_RotatingDoor.m_bIsDoorClosed == False) || m_r6pawn.m_Door.m_RotatingDoor.m_bInProcessOfOpening )
	{
		goto ('End');
	}
	if ( m_r6pawn.m_Door.m_RotatingDoor.m_bIsDoorLocked )
	{
//		m_r6pawn.SetNextPendingAction(PENDING_OpenDoor,1);
//		FinishAnim(m_r6pawn.16);
	}
//	m_r6pawn.SetNextPendingAction(PENDING_OpenDoor,0);
	Sleep(0.50);
	if ( m_r6pawn.m_Door == None )
	{
		goto ('CloseDoor');
	}
	if (  !m_r6pawn.m_Door.m_RotatingDoor.ActorIsOnSideA(Pawn) )
	{
		m_vTargetPosition=m_r6pawn.m_Door.m_RotatingDoor.GetTarget(Pawn,GetFurthestOffsetFromDoor(Pawn),True);
		SetLocation(Pawn.Location);
//		R6PreMoveTo(m_vTargetPosition,Location,m_r6pawn.m_eMovementPace);
		m_r6pawn.m_Door.m_RotatingDoor.OpenDoor(m_r6pawn,10000);
		MoveToPosition(m_vTargetPosition,m_r6pawn.m_Door.Rotation);
	}
	else
	{
		m_r6pawn.m_Door.m_RotatingDoor.OpenDoor(m_r6pawn);
	}
	if ( m_r6pawn.m_Door.m_RotatingDoor.ActorIsOnSideA(Pawn) )
	{
		if ( (m_r6pawn.m_ePawnType == 3) && (m_r6pawn.m_eMovementPace == 5) )
		{
			Sleep(0.50);
		}
		else
		{
			Sleep(0.30);
		}
	}
	else
	{
		if ( (m_r6pawn.m_ePawnType == 3) && (m_r6pawn.m_eMovementPace == 5) )
		{
			Sleep(1.50);
		}
		else
		{
			Sleep(1.00);
		}
	}
	if ( m_r6pawn.m_Door != None )
	{
		m_closeDoor=m_r6pawn.m_Door.m_RotatingDoor;
		m_r6pawn.RemovePotentialOpenDoor(m_r6pawn.m_Door);
	}
CloseDoor:
	if ( (m_closeDoor != None) && (m_r6pawn.m_ePawnType == 2) && (R6Terrorist(m_r6pawn).m_eDefCon != 1) && ( !m_closeDoor.m_bIsDoorClosed || m_closeDoor.m_bInProcessOfOpening) )
	{
		if (  !m_closeDoor.ActorIsOnSideA(Pawn) )
		{
			m_vTargetPosition=m_closeDoor.GetTarget(Pawn,0.00);
		}
		else
		{
			m_vTargetPosition=m_closeDoor.GetTarget(Pawn,GetFurthestOffsetFromDoor(Pawn));
		}
		SetLocation(Pawn.Location);
//		R6PreMoveTo(m_vTargetPosition,Location,m_r6pawn.m_eMovementPace);
		MoveToPosition(m_vTargetPosition,m_r6pawn.Rotation);
		m_closeDoor.CloseDoor(m_r6pawn);
	}
	m_closeDoor=None;
End:
	GotoState(m_openDoorNextState);
}

function SetStateTestMakePath (Pawn anEnemy, eMovementPace ePace)
{
	Enemy=anEnemy;
//	m_r6pawn.m_eMovementPace=ePace;
	LastSeenTime=Level.TimeSeconds;
	GotoState('TestMakePath');
}

state TestMakePathEnd
{
	function BeginState ()
	{
		logX("begin: TestMakePathEnd");
		StopMoving();
		Enemy=None;
	}

}

state TestMakePath
{
	function BeginState ()
	{
		logX("begin. Eneny =" @ string(Enemy.Name));
	}

	function EnemyNotVisible ()
	{
		if ( Level.TimeSeconds - LastSeenTime > 20 )
		{
			logX("Not seen for at least 20 seconds. GotoState('')");
			GotoState('TestMakePathEnd');
		}
	}

ChooseDestination:
Begin:
	if (  !MakePathToRun() )
	{
		logX("Nowhere to run..., gotostate '' ");
		GotoState('TestMakePathEnd');
	}
RunToDestination:
	logX("label RunToDestination.  Goal = " $ string(RouteGoal));
//	FollowPath(m_r6pawn.m_eMovementPace,'ReturnToPath',False);
	goto ('ChooseDestination');
ReturnToPath:
//	FollowPath(m_r6pawn.m_eMovementPace,'ReturnToPath',True);
	goto ('ChooseDestination');
}

function float GetCurrentChanceToHit (Actor aTarget)
{
	local float fAngle;
	local float fDistance;
	local float fError;

	if ( Pawn.EngineWeapon == None )
	{
		return 0.00;
	}
	fAngle=Pawn.EngineWeapon.GetCurrentMaxAngle() * 0.02;
	fAngle=Tan(fAngle);
	fDistance=VSize(Pawn.Location - aTarget.Location);
	fError=fAngle * fDistance;
	return aTarget.CollisionRadius / fError;
}

function bool IsReadyToFire (Actor aTarget)
{
	local float fNeededChanceToHit;
	local float fSelfControl;

	if ( Pawn.EngineWeapon.IsAtBestAccuracy() )
	{
		return True;
	}
	fSelfControl=m_r6pawn.GetSkill(SKILL_SelfControl);
	fNeededChanceToHit=fSelfControl * fSelfControl;
	if ( fNeededChanceToHit > 1.00 )
	{
		fNeededChanceToHit=1.00;
	}
	return GetCurrentChanceToHit(aTarget) > fNeededChanceToHit;
}

function bool IsFocusLeft ()
{
	local int iLeft;
	local int iRight;
	local Rotator rFocus;

	if ( Focus == None )
	{
		return True;
	}
	rFocus=rotator(Focus.Location - Pawn.Location);
	iLeft=Clamp(rFocus.Yaw - Pawn.Rotation.Yaw,0,65535);
	iRight=Clamp(rFocus.Yaw + Pawn.Rotation.Yaw,0,65535);
	return iLeft < iRight;
}

function ChangeOrientationTo (Rotator NewRotation)
{
	Focus=None;
	FocalPoint=Pawn.Location + vector(NewRotation) * 50;
	Pawn.DesiredRotation=NewRotation;
}

function Rotator ChooseRandomDirection (int iLookBackChance)
{
	local bool bLookBack;
	local bool bTurnLeft;
	local int ITemp;
	local Rotator rRot;

	bLookBack=Rand(100) + 1 < iLookBackChance;
	bTurnLeft=Rand(2) == 1;
	if ( bLookBack )
	{
		ITemp=Rand(16383) + 16383;
	}
	else
	{
		ITemp=Rand(8192) + 8192;
	}
	rRot=Pawn.Rotation;
	if ( bTurnLeft )
	{
		rRot.Yaw -= ITemp;
	}
	else
	{
		rRot.Yaw += ITemp;
	}
	return rRot;
}

function bool FindBestPathToward (Actor desired, bool bClearPaths)
{
	local Actor Path;
	local bool bSuccess;

	Path=FindPathToward(desired,bClearPaths);
	bSuccess=Path != None;
	if ( bSuccess )
	{
		MoveTarget=Path;
		Destination=Path.Location;
	}
	return bSuccess;
}

function bool IsFacing (Actor aGrenade)
{
	local Vector vDir;

	vDir=aGrenade.Location - Pawn.Location;
	if ( Normal(vDir) Dot vector(Pawn.Rotation) > 0 )
	{
		return True;
	}
	return False;
}

function AIAffectedByGrenade (Actor aGrenade, EGrenadeType eType)
{
}

function Rotator GetGrenadeDirection (Actor aTarget, optional Vector vTargetLoc)
{
	local Rotator rFiringRotation;

	rFiringRotation=FindGrenadeDirectionToHitActor(aTarget,vTargetLoc,Pawn.EngineWeapon.GetMuzzleVelocity());
	return rFiringRotation;
}

function bool CanInteractWithObjects (R6InteractiveObject o)
{
	return False;
}

function PerformAction_StartInteraction ()
{
	m_StateAfterInteraction=GetStateName();
	m_InteractionObject.m_SeePlayerPawn=None;
	m_InteractionObject.m_HearNoiseNoiseMaker=None;
	m_InteractionObject.m_bPawnDied=False;
	m_bChangingState=True;
	GotoState('PA_StartInteraction');
}

function PerformAction_LookAt (Actor Target)
{
	m_ActorTarget=Target;
	m_bChangingState=True;
	GotoState('PA_LookAt');
}

function PerformAction_Goto (Actor Target)
{
	m_ActorTarget=Target;
	m_bChangingState=True;
	GotoState('PA_Goto');
}

function PerformAction_PlayAnim (name animName)
{
	m_AnimName=animName;
	m_bChangingState=True;
	GotoState('PA_PlayAnim');
}

function PerformAction_LoopAnim (name animName, float fLoopAnimTime)
{
	m_AnimName=animName;
	m_fLoopAnimTime=fLoopAnimTime;
	m_bChangingState=True;
	GotoState('PA_LoopAnim');
}

function PerformAction_StopInteraction ()
{
	m_bChangingState=True;
	GotoState(m_StateAfterInteraction);
	if ( m_InteractionObject.m_bPawnDied == True )
	{
		PawnDied();
	}
	else
	{
		if ( m_InteractionObject.m_SeePlayerPawn != None )
		{
			SeePlayer(m_InteractionObject.m_SeePlayerPawn);
		}
	}
	if ( m_InteractionObject.m_HearNoiseNoiseMaker != None )
	{
		HearNoise(m_InteractionObject.m_HearNoiseLoudness,m_InteractionObject.m_HearNoiseNoiseMaker,m_InteractionObject.m_HearNoiseType);
	}
}

state PA_Interaction
{
	event SeePlayer (Pawn seen)
	{
		if ( m_r6pawn.m_bDontSeePlayer && R6Pawn(seen).m_bIsPlayer )
		{
			return;
		}
		if ( m_InteractionObject.m_SeePlayerPawn == None )
		{
			m_InteractionObject.m_SeePlayerPawn=seen;
			if (  !m_bCantInterruptIO )
			{
				m_InteractionObject.StopInteractionWithEndingActions();
			}
		}
	}

	event HearNoise (float Loudness, Actor NoiseMaker, ENoiseType eType)
	{
		if ( m_r6pawn.m_bDontHearPlayer && R6Pawn(NoiseMaker).m_bIsPlayer )
		{
			return;
		}
		if ( m_InteractionObject.m_HearNoiseNoiseMaker == None )
		{
			m_InteractionObject.m_HearNoiseLoudness=Loudness;
			m_InteractionObject.m_HearNoiseNoiseMaker=NoiseMaker;
			m_InteractionObject.m_HearNoiseType=eType;
			if (  !m_bCantInterruptIO )
			{
				m_InteractionObject.StopInteractionWithEndingActions();
			}
		}
	}

	function PawnDied ()
	{
		if ( m_InteractionObject.m_bPawnDied == False )
		{
			m_InteractionObject.m_bPawnDied=True;
			m_r6pawn.m_iTracedBone=0;
			m_InteractionObject.StopInteraction();
		}
	}

	event AnimEnd (int Channel)
	{
	}

	event bool NotifyBump (Actor Other)
	{
		return True;
	}

	event EndState ()
	{
		if ( m_bChangingState == True )
		{
			m_bChangingState=False;
		}
		else
		{
			m_InteractionObject.StopInteractionWithEndingActions();
		}
	}

}

state PA_StartInteraction extends PA_Interaction
{
Begin:
	m_InteractionObject.FinishAction();
}

state PA_LookAt extends PA_Interaction
{
Begin:
	m_r6pawn.PawnLookAt(m_ActorTarget.Location);
	m_InteractionObject.FinishAction();
}

state PA_Goto extends PA_Interaction
{
	event EndState ()
	{
		StopMoving();
		Super.EndState();
	}

Begin:
	MoveTo(m_ActorTarget.Location);
	MoveToPosition(m_ActorTarget.Location,m_ActorTarget.Rotation);
	m_InteractionObject.FinishAction();
}

state PA_PlayAnim extends PA_Interaction
{
Begin:
	m_r6pawn.R6PlayAnim(m_AnimName,1.00);
	FinishAnim();
	m_InteractionObject.FinishAction();
}

state PA_LoopAnim extends PA_Interaction
{
Begin:
	m_r6pawn.R6LoopAnim(m_AnimName,1.00);
	if ( m_fLoopAnimTime == 0.00 )
	{
//		stop
	}
	else
	{
		Sleep(m_fLoopAnimTime);
	}
	m_InteractionObject.FinishAction();
}

defaultproperties
{
    c_iDistanceBumpBackUp=80
    MinHitWall=-0.40
    bRotateToDesired=True
}
