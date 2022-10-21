//================================================================================
// R61stSubSR2.
//================================================================================
class R61stSubSR2 extends R61stPistolSR2;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stPistolSR2A');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stSubSR2Frame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stSub_UKX.R61stSubSR2'
*/

