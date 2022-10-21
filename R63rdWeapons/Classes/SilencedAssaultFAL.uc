//================================================================================
// SilencedAssaultFAL.
//================================================================================
class SilencedAssaultFAL extends AssaultFAL;

defaultproperties
{
    m_iClipCapacity=20
    m_iNbOfClips=6
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=28600.00
    m_MuzzleScale=0.34
    m_fFireSoundRadius=286.00
    m_fRateOfFire=0.09
    m_pReticuleClass=Class'R6Weapons.R6RifleReticule'
    m_pBulletClass=Class'R6Weapons.ammo762mmNATOSubsonicFMJ'
    m_bIsSilenced=True
    m_fFireAnimRate=1.08
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAG762mm2"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns2"
}
/*
    m_stAccuracyValues=$Ã™Š>$"ÌA@$Y‘@$âã•A$âã•A$ÍÌ½?$y@$5å)@

    m_EquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Equip'
    m_UnEquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Unequip'
    m_ReloadSnd=Sound'Assault_FAL_Reloads.Play_FAL_Reload'
    m_ReloadEmptySnd=Sound'Assault_FAL_Reloads.Play_FAL_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonAssaultRiffles.Play_Assault_ROF'
    m_SingleFireStereoSnd=Sound'Assault_FAL_Silenced.Play_FALSil_SingleShots'
    m_FullAutoStereoSnd=Sound'Assault_FAL_Silenced.Play_FALSil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Assault_FAL_Silenced.Stop_FALSil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonAssaultRiffles.Play_Assault_Trigger'
*/

