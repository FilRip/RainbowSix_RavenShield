//================================================================================
// NormalSniperDragunov.
//================================================================================
class NormalSniperDragunov extends SniperDragunov;

defaultproperties
{
    m_iClipCapacity=10
    m_iNbOfClips=3
    m_iNbOfExtraClips=2
    m_fMuzzleVelocity=48600.00
    m_MuzzleScale=1.00
    m_fFireSoundRadius=3240.00
    m_fRateOfFire=0.73
    m_pReticuleClass=Class'R6Weapons.R6SniperReticule'
    m_pBulletClass=Class'R6Weapons.ammo762x54mmRNormalFMJ'
    m_fFPBlend=0.25
    m_szMagazineClass="R63rdWeapons.R63rdMAGDragunov"
    m_szMuzzleClass="R6WeaponGadgets.R63rdMuzzleAssault762"
}
/*
    m_stAccuracyValues=${7›>$N_4@$zGá@$∂ÅãA$∂ÅãA$33/@$Ap,@$œÆ»A

    m_EquipSnd=Sound'CommonSniper.Play_Sniper_Equip'
    m_UnEquipSnd=Sound'CommonSniper.Play_Sniper_Unequip'
    m_ReloadSnd=Sound'Sniper_Dragunov_Reloads.Play_Dragunov_Reload'
    m_ReloadEmptySnd=Sound'Sniper_Dragunov_Reloads.Play_Dragunov_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Sniper_Dragunov.Play_Dragunov_SingleShots'
    m_TriggerSnd=Sound'CommonSniper.Play_Sniper_Trigger'
*/

