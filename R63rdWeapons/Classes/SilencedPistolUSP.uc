//================================================================================
// SilencedPistolUSP.
//================================================================================
class SilencedPistolUSP extends PistolUSP;

defaultproperties
{
    m_iClipCapacity=13
    m_iNbOfClips=4
    m_iNbOfExtraClips=6
    m_fMuzzleVelocity=28500.00
    m_MuzzleScale=0.32
    m_fFireSoundRadius=285.00
    m_fRateOfFire=0.10
    m_pReticuleClass=Class'R6Weapons.R6CircleReticule'
    m_pBulletClass=Class'R6Weapons.ammo40calAutoSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.52
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerPistol"
}
/*
    m_stAccuracyValues=$!Ð¿?$Š­ï?$vÌ@$ÚzA$ÚzA$„?$_KA$ÿU*A

    m_EquipSnd=Sound'CommonPistols.Play_Pistol_Equip'
    m_UnEquipSnd=Sound'CommonPistols.Play_Pistol_Unequip'
    m_ReloadSnd=Sound'Pistol_USP_Reloads.Play_USP_Reload'
    m_ReloadEmptySnd=Sound'Pistol_USP_Reloads.Play_USP_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Pistol_USP_Silenced.Play_USPSil_SingleShots'
    m_EmptyMagSnd=Sound'Pistol_USP_Reloads.Play_USP_Chamber'
    m_TriggerSnd=Sound'CommonPistols.Play_Pistol_Trigger'
*/

