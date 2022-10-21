//================================================================================
// GameReplicationInfo.
//================================================================================
class GameReplicationInfo extends ReplicationInfo
	Native
	NativeReplication;

const RSS_EndOfMatch=4;
const RSS_InGameState=3;
const RSS_InPreGameState=2;
const RSS_CountDownStage=1;
const RSS_PlayersConnectingStage=0;
var ER6GameType m_eGameTypeFlag;
var byte m_bReceivedGameType;
var byte m_eOldServerState;
var byte m_eCurrectServerState;
var byte m_iNbWeaponsTerro;
var byte m_aRepMObjCompleted[16];
var byte m_aRepMObjFailed[16];
var byte m_bRepMObjInProgress;
var byte m_bRepMObjSuccess;
var byte m_bRepLastRoundSuccess;
var int GoalScore;
var int TimeLimit;
var() globalconfig int ServerRegion;
var int m_iMapIndex;
var int m_iGameSvrGroupID;
var int m_iGameSvrLobbyID;
var bool bTeamGame;
var bool m_bShowPlayerStates;
var bool m_bInPostBetweenRoundTime;
var bool m_bServerAllowRadar;
var bool m_bRepAllowRadarOption;
var bool m_bGameOverRep;
var bool m_bRestartableByJoin;
var TeamInfo Teams[2];
var Actor Winner;
var string GameName;
var string GameClass;
var() globalconfig string ServerName;
var() globalconfig string ShortName;
var() globalconfig string AdminName;
var() globalconfig string AdminEmail;
var() globalconfig string MOTDLine1;
var() globalconfig string MOTDLine2;
var() globalconfig string MOTDLine3;
var() globalconfig string MOTDLine4;
var string m_aRepMObjDescription[16];
var string m_aRepMObjDescriptionLocFile[16];

replication
{
	reliable if ( bNetInitial && (Role == Role_Authority) )
		m_eGameTypeFlag,GoalScore,TimeLimit,ServerRegion,m_iMapIndex,bTeamGame,GameName,GameClass,ServerName,ShortName,AdminName,AdminEmail,MOTDLine1,MOTDLine2,MOTDLine3,MOTDLine4;
	reliable if ( Role == Role_Authority )
		m_eCurrectServerState,m_iNbWeaponsTerro,m_aRepMObjCompleted,m_aRepMObjFailed,m_bRepMObjInProgress,m_bRepMObjSuccess,m_bRepLastRoundSuccess,m_iGameSvrGroupID,m_iGameSvrLobbyID,m_bInPostBetweenRoundTime,m_bServerAllowRadar,m_bRepAllowRadarOption,m_bGameOverRep,m_bRestartableByJoin,m_aRepMObjDescription,m_aRepMObjDescriptionLocFile;
	reliable if ( bNetDirty && (Role == Role_Authority) )
		Teams,Winner;
}

simulated function ControllerStarted (R6GameMenuCom NewMenuCom);

simulated event NewServerState ();

simulated event SaveRemoteServerSettings (string NewServerFile);

function SetServerState (byte NewState)
{
	if ( NewState != m_eCurrectServerState )
	{
		m_eCurrectServerState=NewState;
		if ( Level.NetMode == NM_ListenServer )
		{
			NewServerState();
		}
	}
}

simulated function PostBeginPlay ()
{
	m_eGameTypeFlag=RGM_AllMode;
	if ( Level.NetMode == NM_Client )
	{
		ServerName="";
		AdminName="";
		AdminEmail="";
		MOTDLine1="";
		MOTDLine2="";
		MOTDLine3="";
		MOTDLine4="";
	}
}

function Reset ()
{
	Super.Reset();
	Winner=None;
}

simulated function ResetOriginalData ()
{
	Super.ResetOriginalData();
	m_bInPostBetweenRoundTime=False;
	m_bGameOverRep=False;
}

function RefreshMPlayerInfo ();

function SetRepMObjInfo (int Index, bool bFailed, bool bCompleted)
{
	if ( bFailed )
	{
		m_aRepMObjFailed[Index]=1;
	}
	else
	{
		m_aRepMObjFailed[Index]=0;
	}
	if ( bCompleted )
	{
		m_aRepMObjCompleted[Index]=1;
	}
	else
	{
		m_aRepMObjCompleted[Index]=0;
	}
}

function SetRepMObjString (int Index, string szDesc, string szLocFile)
{
	m_aRepMObjDescription[Index]=szDesc;
	m_aRepMObjDescriptionLocFile[Index]=szLocFile;
}

simulated function string GetRepMObjStringLocFile (int Index)
{
	return m_aRepMObjDescriptionLocFile[Index];
}

simulated function string GetRepMObjString (int Index)
{
	return m_aRepMObjDescription[Index];
}

simulated function bool IsRepMObjCompleted (int Index)
{
	return m_aRepMObjCompleted[Index] == 1;
}

simulated function bool IsRepMObjFailed (int Index)
{
	return m_aRepMObjFailed[Index] == 1;
}

simulated function ResetRepMObjInfo ()
{
	local int i;

	for (i=0;i < 16;++i)
	{
		m_aRepMObjDescription[i]="";
		m_aRepMObjDescriptionLocFile[i]="";
		SetRepMObjInfo(i,False,False);
	}
	m_bRepMObjSuccess=0;
	m_bRepMObjInProgress=1;
}

simulated function int GetRepMObjInfoArraySize ()
{
	return 16;
}

simulated function SetRepMObjInProgress (bool bInProgress)
{
	if ( bInProgress )
	{
		m_bRepMObjInProgress=1;
	}
	else
	{
		m_bRepMObjInProgress=0;
	}
}

simulated function SetRepMObjSuccess (bool bSuccess)
{
	if ( bSuccess )
	{
		m_bRepMObjSuccess=1;
	}
	else
	{
		m_bRepMObjSuccess=0;
	}
}

simulated function SetRepLastRoundSuccess (byte bLastRoundSuccess)
{
	m_bRepLastRoundSuccess=bLastRoundSuccess;
}

simulated function bool IsInAGameState ()
{
	return (m_eCurrectServerState == 2) || (m_eCurrectServerState == 3);
}

defaultproperties
{
    m_bRestartableByJoin=True
    ServerName="Another Server"
    ShortName="Server"
    RemoteRole=ROLE_SimulatedProxy
}