//================================================================================
// PistolMac119.
//================================================================================
class PistolMac119 extends R6Pistol
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellum'
    m_pEmptyShells=Class'R6SFX.R6Shell9mmParabellum'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash9mm'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsPistolMac119'
    m_pFPWeaponClass=Class'R61stWeapons.R61stPistolMac119'
    m_eGripType=6
    m_PawnWaitAnimLow=StandUZILow_nt
    m_PawnWaitAnimHigh=StandUZIHigh_nt
    m_PawnWaitAnimProne=ProneUZI_nt
    m_PawnFiringAnim=StandFireUZI
    m_PawnFiringAnimProne=ProneFireUZI
    m_vPositionOffset=(X=-9.00,Y=-5.00,Z=6.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=200.00,W=0.00)
    m_NameID="PistolMac119"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    m_stWeaponCaps=>"   ="   *"
    StaticMesh=StaticMesh'R63rdWeapons_SM.Pistols.R63rdPistolMac119'
*/

