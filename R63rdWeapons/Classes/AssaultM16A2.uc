//================================================================================
// AssaultM16A2.
//================================================================================
class AssaultM16A2 extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo556mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell556mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   Q"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultM16A2'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultM16A2'
    m_vPositionOffset=(X=1.00,Y=-1.50,Z=-1.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=400.00,W=0.00)
    m_NameID="AssaultM16A2"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdM16A2'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

