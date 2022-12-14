//================================================================================
// R6DescSniperDragunov.
//================================================================================
class R6DescSniperDragunov extends R6SniperDescription;

defaultproperties
{
    m_ARangePercent(0)=61
    m_ARangePercent(1)=27
    m_ADamagePercent(0)=100
    m_ADamagePercent(1)=50
    m_AAccuracyPercent(0)=83
    m_AAccuracyPercent(1)=94
    m_ARecoilPercent(0)=1
    m_ARecoilPercent(1)=86
    m_ARecoveryPercent(0)=60
    m_ARecoveryPercent(1)=53
    m_WeaponTags(0)="NORMAL"
    m_WeaponTags(1)="SILENCED"
    m_WeaponClasses(0)="R63rdWeapons.NormalSniperDragunov"
    m_WeaponClasses(1)="R63rdWeapons.SilencedSniperDragunov"
    m_MyGadgets(0)=Class'R6DescSilencerSnipers'
    m_MyGadgets(1)=Class'R6DescThermalScope'
    m_Bullets(0)=Class'R6Desc762x54mmRFMJ'
    m_Bullets(1)=Class'R6Desc762x54mmRJHP'
    m_MagTag="R63RDMAGDRAGUNOV"
    m_2dMenuRegion=(X=8462859,Y=571080704,W=154,H=8462852)
    m_NameID="SNIPERDRAGUNOV"
}
/*
    m_2DMenuTexture=Texture'R6TextureMenuEquipment.Weapons_01'
*/

