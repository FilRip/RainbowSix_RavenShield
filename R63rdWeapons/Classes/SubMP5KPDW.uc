//================================================================================
// SubMP5KPDW.
//================================================================================
class SubMP5KPDW extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellum'
    m_pEmptyShells=Class'R6SFX.R6Shell9mmParabellum'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlashSub'
    m_stWeaponCaps=7"   Q"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSubMp5KPDW'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubMp5KPDW'
    m_eGripType=1
    m_PawnWaitAnimLow=StandAugLow_nt
    m_PawnWaitAnimHigh=StandAugHigh_nt
    m_PawnWaitAnimProne=ProneAug_nt
    m_PawnFiringAnim=StandFireAug
    m_PawnFiringAnimProne=ProneFireAug
    m_PawnReloadAnim=StandReloadAug
    m_PawnReloadAnimTactical=StandTacReloadAug
    m_PawnReloadAnimProne=ProneReloadAug
    m_PawnReloadAnimProneTactical=ProneTacReloadAug
    m_vPositionOffset=(X=-5.00,Y=-4.50,Z=4.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=400.00,W=0.00)
    m_NameID="SubMP5KPDW"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdMp5KPDW'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

