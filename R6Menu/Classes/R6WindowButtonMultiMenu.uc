//================================================================================
// R6WindowButtonMultiMenu.
//================================================================================
class R6WindowButtonMultiMenu extends R6WindowButton;

var EButtonName m_eButton_Action;
var bool m_bButtonIsReady;
var Texture m_TOverButton;
var Region m_ROverButtonFade;
var Region m_ROverButton;

function BeforePaint (Canvas C, float X, float Y)
{
	if ( m_pPreviousButtonPos != None )
	{
		if (  !m_bSetParam )
		{
			WinLeft=m_pPreviousButtonPos.WinLeft + m_pPreviousButtonPos.m_textSize + (620 - m_pRefButtonPos.m_fTotalButtonsSize) * 0.25;
			m_pPreviousButtonPos=None;
			m_bButtonIsReady=True;
		}
	}
	else
	{
		m_bButtonIsReady=True;
	}
	Super.BeforePaint(C,X,Y);
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_bButtonIsReady )
	{
		Super.Paint(C,X,Y);
	}
}

simulated function Click (float X, float Y)
{
	local R6MenuMPCreateGameTabOptions pCreateTabOptions;
	local R6MenuRootWindow r6Root;
	local R6MenuMPManageTab pFirstTabManager;
	local R6LanServers pLanServers;
	local R6GSServers pGameService;
	local R6WindowListGeneral pListGen;
	local R6MenuMPCreateGameWidget pCreateGW;
	local bool bInternetServer;

	Super.Click(X,Y);
	r6Root=R6MenuRootWindow(Root);
	if ( bDisabled )
	{
		return;
	}
	switch (m_eButton_Action)
	{
/*		case 29:
		R6MenuMultiPlayerWidget(OwnerWindow).m_LoginSuccessAction=6;
		R6MenuMultiPlayerWidget(OwnerWindow).m_pLoginWindow.StartLogInProcedure(OwnerWindow);
		SetButLogInOutState(30);
		break;
		case 30:
		R6MenuMultiPlayerWidget(OwnerWindow).m_GameService.UnInitializeMSClient();
		pFirstTabManager=R6MenuMultiPlayerWidget(OwnerWindow).m_pFirstTabManager;
		pFirstTabManager.m_pMainTabControl.GotoTab(pFirstTabManager.m_pMainTabControl.GetTab(Localize("MultiPlayer","Tab_LanServer","R6Menu")));
		R6MenuMultiPlayerWidget(OwnerWindow).m_GameService.m_GameServerList.Remove (0,R6MenuMultiPlayerWidget(OwnerWindow).m_GameService.m_GameServerList.Length);
		R6MenuMultiPlayerWidget(OwnerWindow).m_GameService.m_GSLSortIdx.Remove (0,R6MenuMultiPlayerWidget(OwnerWindow).m_GameService.m_GSLSortIdx.Length);
		SetButLogInOutState(29);
		break;
		case 31:
		R6MenuMultiPlayerWidget(OwnerWindow).JoinSelectedServerRequested();
		break;
		case 32:
		R6MenuMultiPlayerWidget(OwnerWindow).m_pJoinIPWindow.StartJoinIPProcedure(self,R6MenuMultiPlayerWidget(OwnerWindow).m_szPopUpIP);
		R6MenuMultiPlayerWidget(OwnerWindow).m_bJoinIPInProgress=True;
		break;
		case 33:
		R6MenuMultiPlayerWidget(OwnerWindow).Refresh(True);
		break;
		case 34:
//		r6Root.ChangeCurrentWidget(19);
		break;
		case 35:
		if ( R6Console(Root.Console).m_bNonUbiMatchMakingHost )
		{
//			r6Root.ChangeCurrentWidget(37);
		}
		else
		{
//			r6Root.ChangeCurrentWidget(15);
		}
		break;
		case 36:
		pCreateGW=R6MenuMPCreateGameWidget(OwnerWindow);
		pCreateTabOptions=pCreateGW.m_pCreateTabOptions;
		pListGen=R6WindowListGeneral(pCreateTabOptions.GetList(pCreateTabOptions.GetCurrentGameMode(),pCreateTabOptions.1));
		if (  !pCreateTabOptions.IsAdminPasswordValid() )
		{
			r6Root.SimplePopUp(Localize("MultiPlayer","Popup_Error_Title","R6Menu"),Localize("MultiPlayer","PopUp_Error_InvalidAdminPwrd","R6Menu"),25,2);
			return;
		}
		pCreateTabOptions.FillSelectedMapList();
		if ( pCreateTabOptions.m_SelectedMapList.Length <= 0 )
		{
			r6Root.SimplePopUp(Localize("MultiPlayer","Popup_Error_Title","R6Menu"),Localize("MultiPlayer","PopUp_Error_NoMapSelected","R6Menu"),25,2);
		}
		else
		{
			if (  !R6Console(Root.Console).m_bStartedByGSClient && (pCreateTabOptions.m_pServerNameEdit.GetValue() == "") )
			{
				r6Root.SimplePopUp(Localize("MultiPlayer","Popup_Error_Title","R6Menu"),Localize("MultiPlayer","PopUp_Error_NoServerName","R6Menu"),25,2);
			}
			else
			{
				if ( R6Console(Root.Console).m_bStartedByGSClient || R6Console(Root.Console).m_bNonUbiMatchMakingHost )
				{
					pCreateGW.m_pCDKeyCheckWindow.StartPreJoinProcedure(OwnerWindow);
					pCreateGW.m_bPreJoinInProgress=True;
				}
				else
				{
					if ( bool(pCreateTabOptions.m_pButtonsDef.GetButtonComboValue(pCreateTabOptions.9,pListGen)) &&  !pCreateTabOptions.m_pButtonsDef.GetButtonBoxValue(pCreateTabOptions.10,pListGen) )
					{
						R6Console(Root.Console).szStoreGamePassWd=pCreateTabOptions.GetCreateGamePassword();
						pCreateGW.m_pLoginWindow.StartLogInProcedure(OwnerWindow);
						pCreateGW.m_bLoginInProgress=True;
					}
					else
					{
						if (  !pCreateTabOptions.m_pButtonsDef.GetButtonBoxValue(pCreateTabOptions.10,pListGen) )
						{
							pCreateGW.m_pCDKeyCheckWindow.StartPreJoinProcedure(OwnerWindow);
							pCreateGW.m_bPreJoinInProgress=True;
						}
						else
						{
							pCreateGW.LaunchServer();
						}
					}
				}
			}
		}
		break;
		case 38:
//		r6Root.ChangeCurrentWidget(20);
		R6Console(Root.Console).m_bReturnToGSClient=True;
		break;
		default:
		Log("Button not supported");
		break;*/
	}
}

function SetButLogInOutState (EButtonName _eNewButtonState)
{
	Text=R6MenuButtonsDefines(GetButtonsDefinesUnique(Root.MenuClassDefines.ClassButtonsDefines)).GetButtonLoc(_eNewButtonState);
	ToolTipString=R6MenuButtonsDefines(GetButtonsDefinesUnique(Root.MenuClassDefines.ClassButtonsDefines)).GetButtonLoc(_eNewButtonState,True);
	m_eButton_Action=_eNewButtonState;
	ResizeToText();
}

defaultproperties
{
    m_ROverButtonFade=(X=16261638,Y=570687488,W=6,H=860675)
    m_ROverButton=(X=16589318,Y=570687488,W=2,H=860675)
    bStretched=True
}
/*
    m_TOverButton=Texture'R6MenuTextures.Gui_BoxScroll'
*/

