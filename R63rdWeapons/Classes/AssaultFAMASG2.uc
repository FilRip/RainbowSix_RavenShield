//================================================================================
// AssaultFAMASG2.
//================================================================================
class AssaultFAMASG2 extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo556mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell556mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   Q"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultFAMASG2'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultFAMASG2'
    m_eGripType=2
    m_PawnWaitAnimLow=StandBullPupLow_nt
    m_PawnWaitAnimHigh=StandBullPupHigh_nt
    m_PawnWaitAnimProne=ProneBullPup_nt
    m_PawnFiringAnim=StandFireBullPup
    m_PawnFiringAnimProne=ProneFireBullPup
    m_PawnReloadAnim=StandReloadAug
    m_PawnReloadAnimTactical=StandTacReloadAug
    m_PawnReloadAnimProne=ProneReloadAug
    m_PawnReloadAnimProneTactical=ProneTacReloadAug
    m_vPositionOffset=(X=-9.00,Y=-2.00,Z=-0.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="AssaultFAMASG2"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdFamasG2'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

