//================================================================================
// R6MenuPlanningWidget.
//================================================================================
class R6MenuPlanningWidget extends R6MenuLaptopWidget;

const R6InputKey_PathFlagPopup= 1026;
const R6InputKey_NewNode= 1025;
const R6InputKey_ActionPopup= 1024;
var bool m_bPopUpMenuPoint;
var bool m_bPopUpMenuSpeed;
var bool m_bMoveUDByLaptop;
var bool m_bMoveRLByLaptop;
var bool m_bClosePopup;
var bool bShowLog;
var float m_fLabelHeight;
var float m_fLMouseDownX;
var float m_fLMouseDownY;
var R6MenuPlanningBar m_PlanningBar;
var R6Menu3DViewOnOffButton m_3DButton;
var R6MenuLegendButton m_LegendButton;
var R6Window3DButton m_3DWindow;
var R6WindowLegend m_LegendWindow;
var R6WindowTextLabel m_CodeName;
var R6WindowTextLabel m_DateTime;
var R6WindowTextLabel m_Location;
var Font m_labelFont;
var R6MenuActionPointMenu m_PopUpMenuPoint;
var R6MenuModeMenu m_PopUpMenuMode;
var UWindowWindow DEB_FocusedWindow;

function Created ()
{
	local int i;
	local R6MenuRSLookAndFeel LAF;
	local Region TheRegion;
	local float fLaptopPadding;
	local int labelWidth;
	local R6WindowWrappedTextArea WrapTextArea;

	LAF=R6MenuRSLookAndFeel(OwnerWindow.LookAndFeel);
	Super.Created();
	fLaptopPadding=2.00;
	TheRegion.Y=480 - LAF.m_stLapTopFrame.B.H - 4 - LAF.m_NavBarBack[0].H;
	TheRegion.H=16;
	TheRegion.Y=m_NavBar.WinTop - TheRegion.H - fLaptopPadding;
	TheRegion.X=m_NavBar.WinLeft;
	TheRegion.W=35;
	m_3DButton=R6Menu3DViewOnOffButton(CreateWindow(Class'R6Menu3DViewOnOffButton',TheRegion.X,TheRegion.Y,TheRegion.W,TheRegion.H,self));
	TheRegion.H=16;
	TheRegion.Y=m_NavBar.WinTop - TheRegion.H - fLaptopPadding;
	TheRegion.X=m_NavBar.WinLeft + m_NavBar.WinWidth - 35;
	TheRegion.W=35;
	m_LegendButton=R6MenuLegendButton(CreateWindow(Class'R6MenuLegendButton',TheRegion.X,TheRegion.Y,TheRegion.W,TheRegion.H,self));
	TheRegion.X=LAF.m_stLapTopFrame.L.W + 1;
	TheRegion.H=2 + 23;
	TheRegion.Y -= 2 + TheRegion.H;
	TheRegion.W=640 - m_Right.WinWidth;
	m_PlanningBar=R6MenuPlanningBar(CreateWindow(Class'R6MenuPlanningBar',TheRegion.X,TheRegion.Y,TheRegion.W,TheRegion.H,self));
	TheRegion.W=(m_Right.WinLeft - m_Left.WinWidth) / 3 + 2;
	TheRegion.H=(m_Bottom.WinTop - m_Top.WinHeight) / 3 + 2;
	TheRegion.X=m_Left.WinWidth + 2;
	TheRegion.Y=m_Top.WinHeight + m_fLabelHeight + 1;
	m_3DWindow=R6Window3DButton(CreateWindow(Class'R6Window3DButton',TheRegion.X,TheRegion.Y,TheRegion.W,TheRegion.H,self));
	m_3DWindow.HideWindow();
	m_LegendWindow=R6WindowLegend(CreateWindow(Class'R6WindowLegend',m_Right.WinLeft - 103,m_Top.WinHeight + m_fLabelHeight + 1,100.00,100.00,self));
	m_LegendWindow.HideWindow();
	m_labelFont=Root.Fonts[9];
	labelWidth=(m_Right.WinLeft - m_Left.WinWidth) / 3;
	m_CodeName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_Left.WinWidth,m_Top.WinHeight,labelWidth,m_fLabelHeight,self));
	m_DateTime=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_CodeName.WinLeft + m_CodeName.WinWidth,m_Top.WinHeight,labelWidth,m_fLabelHeight,self));
	m_Location=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_DateTime.WinLeft + m_DateTime.WinWidth,m_Top.WinHeight,m_DateTime.WinWidth,m_fLabelHeight,self));
	m_NavBar.m_PlanningButton.bDisabled=True;
}

function Reset ()
{
	m_PlanningBar.Reset();
}

function ResetTeams (int iWhatToReset)
{
	CloseAllPopup();
	m_PlanningBar.ResetTeams(iWhatToReset);
}

function HideWindow ()
{
	local LevelInfo li;

	Hide3DAndLegend();
	R6MenuRootWindow(Root).StopPlayMode();
	Super.HideWindow();
	li=GetLevel();
	li.m_bAllow3DRendering=False;
}

function Hide3DAndLegend ()
{
	if ( R6PlanningCtrl(GetPlayerOwner()) != None )
	{
		R6PlanningCtrl(GetPlayerOwner()).TurnOff3DView();
	}
	m_3DWindow.Close3DWindow();
	m_LegendWindow.CloseLegendWindow();
	m_3DButton.m_bSelected=False;
	m_LegendButton.m_bSelected=False;
	CloseAllPopup();
}

function ShowWindow ()
{
	local LevelInfo li;
	local R6MissionDescription CurrentMission;
	local R6GameOptions pGameOptions;
	local R6MenuRootWindow r6Root;

	r6Root=R6MenuRootWindow(Root);
	if ( r6Root.m_bPlayerPlanInitialized &&  !r6Root.m_bPlayerDoNotWant3DView )
	{
		m_3DButton.m_bSelected=True;
		m_3DWindow.Toggle3DWindow();
		R6PlanningCtrl(GetPlayerOwner()).Toggle3DView();
	}
	else
	{
		R6PlanningCtrl(GetPlayerOwner()).TurnOff3DView();
		m_3DWindow.Close3DWindow();
		m_3DButton.m_bSelected=False;
	}
	if ( r6Root.m_bPlayerPlanInitialized && r6Root.m_bPlayerWantLegend )
	{
		m_LegendButton.m_bSelected=True;
		m_LegendWindow.ToggleLegend();
	}
	else
	{
		m_LegendButton.m_bSelected=False;
	}
	Super.ShowWindow();
	li=GetLevel();
	li.m_bAllow3DRendering=True;
	CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
/*	m_CodeName.SetProperties(Localize(CurrentMission.m_MapName,"ID_CODENAME",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);
	m_DateTime.SetProperties(Localize(CurrentMission.m_MapName,"ID_DATETIME",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);
	m_Location.SetProperties(Localize(CurrentMission.m_MapName,"ID_LOCATION",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);*/
	if ( r6Root.m_bPlayerPlanInitialized == False )
	{
		pGameOptions=Class'Actor'.static.GetGameOptions();
		if ( pGameOptions.PopUpLoadPlan == True )
		{
//			r6Root.m_ePopUpID=43;
			r6Root.PopUpMenu(True);
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=1;
	C.SetDrawColor(Root.Colors.GrayLight.R,Root.Colors.GrayLight.G,Root.Colors.GrayLight.B);
/*	DrawStretchedTextureSegment(C,m_Left.WinWidth + 1,m_Top.WinHeight + m_fLabelHeight,WinWidth - m_Right.WinWidth - 2,1.00,18.00,56.00,1.00,1.00,Texture'Gui_BoxScroll');
	DrawStretchedTextureSegment(C,m_Left.WinWidth + 1,m_Top.WinHeight + m_fLabelHeight,1.00,364.00 - m_Top.WinHeight - m_fLabelHeight,18.00,56.00,1.00,1.00,Texture'Gui_BoxScroll');
	DrawStretchedTextureSegment(C,WinWidth - m_Right.WinWidth - 2,m_Top.WinHeight + m_fLabelHeight,1.00,364.00 - m_Top.WinHeight - m_fLabelHeight,18.00,56.00,1.00,1.00,Texture'Gui_BoxScroll');*/
	C.SetDrawColor(Root.Colors.GrayDark.R,Root.Colors.GrayDark.G,Root.Colors.GrayDark.B);
//	DrawStretchedTextureSegment(C,0.00,364.00,m_PlanningBar.WinWidth,m_PlanningBar.WinHeight,0.00,364.00,m_PlanningBar.WinWidth,m_PlanningBar.WinHeight,m_TBackGround);
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
/*	DrawStretchedTextureSegment(C,0.00,m_Top.WinHeight,WinWidth,m_fLabelHeight,0.00,m_Top.WinHeight,WinWidth,m_fLabelHeight,m_TBackGround);
	DrawStretchedTextureSegment(C,m_Left.WinWidth,m_Top.WinHeight + m_fLabelHeight,1.00,364.00,m_Left.WinWidth,m_Top.WinHeight + m_fLabelHeight,1.00,364.00,m_TBackGround);
	DrawStretchedTextureSegment(C,WinWidth - m_Right.WinWidth - 1,m_Top.WinHeight + m_fLabelHeight,1.00,364.00,WinWidth - m_Right.WinWidth - 1,m_Top.WinHeight + m_fLabelHeight,1.00,364.00,m_TBackGround);
	DrawStretchedTextureSegment(C,0.00,364.00 + m_PlanningBar.WinHeight,WinWidth,96.00,0.00,364.00 + m_PlanningBar.WinHeight,WinWidth,96.00,m_TBackGround);*/
	m_HelpTextBar.m_HelpTextBar.m_szDefaultText=Localize("PlanningMenu","LevelText","R6Menu");
	m_HelpTextBar.m_HelpTextBar.m_szDefaultText=m_HelpTextBar.m_HelpTextBar.m_szDefaultText @ string(R6PlanningCtrl(GetPlayerOwner()).m_iLevelDisplay - 100);
	if ( bShowLog )
	{
		if ( DEB_FocusedWindow != Root.FocusedWindow )
		{
			Log("-->FocusedWindow: " $ string(Root.FocusedWindow));
			DEB_FocusedWindow=Root.FocusedWindow;
		}
	}
	DrawLaptopFrame(C);
}

function Tick (float fDelta)
{
	local R6PlanningCtrl PlanningCtrl;
	local Region TheRegion;

	Super.Tick(fDelta);
	if ( GetPlayerOwner().IsA('R6PlanningCtrl') )
	{
		PlanningCtrl=R6PlanningCtrl(GetPlayerOwner());
		if ( Root.m_bUseDragIcon == False )
		{
			if ( Root.MouseX < m_Left.WinWidth + 1 )
			{
				PlanningCtrl.m_bMoveLeft=1;
				m_bMoveRLByLaptop=True;
				m_bClosePopup=True;
			}
			else
			{
				if ( Root.MouseX > m_Right.WinLeft - 1 )
				{
					PlanningCtrl.m_bMoveRight=1;
					m_bMoveRLByLaptop=True;
				}
				else
				{
					if ( m_bMoveRLByLaptop == True )
					{
						m_bMoveRLByLaptop=False;
						PlanningCtrl.m_bMoveLeft=0;
						PlanningCtrl.m_bMoveRight=0;
						m_bClosePopup=True;
					}
				}
			}
			if ( Root.MouseY < m_Top.WinHeight + 1 )
			{
				PlanningCtrl.m_bMoveUp=1;
				m_bMoveUDByLaptop=True;
				m_bClosePopup=True;
			}
			else
			{
				if ( Root.MouseY > m_Bottom.WinTop - 1 )
				{
					PlanningCtrl.m_bMoveDown=1;
					m_bMoveUDByLaptop=True;
					m_bClosePopup=True;
				}
				else
				{
					if ( m_bMoveUDByLaptop == True )
					{
						m_bMoveUDByLaptop=False;
						PlanningCtrl.m_bMoveDown=0;
						PlanningCtrl.m_bMoveUp=0;
						m_bClosePopup=True;
					}
				}
			}
		}
		else
		{
			if ( Root.MouseX < 23 )
			{
				PlanningCtrl.m_bMoveLeft=1;
				m_bMoveRLByLaptop=True;
				m_bClosePopup=True;
			}
			else
			{
				if ( Root.MouseX > 616 )
				{
					PlanningCtrl.m_bMoveRight=1;
					m_bMoveRLByLaptop=True;
				}
				else
				{
					if ( m_bMoveRLByLaptop == True )
					{
						m_bMoveRLByLaptop=False;
						PlanningCtrl.m_bMoveLeft=0;
						PlanningCtrl.m_bMoveRight=0;
						m_bClosePopup=True;
					}
				}
			}
			if ( Root.MouseY < 52 )
			{
				PlanningCtrl.m_bMoveUp=1;
				m_bMoveUDByLaptop=True;
				m_bClosePopup=True;
			}
			else
			{
				if ( Root.MouseY > 362 )
				{
					PlanningCtrl.m_bMoveDown=1;
					m_bMoveUDByLaptop=True;
					m_bClosePopup=True;
				}
				else
				{
					if ( m_bMoveUDByLaptop == True )
					{
						m_bMoveUDByLaptop=False;
						PlanningCtrl.m_bMoveDown=0;
						PlanningCtrl.m_bMoveUp=0;
						m_bClosePopup=True;
					}
				}
			}
		}
		if ( PlanningCtrl.m_bFirstTick == True )
		{
			PlanningCtrl.m_bFirstTick=False;
			TheRegion.W=(m_Right.WinLeft - m_Left.WinWidth) / 3;
			TheRegion.H=(m_Bottom.WinTop - m_Top.WinHeight) / 3;
			TheRegion.X=m_Left.WinWidth + 3;
			TheRegion.Y=m_Top.WinHeight + m_fLabelHeight + 2;
			PlanningCtrl.Set3DViewPosition(TheRegion.X,TheRegion.Y,TheRegion.H,TheRegion.W);
		}
	}
	if ( m_bClosePopup )
	{
		CloseAllPopup();
		m_bClosePopup=False;
	}
}

function LMouseDown (float fMouseX, float fMouseY)
{
	local R6PlanningCtrl PlanningCtrl;

	Super.LMouseDown(fMouseX,fMouseY);
	if ( m_bPopUpMenuPoint || m_bPopUpMenuSpeed )
	{
		CloseAllPopup();
	}
	else
	{
		PlanningCtrl=R6PlanningCtrl(GetPlayerOwner());
		if ( PlanningCtrl != None )
		{
			PlanningCtrl.LMouseDown(fMouseX * Root.GUIScale,fMouseY * Root.GUIScale);
		}
	}
}

function LMouseUp (float fMouseX, float fMouseY)
{
	local R6PlanningCtrl PlanningCtrl;

	Super.LMouseUp(fMouseX,fMouseY);
	PlanningCtrl=R6PlanningCtrl(GetPlayerOwner());
	if ( PlanningCtrl != None )
	{
		PlanningCtrl.LMouseUp(fMouseX * Root.GUIScale,fMouseY * Root.GUIScale);
	}
}

function RMouseDown (float fMouseX, float fMouseY)
{
	local R6PlanningCtrl PlanningCtrl;

	Super.RMouseDown(fMouseX,fMouseY);
	if ( m_bPopUpMenuPoint || m_bPopUpMenuSpeed )
	{
		CloseAllPopup();
	}
	else
	{
		PlanningCtrl=R6PlanningCtrl(GetPlayerOwner());
		if ( PlanningCtrl != None )
		{
			PlanningCtrl.RMouseDown(fMouseX * Root.GUIScale,fMouseY * Root.GUIScale);
		}
	}
}

function RMouseUp (float fMouseX, float fMouseY)
{
	local R6PlanningCtrl PlanningCtrl;

	Super.RMouseUp(fMouseX,fMouseY);
	PlanningCtrl=R6PlanningCtrl(GetPlayerOwner());
	if ( PlanningCtrl != None )
	{
		PlanningCtrl.RMouseUp(fMouseX * Root.GUIScale,fMouseY * Root.GUIScale);
	}
}

function MouseMove (float fMouseX, float fMouseY)
{
	local R6PlanningCtrl PlanningCtrl;

	Super.MouseMove(fMouseX,fMouseY);
	PlanningCtrl=R6PlanningCtrl(GetPlayerOwner());
	if ( PlanningCtrl != None )
	{
		PlanningCtrl.MouseMove(fMouseX * Root.GUIScale,fMouseY * Root.GUIScale);
	}
}

function SetMousePos (float X, float Y)
{
	local float fMouseX;
	local float fMouseY;

	if ( Root.m_bUseDragIcon == True )
	{
		fMouseX=X;
		fMouseY=Y;
		if ( fMouseX < 22 )
		{
			fMouseX=22.00;
		}
		else
		{
			if ( fMouseX > 617 )
			{
				fMouseX=617.00;
			}
		}
		if ( fMouseY < 51 )
		{
			fMouseY=51.00;
		}
		else
		{
			if ( fMouseY > 363 )
			{
				fMouseY=363.00;
			}
		}
		Root.Console.MouseX=fMouseX;
		Root.Console.MouseY=fMouseY;
	}
	else
	{
		Super.SetMousePos(X,Y);
	}
}

function KeyType (int iInputKey, float X, float Y)
{
	switch (iInputKey)
	{
		case 1024:
		DisplayActionTypePopUp(X,Y);
		return;
		case 1026:
		DisplayPathFlagPopUp(X,Y);
		return;
		default:
	}
}

function DisplayActionTypePopUp (float X, float Y)
{
	local bool bDisplayUp;
	local bool bDisplayLeft;

	if ( X / (m_Right.WinLeft - m_Left.WinWidth) > 0.50 )
	{
		bDisplayLeft=True;
	}
	if ( Y / (m_Bottom.WinTop - m_Top.WinHeight) > 0.50 )
	{
		bDisplayUp=True;
	}
	if ( m_3DButton.m_bSelected == True )
	{
		Y=200.00;
		bDisplayUp=False;
	}
	if ( m_PopUpMenuPoint == None )
	{
		m_PopUpMenuPoint=R6MenuActionPointMenu(CreateWindow(Class'R6MenuActionPointMenu',X,Y,100.00,100.00,self));
	}
	else
	{
		m_PopUpMenuPoint.WinLeft=X;
		m_PopUpMenuPoint.WinTop=Y;
	}
	m_PopUpMenuPoint.AjustPosition(bDisplayUp,bDisplayLeft);
	R6MenuListActionTypeButton(m_PopUpMenuPoint.m_ButtonList).DisplayMilestoneButton();
	m_PopUpMenuPoint.ShowWindow();
	m_bPopUpMenuPoint=True;
}

function DisplayPathFlagPopUp (float X, float Y)
{
	local bool bDisplayUp;
	local bool bDisplayLeft;

	if ( X / (m_Right.WinLeft - m_Left.WinWidth) > 0.50 )
	{
		bDisplayLeft=True;
	}
	if ( Y / (m_Bottom.WinTop - m_Top.WinHeight) > 0.50 )
	{
		bDisplayUp=True;
	}
	if ( m_3DButton.m_bSelected == True )
	{
		Y=200.00;
		bDisplayUp=False;
	}
	if ( m_PopUpMenuMode == None )
	{
		m_PopUpMenuMode=R6MenuModeMenu(CreateWindow(Class'R6MenuModeMenu',X,Y,100.00,100.00,self));
		m_PopUpMenuMode.AjustPosition(bDisplayUp,bDisplayLeft);
	}
	else
	{
		m_PopUpMenuMode.WinLeft=X;
		m_PopUpMenuMode.WinTop=Y;
		m_PopUpMenuMode.AjustPosition(bDisplayUp,bDisplayLeft);
		m_PopUpMenuMode.ShowWindow();
	}
	m_bPopUpMenuSpeed=True;
}

function CloseAllPopup ()
{
	if ( bShowLog )
	{
		Log("Closing all Popups!");
	}
	if ( (m_PopUpMenuPoint != None) && m_PopUpMenuPoint.bWindowVisible )
	{
		m_PopUpMenuPoint.HideWindow();
		m_bPopUpMenuPoint=False;
	}
	if ( (m_PopUpMenuMode != None) && m_PopUpMenuMode.bWindowVisible )
	{
		m_PopUpMenuMode.HideWindow();
		m_bPopUpMenuSpeed=False;
	}
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local R6PlanningCtrl PlanningCtrl;

	if ( R6MenuRootWindow(Root).m_ePopUpID != 0 )
	{
		Super.WindowEvent(Msg,C,X,Y,Key);
		return;
	}
	switch (Msg)
	{
/*		case 9:
		if ( GetPlayerOwner().IsA('R6PlanningCtrl') )
		{
			PlanningCtrl=R6PlanningCtrl(GetPlayerOwner());
			CloseAllPopup();
		}
		break;
		case 8:
		if ( GetPlayerOwner().IsA('R6PlanningCtrl') )
		{
			PlanningCtrl=R6PlanningCtrl(GetPlayerOwner());
			CloseAllPopup();
		}
		break;
		default:
		Super.WindowEvent(Msg,C,X,Y,Key);
		break;*/
	}
}

defaultproperties
{
    m_fLabelHeight=18.00
}
