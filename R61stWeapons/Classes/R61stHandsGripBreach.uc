//================================================================================
// R61stHandsGripBreach.
//================================================================================
class R61stHandsGripBreach extends R6AbstractFirstPersonHands;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsGripBreachA');
	Super.PostBeginPlay();
	m_HandFire='Fire';
}

simulated state FiringWeapon
{
	function AnimEnd (int iChannel)
	{
		if ( (iChannel != 0) || (Owner == None) )
		{
			return;
		}
		if ( bShowLog )
		{
			Log("HANDS - EndAnim, goto wait");
		}
		AssociatedWeapon.PlayAnim(AssociatedWeapon.m_WeaponNeutralAnim);
		AnimBlendParams(1,0.00);
		R6AbstractWeapon(Owner).FirstPersonAnimOver();
		m_bCanQuitOnAnimEnd=False;
		m_bCannotPlayEmpty=False;
		m_bInBurst=False;
		GotoState('DiscardWeapon');
	}

}

defaultproperties
{
    DrawType=0
}
/*
    Mesh=SkeletalMesh'R61stHands_UKX.R61stHands'
*/

