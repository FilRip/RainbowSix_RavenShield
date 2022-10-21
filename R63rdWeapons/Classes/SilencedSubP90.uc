//================================================================================
// SilencedSubP90.
//================================================================================
class SilencedSubP90 extends SubP90;

defaultproperties
{
    m_iClipCapacity=50
    m_iNbOfClips=4
    m_iNbOfExtraClips=2
    m_fMuzzleVelocity=30000.00
    m_MuzzleScale=0.24
    m_fFireSoundRadius=300.00
    m_fRateOfFire=0.07
    m_pReticuleClass=Class'R6Weapons.R6CircleDotLineReticule'
    m_pBulletClass=Class'R6Weapons.ammo57x28mmSubsonicFMJ'
    m_bIsSilenced=True
    m_fFireAnimRate=1.50
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAGP90"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$cÐ£?$ó@$l®V@$àc]A$àc]A$Ë¡a?$Ø3¿@$þ?

    m_EquipSnd=Sound'CommonSMG.Play_SMG_Equip'
    m_UnEquipSnd=Sound'CommonSMG.Play_SMG_Unequip'
    m_ReloadSnd=Sound'Sub_P90_Reloads.Play_P90_Reload'
    m_ReloadEmptySnd=Sound'Sub_P90_Reloads.Play_P90_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonSMG.Play_SMG_ROF'
    m_SingleFireStereoSnd=Sound'Sub_P90_Silenced.Play_P90Sil_SingleShots'
    m_FullAutoStereoSnd=Sound'Sub_P90_Silenced.Play_P90Sil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Sub_P90_Silenced.Stop_P90Sil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonSMG.Play_SMG_Trigger'
*/

