//================================================================================
// R6WindowUbiCDKeyCheck.
//================================================================================
class R6WindowUbiCDKeyCheck extends R6WindowMPManager;

enum eJoinRoomChoice {
	EJRC_NO,
	EJRC_BY_LOBBY_AND_ROOM_ID
};

var eJoinRoomChoice m_eJoinRoomChoice;
var int m_iGroupID;
var int m_iLobbyID;
var bool m_bLocked;
var config bool bShowLog;
var R6WindowPopUpBox m_pPleaseWait;
var R6WindowPopUpBox m_pPassword;
var R6WindowEditBox m_pPasswordEditBox;
var R6GSServers m_GameService;
var UWindowWindow m_pSendMessageDest;
var R6WindowPopUpBox m_pR6EnterCDKey;
var string m_szPassword;

function StartPreJoinProcedure (UWindowWindow _pCurrentWidget, optional bool _bLocked, optional eJoinRoomChoice _eJoinUbiComRoom, optional int _iGroupID, optional int _iLobbyID)
{
	m_pSendMessageDest=_pCurrentWidget;
	m_eJoinRoomChoice=_eJoinUbiComRoom;
	m_bLocked=_bLocked;
	m_iGroupID=_iGroupID;
	m_iLobbyID=_iLobbyID;
	if (  !m_GameService.m_bValidActivationID )
	{
		m_pR6EnterCDKey.ShowWindow();
	}
	else
	{
		m_GameService.requestGSCDKeyAuthID();
		m_pPleaseWait.ShowLockPopUp();
	}
	ShowWindow();
}

function HandleLockedServerPopUp ()
{
	local string _GamePassword;

	if ( m_bLocked )
	{
		m_pPassword.ShowWindow();
		if ( R6Console(Root.Console).m_bNonUbiMatchMaking )
		{
			Class'Actor'.static.NativeNonUbiMatchMakingPassword(_GamePassword);
			if ( _GamePassword == "" )
			{
				m_pPasswordEditBox.SelectAll();
			}
			else
			{
				m_pPasswordEditBox.SetValue(_GamePassword);
//				m_pPassword.Result=3;
				m_pPassword.Close();
			}
		}
		else
		{
			m_pPasswordEditBox.SelectAll();
		}
	}
	else
	{
//		PopUpBoxDone(3,18);
	}
}

function Manager (UWindowWindow _pCurrentWidget)
{
/*	local R6WindowTextLabel pR6TextLabelTemp;

	switch (m_GameService.m_eMenuGetCDKeyActID)
	{
		case 5:
		if ( bShowLog )
		{
			Log("*** Act ID Fail ***");
		}
		m_GameService.m_eMenuGetCDKeyActID=0;
		m_pPleaseWait.HideWindow();
		m_pR6EnterCDKey.ModifyTextWindow(Localize("Errors","CDKeyServerNotResponding","R6ENGINE"),205.00,170.00,230.00,30.00);
		m_pR6EnterCDKey.ShowWindow();
		break;
		case 4:
		m_GameService.m_eMenuGetCDKeyActID=0;
		m_GameService.requestGSCDKeyAuthID();
		if ( bShowLog )
		{
			Log("*** ActId TimeOut Error ***");
		}
		break;
		case 2:
		m_GameService.m_eMenuGetCDKeyActID=0;
		m_GameService.SaveConfig();
		m_GameService.requestGSCDKeyAuthID();
		if ( bShowLog )
		{
			Log("*** Activation ID obtained ***");
		}
		break;
		case 3:
		if ( bShowLog )
		{
			Log("*** Act ID Fail ***");
		}
		m_GameService.m_eMenuGetCDKeyActID=0;
		m_pPleaseWait.HideWindow();
		switch (m_GameService.m_eMenuCDKeyFailReason)
		{
			case 10:
			m_pR6EnterCDKey.ModifyTextWindow(Localize("Errors","INVALIDCDKEY","R6ENGINE"),205.00,170.00,230.00,30.00);
			m_pR6EnterCDKey.ShowWindow();
			break;
			case 9:
			DisplayErrorMsg(Localize("Errors","CDKeyAlreadyInUse","R6ENGINE"),20);
			break;
			default:
			m_pR6EnterCDKey.ModifyTextWindow(Localize("Errors","CDKeyTryLater","R6ENGINE"),205.00,170.00,230.00,30.00);
			m_pR6EnterCDKey.ShowWindow();
			break;
		}
		break;
		default:
	}
	switch (m_GameService.m_eMenuCDKeyAuthorization)
	{
		case 5:
		if ( bShowLog )
		{
			Log("*** Auth ID Timeout ERROR ***");
		}
		m_pPleaseWait.HideWindow();
		m_GameService.m_eMenuCDKeyAuthorization=0;
		DisplayErrorMsg(Localize("Errors","CDKeyServerNotResponding","R6ENGINE"),21);
		break;
		case 6:
		m_pPleaseWait.HideWindow();
		m_GameService.m_eMenuCDKeyAuthorization=0;
		DisplayErrorMsg(Localize("Errors","CDKeyAlreadyInUse","R6ENGINE"),20);
		break;
		case 4:
		if ( bShowLog )
		{
			Log("*** Auth ID Timeout Let client play ***");
		}
		case 2:
		m_pPleaseWait.HideWindow();
		m_GameService.m_eMenuCDKeyAuthorization=0;
		HandleLockedServerPopUp();
		break;
		case 7:
		if ( bShowLog )
		{
			Log("*** Auth ID NOT Challenged ***");
		}
		m_GameService.m_eMenuCDKeyAuthorization=0;
		m_pPleaseWait.HideWindow();
		m_pPleaseWait.ModifyTextWindow(Localize("Errors","CDKeyTryLater","R6ENGINE") $ ": 3",205.00,170.00,230.00,30.00);
		m_pPleaseWait.ShowWindow();
		break;
		case 8:
		if ( bShowLog )
		{
			Log("*** Auth ID Internal Error ***");
		}
		m_GameService.m_eMenuCDKeyAuthorization=0;
		m_pPleaseWait.HideWindow();
		m_pPleaseWait.ModifyTextWindow(Localize("Errors","CDKeyTryLater","R6ENGINE") $ ": 5",205.00,170.00,230.00,30.00);
		m_pPleaseWait.ShowWindow();
		break;
		case 3:
		m_GameService.m_eMenuCDKeyAuthorization=0;
		if ( bShowLog )
		{
			Log("*** Auth ID Fail ***");
		}
		m_pPleaseWait.HideWindow();
		m_GameService.m_bValidActivationID=False;
		m_pR6EnterCDKey.ModifyTextWindow(Localize("Errors","INVALIDCDKEY","R6ENGINE"),205.00,170.00,230.00,30.00);
		m_pR6EnterCDKey.ShowWindow();
		default:
	}
	switch (m_GameService.m_eMenuJoinServer)
	{
		case 2:
		m_GameService.m_eMenuJoinServer=0;
		m_GameService.m_eMenuCDKeyAuthorization=0;
		m_pSendMessageDest.SendMessage(4);
		m_GameService.NativeMSClientServerConnected(m_iLobbyID,m_iGroupID);
		break;
		case 4:
		case 3:
		m_GameService.m_eMenuJoinServer=0;
		m_pPleaseWait.HideWindow();
		switch (m_GameService.m_eMenuJoinRoomFailReason)
		{
			case 2:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_PassWd","R6Menu"),22);
			break;
			case 3:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_ServerFull","R6Menu"),23);
			break;
			case 0:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_RoomJoin","R6Menu"),19);
			break;
			default:
		}
		break;
		default:
	}*/
}

function PopUpBoxCreate ()
{
	local R6WindowEditBox pR6EditBoxTemp;
	local R6WindowTextLabel pR6TextLabelTemp;

	Super.PopUpBoxCreate();
	m_pPleaseWait=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pPleaseWait.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Wait","R6Menu"),30.00,205.00,170.00,230.00,50.00,4);
	m_pPleaseWait.CreateClientWindow(Class'R6WindowTextLabel');
//	m_pPleaseWait.m_ePopUpID=16;
	m_pPleaseWait.SetPopUpResizable(True);
	pR6TextLabelTemp=R6WindowTextLabel(m_pPleaseWait.m_ClientArea);
	pR6TextLabelTemp.Text=Localize("MultiPlayer","PopUp_Cancel","R6Menu");
	pR6TextLabelTemp.Align=TA_Center;
	pR6TextLabelTemp.m_Font=Root.Fonts[6];
	pR6TextLabelTemp.TextColor=Root.Colors.BlueLight;
	pR6TextLabelTemp.m_BGTexture=None;
	pR6TextLabelTemp.m_HBorderTexture=None;
	pR6TextLabelTemp.m_VBorderTexture=None;
	pR6TextLabelTemp.m_TextDrawstyle=5;
	m_pPleaseWait.HideWindow();
	m_pR6EnterCDKey=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pR6EnterCDKey.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_EnterCDKey","R6Menu"),30.00,205.00,170.00,230.00,50.00);
	m_pR6EnterCDKey.CreateClientWindow(Class'R6WindowEditBox');
//	m_pR6EnterCDKey.m_ePopUpID=17;
	pR6EditBoxTemp=R6WindowEditBox(m_pR6EnterCDKey.m_ClientArea);
	pR6EditBoxTemp.TextColor=Root.Colors.BlueLight;
	pR6EditBoxTemp.SetFont(8);
	m_pR6EnterCDKey.HideWindow();
	m_pPassword=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pPassword.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Password","R6Menu"),30.00,205.00,170.00,230.00,50.00);
	m_pPassword.CreateClientWindow(Class'R6WindowEditBox');
//	m_pPassword.m_ePopUpID=18;
	m_pPasswordEditBox=R6WindowEditBox(m_pPassword.m_ClientArea);
	m_pPasswordEditBox.TextColor=Root.Colors.BlueLight;
	m_pPasswordEditBox.SetFont(8);
	m_pPasswordEditBox.MaxLength=16;
	m_pPasswordEditBox.bCaps=False;
	m_pPasswordEditBox.bPassword=True;
	m_pPassword.HideWindow();
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
/*	if ( Result == 3 )
	{
		switch (_ePopUpID)
		{
			case 18:
    		m_szPassword=R6WindowEditBox(m_pPassword.m_ClientArea).GetValue();
			switch (m_eJoinRoomChoice)
			{
				case 1:
				m_GameService.m_eMenuCDKeyAuthorization=0;
				m_GameService.NativeMSCLientJoinServer(m_iLobbyID,m_iGroupID,m_szPassword);
				m_pPleaseWait.ShowWindow();
				break;
				case 0:
				m_GameService.m_eMenuCDKeyAuthorization=0;
				m_pPleaseWait.ShowLockPopUp();
				m_pSendMessageDest.SendMessage(4);
				break;
				default:
			}
			break;
			case 16:
			HideWindow();
			break;
			case 22:
			m_pPassword.ShowWindow();
			m_pPasswordEditBox.SelectAll();
			break;
			case 19:
			case 20:
			case 21:
			case 23:
			HideWindow();
			m_pSendMessageDest.SendMessage(5);
			break;
			case 17:
			if ( (m_GameService.m_szCDKey != R6WindowEditBox(m_pR6EnterCDKey.m_ClientArea).GetValue()) || (m_GameService.m_bValidActivationID == False) )
			{
				m_GameService.m_szCDKey=R6WindowEditBox(m_pR6EnterCDKey.m_ClientArea).GetValue();
				m_GameService.requestGSCDKeyActID();
				SetRegistryKey("SOFTWARE\Red Storm Entertainment\RAVENSHIELD","CDKey",m_GameService.m_szCDKey);
			}
			else
			{
				m_GameService.requestGSCDKeyAuthID();
			}
			m_pPleaseWait.ShowWindow();
			break;
			default:
		}
	}
	else
	{
		if ( Result == 4 )
		{
			switch (_ePopUpID)
			{
				case 16:
				case 17:
				case 19:
				case 20:
				case 21:
				case 22:
				case 23:
				m_pSendMessageDest.SendMessage(5);
				break;
				case 18:
				if ( R6Console(Root.Console).m_bNonUbiMatchMaking )
				{
					Root.ChangeCurrentWidget(37);
				}
				break;
				default:
			}
			HideWindow();
		}
	}*/
}

defaultproperties
{
    bShowLog=True
}
