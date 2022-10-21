//================================================================================
// R6MenuMPCreateGameTabOptions.
//================================================================================
class R6MenuMPCreateGameTabOptions extends R6MenuMPCreateGameTab;

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

var bool m_bBkpCamFadeToBk;
var bool m_bBkpCamFirstPerson;
var bool m_bBkpCamThirdPerson;
var bool m_bBkpCamFreeThirdP;
var bool m_bBkpCamGhost;
var bool m_bBkpCamTeamOnly;
var bool m_bBkpTKPenalty;
var R6WindowTextLabelExt m_pOptionsText;
var R6WindowComboControl m_pOptionsGameMode;
var R6WindowEditControl m_pServerNameEdit;
var R6WindowButton m_pOptionsWelcomeMsg;
var R6WindowPopUpBox m_pMsgOfTheDayPopUp;
var array<string> m_SelectedMapList;
var array<ER6GameType> m_SelectedModeList;
var string m_szMsgOfTheDay;

function Created ()
{
	Super.Created();
}

function InitMod ()
{
	if ( m_bInitComplete )
	{
		UpdateAllMapList();
	}
}

function InitOptionsTab (optional bool _bInGame)
{
	local stServerGameOpt stNewSGOItem;
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local float fSizeOfCounter;
	local int i;

	m_bInGame=_bInGame;
	m_pOptionsText=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,2.00 * 310,WinHeight,self));
	m_pOptionsText.bAlwaysBehind=True;
	m_pOptionsText.ActiveBorder(0,False);
	m_pOptionsText.ActiveBorder(1,False);
	m_pOptionsText.SetBorderParam(2,310.00,1.00,1.00,Root.Colors.White);
	m_pOptionsText.ActiveBorder(3,False);
	m_pOptionsText.m_Font=Root.Fonts[5];
	m_pOptionsText.m_vTextColor=Root.Colors.White;
	fXOffset=5.00;
	fYOffset=5.00;
	fWidth=310.00;
	fYStep=17.00;
//	m_pOptionsText.AddTextLabel(Localize("MPCreateGame","Options_GameMode","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fXOffset=310.00 + 5;
	fYOffset=165.00;
//	m_pOptionsText.AddTextLabel(Localize("MPCreateGame","Options_DeathCam","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fXOffset=310.00 * 0.50 + 10;
	fYOffset=5.00;
	fWidth=310.00 * 0.50 - 20;
	m_pOptionsGameMode=R6WindowComboControl(CreateControl(Class'R6WindowComboControl',fXOffset,fYOffset,fWidth,LookAndFeel.Size_ComboHeight));
	m_pOptionsGameMode.SetEditBoxTip(Localize("Tip","Options_GameMode","R6Menu"));
	m_pOptionsGameMode.EditBoxWidth=m_pOptionsGameMode.WinWidth - m_pOptionsGameMode.Button.WinWidth;
	m_pOptionsGameMode.SetFont(6);
	m_pOptionsGameMode.AddItem(Caps(m_ALocGameMode[0]),string(m_ANbOfGameMode[0]));
	m_pOptionsGameMode.AddItem(Caps(m_ALocGameMode[1]),string(m_ANbOfGameMode[1]));
	fXOffset=5.00;
	fWidth=310.00 - fXOffset - 10;
	fHeight=15.00;
	if (  !R6Console(Root.Console).m_bStartedByGSClient )
	{
		fYOffset += fYStep;
		m_pServerNameEdit=R6WindowEditControl(CreateControl(Class'R6WindowEditControl',fXOffset,fYOffset,fWidth,fHeight,self));
		m_pServerNameEdit.SetValue("");
		m_pServerNameEdit.CreateTextLabel(Localize("MPCreateGame","Options_ServerName","R6Menu"),0.00,0.00,fWidth * 0.50,fHeight);
		m_pServerNameEdit.SetEditBoxTip(Localize("Tip","Options_ServerName","R6Menu"));
		m_pServerNameEdit.ModifyEditBoxW(160.00,0.00,135.00,fHeight);
		m_pServerNameEdit.EditBox.MaxLength=R6Console(Root.Console).m_GameService.GetMaxUbiServerNameSize();
		m_pServerNameEdit.SetEditControlStatus(_bInGame);
		fYOffset += fYStep;
		InitPassword(fXOffset,fYOffset,fWidth,fHeight);
	}
	fYOffset += fYStep;
	InitAdminPassword(fXOffset,fYOffset,fWidth,fHeight);
	fYOffset += fYStep;
	fWidth=310.00 - fXOffset - 10;
	fHeight=227.00;
	i=0;
JL0534:
	if ( i < m_ANbOfGameMode.Length )
	{
//		CreateListOfButtons(fXOffset,fYOffset,fWidth,fHeight,m_ANbOfGameMode[i],1);
		i++;
		goto JL0534;
	}
	fXOffset=5.00 + 310;
	fYOffset=180.00;
	fHeight=100.00;
	i=0;
JL05A6:
	if ( i < m_ANbOfGameMode.Length )
	{
//		CreateListOfButtons(fXOffset,fYOffset,fWidth,fHeight,m_ANbOfGameMode[i],2);
		i++;
		goto JL05A6;
	}
	InitAllMapList();
	if (  !_bInGame )
	{
		InitEditMsgButton();
	}
	SetCurrentGameMode(m_ANbOfGameMode[0]);
	RefreshServerOpt();
	m_bInitComplete=True;
}

function InitPassword (float _fX, float _fY, float _fW, float _fH)
{
	local R6WindowButtonAndEditBox pButton;
	local stServerGameOpt stNewSGOItem;
	local int i;

	i=0;
JL0007:
	if ( i < m_ANbOfGameMode.Length )
	{
		pButton=CreateButAndEditBox(_fX,_fY,_fW,_fH,Localize("MPCreateGame","Options_Password","R6Menu"),Localize("Tip","Options_UsePass","R6Menu"),Localize("Tip","Options_UsePassEdit","R6Menu"));
		stNewSGOItem.pGameOptList=pButton;
		stNewSGOItem.eGameMode=m_ANbOfGameMode[i];
//		stNewSGOItem.eCGWindowID=4;
		AddWindowInCreateGameArray(stNewSGOItem);
		i++;
		goto JL0007;
	}
}

function InitAdminPassword (float _fX, float _fY, float _fW, float _fH)
{
	local R6WindowButtonAndEditBox pButton;
	local stServerGameOpt stNewSGOItem;
	local int i;

	i=0;
JL0007:
	if ( i < m_ANbOfGameMode.Length )
	{
		pButton=CreateButAndEditBox(_fX,_fY,_fW,_fH,Localize("MPCreateGame","Options_AdminPwd","R6Menu"),Localize("Tip","Options_AdminPwd","R6Menu"),Localize("Tip","Options_AdminPwdEdit","R6Menu"));
		stNewSGOItem.pGameOptList=pButton;
		stNewSGOItem.eGameMode=m_ANbOfGameMode[i];
//		stNewSGOItem.eCGWindowID=5;
		AddWindowInCreateGameArray(stNewSGOItem);
		i++;
		goto JL0007;
	}
}

function InitAllMapList ()
{
	local R6MenuMapList pMapList;
	local stServerGameOpt stNewSGOItem;
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local int i;

	fXOffset=310.00;
	fYOffset=5.00;
	fWidth=310.00;
	fHeight=155.00;
	i=0;
JL0033:
	if ( i < m_ANbOfGameMode.Length )
	{
		pMapList=R6MenuMapList(CreateWindow(Class'R6MenuMapList',fXOffset,fYOffset,fWidth,fHeight,self));
		pMapList.m_bInGame=m_bInGame;
		pMapList.m_szLocGameMode=Caps(m_ALocGameMode[i]);
//		pMapList.m_eMyGameMode=m_ANbOfGameMode[i];
		stNewSGOItem.pGameOptList=pMapList;
		stNewSGOItem.eGameMode=m_ANbOfGameMode[i];
//		stNewSGOItem.eCGWindowID=3;
		AddWindowInCreateGameArray(stNewSGOItem);
		i++;
		goto JL0033;
	}
}

function UpdateButtons (EGameModeInfo _eGameMode, eCreateGameWindow_ID _eCGWindowID, optional bool _bUpdateValue)
{
	local R6WindowListGeneral pTempList;
	local R6ServerInfo pServerInfo;

	pTempList=R6WindowListGeneral(GetList(_eGameMode,_eCGWindowID));
	if ( pTempList == None )
	{
		return;
	}
	if ( _bUpdateValue )
	{
		pServerInfo=Class'Actor'.static.GetServerOptions();
	}
	switch (_eGameMode)
	{
		case m_ANbOfGameMode[0]:
		switch (_eCGWindowID)
		{
/*			case 1:
			if ( _bUpdateValue )
			{
				m_pButtonsDef.ChangeButtonComboValue(9,string(pServerInfo.InternetServer),pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(1,pServerInfo.RoundsPerMatch,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(2,pServerInfo.RoundTime / 60,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(7,pServerInfo.BetweenRoundTime,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(3,pServerInfo.MaxPlayers,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(4,pServerInfo.BombTime,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(10,pServerInfo.DedicatedServer,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(11,pServerInfo.FriendlyFire,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(14,pServerInfo.TeamKillerPenalty,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(13,pServerInfo.Autobalance,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(15,pServerInfo.AllowRadar,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(12,pServerInfo.ShowNames,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(18,pServerInfo.ForceFPersonWeapon,pTempList);
				UpdateMenuOptions(11,pServerInfo.FriendlyFire,pTempList);
			}
			else
			{
				if (  !R6Console(Root.Console).m_bStartedByGSClient &&  !R6Console(Root.Console).m_bNonUbiMatchMakingHost )
				{
					m_pButtonsDef.AddButtonCombo(9,pTempList,self);
					m_pButtonsDef.AddItemInComboButton(9,Localize("MPCreateGame","Options_ServerLocationINT","R6Menu"),string(True),pTempList);
					m_pButtonsDef.AddItemInComboButton(9,Localize("MPCreateGame","Options_ServerLocationLAN","R6Menu"),string(False),pTempList);
				}
				m_pButtonsDef.AddButtonInt(1,1,20,10,pTempList,self);
				m_pButtonsDef.AddButtonInt(2,1,15,3,pTempList,self);
				m_pButtonsDef.AddButtonInt(7,10,99,15,pTempList,self);
				m_pButtonsDef.SetButtonCounterUnlimited(7,True,pTempList);
				m_pButtonsDef.AddButtonInt(4,30,60,35,pTempList,self);
				if (  !R6Console(Root.Console).m_bStartedByGSClient )
				{
					m_pButtonsDef.AddButtonInt(3,1,16,16,pTempList,self);
					if (  !R6Console(Root.Console).m_bNonUbiMatchMakingHost )
					{
						m_pButtonsDef.AddButtonBool(10,False,pTempList,self);
					}
				}
				m_pButtonsDef.AddButtonBool(11,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(14,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(13,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(15,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(12,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(18,True,pTempList,self);
			}
			break;
			case 2:
			if ( _bUpdateValue )
			{
				UpdateCamera(27,pServerInfo.CamFadeToBlack,False,pTempList);
				UpdateCamera(23,pServerInfo.CamFirstPerson,False,pTempList,True);
				UpdateCamera(24,pServerInfo.CamThirdPerson,False,pTempList,True);
				UpdateCamera(25,pServerInfo.CamFreeThirdP,False,pTempList,True);
				UpdateCamera(26,pServerInfo.CamGhost,False,pTempList,True);
				UpdateCamera(28,pServerInfo.CamTeamOnly,False,pTempList,True);
				UpdateCamSpecialCase(pServerInfo.CamTeamOnly,False);
				UpdateCamSpecialCase(pServerInfo.CamFadeToBlack,True);
			}
			else
			{
				m_pButtonsDef.AddButtonBool(27,False,pTempList,self);
				m_pButtonsDef.AddButtonBool(23,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(24,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(25,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(26,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(28,True,pTempList,self);
			}
			break;
			default:
			break;*/
		}
		break;
		case m_ANbOfGameMode[1]:
		switch (_eCGWindowID)
		{
/*			case 1:
			if ( _bUpdateValue )
			{
				m_pButtonsDef.ChangeButtonComboValue(9,string(pServerInfo.InternetServer),pTempList);
				m_pButtonsDef.ChangeButtonComboValue(22,string(pServerInfo.DiffLevel),pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(6,pServerInfo.RoundsPerMatch,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(2,pServerInfo.RoundTime / 60,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(7,pServerInfo.BetweenRoundTime,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(3,pServerInfo.MaxPlayers,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(8,pServerInfo.NbTerro,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(10,pServerInfo.DedicatedServer,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(17,pServerInfo.AIBkp,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(16,pServerInfo.RotateMap,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(11,pServerInfo.FriendlyFire,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(15,pServerInfo.AllowRadar,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(12,pServerInfo.ShowNames,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(18,pServerInfo.ForceFPersonWeapon,pTempList);
			}
			else
			{
				if (  !R6Console(Root.Console).m_bStartedByGSClient &&  !R6Console(Root.Console).m_bNonUbiMatchMakingHost )
				{
					m_pButtonsDef.AddButtonCombo(9,pTempList,self);
					m_pButtonsDef.AddItemInComboButton(9,Localize("MPCreateGame","Options_ServerLocationINT","R6Menu"),string(True),pTempList);
					m_pButtonsDef.AddItemInComboButton(9,Localize("MPCreateGame","Options_ServerLocationLAN","R6Menu"),string(False),pTempList);
				}
				m_pButtonsDef.AddButtonCombo(22,pTempList,self);
				m_pButtonsDef.AddItemInComboButton(22,Localize("SinglePlayer","Difficulty1","R6Menu"),string(1),pTempList);
				m_pButtonsDef.AddItemInComboButton(22,Localize("SinglePlayer","Difficulty2","R6Menu"),string(2),pTempList);
				m_pButtonsDef.AddItemInComboButton(22,Localize("SinglePlayer","Difficulty3","R6Menu"),string(3),pTempList);
				m_pButtonsDef.ChangeButtonComboValue(22,"1",pTempList);
				m_pButtonsDef.AddButtonInt(6,1,20,10,pTempList,self);
				m_pButtonsDef.AddButtonInt(2,1,60,3,pTempList,self);
				m_pButtonsDef.AddButtonInt(7,10,99,15,pTempList,self);
				m_pButtonsDef.SetButtonCounterUnlimited(7,True,pTempList);
				m_pButtonsDef.AddButtonInt(8,5,40,32,pTempList,self);
				if (  !R6Console(Root.Console).m_bStartedByGSClient )
				{
					m_pButtonsDef.AddButtonInt(3,1,8,8,pTempList,self);
					if (  !R6Console(Root.Console).m_bNonUbiMatchMakingHost )
					{
						m_pButtonsDef.AddButtonBool(10,False,pTempList,self);
					}
				}
				m_pButtonsDef.AddButtonBool(17,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(16,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(11,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(15,False,pTempList,self);
				m_pButtonsDef.AddButtonBool(12,False,pTempList,self);
				m_pButtonsDef.AddButtonBool(18,False,pTempList,self);
			}
			break;
			case 2:
			if ( _bUpdateValue )
			{
				UpdateCamera(23,pServerInfo.CamFirstPerson,False,pTempList);
				UpdateCamera(24,pServerInfo.CamThirdPerson,False,pTempList);
				UpdateCamera(25,pServerInfo.CamFreeThirdP,False,pTempList);
				UpdateCamera(26,pServerInfo.CamGhost,False,pTempList);
			}
			else
			{
				m_pButtonsDef.AddButtonBool(23,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(24,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(25,True,pTempList,self);
				m_pButtonsDef.AddButtonBool(26,True,pTempList,self);
			}
			break;
			default:
			break;*/
		}
		break;
		default:
		Log("UpdateButtons not a valid game mode");
		break;
	}
}

function InitEditMsgButton ()
{
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local float fHeight;

	fXOffset=310.00 + 10;
	fYOffset=WinHeight - 20;
	fWidth=310.00 - 20;
	fHeight=15.00;
	m_pOptionsWelcomeMsg=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pOptionsWelcomeMsg.SetButtonBorderColor(Root.Colors.White);
	m_pOptionsWelcomeMsg.m_bDrawBorders=True;
	m_pOptionsWelcomeMsg.m_bDrawSimpleBorder=True;
	m_pOptionsWelcomeMsg.TextColor=Root.Colors.White;
	m_pOptionsWelcomeMsg.align=ta_center;
	m_pOptionsWelcomeMsg.SetFont(6);
	m_pOptionsWelcomeMsg.SetText(Localize("MPCreateGame","EditWelcomeMsg","R6Menu"));
	m_pOptionsWelcomeMsg.ToolTipString=Localize("Tip","EditWelcomeMsg","R6Menu");
//	m_pOptionsWelcomeMsg.m_iButtonID=m_pButtonsDef.37;
}

function byte FillSelectedMapList ()
{
	local UWindowListBoxItem CurItem;
	local R6MenuMapList pCurrentMapList;
	local int i;

	m_SelectedMapList.Remove (0,m_SelectedMapList.Length);
//	pCurrentMapList=R6MenuMapList(GetList(GetCurrentGameMode(),3));
	if ( pCurrentMapList.m_pFinalMapList.Items.Next == None )
	{
		return 0;
	}
	CurItem=UWindowListBoxItem(pCurrentMapList.m_pFinalMapList.Items.Next);
	i=0;
JL0081:
	if ( CurItem != None )
	{
		m_SelectedMapList[i]=R6WindowListBoxItem(CurItem).m_szMisc;
//		m_SelectedModeList[i]=GetLevel().GetER6GameTypeFromLocName(CurItem.m_stSubText.szGameTypeSelect,True);
		CurItem=UWindowListBoxItem(CurItem.Next);
		i++;
		goto JL0081;
	}
	return i;
}

function PopUpMOTDEditionBox ()
{
	local R6WindowEditBox pR6EditBoxTemp;

	if ( m_pMsgOfTheDayPopUp == None )
	{
		m_pMsgOfTheDayPopUp=R6WindowPopUpBox(R6MenuMPCreateGameWidget(OwnerWindow).CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00,self));
		m_pMsgOfTheDayPopUp.CreateStdPopUpWindow(Localize("MPCreateGame","WelcomeMsg","R6Menu"),30.00,75.00,150.00,490.00,70.00);
		m_pMsgOfTheDayPopUp.CreateClientWindow(Class'R6WindowEditBox');
//		m_pMsgOfTheDayPopUp.m_ePopUpID=1;
		pR6EditBoxTemp=R6WindowEditBox(m_pMsgOfTheDayPopUp.m_ClientArea);
		pR6EditBoxTemp.SetValue(m_szMsgOfTheDay);
		pR6EditBoxTemp.TextColor=Root.Colors.BlueLight;
		pR6EditBoxTemp.SetFont(8);
		pR6EditBoxTemp.MaxLength=60;
	}
	else
	{
		pR6EditBoxTemp=R6WindowEditBox(m_pMsgOfTheDayPopUp.m_ClientArea);
		pR6EditBoxTemp.SetValue(m_szMsgOfTheDay);
		m_pMsgOfTheDayPopUp.ShowWindow();
	}
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	if ( Result == 3 )
	{
		if ( _ePopUpID == 1 )
		{
			m_szMsgOfTheDay=R6WindowEditBox(m_pMsgOfTheDayPopUp.m_ClientArea).GetValue();
			SetServerOptions();
		}
	}
}

function bool IsAdminPasswordValid ()
{
	local R6WindowButtonAndEditBox pAdminPassword;

//	pAdminPassword=R6WindowButtonAndEditBox(GetList(GetCurrentGameMode(),5));
	if ( pAdminPassword.m_bSelected )
	{
		if ( pAdminPassword.m_pEditBox.GetValue() == "" )
		{
			return False;
		}
	}
	return True;
}

function string GetCreateGamePassword ()
{
//	return R6WindowButtonAndEditBox(GetList(GetCurrentGameMode(),4)).m_pEditBox.GetValue();

// A enlever
    return "";
}

function UpdateCamera (int _iButtonID, bool _bValue, bool _bDisable, R6WindowListGeneral _pCamList, optional bool _bBackupValue)
{
	switch (_iButtonID)
	{
		case 27:
		m_pButtonsDef.ChangeButtonBoxValue(_iButtonID,_bValue,_pCamList);
		break;
		case 23:
		m_pButtonsDef.ChangeButtonBoxValue(_iButtonID,_bValue,_pCamList,_bDisable);
		if ( _bBackupValue )
		{
			m_bBkpCamFirstPerson=_bValue;
		}
		break;
		case 24:
		m_pButtonsDef.ChangeButtonBoxValue(_iButtonID,_bValue,_pCamList,_bDisable);
		if ( _bBackupValue )
		{
			m_bBkpCamThirdPerson=_bValue;
		}
		break;
		case 25:
		m_pButtonsDef.ChangeButtonBoxValue(_iButtonID,_bValue,_pCamList,_bDisable);
		if ( _bBackupValue )
		{
			m_bBkpCamFreeThirdP=_bValue;
		}
		break;
		case 26:
		m_pButtonsDef.ChangeButtonBoxValue(_iButtonID,_bValue,_pCamList,_bDisable);
		if ( _bBackupValue )
		{
			m_bBkpCamGhost=_bValue;
		}
		break;
		case 28:
		m_pButtonsDef.ChangeButtonBoxValue(_iButtonID,_bValue,_pCamList,_bDisable);
		if ( _bBackupValue )
		{
			m_bBkpCamTeamOnly=_bValue;
		}
		break;
		default:
	}
}

function bool GetCameraSelection (int _iButtonID, R6WindowListGeneral _pCameraList)
{
	local bool bSelection;

	if ( m_pButtonsDef.IsButtonBoxDisabled(_iButtonID,_pCameraList) )
	{
		switch (_iButtonID)
		{
			case 23:
			bSelection=m_bBkpCamFirstPerson;
			break;
			case 24:
			bSelection=m_bBkpCamThirdPerson;
			break;
			case 25:
			bSelection=m_bBkpCamFreeThirdP;
			break;
			case 26:
			bSelection=m_bBkpCamGhost;
			break;
			case 28:
			bSelection=m_bBkpCamTeamOnly;
			break;
			default:
		}
	}
	else
	{
		bSelection=m_pButtonsDef.GetButtonBoxValue(_iButtonID,_pCameraList);
	}
	return bSelection;
}

function UpdateCamSpecialCase (bool _bButtonSel, bool _bUpdateDeathCam)
{
	local bool bCamState;
	local bool bCamFirstPerson;
	local bool bCamThirdPerson;
	local bool bCamFreeThPerson;
	local bool bCamGhost;
	local bool bCanTeamOnly;
	local bool bCamGhostDis;
	local R6WindowListGeneral pCamList;

//	pCamList=R6WindowListGeneral(GetList(GetCurrentGameMode(),2));
	if ( _bUpdateDeathCam )
	{
		bCamState=_bButtonSel;
		bCamFirstPerson=False;
		bCamThirdPerson=False;
		bCamFreeThPerson=False;
		bCamGhost=False;
		bCanTeamOnly=False;
		if ( bCamState )
		{
			m_bBkpCamFirstPerson=m_pButtonsDef.GetButtonBoxValue(23,pCamList);
			m_bBkpCamThirdPerson=m_pButtonsDef.GetButtonBoxValue(24,pCamList);
			m_bBkpCamFreeThirdP=m_pButtonsDef.GetButtonBoxValue(25,pCamList);
			bCamGhostDis=m_pButtonsDef.IsButtonBoxDisabled(26,pCamList);
			if (  !bCamGhostDis )
			{
				m_bBkpCamGhost=m_pButtonsDef.GetButtonBoxValue(26,pCamList);
			}
			if ( GetCurrentGameMode() == m_ANbOfGameMode[0] )
			{
				m_bBkpCamTeamOnly=m_pButtonsDef.GetButtonBoxValue(28,pCamList);
			}
		}
		else
		{
			bCamFirstPerson=m_bBkpCamFirstPerson;
			bCamThirdPerson=m_bBkpCamThirdPerson;
			bCamFreeThPerson=m_bBkpCamFreeThirdP;
			bCamGhost=m_bBkpCamGhost;
			if ( GetCurrentGameMode() == m_ANbOfGameMode[0] )
			{
				bCamGhostDis=m_bBkpCamTeamOnly;
			}
			else
			{
				bCamGhostDis=False;
			}
			bCanTeamOnly=m_bBkpCamTeamOnly;
		}
		UpdateCamera(27,bCamState,False,pCamList);
		UpdateCamera(23,bCamFirstPerson,bCamState,pCamList);
		UpdateCamera(24,bCamThirdPerson,bCamState,pCamList);
		UpdateCamera(25,bCamFreeThPerson,bCamState,pCamList);
		if (  !bCamGhostDis )
		{
			UpdateCamera(26,bCamGhost,bCamState,pCamList);
		}
		if ( GetCurrentGameMode() == m_ANbOfGameMode[0] )
		{
			UpdateCamera(28,bCanTeamOnly,bCamState,pCamList);
		}
	}
	else
	{
		bCamState=_bButtonSel;
		bCamGhost=False;
		if ( bCamState )
		{
			m_bBkpCamGhost=m_pButtonsDef.GetButtonBoxValue(26,pCamList);
		}
		else
		{
			bCamGhost=m_bBkpCamGhost;
		}
		UpdateCamera(26,bCamGhost,bCamState,pCamList);
	}
}

function UpdateMenuOptions (int _iButID, bool _bNewValue, R6WindowListGeneral _pOptionsList, optional bool _bChangeByUserClick)
{
	local bool bButState;

	switch (_iButID)
	{
		case 27:
		UpdateCamSpecialCase(_bNewValue,True);
		break;
		case 28:
		UpdateCamSpecialCase(_bNewValue,False);
		break;
		case 11:
		bButState=False;
		if (  !m_bInitComplete )
		{
			m_bBkpTKPenalty=m_pButtonsDef.GetButtonBoxValue(14,_pOptionsList);
		}
		if ( _bNewValue )
		{
			bButState=m_bBkpTKPenalty;
		}
		else
		{
			if ( _bChangeByUserClick )
			{
				m_bBkpTKPenalty=m_pButtonsDef.GetButtonBoxValue(14,_pOptionsList);
			}
		}
		m_pButtonsDef.ChangeButtonBoxValue(14,bButState,_pOptionsList, !_bNewValue);
		break;
		default:
		break;
	}
}

function UpdateAllMapList ()
{
	local R6MenuMapList pTempList;
	local int i;

	i=0;
JL0007:
	if ( i < m_ANbOfGameMode.Length )
	{
//		pTempList=R6MenuMapList(GetList(m_ANbOfGameMode[i],3));
		if ( pTempList != None )
		{
			pTempList.FillMapListItem();
		}
		i++;
		goto JL0007;
	}
}

function RefreshServerOpt (optional bool _bNewServerProfile)
{
	local int iIndex;
	local R6ServerInfo pServerOpt;
	local R6MenuMapList pCurrentMapList;

	pServerOpt=Class'Actor'.static.GetServerOptions();
	m_bNewServerProfile=_bNewServerProfile;
	if ( m_bInitComplete )
	{
		UpdateAllMapList();
	}
	if ( _bNewServerProfile )
	{
//		pCurrentMapList=R6MenuMapList(GetList(GetCurrentGameMode(),3));
		m_pOptionsGameMode.SetValue(m_pOptionsGameMode.GetValue(),pCurrentMapList.GetNewServerProfileGameMode());
		ManageComboControlNotify(m_pOptionsGameMode);
	}
//	pCurrentMapList=R6MenuMapList(GetList(GetCurrentGameMode(),3));
	iIndex=m_pOptionsGameMode.FindItemIndex2(pCurrentMapList.FillFinalMapList());
	m_pOptionsGameMode.SetSelectedIndex(iIndex);
	if (  !R6Console(Root.Console).m_bStartedByGSClient )
	{
		m_pServerNameEdit.SetValue(pServerOpt.ServerName);
//		SetButtonAndEditBox(4,pServerOpt.GamePassword,pServerOpt.UsePassword);
	}
//	SetButtonAndEditBox(5,pServerOpt.AdminPassword,pServerOpt.UseAdminPassword);
	m_szMsgOfTheDay=Localize("MPCreateGame","Default_MsgOfTheDay","R6Menu");
	if ( pServerOpt.MOTD != "" )
	{
		m_szMsgOfTheDay=pServerOpt.MOTD;
	}
	Super.RefreshServerOpt();
	m_bNewServerProfile=False;
}

function SetServerOptions ()
{
	local UWindowWindow pCGWWindow;
	local R6WindowListGeneral pListGen;
	local int iCounter;
	local R6StartGameInfo StartGameInfo;
	local string szSvrName;
	local ER6GameType eGameType;
	local R6ServerInfo _ServerSettings;
	local R6MapList myList;
	local int iButtonValue;

	_ServerSettings=Class'Actor'.static.GetServerOptions();
	if ( _ServerSettings.m_ServerMapList == None )
	{
		_ServerSettings.m_ServerMapList=GetLevel().Spawn(Class'R6MapList');
	}
	if ( R6Console(Root.Console).m_bStartedByGSClient )
	{
		szSvrName=R6Console(Root.Console).m_GameService.m_szGSServerName;
	}
	else
	{
		szSvrName=m_pServerNameEdit.GetValue();
	}
	_ServerSettings.ServerName=szSvrName;
	if ( R6Console(Root.Console).m_bStartedByGSClient )
	{
		_ServerSettings.UsePassword=R6Console(Root.Console).m_GameService.m_szGSPassword != "";
		if ( _ServerSettings.UsePassword )
		{
			_ServerSettings.GamePassword=R6Console(Root.Console).m_GameService.m_szGSPassword;
		}
	}
	else
	{
//		pCGWWindow=GetList(GetCurrentGameMode(),4);
		_ServerSettings.UsePassword=R6WindowButtonAndEditBox(pCGWWindow).m_bSelected;
		_ServerSettings.GamePassword=R6WindowButtonAndEditBox(pCGWWindow).m_pEditBox.GetValue();
	}
//	pCGWWindow=GetList(GetCurrentGameMode(),5);
	_ServerSettings.UseAdminPassword=R6WindowButtonAndEditBox(pCGWWindow).m_bSelected;
	_ServerSettings.AdminPassword=R6WindowButtonAndEditBox(pCGWWindow).m_pEditBox.GetValue();
//	pListGen=R6WindowListGeneral(GetList(GetCurrentGameMode(),2));
	_ServerSettings.CamFirstPerson=GetCameraSelection(23,pListGen);
	_ServerSettings.CamThirdPerson=GetCameraSelection(24,pListGen);
	_ServerSettings.CamFreeThirdP=GetCameraSelection(25,pListGen);
	_ServerSettings.CamGhost=GetCameraSelection(26,pListGen);
	if ( m_pButtonsDef.FindButtonItem(27,pListGen) == None )
	{
		_ServerSettings.CamFadeToBlack=False;
	}
	else
	{
		_ServerSettings.CamFadeToBlack=GetCameraSelection(27,pListGen);
	}
	if ( m_pButtonsDef.FindButtonItem(28,pListGen) == None )
	{
		_ServerSettings.CamTeamOnly=False;
	}
	else
	{
		_ServerSettings.CamTeamOnly=GetCameraSelection(28,pListGen);
	}
//	pListGen=R6WindowListGeneral(GetList(GetCurrentGameMode(),1));
	if ( R6Console(Root.Console).m_bStartedByGSClient )
	{
		iButtonValue=R6Console(Root.Console).m_GameService.m_iGSNumPlayers;
	}
	else
	{
		iButtonValue=m_pButtonsDef.GetButtonCounterValue(3,pListGen);
	}
	if ( iButtonValue > 0 )
	{
		_ServerSettings.MaxPlayers=iButtonValue;
	}
	else
	{
		_ServerSettings.MaxPlayers=1;
	}
	if ( m_pButtonsDef.FindButtonItem(8,pListGen) != None )
	{
		_ServerSettings.NbTerro=m_pButtonsDef.GetButtonCounterValue(8,pListGen);
	}
	_ServerSettings.MOTD=m_szMsgOfTheDay;
	_ServerSettings.RoundTime=m_pButtonsDef.GetButtonCounterValue(2,pListGen) * 60;
	if ( GetCurrentGameMode() == m_ANbOfGameMode[0] )
	{
		_ServerSettings.RoundsPerMatch=m_pButtonsDef.GetButtonCounterValue(1,pListGen);
	}
	else
	{
		_ServerSettings.RoundsPerMatch=m_pButtonsDef.GetButtonCounterValue(6,pListGen);
	}
	_ServerSettings.BetweenRoundTime=m_pButtonsDef.GetButtonCounterValue(7,pListGen);
	if ( m_pButtonsDef.FindButtonItem(4,pListGen) != None )
	{
		_ServerSettings.BombTime=m_pButtonsDef.GetButtonCounterValue(4,pListGen);
	}
	if ( R6Console(Root.Console).m_bStartedByGSClient || R6Console(Root.Console).m_bNonUbiMatchMakingHost )
	{
		_ServerSettings.InternetServer=True;
	}
	else
	{
		_ServerSettings.InternetServer=bool(m_pButtonsDef.GetButtonComboValue(9,pListGen));
	}
	_ServerSettings.DedicatedServer=m_pButtonsDef.GetButtonBoxValue(10,pListGen);
	_ServerSettings.FriendlyFire=m_pButtonsDef.GetButtonBoxValue(11,pListGen);
	if ( m_pButtonsDef.FindButtonItem(14,pListGen) != None )
	{
		_ServerSettings.TeamKillerPenalty=m_pButtonsDef.GetButtonBoxValue(14,pListGen);
	}
	if ( m_pButtonsDef.FindButtonItem(17,pListGen) != None )
	{
		_ServerSettings.AIBkp=m_pButtonsDef.GetButtonBoxValue(17,pListGen);
	}
	if ( m_pButtonsDef.FindButtonItem(16,pListGen) != None )
	{
		_ServerSettings.RotateMap=m_pButtonsDef.GetButtonBoxValue(16,pListGen);
	}
	if ( m_pButtonsDef.FindButtonItem(13,pListGen) != None )
	{
		_ServerSettings.Autobalance=m_pButtonsDef.GetButtonBoxValue(13,pListGen);
	}
	_ServerSettings.ShowNames=m_pButtonsDef.GetButtonBoxValue(12,pListGen);
	_ServerSettings.ForceFPersonWeapon=m_pButtonsDef.GetButtonBoxValue(18,pListGen);
	_ServerSettings.AllowRadar=m_pButtonsDef.GetButtonBoxValue(15,pListGen);
	if ( m_pButtonsDef.FindButtonItem(22,pListGen) != None )
	{
		_ServerSettings.DiffLevel=int(m_pButtonsDef.GetButtonComboValue(22,pListGen));
	}
	FillSelectedMapList();
	if ( m_SelectedMapList.Length != 0 )
	{
		eGameType=m_SelectedModeList[0];
		StartGameInfo=R6Console(Root.Console).Master.m_StartGameInfo;
//		StartGameInfo.m_GameMode=GetLevel().GetGameTypeClassName(eGameType);
		myList=_ServerSettings.m_ServerMapList;
		iCounter=0;
JL089D:
		if ( iCounter < 32 )
		{
			myList.Maps[iCounter]="";
			myList.GameType[iCounter]="";
			iCounter++;
			goto JL089D;
		}
		iCounter=0;
JL08E8:
		if ( iCounter < m_SelectedMapList.Length )
		{
			myList.Maps[iCounter]=m_SelectedMapList[iCounter];
//			myList.GameType[iCounter]=GetLevel().GetGameTypeClassName(m_SelectedModeList[iCounter]);
			iCounter++;
			goto JL08E8;
		}
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	local bool bProcessNotify;

	if ( C.IsA('R6WindowButton') )
	{
		ManageR6ButtonNotify(C,E);
	}
	else
	{
		if ( E == 2 )
		{
			if ( C.IsA('R6WindowButtonBox') )
			{
				ManageR6ButtonBoxNotify(C);
				bProcessNotify=True;
			}
			else
			{
				if ( C.IsA('R6WindowButtonAndEditBox') )
				{
					ManageR6ButtonAndEditBoxNotify(C);
					bProcessNotify=True;
				}
			}
		}
		else
		{
			if ( E == 1 )
			{
				if ( C.IsA('UWindowComboControl') )
				{
					if (  !m_bNewServerProfile )
					{
						ManageComboControlNotify(C);
						bProcessNotify=True;
					}
				}
				else
				{
					if ( C.IsA('R6WindowButtonAndEditBox') || C.IsA('R6WindowEditControl') )
					{
						bProcessNotify=True;
					}
				}
			}
		}
	}
	if ( bProcessNotify && m_bInitComplete &&  !m_bNewServerProfile )
	{
		SetServerOptions();
	}
}

function ManageR6ButtonNotify (UWindowDialogControl C, byte E)
{
	Super.ManageR6ButtonNotify(C,E);
	if ( E == 2 )
	{
/*		if ( R6WindowButton(C).m_iButtonID == m_pButtonsDef.37 )
		{
			PopUpMOTDEditionBox();
		}*/
	}
}

function ManageComboControlNotify (UWindowDialogControl C)
{
	local string szTemp;
	local R6MenuMapList pCurrentMapList;

	if ( R6WindowComboControl(C) == m_pOptionsGameMode )
	{
		szTemp=m_pOptionsGameMode.GetValue2();
		switch (szTemp)
		{
/*			case string(m_ANbOfGameMode[0]):
			pCurrentMapList=R6MenuMapList(GetList(m_ANbOfGameMode[0],3));
			SetCurrentGameMode(m_ANbOfGameMode[0],True);
			break;
			case string(m_ANbOfGameMode[1]):
			pCurrentMapList=R6MenuMapList(GetList(m_ANbOfGameMode[1],3));
			SetCurrentGameMode(m_ANbOfGameMode[1],True);
			break;
			default:
			break;*/
		}
		pCurrentMapList.SetGameModeToDisplay(m_pOptionsGameMode.GetValue2());
	}
}
