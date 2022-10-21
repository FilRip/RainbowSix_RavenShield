//================================================================================
// SilencedSubM12S.
//================================================================================
class SilencedSubM12S extends SubM12S;

defaultproperties
{
    m_iClipCapacity=40
    m_iNbOfClips=5
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=28500.00
    m_MuzzleScale=0.27
    m_fFireSoundRadius=285.00
    m_fRateOfFire=0.11
    m_pReticuleClass=Class'R6Weapons.R6CircleDotLineReticule'
    m_pBulletClass=Class'R6Weapons.ammo9mmParabellumSubsonicFMJ'
    m_bIsSilenced=True
    m_fFireAnimRate=0.92
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAG9mmStraight"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$´ö¬?$†Ú
@$ÈGA@$RGA$RGA$¶óI?$
À@$f/@

    m_EquipSnd=Sound'CommonSMG.Play_SMG_Equip'
    m_UnEquipSnd=Sound'CommonSMG.Play_SMG_Unequip'
    m_ReloadSnd=Sound'Sub_M12_Reloads.Play_M12_Reload'
    m_ReloadEmptySnd=Sound'Sub_M12_Reloads.Play_M12_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonSMG.Play_SMG_ROF'
    m_SingleFireStereoSnd=Sound'Sub_M12_Silenced.Play_M12Sil_SingleShots'
    m_FullAutoStereoSnd=Sound'Sub_M12_Silenced.Play_M12Sil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Sub_M12_Silenced.Stop_M12Sil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonSMG.Play_SMG_Trigger'
*/

