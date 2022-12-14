//================================================================================
// SilencedSubUzi.
//================================================================================
class SilencedSubUzi extends SubUzi;

defaultproperties
{
    m_iClipCapacity=32
    m_iNbOfClips=7
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=28500.00
    m_MuzzleScale=0.27
    m_fFireSoundRadius=285.00
    m_pReticuleClass=Class'R6Weapons.R6CircleDotLineReticule'
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellumSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAG9mmStraight"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$+??$?@$??k@$?=sA$?=sA$??n?$???@$??0@

    m_EquipSnd=Sound'CommonSMG.Play_SMG_Equip'
    m_UnEquipSnd=Sound'CommonSMG.Play_SMG_Unequip'
    m_ReloadSnd=Sound'Mult_Uzi_Reloads.Play_UZI_Reload'
    m_ReloadEmptySnd=Sound'Mult_Uzi_Reloads.Play_UZI_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonSMG.Play_SMG_ROF'
    m_SingleFireStereoSnd=Sound'Mult_Uzi_Silenced.Play_UZI_Sil_SingleShots'
    m_FullAutoStereoSnd=Sound'Mult_Uzi_Silenced.Play_UZI_Sil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Mult_Uzi_Silenced.Stop_UZI_Sil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonSMG.Play_SMG_Trigger'
*/

