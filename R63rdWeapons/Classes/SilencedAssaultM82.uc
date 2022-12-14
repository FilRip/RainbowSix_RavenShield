//================================================================================
// SilencedAssaultM82.
//================================================================================
class SilencedAssaultM82 extends AssaultM82;

defaultproperties
{
    m_iClipCapacity=30
    m_iNbOfClips=6
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=30000.00
    m_MuzzleScale=0.23
    m_fFireSoundRadius=300.00
    m_fRateOfFire=0.08
    m_pReticuleClass=Class'R6Weapons.R6RifleReticule'
    m_pBulletClass=Class'R6Weapons.ammo556mmNATOSubsonicFMJ'
    m_bIsSilenced=True
    m_fFireAnimRate=1.25
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAG556mm"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$vK?$?1@$?Ja@$KUhA$KUhA$?l?$?"?@$??x?

    m_EquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Equip'
    m_UnEquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Unequip'
    m_ReloadSnd=Sound'Assault_M82_Reloads.Play_M82_Reload'
    m_ReloadEmptySnd=Sound'Assault_M82_Reloads.Play_M82_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonAssaultRiffles.Play_Assault_ROF'
    m_SingleFireStereoSnd=Sound'Assault_M82_Silenced.Play_M82Sil_SingleShots'
    m_FullAutoStereoSnd=Sound'Assault_M82_Silenced.Play_M82Sil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Assault_M82_Silenced.Stop_M82Sil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonAssaultRiffles.Play_Assault_Trigger'
*/

