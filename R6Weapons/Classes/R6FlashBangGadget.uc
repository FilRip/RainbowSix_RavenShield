//================================================================================
// R6FlashBangGadget.
//================================================================================
class R6FlashBangGadget extends R6GrenadeWeapon;

function ServerSetGrenade (eGrenadeThrow eGrenade)
{
	if ( Level.IsGameTypeTeamAdversarial(Level.Game.m_eGameTypeFlag) || Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
	{
		if ( (eGrenade != 3) && (eGrenade != 0) )
		{
//			R6PlayerController(Pawn(Owner).Controller).m_TeamManager.m_MultiCommonVoicesMgr.PlayMultiCommonVoices(R6Pawn(Owner),1);
		}
	}
	Super.ServerSetGrenade(eGrenade);
}

defaultproperties
{
    m_pBulletClass=Class'R6FlashBang'
    m_pFPWeaponClass=Class'R61stWeapons.R61stGrenadeFlashBang'
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=386.00,W=0.00)
    m_NameID="FlashBangGadget"
}
/*
    m_EquipSnd=Sound'Foley_SmokeGrenade.Play_Smoke_Equip'
    m_UnEquipSnd=Sound'Foley_SmokeGrenade.Play_Smoke_Unequip'
    m_SingleFireStereoSnd=Sound'Grenade_FlashBang.Play_FlashBang_Expl'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

