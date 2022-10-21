//================================================================================
// R61stHandsShotgunSPAS12.
//================================================================================
class R61stHandsShotgunSPAS12 extends R61stHandsShotgunM1;

function PostBeginPlay ()
{
//	LinkSkelAnim(MeshAnimation'R61stHandsShotgunSPAS12A');
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
					m_bReloadEmpty=False;
					R6AbstractWeapon(Owner).ServerPutBulletInShotgun();
					if ( Level.NetMode == NM_Client )
					{
						R6AbstractWeapon(Owner).ClientAddShell();
					}
					if ( (R6PlayerController(Pawn(Owner.Owner).Controller).m_bReloading == 1) && (R6AbstractWeapon(Owner).GetNbOfClips() != 0) )
					{
						PlayAnim('Reload_b');
						m_bReloadCycle=True;
						return;
					}
				}
				m_bReloadCycle=False;
				LoopAnim('Wait_c');
				GotoState('Waiting');
				R6AbstractWeapon(Owner).FirstPersonAnimOver();
			}
		}
	}

	simulated function BeginState ()
	{
		if ( m_bReloadEmpty == True )
		{
			AssociatedWeapon.PlayAnim(AssociatedWeapon.m_ReloadEmpty);
			PlayAnim('ReloadEmpty');
			m_bReloadEmpty=True;
		}
		else
		{
			PlayAnim('Reload_b');
			m_bReloadCycle=True;
		}
	}

}
