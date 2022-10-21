//================================================================================
// PistolMicroUzi.
//================================================================================
class PistolMicroUzi extends R6Pistol
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellum'
    m_pEmptyShells=Class'R6SFX.R6Shell9mmParabellum'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash9mm'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsPistolMicroUzi'
    m_pFPWeaponClass=Class'R61stWeapons.R61stPistolMicroUzi'
    m_eGripType=6
    m_PawnWaitAnimLow=StandUZILow_nt
    m_PawnWaitAnimHigh=StandUZIHigh_nt
    m_PawnWaitAnimProne=ProneUZI_nt
    m_PawnFiringAnim=StandFireUZI
    m_PawnFiringAnimProne=ProneFireUZI
    m_vPositionOffset=(X=-0.50,Y=-4.00,Z=3.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="PistolMicroUzi"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Pistols.R63rdPistolMicroUzi'
    m_stWeaponCaps=7"   >"   ="   *"
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

