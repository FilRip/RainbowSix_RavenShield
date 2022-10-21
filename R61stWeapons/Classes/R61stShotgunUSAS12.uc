//================================================================================
// R61stShotgunUSAS12.
//================================================================================
class R61stShotgunUSAS12 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stShotgunUSAS12A');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stShotgunUSAS12Frame');
	AttachToBone(m_smGun,'TagFrame');
	if ( m_smGun2 == None )
	{
		m_smGun2=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun2.SetStaticMesh(StaticMesh'R61stShotgunUSAS12Magazine');
	AttachToBone(m_smGun2,'TagMagazine');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stShotgun_UKX.R61stShotgunUSAS12'
*/

