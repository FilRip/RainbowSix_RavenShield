//================================================================================
// SubSR2.
//================================================================================
class SubSR2 extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9x21mmR'
    m_pEmptyShells=Class'R6SFX.R6Shell9x21mmR'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlashSub'
    m_stWeaponCaps=7"   >"   ="   <"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSubSR2'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubSR2'
    m_eGripType=6
    m_bUseMicroAnim=True
    m_PawnWaitAnimLow=StandUZILow_nt
    m_PawnWaitAnimHigh=StandUZIHigh_nt
    m_PawnWaitAnimProne=ProneUZI_nt
    m_PawnFiringAnim=StandFireUZI
    m_PawnFiringAnimProne=ProneFireUZI
    m_PawnReloadAnim=StandReloadHandGun
    m_PawnReloadAnimTactical=StandReloadHandGun
    m_PawnReloadAnimProne=ProneReloadHandGun
    m_PawnReloadAnimProneTactical=ProneReloadHandGun
    m_vPositionOffset=(X=0.00,Y=-4.00,Z=5.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=288.00,W=0.00)
    m_NameID="SubSR2"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdSubSR2'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

