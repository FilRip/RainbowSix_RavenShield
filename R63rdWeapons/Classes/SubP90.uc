//================================================================================
// SubP90.
//================================================================================
class SubP90 extends R6SubMachineGun
	Abstract;

defaultproperties
{
    m_pBulletClass=Class'R6Weapons.ammo57x28mm'
    m_pEmptyShells=Class'R6SFX.R6Shell57mm'
    m_pMuzzleFlash=Class'R6SFX.R6MuzzleFlash556mm'
    m_stWeaponCaps=7"   >"   <"   *"   G"
    m_pFPHandsClass=Class'R61stWeapons.R61stHandsGripP90'
    m_pFPWeaponClass=Class'R61stWeapons.R61stSubP90'
    m_eGripType=4
    m_PawnWaitAnimLow=StandP90Low_nt
    m_PawnWaitAnimHigh=StandP90High_nt
    m_PawnWaitAnimProne=ProneP90_nt
    m_PawnFiringAnim=StandFireP90
    m_PawnFiringAnimProne=ProneFireP90
    m_PawnReloadAnim=StandReloadP90
    m_PawnReloadAnimTactical=StandTacReloadP90
    m_PawnReloadAnimProne=ProneReloadP90
    m_PawnReloadAnimProneTactical=ProneTacReloadP90
    m_vPositionOffset=(X=-1.00,Y=-4.00,Z=2.50)
    m_HUDTexturePos=(X=0.00,Y=0.00,Z=100.00,W=0.00)
    m_NameID="SubP90"
}
/*
    StaticMesh=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdP90'
    m_WithScopeSM=StaticMesh'R63rdWeapons_SM.SubGuns.R63rdP90ForScope'
    m_HUDTexture=Texture'R6HUD.HUDElements'
*/

