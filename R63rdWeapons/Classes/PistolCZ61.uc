//================================================================================
// PistolCZ61.
//================================================================================
class PistolCZ61 extends R6Pistol
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo765mmAuto'
    m_pEmptyShells=Class'R6SFX.R6Shell765mmAuto'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash9mm'
    m_stWeaponCaps=7"   >"   ="   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsPistolCZ61'
    m_pFPWeaponClass=Class'R61stWeapons.R61stPistolCZ61'
    m_eGripType=4
    m_PawnWaitAnimLow=StandP90Low_nt
    m_PawnWaitAnimHigh=StandP90High_nt
    m_PawnWaitAnimProne=ProneP90_nt
    m_PawnFiringAnim=StandFireP90
    m_PawnFiringAnimProne=ProneFireP90
    m_PawnReloadAnim=StandReloadSubGun
    m_PawnReloadAnimTactical=StandTacReloadSubGun
    m_PawnReloadAnimProne=ProneReloadSubGun
    m_PawnReloadAnimProneTactical=ProneTacReloadSubGun
    m_vPositionOffset=(X=-3.50,Y=-4.50,Z=6.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=400.00,W=0.00)
    m_NameID="PistolCZ61"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Pistols.R63rdPistolCZ61'
*/

