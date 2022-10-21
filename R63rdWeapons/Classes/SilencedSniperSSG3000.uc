//================================================================================
// SilencedSniperSSG3000.
//================================================================================
class SilencedSniperSSG3000 extends SniperSSG3000;

defaultproperties
{
    m_iClipCapacity=5
    m_iNbOfClips=6
    m_iNbOfExtraClips=4
    m_fMuzzleVelocity=30000.00
    m_MuzzleScale=0.35
    m_fFireSoundRadius=300.00
    m_fRateOfFire=1.03
    m_pReticuleClass=Class'R6Weapons.R6SniperReticule'
    m_pBulletClass=Class'R6Weapons.ammo762mmNATOSubsonicFMJ'
    m_bIsSilenced=True
    m_fFPBlend=0.93
    m_szMagazineClass="R63rdWeapons.R63rdMAG762mm"
    m_szSilencerClass="R6WeaponGadgets.R63rdSilencerSnipers"
}
/*
    m_stAccuracyValues=$ô`G>$ﬂH@$'ñ@$·«öA$·«öA$fÊw@$qL„?$¨{@

    m_EquipSnd=Sound'CommonSniper.Play_Sniper_Equip'
    m_UnEquipSnd=Sound'CommonSniper.Play_Sniper_Unequip'
    m_ReloadSnd=Sound'Sniper_SSG3000_Reloads.Play_SSG3000_Reload'
    m_ReloadEmptySnd=Sound'Sniper_SSG3000_Reloads.Play_SSG3000_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Sniper_SSG3000_Silenced.Play_SSG3000Sil_SingleShots'
    m_TriggerSnd=Sound'CommonSniper.Play_Sniper_Trigger'
*/

