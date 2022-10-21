//================================================================================
// AssaultFNC.
//================================================================================
class AssaultFNC extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo556mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell556mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultFNC'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultFNC'
    m_vPositionOffset=(X=11.50,Y=-1.00,Z=0.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=64.00,W=0.00)
    m_NameID="AssaultFNC"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdFNC'
*/

