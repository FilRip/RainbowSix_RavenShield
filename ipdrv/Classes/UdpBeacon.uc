//================================================================================
// UdpBeacon.
//================================================================================
class UdpBeacon extends UdpLink;

var() globalconfig int ServerBeaconPort;
var() globalconfig int BeaconPort;
var int UdpServerQueryPort;
var int boundport;
var() globalconfig bool DoBeacon;
var() globalconfig float BeaconTimeout;
var() globalconfig string BeaconProduct;
var string KeyWordMarker;
var string PreJoinQueryMarker;
var string MaxPlayersMarker;
var string NumPlayersMarker;
var string MapNameMarker;
var string GameTypeMarker;
var string LockedMarker;
var string DecicatedMarker;
var string SvrNameMarker;
var string MenuGmNameMarker;
var string MapListMarker;
var string PlayerListMarker;
var string OptionsListMarker;
var string PlayerTimeMarker;
var string PlayerPingMarker;
var string PlayerKillMarker;
var string GamePortMarker;
var string RoundsPerMatchMarker;
var string RoundTimeMarker;
var string BetTimeMarker;
var string BombTimeMarker;
var string ShowNamesMarker;
var string InternetServerMarker;
var string FriendlyFireMarker;
var string AutoBalTeamMarker;
var string TKPenaltyMarker;
var string AllowRadarMarker;
var string GameVersionMarker;
var string LobbyServerIDMarker;
var string GroupIDMarker;
var string BeaconPortMarker;
var string NumTerroMarker;
var string AIBkpMarker;
var string RotateMapMarker;
var string ForceFPWpnMarker;
var string ModNameMarker;
var string PunkBusterMarker;
var string LocalIpAddress;

function BeginPlay ()
{
	local IpAddr Addr;

	SetServerBeacon(self);
	Level.Game.SetUdpBeacon(self);
	boundport=BindPort(ServerBeaconPort,True,LocalIpAddress);
	if ( boundport == 0 )
	{
		Log("UdpBeacon failed to bind a port.");
		return;
	}
	Addr.Addr=BroadcastAddr;
	Addr.Port=BeaconPort;
	SetTimer(10.00,True);
	InitBeaconProduct();
}

function BroadcastBeacon (IpAddr Addr)
{
	local string textData;

	textData=BuildBeaconText();
	SendText(Addr,BeaconProduct @ Mid(Level.GetAddressURL(),InStr(Level.GetAddressURL(),":") + 1) @ textData);
}

function BroadcastBeaconQuery (IpAddr Addr)
{
	SendText(Addr,BeaconProduct @ string(UdpServerQueryPort));
}

event ReceivedText (IpAddr Addr, string Text)
{
	local R6ServerInfo pServerOptions;
	local bool bServerResistered;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	if ( Text == "REPORT" )
	{
		BroadcastBeacon(Addr);
	}
	if ( Text == "REPORTQUERY" )
	{
		BroadcastBeaconQuery(Addr);
	}
	if ( Text == "PREJOIN" )
	{
		bServerResistered=(Level.Game.GameReplicationInfo.m_iGameSvrLobbyID != 0) && (Level.Game.GameReplicationInfo.m_iGameSvrGroupID != 0);
		if (  !pServerOptions.InternetServer || bServerResistered )
		{
			RespondPreJoinQuery(Addr);
		}
	}
}

function InitBeaconProduct ()
{
	BeaconProduct="rvnshld";
}

function RespondPreJoinQuery (IpAddr Addr)
{
	local string textData;
	local int integerData;
	local R6ServerInfo pServerOptions;
	local PlayerController aPC;
	local int iNumPlayers;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	textData=PreJoinQueryMarker;
	textData=textData $ " " $ LobbyServerIDMarker $ " " $ string(Level.Game.GameReplicationInfo.m_iGameSvrLobbyID);
	textData=textData $ " " $ GroupIDMarker $ " " $ string(Level.Game.GameReplicationInfo.m_iGameSvrGroupID);
	if ( Level.Game.AccessControl.GamePasswordNeeded() )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ LockedMarker $ " " $ string(integerData);
	textData=textData $ " " $ GameVersionMarker $ " " $ Level.GetGameVersion();
	if ( pServerOptions.InternetServer )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ InternetServerMarker $ " " $ string(integerData);
	textData=textData $ " " $ MaxPlayersMarker $ " " $ string(Level.Game.MaxPlayers);
	iNumPlayers=0;
	foreach DynamicActors(Class'PlayerController',aPC)
	{
		iNumPlayers++;
	}
	textData=textData $ " " $ NumPlayersMarker $ " " $ string(iNumPlayers);
	SendText(Addr,BeaconProduct @ Mid(Level.GetAddressURL(),InStr(Level.GetAddressURL(),":") + 1) @ textData);
}

function Destroyed ()
{
	Level.Game.SetUdpBeacon(None);
	Super.Destroyed();
}

function string BuildBeaconText ()
{
	local string textData;
	local int integerData;
	local string MapListType;
	local MapList myList;
	local Class<MapList> ML;
	local int iCounter;
	local PlayerController aPC;
	local int iNumPlayers;
	local string szIPAddr;
	local float fPlayingTime[32];
	local int iPingTimeMS[32];
	local int iKillCount[32];
	local Controller _Controller;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	textData=KeyWordMarker $ " ";
	textData=textData $ " " $ GamePortMarker $ " " $ Mid(Level.GetAddressURL(),InStr(Level.GetAddressURL(),":") + 1);
	if ( InStr(Level.Game.GetURLMap(),".") == -1 )
	{
		textData=textData $ " " $ MapNameMarker $ " " $ Level.Game.GetURLMap();
	}
	else
	{
		textData=textData $ " " $ MapNameMarker $ " " $ Left(Level.Game.GetURLMap(),InStr(Level.Game.GetURLMap(),"."));
	}
	textData=textData $ " " $ SvrNameMarker $ " " $ Level.Game.GameReplicationInfo.ServerName;
	textData=textData $ " " $ GameTypeMarker $ " " $ string(Level.Game.m_iCurrGameType);
	textData=textData $ " " $ MaxPlayersMarker $ " " $ string(Level.Game.MaxPlayers);
	if ( Level.Game.AccessControl.GamePasswordNeeded() )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ LockedMarker $ " " $ string(integerData);
	if ( Level.NetMode == NM_DedicatedServer )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ DecicatedMarker $ " " $ string(integerData);
	MapListType="Engine.R6MapList";
	ML=Class<MapList>(DynamicLoadObject(MapListType,Class'Class'));
	myList=Spawn(ML);
	textData=textData $ " " $ MapListMarker $ " ";
	iCounter=0;
JL02CA:
	if ( iCounter < 32 )
	{
		if ( myList.Maps[iCounter] != "" )
		{
			if ( InStr(myList.Maps[iCounter],".") == -1 )
			{
				textData=textData $ "/" $ myList.Maps[iCounter];
			}
			else
			{
				textData=textData $ "/" $ Left(myList.Maps[iCounter],InStr(myList.Maps[iCounter],"."));
			}
		}
		iCounter++;
		goto JL02CA;
	}
	textData=textData $ " " $ MenuGmNameMarker $ " ";
	iCounter=0;
JL03AB:
	if ( iCounter < 32 )
	{
		textData=textData $ "/" $ string(Level.GetER6GameTypeFromClassName(R6MapList(myList).GameType[iCounter]));
		iCounter++;
		goto JL03AB;
	}
	myList.Destroy();
	textData=textData $ " " $ PlayerListMarker $ " ";
	CheckForPlayerTimeouts();
	iNumPlayers=0;
	_Controller=Level.ControllerList;
JL0446:
	if ( _Controller != None )
	{
		aPC=PlayerController(_Controller);
		if ( aPC != None )
		{
			textData=textData $ "/" $ aPC.PlayerReplicationInfo.PlayerName;
			if ( NetConnection(aPC.Player) == None )
			{
				szIPAddr=WindowConsole(aPC.Player.Console).szStoreIP;
			}
			else
			{
				szIPAddr=aPC.GetPlayerNetworkAddress();
			}
			szIPAddr=Left(szIPAddr,InStr(szIPAddr,":"));
			iPingTimeMS[iNumPlayers]=aPC.PlayerReplicationInfo.Ping;
			iKillCount[iNumPlayers]=aPC.PlayerReplicationInfo.m_iKillCount;
			fPlayingTime[iNumPlayers]=GetPlayingTime(szIPAddr);
			iNumPlayers++;
		}
		_Controller=_Controller.nextController;
		goto JL0446;
	}
	textData=textData $ " " $ PlayerTimeMarker $ " ";
	iCounter=0;
JL05A6:
	if ( iCounter < iNumPlayers )
	{
		textData=textData $ "/" $ DisplayTime(fPlayingTime[iCounter]);
		iCounter++;
		goto JL05A6;
	}
	textData=textData $ " " $ PlayerPingMarker $ " ";
	iCounter=0;
JL0607:
	if ( iCounter < iNumPlayers )
	{
		textData=textData $ "/" $ string(iPingTimeMS[iCounter]);
		iCounter++;
		goto JL0607;
	}
	textData=textData $ " " $ PlayerKillMarker $ " ";
	iCounter=0;
JL0662:
	if ( iCounter < iNumPlayers )
	{
		textData=textData $ "/" $ string(iKillCount[iCounter]);
		iCounter++;
		goto JL0662;
	}
	textData=textData $ " " $ NumPlayersMarker $ " " $ string(iNumPlayers);
	textData=textData $ " " $ RoundsPerMatchMarker $ " " $ string(pServerOptions.RoundsPerMatch);
	textData=textData $ " " $ RoundTimeMarker $ " " $ string(pServerOptions.RoundTime);
	textData=textData $ " " $ BetTimeMarker $ " " $ string(pServerOptions.BetweenRoundTime);
	if ( pServerOptions.BombTime > -1 )
	{
		textData=textData $ " " $ BombTimeMarker $ " " $ string(pServerOptions.BombTime);
	}
	if ( pServerOptions.ShowNames )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ ShowNamesMarker $ " " $ string(integerData);
	if ( pServerOptions.InternetServer )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ InternetServerMarker $ " " $ string(integerData);
	if ( pServerOptions.FriendlyFire )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ FriendlyFireMarker $ " " $ string(integerData);
	if ( pServerOptions.Autobalance )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ AutoBalTeamMarker $ " " $ string(integerData);
	if ( pServerOptions.TeamKillerPenalty )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ TKPenaltyMarker $ " " $ string(integerData);
	textData=textData $ " " $ GameVersionMarker $ " " $ Level.GetGameVersion();
	if ( pServerOptions.AllowRadar )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ AllowRadarMarker $ " " $ string(integerData);
	textData=textData $ " " $ LobbyServerIDMarker $ " " $ string(Level.Game.GameReplicationInfo.m_iGameSvrLobbyID);
	textData=textData $ " " $ GroupIDMarker $ " " $ string(Level.Game.GameReplicationInfo.m_iGameSvrGroupID);
	textData=textData $ " " $ BeaconPortMarker $ " " $ string(boundport);
	textData=textData $ " " $ NumTerroMarker $ " " $ string(pServerOptions.NbTerro);
	if ( pServerOptions.AIBkp )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ AIBkpMarker $ " " $ string(integerData);
	if ( pServerOptions.RotateMap )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ RotateMapMarker $ " " $ string(integerData);
	if ( pServerOptions.ForceFPersonWeapon )
	{
		integerData=1;
	}
	else
	{
		integerData=0;
	}
	textData=textData $ " " $ ForceFPWpnMarker $ " " $ string(integerData);
	textData=textData $ " " $ ModNameMarker $ " " $ Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szKeyWord;
	textData=textData $ " " $ PunkBusterMarker $ " " $ string(Level.iPBEnabled);
	return textData;
}

function Timer ()
{
	local Controller aPC;

	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
	{
		aPC=Level.ControllerList;
JL0048:
		if ( aPC != None )
		{
			if ( (PlayerController(aPC) != None) && (PlayerController(aPC).m_szIpAddr != "") )
			{
				SetPlayingTime(PlayerController(aPC).m_szIpAddr,PlayerController(aPC).m_fLoginTime,Level.TimeSeconds);
			}
			aPC=aPC.nextController;
			goto JL0048;
		}
	}
}

function string DisplayTime (int _iTimeToConvert)
{
	local float fTemp;
	local int iMin;
	local int iSec;
	local int ITemp;
	local string szTemp;
	local string szTime;

	iMin=0;
	iSec=_iTimeToConvert;
	if ( _iTimeToConvert >= 60 )
	{
		fTemp=_iTimeToConvert / 60;
		iMin=fTemp;
		iSec=_iTimeToConvert - iMin * 60;
	}
	if ( iSec < 10 )
	{
		szTime=string(iMin) $ ":0" $ string(iSec);
	}
	else
	{
		szTemp=string(iSec);
		szTemp=Left(szTemp,2);
		szTime=string(iMin) $ ":" $ szTemp;
	}
	return szTime;
}

defaultproperties
{
    ServerBeaconPort=8777
    BeaconPort=9777
    DoBeacon=True
    BeaconTimeout=10.00
    BeaconProduct="unreal"
    KeyWordMarker="KEYWORD"
    PreJoinQueryMarker="PREJOINQUERY"
    MaxPlayersMarker="¶A1"
    NumPlayersMarker="¶B1"
    MapNameMarker="¶E1"
    GameTypeMarker="¶F1"
    LockedMarker="¶G1"
    DecicatedMarker="¶H1"
    SvrNameMarker="¶I1"
    MenuGmNameMarker="¶J1"
    MapListMarker="¶K1"
    PlayerListMarker="¶L1"
    OptionsListMarker="¶C2"
    PlayerTimeMarker="¶M1"
    PlayerPingMarker="¶N1"
    PlayerKillMarker="¶O1"
    GamePortMarker="¶P1"
    RoundsPerMatchMarker="¶Q1"
    RoundTimeMarker="¶R1"
    BetTimeMarker="¶S1"
    BombTimeMarker="¶T1"
    ShowNamesMarker="¶W1"
    InternetServerMarker="¶X1"
    FriendlyFireMarker="¶Y1"
    AutoBalTeamMarker="¶Z1"
    TKPenaltyMarker="¶A2"
    AllowRadarMarker="¶B2"
    GameVersionMarker="¶D2"
    LobbyServerIDMarker="¶E2"
    GroupIDMarker="¶F2"
    BeaconPortMarker="¶G2"
    NumTerroMarker="¶H2"
    AIBkpMarker="¶I2"
    RotateMapMarker="¶J2"
    ForceFPWpnMarker="¶K2"
    ModNameMarker="¶L2"
    PunkBusterMarker="¶L3"
    RemoteRole=ROLE_None
}