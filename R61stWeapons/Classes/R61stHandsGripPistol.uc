//================================================================================
// R61stHandsGripPistol.
//================================================================================
class R61stHandsGripPistol extends R6AbstractFirstPersonHands;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsGripPistolA');
	Super.PostBeginPlay();
}

defaultproperties
{
    DrawType=0
}
/*
    Mesh=SkeletalMesh'R61stHands_UKX.R61stHands'
*/

