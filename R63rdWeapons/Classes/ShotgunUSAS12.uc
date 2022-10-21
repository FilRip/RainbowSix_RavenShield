//================================================================================
// ShotgunUSAS12.
//================================================================================
class ShotgunUSAS12 extends R6Shotgun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo12gauge'
    m_pEmptyShells=Class'R6SFX.R6Shell12GaugeBuck'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash12Gauge'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsShotgunUSAS12'
    m_pFPWeaponClass=Class'R61stWeapons.R61stShotgunUSAS12'
    m_vPositionOffset=(X=-1.50,Y=-3.50,Z=3.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=200.00,W=0.00)
    m_NameID="ShotgunUSAS12"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    m_stWeaponCaps=7"   >"   *"   G"
    StaticMesh=StaticMesh'R63rdWeapons_SM.Shotguns.R63rdUSAS12'
*/

