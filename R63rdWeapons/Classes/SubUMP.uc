//================================================================================
// SubUMP.
//================================================================================
class SubUMP extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo45calAuto'
    m_pEmptyShells=Class'R6SFX.R6Shell45calAuto'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlashSub'
    m_stWeaponCaps=7"   Q"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsSubUMP'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubUMP'
    m_PawnWaitAnimLow=StandBullPupLow_nt
    m_PawnWaitAnimHigh=StandBullPupHigh_nt
    m_PawnWaitAnimProne=ProneBullPup_nt
    m_PawnFiringAnim=StandFireBullPup
    m_PawnFiringAnimProne=ProneFireBullPup
    m_vPositionOffset=(X=6.00,Y=-1.00,Z=-1.00)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=300.00,W=0.00)
    m_NameID="SubUMP"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdUMP'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

