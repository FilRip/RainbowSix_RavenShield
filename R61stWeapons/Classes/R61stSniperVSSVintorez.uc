//================================================================================
// R61stSniperVSSVintorez.
//================================================================================
class R61stSniperVSSVintorez extends R61stSniperDragunov;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stSniperVSSVintorezA');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stSniperVSSVintorezFrame');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stSniper_UKX.R61stSniperVSSVintorez'
*/

