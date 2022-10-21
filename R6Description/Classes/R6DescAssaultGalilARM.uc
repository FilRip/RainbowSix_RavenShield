//================================================================================
// R6DescAssaultGalilARM.
//================================================================================
class R6DescAssaultGalilARM extends R6AssaultDescription;

defaultproperties
{
    m_ARangePercent(0)=39
    m_ARangePercent(1)=39
    m_ARangePercent(2)=19
    m_ADamagePercent(0)=60
    m_ADamagePercent(1)=60
    m_ADamagePercent(2)=30
    m_AAccuracyPercent(0)=71
    m_AAccuracyPercent(1)=71
    m_AAccuracyPercent(2)=83
    m_ARecoilPercent(0)=55
    m_ARecoilPercent(1)=66
    m_ARecoilPercent(2)=100
    m_ARecoveryPercent(0)=88
    m_ARecoveryPercent(1)=84
    m_ARecoveryPercent(2)=83
    m_WeaponTags(0)="NORMAL"
    m_WeaponTags(1)="CMAG"
    m_WeaponTags(2)="SILENCED"
    m_WeaponClasses(0)="R63rdWeapons.NormalAssaultGalilARM"
    m_WeaponClasses(1)="R63rdWeapons.CMagAssaultGalilARM"
    m_WeaponClasses(2)="R63rdWeapons.SilencedAssaultGalilARM"
    m_MyGadgets(0)=Class'R6DescMiniScope'
    m_MyGadgets(1)=Class'R6DescCMAG556mm'
    m_MyGadgets(2)=Class'R6DescSilencerSubGuns'
    m_Bullets(0)=Class'R6Desc556mmNATOFMJ'
    m_MagTag="R63RDMAG556MM"
    m_2dMenuRegion=(X=16917003,Y=571080704,W=154,H=8462852)
    m_NameID="ASSAULTGALILARM"
}
/*
    m_2DMenuTexture=Texture'R6TextureMenuEquipment.Weapons_00'
*/

