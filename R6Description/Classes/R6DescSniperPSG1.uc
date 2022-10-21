//================================================================================
// R6DescSniperPSG1.
//================================================================================
class R6DescSniperPSG1 extends R6SniperDescription;

defaultproperties
{
    m_ARangePercent(0)=49
    m_ARangePercent(1)=19
    m_ADamagePercent(0)=98
    m_ADamagePercent(1)=54
    m_AAccuracyPercent(0)=83
    m_AAccuracyPercent(1)=95
    m_ARecoilPercent(0)=16
    m_ARecoilPercent(1)=85
    m_ARecoveryPercent(0)=42
    m_ARecoveryPercent(1)=35
    m_WeaponTags(0)="NORMAL"
    m_WeaponTags(1)="SILENCED"
    m_WeaponClasses(0)="R63rdWeapons.NormalSniperPSG1"
    m_WeaponClasses(1)="R63rdWeapons.SilencedSniperPSG1"
    m_MyGadgets(0)=Class'R6DescSilencerSnipers'
    m_MyGadgets(1)=Class'R6DescThermalScope'
    m_Bullets(0)=Class'R6Desc762mmNATOFMJ'
    m_Bullets(1)=Class'R6Desc762mmNATOJHP'
    m_MagTag="R63RDMAG762MM"
    m_2dMenuRegion=(X=15147530,Y=570687488,W=129,H=5054981)
    m_NameID="SNIPERPSG1"
}
/*
    m_2DMenuTexture=Texture'R6TextureMenuEquipment.Weapons_01'
*/

