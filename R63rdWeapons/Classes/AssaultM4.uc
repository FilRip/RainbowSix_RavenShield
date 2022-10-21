//================================================================================
// AssaultM4.
//================================================================================
class AssaultM4 extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo556mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell556mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultM4'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultM4'
    m_vPositionOffset=(X=-1.50,Y=-1.00,Z=1.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=300.00,W=0.00)
    m_NameID="AssaultM4"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdM4wHandle'
    m_stWeaponCaps=7"   >"   ="   <"   *"   G"
    m_WithScopeSM=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdM4'
*/

