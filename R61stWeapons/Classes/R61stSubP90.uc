//================================================================================
// R61stSubP90.
//================================================================================
class R61stSubP90 extends R6AbstractFirstPersonWeapon;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stSubP90A');
	Super.PostBeginPlay();
	if ( m_smGun == None )
	{
		m_smGun=Spawn(Class'R61stWeaponStaticMesh');
	}
//	m_smGun.SetStaticMesh(StaticMesh'R61stSubP90Frame');
	AttachToBone(m_smGun,'TagFrame');
}

simulated function SwitchFPMesh ()
{
//	m_smGun.SetStaticMesh(StaticMesh'R61stSubP90ForScopeFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stSub_UKX.R61stSubP90'
*/

