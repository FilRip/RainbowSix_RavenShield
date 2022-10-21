//================================================================================
// AssaultM14.
//================================================================================
class AssaultM14 extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo762mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell762mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
    m_stWeaponCaps=7"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultM14'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultM14'
    m_vPositionOffset=(X=5.50,Y=-0.50,Z=-1.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=32.00,W=0.00)
    m_NameID="AssaultM14"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdM14'
*/

