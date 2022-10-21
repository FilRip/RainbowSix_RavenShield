//================================================================================
// SilencedPistolAPArmy.
//================================================================================
class SilencedPistolAPArmy extends PistolAPArmy;

defaultproperties
{
    m_iClipCapacity=20
    m_iNbOfClips=3
    m_iNbOfExtraClips=4
    m_fMuzzleVelocity=30000.00
    m_MuzzleScale=0.24
    m_fFireSoundRadius=300.00
    m_fRateOfFire=0.10
    m_pReticuleClass=Class'R6Weapons.R6CircleReticule'
    m_pBulletClass=Class'R6Weapons.ammo57x28mmSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.76
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerPistol"
}
/*
    m_stAccuracyValues=$5Í´?$Û2@$‘!@$Ž‹&A$Ž‹&A$Év€?$Çú@$c§@

    m_EquipSnd=Sound'CommonPistols.Play_Pistol_Equip'
    m_UnEquipSnd=Sound'CommonPistols.Play_Pistol_Unequip'
    m_ReloadSnd=Sound'Pistol_Belgian_Reloads.Play_Belgian_Reload'
    m_ReloadEmptySnd=Sound'Pistol_Belgian_Reloads.Play_Belgian_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Pistol_Belgian_Silenced.Play_BelgianSil_SingleShots'
    m_EmptyMagSnd=Sound'Pistol_Belgian_Reloads.Play_Belgian_Chamber'
    m_TriggerSnd=Sound'CommonPistols.Play_Pistol_Trigger'
*/

