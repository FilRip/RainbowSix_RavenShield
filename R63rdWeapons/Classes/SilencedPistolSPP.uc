//================================================================================
// SilencedPistolSPP.
//================================================================================
class SilencedPistolSPP extends PistolSPP;

defaultproperties
{
    m_iClipCapacity=30
    m_iNbOfClips=2
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=28500.00
    m_MuzzleScale=0.30
    m_fFireSoundRadius=285.00
    m_fRateOfFire=0.10
    m_pReticuleClass=Class'R6Weapons.R6CircleReticule'
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellumSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.72
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$­®Ú?$‡ëB@$i¦s@$œC{A$œC{A$Ñ"™?$	"ù@$§ÃÃ@

    m_EquipSnd=Sound'CommonSMG.Play_SMG_Equip'
    m_UnEquipSnd=Sound'CommonSMG.Play_SMG_Unequip'
    m_ReloadSnd=Sound'Pistol_SPP_Reloads.Play_SPP_Reload'
    m_ReloadEmptySnd=Sound'Pistol_SPP_Reloads.Play_SPP_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Sub_TMP_Silenced.Play_TMPSil_SingleShots'
    m_TriggerSnd=Sound'CommonPistols.Play_Pistol_Trigger'
*/

