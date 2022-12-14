//================================================================================
// SilencedAssaultM14.
//================================================================================
class SilencedAssaultM14 extends AssaultM14;

defaultproperties
{
    m_iClipCapacity=20
    m_iNbOfClips=6
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=28600.00
    m_MuzzleScale=0.34
    m_fFireSoundRadius=286.00
    m_fRateOfFire=0.08
    m_pReticuleClass=Class'R6Weapons.R6RifleReticule'
    m_pBulletClass=Class'R6Weapons.ammo762mmNATOSubsonicFMJ'
    m_bIsSilenced=True
    m_fFireAnimRate=1.21
    m_fFPBlend=0.75
    m_szMagazineClass="R63rdWeapons.R63rdMAG762mm2"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSubGuns2"
}
/*
    m_stAccuracyValues=$?kc>$??E@$?a?@$??A$??A$???$I???$?p@

    m_EquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Equip'
    m_UnEquipSnd=Sound'CommonAssaultRiffles.Play_Assault_Unequip'
    m_ReloadSnd=Sound'Assault_M14_Reloads.Play_M14_Reload'
    m_ReloadEmptySnd=Sound'Assault_M14_Reloads.Play_M14_ReloadEmpty'
    m_ChangeROFSnd=Sound'CommonAssaultRiffles.Play_Assault_ROF'
    m_SingleFireStereoSnd=Sound'Assault_M14_Silenced.Play_M14Sil_SingleShots'
    m_FullAutoStereoSnd=Sound'Assault_M14_Silenced.Play_M14Sil_AutoShots'
    m_FullAutoEndStereoSnd=Sound'Assault_M14_Silenced.Stop_M14Sil_AutoShots_Go'
    m_TriggerSnd=Sound'CommonAssaultRiffles.Play_Assault_Trigger'
    StaticMesh=StaticMesh'R63rdWeapons_SM.AssaultRifles.R63rdM14ForSilencer'
*/

