//================================================================================
// R6RainbowStartInfo.
//================================================================================
class R6RainbowStartInfo extends Actor
	Native;
//	NoNativeReplication;

var int m_iHealth;
var int m_iOperativeID;
var bool m_bIsMale;
var float m_fSkillAssault;
var float m_fSkillDemolitions;
var float m_fSkillElectronics;
var float m_fSkillSniper;
var float m_fSkillStealth;
var float m_fSkillSelfControl;
var float m_fSkillLeadership;
var float m_fSkillObservation;
var Material m_FaceTexture;
var Plane m_FaceCoords;
var string m_CharacterName;
var string m_ArmorName;
var string m_szSpecialityID;
var string m_WeaponName[2];
var string m_BulletType[2];
var string m_WeaponGadgetName[2];
var string m_GadgetName[2];

defaultproperties
{
    m_bIsMale=True
    bHidden=True
}