//================================================================================
// R6MenuRootWindow.
//================================================================================
class R6MenuRootWindow extends R6WindowRootWindow;

var EPopUpID m_ePopUpID;
var bool m_bReloadPlan;
var bool m_bLoadingPlanning;
var bool m_bPlayerPlanInitialized;
var bool m_bPlayerDoNotWant3DView;
var bool m_bPlayerWantLegend;
var bool bShowLog;
var bool m_bJoinServerProcess;
var Texture m_BGTexture0;
var Texture m_BGTexture1;
var R6MenuWidget m_CurrentWidget;
var R6MenuWidget m_PreviousWidget;
var R6MenuIntelWidget m_IntelWidget;
var R6MenuPlanningWidget m_PlanningWidget;
var R6MenuExecuteWidget m_ExecuteWidget;
var R6MenuMainWidget m_MainMenuWidget;
var R6MenuSinglePlayerWidget m_SinglePlayerWidget;
var R6MenuCustomMissionWidget m_CustomMissionWidget;
var R6MenuTrainingWidget m_TrainingWidget;
var R6MenuMultiPlayerWidget m_MultiPlayerWidget;
var R6MenuOptionsWidget m_OptionsWidget;
var R6MenuCreditsWidget m_CreditsWidget;
var R6MenuGearWidget m_GearRoomWidget;
var R6MenuMPCreateGameWidget m_pMPCreateGameWidget;
var R6MenuUbiComWidget m_pUbiComWidget;
var R6MenuNonUbiWidget m_pNonUbiWidget;
var R6MenuQuit m_pMenuQuit;
var R6FileManager m_pFileManager;
var R6WindowPopUpBox m_PopUpSavePlan;
var R6WindowPopUpBox m_PopUpLoadPlan;
var Sound m_MainMenuMusic;
var array<R6Operative> m_GameOperatives;

function Created ()
{
	local R6WindowEditBox EditPopUpBox;
	local R6WindowTextListBox SavedPlanningListBox;
	local R6GameOptions pGameOptions;

	Super.Created();
	R6Console(Console).InitializedGameService();
	m_pFileManager=new Class'R6FileManager';
	if ( m_pFileManager == None )
	{
		Log("m_pFileManager == NONE");
	}
	pGameOptions=Class'Actor'.static.GetGameOptions();
	m_bPlayerDoNotWant3DView=pGameOptions.Hide3DView;
//	m_eRootId=1;
	SetResolution(640.00,480.00);
	m_IntelWidget=R6MenuIntelWidget(CreateWindow(Class'R6MenuIntelWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_IntelWidget.Close();
	m_PlanningWidget=R6MenuPlanningWidget(CreateWindow(Class'R6MenuPlanningWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_PlanningWidget.Close();
	m_ExecuteWidget=R6MenuExecuteWidget(CreateWindow(Class'R6MenuExecuteWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_ExecuteWidget.Close();
	m_SinglePlayerWidget=R6MenuSinglePlayerWidget(CreateWindow(Class'R6MenuSinglePlayerWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_SinglePlayerWidget.Close();
	m_CustomMissionWidget=R6MenuCustomMissionWidget(CreateWindow(MenuClassDefines.ClassCustomMissionWidget,WinLeft,WinTop,WinWidth,WinHeight,self));
	m_CustomMissionWidget.Close();
	m_TrainingWidget=R6MenuTrainingWidget(CreateWindow(Class'R6MenuTrainingWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_TrainingWidget.Close();
	HarmonizeMenuFonts();
	m_MultiPlayerWidget=R6MenuMultiPlayerWidget(CreateWindow(MenuClassDefines.ClassMultiPlayerWidget,WinLeft,WinTop,WinWidth,WinHeight,self));
	m_MultiPlayerWidget.Close();
	m_OptionsWidget=R6MenuOptionsWidget(CreateWindow(Class'R6MenuOptionsWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_OptionsWidget.Close();
	m_CreditsWidget=R6MenuCreditsWidget(CreateWindow(Class'R6MenuCreditsWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_CreditsWidget.Close();
	m_GearRoomWidget=R6MenuGearWidget(CreateWindow(Class'R6MenuGearWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_GearRoomWidget.Close();
	m_pMPCreateGameWidget=R6MenuMPCreateGameWidget(CreateWindow(MenuClassDefines.ClassMPCreateGameWidget,WinLeft,WinTop,WinWidth,WinHeight,self));
	m_pMPCreateGameWidget.Close();
	m_pUbiComWidget=R6MenuUbiComWidget(CreateWindow(MenuClassDefines.ClassUbiComWidget,WinLeft,WinTop,WinWidth,WinHeight,self));
	m_pUbiComWidget.Close();
	m_pNonUbiWidget=R6MenuNonUbiWidget(CreateWindow(MenuClassDefines.ClassNonUbiComWidget,WinLeft,WinTop,WinWidth,WinHeight,self));
	m_pNonUbiWidget.Close();
	m_pMenuQuit=R6MenuQuit(CreateWindow(Class'R6MenuQuit',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_pMenuQuit.Close();
	m_MainMenuWidget=R6MenuMainWidget(CreateWindow(Class'R6MenuMainWidget',WinLeft,WinTop,WinWidth,WinHeight,self));
	m_MainMenuWidget.Close();
	if ( R6Console(Console).m_bStartedByGSClient )
	{
		m_CurrentWidget=m_pUbiComWidget;
	}
	else
	{
		if ( R6Console(Console).m_bNonUbiMatchMaking )
		{
			m_CurrentWidget=m_pNonUbiWidget;
		}
		else
		{
			if ( R6Console(Console).m_bNonUbiMatchMakingHost )
			{
				m_CurrentWidget=m_pMPCreateGameWidget;
				m_pMPCreateGameWidget.RefreshCreateGameMenu();
			}
			else
			{
				m_CurrentWidget=m_MainMenuWidget;
			}
		}
	}
	m_CurrentWidget.ShowWindow();
	m_CurrentWidget.SetMousePos(WinWidth * 0.50,WinHeight * 0.50);
//	m_ePopUpID=0;
	m_PopUpSavePlan=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_PopUpSavePlan.CreateStdPopUpWindow(Localize("POPUP","PopUpTitle_SavePlan","R6Menu"),30.00,188.00,150.00,264.00,180.00);
	m_PopUpSavePlan.CreateClientWindow(Class'R6MenuSavePlan',False,True);
//	m_PopUpSavePlan.m_ePopUpID=42;
	m_PopUpSavePlan.HideWindow();
	m_PopUpLoadPlan=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
	m_PopUpLoadPlan.CreateStdPopUpWindow(Localize("POPUP","PopUpTitle_Load","R6Menu"),30.00,188.00,150.00,264.00,180.00);
	m_PopUpLoadPlan.CreateClientWindow(Class'R6MenuLoadPlan',False,True);
//	m_PopUpLoadPlan.m_ePopUpID=43;
	m_PopUpLoadPlan.HideWindow();
	GUIScale=1.00;
	if (  !R6Console(Console).m_bStartedByGSClient )
	{
//		GetPlayerOwner().PlayMusic(m_MainMenuMusic,True);
	}
	Class'Actor'.static.GetModMgr().RegisterObject(self);
}

function InitMod ()
{
	SetLoadRandomBackgroundImage(m_szCurrentBackgroundSubDirectory);
}

function Set3dView (bool bSelected)
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	pGameOptions.Hide3DView=bSelected;
	m_bPlayerDoNotWant3DView=bSelected;
}

function DrawMouse (Canvas C)
{
	local float X;
	local float Y;
	local float fMouseClipX;
	local float fMouseClipY;
	local Texture MouseTex;

	if ( Console.ViewportOwner.bWindowsMouseAvailable )
	{
		Console.ViewportOwner.SelectedCursor=MouseWindow.Cursor.WindowsCursor;
	}
	else
	{
		C.SetDrawColor(255,255,255);
		C.Style=5;
		if ( m_bUseAimIcon == True )
		{
			C.SetPos(MouseX * GUIScale - AimCursor.HotX,MouseY * GUIScale - AimCursor.HotY);
			MouseTex=AimCursor.Tex;
		}
		else
		{
			if ( m_bUseDragIcon == True )
			{
				C.SetPos(MouseX * GUIScale - DragCursor.HotX,MouseY * GUIScale - DragCursor.HotY);
				MouseTex=DragCursor.Tex;
			}
			else
			{
				C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX,MouseY * GUIScale - MouseWindow.Cursor.HotY);
				MouseTex=MouseWindow.Cursor.Tex;
			}
		}
		fMouseClipX=m_CurrentWidget.m_fRightMouseXClipping * GUIScale;
		fMouseClipY=m_CurrentWidget.m_fRightMouseYClipping * GUIScale;
		C.SetClip(fMouseClipX,fMouseClipY);
		if ( MouseTex != None )
		{
			C.DrawTileClipped(MouseTex,MouseTex.USize,MouseTex.VSize,0.00,0.00,MouseTex.USize,MouseTex.VSize);
		}
		C.Style=1;
	}
}

function ResetMenus (optional bool _bConnectionFailed)
{
	if ( _bConnectionFailed )
	{
		m_MultiPlayerWidget.ResetMultiplayerMenu();
	}
	else
	{
		m_IntelWidget.Reset();
		m_PlanningWidget.Reset();
		m_bPlayerPlanInitialized=False;
	}
}

function UpdateMenus (int iWhatToUpdate)
{
	if ( m_PlanningWidget != None )
	{
		m_PlanningWidget.ResetTeams(iWhatToUpdate);
	}
}

function MoveMouse (float X, float Y)
{
	if ( m_CurrentWidget != None )
	{
		m_CurrentWidget.SetMousePos(X,Y);
	}
	Super.MoveMouse(Console.MouseX,Console.MouseY);
}

function ClosePopups ()
{
	if ( m_CurrentWidget == m_PlanningWidget )
	{
		m_PlanningWidget.Hide3DAndLegend();
	}
}

function bool IsInsidePlanning ()
{
	return (m_ePrevWidgetInUse == 8) || (m_ePrevWidgetInUse == 12) || (m_ePrevWidgetInUse == 9) || (m_ePrevWidgetInUse == 13) || (m_ePrevWidgetInUse == 10) || (m_ePrevWidgetInUse == 11);
}

function ChangeCurrentWidget (eGameWidgetID widgetID)
{
	local bool bDontQuitNow;

	m_bJoinServerProcess=False;
	if ( widgetID == 17 )
	{
		m_eCurWidgetInUse=m_ePrevWidgetInUse;
//		m_ePrevWidgetInUse=0;
	}
	else
	{
		m_ePrevWidgetInUse=m_eCurWidgetInUse;
		m_eCurWidgetInUse=widgetID;
		if ( m_ePrevWidgetInUse == 9 )
		{
			if ( R6PlanningCtrl(GetPlayerOwner()) != None )
			{
				R6PlanningCtrl(GetPlayerOwner()).CancelActionPointAction();
			}
		}
	}
	switch (widgetID)
	{
/*		case 5:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_SinglePlayerWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 4:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_TrainingWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 7:
		if ( m_CurrentWidget == m_MultiPlayerWidget )
		{
			R6MenuMultiPlayerWidget(m_CurrentWidget).BackToMainMenu();
		}
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_MainMenuWidget;
		m_CurrentWidget.ShowWindow();
		ResetMenus();
		break;
		case 8:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_IntelWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 11:
		ResetCustomMissionOperatives();
		m_bReloadPlan=True;
		m_bLoadingPlanning=True;
		m_bPlayerPlanInitialized=True;
		GotoPlanning();
		break;
		case 9:
		if ( m_CurrentWidget != m_PlanningWidget )
		{
			m_CurrentWidget.HideWindow();
			m_PreviousWidget=m_CurrentWidget;
			m_CurrentWidget=m_PlanningWidget;
			m_CurrentWidget.ShowWindow();
		}
		break;
		case 13:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_ExecuteWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 12:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_GearRoomWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 14:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_CustomMissionWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 15:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_MultiPlayerWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 20:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_pUbiComWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 35:
		if ( R6Console(Console).m_bStartedByGSClient )
		{
//			ChangeCurrentWidget(20);
			m_pUbiComWidget.PromptConnectionError();
		}
		else
		{
			if ( R6Console(Console).m_bNonUbiMatchMaking )
			{
//				ChangeCurrentWidget(21);
				m_pNonUbiWidget.PromptConnectionError();
			}
			else
			{
				if ( R6Console(Console).m_bNonUbiMatchMakingHost )
				{
					goto JL03D5;
				}
//				ChangeCurrentWidget(15);
				m_MultiPlayerWidget.PromptConnectionError();
			}
		}
JL03D5:
		break;
		case 36:
//		ChangeCurrentWidget(20);
		m_pUbiComWidget.PromptConnectionError();
		break;
		case 16:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_OptionsWidget;
		m_OptionsWidget.RefreshOptions();
		m_CurrentWidget.ShowWindow();
		break;
		case 18:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_CreditsWidget;
		m_CurrentWidget.ShowWindow();
		break;
		case 19:
		m_CurrentWidget.HideWindow();
		m_PreviousWidget=m_CurrentWidget;
		m_CurrentWidget=m_pMPCreateGameWidget;
		m_pMPCreateGameWidget.RefreshCreateGameMenu();
		m_CurrentWidget.ShowWindow();
		break;
		case 10:
		m_bReloadPlan=True;
		m_bPlayerPlanInitialized=True;
		GotoCampaignPlanning(True);
		break;
		case 6:
		GotoCampaignPlanning(False);
		break;
		case 37:
		if ( bDontQuitNow )
		{
			m_CurrentWidget.HideWindow();
			m_PreviousWidget=m_CurrentWidget;
			m_CurrentWidget=m_pMenuQuit;
			m_CurrentWidget.ShowWindow();
		}
		else
		{
			Root.DoQuitGame();
		}
		break;
		case 17:
		if ( m_PreviousWidget != None )
		{
			m_CurrentWidget.HideWindow();
			m_CurrentWidget=m_PreviousWidget;
			m_PreviousWidget=None;
			m_CurrentWidget.ShowWindow();
		}
		break;
		default:
		break;*/
	}
}

function bool PlanningShouldProcessKey ()
{
	if ( (m_ePopUpID == 0) && (m_eCurWidgetInUse == 9) )
	{
		return True;
	}
	return False;
}

function bool PlanningShouldDrawPath ()
{
	if ( m_eCurWidgetInUse == 9 )
	{
		return True;
	}
	return False;
}

function ResetCustomMissionOperatives ()
{
	local R6Operative tmpOperative;
	local Class<R6Operative> tmpOperativeClass;
	local int iNbArrayElements;
	local int iNbTotalOperatives;
	local int i;
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	m_GameOperatives.Remove (0,m_GameOperatives.Length);
	iNbArrayElements=R6Console(Console).m_CurrentCampaign.m_OperativeClassName.Length;
	i=0;
JL0049:
	if ( i < iNbArrayElements )
	{
		tmpOperative=new Class<R6Operative>(DynamicLoadObject(R6Console(Console).m_CurrentCampaign.m_OperativeClassName[i],Class'Class'));
		m_GameOperatives[i]=tmpOperative;
		i++;
		goto JL0049;
	}
	iNbTotalOperatives=i;
	i=0;
JL00C1:
	if ( i < pModManager.GetPackageMgr().GetNbPackage() )
	{
		tmpOperativeClass=Class<R6Operative>(pModManager.GetPackageMgr().GetFirstClassFromPackage(i,Class'R6Operative'));
JL0112:
		if ( tmpOperativeClass != None )
		{
			tmpOperative=new tmpOperativeClass;
			if ( tmpOperative != None )
			{
				m_GameOperatives[iNbTotalOperatives]=tmpOperative;
				iNbTotalOperatives++;
			}
			tmpOperativeClass=Class<R6Operative>(pModManager.GetPackageMgr().GetNextClassFromPackage());
			goto JL0112;
		}
		i++;
		goto JL00C1;
	}
}

function KeyType (int iInputKey, float X, float Y)
{
	m_CurrentWidget.KeyType(iInputKey,X,Y);
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	if ( bShowLog )
	{
		switch (Msg)
		{
/*			case 9:
			Log("R6MenuRoot::WindowEvent Msg= WM_KeyDown Key" @ string(Key));
			break;
			case 8:
			Log("R6MenuRoot::WindowEvent Msg= WM_KeyUp Key" @ string(Key));
			break;
			case 10:
			Log("R6MenuRoot::WindowEvent Msg= WM_KeyType Key" @ string(Key));
			break;
			default:*/
		}
	}
	if ( Msg != 11 )
	{
		if ( Console.m_bInterruptConnectionProcess || R6Console(Console).m_bRenderMenuOneTime )
		{
			return;
		}
		if ( m_bJoinServerProcess )
		{
			if ( Msg == 9 )
			{
/*				if ( Key == Root.Console.27 )
				{
					Console.m_bInterruptConnectionProcess=True;
					return;
				} */
			}
		}
	}
	switch (Msg)
	{
/*		case 9:
		if ( HotKeyDown(Key,X,Y) )
		{
			return;
		}
		break;
		case 8:
		if ( HotKeyUp(Key,X,Y) )
		{
			return;
		}
		break;
		default:*/
	}
	if ( (Msg == 11) ||  !WaitModal() )
	{
		Super.WindowEvent(Msg,C,X,Y,Key);
	}
	else
	{
		if ( WaitModal() )
		{
			ModalWindow.WindowEvent(Msg,C,X - ModalWindow.WinLeft,Y - ModalWindow.WinTop,Key);
		}
	}
}

function GotoCampaignPlanning (bool _bRetrying)
{
	local R6PlayerCampaign PlayerCampaign;
	local int iNbArrayElements;
	local int i;
	local R6MissionDescription CurrentMission;
	local R6Console CurrentConsole;

	CurrentConsole=R6Console(Console);
	PlayerCampaign=CurrentConsole.m_PlayerCampaign;
	iNbArrayElements=0;
	if ( bShowLog )
	{
		Log("start GotoPlanning PlayerCampaign.m_FileName=" $ PlayerCampaign.m_FileName);
	}
	CurrentConsole.m_CurrentCampaign=new Class'R6Campaign';
	CurrentConsole.m_CurrentCampaign.Init(GetLevel(),PlayerCampaign.m_CampaignFileName,CurrentConsole);
	CurrentMission=CurrentConsole.m_CurrentCampaign.m_missions[PlayerCampaign.m_iNoMission];
	CurrentConsole.Master.m_StartGameInfo.m_CurrentMission=CurrentMission;
	if ( bShowLog )
	{
		Log("m_CurrentCampaign" @ string(CurrentConsole.m_CurrentCampaign));
	}
	if ( bShowLog )
	{
		Log("currentMission" @ string(CurrentMission));
	}
	CurrentConsole.Master.m_StartGameInfo.m_MapName=CurrentMission.m_MapName;
	if ( bShowLog )
	{
		Log("currentMission.m_MapName" @ CurrentMission.m_MapName);
	}
	CurrentConsole.Master.m_StartGameInfo.m_DifficultyLevel=PlayerCampaign.m_iDifficultyLevel;
	if ( bShowLog )
	{
		Log("PlayerCampaign.m_iDifficultyLevel" @ string(PlayerCampaign.m_iDifficultyLevel));
	}
	CurrentConsole.Master.m_StartGameInfo.m_GameMode="R6Game.R6StoryModeGame";
	iNbArrayElements=PlayerCampaign.m_OperativesMissionDetails.m_MissionOperatives.Length;
	if ( bShowLog )
	{
		Log("m_MissionOperatives.Length" @ string(PlayerCampaign.m_OperativesMissionDetails.m_MissionOperatives.Length));
	}
	m_GameOperatives.Remove (0,m_GameOperatives.Length);
	i=0;
JL02E5:
	if ( i < iNbArrayElements )
	{
		m_GameOperatives[i]=PlayerCampaign.m_OperativesMissionDetails.m_MissionOperatives[i];
		i++;
		goto JL02E5;
	}
	if ( bShowLog )
	{
		Log("end GotoPlanning");
	}
	m_bLoadingPlanning=True;
	if ( _bRetrying )
	{
		GotoPlanning();
	}
	else
	{
		CurrentConsole.PreloadMapForPlanning();
	}
}

function GotoPlanning ()
{
	local Player CurrentPlayer;
	local PlayerController NewController;
	local R6IORotatingDoor RotDoor;
	local R6DeploymentZone DeployZone;

	if ( m_bLoadingPlanning )
	{
		if ( m_bReloadPlan )
		{
			R6GameInfo(GetLevel().Game).RestartGameMgr();
			CurrentPlayer=GetPlayerOwner().Player;
			GetPlayerOwner().Destroy();
			NewController=GetLevel().Spawn(Class'R6PlanningCtrl');
			R6GameInfo(GetLevel().Game).SetController(NewController,CurrentPlayer);
			R6GameInfo(GetLevel().Game).bRestartLevel=False;
			R6GameInfo(GetLevel().Game).RestartPlayer(NewController);
			R6PlanningCtrl(NewController).SetPlanningInfo();
			NewController.SpawnDefaultHUD();
//			NewController.ChangeInputSet(1);
			R6PlanningCtrl(GetPlayerOwner()).DeleteEverySingleNode();
			R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.LoadPlanning("Backup","Backup","Backup","","Backup.pln",Console.Master.m_StartGameInfo);
			R6PlanningCtrl(GetPlayerOwner()).InitNewPlanning(R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.m_iCurrentTeam);
			m_GearRoomWidget.LoadRosterFromStartInfo();
			m_bReloadPlan=False;
		}
		else
		{
			m_GearRoomWidget.Reset();
		}
		m_bLoadingPlanning=False;
//		ChangeCurrentWidget(8);
	}
}

function LaunchQuickPlay ()
{
	local string szFileName;

	szFileName=R6MissionDescription(R6Console(Console).Master.m_StartGameInfo.m_CurrentMission).m_ShortName;
	szFileName=szFileName $ R6AbstractGameInfo(GetLevel().Game).m_szDefaultActionPlan;
	if ( LoadAPlanning(Caps(szFileName)) )
	{
		if ( m_GearRoomWidget.IsTeamConfigValid() )
		{
			StopWidgetSound();
			m_PlanningWidget.m_PlanningBar.m_TimeLine.Reset();
			LeaveForGame(False,0);
		}
		else
		{
//			SimplePopUp(Localize("POPUP","INCOMPLETEPLANNING","R6Menu"),Localize("POPUP","INCOMPLETEPLANNINGPROBLEM","R6Menu"),44,2);
		}
	}
}

function NotifyAfterLevelChange ()
{
	GotoPlanning();
}

function PopUpMenu (optional bool _bautoLoadPrompt)
{
	local int i;
	local int iMax;
	local R6WindowListBoxItem NewItem;
	local string szFileName;

	switch (m_ePopUpID)
	{
/*		case 42:
		FillListOfSavedPlan(R6MenuSavePlan(m_PopUpSavePlan.m_ClientArea).m_pListOfSavedPlan);
		m_PopUpSavePlan.ShowWindow();
		R6MenuSavePlan(m_PopUpSavePlan.m_ClientArea).m_pEditSaveNameBox.LMouseDown(0.00,0.00);
		break;
		case 43:
		if ( _bautoLoadPrompt )
		{
			m_PopUpLoadPlan.ModifyPopUpFrameWindow(Localize("POPUP","PopUpTitle_Load","R6Menu"),30.00,165.00,150.00,310.00,180.00);
			m_PopUpLoadPlan.AddDisableDLG();
			m_bPlayerPlanInitialized=True;
		}
		else
		{
			m_PopUpLoadPlan.ModifyPopUpFrameWindow(Localize("POPUP","PopUpTitle_Load","R6Menu"),30.00,188.00,150.00,264.00,180.00);
			m_PopUpLoadPlan.RemoveDisableDLG();
		}
		FillListOfSavedPlan(R6MenuLoadPlan(m_PopUpLoadPlan.m_ClientArea).m_pListOfSavedPlan);
		m_PopUpLoadPlan.ShowWindow();
		break;
		default:*/
	}
}

function SimplePopUp (string _szTitle, string _szText, EPopUpID _ePopUpID, optional int _iButtonsType, optional bool bAddDisableDlg, optional UWindowWindow OwnerWindow)
{
	if ( OwnerWindow == None )
	{
		Super.SimplePopUp(_szTitle,_szText,_ePopUpID,_iButtonsType,bAddDisableDlg,self);
	}
	else
	{
		Super.SimplePopUp(_szTitle,_szText,_ePopUpID,_iButtonsType,bAddDisableDlg,OwnerWindow);
	}
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	local string szFileName;
	local R6WindowListBoxItem SelectedItem;
	local R6WindowTextListBox SavedPlanningListBox;
	local R6StartGameInfo StartGameInfo;
	local R6MissionDescription mission;
	local string szMapName;
	local string szGameTypeDirName;
	local string szEnglishGTDirectory;

	Super.PopUpBoxDone(Result,_ePopUpID);
	if ( Result == 3 )
	{
		switch (_ePopUpID)
		{
/*			case 4:
			case 42:
			szFileName=R6MenuSavePlan(m_PopUpSavePlan.m_ClientArea).m_pEditSaveNameBox.GetValue();
			if ( szFileName != "" )
			{
				if ( _ePopUpID == 4 )
				{
					m_PopUpSavePlan.HideWindow();
				}
				else
				{
					if ( IsSaveFileAlreadyExist(szFileName) )
					{
						m_ePopUpID=42;
						PopUpMenu();
						SimplePopUp(Localize("POPUP","SaveFileExist","R6Menu"),Localize("POPUP","SaveFileExistMsg","R6Menu"),4);
						return;
					}
				}
				R6PlanningCtrl(GetPlayerOwner()).ResetAllID();
				m_GearRoomWidget.SetStartTeamInfoForSaving();
				R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.m_iCurrentTeam=R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam;
				StartGameInfo=Console.Master.m_StartGameInfo;
				mission=R6MissionDescription(StartGameInfo.m_CurrentMission);
				szMapName=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
				if ( szMapName == "" )
				{
					szMapName=string(GetLevel().Outer.Name);
				}
				GetLevel().GetGameTypeSaveDirectories(szGameTypeDirName,szEnglishGTDirectory);
				if ( R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.SavePlanning(mission.m_MapName,szMapName,szEnglishGTDirectory,szGameTypeDirName,szFileName,StartGameInfo) == False )
				{
					SimplePopUp(Localize("POPUP","FILEERROR","R6Menu"),szFileName @ ":" @ Localize("POPUP","FILEERRORPROBLEM","R6Menu"),2,2);
				}
			}
			break;
			case 43:
			SavedPlanningListBox=R6MenuLoadPlan(m_PopUpLoadPlan.m_ClientArea).m_pListOfSavedPlan;
			if ( SavedPlanningListBox.m_SelectedItem != None )
			{
				szFileName=R6WindowListBoxItem(SavedPlanningListBox.m_SelectedItem).HelpText;
				if ( szFileName == "" )
				{
					goto JL0549;
				}
				LoadAPlanning(szFileName);
			}
			break;
			case 36:
			SavedPlanningListBox=R6MenuSavePlan(m_PopUpSavePlan.m_ClientArea).m_pListOfSavedPlan;
			if ( SavedPlanningListBox.m_SelectedItem != None )
			{
				szFileName=R6WindowListBoxItem(SavedPlanningListBox.m_SelectedItem).HelpText;
				if ( szFileName == "" )
				{
					goto JL0549;
				}
				if ( DeleteAPlanning(szFileName) )
				{
					FillListOfSavedPlan(R6MenuSavePlan(m_PopUpSavePlan.m_ClientArea).m_pListOfSavedPlan);
				}
			}
			return;
			break;
			case 35:
			SavedPlanningListBox=R6MenuLoadPlan(m_PopUpLoadPlan.m_ClientArea).m_pListOfSavedPlan;
			if ( SavedPlanningListBox.m_SelectedItem != None )
			{
				szFileName=R6WindowListBoxItem(SavedPlanningListBox.m_SelectedItem).HelpText;
				if ( szFileName == "" )
				{
					goto JL0549;
				}
				if ( DeleteAPlanning(szFileName) )
				{
					FillListOfSavedPlan(R6MenuLoadPlan(m_PopUpLoadPlan.m_ClientArea).m_pListOfSavedPlan);
				}
			}
			return;
			break;
			case 38:
			m_SinglePlayerWidget.TryCreatingCampaign();
			break;
			case 34:
			LaunchQuickPlay();
			return;
			break;
			case 37:
			m_SinglePlayerWidget.DeleteCurrentSelectedCampaign();
			break;
			case 41:
			Console.Master.m_StartGameInfo.m_ReloadPlanning=False;
			R6PlanningCtrl(GetPlayerOwner()).DeleteEverySingleNode();
//			ChangeCurrentWidget(7);
			break;
			case 39:
			R6PlanningCtrl(GetPlayerOwner()).DeleteAllNode();
			break;
			case 40:
			R6PlanningCtrl(GetPlayerOwner()).DeleteEverySingleNode();
			break;
			case 6:
			case 44:
			case 25:
			break;
			case 5:
			return;
			break;
			default:*/
		}
JL0549:
	}
	else
	{
		if ( (_ePopUpID == 35) || (_ePopUpID == 36) )
		{
			return;
		}
		if ( _ePopUpID == 4 )
		{
//			m_ePopUpID=42;
			return;
		}
	}
	if ( (m_CurrentWidget == m_PlanningWidget) &&  !m_bPlayerDoNotWant3DView )
	{
		m_PlanningWidget.m_3DButton.m_bSelected=True;
		m_PlanningWidget.m_3DWindow.Toggle3DWindow();
		R6PlanningCtrl(GetPlayerOwner()).Toggle3DView();
	}
	if ( (m_CurrentWidget == m_PlanningWidget) && m_bPlayerWantLegend )
	{
		m_PlanningWidget.m_LegendWindow.ToggleLegend();
		m_PlanningWidget.m_LegendButton.m_bSelected=True;
	}
	if ( _ePopUpID == 3 )
	{
		m_GearRoomWidget.SetStartTeamInfo();
		R6Console(Console).LaunchR6Game();
	}
//	m_ePopUpID=0;
}

function StopPlayMode ()
{
	m_PlanningWidget.m_PlanningBar.m_TimeLine.StopPlayMode();
}

function StopWidgetSound ()
{
	if ( m_eCurWidgetInUse == 8 )
	{
		m_IntelWidget.StopIntelWidgetSound();
	}
}

function SetServerOptions ()
{
	if ( (m_pMPCreateGameWidget != None) && (m_pMPCreateGameWidget.m_pCreateTabOptions != None) )
	{
		m_pMPCreateGameWidget.m_pCreateTabOptions.SetServerOptions();
	}
}

function FillListOfSavedPlan (R6WindowTextListBox _pListOfSavedPlan)
{
	local R6WindowListBoxItem NewItem;
	local string szFileName;
	local int i;
	local int iMax;
	local R6StartGameInfo StartGameInfo;
	local R6MissionDescription mission;
	local string szMapName;
	local string szGameTypeDirName;
	local string szEnglishGTDirectory;

	_pListOfSavedPlan.Clear();
	StartGameInfo=Console.Master.m_StartGameInfo;
	mission=R6MissionDescription(StartGameInfo.m_CurrentMission);
	GetLevel().GetGameTypeSaveDirectories(szGameTypeDirName,szEnglishGTDirectory);
	szMapName=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
	if ( szMapName == "" )
	{
		szMapName=string(GetLevel().Outer.Name);
	}
//	iMax=R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.GetNumberOfFiles(szMapName,szGameTypeDirName);
	i=0;
JL00F3:
	if ( i < iMax )
	{
		R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.GetFileName(i,szFileName);
		if ( szFileName != "" )
		{
			szFileName=Left(szFileName,InStr(szFileName,".PLN"));
			NewItem=R6WindowListBoxItem(_pListOfSavedPlan.Items.Append(Class'R6WindowListBoxItem'));
			NewItem.HelpText=szFileName;
		}
		i++;
		goto JL00F3;
	}
}

function bool IsSaveFileAlreadyExist (string _szFileName)
{
	local string szPathAndFilename;
	local string szGameTypeDirName;
	local R6StartGameInfo StartGameInfo;
	local string szMapName;
	local R6MissionDescription mission;
	local string szEnglishGTDirectory;

	StartGameInfo=Console.Master.m_StartGameInfo;
	mission=R6MissionDescription(StartGameInfo.m_CurrentMission);
	GetLevel().GetGameTypeSaveDirectories(szGameTypeDirName,szEnglishGTDirectory);
	szMapName=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
	if ( szMapName == "" )
	{
		szMapName=string(GetLevel().Outer.Name);
	}
	szPathAndFilename="..\\save\\plan\\" $ szMapName $ "\\" $ szGameTypeDirName $ "\\" $ _szFileName $ ".PLN";
	if ( m_pFileManager.FindFile(szPathAndFilename) )
	{
		return True;
	}
	return False;
}

function bool LoadAPlanning (string _szFileName)
{
	local string szLoadErrorMsg;
	local string szLoadErrorMsgMapName;
	local string szLoadErrorMsgGameType;
	local R6StartGameInfo StartGameInfo;
	local R6MissionDescription mission;
	local string szMapName;
	local string szGameTypeDirName;
	local string szEnglishGTDirectory;
	local int iMission;
	local bool bFoundMission;

	R6PlanningCtrl(GetPlayerOwner()).DeleteEverySingleNode();
	StartGameInfo=Console.Master.m_StartGameInfo;
	mission=R6MissionDescription(StartGameInfo.m_CurrentMission);
	szMapName=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
	if ( szMapName == "" )
	{
		szMapName=string(GetLevel().Outer.Name);
	}
	GetLevel().GetGameTypeSaveDirectories(szGameTypeDirName,szEnglishGTDirectory);
	if ( R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.LoadPlanning(mission.m_MapName,szMapName,szEnglishGTDirectory,szGameTypeDirName,_szFileName,StartGameInfo,szLoadErrorMsgMapName,szLoadErrorMsgGameType) == True )
	{
		R6PlanningCtrl(GetPlayerOwner()).InitNewPlanning(R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.m_iCurrentTeam);
		m_GearRoomWidget.LoadRosterFromStartInfo();
		m_bPlayerPlanInitialized=True;
		return True;
	}
	else
	{
		bFoundMission=False;
		iMission=0;
JL0176:
		if ( iMission < R6Console(Root.Console).m_aMissionDescriptions.Length )
		{
			mission=R6Console(Root.Console).m_aMissionDescriptions[iMission];
			if ( Caps(mission.m_MapName) == Caps(szLoadErrorMsgMapName) )
			{
				bFoundMission=True;
				iMission=R6Console(Root.Console).m_aMissionDescriptions.Length;
			}
			iMission++;
			goto JL0176;
		}
		szMapName=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
		if ( (szMapName == "") || (bFoundMission == False) )
		{
			szMapName=Localize("POPUP","LOADERRORMAPUNKNOWN","R6Menu");
		}
		if ( GetLevel().FindSaveDirectoryNameFromEnglish(szGameTypeDirName,szLoadErrorMsgGameType) == False )
		{
			szGameTypeDirName=Localize("POPUP","LOADERRORMAPUNKNOWN","R6Menu");
		}
		szLoadErrorMsg=Localize("POPUP","LOADERRORPROBLEM","R6Menu") @ szMapName @ Localize("POPUP","LOADERRORPROBLEM2","R6Menu") @ szGameTypeDirName;
		SimplePopUp(Localize("POPUP","LOADERROR","R6Menu"),_szFileName @ szLoadErrorMsg,EPopUpID_InvalidLoad,2);
		return False;
	}
	return false;
}

function bool DeleteAPlanning (string szFileName)
{
	local string szPathAndFilename;
	local string ErrorMsg;
	local R6StartGameInfo StartGameInfo;
	local string szMapName;
	local string szGameTypeDirName;
	local string szEnglishGTDirectory;
	local R6MissionDescription mission;
	local int i;

	StartGameInfo=Console.Master.m_StartGameInfo;
	mission=R6MissionDescription(StartGameInfo.m_CurrentMission);
	GetLevel().GetGameTypeSaveDirectories(szGameTypeDirName,szEnglishGTDirectory);
	szMapName=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
	if ( szMapName == "" )
	{
		szMapName=string(GetLevel().Outer.Name);
	}
	szPathAndFilename="..\\save\\plan\\" $ szMapName $ "\\" $ szGameTypeDirName $ "\\" $ szFileName $ ".PLN";
	if ( m_pFileManager.DeleteFile(szPathAndFilename) )
	{
		return True;
	}
	ErrorMsg=Localize("POPUP","PLANDELETEERRORPROBLEM","R6Menu") @ ":" @ szFileName @ "\n" @ Localize("POPUP","PLANDELETEERRORMSG","R6Menu");
//	SimplePopUp(Localize("POPUP","PLANDELETEERROR","R6Menu"),ErrorMsg,5,2);
	return False;
}

function bool IsPlanningEmpty ()
{
	local bool Result;
	local R6PlanningInfo PlanningInfo;
	local int i;

	Result=True;
	i=0;
JL000F:
	if ( i < 3 )
	{
		PlanningInfo=R6PlanningInfo(Console.Master.m_StartGameInfo.m_TeamInfo[i].m_pPlanning);
		if ( PlanningInfo.m_NodeList.Length > 0 )
		{
			Result=False;
		}
		i++;
		goto JL000F;
	}
	return Result;
}

function LeaveForGame (bool _ObserverMode, int _iTeamStart)
{
	local R6StartGameInfo StartGameInfo;

	StartGameInfo=Console.Master.m_StartGameInfo;
	StartGameInfo.m_bIsPlaying= !_ObserverMode;
	StartGameInfo.m_iTeamStart=_iTeamStart;
	m_GearRoomWidget.SetStartTeamInfoForSaving();
	R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.m_iCurrentTeam=R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam;
	if ( R6PlanningCtrl(GetPlayerOwner()).m_pFileManager.SavePlanning("Backup","Backup","Backup","","Backup.pln",StartGameInfo) == False )
	{
		SimplePopUp(Localize("POPUP","FILEERROR","R6Menu"),"Backup.pln" @ ":" @ Localize("POPUP","FILEERRORPROBLEM","R6Menu"),EPopUpID_FileWriteError,2);
	}
	else
	{
		m_GearRoomWidget.SetStartTeamInfo();
		SimpleTextPopUp(Localize("POPUP","LAUNCHING","R6Menu"));
		R6Console(Console).LaunchR6Game(True);
	}
}

function HarmonizeMenuFonts ()
{
	local Font ButtonFont;
	local Font DownSizeFont;

	DownSizeFont=Root.Fonts[6];
	ButtonFont=Root.Fonts[16];
	m_SinglePlayerWidget.m_LeftButtonFont=ButtonFont;
	m_CustomMissionWidget.m_LeftButtonFont=ButtonFont;
	m_TrainingWidget.m_LeftButtonFont=ButtonFont;
	m_SinglePlayerWidget.m_LeftDownSizeFont=DownSizeFont;
	m_CustomMissionWidget.m_LeftDownSizeFont=DownSizeFont;
	m_TrainingWidget.m_LeftDownSizeFont=DownSizeFont;
	m_SinglePlayerWidget.CreateButtons();
	m_CustomMissionWidget.CreateButtons();
	m_TrainingWidget.CreateButtons();
	if ( m_SinglePlayerWidget.ButtonsUsingDownSizeFont() || m_CustomMissionWidget.ButtonsUsingDownSizeFont() || m_TrainingWidget.ButtonsUsingDownSizeFont() )
	{
		m_SinglePlayerWidget.ForceFontDownSizing();
		m_CustomMissionWidget.ForceFontDownSizing();
		m_TrainingWidget.ForceFontDownSizing();
	}
}

function MenuLoadProfile (bool _bServerProfile)
{
	if ( _bServerProfile )
	{
		m_pMPCreateGameWidget.MenuServerLoadProfile();
	}
	else
	{
		m_OptionsWidget.MenuOptionsLoadProfile();
	}
}

function NotifyWindow (UWindowWindow C, byte E)
{
	if ( E == 11 )
	{
		if ( C == R6MenuLoadPlan(m_PopUpLoadPlan.m_ClientArea).m_pListOfSavedPlan )
		{
//			m_PopUpLoadPlan.Result=3;
			m_PopUpLoadPlan.Close();
		}
		else
		{
			if ( C == R6MenuSavePlan(m_PopUpSavePlan.m_ClientArea).m_pListOfSavedPlan )
			{
//				m_PopUpSavePlan.Result=3;
				m_PopUpSavePlan.Close();
			}
		}
	}
}

function SetNewMODS (string _szNewBkgFolder, optional bool _bForceRefresh)
{
	if (! _bForceRefresh ) goto JL0009;
JL0009:
	Super.SetNewMODS(_szNewBkgFolder,_bForceRefresh);
}

function InitBeaconService ()
{
	if ( R6Console(Console).m_LanServers == None )
	{
		R6Console(Console).m_LanServers=new Class<R6LanServers>(Root.MenuClassDefines.ClassLanServer);
		R6Console(Console).m_LanServers.Created();
	}
	if ( R6Console(Console).m_LanServers.m_ClientBeacon == None )
	{
		R6Console(Console).m_LanServers.m_ClientBeacon=Console.ViewportOwner.Actor.Spawn(Class'ClientBeaconReceiver');
	}
	R6Console(Console).m_GameService.m_ClientBeacon=R6Console(Console).m_LanServers.m_ClientBeacon;
}

defaultproperties
{
    LookAndFeelClass="R6Menu.R6MenuRSLookAndFeel"
}
/*
    m_BGTexture0=Texture'R6MenuBG.Backgrounds.GenericLoad0'
    m_BGTexture1=Texture'R6MenuBG.Backgrounds.GenericLoad1'
    m_MainMenuMusic=Sound'Music.Play_theme_Menu1'
*/

