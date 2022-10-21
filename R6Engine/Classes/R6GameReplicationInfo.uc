//================================================================================
// R6GameReplicationInfo.
//================================================================================
class R6GameReplicationInfo extends GameReplicationInfo
	Native;
//	NoNativeReplication;

const m_MapLength= 32;
var int m_iDeathCameraMode;
var int m_iCurrGameType;
var int m_MaxPlayers;
var int m_iCurrentRound;
var int m_iRoundsPerMatch;
var int m_iDiffLevel;
var int m_iNbOfTerro;
var int m_iMenuCountDownTime;
var int m_aTeamScore[2];
var const int c_iTeamNumBravo;
var bool bShowLog;
var bool m_bPasswordReq;
var bool m_bAdminPasswordReq;
var bool m_bFriendlyFire;
var bool m_bAutoBalance;
var bool m_bTKPenalty;
var bool m_bMenuTKPenaltySetting;
var bool m_bShowNames;
var bool m_bInternetSvr;
var bool m_bFFPWeapon;
var bool m_bDedicatedSvr;
var bool m_bAIBkp;
var bool m_bRotateMap;
var bool m_bPunkBuster;
var bool m_bRepMenuCountDownTimePaused;
var bool m_bRepMenuCountDownTimeUnlimited;
var bool m_bIsWritableMapAllowed;
var float m_fTimeBetRounds;
var float m_fBombTime;
var float m_fRepMenuCountDownTime;
var float m_fRepMenuCountDownTimeLastUpdate;
var R6RainbowTeam m_RainbowTeam[3];
var R6GameMenuCom m_MenuCommunication;
var string m_mapArray[32];
var string m_gameModeArray[32];
var string m_szSubMachineGunsRes[32];
var string m_szShotGunRes[32];
var string m_szAssRifleRes[32];
var string m_szMachGunRes[32];
var string m_szSnipRifleRes[32];
var string m_szPistolRes[32];
var string m_szMachPistolRes[32];
var string m_szGadgPrimaryRes[32];
var string m_szGadgSecondayRes[32];
var string m_szGadgMiscRes[32];

replication
{
	reliable if ( bNetInitial && (Role == Role_Authority) )
		m_iDeathCameraMode,m_iCurrGameType,m_MaxPlayers,m_iRoundsPerMatch,m_iDiffLevel,m_iNbOfTerro,m_bPasswordReq,m_bAdminPasswordReq,m_bFriendlyFire,m_bAutoBalance,m_bTKPenalty,m_bMenuTKPenaltySetting,m_bShowNames,m_bInternetSvr,m_bFFPWeapon,m_bDedicatedSvr,m_bAIBkp,m_bRotateMap,m_bPunkBuster,m_bIsWritableMapAllowed,m_fTimeBetRounds,m_fBombTime,m_mapArray,m_gameModeArray;
	reliable if ( Role == Role_Authority )
		m_iCurrentRound,m_aTeamScore,m_bRepMenuCountDownTimePaused,m_bRepMenuCountDownTimeUnlimited,m_fRepMenuCountDownTime;
	reliable if ( Role == Role_Authority )
		m_szSubMachineGunsRes,m_szShotGunRes,m_szAssRifleRes,m_szMachGunRes,m_szSnipRifleRes,m_szPistolRes,m_szMachPistolRes,m_szGadgPrimaryRes,m_szGadgSecondayRes,m_szGadgMiscRes;
}

simulated function FirstPassReset ()
{
	m_RainbowTeam[0]=None;
	m_RainbowTeam[1]=None;
	m_RainbowTeam[2]=None;
}

simulated event Tick (float fDeltaTime)
{
	Super.Tick(fDeltaTime);
	if ( (Level.NetMode == NM_Client) &&  !m_bRepMenuCountDownTimePaused &&  !m_bRepMenuCountDownTimeUnlimited )
	{
		m_fRepMenuCountDownTime -= fDeltaTime;
		if ( m_fRepMenuCountDownTime < 0.00 )
		{
			m_fRepMenuCountDownTime=0.00;
		}
	}
}

simulated function float GetRoundTime ()
{
	if ( Level.NetMode == NM_ListenServer )
	{
		return m_iMenuCountDownTime;
	}
	return m_fRepMenuCountDownTime;
}

simulated function ControllerStarted (R6GameMenuCom NewMenuCom)
{
	m_MenuCommunication=NewMenuCom;
}

simulated event Destroyed ()
{
	Super.Destroyed();
	if ( m_MenuCommunication != None )
	{
		m_MenuCommunication.ClearLevelReferences();
	}
}

function PlaySoundStatus ();

simulated function RefreshMPlayerInfo ()
{
	m_MenuCommunication.m_iLastValidIndex=0;
	m_MenuCommunication.m_szServerName=ServerName;
	RefreshMPInfoPlayerStats();
}

simulated function RefreshMPInfoPlayerStats ()
{
	local PlayerReplicationInfo PRI;
	local PlayerMenuInfo _PlayerMenuInfo;
	local int _iLastValidIndex;

	foreach DynamicActors(Class'PlayerReplicationInfo',PRI)
	{
		if ( bShowLog )
		{
			Log("RefreshMPlayerInfo Index:" @ string(_iLastValidIndex) @ "PRI is" @ string(PRI) @ "Name is" @ PRI.PlayerName);
		}
		if ( PRI.m_iRoundsHit > 0 )
		{
			if ( PRI.m_iRoundsHit < PRI.m_iRoundFired )
			{
				_PlayerMenuInfo.iEfficiency=PRI.m_iRoundsHit * 100 / PRI.m_iRoundFired;
			}
			else
			{
				_PlayerMenuInfo.iEfficiency=100;
			}
		}
		else
		{
			_PlayerMenuInfo.iEfficiency=0;
		}
		_PlayerMenuInfo.szPlayerName=PRI.PlayerName;
		_PlayerMenuInfo.iKills=PRI.m_iKillCount;
		_PlayerMenuInfo.iRoundsFired=PRI.m_iRoundFired;
		_PlayerMenuInfo.iRoundsHit=PRI.m_iRoundsHit;
		_PlayerMenuInfo.szKilledBy=PRI.m_szKillersName;
		_PlayerMenuInfo.iPingTime=PRI.Ping;
		_PlayerMenuInfo.iHealth=PRI.m_iHealth;
		_PlayerMenuInfo.bJoinedTeamLate=PRI.m_bJoinedTeamLate;
		_PlayerMenuInfo.iTeamSelection=PRI.TeamID;
		_PlayerMenuInfo.iRoundsPlayed=PRI.m_iRoundsPlayed;
		_PlayerMenuInfo.iRoundsWon=PRI.m_iRoundsWon;
		_PlayerMenuInfo.iDeathCount=PRI.Deaths;
		_PlayerMenuInfo.bPlayerReady=PRI.m_bPlayerReady;
		_PlayerMenuInfo.bSpectator=(PRI.TeamID == 0) || (PRI.TeamID == 4);
		if ( m_bShowPlayerStates )
		{
			Log("DBG: " $ PRI.PlayerName $ " bSpectator=" $ string(_PlayerMenuInfo.bSpectator) $ " TeamID=" $ string(PRI.TeamID));
		}
		if ( PRI.Owner == None )
		{
			_PlayerMenuInfo.bOwnPlayer=False;
		}
		else
		{
			_PlayerMenuInfo.bOwnPlayer=Viewport(PlayerController(PRI.Owner).Player) != None;
		}
		SetFPlayerMenuInfo(_iLastValidIndex,_PlayerMenuInfo);
		_iLastValidIndex++;
	}
	SortFPlayerMenuInfo(_iLastValidIndex,m_iCurrGameType);
	if ( m_MenuCommunication != None )
	{
		m_MenuCommunication.m_iLastValidIndex=_iLastValidIndex;
	}
}

simulated event NewServerState ()
{
	if ( (m_MenuCommunication != None) &&  !m_MenuCommunication.m_bImCurrentlyDisconnect )
	{
		m_MenuCommunication.NewServerState();
	}
}

simulated event SaveRemoteServerSettings (string NewServerFile)
{
	local R6ServerInfo pServerOptions;
	local int _iCount;
	local WindowConsole _console;

	pServerOptions=new Class'R6ServerInfo';
	pServerOptions.m_ServerMapList=Spawn(Class'R6MapList');
	pServerOptions.ServerName=ServerName;
	pServerOptions.CamFirstPerson=(m_iDeathCameraMode & 1) > 0;
	pServerOptions.CamThirdPerson=(m_iDeathCameraMode & 2) > 0;
	pServerOptions.CamFreeThirdP=(m_iDeathCameraMode & 4) > 0;
	pServerOptions.CamGhost=(m_iDeathCameraMode & 8) > 0;
	pServerOptions.CamFadeToBlack=(m_iDeathCameraMode & 16) > 0;
	pServerOptions.CamTeamOnly=(m_iDeathCameraMode & 32) > 0;
	pServerOptions.MaxPlayers=m_MaxPlayers;
	pServerOptions.NbTerro=m_iNbOfTerro;
	pServerOptions.UsePassword=False;
	pServerOptions.GamePassword="";
	pServerOptions.MOTD=MOTDLine1;
	pServerOptions.RoundTime=TimeLimit;
	pServerOptions.RoundsPerMatch=m_iRoundsPerMatch;
	pServerOptions.BetweenRoundTime=m_fTimeBetRounds;
	pServerOptions.UseAdminPassword=False;
	pServerOptions.AdminPassword="";
	pServerOptions.BombTime=m_fBombTime;
	pServerOptions.DiffLevel=m_iDiffLevel;
	pServerOptions.ShowNames=m_bShowNames;
	pServerOptions.InternetServer=m_bInternetSvr;
	pServerOptions.DedicatedServer=m_bDedicatedSvr;
	pServerOptions.FriendlyFire=m_bFriendlyFire;
	pServerOptions.Autobalance=m_bAutoBalance;
	pServerOptions.TeamKillerPenalty=m_bMenuTKPenaltySetting;
	pServerOptions.AllowRadar=m_bRepAllowRadarOption;
	pServerOptions.ForceFPersonWeapon=m_bFFPWeapon;
	pServerOptions.AIBkp=m_bAIBkp;
	pServerOptions.RotateMap=m_bRotateMap;
	pServerOptions.ClearSettings();
	_console=WindowConsole(m_MenuCommunication.m_PlayerController.Player.Console);
	_console.GetRestKitDescName(self,pServerOptions);
	_iCount=0;
JL02FB:
	if ( (_iCount < 32) && (m_szGadgPrimaryRes[_iCount] != "") )
	{
		pServerOptions.RestrictedPrimary[_iCount]=m_szGadgPrimaryRes[_iCount];
		_iCount++;
		goto JL02FB;
	}
	_iCount=0;
JL034C:
	if ( (_iCount < 32) && (m_szGadgSecondayRes[_iCount] != "") )
	{
		pServerOptions.RestrictedSecondary[_iCount]=m_szGadgSecondayRes[_iCount];
		_iCount++;
		goto JL034C;
	}
	_iCount=0;
JL039D:
	if ( (_iCount < 32) && (m_szGadgMiscRes[_iCount] != "") )
	{
		pServerOptions.RestrictedMiscGadgets[_iCount]=m_szGadgMiscRes[_iCount];
		_iCount++;
		goto JL039D;
	}
	_iCount=0;
JL03EE:
	if ( _iCount < 32 )
	{
		pServerOptions.m_ServerMapList.GameType[_iCount]=m_gameModeArray[_iCount];
		pServerOptions.m_ServerMapList.Maps[_iCount]=m_mapArray[_iCount];
		_iCount++;
		goto JL03EE;
	}
	pServerOptions.SaveConfig(NewServerFile);
	pServerOptions.m_ServerMapList.SaveConfig(NewServerFile);
}

defaultproperties
{
    c_iTeamNumBravo=3
}
