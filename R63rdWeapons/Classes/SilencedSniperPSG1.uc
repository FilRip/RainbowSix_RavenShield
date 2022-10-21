//================================================================================
// SilencedSniperPSG1.
//================================================================================
class SilencedSniperPSG1 extends SniperPSG1;

defaultproperties
{
    m_iClipCapacity=10
    m_iNbOfClips=3
    m_iNbOfExtraClips=2
    m_fMuzzleVelocity=30000.00
    m_MuzzleScale=0.35
    m_fFireSoundRadius=300.00
    m_fRateOfFire=1.15
    m_pReticuleClass=Class'R6Weapons.R6SniperReticule'
    m_pBulletClass=Class'R6Weapons.ammo762mmNATOSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.88
    m_szMagazineClass="R63rdWeapons.R63rdMAG762mm"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSnipers"
}
/*
    m_stAccuracyValues=$)D>$•?M@$°ï™@$-¿žA$-¿žA$q=Š@$ÄÄÄ?$ž;v@

    m_EquipSnd=Sound'CommonSniper.Play_Sniper_Equip'
    m_UnEquipSnd=Sound'CommonSniper.Play_Sniper_Unequip'
    m_ReloadSnd=Sound'Sniper_PSG1_Reloads.Play_PSG1_Reload'
    m_ReloadEmptySnd=Sound'Sniper_PSG1_Reloads.Play_PSG1_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Sniper_PSG1_Silenced.Play_PSG1Sil_SingleShots'
    m_TriggerSnd=Sound'CommonSniper.Play_Sniper_Trigger'
*/

