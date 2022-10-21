//================================================================================
// SilencedSniperWA2000.
//================================================================================
class SilencedSniperWA2000 extends SniperWA2000;

defaultproperties
{
    m_iClipCapacity=6
    m_iNbOfClips=5
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=30000.00
    m_MuzzleScale=0.36
    m_fFireSoundRadius=300.00
    m_fRateOfFire=0.98
    m_pReticuleClass=Class'R6Weapons.R6SniperReticule'
    m_pBulletClass=Class'R6Weapons.ammo30calMagnumSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.93
    m_szMagazineClass="R63rdWeapons.R63rdMAG762mm"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerWA2000"
}
/*
    m_stAccuracyValues=$Í¢?$∆â-@$U'Ç@$è8ÜA$è8ÜA$öl@$y»@@$Í@

    m_EquipSnd=Sound'CommonSniper.Play_Sniper_Equip'
    m_UnEquipSnd=Sound'CommonSniper.Play_Sniper_Unequip'
    m_ReloadSnd=Sound'Sniper_WA2000_Reloads.Play_WA2000_Reload'
    m_ReloadEmptySnd=Sound'Sniper_WA2000_Reloads.Play_WA2000_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Sniper_WA2000_Silenced.Play_WA2000Sil_SingleShots'
    m_TriggerSnd=Sound'CommonSniper.Play_Sniper_Trigger'
*/

