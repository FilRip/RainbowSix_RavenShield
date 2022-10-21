//================================================================================
// SniperM82A1.
//================================================================================
class SniperM82A1 extends R6SniperRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo50calM33'
    m_pEmptyShells=Class'R6SFX.R6Shell50calM33'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash50M33'
    m_stWeaponCaps=7"   <"   *"   ]"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSniperM82A1'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSniperM82A1'
    m_PawnWaitAnimLow=StandLMGLow_nt
    m_PawnWaitAnimHigh=StandLMGHigh_nt
    m_PawnWaitAnimProne=ProneSniper_nt
    m_PawnFiringAnim=StandFireLmg
    m_PawnFiringAnimProne=ProneBipodFireSniper
    m_PawnReloadAnimProne=ProneReloadSniper
    m_PawnReloadAnimProneTactical=ProneTacReloadSniper
    m_vPositionOffset=(X=2.00,Y=-0.50,Z=-3.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=400.00,W=0.00)
    m_NameID="SniperM82A1"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SniperRifles.R63rdM82A1'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

