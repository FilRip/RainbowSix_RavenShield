//================================================================================
// R61stSubMp5A4.
//================================================================================
class R61stSubMp5A4 extends R61stSubMp5SD5;

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stSubMp5A4Frame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stSub_UKX.R61stSubMp5A4'
*/

