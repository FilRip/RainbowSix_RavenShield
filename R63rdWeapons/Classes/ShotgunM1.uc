//================================================================================
// ShotgunM1.
//================================================================================
class ShotgunM1 extends R6PumpShotgun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo12gauge'
    m_pEmptyShells=Class'R6SFX.R6Shell12GaugeBuck'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash12Gauge'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsShotgunM1'
    m_pFPWeaponClass=Class'R61stWeapons.R61stShotgunM1'
    m_vPositionOffset=(X=-13.80,Y=-2.50,Z=6.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=400.00,W=0.00)
    m_NameID="ShotgunM1"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    m_stWeaponCaps=7"   *"   G"
    StaticMesh=StaticMesh'R63rdWeapons_SM.Shotguns.R63rdM1'
*/

