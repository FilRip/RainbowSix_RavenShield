//================================================================================
// R61stHandsGripC4.
//================================================================================
class R61stHandsGripC4 extends R6AbstractFirstPersonHands;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsGripC4A');
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
		GotoState('DiscardWeaponAfterFire');
	}

}

state DiscardWeaponAfterFire
{
	function Timer ()
	{
		R6AbstractWeapon(Owner).FirstPersonAnimOver();
	}

	simulated event AnimEnd (int Channel)
	{
		if ( bShowLog )
		{
			Log("IN:" @ string(self) @ "::DiscardWeaponAfterFire::AnimEnd()");
		}
		if ( Owner == None )
		{
			return;
		}
		if ( Channel == 0 )
		{
			SetDrawType(DT_None);
			SetTimer(R6AbstractWeapon(Owner).m_fPauseWhenChanging,False);
		}
		if ( bShowLog )
		{
			Log("OUT:" @ string(self) @ "::DiscardWeaponAfterFire::AnimEnd()");
		}
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("IN:" @ string(self) @ "::DiscardWeaponAfterFire::BeginState()");
		}
		PlayAnim('FireEmpty',R6Pawn(Owner.Owner).ArmorSkillEffect());
		if ( bShowLog )
		{
			Log("OUT:" @ string(self) @ "::DiscardWeaponAfterFire::BeginState()");
		}
	}

}

defaultproperties
{
    DrawType=0
}
/*
    Mesh=SkeletalMesh'R61stHands_UKX.R61stHands'
*/

