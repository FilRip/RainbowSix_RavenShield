//================================================================================
// SilencedSniperDragunov.
//================================================================================
class SilencedSniperDragunov extends SniperDragunov;

defaultproperties
{
    m_iClipCapacity=10
    m_iNbOfClips=3
    m_iNbOfExtraClips=2
    m_fMuzzleVelocity=30000.00
    m_MuzzleScale=0.38
    m_fFireSoundRadius=300.00
    m_fRateOfFire=0.86
    m_pReticuleClass=Class'R6Weapons.R6SniperReticule'
    m_pBulletClass=Class'R6Weapons.ammo762x54mmRSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.89
    m_szMagazineClass="R63rdWeapons.R63rdMAGDragunov"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSnipers"
}
/*
    m_stAccuracyValues=$Û½>$K÷L@$x¹™@$D‡žA$D‡žA$33M@$(sÆ?$ÌÙk@

    m_EquipSnd=Sound'CommonSniper.Play_Sniper_Equip'
    m_UnEquipSnd=Sound'CommonSniper.Play_Sniper_Unequip'
    m_ReloadSnd=Sound'Sniper_Dragunov_Reloads.Play_Dragunov_Reload'
    m_ReloadEmptySnd=Sound'Sniper_Dragunov_Reloads.Play_Dragunov_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Sniper_Dragunov_Silenced.Play_DragunovSil_SingleShots'
    m_TriggerSnd=Sound'CommonSniper.Play_Sniper_Trigger'
    StaticMesh=StaticMesh'R63rdWeapons_SM.SniperRifles.R63rdDragunovForSilencer'
*/

