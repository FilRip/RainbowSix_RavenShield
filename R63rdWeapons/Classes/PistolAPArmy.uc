//================================================================================
// PistolAPArmy.
//================================================================================
class PistolAPArmy extends R6Pistol
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo57x28mm'
    m_pEmptyShells=Class'R6SFX.R6Shell57mm'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   ="   <"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripPistol'
    m_pFPWeaponClass=Class'R61stWeapons.R61stPistolAPArmy'
    m_vPositionOffset=(X=-0.50,Y=-4.50,Z=4.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=192.00,W=0.00)
    m_NameID="PistolAPArmy"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.Pistols.R63rdAPArmy'
*/

