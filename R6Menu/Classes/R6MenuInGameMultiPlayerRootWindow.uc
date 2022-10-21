//================================================================================
// R6MenuInGameMultiPlayerRootWindow.
//================================================================================
class R6MenuInGameMultiPlayerRootWindow extends R6WindowRootWindow;

enum EGameModeInfo {
	GMI_None,
	GMI_SinglePlayer,
	GMI_Cooperative,
	GMI_Adversarial,
	GMI_Squad
};

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

var EGameModeInfo m_eCurrentGameMode;
var ER6GameType m_eCurrentGameType;
var bool bShowLog;
var bool m_bActiveBar;
var bool m_bActiveVoteMenu;
var bool m_bCanDisplayOperativeSelector;
var bool m_bPreventMenuSwitch;
var bool m_bMenuInvalid;
var bool m_bPlayerDidASelection;
var bool m_bJoinTeamWidget;
var bool m_bTrapKey;
var R6MenuInGameWritableMapWidget m_InGameWritableMapWidget;
var R6MenuMPJoinTeamWidget m_pJoinTeamWidget;
var R6MenuMPInterWidget m_pIntermissionMenuWidget;
var R6MenuMPInGameEsc m_pInGameEscMenu;
var R6MenuMPInGameRecMessages m_pRecMessagesMenuWidget;
var R6MenuMPInGameMsgOffensive m_pOffensiveMenuWidget;
var R6MenuMPInGameMsgDefensive m_pDefensiveMenuWidget;
var R6MenuMPInGameMsgReply m_pReplyMenuWidget;
var R6MenuMPInGameMsgStatus m_pStatusMenuWidget;
var R6MenuMPInGameVote m_pVoteWidget;
var R6MPGameMenuCom m_R6GameMenuCom;
var R6MenuOptionsWidget m_pOptionsWidget;
var R6MenuMPCountDown m_pCountDownWidget;
var R6MenuInGameOperativeSelectorWidget m_InGameOperativeSelectorWidget;
var Sound m_sndOpenDrawingTool;
var Sound m_sndCloseDrawingTool;
var Region m_RJoinWidget;
var Region m_RInterWidget;
var Region m_REscPopUp;
var string m_szGameModeLoc[2];
var string m_szCurrentGameModeLoc;
const C_iWKA_ALL= 0x3F;
const C_iWKA_INGAME= 0x1F;
const C_iWKA_ESC= 0x20;
const C_iWKA_MENUCOUNTDOWN= 0x10;
const C_iWKA_TOGGLE_STATS= 0x08;
const C_iWKA_DRAWINGTOOL= 0x04;
const C_iWKA_PRERECMESSAGES= 0x02;
const C_iWKA_INBETROUND= 0x01;
const C_iWKA_NONE= 0x00;
const C_iESC_POP_UP_HEIGHT= 30;

function Created ()
{
	m_R6GameMenuCom=new Class'R6MPGameMenuCom';
	m_R6GameMenuCom.m_pCurrentRoot=self;
	m_R6GameMenuCom.PostBeginPlay();
	R6Console(Root.Console).Master.m_MenuCommunication=m_R6GameMenuCom;
	Super.Created();
//	m_eRootId=3;
	m_InGameWritableMapWidget=R6MenuInGameWritableMapWidget(CreateWindow(Class'R6MenuInGameWritableMapWidget',0.00,0.00,640.00,480.00));
	m_InGameWritableMapWidget.HideWindow();
	m_pJoinTeamWidget=R6MenuMPJoinTeamWidget(CreateWindow(Class'R6MenuMPJoinTeamWidget',0.00,0.00,640.00,480.00));
	m_pJoinTeamWidget.HideWindow();
	m_pIntermissionMenuWidget=R6MenuMPInterWidget(CreateWindow(Class'R6MenuMPInterWidget',0.00,0.00,640.00,480.00));
	m_pIntermissionMenuWidget.HideWindow();
	m_pRecMessagesMenuWidget=R6MenuMPInGameRecMessages(CreateWindow(Class'R6MenuMPInGameRecMessages',0.00,0.00,640.00,480.00));
	m_pRecMessagesMenuWidget.HideWindow();
	m_pOffensiveMenuWidget=R6MenuMPInGameMsgOffensive(CreateWindow(Class'R6MenuMPInGameMsgOffensive',0.00,0.00,640.00,480.00));
	m_pOffensiveMenuWidget.HideWindow();
	m_pDefensiveMenuWidget=R6MenuMPInGameMsgDefensive(CreateWindow(Class'R6MenuMPInGameMsgDefensive',0.00,0.00,640.00,480.00));
	m_pDefensiveMenuWidget.HideWindow();
	m_pReplyMenuWidget=R6MenuMPInGameMsgReply(CreateWindow(Class'R6MenuMPInGameMsgReply',0.00,0.00,640.00,480.00));
	m_pReplyMenuWidget.HideWindow();
	m_pStatusMenuWidget=R6MenuMPInGameMsgStatus(CreateWindow(Class'R6MenuMPInGameMsgStatus',0.00,0.00,640.00,480.00));
	m_pStatusMenuWidget.HideWindow();
	m_pVoteWidget=R6MenuMPInGameVote(CreateWindow(Class'R6MenuMPInGameVote',0.00,0.00,640.00,480.00));
	m_pVoteWidget.HideWindow();
	m_pInGameEscMenu=R6MenuMPInGameEsc(CreateWindow(Class'R6MenuMPInGameEsc',0.00,0.00,640.00,480.00));
	m_pInGameEscMenu.HideWindow();
	m_pOptionsWidget=R6MenuOptionsWidget(CreateWindow(Class'R6MenuOptionsWidget',0.00,0.00,640.00,480.00));
	m_pOptionsWidget.HideWindow();
	m_pCountDownWidget=R6MenuMPCountDown(CreateWindow(Class'R6MenuMPCountDown',0.00,0.00,640.00,480.00));
	m_pCountDownWidget.HideWindow();
	m_InGameOperativeSelectorWidget=R6MenuInGameOperativeSelectorWidget(CreateWindow(Class'R6MenuInGameOperativeSelectorWidget',0.00,0.00,640.00,480.00));
	m_InGameOperativeSelectorWidget.HideWindow();
	m_szGameModeLoc[0]=Caps(Localize("MultiPlayer","GameMode_Adversarial","R6Menu"));
	m_szGameModeLoc[1]=Caps(Localize("MultiPlayer","GameMode_Cooperative","R6Menu"));
	FillListOfKeyAvailability();
}

function FillListOfKeyAvailability ()
{
	AddKeyInList(GetPlayerOwner().GetKey("Talk"),63);
	AddKeyInList(GetPlayerOwner().GetKey("TeamTalk"),63);
	AddKeyInList(GetPlayerOwner().GetKey("ToggleGameStats"),8);
	AddKeyInList(GetPlayerOwner().GetKey("DrawingTool"),4);
	AddKeyInList(GetPlayerOwner().GetKey("VotingMenu"),2);
	AddKeyInList(GetPlayerOwner().GetKey("PreRecMessages"),2);
	AddKeyInList(GetPlayerOwner().GetKey("PrimaryWeapon"),16);
	AddKeyInList(GetPlayerOwner().GetKey("SecondaryWeapon"),16);
	AddKeyInList(GetPlayerOwner().GetKey("GadgetOne"),16);
	AddKeyInList(GetPlayerOwner().GetKey("GadgetTwo"),16);
	AddKeyInList(GetPlayerOwner().GetKey("RaisePosture"),16);
	AddKeyInList(GetPlayerOwner().GetKey("LowerPosture"),16);
	AddKeyInList(GetPlayerOwner().GetKey("ChangeRateOfFire"),16);
	AddKeyInList(GetPlayerOwner().GetKey("Reload"),16);
//	AddKeyInList(Console.27,32);
}

function ChangeCurrentWidget (eGameWidgetID widgetID)
{
	switch (widgetID)
	{
/*		case 27:
		case 28:
		case 29:
		case 30:
		case 31:
		case 32:
		case 23:
		case 24:
		case 22:
		case 34:
		case 17:
		case 0:
		ChangeWidget(widgetID,True,False);
		break;
		case 33:
		case 25:
		ChangeWidget(widgetID,True,True);
		break;
		case 16:
		ChangeWidget(widgetID,False,False);
		break;
		case 26:
		if ( Console.IsInState('UWindowCanPlay') )
		{
			if ( m_bPlayerDidASelection )
			{
				ChangeWidget(0,True,False);
			}
			else
			{
				ChangeWidget(0,False,False);
				ChangeWidget(widgetID,False,False);
			}
		}
		else
		{
			ChangeWidget(widgetID,False,False);
		}
		break;
		default:
		break; */
	}
}

function ChangeWidget (eGameWidgetID widgetID, bool _bClearPrevWInHistory, bool _bCloseAll)
{
	local StWidget pStNewWidget;
	local name ConsoleState;
	local int iNbOfShowWindow;
	local int i;

	if ( m_bPreventMenuSwitch )
	{
		return;
	}
	iNbOfShowWindow=m_pListOfActiveWidget.Length;
	ConsoleState='UWindow';
	if ( _bCloseAll )
	{
		CloseAllWindow();
		iNbOfShowWindow=0;
	}
	ManagePrevWInHistory(_bClearPrevWInHistory,iNbOfShowWindow);
	m_eCurWidgetInUse=widgetID;
	pStNewWidget.m_eGameWidgetID=widgetID;
	GetPopUpFrame(iNbOfShowWindow).m_bBGClientArea=True;
	switch (widgetID)
	{
/*		case 23:
		UpdateCurrentGameMode();
		pStNewWidget.m_pPopUpFrame=GetPopUpFrame(iNbOfShowWindow);
		pStNewWidget.m_pPopUpFrame.ModifyPopUpFrameWindow(Localize("MPInGame","TeamSelect","R6Menu"),R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RJoinWidget.X,m_RJoinWidget.Y,m_RJoinWidget.W,m_RJoinWidget.H);
		pStNewWidget.m_pWidget=m_pJoinTeamWidget;
		m_pJoinTeamWidget.SetMenuToDisplay(m_eCurrentGameType);
		m_iWidgetKA=8 | 32;
		break;
		case 24:
		pStNewWidget.m_pPopUpFrame=GetPopUpFrame(iNbOfShowWindow);
		pStNewWidget.m_pPopUpFrame.ModifyPopUpFrameWindow(m_szCurrentGameModeLoc,R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RInterWidget.X,m_RInterWidget.Y,m_RInterWidget.W,m_RInterWidget.H);
		pStNewWidget.m_pPopUpFrame.m_bBGClientArea=False;
		pStNewWidget.m_pWidget=m_pIntermissionMenuWidget;
		m_pIntermissionMenuWidget.SetInterWidgetMenu(m_eCurrentGameType,m_bActiveBar);
		m_iWidgetKA=8 | 32 | 4;
		if ( (GetPlayerOwner().Pawn != None) && GetPlayerOwner().Pawn.IsAlive() )
		{
			m_bActiveBar=False;
		}
		if (  !m_bActiveBar && m_bPlayerDidASelection )
		{
			ConsoleState='UWindowCanPlay';
		}
		break;
		case 25:
		pStNewWidget.m_pPopUpFrame=GetPopUpFrame(iNbOfShowWindow);
		pStNewWidget.m_pPopUpFrame.ModifyPopUpFrameWindow(m_szCurrentGameModeLoc,R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize(),m_RInterWidget.X,m_RInterWidget.Y,m_RInterWidget.W,m_RInterWidget.H);
		pStNewWidget.m_pPopUpFrame.m_bBGClientArea=False;
		pStNewWidget.m_pWidget=m_pIntermissionMenuWidget;
		m_bActiveBar=True;
		m_pIntermissionMenuWidget.SetInterWidgetMenu(m_eCurrentGameType,m_bActiveBar);
		m_iWidgetKA=32 | 4;
		break;
		case 22:
		pStNewWidget.m_pPopUpFrame=GetPopUpFrame(iNbOfShowWindow);
		pStNewWidget.m_pWidget=m_InGameWritableMapWidget;
		m_iWidgetKA=4 | 32;
		break;
		case 26:
		pStNewWidget.m_pPopUpFrame=GetPopUpFrame(iNbOfShowWindow);
		pStNewWidget.m_pPopUpFrame.ModifyPopUpFrameWindow(Localize("ESCMENUS","ESCMENU","R6Menu"),30.00,m_REscPopUp.X,m_REscPopUp.Y,m_REscPopUp.W,m_REscPopUp.H);
		pStNewWidget.m_pWidget=m_pInGameEscMenu;
		m_iWidgetKA=32;
		break;
		case 16:
		pStNewWidget.m_pWidget=m_pOptionsWidget;
		m_pOptionsWidget.RefreshOptions();
		m_iWidgetKA=63;
		break;
		case 27:
		pStNewWidget.m_pWidget=m_pRecMessagesMenuWidget;
		m_iWidgetKA=2 | 32;
		ConsoleState='UWindowCanPlay';
		break;
		case 28:
		pStNewWidget.m_pWidget=m_pOffensiveMenuWidget;
		m_iWidgetKA=2 | 32;
		ConsoleState='UWindowCanPlay';
		break;
		case 29:
		pStNewWidget.m_pWidget=m_pDefensiveMenuWidget;
		m_iWidgetKA=2 | 32;
		ConsoleState='UWindowCanPlay';
		break;
		case 30:
		pStNewWidget.m_pWidget=m_pReplyMenuWidget;
		m_iWidgetKA=2 | 32;
		ConsoleState='UWindowCanPlay';
		break;
		case 31:
		pStNewWidget.m_pWidget=m_pStatusMenuWidget;
		m_iWidgetKA=2 | 32;
		ConsoleState='UWindowCanPlay';
		break;
		case 32:
		pStNewWidget.m_pWidget=m_pVoteWidget;
		m_iWidgetKA=2 | 32;
		ConsoleState='UWindowCanPlay';
		break;
		case 33:
		pStNewWidget.m_pWidget=m_pCountDownWidget;
		m_iWidgetKA=16;
		break;
		case 34:
		pStNewWidget.m_pPopUpFrame=GetPopUpFrame(iNbOfShowWindow);
		pStNewWidget.m_pPopUpFrame.ModifyPopUpFrameWindow(Localize("OPERATIVESELECTOR","Title_ID","R6Menu"),30.00,217.00,33.00,206.00,397.00);
		pStNewWidget.m_pWidget=m_InGameOperativeSelectorWidget;
		break;
		case 0:
		m_iWidgetKA=63;
		case 17:
		if ( iNbOfShowWindow != 0 )
		{
			pStNewWidget=m_pListOfActiveWidget[iNbOfShowWindow - 1];
			m_iWidgetKA=pStNewWidget.iWidgetKA;
			iNbOfShowWindow -= 1;
		}
		break;
		default:
		break;  */
	}
	if ( pStNewWidget.m_pWidget != None )
	{
		if (  !Console.IsInState(ConsoleState) )
		{
			CloseAllWindow();
			Console.bUWindowActive=True;
			if ( Console.Root != None )
			{
				Console.Root.bWindowVisible=True;
			}
			CheckConsoleTypingState(ConsoleState);
		}
		if ( ConsoleState == 'UWindow' )
		{
			Console.ViewportOwner.bSuspendPrecaching=True;
			Console.ViewportOwner.bShowWindowsMouse=True;
		}
		if ( pStNewWidget.m_pPopUpFrame != None )
		{
			pStNewWidget.m_pPopUpFrame.ShowWindow();
		}
		pStNewWidget.m_pWidget.ShowWindow();
		pStNewWidget.iWidgetKA=m_iWidgetKA;
		m_eCurWidgetInUse=pStNewWidget.m_eGameWidgetID;
		m_pListOfActiveWidget[iNbOfShowWindow]=pStNewWidget;
		if ( m_eCurWidgetInUse == 33 )
		{
			Console.ViewportOwner.bShowWindowsMouse=False;
		}
	}
	else
	{
		Console.bUWindowActive=False;
		Console.ViewportOwner.bShowWindowsMouse=False;
		bWindowVisible=False;
		CheckConsoleTypingState('Game');
	}
}

function UpdateCurrentGameMode ()
{
/*	m_eCurrentGameType=m_R6GameMenuCom.GetGameType();
	if ( GetLevel().IsGameTypeAdversarial(m_eCurrentGameType) )
	{
		m_eCurrentGameMode=GetLevel().3;
		m_szCurrentGameModeLoc=m_szGameModeLoc[0];
	}
	else
	{
		if ( GetLevel().IsGameTypeCooperative(m_eCurrentGameType) )
		{
			m_eCurrentGameMode=GetLevel().2;
			m_szCurrentGameModeLoc=m_szGameModeLoc[1];
		}
		else
		{
			Log("eGameType:" @ string(m_eCurrentGameType) @ "in R6MenuInGameMultiPlayerRootWindow not VALID");
		}
	} */
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
	if ( m_eCurWidgetInUse == 22 )
	{
		ChangeCurrentWidget(WidgetID_None);
	}
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	Super.PopUpBoxDone(Result,_ePopUpID);
	if ( Result == 3 )
	{
		switch (_ePopUpID)
		{
/*			case 28:
			m_R6GameMenuCom.TKPopUpDone(True);
			break;
			case 29:
			m_R6GameMenuCom.DisconnectClient(GetLevel());
			R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).3);
			break;
			case 45:
			GetPlayerOwner().StopAllMusic();
			m_R6GameMenuCom.DisconnectClient(GetLevel());
			R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).0);
			break;
			case 46:
			GetPlayerOwner().StopAllMusic();
			Root.DoQuitGame();
			break;
			default:
			break; */
		}
	}
	else
	{
		if ( Result == 4 )
		{
			switch (_ePopUpID)
			{
/*				case 28:
				m_R6GameMenuCom.TKPopUpDone(False);
				break;
				default:       */
			}
		}
		else
		{
		}
	}
	if ( m_eCurWidgetInUse == 0 )
	{
		Console.bUWindowActive=False;
		Console.ViewportOwner.bShowWindowsMouse=False;
		bWindowVisible=False;
		m_bActiveBar=True;
//		ChangeWidget(0,False,False);
	}
	m_pInGameEscMenu.m_bEscAvailable=True;
}

function CloseSimplePopUpBox ()
{
	if ( m_pSimplePopUp != None )
	{
		m_pSimplePopUp.Close();
	}
}

function VoteMenu (string _szPlayerNameToKick, bool _ActiveMenu)
{
	m_bActiveVoteMenu=_ActiveMenu;
	m_pVoteWidget.m_szPlayerNameToKick=_szPlayerNameToKick;
	m_pVoteWidget.m_bFirstTimePaint=False;
}

function NotifyBeforeLevelChange ()
{
	if ( bShowLog )
	{
		Log("R6MenuInGameMultiPlayerRootWindow::NotifyBeforeLevelChange()");
	}
	if ( m_R6GameMenuCom != None )
	{
		if ( bShowLog )
		{
			R6Console(Root.Console).ConsoleCommand("OBJ REFS CLASS=R6MPGameMenuCom NAME=" $ string(m_R6GameMenuCom));
		}
		m_R6GameMenuCom.m_pCurrentRoot=None;
	}
	R6Console(Root.Console).Master.m_MenuCommunication=None;
	m_R6GameMenuCom=None;
	CheckConsoleTypingState('UWindow');
	Super.NotifyBeforeLevelChange();
}

function NotifyAfterLevelChange ()
{
	if ( bShowLog )
	{
		Log("R6MenuInGameMultiPlayerRootWindow::NotifyAfterLevelChange()");
	}
	m_R6GameMenuCom=new Class'R6MPGameMenuCom';
	m_R6GameMenuCom.m_pCurrentRoot=self;
	m_R6GameMenuCom.PostBeginPlay();
	R6Console(Root.Console).Master.m_MenuCommunication=m_R6GameMenuCom;
	m_bJoinTeamWidget=True;
	m_bPlayerDidASelection=False;
	m_bPreventMenuSwitch=False;
	ChangeCurrentWidget(WidgetID_None);
	m_pIntermissionMenuWidget.SetNavBarInActive(False);
	Super.NotifyAfterLevelChange();
}

function MoveMouse (float X, float Y)
{
	local UWindowWindow NewMouseWindow;
	local float tX;
	local float tY;

	MouseX=X;
	MouseY=Y;
	if (  !bMouseCapture )
	{
		NewMouseWindow=FindWindowUnder(X * m_fWindowScaleX,Y * m_fWindowScaleY);
	}
	else
	{
		NewMouseWindow=MouseWindow;
	}
	if ( NewMouseWindow != MouseWindow )
	{
		MouseWindow.MouseLeave();
		NewMouseWindow.MouseEnter();
		MouseWindow=NewMouseWindow;
	}
	if ( (MouseX != OldMouseX) || (MouseY != OldMouseY) )
	{
		OldMouseX=MouseX;
		OldMouseY=MouseY;
		MouseWindow.GetMouseXY(tX,tY);
		MouseWindow.MouseMove(tX,tY);
	}
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
		C.SetPos(MouseX - MouseWindow.Cursor.HotX,MouseY - MouseWindow.Cursor.HotY);
		if ( MouseWindow.Cursor.Tex != None )
		{
			MouseTex=MouseWindow.Cursor.Tex;
			C.DrawTile(MouseTex,MouseTex.USize,MouseTex.VSize,0.00,0.00,MouseTex.USize,MouseTex.VSize);
		}
		C.Style=1;
	}
}

function Tick (float Delta)
{
	if ( m_bJoinTeamWidget )
	{
		if ( IsGameMenuComInitialized() )
		{
			m_bJoinTeamWidget=False;
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	local string szTemp;
	local float W;
	local float H;

	if ( m_bJoinTeamWidget )
	{
		C.Style=5;
		C.SetDrawColor(Root.Colors.Black.R,Root.Colors.Black.G,Root.Colors.Black.B);
		DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,0.00,0.00,10.00,10.00,Texture'WhiteTexture');
		szTemp=Localize("MP","WaitingForServer","R6Engine");
		C.Font=Root.Fonts[14];
		C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
		TextSize(C,szTemp,W,H);
		W=(WinWidth - W) * 0.50;
		H=(WinHeight - H) * 0.50;
		C.SetPos(W,H);
		C.DrawText(szTemp);
	}
}

function bool IsGameMenuComInitialized ()
{
	if ( (m_R6GameMenuCom != None) && m_R6GameMenuCom.IsInitialisationCompleted() )
	{
		return True;
	}
	return False;
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	if ( Msg != 11 )
	{
		if (  !IsGameMenuComInitialized() || (GetPlayerOwner() == None) || (GetLevel() == None) || (Console == None) )
		{
			if ( GetSimplePopUpID() == 31 )
			{
				Super.WindowEvent(Msg,C,X * m_fWindowScaleX,Y * m_fWindowScaleY,Key);
			}
			m_bMenuInvalid=True;
			m_pIntermissionMenuWidget.SetNavBarInActive(True,True);
			return;
		}
		else
		{
			if ( m_bMenuInvalid )
			{
				m_bMenuInvalid=False;
				m_pIntermissionMenuWidget.SetNavBarInActive(False,True);
			}
		}
	}
	switch (Msg)
	{
/*		case 11:
		if ( m_bScaleWindowToRoot )
		{
			C.UseVirtualSize(True,640.00,480.00);
			m_fWindowScaleX=C.GetVirtualSizeX() / C.SizeX;
			m_fWindowScaleY=C.GetVirtualSizeY() / C.SizeY;
			Super.WindowEvent(Msg,C,X,Y,Key);
			C.UseVirtualSize(False);
		}
		else
		{
			if ( (WinWidth != C.SizeX) || (WinHeight != C.SizeY) )
			{
				SetResolution(C.SizeX,C.SizeY);
			}
			m_fWindowScaleX=1.00;
			m_fWindowScaleY=1.00;
			Super.WindowEvent(Msg,C,X,Y,Key);
		}
		break;
		case 9:
		if ( m_eCurWidgetInUse != 16 )
		{
			if (  !ProcessKeyDown(Key) )
			{
				goto JL0320;
			}
		}
		Super.WindowEvent(Msg,C,X * m_fWindowScaleX,Y * m_fWindowScaleY,Key);
		break;
		case 8:
		if (  !ProcessKeyUp(Key) )
		{
			goto JL0320;
		}
		Super.WindowEvent(Msg,C,X * m_fWindowScaleX,Y * m_fWindowScaleY,Key);
		break;
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
		Super.WindowEvent(Msg,C,X * m_fWindowScaleX,Y * m_fWindowScaleY,Key);
		break;
		default:
		Super.WindowEvent(Msg,C,X * m_fWindowScaleX,Y * m_fWindowScaleY,Key);
		break;*/
	}
JL0320:
}

function bool ProcessKeyDown (int Key)
{
	local eGameWidgetID eNextWidgetIDUp;
	local eGameWidgetID eNextWidgetIDDown;
	local int i;
	local int iNbOfKeys;
	local bool bProcessWChange;
	local bool bProcessKeyToAllMenu;
	local bool bIsInBetweenRound;
	local PlayerController PC;

	PC=GetPlayerOwner();
	if ( m_iLastKeyDown != -1 )
	{
		return True;
	}
	bProcessKeyToAllMenu=True;
	iNbOfKeys=m_pListOfKeyAvailability.Length;
	m_bTrapKey=True;
	i=0;
JL0040:
	if ( i < iNbOfKeys )
	{
		if ( m_pListOfKeyAvailability[i].iKey == Key )
		{
			if ( (m_pListOfKeyAvailability[i].iWidgetKA & m_iWidgetKA) > 0 )
			{
				if ( m_eCurWidgetInUse == 33 )
				{
					m_bTrapKey=False;
				}
				goto JL00B5;
			}
			else
			{
				return bProcessKeyToAllMenu;
			}
		}
		i++;
		goto JL0040;
	}
JL00B5:
	bIsInBetweenRound=m_R6GameMenuCom.IsInBetweenRoundMenu();
	switch (Key)
	{
		case PC.GetKey("Talk"):
		Console.Talk();
		break;
		case PC.GetKey("TeamTalk"):
		Console.TeamTalk();
		break;
		case PC.GetKey("ToggleGameStats"):
		R6Console(Root.Console).bCancelFire=False;
		eNextWidgetIDUp=InGameMPWID_Intermission;
		if ( m_bPlayerDidASelection )
		{
			if ( m_R6GameMenuCom.m_GameRepInfo.IsInAGameState() )
			{
				eNextWidgetIDDown=WidgetID_None;
				bProcessWChange=True;
			}
		}
		else
		{
			eNextWidgetIDDown=InGameMPWID_TeamJoin;
			bProcessWChange=True;
		}
		break;
		case PC.GetKey("DrawingTool"):
		if ( R6GameReplicationInfo(PC.GameReplicationInfo).m_bIsWritableMapAllowed && m_R6GameMenuCom.IsAPlayerSelection() )
		{
			if ( (PC.Pawn != None) && PC.Pawn.IsAlive() || bIsInBetweenRound )
			{
				eNextWidgetIDUp=InGameMPWID_Writable;
				eNextWidgetIDDown=WidgetID_None;
				if ( m_eCurWidgetInUse == 22 )
				{
					if ( bIsInBetweenRound )
					{
						eNextWidgetIDDown=m_ePrevWidgetInUse;
					}
					if ( PC.Pawn != None )
					{
						PC.Pawn.PlaySound(m_sndCloseDrawingTool,SLOT_Menu);
					}
				}
				else
				{
					if ( bIsInBetweenRound )
					{
						m_ePrevWidgetInUse=m_eCurWidgetInUse;
					}
					else
					{
						if ( m_eCurWidgetInUse != 0 )
						{
							goto JL0560;
						}
					}
					if ( PC.Pawn != None )
					{
						PC.Pawn.PlaySound(m_sndOpenDrawingTool,SLOT_Menu);
					}
				}
				bProcessWChange=True;
			}
		}
		break;
/*		case Console.27:
		eNextWidgetIDUp=InGameMPWID_EscMenu;
		eNextWidgetIDDown=WidgetID_None;
		bProcessWChange=True;
		if ( m_eCurWidgetInUse == 26 )
		{
			if ( R6MenuMPInGameEsc(m_pListOfActiveWidget[m_pListOfActiveWidget.Length - 1].m_pWidget).m_bEscAvailable )
			{
				bProcessKeyToAllMenu=False;
			}
			else
			{
				bProcessWChange=False;
			}
		}
		else
		{
			if ( m_eCurWidgetInUse == 22 )
			{
				if ( bIsInBetweenRound )
				{
					eNextWidgetIDUp=m_ePrevWidgetInUse;
				}
				else
				{
					eNextWidgetIDUp=0;
				}
			}
		}
		break;*/
		case PC.GetKey("VotingMenu"):
		if ( m_bActiveVoteMenu )
		{
			R6Console(Root.Console).bCancelFire=False;
			eNextWidgetIDUp=InGameMPWID_Vote;
			eNextWidgetIDDown=WidgetID_None;
			bProcessWChange=True;
		}
		break;
		case PC.GetKey("PreRecMessages"):
/*		if ( (m_eCurrentGameType != GetLevel().13) &&  !PC.IsInState('Dead') &&  !PC.bOnlySpectator )
		{
			R6Console(Root.Console).bCancelFire=False;
			eNextWidgetIDUp=InGameMpWID_RecMessages;
			eNextWidgetIDDown=WidgetID_None;
			bProcessWChange=True;
		}*/
		break;
		case PC.GetKey("OperativeSelector"):
/*		if ( GetLevel().IsGameTypeCooperative(m_R6GameMenuCom.GetGameType()) && (m_eCurWidgetInUse == 0) &&  !PC.bOnlySpectator && m_bCanDisplayOperativeSelector )
		{
			m_bCanDisplayOperativeSelector=False;
			eNextWidgetIDUp=InGameID_OperativeSelector;
			eNextWidgetIDDown=WidgetID_None;
			bProcessWChange=True;
		}*/
		break;
		default:
		break;
	}
JL0560:
	if ( bProcessWChange )
	{
		if ( m_eCurWidgetInUse == eNextWidgetIDUp )
		{
			ChangeCurrentWidget(eNextWidgetIDDown);
			m_iLastKeyDown=-1;
		}
		else
		{
			ChangeCurrentWidget(eNextWidgetIDUp);
			m_iLastKeyDown=Key;
		}
	}
	return bProcessKeyToAllMenu;
}

function bool ProcessKeyUp (int Key)
{
	if ( (m_iLastKeyDown != -1) && (m_iLastKeyDown == Key) )
	{
		m_iLastKeyDown=-1;
	}
	if ( Key == GetPlayerOwner().GetKey("OperativeSelector") )
	{
		if ( m_eCurWidgetInUse == 34 )
		{
			ChangeCurrentWidget(WidgetID_None);
		}
		m_bCanDisplayOperativeSelector=True;
		return False;
	}
	return True;
}

function bool TrapKey (bool _bIncludeMouseMove)
{
	if ( _bIncludeMouseMove )
	{
		if ( m_eCurWidgetInUse == 33 )
		{
			return False;
		}
	}
	return m_bTrapKey;
}

function UpdateTimeInBetRound (int _iNewTime, optional string _StringInstead)
{
	local int i;
	local int iNbOfWindow;

	iNbOfWindow=m_pListOfActiveWidget.Length;
	i=0;
JL0013:
	if ( i < iNbOfWindow )
	{
		if ( (m_pListOfActiveWidget[i].m_eGameWidgetID == 25) || (m_pListOfActiveWidget[i].m_eGameWidgetID == 24) )
		{
			m_pListOfActiveWidget[i].m_pPopUpFrame.UpdateTimeInTextLabel(_iNewTime,_StringInstead);
		}
		else
		{
			i++;
			goto JL0013;
		}
	}
}

function MenuLoadProfile (bool _bServerProfile)
{
	if (  !_bServerProfile )
	{
		m_pOptionsWidget.MenuOptionsLoadProfile();
	}
}

defaultproperties
{
    m_bCanDisplayOperativeSelector=True
    m_bJoinTeamWidget=True
    m_bTrapKey=True
    m_RJoinWidget=(X=1647110,Y=570753024,W=40,H=38674948)
    m_RInterWidget=(X=1647110,Y=570753024,W=80,H=38674948)
    m_REscPopUp=(X=7545350,Y=570753024,W=200,H=26878468)
    LookAndFeelClass="R6Menu.R6MenuRSLookAndFeel"
}
/*
    m_sndOpenDrawingTool=Sound'Common_Multiplayer.Play_DrawingTool_Open'
    m_sndCloseDrawingTool=Sound'Common_Multiplayer.Play_DrawingTool_Close'
*/

