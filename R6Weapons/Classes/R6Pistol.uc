//================================================================================
// R6Pistol.
//================================================================================
class R6Pistol extends R6Weapons
	Abstract;

defaultproperties
{
    m_fRateOfFire=0.17
    m_eGripType=8
    m_InventoryGroup=2
    m_PawnWaitAnimLow=StandHandGunLow_nt
    m_PawnWaitAnimHigh=StandHandGunHigh_nt
    m_PawnWaitAnimProne=ProneHandGun_nt
    m_PawnFiringAnim=StandFireHandGun
    m_PawnFiringAnimProne=ProneFireHandGun
    m_PawnReloadAnim=StandReloadHandGun
    m_PawnReloadAnimTactical=StandReloadHandGun
    m_PawnReloadAnimProne=ProneReloadHandGun
    m_PawnReloadAnimProneTactical=ProneReloadHandGun
    m_AttachPoint=TagRightHand
    m_HoldAttachPoint=TagHolster
    m_szMagazineClass="R63rdWeapons.R63rdMAGPistol"
}
/*
    m_FPMuzzleFlashTexture=Texture'R6SFX_T.Muzzleflash.1stMuzzle_B'
    m_ShellSingleFireSnd=Sound'CommonPistols.Play_Pistol_SingleShells'
    m_ShellEndFullAutoSnd=Sound'CommonPistols.Play_Pistol_EndShell'
    StaticMesh=StaticMesh'RedPistolStaticMesh'
*/

