//================================================================================
// SilencedPistolMk23.
//================================================================================
class SilencedPistolMk23 extends PistolMk23;

defaultproperties
{
    m_iClipCapacity=12
    m_iNbOfClips=4
    m_iNbOfExtraClips=6
    m_fMuzzleVelocity=27000.00
    m_MuzzleScale=0.34
    m_fFireSoundRadius=270.00
    m_fRateOfFire=0.10
    m_pReticuleClass=Class'R6Weapons.R6CircleReticule'
    m_pBulletClass=Class'R6Weapons.ammo45calAutoSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.61
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerPistol"
}
/*
    m_stAccuracyValues=$¶?$Sƒÿ?$²@$¤―$A$¤―$A$τύ•?$qηA$
°A

    m_EquipSnd=Sound'CommonPistols.Play_Pistol_Equip'
    m_UnEquipSnd=Sound'CommonPistols.Play_Pistol_Unequip'
    m_ReloadSnd=Sound'Pistol_MK23_Reloads.Play_MK23_Reload'
    m_ReloadEmptySnd=Sound'Pistol_MK23_Reloads.Play_MK23_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Pistol_MK23_Silenced.Play_MK23Sil_SingleShots'
    m_EmptyMagSnd=Sound'Pistol_MK23_Reloads.Play_MK23_Chamber'
    m_TriggerSnd=Sound'CommonPistols.Play_Pistol_Trigger'
*/

