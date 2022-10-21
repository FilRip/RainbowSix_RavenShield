//================================================================================
// R6FalseHBGadget.
//================================================================================
class R6FalseHBGadget extends R6GrenadeWeapon;

function ThrowGrenade ()
{
	local Vector vStart;
	local Rotator rFiringDir;
	local R6Pawn pawnOwner;
	local R6FalseHeartBeat aFalseHeartBeat;

	pawnOwner=R6Pawn(Owner);
	if ( m_iNbBulletsInWeapon > 0 )
	{
		m_iNbBulletsInWeapon--;
		if ( m_iNbBulletsInWeapon == 0 )
		{
			SetStaticMesh(None);
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
		aFalseHeartBeat=Spawn(Class'R6FalseHeartBeat',self,,vStart,rFiringDir);
		aFalseHeartBeat.Instigator=None;
//		aFalseHeartBeat.m_HeartBeatPuckOwner=Pawn(Owner);
		if ( pawnOwner.m_bIsProne == True )
		{
			aFalseHeartBeat.SetSpeed(m_fMuzzleVelocity * 0.50);
		}
		else
		{
			aFalseHeartBeat.SetSpeed(m_fMuzzleVelocity);
		}
		ClientThrowGrenade();
	}
}

defaultproperties
{
    m_bPinToRemove=False
    m_fMuzzleVelocity=1000.00
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripFalseHBPuck'
    m_pFPWeaponClass=Class'R61stWeapons.R61stFalseHBPuck'
    m_AttachPoint=TagHBPuck
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=353.00,W=0.00)
    m_NameID="FalseHBGadget"
    DrawScale=1.10
}
/*
    m_EquipSnd=Sound'Foley_FragGrenade.Play_Frag_Equip'
    m_UnEquipSnd=Sound'Foley_FragGrenade.Play_Frag_Unequip'
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Items.R63rdFalseHBPuck'
*/

