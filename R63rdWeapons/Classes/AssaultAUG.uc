//================================================================================
// AssaultAUG.
//================================================================================
class AssaultAUG extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo556mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell556mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   >"   ="   <"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripAUG'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultAUG'
    m_eGripType=1
    m_fMaxZoom=2.50
    m_PawnWaitAnimLow=StandAugLow_nt
    m_PawnWaitAnimHigh=StandAugHigh_nt
    m_PawnWaitAnimProne=ProneAug_nt
    m_PawnFiringAnim=StandFireAug
    m_PawnFiringAnimProne=ProneFireAug
    m_PawnReloadAnim=StandReloadAug
    m_PawnReloadAnimTactical=StandTacReloadAug
    m_PawnReloadAnimProne=ProneReloadAug
    m_PawnReloadAnimProneTactical=ProneTacReloadAug
    m_vPositionOffset=(X=-2.50,Y=-3.50,Z=4.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=300.00,W=0.00)
    m_NameID="AssaultAUG"
}
/*
    m_ScopeTexture=Texture'Inventory_t.Scope.ScopeBlurTex_Aug'
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdAUG'
*/

