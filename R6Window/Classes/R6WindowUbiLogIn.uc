//================================================================================
// R6WindowUbiLogIn.
//================================================================================
class R6WindowUbiLogIn extends R6WindowMPManager;

var R6WindowPopUpBox m_pR6UbiAccount;
var R6WindowPopUpBox m_pDisconnected;
var R6GSServers m_GameService;
var UWindowWindow m_pSendMessageDest;

function StartLogInProcedure (UWindowWindow _pCurrentWidget)
{
	if ( m_GameService.m_eMSClientInitRequest != 0 )
	{
		return;
	}
	m_pR6UbiAccount.HideWindow();
	m_pDisconnected.HideWindow();
	m_pError.HideWindow();
//	m_GameService.m_eMenuLoginMasterSvr=0;
	m_pSendMessageDest=_pCurrentWidget;
/*	if (  !m_GameService.NativeGetLoggedInUbiDotCom() )
	{
		ShowWindow();
		R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea).m_pPassword.SetValue(m_GameService.m_szSavedPwd);
		R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea).m_pUserName.SetValue(m_GameService.m_szUserID);
		m_pR6UbiAccount.ShowWindow();
		R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea).m_pUserName.EditBox.LMouseDown(0.00,0.00);
	}
	else
	{
		m_pSendMessageDest.SendMessage(2);
	}*/
}

function LogInAfterDisconnect (UWindowWindow _pCurrentWidget)
{
	m_pSendMessageDest=_pCurrentWidget;
	ShowWindow();
	m_pDisconnected.ShowWindow();
}

function Manager (UWindowWindow _pCurrentWidget)
{
/*	local R6WindowTextLabel pR6TextLabelTemp;

	m_pSendMessageDest=_pCurrentWidget;
	switch (m_GameService.m_eMenuLoginMasterSvr)
	{
		case 2:
		m_pR6UbiAccount.HideWindow();
		m_pDisconnected.HideWindow();
		HideWindow();
		m_GameService.m_eMenuLoginMasterSvr=0;
		m_GameService.SaveConfig();
		_pCurrentWidget.SendMessage(0);
		break;
		case 3:
		switch (m_GameService.m_eMenuLogMasSvrFailReason)
		{
			case 2:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_PassWd","R6Menu"),14);
			break;
			case 5:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_UserID","R6Menu"),14);
			break;
			case 4:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_IdInUse","R6Menu"),14);
			break;
			case 11:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_DataBase","R6Menu"),14);
			break;
			case 12:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_Banned","R6Menu"),14);
			break;
			case 13:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_Blocked","R6Menu"),14);
			break;
			case 14:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_Locked","R6Menu"),14);
			break;
			default:
			DisplayErrorMsg(Localize("MultiPlayer","PopUp_Error_Default","R6Menu"),14);
			break;
		}
		m_GameService.m_eMenuLoginMasterSvr=0;
		break;
		default:
	}*/
}

function PopUpBoxCreate ()
{
	local R6WindowUbiLoginClient pR6LoginClientTemp;
	local R6WindowWrappedTextArea pTextZone;
	local float fX;
	local float fY;
	local float fWidth;
	local float fHeight;
	local float fTextHeight;

	Super.PopUpBoxCreate();
	fTextHeight=30.00;
	fX=160.00;
	fY=140.00;
	fWidth=300.00;
	fHeight=118.00;
	m_pR6UbiAccount=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pR6UbiAccount.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_UbiComUser","R6Menu"),fTextHeight,fX,fY,fWidth,fHeight);
	m_pR6UbiAccount.CreateClientWindow(Root.MenuClassDefines.ClassUbiLoginClient);
//	m_pR6UbiAccount.m_ePopUpID=13;
	pR6LoginClientTemp=R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea);
	pR6LoginClientTemp.SetupClientWindow(fWidth);
	pR6LoginClientTemp.m_pPassword.SetValue(m_GameService.m_szSavedPwd);
	pR6LoginClientTemp.m_pUserName.SetValue(m_GameService.m_szUserID);
	pR6LoginClientTemp.m_pSavePassword.SetButtonBox(m_GameService.m_bSavePWSave);
	pR6LoginClientTemp.m_pAutoLogIn.SetButtonBox(m_GameService.m_bAutoLISave);
	pR6LoginClientTemp.m_pAutoLogIn.bDisabled= !pR6LoginClientTemp.m_pSavePassword.m_bSelected;
	m_pR6UbiAccount.HideWindow();
	fTextHeight=30.00;
	fX=205.00;
	fY=170.00;
	fWidth=230.00;
	fHeight=77.00;
	m_pDisconnected=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_pDisconnected.CreateStdPopUpWindow(Localize("MultiPlayer","PopUp_Error_Title","R6Menu"),fTextHeight,fX,fY,fWidth,fHeight);
	m_pDisconnected.CreateClientWindow(Class'R6WindowWrappedTextArea');
//	m_pDisconnected.m_ePopUpID=15;
	pTextZone=R6WindowWrappedTextArea(m_pDisconnected.m_ClientArea);
	pTextZone.SetScrollable(True);
	pTextZone.m_fXOffSet=5.00;
	pTextZone.m_fYOffSet=5.00;
	pTextZone.AddText(Localize("MultiPlayer","PopUp_Reconnect","R6Menu"),Root.Colors.BlueLight,Root.Fonts[6]);
	pTextZone.m_bDrawBorders=False;
	m_pDisconnected.HideWindow();
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
/*	if ( Result == 3 )
	{
		switch (_ePopUpID)
		{
			case 13:
			m_GameService.SetUbiAccount(R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea).m_pUserName.GetValue(),R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea).m_pPassword.GetValue());
			m_GameService.m_bUbiAccntInfoEntered=True;
			if ( R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea).m_pSavePassword.m_bSelected )
			{
				m_GameService.m_szSavedPwd=m_GameService.m_szPassword;
			}
			else
			{
				m_GameService.m_szSavedPwd="";
			}
			m_GameService.m_bSavePWSave=R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea).m_pSavePassword.m_bSelected;
			m_GameService.m_bAutoLISave=R6WindowUbiLoginClient(m_pR6UbiAccount.m_ClientArea).m_pAutoLogIn.m_bSelected;
			if (  !m_GameService.NativeGetMSClientInitialized() )
			{
				m_GameService.InitializeMSClient();
			}
			m_pR6UbiAccount.ShowWindow();
			break;
			case 14:
			break;
			case 15:
			if (  !m_GameService.NativeGetMSClientInitialized() )
			{
				m_GameService.InitializeMSClient();
			}
			m_pDisconnected.ShowWindow();
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
				case 14:
				m_pError.HideWindow();
				break;
				case 13:
				case 15:
				HideWindow();
				m_pSendMessageDest.SendMessage(1);
				break;
				default:
			}
		}
	}*/
}

function ShowWindow ()
{
	bAlwaysAcceptsFocus=True;
	Super.ShowWindow();
}

function HideWindow ()
{
	bAlwaysAcceptsFocus=False;
	Super.HideWindow();
}
