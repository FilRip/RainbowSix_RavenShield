//================================================================================
// R61stAssaultM82.
//================================================================================
class R61stAssaultM82 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stAssaultM82A');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stAssaultM82Frame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stAssault_UKX.R61stAssaultM82'
*/

