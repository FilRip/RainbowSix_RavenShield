//================================================================================
// AssaultL85A1.
//================================================================================
class AssaultL85A1 extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo556mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell556mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   Q"   >"   ="   <"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultL85A1'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultL85A1'
    m_eGripType=2
    m_fMaxZoom=2.50
    m_PawnWaitAnimLow=StandBullPupLow_nt
    m_PawnWaitAnimHigh=StandBullPupHigh_nt
    m_PawnWaitAnimProne=ProneBullPup_nt
    m_PawnFiringAnim=StandFireBullPup
    m_PawnFiringAnimProne=ProneFireBullPup
    m_PawnReloadAnim=StandReloadAug
    m_PawnReloadAnimTactical=StandTacReloadAug
    m_PawnReloadAnimProne=ProneReloadAug
    m_PawnReloadAnimProneTactical=ProneTacReloadAug
    m_vPositionOffset=(X=-2.50,Y=-3.00,Z=1.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="AssaultL85A1"
}
/*
    m_ScopeTexture=Texture'Inventory_t.Scope.ScopeBlurTex_Aug'
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdL85A1'
*/

