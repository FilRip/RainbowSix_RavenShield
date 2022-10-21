//================================================================================
// AssaultG36K.
//================================================================================
class AssaultG36K extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pWithWeaponReticuleClass=Class'R6Weapons.R6WithWeaponDotReticule'
    m_pBulletClass=Class'R6Weapons.ammo556mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell556mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   Q"   >"   ="   <"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultG36K'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultG36K'
    m_fMaxZoom=2.50
    m_vPositionOffset=(X=9.50,Y=-0.50,Z=-3.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=400.00,W=0.00)
    m_NameID="AssaultG36K"
}
/*
    m_ScopeTexture=Texture'Inventory_t.Scope.ScopeBlurTex_TAR'
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdG36K'
*/

