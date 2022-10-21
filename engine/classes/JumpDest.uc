//================================================================================
// JumpDest.
//================================================================================
class JumpDest extends NavigationPoint
	Native;

var int NumUpstreamPaths;
var ReachSpec UpstreamPaths[8];
var Vector NeededJump[8];

function int GetPathIndex (ReachSpec Path)
{
	local int i;

	if ( Path == None )
	{
		return 0;
	}
	for (i=0;i < 4;i++)
	{
		if ( UpstreamPaths[i] == Path )
		{
			return i;
		}
	}
	return 0;
}

event int SpecialCost (Pawn Other, ReachSpec Path)
{
	local int Num;

	Num=GetPathIndex(Path);
	if ( Abs(Other.JumpZ / Other.PhysicsVolume.Gravity.Z) >= Abs(NeededJump[Num].Z / Other.PhysicsVolume.Default.Gravity.Z) )
	{
		return 100;
	}
	return 10000000;
}

event bool SuggestMovePreparation (Pawn Other)
{
	local int Num;

	if ( Other.Controller == None )
	{
		return False;
	}
	Num=GetPathIndex(Other.Controller.CurrentPath);
	if ( Abs(Other.JumpZ / Other.PhysicsVolume.Gravity.Z) < Abs(NeededJump[Num].Z / Other.PhysicsVolume.Default.Gravity.Z) )
	{
		return False;
	}
	Other.Controller.MoveTarget=self;
	Other.Controller.Destination=Location;
	Other.bNoJumpAdjust=True;
	Other.Velocity=NeededJump[Num];
	Other.Acceleration=vect(0.00,0.00,0.00);
	Other.SetPhysics(PHYS_Falling);
	Other.Controller.SetFall();
	Other.DestinationOffset=CollisionRadius;
	return False;
}

defaultproperties
{
    bSpecialForced=True
}