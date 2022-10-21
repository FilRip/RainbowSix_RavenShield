//================================================================================
// R6ServerList.
//================================================================================
class R6ServerList extends R6AbstractGameService
	Native;

enum eSortCategory {
	eSG_Favorite,
	eSG_Locked,
	eSG_Dedicated,
	eSG_PunkBuster,
	eSG_PingTime,
	eSG_Name,
	eSG_GameType,
	eSG_GameMode,
	eSG_Map,
	eSG_NumPlayers
};

struct stFilterSettings
{
	var bool bDeathMatch;
	var bool bTeamDeathMatch;
	var bool bDisarmBomb;
	var bool bHostageRescueAdv;
	var bool bEscortPilot;
	var bool bMission;
	var bool bTerroristHunt;
	var bool bTerroristHuntAdv;
	var bool bScatteredHuntAdv;
	var bool bCaptureTheEnemyAdv;
	var bool bKamikaze;
	var bool bHostageRescueCoop;
	var bool bDefend;
	var bool bRecon;
	var bool bSquadDeathMatch;
	var bool bSquadTeamDeathMatch;
	var bool bDebugGameMode;
	var bool bUnlockedOnly;
	var bool bFavoritesOnly;
	var bool bDedicatedServersOnly;
	var bool bServersNotEmpty;
	var bool bServersNotFull;
	var bool bResponding;
	var bool bSameVersion;
	var string szHasPlayer;
	var int iFasterThan;
};

enum ER6GameType {
	RGM_AllMode,
	RGM_StoryMode,
	RGM_PracticeMode,
	RGM_MissionMode,
	RGM_TerroristHuntMode,
	RGM_TerroristHuntCoopMode,
	RGM_HostageRescueMode,
	RGM_HostageRescueCoopMode,
	RGM_HostageRescueAdvMode,
	RGM_DefendMode,
	RGM_DefendCoopMode,
	RGM_ReconMode,
	RGM_ReconCoopMode,
	RGM_DeathmatchMode,
	RGM_TeamDeathmatchMode,
	RGM_BombAdvMode,
	RGM_EscortAdvMode,
	RGM_LoneWolfMode,
	RGM_SquadDeathmatch,
	RGM_SquadTeamDeathmatch,
	RGM_TerroristHuntAdvMode,
	RGM_ScatteredHuntAdvMode,
	RGM_CaptureTheEnemyAdvMode,
	RGM_CountDownMode,
	RGM_KamikazeMode,
	RGM_NoRulesMode
};

struct stGameTypeAndMap
{
	var string szMap;
	var ER6GameType eGameType;
};

struct stRemotePlayers
{
	var string szAlias;
	var int iPing;
	var int iGroupID;
	var int iLobbySrvID;
	var int iSkills;
	var int iRank;
	var string szTime;
};

struct stGameData
{
	var bool bUsePassword;
	var bool bDedicatedServer;
	var int iRoundsPerMatch;
	var int iRoundTime;
	var int iBetTime;
	var int iBombTime;
	var bool bShowNames;
	var bool bInternetServer;
	var bool bFriendlyFire;
	var bool bAutoBalTeam;
	var bool bTKPenalty;
	var bool bRadar;
	var bool bAdversarial;
	var bool bRotateMap;
	var bool bAIBkp;
	var bool bForceFPWeapon;
	var bool bPunkBuster;
	var int iNumMaps;
	var int iNumTerro;
	var int iPort;
	var string szName;
	var string szModName;
	var int iMaxPlayer;
	var int iNbrPlayer;
	var ER6GameType eGameType;
	var string szGameType;
	var string szCurrentMap;
	var string szMessageOfDay;
	var string szGameVersion;
	var array<stGameTypeAndMap> gameMapList;
	var array<stRemotePlayers> PlayerList;
	var string szPassword;
};

struct stGameServer
{
	var int iGroupID;
	var int iLobbySrvID;
	var int iBeaconPort;
	var int iPing;
	var string szIPAddress;
	var string szAltIPAddress;
	var bool bUseAltIP;
	var bool bDisplay;
	var bool bFavorite;
	var bool bSameVersion;
	var string szOptions;
	var stGameData sGameData;
};

struct IpAddr
{
	var int Addr;
	var int Port;
};

enum ECDKEYST_STATUS {
	ECDKEYST_PLAYER_UNKNOWN,
	ECDKEYST_PLAYER_INVALID,
	ECDKEYST_PLAYER_VALID,
	ECDKEYST_PLAYER_BANNED
};

struct stValidationResponse
{
	var int iReqID;
	var ECDKEYST_STATUS eStatus;
	var bool bSuceeded;
	var bool bTimeout;
	var byte ucGlobalID[16];
};

const K_GlobalID_size= 16;

var int m_iSelSrvIndex;
var int m_iIndRefrIndex;
var bool m_bDedicatedServer;
var bool m_bServerListChanged;
var bool m_bServerInfoChanged;
var config bool m_bUseCDKey;
var bool m_bIndRefrInProgress;
var config bool m_bSavePWSave;
var config bool m_bAutoLISave;
var ClientBeaconReceiver m_ClientBeacon;
var array<string> m_favoriteServersList;
var array<stGameServer> m_GameServerList;
var array<stValidationResponse> m_ValidResponseList;
var array<int> m_GSLSortIdx;
var config stFilterSettings m_Filters;
var stGameServer m_CrGameSrvInfo;
var string m_szGameVersion;

native(1222) final function NativeInitFavorites ();

native(1223) final function NativeUpdateFavorites ();

native(1225) final function int NativeGetPingTime (coerce string IpAddr);

native(1202) final function int NativeGetPingTimeOut ();

native(1278) final function int NativeGetMilliSeconds ();

native(1206) final function SortServers (int _iSortType, bool _bAscending);

native(1236) final function NativeResetSvrContainer ();

native(1229) final function NativeFillSvrContainer ();

native(1291) final function NativeSetOwnSvrPort (int iPort);

native(1292) final function int NativeGetOwnSvrPort ();

native(1351) final function int NativeGetLobbyID ();

native(1352) final function int NativeGetGroupID ();

native(1355) final function int NativeGetMaxPlayers ();

native(1314) final function int GetDisplayListSize ();

function getServerListItem (int iSortIdx, out stGameServer _stGameServer)
{
	local int Index;

	Index=m_GSLSortIdx[iSortIdx];
	_stGameServer.bFavorite=m_GameServerList[Index].bFavorite;
	_stGameServer.bSameVersion=m_GameServerList[Index].bSameVersion;
	_stGameServer.szIPAddress=m_GameServerList[Index].szIPAddress;
	_stGameServer.iPing=m_GameServerList[Index].iPing;
	_stGameServer.sGameData.szName=m_GameServerList[Index].sGameData.szName;
	_stGameServer.sGameData.szCurrentMap=m_GameServerList[Index].sGameData.szCurrentMap;
	_stGameServer.sGameData.iMaxPlayer=m_GameServerList[Index].sGameData.iMaxPlayer;
	_stGameServer.sGameData.iNbrPlayer=m_GameServerList[Index].sGameData.iNbrPlayer;
	_stGameServer.sGameData.eGameType=m_GameServerList[Index].sGameData.eGameType;
	_stGameServer.sGameData.bUsePassword=m_GameServerList[Index].sGameData.bUsePassword;
	_stGameServer.sGameData.bDedicatedServer=m_GameServerList[Index].sGameData.bDedicatedServer;
	_stGameServer.sGameData.bPunkBuster=m_GameServerList[Index].sGameData.bPunkBuster;
}

function UpdateFilters ()
{
	local R6ModMgr pModMgr;
	local int i;
	local int j;
	local bool bFound;
	local bool bIsRavenShield;
	local string szCurrentMod;

	pModMgr=Class'Actor'.static.GetModMgr();
	szCurrentMod=pModMgr.m_pCurrentMod.m_szKeyWord;
	bIsRavenShield=pModMgr.IsRavenShield();
	i=0;
JL004C:
	if ( i < m_GameServerList.Length )
	{
		m_GameServerList[i].bDisplay=True;
		if (  !m_Filters.bDeathMatch && (m_GameServerList[i].sGameData.eGameType == 13) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bTeamDeathMatch && (m_GameServerList[i].sGameData.eGameType == 14) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bDisarmBomb && (m_GameServerList[i].sGameData.eGameType == 15) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bHostageRescueAdv && (m_GameServerList[i].sGameData.eGameType == 8) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bEscortPilot && (m_GameServerList[i].sGameData.eGameType == 16) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bMission && (m_GameServerList[i].sGameData.eGameType == 3) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bTerroristHunt && (m_GameServerList[i].sGameData.eGameType == 5) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bHostageRescueCoop && (m_GameServerList[i].sGameData.eGameType == 7) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bDefend && (m_GameServerList[i].sGameData.eGameType == 10) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bRecon && (m_GameServerList[i].sGameData.eGameType == 12) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bSquadDeathMatch && (m_GameServerList[i].sGameData.eGameType == 18) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bSquadTeamDeathMatch && (m_GameServerList[i].sGameData.eGameType == 19) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !m_Filters.bDebugGameMode && (m_GameServerList[i].sGameData.eGameType == 25) )
		{
			m_GameServerList[i].bDisplay=False;
		}
		if (  !bIsRavenShield )
		{
			if ( (m_GameServerList[i].sGameData.szModName == "") ||  !(m_GameServerList[i].sGameData.szModName ~= szCurrentMod) )
			{
				m_GameServerList[i].bDisplay=False;
			}
			else
			{
				if (  !m_Filters.bTerroristHuntAdv && (m_GameServerList[i].sGameData.eGameType == 20) )
				{
					m_GameServerList[i].bDisplay=False;
				}
				if (  !m_Filters.bScatteredHuntAdv && (m_GameServerList[i].sGameData.eGameType == 21) )
				{
					m_GameServerList[i].bDisplay=False;
				}
				if (  !m_Filters.bCaptureTheEnemyAdv && (m_GameServerList[i].sGameData.eGameType == 22) )
				{
					m_GameServerList[i].bDisplay=False;
				}
				if (  !m_Filters.bKamikaze && (m_GameServerList[i].sGameData.eGameType == 24) )
				{
					m_GameServerList[i].bDisplay=False;
				}
				if (  !m_Filters.bDebugGameMode && (m_GameServerList[i].sGameData.eGameType == 25) )
				{
					m_GameServerList[i].bDisplay=False;
				}
				goto JL0700;
				if ( (m_GameServerList[i].sGameData.szModName != "") &&  !(m_GameServerList[i].sGameData.szModName ~= szCurrentMod) )
				{
					m_GameServerList[i].bDisplay=False;
				}
				else
				{
					if ( m_GameServerList[i].sGameData.eGameType == 20 )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_GameServerList[i].sGameData.eGameType == 21 )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_GameServerList[i].sGameData.eGameType == 22 )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_GameServerList[i].sGameData.eGameType == 24 )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_GameServerList[i].sGameData.eGameType == 25 )
					{
						m_GameServerList[i].bDisplay=False;
					}
JL0700:
					if ( m_Filters.szHasPlayer != "" )
					{
						bFound=False;
						j=0;
JL0720:
						if ( j < m_GameServerList[i].sGameData.PlayerList.Length )
						{
							if ( InStr(Caps(m_GameServerList[i].sGameData.PlayerList[j].szAlias),Caps(m_Filters.szHasPlayer)) != -1 )
							{
								bFound=True;
							}
							j++;
							goto JL0720;
						}
						if (  !bFound )
						{
							m_GameServerList[i].bDisplay=False;
						}
					}
					if ( m_Filters.bUnlockedOnly && m_GameServerList[i].sGameData.bUsePassword )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_Filters.bFavoritesOnly &&  !m_GameServerList[i].bFavorite )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_Filters.bDedicatedServersOnly &&  !m_GameServerList[i].sGameData.bDedicatedServer )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_Filters.bServersNotEmpty && (m_GameServerList[i].sGameData.iNbrPlayer == 0) )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_Filters.bServersNotFull && (m_GameServerList[i].sGameData.iNbrPlayer >= m_GameServerList[i].sGameData.iMaxPlayer) )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_Filters.bResponding && (m_GameServerList[i].iPing >= 1000) )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( (m_Filters.iFasterThan > 0) && (m_GameServerList[i].iPing > m_Filters.iFasterThan) )
					{
						m_GameServerList[i].bDisplay=False;
					}
					if ( m_Filters.bSameVersion &&  !m_GameServerList[i].bSameVersion )
					{
						m_GameServerList[i].bDisplay=False;
					}
				}
			}
		}
		i++;
		goto JL004C;
	}
}

function bool IsAFavorite (string szIPAddress)
{
	local int i;
	local bool bFound;

	bFound=False;
	i=0;
JL000F:
	if ( (i < m_favoriteServersList.Length) &&  !bFound )
	{
		if ( szIPAddress == m_favoriteServersList[i] )
		{
			bFound=True;
		}
		i++;
		goto JL000F;
	}
	return bFound;
}

function AddToFavorites (int sortedListIdx)
{
	local int i;
	local bool Found;
	local int serverListIndex;

	serverListIndex=m_GSLSortIdx[sortedListIdx];
	m_GameServerList[serverListIndex].bFavorite=True;
	Found=False;
	i=0;
JL0033:
	if ( (i < m_favoriteServersList.Length) &&  !Found )
	{
		if ( m_GameServerList[serverListIndex].szIPAddress == m_favoriteServersList[i] )
		{
			Found=True;
		}
		i++;
		goto JL0033;
	}
	if (  !Found )
	{
		m_favoriteServersList[m_favoriteServersList.Length]=m_GameServerList[serverListIndex].szIPAddress;
		NativeUpdateFavorites();
	}
}

function DelFromFavorites (int sortedListIdx)
{
	local int i;
	local int favoritesListIndex;
	local bool Found;
	local int serverListIndex;

	serverListIndex=m_GSLSortIdx[sortedListIdx];
	m_GameServerList[serverListIndex].bFavorite=False;
	Found=False;
	i=0;
JL0033:
	if ( (i < m_favoriteServersList.Length) &&  !Found )
	{
		if ( m_GameServerList[serverListIndex].szIPAddress == m_favoriteServersList[i] )
		{
			Found=True;
			favoritesListIndex=i;
		}
		i++;
		goto JL0033;
	}
	if ( Found )
	{
		m_favoriteServersList.Remove (favoritesListIndex,1);
		NativeUpdateFavorites();
	}
}

function SetSelectedServer (int iServerListIndex)
{
	if ( (iServerListIndex > m_GameServerList.Length) || (m_GameServerList.Length == 0) )
	{
		return;
	}
	m_iSelSrvIndex=m_GSLSortIdx[iServerListIndex];
}

function Created ()
{
	m_szGameVersion=Class'Actor'.static.GetGameVersion();
}

function stGameData getSvrData (int iBeaconIdx)
{
	local stGameData sGameData;
	local stGameTypeAndMap sMapAndGame;
	local stRemotePlayers remPlayer;
	local int j;

	sGameData.bUsePassword=m_ClientBeacon.GetLocked(iBeaconIdx);
	sGameData.bDedicatedServer=m_ClientBeacon.GetDedicated(iBeaconIdx);
	sGameData.iRoundsPerMatch=m_ClientBeacon.GetRoundsPerMap(iBeaconIdx);
	sGameData.iRoundTime=m_ClientBeacon.GetRoundTime(iBeaconIdx);
	sGameData.iBetTime=m_ClientBeacon.GetBetTime(iBeaconIdx);
	sGameData.iBombTime=m_ClientBeacon.GetBombTime(iBeaconIdx);
	sGameData.bShowNames=m_ClientBeacon.GetShowEnemyNames(iBeaconIdx);
	sGameData.bInternetServer=m_ClientBeacon.GetInternetServer(iBeaconIdx);
	sGameData.bFriendlyFire=m_ClientBeacon.GetFriendlyFire(iBeaconIdx);
	sGameData.bAutoBalTeam=m_ClientBeacon.GetAutoBalanceTeam(iBeaconIdx);
	sGameData.bRadar=m_ClientBeacon.GetRadar(iBeaconIdx);
	sGameData.bTKPenalty=m_ClientBeacon.GetTKPenalty(iBeaconIdx);
	sGameData.iPort=m_ClientBeacon.GetPortNumber(iBeaconIdx);
//	sGameData.eGameType=m_ClientBeacon.GetCurrGameType(iBeaconIdx);
	sGameData.szName=m_ClientBeacon.GetSvrName(iBeaconIdx);
	sGameData.szModName=m_ClientBeacon.GetModName(iBeaconIdx);
	sGameData.iNumTerro=m_ClientBeacon.GetNumTerrorists(iBeaconIdx);
	sGameData.bAIBkp=m_ClientBeacon.GetAIBackup(iBeaconIdx);
	sGameData.bRotateMap=m_ClientBeacon.GetRotateMap(iBeaconIdx);
	sGameData.bForceFPWeapon=m_ClientBeacon.GetForceFirstPersonWeapon(iBeaconIdx);
	sGameData.bPunkBuster=m_ClientBeacon.GetPunkBusterEnabled(iBeaconIdx);
	sGameData.szGameVersion=m_ClientBeacon.GetServerGameVersion(iBeaconIdx);
	sGameData.iMaxPlayer=m_ClientBeacon.GetMaxPlayers(iBeaconIdx);
	sGameData.iNbrPlayer=m_ClientBeacon.GetNumPlayers(iBeaconIdx);
	sGameData.szCurrentMap=m_ClientBeacon.GetFirstMapName(iBeaconIdx);
	sGameData.gameMapList.Remove (0,sGameData.gameMapList.Length);
	j=0;
JL0339:
	if ( j < m_ClientBeacon.GetMapListSize(iBeaconIdx) )
	{
		sMapAndGame.szMap=m_ClientBeacon.GetOneMapName(iBeaconIdx,j);
//		sMapAndGame.eGameType=m_ClientBeacon.GetGameType(iBeaconIdx,j);
		sGameData.gameMapList[j]=sMapAndGame;
		j++;
		goto JL0339;
	}
	sGameData.PlayerList.Remove (0,sGameData.PlayerList.Length);
	j=0;
JL03DD:
	if ( j < m_ClientBeacon.GetPlayerListSize(iBeaconIdx) )
	{
		remPlayer.szAlias=m_ClientBeacon.GetPlayerName(iBeaconIdx,j);
		remPlayer.szTime=m_ClientBeacon.GetPlayerTime(iBeaconIdx,j);
		remPlayer.iPing=m_ClientBeacon.GetPlayerPingTime(iBeaconIdx,j);
		remPlayer.iSkills=m_ClientBeacon.GetPlayerKillCount(iBeaconIdx,j);
		sGameData.PlayerList[j]=remPlayer;
		j++;
		goto JL03DD;
	}
	return sGameData;
}

function SortPlayersByKills (bool _bAscending, int _iIdx)
{
	local int i;
	local int j;
	local bool bSwap;
	local int iListSize;
	local stRemotePlayers tempPlayer;

	iListSize=m_GameServerList[_iIdx].sGameData.PlayerList.Length;
	i=0;
JL0023:
	if ( i < iListSize - 1 )
	{
		j=0;
JL003C:
		if ( j < iListSize - 1 - i )
		{
			if ( _bAscending )
			{
				bSwap=m_GameServerList[_iIdx].sGameData.PlayerList[j].iSkills > m_GameServerList[_iIdx].sGameData.PlayerList[j + 1].iSkills;
			}
			else
			{
				bSwap=m_GameServerList[_iIdx].sGameData.PlayerList[j].iSkills < m_GameServerList[_iIdx].sGameData.PlayerList[j + 1].iSkills;
			}
			if ( bSwap )
			{
				tempPlayer=m_GameServerList[_iIdx].sGameData.PlayerList[j];
				m_GameServerList[_iIdx].sGameData.PlayerList[j]=m_GameServerList[_iIdx].sGameData.PlayerList[j + 1];
				m_GameServerList[_iIdx].sGameData.PlayerList[j + 1]=tempPlayer;
			}
			j++;
			goto JL003C;
		}
		i++;
		goto JL0023;
	}
}

function int GetTotalPlayers ()
{
	local int i;
	local int iTotal;
	local int iMaxPlayers;

	iTotal=0;
	iMaxPlayers=NativeGetMaxPlayers();
	i=0;
JL0017:
	if ( i < m_GameServerList.Length )
	{
		if ( (m_GameServerList[i].sGameData.iNbrPlayer <= iMaxPlayers) && (m_GameServerList[i].sGameData.iNbrPlayer > 0) )
		{
			iTotal += m_GameServerList[i].sGameData.iNbrPlayer;
		}
		i++;
		goto JL0017;
	}
	return iTotal;
}

defaultproperties
{
    m_bUseCDKey=True
}
