//================================================================================
// R61stPistolDesertEagles.
//================================================================================
class R61stPistolDesertEagles extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stPistolDesertEaglesA');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stPistolDesertEaglesFrame');
	AttachToBone(m_smGun,'TagFrame');
	m_smGun2=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun2.SetStaticMesh(StaticMesh'R61stPistolDesertEaglesSlide');
	AttachToBone(m_smGun2,'TagSlide');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stPistol_UKX.R61stPistolDesertEagles'
*/

