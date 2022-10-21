//================================================================================
// R61stSubMp510A2.
//================================================================================
class R61stSubMp510A2 extends R61stSubMp5SD5;

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stSubMp510A2Frame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stSub_UKX.R61stSubMp510A2'
*/

