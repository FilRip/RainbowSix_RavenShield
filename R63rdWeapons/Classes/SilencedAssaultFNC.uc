//================================================================================
// SilencedAssaultFNC.
//================================================================================
class SilencedAssaultFNC extends AssaultFNC;

defaultproperties
{
    m_iClipCapacity=30
    m_iNbOfClips=6
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=30000.00
    m_MuzzleScale=0.23
    m_fFireSoundRadius=300.00
    m_fRateOfFire=0.09
    m_pReticuleClass=Class'R6Weapons.R6RifleReticule'
    m_pBulletClass=Class'R6Weapons.ammo556mmNATOSubsonicFMJ'
    m_bIsSilenced=True
    m_fFireAnimRate=1.08
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAG556mm"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns2"
}
/*
    m_stAccuracyValues=$hýÆ>$ñû7@$õü‰@$ÜLŽA$ÜLŽA$“°?$¯¯!@$ôŒI?

    m_EquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Equip'
    m_UnEquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Unequip'
    m_ReloadSnd=Sound'Assault_FNC_Reloads.Play_FNC_Reload'
    m_ReloadEmptySnd=Sound'Assault_FNC_Reloads.Play_FNC_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonAssaultRiffles.Play_Assault_ROF'
    m_SingleFireStereoSnd=Sound'Assault_FNC_Silenced.Play_FNCSil_SingleShots'
    m_FullAutoStereoSnd=Sound'Assault_FNC_Silenced.Play_FNCSil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Assault_FNC_Silenced.Stop_FNCSil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonAssaultRiffles.Play_Assault_Trigger'
*/

