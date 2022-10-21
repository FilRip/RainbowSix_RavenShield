//================================================================================
// PistolSR2.
//================================================================================
class PistolSR2 extends R6Pistol
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9x21mmR'
    m_pEmptyShells=Class'R6SFX.R6Shell9x21mmR'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash9mm'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsPistolSR2'
    m_pFPWeaponClass=Class'R61stWeapons.R61stPistolSR2'
    m_eGripType=6
    m_PawnWaitAnimLow=StandUZILow_nt
    m_PawnWaitAnimHigh=StandUZIHigh_nt
    m_PawnWaitAnimProne=ProneUZI_nt
    m_PawnFiringAnim=StandFireUZI
    m_PawnFiringAnimProne=ProneFireUZI
    m_vPositionOffset=(X=-6.50,Y=-5.00,Z=5.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=200.00,W=0.00)
    m_NameID="PistolSR2"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Pistols.R63rdPistolSR2'
    m_stWeaponCaps=7"   >"   ="   *"
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

