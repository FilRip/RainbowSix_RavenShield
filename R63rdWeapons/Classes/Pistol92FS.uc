//================================================================================
// Pistol92FS.
//================================================================================
class Pistol92FS extends R6Pistol
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellum'
    m_pEmptyShells=Class'R6SFX.R6Shell9mmParabellum'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash9mm'
    m_stWeaponCaps=7"   ="   <"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripPistol'
    m_pFPWeaponClass=Class'R61stWeapons.R61stPistol92FS'
    m_vPositionOffset=(X=0.00,Y=-5.00,Z=4.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="Pistol92FS"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Pistols.R63rd92FS'
*/

