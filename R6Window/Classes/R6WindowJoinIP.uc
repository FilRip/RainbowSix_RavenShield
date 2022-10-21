//================================================================================
// R6WindowJoinIP.
//================================================================================
class R6WindowJoinIP extends UWindowWindow;

enum eJoinIPState {
	EJOINIP_ENTER_IP,
	EJOINIP_WAITING_FOR_BEACON,
	EJOINIP_BEACON_FAIL,
	EJOINIP_WAITING_FOR_UBICOMLOGIN
};

var eJoinIPState eState;
var bool m_bRoomValid;
var bool m_bStartByCmdLine;
var float m_fBeaconTime;
var R6WindowPopUpBox m_pEnterIP;
var R6WindowPopUpBox m_pPleaseWait;
var R6WindowPopUpBox m_pError;
var R6GSServers m_GameService;
var UWindowWindow m_pSendMessageDest;
var string m_szIP;
const K_MAX_TIME_BEACON= 5.0;

function StartJoinIPProcedure (UWindowWindow _pCurrentWidget, string _szLastIP)
{
	m_pSendMessageDest=_pCurrentWidget;
	ShowWindow();
//	eState=0;
	m_pEnterIP.ShowWindow();
	R6WindowEditBox(m_pEnterIP.m_ClientArea).SetValue(_szLastIP);
	m_bStartByCmdLine=False;
}

function StartCmdLineJoinIPProcedure (UWindowWindow _pCurrentWidget, string _szLastIP)
{
	Log("R6WindowJoinIP::StartCmdLineJoinIPProcedure");
	m_pSendMessageDest=_pCurrentWidget;
	ShowWindow();
//	eState=3;
	m_pPleaseWait.ShowWindow();
	Log("R6WindowJoinIP::SetValue");
	R6WindowEditBox(m_pEnterIP.m_ClientArea).SetValue(_szLastIP);
	m_bStartByCmdLine=True;
}

function Manager (UWindowWindow _pCurrentWidget)
{
	local float elapsedTime;

	switch (eState)
	{
/*		case 3:
		if ( m_GameService.m_bLoggedInUbiDotCom )
		{
			PopUpBoxDone(3,10);
		}
		break;
		case 1:
		if ( m_GameService.m_ClientBeacon.PreJoinInfo.bResponseRcvd )
		{
			if ( Root.Console.ViewportOwner.Actor.GetGameVersion() != m_GameService.m_ClientBeacon.PreJoinInfo.szGameVersion )
			{
				eState=2;
				m_pPleaseWait.HideWindow();
				m_pError.ShowWindow();
				R6WindowTextLabel(m_pError.m_ClientArea).Text=Localize("MultiPlayer","PopUp_Error_BadVersion","R6Menu");
			}
			else
			{
				if ( R6Console(Root.Console).m_bNonUbiMatchMaking )
				{
					_pCurrentWidget.SendMessage(6);
					if (  !m_bStartByCmdLine )
					{
						HideWindow();
					}
				}
				else
				{
					if (  !m_GameService.m_ClientBeacon.PreJoinInfo.bInternetServer )
					{
						eState=2;
						m_pPleaseWait.HideWindow();
						m_pError.ShowWindow();
						R6WindowTextLabel(m_pError.m_ClientArea).Text=Localize("MultiPlayer","PopUp_Error_LanServer","R6Menu");
					}
					else
					{
						m_bRoomValid=(m_GameService.m_ClientBeacon.PreJoinInfo.iLobbyID != 0) && (m_GameService.m_ClientBeacon.PreJoinInfo.iGroupID != 0);
						_pCurrentWidget.SendMessage(6);
						HideWindow();
					}
				}
			}
		}
		else
		{
			elapsedTime=m_GameService.NativeGetSeconds() - m_fBeaconTime;
			if ( elapsedTime > 5.00 )
			{
				eState=2;
				m_pPleaseWait.HideWindow();
				m_pError.ShowWindow();
				R6WindowTextLabel(m_pError.m_ClientArea).Text=Localize("MultiPlayer","PopUp_Error_NoServer","R6Menu");
			}
		}
		break;
		default:*/
	}
}

function PopUpBoxCreate ()
{
	local R6WindowEditBox pR6EditBoxTemp;
	local R6WindowTextLabel pR6TextLabelTemp;

	m_pEnterIP=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pEnterIP.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Join","R6Menu"),30.00,205.00,170.00,230.00,50.00);
	m_pEnterIP.CreateClientWindow(Class'R6WindowEditBox');
//	m_pEnterIP.m_ePopUpID=10;
	pR6EditBoxTemp=R6WindowEditBox(m_pEnterIP.m_ClientArea);
	pR6EditBoxTemp.TextColor=Root.Colors.BlueLight;
	pR6EditBoxTemp.SetFont(8);
	pR6EditBoxTemp.MaxLength=21;
	m_pEnterIP.HideWindow();
	m_pError=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pError.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Error_Title","R6Menu"),30.00,205.00,170.00,230.00,50.00,2);
	m_pError.CreateClientWindow(Class'R6WindowTextLabel');
//	m_pError.m_ePopUpID=11;
	pR6TextLabelTemp=R6WindowTextLabel(m_pError.m_ClientArea);
	pR6TextLabelTemp.Text=Localize("MultiPlayer","PopUp_Error_NoServer","R6Menu");
	pR6TextLabelTemp.Align=TA_Center;
	pR6TextLabelTemp.m_Font=Root.Fonts[6];
	pR6TextLabelTemp.TextColor=Root.Colors.BlueLight;
	pR6TextLabelTemp.m_BGTexture=None;
	pR6TextLabelTemp.m_HBorderTexture=None;
	pR6TextLabelTemp.m_VBorderTexture=None;
	pR6TextLabelTemp.m_TextDrawstyle=5;
	m_pError.HideWindow();
	m_pPleaseWait=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pPleaseWait.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Wait","R6Menu"),30.00,205.00,170.00,230.00,50.00,2);
	m_pPleaseWait.CreateClientWindow(Class'R6WindowTextLabel');
//	m_pPleaseWait.m_ePopUpID=12;
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
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
/*	if ( Result == 3 )
	{
		switch (_ePopUpID)
		{
			case 10:
			m_szIP=R6WindowEditBox(m_pEnterIP.m_ClientArea).GetValue();
			if ( m_GameService.m_ClientBeacon.PreJoinQuery(m_szIP,0) == False )
			{
				PopUpBoxDone(3,11);
				Log("Invalid IP string entered");
			}
			else
			{
				if (  !m_bStartByCmdLine )
				{
					m_pPleaseWait.ShowWindow();
				}
				m_fBeaconTime=m_GameService.NativeGetSeconds();
				eState=1;
				goto JL0141;
				case 12:
				m_pPleaseWait.HideWindow();
				m_pError.HideWindow();
				m_pSendMessageDest.SendMessage(7);
				HideWindow();
				goto JL0141;
				case 11:
				m_pPleaseWait.HideWindow();
				m_pError.HideWindow();
				m_pEnterIP.ShowWindow();
				eState=0;
				goto JL0141;
				default:
			}
JL0141:
			break;
			if ( Result == 4 )
			{
				switch (_ePopUpID)
				{
					case 10:
					m_pEnterIP.HideWindow();
					m_pSendMessageDest.SendMessage(7);
					HideWindow();
					break;
					default:
				}
			}
		}
	}*/
}
