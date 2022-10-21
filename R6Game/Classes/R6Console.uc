//================================================================================
// R6Console.
//================================================================================
class R6Console extends WindowConsole;

enum eLeaveGame {
	LG_MainMenu,
	LG_NextLevel,
	LG_Trainning,
	LG_MultiPlayerMenu,
	LG_RetryPlanningCustomMission,
	LG_CustomMissionMenu,
	LG_RetryPlanningCampaign,
	LG_QuitGame,
	LG_MultiPlayerError,
	LG_InitMod
};

enum eGameWidgetID {
	WidgetID_None,
	InGameID_EscMenu,
	InGameID_Debriefing,
	InGameID_TrainingInstruction,
	TrainingWidgetID,
	SinglePlayerWidgetID,
	CampaignPlanningID,
	MainMenuWidgetID,
	IntelWidgetID,
	PlanningWidgetID,
	RetryCampaignPlanningID,
	RetryCustomMissionPlanningID,
	GearRoomWidgetID,
	ExecuteWidgetID,
	CustomMissionWidgetID,
	MultiPlayerWidgetID,
	OptionsWidgetID,
	PreviousWidgetID,
	CreditsWidgetID,
	MPCreateGameWidgetID,
	UbiComWidgetID,
	NonUbiWidgetID,
	InGameMPWID_Writable,
	InGameMPWID_TeamJoin,
	InGameMPWID_Intermission,
	InGameMPWID_InterEndRound,
	InGameMPWID_EscMenu,
	InGameMpWID_RecMessages,
	InGameMpWID_MsgOffensive,
	InGameMpWID_MsgDefensive,
	InGameMpWID_MsgReply,
	InGameMpWID_MsgStatus,
	InGameMPWID_Vote,
	InGameMPWID_CountDown,
	InGameID_OperativeSelector,
	MultiPlayerError,
	MultiPlayerErrorUbiCom,
	MenuQuitID
};

var eLeaveGame m_eNextStep;
var eGameWidgetID m_eLastPreviousWID;
const K_CHECKTIME_TIMEOUT= 9000;
const K_CHECKTIME_INTERVAL= 3000;
const K_TimeRetryConnect= 5;
var int m_iRetryTime;
var int m_iLastCheckTime;
var int m_iLastSuccCheckTime;
var bool bResetLevel;
var bool bLaunchWasCalled;
var bool bLaunchMultiPlayer;
var bool bReturnToMenu;
var bool bMultiPlayerGameActive;
var bool bCancelFire;
var bool m_bInGamePlanningKeyDown;
var bool m_bAutoLoginFirstPass;
var bool m_bReturnToGSClient;
var bool m_bJoinUbiServer;
var bool m_bCreateUbiServer;
var bool m_bSkipAFrameAndStart;
var bool m_bRenderMenuOneTime;
var bool m_bGSClientAlreadyInit;
var bool m_bStartR6GameInProgress;
var R6Campaign m_CurrentCampaign;
var R6PlayerCampaign m_PlayerCampaign;
var R6GSServers m_GameService;
var R6LanServers m_LanServers;
var R6PlayerCustomMission m_playerCustomMission;
var Sound m_StopMainMenuMusic;
var array<R6Campaign> m_aCampaigns;
var array<R6MissionDescription> m_aMissionDescriptions;
var string m_szLastError;
var string szStoreGamePassWd;

event Message (coerce string Msg, float MsgLife)
{
	local PlayerController PController;

	if ( ViewportOwner == None )
	{
		return;
	}
	PController=ViewportOwner.Actor;
	PController.myHUD.Message(PController.PlayerReplicationInfo,Msg,'Console');
}

function CreateRootWindow (Canvas Canvas)
{
	InitCampaignAndMissionDescription();
	Super.CreateRootWindow(Canvas);
}

function InitCampaignAndMissionDescription ()
{
	local R6FileManager pFileManager;
	local string szCampaignName;
	local string szCampaignPathName;

	if ( m_CurrentCampaign != None )
	{
		return;
	}
	Class'Actor'.static.GetModMgr().RegisterObject(self);
	ViewportOwner.Actor.Level.GetCampaignNameFromParam(szCampaignName);
	pFileManager=new Class'R6FileManager';
	szCampaignPathName="..\\maps\\" $ szCampaignName;
	if (  !pFileManager.FindFile(szCampaignPathName) )
	{
		szCampaignName="";
	}
	if ( szCampaignName == "" )
	{
		szCampaignName=Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szCampaignIniFile;
	}
	LoadCampaignIni(szCampaignName);
}

function LoadCampaignIni (string szCampaign)
{
	local int i;
	local bool bFound;

	i=0;
JL0007:
	if ( i < m_aCampaigns.Length )
	{
		if ( m_aCampaigns[i].m_szCampaignFile == szCampaign )
		{
			m_CurrentCampaign=m_aCampaigns[i];
			bFound=True;
		}
		i++;
		goto JL0007;
	}
	if ( bFound == False )
	{
		m_CurrentCampaign=new Class'R6Campaign';
		m_aCampaigns[i]=m_CurrentCampaign;
	}
	m_CurrentCampaign.Init(ViewportOwner.Actor.Level,szCampaign,self);
	UnlockMissions();
}

function InitMod ()
{
	local string szCampaign;

	if (  !Class'Actor'.static.GetModMgr().IsRavenShield() )
	{
		LoadCampaignIni("RavenShieldCampaign");
	}
	szCampaign=Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szCampaignIniFile;
	LoadCampaignIni(szCampaign);
	if ( m_PlayerCampaign != None )
	{
		m_PlayerCampaign.m_bCampaignCompleted=0;
	}
	ConsoleCommand("LOADSERVER " $ Class'Actor'.static.GetModMgr().GetServerIni() $ ".ini");
}

event Initialized ()
{
	if ( bShowLog )
	{
		Log("R6Console Initialized");
	}
	m_PlayerCampaign=new Class'R6PlayerCampaign';
	m_PlayerCampaign.m_OperativesMissionDetails=new Class'R6MissionRoster';
	m_playerCustomMission=new Class'R6PlayerCustomMission';
}

function InitializedGameService ()
{
	if ( m_GameService == None )
	{
		m_GameService=new Class<R6GSServers>(Root.MenuClassDefines.ClassGSServer);
		m_GameService.Created();
		m_bAutoLoginFirstPass=True;
		m_bNonUbiMatchMaking=Class'Actor'.static.NativeNonUbiMatchMaking();
		m_bStartedByGSClient=Class'Actor'.static.NativeStartedByGSClient();
		m_bNonUbiMatchMakingHost=Class'Actor'.static.NativeNonUbiMatchMakingHost();
		if ( m_bNonUbiMatchMaking || m_bStartedByGSClient || m_bNonUbiMatchMakingHost )
		{
			m_GameService.initGSCDKey();
		}
	}
}

function Object SetGameServiceLinks (PlayerController _localPlayer)
{
	if ( m_GameService != None )
	{
		m_GameService.m_LocalPlayerController=_localPlayer;
	}
	if ( m_LanServers != None )
	{
		m_LanServers.m_LocalPlayerController=_localPlayer;
	}
	return m_GameService;
}

event UserDisconnected ()
{
	if ( bShowLog )
	{
		Log("R6Console::UserDisconnected() Returning to menus due to Server disconnection!");
	}
	if ( m_GameService != None )
	{
		m_GameService.DisconnectAllCDKeyPlayers();
	}
	m_GameService.ResetAuthId();
	SetGameServiceLinks(None);
	if ( m_bNonUbiMatchMaking || m_bNonUbiMatchMakingHost )
	{
//		LeaveR6Game(7);
	}
	else
	{
//		LeaveR6Game(3);
	}
}

event ServerDisconnected ()
{
	if ( bShowLog )
	{
		Log("R6Console::ServerDisconnected() Returning to menus due to Server disconnection!");
	}
//	LeaveR6Game(8);
	m_GameService.ResetAuthId();
	SetGameServiceLinks(None);
}

event R6ConnectionFailed (string szError)
{
	if ( bShowLog )
	{
		Log("R6Console::R6ConnectionFailed() " $ szError);
	}
	m_szLastError=szError;
	Root.ResetMenus(True);
//	LeaveR6Game(8);
	m_GameService.ResetAuthId();
	SetGameServiceLinks(None);
}

event R6ConnectionSuccess ()
{
	if ( bShowLog )
	{
		Log("R6Console::R6ConnectionSuccess()");
	}
/*	if ( Root.m_eRootId != Root.3 )
	{
		LaunchR6MultiPlayerGame();
	}*/
}

event R6ConnectionInterrupted ()
{
	if ( bShowLog )
	{
		Log("R6Console::R6ConnectionInterrupted()");
	}
	Class'Actor'.static.EnableLoadingScreen(True);
	Root.ResetMenus(True);
//	LeaveR6Game(3);
	m_GameService.ResetAuthId();
	SetGameServiceLinks(None);
}

event R6ConnectionInProgress ()
{
	if ( Root.GetSimplePopUpID() == 0 )
	{
//		Root.SimplePopUp(Localize("MultiPlayer","PopUp_Downloading","R6Menu"),Localize("PopUP","PopUpEscCancel","R6Menu"),31,4);
	}
}

event R6ProgressMsg (string _Str1, string _Str2, float Seconds)
{
	local array<string> ATextMsg;

	ATextMsg[0]=_Str1;
	ATextMsg[1]=_Str2;
	Root.ModifyPopUpInsideText(ATextMsg);
}

function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
{
	if ( bShowLog )
	{
		Log("ERROR!!!!!!!!!!!!!!!!!!! IN R6Console >> KeyEvent");
	}
	return False;
}

function bool KeyType (EInputKey Key)
{
	if ( bShowLog )
	{
		Log("ERROR!!!!!!!!!!!!!!!!!!! IN R6Console >> KeyType");
	}
	return False;
}

function PostRender (Canvas Canvas)
{
	if ( bShowLog )
	{
		Log("ERROR!!!!!!!!!!!!!!!!!!! IN R6Console >> PostRender");
	}
}

state UWindow
{
	function BeginState ()
	{
		ConsoleState=GetStateName();
	}

	function PostRender (Canvas Canvas)
	{
		if ( m_bRenderMenuOneTime )
		{
			if ( m_bInterruptConnectionProcess )
			{
				m_bInterruptConnectionProcess=False;
			}
			else
			{
				m_bRenderMenuOneTime=False;
			}
		}
		if ( (bReturnToMenu == True) && (Root != None) )
		{
			bReturnToMenu=False;
			if ( m_bInterruptConnectionProcess )
			{
				m_bRenderMenuOneTime=True;
			}
			switch (m_eNextStep)
			{
/*				case 9:
				Root.ChangeCurrentWidget(m_eLastPreviousWID);
				Root.ChangeCurrentWidget(16);
				Class'Actor'.static.GetModMgr().InitAllModObjects();
				break;
				case 0:
				Root.ChangeCurrentWidget(7);
				break;
				case 2:
				Root.ChangeCurrentWidget(4);
				break;
				case 1:
				if ( m_PlayerCampaign.m_bCampaignCompleted == 1 )
				{
					Root.ChangeCurrentWidget(18);
					Canvas.m_bDisplayGameOutroVideo=True;
				}
				else
				{
					Root.ChangeCurrentWidget(6);
				}
				break;
				case 3:
				if ( m_bStartedByGSClient )
				{
					Root.ChangeCurrentWidget(20);
					m_bReturnToGSClient=True;
				}
				else
				{
					Root.ChangeCurrentWidget(15);
				}
				break;
				case 4:
				Root.ChangeCurrentWidget(11);
				break;
				case 5:
				Root.ChangeCurrentWidget(14);
				break;
				case 6:
				Root.ChangeCurrentWidget(10);
				break;
				case 7:
				Root.ChangeCurrentWidget(37);
				break;
				case 8:
				Class'Actor'.static.GarbageCollect();
				Root.ChangeCurrentWidget(35);
				break;
				default:   */
			}
		}
		if ( (bLaunchWasCalled == True) && (m_bSkipAFrameAndStart == False) )
		{
			if ( bResetLevel )
			{
				ViewportOwner.Actor.Level.SetBankSound(BANK_UnloadGun);
				R6GameInfo(ViewportOwner.Actor.Level.Game).RestartGameMgr();
				StartR6Game(bResetLevel);
//				Root.ChangeCurrentWidget(0);
				bResetLevel=False;
			}
			else
			{
				StartR6Game(bResetLevel);
			}
			bLaunchWasCalled=False;
		}
		else
		{
			m_bSkipAFrameAndStart=False;
			if ( Root != None )
			{
				Root.bUWindowActive=True;
			}
			RenderUWindow(Canvas);
		}
	}

	function bool KeyEvent (EInputKey eKey, EInputAction eAction, float fDelta)
	{
/*		local byte k;

		k=eKey;
		if ( bShowLog )
		{
			Log("R6Console state Uwindow KeyEvent eAction" @ string(eAction) @ "Key" @ string(eKey));
		}
		switch (eAction)
		{
			case 3:
			switch (eKey)
			{
				case 1:
				if ( Root != None )
				{
					Root.WindowEvent(1,None,MouseX,MouseY,k);
				}
				return True;
				case 2:
				if ( Root != None )
				{
					Root.WindowEvent(5,None,MouseX,MouseY,k);
				}
				return True;
				case 4:
				if ( Root != None )
				{
					Root.WindowEvent(3,None,MouseX,MouseY,k);
				}
				return True;
				default:
			}
			if ( Root != None )
			{
				Root.WindowEvent(8,None,MouseX,MouseY,k);
			}
			if ( ViewportOwner.Actor.InPlanningMode() )
			{
				return False;
			}
			else
			{
				if ( Root != None )
				{
					return Root.TrapKey(False);
				}
				else
				{
					return True;
				}
			}
			break;
		}
		goto JL03A3;
		case 1:
		if ( k == ViewportOwner.Actor.GetKey("Console") )
		{
			if ( bLocked )
			{
				return True;
			}
			type();
			return True;
		}
		switch (k)
		{
			case 1:
			if ( Root != None )
			{
				Root.WindowEvent(0,None,MouseX,MouseY,k);
			}
			return True;
			case 2:
			if ( Root != None )
			{
				Root.WindowEvent(4,None,MouseX,MouseY,k);
			}
			return True;
			case 4:
			if ( Root != None )
			{
				Root.WindowEvent(2,None,MouseX,MouseY,k);
			}
			return True;
			case 237:
			if ( Root != None )
			{
				Root.WindowEvent(6,None,MouseX,MouseY,k);
			}
			return True;
			case 236:
			if ( Root != None )
			{
				Root.WindowEvent(7,None,MouseX,MouseY,k);
			}
			return True;
			default:
		}
		if ( Root != None )
		{
			Root.WindowEvent(9,None,MouseX,MouseY,k);
		}
		if ( ViewportOwner.Actor.InPlanningMode() )
		{
			return False;
		}
		else
		{
			if ( Root != None )
			{
				return Root.TrapKey(False);
			}
			else
			{
				return True;
			}
		}
		goto JL0346;
	JL0346:
		goto JL03A3;
		case 4:
		switch (k)
		{
			case 228:
			MouseX=MouseX + MouseScale * fDelta;
			break;
			case 229:
			MouseY=MouseY - MouseScale * fDelta;
			break;
			default:
		}
		goto JL03A3;
		default:
		goto JL03A3;
	JL03A3:
		if ( ViewportOwner.Actor.InPlanningMode() )
		{
			return False;
		}
		else
		{
			if ( Root != None )
			{
				return Root.TrapKey(True);
			}
			else
			{
				return True;
			}
		}*/
		return false;
	}

}

state Typing
{
	function PostRender (Canvas Canvas)
	{
		if ( Root != None )
		{
			Root.bUWindowActive=True;
		}
		RenderUWindow(Canvas);
		Super.PostRender(Canvas);
	}

	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		local string temp;
		local string FileName;
		local int i;

		if ( bShowLog )
		{
			Log("R6Console state Typing KeyEvent Action" @ string(Action) @ "Key" @ string(Key));
		}
		if ( Action == 1 )
		{
			bIgnoreKeys=False;
		}
		if ( (Action == 1) && (Key == ViewportOwner.Actor.GetKey("Console")) )
		{
			GotoState(ConsoleState);
			return True;
		}
		if ( Key == 27 )
		{
			if ( TypedStr != "" )
			{
				TypedStr="";
				HistoryCur=HistoryTop;
			}
			else
			{
				GotoState(ConsoleState);
			}
		}
		else
		{
			if ( (Key == 13) && (Action == 3) )
			{
				if ( TypedStr != "" )
				{
					if ( Caps(Left(TypedStr,Len("WRITESERVER"))) == "WRITESERVER" )
					{
						FileName=Right(TypedStr,Len(TypedStr) - Len("WRITESERVER "));
/*						if ( Root.m_eCurWidgetInUse == Root.19 )
						{
							Root.SetServerOptions();
							Class'Actor'.static.SaveServerOptions(FileName);
							Message(Localize("Errors","LoadSuccessful","R6Engine"),6.00);
							GotoState(ConsoleState);
							return True;
						}*/
					}
					if ( Caps(Left(TypedStr,Len("SHOT"))) != "SHOT" )
					{
						Message(TypedStr,6.00);
					}
					History[HistoryTop]=TypedStr;
					HistoryTop=(HistoryTop + 1) % 16;
					if ( (HistoryBot == -1) || (HistoryBot == HistoryTop) )
					{
						HistoryBot=(HistoryBot + 1) % 16;
					}
					HistoryCur=HistoryTop;
					temp=TypedStr;
					TypedStr="";
					if (  !ConsoleCommand(temp) )
					{
						Message(Localize("Errors","Exec","R6Engine"),6.00);
					}
					Message("",6.00);
					if ( Caps(Left(temp,Len("SHOT"))) == "SHOT" )
					{
						GotoState(ConsoleState);
					}
					else
					{
						if (  !bShowConsoleLog )
						{
							GotoState(ConsoleState);
						}
					}
				}
				else
				{
					GotoState(ConsoleState);
				}
			}
			else
			{
				if ( Action == 3 )
				{
					return True;
				}
				else
				{
					if ( Key == 38 )
					{
						if ( HistoryBot >= 0 )
						{
							if ( HistoryCur == HistoryBot )
							{
								HistoryCur=HistoryTop;
							}
							else
							{
								HistoryCur--;
								if ( HistoryCur < 0 )
								{
									HistoryCur=16 - 1;
								}
							}
							TypedStr=History[HistoryCur];
						}
					}
					else
					{
						if ( Key == 40 )
						{
							if ( HistoryBot >= 0 )
							{
								if ( HistoryCur == HistoryTop )
								{
									HistoryCur=HistoryBot;
								}
								else
								{
									HistoryCur=(HistoryCur + 1) % 16;
								}
								TypedStr=History[HistoryCur];
							}
						}
						else
						{
							if ( (Key == 8) || (Key == 37) )
							{
								m_bStringIsTooLong=False;
								if ( Len(TypedStr) > 0 )
								{
									TypedStr=Left(TypedStr,Len(TypedStr) - 1);
								}
							}
						}
					}
				}
			}
		}
		return True;
	}

}

state Game
{
	function BeginState ()
	{
		if ( bShowLog )
		{
			Log("R6Console  Game::BeginState");
		}
		bCancelFire=True;
		ConsoleState=GetStateName();
	}

	function PostRender (Canvas Canvas)
	{
		if ( Root != None )
		{
			Root.bUWindowActive=True;
			RenderUWindow(Canvas);
		}
	}

	function EndState ()
	{
		if ( bShowLog )
		{
			Log("R6Console  Game::EndState");
		}
		if ( ViewportOwner.Actor != None )
		{
			if ( R6PlayerController(ViewportOwner.Actor) != None )
			{
				if ( bCancelFire == True )
				{
					R6PlayerController(ViewportOwner.Actor).bFire=0;
				}
			}
			if ( ViewportOwner.Actor.Level != None )
			{
				ViewportOwner.Actor.Level.m_bInGamePlanningZoomingIn=False;
				ViewportOwner.Actor.Level.m_bInGamePlanningZoomingOut=False;
			}
		}
	}

	function bool KeyEvent (EInputKey eKey, EInputAction eAction, float fDelta)
	{
/*		local byte k;
		local int i;

		k=eKey;
		if ( bShowLog )
		{
			Log("R6Console state Game KeyEvent eAction" @ string(eAction) @ "Key" @ string(eKey));
		}
		if (  !bTyping )
		{
			if ( (ViewportOwner.Actor != None) &&  !ViewportOwner.Actor.IsInState('Dead') )
			{
				switch (eAction)
				{
					case 3:
					if ( k == ViewportOwner.Actor.GetKey("ToggleMap") )
					{
						m_bInGamePlanningKeyDown=False;
						return True;
					}
					else
					{
						if ( k == ViewportOwner.Actor.GetKey("MapZoomIn") )
						{
							if ( ViewportOwner.Actor.Level.m_bInGamePlanningActive )
							{
								ViewportOwner.Actor.Level.m_bInGamePlanningZoomingIn=False;
								return True;
							}
						}
						else
						{
							if ( k == ViewportOwner.Actor.GetKey("MapZoomOut") )
							{
								if ( ViewportOwner.Actor.Level.m_bInGamePlanningActive )
								{
									ViewportOwner.Actor.Level.m_bInGamePlanningZoomingOut=False;
									return True;
								}
							}
						}
					}
					break;
					case 1:
					if ( k == ViewportOwner.Actor.GetKey("ToggleMap") )
					{
						if ( ViewportOwner.Actor.Level.m_bInGamePlanningActive == False )
						{
							ViewportOwner.Actor.Level.m_bInGamePlanningActive=True;
							ViewportOwner.Actor.Level.m_bInGamePlanningZoomingIn=False;
							ViewportOwner.Actor.Level.m_bInGamePlanningZoomingOut=False;
							m_bInGamePlanningKeyDown=True;
							return True;
						}
						else
						{
							if ( m_bInGamePlanningKeyDown == False )
							{
								ViewportOwner.Actor.Level.m_bInGamePlanningActive=False;
								ViewportOwner.Actor.Level.m_bInGamePlanningZoomingIn=False;
								ViewportOwner.Actor.Level.m_bInGamePlanningZoomingOut=False;
								return True;
							}
						}
					}
					else
					{
						if ( k == ViewportOwner.Actor.GetKey("MapZoomIn") )
						{
							if ( ViewportOwner.Actor.Level.m_bInGamePlanningActive )
							{
								ViewportOwner.Actor.Level.m_bInGamePlanningZoomingIn=True;
								return True;
							}
						}
						else
						{
							if ( k == ViewportOwner.Actor.GetKey("MapZoomOut") )
							{
								if ( ViewportOwner.Actor.Level.m_bInGamePlanningActive )
								{
									ViewportOwner.Actor.Level.m_bInGamePlanningZoomingOut=True;
									return True;
								}
							}
						}
					}
					break;
					default:
				}
			}
			switch (eAction)
			{
				case 3:
				if ( k == ViewportOwner.Actor.GetKey("ShowCompleteHUD") )
				{
					R6PlayerController(ViewportOwner.Actor).m_bShowCompleteHUD=False;
					return True;
				}
				switch (k)
				{
					case 1:
					if ( Root != None )
					{
						Root.WindowEvent(1,None,MouseX,MouseY,k);
					}
					break;
					case 2:
					if ( Root != None )
					{
						Root.WindowEvent(5,None,MouseX,MouseY,k);
					}
					break;
					case 4:
					if ( Root != None )
					{
						Root.WindowEvent(3,None,MouseX,MouseY,k);
					}
					break;
					default:
					if ( Root != None )
					{
						Root.WindowEvent(8,None,MouseX,MouseY,k);
					}
					break;
				}
				break;
				case 1:
				if ( k == ViewportOwner.Actor.GetKey("Console") )
				{
					type();
					return True;
				}
				else
				{
					if ( k == ViewportOwner.Actor.GetKey("ShowCompleteHUD") )
					{
						R6PlayerController(ViewportOwner.Actor).m_bShowCompleteHUD=True;
						return True;
					}
				}
				switch (k)
				{
					case 1:
					if ( Root != None )
					{
						Root.WindowEvent(0,None,MouseX,MouseY,k);
					}
					break;
					case 2:
					if ( Root != None )
					{
						Root.WindowEvent(4,None,MouseX,MouseY,k);
					}
					break;
					case 4:
					if ( Root != None )
					{
						Root.WindowEvent(2,None,MouseX,MouseY,k);
					}
					break;
					default:
					if ( Root != None )
					{
						Root.WindowEvent(9,None,MouseX,MouseY,k);
					}
					break;
				}
				break;
				case 4:
				switch (k)
				{
					case 228:
					MouseX=MouseX + MouseScale * fDelta;
					break;
					case 229:
					MouseY=MouseY - MouseScale * fDelta;
					break;
					default:
				}
				break;
				default:
			}
		}
		else
		{
		}*/
		return False;
	}

}

state TrainingInstruction extends UWindowCanPlay
{
	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		local byte k;

		k=Key;
		if ( bShowLog )
		{
			Log("R6Console state TrainingInstruction KeyEvent eAction" @ string(Action) @ "Key" @ string(Key));
		}
		switch (Action)
		{
/*			case 3:
			if ( (k == 27) || (k == ViewportOwner.Actor.GetKey("Action")) )
			{
				if ( Root != None )
				{
					Root.WindowEvent(8,None,MouseX,MouseY,k);
				}
				return True;
			}
			break;
			case 1:
			if ( k == ViewportOwner.Actor.GetKey("Console") )
			{
				if ( bLocked )
				{
					return True;
				}
				type();
				return True;
			}
			if ( k == ViewportOwner.Actor.GetKey("Action") )
			{
				return True;
			}
			if ( Root != None )
			{
				Root.WindowEvent(9,None,MouseX,MouseY,k);
			}
			break;
			default:
			break;   */
		}
		return False;
	}

}

function LaunchInstructionMenu (R6InstructionSoundVolume pISV, bool bShow, int iBox, int iParagraph)
{
	Root.ChangeInstructionWidget(pISV,bShow,iBox,iParagraph);
}

event LaunchR6MainMenu ()
{
	local UWindowMenuClassDefines pMenuDefGSServers;
	local int i;

	if ( bShowLog )
	{
		Log("R6Console LaunchR6MainMenu");
	}
	bVisible=True;
	bUWindowActive=True;
	pMenuDefGSServers=new Class'UWindowMenuClassDefines';
	pMenuDefGSServers.Created();
	RootWindow=pMenuDefGSServers.RegularRoot;
	CreateRootWindow(None);
	LaunchUWindow();
}

function NotifyLevelChange ()
{
	if ( bShowLog )
	{
		Log("R6Console NotifyLevelChange");
	}
	Super.NotifyLevelChange();
	if ( R6PlayerController(ViewportOwner.Actor) != None )
	{
		R6PlayerController(ViewportOwner.Actor).ClearReferences();
	}
}

function LeaveR6Game (eLeaveGame _bwhatToDo)
{
	local Canvas C;
	local bool bCleanUp;
	local R6ServerInfo ServerInfo;

	if ( bShowLog )
	{
		Log("R6Console LeaveR6Game");
	}
	if ( bReturnToMenu )
	{
		return;
	}
	bReturnToMenu=True;
	CleanSound(_bwhatToDo);
	Master.m_MenuCommunication=None;
	CloseR6MainMenu(True);
	LaunchR6MainMenu();
	C=Class'Actor'.static.GetCanvas();
	C.m_iNewResolutionX=640;
	C.m_iNewResolutionY=480;
	C.m_bChangeResRequested=True;
	C.m_bFading=False;
	ServerInfo=Class'Actor'.static.GetServerOptions();
	ServerInfo.m_ServerMapList=None;
	ServerInfo.m_GameInfo=None;
	switch (_bwhatToDo)
	{
/*		case 1:
		m_eNextStep=1;
		CleanPlanning();
		if ( m_PlayerCampaign.m_bCampaignCompleted == 1 )
		{
			bCleanUp=True;
		}
		break;
		case 3:
		m_eNextStep=3;
		bCleanUp=True;
		break;
		case 4:
		CleanPlanning();
		Master.m_StartGameInfo.m_ReloadPlanning=True;
		ViewportOwner.Actor.SetPlanningMode(True);
		m_eNextStep=4;
		if ( R6PlayerController(ViewportOwner.Actor) != None )
		{
			R6PlayerController(ViewportOwner.Actor).ClearReferences();
		}
		break;
		case 5:
		CleanPlanning();
		m_eNextStep=5;
		bCleanUp=True;
		break;
		case 6:
		CleanPlanning();
		Master.m_StartGameInfo.m_ReloadPlanning=True;
		ViewportOwner.Actor.SetPlanningMode(True);
		m_eNextStep=6;
		if ( R6PlayerController(ViewportOwner.Actor) != None )
		{
			R6PlayerController(ViewportOwner.Actor).ClearReferences();
		}
		break;
		case 7:
		CleanPlanning();
		m_eNextStep=7;
		bCleanUp=True;
		break;
		case 8:
		m_eNextStep=8;
		bCleanUp=True;
		break;
		case 2:
		CleanPlanning();
		m_eNextStep=2;
		bCleanUp=True;
		break;
		case 9:
		CleanPlanning();
		m_eNextStep=9;
		bCleanUp=True;
		break;
		case 0:
		default:
		CleanPlanning();
		m_eNextStep=0;
		bCleanUp=True;
		break;*/
	}
	if ( bCleanUp )
	{
		if ( (ViewportOwner.Actor != None) && (ViewportOwner.Actor.Level.NetMode == NM_Standalone) )
		{
			if ( ViewportOwner.Actor.Level != ViewportOwner.Actor.GetEntryLevel() )
			{
				Master.m_StartGameInfo.m_MapName="Entry";
				PreloadMapForPlanning();
			}
		}
		else
		{
			ConsoleCommand("DISCONNECT");
		}
	}
	bMultiPlayerGameActive=False;
	if ( m_GameService.m_bServerJoined )
	{
		m_GameService.NativeMSCLientLeaveServer();
	}
	ViewportOwner.Actor.SpawnDefaultHUD();
}

function CleanSound (eLeaveGame _bwhatToDo)
{
	ViewportOwner.Actor.StopAllSounds();
	ViewportOwner.Actor.ResetVolume_AllTypeSound();
	switch (_bwhatToDo)
	{
		case LG_RetryPlanningCustomMission:
		ViewportOwner.Actor.FadeSound(0.00,25,SLOT_Music);
		case LG_CustomMissionMenu:
		case LG_RetryPlanningCampaign:
		break;
		case LG_NextLevel:
		if ( ViewportOwner.Actor.Level.NetMode != 0 )
		{
			ViewportOwner.Actor.StopAllMusic();
		}
		ViewportOwner.Actor.Level.SetBankSound(BANK_UnloadAll);
		ViewportOwner.Actor.Level.FinalizeLoading();
		break;
		case LG_QuitGame:
		case LG_Trainning:
		case LG_MultiPlayerMenu:
		case LG_InitMod:
		ViewportOwner.Actor.StopAllMusic();
		case LG_MainMenu:
		default:
		ViewportOwner.Actor.Level.SetBankSound(BANK_UnloadAll);
		ViewportOwner.Actor.Level.FinalizeLoading();
		break;
	}
}

function CleanPlanning ()
{
	if ( ViewportOwner.Actor.Level.NetMode == NM_Standalone )
	{
		if ( (Master == None) || (Master.m_StartGameInfo == None) )
		{
			return;
		}
		Master.m_StartGameInfo.m_TeamInfo[0].m_iNumberOfMembers=0;
		Master.m_StartGameInfo.m_TeamInfo[1].m_iNumberOfMembers=0;
		Master.m_StartGameInfo.m_TeamInfo[2].m_iNumberOfMembers=0;
		if ( Master.m_StartGameInfo.m_TeamInfo[0].m_pPlanning == None )
		{
			return;
		}
		Master.m_StartGameInfo.m_TeamInfo[0].m_pPlanning.DeleteAllNode();
		Master.m_StartGameInfo.m_TeamInfo[1].m_pPlanning.DeleteAllNode();
		Master.m_StartGameInfo.m_TeamInfo[2].m_pPlanning.DeleteAllNode();
		Master.m_StartGameInfo.m_TeamInfo[0].m_pPlanning.m_pTeamManager=None;
		Master.m_StartGameInfo.m_TeamInfo[1].m_pPlanning.m_pTeamManager=None;
		Master.m_StartGameInfo.m_TeamInfo[2].m_pPlanning.m_pTeamManager=None;
	}
}

function CloseR6MainMenu (optional bool bKeepInputSystem)
{
	if ( bShowLog )
	{
		Log("R6Console CloseR6MainMenu");
	}
	Class'Actor'.static.GetModMgr().UnRegisterAllObject();
	Class'Actor'.static.GetModMgr().RegisterObject(self);
	Class'Actor'.static.GetModMgr().RegisterObject(m_GameService);
	bVisible=False;
	ResetUWindow();
	if ( bKeepInputSystem == False )
	{
		ViewportOwner.Actor.ChangeInputSet(0);
		ViewportOwner.Actor.Level.m_bPlaySound=True;
	}
}

function PreloadMapForPlanning ()
{
	local int iPlayerSpawnNumber;

	ConsoleCommand("Start " $ Master.m_StartGameInfo.m_MapName $ "?SpawnNum=" $ string(iPlayerSpawnNumber));
//	ViewportOwner.Actor.ChangeInputSet(1);
}

function CreateInGameMenus ()
{
	local UWindowMenuClassDefines pMenuDefGSServers;

	Log("R6Console CreateInGameMenus bLaunchMultiPlayer" @ string(bLaunchMultiPlayer));
	pMenuDefGSServers=new Class'UWindowMenuClassDefines';
	pMenuDefGSServers.Created();
	if ( bLaunchMultiPlayer )
	{
		RootWindow=pMenuDefGSServers.InGameMultiRoot;
		bUWindowActive=True;
		CreateRootWindow(None);
		LaunchUWindow();
	}
	else
	{
		RootWindow=pMenuDefGSServers.InGameSingleRoot;
		CreateRootWindow(None);
	}
}

function ResetR6Game ()
{
	if ( bShowLog )
	{
		Log("R6Console ResetR6Game");
	}
	bLaunchWasCalled=True;
	bResetLevel=True;
}

function LaunchR6Game (optional bool bSkipFrameAndStart_)
{
	if ( bShowLog )
	{
		Log("R6Console LaunchR6Game");
	}
	bLaunchWasCalled=True;
	m_bSkipAFrameAndStart=bSkipFrameAndStart_;
}

function LaunchR6MultiPlayerGame ()
{
	if ( bShowLog )
	{
		Log("R6Console LaunchR6MultiPlayerGame");
	}
	bLaunchWasCalled=True;
	bLaunchMultiPlayer=True;
}

function LaunchTraining ()
{
	Master.m_StartGameInfo.m_bIsPlaying=True;
	PreloadMapForPlanning();
}

function StartR6Game (optional bool bResetLevel)
{
	local R6PlayerController aPC;

	if ( bShowLog )
	{
		Log("R6Console StartR6Game bResetLevel=" @ string(bResetLevel));
	}
	ViewportOwner.Actor.StopMusic(m_StopMainMenuMusic);
	m_bStartR6GameInProgress=True;
	if (  !bResetLevel )
	{
		Class'Actor'.static.GetCanvas().m_iNewResolutionX=0;
		Class'Actor'.static.GetCanvas().m_iNewResolutionY=0;
		Class'Actor'.static.GetCanvas().m_bChangeResRequested=True;
	}
	if (  !bResetLevel )
	{
		CloseR6MainMenu();
	}
	if (  !bResetLevel )
	{
		CreateInGameMenus();
	}
	if ( bLaunchMultiPlayer == False )
	{
		if ( ViewportOwner.Actor.Level.Game.IsA('R6GameInfo') )
		{
			ViewportOwner.Actor.Level.Game.DeployCharacters(ViewportOwner.Actor);
		}
	}
	ViewportOwner.Actor.ClientSetHUD(Class'R6HUD',None);
	Class'Actor'.static.GarbageCollect();
	if ( (ViewportOwner.Actor.Level.NetMode == NM_Standalone) && ViewportOwner.Actor.Level.Game.IsA('R6AbstractGameInfo') )
	{
		R6AbstractGameInfo(ViewportOwner.Actor.Level.Game).SpawnAIandInitGoInGame();
		ViewportOwner.Actor.Level.Game.m_bGameStarted=True;
	}
	if ( bLaunchMultiPlayer )
	{
		bMultiPlayerGameActive=True;
	}
	else
	{
		aPC=R6PlayerController(ViewportOwner.Actor);
		if ( aPC != None )
		{
			if ( R6GameInfo(ViewportOwner.Actor.Level.Game).m_bUseClarkVoice )
			{
				aPC.AddSoundBankName(R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission).m_InGameVoiceClarkBankName);
				ViewportOwner.Actor.Level.m_sndPlayMissionIntro=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission).m_PlayMissionIntro;
				ViewportOwner.Actor.Level.m_sndPlayMissionExtro=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission).m_PlayMissionExtro;
			}
			ViewportOwner.Actor.ServerSendBankToLoad();
			aPC.ServerReadyToLoadWeaponSound();
		}
	}
	bLaunchMultiPlayer=False;
	m_bStartR6GameInProgress=False;
}

exec function unlock ()
{
	local int i;
	local int j;

	i=0;
JL0007:
	if ( i < m_aCampaigns.Length )
	{
		j=0;
JL001E:
		if ( j < m_aCampaigns[i].m_missions.Length )
		{
			m_aCampaigns[i].m_missions[j].m_bIsLocked=False;
			j++;
			goto JL001E;
		}
		i++;
		goto JL0007;
	}
}

function SendGoCode (EGoCode eGo)
{
	local int i;

	i=0;
JL0007:
	if ( i < 3 )
	{
//		Master.m_StartGameInfo.m_TeamInfo[i].m_pPlanning.NotifyActionPoint(4,eGo);
		i++;
		goto JL0007;
	}
}

function int GetSpawnNumber ()
{
	local R6StartGameInfo StartGameInfo;

	StartGameInfo=Master.m_StartGameInfo;
	if ( StartGameInfo == None )
	{
		return 0;
	}
	if (  !StartGameInfo.m_bIsPlaying )
	{
		return 0;
	}
	return StartGameInfo.m_TeamInfo[StartGameInfo.m_iTeamStart].m_iSpawningPointNumber;
}

event GameServiceTick ()
{
	if ( m_bStartedByGSClient )
	{
		GSClientManager();
	}
	else
	{
		MSClientManager();
	}
}

function MSClientManager ()
{
	local bool bMSCLientActive;
	local R6GameReplicationInfo pReplInfo;
	local bool bServerIDValid;

	pReplInfo=None;
	if ( Master.m_MenuCommunication != None )
	{
		if ( Master.m_MenuCommunication.m_GameRepInfo != None )
		{
			pReplInfo=R6GameReplicationInfo(Master.m_MenuCommunication.m_GameRepInfo);
		}
	}
	if ( m_GameService == None )
	{
		return;
	}
	if ( bMultiPlayerGameActive && (pReplInfo != None) )
	{
/*		if ( pReplInfo.m_eCurrectServerState == pReplInfo.1 )
		{
			bServerIDValid=(pReplInfo.m_iGameSvrLobbyID != 0) && (pReplInfo.m_iGameSvrGroupID != 0);
			switch (m_GameService.m_eMenuLoginMasterSvr)
			{
				case 3:
				m_GameService.m_eMenuLoginMasterSvr=0;
				m_iRetryTime=m_GameService.NativeGetSeconds() + 5;
				if ( bShowLog )
				{
					Log("Failed to log in to ubi.com");
				}
				break;
				case 2:
				m_GameService.m_eMenuLoginMasterSvr=0;
				break;
				case 0:
				if ( bServerIDValid &&  !m_GameService.NativeGetMSClientInitialized() && (m_GameService.NativeGetSeconds() > m_iRetryTime) )
				{
					m_GameService.InitializeMSClient();
					if ( bShowLog )
					{
						Log("retry");
					}
				}
				break;
				default:
			}
			if ( m_GameService.m_bLoggedInUbiDotCom &&  !m_GameService.m_bServerJoined && bServerIDValid && (m_GameService.m_eMenuJoinServer == 0) && (m_GameService.NativeGetSeconds() > m_iRetryTime) )
			{
				m_GameService.joinServer(pReplInfo.m_iGameSvrLobbyID,pReplInfo.m_iGameSvrGroupID,szStoreGamePassWd);
			}
		}
		switch (m_GameService.m_eMenuJoinServer)
		{
			case 2:
			if ( bShowLog )
			{
				Log("Server Join success");
			}
			m_GameService.m_eMenuJoinServer=0;
			break;
			case 3:
			if ( bShowLog )
			{
				Log("Server Join Failure");
			}
			m_iRetryTime=m_GameService.NativeGetSeconds() + 5;
			m_GameService.m_eMenuJoinServer=0;
			break;
			default:
		}*/
	}
	if ( m_GameService.m_bMSClientRouterDisconnect )
	{
		m_iRetryTime=m_GameService.NativeGetSeconds() + 5;
		m_GameService.UnInitializeMSClient();
		m_GameService.m_bMSClientRouterDisconnect=False;
	}
	if ( m_GameService.m_bMSClientLobbyDisconnect )
	{
		if ( m_GameService.m_bServerJoined )
		{
			m_GameService.NativeMSCLientLeaveServer();
		}
		m_GameService.m_bMSClientLobbyDisconnect=False;
		m_iRetryTime=m_GameService.NativeGetSeconds() + 5;
	}
	m_GameService.GameServiceManager(True,True,False,False);
}

function GSClientManager ()
{
	if (  !m_bGSClientAlreadyInit &&  !m_GameService.m_bGSClientInitialized )
	{
		m_GameService.InitializeGSClient();
		m_bGSClientAlreadyInit=m_GameService.m_bGSClientInitialized;
	}
	m_GameService.GameServiceManager(True,True,False,True);
	switch (m_GameService.m_eGSGameState)
	{
/*		case 0:
		if ( m_GameService.m_bUbiComClientDied )
		{
			ConsoleCommand("quit");
			Log("Game exited because ubi.com client application died");
		}
		if ( m_bReturnToGSClient )
		{
			m_bReturnToGSClient=False;
			MinimizeAndPauseMusic();
		}
		break;
		case 1:
		if ( bShowLog )
		{
			Log("*** EGS_GS_CLIENT_INIT_RCVD");
		}
		m_GameService.NativeGSClientPostMessage(3);
		m_GameService.m_eGSGameState=2;
		break;
		case 2:
		if ( m_GameService.m_bUbiComClientDied )
		{
			ConsoleCommand("quit");
			Log("Game exited because ubi.com client application died");
		}
		if ( m_GameService.m_bUbiComRoomDestroyed )
		{
			m_GameService.m_bUbiComRoomDestroyed=False;
			m_GameService.m_eGSGameState=0;
		}
		break;
		case 3:
		if ( bShowLog )
		{
			Log("*** EGS_CLIENT_CHSTA_RCVD");
		}
		ConsoleCommand("MAXIMIZEAPP");
		m_GameService.NativeGSClientPostMessage(4);
		m_GameService.m_eGSGameState=4;
		m_bJoinUbiServer=True;
		break;
		case 4:
		if ( m_bReturnToGSClient )
		{
			if ( bShowLog )
			{
				Log("*** EGS_WAITING_FOR_GS_INIT");
			}
			m_bReturnToGSClient=False;
			MinimizeAndPauseMusic();
			m_GameService.NativeGSClientPostMessage(5);
			m_GameService.m_eGSGameState=0;
		}
		break;
		case 5:
		if ( bShowLog )
		{
			Log("*** EGS_SERVER_INIT_RCVD");
		}
		m_GameService.NativeGSClientPostMessage(0);
		m_GameService.m_eGSGameState=6;
		break;
		case 6:
		if ( m_GameService.m_bUbiComClientDied )
		{
			ConsoleCommand("quit");
			Log("Game exited because ubi.com client application died");
		}
		break;
		case 7:
		if ( bShowLog )
		{
			Log("*** EGS_SERVER_CHSTA_RCVD");
		}
		ViewportOwner.Actor.PlaySound(Sound'Play_theme_Musicsilence',5);
		ConsoleCommand("MAXIMIZEAPP");
		m_GameService.NativeGSClientPostMessage(1);
		m_GameService.m_eGSGameState=8;
		m_bCreateUbiServer=True;
		break;
		case 8:
		if ( m_bReturnToGSClient )
		{
			if ( bShowLog )
			{
				Log("*** EGS_WAITING_FOR_GS_INIT");
			}
			m_bReturnToGSClient=False;
			MinimizeAndPauseMusic();
			m_GameService.NativeGSClientPostMessage(5);
			m_GameService.m_eGSGameState=0;
		}
		else
		{
			if ( bMultiPlayerGameActive )
			{
				if ( bShowLog )
				{
					Log("*** EGS_SERVER_READY");
				}
				m_GameService.NativeGSClientPostMessage(2);
				m_GameService.m_eGSGameState=10;
			}
		}
		break;
		case 10:
		if ( m_bReturnToGSClient )
		{
			if ( bShowLog )
			{
				Log("*** EGS_WAITING_FOR_GS_INIT");
			}
			m_bReturnToGSClient=False;
			MinimizeAndPauseMusic();
			m_GameService.NativeGSClientPostMessage(5);
			m_GameService.m_eGSGameState=0;
		}
		break;
		case 9:
		ConsoleCommand("quit");
		break;
		default:  */
	}
}

function MinimizeAndPauseMusic ()
{
	ViewportOwner.Actor.StopAllMusic();
	ConsoleCommand("MINIMIZEAPP");
}

function R6Campaign GetCampaignFromString (string szName)
{
	local int i;
	local int j;

JL0000:
	if ( i < m_aCampaigns.Length )
	{
		if ( Caps(m_aCampaigns[i].m_szCampaignFile) == Caps(szName) )
		{
			return m_aCampaigns[i];
		}
		++i;
		goto JL0000;
	}
	return None;
}

function UnlockMissions ()
{
	local int i;
	local int iMissionIndex;
	local int iMaxMissionIndex;
	local R6Campaign campaign;

	if ( m_playerCustomMission == None )
	{
		return;
	}
	i=0;
JL0014:
	if ( i < m_playerCustomMission.m_aCampaignFileName.Length )
	{
		campaign=GetCampaignFromString(m_playerCustomMission.m_aCampaignFileName[i]);
		if ( campaign != None )
		{
			iMaxMissionIndex=m_playerCustomMission.m_iNbMapUnlock[i];
			iMaxMissionIndex++;
			iMaxMissionIndex=Clamp(iMaxMissionIndex,0,campaign.m_missions.Length);
			iMissionIndex=0;
JL009D:
			if ( iMissionIndex < iMaxMissionIndex )
			{
				campaign.m_missions[iMissionIndex].m_bIsLocked=False;
				++iMissionIndex;
				goto JL009D;
			}
		}
		i++;
		goto JL0014;
	}
}

function bool UpdateCurrentMapAvailable (R6PlayerCampaign pCampaign, optional bool bCheckCampaignMission)
{
	local bool bFileChange;
	local bool bInTab;
	local int i;
	local int j;
	local string szIniFile;
	local R6Campaign pCampaignMatch;

	i=0;
JL0007:
	if ( i < m_playerCustomMission.m_aCampaignFileName.Length )
	{
		if ( m_playerCustomMission.m_aCampaignFileName[i] == pCampaign.m_CampaignFileName )
		{
			bInTab=True;
			if ( m_playerCustomMission.m_iNbMapUnlock[i] < pCampaign.m_iNoMission )
			{
				bFileChange=True;
				m_playerCustomMission.m_iNbMapUnlock[i]=pCampaign.m_iNoMission;
			}
		}
		else
		{
			i++;
			goto JL0007;
		}
	}
	if (  !bInTab && (pCampaign.m_CampaignFileName != "") )
	{
		m_playerCustomMission.m_aCampaignFileName[m_playerCustomMission.m_aCampaignFileName.Length]=pCampaign.m_CampaignFileName;
		m_playerCustomMission.m_iNbMapUnlock[m_playerCustomMission.m_iNbMapUnlock.Length]=pCampaign.m_iNoMission;
		bFileChange=True;
	}
	if ( bCheckCampaignMission == True )
	{
		i=0;
JL0145:
		if ( i < m_aCampaigns.Length )
		{
			if ( pCampaign.m_CampaignFileName == m_aCampaigns[i].m_szCampaignFile )
			{
				pCampaignMatch=m_aCampaigns[i];
			}
			else
			{
				i++;
				goto JL0145;
			}
		}
		i=0;
JL01A1:
		if ( (pCampaignMatch != None) && (i < pCampaignMatch.missions.Length) )
		{
			pCampaignMatch.missions[i]=Caps(pCampaignMatch.missions[i]);
			szIniFile=pCampaignMatch.missions[i] $ ".INI";
			j=0;
JL021B:
			if ( j < m_aMissionDescriptions.Length )
			{
				if ( m_aMissionDescriptions[j].m_missionIniFile == szIniFile )
				{
					m_aMissionDescriptions[j].m_bCampaignMission=True;
				}
				else
				{
					j++;
					goto JL021B;
				}
			}
			i++;
			goto JL01A1;
		}
	}
	if ( bFileChange )
	{
		UnlockMissions();
	}
	return bFileChange;
}

function GetAllMissionDescriptions ()
{
	local int i;
	local int j;
	local int iFiles;
	local int iIniFiles;
	local int Index;
	local R6FileManager pIniFileManager;
	local string szName;
	local string szFileName;
	local string szIniName;
	local string szIniFilename;
	local string szCurrentMapDir;
	local bool bMissionIsValid;
	local bool bAddedModMaps;
	local R6FileManager pFileManager;
	local R6Mod pCurrentMod;

	m_aMissionDescriptions.Remove (0,m_aMissionDescriptions.Length);
	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	bAddedModMaps=False;
	szCurrentMapDir="..\\maps\\";
	pIniFileManager=new Class'R6FileManager';
	pFileManager=new Class'R6FileManager';
JL005E:
	if ( szCurrentMapDir != "" )
	{
		iIniFiles=pIniFileManager.GetNbFile(szCurrentMapDir,"ini");
		iFiles=pFileManager.GetNbFile(szCurrentMapDir,Class'Actor'.static.GetMapNameExt());
		Log("Looking for maps In Dir : " $ szCurrentMapDir $ ", found : " $ string(iIniFiles) $ " .ini files" $ " and " $ string(iFiles) $ ".rsm");
		i=0;
JL0115:
		if ( i < iIniFiles )
		{
			pIniFileManager.GetFileName(i,szIniFilename);
			if ( szIniFilename == "" )
			{
				goto JL0283;
			}
			bMissionIsValid=True;
			Index=m_aMissionDescriptions.Length;
			m_aMissionDescriptions[Index]=new Class'R6MissionDescription';
			m_aMissionDescriptions[Index].Init(ViewportOwner.Actor.Level,szCurrentMapDir $ szIniFilename);
			if ( m_aMissionDescriptions[Index].m_MapName != "" )
			{
				j=0;
JL01CC:
				if ( j < iFiles )
				{
					bMissionIsValid=False;
					pFileManager.GetFileName(j,szFileName);
					if ( szFileName == "" )
					{
						goto JL0257;
					}
					szName=Left(szFileName,InStr(szFileName,"."));
					szName=Caps(szName);
					if ( szName == Caps(m_aMissionDescriptions[Index].m_MapName) )
					{
						bMissionIsValid=True;
					}
					else
					{
JL0257:
						j++;
						goto JL01CC;
					}
				}
			}
			else
			{
				bMissionIsValid=False;
			}
			if (  !bMissionIsValid )
			{
				m_aMissionDescriptions.Remove (Index,1);
			}
JL0283:
			i++;
			goto JL0115;
		}
		if (  !Class'Actor'.static.GetModMgr().IsRavenShield() &&  !bAddedModMaps )
		{
			szCurrentMapDir="..\\Mods\\" $ pCurrentMod.m_szCampaignDir $ "\\maps\\";
			bAddedModMaps=True;
		}
		else
		{
			szCurrentMapDir="";
		}
		goto JL005E;
	}
	UnlockMissions();
}

function GetRestKitDescName (GameReplicationInfo gameRepInfo, R6ServerInfo pServerOptions)
{
	local int _iCount;
	local bool _bFound;
	local Class<R6Description> WeaponClass;
	local R6GameReplicationInfo _GRI;
	local R6Mod pCurrentMod;
	local int i;

	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	_GRI=R6GameReplicationInfo(gameRepInfo);
	i=0;
JL0032:
	if ( i < pCurrentMod.m_aDescriptionPackage.Length )
	{
		WeaponClass=Class<R6Description>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[i] $ ".u",Class'R6Description'));
		_iCount=0;
JL007F:
		if ( (_iCount < 32) && (_GRI.m_szSubMachineGunsRes[_iCount] != "") )
		{
			_bFound=False;
JL00B0:
			if ( (WeaponClass != None) && (_bFound == False) )
			{
				if ( WeaponClass.Default.m_NameID == _GRI.m_szSubMachineGunsRes[_iCount] )
				{
					pServerOptions.RestrictedSubMachineGuns[_iCount]=WeaponClass;
					_bFound=True;
				}
				WeaponClass=Class<R6Description>(GetNextClass());
				goto JL00B0;
			}
			WeaponClass=Class<R6Description>(RewindToFirstClass());
			_iCount++;
			goto JL007F;
		}
		_iCount=0;
JL0142:
		if ( (_iCount < 32) && (_GRI.m_szShotGunRes[_iCount] != "") )
		{
			_bFound=False;
JL0173:
			if ( (WeaponClass != None) && (_bFound == False) )
			{
				if ( WeaponClass.Default.m_NameID == _GRI.m_szShotGunRes[_iCount] )
				{
					pServerOptions.RestrictedShotGuns[_iCount]=WeaponClass;
					_bFound=True;
				}
				WeaponClass=Class<R6Description>(GetNextClass());
				goto JL0173;
			}
			WeaponClass=Class<R6Description>(RewindToFirstClass());
			_iCount++;
			goto JL0142;
		}
		_iCount=0;
JL0205:
		if ( (_iCount < 32) && (_GRI.m_szAssRifleRes[_iCount] != "") )
		{
			_bFound=False;
JL0236:
			if ( (WeaponClass != None) && (_bFound == False) )
			{
				if ( WeaponClass.Default.m_NameID == _GRI.m_szAssRifleRes[_iCount] )
				{
					pServerOptions.RestrictedAssultRifles[_iCount]=WeaponClass;
					_bFound=True;
				}
				WeaponClass=Class<R6Description>(GetNextClass());
				goto JL0236;
			}
			WeaponClass=Class<R6Description>(RewindToFirstClass());
			_iCount++;
			goto JL0205;
		}
		_iCount=0;
JL02C8:
		if ( (_iCount < 32) && (_GRI.m_szMachGunRes[_iCount] != "") )
		{
			_bFound=False;
JL02F9:
			if ( (WeaponClass != None) && (_bFound == False) )
			{
				if ( WeaponClass.Default.m_NameID == _GRI.m_szMachGunRes[_iCount] )
				{
					pServerOptions.RestrictedMachineGuns[_iCount]=WeaponClass;
					_bFound=True;
				}
				WeaponClass=Class<R6Description>(GetNextClass());
				goto JL02F9;
			}
			WeaponClass=Class<R6Description>(RewindToFirstClass());
			_iCount++;
			goto JL02C8;
		}
		_iCount=0;
JL038B:
		if ( (_iCount < 32) && (_GRI.m_szSnipRifleRes[_iCount] != "") )
		{
			_bFound=False;
JL03BC:
			if ( (WeaponClass != None) && (_bFound == False) )
			{
				if ( WeaponClass.Default.m_NameID == _GRI.m_szSnipRifleRes[_iCount] )
				{
					pServerOptions.RestrictedSniperRifles[_iCount]=WeaponClass;
					_bFound=True;
				}
				WeaponClass=Class<R6Description>(GetNextClass());
				goto JL03BC;
			}
			WeaponClass=Class<R6Description>(RewindToFirstClass());
			_iCount++;
			goto JL038B;
		}
		_iCount=0;
JL044E:
		if ( (_iCount < 32) && (_GRI.m_szPistolRes[_iCount] != "") )
		{
			_bFound=False;
JL047F:
			if ( (WeaponClass != None) && (_bFound == False) )
			{
				if ( WeaponClass.Default.m_NameID == _GRI.m_szPistolRes[_iCount] )
				{
					pServerOptions.RestrictedPistols[_iCount]=WeaponClass;
					_bFound=True;
				}
				WeaponClass=Class<R6Description>(GetNextClass());
				goto JL047F;
			}
			WeaponClass=Class<R6Description>(RewindToFirstClass());
			_iCount++;
			goto JL044E;
		}
		_iCount=0;
JL0511:
		if ( (_iCount < 32) && (_GRI.m_szMachPistolRes[_iCount] != "") )
		{
			_bFound=False;
JL0542:
			if ( (WeaponClass != None) && (_bFound == False) )
			{
				if ( WeaponClass.Default.m_NameID == _GRI.m_szMachPistolRes[_iCount] )
				{
					pServerOptions.RestrictedMachinePistols[_iCount]=WeaponClass;
					_bFound=True;
				}
				WeaponClass=Class<R6Description>(GetNextClass());
				goto JL0542;
			}
			WeaponClass=Class<R6Description>(RewindToFirstClass());
			_iCount++;
			goto JL0511;
		}
		FreePackageObjects();
		i++;
		goto JL0032;
	}
}

defaultproperties
{
    RootWindow="R6Menu.R6MenuRootWindow"
}
/*
    m_StopMainMenuMusic=Sound'Music.Play_theme_Musicsilence'
*/

