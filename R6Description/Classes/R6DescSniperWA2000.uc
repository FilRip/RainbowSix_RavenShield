//================================================================================
// R6DescSniperWA2000.
//================================================================================
class R6DescSniperWA2000 extends R6SniperDescription;

defaultproperties
{
    m_ARangePercent(0)=87
    m_ARangePercent(1)=37
    m_ADamagePercent(0)=100
    m_ADamagePercent(1)=50
    m_AAccuracyPercent(0)=67
    m_AAccuracyPercent(1)=79
    m_ARecoilPercent(0)=1
    m_ARecoilPercent(1)=93
    m_ARecoveryPercent(0)=52
    m_ARecoveryPercent(1)=45
    m_WeaponTags(0)="NORMAL"
    m_WeaponTags(1)="SILENCED"
    m_WeaponClasses(0)="R63rdWeapons.NormalSniperWA2000"
    m_WeaponClasses(1)="R63rdWeapons.SilencedSniperWA2000"
    m_MyGadgets(0)=Class'R6DescSilencerSnipers'
    m_MyGadgets(1)=Class'R6DescThermalScope'
    m_Bullets(0)=Class'R6Desc30calMagnumFMJ'
    m_Bullets(1)=Class'R6Desc30calMagnumJHP'
    m_MagTag="R63RDMAG762MM"
    m_2dMenuRegion=(X=20193802,Y=570687488,W=129,H=5054981)
    m_NameID="SNIPERWA2000"
}
/*
    m_2DMenuTexture=Texture'R6TextureMenuEquipment.Weapons_01'
*/

