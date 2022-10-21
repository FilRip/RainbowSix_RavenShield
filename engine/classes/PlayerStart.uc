//================================================================================
// PlayerStart.
//================================================================================
class PlayerStart extends SmallNavigationPoint
	Native
	Placeable;

var() byte TeamNumber;
var() bool bSinglePlayerStart;
var() bool bCoopStart;
var() bool bEnabled;

defaultproperties
{
    bSinglePlayerStart=True
    bCoopStart=True
    bEnabled=True
    bDirectional=True
}
/*
    Texture=Texture'S_Player'
*/

