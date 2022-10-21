//================================================================================
// R6PumpShotgun.
//================================================================================
class R6PumpShotgun extends R6Shotgun
	Abstract;

simulated function bool GunIsFull ()
{
	return m_iNbBulletsInWeapon >= m_iClipCapacity;
}

simulated function bool IsPumpShotGun ()
{
	return True;
}

function ClientAddShell ()
{
	m_iNbBulletsInWeapon++;
}

simulated function AddClips (int iNbOfExtraClips)
{
	m_iCurrentNbOfClips += iNbOfExtraClips;
	if ( Level.NetMode == NM_Client )
	{
		ServerAddClips();
	}
}

function ServerPutBulletInShotgun ()
{
	if (  !GunIsFull() )
	{
		m_iNbBulletsInWeapon++;
		if (  !m_bUnlimitedClip )
		{
			m_iCurrentNbOfClips--;
		}
		if ( m_ReloadSnd != None )
		{
			Owner.PlaySound(m_ReloadSnd);
		}
	}
}

state Reloading
{
	function FirstPersonAnimOver ()
	{
		if ( bShowLog )
		{
			Log("SHOTGUN - FPAOver");
		}
		if ( Pawn(Owner).Controller.bFire == 1 )
		{
			GotoState('NormalFire');
		}
		else
		{
			GotoState('None');
		}
	}

	simulated function ChangeClip ()
	{
		if ( bShowLog )
		{
			Log("SHOTGUN - ChangeClip");
		}
		ServerPutBulletInShotgun();
	}

	function EndState ()
	{
		local R6Pawn pawnOwner;
		local R6PlayerController PlayerCtrl;

		pawnOwner=R6Pawn(Owner);
		PlayerCtrl=R6PlayerController(pawnOwner.Controller);
		if ( bShowLog )
		{
			Log("SHOTGUN - Leaving State Reloading");
		}
		pawnOwner.ServerSwitchReloadingWeapon(False);
		if ( PlayerCtrl != None )
		{
			PlayerCtrl.m_iPlayerCAProgress=0;
			PlayerCtrl.m_bHideReticule=False;
		}
	}

	simulated function BeginState ()
	{
		local R6Pawn pawnOwner;
		local R6PlayerController PlayerCtrl;

		pawnOwner=R6Pawn(Owner);
		PlayerCtrl=R6PlayerController(pawnOwner.Controller);
		if ( bShowLog )
		{
			Log("SHOTGUN - Begin State Reloading! " $ string(GetNbOfClips()));
		}
		if ( (GetNbOfClips() > 0) &&  !GunIsFull() )
		{
			ServerStartChangeClip();
			if ( pawnOwner.m_bIsPlayer )
			{
				if ( PlayerCtrl.bBehindView == False )
				{
					if ( m_iNbBulletsInWeapon == 0 )
					{
						m_FPHands.m_bReloadEmpty=True;
					}
					m_FPHands.GotoState('Reloading');
					PlayerCtrl.m_iPlayerCAProgress=0;
					PlayerCtrl.m_bHideReticule=True;
				}
			}
		}
		else
		{
			GotoState('None');
		}
	}

	function int GetReloadProgress ()
	{
		local name Anim;
		local float fFrame;
		local float fRate;

		m_FPHands.GetAnimParams(0,Anim,fFrame,fRate);
		if ( Anim != 'Reload_e' )
		{
			return fFrame * 110;
		}
		else
		{
			return 0;
		}
	}

	event Tick (float fDeltaTime)
	{
		local R6PlayerController PlayerCtrl;

		PlayerCtrl=R6PlayerController(R6Pawn(Owner).Controller);
		if ( (PlayerCtrl != None) && (PlayerCtrl.m_bUseFirstPersonWeapon == False) )
		{
			PlayerCtrl.m_iPlayerCAProgress=GetReloadProgress();
		}
	}

}

state NormalFire
{
	function Fire (float Value)
	{
	}

	function EndState ()
	{
		Pawn(Owner).ServerFinishShotgunAnimation();
		Super.EndState();
	}

}

defaultproperties
{
    m_PawnReloadAnim=StandReloadEmptyShotGun
    m_PawnReloadAnimTactical=StandReloadShotGun
    m_PawnReloadAnimProne=ProneReloadEmptyShotGun
    m_PawnReloadAnimProneTactical=ProneReloadShotGun
}
