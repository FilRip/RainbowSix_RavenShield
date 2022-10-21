//================================================================================
// SubCZ61.
//================================================================================
class SubCZ61 extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo765mmAuto'
    m_pEmptyShells=Class'R6SFX.R6Shell765mmAuto'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlashSub'
    m_stWeaponCaps=7"   >"   ="   <"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSubCZ61'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubCZ61'
    m_eGripType=4
    m_bUseMicroAnim=True
    m_PawnWaitAnimLow=StandP90Low_nt
    m_PawnWaitAnimHigh=StandP90High_nt
    m_PawnWaitAnimProne=ProneP90_nt
    m_PawnFiringAnim=StandFireP90
    m_PawnFiringAnimProne=ProneFireP90
    m_vPositionOffset=(X=-2.50,Y=-4.50,Z=6.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=400.00,W=0.00)
    m_NameID="SubCZ61"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdSubCZ61'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

