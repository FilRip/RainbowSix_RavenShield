//================================================================================
// AssaultAK47.
//================================================================================
class AssaultAK47 extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo762mmM43'
    m_pEmptyShells=Class'R6SFX.R6Shell762mmm43'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
    m_stWeaponCaps=7"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultAK47'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultAK47'
    m_vPositionOffset=(X=-6.50,Y=-1.00,Z=-0.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=96.00,W=0.00)
    m_NameID="AssaultAK47"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdAK47'
*/

