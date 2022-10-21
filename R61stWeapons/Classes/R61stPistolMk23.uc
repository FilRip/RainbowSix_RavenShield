//================================================================================
// R61stPistolMk23.
//================================================================================
class R61stPistolMk23 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stPistolMk23A');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stPistolMk23Frame');
	AttachToBone(m_smGun,'TagFrame');
	m_smGun2=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun2.SetStaticMesh(StaticMesh'R61stPistolMk23Slide');
	AttachToBone(m_smGun2,'TagSlide');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stPistol_UKX.R61stPistolMk23'
*/

