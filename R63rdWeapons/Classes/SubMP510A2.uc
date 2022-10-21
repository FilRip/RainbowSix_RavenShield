//================================================================================
// SubMP510A2.
//================================================================================
class SubMP510A2 extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo10mmAuto'
    m_pEmptyShells=Class'R6SFX.R6Shell10mmAuto'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlashSub'
    m_stWeaponCaps=7"   Q"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripMP5'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubMp510A2'
    m_PawnWaitAnimLow=StandBullPupLow_nt
    m_PawnWaitAnimHigh=StandBullPupHigh_nt
    m_PawnWaitAnimProne=ProneBullPup_nt
    m_PawnFiringAnim=StandFireBullPup
    m_PawnFiringAnimProne=ProneFireBullPup
    m_vPositionOffset=(X=-2.00,Y=-1.00,Z=0.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=143.00,W=0.00)
    m_NameID="SubMP510A2"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdMp5A4'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

