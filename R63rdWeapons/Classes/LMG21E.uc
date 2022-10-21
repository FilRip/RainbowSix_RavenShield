//================================================================================
// LMG21E.
//================================================================================
class LMG21E extends R6MachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo762mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell762mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
    m_stWeaponCaps=>"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsLMG21E'
    m_pFPWeaponClass=Class'R61stWeapons.R61stLMG21E'
    m_vPositionOffset=(X=-3.00,Y=-0.50,Z=-1.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=128.00,W=0.00)
    m_NameID="LMG21E"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.MachineGuns.R63rd21E'
*/

