//================================================================================
// AssaultType97.
//================================================================================
class AssaultType97 extends R6AssaultRifle
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo556mmNATO'
    m_pEmptyShells=Class'R6SFX.R6Shell556mmNATO'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   >"   ="   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsAssaultType97'
    m_pFPWeaponClass=Class'R61stWeapons.R61stAssaultType97'
    m_eGripType=4
    m_PawnWaitAnimLow=StandP90Low_nt
    m_PawnWaitAnimHigh=StandP90High_nt
    m_PawnWaitAnimProne=ProneP90_nt
    m_PawnFiringAnim=StandFireP90
    m_PawnFiringAnimProne=ProneFireP90
    m_PawnReloadAnim=StandReloadAug
    m_PawnReloadAnimTactical=StandTacReloadAug
    m_PawnReloadAnimProne=ProneReloadAug
    m_PawnReloadAnimProneTactical=ProneTacReloadAug
    m_vPositionOffset=(X=0.50,Y=-5.50,Z=4.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="AssaultType97"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdType97'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

