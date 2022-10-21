//================================================================================
// R6ServerInfo.
//================================================================================
class R6ServerInfo extends Object
	Native
//	Export
	Config(server);

var config int MaxPlayers;
var config int NbTerro;
var config int RoundTime;
var config int RoundsPerMatch;
var config int BetweenRoundTime;
var config int BombTime;
var config int DiffLevel;
var config bool CamFirstPerson;
var config bool CamThirdPerson;
var config bool CamFreeThirdP;
var config bool CamGhost;
var config bool CamFadeToBlack;
var config bool CamTeamOnly;
var config bool UsePassword;
var config bool UseAdminPassword;
var config bool ShowNames;
var config bool InternetServer;
var config bool DedicatedServer;
var config bool FriendlyFire;
var config bool Autobalance;
var config bool TeamKillerPenalty;
var config bool AllowRadar;
var config bool ForceFPersonWeapon;
var config bool AIBkp;
var config bool RotateMap;
var config float SpamThreshold;
var config float ChatLockDuration;
var config float VoteBroadcastMaxFrequency;
var R6MapList m_ServerMapList;
var GameInfo m_GameInfo;
var config array<Class> RestrictedSubMachineGuns;
var config array<Class> RestrictedShotGuns;
var config array<Class> RestrictedAssultRifles;
var config array<Class> RestrictedMachineGuns;
var config array<Class> RestrictedSniperRifles;
var config array<Class> RestrictedPistols;
var config array<Class> RestrictedMachinePistols;
var config array<string> RestrictedPrimary;
var config array<string> RestrictedSecondary;
var config array<string> RestrictedMiscGadgets;
var config string ServerName;
var config string GamePassword;
var config string MOTD;
var config string AdminPassword;

function PostBeginPlay ()
{
}

function ClearSettings ()
{
	RestrictedSubMachineGuns.Remove (0,RestrictedSubMachineGuns.Length);
	RestrictedSubMachineGuns.Remove (0,RestrictedSubMachineGuns.Length);
	RestrictedShotGuns.Remove (0,RestrictedShotGuns.Length);
	RestrictedAssultRifles.Remove (0,RestrictedAssultRifles.Length);
	RestrictedMachineGuns.Remove (0,RestrictedMachineGuns.Length);
	RestrictedSniperRifles.Remove (0,RestrictedSniperRifles.Length);
	RestrictedPistols.Remove (0,RestrictedPistols.Length);
	RestrictedMachinePistols.Remove (0,RestrictedMachinePistols.Length);
	RestrictedPrimary.Remove (0,RestrictedPrimary.Length);
	RestrictedSecondary.Remove (0,RestrictedSecondary.Length);
	RestrictedMiscGadgets.Remove (0,RestrictedMiscGadgets.Length);
}

event RestartServer ()
{
	if ( m_GameInfo != None )
	{
		m_GameInfo.AbortScoreSubmission();
		m_GameInfo.bChangeLevels=True;
		m_GameInfo.m_bChangedServerConfig=True;
		m_GameInfo.SetJumpingMaps(True,0);
		m_GameInfo.RestartGameMgr();
	}
}

defaultproperties
{
    MaxPlayers=16
    RoundTime=240
    RoundsPerMatch=10
    BetweenRoundTime=45
    BombTime=45
    DiffLevel=2
    CamFirstPerson=True
    CamThirdPerson=True
    CamFreeThirdP=True
    CamGhost=True
    CamTeamOnly=True
    ShowNames=True
    InternetServer=True
    DedicatedServer=True
    FriendlyFire=True
    Autobalance=True
    TeamKillerPenalty=True
    AllowRadar=True
    ForceFPersonWeapon=True
    SpamThreshold=5.00
    ChatLockDuration=15.00
    VoteBroadcastMaxFrequency=15.00
    ServerName="Raven Shield ADVER"
}