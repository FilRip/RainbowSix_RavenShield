//================================================================================
// UWindowWindow.
//================================================================================
class UWindowWindow extends UWindowBase;

const DE_WheelDownPressed= 15;
const DE_WheelUpPressed= 14;
const DE_HelpChanged= 13;
const DE_MouseEnter= 12;
const DE_DoubleClick= 11;
const DE_LMouseDown= 10;
const DE_MouseLeave= 9;
const DE_MouseMove= 8;
const DE_EnterPressed= 7;
const DE_RClick= 6;
const DE_MClick= 5;
const DE_Exit= 4;
const DE_Enter= 3;
const DE_Click= 2;
const DE_Change= 1;
const DE_Created= 0;

enum eR6MenuWidgetMessage {
	MWM_UBI_LOGIN_SUCCESS,
	MWM_UBI_LOGIN_FAIL,
	MWM_UBI_LOGIN_SKIPPED,
	MWM_CDKEYVAL_SKIPPED,
	MWM_CDKEYVAL_SUCCESS,
	MWM_CDKEYVAL_FAIL,
	MWM_UBI_JOINIP_SUCCESS,
	MWM_UBI_JOINIP_FAIL,
	MWM_QUERYSERVER_SUCCESS,
	MWM_QUERYSERVER_FAIL,
	MWM_QUERYSERVER_TRYAGAIN
};

enum WinMessage {
	WM_LMouseDown,
	WM_LMouseUp,
	WM_MMouseDown,
	WM_MMouseUp,
	WM_RMouseDown,
	WM_RMouseUp,
	WM_MouseWheelDown,
	WM_MouseWheelUp,
	WM_KeyUp,
	WM_KeyDown,
	WM_KeyType,
	WM_Paint
};

struct MouseCursor
{
	var Texture Tex;
	var int HotX;
	var int HotY;
	var byte WindowsCursor;
};

var int m_BorderStyle;
var bool bWindowVisible;
var bool bNoClip;
var bool bMouseDown;
var bool bRMouseDown;
var bool bMMouseDown;
var bool bAlwaysBehind;
var bool bAcceptsFocus;
var bool bAlwaysAcceptsFocus;
var bool bAlwaysOnTop;
var bool bLeaveOnscreen;
var bool bUWindowActive;
var bool bTransient;
var bool bAcceptsHotKeys;
var bool bIgnoreLDoubleClick;
var bool bIgnoreMDoubleClick;
var bool bIgnoreRDoubleClick;
var bool m_bNotDisplayBkg;
var bool m_bPreCalculatePos;
var float WinLeft;
var float WinTop;
var float WinWidth;
var float WinHeight;
var float OrgXOffset;
var float OrgYOffset;
var float ClickTime;
var float MClickTime;
var float RClickTime;
var float ClickX;
var float ClickY;
var float MClickX;
var float MClickY;
var float RClickX;
var float RClickY;
var UWindowWindow ParentWindow;
var UWindowWindow FirstChildWindow;
var UWindowWindow LastChildWindow;
var UWindowWindow NextSiblingWindow;
var UWindowWindow PrevSiblingWindow;
var UWindowWindow ActiveWindow;
var UWindowRootWindow Root;
var UWindowWindow OwnerWindow;
var UWindowWindow ModalWindow;
var UWindowLookAndFeel LookAndFeel;
var Texture m_BorderTexture;
var Region ClippingRegion;
var Region m_BorderTextureRegion;
var Color m_BorderColor;
var MouseCursor Cursor;
var string ToolTipString;

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	switch (Msg)
	{
		case WM_Paint:
		Paint(C,X,Y);
		PaintClients(C,X,Y);
		break;
		case WM_LMouseDown:
		if (  !Root.CheckCaptureMouseDown() )
		{
			if (  !MessageClients(Msg,C,X,Y,Key) )
			{
				LMouseDown(X,Y);
			}
		}
		break;
		case WM_LMouseUp:
		if (  !Root.CheckCaptureMouseUp() )
		{
			if (  !MessageClients(Msg,C,X,Y,Key) )
			{
				LMouseUp(X,Y);
			}
		}
		break;
		case WM_RMouseDown:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			RMouseDown(X,Y);
		}
		break;
		case WM_RMouseUp:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			RMouseUp(X,Y);
		}
		break;
		case WM_MMouseDown:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			MMouseDown(X,Y);
		}
		break;
		case WM_MMouseUp:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			MMouseUp(X,Y);
		}
		break;
		case WM_MouseWheelDown:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			MouseWheelDown(X,Y);
		}
		break;
		case WM_MouseWheelUp:
		if (  !MessageClients(Msg,C,X,Y,Key) )
		{
			MouseWheelUp(X,Y);
		}
		break;
		case WM_KeyDown:
		if (  !PropagateKey(Msg,C,X,Y,Key) )
		{
			KeyDown(Key,X,Y);
		}
		break;
		case WM_KeyUp:
		if (  !PropagateKey(Msg,C,X,Y,Key) )
		{
			KeyUp(Key,X,Y);
		}
		break;
		case WM_KeyType:
		if (  !PropagateKey(Msg,C,X,Y,Key) )
		{
			KeyType(Key,X,Y);
		}
		break;
		default:
		break;
	}
}

function SaveConfigs ()
{
}

final function PlayerController GetPlayerOwner ()
{
	return Root.Console.ViewportOwner.Actor;
}

final function LevelInfo GetLevel ()
{
	return Root.Console.ViewportOwner.Actor.Level;
}

final function float GetTime ()
{
	return Class'Actor'.static.GetTime();
	return 0.00;
}

final function LevelInfo GetEntryLevel ()
{
//	return Root.Console.ViewportOwner.Actor.Super(PlayerController).GetEntryLevel();
	return None;
}

final function UWindowWindow GetButtonsDefinesUnique (Class<UWindowWindow> WndClass)
{
	local UWindowWindow Child;

	Child=Root.FindChildWindow(WndClass,True);
	if ( Child == None )
	{
		Child=Root.CreateWindow(WndClass,0.00,0.00,0.00,0.00,None,True);
	}
	return Child;
}

function Resized ()
{
}

function BeforePaint (Canvas C, float X, float Y)
{
}

function AfterPaint (Canvas C, float X, float Y)
{
}

function Paint (Canvas C, float X, float Y)
{
}

function Click (float X, float Y)
{
}

function MClick (float X, float Y)
{
}

function RClick (float X, float Y)
{
}

function DoubleClick (float X, float Y)
{
}

function MDoubleClick (float X, float Y)
{
}

function RDoubleClick (float X, float Y)
{
}

function BeginPlay ()
{
}

function Created ()
{
}

function MouseEnter ()
{
	if ( ToolTipString != "" )
	{
		ToolTip(ToolTipString);
	}
}

function Activated ()
{
}

function Deactivated ()
{
}

function MouseLeave ()
{
	bMouseDown=False;
	bMMouseDown=False;
	bRMouseDown=False;
	if ( ToolTipString != "" )
	{
		ToolTip("");
	}
}

function MouseMove (float X, float Y)
{
}

function KeyUp (int Key, float X, float Y)
{
}

function KeyDown (int Key, float X, float Y)
{
}

function bool HotKeyDown (int Key, float X, float Y)
{
	return False;
}

function bool HotKeyUp (int Key, float X, float Y)
{
	return False;
}

function bool MouseUpDown (int Key, float X, float Y)
{
	return False;
}

function KeyType (int Key, float X, float Y)
{
}

function ProcessMenuKey (int Key, string KeyName)
{
}

function KeyFocusEnter ()
{
}

function KeyFocusExit ()
{
}

function RMouseDown (float X, float Y)
{
	ActivateWindow(0,False);
	bRMouseDown=True;
}

function RMouseUp (float X, float Y)
{
	if ( bRMouseDown )
	{
		if (  !bIgnoreRDoubleClick && (Abs(X - RClickX) <= 1) && (Abs(Y - RClickY) <= 1) && (GetTime() < RClickTime + 0.40) )
		{
			RDoubleClick(X,Y);
			RClickTime=0.00;
		}
		else
		{
			RClickTime=GetTime();
			RClickX=X;
			RClickY=Y;
			RClick(X,Y);
		}
	}
	bRMouseDown=False;
}

function MMouseDown (float X, float Y)
{
	ActivateWindow(0,False);
	bMMouseDown=True;
}

function MMouseUp (float X, float Y)
{
	if ( bMMouseDown )
	{
		if (  !bIgnoreMDoubleClick && (Abs(X - MClickX) <= 1) && (Y - MClickY <= 1) && (GetTime() < MClickTime + 0.40) )
		{
			MDoubleClick(X,Y);
			MClickTime=0.00;
		}
		else
		{
			MClickTime=GetTime();
			MClickX=X;
			MClickY=Y;
			MClick(X,Y);
		}
	}
	bMMouseDown=False;
}

function MouseWheelDown (float X, float Y)
{
}

function MouseWheelUp (float X, float Y)
{
}

function LMouseDown (float X, float Y)
{
	ActivateWindow(0,False);
	bMouseDown=True;
}

function LMouseUp (float X, float Y)
{
	if ( bMouseDown )
	{
		if (  !bIgnoreLDoubleClick && (Abs(X - ClickX) <= 1) && (Y - ClickY <= 1) && (GetTime() < ClickTime + 0.40) )
		{
			DoubleClick(X,Y);
			ClickTime=0.00;
		}
		else
		{
			ClickTime=GetTime();
			ClickX=X;
			ClickY=Y;
			Click(X,Y);
		}
	}
	bMouseDown=False;
}

function FocusWindow ()
{
	if ( (Root.FocusedWindow != None) && (Root.FocusedWindow != self) )
	{
		Root.FocusedWindow.FocusOtherWindow(self);
	}
	Root.FocusedWindow=self;
}

function FocusOtherWindow (UWindowWindow W)
{
}

function EscClose ()
{
	Close();
}

function Close (optional bool bByParent)
{
	local UWindowWindow Prev;
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Prev=Child.PrevSiblingWindow;
		Child.Close(True);
		Child=Prev;
		goto JL000B;
	}
	SaveConfigs();
	if (  !bByParent )
	{
		HideWindow();
	}
}

final function SetSize (float W, float H)
{
	if ( (WinWidth != W) || (WinHeight != H) )
	{
		WinWidth=W;
		WinHeight=H;
		Resized();
	}
}

function Tick (float Delta)
{
}

final function DoTick (float Delta)
{
	local UWindowWindow Child;

	Tick(Delta);
	Child=FirstChildWindow;
JL0016:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
//			Child.Super(UWindowWindow).DoTick(Delta);
		}
		Child=Child.NextSiblingWindow;
		goto JL0016;
	}
}

final function PaintClients (Canvas C, float X, float Y)
{
	local float OrgX;
	local float OrgY;
	local float ClipX;
	local float ClipY;
	local UWindowWindow Child;

	OrgX=C.OrgX;
	OrgY=C.OrgY;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	Child=FirstChildWindow;
JL005B:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		C.SetPos(0.00,0.00);
//		C.Style=GetPlayerOwner().1;
		C.SetDrawColor(255,255,255);
		C.SpaceX=0.00;
		C.SpaceY=0.00;
		Child.BeforePaint(C,X - Child.WinLeft,Y - Child.WinTop);
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			C.OrgX=C.OrgX + Child.WinLeft * Root.GUIScale;
			C.OrgY=C.OrgY + Child.WinTop * Root.GUIScale;
			if (  !Child.bNoClip )
			{
				C.ClipX=FMin(WinWidth - Child.WinLeft,Child.WinWidth) * Root.GUIScale;
				C.ClipY=FMin(WinHeight - Child.WinTop,Child.WinHeight) * Root.GUIScale;
				C.HalfClipX=C.ClipX * 0.50;
				C.HalfClipY=C.ClipY * 0.50;
				Child.ClippingRegion.X=ClippingRegion.X - Child.WinLeft;
				Child.ClippingRegion.Y=ClippingRegion.Y - Child.WinTop;
				Child.ClippingRegion.W=ClippingRegion.W;
				Child.ClippingRegion.H=ClippingRegion.H;
				if ( Child.ClippingRegion.X < 0 )
				{
					Child.ClippingRegion.W += Child.ClippingRegion.X;
					Child.ClippingRegion.X=0;
				}
				if ( Child.ClippingRegion.Y < 0 )
				{
					Child.ClippingRegion.H += Child.ClippingRegion.Y;
					Child.ClippingRegion.Y=0;
				}
				if ( Child.ClippingRegion.W > Child.WinWidth - Child.ClippingRegion.X )
				{
					Child.ClippingRegion.W=Child.WinWidth - Child.ClippingRegion.X;
				}
				if ( Child.ClippingRegion.H > Child.WinHeight - Child.ClippingRegion.Y )
				{
					Child.ClippingRegion.H=Child.WinHeight - Child.ClippingRegion.Y;
				}
			}
			if ( (Child.ClippingRegion.W > 0) && (Child.ClippingRegion.H > 0) )
			{
				if (  !Child.m_bPreCalculatePos )
				{
					Child.WindowEvent(WM_Paint,C,X - Child.WinLeft,Y - Child.WinTop,0);
					Child.AfterPaint(C,X - Child.WinLeft,Y - Child.WinTop);
				}
				Child.m_bPreCalculatePos=False;
			}
			C.OrgX=OrgX;
			C.OrgY=OrgY;
		}
		Child=Child.NextSiblingWindow;
		goto JL005B;
	}
	C.ClipX=ClipX;
	C.ClipY=ClipY;
	C.HalfClipX=C.ClipX * 0.50;
	C.HalfClipY=C.ClipY * 0.50;
}

final function UWindowWindow FindWindowUnder (float X, float Y)
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			if ( (X >= Child.WinLeft) && (X <= Child.WinLeft + Child.WinWidth) && (Y >= Child.WinTop) && (Y <= Child.WinTop + Child.WinHeight) &&  !Child.CheckMousePassThrough(X - Child.WinLeft,Y - Child.WinTop) )
			{
//				return Child.Super(UWindowWindow).FindWindowUnder(X - Child.WinLeft,Y - Child.WinTop);
			}
		}
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
	return self;
}

function ApplyResolutionOnWindowsPos (float X, float Y)
{
	local UWindowWindow Child;
	local float fX;
	local float fY;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( Root.m_bScaleWindowToRoot )
		{
			return;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			fX=(Root.WinWidth - 640) * 0.50;
			fY=(Root.WinHeight - 480) * 0.50;
			if ( Child.OrgXOffset != fX )
			{
				Child.WinLeft -= Child.OrgXOffset;
				Child.OrgXOffset=fX;
				Child.WinLeft += Child.OrgXOffset;
			}
			if ( Child.OrgYOffset != fY )
			{
				Child.WinTop -= Child.OrgYOffset;
				Child.OrgYOffset=fY;
				Child.WinTop += Child.OrgYOffset;
			}
		}
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function bool PropagateKey (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local UWindowWindow Child;

	Child=LastChildWindow;
	if ( (ActiveWindow != None) && (Child != ActiveWindow) &&  !Child.bTransient )
	{
		Child=ActiveWindow;
	}
JL0048:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( (bUWindowActive || Child.bLeaveOnscreen) && Child.bAcceptsFocus )
		{
			Child.WindowEvent(Msg,C,X - Child.WinLeft,Y - Child.WinTop,Key);
			return True;
		}
		Child=Child.PrevSiblingWindow;
		goto JL0048;
	}
	return False;
}

final function UWindowWindow CheckKeyFocusWindow ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
	if ( (ActiveWindow != None) && (Child != ActiveWindow) &&  !Child.bTransient )
	{
		Child=ActiveWindow;
	}
JL0048:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			if ( Child.bAcceptsFocus )
			{
//				return Child.Super(UWindowWindow).CheckKeyFocusWindow();
			}
		}
		Child=Child.PrevSiblingWindow;
		goto JL0048;
	}
	return self;
}

final function bool MessageClients (WinMessage Msg, Canvas C, float X, float Y, int Key)
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.bUWindowActive=bUWindowActive;
		if ( bLeaveOnscreen )
		{
			Child.bLeaveOnscreen=True;
		}
		if ( bUWindowActive || Child.bLeaveOnscreen )
		{
			if ( (X >= Child.WinLeft) && (X <= Child.WinLeft + Child.WinWidth) && (Y >= Child.WinTop) && (Y <= Child.WinTop + Child.WinHeight) &&  !Child.CheckMousePassThrough(X - Child.WinLeft,Y - Child.WinTop) )
			{
				Child.WindowEvent(Msg,C,X - Child.WinLeft,Y - Child.WinTop,Key);
				return True;
			}
		}
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
	return False;
}

final function ActivateWindow (int depth, bool bTransientNoDeactivate)
{
	if ( self == Root )
	{
		if ( depth == 0 )
		{
			FocusWindow();
		}
		return;
	}
	if ( WaitModal() )
	{
		return;
	}
	if (  !bAlwaysBehind )
	{
		ParentWindow.HideChildWindow(self);
		ParentWindow.ShowChildWindow(self);
	}
	if (  !bTransient || bTransientNoDeactivate )
	{
		if ( (ParentWindow.ActiveWindow != None) && (ParentWindow.ActiveWindow != self) )
		{
			ParentWindow.ActiveWindow.Deactivated();
		}
		ParentWindow.ActiveWindow=self;
//		ParentWindow.Super(UWindowWindow).ActivateWindow(depth + 1,False);
		Activated();
	}
	else
	{
//		ParentWindow.Super(UWindowWindow).ActivateWindow(depth + 1,True);
	}
	if ( depth == 0 )
	{
		FocusWindow();
	}
}

final function BringToFront ()
{
	if ( self == Root )
	{
		return;
	}
	if (  !bAlwaysBehind &&  !WaitModal() )
	{
		ParentWindow.HideChildWindow(self);
		ParentWindow.ShowChildWindow(self);
	}
//	ParentWindow.Super(UWindowWindow).BringToFront();
}

final function SendToBack ()
{
	ParentWindow.HideChildWindow(self);
	ParentWindow.ShowChildWindow(self,True);
}

final function HideChildWindow (UWindowWindow Child)
{
	local UWindowWindow Window;

	if (  !Child.bWindowVisible )
	{
		return;
	}
	Child.bWindowVisible=False;
	if ( Child.bAcceptsHotKeys )
	{
		Root.RemoveHotkeyWindow(Child);
	}
	if ( LastChildWindow == Child )
	{
		LastChildWindow=Child.PrevSiblingWindow;
		if ( LastChildWindow != None )
		{
			LastChildWindow.NextSiblingWindow=None;
		}
		else
		{
			FirstChildWindow=None;
		}
	}
	else
	{
		if ( FirstChildWindow == Child )
		{
			FirstChildWindow=Child.NextSiblingWindow;
			if ( FirstChildWindow != None )
			{
				FirstChildWindow.PrevSiblingWindow=None;
			}
			else
			{
				LastChildWindow=None;
			}
		}
		else
		{
			Window=FirstChildWindow;
JL00EE:
			if ( Window != None )
			{
				if ( Window.NextSiblingWindow == Child )
				{
					Window.NextSiblingWindow=Child.NextSiblingWindow;
					Window.NextSiblingWindow.PrevSiblingWindow=Window;
				}
				else
				{
					Window=Window.NextSiblingWindow;
					goto JL00EE;
				}
			}
		}
	}
	ActiveWindow=None;
	Window=LastChildWindow;
JL0177:
	if ( Window != None )
	{
		if (  !Window.bAlwaysOnTop )
		{
			ActiveWindow=Window;
		}
		else
		{
			Window=Window.PrevSiblingWindow;
			goto JL0177;
		}
	}
	if ( ActiveWindow == None )
	{
		ActiveWindow=LastChildWindow;
	}
}

final function SetAcceptsFocus ()
{
	if (! bAcceptsFocus ) goto JL0009;
JL0009:
	bAcceptsFocus=True;
	if ( self != Root )
	{
//		ParentWindow.Super(UWindowWindow).SetAcceptsFocus();
	}
}

final function CancelAcceptsFocus ()
{
	if (  !bAcceptsFocus || bAlwaysAcceptsFocus )
	{
		return;
	}
	bAcceptsFocus=False;
	if ( self != Root )
	{
//		ParentWindow.Super(UWindowWindow).CancelAcceptsFocus();
	}
}

final function GetMouseXY (out float X, out float Y)
{
	local UWindowWindow P;

	X=Root.MouseX * Root.m_fWindowScaleX;
	Y=Root.MouseY * Root.m_fWindowScaleY;
	P=self;
JL0057:
	if ( P != Root )
	{
		X=X - P.WinLeft;
		Y=Y - P.WinTop;
		P=P.ParentWindow;
		goto JL0057;
	}
}

final function GlobalToWindow (float GlobalX, float GlobalY, out float WinX, out float WinY)
{
	local UWindowWindow P;

	WinX=GlobalX;
	WinY=GlobalY;
	P=self;
JL001D:
	if ( P != Root )
	{
		WinX -= P.WinLeft;
		WinY -= P.WinTop;
		P=P.ParentWindow;
		goto JL001D;
	}
}

final function WindowToGlobal (float WinX, float WinY, out float GlobalX, out float GlobalY)
{
	local UWindowWindow P;

	GlobalX=WinX;
	GlobalY=WinY;
	P=self;
JL001D:
	if ( P != Root )
	{
		GlobalX += P.WinLeft;
		GlobalY += P.WinTop;
		P=P.ParentWindow;
		goto JL001D;
	}
}

final function ShowChildWindow (UWindowWindow Child, optional bool bAtBack)
{
	local UWindowWindow W;

	if (  !Child.bTransient )
	{
		ActiveWindow=Child;
	}
	if ( Child.bWindowVisible )
	{
		return;
	}
	Child.bWindowVisible=True;
	if ( Child.bAcceptsHotKeys )
	{
		Root.AddHotkeyWindow(Child);
	}
	if ( bAtBack )
	{
		if ( FirstChildWindow == None )
		{
			Child.NextSiblingWindow=None;
			Child.PrevSiblingWindow=None;
			LastChildWindow=Child;
			FirstChildWindow=Child;
		}
		else
		{
			FirstChildWindow.PrevSiblingWindow=Child;
			Child.NextSiblingWindow=FirstChildWindow;
			Child.PrevSiblingWindow=None;
			FirstChildWindow=Child;
		}
	}
	else
	{
		W=LastChildWindow;
JL0108:
		if ( True )
		{
			if ( Child.bAlwaysOnTop || (W == None) ||  !W.bAlwaysOnTop )
			{
				if ( W == None )
				{
					if ( LastChildWindow == None )
					{
						Child.NextSiblingWindow=None;
						Child.PrevSiblingWindow=None;
						LastChildWindow=Child;
						FirstChildWindow=Child;
					}
					else
					{
						Child.NextSiblingWindow=FirstChildWindow;
						Child.PrevSiblingWindow=None;
						FirstChildWindow.PrevSiblingWindow=Child;
						FirstChildWindow=Child;
					}
				}
				else
				{
					Child.NextSiblingWindow=W.NextSiblingWindow;
					Child.PrevSiblingWindow=W;
					if ( W.NextSiblingWindow != None )
					{
						W.NextSiblingWindow.PrevSiblingWindow=Child;
					}
					else
					{
						LastChildWindow=Child;
					}
					W.NextSiblingWindow=Child;
				}
			}
			else
			{
				W=W.PrevSiblingWindow;
				goto JL0108;
			}
		}
	}
}

function ShowWindow ()
{
	ParentWindow.ShowChildWindow(self);
	WindowShown();
}

function HideWindow ()
{
	WindowHidden();
	ParentWindow.HideChildWindow(self);
}

final function UWindowWindow CreateWindow (Class<UWindowWindow> WndClass, float X, float Y, float W, float H, optional UWindowWindow OwnerW, optional bool bUnique, optional name ObjectName)
{
	local UWindowWindow Child;

	if ( bUnique )
	{
		Child=Root.FindChildWindow(WndClass,True);
		if ( Child != None )
		{
			Child.ShowWindow();
			Child.BringToFront();
			return Child;
		}
	}
	if ( ObjectName != 'None' )
	{
//		Child=new string(ObjectName) WndClass;
	}
	else
	{
		Child=new WndClass;
	}
	Child.BeginPlay();
	Child.WinTop=Y;
	Child.WinLeft=X;
	Child.WinWidth=W;
	Child.WinHeight=H;
	Child.Root=Root;
	Child.ParentWindow=self;
	Child.OwnerWindow=OwnerW;
	if ( Child.OwnerWindow == None )
	{
		Child.OwnerWindow=self;
	}
	Child.Cursor=Cursor;
	Child.bAlwaysBehind=False;
	Child.LookAndFeel=LookAndFeel;
	Child.Created();
	ShowChildWindow(Child);
	return Child;
}

final function DrawHorizTiledPieces (Canvas C, float DestX, float DestY, float DestW, float DestH, TexRegion T1, TexRegion T2, TexRegion T3, TexRegion T4, TexRegion T5, float Scale)
{
	local TexRegion Pieces[5];
	local TexRegion R;
	local int PieceCount;
	local int j;
	local float X;
	local float L;

	Pieces[0]=T1;
	if ( T1.t != None )
	{
		PieceCount=1;
	}
	Pieces[1]=T2;
	if ( T2.t != None )
	{
		PieceCount=2;
	}
	Pieces[2]=T3;
	if ( T3.t != None )
	{
		PieceCount=3;
	}
	Pieces[3]=T4;
	if ( T4.t != None )
	{
		PieceCount=4;
	}
	Pieces[4]=T5;
	if ( T5.t != None )
	{
		PieceCount=5;
	}
	j=0;
	X=DestX;
JL00CD:
	if ( X < DestX + DestW )
	{
		L=DestW - X - DestX;
		R=Pieces[j];
		DrawStretchedTextureSegment(C,X,DestY,FMin(R.W * Scale,L),R.H * Scale,R.X,R.Y,FMin(R.W,L / Scale),R.H,R.t);
		X += FMin(R.W * Scale,L);
		j=(j + 1) % PieceCount;
		goto JL00CD;
	}
}

final function DrawVertTiledPieces (Canvas C, float DestX, float DestY, float DestW, float DestH, TexRegion T1, TexRegion T2, TexRegion T3, TexRegion T4, TexRegion T5, float Scale)
{
	local TexRegion Pieces[5];
	local TexRegion R;
	local int PieceCount;
	local int j;
	local float Y;
	local float L;

	Pieces[0]=T1;
	if ( T1.t != None )
	{
		PieceCount=1;
	}
	Pieces[1]=T2;
	if ( T2.t != None )
	{
		PieceCount=2;
	}
	Pieces[2]=T3;
	if ( T3.t != None )
	{
		PieceCount=3;
	}
	Pieces[3]=T4;
	if ( T4.t != None )
	{
		PieceCount=4;
	}
	Pieces[4]=T5;
	if ( T5.t != None )
	{
		PieceCount=5;
	}
	j=0;
	Y=DestY;
JL00CD:
	if ( Y < DestY + DestH )
	{
		L=DestH - Y - DestY;
		R=Pieces[j];
		DrawStretchedTextureSegment(C,DestX,Y,R.W * Scale,FMin(R.H * Scale,L),R.X,R.Y,R.W,FMin(R.H,L / Scale),R.t);
		Y += FMin(R.H * Scale,L);
		j=(j + 1) % PieceCount;
		goto JL00CD;
	}
}

final function DrawClippedTexture (Canvas C, float X, float Y, Texture Tex)
{
	DrawStretchedTextureSegment(C,X,Y,Tex.USize,Tex.VSize,0.00,0.00,Tex.USize,Tex.VSize,Tex);
}

final function DrawStretchedTexture (Canvas C, float X, float Y, float W, float H, Texture Tex)
{
	DrawStretchedTextureSegment(C,X,Y,W,H,0.00,0.00,Tex.USize,Tex.VSize,Tex);
}

final function DrawStretchedTextureSegment (Canvas C, float X, float Y, float W, float H, float tX, float tY, float tW, float tH, Texture Tex)
{
	C.DrawStretchedTextureSegmentNative(X,Y,W,H,tX,tY,tW,tH,Root.GUIScale,ClippingRegion,Tex);
}

final function DrawStretchedTextureSegmentRot (Canvas C, float X, float Y, float W, float H, float tX, float tY, float tW, float tH, Texture Tex, float fTexRotation)
{
	local float OrgX;
	local float OrgY;
	local float ClipX;
	local float ClipY;

	OrgX=C.OrgX;
	OrgY=C.OrgY;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	C.SetOrigin(OrgX + ClippingRegion.X * Root.GUIScale,OrgY + ClippingRegion.Y * Root.GUIScale);
	C.SetClip(ClippingRegion.W * Root.GUIScale,ClippingRegion.H * Root.GUIScale);
	C.SetPos((X - ClippingRegion.X) * Root.GUIScale,(Y - ClippingRegion.Y) * Root.GUIScale);
	C.DrawTile(Tex,W * Root.GUIScale,H * Root.GUIScale,tX,tY,tW,tH,fTexRotation);
	C.SetClip(ClipX,ClipY);
	C.SetOrigin(OrgX,OrgY);
}

function DrawSimpleBorder (Canvas C)
{

	C.Style=m_BorderStyle;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,0.00,WinHeight - m_BorderTextureRegion.H,WinWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,0.00,m_BorderTextureRegion.H,m_BorderTextureRegion.W,WinHeight - 2 * m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,WinWidth - m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTextureRegion.W,WinHeight - 2 * m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

function DrawSimpleBackGround (Canvas C, float X, float Y, float W, float H, Color _BGColor, optional byte Alpha)
{
	local Texture BGTexture;
	local Region BGTextureRegion;
	local Color BGColor;

//	BGTexture=Texture'Gui_BoxScroll';
	BGTextureRegion.X=77;
	BGTextureRegion.Y=31;
	BGTextureRegion.W=8;
	BGTextureRegion.H=8;
	C.Style=5;
	C.SetDrawColor(_BGColor.R,_BGColor.G,_BGColor.B,Alpha);
	DrawStretchedTextureSegment(C,X,Y,W,H,BGTextureRegion.X,BGTextureRegion.Y,BGTextureRegion.W,BGTextureRegion.H,BGTexture);
}

final function ClipText (Canvas C, float X, float Y, coerce string S, optional bool bCheckHotKey)
{
	C.ClipTextNative(X,Y,S,Root.GUIScale,ClippingRegion,bCheckHotKey);
}

final function int WrapClipText (Canvas C, float X, float Y, coerce string S, optional bool bCheckHotKey, optional int Length, optional int PaddingLength, optional bool bNoDraw)
{
	local float W;
	local float H;
	local float Xdefault;
	local int SpacePos;
	local int CRPos;
	local int WordPos;
	local int TotalPos;
	local string Out;
	local string temp;
	local string Padding;
	local bool bCR;
	local bool bSentry;
	local int i;
	local int numLines;
	local float pW;
	local float pH;

	Xdefault=X;
	i=InStr(S,"\n");
JL001C:
	if ( i != -1 )
	{
		S=Left(S,i) $ Chr(13) $ Mid(S,i + 2);
		i=InStr(S,"\n");
		goto JL001C;
	}
	i=0;
	bSentry=True;
	Out="";
	numLines=1;
JL0087:
	if ( bSentry && (Y < WinHeight) )
	{
		if ( Out == "" )
		{
			i++;
			if ( Length > 0 )
			{
				Out=Left(S,Length);
			}
			else
			{
				Out=S;
			}
		}
		SpacePos=InStr(Out," ");
		CRPos=InStr(Out,Chr(13));
		bCR=False;
		if ( (CRPos != -1) && ((CRPos < SpacePos) || (SpacePos == -1)) )
		{
			WordPos=CRPos;
			bCR=True;
		}
		else
		{
			WordPos=SpacePos;
		}
		C.SetPos(0.00,0.00);
		if ( WordPos == -1 )
		{
			temp=Out;
		}
		else
		{
			temp=Left(Out,WordPos) $ " ";
		}
		TotalPos += WordPos;
		TextSize(C,temp,W,H);
		if ( (Mid(Out,Len(temp)) == "") && (PaddingLength > 0) )
		{
			Padding=Mid(S,Length,PaddingLength);
			TextSize(C,Padding,pW,pH);
			if ( (W + X + pW > WinWidth) && (X > 0) )
			{
				X=Xdefault;
				Y += H;
				numLines++;
			}
		}
		else
		{
			if ( (W + X > WinWidth) && (X > 0) )
			{
				X=Xdefault;
				Y += H;
				numLines++;
			}
		}
		if (  !bNoDraw )
		{
			ClipText(C,X,Y,temp,bCheckHotKey);
		}
		X += W;
		if ( bCR )
		{
			X=Xdefault;
			Y += H;
			numLines++;
		}
		Out=Mid(Out,Len(temp));
		if ( (Out == "") && (i > 0) )
		{
			bSentry=False;
		}
		goto JL0087;
	}
	return numLines;
}

final function ClipTextWidth (Canvas C, float X, float Y, coerce string S, float W)
{
	local float OrgX;
	local float OrgY;
	local float ClipX;
	local float ClipY;
	local float finalWidth;

	OrgX=C.OrgX;
	OrgY=C.OrgY;
	ClipX=C.ClipX;
	ClipY=C.ClipY;
	finalWidth=Min(W,WinWidth * Root.GUIScale);
	C.SetOrigin(OrgX + ClippingRegion.X * Root.GUIScale,OrgY + ClippingRegion.Y * Root.GUIScale);
	C.SetClip(finalWidth,ClippingRegion.H * Root.GUIScale);
	C.SetPos((X - ClippingRegion.X) * Root.GUIScale,(Y - ClippingRegion.Y) * Root.GUIScale);
	C.DrawTextClipped(S,False);
	C.SetClip(ClipX,ClipY);
	C.SetOrigin(OrgX,OrgY);
}

final function DrawUpBevel (Canvas C, float X, float Y, float W, float H, Texture t)
{
	local Region R;

	R=LookAndFeel.BevelUpTL;
	DrawStretchedTextureSegment(C,X,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpT;
	DrawStretchedTextureSegment(C,X + LookAndFeel.BevelUpTL.W,Y,W - LookAndFeel.BevelUpTL.W - LookAndFeel.BevelUpTR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpTR;
	DrawStretchedTextureSegment(C,X + W - R.W,Y,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpL;
	DrawStretchedTextureSegment(C,X,Y + LookAndFeel.BevelUpTL.H,R.W,H - LookAndFeel.BevelUpTL.H - LookAndFeel.BevelUpBL.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpR;
	DrawStretchedTextureSegment(C,X + W - R.W,Y + LookAndFeel.BevelUpTL.H,R.W,H - LookAndFeel.BevelUpTL.H - LookAndFeel.BevelUpBL.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpBL;
	DrawStretchedTextureSegment(C,X,Y + H - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpB;
	DrawStretchedTextureSegment(C,X + LookAndFeel.BevelUpBL.W,Y + H - R.H,W - LookAndFeel.BevelUpBL.W - LookAndFeel.BevelUpBR.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpBR;
	DrawStretchedTextureSegment(C,X + W - R.W,Y + H - R.H,R.W,R.H,R.X,R.Y,R.W,R.H,t);
	R=LookAndFeel.BevelUpArea;
	DrawStretchedTextureSegment(C,X + LookAndFeel.BevelUpTL.W,Y + LookAndFeel.BevelUpTL.H,W - LookAndFeel.BevelUpBL.W - LookAndFeel.BevelUpBR.W,H - LookAndFeel.BevelUpTL.H - LookAndFeel.BevelUpBL.H,R.X,R.Y,R.W,R.H,t);
}

final function DrawMiscBevel (Canvas C, float X, float Y, float W, float H, Texture t, int BevelType)
{
	local Region R;

	C.Style=5;
	C.SetDrawColor(31,34,39);
	R=LookAndFeel.MiscBevelArea[BevelType];
	DrawStretchedTextureSegment(C,X + LookAndFeel.MiscBevelTL[BevelType].W,Y + LookAndFeel.MiscBevelTL[BevelType].H,W - LookAndFeel.MiscBevelBL[BevelType].W - LookAndFeel.MiscBevelBR[BevelType].W,H - LookAndFeel.MiscBevelTL[BevelType].H - LookAndFeel.MiscBevelBL[BevelType].H,R.X,R.Y,R.W,R.H,t);
}

final function string RemoveAmpersand (string S)
{
	local string Result;
	local string Underline;

	ParseAmpersand(S,Result,Underline,False);
	return Result;
}

final function byte ParseAmpersand (string S, out string Result, out string Underline, bool bCalcUnderline)
{
	local string temp;
	local int pos;
	local int NewPos;
	local int i;
	local byte HotKey;

	HotKey=0;
	pos=0;
	Result="";
	Underline="";
JL001F:
	if ( True )
	{
		temp=Mid(S,pos);
		NewPos=InStr(temp,"&");
		if ( NewPos == -1 )
		{
			goto JL0154;
		}
		pos += NewPos;
		if ( Mid(temp,NewPos + 1,1) == "&" )
		{
			Result=Result $ Left(temp,NewPos) $ "&";
			if ( bCalcUnderline )
			{
				Underline=Underline $ " ";
			}
			pos++;
		}
		else
		{
			if ( HotKey == 0 )
			{
				HotKey=Asc(Caps(Mid(temp,NewPos + 1,1)));
			}
			Result=Result $ Left(temp,NewPos);
			if ( bCalcUnderline )
			{
				i=0;
JL010E:
				if ( i < NewPos - 1 )
				{
					Underline=Underline $ " ";
					i++;
					goto JL010E;
				}
				Underline=Underline $ "_";
			}
		}
		pos++;
		goto JL001F;
	}
JL0154:
	Result=Result $ temp;
	return HotKey;
}

final function bool MouseIsOver ()
{
	return Root.MouseWindow == self;
}

function ToolTip (string strTip)
{
	if ( ParentWindow != Root )
	{
		ParentWindow.ToolTip(strTip);
	}
}

final function SetMouseWindow ()
{
	Root.MouseWindow=self;
}

function Texture GetLookAndFeelTexture ()
{
	return ParentWindow.GetLookAndFeelTexture();
}

function bool IsActive ()
{
	return ParentWindow.IsActive();
}

function SetAcceptsHotKeys (bool bNewAccpetsHotKeys)
{
	if ( bNewAccpetsHotKeys &&  !bAcceptsHotKeys && bWindowVisible )
	{
		Root.AddHotkeyWindow(self);
	}
	if (  !bNewAccpetsHotKeys && bAcceptsHotKeys && bWindowVisible )
	{
		Root.RemoveHotkeyWindow(self);
	}
	bAcceptsHotKeys=bNewAccpetsHotKeys;
}

final function UWindowWindow GetParent (Class<UWindowWindow> ParentClass, optional bool bExactClass)
{
	local UWindowWindow P;

	P=ParentWindow;
JL000B:
	if ( P != Root )
	{
		if ( bExactClass )
		{
			if ( P.Class == ParentClass )
			{
				return P;
			}
		}
		else
		{
			if ( ClassIsChildOf(P.Class,ParentClass) )
			{
				return P;
			}
		}
		P=P.ParentWindow;
		goto JL000B;
	}
	return None;
}

final function UWindowWindow FindChildWindow (Class<UWindowWindow> ChildClass, optional bool bExactClass)
{
	local UWindowWindow Child;
	local UWindowWindow Found;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		if ( bExactClass )
		{
			if ( Child.Class == ChildClass )
			{
				return Child;
			}
		}
		else
		{
			if ( ClassIsChildOf(Child.Class,ChildClass) )
			{
				return Child;
			}
		}
//		Found=Child.Super(UWindowWindow).FindChildWindow(ChildClass);
		if ( Found != None )
		{
			return Found;
		}
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
	return None;
}

function GetDesiredDimensions (out float W, out float H)
{
	local float MaxW;
	local float MaxH;
	local float tW;
	local float tH;
	local UWindowWindow Child;
	local UWindowWindow Found;

	MaxW=0.00;
	MaxH=0.00;
	Child=LastChildWindow;
JL0021:
	if ( Child != None )
	{
		Child.GetDesiredDimensions(tW,tH);
		if ( tW > MaxW )
		{
			MaxW=tW;
		}
		if ( tH > MaxH )
		{
			MaxH=tH;
		}
		Child=Child.PrevSiblingWindow;
		goto JL0021;
	}
	W=MaxW;
	H=MaxH;
}

final function string TextSize (Canvas C, string Text, out float W, out float H, optional int _TotalWidth, optional int _SpaceWidth)
{
	local string szResult;

	C.SetPos(0.00,0.00);
//	szResult=C.Super.TextSize(Text,W,H,_TotalWidth,_SpaceWidth);
	W=W / Root.GUIScale;
	H=H / Root.GUIScale;
	return szResult;
}

function ResolutionChanged (float W, float H)
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.ResolutionChanged(W,H);
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function ShowModal (UWindowWindow W)
{
	ModalWindow=W;
	W.ShowWindow();
	W.BringToFront();
}

function bool WaitModal ()
{
	if ( (ModalWindow != None) && ModalWindow.bWindowVisible )
	{
		return True;
	}
	ModalWindow=None;
	return False;
}

function WindowHidden ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.WindowHidden();
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function WindowShown ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.WindowShown();
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function bool CheckMousePassThrough (float X, float Y)
{
	return False;
}

final function bool WindowIsVisible ()
{
	if ( self == Root )
	{
		return True;
	}
	if (  !bWindowVisible )
	{
		return False;
	}
//	return ParentWindow.Super(UWindowWindow).WindowIsVisible();
	return true;
}

function SetParent (UWindowWindow NewParent)
{
	HideWindow();
	ParentWindow=NewParent;
	ShowWindow();
}

function UWindowMessageBox MessageBox (string Title, string Message, MessageBoxButtons Buttons, MessageBoxResult ESCResult, optional MessageBoxResult EnterResult, optional int TimeOut)
{
	local UWindowMessageBox W;
	local UWindowFramedWindow f;

	W=UWindowMessageBox(Root.CreateWindow(Class'UWindowMessageBox',100.00,100.00,100.00,100.00,self));
	W.SetupMessageBox(Title,Message,Buttons,ESCResult,EnterResult,TimeOut);
	f=UWindowFramedWindow(GetParent(Class'UWindowFramedWindow'));
	if ( f != None )
	{
		f.ShowModal(W);
	}
	else
	{
		Root.ShowModal(W);
	}
	return W;
}

function MessageBoxDone (UWindowMessageBox W, MessageBoxResult Result)
{
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
}

function SendMessage (eR6MenuWidgetMessage eMessage)
{
}

function NotifyQuitUnreal ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.NotifyQuitUnreal();
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function NotifyBeforeLevelChange ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.NotifyBeforeLevelChange();
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function NotifyAfterLevelChange ()
{
	local UWindowWindow Child;

	Child=LastChildWindow;
JL000B:
	if ( Child != None )
	{
		Child.NotifyAfterLevelChange();
		Child=Child.PrevSiblingWindow;
		goto JL000B;
	}
}

function NotifyWindow (UWindowWindow C, byte E)
{
}

function SetCursor (MouseCursor C)
{
	local UWindowWindow Child;

	Cursor=C;
	Child=LastChildWindow;
JL0016:
	if ( Child != None )
	{
		Child.SetCursor(C);
		Child=Child.PrevSiblingWindow;
		goto JL0016;
	}
}

final function ReplaceText (out string Text, string Replace, string With)
{
	local int i;
	local string Input;

	Input=Text;
	Text="";
	i=InStr(Input,Replace);
JL0025:
	if ( i != -1 )
	{
		Text=Text $ Left(Input,i) $ With;
		Input=Mid(Input,i + Len(Replace));
		i=InStr(Input,Replace);
		goto JL0025;
	}
	Text=Text $ Input;
}

function StripCRLF (out string Text)
{
	ReplaceText(Text,Chr(13) $ Chr(10),"");
	ReplaceText(Text,Chr(13),"");
	ReplaceText(Text,Chr(10),"");
}

function SetServerOptions ()
{
}

function MenuLoadProfile (bool _bServerProfile)
{
}

function SetBorderColor (Color _NewColor)
{
}

defaultproperties
{
    m_BorderStyle=1
//    m_BorderTexture=Texture'WhiteTexture'
    m_BorderTextureRegion=(X=74244,Y=570490880,W=1,H=0)
    m_BorderColor=(R=255,G=255,B=255,A=0)
}
