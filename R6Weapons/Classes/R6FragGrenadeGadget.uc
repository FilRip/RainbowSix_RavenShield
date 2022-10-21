//================================================================================
// R6FragGrenadeGadget.
//================================================================================
class R6FragGrenadeGadget extends R6GrenadeWeapon;

function ServerSetGrenade (eGrenadeThrow eGrenade)
{
	if ( Level.IsGameTypeTeamAdversarial(Level.Game.m_eGameTypeFlag) || Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
	{
		if ( (eGrenade != 3) && (eGrenade != 0) )
		{
//			R6PlayerController(Pawn(Owner).Controller).m_TeamManager.m_MultiCommonVoicesMgr.PlayMultiCommonVoices(R6Pawn(Owner),0);
		}
	}
	Super.ServerSetGrenade(eGrenade);
}

defaultproperties
{
    m_pBulletClass=Class'R6FragGrenade'
    m_pFPWeaponClass=Class'R61stWeapons.R61stGrenadeHE'
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=-131072.56,W=0.00)
    m_NameID="FragGrenadeGadget"
}
/*
    m_EquipSnd=Sound'Foley_FragGrenade.Play_Frag_Equip'
    m_UnEquipSnd=Sound'Foley_FragGrenade.Play_Frag_Unequip'
    m_SingleFireStereoSnd=Sound'Grenade_Frag.Play_random_Frag_Expl_Metal'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

