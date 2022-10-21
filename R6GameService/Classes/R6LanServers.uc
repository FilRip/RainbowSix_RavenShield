//================================================================================
// R6LanServers.
//================================================================================
class R6LanServers extends R6ServerList
	Native;

const K_INDREFR_MAXATT= 4;
const K_REFRESH_TIMEOUT= 1000;
var int m_iIndRefrAttempts;
var int m_iIndRefrEndTime;

function RefreshServers ()
{
	m_GameServerList.Remove (0,m_GameServerList.Length);
	m_GSLSortIdx.Remove (0,m_GSLSortIdx.Length);
	m_ClientBeacon.RefreshServers();
	m_bIndRefrInProgress=False;
}

function RefreshOneServer (int sortedListIdx)
{
	local int serverListIndex;

	serverListIndex=m_GSLSortIdx[sortedListIdx];
	if ( m_bIndRefrInProgress )
	{
		return;
	}
	m_iIndRefrAttempts=0;
	m_bIndRefrInProgress=True;
	m_iIndRefrIndex=serverListIndex;
	SendBeaconToOneServer(serverListIndex);
}

function SendBeaconToOneServer (int iIndex)
{
	local IpAddr Addr;
	local string szIP;

	m_iIndRefrAttempts++;
	m_iIndRefrEndTime=NativeGetMilliSeconds() + 1000;
	szIP=Left(m_GameServerList[iIndex].szIPAddress,InStr(m_GameServerList[iIndex].szIPAddress,":"));
//	m_ClientBeacon.StringToIpAddr(szIP,Addr);
	Addr.Port=m_ClientBeacon.ServerBeaconPort;
//	m_ClientBeacon.BroadcastBeacon(Addr);
}

function Created ()
{
	Super.Created();
	NativeInitFavorites();
}

function LANSeversManager ()
{
	local int i;
	local int j;
	local stGameServer sSvr;
	local bool bFound;
	local int iIndex;
	local string szSvrAddr;
	local bool bListChanged;
	local int iBeaconArraySize;
	local string szCurrentMod;

	bListChanged=False;
	if ( m_ClientBeacon == None )
	{
		return;
	}
	iBeaconArraySize=m_ClientBeacon.GetBeaconListSize();
	szCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szKeyWord;
	i=0;
JL0055:
	if ( i < iBeaconArraySize )
	{
		if ( (m_ClientBeacon.GetBeaconIntAddress(i) != 0) && m_ClientBeacon.GetNewDataFlag(i) )
		{
			szSvrAddr=m_ClientBeacon.GetBeaconAddress(i);
			bFound=False;
			j=0;
JL00C0:
			if ( (j < m_GameServerList.Length) &&  !bFound )
			{
				if ( szSvrAddr == m_GameServerList[j].szIPAddress )
				{
					bFound=True;
					iIndex=j;
					if ( m_bIndRefrInProgress && (iIndex == m_iIndRefrIndex) )
					{
						m_bIndRefrInProgress=False;
					}
				}
				j++;
				goto JL00C0;
			}
			sSvr.sGameData=getSvrData(i);
			if ( sSvr.sGameData.bInternetServer == False )
			{
				sSvr.szIPAddress=szSvrAddr;
				sSvr.bDisplay=True;
				sSvr.bFavorite=IsAFavorite(szSvrAddr);
				sSvr.iPing=NativeGetPingTime(Left(szSvrAddr,InStr(szSvrAddr,":")));
				sSvr.iGroupID=m_ClientBeacon.GetGroupID(i);
				sSvr.iLobbySrvID=m_ClientBeacon.GetLobbyID(i);
				sSvr.iBeaconPort=m_ClientBeacon.GetBeaconPort(i);
//				sSvr.sGameData.bAdversarial=m_ClientBeacon.Level.IsGameTypeAdversarial(sSvr.sGameData.eGameType);
//				sSvr.sGameData.szGameType=m_ClientBeacon.Level.GetGameNameLocalization(sSvr.sGameData.eGameType);
				if ( sSvr.sGameData.szModName != szCurrentMod )
				{
					goto JL03B6;
				}
				if ( bFound )
				{
					m_GameServerList[iIndex].sGameData=sSvr.sGameData;
					m_GameServerList[iIndex].iPing=sSvr.iPing;
					m_GameServerList[iIndex].iGroupID=sSvr.iGroupID;
					m_GameServerList[iIndex].iLobbySrvID=sSvr.iLobbySrvID;
					m_GameServerList[iIndex].iBeaconPort=sSvr.iBeaconPort;
				}
				else
				{
					iIndex=m_GameServerList.Length;
					m_GameServerList[m_GameServerList.Length]=sSvr;
					m_GSLSortIdx[m_GSLSortIdx.Length]=m_GSLSortIdx.Length - 1;
				}
				m_GameServerList[iIndex].bSameVersion=m_GameServerList[iIndex].sGameData.szGameVersion == Class'Actor'.static.GetGameVersion();
				m_ClientBeacon.SetNewDataFlag(i,False);
				m_bServerListChanged=True;
			}
		}
JL03B6:
		i++;
		goto JL0055;
	}
	if ( m_bIndRefrInProgress )
	{
		if ( NativeGetMilliSeconds() > m_iIndRefrEndTime )
		{
			if ( m_iIndRefrAttempts < 4 )
			{
				SendBeaconToOneServer(m_iIndRefrIndex);
			}
			else
			{
				m_GameServerList.Remove (m_iIndRefrIndex,1);
				m_GSLSortIdx.Remove (m_iIndRefrIndex,1);
				m_bIndRefrInProgress=False;
				m_bServerListChanged=True;
			}
		}
	}
}

defaultproperties
{
}
/*
    m_Filters=(bDeathMatch=True, bTeamDeathMatch=True, bDisarmBomb=False, bHostageRescueAdv=True, bEscortPilot=True, bMission=False, bTerroristHunt=True, bTerroristHuntAdv=True, bScatteredHuntAdv=False, bCaptureTheEnemyAdv=True, bKamikaze=True, bHostageRescueCoop=False, bDefend=True, bRecon=True, bSquadDeathMatch=False, bSquadTeamDeathMatch=True, bDebugGameMode=True, bUnlockedOnly=False, bFavoritesOnly=True, bDedicatedServersOnly=True, bServersNotEmpty=False, bServersNotFull=True, bResponding=True, bSameVersion=False, szHasPlayer="Ó
.Ó
.Ó
#Ó
$Ó
%Ó
&Ó", iFasterThan=13838080)
*/

