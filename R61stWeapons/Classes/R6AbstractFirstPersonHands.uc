//================================================================================
// R6AbstractFirstPersonHands.
//================================================================================
class R6AbstractFirstPersonHands extends R6AbstractFirstPersonWeapon
	Abstract;

var bool m_bPlayWaitAnim;
var bool m_bCanQuitOnAnimEnd;
var bool m_bCannotPlayEmpty;
var bool m_bInBurst;
var bool m_bBipodDeployed;
var bool bShowLog;
var bool bPlayerWalking;
var float m_fAnimAcceleration;
var R6AbstractFirstPersonWeapon AssociatedWeapon;
var R6AbstractGadget AssociatedGadget;
var(R6HandAnimation) name m_HandFire;
var(R6HandAnimation) name m_HandFireLast;
var(R6HandAnimation) name m_HandBipodFire;
var(R6HandAnimation) name m_HandReloadEmpty;
var(R6HandAnimation) name m_HandBipodReloadEmpty;
var(R6HandAnimation) name m_WaitAnim1;
var(R6HandAnimation) name m_WaitAnim2;
var(R6HandAnimation) name m_WalkAnim;

function PostBeginPlay ()
{
	if (  !HasAnim('Fire') )
	{
		m_HandFire='Neutral';
	}
	if (  !HasAnim('FireLast') )
	{
		m_HandFireLast=m_HandFire;
	}
	if (  !HasAnim('BipodFire') )
	{
		m_HandBipodFire=m_HandFire;
	}
	if (  !HasAnim('ReloadEmpty') )
	{
		m_HandReloadEmpty='Reload';
	}
	if (  !HasAnim('BipodReloadEmpty') )
	{
		m_HandBipodReloadEmpty='BipodReload';
	}
	if (  !HasAnim('Wait01') )
	{
		m_WaitAnim1='Wait_c';
	}
	if (  !HasAnim('Wait02') )
	{
		m_WaitAnim2=m_WaitAnim1;
	}
	if (  !HasAnim('walk_c') )
	{
		m_WalkAnim='Wait_c';
	}
	Super.PostBeginPlay();
}

function ResetNeutralAnim ()
{
	AssociatedWeapon.m_WeaponNeutralAnim=AssociatedWeapon.m_Neutral;
	AssociatedWeapon.PlayAnim(AssociatedWeapon.m_WeaponNeutralAnim);
}

function PlayWalkingAnimation ()
{
	if ( IsInState('Waiting') )
	{
		LoopAnim(m_WalkAnim);
	}
	bPlayerWalking=True;
}

function StopWalkingAnimation ()
{
	if ( IsInState('Waiting') )
	{
		LoopAnim('Wait_c');
	}
	bPlayerWalking=False;
}

simulated function SetAssociatedWeapon (R6AbstractFirstPersonWeapon AWeapon)
{
	AssociatedWeapon=AWeapon;
}

simulated function SetAssociatedGadget (R6AbstractGadget AGadget)
{
	AssociatedGadget=AGadget;
}

state Reloading
{
	function EndState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  Leaving State Reloading");
		}
	}

	simulated event AnimEnd (int Channel)
	{
		if ( Channel == 0 )
		{
			if ( m_bBipodDeployed )
			{
				AssociatedWeapon.m_WeaponNeutralAnim=AssociatedWeapon.m_BipodNeutral;
			}
			else
			{
				AssociatedWeapon.m_WeaponNeutralAnim=AssociatedWeapon.m_Neutral;
			}
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_WeaponNeutralAnim);
			GotoState('Waiting');
			AssociatedWeapon.GotoState('None');
			R6AbstractWeapon(Owner).FirstPersonAnimOver();
		}
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  Begin State Reloading");
		}
		R6Pawn(Owner.Owner).ServerPlayReloadAnimAgain();
		AssociatedWeapon.GotoState('Reloading');
		if ( m_bReloadEmpty == True )
		{
			if ( m_bBipodDeployed )
			{
				PlayAnim(m_HandBipodReloadEmpty);
				AssociatedWeapon.PlayAnim(AssociatedWeapon.m_BipodReloadEmpty);
			}
			else
			{
				PlayAnim(m_HandReloadEmpty);
				AssociatedWeapon.PlayAnim(AssociatedWeapon.m_ReloadEmpty);
			}
			m_bReloadEmpty=False;
		}
		else
		{
			if ( m_bBipodDeployed )
			{
				PlayAnim('BipodReload');
				AssociatedWeapon.PlayAnim(AssociatedWeapon.m_BipodReload);
			}
			else
			{
				PlayAnim('Reload');
				AssociatedWeapon.PlayAnim(AssociatedWeapon.m_Reload);
			}
		}
	}

}

state DiscardWeapon
{
	simulated event AnimEnd (int Channel)
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  " $ string(self) $ " -   IN:" @ string(self) @ "::DiscardWeapon::AnimEnd()");
		}
		if ( Owner == None )
		{
			return;
		}
		if ( Channel == 0 )
		{
			SetDrawType(DT_None);
			R6AbstractWeapon(Owner).FirstPersonAnimOver();
		}
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  IN:" @ string(self) @ "::DiscardWeapon::BeginState()");
		}
//		Owner.Owner.PlaySound(R6AbstractWeapon(Owner).m_UnEquipSnd,3);
		if ( m_bBipodDeployed )
		{
			PlayAnim('BipodEnd',R6Pawn(Owner.Owner).ArmorSkillEffect() * m_fAnimAcceleration);
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_BipodDiscard);
		}
		else
		{
			PlayAnim('End',R6Pawn(Owner.Owner).ArmorSkillEffect() * m_fAnimAcceleration);
		}
	}

}

state RaiseWeapon
{
	simulated event AnimEnd (int Channel)
	{
		if ( Channel == 0 )
		{
			GotoState('Waiting');
			R6AbstractWeapon(Owner).FirstPersonAnimOver();
		}
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  RaiseWeapon, Animation Begin");
		}
		SetDrawType(DT_Mesh);
		m_bBipodDeployed=R6Pawn(Owner.Owner).m_bIsProne && R6AbstractWeapon(Owner).GotBipod();
		AssociatedWeapon.m_bWeaponBipodDeployed=m_bBipodDeployed;
//		Owner.Owner.PlaySound(R6AbstractWeapon(Owner).m_EquipSnd,3);
		if ( m_bBipodDeployed )
		{
			PlayAnim('BipodBegin',R6Pawn(Owner.Owner).ArmorSkillEffect() * m_fAnimAcceleration);
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_BipodRaise);
		}
		else
		{
			PlayAnim('Begin',R6Pawn(Owner.Owner).ArmorSkillEffect() * m_fAnimAcceleration);
		}
	}

}

state PutWeaponDown
{
	simulated event AnimEnd (int Channel)
	{
		if ( Channel == 0 )
		{
			SetDrawType(DT_None);
			R6AbstractWeapon(Owner).FirstPersonAnimOver();
		}
	}

	simulated function BeginState ()
	{
//		Owner.Owner.PlaySound(R6AbstractWeapon(Owner).m_UnEquipSnd,3);
		if ( m_bBipodDeployed )
		{
			PlayAnim('BipodEnd');
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_BipodDiscard,R6Pawn(Owner.Owner).ArmorSkillEffect() * m_fAnimAcceleration);
		}
		else
		{
			PlayAnim('End',R6Pawn(Owner.Owner).ArmorSkillEffect() * 1.50);
		}
	}

}

state BringWeaponUp
{
	simulated function BeginState ()
	{
		SetDrawType(DT_Mesh);
		m_bBipodDeployed=R6Pawn(Owner.Owner).m_bIsProne && R6AbstractWeapon(Owner).GotBipod();
		AssociatedWeapon.m_bWeaponBipodDeployed=m_bBipodDeployed;
//		Owner.Owner.PlaySound(R6AbstractWeapon(Owner).m_EquipSnd,3);
		if ( m_bBipodDeployed )
		{
			PlayAnim('BipodBegin');
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_BipodRaise,R6Pawn(Owner.Owner).ArmorSkillEffect() * m_fAnimAcceleration);
		}
		else
		{
			PlayAnim('Begin',R6Pawn(Owner.Owner).ArmorSkillEffect() * 1.50);
		}
	}

	simulated event AnimEnd (int Channel)
	{
		if ( Channel == 0 )
		{
			GotoState('Waiting');
			R6AbstractWeapon(Owner).FirstPersonAnimOver();
		}
	}

}

auto state Waiting
{
	simulated function Timer ()
	{
		local int WhichAnim;
		local int HowLongBeforeWait;

		if ( DrawType != 0 )
		{
			StopAnimating();
			WhichAnim=Rand(10);
			if ( WhichAnim < 5 )
			{
				PlayAnim(m_WaitAnim1);
			}
			else
			{
				PlayAnim(m_WaitAnim2);
			}
			m_bPlayWaitAnim=True;
			HowLongBeforeWait=Rand(10);
			SetTimer(HowLongBeforeWait + 5,False);
		}
	}

	event AnimEnd (int iChannel)
	{
		if ( m_bPlayWaitAnim == True )
		{
			m_bPlayWaitAnim=False;
			if ( m_bBipodDeployed )
			{
				LoopAnim('Bipod_nt');
			}
			else
			{
				if ( bPlayerWalking == True )
				{
					LoopAnim(m_WalkAnim);
				}
				else
				{
					LoopAnim('Wait_c');
				}
			}
		}
	}

	function StopTimer ()
	{
		SetTimer(0.00,False);
	}

	function StartTimer ()
	{
		local int HowLongBeforeWait;

		if ( DrawType != 0 )
		{
			HowLongBeforeWait=Rand(10);
			SetTimer(HowLongBeforeWait + 5,False);
		}
	}

	simulated function EndState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  Waiting::EndState ");
		}
		StopAnimating();
		StopTimer();
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  Waiting::BeginState ");
		}
		if ( m_bBipodDeployed )
		{
			LoopAnim('Bipod_nt');
		}
		else
		{
			if ( bPlayerWalking == True )
			{
				LoopAnim(m_WalkAnim);
			}
			else
			{
				LoopAnim('Wait_c');
			}
		}
		StartTimer();
	}

}

simulated state FiringWeapon
{
	function EndState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  Leaving State FiringWeapon");
		}
		AnimBlendParams(1,0.00);
	}

	function AnimEnd (int iChannel)
	{
		if ( (iChannel != 0) || (Owner == None) )
		{
			return;
		}
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  FiringWeapon::AnimEnd Can quit: " $ string(m_bCanQuitOnAnimEnd) $ " In burst " $ string(m_bInBurst));
		}
		if ( m_bCanQuitOnAnimEnd == True )
		{
			if ( bShowLog )
			{
				Log("HANDS - " $ string(self) $ " -  EndAnim, goto wait Owner : " $ string(R6AbstractWeapon(Owner)));
			}
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_WeaponNeutralAnim);
			AnimBlendParams(1,0.00);
			GotoState('Waiting');
			R6AbstractWeapon(Owner).FirstPersonAnimOver();
			m_bCanQuitOnAnimEnd=False;
			m_bCannotPlayEmpty=False;
			m_bInBurst=False;
		}
		else
		{
			if ( m_bInBurst == True )
			{
				if ( bShowLog )
				{
					Log("HANDS - " $ string(self) $ " -  EndAnim, loop Burst");
				}
				AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
				LoopAnim('Fireburst_c',R6AbstractWeapon(Owner).m_fFireAnimRate,0.10);
				AssociatedWeapon.LoopWeaponBurst();
			}
			else
			{
				if ( bShowLog )
				{
					Log("HANDS - " $ string(self) $ " -  EndAnim, playing fireburst_2");
				}
				m_bCannotPlayEmpty=True;
				m_bCanQuitOnAnimEnd=True;
				AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
				PlayAnim('Fireburst_e',,0.10);
				AssociatedWeapon.StopWeaponBurst();
			}
		}
	}

	function StopFiring ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  StopFiring");
		}
		m_bInBurst=False;
		AnimEnd(0);
	}

	function InterruptFiring ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  InterruptFiring");
		}
		m_bCanQuitOnAnimEnd=True;
		m_bInBurst=False;
		AnimEnd(0);
	}

	function FireEmpty ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  Fire Empty");
		}
		if (  !m_bBipodDeployed )
		{
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_FireEmpty);
		}
		if ( m_bCannotPlayEmpty == False )
		{
			PlayAnim('FireEmpty');
			m_bCanQuitOnAnimEnd=True;
		}
	}

	function FireLastBullet ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  FireLastBullet");
		}
		AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
		if ( m_bBipodDeployed )
		{
			PlayAnim(m_HandBipodFire);
			AssociatedWeapon.m_WeaponNeutralAnim=AssociatedWeapon.m_BipodNeutral;
		}
		else
		{
			PlayAnim(m_HandFireLast);
			if ( bShowLog )
			{
				Log("New neutral anim is: " $ string(AssociatedWeapon.m_Empty));
			}
			AssociatedWeapon.m_WeaponNeutralAnim=AssociatedWeapon.m_Empty;
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_FireLast);
		}
		m_bCanQuitOnAnimEnd=True;
	}

	function FireSingleShot ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  FireSingleShot");
		}
		AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
		if ( m_bBipodDeployed )
		{
			PlayAnim(m_HandBipodFire);
		}
		else
		{
			PlayAnim(m_HandFire);
		}
		m_bCanQuitOnAnimEnd=True;
	}

	function FireThreeShots ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  FireThreeShots rate = " $ string(R6AbstractWeapon(Owner).m_fFireAnimRate) $ "Blend = " $ string(R6AbstractWeapon(Owner).m_fFPBlend));
		}
		AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
		PlayAnim('Fireburst_b',R6AbstractWeapon(Owner).m_fFireAnimRate);
		m_bCanQuitOnAnimEnd=False;
	}

	function StartBurst ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  StartBurst rate = " $ string(R6AbstractWeapon(Owner).m_fFireAnimRate) $ "  Blend = " $ string(R6AbstractWeapon(Owner).m_fFPBlend));
		}
		m_bCanQuitOnAnimEnd=False;
		AnimBlendParams(1,R6AbstractWeapon(Owner).m_fFPBlend);
		PlayAnim('Fireburst_b',R6AbstractWeapon(Owner).m_fFireAnimRate);
		m_bInBurst=True;
		AssociatedWeapon.StartWeaponBurst();
	}

	function BeginState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  Begin Firing Anims");
		}
		LoopAnim('Neutral',,,1);
	}

}

state HandsDown
{
	simulated function EndState ()
	{
		StopAnimating();
		PlayAnim('OneHand_e');
	}

	event AnimEnd (int iChannel)
	{
		LoopAnim('OneHand_nt');
	}

	simulated function BeginState ()
	{
		PlayAnim('OneHand_b');
	}

}

state DeployBipod
{
	event AnimEnd (int iChannel)
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  DeployBipod::AnimEnd");
		}
		GotoState('Waiting');
		R6AbstractWeapon(Owner).FirstPersonAnimOver();
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  DeployBipod::BeginState");
		}
		PlayAnim('Bipod_b');
		AssociatedWeapon.PlayAnim(AssociatedWeapon.m_BipodDeploy);
		m_bBipodDeployed=True;
		AssociatedWeapon.m_bWeaponBipodDeployed=m_bBipodDeployed;
		AssociatedWeapon.m_WeaponNeutralAnim=AssociatedWeapon.m_BipodNeutral;
	}

	function EndState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  DeployBipod::EndState");
		}
	}

}

state CloseBipod
{
	simulated function EndState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  CloseBipod::EndState");
		}
		m_bBipodDeployed=False;
		AssociatedWeapon.m_bWeaponBipodDeployed=m_bBipodDeployed;
		AssociatedWeapon.m_WeaponNeutralAnim=AssociatedWeapon.m_Neutral;
	}

	event AnimEnd (int iChannel)
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  CloseBipod::AnimEnd");
		}
		GotoState('Waiting');
		R6AbstractWeapon(Owner).FirstPersonAnimOver();
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  CloseBipod::BeginState");
		}
		PlayAnim('Bipod_e');
		AssociatedWeapon.PlayAnim(AssociatedWeapon.m_BipodClose);
	}

}

state ZoomIn
{
	event AnimEnd (int iChannel)
	{
		if ( bShowLog )
		{
			Log("HANDS - " $ string(self) $ " -  ZoomIn::AnimEnd");
		}
		GotoState('Waiting');
		R6AbstractWeapon(Owner).FirstPersonAnimOver();
	}

	simulated function BeginState ()
	{
		if ( HasAnim('ZoomIn') )
		{
			PlayAnim('ZoomIn');
		}
		else
		{
			AnimEnd(0);
		}
	}

}

state ZoomOut
{
	event AnimEnd (int iChannel)
	{
		LoopAnim(AssociatedWeapon.m_WeaponNeutralAnim);
		GotoState('Waiting');
		R6AbstractWeapon(Owner).FirstPersonAnimOver();
	}

	simulated function BeginState ()
	{
		if ( HasAnim('ZoomOut') )
		{
			PlayAnim('ZoomOut');
		}
		else
		{
			AnimEnd(0);
		}
	}

}

defaultproperties
{
    m_fAnimAcceleration=1.20
    m_HandFire=Fire
    m_HandFireLast=FireLast
    m_HandBipodFire=BipodFire
    m_HandReloadEmpty=ReloadEmpty
    m_HandBipodReloadEmpty=BipodReloadEmpty
    m_WaitAnim1=Wait01
    m_WaitAnim2=Wait02
    m_WalkAnim=walk_c
    bHidden=True
}
