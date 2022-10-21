//================================================================================
// PistolUSP.
//================================================================================
class PistolUSP extends R6Pistol
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo40calAuto'
    m_pEmptyShells=Class'R6SFX.R6Shell40calAuto'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash9mm'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripPistol'
    m_pFPWeaponClass=Class'R61stWeapons.R61stPistolUSP'
    m_vPositionOffset=(X=0.00,Y=-5.00,Z=4.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="PistolUSP"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.Pistols.R63rdUSP'
    m_HUDTexture=Texture'R6HUD.HUDElements'
    m_stWeaponCaps=7"   ="   <"   *"
*/

