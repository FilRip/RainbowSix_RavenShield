//================================================================================
// R6WindowQueryServerInfo.
//================================================================================
class R6WindowQueryServerInfo extends R6WindowMPManager;

var bool m_bWaitingForBeacon;
var bool m_bRoomValid;
var float m_fBeaconTime;
var R6WindowPopUpBox m_pPleaseWait;
var R6GSServers m_GameService;
var UWindowWindow m_pSendMessageDest;
const K_MAX_TIME_BEACON= 5.0;

function StartQueryServerInfoProcedure (UWindowWindow _pCurrentWidget, string _szServerIP, int _iBeaconPort)
{
	if ( InStr(_szServerIP,":") != -1 )
	{
		_szServerIP=Left(_szServerIP,InStr(_szServerIP,":"));
	}
	m_pSendMessageDest=_pCurrentWidget;
	m_GameService.m_szLastServerQueried=_szServerIP;
	m_GameService.m_ClientBeacon.PreJoinQuery(_szServerIP,_iBeaconPort);
	ShowWindow();
	m_bWaitingForBeacon=True;
	m_pPleaseWait.ShowWindow();
	m_fBeaconTime=m_GameService.NativeGetSeconds();
}

function Manager (UWindowWindow _pCurrentWidget)
{
	local float elapsedTime;

	if ( m_bWaitingForBeacon )
	{
		if ( m_GameService.m_ClientBeacon.PreJoinInfo.bResponseRcvd )
		{
			m_bWaitingForBeacon=False;
/*			if ( Root.Console.ViewportOwner.Actor.GetGameVersion() != m_GameService.m_ClientBeacon.PreJoinInfo.szGameVersion )
			{
				m_pPleaseWait.HideWindow();
				DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_BadVersion","R6Menu"),27);
			}
			else
			{
				if ( m_GameService.m_ClientBeacon.PreJoinInfo.iNumPlayers >= m_GameService.m_ClientBeacon.PreJoinInfo.iMaxPlayers )
				{
					m_pPleaseWait.HideWindow();
					DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_ServerFull","R6Menu"),27);
				}
				else
				{
					m_bRoomValid=(m_GameService.m_ClientBeacon.PreJoinInfo.iLobbyID != 0) && (m_GameService.m_ClientBeacon.PreJoinInfo.iGroupID != 0);
					_pCurrentWidget.SendMessage(8);
					HideWindow();
				}
			}*/
		}
		else
		{
			elapsedTime=m_GameService.NativeGetSeconds() - m_fBeaconTime;
			if ( elapsedTime > 5.00 )
			{
				m_bWaitingForBeacon=False;
				if ( R6Console(Root.Console).m_bNonUbiMatchMaking )
				{
//					_pCurrentWidget.SendMessage(10);
				}
				else
				{
					m_pPleaseWait.HideWindow();
//					DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_NoServer","R6Menu"),27);
				}
			}
		}
	}
}

function PopUpBoxCreate ()
{
	local R6WindowEditBox pR6EditBoxTemp;
	local R6WindowTextLabel pR6TextLabelTemp;

	Super.PopUpBoxCreate();
	m_pPleaseWait=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pPleaseWait.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Wait","R6Menu"),30.00,205.00,170.00,230.00,50.00,2);
	m_pPleaseWait.CreateClientWindow(Class'R6WindowTextLabel');
//	m_pPleaseWait.m_ePopUpID=26;
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
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	if ( Result == 3 )
	{
		switch (_ePopUpID)
		{
/*			case 26:
			case 27:
			if ( R6Console(Root.Console).m_bNonUbiMatchMaking )
			{
				Root.ChangeCurrentWidget(37);
			}
			else
			{
				m_pPleaseWait.HideWindow();
				m_pError.HideWindow();
				m_pSendMessageDest.SendMessage(9);
				m_GameService.m_szLastServerQueried="0";
				HideWindow();
			}
			break;
			default:*/
		}
	}
}
