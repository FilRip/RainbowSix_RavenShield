//================================================================================
// R61stSniperM82A1.
//================================================================================
class R61stSniperM82A1 extends R61stSniperDragunov;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stSniperM82A1A');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stSniperM82A1Frame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stSniper_UKX.R61stSniperM82A1'
*/

