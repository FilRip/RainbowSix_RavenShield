//================================================================================
// R61stPistolAPArmy.
//================================================================================
class R61stPistolAPArmy extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stPistolAPArmyA');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stPistolAPArmyFrame');
	AttachToBone(m_smGun,'TagFrame');
	m_smGun2=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun2.SetStaticMesh(StaticMesh'R61stPistolAPArmySlide');
	AttachToBone(m_smGun2,'TagSlide');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stPistol_UKX.R61stPistolAPArmy'
*/

