//================================================================================
// SubM12S.
//================================================================================
class SubM12S extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellum'
    m_pEmptyShells=Class'R6SFX.R6Shell9mmParabellum'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlashSub'
    m_stWeaponCaps=7"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSubM12S'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubM12S'
    m_eGripType=1
    m_PawnWaitAnimLow=StandAugLow_nt
    m_PawnWaitAnimHigh=StandAugHigh_nt
    m_PawnWaitAnimProne=ProneAug_nt
    m_PawnFiringAnim=StandFireAug
    m_PawnFiringAnimProne=ProneFireAug
    m_vPositionOffset=(X=3.50,Y=-4.00,Z=5.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=300.00,W=0.00)
    m_NameID="SubM12S"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdM12S'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

