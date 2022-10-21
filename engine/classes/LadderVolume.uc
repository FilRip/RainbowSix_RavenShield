//================================================================================
// LadderVolume.
//================================================================================
class LadderVolume extends PhysicsVolume
	Native;
//	NoNativeReplication;

var() bool bNoPhysicalLadder;
var() bool bAutoPath;
var const Ladder LadderList;
var Pawn PendingClimber;
var() name ClimbingAnimation;
var() name TopAnimation;
var() Rotator WallDir;
var Vector LookDir;
var Vector ClimbDir;

simulated function PostBeginPlay ()
{
	local Ladder L;
	local Ladder M;
	local Vector Dir;

	Super.PostBeginPlay();
	LookDir=vector(WallDir);
	if (  !bAutoPath && (LookDir.Z != 0) )
	{
		ClimbDir=vect(0.00,0.00,1.00);
		L=LadderList;
JL0050:
		if ( L != None )
		{
			M=LadderList;
JL0066:
			if ( M != None )
			{
				if ( M != L )
				{
					Dir=Normal(M.Location - L.Location);
					if ( Dir Dot ClimbDir < 0 )
					{
						Dir *= -1;
					}
					ClimbDir += Dir;
				}
				M=M.LadderList;
				goto JL0066;
			}
			L=L.LadderList;
			goto JL0050;
		}
		ClimbDir=Normal(ClimbDir);
		if ( ClimbDir Dot vect(0.00,0.00,1.00) < 0 )
		{
			ClimbDir *= -1;
		}
	}
}

function bool InUse (Pawn Ignored)
{
	local Pawn StillClimbing;

	foreach TouchingActors(Class'Pawn',StillClimbing)
	{
		if ( (StillClimbing != Ignored) && StillClimbing.bCollideActors && StillClimbing.bBlockActors )
		{
			return True;
		}
	}
	if ( PendingClimber != None )
	{
		if ( (PendingClimber.Controller == None) ||  !PendingClimber.bCollideActors ||  !PendingClimber.bBlockActors || (Ladder(PendingClimber.Controller.MoveTarget) == None) || (Ladder(PendingClimber.Controller.MoveTarget).MyLadder != self) )
		{
			PendingClimber=None;
		}
	}
	return (PendingClimber != None) && (PendingClimber != Ignored);
}

simulated event PawnEnteredVolume (Pawn P)
{
	local Rotator PawnRot;

	Super.PawnEnteredVolume(P);
	if (  !P.CanGrabLadder() )
	{
		return;
	}
	PawnRot=P.Rotation;
	PawnRot.Pitch=0;
	if ( ((vector(PawnRot) Dot LookDir) > 0.90) || (AIController(P.Controller) != None) && (Ladder(P.Controller.MoveTarget) != None) )
	{
		P.ClimbLadder(self);
	}
	else
	{
		if (  !P.bDeleteMe && (P.Controller != None) )
		{
			Spawn(Class'PotentialClimbWatcher',P);
		}
	}
}

simulated event PawnLeavingVolume (Pawn P)
{
	local Controller C;

	if ( P.OnLadder != self )
	{
		return;
	}
	Super.PawnLeavingVolume(P);
	P.OnLadder=None;
	P.EndClimbLadder(self);
	if ( P == PendingClimber )
	{
		PendingClimber=None;
	}
	if (  !InUse(P) )
	{
		C=Level.ControllerList;
JL007B:
		if ( C != None )
		{
			if ( C.bPreparingMove && (Ladder(C.MoveTarget) != None) && (Ladder(C.MoveTarget).MyLadder == self) )
			{
				C.bPreparingMove=False;
				PendingClimber=C.Pawn;
				return;
			}
			C=C.nextController;
			goto JL007B;
		}
	}
}

simulated event PhysicsChangedFor (Actor Other)
{
	if ( (Other.Physics == 2) || (Other.Physics == 11) || Other.bDeleteMe || (Pawn(Other) == None) || (Pawn(Other).Controller == None) )
	{
		return;
	}
	Spawn(Class'PotentialClimbWatcher',Other);
}

defaultproperties
{
    bAutoPath=True
    ClimbDir=(X=0.00,Y=0.00,Z=1.00)
    RemoteRole=ROLE_SimulatedProxy
}