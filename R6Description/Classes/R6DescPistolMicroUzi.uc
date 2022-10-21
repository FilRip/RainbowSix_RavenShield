//================================================================================
// R6DescPistolMicroUzi.
//================================================================================
class R6DescPistolMicroUzi extends R6MachinePistolsDescription;

defaultproperties
{
    m_ARangePercent(0)=11
    m_ARangePercent(1)=11
    m_ADamagePercent(0)=14
    m_ADamagePercent(1)=14
    m_AAccuracyPercent(0)=19
    m_AAccuracyPercent(1)=19
    m_ARecoilPercent(0)=60
    m_ARecoilPercent(1)=64
    m_ARecoveryPercent(0)=86
    m_ARecoveryPercent(1)=86
    m_WeaponTags(0)="NORMAL"
    m_WeaponTags(1)="CMAG"
    m_WeaponClasses(0)="R63rdWeapons.NormalPistolMicroUzi"
    m_WeaponClasses(1)="R63rdWeapons.CMagPistolMicroUzi"
    m_MyGadgets(0)=Class'R6DescMAGPistolHigh'
    m_Bullets(0)=Class'R6Desc9mmParabellumFMJ'
    m_Bullets(1)=Class'R6Desc9mmParabellumJHP'
    m_MagTag="R63RDMAGPISTOL"
    m_2dMenuRegion=(X=12591627,Y=571080704,W=231,H=4203012)
    m_NameID="PISTOLMICROUZI"
}
/*
    m_2DMenuTexture=Texture'R6TextureMenuEquipment.Weapons_02'
*/

