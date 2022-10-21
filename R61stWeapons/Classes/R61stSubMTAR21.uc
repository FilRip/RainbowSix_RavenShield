//================================================================================
// R61stSubMTAR21.
//================================================================================
class R61stSubMTAR21 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stSubMTAR21A');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stSubMTAR21Frame');
	AttachToBone(m_smGun,'TagFrame');
}

simulated function SwitchFPMesh ()
{
//	m_smGun.SetStaticMesh(StaticMesh'R61stSubMTAR21ForScopeFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stSub_UKX.R61stSubMTAR21'
*/

