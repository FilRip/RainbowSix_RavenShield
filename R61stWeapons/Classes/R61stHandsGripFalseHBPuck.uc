//================================================================================
// R61stHandsGripFalseHBPuck.
//================================================================================
class R61stHandsGripFalseHBPuck extends R61stHandsGripGrenade;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsItemFakeHBPuckA');
	Super.PostBeginPlay();
}

state RaiseWeapon
{
	simulated function BeginState ()
	{
		SetDrawType(DT_Mesh);
		AssociatedWeapon.SetDrawType(DT_Mesh);
		PlayAnim('Begin',R6Pawn(Owner.Owner).ArmorSkillEffect());
	}

}
