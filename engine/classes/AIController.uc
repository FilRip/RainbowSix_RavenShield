//================================================================================
// AIController.
//================================================================================
class AIController extends Controller
	Native;
//	NoNativeReplication;

var bool bHunting;
var bool bAdjustFromWalls;
var float Skill;
var AIScript MyScript;

native(510) final latent function WaitToSeeEnemy ();

event PreBeginPlay ()
{
	Super.PreBeginPlay();
	if ( bDeleteMe )
	{
		return;
	}
	if ( Level.Game != None )
	{
		Skill += Level.Game.Difficulty;
	}
	Skill=FClamp(Skill,0.00,3.00);
}

function Reset ()
{
	Super.Reset();
	if ( bIsPlayer )
	{
		Destroy();
	}
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	TriggerScript(Other,EventInstigator);
}

function bool TriggerScript (Actor Other, Pawn EventInstigator)
{
	if ( MyScript != None )
	{
		MyScript.Trigger(EventInstigator,Pawn);
		return True;
	}
	return False;
}

function DisplayDebug (Canvas Canvas, out float YL, out float YPos)
{
	local int i;
	local string t;

	Super.DisplayDebug(Canvas,YL,YPos);
	Canvas.DrawColor.B=255;
	Canvas.DrawText("     Skill " $ string(Skill) $ " NAVIGATION MoveTarget " $ GetItemName(string(MoveTarget)) $ " PendingMover " $ string(PendingMover) $ " MoveTimer " $ string(MoveTimer),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("      Destination " $ string(Destination) $ " Focus " $ GetItemName(string(Focus)),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("      RouteGoal " $ GetItemName(string(RouteGoal)) $ " RouteDist " $ string(RouteDist),False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	for (i=0;i < 16;i++)
	{
		if ( RouteCache[i] == None )
		{
			if ( i > 5 )
			{
				t=t $ "--" $ GetItemName(string(RouteCache[i - 1]));
			}
			break;
		}
		else
		{
			if ( i < 5 )
			{
				t=t $ GetItemName(string(RouteCache[i])) $ "-";
			}
		}
	}
	Canvas.DrawText("RouteCache: " $ t,False);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
}

function HearPickup (Pawn Other);

function int GetFacingDirection ()
{
	local float strafeMag;
	local Vector Focus2D;
	local Vector Loc2D;
	local Vector Dest2D;
	local Vector Dir;
	local Vector LookDir;
	local Vector Y;

	Focus2D=FocalPoint;
	Focus2D.Z=0.00;
	Loc2D=Pawn.Location;
	Loc2D.Z=0.00;
	Dest2D=Destination;
	Dest2D.Z=0.00;
	LookDir=Normal(Focus2D - Loc2D);
	Dir=Normal(Dest2D - Loc2D);
	strafeMag=LookDir Dot Dir;
	Y=LookDir Cross vect(0.00,0.00,1.00);
	if ( Y Dot (Dest2D - Loc2D) < 0 )
	{
		return 49152 + 16384 * strafeMag;
	}
	else
	{
		return 16384 - 16384 * strafeMag;
	}
}

function AdjustView (float DeltaTime)
{
	local float TargetYaw;
	local float TargetPitch;
	local Rotator OldViewRotation;
	local Rotator ViewRotation;

	Super.AdjustView(DeltaTime);
	ViewRotation=Rotation;
	OldViewRotation=Rotation;
	if ( Enemy == None )
	{
		ViewRotation.Roll=0;
		if ( DeltaTime < 0.20 )
		{
			OldViewRotation.Yaw=OldViewRotation.Yaw & 65535;
			OldViewRotation.Pitch=OldViewRotation.Pitch & 65535;
			TargetYaw=Rotation.Yaw & 65535;
			if ( Abs(TargetYaw - OldViewRotation.Yaw) > 32768 )
			{
				if ( TargetYaw < OldViewRotation.Yaw )
				{
					TargetYaw += 65536;
				}
				else
				{
					TargetYaw -= 65536;
				}
			}
			TargetYaw=OldViewRotation.Yaw * (1 - 5 * DeltaTime) + TargetYaw * 5 * DeltaTime;
			ViewRotation.Yaw=TargetYaw;
			TargetPitch=Rotation.Pitch & 65535;
			if ( Abs(TargetPitch - OldViewRotation.Pitch) > 32768 )
			{
				if ( TargetPitch < OldViewRotation.Pitch )
				{
					TargetPitch += 65536;
				}
				else
				{
					TargetPitch -= 65536;
				}
			}
			TargetPitch=OldViewRotation.Pitch * (1 - 5 * DeltaTime) + TargetPitch * 5 * DeltaTime;
			ViewRotation.Pitch=TargetPitch;
			SetRotation(ViewRotation);
		}
	}
}

function SetOrders (name NewOrders, Controller OrderGiver);

function Actor GetOrderObject ()
{
	return None;
}

function name GetOrders ()
{
	return 'None';
}

event PrepareForMove (NavigationPoint Goal, ReachSpec Path);

function WaitForMover (Mover M)
{
	PendingMover=M;
	bPreparingMove=True;
	Pawn.Acceleration=vect(0.00,0.00,0.00);
}

function MoverFinished ()
{
	if ( PendingMover.myMarker.ProceedWithMove(Pawn) )
	{
		PendingMover=None;
		bPreparingMove=False;
	}
}

function UnderLift (Mover M)
{
	local NavigationPoint N;

	bPreparingMove=False;
	PendingMover=None;
	if ( (MoveTarget != None) && MoveTarget.IsA('LiftCenter') )
	{
		for (N=Level.NavigationPointList;N != None;N=N.nextNavigationPoint)
		{
			if ( N.IsA('LiftExit') && (LiftExit(N).LiftTag == M.Tag) && actorReachable(N) )
			{
				MoveTarget=N;
				return;
			}
		}
	}
}

defaultproperties
{
    bAdjustFromWalls=True
    bCanOpenDoors=True
    bCanDoSpecial=True
    MinHitWall=-0.50
}