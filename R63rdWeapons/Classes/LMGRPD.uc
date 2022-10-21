//================================================================================
// LMGRPD.
//================================================================================
class LMGRPD extends R6MachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo762mmM43'
    m_pEmptyShells=Class'R6SFX.R6Shell762mmm43'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
    m_stWeaponCaps=>"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsLMGRPD'
    m_pFPWeaponClass=Class'R61stWeapons.R61stLMGRPD'
    m_vPositionOffset=(X=-9.50,Y=-1.50,Z=2.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="LMGRPD"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.MachineGuns.R63rdRPD'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

