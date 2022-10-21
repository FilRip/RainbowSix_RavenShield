//================================================================================
// R61stClaymore.
//================================================================================
class R61stClaymore extends R6AbstractFirstPersonWeapon;

simulated function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stItemAttachementA');
	Super.PostBeginPlay();
	m_smGun=Spawn(Class'R61stWeaponStaticMesh');
//	m_smGun.SetStaticMesh(StaticMesh'R61stClaymore');
	AttachToBone(m_smGun,'TagFrame');
}

defaultproperties
{
}
/*
    Mesh=SkeletalMesh'R61stItems_UKX.R61stItemAttachement'
*/

