//================================================================================
// R6MenuMultiPlayerWidget.
//================================================================================
class R6MenuMultiPlayerWidget extends R6MenuWidget
	Config(User);

enum eJoinRoomChoice {
	EJRC_NO,
	EJRC_BY_LOBBY_AND_ROOM_ID
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

enum eLoginSuccessAction {
	eLSAct_None,
	eLSAct_JoinIP,
	eLSAct_Join,
	eLSAct_InternetTab,
	eLSAct_LaunchServer,
	eLSAct_CloseWindow,
	eLSAct_SwitchToInternetTab
};

enum eServerInfoID {
	eServerInfoID_DeathMatch,
	eServerInfoID_TeamDeathMatch,
	eServerInfoID_Bomb,
	eServerInfoID_HostageAdv,
	eServerInfoID_Escort,
	eServerInfoID_Mission,
	eServerInfoID_Terrorist,
	eServerInfoID_HostageCoop,
	eServerInfoID_Defend,
	eServerInfoID_Recon,
	eServerInfoID_Unlocked,
	eServerInfoID_Favorites,
	eServerInfoID_Dedicated,
	eServerInfoID_NotEmpty,
	eServerInfoID_NotFull,
	eServerInfoID_Responding,
	eServerInfoID_HasPlayer,
	eServerInfoID_SameVersion
};

enum MultiPlayerTabID {
	TAB_Lan_Server,
	TAB_Internet_Server,
	TAB_Game_Mode,
	TAB_Tech_Filter,
	TAB_Server_Info
};

var MultiPlayerTabID m_ConnectionTab;
var MultiPlayerTabID m_FilterTab;
var eLoginSuccessAction m_LoginSuccessAction;
var int m_FrameCounter;
var int m_iTimeLastUpdate;
var int m_iLastSortCategory;
var config int m_iLastTabSel;
var int m_iTotalPlayers;
var bool m_bListUpdateReq;
var bool m_bChangeMap;
var bool m_bLastTypeOfSort;
var bool m_bFPassWindowActv;
var bool m_bPreJoinInProgress;
var bool m_bJoinIPInProgress;
var bool m_bQueryServerInfoInProgress;
var bool m_bGetServerInfo;
var bool m_bLanRefreshFPass;
var bool m_bIntRefreshFPass;
var float m_fMouseX;
var float m_fMouseY;
var float m_fRefeshDeltaTime;
var R6WindowTextLabel m_LMenuTitle;
var R6WindowButton m_ButtonMainMenu;
var R6WindowButton m_ButtonOptions;
var R6WindowPageSwitch m_PageCount;
var R6WindowButtonMultiMenu m_ButtonLogInOut;
var R6WindowButtonMultiMenu m_ButtonJoin;
var R6WindowButtonMultiMenu m_ButtonJoinIP;
var R6WindowButtonMultiMenu m_ButtonRefresh;
var R6WindowButtonMultiMenu m_ButtonCreate;
var R6WindowTextLabelCurved m_FirstTabWindow;
var R6WindowTextLabelCurved m_SecondTabWindow;
var R6WindowTextLabelExt m_ServerDescription;
var R6MenuMPButServerList m_pButServerList;
var R6MenuMPManageTab m_pFirstTabManager;
var R6MenuMPManageTab m_pSecondTabManager;
var R6MenuMPMenuTab m_pSecondWindow;
var R6MenuMPMenuTab m_pSecondWindowGameMode;
var R6MenuMPMenuTab m_pSecondWindowFilter;
var R6MenuMPMenuTab m_pSecondWindowServerInfo;
var R6WindowSimpleFramedWindowExt m_pFirstWindowBorder;
var R6WindowSimpleFramedWindowExt m_pSecondWindowBorder;
var R6MenuHelpWindow m_pHelpTextWindow;
var R6WindowServerListBox m_ServerListBox;
var R6WindowServerInfoPlayerBox m_ServerInfoPlayerBox;
var R6WindowServerInfoMapBox m_ServerInfoMapBox;
var R6WindowServerInfoOptionsBox m_ServerInfoOptionsBox;
var R6GSServers m_GameService;
var R6LanServers m_LanServers;
var UWindowListBoxItem m_oldSelItem;
var R6WindowUbiLogIn m_pLoginWindow;
var R6WindowUbiCDKeyCheck m_pCDKeyCheckWindow;
var R6WindowJoinIP m_pJoinIPWindow;
var R6WindowQueryServerInfo m_pQueryServerInfo;
var R6WindowRightClickMenu m_pRightClickMenu;
var string m_szGamePwd;
var config string m_szPopUpIP;
var string m_szServerIP;
var string m_szMultiLoc[2];
const K_REFRESH_TIMEOUT= 2.0;
const K_LIST_UPDATE_TIME= 1000;
const C_fDIST_BETWEEN_BUTTON= 30;
const K_YPOS_HELPTEXT_WINDOW= 430;
const K_YPOS_SECOND_TABWINDOW= 296;
const K_YPOS_FIRST_TABWINDOW= 126;
const K_FSECOND_WINDOWHEIGHT= 90;
const K_FFIRST_WINDOWHEIGHT= 154;
const K_SEC_TABWINDOW_WIDTH= 600;
const K_FIRST_TABWINDOW_WIDTH= 500;
const K_XTABOFFSET= 5;
const K_WINDOWWIDTH_NOBORDER= 616;
const K_XSTARTPOS_NOBORDER= 12;
const K_WINDOWWIDTH= 620;
const K_XSTARTPOS= 10;

function Created ()
{
	m_GameService=R6Console(Root.Console).m_GameService;
	InitText();
	InitButton();
	m_FirstTabWindow=R6WindowTextLabelCurved(CreateWindow(Class'R6WindowTextLabelCurved',10.00,85.00,620.00,30.00,self));
	m_FirstTabWindow.bAlwaysBehind=True;
	m_FirstTabWindow.Text="";
	m_FirstTabWindow.m_BGTexture=None;
	m_pFirstTabManager=R6MenuMPManageTab(CreateWindow(Class'R6MenuMPManageTab',10.00 + 5,90.00,500.00,25.00,self));
	m_pFirstTabManager.AddTabInControl(Localize("MultiPlayer","Tab_InternetServer","R6Menu"),Localize("Tip","Tab_InternetServer","R6Menu"),1);
	m_pFirstTabManager.AddTabInControl(Localize("MultiPlayer","Tab_LanServer","R6Menu"),Localize("Tip","Tab_LanServer","R6Menu"),0);
	InitInfoBar();
	InitFirstTabWindow();
	InitServerInfoPlayer();
	InitServerInfoMap();
	InitServerInfoOptions();
	InitRightClickMenu();
	m_SecondTabWindow=R6WindowTextLabelCurved(CreateWindow(Class'R6WindowTextLabelCurved',10.00,296.00,620.00,30.00,self));
	m_SecondTabWindow.bAlwaysBehind=True;
	m_SecondTabWindow.Text="";
	m_SecondTabWindow.m_BGTexture=None;
	m_pSecondTabManager=R6MenuMPManageTab(CreateWindow(Class'R6MenuMPManageTab',10.00 + 5,296.00 + 5,600.00,25.00,self));
	m_pSecondTabManager.AddTabInControl(Localize("MultiPlayer","Tab_GameFilter","R6Menu"),Localize("Tip","Tab_GameFilter","R6Menu"),2);
	m_pSecondTabManager.AddTabInControl(Localize("MultiPlayer","Tab_TechFilter","R6Menu"),Localize("Tip","Tab_TechFilter","R6Menu"),3);
	m_pSecondTabManager.AddTabInControl(Localize("MultiPlayer","Tab_ServerInfo","R6Menu"),Localize("Tip","Tab_ServerInfo","R6Menu"),4);
	m_pHelpTextWindow=R6MenuHelpWindow(CreateWindow(Class'R6MenuHelpWindow',150.00,429.00,340.00,42.00,self));
	m_pHelpTextWindow.m_bForceRefreshOnSameTip=True;
	m_pLoginWindow=R6WindowUbiLogIn(CreateWindow(Root.MenuClassDefines.ClassUbiLogIn,0.00,0.00,640.00,480.00,self,True));
	m_pLoginWindow.m_GameService=m_GameService;
	m_pLoginWindow.PopUpBoxCreate();
	m_pLoginWindow.HideWindow();
	m_pCDKeyCheckWindow=R6WindowUbiCDKeyCheck(CreateWindow(Root.MenuClassDefines.ClassUbiCDKeyCheck,0.00,0.00,640.00,480.00,self,True));
	m_pCDKeyCheckWindow.m_GameService=m_GameService;
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
	m_bFPassWindowActv=True;
	if ( m_GameService.m_bLoggedInUbiDotCom )
	{
//		m_ButtonLogInOut.SetButLogInOutState(30);
	}
	else
	{
//		m_ButtonLogInOut.SetButLogInOutState(29);
	}
	m_fRefeshDeltaTime=2.00;
	m_GameService.m_bRefreshInProgress=False;
	m_GameService.m_bIndRefrInProgress=False;
	m_szMultiLoc[0]=Localize("MultiPlayer","NbOfServers","R6Menu");
	m_szMultiLoc[1]=Localize("MultiPlayer","NbOfPlayers","R6Menu");
	m_PageCount=R6WindowPageSwitch(CreateWindow(Class'R6WindowPageSwitch',530.00,90.00,90.00,25.00,self));
	Class'Actor'.static.GetModMgr().RegisterObject(self);
}

function InitMod ()
{
	if ( m_LanServers != None )
	{
		UpdateServerFilters();
	}
}

function Paint (Canvas C, float X, float Y)
{
	local R6WindowTextLabel pR6TextLabelTemp;

	Root.PaintBackground(C,self);
	m_fMouseX=X;
	m_fMouseY=Y;
	if ( m_ConnectionTab == 0 )
	{
		m_LanServers.LANSeversManager();
	}
	if ( (m_LanServers.m_bServerListChanged || m_GameService.m_bServerListChanged) && (m_GameService.NativeGetMilliSeconds() - m_iTimeLastUpdate > 1000) )
	{
		m_iTimeLastUpdate=m_GameService.NativeGetMilliSeconds();
		m_GameService.m_bServerListChanged=False;
		m_LanServers.m_bServerListChanged=False;
		if ( m_ConnectionTab == 0 )
		{
			ResortServerList(m_iLastSortCategory,m_bLastTypeOfSort);
			m_LanServers.UpdateFilters();
			GetLanServers();
		}
		else
		{
			m_GameService.UpdateFilters();
			GetGSServers();
		}
	}
	if ( m_ConnectionTab == 1 )
	{
		if ( m_GameService.m_bRefreshFinished )
		{
			m_GameService.m_bRefreshFinished=False;
			ResortServerList(m_iLastSortCategory,m_bLastTypeOfSort);
			GetGSServers();
			m_bGetServerInfo=True;
		}
		if ( m_GameService.m_bRefreshInProgress || m_GameService.m_bIndRefrInProgress )
		{
			SetCursor(Root.WaitCursor);
		}
		else
		{
			SetCursor(Root.NormalCursor);
		}
	}
	else
	{
		SetCursor(Root.NormalCursor);
	}
	if ( m_ServerListBox.m_SelectedItem != m_oldSelItem )
	{
		m_oldSelItem=m_ServerListBox.m_SelectedItem;
		if ( m_ConnectionTab == 0 )
		{
			if ( m_ServerListBox.m_SelectedItem != None )
			{
				m_LanServers.SetSelectedServer(R6WindowListServerItem(m_ServerListBox.m_SelectedItem).iMainSvrListIdx);
			}
			GetServerInfo(m_LanServers);
		}
		else
		{
			if ( m_ServerListBox.m_SelectedItem != None )
			{
				m_GameService.SetSelectedServer(R6WindowListServerItem(m_ServerListBox.m_SelectedItem).iMainSvrListIdx);
			}
			m_bGetServerInfo=True;
		}
	}
	if ( m_bGetServerInfo &&  !m_GameService.m_bRefreshInProgress && (m_ConnectionTab == 1) && (m_FilterTab == 4) )
	{
		if ( m_GameService.m_GameServerList.Length > 0 )
		{
			m_GameService.NativeMSClientReqAltInfo(m_GameService.m_GameServerList[m_GameService.m_iSelSrvIndex].iLobbySrvID,m_GameService.m_GameServerList[m_GameService.m_iSelSrvIndex].iGroupID);
		}
		ClearServerInfo();
		m_bGetServerInfo=False;
	}
	if ( m_GameService.m_bServerInfoChanged && (m_ConnectionTab == 1) )
	{
		GetServerInfo(m_GameService);
		m_GameService.m_bServerInfoChanged=False;
	}
	if ( m_GameService.m_bMSClientRouterDisconnect )
	{
		if ( m_GameService.m_bRefreshInProgress )
		{
			m_GameService.m_bMSRequestFinished=True;
		}
		m_GameService.UnInitializeMSClient();
		m_GameService.m_bMSClientRouterDisconnect=False;
//		m_LoginSuccessAction=5;
		m_pLoginWindow.LogInAfterDisconnect(self);
	}
	if ( m_LoginSuccessAction != 0 )
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
	if ( m_ServerListBox.m_SelectedItem == None )
	{
		m_ButtonJoin.bDisabled=True;
	}
	else
	{
		if (  !R6WindowListServerItem(m_ServerListBox.m_SelectedItem).bSameVersion )
		{
			m_ButtonJoin.bDisabled=True;
		}
		else
		{
			m_ButtonJoin.bDisabled=False;
		}
	}
}

function ShowWindow ()
{
	local string _szIpAddress;

	if ( m_LanServers == None )
	{
		m_LanServers=new Class<R6LanServers>(Root.MenuClassDefines.ClassLanServer);
		R6Console(Root.Console).m_LanServers=m_LanServers;
		m_LanServers.Created();
		InitServerList();
		InitSecondTabWindow();
	}
	if ( m_LanServers.m_ClientBeacon == None )
	{
		m_LanServers.m_ClientBeacon=Root.Console.ViewportOwner.Actor.Spawn(Class'ClientBeaconReceiver');
	}
	m_GameService.m_ClientBeacon=m_LanServers.m_ClientBeacon;
//	m_iLastSortCategory=m_LanServers.4;
	m_bLastTypeOfSort=True;
	Super.ShowWindow();
	R6Console(Root.Console).m_GameService.initGSCDKey();
	Root.SetLoadRandomBackgroundImage("Multiplayer");
	if ( R6Console(Root.Console).m_bNonUbiMatchMaking )
	{
		Class'Actor'.static.NativeNonUbiMatchMakingAddress(_szIpAddress);
		m_pJoinIPWindow.StartCmdLineJoinIPProcedure(m_ButtonJoinIP,_szIpAddress);
		m_bJoinIPInProgress=True;
	}
}

function ToolTip (string strTip)
{
	ManageToolTip(strTip);
}

function ManageToolTip (string _strTip, optional bool _bForceATip)
{
	local string szTemp1;
	local string szTemp2;
	local int iNbOfServers;

	if ( (m_pHelpTextWindow == None) ||  !bWindowVisible )
	{
		return;
	}
	szTemp1=_strTip;
	szTemp2="";
	if ( _bForceATip )
	{
		if ( m_ConnectionTab == 1 )
		{
			m_iTotalPlayers=m_GameService.GetTotalPlayers();
		}
		else
		{
			m_iTotalPlayers=m_LanServers.GetTotalPlayers();
		}
	}
	if ( _strTip == "" )
	{
		if ( m_ConnectionTab == 1 )
		{
			iNbOfServers=m_GameService.m_GameServerList.Length;
		}
		else
		{
			iNbOfServers=m_LanServers.m_GameServerList.Length;
		}
		szTemp1=m_szMultiLoc[0] $ " " $ string(iNbOfServers);
		szTemp2=m_szMultiLoc[1] $ " " $ string(m_iTotalPlayers);
	}
	m_pHelpTextWindow.ToolTip(szTemp1);
	if ( szTemp2 != "" )
	{
		m_pHelpTextWindow.AddTipText(szTemp2);
	}
}

function ManageTabSelection (int _MPTabChoiceID)
{
	switch (_MPTabChoiceID)
	{
/*		case 0:
		m_ConnectionTab=0;
		if ( m_LanServers.m_GameServerList.Length == 0 )
		{
			Refresh(False);
		}
		GetLanServers();
		GetServerInfo(m_LanServers);
		UpdateServerFilters();
		m_iLastTabSel=0;
		SaveConfig();
		break;
		case 1:
		m_ConnectionTab=1;
		m_LoginSuccessAction=3;
		m_pLoginWindow.StartLogInProcedure(self);
		if ( m_GameService.m_GameServerList.Length == 0 )
		{
			Refresh(False);
		}
		GetGSServers();
		UpdateServerFilters();
		m_iLastTabSel=1;
		SaveConfig();
		break;
		case 2:
		m_FilterTab=2;
		m_ServerInfoPlayerBox.HideWindow();
		m_ServerInfoMapBox.HideWindow();
		m_ServerInfoOptionsBox.HideWindow();
		m_pSecondWindow.HideWindow();
		m_pSecondWindowGameMode.ShowWindow();
		m_pSecondWindow=m_pSecondWindowGameMode;
		break;
		case 3:
		m_FilterTab=3;
		m_ServerInfoPlayerBox.HideWindow();
		m_ServerInfoMapBox.HideWindow();
		m_ServerInfoOptionsBox.HideWindow();
		m_pSecondWindow.HideWindow();
		m_pSecondWindowFilter.ShowWindow();
		m_pSecondWindow=m_pSecondWindowFilter;
		break;
		case 4:
		m_FilterTab=4;
		m_pSecondWindow.HideWindow();
		m_pSecondWindowServerInfo.ShowWindow();
		m_ServerInfoPlayerBox.ShowWindow();
		m_ServerInfoMapBox.ShowWindow();
		m_ServerInfoOptionsBox.ShowWindow();
		m_pSecondWindow=m_pSecondWindowServerInfo;
		break;
		default:
		Log("This tab was not supported (R6MenuMultiPlayerWidget)");
		break;  */
	}
}

function SetServerFilterBooleans (int _iServerInfoID, bool _bNewChoice)
{
	switch (_iServerInfoID)
	{
		case 0:
		m_LanServers.m_Filters.bDeathMatch=_bNewChoice;
		m_GameService.m_Filters.bDeathMatch=_bNewChoice;
		break;
		case 1:
		m_LanServers.m_Filters.bTeamDeathMatch=_bNewChoice;
		m_GameService.m_Filters.bTeamDeathMatch=_bNewChoice;
		break;
		case 2:
		m_LanServers.m_Filters.bDisarmBomb=_bNewChoice;
		m_GameService.m_Filters.bDisarmBomb=_bNewChoice;
		break;
		case 3:
		m_LanServers.m_Filters.bHostageRescueAdv=_bNewChoice;
		m_GameService.m_Filters.bHostageRescueAdv=_bNewChoice;
		break;
		case 4:
		m_LanServers.m_Filters.bEscortPilot=_bNewChoice;
		m_GameService.m_Filters.bEscortPilot=_bNewChoice;
		break;
		case 5:
		m_LanServers.m_Filters.bMission=_bNewChoice;
		m_GameService.m_Filters.bMission=_bNewChoice;
		break;
		case 6:
		m_LanServers.m_Filters.bTerroristHunt=_bNewChoice;
		m_GameService.m_Filters.bTerroristHunt=_bNewChoice;
		break;
		case 7:
		m_LanServers.m_Filters.bHostageRescueCoop=_bNewChoice;
		m_GameService.m_Filters.bHostageRescueCoop=_bNewChoice;
		break;
		case 8:
		m_LanServers.m_Filters.bDefend=_bNewChoice;
		m_GameService.m_Filters.bDefend=_bNewChoice;
		break;
		case 9:
		m_LanServers.m_Filters.bRecon=_bNewChoice;
		m_GameService.m_Filters.bRecon=_bNewChoice;
		break;
		case 10:
		m_LanServers.m_Filters.bUnlockedOnly=_bNewChoice;
		m_GameService.m_Filters.bUnlockedOnly=_bNewChoice;
		break;
		case 11:
		m_LanServers.m_Filters.bFavoritesOnly=_bNewChoice;
		m_GameService.m_Filters.bFavoritesOnly=_bNewChoice;
		break;
		case 12:
		m_LanServers.m_Filters.bDedicatedServersOnly=_bNewChoice;
		m_GameService.m_Filters.bDedicatedServersOnly=_bNewChoice;
		break;
		case 13:
		m_LanServers.m_Filters.bServersNotEmpty=_bNewChoice;
		m_GameService.m_Filters.bServersNotEmpty=_bNewChoice;
		break;
		case 14:
		m_LanServers.m_Filters.bServersNotFull=_bNewChoice;
		m_GameService.m_Filters.bServersNotFull=_bNewChoice;
		break;
		case 15:
		m_LanServers.m_Filters.bResponding=_bNewChoice;
		m_GameService.m_Filters.bResponding=_bNewChoice;
		break;
		case 17:
		m_LanServers.m_Filters.bSameVersion=_bNewChoice;
		m_GameService.m_Filters.bSameVersion=_bNewChoice;
		break;
		default:
		Log("Sorry, no server info associate with this button");
		break;
	}
	UpdateServerFilters();
}

function SetServerFilterHasPlayer (string szPlayerName, bool _bActive)
{
	if ( _bActive )
	{
		m_LanServers.m_Filters.szHasPlayer=szPlayerName;
		m_GameService.m_Filters.szHasPlayer=szPlayerName;
	}
	else
	{
		m_LanServers.m_Filters.szHasPlayer="";
		m_GameService.m_Filters.szHasPlayer="";
	}
	UpdateServerFilters();
}

function SetServerFilterFasterThan (int iFasterThan)
{
	m_LanServers.m_Filters.iFasterThan=iFasterThan;
	m_GameService.m_Filters.iFasterThan=iFasterThan;
	UpdateServerFilters();
}

function UpdateServerFilters ()
{
	m_pSecondWindowGameMode.UpdateGameTypeFilter();
	m_pSecondWindowFilter.UpdateGameTypeFilter();
	if ( m_ConnectionTab == 0 )
	{
		m_LanServers.UpdateFilters();
		m_LanServers.SaveConfig();
		m_GameService.SaveConfig();
		GetLanServers();
	}
	else
	{
		m_GameService.UpdateFilters();
		m_LanServers.SaveConfig();
		m_GameService.SaveConfig();
		GetGSServers();
	}
}

function Refresh (bool bActivatedByUser)
{
	local int i;

	if ( bActivatedByUser )
	{
		if ( m_fRefeshDeltaTime > 2.00 )
		{
			m_fRefeshDeltaTime=0.00;
		}
		else
		{
			return;
		}
	}
	m_oldSelItem=None;
	if ( m_ConnectionTab == 0 )
	{
		m_LanServers.RefreshServers();
		ResortServerList(m_iLastSortCategory,m_bLastTypeOfSort);
		GetLanServers();
		i=0;
JL006C:
		if ( i < m_LanServers.m_ClientBeacon.GetBeaconListSize() )
		{
			m_LanServers.m_ClientBeacon.ClearBeacon(i);
			i++;
			goto JL006C;
		}
	}
	else
	{
		if ( m_GameService.m_bLoggedInUbiDotCom )
		{
			m_GameService.RefreshServers();
		}
	}
}

function GetLanServers ()
{
	local R6WindowListServerItem NewItem;
	local int i;
	local int j;
	local int iNumServers;
	local int iNumServersDisplay;
	local string szSelSvrIP;
	local bool bFirstSvr;
	local ER6GameType eGameType;
	local LevelInfo pLevel;
	local R6Console Console;
	local int iNbPages;
	local int iStartingIndex;
	local int iEndIndex;
	local stGameServer _stGameServer;

	Console=R6Console(Root.Console);
	pLevel=GetLevel();
	if ( m_ServerListBox.m_SelectedItem != None )
	{
		szSelSvrIP=R6WindowListServerItem(m_ServerListBox.m_SelectedItem).szIPAddr;
	}
	else
	{
		szSelSvrIP="";
	}
	m_ServerListBox.ClearListOfItems();
	m_ServerListBox.m_SelectedItem=None;
	iNumServers=m_LanServers.m_GameServerList.Length;
	iNumServersDisplay=m_LanServers.GetDisplayListSize();
	bFirstSvr=True;
	iNbPages=iNumServersDisplay / Console.iBrowserMaxNbServerPerPage;
	iNbPages += 1;
	if ( m_PageCount.m_iCurrentPages > iNbPages )
	{
		m_PageCount.SetCurrentPage(iNbPages);
	}
	if ( iNbPages != m_PageCount.m_iTotalPages )
	{
		m_PageCount.SetTotalPages(iNbPages);
	}
	iStartingIndex=Console.iBrowserMaxNbServerPerPage * (m_PageCount.m_iCurrentPages - 1);
	iEndIndex=iStartingIndex + Console.iBrowserMaxNbServerPerPage;
	if ( iEndIndex > iNumServersDisplay )
	{
		iEndIndex=iNumServersDisplay;
	}
	j=0;
	i=iStartingIndex;
JL019D:
	if ( iNumServersDisplay > 0 )
	{
		if ( m_LanServers.m_GameServerList[m_LanServers.m_GSLSortIdx[i]].bDisplay )
		{
			NewItem=R6WindowListServerItem(m_ServerListBox.GetItemAtIndex(j));
			NewItem.Created();
			NewItem.iMainSvrListIdx=i;
//			m_LanServers.getServerListItem(i,_stGameServer);
			NewItem.bFavorite=_stGameServer.bFavorite;
			NewItem.bSameVersion=_stGameServer.bSameVersion;
			NewItem.szIPAddr=_stGameServer.szIPAddress;
			NewItem.iPing=_stGameServer.iPing;
			NewItem.szName=_stGameServer.sGameData.szName;
			NewItem.szMap=_stGameServer.sGameData.szCurrentMap;
			NewItem.iMaxPlayers=_stGameServer.sGameData.iMaxPlayer;
			NewItem.iNumPlayers=_stGameServer.sGameData.iNbrPlayer;
			eGameType=_stGameServer.sGameData.eGameType;
			NewItem.bLocked=_stGameServer.sGameData.bUsePassword;
			NewItem.bDedicated=_stGameServer.sGameData.bDedicatedServer;
			Root.GetMapNameLocalisation(NewItem.szMap,NewItem.szMap,True);
//			NewItem.szGameType=pLevel.GetGameNameLocalization(eGameType);
/*			if ( pLevel.IsGameTypeAdversarial(eGameType) )
			{
				NewItem.szGameMode=Localize("MultiPlayer","GameMode_Adversarial","R6Menu");
			}
			else
			{
				if ( pLevel.IsGameTypeCooperative(eGameType) )
				{
					NewItem.szGameMode=Localize("MultiPlayer","GameMode_Cooperative","R6Menu");
				}
				else
				{
					NewItem.szGameMode="";
				}
			}*/
			if ( (NewItem.szIPAddr == szSelSvrIP) || bFirstSvr )
			{
				m_ServerListBox.SetSelectedItem(NewItem);
				m_LanServers.SetSelectedServer(i);
			}
			bFirstSvr=False;
			j++;
		}
		i++;
		if ( iStartingIndex + j >= iEndIndex )
		{
			goto JL0507;
		}
		if ( i >= iNumServers )
		{
			goto JL0507;
		}
		goto JL019D;
	}
JL0507:
	ManageToolTip("",True);
}

function GetGSServers ()
{
	local R6WindowListServerItem NewItem;
	local int i;
	local int j;
	local int iNumServers;
	local int iNumServersDisplay;
	local string szSelSvrIP;
	local bool bFirstSvr;
	local ER6GameType eGameType;
	local LevelInfo pLevel;
	local R6Console Console;
	local int iNbPages;
	local int iStartingIndex;
	local int iEndIndex;
	local stGameServer _stGameServer;

	Console=R6Console(Root.Console);
	pLevel=GetLevel();
	if ( m_ServerListBox.m_SelectedItem != None )
	{
		szSelSvrIP=R6WindowListServerItem(m_ServerListBox.m_SelectedItem).szIPAddr;
	}
	else
	{
		szSelSvrIP="";
	}
	m_ServerListBox.ClearListOfItems();
	m_ServerListBox.m_SelectedItem=None;
	iNumServers=m_GameService.m_GameServerList.Length;
	iNumServersDisplay=m_GameService.GetDisplayListSize();
	bFirstSvr=True;
	iNbPages=iNumServersDisplay / Console.iBrowserMaxNbServerPerPage;
	iNbPages += 1;
	if ( m_PageCount.m_iCurrentPages > iNbPages )
	{
		m_PageCount.SetCurrentPage(iNbPages);
	}
	if ( iNbPages != m_PageCount.m_iTotalPages )
	{
		m_PageCount.SetTotalPages(iNbPages);
	}
	iStartingIndex=Console.iBrowserMaxNbServerPerPage * (m_PageCount.m_iCurrentPages - 1);
	iEndIndex=iStartingIndex + Console.iBrowserMaxNbServerPerPage;
	if ( iEndIndex > iNumServersDisplay )
	{
		iEndIndex=iNumServersDisplay;
	}
	j=0;
	i=iStartingIndex;
JL019D:
	if ( iNumServersDisplay > 0 )
	{
		if ( m_GameService.m_GameServerList[m_GameService.m_GSLSortIdx[i]].bDisplay )
		{
			NewItem=R6WindowListServerItem(m_ServerListBox.GetItemAtIndex(j));
			NewItem.Created();
			NewItem.iMainSvrListIdx=i;
//			m_GameService.getServerListItem(i,_stGameServer);
			NewItem.bFavorite=_stGameServer.bFavorite;
			NewItem.bSameVersion=_stGameServer.bSameVersion;
			NewItem.szIPAddr=_stGameServer.szIPAddress;
			NewItem.iPing=_stGameServer.iPing;
			NewItem.szName=_stGameServer.sGameData.szName;
			NewItem.szMap=_stGameServer.sGameData.szCurrentMap;
			NewItem.iMaxPlayers=_stGameServer.sGameData.iMaxPlayer;
			NewItem.iNumPlayers=_stGameServer.sGameData.iNbrPlayer;
			eGameType=_stGameServer.sGameData.eGameType;
			NewItem.bLocked=_stGameServer.sGameData.bUsePassword;
			NewItem.bDedicated=_stGameServer.sGameData.bDedicatedServer;
			Root.GetMapNameLocalisation(NewItem.szMap,NewItem.szMap,True);
//			NewItem.szGameType=pLevel.GetGameNameLocalization(eGameType);
/*			if ( pLevel.IsGameTypeAdversarial(eGameType) )
			{
				NewItem.szGameMode=Localize("MultiPlayer","GameMode_Adversarial","R6Menu");
			}
			else
			{
				if ( pLevel.IsGameTypeCooperative(eGameType) )
				{
					NewItem.szGameMode=Localize("MultiPlayer","GameMode_Cooperative","R6Menu");
				}
			}  */
			if ( (NewItem.szIPAddr == szSelSvrIP) || bFirstSvr )
			{
				m_ServerListBox.SetSelectedItem(NewItem);
				m_GameService.SetSelectedServer(i);
			}
			bFirstSvr=False;
			j++;
		}
		i++;
		if ( iStartingIndex + j >= iEndIndex )
		{
			goto JL04F3;
		}
		if ( i >= iNumServers )
		{
			goto JL04F3;
		}
		goto JL019D;
	}
JL04F3:
	ManageToolTip("",True);
}

function GetServerInfo (R6ServerList pServerList)
{
	local R6WindowListInfoPlayerItem NewItemPlayer;
	local R6WindowListInfoMapItem NewItemMap;
	local R6WindowListInfoOptionsItem NewItemOptions;
	local R6MenuButtonsDefines pButtonsDef;
	local int i;
	local int iNum;

	ClearServerInfo();
	if ( pServerList.m_GameServerList.Length == 0 )
	{
		return;
	}
	iNum=pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.gameMapList.Length;
	i=0;
JL0052:
	if ( i < iNum )
	{
		NewItemMap=R6WindowListInfoMapItem(m_ServerInfoMapBox.GetItemAtIndex(i));
		NewItemMap.szMap=pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.gameMapList[i].szMap;
		Root.GetMapNameLocalisation(NewItemMap.szMap,NewItemMap.szMap,True);
//		NewItemMap.szType=GetLevel().GetGameNameLocalization(pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.gameMapList[i].eGameType);
		i++;
		goto JL0052;
	}
	iNum=pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.PlayerList.Length;
	pServerList.SortPlayersByKills(False,pServerList.m_iSelSrvIndex);
	i=0;
JL019B:
	if ( i < iNum )
	{
		NewItemPlayer=R6WindowListInfoPlayerItem(m_ServerInfoPlayerBox.GetItemAtIndex(i));
		NewItemPlayer.szPlName=pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.PlayerList[i].szAlias;
		NewItemPlayer.iSkills=pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.PlayerList[i].iSkills;
		NewItemPlayer.szTime=pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.PlayerList[i].szTime;
		NewItemPlayer.iPing=pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.PlayerList[i].iPing;
		NewItemPlayer.iRank=0;
		i++;
		goto JL019B;
	}
	pButtonsDef=R6MenuButtonsDefines(GetButtonsDefinesUnique(Root.MenuClassDefines.ClassButtonsDefines));
	i=0;
	NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
	NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(1) $ " = " $ string(pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.iRoundsPerMatch);
	NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
	NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(2) $ " = " $ Class'Actor'.static.ConvertIntTimeToString(pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.iRoundTime);
	NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
	NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(7) $ " = " $ string(pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.iBetTime);
	if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bAdversarial )
	{
		NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
		NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(4) $ " = " $ string(pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.iBombTime);
	}
	else
	{
		NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
		NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(8) $ " = " $ string(pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.iNumTerro);
		if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bAIBkp )
		{
			NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
			NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(17);
		}
		if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bRotateMap )
		{
			NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
			NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(16);
		}
	}
	if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bShowNames )
	{
		NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
		NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(12);
	}
	if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bFriendlyFire )
	{
		NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
		NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(11);
	}
	if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bAutoBalTeam )
	{
		NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
		NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(13);
	}
	if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bTKPenalty )
	{
		NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
		NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(14);
	}
	if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bRadar )
	{
		NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
		NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(15);
	}
	if ( pServerList.m_GameServerList[pServerList.m_iSelSrvIndex].sGameData.bForceFPWeapon )
	{
		NewItemOptions=R6WindowListInfoOptionsItem(m_ServerInfoOptionsBox.GetItemAtIndex(i++ ));
		NewItemOptions.szOptions=pButtonsDef.GetButtonLoc(18);
	}
}

function ClearServerInfo ()
{
	m_ServerInfoPlayerBox.ClearListOfItems();
	m_ServerInfoMapBox.ClearListOfItems();
	m_ServerInfoOptionsBox.ClearListOfItems();
}

function QuickJoin ()
{
}

function JoinSelectedServerRequested ()
{
	local int iBeaconPort;

	if ( m_ServerListBox.m_SelectedItem == None )
	{
		return;
	}
	if ( R6WindowListServerItem(m_ServerListBox.m_SelectedItem).bSameVersion )
	{
		if ( m_ConnectionTab == 1 )
		{
			m_szServerIP=m_GameService.GetSelectedServerIP();
			iBeaconPort=m_GameService.m_GameServerList[m_GameService.m_iSelSrvIndex].iBeaconPort;
		}
		else
		{
			m_szServerIP=m_LanServers.m_GameServerList[m_LanServers.m_iSelSrvIndex].szIPAddress;
			iBeaconPort=m_LanServers.m_GameServerList[m_LanServers.m_iSelSrvIndex].iBeaconPort;
		}
		m_pQueryServerInfo.StartQueryServerInfoProcedure(OwnerWindow,m_szServerIP,iBeaconPort);
		m_bQueryServerInfoInProgress=True;
	}
}

function QueryReceivedStartPreJoin ()
{
	local eJoinRoomChoice eJoinRoom;
	local bool bRoomValid;

	bRoomValid=(m_GameService.m_ClientBeacon.PreJoinInfo.iLobbyID != 0) && (m_GameService.m_ClientBeacon.PreJoinInfo.iGroupID != 0);
	if ( (m_ConnectionTab == 1) &&  !bRoomValid )
	{
//		R6MenuRootWindow(Root).SimplePopUp(Localize("MultiPlayer","PopUp_Error_RoomJoin","R6Menu"),Localize("MultiPlayer","PopUp_Error_NoServer","R6Menu"),30,2);
		Refresh(False);
		return;
	}
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

function Tick (float DeltaTime)
{
	if ( R6Console(Root.Console).m_bAutoLoginFirstPass )
	{
		R6Console(Root.Console).m_bAutoLoginFirstPass=False;
		if (  !R6Console(Root.Console).m_bStartedByGSClient )
		{
			m_GameService.StartAutoLogin();
		}
	}
	if ( m_bFPassWindowActv )
	{
		if ( m_iLastTabSel == 1 )
		{
			m_pFirstTabManager.m_pMainTabControl.GotoTab(m_pFirstTabManager.m_pMainTabControl.GetTab(Localize("MultiPlayer","Tab_InternetServer","R6Menu")));
		}
		else
		{
			m_pFirstTabManager.m_pMainTabControl.GotoTab(m_pFirstTabManager.m_pMainTabControl.GetTab(Localize("MultiPlayer","Tab_LanServer","R6Menu")));
		}
		m_bFPassWindowActv=False;
	}
	m_fRefeshDeltaTime += DeltaTime;
	if ( m_GameService.m_bLoggedInUbiDotCom )
	{
		if ( m_ButtonLogInOut.m_eButton_Action != 30 )
		{
//			m_ButtonLogInOut.SetButLogInOutState(30);
		}
	}
	else
	{
		if ( m_ButtonLogInOut.m_eButton_Action != 29 )
		{
//			m_ButtonLogInOut.SetButLogInOutState(29);
		}
	}
	if ( m_GameService.m_bAutoLoginFailed )
	{
		m_GameService.m_bAutoLoginFailed=False;
		if ( m_ConnectionTab == 1 )
		{
			ManageTabSelection(1);
		}
	}
	if ( m_bLanRefreshFPass )
	{
		if ( m_ConnectionTab == 0 )
		{
			Refresh(False);
			m_bLanRefreshFPass=False;
		}
	}
	if ( m_bIntRefreshFPass )
	{
		if ( (m_ConnectionTab == 1) && m_GameService.m_bLoggedInUbiDotCom )
		{
			Refresh(False);
			m_bIntRefreshFPass=False;
		}
	}
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
	if ( m_szGamePwd != "" )
	{
		szOptions=szOptions $ "?Password=" $ m_szGamePwd;
	}
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
	R6Console(Root.Console).szStoreGamePassWd=m_szGamePwd;
	R6MenuRootWindow(Root).m_bJoinServerProcess=True;
}

function AddServerToFavorites ()
{
	if ( m_ConnectionTab == 0 )
	{
		m_LanServers.AddToFavorites(R6WindowListServerItem(m_ServerListBox.m_SelectedItem).iMainSvrListIdx);
	}
	else
	{
		m_GameService.AddToFavorites(R6WindowListServerItem(m_ServerListBox.m_SelectedItem).iMainSvrListIdx);
	}
}

function DelServerFromFavorites ()
{
	if ( m_ConnectionTab == 0 )
	{
		m_LanServers.DelFromFavorites(R6WindowListServerItem(m_ServerListBox.m_SelectedItem).iMainSvrListIdx);
	}
	else
	{
		m_GameService.DelFromFavorites(R6WindowListServerItem(m_ServerListBox.m_SelectedItem).iMainSvrListIdx);
	}
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
}

function DisplayRightClickMenu ()
{
	m_pRightClickMenu.DisplayMenuHere(m_fMouseX,m_fMouseY);
}

function UpdateFavorites ()
{
	if ( m_pRightClickMenu.GetValue() == Localize("MultiPlayer","RightClick_AddFav","R6Menu") )
	{
		AddServerToFavorites();
	}
	else
	{
		if ( m_pRightClickMenu.GetValue() == Localize("MultiPlayer","RightClick_SubFav","R6Menu") )
		{
			DelServerFromFavorites();
		}
		else
		{
			if ( m_pRightClickMenu.GetValue() == Localize("MultiPlayer","RightClick_Refr","R6Menu") )
			{
				if ( m_ConnectionTab == 0 )
				{
					m_LanServers.RefreshOneServer(R6WindowListServerItem(m_ServerListBox.m_SelectedItem).iMainSvrListIdx);
				}
				else
				{
					m_GameService.RefreshOneServer(R6WindowListServerItem(m_ServerListBox.m_SelectedItem).iMainSvrListIdx);
				}
			}
		}
	}
	if ( m_ConnectionTab == 0 )
	{
		m_LanServers.UpdateFilters();
		GetLanServers();
	}
	else
	{
		m_GameService.UpdateFilters();
		GetGSServers();
	}
}

function ResortServerList (int iCategory, bool _bAscending)
{
	m_iLastSortCategory=iCategory;
	m_bLastTypeOfSort=_bAscending;
	m_GameService.SortServers(iCategory,_bAscending);
	m_LanServers.SortServers(iCategory,_bAscending);
	if ( m_ConnectionTab == 0 )
	{
		GetLanServers();
	}
	else
	{
		GetGSServers();
	}
}

function InitText ()
{
	m_LMenuTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,18.00,WinWidth - 8,25.00,self));
	m_LMenuTitle.Text=Localize("MultiPlayer","Title","R6Menu");
	m_LMenuTitle.align=ta_right;
	m_LMenuTitle.m_Font=Root.Fonts[4];
	m_LMenuTitle.TextColor=Root.Colors.White;
	m_LMenuTitle.m_BGTexture=None;
	m_LMenuTitle.m_HBorderTexture=None;
	m_LMenuTitle.m_VBorderTexture=None;
}

function InitButton ()
{
	local Font ButtonFont;
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local R6MenuButtonsDefines pButtonsDef;

	m_ButtonMainMenu=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,425.00,250.00,25.00,self));
	m_ButtonMainMenu.ToolTipString=Localize("Tip","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.Text=Localize("SinglePlayer","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.align=ta_left;
	m_ButtonMainMenu.m_fFontSpacing=0.00;
	m_ButtonMainMenu.m_buttonFont=Root.Fonts[15];
	m_ButtonMainMenu.ResizeToText();
	m_ButtonOptions=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,447.00,250.00,25.00,self));
	m_ButtonOptions.ToolTipString=Localize("Tip","ButtonOptions","R6Menu");
	m_ButtonOptions.Text=Localize("SinglePlayer","ButtonOptions","R6Menu");
	m_ButtonOptions.align=ta_left;
	m_ButtonOptions.m_fFontSpacing=0.00;
	m_ButtonOptions.m_buttonFont=Root.Fonts[15];
	ButtonFont=Root.Fonts[16];
	pButtonsDef=R6MenuButtonsDefines(GetButtonsDefinesUnique(Root.MenuClassDefines.ClassButtonsDefines));
	fXOffset=10.00;
	fYOffset=50.00;
	fWidth=124.00;
	m_ButtonLogInOut=R6WindowButtonMultiMenu(CreateWindow(Class'R6WindowButtonMultiMenu',fXOffset,fYOffset,400.00,25.00,self));
	m_ButtonLogInOut.ToolTipString=pButtonsDef.GetButtonLoc(29,True);
	m_ButtonLogInOut.Text=pButtonsDef.GetButtonLoc(29);
//	m_ButtonLogInOut.m_eButton_Action=29;
	m_ButtonLogInOut.align=ta_left;
	m_ButtonLogInOut.m_fFontSpacing=0.00;
	m_ButtonLogInOut.m_buttonFont=ButtonFont;
	m_ButtonLogInOut.ResizeToText();
	fXOffset += fWidth;
	m_ButtonJoin=R6WindowButtonMultiMenu(CreateWindow(Class'R6WindowButtonMultiMenu',fXOffset,fYOffset,400.00,25.00,self));
	m_ButtonJoin.ToolTipString=pButtonsDef.GetButtonLoc(31,True);
	m_ButtonJoin.Text=pButtonsDef.GetButtonLoc(31);
//	m_ButtonJoin.m_eButton_Action=31;
	m_ButtonJoin.align=ta_left;
	m_ButtonJoin.m_fFontSpacing=0.00;
	m_ButtonJoin.m_buttonFont=ButtonFont;
	m_ButtonJoin.ResizeToText();
	m_ButtonJoin.m_pPreviousButtonPos=m_ButtonLogInOut;
	m_ButtonJoin.m_pRefButtonPos=m_ButtonLogInOut;
	fXOffset += fWidth;
	m_ButtonJoinIP=R6WindowButtonMultiMenu(CreateWindow(Class'R6WindowButtonMultiMenu',fXOffset,fYOffset,400.00,25.00,self));
	m_ButtonJoinIP.ToolTipString=pButtonsDef.GetButtonLoc(32,True);
	m_ButtonJoinIP.Text=pButtonsDef.GetButtonLoc(32);
//	m_ButtonJoinIP.m_eButton_Action=32;
	m_ButtonJoinIP.align=ta_left;
	m_ButtonJoinIP.m_fFontSpacing=0.00;
	m_ButtonJoinIP.m_buttonFont=ButtonFont;
	m_ButtonJoinIP.ResizeToText();
	m_ButtonJoinIP.m_pPreviousButtonPos=m_ButtonJoin;
	m_ButtonJoinIP.m_pRefButtonPos=m_ButtonLogInOut;
	fXOffset += fWidth;
	m_ButtonRefresh=R6WindowButtonMultiMenu(CreateWindow(Class'R6WindowButtonMultiMenu',fXOffset,fYOffset,400.00,25.00,self));
	m_ButtonRefresh.ToolTipString=pButtonsDef.GetButtonLoc(33,True);
	m_ButtonRefresh.Text=pButtonsDef.GetButtonLoc(33);
//	m_ButtonRefresh.m_eButton_Action=33;
	m_ButtonRefresh.align=ta_left;
	m_ButtonRefresh.m_fFontSpacing=0.00;
	m_ButtonRefresh.m_buttonFont=ButtonFont;
	m_ButtonRefresh.ResizeToText();
	m_ButtonRefresh.m_pPreviousButtonPos=m_ButtonJoinIP;
	m_ButtonRefresh.m_pRefButtonPos=m_ButtonLogInOut;
	fXOffset += fWidth;
	m_ButtonCreate=R6WindowButtonMultiMenu(CreateWindow(Class'R6WindowButtonMultiMenu',fXOffset,fYOffset,fWidth,25.00,self));
	m_ButtonCreate.ToolTipString=pButtonsDef.GetButtonLoc(34,True);
	m_ButtonCreate.Text=pButtonsDef.GetButtonLoc(34);
//	m_ButtonCreate.m_eButton_Action=34;
	m_ButtonCreate.align=ta_right;
	m_ButtonCreate.m_fFontSpacing=0.00;
	m_ButtonCreate.m_buttonFont=ButtonFont;
	m_ButtonCreate.ResizeToText();
	m_ButtonCreate.m_pRefButtonPos=m_ButtonLogInOut;
}

function InitInfoBar ()
{
	local float fWidth;
	local float fPreviousPos;

	fWidth=15.00;
	fPreviousPos=0.00;
	m_pButServerList=R6MenuMPButServerList(CreateWindow(Class'R6MenuMPButServerList',10.00 + 1,114.00,620.00 - 2,12.00,self));
}

function InitFirstTabWindow ()
{
	local float fWidth;

	fWidth=1.00;
	m_pFirstWindowBorder=R6WindowSimpleFramedWindowExt(CreateWindow(Class'R6WindowSimpleFramedWindowExt',10.00,126.00,620.00,154.00,self));
	m_pFirstWindowBorder.bAlwaysBehind=True;
	m_pFirstWindowBorder.ActiveBorder(0,False);
	m_pFirstWindowBorder.SetBorderParam(1,7.00,0.00,fWidth,Root.Colors.White);
	m_pFirstWindowBorder.SetBorderParam(2,1.00,0.00,fWidth,Root.Colors.White);
	m_pFirstWindowBorder.SetBorderParam(3,1.00,0.00,fWidth,Root.Colors.White);
//	m_pFirstWindowBorder.m_eCornerType=2;
	m_pFirstWindowBorder.SetCornerColor(2,Root.Colors.White);
	m_pFirstWindowBorder.ActiveBackGround(True,Root.Colors.Black);
}

function InitServerList ()
{
	local Font ButtonFont;
	local int iFiles;
	local int i;
	local int j;

	if ( m_ServerListBox != None )
	{
		return;
	}
	m_ServerListBox=R6WindowServerListBox(CreateWindow(Class'R6WindowServerListBox',12.00,126.00,616.00,154.00,self));
	m_ServerListBox.Register(m_pFirstTabManager);
//	m_ServerListBox.SetCornerType(1);
	m_ServerListBox.m_Font=Root.Fonts[10];
	m_ServerListBox.m_iPingTimeOut=m_LanServers.NativeGetPingTimeOut();
}

function InitServerInfoPlayer ()
{
	local Font ButtonFont;
	local int iFiles;
	local int i;
	local int j;

	m_ServerInfoPlayerBox=R6WindowServerInfoPlayerBox(CreateWindow(Class'R6WindowServerInfoPlayerBox',10.00,336.00,245.00,79.00,self));
	m_ServerInfoPlayerBox.ToolTipString=Localize("Tip","InfoBar_ServerInfo_Player","R6Menu");
//	m_ServerInfoPlayerBox.SetCornerType(1);
	m_ServerInfoPlayerBox.m_Font=Root.Fonts[10];
	m_ServerInfoPlayerBox.HideWindow();
}

function InitServerInfoMap ()
{
	local Font ButtonFont;
	local int iFiles;
	local int i;
	local int j;

	m_ServerInfoMapBox=R6WindowServerInfoMapBox(CreateWindow(Class'R6WindowServerInfoMapBox',255.00,336.00,174.00,79.00,self));
	m_ServerInfoMapBox.ToolTipString=Localize("Tip","InfoBar_ServerInfo_Map","R6Menu");
//	m_ServerInfoMapBox.SetCornerType(0);
	m_ServerInfoMapBox.m_Font=Root.Fonts[10];
	m_ServerInfoMapBox.HideWindow();
}

function InitServerInfoOptions ()
{
	local Font ButtonFont;
	local int iFiles;
	local int i;
	local int j;

	m_ServerInfoOptionsBox=R6WindowServerInfoOptionsBox(CreateWindow(Class'R6WindowServerInfoOptionsBox',429.00,336.00,200.00,79.00,self));
	m_ServerInfoOptionsBox.ToolTipString=Localize("Tip","InfoBar_ServerInfo_Opt","R6Menu");
//	m_ServerInfoOptionsBox.SetCornerType(0);
	m_ServerInfoOptionsBox.m_Font=Root.Fonts[10];
	m_ServerInfoOptionsBox.HideWindow();
}

function InitSecondTabWindow ()
{
	local float fWidth;

	fWidth=1.00;
	if ( m_pSecondWindowBorder == None )
	{
		m_pSecondWindowBorder=R6WindowSimpleFramedWindowExt(CreateWindow(Class'R6WindowSimpleFramedWindowExt',10.00,296.00 + 29,620.00,90.00,self));
		m_pSecondWindowBorder.bAlwaysBehind=True;
		m_pSecondWindowBorder.ActiveBorder(0,False);
		m_pSecondWindowBorder.SetBorderParam(1,7.00,0.00,fWidth,Root.Colors.White);
		m_pSecondWindowBorder.SetBorderParam(2,1.00,1.00,fWidth,Root.Colors.White);
		m_pSecondWindowBorder.SetBorderParam(3,1.00,1.00,fWidth,Root.Colors.White);
//		m_pSecondWindowBorder.m_eCornerType=2;
		m_pSecondWindowBorder.SetCornerColor(2,Root.Colors.White);
		m_pSecondWindowBorder.ActiveBackGround(True,Root.Colors.Black);
		m_pSecondWindowGameMode=R6MenuMPMenuTab(CreateWindow(Root.MenuClassDefines.ClassMPMenuTabGameModeFilters,10.00,296.00 + 29,620.00,90.00,self));
		m_pSecondWindowGameMode.InitGameModeTab();
		m_pSecondWindowFilter=R6MenuMPMenuTab(CreateWindow(Class'R6MenuMPMenuTab',10.00,296.00 + 29,620.00,90.00,self));
		m_pSecondWindowFilter.InitFilterTab();
		m_pSecondWindowFilter.HideWindow();
		m_pSecondWindowServerInfo=R6MenuMPMenuTab(CreateWindow(Class'R6MenuMPMenuTab',10.00,296.00 + 29,620.00,90.00,self));
		m_pSecondWindowServerInfo.bAlwaysBehind=True;
		m_pSecondWindowServerInfo.InitServerTab();
		m_pSecondWindowServerInfo.HideWindow();
		m_pSecondWindow=m_pSecondWindowGameMode;
	}
}

function InitRightClickMenu ()
{
	m_pRightClickMenu=R6WindowRightClickMenu(CreateControl(Class'R6WindowRightClickMenu',100.00,150.00,140.00,14.00));
	m_pRightClickMenu.Register(m_pFirstTabManager);
	m_pRightClickMenu.EditBoxWidth=140.00;
	m_pRightClickMenu.SetFont(6);
	m_pRightClickMenu.SetValue("");
	m_pRightClickMenu.AddItem(Localize("MultiPlayer","RightClick_AddFav","R6Menu"));
	m_pRightClickMenu.AddItem(Localize("MultiPlayer","RightClick_SubFav","R6Menu"));
	m_pRightClickMenu.AddItem(Localize("MultiPlayer","RightClick_Refr","R6Menu"));
	m_pRightClickMenu.HideWindow();
}

function SendMessage (eR6MenuWidgetMessage eMessage)
{
	switch (eMessage)
	{
/*		case 0:
		switch (m_LoginSuccessAction)
		{
			case 1:
			m_szServerIP=m_pJoinIPWindow.m_szIP;
			QueryReceivedStartPreJoin();
			break;
			case 2:
			QueryReceivedStartPreJoin();
			break;
			case 3:
			Refresh(False);
			break;
			case 6:
			m_pFirstTabManager.m_pMainTabControl.GotoTab(m_pFirstTabManager.m_pMainTabControl.GetTab(Localize("MultiPlayer","Tab_InternetServer","R6Menu")));
			break;
			case 5:
			if ( m_ConnectionTab == 1 )
			{
				Refresh(False);
			}
			default:
		}
		m_LoginSuccessAction=0;
		break;
		case 1:
		m_pFirstTabManager.m_pMainTabControl.GotoTab(m_pFirstTabManager.m_pMainTabControl.GetTab(Localize("MultiPlayer","Tab_LanServer","R6Menu")));
		m_LoginSuccessAction=0;
		break;
		case 2:
		switch (m_LoginSuccessAction)
		{
			case 1:
			m_szServerIP=m_pJoinIPWindow.m_szIP;
			QueryReceivedStartPreJoin();
			break;
			case 2:
			QueryReceivedStartPreJoin();
			break;
			default:
		}
		m_LoginSuccessAction=0;
		break;
		case 3:
		m_bPreJoinInProgress=False;
		m_szGamePwd=m_pCDKeyCheckWindow.m_szPassword;
		joinServer(m_szServerIP);
		break;
		case 4:
		m_GameService.SaveConfig();
		m_bPreJoinInProgress=False;
		m_szGamePwd=m_pCDKeyCheckWindow.m_szPassword;
		joinServer(m_szServerIP);
		break;
		case 5:
		m_bPreJoinInProgress=False;
		break;
		case 6:
		m_bJoinIPInProgress=False;
		m_szPopUpIP=m_pJoinIPWindow.m_szIP;
		SaveConfig();
		if ( m_pJoinIPWindow.m_bRoomValid )
		{
			m_LoginSuccessAction=1;
			m_pLoginWindow.StartLogInProcedure(self);
		}
		else
		{
			m_szServerIP=m_pJoinIPWindow.m_szIP;
			QueryReceivedStartPreJoin();
		}
		break;
		case 7:
		m_bJoinIPInProgress=False;
		break;
		case 8:
		if ( m_pQueryServerInfo.m_bRoomValid )
		{
			m_LoginSuccessAction=2;
			m_pLoginWindow.StartLogInProcedure(self);
		}
		else
		{
			QueryReceivedStartPreJoin();
		}
		m_bQueryServerInfoInProgress=False;
		break;
		case 9:
		m_bQueryServerInfoInProgress=False;
		break;
		default:  */
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		switch (C)
		{
			case m_ButtonMainMenu:
//			Root.ChangeCurrentWidget(7);
			break;
			case m_ButtonOptions:
//			Root.ChangeCurrentWidget(16);
			break;
			case m_PageCount.m_pNextButton:
			m_PageCount.NextPage();
			m_GameService.m_bServerListChanged=True;
			m_iTimeLastUpdate=0;
			break;
			case m_PageCount.m_pPreviousButton:
			m_PageCount.PreviousPage();
			m_GameService.m_bServerListChanged=True;
			m_iTimeLastUpdate=0;
			break;
			default:
		}
	}
}

function BackToMainMenu ()
{
	local ClientBeaconReceiver _BeaconReceiver;

	ResetMultiplayerMenu();
}

function ResetMultiplayerMenu ()
{
	local ClientBeaconReceiver _BeaconReceiver;

	if ( m_LanServers != None )
	{
		_BeaconReceiver=m_LanServers.m_ClientBeacon;
		m_LanServers.m_ClientBeacon=None;
	}
	if ( m_GameService != None )
	{
		m_GameService.m_ClientBeacon=None;
	}
	if ( _BeaconReceiver != None )
	{
		_BeaconReceiver.Destroy();
	}
	m_LanServers=None;
	R6Console(Root.Console).m_LanServers=None;
}

defaultproperties
{
    m_bLanRefreshFPass=True
    m_bIntRefreshFPass=True
}
