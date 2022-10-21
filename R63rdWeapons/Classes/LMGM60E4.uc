//================================================================================
// LMGM60E4.
//================================================================================
class LMGM60E4 extends R6MachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo762mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell762mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash762mm'
    m_stWeaponCaps=>"   *"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsLMGM60E4'
    m_pFPWeaponClass=Class'R61stWeapons.R61stLMGM60E4'
    m_eGripType=1
    m_PawnWaitAnimLow=StandM60Low_nt
    m_PawnWaitAnimHigh=StandM60High_nt
    m_PawnFiringAnim=StandFireM60
    m_vPositionOffset=(X=-2.50,Y=-0.50,Z=-1.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=200.00,W=0.00)
    m_NameID="LMGM60E4"
}
/*
    m_HUDTexture=Texture'R6HUD.HUDElements'
    StaticMesh=StaticMesh'R63rdWeapons_SM.MachineGuns.R63rdM60E4'
*/

