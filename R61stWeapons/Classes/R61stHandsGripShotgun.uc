//================================================================================
// R61stHandsGripShotgun.
//================================================================================
class R61stHandsGripShotgun extends R6AbstractFirstPersonHands;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsGripShotgunA');
	Super.PostBeginPlay();
}

defaultproperties
{
    DrawType=0
}
/*
    Mesh=SkeletalMesh'R61stHands_UKX.R61stHands'
*/

