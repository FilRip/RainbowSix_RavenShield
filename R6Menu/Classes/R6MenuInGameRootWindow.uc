//================================================================================
// R6MenuInGameRootWindow.
//================================================================================
class R6MenuInGameRootWindow extends R6WindowRootWindow;

var int m_ESCMenuKey;
var bool m_bCanDisplayOperativeSelector;
var bool m_bInEscMenu;
var bool m_bInTraining;
var bool m_bInPopUp;
var float m_fTopLabelHeight;
var R6MenuDebriefingWidget m_DebriefingWidget;
var R6MenuInGameInstructionWidget m_pInstructionWidget;
var R6MenuOptionsWidget m_OptionsWidget;
var R6MenuInGameOperativeSelectorWidget m_InGameOperativeSelectorWidget;
var R6MenuInGameEsc m_EscMenuWidget;
var Region m_REscMenuWidget;
var Region m_REscTraining;

function Created ()
{
	Super.Created();
//	m_eRootId=2;
	m_bInTraining=Root.Console.Master.m_StartGameInfo.m_GameMode == "R6Game.R6TrainingMgr";
	m_DebriefingWidget=R6MenuDebriefingWidget(CreateWindow(Class'R6MenuDebriefingWidget',0.00,0.00,640.00,480.00));
	m_DebriefingWidget.HideWindow();
	m_InGameOperativeSelectorWidget=R6MenuInGameOperativeSelectorWidget(CreateWindow(Class'R6MenuInGameOperativeSelectorWidget',0.00,0.00,640.00,480.00));
	m_InGameOperativeSelectorWidget.HideWindow();
	m_EscMenuWidget=R6MenuInGameEsc(CreateWindow(Class'R6MenuInGameEsc',0.00,0.00,640.00,480.00,self));
	m_EscMenuWidget.HideWindow();
	m_OptionsWidget=R6MenuOptionsWidget(CreateWindow(Class'R6MenuOptionsWidget',0.00,0.00,640.00,480.00));
	m_OptionsWidget.HideWindow();
	m_pInstructionWidget=R6MenuInGameInstructionWidget(CreateWindow(Class'R6MenuInGameInstructionWidget',0.00,0.00,640.00,480.00,self));
	m_pInstructionWidget.HideWindow();
}

function ChangeInstructionWidget (Actor pISV, bool bShow, int iBox, int iParagraph)
{
	local int i;
	local int iNbOfWindow;
	local R6InstructionSoundVolume aISV;

	aISV=R6InstructionSoundVolume(pISV);
	if ( bShow )
	{
		m_pInstructionWidget.ChangeText(aISV,iBox,iParagraph);
		iNbOfWindow=m_pListOfActiveWidget.Length;
		i=0;
JL004A:
		if ( i < iNbOfWindow )
		{
			if ( m_pListOfActiveWidget[i].m_eGameWidgetID == 3 )
			{
				return;
			}
			i++;
			goto JL004A;
		}
//		ChangeCurrentWidget(InGameID_TrainingInstruction);
	}
	else
	{
//		ChangeCurrentWidget(WidgetID_None);
	}
}

function ChangeCurrentWidget (eGameWidgetID widgetID)
{
	switch (widgetID)
	{
/*		case 17:
		case 3:
		case 34:
		case 2:
		case 0:
		ChangeWidget(widgetID,True,False);
		break;
		case 1:
		case 16:
		ChangeWidget(widgetID,False,False);
		break;
		default:
		break;      */
	}
}

function ChangeWidget (eGameWidgetID widgetID, bool _bClearPrevWInHistory, bool _bCloseAll)
{
	local StWidget pStNewWidget;
	local name ConsoleState;
	local int iNbOfShowWindow;
	local int i;

	iNbOfShowWindow=m_pListOfActiveWidget.Length;
	ConsoleState='UWindow';
	m_bWidgetResolutionFix=False;
	if ( _bCloseAll )
	{
		CloseAllWindow();
		iNbOfShowWindow=0;
	}
	ManagePrevWInHistory(_bClearPrevWInHistory,iNbOfShowWindow);
	m_eCurWidgetInUse=widgetID;
	pStNewWidget.m_eGameWidgetID=widgetID;
	pStNewWidget.m_WidgetConsoleState=ConsoleState;
	GetPopUpFrame(iNbOfShowWindow).m_bBGClientArea=True;
	switch (widgetID)
	{
/*		case 3:
		pStNewWidget.m_pWidget=m_pInstructionWidget;
		pStNewWidget.m_WidgetConsoleState='TrainingInstruction';
		ConsoleState='TrainingInstruction';
		break;
		case 2:
		Root.Console.ViewportOwner.Actor.Level.m_bInGamePlanningActive=False;
		Root.Console.ViewportOwner.Actor.Level.SetPlanningMode(False);
		pStNewWidget.m_pWidget=m_DebriefingWidget;
		m_bWidgetResolutionFix=True;
		break;
		case 34:
		pStNewWidget.m_pPopUpFrame=GetPopUpFrame(iNbOfShowWindow);
		pStNewWidget.m_pPopUpFrame.ModifyPopUpFrameWindow(Localize("OPERATIVESELECTOR","Title_ID","R6Menu"),m_fTopLabelHeight,17.00,33.00,606.00,397.00);
		pStNewWidget.m_pWidget=m_InGameOperativeSelectorWidget;
		break;
		case 1:
		pStNewWidget.m_pPopUpFrame=GetPopUpFrame(iNbOfShowWindow);
		if ( m_bInTraining )
		{
			pStNewWidget.m_pPopUpFrame.ModifyPopUpFrameWindow(Localize("ESCMENUS","ESCMENU","R6Menu"),m_fTopLabelHeight,m_REscTraining.X,m_REscTraining.Y,m_REscTraining.W,m_REscTraining.H);
		}
		else
		{
			pStNewWidget.m_pPopUpFrame.ModifyPopUpFrameWindow(Localize("ESCMENUS","ESCMENU","R6Menu"),m_fTopLabelHeight,m_REscMenuWidget.X,m_REscMenuWidget.Y,m_REscMenuWidget.W,m_REscMenuWidget.H);
		}
		pStNewWidget.m_pWidget=m_EscMenuWidget;
		break;
		case 16:
		if ( IsWidgetIsInHistory(2) )
		{
			m_bWidgetResolutionFix=True;
		}
		pStNewWidget.m_pWidget=m_OptionsWidget;
		m_OptionsWidget.RefreshOptions();
		break;
		case 0:
		case 17:
		if ( iNbOfShowWindow != 0 )
		{
			pStNewWidget=m_pListOfActiveWidget[iNbOfShowWindow - 1];
			ConsoleState=pStNewWidget.m_WidgetConsoleState;
			iNbOfShowWindow -= 1;
		}
		break;
		default:
		break;   */
	}
	if ( pStNewWidget.m_pWidget != None )
	{
		if (  !Console.IsInState(ConsoleState) )
		{
			if ( ConsoleState == 'TrainingInstruction' )
			{
				Console.ViewportOwner.bSuspendPrecaching=False;
				Console.ViewportOwner.bShowWindowsMouse=False;
			}
			else
			{
				Console.ViewportOwner.bSuspendPrecaching=True;
				Console.ViewportOwner.bShowWindowsMouse=True;
			}
			Console.bUWindowActive=True;
			if ( Console.Root != None )
			{
				Console.Root.bWindowVisible=True;
			}
			CheckConsoleTypingState(ConsoleState);
		}
		if ( pStNewWidget.m_pPopUpFrame != None )
		{
			pStNewWidget.m_pPopUpFrame.ShowWindow();
		}
		pStNewWidget.m_pWidget.ShowWindow();
		m_eCurWidgetInUse=pStNewWidget.m_eGameWidgetID;
		m_pListOfActiveWidget[iNbOfShowWindow]=pStNewWidget;
	}
	else
	{
		Console.bUWindowActive=False;
		Console.ViewportOwner.bShowWindowsMouse=False;
		if ( Console.Root != None )
		{
			Console.Root.bWindowVisible=False;
		}
		CheckConsoleTypingState('Game');
		Console.ViewportOwner.bSuspendPrecaching=False;
	}
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
		NewMouseWindow=FindWindowUnder(X,Y);
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

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	local R6GameInfo GameInfo;

	Super.PopUpBoxDone(Result,_ePopUpID);
	if ( Result == 3 )
	{
		switch (_ePopUpID)
		{
/*			case 45:
			Console.Master.m_StartGameInfo.m_SkipPlanningPhase=False;
			Console.Master.m_StartGameInfo.m_ReloadPlanning=False;
			Console.Master.m_StartGameInfo.m_ReloadActionPointOnly=False;
			R6Console(Console).LeaveR6Game(R6Console(Console).0);
			break;
			case 46:
			GetPlayerOwner().StopAllMusic();
			Root.DoQuitGame();
			break;
			case 47:
			Console.Master.m_StartGameInfo.m_SkipPlanningPhase=True;
			Console.Master.m_StartGameInfo.m_ReloadPlanning=True;
			Console.Master.m_StartGameInfo.m_ReloadActionPointOnly=True;
			m_bInEscMenu=False;
			GetPlayerOwner().StopAllMusic();
			R6Console(Root.Console).ResetR6Game();
			break;
			case 49:
			Console.Master.m_StartGameInfo.m_SkipPlanningPhase=False;
			Console.Master.m_StartGameInfo.m_ReloadPlanning=False;
			Console.Master.m_StartGameInfo.m_ReloadActionPointOnly=False;
			R6Console(Console).LeaveR6Game(R6Console(Console).2);
			break;
			case 48:
			Console.Master.m_StartGameInfo.m_SkipPlanningPhase=False;
			Console.Master.m_StartGameInfo.m_ReloadPlanning=True;
			Console.Master.m_StartGameInfo.m_ReloadActionPointOnly=False;
			GameInfo=R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game);
			GetPlayerOwner().StopAllMusic();
			if ( GameInfo.m_bUsingPlayerCampaign )
			{
				R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).6);
			}
			else
			{
				R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).4);
			}
			break;
			default:    */
		}
	}
	m_bInPopUp=False;
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	switch (Msg)
	{
/*		case 11:
		if ( (WinWidth != C.SizeX) || (WinHeight != C.SizeY) )
		{
			SetResolution(C.SizeX,C.SizeY);
		}
		Super.WindowEvent(Msg,C,X,Y,Key);
		break;
		case 8:
		if (  !ProcessKeyUp(Key) )
		{
			goto JL0120;
		}
		Super.WindowEvent(Msg,C,X,Y,Key);
		break;
		case 9:
		if (  !ProcessKeyDown(Key) )
		{
			goto JL0120;
		}
		Super.WindowEvent(Msg,C,X,Y,Key);
		break;
		default:
		Super.WindowEvent(Msg,C,X,Y,Key);    */
	}
JL0120:
}

function SimplePopUp (string _szTitle, string _szText, EPopUpID _ePopUpID, optional int _iButtonsType, optional bool bAddDisableDlg, optional UWindowWindow OwnerWindow)
{
	m_bInPopUp=True;
	if ( OwnerWindow == None )
	{
		Super.SimplePopUp(_szTitle,_szText,_ePopUpID,_iButtonsType,bAddDisableDlg,self);
	}
	else
	{
		Super.SimplePopUp(_szTitle,_szText,_ePopUpID,_iButtonsType,bAddDisableDlg,OwnerWindow);
	}
}

function bool ProcessKeyDown (int Key)
{
	if ( m_eCurWidgetInUse == 16 )
	{
		return True;
	}
	if ( Key == m_ESCMenuKey )
	{
		if ( m_bInPopUp == True )
		{
			return True;
		}
		if ( m_eCurWidgetInUse != 1 )
		{
			if (  !R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_bGameOver )
			{
				Root.Console.ViewportOwner.Actor.Level.m_bInGamePlanningActive=False;
				Root.Console.ViewportOwner.Actor.Level.SetPlanningMode(False);
//				ChangeCurrentWidget(InGameID_EscMenu);
				m_bInEscMenu=True;
			}
		}
		else
		{
			m_bInEscMenu=False;
//			ChangeCurrentWidget(WidgetID_None);
		}
		return False;
	}
	if ( (Key == GetPlayerOwner().GetKey("OperativeSelector")) && (m_eCurWidgetInUse == 0) )
	{
		if ( m_bCanDisplayOperativeSelector )
		{
			m_bCanDisplayOperativeSelector=False;
			ChangeCurrentWidget(InGameID_OperativeSelector);
		}
		return False;
	}
	return True;
}

function bool ProcessKeyUp (int Key)
{
	if ( Key == GetPlayerOwner().GetKey("OperativeSelector") )
	{
		if ( m_eCurWidgetInUse == InGameID_OperativeSelector )
		{
			ChangeCurrentWidget(WidgetID_None);
		}
		m_bCanDisplayOperativeSelector=True;
		return False;
	}
	return True;
}

function MenuLoadProfile (bool _bServerProfile)
{
	if (  !_bServerProfile )
	{
		m_OptionsWidget.MenuOptionsLoadProfile();
	}
}

defaultproperties
{
    m_ESCMenuKey=27
    m_bCanDisplayOperativeSelector=True
    m_fTopLabelHeight=30.00
    m_REscMenuWidget=(X=7545350,Y=570753024,W=36,H=26878468)
    m_REscTraining=(X=7545350,Y=570753024,W=250,H=26878468)
    LookAndFeelClass="R6Menu.R6MenuRSLookAndFeel"
}
