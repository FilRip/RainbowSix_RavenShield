//================================================================================
// R6MenuMPServerOption.
//================================================================================
class R6MenuMPServerOption extends R6MenuMPCreateGameTabOptions;

var bool m_bServerSettingsChange;
var bool m_bImAnAdmin;
var UWindowWindow m_pServerOptFakeW;
var UWindowWindow m_pServerOptFakeW2;
var R6WindowTextLabel m_InTheReleaseLabel;

function Created ()
{
	Super.Created();
	Class'Actor'.static.GetModMgr().RegisterObject(self);
	m_pServerOptFakeW=CreateWindow(Class'UWindowWindow',0.00,0.00,WinWidth * 0.50,WinHeight,self);
	m_pServerOptFakeW.bAlwaysOnTop=True;
	m_pServerOptFakeW2=CreateWindow(Class'UWindowWindow',310.00,136.00,WinWidth * 0.50,WinHeight - 136,self);
	m_pServerOptFakeW2.bAlwaysOnTop=True;
	InitOptionsTab(True);
	Refresh();
}

function Refresh ()
{
/*	if ( R6PlayerController(GetPlayerOwner()).CheckAuthority(R6PlayerController(GetPlayerOwner()).1) )
	{
		if ( m_bImAnAdmin == False )
		{
			m_bImAnAdmin=True;
			R6PlayerController(GetPlayerOwner()).ServerPausePreGameRoundTime();
		}
		m_pServerOptFakeW.HideWindow();
		m_pServerOptFakeW2.HideWindow();
	}
	else
	{
		m_bImAnAdmin=False;
		m_pServerOptFakeW.ShowWindow();
		m_pServerOptFakeW2.ShowWindow();
	}*/
}

function RefreshServerOpt (optional bool _bNewServerProfile)
{
	local int iIndex;
	local R6GameReplicationInfo pGameRepInfo;
	local R6MenuMapList pCurrentMapList;

	Refresh();
	pGameRepInfo=R6GameReplicationInfo(R6MenuInGameMultiPlayerRootWindow(Root).m_R6GameMenuCom.m_GameRepInfo);
	if ( m_bInitComplete )
	{
		UpdateAllMapList();
	}
//	pCurrentMapList=R6MenuMapList(GetList(GetCurrentGameMode(),3));
	m_pOptionsGameMode.SetValue(m_pOptionsGameMode.GetValue(),pCurrentMapList.GetNewServerProfileGameMode(True));
	ManageComboControlNotify(m_pOptionsGameMode);
//	pCurrentMapList=R6MenuMapList(GetList(GetCurrentGameMode(),3));
	iIndex=m_pOptionsGameMode.FindItemIndex2(pCurrentMapList.FillFinalMapListInGame());
	m_pOptionsGameMode.SetSelectedIndex(iIndex);
	m_pOptionsGameMode.SetDisableButton(True);
	m_pServerNameEdit.SetValue(pGameRepInfo.ServerName);
//	SetButtonAndEditBox(4,"*******",pGameRepInfo.m_bPasswordReq);
//	R6WindowButtonAndEditBox(GetList(GetCurrentGameMode(),4)).SetDisableButtonAndEditBox(True);
//	SetButtonAndEditBox(5,"*******",pGameRepInfo.m_bAdminPasswordReq);
//	R6WindowButtonAndEditBox(GetList(GetCurrentGameMode(),5)).SetDisableButtonAndEditBox(True);
	m_szMsgOfTheDay=pGameRepInfo.MOTDLine1;
	RefreshCGButtons();
}

function UpdateButtons (EGameModeInfo _eGameMode, eCreateGameWindow_ID _eCGWindowID, optional bool _bUpdateValue)
{
	local R6WindowListGeneral pTempList;
	local R6GameReplicationInfo pR6GameRepInfo;

	if ( _bUpdateValue )
	{
		pTempList=R6WindowListGeneral(GetList(_eGameMode,_eCGWindowID));
		if ( pTempList == None )
		{
			return;
		}
		pR6GameRepInfo=R6GameReplicationInfo(R6MenuInGameMultiPlayerRootWindow(Root).m_R6GameMenuCom.m_GameRepInfo);
		switch (_eGameMode)
		{
			case m_ANbOfGameMode[0]:
			switch (_eCGWindowID)
			{
/*				case 1:
				m_pButtonsDef.ChangeButtonComboValue(9,string(pR6GameRepInfo.m_bInternetSvr),pTempList,True);
				m_pButtonsDef.ChangeButtonCounterValue(1,pR6GameRepInfo.m_iRoundsPerMatch,pTempList, !m_bImAnAdmin);
				m_pButtonsDef.ChangeButtonCounterValue(2,pR6GameRepInfo.TimeLimit / 60,pTempList, !m_bImAnAdmin);
				m_pButtonsDef.ChangeButtonCounterValue(7,pR6GameRepInfo.m_fTimeBetRounds,pTempList, !m_bImAnAdmin);
				m_pButtonsDef.ChangeButtonCounterValue(3,pR6GameRepInfo.m_MaxPlayers,pTempList, !m_bImAnAdmin);
				m_pButtonsDef.ChangeButtonCounterValue(4,pR6GameRepInfo.m_fBombTime,pTempList, !m_bImAnAdmin);
				m_pButtonsDef.ChangeButtonBoxValue(10,pR6GameRepInfo.m_bDedicatedSvr,pTempList,True);
				m_pButtonsDef.ChangeButtonBoxValue(11,pR6GameRepInfo.m_bFriendlyFire,pTempList);
				m_bBkpTKPenalty=pR6GameRepInfo.m_bMenuTKPenaltySetting;
				m_pButtonsDef.ChangeButtonBoxValue(14,pR6GameRepInfo.m_bMenuTKPenaltySetting,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(15,pR6GameRepInfo.m_bRepAllowRadarOption,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(12,pR6GameRepInfo.m_bShowNames,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(18,pR6GameRepInfo.m_bFFPWeapon,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(13,pR6GameRepInfo.m_bAutoBalance,pTempList);
				UpdateMenuOptions(11,pR6GameRepInfo.m_bFriendlyFire,pTempList);
				break;
				case 2:
				UpdateCamera(27,(pR6GameRepInfo.m_iDeathCameraMode & 16) > 0,False,pTempList);
				UpdateCamera(23,(pR6GameRepInfo.m_iDeathCameraMode & 1) > 0,False,pTempList,True);
				UpdateCamera(24,(pR6GameRepInfo.m_iDeathCameraMode & 2) > 0,False,pTempList,True);
				UpdateCamera(25,(pR6GameRepInfo.m_iDeathCameraMode & 4) > 0,False,pTempList,True);
				UpdateCamera(26,(pR6GameRepInfo.m_iDeathCameraMode & 8) > 0,False,pTempList,True);
				UpdateCamera(28,(pR6GameRepInfo.m_iDeathCameraMode & 32) > 0,False,pTempList,True);
				UpdateCamSpecialCase((pR6GameRepInfo.m_iDeathCameraMode & 32) > 0,False);
				UpdateCamSpecialCase((pR6GameRepInfo.m_iDeathCameraMode & 16) > 0,True);
				break;
				default:
				break;*/
			}
			break;
			case m_ANbOfGameMode[1]:
			switch (_eCGWindowID)
			{
/*				case 1:
				m_pButtonsDef.ChangeButtonComboValue(9,string(pR6GameRepInfo.m_bInternetSvr),pTempList,True);
				m_pButtonsDef.ChangeButtonComboValue(22,string(pR6GameRepInfo.m_iDiffLevel),pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(6,pR6GameRepInfo.m_iRoundsPerMatch,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(2,pR6GameRepInfo.TimeLimit / 60,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(7,pR6GameRepInfo.m_fTimeBetRounds,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(3,pR6GameRepInfo.m_MaxPlayers,pTempList);
				m_pButtonsDef.ChangeButtonCounterValue(8,pR6GameRepInfo.m_iNbOfTerro,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(10,pR6GameRepInfo.m_bDedicatedSvr,pTempList,True);
				m_pButtonsDef.ChangeButtonBoxValue(17,pR6GameRepInfo.m_bAIBkp,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(16,pR6GameRepInfo.m_bRotateMap,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(11,pR6GameRepInfo.m_bFriendlyFire,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(15,pR6GameRepInfo.m_bRepAllowRadarOption,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(12,pR6GameRepInfo.m_bShowNames,pTempList);
				m_pButtonsDef.ChangeButtonBoxValue(18,pR6GameRepInfo.m_bFFPWeapon,pTempList);
				break;
				case 2:
				UpdateCamera(23,(pR6GameRepInfo.m_iDeathCameraMode & 1) > 0,False,pTempList);
				UpdateCamera(24,(pR6GameRepInfo.m_iDeathCameraMode & 2) > 0,False,pTempList);
				UpdateCamera(25,(pR6GameRepInfo.m_iDeathCameraMode & 4) > 0,False,pTempList);
				UpdateCamera(26,(pR6GameRepInfo.m_iDeathCameraMode & 8) > 0,False,pTempList);
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
	else
	{
		Super.UpdateButtons(_eGameMode,_eCGWindowID,_bUpdateValue);
	}
}

function bool SendNewServerSettings ()
{
	local R6GameReplicationInfo pGameRepInfo;
	local R6PlayerController pPlayContr;
	local R6WindowListGeneral pTempButList;
	local R6WindowListGeneral pTempCamList;
	local int iTempValue;
	local bool bTempValue;
	local bool bSettingsChange;
	local bool bLogSettingsChange;

	if (  !m_bServerSettingsChange )
	{
		return False;
	}
//	pTempButList=R6WindowListGeneral(GetList(GetCurrentGameMode(),1));
//	pTempCamList=R6WindowListGeneral(GetList(GetCurrentGameMode(),2));
	pGameRepInfo=R6GameReplicationInfo(R6MenuInGameMultiPlayerRootWindow(Root).m_R6GameMenuCom.m_GameRepInfo);
	pPlayContr=R6PlayerController(GetPlayerOwner());
	if ( (pTempButList == None) || (pTempCamList == None) || (pGameRepInfo == None) || (pPlayContr == None) )
	{
		return False;
	}
	iTempValue=m_pButtonsDef.GetButtonCounterValue(2,pTempButList);
	if ( iTempValue != pGameRepInfo.TimeLimit / 60 )
	{
		bSettingsChange=True;
//		pPlayContr.ServerNewGeneralSettings(2,,iTempValue * 60);
	}
	iTempValue=m_pButtonsDef.GetButtonCounterValue(7,pTempButList);
	if ( iTempValue != pGameRepInfo.m_fTimeBetRounds )
	{
		bSettingsChange=True;
//		pPlayContr.ServerNewGeneralSettings(7,,iTempValue) || bSettingsChange;
	}
	iTempValue=m_pButtonsDef.GetButtonCounterValue(3,pTempButList);
	if ( (iTempValue > -1) && (iTempValue != pGameRepInfo.m_MaxPlayers) )
	{
		bSettingsChange=True;
//		pPlayContr.ServerNewGeneralSettings(3,,iTempValue);
	}
	bTempValue=m_pButtonsDef.GetButtonBoxValue(11,pTempButList);
	if ( bTempValue != pGameRepInfo.m_bFriendlyFire )
	{
		bSettingsChange=True;
//		pPlayContr.ServerNewGeneralSettings(11,bTempValue);
	}
	if ( m_pButtonsDef.FindButtonItem(14,pTempButList) != None )
	{
		if ( m_pButtonsDef.IsButtonBoxDisabled(14,pTempButList) )
		{
			bTempValue=m_bBkpTKPenalty;
		}
		else
		{
			bTempValue=m_pButtonsDef.GetButtonBoxValue(14,pTempButList);
		}
		if ( bTempValue != pGameRepInfo.m_bMenuTKPenaltySetting )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(14,bTempValue);
		}
	}
	if ( m_pButtonsDef.FindButtonItem(15,pTempButList) != None )
	{
		bTempValue=m_pButtonsDef.GetButtonBoxValue(15,pTempButList);
		if ( bTempValue != pGameRepInfo.m_bRepAllowRadarOption )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(15,bTempValue);
		}
	}
	if ( m_pButtonsDef.FindButtonItem(12,pTempButList) != None )
	{
		bTempValue=m_pButtonsDef.GetButtonBoxValue(12,pTempButList);
		if ( bTempValue != pGameRepInfo.m_bShowNames )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(12,bTempValue);
		}
	}
	if ( m_pButtonsDef.FindButtonItem(18,pTempButList) != None )
	{
		bTempValue=m_pButtonsDef.GetButtonBoxValue(18,pTempButList);
		if ( bTempValue != pGameRepInfo.m_bFFPWeapon )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(18,bTempValue);
		}
	}
	bTempValue=GetCameraSelection(23,pTempCamList);
	if ( bTempValue != (pGameRepInfo.m_iDeathCameraMode & 1) > 0 )
	{
		bSettingsChange=True;
//		pPlayContr.ServerNewGeneralSettings(23,bTempValue);
	}
	bTempValue=GetCameraSelection(24,pTempCamList);
	if ( bTempValue != (pGameRepInfo.m_iDeathCameraMode & 2) > 0 )
	{
		bSettingsChange=True;
//		pPlayContr.ServerNewGeneralSettings(24,bTempValue);
	}
	bTempValue=GetCameraSelection(25,pTempCamList);
	if ( bTempValue != (pGameRepInfo.m_iDeathCameraMode & 4) > 0 )
	{
		bSettingsChange=True;
//		pPlayContr.ServerNewGeneralSettings(25,bTempValue);
	}
	bTempValue=GetCameraSelection(26,pTempCamList);
	if ( bTempValue != (pGameRepInfo.m_iDeathCameraMode & 8) > 0 )
	{
		bSettingsChange=True;
//		pPlayContr.ServerNewGeneralSettings(26,bTempValue);
	}
	if ( m_pOptionsGameMode.GetValue2() == string(m_ANbOfGameMode[0]) )
	{
		bTempValue=GetCameraSelection(27,pTempCamList);
		if ( bTempValue != (pGameRepInfo.m_iDeathCameraMode & 16) > 0 )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(27,bTempValue);
		}
		bTempValue=GetCameraSelection(28,pTempCamList);
		if ( bTempValue != (pGameRepInfo.m_iDeathCameraMode & 32) > 0 )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(28,bTempValue);
		}
		iTempValue=m_pButtonsDef.GetButtonCounterValue(4,pTempButList);
		if ( iTempValue != pGameRepInfo.m_fBombTime )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(4,,iTempValue);
			if ( bLogSettingsChange )
			{
				Log("EBN_BombTimer change");
			}
		}
		iTempValue=m_pButtonsDef.GetButtonCounterValue(1,pTempButList);
		if ( iTempValue != pGameRepInfo.m_iRoundsPerMatch )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(1,,iTempValue);
		}
		bTempValue=m_pButtonsDef.GetButtonBoxValue(13,pTempButList);
		if ( bTempValue != pGameRepInfo.m_bAutoBalance )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(13,bTempValue);
		}
	}
	else
	{
		iTempValue=m_pButtonsDef.GetButtonCounterValue(6,pTempButList);
		if ( iTempValue != pGameRepInfo.m_iRoundsPerMatch )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(6,,iTempValue);
		}
		iTempValue=m_pButtonsDef.GetButtonCounterValue(8,pTempButList);
		if ( iTempValue != pGameRepInfo.m_iNbOfTerro )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(8,,iTempValue);
		}
		bTempValue=m_pButtonsDef.GetButtonBoxValue(17,pTempButList);
		if ( bTempValue != pGameRepInfo.m_bAIBkp )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(17,bTempValue);
		}
		bTempValue=m_pButtonsDef.GetButtonBoxValue(16,pTempButList);
		if ( bTempValue != pGameRepInfo.m_bRotateMap )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(16,bTempValue);
		}
		iTempValue=int(m_pButtonsDef.GetButtonComboValue(22,pTempButList));
		if ( iTempValue != pGameRepInfo.m_iDiffLevel )
		{
			bSettingsChange=True;
//			pPlayContr.ServerNewGeneralSettings(22,,iTempValue);
		}
	}
	return bSettingsChange;
}

function bool SendNewMapSettings (out byte _bMapCount)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local R6GameReplicationInfo R6GameRepInfo;
	local R6PlayerController pPlayContr;
	local string szTempMenu;
	local string szTempSrv;
	local ER6GameType eR6TempMenu;
	local ER6GameType eR6TempSrv;
	local int i;
	local int iTotFinalListItem;
	local int iTotGameRepItem;
	local int iTotalMax;
	local int iLastValidItem;
	local int iUpdate;
	local bool bSettingsChange;

	if (  !m_bServerSettingsChange )
	{
		return False;
	}
	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	R6GameRepInfo=R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo);
	pPlayContr=R6PlayerController(GetPlayerOwner());
	_bMapCount=FillSelectedMapList();
	if ( _bMapCount == 0 )
	{
		return True;
	}
	i=0;
JL0072:
/*	if ( (i < R6GameRepInfo.32) && (R6GameRepInfo.m_mapArray[i] != "") )
	{
		i++;
		goto JL0072;
	}*/
	iTotGameRepItem=i;
	iTotFinalListItem=m_SelectedMapList.Length;
	if ( iTotFinalListItem > 32 )
	{
		iTotFinalListItem=32;
	}
	iTotalMax=iTotFinalListItem;
	i=0;
JL00EB:
	if ( i < iTotalMax )
	{
		szTempSrv=R6GameRepInfo.m_mapArray[i];
		szTempMenu=m_SelectedMapList[i];
//		eR6TempSrv=GetLevel().GetER6GameTypeFromClassName(R6GameRepInfo.m_gameModeArray[i]);
		eR6TempMenu=m_SelectedModeList[i];
		iUpdate=0;
		if ( szTempSrv != szTempMenu )
		{
			iUpdate += 1;
		}
		if ( eR6TempSrv != eR6TempMenu )
		{
			iUpdate += 2;
		}
		if ( iUpdate != 0 )
		{
//			pPlayContr.ServerNewMapListSettings(i,iUpdate,GetLevel().GetGameTypeClassName(eR6TempMenu),szTempMenu);
			bSettingsChange=True;
		}
		i++;
		goto JL00EB;
	}
	if ( iTotGameRepItem > iTotFinalListItem )
	{
//		pPlayContr.ServerNewMapListSettings(i,0,GetLevel().GetGameTypeClassName(eR6TempMenu),szTempMenu,i);
		bSettingsChange=True;
	}
	return bSettingsChange;
}

function Notify (UWindowDialogControl C, byte E)
{
	if (  !m_bImAnAdmin )
	{
		if ( E == 1 )
		{
			if ( C.IsA('UWindowComboControl') )
			{
				ManageComboControlNotify(C);
			}
		}
		return;
	}
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
			}
			else
			{
				if ( C.IsA('R6WindowButtonAndEditBox') )
				{
					ManageR6ButtonAndEditBoxNotify(C);
				}
			}
		}
		else
		{
			if ( E == 1 )
			{
				if ( C.IsA('UWindowComboControl') )
				{
					ManageComboControlNotify(C);
				}
			}
		}
	}
	if ( m_bInitComplete )
	{
		m_bServerSettingsChange=True;
	}
}
