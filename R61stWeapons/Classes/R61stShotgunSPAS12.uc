//================================================================================
// R61stShotgunSPAS12.
//================================================================================
class R61stShotgunSPAS12 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stShotgunSPAS12A');
	Super.PostBeginPlay();
	m_FireLast=m_Neutral;
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stShotgunSPAS12Frame');
	AttachToBone(m_smGun,'TagFrame');
	if ( m_smGun2 == None )
	{
		m_smGun2=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun2.SetStaticMesh(StaticMesh'R61stShotgunSPAS12Pump');
	AttachToBone(m_smGun2,'TagPump');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stShotgun_UKX.R61stShotgunSPAS12'
*/

