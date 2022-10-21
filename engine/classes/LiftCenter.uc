//================================================================================
// LiftCenter.
//================================================================================
class LiftCenter extends NavigationPoint
	Native
	Placeable;

var float MaxDist2D;
var Mover MyLift;
var Trigger RecommendedTrigger;
var() name LiftTag;
var() name LiftTrigger;
var Vector LiftOffset;

function PostBeginPlay ()
{
	if ( LiftTrigger != 'None' )
	{
		foreach DynamicActors(Class'Trigger',RecommendedTrigger,LiftTrigger)
		{
/*			goto JL0028;
JL0028:*/
		}
	}
	Super.PostBeginPlay();
}

function Actor SpecialHandling (Pawn Other)
{
	if ( MyLift == None )
	{
		return self;
	}
	if (  !MyLift.IsInState('StandOpenTimed') )
	{
		if ( MyLift.bClosed && (RecommendedTrigger != None) )
		{
			return RecommendedTrigger;
		}
	}
	else
	{
		if ( (MyLift.BumpType == 0) &&  !Other.IsPlayerPawn() )
		{
			return None;
		}
	}
	return self;
}

function bool SuggestMovePreparation (Pawn Other)
{
	if ( Other.Base == MyLift )
	{
		return False;
	}
	SetLocation(MyLift.Location + LiftOffset);
	SetBase(MyLift);
	if ( MyLift.bInterpolating ||  !ProceedWithMove(Other) )
	{
		Other.Controller.WaitForMover(MyLift);
		return True;
	}
	return False;
}

function bool ProceedWithMove (Pawn Other)
{
	local LiftExit Start;
	local float Dist2D;
	local Vector Dir;

	Start=LiftExit(Other.Anchor);
	if ( (Start != None) && (Start.KeyFrame != 255) )
	{
		if ( MyLift.KeyNum == Start.KeyFrame )
		{
			return True;
		}
	}
	else
	{
		Dir=Location - Other.Location;
		Dir.Z=0.00;
		Dist2D=VSize(Dir);
		if ( (Location.Z - CollisionHeight < Other.Location.Z - Other.CollisionHeight + 33.00) && (Location.Z - CollisionHeight > Other.Location.Z - Other.CollisionHeight - 1200) && (Dist2D < MaxDist2D) )
		{
			return True;
		}
	}
	if ( MyLift.bClosed )
	{
		Other.SetMoveTarget(SpecialHandling(Other));
		return True;
	}
	return False;
}

defaultproperties
{
    MaxDist2D=400.00
    ExtraCost=400
    bNeverUseStrafing=True
    bForceNoStrafing=True
    bSpecialMove=True
    bNoAutoConnect=True
    RemoteRole=ROLE_None
    bStatic=False
}
/*
    Texture=Texture'S_LiftCenter'
*/

