//================================================================================
// SilencedSubUMP.
//================================================================================
class SilencedSubUMP extends SubUMP;

defaultproperties
{
    m_iClipCapacity=25
    m_iNbOfClips=6
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=28500.00
    m_MuzzleScale=0.36
    m_fFireSoundRadius=285.00
    m_fRateOfFire=0.10
    m_pReticuleClass=Class'R6Weapons.R6CircleDotLineReticule'
    m_pBulletClass=Class'R6Weapons.ammo45calAutoSubsonicFMJ'
    m_bIsSilenced=True
    m_fFireAnimRate=0.97
    m_fFPBlend=0.58
    m_szMagazineClass="R63rdWeapons.R63rdMAG10mm"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns"
}
/*
    m_stAccuracyValues=$²/—?$	ì?$Ç1@$]›6A$]›6A$=
7?$ÏÆ°@$z'ª@

    m_EquipSnd=Sound'CommonSMG.Play_SMG_Equip'
    m_UnEquipSnd=Sound'CommonSMG.Play_SMG_Unequip'
    m_ReloadSnd=Sound'Sub_UMP45_Reloads.Play_UMP45_Reload'
    m_ReloadEmptySnd=Sound'Sub_UMP45_Reloads.Play_UMP45_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonSMG.Play_SMG_ROF'
    m_SingleFireStereoSnd=Sound'Sub_UMP45_Silenced.Play_UMP45Sil_SingleShots'
    m_BurstFireStereoSnd=Sound'Sub_UMP45_Silenced.Play_UMP45Sil_TripleShots'
    m_FullAutoStereoSnd=Sound'Sub_UMP45_Silenced.Play_UMP45Sil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Sub_UMP45_Silenced.Stop_UMP45Sil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonSMG.Play_SMG_Trigger'
*/

