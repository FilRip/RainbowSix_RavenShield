//================================================================================
// UWindowRootWindow.
//================================================================================
class UWindowRootWindow extends UWindowWindow;

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

enum eRootID {
	RootID_UWindow,
	RootID_R6Menu,
	RootID_R6MenuInGame,
	RootID_R6MenuInGameMulti
};

var bool bMouseCapture;
var bool bRequestQuit;
var bool bAllowConsole;
var bool m_bUseAimIcon;
var bool m_bUseDragIcon;
var bool m_bScaleWindowToRoot;
var bool m_bWidgetResolutionFix;
var float MouseX;
var float MouseY;
var float OldMouseX;
var float OldMouseY;
var float GUIScale;
var float RealWidth;
var float RealHeight;
var float QuitTime;
var float m_fWindowScaleX;
var float m_fWindowScaleY;
var UWindowWindow MouseWindow;
var WindowConsole Console;
var UWindowWindow FocusedWindow;
var UWindowWindow KeyFocusWindow;
var UWindowHotkeyWindowList HotkeyWindows;
var Font Fonts[30];
var UWindowLookAndFeel LooksAndFeels[20];
var R6GameColors Colors;
var UWindowMenuClassDefines MenuClassDefines;
var MouseCursor NormalCursor;
var MouseCursor MoveCursor;
var MouseCursor DiagCursor1;
var MouseCursor HandCursor;
var MouseCursor HSplitCursor;
var MouseCursor VSplitCursor;
var MouseCursor DiagCursor2;
var MouseCursor NSCursor;
var MouseCursor WECursor;
var MouseCursor WaitCursor;
var MouseCursor AimCursor;
var MouseCursor DragCursor;
var config string LookAndFeelClass;

var eRootID m_eRootId;
var eGameWidgetID m_eCurWidgetInUse;
var eGameWidgetID m_ePrevWidgetInUse;

function ChangeCurrentWidget (eGameWidgetID widgetID);

function ResetMenus (optional bool _bConnectionFailed);

function UpdateMenus (int iWhatToUpdate);

function ChangeInstructionWidget (Actor pISV, bool bShow, int iBox, int iParagraph);

function StopPlayMode ();

function bool PlanningShouldProcessKey ();

function bool PlanningShouldDrawPath ();

function EPopUpID GetSimplePopUpID ();

function SimplePopUp (string _szTitle, string _szText, EPopUpID _ePopUpID, optional int _iButtonsType, optional bool bAddDisableDlg, optional UWindowWindow OwnerWindow);

function ModifyPopUpInsideText (array<string> _ANewText);

function bool GetMapNameLocalisation (string _szMapName, out string _szMapNameLoc, optional bool _bReturnInitName);

function BeginPlay ()
{
	Root=self;
	MouseWindow=self;
	KeyFocusWindow=self;
}

function UWindowLookAndFeel GetLookAndFeel (string LFClassName)
{
	local int i;
	local Class<UWindowLookAndFeel> LFClass;

	LFClass=Class<UWindowLookAndFeel>(DynamicLoadObject(LFClassName,Class'Class'));
	i=0;
JL0022:
	if ( i < 20 )
	{
		if ( LooksAndFeels[i] == None )
		{
			LooksAndFeels[i]=new LFClass;
			LooksAndFeels[i].Setup();
			return LooksAndFeels[i];
		}
		if ( LooksAndFeels[i].Class == LFClass )
		{
			return LooksAndFeels[i];
		}
		i++;
		goto JL0022;
	}
	Log("Out of LookAndFeel array space!!");
	return None;
}

function Created ()
{
	m_eRootId=RootID_UWindow;
	LookAndFeel=GetLookAndFeel(LookAndFeelClass);
	SetupFonts();
//	NormalCursor.Tex=Texture'MouseCursor';
	NormalCursor.HotX=0;
	NormalCursor.HotY=0;
//	NormalCursor.WindowsCursor=Console.ViewportOwner.0;
//	MoveCursor.Tex=Texture'MouseMove';
	MoveCursor.HotX=8;
	MoveCursor.HotY=8;
//	MoveCursor.WindowsCursor=Console.ViewportOwner.1;
//	DiagCursor1.Tex=Texture'MouseDiag1';
	DiagCursor1.HotX=8;
	DiagCursor1.HotY=8;
//	DiagCursor1.WindowsCursor=Console.ViewportOwner.4;
//	HandCursor.Tex=Texture'MouseHand';
	HandCursor.HotX=11;
	HandCursor.HotY=1;
//	HandCursor.WindowsCursor=Console.ViewportOwner.0;
//	HSplitCursor.Tex=Texture'MouseHSplit';
	HSplitCursor.HotX=9;
	HSplitCursor.HotY=9;
//	HSplitCursor.WindowsCursor=Console.ViewportOwner.5;
//	VSplitCursor.Tex=Texture'MouseVSplit';
	VSplitCursor.HotX=9;
	VSplitCursor.HotY=9;
//	VSplitCursor.WindowsCursor=Console.ViewportOwner.3;
//	DiagCursor2.Tex=Texture'MouseDiag2';
	DiagCursor2.HotX=7;
	DiagCursor2.HotY=7;
//	DiagCursor2.WindowsCursor=Console.ViewportOwner.2;
//	NSCursor.Tex=Texture'MouseNS';
	NSCursor.HotX=3;
	NSCursor.HotY=7;
//	NSCursor.WindowsCursor=Console.ViewportOwner.3;
//	WECursor.Tex=Texture'MouseWE';
	WECursor.HotX=7;
	WECursor.HotY=3;
//	WECursor.WindowsCursor=Console.ViewportOwner.5;
//	WaitCursor.Tex=Texture'MouseWait';
	WECursor.HotX=6;
	WECursor.HotY=9;
//	WECursor.WindowsCursor=Console.ViewportOwner.6;
//	AimCursor.Tex=Texture'PlanCursor_Aim';
	AimCursor.HotX=16;
	AimCursor.HotY=16;
//	DragCursor.Tex=Texture'PlanCursor_Drag';
	DragCursor.HotX=5;
	DragCursor.HotY=5;
	Colors=new Class'R6GameColors';
	MenuClassDefines=new Class'UWindowMenuClassDefines';
	MenuClassDefines.Created();
	HotkeyWindows=new Class'UWindowHotkeyWindowList';
	HotkeyWindows.Last=HotkeyWindows;
	HotkeyWindows.Next=None;
	HotkeyWindows.Sentinel=HotkeyWindows;
	Cursor=NormalCursor;
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

	if ( Console.ViewportOwner.bWindowsMouseAvailable )
	{
		Console.ViewportOwner.SelectedCursor=MouseWindow.Cursor.WindowsCursor;
	}
	else
	{
		C.SetDrawColor(255,255,255);
		C.SetPos(MouseX * GUIScale - MouseWindow.Cursor.HotX,MouseY * GUIScale - MouseWindow.Cursor.HotY);
		C.DrawIcon(MouseWindow.Cursor.Tex,1.00);
	}
}

function bool CheckCaptureMouseUp ()
{
	local float X;
	local float Y;

	if ( bMouseCapture )
	{
		MouseWindow.GetMouseXY(X,Y);
		MouseWindow.LMouseUp(X,Y);
		bMouseCapture=False;
		return True;
	}
	return False;
}

function bool CheckCaptureMouseDown ()
{
	local float X;
	local float Y;

	if ( bMouseCapture )
	{
		MouseWindow.GetMouseXY(X,Y);
		MouseWindow.LMouseDown(X,Y);
		bMouseCapture=False;
		return True;
	}
	return False;
}

function CancelCapture ()
{
	bMouseCapture=False;
}

function CaptureMouse (optional UWindowWindow W)
{
	bMouseCapture=True;
	if ( W != None )
	{
		MouseWindow=W;
	}
}

function Texture GetLookAndFeelTexture ()
{
	return LookAndFeel.Active;
}

function bool IsActive ()
{
	return True;
}

function AddHotkeyWindow (UWindowWindow W)
{
	UWindowHotkeyWindowList(HotkeyWindows.Insert(Class'UWindowHotkeyWindowList')).Window=W;
}

function RemoveHotkeyWindow (UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

	L=HotkeyWindows.FindWindow(W);
	if ( L != None )
	{
		L.Remove();
	}
}

function bool IsAHotKeyWindow (UWindowWindow W)
{
	local UWindowHotkeyWindowList L;

	L=HotkeyWindows.FindWindow(W);
	if ( L != None )
	{
		return True;
	}
	return False;
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	switch (Msg)
	{
		case WM_KeyDown:
		if ( HotKeyDown(Key,X,Y) )
		{
			return;
		}
		break;
		case WM_KeyUp:
		if ( HotKeyUp(Key,X,Y) )
		{
			return;
		}
		break;
		case WM_LMouseDown:
		case WM_MMouseDown:
		case WM_RMouseDown:
		if ( MouseUpDown(Key,X,Y) )
		{
			return;
		}
		break;
		default:
	}
	Super.WindowEvent(Msg,C,X,Y,Key);
}

function bool HotKeyDown (int Key, float X, float Y)
{
	local UWindowHotkeyWindowList L;

	L=UWindowHotkeyWindowList(HotkeyWindows.Next);
JL0019:
	if ( L != None )
	{
		if ( (L.Window != self) && L.Window.HotKeyDown(Key,X,Y) )
		{
			return True;
		}
		L=UWindowHotkeyWindowList(L.Next);
		goto JL0019;
	}
	return False;
}

function bool HotKeyUp (int Key, float X, float Y)
{
	local UWindowHotkeyWindowList L;

	L=UWindowHotkeyWindowList(HotkeyWindows.Next);
JL0019:
	if ( L != None )
	{
		if ( (L.Window != self) && L.Window.HotKeyUp(Key,X,Y) )
		{
			return True;
		}
		L=UWindowHotkeyWindowList(L.Next);
		goto JL0019;
	}
	return False;
}

function bool MouseUpDown (int Key, float X, float Y)
{
	local UWindowHotkeyWindowList L;

	L=UWindowHotkeyWindowList(HotkeyWindows.Next);
JL0019:
	if ( L != None )
	{
		if ( (L.Window != self) && L.Window.MouseUpDown(Key,X,Y) )
		{
			return True;
		}
		L=UWindowHotkeyWindowList(L.Next);
		goto JL0019;
	}
	return False;
}

function CloseActiveWindow ()
{
	if ( ActiveWindow != None )
	{
		ActiveWindow.EscClose();
	}
	else
	{
		Console.CloseUWindow();
	}
}

function Resized ()
{
	ResolutionChanged(WinWidth,WinHeight);
}

function SetScale (float NewScale)
{
	WinWidth=RealWidth / NewScale;
	WinHeight=RealHeight / NewScale;
	GUIScale=NewScale;
	ClippingRegion.X=0;
	ClippingRegion.Y=0;
	ClippingRegion.W=WinWidth;
	ClippingRegion.H=WinHeight;
	SetupFonts();
	Resized();
}

function SetResolution (float _NewWidth, float _NewHeight)
{
	WinWidth=_NewWidth;
	WinHeight=_NewHeight;
	ClippingRegion.X=0;
	ClippingRegion.Y=0;
	ClippingRegion.W=WinWidth;
	ClippingRegion.H=WinHeight;
	Resized();
}

function SetupFonts ()
{
/*	Fonts[4]=Font'Rainbow6_36pt';
	Fonts[5]=Font'Rainbow6_14pt';
	Fonts[6]=Font'Rainbow6_12pt';
	Fonts[7]=Font'Rainbow6_15pt';
	Fonts[8]=Font'Rainbow6_15pt';
	Fonts[9]=Font'OcraExt_14pt';
	Fonts[10]=Font'Arial_10pt';
	Fonts[11]=Font'Rainbow6_14pt';
	Fonts[12]=Font'Rainbow6_12pt';
	Fonts[14]=Font'Rainbow6_36pt';
	Fonts[15]=Font'Rainbow6_17pt';
	Fonts[16]=Font'Rainbow6_17pt';
	Fonts[17]=Font'Rainbow6_12pt';
	Fonts[0]=Font'Rainbow6_12pt';*/
}

function ChangeLookAndFeel (string NewLookAndFeel)
{
	LookAndFeelClass=NewLookAndFeel;
	SaveConfig();
	Console.ResetUWindow();
}

function HideWindow ()
{
}

function SetMousePos (float X, float Y)
{
	Console.MouseX=X;
	Console.MouseY=Y;
}

function QuitGame ()
{
	bRequestQuit=True;
	QuitTime=0.00;
	NotifyQuitUnreal();
}

function DoQuitGame ()
{
	SaveConfig();
	Close();
	Console.ViewportOwner.Actor.ConsoleCommand("exit");
}

function Tick (float Delta)
{
	if ( bRequestQuit )
	{
		if ( QuitTime > 0.25 )
		{
			DoQuitGame();
		}
		QuitTime += Delta;
	}
	Super.Tick(Delta);
}

function SetNewMODS (string _szNewBkgFolder, optional bool _bForceRefresh)
{
}

function SetLoadRandomBackgroundImage (string _szFolder)
{
}

function PaintBackground (Canvas C, UWindowWindow _WidgetWindow)
{
}

function DrawBackGroundEffect (Canvas C, Color _BGColor)
{
	local float OrgX;
	local float OrgY;
	local float ClipX;
	local float ClipY;

	OrgX=C.OrgX;
	OrgY=C.OrgY;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	C.SetOrigin(0.00,0.00);
	C.SetClip(C.SizeX,C.SizeY);
	C.SetDrawColor(_BGColor.R,_BGColor.G,_BGColor.B,_BGColor.A);
	C.SetPos(0.00,0.00);
//	C.DrawTile(Texture'WhiteTexture',C.SizeX,C.SizeY,0.00,0.00,10.00,10.00);
	C.SetClip(ClipX,ClipY);
	C.SetOrigin(OrgX,OrgY);
}

function bool TrapKey (bool _bIncludeMouseMove)
{
	return True;
}

defaultproperties
{
    bAllowConsole=True
    GUIScale=1.00
    m_fWindowScaleX=1.00
    m_fWindowScaleY=1.00
}
