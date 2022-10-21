//================================================================================
// R61stFalseHBPuck.
//================================================================================
class R61stFalseHBPuck extends R6AbstractFirstPersonWeapon;

simulated function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stItemAttachementA');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stFalseHBPuck');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stItems_UKX.R61stItemAttachement'
*/

