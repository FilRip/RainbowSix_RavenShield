//================================================================================
// R6GrenadeWeapon.
//================================================================================
class R6GrenadeWeapon extends R6Gadget
	Native
	Abstract;

enum eGrenadeThrow {
	GRENADE_None,
	GRENADE_Throw,
	GRENADE_Roll,
	GRENADE_RemovePin,
	GRENADE_PeekLeft,
	GRENADE_PeekRight,
	GRENADE_PeekLeftThrow,
	GRENADE_PeekRightThrow
};

var eGrenadeThrow m_eThrow;
var bool m_bCanThrowGrenade;
var bool m_bFistPersonAnimFinish;
var bool m_bPinToRemove;
var bool m_bReadyToThrow;

replication
{
	reliable if ( Role == Role_Authority )
		ClientThrowGrenade;
	reliable if ( Role < Role_Authority )
		ServerSetGrenade;
	unreliable if ( Role < Role_Authority )
		ServerSetThrow,ServerImReadyToThrow;
}

simulated function PostBeginPlay ()
{
	local R6RainbowAI localRainbowAI;

	Super.PostBeginPlay();
	if ( m_pBulletClass != None )
	{
		SetStaticMesh(m_pBulletClass.Default.StaticMesh);
	}
	if ( Pawn(Owner) != None )
	{
		if ( Pawn(Owner).Controller != None )
		{
			localRainbowAI=R6RainbowAI(Pawn(Owner).Controller);
			if ( (localRainbowAI != None) && (localRainbowAI.m_TeamManager != None) )
			{
				localRainbowAI.m_TeamManager.UpdateTeamGrenadeStatus();
			}
		}
	}
}

function ServerImReadyToThrow (bool bReady)
{
	m_bReadyToThrow=bReady;
}

simulated function DropGrenade ()
{
	local R6Grenade aGrenade;
	local Vector vStart;

	if ( R6Pawn(Owner).m_bIsPlayer )
	{
//		vStart=R6Pawn(Owner).GetGrenadeStartLocation(m_eThrow);
	}
	else
	{
		vStart=R6Pawn(Owner).GetHandLocation();
	}
	aGrenade=R6Grenade(Spawn(m_pBulletClass,self,,vStart));
	aGrenade.Instigator=Pawn(Owner);
	aGrenade.SetSpeed(0.00);
}

simulated function StartFalling ()
{
	if ( m_iNbBulletsInWeapon != 0 )
	{
		if ( m_bReadyToThrow == True )
		{
			bHidden=True;
			if ( Level.NetMode != 3 )
			{
				DropGrenade();
			}
		}
		else
		{
			Super.StartFalling();
		}
	}
}

function float GetExplosionDelay ()
{
	if ( m_pBulletClass == None )
	{
		return 2.00;
	}
	else
	{
		return m_pBulletClass.Default.m_fExplosionDelay;
	}
}

function Fire (float fValue)
{
	GotoState('StandByToThrow');
}

function ServerSetThrow (eGrenadeThrow eThrow)
{
//	m_eThrow=eThrow;
}

state StandByToThrow
{
	function BeginState ()
	{
		local R6PlayerController PController;

		R6Pawn(Owner).m_bIsFiringState=False;
		if ( bShowLog )
		{
			Log("**** IN  STANDBY TO THROW *******");
		}
		if ( m_iNbBulletsInWeapon == 0 )
		{
			if ( bShowLog )
			{
				Log("**** No more Grenades, Autoswitch to Primary Weapon *******");
			}
			PController=R6PlayerController(Pawn(Owner).Controller);
			if ( PController != None )
			{
				PController.PrimaryWeapon();
			}
		}
	}

	function Fire (float fValue)
	{
		if ( bShowLog )
		{
			Log("StandByToThrow =" @ string(m_bCanThrowGrenade));
		}
		if ( (m_iNbBulletsInWeapon > 0) && m_bCanThrowGrenade )
		{
			if ( R6PlayerController(Pawn(Owner).Controller) != None )
			{
				Pawn(Owner).Controller.m_bLockWeaponActions=True;
				if ( R6Pawn(Owner).IsPeeking() &&  !R6Pawn(Owner).m_bIsProne )
				{
					if ( R6PlayerController(Pawn(Owner).Controller).m_bPeekLeft == 1 )
					{
//						m_eThrow=6;
					}
					else
					{
//						m_eThrow=7;
					}
				}
				else
				{
//					m_eThrow=1;
				}
			}
			ServerSetThrow(m_eThrow);
			GotoState('ReadyToThrow');
		}
	}

	function AltFire (float fValue)
	{
		if ( (m_iNbBulletsInWeapon > 0) && m_bCanThrowGrenade )
		{
			if ( R6PlayerController(Pawn(Owner).Controller) != None )
			{
				Pawn(Owner).Controller.m_bLockWeaponActions=True;
				if ( R6Pawn(Owner).IsPeeking() &&  !R6Pawn(Owner).m_bIsProne )
				{
					if ( R6PlayerController(Pawn(Owner).Controller).m_bPeekLeft == 1 )
					{
//						m_eThrow=4;
					}
					else
					{
//						m_eThrow=5;
					}
				}
				else
				{
//					m_eThrow=2;
				}
			}
			ServerSetThrow(m_eThrow);
			GotoState('ReadyToThrow');
		}
	}

	function FirstPersonAnimOver ()
	{
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

}

function ServerSetGrenade (eGrenadeThrow eGrenade)
{
	local R6Pawn pawnOwner;

	pawnOwner=R6Pawn(Owner);
	pawnOwner.m_ePlayerIsUsingHands=HANDS_None;
//	pawnOwner.m_eGrenadeThrow=eGrenade;
//	pawnOwner.m_eRepGrenadeThrow=eGrenade;
	pawnOwner.PlayWeaponAnimation();
	if ( bShowLog )
	{
		Log("ServerSetGrenade");
	}
}

state ReadyToThrow
{
	function Fire (float fValue)
	{
	}

	function AltFire (float fValue)
	{
	}

	function StopFire (optional bool bSoundOnly)
	{
	}

	function StopAltFire ()
	{
	}

	function BeginState ()
	{
		if ( bShowLog )
		{
			Log("**** IN  READY TO THROW *******");
		}
		R6Pawn(Owner).m_bIsFiringState=True;
		m_bFistPersonAnimFinish=True;
		ServerImReadyToThrow(True);
		m_bReadyToThrow=True;
		m_PawnWaitAnimLow='StandGrenade_nt';
		m_PawnWaitAnimHigh='StandGrenade_nt';
		m_PawnWaitAnimProne='ProneGrenade_nt';
		if ( R6Pawn(Owner).m_bIsPlayer )
		{
			if ( R6PlayerController(Pawn(Owner).Controller).bBehindView == False )
			{
				if ( m_FPHands != None )
				{
					m_bFistPersonAnimFinish=False;
					m_FPHands.GotoState('FiringWeapon');
					if ( bShowLog )
					{
						Log("Calling Fire SingleShot");
					}
					m_FPHands.FireSingleShot();
				}
			}
		}
		if ( m_bPinToRemove )
		{
//			ServerSetGrenade(3);
		}
	}

	function FirstPersonAnimOver ()
	{
		m_bFistPersonAnimFinish=True;
		if ( bShowLog )
		{
			Log("ReadyToThrow = FirstPersonAnimFinish");
		}
	}

	simulated function Tick (float fDeltaTime)
	{
		local R6Pawn pawnOwner;

		pawnOwner=R6Pawn(Owner);
		if ( (pawnOwner.Controller != None) && (pawnOwner.Controller.bFire == 0) && (pawnOwner.Controller.bAltFire == 0) && (pawnOwner.m_bWeaponTransition == False) && m_bFistPersonAnimFinish )
		{
			m_bCanThrowGrenade=False;
			m_bFistPersonAnimFinish=False;
			if ( bShowLog )
			{
				Log("!!!!!!!!!!!!!!! THROW GRENADE!!!!!!!!!!!!!!!");
			}
//			ServerSetGrenade(m_eThrow);
			if ( pawnOwner.m_bIsPlayer )
			{
				if ( R6PlayerController(pawnOwner.Controller).bBehindView == False )
				{
					if ( m_FPHands != None )
					{
						m_bFistPersonAnimFinish=False;
						if ( (m_eThrow == 1) || (m_eThrow == 6) || (m_eThrow == 7) )
						{
							m_FPHands.FireGrenadeThrow();
						}
						else
						{
							m_FPHands.FireGrenadeRoll();
						}
					}
				}
			}
			GotoState('WaitEndOfThrow');
		}
	}

}

state WaitEndOfThrow
{
	function Fire (float fValue)
	{
	}

	function AltFire (float fValue)
	{
	}

	function StopFire (optional bool bSoundOnly)
	{
	}

	function StopAltFire ()
	{
	}

	function FirstPersonAnimOver ()
	{
		m_bFistPersonAnimFinish=True;
		if ( bShowLog )
		{
			Log("ReadyToThrow = FirstPersonAnimFinish");
		}
	}

	simulated function Tick (float fDeltaTime)
	{
		if ( m_bFistPersonAnimFinish && m_bCanThrowGrenade )
		{
//			ServerSetGrenade(0);
			if ( bShowLog )
			{
				Log("ClientThrowGrenade()" @ string(m_iNbBulletsInWeapon));
			}
			if ( m_iNbBulletsInWeapon == 0 )
			{
				SetStaticMesh(None);
				m_PawnWaitAnimLow='StandNoGun_nt';
				m_PawnWaitAnimHigh='StandNoGun_nt';
				m_PawnWaitAnimProne='StandNoGun_nt';
				GotoState('NoGrenadeLeft');
			}
			else
			{
				if ( m_FPHands != None )
				{
					if ( m_FPHands.IsInState('RaiseWeapon') )
					{
						m_FPHands.BeginState();
					}
					else
					{
						m_FPHands.GotoState('RaiseWeapon');
					}
				}
			}
			GotoState('StandByToThrow');
		}
	}

	function BeginState ()
	{
		if ( bShowLog )
		{
			Log("WEAPON - BeginState of WaitEndOfThrow for " $ string(self));
		}
	}

}

state NoGrenadeLeft
{
	ignores  Fire;

	function StopFire (optional bool bSoundOnly)
	{
	}

	function AltFire (float fValue)
	{
	}

	function StopAltFire ()
	{
	}

	function BeginState ()
	{
		R6Pawn(Owner).m_bIsFiringState=False;
		if ( bShowLog )
		{
			Log(string(self) $ " state NoChargesLeft : BeginState()...");
		}
		Pawn(Owner).Controller.m_bHideReticule=True;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

}

function DestroyReticules ()
{
	local R6Reticule aReticule;

	aReticule=m_ReticuleInstance;
	m_ReticuleInstance=None;
	if ( aReticule != None )
	{
		aReticule.Destroy();
	}
}

function ThrowGrenade ()
{
	local Vector vStart;
	local Rotator rFiringDir;
	local R6Grenade aGrenade;
	local R6RainbowAI localRainbowAI;
	local R6Pawn pawnOwner;

	pawnOwner=R6Pawn(Owner);
	if ( m_iNbBulletsInWeapon > 0 )
	{
		m_iNbBulletsInWeapon--;
		if ( (m_iNbBulletsInWeapon == 0) && (pawnOwner != None) )
		{
			SetStaticMesh(None);
			localRainbowAI=R6RainbowAI(pawnOwner.Controller);
			if ( (localRainbowAI != None) && (localRainbowAI.m_TeamManager != None) )
			{
				localRainbowAI.m_TeamManager.UpdateTeamGrenadeStatus();
			}
		}
		GetFiringDirection(vStart,rFiringDir);
		if ( pawnOwner.m_bIsPlayer )
		{
//			vStart=pawnOwner.GetGrenadeStartLocation(m_eThrow);
		}
		else
		{
			vStart=pawnOwner.GetHandLocation();
		}
		aGrenade=R6Grenade(Spawn(m_pBulletClass,self,,vStart,rFiringDir));
		aGrenade.Instigator=pawnOwner;
		m_bReadyToThrow=False;
		if ( pawnOwner.m_bIsProne == True )
		{
			aGrenade.SetSpeed(m_fMuzzleVelocity * 0.50);
		}
		else
		{
			aGrenade.SetSpeed(m_fMuzzleVelocity);
		}
		ClientThrowGrenade();
	}
}

function ClientThrowGrenade ()
{
	m_bCanThrowGrenade=True;
}

state RaiseWeapon
{
	function FirstPersonAnimOver ()
	{
		if ( bShowLog )
		{
			Log("GRENADE - RaiseWeapon Calling SWUAD");
		}
		R6PlayerController(Pawn(Owner).Controller).ServerWeaponUpAnimDone();
		GotoState('StandByToThrow');
		R6Pawn(Owner).m_fWeaponJump=m_stAccuracyValues.fWeaponJump;
	}

	simulated function EndState ()
	{
		if ( bShowLog )
		{
			Log("GRENADE - Leaving state Raise Weapon");
		}
		Pawn(Owner).Controller.m_bHideReticule=False;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
		m_bCanThrowGrenade=True;
	}

	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("WEAPON - BeginState of RaiseWeapon for " $ string(self));
		}
		Pawn(Owner).Controller.m_bLockWeaponActions=True;
		if ( m_FPHands != None )
		{
			if ( m_FPHands.IsInState('RaiseWeapon') )
			{
				m_FPHands.BeginState();
			}
			else
			{
				m_FPHands.GotoState('RaiseWeapon');
			}
			m_FPWeapon.m_smGun.bHidden=False;
		}
		else
		{
			FirstPersonAnimOver();
		}
	}

}

state DiscardWeapon
{
	function Fire (float Value)
	{
	}

	function AltFire (float Value)
	{
	}

	function StopFire (optional bool bSoundOnly)
	{
	}

	function StopAltFire ()
	{
	}

	function PlayReloading ()
	{
	}

	simulated function BeginState ()
	{
		local Pawn aPawn;

		if ( bShowLog )
		{
			Log("IN:" @ string(self) @ "::DiscardWeapon::BeginState()");
		}
		if ( m_FPHands != None )
		{
			aPawn=Pawn(Owner);
			if ( aPawn.Controller != None )
			{
				aPawn.Controller.m_bLockWeaponActions=True;
				aPawn.Controller.m_bHideReticule=True;
			}
			if ( m_iNbBulletsInWeapon > 0 )
			{
				m_FPHands.GotoState('DiscardWeapon');
			}
			else
			{
				FirstPersonAnimOver();
			}
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

state PutWeaponDown
{
	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("WEAPON - " $ string(self) $ " - BeginState of PutWeaponDown for " $ string(self));
		}
		if ( m_FPHands != None )
		{
			if ( m_iNbBulletsInWeapon == 0 )
			{
				GotoState('NoGrenadeLeft');
			}
			else
			{
				if ( m_FPHands.IsInState('FiringWeapon') )
				{
					GotoState('None');
					return;
				}
				Pawn(Owner).Controller.m_bLockWeaponActions=True;
				m_FPHands.GotoState('PutWeaponDown');
			}
		}
	}

}

state BringWeaponUp
{
	simulated function BeginState ()
	{
		if ( bShowLog )
		{
			Log("WEAPON - " $ string(self) $ " - BeginState of BringWeaponUp for " $ string(self));
		}
		if ( m_FPHands != None )
		{
			if ( m_iNbBulletsInWeapon == 0 )
			{
				GotoState('NoGrenadeLeft');
			}
			else
			{
				m_FPHands.GotoState('BringWeaponUp');
			}
		}
		else
		{
			FirstPersonAnimOver();
		}
	}

	function FirstPersonAnimOver ()
	{
		if ( (Pawn(Owner).Controller != None) && (Pawn(Owner).Controller.bFire == 1) )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('StandByToThrow');
		}
	}

	simulated function EndState ()
	{
		m_bCanThrowGrenade=True;
		Pawn(Owner).Controller.m_bHideReticule=False;
		Pawn(Owner).Controller.m_bLockWeaponActions=False;
	}

}

function float GetSaveDistanceToThrow ()
{
	if ( m_pBulletClass.Default.m_fKillBlastRadius > 30 )
	{
		return m_pBulletClass.Default.m_fExplosionRadius;
	}
	else
	{
		return 0.00;
	}
}

simulated function WeaponInitialization (Pawn pawnOwner)
{
	Super.WeaponInitialization(pawnOwner);
	if ( Level.NetMode == NM_DedicatedServer )
	{
		return;
	}
	if ( m_iNbBulletsInWeapon == 0 )
	{
		HideAttachment();
	}
}

simulated event HideAttachment ()
{
	Super.HideAttachment();
	if ( bShowLog )
	{
		Log("***** HideAttachment for" @ string(self) @ "******");
	}
	SetDrawType(DT_None);
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

defaultproperties
{
    m_bCanThrowGrenade=True
    m_bPinToRemove=True
    m_iClipCapacity=3
    m_fMuzzleVelocity=1500.00
    m_pReticuleClass=Class'R6GrenadeReticule'
    m_stWeaponCaps=(bSingle=19007332,bThreeRound=0,bFullAuto=18,bCMag=1,bMuzzle=1,bSilencer=3553025,bLight=42,bMiniScope=6734724,bHeatVision=1)
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripGrenade'
    m_eWeaponType=6
    m_PawnWaitAnimLow=StandGrenade_nt
    m_PawnWaitAnimHigh=StandGrenade_nt
    m_PawnWaitAnimProne=ProneGrenade_nt
    m_AttachPoint=TagGrenadeHand
    bCollideWorld=True
}
/*
    m_ReloadSnd=Sound'Foley_CommonGrenade.Play_Grenade_Degoupille'
    m_BurstFireStereoSnd=Sound'Foley_CommonGrenade.Play_Grenade_Throw'
*/

