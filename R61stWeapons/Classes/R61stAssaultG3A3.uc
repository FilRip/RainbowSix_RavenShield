//================================================================================
// R61stAssaultG3A3.
//================================================================================
class R61stAssaultG3A3 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stAssaultG3A3A');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stAssaultG3A3Frame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stAssault_UKX.R61stAssaultG3A3'
*/

