//================================================================================
// R6PrimaryWeaponDescription.
//================================================================================
class R6PrimaryWeaponDescription extends R6Description;

var array<int> m_ARangePercent;
var array<int> m_ADamagePercent;
var array<int> m_AAccuracyPercent;
var array<int> m_ARecoilPercent;
var array<int> m_ARecoveryPercent;
var array<string> m_WeaponTags;
var array<string> m_WeaponClasses;
var array<Class> m_MyGadgets;
var array<Class> m_Bullets;
var string m_MagTag;

defaultproperties
{
    m_MyGadgets(0)=Class'R6DescWeaponGadgetNone'
    m_Bullets(0)=Class'R6DescBulletNone'
    m_2dMenuRegion=(X=8462852,Y=570753024,W=77,H=0)
    m_NameTag="NONE"
}
/*
    m_2DMenuTexture=Texture'R6TextureMenuEquipment.PrimaryNone1'
*/

