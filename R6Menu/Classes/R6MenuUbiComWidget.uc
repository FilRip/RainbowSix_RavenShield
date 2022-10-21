//================================================================================
// R6MenuUbiComWidget.
//================================================================================
class R6MenuUbiComWidget extends R6MenuWidget;

var bool m_bPreJoinInProgress;
var bool m_bChangeMap;
var R6WindowUbiCDKeyCheck m_pCDKeyCheckWindow;
var R6GSServers m_GameService;
var R6WindowPopUpBox m_pErrorConnect;
var R6WindowButtonMainMenu m_ButtonQuit;
var R6WindowButtonMainMenu m_ButtonReturn;
var string m_szIPAddress;

function Created ()
{
	local float fButtonXpos;
	local float fButtonWidth;
	local float fButtonHeight;
	local float fFirstButtonYpos;
	local float fButtonOffset;

	fButtonXpos=350.00;
	fButtonWidth=250.00;
	fFirstButtonYpos=225.00;
	fButtonOffset=35.00;
	fButtonHeight=35.00;
	Root.SetLoadRandomBackgroundImage("");
	m_GameService=R6Console(Root.Console).m_GameService;
	m_pCDKeyCheckWindow=R6WindowUbiCDKeyCheck(CreateWindow(Root.MenuClassDefines.ClassUbiCDKeyCheck,0.00,0.00,640.00,480.00,self,True));
	m_pCDKeyCheckWindow.m_GameService=m_GameService;
	m_pCDKeyCheckWindow.PopUpBoxCreate();
	m_pCDKeyCheckWindow.HideWindow();
	m_ButtonQuit=R6WindowButtonMainMenu(CreateControl(Class'R6WindowButtonMainMenu',fButtonXpos,fFirstButtonYpos,fButtonWidth,fButtonHeight,self));
	m_ButtonQuit.ToolTipString=Localize("UbiCom","ButtonQuit","R6Menu");
	m_ButtonQuit.Text=Localize("UbiCom","ButtonQuit","R6Menu");
	m_ButtonQuit.align=ta_right;
	m_ButtonQuit.m_buttonFont=Root.Fonts[14];
//	m_ButtonQuit.m_eButton_Action=8;
	m_ButtonQuit.ResizeToText();
	m_ButtonReturn=R6WindowButtonMainMenu(CreateControl(Class'R6WindowButtonMainMenu',fButtonXpos,fFirstButtonYpos + fButtonOffset,fButtonWidth,fButtonHeight,self));
	m_ButtonReturn.ToolTipString=Localize("UbiCom","ButtonReturn","R6Menu");
	m_ButtonReturn.Text=Localize("UbiCom","ButtonReturn","R6Menu");
	m_ButtonReturn.align=ta_right;
	m_ButtonReturn.m_buttonFont=Root.Fonts[14];
//	m_ButtonReturn.m_eButton_Action=9;
	m_ButtonReturn.ResizeToText();
}

function Paint (Canvas C, float X, float Y)
{
	Root.PaintBackground(C,self);
	if ( m_GameService.m_eGSGameState == 0 )
	{
		if (  !m_ButtonQuit.bWindowVisible )
		{
			m_ButtonQuit.ShowWindow();
		}
		if (  !m_ButtonReturn.bWindowVisible )
		{
			m_ButtonReturn.ShowWindow();
		}
	}
	else
	{
		if ( m_ButtonQuit.bWindowVisible )
		{
			m_ButtonQuit.HideWindow();
		}
		if ( m_ButtonReturn.bWindowVisible )
		{
			m_ButtonReturn.HideWindow();
		}
	}
}

function ShowWindow ()
{
	Root.SetLoadRandomBackgroundImage("");
	Super.ShowWindow();
}

function Tick (float Delta)
{
	if ( CheckForGSClientStart() )
	{
		return;
	}
	if ( R6Console(Root.Console).m_bJoinUbiServer )
	{
		R6Console(Root.Console).m_bJoinUbiServer=False;
		m_szIPAddress=m_GameService.m_szGSClientIP;
		m_pCDKeyCheckWindow.StartPreJoinProcedure(self);
		m_bPreJoinInProgress=True;
	}
	else
	{
		if ( R6Console(Root.Console).m_bCreateUbiServer )
		{
			R6Console(Root.Console).m_bCreateUbiServer=False;
//			Root.ChangeCurrentWidget(19);
			R6MenuRootWindow(Root).InitBeaconService();
		}
	}
	if ( m_bPreJoinInProgress )
	{
		m_pCDKeyCheckWindow.Manager(self);
	}
}

function SendMessage (eR6MenuWidgetMessage eMessage)
{
	switch (eMessage)
	{
/*		case 3:
		case 4:
		m_bPreJoinInProgress=False;
		joinServer(m_szIPAddress);
		break;
		case 5:
		R6Console(Root.Console).m_bReturnToGSClient=True;
		m_bPreJoinInProgress=False;
		break;
		default:*/
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
	if ( m_GameService.m_szGSPassword != "" )
	{
		szOptions=szOptions $ "?Password=" $ m_GameService.m_szGSPassword;
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
	Root.Console.ConsoleCommand("Open " $ szIPAddress $ "?SpawnNum=" $ string(iPlayerSpawnNumber) $ szOptions $ "?AuthID=" $ m_GameService.m_szAuthorizationID);
	self.HideWindow();
	R6Console(Root.Console).szStoreIP=szIPAddress;
	R6Console(Root.Console).szStoreGamePassWd=m_GameService.m_szGSPassword;
}

function bool CheckForGSClientStart ()
{
	local R6ModMgr pModManager;

	if ( R6Console(Root.Console).m_bStartedByGSClient )
	{
		pModManager=Class'Actor'.static.GetModMgr();
		if (  !(pModManager.m_szPendingModName ~= pModManager.m_pRVS.m_szGameServiceGameName) && (pModManager.m_szPendingModName != "") )
		{
			if ( R6Console(Root.Console).m_GameService.m_eGSGameState == 8 )
			{
				pModManager.SetCurrentMod(pModManager.m_szPendingModName,True);
//				R6Console(Root.Console).m_eLastPreviousWID=20;
//				R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).9);
			}
			return True;
		}
	}
	return False;
}

function PromptConnectionError ()
{
	local string szTemp;
	local R6WindowTextLabel pR6TextLabelTemp;

	if ( m_pErrorConnect == None )
	{
		m_pErrorConnect=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00,self));
		m_pErrorConnect.CreateStdPopUpWindow(Localize("MultiPlayer","Popup_Error_Title","R6Menu"),30.00,205.00,170.00,230.00,50.00,2);
		m_pErrorConnect.CreateClientWindow(Class'R6WindowTextLabel');
		pR6TextLabelTemp=R6WindowTextLabel(m_pErrorConnect.m_ClientArea);
		if ( R6Console(Root.Console).m_szLastError != "" )
		{
			szTemp=Localize("Multiplayer",R6Console(Root.Console).m_szLastError,"R6Menu",True);
			if ( szTemp == "" )
			{
				szTemp=Localize("Errors",R6Console(Root.Console).m_szLastError,"R6Engine",True);
			}
			if ( szTemp == "" )
			{
				pR6TextLabelTemp.Text=R6Console(Root.Console).m_szLastError;
			}
			else
			{
				pR6TextLabelTemp.Text=szTemp;
			}
			R6Console(Root.Console).m_szLastError="";
		}
		else
		{
			pR6TextLabelTemp.Text=Localize("MultiPlayer","Popup_ConnectionError","R6Menu");
		}
		pR6TextLabelTemp.align=ta_center;
		pR6TextLabelTemp.m_Font=Root.Fonts[6];
		pR6TextLabelTemp.TextColor=Root.Colors.BlueLight;
		pR6TextLabelTemp.m_BGTexture=None;
		pR6TextLabelTemp.m_HBorderTexture=None;
		pR6TextLabelTemp.m_VBorderTexture=None;
		pR6TextLabelTemp.m_TextDrawstyle=5;
	}
	m_pErrorConnect.ShowWindow();
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	R6Console(Root.Console).m_bReturnToGSClient=True;
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( C.IsA('R6WindowButtonMainMenu') )
	{
		if ( E == 2 )
		{
			if ( C == m_ButtonQuit )
			{
				Root.DoQuitGame();
			}
			else
			{
				if ( C == m_ButtonReturn )
				{
					R6Console(Root.Console).m_bReturnToGSClient=True;
				}
			}
		}
	}
}
