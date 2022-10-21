//================================================================================
// R6MenuMPCreateGameWidget.
//================================================================================
class R6MenuMPCreateGameWidget extends R6MenuWidget;

enum eRestrictionKit {
	KIT_SubMachineGuns,
	KIT_Shotguns
};

enum eCreateGameTabID {
	TAB_Options,
	TAB_AdvancedOptions,
	TAB_Kit
};

var bool m_bLoginInProgress;
var bool m_bPreJoinInProgress;
var R6WindowTextLabel m_LMenuTitle;
var R6WindowButton m_ButtonMainMenu;
var R6WindowButton m_ButtonOptions;
var R6WindowButtonMultiMenu m_ButtonCancel;
var R6WindowButtonMultiMenu m_ButtonLaunch;
var R6WindowTextLabelCurved m_FirstTabWindow;
var R6MenuMPManageTab m_pFirstTabManager;
var R6MenuMPCreateGameTab m_pCreateTabWindow;
var R6MenuMPCreateGameTabOptions m_pCreateTabOptions;
var R6MenuMPCreateGameTabKitRest m_pCreateTabKit;
var R6MenuMPCreateGameTabAdvOptions m_pCreateTabAdvOptions;
var R6MenuHelpWindow m_pHelpTextWindow;
var R6WindowSimpleFramedWindowExt m_pWindowBorder;
var R6WindowUbiLogIn m_pLoginWindow;
var R6WindowUbiCDKeyCheck m_pCDKeyCheckWindow;
const K_HSIZE_UNDER_TABWINDOW= 300;
const K_HSIZE_TABWINDOW= 25;
const K_HSIZE_TABWINDOWCURVED= 30;
const K_YPOS_HELPTEXT_WINDOW= 430;
const K_YPOS_TABWINDOW= 92;
const K_YPOS_TABWINDOW_CURVED= 87;
const K_TABWINDOW_WIDTH= 550;
const K_XTABOFFSET= 5;
const K_WINDOWWIDTH= 620;
const K_XSTARTPOS= 10;

function Created ()
{
	InitText();
	InitButton();
	m_FirstTabWindow=R6WindowTextLabelCurved(CreateWindow(Class'R6WindowTextLabelCurved',10.00,87.00,620.00,30.00,self));
	m_FirstTabWindow.bAlwaysBehind=True;
	m_FirstTabWindow.Text="";
	m_FirstTabWindow.m_BGTexture=None;
	m_pFirstTabManager=R6MenuMPManageTab(CreateWindow(Class'R6MenuMPManageTab',10.00 + 5,92.00,550.00,25.00,self));
	m_pFirstTabManager.AddTabInControl(Localize("MPCreateGame","Tab_Options","R6Menu"),Localize("Tip","Tab_Options","R6Menu"),0);
	m_pFirstTabManager.AddTabInControl(Localize("MPCreateGame","Tab_Kit","R6Menu"),Localize("Tip","Tab_Kit","R6Menu"),2);
	m_pLoginWindow=R6WindowUbiLogIn(CreateWindow(Root.MenuClassDefines.ClassUbiLogIn,0.00,0.00,640.00,480.00,self,True));
	m_pLoginWindow.m_GameService=R6Console(Root.Console).m_GameService;
	m_pLoginWindow.PopUpBoxCreate();
	m_pLoginWindow.HideWindow();
	m_pCDKeyCheckWindow=R6WindowUbiCDKeyCheck(CreateWindow(Root.MenuClassDefines.ClassUbiCDKeyCheck,0.00,0.00,640.00,480.00,self,True));
	m_pCDKeyCheckWindow.m_GameService=R6Console(Root.Console).m_GameService;
	m_pCDKeyCheckWindow.PopUpBoxCreate();
	m_pCDKeyCheckWindow.HideWindow();
	m_pHelpTextWindow=R6MenuHelpWindow(CreateWindow(Class'R6MenuHelpWindow',150.00,429.00,340.00,42.00,self));
	InitTabWindow();
}

function Paint (Canvas C, float X, float Y)
{
	Root.PaintBackground(C,self);
	if ( m_bLoginInProgress )
	{
		m_pLoginWindow.Manager(self);
	}
	if ( m_bPreJoinInProgress )
	{
		m_pCDKeyCheckWindow.Manager(self);
	}
}

function ShowWindow ()
{
	Root.SetLoadRandomBackgroundImage("CreateGame");
	if ( R6Console(Root.Console).m_bNonUbiMatchMakingHost || R6Console(Root.Console).m_bAutoLoginFirstPass )
	{
		R6Console(Root.Console).m_bAutoLoginFirstPass=False;
		R6MenuRootWindow(Root).InitBeaconService();
		R6Console(Root.Console).m_GameService.StartAutoLogin();
		if (  !R6Console(Root.Console).m_GameService.m_bAutoLoginInProgress )
		{
			R6Console(Root.Console).szStoreGamePassWd=m_pCreateTabOptions.GetCreateGamePassword();
			m_pLoginWindow.StartLogInProcedure(OwnerWindow);
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

function SendMessage (eR6MenuWidgetMessage eMessage)
{
	switch (eMessage)
	{
/*		case 0:
		case 2:
		m_bLoginInProgress=False;
		m_bPreJoinInProgress=True;
		if (  !R6Console(Root.Console).m_bNonUbiMatchMakingHost )
		{
			m_pCDKeyCheckWindow.StartPreJoinProcedure(self);
		}
		break;
		case 3:
		case 4:
		m_bPreJoinInProgress=False;
		LaunchServer();
		break;
		case 5:
		m_bPreJoinInProgress=False;
		break;
		case 1:
		if ( R6Console(Root.Console).m_bNonUbiMatchMakingHost )
		{
			m_bLoginInProgress=False;
		}
		break;
		default:*/
	}
}

function ToolTip (string strTip)
{
	m_pHelpTextWindow.ToolTip(strTip);
}

function ManageTabSelection (int _MPTabChoiceID)
{
	switch (_MPTabChoiceID)
	{
		case 0:
		m_pCreateTabWindow.HideWindow();
		m_pCreateTabOptions.ShowWindow();
		m_pCreateTabWindow=m_pCreateTabOptions;
		break;
		case 2:
		m_pCreateTabWindow.HideWindow();
		m_pCreateTabKit.ShowWindow();
		m_pCreateTabWindow=m_pCreateTabKit;
		break;
		case 1:
		m_pCreateTabWindow.HideWindow();
		m_pCreateTabAdvOptions.ShowWindow();
		m_pCreateTabWindow=m_pCreateTabAdvOptions;
		break;
		default:
		Log("This tab was not supported (R6MenuMPCreateGameWidget)");
		break;
	}
}

function LaunchServer ()
{
/*	local IpAddr _localAddr;

	m_pCreateTabOptions.SetServerOptions();
	Class'Actor'.static.SaveServerOptions();
	if (  !R6Console(Root.Console).m_bStartedByGSClient &&  !R6Console(Root.Console).m_bNonUbiMatchMakingHost && m_pCreateTabOptions.m_pButtonsDef.GetButtonBoxValue(10,R6WindowListGeneral(m_pCreateTabOptions.GetList(m_pCreateTabOptions.GetCurrentGameMode(),m_pCreateTabOptions.1))) )
	{
		Root.Console.ConsoleCommand("SERVER mod=" $ Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szKeyWord);
	}
	else
	{
		Root.Console.ConsoleCommand("Open " $ m_pCreateTabOptions.m_SelectedMapList[0] $ "?listen?" $ GetLevel().GetGameTypeClassName(m_pCreateTabOptions.m_SelectedModeList[0]));
		R6Console(Root.Console).m_LanServers.m_ClientBeacon.GetLocalIP(_localAddr);
		R6Console(Root.Console).szStoreIP=R6Console(Root.Console).m_LanServers.m_ClientBeacon.IpAddrToString(_localAddr);
		R6Console(Root.Console).LaunchR6MultiPlayerGame();
	}*/
}

function RefreshCreateGameMenu ()
{
	m_pCreateTabOptions.RefreshServerOpt();
	m_pCreateTabAdvOptions.RefreshServerOpt();
}

function MenuServerLoadProfile ()
{
	m_pCreateTabOptions.RefreshServerOpt(True);
	m_pCreateTabAdvOptions.RefreshServerOpt();
	m_pCreateTabKit.m_pMainRestriction.RefreshCreateGameKitRest();
}

function InitText ()
{
	m_LMenuTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,18.00,WinWidth - 8,25.00,self));
	m_LMenuTitle.Text=Localize("MPCreateGame","Title","R6Menu");
	m_LMenuTitle.Align=TA_Right;
	m_LMenuTitle.m_Font=Root.Fonts[4];
	m_LMenuTitle.TextColor=Root.Colors.White;
	m_LMenuTitle.m_BGTexture=None;
	m_LMenuTitle.m_HBorderTexture=None;
	m_LMenuTitle.m_VBorderTexture=None;
}

function InitButton ()
{
	local Font ButtonFont;
	local float fYOffset;

	fYOffset=50.00;
	ButtonFont=Root.Fonts[15];
	m_ButtonMainMenu=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,425.00,250.00,25.00,self));
	m_ButtonMainMenu.ToolTipString=Localize("Tip","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.Text=Localize("SinglePlayer","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.Align=TA_Left;
	m_ButtonMainMenu.m_fFontSpacing=0.00;
	m_ButtonMainMenu.m_buttonFont=Root.Fonts[15];
	m_ButtonMainMenu.ResizeToText();
	m_ButtonMainMenu.bDisabled=R6Console(Root.Console).m_bStartedByGSClient || R6Console(Root.Console).m_bNonUbiMatchMakingHost;
	m_ButtonOptions=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,447.00,250.00,25.00,self));
	m_ButtonOptions.ToolTipString=Localize("Tip","ButtonOptions","R6Menu");
	m_ButtonOptions.Text=Localize("SinglePlayer","ButtonOptions","R6Menu");
	m_ButtonOptions.Align=TA_Left;
	m_ButtonOptions.m_fFontSpacing=0.00;
	m_ButtonOptions.m_buttonFont=Root.Fonts[15];
	m_ButtonOptions.ResizeToText();
	m_ButtonCancel=R6WindowButtonMultiMenu(CreateWindow(Class'R6WindowButtonMultiMenu',10.00,fYOffset,200.00,25.00,self));
	m_ButtonCancel.Text=Localize("MPCreateGame","ButtonCancel","R6Menu");
	m_ButtonCancel.ToolTipString=Localize("Tip","ButtonCancel","R6Menu");
//	m_ButtonCancel.m_eButton_Action=35;
	m_ButtonCancel.Align=TA_Left;
	m_ButtonCancel.m_fFontSpacing=2.00;
	m_ButtonCancel.m_buttonFont=ButtonFont;
	m_ButtonCancel.ResizeToText();
	if ( R6Console(Root.Console).m_bStartedByGSClient )
	{
//		m_ButtonCancel.m_eButton_Action=38;
	}
	m_ButtonLaunch=R6WindowButtonMultiMenu(CreateWindow(Class'R6WindowButtonMultiMenu',200.00,fYOffset,106.00,25.00,self));
	m_ButtonLaunch.Text=Localize("MPCreateGame","ButtonLaunch","R6Menu");
	m_ButtonLaunch.ToolTipString=Localize("Tip","ButtonLaunch","R6Menu");
//	m_ButtonLaunch.m_eButton_Action=36;
	m_ButtonLaunch.Align=TA_Center;
	m_ButtonLaunch.m_fFontSpacing=2.00;
	m_ButtonLaunch.m_buttonFont=ButtonFont;
	m_ButtonLaunch.ResizeToText();
}

function InitTabWindow ()
{
	local float fWidth;
	local float fYPos;

	fWidth=1.00;
	fYPos=87.00 + 30 - 1;
	m_pWindowBorder=R6WindowSimpleFramedWindowExt(CreateWindow(Class'R6WindowSimpleFramedWindowExt',10.00,fYPos,620.00,300.00,self));
	m_pWindowBorder.bAlwaysBehind=True;
	m_pWindowBorder.ActiveBorder(0,False);
	m_pWindowBorder.SetBorderParam(1,7.00,0.00,fWidth,Root.Colors.White);
	m_pWindowBorder.SetBorderParam(2,1.00,1.00,fWidth,Root.Colors.White);
	m_pWindowBorder.SetBorderParam(3,1.00,1.00,fWidth,Root.Colors.White);
//	m_pWindowBorder.m_eCornerType=2;
	m_pWindowBorder.SetCornerColor(2,Root.Colors.White);
	m_pWindowBorder.ActiveBackGround(True,Root.Colors.Black);
	m_pCreateTabOptions=R6MenuMPCreateGameTabOptions(CreateWindow(Root.MenuClassDefines.ClassMPCreateGameTabOpt,10.00,fYPos,620.00,300.00,self));
	m_pCreateTabOptions.InitOptionsTab();
	m_pCreateTabKit=R6MenuMPCreateGameTabKitRest(CreateWindow(Class'R6MenuMPCreateGameTabKitRest',10.00,fYPos,620.00,300.00,self));
	m_pCreateTabKit.InitKitTab();
	m_pCreateTabKit.HideWindow();
	m_pCreateTabAdvOptions=R6MenuMPCreateGameTabAdvOptions(CreateWindow(Root.MenuClassDefines.ClassMPCreateGameTabAdvOpt,10.00,fYPos,620.00,300.00,self));
	m_pCreateTabAdvOptions.InitAdvOptionsTab();
	m_pCreateTabAdvOptions.HideWindow();
	m_pCreateTabOptions.AddLinkWindow(m_pCreateTabKit);
	m_pCreateTabOptions.AddLinkWindow(m_pCreateTabAdvOptions);
	m_pCreateTabKit.AddLinkWindow(m_pCreateTabOptions);
	m_pCreateTabKit.AddLinkWindow(m_pCreateTabAdvOptions);
	m_pCreateTabAdvOptions.AddLinkWindow(m_pCreateTabKit);
	m_pCreateTabAdvOptions.AddLinkWindow(m_pCreateTabOptions);
	m_pCreateTabWindow=m_pCreateTabOptions;
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
			default:
		}
	}
}
