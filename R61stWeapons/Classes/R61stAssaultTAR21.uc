//================================================================================
// R61stAssaultTAR21.
//================================================================================
class R61stAssaultTAR21 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stAssaultTAR21A');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stAssaultTAR21Frame');
	AttachToBone(m_smGun,'TagFrame');
}

simulated function SwitchFPMesh ()
{
//	m_smGun.SetStaticMesh(StaticMesh'R61stAssaultTAR21ForScopeFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stAssault_UKX.R61stAssaultTAR21'
*/

