//================================================================================
// SniperWA2000.
//================================================================================
class SniperWA2000 extends R6SniperRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo30calMagnum'
    m_pEmptyShells=Class'R6SFX.R6Shell762mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
    m_stWeaponCaps=7"   <"   *"   ]"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSniperWA2000'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSniperWA2000'
    m_PawnWaitAnimLow=StandLMGLow_nt
    m_PawnWaitAnimHigh=StandLMGHigh_nt
    m_PawnWaitAnimProne=ProneSniper_nt
    m_PawnFiringAnim=StandFireLmg
    m_PawnFiringAnimProne=ProneBipodFireSniper
    m_PawnReloadAnim=StandReloadAug
    m_PawnReloadAnimTactical=StandTacReloadAug
    m_PawnReloadAnimProne=ProneReloadAug
    m_PawnReloadAnimProneTactical=ProneTacReloadAug
    m_vPositionOffset=(X=-2.00,Y=0.50,Z=-5.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=224.00,W=0.00)
    m_NameID="SniperWA2000"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SniperRifles.R63rdWA2000'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

