//================================================================================
// SubUzi.
//================================================================================
class SubUzi extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellum'
    m_pEmptyShells=Class'R6SFX.R6Shell9mmParabellum'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlashSub'
    m_stWeaponCaps=7"   >"   ="   <"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripUZI'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubUzi'
    m_eGripType=2
    m_bUseMicroAnim=True
    m_PawnWaitAnimLow=StandBullPupLow_nt
    m_PawnWaitAnimHigh=StandBullPupHigh_nt
    m_PawnWaitAnimProne=ProneBullPup_nt
    m_PawnFiringAnim=StandFireBullPup
    m_PawnFiringAnimProne=ProneFireBullPup
    m_PawnReloadAnim=StandReloadHandGun
    m_PawnReloadAnimTactical=StandReloadHandGun
    m_PawnReloadAnimProne=ProneReloadHandGun
    m_PawnReloadAnimProneTactical=ProneReloadHandGun
    m_vPositionOffset=(X=-0.50,Y=-2.50,Z=3.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=200.00,W=0.00)
    m_NameID="SubUzi"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdUzi'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

