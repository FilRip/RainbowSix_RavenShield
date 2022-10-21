//================================================================================
// R61stGrenadeFlashBang.
//================================================================================
class R61stGrenadeFlashBang extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stGrenadeA');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stGrenadeFlashBang');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stGrenade_UKX.R61stGrenade'
*/

