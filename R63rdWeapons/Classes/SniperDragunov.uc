//================================================================================
// SniperDragunov.
//================================================================================
class SniperDragunov extends R6SniperRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo762x54mmR'
    m_pEmptyShells=Class'R6SFX.R6Shell762mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
    m_stWeaponCaps=7"   <"   *"   ]"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSniperDragunov'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSniperDragunov'
    m_PawnWaitAnimLow=StandLMGLow_nt
    m_PawnWaitAnimHigh=StandLMGHigh_nt
    m_PawnWaitAnimProne=ProneSniper_nt
    m_PawnFiringAnim=StandFireLmg
    m_PawnFiringAnimProne=ProneBipodFireSniper
    m_PawnReloadAnimProne=ProneReloadSniper
    m_PawnReloadAnimProneTactical=ProneTacReloadSniper
    m_vPositionOffset=(X=0.00,Y=0.00,Z=-2.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=256.00,W=0.00)
    m_NameID="SniperDragunov"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SniperRifles.R63rdDragunov'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

