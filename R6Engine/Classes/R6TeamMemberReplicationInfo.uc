//================================================================================
// R6TeamMemberReplicationInfo.
//================================================================================
class R6TeamMemberReplicationInfo extends Actor
	Native;
//	NoNativeReplication;

var byte m_RotationYaw;
var byte m_BlinkCounter;
var byte m_iTeamPosition;
var byte m_eHealth;
var byte m_BlinkCounterOld;
var int m_iTeam;
var int m_iTeamId;
var bool m_bIsPrimaryGadgetEmpty;
var bool m_bIsSecondaryGadgetEmpty;
var bool m_bIsPilot;
var float m_fLastCommunicationTime;
var float m_fClientUpdateFrequency;
var float m_fClientLastUpdate;
var Vector m_Location;
var string m_CharacterName;
var string m_PrimaryWeapon;
var string m_SecondaryWeapon;
var string m_PrimaryGadget;
var string m_SecondaryGadget;

replication
{
	reliable if ( Role == Role_Authority )
		m_RotationYaw,m_BlinkCounter,m_iTeamPosition,m_eHealth,m_iTeam,m_iTeamId,m_bIsPrimaryGadgetEmpty,m_bIsSecondaryGadgetEmpty,m_bIsPilot,m_Location,m_CharacterName,m_PrimaryWeapon,m_SecondaryWeapon,m_PrimaryGadget,m_SecondaryGadget;
}

defaultproperties
{
    m_iTeamId=-1
    m_fClientUpdateFrequency=0.20
    RemoteRole=ROLE_AutonomousProxy
    DrawType=0
    bHidden=True
    bSkipActorPropertyReplication=True
    NetUpdateFrequency=5.00
}
