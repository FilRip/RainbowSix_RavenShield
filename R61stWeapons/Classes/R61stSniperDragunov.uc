//================================================================================
// R61stSniperDragunov.
//================================================================================
class R61stSniperDragunov extends R61stSniperSSG3000;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stSniperDragunovA');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stSniperDragunovFrame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stSniper_UKX.R61stSniperDragunov'
*/

