//================================================================================
// LiftExit.
//================================================================================
class LiftExit extends NavigationPoint
	Native
	Placeable;

var() byte SuggestedKeyFrame;
var byte KeyFrame;
var Mover MyLift;
var() name LiftTag;

function bool SuggestMovePreparation (Pawn Other)
{
	if ( (Other.Base == MyLift) && (MyLift != None) )
	{
		if ( (self.Location.Z < Other.Location.Z + Other.CollisionHeight) && Other.LineOfSightTo(self) )
		{
			return False;
		}
		Other.DesiredRotation=rotator(Location - Other.Location);
		Other.Controller.WaitForMover(MyLift);
		return True;
	}
	return False;
}

defaultproperties
{
    SuggestedKeyFrame=255
    bNeverUseStrafing=True
    bForceNoStrafing=True
    bSpecialMove=True
}
/*
    Texture=Texture'S_LiftExit'
*/

