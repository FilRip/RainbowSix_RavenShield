//================================================================================
// R6TearGasGrenadeGadget.
//================================================================================
class R6TearGasGrenadeGadget extends R6GrenadeWeapon;

function ServerSetGrenade (eGrenadeThrow eGrenade)
{
	if ( Level.IsGameTypeTeamAdversarial(Level.Game.m_eGameTypeFlag) || Level.IsGameTypeCooperative(Level.Game.m_eGameTypeFlag) )
	{
		if ( (eGrenade != 3) && (eGrenade != 0) )
		{
//			R6PlayerController(Pawn(Owner).Controller).m_TeamManager.m_MultiCommonVoicesMgr.PlayMultiCommonVoices(R6Pawn(Owner),2);
		}
	}
	Super.ServerSetGrenade(eGrenade);
}

defaultproperties
{
    m_pBulletClass=Class'R6TearGasGrenade'
    m_pFPWeaponClass=Class'R61stWeapons.R61stGrenadeTearGas'
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=131072.56,W=0.00)
    m_NameID="TearGasGrenadeGadget"
}
/*
    m_EquipSnd=Sound'Foley_SmokeGrenade.Play_Smoke_Equip'
    m_UnEquipSnd=Sound'Foley_SmokeGrenade.Play_Smoke_Unequip'
    m_SingleFireStereoSnd=Sound'Grenade_Gas.Play_GasGrenade_Expl'
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Grenades.R63rdGrenadeTearGas'
*/

