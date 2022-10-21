//================================================================================
// R61stRemoteCharge.
//================================================================================
class R61stRemoteCharge extends R6AbstractFirstPersonWeapon;

simulated function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stItemAttachementA');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stC4');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stItems_UKX.R61stItemAttachement'
*/

