//================================================================================
// SubMTAR21.
//================================================================================
class SubMTAR21 extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellum'
    m_pEmptyShells=Class'R6SFX.R6Shell9mmParabellum'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlashSub'
    m_stWeaponCaps=7"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSubMTAR21'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubMTAR21'
    m_eGripType=4
    m_PawnWaitAnimLow=StandP90Low_nt
    m_PawnWaitAnimHigh=StandP90High_nt
    m_PawnWaitAnimProne=ProneP90_nt
    m_PawnFiringAnim=StandFireP90
    m_PawnFiringAnimProne=ProneFireP90
    m_PawnReloadAnim=StandReloadAug
    m_PawnReloadAnimTactical=StandTacReloadAug
    m_PawnReloadAnimProne=ProneReloadAug
    m_PawnReloadAnimProneTactical=ProneTacReloadAug
    m_vPositionOffset=(X=-5.50,Y=-4.50,Z=5.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=200.00,W=0.00)
    m_NameID="SubMTAR21"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdMTAR21'
    m_WithScopeSM=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdMTAR21ForScope'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

