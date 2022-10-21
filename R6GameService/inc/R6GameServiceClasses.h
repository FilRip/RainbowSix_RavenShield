/*===========================================================================
    C++ class definitions exported from UnrealScript.
    This is automatically generated by the tools.
    DO NOT modify this manually! Edit the corresponding .uc files instead!
===========================================================================*/
#if SUPPORTS_PRAGMA_PACK
#pragma pack (push,4)
#endif

#ifndef R6GAMESERVICE_API
#define R6GAMESERVICE_API DLL_IMPORT
#endif

#ifndef NAMES_ONLY
#define AUTOGENERATE_NAME(name) extern R6GAMESERVICE_API FName R6GAMESERVICE_##name;
#define AUTOGENERATE_FUNCTION(cls,idx,name)
#endif

AUTOGENERATE_NAME(EndOfRoundDataSent)
AUTOGENERATE_NAME(SetGlobalIDToString)

#ifndef NAMES_ONLY

enum ECDKEYST_STATUS
{
    ECDKEYST_PLAYER_UNKNOWN =0,
    ECDKEYST_PLAYER_INVALID =1,
    ECDKEYST_PLAYER_VALID   =2,
    ECDKEYST_PLAYER_BANNED  =3,
    ECDKEYST_MAX            =4,
};
enum ER6GameType
{
    RGM_AllMode             =0,
    RGM_StoryMode           =1,
    RGM_PracticeMode        =2,
    RGM_MissionMode         =3,
    RGM_TerroristHuntMode   =4,
    RGM_TerroristHuntCoopMode=5,
    RGM_HostageRescueMode   =6,
    RGM_HostageRescueCoopMode=7,
    RGM_HostageRescueAdvMode=8,
    RGM_DefendMode          =9,
    RGM_DefendCoopMode      =10,
    RGM_ReconMode           =11,
    RGM_ReconCoopMode       =12,
    RGM_DeathmatchMode      =13,
    RGM_TeamDeathmatchMode  =14,
    RGM_BombAdvMode         =15,
    RGM_EscortAdvMode       =16,
    RGM_LoneWolfMode        =17,
    RGM_SquadDeathmatch     =18,
    RGM_SquadTeamDeathmatch =19,
    RGM_TerroristHuntAdvMode=20,
    RGM_ScatteredHuntAdvMode=21,
    RGM_CaptureTheEnemyAdvMode=22,
    RGM_CountDownMode       =23,
    RGM_KamikazeMode        =24,
    RGM_NoRulesMode         =25,
    RGM_MAX                 =26,
};
enum eSortCategory
{
    eSG_Favorite            =0,
    eSG_Locked              =1,
    eSG_Dedicated           =2,
    eSG_PunkBuster          =3,
    eSG_PingTime            =4,
    eSG_Name                =5,
    eSG_GameType            =6,
    eSG_GameMode            =7,
    eSG_Map                 =8,
    eSG_NumPlayers          =9,
    eSG_MAX                 =10,
};
#define UCONST_K_GlobalID_size 16

class R6GAMESERVICE_API UR6ServerList : public UR6AbstractGameService
{
public:
    INT m_iSelSrvIndex;
    INT m_iIndRefrIndex;
    BITFIELD m_bDedicatedServer:1 GCC_PACK(4);
    BITFIELD m_bServerListChanged:1;
    BITFIELD m_bServerInfoChanged:1;
    BITFIELD m_bUseCDKey:1;
    BITFIELD m_bIndRefrInProgress:1;
    BITFIELD m_bSavePWSave:1;
    BITFIELD m_bAutoLISave:1;
    class AClientBeaconReceiver* m_ClientBeacon GCC_PACK(4);
    TArrayNoInit<FString> m_favoriteServersList;
    TArrayNoInit<FstGameServer> m_GameServerList;
    TArrayNoInit<FstValidationResponse> m_ValidResponseList;
    TArrayNoInit<INT> m_GSLSortIdx;
    FstFilterSettings m_Filters;
    FstGameServer m_CrGameSrvInfo;
    FStringNoInit m_szGameVersion;
    DECLARE_FUNCTION(execGetDisplayListSize);
    DECLARE_FUNCTION(execNativeGetMaxPlayers);
    DECLARE_FUNCTION(execNativeGetGroupID);
    DECLARE_FUNCTION(execNativeGetLobbyID);
    DECLARE_FUNCTION(execNativeGetOwnSvrPort);
    DECLARE_FUNCTION(execNativeSetOwnSvrPort);
    DECLARE_FUNCTION(execNativeFillSvrContainer);
    DECLARE_FUNCTION(execNativeResetSvrContainer);
    DECLARE_FUNCTION(execSortServers);
    DECLARE_FUNCTION(execNativeGetMilliSeconds);
    DECLARE_FUNCTION(execNativeGetPingTimeOut);
    DECLARE_FUNCTION(execNativeGetPingTime);
    DECLARE_FUNCTION(execNativeUpdateFavorites);
    DECLARE_FUNCTION(execNativeInitFavorites);
    DECLARE_CLASS(UR6ServerList,UR6AbstractGameService,0|CLASS_Config,R6GameService)
    NO_DEFAULT_CONSTRUCTOR(UR6ServerList)
};

#define UCONST_K_REFRESH_TIMEOUT 1000
#define UCONST_K_INDREFR_MAXATT 4

class R6GAMESERVICE_API UR6LanServers : public UR6ServerList
{
public:
    INT m_iIndRefrAttempts;
    INT m_iIndRefrEndTime;
    DECLARE_CLASS(UR6LanServers,UR6ServerList,0|CLASS_Config,R6GameService)
    NO_DEFAULT_CONSTRUCTOR(UR6LanServers)
};

enum ERegServerRequestState
{
    ERSREQ_NONE             =0,
    ERSREQ_INIT             =1,
    ERSREQ_LOGIN            =2,
    ERSREQ_SUCCESS          =3,
    ERSREQ_FAILURE          =4,
    ERSREQ_MAX              =5,
};
enum EGSRequestState
{
    EGSREQ_NONE             =0,
    EGSREQ_FIRST_PASS       =1,
    EGSREQ_WAITING_FOR_RESPONSE=2,
    EGSREQ_FAILED           =3,
    EGSREQ_CONNECT_FAILED   =4,
    EGSREQ_INUSE_FAILED     =5,
    EGSREQ_SUCCESS          =6,
    EGSREQ_MAX              =7,
};
enum EMenuRequestState
{
    EMENU_REQ_NONE          =0,
    EMENU_REQ_PENDING       =1,
    EMENU_REQ_SUCCESS       =2,
    EMENU_REQ_FAILURE       =3,
    EMENU_REQ_TIMEOUT       =4,
    EMENU_REQ_TIMEOUT_ERROR =5,
    EMENU_REQ_INUSE_ERROR   =6,
    EMENU_REQ_NOTCHALLENGED =7,
    EMENU_REQ_INT_ERROR     =8,
    EMENU_MAX               =9,
};
enum EGSGameState
{
    EGS_WAITING_FOR_GS_INIT =0,
    EGS_CLIENT_INIT_RCVD    =1,
    EGS_CLIENT_WAITING_CHSTA=2,
    EGS_CLIENT_CHSTA_RCVD   =3,
    EGS_CLIENT_IN_GAME      =4,
    EGS_SERVER_INIT_RCVD    =5,
    EGS_SERVER_WAITING_CHSTA=6,
    EGS_SERVER_CHSTA_RCVD   =7,
    EGS_SERVER_SETTING_UP_GAME=8,
    EGS_TERMINATE_RCVD      =9,
    EGS_SERVER_READY        =10,
    EGS_MAX                 =11,
};
enum EGSMESSAGE_ID
{
    EGSMESSAGE_INITMASTERSESSION_AK=0,
    EGSMESSAGE_MASTERSESSION_AK=1,
    EGSMESSAGE_READYTORECEIVECONNECTIONS=2,
    EGSMESSAGE_INITCLIENTSESSION_AK=3,
    EGSMESSAGE_CLIENTSESSION_AK=4,
    EGSMESSAGE_SWITCHTOGS   =5,
    EGSMESSAGE_MAX          =6,
};
enum EFailureReasons
{
    EFAIL_DEFAULT           =0,
    EFAIL_SERVER_CONNECT    =1,
    EFAIL_PASSWORDNOTCORRECT=2,
    EFAIL_ROOMFULL          =3,
    EFAIL_ALREADYCONNECTED  =4,
    EFAIL_NOTREGISTERED     =5,
    EFAIL_NOTDISCONNECTED   =6,
    EFAIL_PLAYERALREADYREGISTERED=7,
    EFAIL_TIMED_OUT         =8,
    EFAIL_CDKEYUSED         =9,
    EFAIL_INVALIDCDKEY      =10,
    EFAIL_DATABASEFAILED    =11,
    EFAIL_BANNEDACCOUNT     =12,
    EFAIL_BLOCKEDACCOUNT    =13,
    EFAIL_LOCKEDACCOUNT     =14,
    EFAIL_MAX               =15,
};
#define UCONST_K_MAX_SIZE_UBISERVERNAME 32
#define UCONST_K_TimeRetryConnect 15

struct UR6GSServers_eventSetGlobalIDToString_Parms
{
    BYTE _globalID[16];
};
struct UR6GSServers_eventEndOfRoundDataSent_Parms
{
};
class R6GAMESERVICE_API UR6GSServers : public UR6ServerList
{
public:
    BYTE m_eMenuLoginUbidotcom;
    BYTE m_eMenuLoginFailReason;
    BYTE m_eMenuCreateAccount;
    BYTE m_eMenuCrAcctFailReason;
    BYTE m_eMenuCreateGame;
    BYTE m_eMenuCrGameFailReason;
    BYTE m_eMenuCDKeyNotUsed;
    BYTE m_eMenuCDKeyFailReason;
    BYTE m_eMenuJoinLobby;
    BYTE m_eMenuLoginMasterSvr;
    BYTE m_eMenuLogMasSvrFailReason;
    BYTE m_eMenuLoginRegServer;
    BYTE m_eMenuUpdateServer;
    BYTE m_eMenuGetCDKeyActID;
    BYTE m_eMenuCDKeyAuthorization;
    BYTE m_eMenuUserValidation;
    BYTE m_eMenuJoinServer;
    BYTE m_eMenuJoinRoomFailReason;
    BYTE m_eGSGameState;
    BYTE m_ucActivationID[16];
    BYTE m_eLoginRouterRequest;
    BYTE m_eLoginWaitModuleRequest;
    BYTE m_eJoinWaitModuleRequest;
    BYTE m_eCreateAccountRequest;
    BYTE m_eLoginFriendServiceRequest;
    BYTE m_eLoginLobbyServiceRequest;
    BYTE m_eCreateGameRequest;
    BYTE m_eCDKeyNotUsedRequest;
    BYTE m_eJoinLobbyRequest;
    BYTE m_eJoinRoomRequest;
    BYTE m_eMSClientInitRequest;
    BYTE m_eGameStartRequest;
    BYTE m_eGameReadyRequest;
    BYTE m_eGameConnectedRequest;
    BYTE m_eRegServerLoginRouterRequest;
    BYTE m_eRegServerGetLobbiesRequest;
    BYTE m_eRegServerRegOnLobbyRequest;
    BYTE m_eRegServerConnectRequest;
    BYTE m_eRegServerLoginRequest;
    BYTE m_eRegServerUpdateRequest;
    BYTE m_eCDKeyActIDRequest;
    BYTE m_eCDKeyAuthorizationRequest;
    BYTE m_eUserValidationRequest;
    BYTE m_eJoinServerRequest;
    INT m_bPingsPending;
    INT m_iWaitModulePort;
    INT m_iLobbyIndex;
    INT m_iCDKeyClientPort;
    INT m_iCDKeyServerPort;
    INT m_iRegSvrPort;
    INT m_iOwnGroupID;
    INT m_iOwnLobbySrvID;
    INT m_iGroupID;
    INT m_iLobbySrvID;
    INT m_iRoomCreatedGroupID;
    INT m_iRetryTime;
    INT m_iMaxAvailPorts;
    INT m_iGSNumPlayers;
    BITFIELD m_bGameServiceInit:1 GCC_PACK(4);
    BITFIELD m_bConnectedToServer:1;
    BITFIELD m_bLoggedInToServer:1;
    BITFIELD m_bLoggedInToLobbyService:1;
    BITFIELD m_bLoggedInToFriendService:1;
    BITFIELD m_bCDKeyNotUsed:1;
    BITFIELD m_bServerJoined:1;
    BITFIELD m_bRegSrvrConnectionLost:1;
    BITFIELD m_bGSClientInitialized:1;
    BITFIELD m_bRefreshInProgress:1;
    BITFIELD m_bRefreshFinished:1;
    BITFIELD m_bMSRequestFinished:1;
    BITFIELD m_bValidActivationID:1;
    BITFIELD m_bPingReceived:1;
    BITFIELD m_bUbiAccntInfoEntered:1;
    BITFIELD m_bLoggedInUbiDotCom:1;
    BITFIELD m_bInitGame:1;
    BITFIELD m_bUpdateServer:1;
    BITFIELD m_bUbiComClientDied:1;
    BITFIELD m_bUbiComRoomDestroyed:1;
    BITFIELD m_bAutoLoginInProgress:1;
    BITFIELD m_bAutoLoginFailed:1;
    BITFIELD m_bStartedByGSClient:1;
    BITFIELD bShowLog:1;
    FLOAT m_fLoginRouterStartTime GCC_PACK(4);
    FLOAT m_fLoginWaitModuleStartTime;
    FLOAT m_fJoinWaitModuleStartTime;
    FLOAT m_fCreateAccountStartTime;
    FLOAT m_fLoginFriendServiceStartTime;
    FLOAT m_fLoginLobbyServiceStartTime;
    FLOAT m_fCDKeyStartTime;
    FLOAT m_fCreateGameStartTime;
    FLOAT m_fMSClientInitStartTime;
    FLOAT m_fJoinLobbyStartTime;
    FLOAT m_fJoinRoomStartTime;
    FLOAT m_fGameStartStartTime;
    FLOAT m_fGameReadyStartTime;
    FLOAT m_fGameConnectedStartTime;
    FLOAT m_fRegServerRouterLoginTime;
    FLOAT m_fRegServerGetLobbiesTime;
    FLOAT m_fMaxTimeForResponse;
    FLOAT m_fRegServerRegOnLobbyTime;
    FLOAT m_fRegServerConnectTime;
    FLOAT m_fRegServerLoginTime;
    FLOAT m_fRegServerUpdateTime;
    FLOAT m_fCDKeyGetActIDTime;
    FLOAT m_fCDKeyGetAuthorizationTime;
    FLOAT m_fUserValidationTime;
    FLOAT m_fJoinServerTime;
    FLOAT m_fRefreshTime;
    TArrayNoInit<INT> m_PingReqList;
    TArrayNoInit<FString> m_CDKeyUpdateReqList;
    FstLobby m_GaveServerID;
    FStringNoInit m_szNetGameName;
    FStringNoInit m_szUBIClientVersion;
    FStringNoInit m_szGSVersion;
    FStringNoInit m_szCDKey;
    FStringNoInit m_szUbiGuestAcct;
    FStringNoInit m_szGlobalID;
    FStringNoInit m_szUbiRemFileURL;
    FStringNoInit m_szUbiHomePage;
    FStringNoInit m_szSavedPwd;
    FStringNoInit m_szFirstName;
    FStringNoInit m_szLastName;
    FStringNoInit m_szCountry;
    FStringNoInit m_szEmail;
    FStringNoInit m_szAuthorizationID;
    FStringNoInit m_szRegSvrUserID;
    FStringNoInit m_szPassword;
    FStringNoInit m_szGSInitFileName;
    FStringNoInit m_szGSClientIP;
    FStringNoInit m_szGSClientAltIP;
    FStringNoInit m_szGSServerName;
    FStringNoInit m_szLastServerQueried;
    FStringNoInit m_szGSPassword;
    DECLARE_FUNCTION(execOnSameSubNet);
    DECLARE_FUNCTION(execHandleAnyLobbyConnectionFail);
    DECLARE_FUNCTION(execResetAuthId);
    DECLARE_FUNCTION(execDisconnectAllCDKeyPlayers);
    DECLARE_FUNCTION(execNativeCDKeyDisconnecUser);
    DECLARE_FUNCTION(execGetCDKeyInitialised);
    DECLARE_FUNCTION(execSetCDKeyInitialised);
    DECLARE_FUNCTION(execGetRegisteredWithMS);
    DECLARE_FUNCTION(execSetRegisteredWithMS);
    DECLARE_FUNCTION(execGetGameServiceRequestState);
    DECLARE_FUNCTION(execSetGameServiceRequestState);
    DECLARE_FUNCTION(execCleanPlayerIDList);
    DECLARE_FUNCTION(execNativeMSClientServerConnected);
    DECLARE_FUNCTION(execTestRegServerLobbyDisconnect);
    DECLARE_FUNCTION(execLogGSVersion);
    DECLARE_FUNCTION(execSetGSClientComInterface);
    DECLARE_FUNCTION(execNativeProcessIcmpPing);
    DECLARE_FUNCTION(execNativeSetMatchResult);
    DECLARE_FUNCTION(execNativeServerRoundFinish);
    DECLARE_FUNCTION(execNativeServerRoundStart);
    DECLARE_FUNCTION(execNativeCheckGSClientAlive);
    DECLARE_FUNCTION(execNativeGSClientUpdateServerInfo);
    DECLARE_FUNCTION(execNativeGSClientPostMessage);
    DECLARE_FUNCTION(execNativeInitGSClient);
    DECLARE_FUNCTION(execGetIDListSize);
    DECLARE_FUNCTION(execGetIDListAuthID);
    DECLARE_FUNCTION(execGetIDListIPAddr);
    DECLARE_FUNCTION(execRemoveFromIDList);
    DECLARE_FUNCTION(execGetGlobalIdFromPlayerIDList);
    DECLARE_FUNCTION(execPlayerIsInIDList);
    DECLARE_FUNCTION(execAddPlayerToIDList);
    DECLARE_FUNCTION(execNativeGetServerRegistered);
    DECLARE_FUNCTION(execNativeMSCLientJoinServer);
    DECLARE_FUNCTION(execNativeRegServerShutDown);
    DECLARE_FUNCTION(execNativeGetRegServerIntialized);
    DECLARE_FUNCTION(execNativeRegServerServerClose);
    DECLARE_FUNCTION(execNativeMSClientReqAltInfo);
    DECLARE_FUNCTION(execNativeRefreshServer);
    DECLARE_FUNCTION(execNativeMSCLientLeaveServer);
    DECLARE_FUNCTION(execNativeUnInitMSClient);
    DECLARE_FUNCTION(execNativeInitMSClient);
    DECLARE_FUNCTION(execNativeRequestMSList);
    DECLARE_FUNCTION(execNativeRegServerMemberLeave);
    DECLARE_FUNCTION(execNativeRegServerMemberJoin);
    DECLARE_FUNCTION(execNativeGetLoggedInUbiDotCom);
    DECLARE_FUNCTION(execNativeGetMSClientInitialized);
    DECLARE_FUNCTION(execNativeReceiveValidation);
    DECLARE_FUNCTION(execNativeCDKeyGetOwnAuthID);
    DECLARE_FUNCTION(execNativeCDKeyPlayerStatusReply);
    DECLARE_FUNCTION(execNativeCDKeyValidateUser);
    DECLARE_FUNCTION(execNativeUnInitCDKey);
    DECLARE_FUNCTION(execNativeInitCDKey);
    DECLARE_FUNCTION(execNativeRequestAuthorization);
    DECLARE_FUNCTION(execNativeRequestActivation);
    DECLARE_FUNCTION(execNativePingReq);
    DECLARE_FUNCTION(execNativeUpdateServer);
    DECLARE_FUNCTION(execNativeGetInitialized);
    DECLARE_FUNCTION(execNativeServerLogin);
    DECLARE_FUNCTION(execNativeRouterDisconnect);
    DECLARE_FUNCTION(execNativeRegisterServer);
    DECLARE_FUNCTION(execNativeRegServerGetLobbies);
    DECLARE_FUNCTION(execNativeRegServerRouterLogin);
    DECLARE_FUNCTION(execNativeInitRegServer);
    DECLARE_FUNCTION(execNativeReceiveAltInfo);
    DECLARE_FUNCTION(execNativeReceiveServer);
    DECLARE_FUNCTION(execNativePollCallbacks);
    DECLARE_FUNCTION(execNativeGetSeconds);
    DECLARE_FUNCTION(execNativeInit);
    void eventSetGlobalIDToString(BYTE* _globalID)
    {
        UR6GSServers_eventSetGlobalIDToString_Parms Parms;
        appMemcpy(&Parms._globalID,&_globalID,sizeof(Parms._globalID));
        ProcessEvent(FindFunctionChecked(R6GAMESERVICE_SetGlobalIDToString),&Parms);
    }
    void eventEndOfRoundDataSent()
    {
        ProcessEvent(FindFunctionChecked(R6GAMESERVICE_EndOfRoundDataSent),NULL);
    }
    DECLARE_CLASS(UR6GSServers,UR6ServerList,0|CLASS_Config,R6GameService)
    NO_DEFAULT_CONSTRUCTOR(UR6GSServers)
};

#endif

AUTOGENERATE_FUNCTION(UR6ServerList,1314,execGetDisplayListSize);
AUTOGENERATE_FUNCTION(UR6ServerList,1355,execNativeGetMaxPlayers);
AUTOGENERATE_FUNCTION(UR6ServerList,1352,execNativeGetGroupID);
AUTOGENERATE_FUNCTION(UR6ServerList,1351,execNativeGetLobbyID);
AUTOGENERATE_FUNCTION(UR6ServerList,1292,execNativeGetOwnSvrPort);
AUTOGENERATE_FUNCTION(UR6ServerList,1291,execNativeSetOwnSvrPort);
AUTOGENERATE_FUNCTION(UR6ServerList,1229,execNativeFillSvrContainer);
AUTOGENERATE_FUNCTION(UR6ServerList,1236,execNativeResetSvrContainer);
AUTOGENERATE_FUNCTION(UR6ServerList,1206,execSortServers);
AUTOGENERATE_FUNCTION(UR6ServerList,1278,execNativeGetMilliSeconds);
AUTOGENERATE_FUNCTION(UR6ServerList,1202,execNativeGetPingTimeOut);
AUTOGENERATE_FUNCTION(UR6ServerList,1225,execNativeGetPingTime);
AUTOGENERATE_FUNCTION(UR6ServerList,1223,execNativeUpdateFavorites);
AUTOGENERATE_FUNCTION(UR6ServerList,1222,execNativeInitFavorites);
AUTOGENERATE_FUNCTION(UR6GSServers,1313,execOnSameSubNet);
AUTOGENERATE_FUNCTION(UR6GSServers,1310,execHandleAnyLobbyConnectionFail);
AUTOGENERATE_FUNCTION(UR6GSServers,1309,execResetAuthId);
AUTOGENERATE_FUNCTION(UR6GSServers,1307,execDisconnectAllCDKeyPlayers);
AUTOGENERATE_FUNCTION(UR6GSServers,1263,execNativeCDKeyDisconnecUser);
AUTOGENERATE_FUNCTION(UR6GSServers,1266,execGetCDKeyInitialised);
AUTOGENERATE_FUNCTION(UR6GSServers,1265,execSetCDKeyInitialised);
AUTOGENERATE_FUNCTION(UR6GSServers,1252,execGetRegisteredWithMS);
AUTOGENERATE_FUNCTION(UR6GSServers,1251,execSetRegisteredWithMS);
AUTOGENERATE_FUNCTION(UR6GSServers,1247,execGetGameServiceRequestState);
AUTOGENERATE_FUNCTION(UR6GSServers,1246,execSetGameServiceRequestState);
AUTOGENERATE_FUNCTION(UR6GSServers,1308,execCleanPlayerIDList);
AUTOGENERATE_FUNCTION(UR6GSServers,1354,execNativeMSClientServerConnected);
AUTOGENERATE_FUNCTION(UR6GSServers,1353,execTestRegServerLobbyDisconnect);
AUTOGENERATE_FUNCTION(UR6GSServers,1300,execLogGSVersion);
AUTOGENERATE_FUNCTION(UR6GSServers,1299,execSetGSClientComInterface);
AUTOGENERATE_FUNCTION(UR6GSServers,1298,execNativeProcessIcmpPing);
AUTOGENERATE_FUNCTION(UR6GSServers,1296,execNativeSetMatchResult);
AUTOGENERATE_FUNCTION(UR6GSServers,1295,execNativeServerRoundFinish);
AUTOGENERATE_FUNCTION(UR6GSServers,1294,execNativeServerRoundStart);
AUTOGENERATE_FUNCTION(UR6GSServers,1350,execNativeCheckGSClientAlive);
AUTOGENERATE_FUNCTION(UR6GSServers,1293,execNativeGSClientUpdateServerInfo);
AUTOGENERATE_FUNCTION(UR6GSServers,1289,execNativeGSClientPostMessage);
AUTOGENERATE_FUNCTION(UR6GSServers,1288,execNativeInitGSClient);
AUTOGENERATE_FUNCTION(UR6GSServers,1286,execGetIDListSize);
AUTOGENERATE_FUNCTION(UR6GSServers,1285,execGetIDListAuthID);
AUTOGENERATE_FUNCTION(UR6GSServers,1284,execGetIDListIPAddr);
AUTOGENERATE_FUNCTION(UR6GSServers,1290,execRemoveFromIDList);
AUTOGENERATE_FUNCTION(UR6GSServers,1315,execGetGlobalIdFromPlayerIDList);
AUTOGENERATE_FUNCTION(UR6GSServers,1239,execPlayerIsInIDList);
AUTOGENERATE_FUNCTION(UR6GSServers,1238,execAddPlayerToIDList);
AUTOGENERATE_FUNCTION(UR6GSServers,1204,execNativeGetServerRegistered);
AUTOGENERATE_FUNCTION(UR6GSServers,1277,execNativeMSCLientJoinServer);
AUTOGENERATE_FUNCTION(UR6GSServers,1276,execNativeRegServerShutDown);
AUTOGENERATE_FUNCTION(UR6GSServers,1275,execNativeGetRegServerIntialized);
AUTOGENERATE_FUNCTION(UR6GSServers,1274,execNativeRegServerServerClose);
AUTOGENERATE_FUNCTION(UR6GSServers,1220,execNativeMSClientReqAltInfo);
AUTOGENERATE_FUNCTION(UR6GSServers,1255,execNativeRefreshServer);
AUTOGENERATE_FUNCTION(UR6GSServers,1272,execNativeMSCLientLeaveServer);
AUTOGENERATE_FUNCTION(UR6GSServers,1249,execNativeUnInitMSClient);
AUTOGENERATE_FUNCTION(UR6GSServers,1234,execNativeInitMSClient);
AUTOGENERATE_FUNCTION(UR6GSServers,1235,execNativeRequestMSList);
AUTOGENERATE_FUNCTION(UR6GSServers,1270,execNativeRegServerMemberLeave);
AUTOGENERATE_FUNCTION(UR6GSServers,1269,execNativeRegServerMemberJoin);
AUTOGENERATE_FUNCTION(UR6GSServers,1268,execNativeGetLoggedInUbiDotCom);
AUTOGENERATE_FUNCTION(UR6GSServers,1267,execNativeGetMSClientInitialized);
AUTOGENERATE_FUNCTION(UR6GSServers,1264,execNativeReceiveValidation);
AUTOGENERATE_FUNCTION(UR6GSServers,1287,execNativeCDKeyGetOwnAuthID);
AUTOGENERATE_FUNCTION(UR6GSServers,1262,execNativeCDKeyPlayerStatusReply);
AUTOGENERATE_FUNCTION(UR6GSServers,1261,execNativeCDKeyValidateUser);
AUTOGENERATE_FUNCTION(UR6GSServers,1260,execNativeUnInitCDKey);
AUTOGENERATE_FUNCTION(UR6GSServers,1259,execNativeInitCDKey);
AUTOGENERATE_FUNCTION(UR6GSServers,1258,execNativeRequestAuthorization);
AUTOGENERATE_FUNCTION(UR6GSServers,1257,execNativeRequestActivation);
AUTOGENERATE_FUNCTION(UR6GSServers,1254,execNativePingReq);
AUTOGENERATE_FUNCTION(UR6GSServers,1250,execNativeUpdateServer);
AUTOGENERATE_FUNCTION(UR6GSServers,1248,execNativeGetInitialized);
AUTOGENERATE_FUNCTION(UR6GSServers,1245,execNativeServerLogin);
AUTOGENERATE_FUNCTION(UR6GSServers,1244,execNativeRouterDisconnect);
AUTOGENERATE_FUNCTION(UR6GSServers,1243,execNativeRegisterServer);
AUTOGENERATE_FUNCTION(UR6GSServers,1242,execNativeRegServerGetLobbies);
AUTOGENERATE_FUNCTION(UR6GSServers,1241,execNativeRegServerRouterLogin);
AUTOGENERATE_FUNCTION(UR6GSServers,1240,execNativeInitRegServer);
AUTOGENERATE_FUNCTION(UR6GSServers,1237,execNativeReceiveAltInfo);
AUTOGENERATE_FUNCTION(UR6GSServers,1214,execNativeReceiveServer);
AUTOGENERATE_FUNCTION(UR6GSServers,1205,execNativePollCallbacks);
AUTOGENERATE_FUNCTION(UR6GSServers,1203,execNativeGetSeconds);
AUTOGENERATE_FUNCTION(UR6GSServers,1201,execNativeInit);

#ifndef NAMES_ONLY
#undef AUTOGENERATE_NAME
#undef AUTOGENERATE_FUNCTION
#endif

#if SUPPORTS_PRAGMA_PACK
#pragma pack (pop)
#endif
