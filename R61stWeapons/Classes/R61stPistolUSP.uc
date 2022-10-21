//================================================================================
// R61stPistolUSP.
//================================================================================
class R61stPistolUSP extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stPistolUSPA');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stPistolUSPFrame');
	AttachToBone(m_smGun,'TagFrame');
	m_smGun2=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun2.SetStaticMesh(StaticMesh'R61stPistolUSPSlide');
	AttachToBone(m_smGun2,'TagSlide');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stPistol_UKX.R61stPistolUSP'
*/

