//================================================================================
// SilencedSubSR2.
//================================================================================
class SilencedSubSR2 extends SubSR2;

defaultproperties
{
    m_iClipCapacity=20
    m_iNbOfClips=10
    m_iNbOfExtraClips=4
    m_fMuzzleVelocity=28500.00
    m_MuzzleScale=0.26
    m_fFireSoundRadius=285.00
    m_pReticuleClass=Class'R6Weapons.R6CircleDotLineReticule'
    m_pBulletClass=Class'R6Weapons.ammo9x21mmRSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.72
    m_szMagazineClass="R63rdWeapons.R63rdMAGPistol"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$’°?$+Ã@$Á¤c@$çÁjA$çÁjA$#Ûå>$qþÂ@$Úb@

    m_EquipSnd=Sound'CommonSMG.Play_SMG_Equip'
    m_UnEquipSnd=Sound'CommonSMG.Play_SMG_Unequip'
    m_ReloadSnd=Sound'Mult_SR2MP_Reloads.Play_SR2MP_Reload'
    m_ReloadEmptySnd=Sound'Mult_SR2MP_Reloads.Play_SR2MP_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonSMG.Play_SMG_ROF'
    m_SingleFireStereoSnd=Sound'Mult_SR2MP_Silenced.Play_SR2MPSil_SingleShots'
    m_FullAutoStereoSnd=Sound'Mult_SR2MP_Silenced.Play_SR2MPSil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Mult_SR2MP_Silenced.Stop_SR2MPSil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonSMG.Play_SMG_Trigger'
*/

