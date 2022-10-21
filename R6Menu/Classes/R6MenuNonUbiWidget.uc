//================================================================================
// R6MenuNonUbiWidget.
//================================================================================
class R6MenuNonUbiWidget extends R6MenuWidget;

enum eJoinRoomChoice {
	EJRC_NO,
	EJRC_BY_LOBBY_AND_ROOM_ID
};

var bool m_bLoginInProgress;
var bool m_bPreJoinInProgress;
var bool m_bJoinIPInProgress;
var bool m_bQueryServerInfoInProgress;
var bool m_bNonUbiMatchMakingClient;
var R6GSServers m_GameService;
var R6WindowUbiLogIn m_pLoginWindow;
var R6WindowUbiCDKeyCheck m_pCDKeyCheckWindow;
var R6WindowJoinIP m_pJoinIPWindow;
var R6WindowQueryServerInfo m_pQueryServerInfo;
var string m_szGamePwd;

function Created ()
{
	m_GameService=R6Console(Root.Console).m_GameService;
	m_pLoginWindow=R6WindowUbiLogIn(CreateWindow(Root.MenuClassDefines.ClassUbiLogIn,0.00,0.00,640.00,480.00,self,True));
	m_pLoginWindow.m_GameService=R6Console(Root.Console).m_GameService;
	m_pLoginWindow.PopUpBoxCreate();
	m_pLoginWindow.HideWindow();
	m_pCDKeyCheckWindow=R6WindowUbiCDKeyCheck(CreateWindow(Root.MenuClassDefines.ClassUbiCDKeyCheck,0.00,0.00,640.00,480.00,self,True));
	m_pCDKeyCheckWindow.m_GameService=R6Console(Root.Console).m_GameService;
	m_pCDKeyCheckWindow.PopUpBoxCreate();
	m_pCDKeyCheckWindow.HideWindow();
	m_pJoinIPWindow=R6WindowJoinIP(CreateWindow(Root.MenuClassDefines.ClassMultiJoinIP,0.00,0.00,640.00,480.00,self,True));
	m_pJoinIPWindow.m_GameService=m_GameService;
	m_pJoinIPWindow.PopUpBoxCreate();
	m_pJoinIPWindow.HideWindow();
	m_pQueryServerInfo=R6WindowQueryServerInfo(CreateWindow(Root.MenuClassDefines.ClassQueryServerInfo,0.00,0.00,640.00,480.00,self,True));
	m_pQueryServerInfo.m_GameService=m_GameService;
	m_pQueryServerInfo.PopUpBoxCreate();
	m_pQueryServerInfo.HideWindow();
	m_bNonUbiMatchMakingClient=R6Console(Root.Console).m_bNonUbiMatchMaking;
}

function ShowWindow ()
{
	if ( m_bNonUbiMatchMakingClient || R6Console(Root.Console).m_bAutoLoginFirstPass )
	{
		R6Console(Root.Console).m_bAutoLoginFirstPass=False;
		R6MenuRootWindow(Root).InitBeaconService();
		R6Console(Root.Console).m_GameService.StartAutoLogin();
		if (  !R6Console(Root.Console).m_GameService.m_bAutoLoginInProgress )
		{
			R6Console(Root.Console).szStoreGamePassWd=R6Console(Root.Console).m_GameService.m_szSavedPwd;
			m_pLoginWindow.StartLogInProcedure(self);
			m_bLoginInProgress=True;
		}
		else
		{
			m_pLoginWindow.m_pSendMessageDest=self;
			m_bLoginInProgress=True;
		}
	}
	Super.ShowWindow();
}

function Paint (Canvas C, float X, float Y)
{
	local string szTemp;
	local float W;
	local float H;

	C.Style=5;
	C.SetDrawColor(Root.Colors.Black.R,Root.Colors.Black.G,Root.Colors.Black.B);
	DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,0.00,0.00,10.00,10.00,Texture'WhiteTexture');
}

function Tick (float Delta)
{
	if ( m_bLoginInProgress )
	{
		m_pLoginWindow.Manager(self);
	}
	if ( m_bPreJoinInProgress )
	{
		m_pCDKeyCheckWindow.Manager(self);
	}
	if ( m_bJoinIPInProgress )
	{
		m_pJoinIPWindow.Manager(self);
	}
	if ( m_bQueryServerInfoInProgress )
	{
		m_pQueryServerInfo.Manager(self);
	}
}

function SendMessage (eR6MenuWidgetMessage eMessage)
{
	local string _szIpAddress;

	switch (eMessage)
	{
/*		case 10:
		m_bQueryServerInfoInProgress=False;
		case 0:
		case 2:
		m_bLoginInProgress=False;
		Class'Actor'.static.NativeNonUbiMatchMakingAddress(_szIpAddress);
		if ( m_bNonUbiMatchMakingClient )
		{
			m_pQueryServerInfo.StartQueryServerInfoProcedure(self,_szIpAddress,0);
			m_bQueryServerInfoInProgress=True;
		}
		break;
		case 3:
		case 4:
		m_bPreJoinInProgress=False;
		if ( m_bNonUbiMatchMakingClient )
		{
			Class'Actor'.static.NativeNonUbiMatchMakingAddress(_szIpAddress);
			m_szGamePwd=m_pCDKeyCheckWindow.m_szPassword;
			joinServer(_szIpAddress);
		}
		break;
		case 1:
		m_bLoginInProgress=False;
		case 5:
		m_bPreJoinInProgress=False;
		Root.ChangeCurrentWidget(37);
		break;
		case 6:
		m_bJoinIPInProgress=False;
		joinServer(m_pJoinIPWindow.m_szIP);
		break;
		case 8:
		QueryReceivedStartPreJoin();
		Log("m_bRoomValid =" @ string(m_pQueryServerInfo.m_bRoomValid));
		m_bQueryServerInfoInProgress=False;
		break;
		case 9:
		m_bQueryServerInfoInProgress=False;
		break;
		default:*/
	}
}

function QueryReceivedStartPreJoin ()
{
	local eJoinRoomChoice eJoinRoom;
	local bool bRoomValid;

	bRoomValid=(m_GameService.m_ClientBeacon.PreJoinInfo.iLobbyID != 0) && (m_GameService.m_ClientBeacon.PreJoinInfo.iGroupID != 0);
	if ( bRoomValid )
	{
//		eJoinRoom=1;
	}
	else
	{
//		eJoinRoom=0;
	}
//	m_pCDKeyCheckWindow.StartPreJoinProcedure(self,m_GameService.m_ClientBeacon.PreJoinInfo.bLocked,eJoinRoom,m_GameService.m_ClientBeacon.PreJoinInfo.iGroupID,m_GameService.m_ClientBeacon.PreJoinInfo.iLobbyID);
	m_bPreJoinInProgress=True;
}

function joinServer (string szIPAddress)
{
	local int iPlayerSpawnNumber;
	local string szOptions;
	local string m_CharacterName;
	local string szUbiUserID;
	local string m_ArmorName;
	local string m_WeaponNameOne;
	local string m_WeaponGadgetNameOne;
	local string m_BulletTypeOne;
	local string m_WeaponNameTwo;
	local string m_WeaponGadgetNameTwo;
	local string m_BulletTypeTwo;
	local string m_GadgetNameOne;
	local string m_GadgetNameTwo;
	local PlayerController aPlayerController;

	iPlayerSpawnNumber=R6Console(Root.Console).GetSpawnNumber();
	szOptions="";
	szOptions=szOptions $ "?Password=" $ m_pCDKeyCheckWindow.m_szPassword;
	Root.Console.ViewportOwner.Actor.GetPlayerSetupInfo(m_CharacterName,m_ArmorName,m_WeaponNameOne,m_WeaponGadgetNameOne,m_BulletTypeOne,m_WeaponNameTwo,m_WeaponGadgetNameTwo,m_BulletTypeTwo,m_GadgetNameOne,m_GadgetNameTwo);
	ReplaceText(m_CharacterName,"?","~");
	ReplaceText(m_CharacterName,",","~");
	ReplaceText(m_CharacterName,"#","~");
	ReplaceText(m_CharacterName,"/","~");
	szOptions=szOptions $ "?Name=" $ m_CharacterName;
	ReplaceText(szOptions," ","~");
	szUbiUserID=m_GameService.m_szUserID;
	szOptions=szOptions $ "?UbiUserID=" $ m_GameService.m_szUserID;
	m_GameService.SaveConfig();
	Root.Console.ConsoleCommand("Start " $ szIPAddress $ "?SpawnNum=" $ string(iPlayerSpawnNumber) $ szOptions $ "?AuthID=" $ m_GameService.m_szAuthorizationID);
	R6Console(Root.Console).szStoreIP=szIPAddress;
	R6Console(Root.Console).szStoreGamePassWd=m_pCDKeyCheckWindow.m_szPassword;
	R6MenuRootWindow(Root).m_bJoinServerProcess=True;
}

function PromptConnectionError ()
{
	local R6MenuRootWindow r6Root;
	local string szTemp;

	r6Root=R6MenuRootWindow(Root);
	r6Root.m_RSimplePopUp.X=140;
	r6Root.m_RSimplePopUp.Y=170;
	r6Root.m_RSimplePopUp.W=360;
	r6Root.m_RSimplePopUp.H=77;
	if ( R6Console(Root.Console).m_szLastError != "" )
	{
		szTemp=Localize("Multiplayer",R6Console(Root.Console).m_szLastError,"R6Menu",True);
		if ( szTemp == "" )
		{
			szTemp=Localize("Errors",R6Console(Root.Console).m_szLastError,"R6Engine",True);
		}
		if ( szTemp == "" )
		{
			szTemp=R6Console(Root.Console).m_szLastError;
		}
//		r6Root.SimplePopUp(Localize("MultiPlayer","Popup_Error_Title","R6Menu"),szTemp,24,2,False,self);
		R6Console(Root.Console).m_szLastError="";
	}
	else
	{
//		r6Root.SimplePopUp(Localize("MultiPlayer","Popup_Error_Title","R6Menu"),Localize("MultiPlayer","Popup_ConnectionError","R6Menu"),24,2,False,self);
	}
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	R6WindowRootWindow(Root).m_RSimplePopUp=R6WindowRootWindow(Root).Default.m_RSimplePopUp;
	if ( Result == 3 )
	{
//		Root.ChangeCurrentWidget(37);
	}
}
