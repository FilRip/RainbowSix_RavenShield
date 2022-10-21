//================================================================================
// SilencedAssaultAK47.
//================================================================================
class SilencedAssaultAK47 extends AssaultAK47;

defaultproperties
{
    m_iClipCapacity=30
    m_iNbOfClips=6
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=29600.00
    m_MuzzleScale=0.33
    m_fFireSoundRadius=296.00
    m_pReticuleClass=Class'R6Weapons.R6RifleReticule'
    m_pBulletClass=Class'R6Weapons.ammo762mmM43SubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAGAK47"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$¿S.?$ç©@$Û~o@$ÒúvA$ÒúvA$¤p™?$èÀZ@$´ÙA@

    m_EquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Equip'
    m_UnEquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Unequip'
    m_ReloadSnd=Sound'Assault_AK47_Reloads.Play_AK47_Reload'
    m_ReloadEmptySnd=Sound'Assault_AK47_Reloads.Play_AK47_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonAssaultRiffles.Play_Assault_ROF'
    m_SingleFireStereoSnd=Sound'Assault_AK47_Silenced.Play_AK47Sil_SingleShots'
    m_FullAutoStereoSnd=Sound'Assault_AK47_Silenced.Play_AK47Sil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Assault_AK47_Silenced.Stop_AK47Sil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonAssaultRiffles.Play_Assault_Trigger'
*/

