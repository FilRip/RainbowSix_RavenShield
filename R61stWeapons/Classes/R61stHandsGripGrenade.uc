//================================================================================
// R61stHandsGripGrenade.
//================================================================================
class R61stHandsGripGrenade extends R6AbstractFirstPersonHands;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsGripGrenadeA');
	Super.PostBeginPlay();
}

auto state Waiting
{
	simulated function Timer ()
	{
		local int HowLongBeforeWait;

		PlayAnim('Wait01');
		m_bPlayWaitAnim=True;
		HowLongBeforeWait=Rand(10);
		SetTimer(HowLongBeforeWait + 5,False);
	}

}

state RaiseWeapon
{
	simulated function BeginState ()
	{
		SetDrawType(DT_Mesh);
		AssociatedWeapon.SetDrawType(DT_Mesh);
		AssociatedWeapon.PlayAnim(AssociatedWeapon.m_WeaponNeutralAnim);
//		Owner.Owner.PlaySound(R6AbstractWeapon(Owner).m_EquipSnd,3);
		PlayAnim('Begin',R6Pawn(Owner.Owner).ArmorSkillEffect());
	}

}

simulated state FiringWeapon
{
	function EndState ()
	{
	}

	function FireEmpty ()
	{
	}

	function BeginState ()
	{
		LoopAnim('Neutral',,,1);
	}

	simulated function AnimEnd (int iChannel)
	{
		if ( bShowLog )
		{
			Log("animEnd " $ string(self));
		}
		if ( (iChannel != 0) || (Owner == None) )
		{
			return;
		}
		if ( m_bCanQuitOnAnimEnd == True )
		{
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_WeaponNeutralAnim);
			AnimBlendParams(1,0.00);
			LoopAnim('Empty_nt');
			m_bCanQuitOnAnimEnd=False;
			m_bCannotPlayEmpty=False;
			m_bInBurst=False;
			GotoState('None');
		}
		else
		{
			AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
			LoopAnim('Fire_nt',R6AbstractWeapon(Owner).m_fFireAnimRate,0.10);
		}
		if ( bShowLog )
		{
			Log("Calling FPAO");
		}
		R6AbstractWeapon(Owner).FirstPersonAnimOver();
	}

	simulated function FireGrenadeThrow ()
	{
		AssociatedWeapon.SetDrawType(DT_None);
		AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
		PlayAnim('Fire_Up',R6Pawn(Owner.Owner).ArmorSkillEffect() * 0.80);
		m_bCanQuitOnAnimEnd=True;
		if ( bShowLog )
		{
			Log("FireGrenadeThrow " $ string(self));
		}
	}

	simulated function FireGrenadeRoll ()
	{
		AssociatedWeapon.SetDrawType(DT_None);
		AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
		PlayAnim('Fire_Down',R6Pawn(Owner.Owner).ArmorSkillEffect() * 0.80);
		m_bCanQuitOnAnimEnd=True;
		if ( bShowLog )
		{
			Log("FireGrenadeRoll " $ string(self));
		}
	}

	simulated function FireSingleShot ()
	{
		AssociatedWeapon.PlayAnim(AssociatedWeapon.m_Fire,R6Pawn(Owner.Owner).ArmorSkillEffect());
		AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
		PlayAnim('Fire',R6Pawn(Owner.Owner).ArmorSkillEffect());
		m_bCanQuitOnAnimEnd=False;
		if ( bShowLog )
		{
			Log("FireSingleShot " $ string(self));
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

