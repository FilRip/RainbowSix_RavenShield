//================================================================================
// R6HBSJammerGadget.
//================================================================================
class R6HBSJammerGadget extends R6Gadget;

var bool m_bHeartBeatJammerOn;

replication
{
	unreliable if ( Role < Role_Authority )
		ServerToggleHeartBeatJammerProperties;
}

function Fire (float fValue)
{
}

function StopFire (optional bool bSoundOnly)
{
}

function AltFire (float fValue)
{
}

function StopAltFire ()
{
}

function ServerToggleHeartBeatJammerProperties (bool bGadgetOn)
{
	if ( bShowLog )
	{
		Log("HBJ - ServerToggleHeartBeatJammerProperties is " $ string(bGadgetOn));
	}
	R6Pawn(Owner).m_bHBJammerOn=bGadgetOn;
}

simulated function RemoveFirstPersonWeapon ()
{
	Super.RemoveFirstPersonWeapon();
	TurnOnGadget(False);
}

simulated function bool LoadFirstPersonWeapon (optional Pawn NetOwner, optional Controller LocalPlayerController)
{
	Super.LoadFirstPersonWeapon(NetOwner,LocalPlayerController);
	TurnOnGadget(m_bHeartBeatJammerOn);
	return True;
}

simulated function TurnOnGadget (bool bGadgetOn)
{
	if ( (R6Pawn(Owner) == None) ||  !R6Pawn(Owner).IsLocallyControlled() )
	{
		return;
	}
	m_bHeartBeatJammerOn=bGadgetOn;
	ServerToggleHeartBeatJammerProperties(bGadgetOn);
}

simulated function DisableWeaponOrGadget ()
{
	TurnOnGadget(False);
}

state PutWeaponDown
{
	simulated function BeginState ()
	{
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('PutWeaponDown');
		}
		TurnOnGadget(False);
		if ( bShowLog )
		{
			Log("HBSJammer - BeginState of PutWeaponDown for" @ string(self) @ "=" @ string(m_bHeartBeatJammerOn));
		}
		Pawn(Owner).Controller.m_bLockWeaponActions=True;
	}

}

state BringWeaponUp
{
	function FirstPersonAnimOver ()
	{
		GotoState('None');
		TurnOnGadget(True);
		if ( bShowLog )
		{
			Log("HBSJammer - FirstPersonAnimOver of BringWeaponUp for" @ string(self) @ "=" @ string(m_bHeartBeatJammerOn));
		}
	}

	simulated function EndState ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

}

state RaiseWeapon
{
	function FirstPersonAnimOver ()
	{
		if ( bShowLog )
		{
			Log("HBS - FirstPersonAnimOver in RaiseWeapon for " $ string(self));
		}
		R6PlayerController(Pawn(Owner).Controller).ServerWeaponUpAnimDone();
		GotoState('None');
	}

	function BeginState ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=True;
		m_FPHands.GotoState('RaiseWeapon');
	}

	simulated function EndState ()
	{
		Pawn(Owner).Controller.m_bHideReticule=False;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
		TurnOnGadget(True);
	}

}

state DiscardWeapon
{
	simulated function BeginState ()
	{
		TurnOnGadget(False);
		if ( bShowLog )
		{
			Log("HBSJammer - BeginState of DiscardWeapon for" @ string(self) @ "=" @ string(m_bHeartBeatJammerOn));
		}
		if ( m_FPHands != None )
		{
			Pawn(Owner).Controller.m_bLockWeaponActions=True;
			Pawn(Owner).Controller.m_bHideReticule=True;
			m_FPHands.GotoState('DiscardWeapon');
		}
	}

}

state NormalFire
{
	simulated function BeginState ()
	{
		GotoState('None');
	}

}

defaultproperties
{
    m_fMuzzleVelocity=1000.00
    m_pReticuleClass=Class'R6DotReticule'
    m_bHiddenWhenNotInUse=True
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripHBSJ'
    m_pFPWeaponClass=Class'R61stWeapons.R61stHBSJ'
    m_PawnWaitAnimLow=StandHandGunLow_nt
    m_PawnWaitAnimHigh=StandHandGunHigh_nt
    m_PawnWaitAnimProne=ProneHandGun_nt
    m_AttachPoint=TagHBSJammer
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=-131072.56,W=0.00)
    m_NameID="HBSJammerGadget"
    bCollideWorld=True
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdHBSensor_Jamer'
    m_EquipSnd=Sound'Foley_HBSJammer.Play_HBSJ_Equip'
    m_UnEquipSnd=Sound'Foley_HBSJammer.Play_HBSJ_Unequip'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

