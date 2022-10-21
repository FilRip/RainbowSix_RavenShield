//================================================================================
// R6HBSSAJammerGadget.
//================================================================================
class R6HBSSAJammerGadget extends R6DemolitionsGadget;

function Fire (float fValue)
{
	if ( Pawn(Owner).Controller.m_bLockWeaponActions == False )
	{
		GotoState('ArmingCharge');
	}
}

simulated function PlaceChargeAnimation ()
{
	ServerPlaceChargeAnimation();
}

function ServerPlaceChargeAnimation ()
{
//	R6Pawn(Owner).SetNextPendingAction(PENDING_Coughing7);
}

function SetAmmoStaticMesh ()
{
//	m_FPWeapon.m_smGun.SetStaticMesh(StaticMesh'R61stHBSSAJ');
}

simulated function ServerPlaceCharge (Vector vLocation)
{
	local Rotator rDesiredRotation;
	local R6SAHeartBeatJammer aSAHeartBeatJammer;

	if ( m_iNbBulletsInWeapon == 0 )
	{
		return;
	}
	m_iNbBulletsInWeapon--;
	if ( m_iNbBulletsInWeapon == 0 )
	{
		m_bHide=True;
	}
	rDesiredRotation=Pawn(Owner).GetViewRotation();
	if ( bShowLog )
	{
		Log("aSAHeartBeatJammer :: ServerPlaceCharge() rDesiredRotation=" $ string(rDesiredRotation) $ " vLocation=" $ string(vLocation));
	}
	rDesiredRotation.Pitch=0;
	rDesiredRotation.Yaw += 32768;
	aSAHeartBeatJammer=Spawn(Class'R6SAHeartBeatJammer');
	aSAHeartBeatJammer.Instigator=None;
	aSAHeartBeatJammer.SetLocation(vLocation + vect(0.00,0.00,10.00));
	aSAHeartBeatJammer.SetRotation(rDesiredRotation);
	aSAHeartBeatJammer.SetSpeed(0.00);
}

state ArmingCharge
{
	function BeginState ()
	{
		if ( bShowLog )
		{
			Log(string(self) $ " entered state ArmingCharge...");
		}
		SetStaticMesh(m_ChargeStaticMesh);
		Pawn(Owner).AttachToBone(self,m_AttachPoint);
		m_bDetonated=False;
		if ( Pawn(Owner).Controller.bFire == 1 )
		{
			Fire(0.00);
		}
	}

	function Timer ()
	{
		local R6Pawn pawnOwner;

		pawnOwner=R6Pawn(Owner);
		if (  !pawnOwner.m_bIsPlayer || pawnOwner.m_bPostureTransition ||  !m_bInstallingCharge )
		{
			return;
		}
		if ( bShowLog )
		{
			Log(string(self) $ " state ArmingCharge : Timer() has expired " $ string(R6PlayerController(Pawn(Owner).Controller).m_bPlacedExplosive));
		}
		if ( R6PlayerController(Pawn(Owner).Controller).m_bPlacedExplosive )
		{
			ServerPlaceCharge(m_vLocation);
			m_bChargeInPosition=True;
			m_bInstallingCharge=False;
			if ( (Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer) )
			{
				if ( m_iNbBulletsInWeapon != 0 )
				{
					GotoState('GetNextCharge');
				}
				else
				{
					GotoState('NoChargesLeft');
				}
			}
		}
	}

	function Fire (float fValue)
	{
		local R6PlayerController PlayerCtrl;

		PlayerCtrl=R6PlayerController(R6Pawn(Owner).Controller);
		if ( m_bChargeInPosition ||  !m_bCanPlaceCharge || (PlayerCtrl.m_bLockWeaponActions == True) )
		{
			return;
		}
		if ( m_SingleFireStereoSnd != None )
		{
//			Owner.PlaySound(m_SingleFireStereoSnd,2);
		}
		PlayerCtrl.m_bLockWeaponActions=True;
		HideReticule();
		PlayerCtrl.GotoState('PlayerSetExplosive');
		PlaceChargeAnimation();
		m_vLocation=PlayerCtrl.m_vDefaultLocation;
		SetTimer(0.10,True);
		m_bInstallingCharge=True;
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('DiscardWeapon');
		}
	}

	function FirstPersonAnimOver ()
	{
		if ( m_bCancelChargeInstallation == True )
		{
			m_bCancelChargeInstallation=False;
			Pawn(Owner).Controller.m_bLockWeaponActions=False;
		}
	}

}

state GetNextCharge
{
	function BeginState ()
	{
		if ( bShowLog )
		{
			Log(string(self) $ " state HBSAJ GetNextCharge : beginState() ");
		}
		m_bChargeInPosition=False;
		m_bRaiseWeapon=False;
		SetTimer(0.10,True);
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('RaiseWeapon');
		}
		else
		{
			FirstPersonAnimOver();
		}
	}

	function FirstPersonAnimOver ()
	{
		m_bRaiseWeapon=True;
	}

	function Timer ()
	{
		if (  !m_bRaiseWeapon )
		{
			return;
		}
		if ( Pawn(Owner).Controller.bFire == 1 )
		{
			return;
		}
		GotoState('ArmingCharge');
	}

}

state RaiseWeapon
{
	function FirstPersonAnimOver ()
	{
		R6PlayerController(Pawn(Owner).Controller).ServerWeaponUpAnimDone();
		GotoState('ArmingCharge');
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("WEAPON - BeginState of RaiseWeapon for " $ string(self));
		}
		if ( m_FPHands != None )
		{
			m_FPHands.GotoState('RaiseWeapon');
			m_FPWeapon.m_smGun.bHidden=False;
		}
		else
		{
			FirstPersonAnimOver();
		}
		Pawn(Owner).Controller.m_bLockWeaponActions=True;
	}

	simulated function EndState ()
	{
		Pawn(Owner).Controller.m_bHideReticule=False;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

}

simulated event HideAttachment ()
{
	GotoState('NoChargesLeft');
	Super.HideAttachment();
}

event NbBulletChange ()
{
	if ( m_iNbBulletsInWeapon > 0 )
	{
		GotoState('GetNextCharge');
	}
	else
	{
		GotoState('NoChargesLeft');
	}
}

function bool CanSwitchToWeapon ()
{
	if ( m_iNbBulletsInWeapon > 0 )
	{
		return True;
	}
	else
	{
		return False;
	}
}

state NoChargesLeft
{
	function BeginState ()
	{
		if ( bShowLog )
		{
			Log(string(self) $ " HBSSAJammer state NoChargesLeft : BeginState()...");
		}
		Pawn(Owner).Controller.m_bHideReticule=True;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

}

defaultproperties
{
    m_iClipCapacity=1
    m_fMuzzleVelocity=1000.00
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripHBSSAJ'
    m_pFPWeaponClass=Class'R61stWeapons.R61stHBSSAJ'
    m_PawnWaitAnimLow=StandGrenade_nt
    m_PawnWaitAnimHigh=StandGrenade_nt
    m_PawnWaitAnimProne=ProneGrenade_nt
    m_PawnFiringAnim=CrouchClaymore
    m_PawnFiringAnimProne=ProneClaymore
    m_AttachPoint=TagSAHBSensorJammer
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=0.00,W=0.00)
    m_NameID="HBSSAJammerGadget"
}
/*
    m_ChargeStaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdHBSensorSA_Jamer'
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdHBSensorSA_Jamer'
*/

