//================================================================================
// R61stHandsShotgunM1.
//================================================================================
class R61stHandsShotgunM1 extends R61stHandsGripShotgun;

var bool m_bReloadCycle;
var bool m_bPlayedEnd;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsShotgunM1A');
	Super.PostBeginPlay();
}

state Reloading
{
	function EndState ()
	{
	}

	simulated event AnimEnd (int Channel)
	{
		if ( Channel == 0 )
		{
			if ( m_bReloadCycle == True )
			{
				R6AbstractWeapon(Owner).ServerPutBulletInShotgun();
				if ( Level.NetMode == NM_Client )
				{
					R6AbstractWeapon(Owner).ClientAddShell();
				}
				if ( (R6PlayerController(Pawn(Owner.Owner).Controller).m_bReloading == 1) && (R6AbstractWeapon(Owner).GetNbOfClips() != 0) &&  !R6AbstractWeapon(Owner).GunIsFull() )
				{
					R6Pawn(Owner.Owner).ServerPlayReloadAnimAgain();
					PlayAnim('Reload_c');
				}
				else
				{
					PlayAnim('Reload_e');
					m_bReloadCycle=False;
				}
			}
			else
			{
				if ( m_bReloadEmpty == True )
				{
					if ( m_bPlayedEnd == False )
					{
						R6AbstractWeapon(Owner).ServerPutBulletInShotgun();
						if ( Level.NetMode == NM_Client )
						{
							R6AbstractWeapon(Owner).ClientAddShell();
						}
						PlayAnim('Reload_e');
						m_bPlayedEnd=True;
					}
					else
					{
						AssociatedWeapon.PlayAnim(AssociatedWeapon.m_ReloadEmpty);
						PlayAnim('ReloadEmpty');
						m_bReloadEmpty=False;
					}
				}
				else
				{
					if ( (R6PlayerController(Pawn(Owner.Owner).Controller).m_bReloading == 1) && (R6AbstractWeapon(Owner).GetNbOfClips() != 0) &&  !R6AbstractWeapon(Owner).GunIsFull() )
					{
						PlayAnim('Reload_b');
						m_bReloadCycle=True;
					}
					else
					{
						LoopAnim('Wait_c');
						GotoState('Waiting');
						R6AbstractWeapon(Owner).FirstPersonAnimOver();
					}
				}
			}
		}
	}

	simulated function BeginState ()
	{
		PlayAnim('Reload_b');
		if ( m_bReloadEmpty == False )
		{
			m_bReloadCycle=True;
		}
		else
		{
			m_bPlayedEnd=False;
		}
	}

}
