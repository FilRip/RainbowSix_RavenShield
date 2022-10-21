//================================================================================
// R61stPistolSR2.
//================================================================================
class R61stPistolSR2 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stPistolSR2A');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stPistolSR2Frame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stPistol_UKX.R61stPistolSR2'
*/

