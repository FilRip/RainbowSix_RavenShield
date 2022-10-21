//================================================================================
// R6GSServers.
//================================================================================
class R6GSServers extends R6ServerList
	Native;

enum EFailureReasons {
	EFAIL_DEFAULT,
	EFAIL_SERVER_CONNECT,
	EFAIL_PASSWORDNOTCORRECT,
	EFAIL_ROOMFULL,
	EFAIL_ALREADYCONNECTED,
	EFAIL_NOTREGISTERED,
	EFAIL_NOTDISCONNECTED,
	EFAIL_PLAYERALREADYREGISTERED,
	EFAIL_TIMED_OUT,
	EFAIL_CDKEYUSED,
	EFAIL_INVALIDCDKEY,
	EFAIL_DATABASEFAILED,
	EFAIL_BANNEDACCOUNT,
	EFAIL_BLOCKEDACCOUNT,
	EFAIL_LOCKEDACCOUNT
};

enum EGSMESSAGE_ID {
	EGSMESSAGE_INITMASTERSESSION_AK,
	EGSMESSAGE_MASTERSESSION_AK,
	EGSMESSAGE_READYTORECEIVECONNECTIONS,
	EGSMESSAGE_INITCLIENTSESSION_AK,
	EGSMESSAGE_CLIENTSESSION_AK,
	EGSMESSAGE_SWITCHTOGS
};

enum EGSGameState {
	EGS_WAITING_FOR_GS_INIT,
	EGS_CLIENT_INIT_RCVD,
	EGS_CLIENT_WAITING_CHSTA,
	EGS_CLIENT_CHSTA_RCVD,
	EGS_CLIENT_IN_GAME,
	EGS_SERVER_INIT_RCVD,
	EGS_SERVER_WAITING_CHSTA,
	EGS_SERVER_CHSTA_RCVD,
	EGS_SERVER_SETTING_UP_GAME,
	EGS_TERMINATE_RCVD,
	EGS_SERVER_READY
};

enum EMenuRequestState {
	EMENU_REQ_NONE,
	EMENU_REQ_PENDING,
	EMENU_REQ_SUCCESS,
	EMENU_REQ_FAILURE,
	EMENU_REQ_TIMEOUT,
	EMENU_REQ_TIMEOUT_ERROR,
	EMENU_REQ_INUSE_ERROR,
	EMENU_REQ_NOTCHALLENGED,
	EMENU_REQ_INT_ERROR
};

enum EGSRequestState {
	EGSREQ_NONE,
	EGSREQ_FIRST_PASS,
	EGSREQ_WAITING_FOR_RESPONSE,
	EGSREQ_FAILED,
	EGSREQ_CONNECT_FAILED,
	EGSREQ_INUSE_FAILED,
	EGSREQ_SUCCESS
};

enum ERegServerRequestState {
	ERSREQ_NONE,
	ERSREQ_INIT,
	ERSREQ_LOGIN,
	ERSREQ_SUCCESS,
	ERSREQ_FAILURE
};

struct stLobby
{
	var int iGroupID;
	var int iLobbySrvID;
};

struct stFriend
{
	var string szAlias;
	var int iStatus;
};

struct stChatMessage
{
	var string szUserId;
	var string szMessage;
};

var EMenuRequestState m_eMenuLoginUbidotcom;
var EFailureReasons m_eMenuLoginFailReason;
var EMenuRequestState m_eMenuCreateAccount;
var EFailureReasons m_eMenuCrAcctFailReason;
var EMenuRequestState m_eMenuCreateGame;
var EFailureReasons m_eMenuCrGameFailReason;
var EMenuRequestState m_eMenuCDKeyNotUsed;
var EFailureReasons m_eMenuCDKeyFailReason;
var EMenuRequestState m_eMenuJoinLobby;
var EMenuRequestState m_eMenuLoginMasterSvr;
var EFailureReasons m_eMenuLogMasSvrFailReason;
var EMenuRequestState m_eMenuLoginRegServer;
var EMenuRequestState m_eMenuUpdateServer;
var EMenuRequestState m_eMenuGetCDKeyActID;
var EMenuRequestState m_eMenuCDKeyAuthorization;
var EMenuRequestState m_eMenuUserValidation;
var EMenuRequestState m_eMenuJoinServer;
var EFailureReasons m_eMenuJoinRoomFailReason;
var EGSGameState m_eGSGameState;
var config byte m_ucActivationID[16];
var EGSRequestState m_eLoginRouterRequest;
var EGSRequestState m_eLoginWaitModuleRequest;
var EGSRequestState m_eJoinWaitModuleRequest;
var EGSRequestState m_eCreateAccountRequest;
var EGSRequestState m_eLoginFriendServiceRequest;
var EGSRequestState m_eLoginLobbyServiceRequest;
var EGSRequestState m_eCreateGameRequest;
var EGSRequestState m_eCDKeyNotUsedRequest;
var EGSRequestState m_eJoinLobbyRequest;
var EGSRequestState m_eJoinRoomRequest;
var EGSRequestState m_eMSClientInitRequest;
var EGSRequestState m_eGameStartRequest;
var EGSRequestState m_eGameReadyRequest;
var EGSRequestState m_eGameConnectedRequest;
var EGSRequestState m_eRegServerLoginRouterRequest;
var EGSRequestState m_eRegServerGetLobbiesRequest;
var EGSRequestState m_eRegServerRegOnLobbyRequest;
var EGSRequestState m_eRegServerConnectRequest;
var EGSRequestState m_eRegServerLoginRequest;
var EGSRequestState m_eRegServerUpdateRequest;
var EGSRequestState m_eCDKeyActIDRequest;
var EGSRequestState m_eCDKeyAuthorizationRequest;
var EGSRequestState m_eUserValidationRequest;
var EGSRequestState m_eJoinServerRequest;
var int m_bPingsPending;
var int m_iWaitModulePort;
var int m_iLobbyIndex;
var config int m_iCDKeyClientPort;
var config int m_iCDKeyServerPort;
var config int m_iRegSvrPort;
var int m_iOwnGroupID;
var int m_iOwnLobbySrvID;
var int m_iGroupID;
var int m_iLobbySrvID;
var int m_iRoomCreatedGroupID;
var int m_iRetryTime;
var int m_iMaxAvailPorts;
var int m_iGSNumPlayers;
var bool m_bGameServiceInit;
var bool m_bConnectedToServer;
var bool m_bLoggedInToServer;
var bool m_bLoggedInToLobbyService;
var bool m_bLoggedInToFriendService;
var bool m_bCDKeyNotUsed;
var bool m_bServerJoined;
var bool m_bRegSrvrConnectionLost;
var bool m_bGSClientInitialized;
var bool m_bRefreshInProgress;
var bool m_bRefreshFinished;
var bool m_bMSRequestFinished;
var config bool m_bValidActivationID;
var bool m_bPingReceived;
var bool m_bUbiAccntInfoEntered;
var bool m_bLoggedInUbiDotCom;
var bool m_bInitGame;
var bool m_bUpdateServer;
var bool m_bUbiComClientDied;
var bool m_bUbiComRoomDestroyed;
var bool m_bAutoLoginInProgress;
var bool m_bAutoLoginFailed;
var bool m_bStartedByGSClient;
var bool bShowLog;
var float m_fLoginRouterStartTime;
var float m_fLoginWaitModuleStartTime;
var float m_fJoinWaitModuleStartTime;
var float m_fCreateAccountStartTime;
var float m_fLoginFriendServiceStartTime;
var float m_fLoginLobbyServiceStartTime;
var float m_fCDKeyStartTime;
var float m_fCreateGameStartTime;
var float m_fMSClientInitStartTime;
var float m_fJoinLobbyStartTime;
var float m_fJoinRoomStartTime;
var float m_fGameStartStartTime;
var float m_fGameReadyStartTime;
var float m_fGameConnectedStartTime;
var float m_fRegServerRouterLoginTime;
var float m_fRegServerGetLobbiesTime;
var float m_fMaxTimeForResponse;
var float m_fRegServerRegOnLobbyTime;
var float m_fRegServerConnectTime;
var float m_fRegServerLoginTime;
var float m_fRegServerUpdateTime;
var float m_fCDKeyGetActIDTime;
var float m_fCDKeyGetAuthorizationTime;
var float m_fUserValidationTime;
var float m_fJoinServerTime;
var float m_fRefreshTime;
var array<int> m_PingReqList;
var array<string> m_CDKeyUpdateReqList;
var stLobby m_GaveServerID;
var string m_szNetGameName;
var string m_szUBIClientVersion;
var config string m_szGSVersion;
var string m_szCDKey;
var string m_szUbiGuestAcct;
var config string m_szGlobalID;
var config string m_szUbiRemFileURL;
var string m_szUbiHomePage;
var config string m_szSavedPwd;
var string m_szFirstName;
var string m_szLastName;
var string m_szCountry;
var string m_szEmail;
var string m_szAuthorizationID;
var string m_szRegSvrUserID;
var string m_szPassword;
var string m_szGSInitFileName;
var string m_szGSClientIP;
var string m_szGSClientAltIP;
var string m_szGSServerName;
var string m_szLastServerQueried;
var string m_szGSPassword;

const K_TimeRetryConnect= 15;
const K_MAX_SIZE_UBISERVERNAME= 32;

native(1201) final function bool NativeInit (string szLocalBoundIp);

native(1203) final function float NativeGetSeconds ();

native(1205) final function NativePollCallbacks (bool _bMSClient, bool _bCDKey, bool _bRegServer, bool _bGSClient);

native(1214) final function bool NativeReceiveServer ();

native(1237) final function bool NativeReceiveAltInfo ();

native(1240) final function bool NativeInitRegServer ();

native(1241) final function NativeRegServerRouterLogin ();

native(1242) final function NativeRegServerGetLobbies ();

native(1243) final function NativeRegisterServer ();

native(1244) final function NativeRouterDisconnect ();

native(1245) final function NativeServerLogin ();

native(1248) final function bool NativeGetInitialized ();

native(1250) final function NativeUpdateServer ();

native(1254) final function NativePingReq (string szSvrName, string szIPAddress);

native(1257) final function NativeRequestActivation ();

native(1258) final function NativeRequestAuthorization ();

native(1259) final function bool NativeInitCDKey (int iPort);

native(1260) final function NativeUnInitCDKey ();

native(1261) final function int NativeCDKeyValidateUser (string szAuthID, bool bExtraTime);

native(1262) final function NativeCDKeyPlayerStatusReply (string szAuthID, ECDKEYST_STATUS eStatus);

native(1287) final function string NativeCDKeyGetOwnAuthID ();

native(1264) final function NativeReceiveValidation ();

native(1267) final function bool NativeGetMSClientInitialized ();

native(1268) final function bool NativeGetLoggedInUbiDotCom ();

native(1269) final function NativeRegServerMemberJoin (string szUbiUserID);

native(1270) final function NativeRegServerMemberLeave (string szUbiUserID);

native(1235) final function NativeRequestMSList ();

native(1234) final function NativeInitMSClient ();

native(1249) final function bool NativeUnInitMSClient ();

native(1272) final function bool NativeMSCLientLeaveServer ();

native(1255) final function NativeRefreshServer (int iIdx);

native(1220) final function NativeMSClientReqAltInfo (int iLobbyID, int iGroupID);

native(1274) final function NativeRegServerServerClose ();

native(1275) final function bool NativeGetRegServerIntialized ();

native(1276) final function NativeRegServerShutDown ();

native(1277) final function NativeMSCLientJoinServer (int iLobbyID, int iGroupID, string szPassword);

native(1204) final function bool NativeGetServerRegistered ();

native(1238) final function AddPlayerToIDList (string szAuthID, string szIPAddr, string szUbiBanID);

native(1239) final function bool PlayerIsInIDList (string szAuthID, string szIPAddr);

native(1315) final function string GetGlobalIdFromPlayerIDList (string szAuthID);

native(1290) final function RemoveFromIDList (int iIdx);

native(1284) final function string GetIDListIPAddr (int iIdx);

native(1285) final function string GetIDListAuthID (int iIdx);

native(1286) final function int GetIDListSize ();

native(1288) final function bool NativeInitGSClient ();

native(1289) final function bool NativeGSClientPostMessage (EGSMESSAGE_ID eMessageID);

native(1293) final function bool NativeGSClientUpdateServerInfo ();

native(1350) final function bool NativeCheckGSClientAlive ();

native(1294) final function NativeServerRoundStart (int uiMode);

native(1295) final function NativeServerRoundFinish ();

native(1296) final function NativeSetMatchResult (string szUbiUserID, int iField, int iValue);

native(1298) final function bool NativeProcessIcmpPing (string _ServerIpAddress, out int piPingTime);

native(1299) final function bool SetGSClientComInterface ();

native(1300) final function LogGSVersion ();

native(1353) final function TestRegServerLobbyDisconnect ();

native(1354) final function NativeMSClientServerConnected (int iLobbyID, int iGroupID);

native(1308) final function CleanPlayerIDList (Controller _ControllerList);

native(1246) final function SetGameServiceRequestState (ERegServerRequestState eRegServerState);

native(1247) final function ERegServerRequestState GetGameServiceRequestState ();

native(1251) final function SetRegisteredWithMS (bool bRegisteredWithMS);

native(1252) final function bool GetRegisteredWithMS ();

native(1265) final function SetCDKeyInitialised (bool bCDKeyInitialised);

native(1266) final function bool GetCDKeyInitialised ();

native(1263) final function NativeCDKeyDisconnecUser (string szAuthID);

native(1307) final function DisconnectAllCDKeyPlayers ();

native(1309) final function ResetAuthId ();

native(1310) final function bool HandleAnyLobbyConnectionFail ();

native(1313) final function bool OnSameSubNet (string szIPAddr);

function bool CallNativeProcessIcmpPing (string _ServerIpAddress, out int piPingTime)
{
	return NativeProcessIcmpPing(_ServerIpAddress,piPingTime);
    return false;
}

function CallNativeSetMatchResult (string szUbiUserID, int iField, int iValue)
{
	NativeSetMatchResult(szUbiUserID,iField,iValue);
}

function int getServerListSize ()
{
	return m_GameServerList.Length;
}

function Created ()
{
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	GetRegistryKey("SOFTWARE\\Red Storm Entertainment\\RAVENSHIELD","CDKey",m_szCDKey);
	Super.Created();
	m_szPassword=m_szSavedPwd;
	m_bStartedByGSClient=Class'Actor'.static.NativeStartedByGSClient();
	LogGSVersion();
	InitMod();
	pModManager.RegisterObject(self);
}

function InitMod ()
{
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	m_szUBIClientVersion=pModManager.GetUbiComClientVersion();
	m_szNetGameName=pModManager.GetGameServiceGameName();
	Log("UbiClientVersion: " $ m_szUBIClientVersion);
	Log("m_szNetGameName: " $ m_szNetGameName);
}

function RefreshOneServer (int sortedListIdx)
{
	local int serverListIndex;

	serverListIndex=m_GSLSortIdx[sortedListIdx];
	if (  !m_bConnectedToServer || m_bRefreshInProgress || m_bIndRefrInProgress )
	{
		return;
	}
	m_fRefreshTime=NativeGetSeconds();
	m_bMSRequestFinished=False;
	m_bIndRefrInProgress=True;
	m_iIndRefrIndex=serverListIndex;
	NativeRefreshServer(serverListIndex);
}

function GameServiceManager (bool _bMSClient, bool _bCDKey, bool _bRegServer, bool _bGSClient)
{
	local float elapsedTime;
	local int i;
	local int j;
	local int iIndex;
	local bool bFound;
	local stGameData sGameData;

	if (  !NativeGetInitialized() )
	{
		return;
	}
	NativePollCallbacks(_bMSClient,_bCDKey,_bRegServer,_bGSClient);
	if ( NativeReceiveServer() )
	{
		m_bServerListChanged=True;
	}
	if ( NativeReceiveAltInfo() )
	{
		m_bServerInfoChanged=True;
	}
	if ( m_bPingReceived )
	{
		m_bServerListChanged=True;
	}
	i=0;
JL0059:
	if ( i < m_PingReqList.Length )
	{
		NativePingReq(m_GameServerList[m_PingReqList[i]].sGameData.szName,m_GameServerList[m_PingReqList[i]].szIPAddress);
		i++;
		goto JL0059;
	}
	m_PingReqList.Remove (0,m_PingReqList.Length);
	if ( m_bRefreshInProgress )
	{
		if ( (m_bMSRequestFinished || (NativeGetSeconds() - m_fRefreshTime > m_fMaxTimeForResponse)) && (m_bPingsPending == 0) )
		{
			m_bRefreshInProgress=False;
			m_bRefreshFinished=True;
		}
	}
	else
	{
		if ( m_bIndRefrInProgress )
		{
			if ( m_bMSRequestFinished || (NativeGetSeconds() - m_fRefreshTime > m_fMaxTimeForResponse) )
			{
				m_bIndRefrInProgress=False;
				m_bRefreshFinished=True;
				m_GameServerList.Remove (m_iIndRefrIndex,1);
				m_GSLSortIdx.Remove (m_iIndRefrIndex,1);
			}
		}
	}
	if ( _bRegServer )
	{
		NativeReceiveValidation();
	}
	switch (m_eMSClientInitRequest)
	{
/*		case 1:
		m_fMSClientInitStartTime=NativeGetSeconds();
		m_eMSClientInitRequest=2;
		NativeInitMSClient();
		break;
		case 2:
		elapsedTime=NativeGetSeconds() - m_fMSClientInitStartTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			m_eMSClientInitRequest=3;
		}
		break;
		case 3:
		NativeUnInitMSClient();
		m_eMSClientInitRequest=0;
		m_eMenuLoginMasterSvr=3;
		break;
		case 6:
		m_bLoggedInToFriendService=True;
		m_bConnectedToServer=True;
		m_bLoggedInUbiDotCom=True;
		m_eMSClientInitRequest=0;
		m_eMenuLoginMasterSvr=2;
		break;
		case 0:
		break;
		default: */
	}
	switch (m_eRegServerLoginRouterRequest)
	{
/*		case 1:
		m_fRegServerRouterLoginTime=NativeGetSeconds();
		NativeRegServerRouterLogin();
		m_eRegServerLoginRouterRequest=2;
		break;
		case 2:
		elapsedTime=NativeGetSeconds() - m_fRegServerRouterLoginTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			m_eRegServerLoginRouterRequest=3;
		}
		break;
		case 3:
		if ( (m_szRegSvrUserID != m_szUbiGuestAcct) && m_CrGameSrvInfo.sGameData.bDedicatedServer )
		{
			m_szRegSvrUserID=m_szUbiGuestAcct;
			m_eRegServerLoginRouterRequest=1;
		}
		else
		{
			m_eMenuLoginRegServer=3;
			m_eRegServerLoginRouterRequest=0;
			goto JL02C7;
			case 6:
			m_eRegServerLoginRouterRequest=0;
			m_eRegServerGetLobbiesRequest=1;
			goto JL02C7;
			case 0:
			goto JL02C7;
			default:
		}   */
	}
JL02C7:
	switch (m_eRegServerGetLobbiesRequest)
	{
/*		case 1:
		m_fRegServerGetLobbiesTime=NativeGetSeconds();
		NativeRegServerGetLobbies();
		m_eRegServerGetLobbiesRequest=2;
		break;
		case 2:
		elapsedTime=NativeGetSeconds() - m_fRegServerGetLobbiesTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			m_eRegServerGetLobbiesRequest=3;
		}
		break;
		case 3:
		m_eMenuLoginRegServer=3;
		m_eRegServerGetLobbiesRequest=0;
		break;
		case 6:
		m_eRegServerGetLobbiesRequest=0;
		m_eRegServerRegOnLobbyRequest=1;
		break;
		case 0:
		break;
		default: */
	}
	switch (m_eRegServerRegOnLobbyRequest)
	{
/*		case 1:
		m_fRegServerRegOnLobbyTime=NativeGetSeconds();
		NativeResetSvrContainer();
		NativeFillSvrContainer();
		NativeRegisterServer();
		m_eRegServerRegOnLobbyRequest=2;
		break;
		case 2:
		elapsedTime=NativeGetSeconds() - m_fRegServerRegOnLobbyTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			m_eRegServerRegOnLobbyRequest=3;
		}
		break;
		case 3:
		m_eMenuLoginRegServer=3;
		m_eRegServerRegOnLobbyRequest=0;
		break;
		case 6:
		m_eRegServerRegOnLobbyRequest=0;
		m_eRegServerLoginRequest=1;
		break;
		case 0:
		break;
		default: */
	}
	switch (m_eRegServerLoginRequest)
	{
/*		case 1:
		m_fRegServerLoginTime=NativeGetSeconds();
		NativeServerLogin();
		m_eRegServerLoginRequest=2;
		break;
		case 2:
		elapsedTime=NativeGetSeconds() - m_fRegServerLoginTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			m_eRegServerLoginRequest=3;
		}
		break;
		case 3:
		m_eMenuLoginRegServer=3;
		m_eRegServerLoginRequest=0;
		break;
		case 6:
		NativeRouterDisconnect();
		m_eRegServerLoginRequest=0;
		m_eMenuLoginRegServer=2;
		break;
		case 0:
		break;
		default:     */
	}
	switch (m_eRegServerUpdateRequest)
	{
/*		case 1:
		m_fRegServerUpdateTime=NativeGetSeconds();
		NativeUpdateServer();
		m_eRegServerUpdateRequest=2;
		break;
		case 2:
		elapsedTime=NativeGetSeconds() - m_fRegServerUpdateTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			m_eRegServerUpdateRequest=3;
		}
		break;
		case 3:
		m_eMenuUpdateServer=3;
		m_eRegServerUpdateRequest=0;
		break;
		case 6:
		m_eMenuUpdateServer=2;
		m_eRegServerUpdateRequest=0;
		break;
		case 0:
		break;
		default:  */
	}
	switch (m_eCDKeyActIDRequest)
	{
/*		case 1:
		m_fCDKeyGetActIDTime=NativeGetSeconds();
		NativeRequestActivation();
		m_eCDKeyActIDRequest=2;
		break;
		case 2:
		elapsedTime=NativeGetSeconds() - m_fCDKeyGetActIDTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			m_eMenuGetCDKeyActID=4;
			m_eCDKeyActIDRequest=0;
		}
		break;
		case 6:
		SaveConfig();
		m_eMenuGetCDKeyActID=2;
		m_eCDKeyActIDRequest=0;
		break;
		case 0:
		break;
		default:  */
	}
	switch (m_eCDKeyAuthorizationRequest)
	{
/*		case 1:
		if ( bShowLog )
		{
			Log("AT m_eCDKeyAuthorizationRequest EGSREQ_FIRST_PASS");
		}
		m_fCDKeyGetAuthorizationTime=NativeGetSeconds();
		NativeRequestAuthorization();
		m_eCDKeyAuthorizationRequest=2;
		break;
		case 2:
		if ( bShowLog )
		{
			Log("AT m_eCDKeyAuthorizationRequest EGSREQ_WAITING_FOR_RESPONSE");
		}
		elapsedTime=NativeGetSeconds() - m_fCDKeyGetAuthorizationTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			if ( bShowLog )
			{
				Log("--- and going m_eMenuCDKeyAuthorization = EMENU_REQ_TIMEOUT");
			}
			m_eMenuCDKeyAuthorization=4;
			m_eCDKeyAuthorizationRequest=0;
		}
		break;
		case 5:
		if ( bShowLog )
		{
			Log("4> AT m_eCDKeyAuthorizationRequest EGSREQ_INUSE_FAILED");
		}
		m_eCDKeyAuthorizationRequest=0;
		break;
		case 4:
		if ( bShowLog )
		{
			Log("AT m_eCDKeyAuthorizationRequest EGSREQ_CONNECT_FAILED");
		}
		m_eMenuCDKeyAuthorization=5;
		m_eCDKeyAuthorizationRequest=0;
		break;
		case 3:
		if ( bShowLog )
		{
			Log("AT m_eCDKeyAuthorizationRequest EGSREQ_FAILED");
		}
		m_eMenuCDKeyAuthorization=3;
		m_eCDKeyAuthorizationRequest=0;
		break;
		case 6:
		if ( bShowLog )
		{
			Log("AT m_eCDKeyAuthorizationRequest EGSREQ_SUCCESS");
		}
		m_eMenuCDKeyAuthorization=2;
		m_eCDKeyAuthorizationRequest=0;
		break;
		case 0:
		break;
		default:   */
	}
	switch (m_eJoinServerRequest)
	{
/*		case 1:
		m_fJoinServerTime=NativeGetSeconds();
		m_eJoinServerRequest=2;
		break;
		case 2:
		elapsedTime=NativeGetSeconds() - m_fJoinServerTime;
		if ( elapsedTime > m_fMaxTimeForResponse )
		{
			m_eMenuLogMasSvrFailReason=0;
			m_eJoinServerRequest=3;
		}
		break;
		case 3:
		m_eMenuJoinServer=3;
		m_eJoinServerRequest=0;
		break;
		case 6:
		m_eMenuJoinServer=2;
		m_eJoinServerRequest=0;
		break;
		case 0:
		break;
		default:  */
	}
	return;
}

function string GetLocallyBoundIpAddr ()
{
	local UdpBeacon _udpBeacon;
	local InternetInfo _info;

	if ( m_ClientBeacon != None )
	{
		return m_ClientBeacon.LocalIpAddress;
	}
	else
	{
		_udpBeacon=UdpBeacon(Class'Actor'.static.GetServerBeacon());
		if ( _udpBeacon != None )
		{
			return _udpBeacon.LocalIpAddress;
		}
	}
	return "";
}

function Initialize ()
{
	if (  !m_bGameServiceInit )
	{
		m_bGameServiceInit=NativeInit(GetLocallyBoundIpAddr());
	}
}

function bool InitializeMSClient ()
{
	local int j;

	NativeInitFavorites();
	if (  !m_bGameServiceInit )
	{
		m_bGameServiceInit=NativeInit(GetLocallyBoundIpAddr());
	}
	if ( m_bGameServiceInit )
	{
//		m_eMSClientInitRequest=1;
//		m_eMenuLoginMasterSvr=1;
	}
	else
	{
//		m_eMenuLoginMasterSvr=3;
//		m_eMenuLogMasSvrFailReason=0;
	}
	return m_bGameServiceInit;
}

function bool UnInitializeMSClient ()
{
	m_bLoggedInToFriendService=False;
	m_bConnectedToServer=False;
	m_bLoggedInUbiDotCom=False;
	m_bServerJoined=False;
	m_bIndRefrInProgress=False;
	m_bRefreshInProgress=False;
	return NativeUnInitMSClient();
}

function SetUbiAccount (string szUserId, string szPassword)
{
	m_szUserID=szUserId;
	m_szPassword=szPassword;
}

function bool InitializeRegServer ()
{
	if (  !m_bGameServiceInit )
	{
		m_bGameServiceInit=NativeInit(GetLocallyBoundIpAddr());
	}
	if ( m_bGameServiceInit )
	{
		m_bGameServiceInit=NativeInitRegServer();
//		m_eMenuLoginRegServer=1;
	}
	return m_bGameServiceInit;
}

function LoginRegServer (GameInfo pGameInfo, LevelInfo pLevel)
{
//	m_eRegServerLoginRouterRequest=1;
//	m_eMenuLoginRegServer=1;
	FillCreateGameInfo(pGameInfo,pLevel);
	m_szRegSvrUserID=m_szUbiGuestAcct;
}

function InitProcessUpdateUbiServer (GameInfo pGameInfo, LevelInfo pLevel)
{
	FillCreateGameInfo(pGameInfo,pLevel);
	NativeResetSvrContainer();
	NativeFillSvrContainer();
}

function UpdateServerRegServer (GameInfo pGameInfo, LevelInfo pLevel)
{
	InitProcessUpdateUbiServer(pGameInfo,pLevel);
//	m_eRegServerUpdateRequest=1;
//	m_eMenuUpdateServer=1;
}

function UpdateServerUbiCom (GameInfo pGameInfo, LevelInfo pLevel)
{
	InitProcessUpdateUbiServer(pGameInfo,pLevel);
	NativeGSClientUpdateServerInfo();
}

function FillCreateGameInfo (GameInfo pGameInfo, LevelInfo pLevel)
{
	local R6ServerInfo pServerOptions;
	local PlayerController aPC;
	local Controller _PC;
	local int iNumPlayers;
	local int iNumMaps;
	local R6MapList MapList;
	local int iCounter;
	local stRemotePlayers sPlayer;
	local stGameTypeAndMap sMapAndGame;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	iNumPlayers=0;
	m_CrGameSrvInfo.sGameData.PlayerList.Remove (0,m_CrGameSrvInfo.sGameData.iNbrPlayer);
	_PC=pGameInfo.Level.ControllerList;
JL0056:
	if ( _PC != None )
	{
		aPC=PlayerController(_PC);
		if ( aPC != None )
		{
			sPlayer.szAlias=aPC.PlayerReplicationInfo.PlayerName;
			sPlayer.iPing=aPC.PlayerReplicationInfo.Ping;
			sPlayer.iSkills=aPC.PlayerReplicationInfo.m_iKillCount;
			sPlayer.szTime=DisplayTime(pLevel.TimeSeconds - aPC.PlayerReplicationInfo.StartTime);
			m_CrGameSrvInfo.sGameData.PlayerList[iNumPlayers]=sPlayer;
			iNumPlayers++;
		}
		_PC=_PC.nextController;
		goto JL0056;
	}
	m_CrGameSrvInfo.sGameData.gameMapList.Remove (0,m_CrGameSrvInfo.sGameData.gameMapList.Length);
	MapList=pGameInfo.Spawn(Class'R6MapList');
	iCounter=0;
JL0196:
	if ( iCounter < 32 )
	{
		if ( MapList.Maps[iCounter] != "" )
		{
			if ( InStr(MapList.Maps[iCounter],".") == -1 )
			{
				sMapAndGame.szMap=MapList.Maps[iCounter];
			}
			else
			{
				sMapAndGame.szMap=Left(MapList.Maps[iCounter],InStr(MapList.Maps[iCounter],"."));
			}
//			sMapAndGame.eGameType=pLevel.GetER6GameTypeFromClassName(MapList.GameType[iCounter]);
			m_CrGameSrvInfo.sGameData.gameMapList[iNumMaps]=sMapAndGame;
			iNumMaps++;
		}
		iCounter++;
		goto JL0196;
	}
	m_CrGameSrvInfo.sGameData.szCurrentMap=MapList.CheckCurrentMap();
	MapList.Destroy();
	if ( m_ClientBeacon != None )
	{
		m_CrGameSrvInfo.iBeaconPort=m_ClientBeacon.boundport;
	}
	else
	{
		if ( R6AbstractGameInfo(pGameInfo).m_UdpBeacon != None )
		{
			m_CrGameSrvInfo.iBeaconPort=R6AbstractGameInfo(pGameInfo).m_UdpBeacon.boundport;
		}
		else
		{
			m_CrGameSrvInfo.iBeaconPort=Class'UdpBeacon'.Default.ServerBeaconPort;
		}
	}
	m_CrGameSrvInfo.sGameData.szName=pGameInfo.GameReplicationInfo.ServerName;
	m_CrGameSrvInfo.sGameData.szModName=Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szKeyWord;
	m_CrGameSrvInfo.sGameData.szPassword=pServerOptions.GamePassword;
	m_CrGameSrvInfo.sGameData.bUsePassword=pServerOptions.UsePassword;
	m_CrGameSrvInfo.sGameData.iMaxPlayer=pServerOptions.MaxPlayers;
	m_CrGameSrvInfo.sGameData.bDedicatedServer=pLevel.NetMode == NM_DedicatedServer;
	m_CrGameSrvInfo.sGameData.iPort=int(Mid(pLevel.GetAddressURL(),InStr(pLevel.GetAddressURL(),":") + 1));
	m_CrGameSrvInfo.sGameData.bAutoBalTeam=pServerOptions.Autobalance;
	m_CrGameSrvInfo.sGameData.bFriendlyFire=pServerOptions.FriendlyFire;
	m_CrGameSrvInfo.sGameData.bInternetServer=pServerOptions.InternetServer;
	m_CrGameSrvInfo.sGameData.bShowNames=pServerOptions.ShowNames;
	m_CrGameSrvInfo.sGameData.bTKPenalty=pServerOptions.TeamKillerPenalty;
	m_CrGameSrvInfo.sGameData.bRadar=pServerOptions.AllowRadar;
	m_CrGameSrvInfo.sGameData.iRoundsPerMatch=pServerOptions.RoundsPerMatch;
//	m_CrGameSrvInfo.sGameData.eGameType=pGameInfo.ConvertGameTypeIntToEnum(pGameInfo.m_iCurrGameType);
	m_CrGameSrvInfo.sGameData.iBetTime=pServerOptions.BetweenRoundTime;
	m_CrGameSrvInfo.sGameData.iBombTime=pServerOptions.BombTime;
	m_CrGameSrvInfo.sGameData.iNbrPlayer=iNumPlayers;
	m_CrGameSrvInfo.sGameData.iNumMaps=iNumMaps;
	m_CrGameSrvInfo.sGameData.iRoundTime=pServerOptions.RoundTime;
	m_CrGameSrvInfo.sGameData.szMessageOfDay=pServerOptions.MOTD;
//	m_CrGameSrvInfo.sGameData.szGameType=pLevel.GetGameNameLocalization(m_CrGameSrvInfo.sGameData.eGameType);
//	m_CrGameSrvInfo.sGameData.bAdversarial=pLevel.IsGameTypeAdversarial(m_CrGameSrvInfo.sGameData.eGameType);
	m_CrGameSrvInfo.sGameData.iNumTerro=pServerOptions.NbTerro;
	m_CrGameSrvInfo.sGameData.bAIBkp=pServerOptions.AIBkp;
	m_CrGameSrvInfo.sGameData.bRotateMap=pServerOptions.RotateMap;
	m_CrGameSrvInfo.sGameData.bForceFPWeapon=pServerOptions.ForceFPersonWeapon;
}

function RefreshServers ()
{
	if (  !m_bConnectedToServer || m_bIndRefrInProgress || m_bRefreshInProgress )
	{
		return;
	}
	m_fRefreshTime=NativeGetSeconds();
	m_bRefreshInProgress=True;
	m_bMSRequestFinished=False;
	m_GameServerList.Remove (0,m_GameServerList.Length);
	m_GSLSortIdx.Remove (0,m_GSLSortIdx.Length);
	NativeRequestMSList();
}

function bool initGSCDKey ()
{
	local int iPort;
	local bool bCDKInit;

	m_iMaxAvailPorts=Class'UdpLink'.static.GetMaxAvailPorts();
	if (  !m_bGameServiceInit )
	{
		m_bGameServiceInit=NativeInit(GetLocallyBoundIpAddr());
	}
	if ( m_bDedicatedServer )
	{
		iPort=m_iCDKeyServerPort;
	}
	else
	{
		iPort=m_iCDKeyClientPort;
	}
	bCDKInit=NativeInitCDKey(iPort);
	return bCDKInit;
}

function requestGSCDKeyActID ()
{
//	m_eCDKeyActIDRequest=1;
//	m_eMenuGetCDKeyActID=1;
}

function joinServer (int iLobbyID, int iGroupID, string szPassword)
{
	NativeMSCLientJoinServer(iLobbyID,iGroupID,szPassword);
//	m_eJoinServerRequest=1;
//	m_eMenuJoinServer=1;
}

function requestGSCDKeyAuthID ()
{
//	m_eCDKeyAuthorizationRequest=1;
//	m_eMenuCDKeyAuthorization=1;
}

function InitializeGSClient ()
{
	local bool bInitialized;

	m_bGSClientInitialized=NativeInitGSClient();
	m_bStartedByGSClient=Class'Actor'.static.NativeStartedByGSClient();
	if ( m_bStartedByGSClient == True )
	{
		bInitialized=SetGSClientComInterface();
		if ( bInitialized == False )
		{
			Log("ERROR: GS Client Com interface not initialized!!!");
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

function string GetSelectedServerIP ()
{
	local string szIPAddress;
	local string szAltIPAddress;

	szIPAddress=Left(m_GameServerList[m_iSelSrvIndex].szIPAddress,InStr(m_GameServerList[m_iSelSrvIndex].szIPAddress,":"));
	szAltIPAddress=Left(m_GameServerList[m_iSelSrvIndex].szAltIPAddress,InStr(m_GameServerList[m_iSelSrvIndex].szAltIPAddress,":"));
	if ( m_GameServerList[m_iSelSrvIndex].iPing >= NativeGetPingTimeOut() )
	{
		if ( NativeGetPingTime(szIPAddress) >= NativeGetPingTimeOut() )
		{
			if ( NativeGetPingTime(szAltIPAddress) < NativeGetPingTimeOut() )
			{
				m_GameServerList[m_iSelSrvIndex].bUseAltIP=True;
			}
		}
	}
	if ( m_GameServerList[m_iSelSrvIndex].bUseAltIP )
	{
		return m_GameServerList[m_iSelSrvIndex].szAltIPAddress;
	}
	else
	{
		return m_GameServerList[m_iSelSrvIndex].szIPAddress;
	}
}

function StartAutoLogin ()
{
	if ( (m_szUserID != "") && (m_szPassword != "") && m_bAutoLISave )
	{
		InitializeMSClient();
		m_bAutoLoginInProgress=True;
	}
}

event EndOfRoundDataSent ()
{
	R6PlayerController(m_LocalPlayerController).ServerEndOfRoundDataSent();
}

function int GetMaxUbiServerNameSize ()
{
	return 32;
}

function HandleNewLobbyConnection (LevelInfo _Level)
{
	local Controller P;

	P=_Level.ControllerList;
JL0014:
	if ( P != None )
	{
		if ( R6PlayerController(P) != None )
		{
			R6PlayerController(P).ClientNewLobbyConnection(_Level.Game.GameReplicationInfo.m_iGameSvrLobbyID,_Level.Game.GameReplicationInfo.m_iGameSvrGroupID);
		}
		P=P.nextController;
		goto JL0014;
	}
}

function LogOutServer (R6GameReplicationInfo _GRI)
{
	_GRI.m_iGameSvrGroupID=0;
	_GRI.m_iGameSvrLobbyID=0;
	NativeRegServerShutDown();
	SetRegisteredWithMS(False);
}

function MasterServerManager (R6AbstractGameInfo _GameInfo, LevelInfo _Level)
{
	local Controller _aController;
	local PlayerController aPlayerController;
	local int i;
	local int jID;
	local bool bFound;
	local ERegServerRequestState eRSReqState;
	local string szIPAddr;

	eRSReqState=GetGameServiceRequestState();
	if ( _GameInfo.m_bInternetSvr )
	{
		if (  !Class'Actor'.static.NativeStartedByGSClient() )
		{
			switch (eRSReqState)
			{
				case ERSREQ_INIT:
				if ( InitializeRegServer() )
				{
					LoginRegServer(_GameInfo,_Level);
					m_bUpdateServer=False;
					eRSReqState=ERSREQ_LOGIN;
				}
				else
				{
					eRSReqState=ERSREQ_FAILURE;
				}
				break;
				case ERSREQ_LOGIN:
				if ( m_eMenuLoginRegServer == 2 )
				{
					eRSReqState=ERSREQ_SUCCESS;
				}
				else
				{
					if ( m_eMenuLoginRegServer == 3 )
					{
						eRSReqState=ERSREQ_FAILURE;
					}
				}
				break;
				case ERSREQ_SUCCESS:
				eRSReqState=ERSREQ_NONE;
				SetRegisteredWithMS(True);
				_GameInfo.GameReplicationInfo.m_iGameSvrGroupID=NativeGetGroupID();
				_GameInfo.GameReplicationInfo.m_iGameSvrLobbyID=NativeGetLobbyID();
				Log("Server registered with ubi.com master server");
				HandleNewLobbyConnection(_Level);
				break;
				case ERSREQ_FAILURE:
				eRSReqState=ERSREQ_NONE;
				m_iRetryTime=NativeGetSeconds() + 15;
				break;
				case ERSREQ_NONE:
				if (  !NativeGetServerRegistered() && (NativeGetSeconds() > m_iRetryTime) )
				{
					Log("try again time " $ string(_Level.TimeSeconds));
					eRSReqState=ERSREQ_INIT;
				}
				break;
				default:
			}
		}
		if ( m_bInitGame && (_Level.Game.GameReplicationInfo != None) )
		{
			m_bInitGame=False;
			_Level.Game.GameReplicationInfo.m_iGameSvrGroupID=NativeGetGroupID();
			_Level.Game.GameReplicationInfo.m_iGameSvrLobbyID=NativeGetLobbyID();
		}
		if ( m_bUpdateServer )
		{
			if ( GetRegisteredWithMS() )
			{
				m_bUpdateServer=False;
				UpdateServerRegServer(_GameInfo,_Level);
			}
			else
			{
				if ( Class'Actor'.static.NativeStartedByGSClient() )
				{
					UpdateServerUbiCom(_GameInfo,_Level);
					m_bUpdateServer=False;
				}
			}
		}
		if ( m_bRegSrvrConnectionLost )
		{
			m_iRetryTime=NativeGetSeconds() + 15;
			LogOutServer(R6GameReplicationInfo(_GameInfo.GameReplicationInfo));
			m_bRegSrvrConnectionLost=False;
		}
	}
	if (  !GetCDKeyInitialised() )
	{
		SetCDKeyInitialised(initGSCDKey());
	}
	_aController=_Level.ControllerList;
JL02CA:
	if ( _aController != None )
	{
		aPlayerController=PlayerController(_aController);
		if ( aPlayerController != None )
		{
			switch (aPlayerController.m_eCDKeyRequest)
			{
/*				case 1:
				if ( NetConnection(aPlayerController.Player) == None )
				{
					aPlayerController.m_szAuthorizationID=NativeCDKeyGetOwnAuthID();
					szIPAddr=WindowConsole(aPlayerController.Player.Console).szStoreIP;
				}
				else
				{
					szIPAddr=aPlayerController.GetPlayerNetworkAddress();
				}
				aPlayerController.m_szIpAddr=Left(szIPAddr,InStr(szIPAddr,":"));
				if ( PlayerIsInIDList(aPlayerController.m_szAuthorizationID,aPlayerController.m_szIpAddr) )
				{
					aPlayerController.m_szGlobalID=GetGlobalIdFromPlayerIDList(aPlayerController.m_szAuthorizationID);
					aPlayerController.m_eCDKeyRequest=4;
				}
				else
				{
					aPlayerController.m_iCDKeyReqID=NativeCDKeyValidateUser(aPlayerController.m_szAuthorizationID,aPlayerController.m_bCDKeyValSecondTry);
					aPlayerController.m_eCDKeyRequest=2;
				}
				break;
				case 2:
				bFound=False;
				i=0;
JL0440:
				if ( (i < m_ValidResponseList.Length) &&  !bFound )
				{
					if ( aPlayerController.m_iCDKeyReqID == m_ValidResponseList[i].iReqID )
					{
						bFound=True;
						if ( m_ValidResponseList[i].bSuceeded )
						{
							aPlayerController.m_szGlobalID=aPlayerController.GlobalIDToString(m_ValidResponseList[i].ucGlobalID);
							if ( _GameInfo.AccessControl.IsGlobalIDBanned(aPlayerController.m_szGlobalID) )
							{
								m_ValidResponseList[i].eStatus=3;
							}
							aPlayerController.m_eCDKeyStatus=m_ValidResponseList[i].eStatus;
							if ( (m_ValidResponseList[i].eStatus == 1) || (m_ValidResponseList[i].eStatus == 0) || (m_ValidResponseList[i].eStatus == 3) )
							{
								aPlayerController.m_eCDKeyRequest=3;
							}
							else
							{
								aPlayerController.m_eCDKeyRequest=4;
							}
						}
						else
						{
							if ( m_ValidResponseList[i].bTimeout && aPlayerController.m_bCDKeyValSecondTry )
							{
								Log("*** TIMEOUT second attempt ***");
								aPlayerController.m_bCDKeyValSecondTry=False;
								if ( (OnSameSubNet(aPlayerController.m_szIpAddr) == True) || (Viewport(aPlayerController.Player) != None) )
								{
									aPlayerController.m_eCDKeyRequest=4;
								}
								else
								{
									aPlayerController.m_eCDKeyRequest=0;
									aPlayerController.m_eCDKeyStatus=0;
									R6PlayerController(aPlayerController).ServerIndicatesInvalidCDKey("ServerAuthNotResponding");
									if ( R6PlayerController(aPlayerController).m_GameService == None )
									{
										R6PlayerController(aPlayerController).m_GameService=self;
									}
									aPlayerController.SpecialDestroy();
								}
							}
							else
							{
								if ( m_ValidResponseList[i].bTimeout )
								{
									Log("*** TIMEOUT first attempt ***");
									aPlayerController.m_eCDKeyRequest=1;
									aPlayerController.m_bCDKeyValSecondTry=True;
								}
								else
								{
									aPlayerController.m_eCDKeyRequest=3;
								}
							}
						}
					}
					i++;
					goto JL0440;
				}
				m_ValidResponseList.Remove (0,m_ValidResponseList.Length);
				break;
				case 3:
				if ( aPlayerController.m_eCDKeyStatus == 3 )
				{
					R6PlayerController(aPlayerController).ServerIndicatesInvalidCDKey("BannedIP");
				}
				else
				{
					R6PlayerController(aPlayerController).ServerIndicatesInvalidCDKey("CDKeyServerRefused");
				}
				if ( R6PlayerController(aPlayerController).m_GameService == None )
				{
					R6PlayerController(aPlayerController).m_GameService=self;
				}
				aPlayerController.SpecialDestroy();
				aPlayerController.m_eCDKeyRequest=0;
				aPlayerController.m_eCDKeyStatus=1;
				break;
				case 4:
				AddPlayerToIDList(aPlayerController.m_szAuthorizationID,aPlayerController.m_szIpAddr,aPlayerController.m_szGlobalID);
				aPlayerController.m_eCDKeyRequest=0;
				aPlayerController.m_eCDKeyStatus=2;
				break;
				case 0:
				break;
				default:*/
			}
		}
		_aController=_aController.nextController;
		goto JL02CA;
	}
	bFound=False;
	i=0;
JL089F:
	if ( i < m_CDKeyUpdateReqList.Length )
	{
		_aController=_Level.ControllerList;
JL08C3:
		if ( _aController != None )
		{
			aPlayerController=PlayerController(_aController);
			if ( aPlayerController != None )
			{
				if ( aPlayerController.m_szAuthorizationID == m_CDKeyUpdateReqList[i] )
				{
//					NativeCDKeyPlayerStatusReply(aPlayerController.m_szAuthorizationID,aPlayerController.m_eCDKeyStatus);
					bFound=True;
				}
			}
			_aController=_aController.nextController;
			goto JL08C3;
		}
		if (  !bFound )
		{
			NativeCDKeyPlayerStatusReply(m_CDKeyUpdateReqList[i],ECDKEYST_PLAYER_UNKNOWN);
		}
		i++;
		goto JL089F;
	}
	m_CDKeyUpdateReqList.Remove (0,m_CDKeyUpdateReqList.Length);
	GameServiceManager(False,True,True,False);
	SetGameServiceRequestState(eRSReqState);
}

event SetGlobalIDToString (byte _globalID[16])
{
	local int X;

	m_szGlobalID=Class'Actor'.static.GlobalIDToString(_globalID);
}

function string MyID ()
{
	return m_szGlobalID;
}

defaultproperties
{
    m_iCDKeyClientPort=5777
    m_iCDKeyServerPort=5778
    m_iRegSvrPort=6777
    m_bUpdateServer=True
    m_fMaxTimeForResponse=10.00
    m_szGSVersion="315"
    m_szUbiGuestAcct="Ubi_Guest"
    m_szUbiRemFileURL="http://gsconnect.ubisoft.com/gsinit.php?user=%s&dp=%s"
    m_szUbiHomePage="http://www.ubi.com/login/newuser?l=%s"
    m_szGSInitFileName="./GSRouters.dat"
    m_szLastServerQueried="0"
    m_iSelSrvIndex=-1
    m_bUseCDKey=False
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

