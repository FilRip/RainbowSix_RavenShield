//================================================================================
// R6HBSGadget.
//================================================================================
class R6HBSGadget extends R6Gadget
	Native;

var bool m_bHeartBeatOn;
var Sound m_sndActivation;
var Sound m_sndDesactivation;

replication
{
	unreliable if ( Role < Role_Authority )
		ServerToggleHeartBeatProperties;
}

native(2700) final function ToggleHeartBeatProperties (bool bTurnItOn);

simulated event bool IsGoggles ()
{
	return True;
}

function ServerToggleHeartBeatProperties (bool bActiveHeartBeat)
{
	if ( bShowLog )
	{
		Log("HBS - ServerToggleHeartBeatProperties =" @ string(bActiveHeartBeat));
	}
	m_bHeartBeatOn=bActiveHeartBeat;
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

function DisplayHeartBeat (bool bActivateHeartBeat)
{
	local R6Pawn pawnOwner;

	pawnOwner=R6Pawn(Owner);
	if (  !pawnOwner.IsLocallyControlled() )
	{
		return;
	}
	if ( bShowLog )
	{
		Log("HBS - DisplayHeartBeat =" @ string(bActivateHeartBeat) @ string(m_sndActivation) @ string(m_sndDesactivation));
	}
	m_bHeartBeatOn=bActivateHeartBeat;
	if ( bActivateHeartBeat )
	{
//		pawnOwner.PlaySound(m_sndActivation,3);
	}
	else
	{
//		pawnOwner.PlaySound(m_sndDesactivation,3);
	}
	ServerToggleHeartBeatProperties(bActivateHeartBeat);
	ToggleHeartBeatProperties(bActivateHeartBeat);
}

simulated function RemoveFirstPersonWeapon ()
{
	Super.RemoveFirstPersonWeapon();
	DisplayHeartBeat(False);
	if ( bShowLog )
	{
		Log("HBS - RemoveFirstPersonWeapon =" @ string(m_bHeartBeatOn));
	}
}

simulated function bool LoadFirstPersonWeapon (optional Pawn NetOwner, optional Controller LocalPlayerController)
{
	Super.LoadFirstPersonWeapon(NetOwner,LocalPlayerController);
	if ( bShowLog )
	{
		Log("HBS - LoadFirstPersonWeapon =" @ string(m_bHeartBeatOn));
	}
	DisplayHeartBeat(m_bHeartBeatOn);
	return True;
}

simulated function DisableWeaponOrGadget ()
{
	DisplayHeartBeat(False);
	if ( bShowLog )
	{
		Log("HBS - DisableWeaponOrGadget =" @ string(m_bHeartBeatOn));
	}
}

state PutWeaponDown
{
	simulated function BeginState ()
	{
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('PutWeaponDown');
			Pawn(Owner).Controller.m_bLockWeaponActions=True;
		}
		DisplayHeartBeat(False);
		if ( bShowLog )
		{
			Log("HBS - BeginState of PutWeaponDown for" @ string(self) @ "=" @ string(m_bHeartBeatOn));
		}
	}

}

state BringWeaponUp
{
	simulated function BeginState ()
	{
		Super.BeginState();
		if ( R6Pawn(Owner).m_bActivateNightVision == True )
		{
			R6Pawn(Owner).ToggleNightVision();
		}
	}

	simulated function EndState ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

	function FirstPersonAnimOver ()
	{
		GotoState('None');
		DisplayHeartBeat(True);
		if ( bShowLog )
		{
			Log("HBS - FirstPersonAnimOver of BringWeaponUp for" @ string(self) @ "=" @ string(m_bHeartBeatOn));
		}
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

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("HBS - BeginState of RaiseWeapon for" @ string(self) @ "=" @ string(m_bHeartBeatOn));
		}
		Super.BeginState();
		if ( R6Pawn(Owner).m_bActivateNightVision == True )
		{
			R6Pawn(Owner).ToggleNightVision();
		}
	}

	simulated function EndState ()
	{
		if ( bShowLog )
		{
			Log("HBS - EndState of RaiseWeapon for" @ string(self) @ "=" @ string(m_bHeartBeatOn));
		}
		Pawn(Owner).Controller.m_bHideReticule=False;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
		DisplayHeartBeat(True);
	}

}

state DiscardWeapon
{
	simulated function BeginState ()
	{
		local Pawn aPawn;

		DisplayHeartBeat(False);
		if ( bShowLog )
		{
			Log("HBS - BeginState of DiscardWeapon for" @ string(self) @ "=" @ string(m_bHeartBeatOn));
		}
		if ( m_FPHands != None )
		{
			aPawn=Pawn(Owner);
			if ( aPawn.Controller != None )
			{
				aPawn.Controller.m_bHideReticule=True;
				aPawn.Controller.m_bLockWeaponActions=True;
			}
			m_FPHands.GotoState('DiscardWeapon');
		}
	}

	simulated function EndState ()
	{
		if ( bShowLog )
		{
			Log("IN:" @ string(self) @ "::DiscardWeapon::EndState()");
		}
	}

}

function StartLoopingAnims ()
{
	if ( m_FPHands != None )
	{
		m_FPHands.SetDrawType(DT_None);
		m_FPHands.GotoState('Waiting');
	}
	GotoState('None');
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
    m_bHiddenWhenNotInUse=True
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripHBS'
    m_pFPWeaponClass=Class'R61stWeapons.R61stHBS'
    m_PawnWaitAnimLow=StandHBS_nt
    m_PawnWaitAnimHigh=StandHBS_nt
    m_PawnWaitAnimProne=ProneHBS_nt
    m_PawnFiringAnim=StandHBS
    m_PawnFiringAnimProne=ProneHBS
    m_AttachPoint=TagHBHand
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=0.00,W=0.00)
    m_NameID="HBSGadget"
    bCollideWorld=True
    DrawScale=1.10
}
/*
    m_sndActivation=Sound'Foley_HBSensor.Play_HBSensorAction1'
    m_sndDesactivation=Sound'Foley_HBSensor.Stop_HBSensorAction1'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdHBSensor'
    m_EquipSnd=Sound'Foley_HBSensor.Play_HBS_Equip'
    m_UnEquipSnd=Sound'Foley_HBSensor.Play_HBS_Unequip'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

