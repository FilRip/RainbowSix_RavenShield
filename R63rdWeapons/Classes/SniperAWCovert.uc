//================================================================================
// SniperAWCovert.
//================================================================================
class SniperAWCovert extends R6BoltActionSniperRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo762mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell762mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
    m_stWeaponCaps=7"   *"   ]"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripSniper'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSniperAWCovert'
    m_PawnWaitAnimLow=StandLMGLow_nt
    m_PawnWaitAnimHigh=StandLMGHigh_nt
    m_PawnWaitAnimProne=ProneSniper_nt
    m_PawnFiringAnim=StandFireAndBoltRifle
    m_PawnFiringAnimProne=ProneBipodFireAndBoltRifle
    m_PawnReloadAnimProne=ProneReloadSniper
    m_PawnReloadAnimProneTactical=ProneTacReloadSniper
    m_vPositionOffset=(X=-5.50,Y=0.50,Z=-1.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="SniperAWCovert"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SniperRifles.R63rdAWCovert'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

