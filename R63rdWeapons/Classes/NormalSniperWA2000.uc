//================================================================================
// NormalSniperWA2000.
//================================================================================
class NormalSniperWA2000 extends SniperWA2000;

defaultproperties
{
    m_iClipCapacity=6
    m_iNbOfClips=5
    m_iNbOfExtraClips=3
    m_fMuzzleVelocity=62160.00
    m_MuzzleScale=1.00
    m_fFireSoundRadius=4144.00
    m_fRateOfFire=0.86
    m_pReticuleClass=Class'R6Weapons.R6SniperReticule'
    m_pBulletClass=Class'R6Weapons.ammo30calMagnumNormalFMJ'
    m_fFPBlend=0.35
    m_szMagazineClass="R63rdWeapons.R63rdMAG762mm"
    m_szMuzzleClass="R6WeaponGadgets.R63rdMuzzleAssault762"
}
/*
    m_stAccuracyValues=$0OO?$Éñ@$­j_@$ffA$ffA$šN@$“ÿ„@$íÁ­A

    m_EquipSnd=Sound'CommonSniper.Play_Sniper_Equip'
    m_UnEquipSnd=Sound'CommonSniper.Play_Sniper_Unequip'
    m_ReloadSnd=Sound'Sniper_WA2000_Reloads.Play_WA2000_Reload'
    m_ReloadEmptySnd=Sound'Sniper_WA2000_Reloads.Play_WA2000_ReloadEmpty'
    m_SingleFireStereoSnd=Sound'Sniper_WA2000.Play_WA2000_SingleShots'
    m_TriggerSnd=Sound'CommonSniper.Play_Sniper_Trigger'
*/

