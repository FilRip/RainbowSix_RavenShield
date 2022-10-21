//================================================================================
// SilencedAssaultAK74.
//================================================================================
class SilencedAssaultAK74 extends AssaultAK74;

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
    m_pBulletClass=Class'R6Weapons.ammo545mm7N6SubsonicFMJ'
    m_bIsSilenced=True
    m_fFireAnimRate=1.08
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAGAK74"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$8j?$f�*@$��@$��A$��A$!��?$�<@$x��?

    m_EquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Equip'
    m_UnEquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Unequip'
    m_ReloadSnd=Sound'Assault_AK74_Reloads.Play_AK74_Reload'
    m_ReloadEmptySnd=Sound'Assault_AK74_Reloads.Play_AK74_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonAssaultRiffles.Play_Assault_ROF'
    m_SingleFireStereoSnd=Sound'Assault_AK74_Silenced.Play_AK74Sil_SingleShots'
    m_FullAutoStereoSnd=Sound'Assault_AK74_Silenced.Play_AK74Sil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Assault_AK74_Silenced.Stop_AK74Sil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonAssaultRiffles.Play_Assault_Trigger'
*/

