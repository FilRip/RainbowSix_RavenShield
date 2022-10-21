//================================================================================
// Ladder.
//================================================================================
class Ladder extends SmallNavigationPoint
	Native
	Placeable;

var LadderVolume MyLadder;
var Ladder LadderList;

event bool SuggestMovePreparation (Pawn Other)
{
	if ( MyLadder == None )
	{
		return False;
	}
	if (  !MyLadder.InUse(Other) )
	{
		MyLadder.PendingClimber=Other;
		return False;
	}
	Other.Controller.bPreparingMove=True;
	Other.Acceleration=vect(0.00,0.00,0.00);
	return True;
}

defaultproperties
{
    bSpecialMove=True
    bNotBased=True
    bDirectional=True
}
/*
    Texture=Texture'S_Ladder'
*/

