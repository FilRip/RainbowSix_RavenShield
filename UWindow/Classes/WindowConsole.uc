//================================================================================
// WindowConsole.
//================================================================================
class WindowConsole extends Console;

var int Scrollback;
var int numLines;
var int TopLine;
var int TextLines;
var int ConsoleLines;
var bool bNoStuff;
var bool bTyping;
var bool bShowLog;
var bool bCreatedRoot;
var config bool bShowConsole;
var bool bBlackout;
var bool bUWindowType;
var bool bUWindowActive;
var bool bLocked;
var bool bLevelChange;
var float MsgTime;
var float MsgTickTime;
var float MsgTick[64];
var float OldClipX;
var float OldClipY;
var float MouseX;
var float MouseY;
var config float MouseScale;
var Viewport Viewport;
var UWindowRootWindow Root;
var name ConsoleState;
var Class<UWindowConsoleWindow> ConsoleClass;
var string MsgText[64];
var() config string RootWindow;
var string OldLevel;
var string szStoreIP;
const TextMsgSize=128;
const MaxLines=64;

function GetRestKitDescName (GameReplicationInfo _GRI, R6ServerInfo pServerOptions);

function ResetUWindow ()
{
	if ( bShowLog )
	{
		Log("WindowConsole::ResetUWindow");
	}
	if ( Root != None )
	{
		Root.Close();
	}
	Root=None;
	bCreatedRoot=False;
	bShowConsole=False;
	CloseUWindow();
}

function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
{
	local byte k;

	k=Key;
	if ( bShowLog )
	{
		Log("WindowConsole state " @ string(Action) @ "Key" @ string(Key));
	}
	switch (Action)
	{
/*		case 1:
		if ( k == ViewportOwner.Actor.GetKey("Console") )
		{
			if ( bLocked )
			{
				return True;
			}
			LaunchUWindow();
			if (  !bShowConsole )
			{
				ShowConsole();
			}
			return True;
		}
		switch (k)
		{
			case 27:
			if ( bLocked )
			{
				return True;
			}
			LaunchUWindow();
			return True;
			default:
		}
		break;
		default:*/
	}
	return False;
}

function ShowConsole ()
{
	bShowConsole=True;
}

function HideConsole ()
{
	ConsoleLines=0;
	bShowConsole=False;
}

state UWindowCanPlay
{
	function BeginState ()
	{
		if ( bShowLog )
		{
			Log("UWindowCanPlay::BeginState");
		}
		ConsoleState=GetStateName();
	}

	event Tick (float Delta)
	{
		Global.Tick(Delta);
		if ( Root != None )
		{
			Root.DoTick(Delta);
		}
	}

	function PostRender (Canvas Canvas)
	{
		if ( bShowLog )
		{
			Log("UWindowCanPlay::PostRender");
		}
		if ( Root != None )
		{
			Root.bUWindowActive=True;
		}
		RenderUWindow(Canvas);
	}

	function bool KeyType (EInputKey Key)
	{
		if ( bShowLog )
		{
			Log("WindowConsole state UWindowCanPlay KeyType Key" @ string(Key));
		}
		if ( Root != None )
		{
			Root.WindowEvent(WM_KeyType,None,MouseX,MouseY,Key);
		}
		return True;
	}

	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		local byte k;

		k=Key;
		if ( bShowLog )
		{
			Log("WindowConsole state UWindowCanPlay KeyEvent eAction" @ string(Action) @ "Key" @ string(Key));
		}
		switch (Action)
		{
/*			case 3:
			if ( Root != None )
			{
				Root.WindowEvent(WM_KeyUp,None,MouseX,MouseY,k);
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
			switch (k)
			{
				case 120:
				return Global.KeyEvent(Key,Action,Delta);
				break;
				default:
				if ( Root != None )
				{
					Root.WindowEvent(WM_KeyDown,None,MouseX,MouseY,k);
				}
				break;
			}
			break;
			default:
			break;*/
		}
		if ( (k >= 48) && (k <= 57) )
		{
			return True;
		}
		else
		{
			return False;
		}
	}

}

state UWindow
{
	event Tick (float Delta)
	{
		Global.Tick(Delta);
		if ( Root != None )
		{
			Root.DoTick(Delta);
		}
	}

	function PostRender (Canvas Canvas)
	{
		if ( bShowLog )
		{
			Log("Window Console state UWindow::PostRender");
		}
		if ( Root != None )
		{
			Root.bUWindowActive=True;
		}
		RenderUWindow(Canvas);
	}

	function bool KeyType (EInputKey Key)
	{
		if ( bShowLog )
		{
			Log("WindowConsole state UWindow KeyType Key" @ string(Key));
		}
		if ( Root != None )
		{
			Root.WindowEvent(WM_KeyType,None,MouseX,MouseY,Key);
		}
		return True;
	}

	function bool KeyEvent (EInputKey Key, EInputAction Action, float Delta)
	{
		local byte k;

		k=Key;
		if ( bShowLog )
		{
			Log("WindowConsole state UWindow KeyEvent eAction" @ string(Action) @ "Key" @ string(Key));
		}
		switch (Action)
		{
/*			case 3:
			switch (k)
			{
				case 1:
				if ( Root != None )
				{
					Root.WindowEvent(WM_LMouseUp,None,MouseX,MouseY,k);
				}
				break;
				case 2:
				if ( Root != None )
				{
					Root.WindowEvent(WM_RMouseUp,None,MouseX,MouseY,k);
				}
				break;
				case 4:
				if ( Root != None )
				{
					Root.WindowEvent(WM_MMouseUp,None,MouseX,MouseY,k);
				}
				break;
				default:
				if ( Root != None )
				{
					Root.WindowEvent(WM_KeyUp,None,MouseX,MouseY,k);
				}
				break;
			}
			break;
			case 1:
			if ( k == ViewportOwner.Actor.GetKey("Console") )
			{
				if ( bShowConsole )
				{
					HideConsole();
				}
				else
				{
					if ( Root.bAllowConsole )
					{
						ShowConsole();
					}
					else
					{
						Root.WindowEvent(WM_KeyDown,None,MouseX,MouseY,k);
					}
				}
			}
			else
			{
				switch (k)
				{
					case 120:
					return Global.KeyEvent(Key,Action,Delta);
					break;
					case 27:
					if ( Root != None )
					{
						Root.CloseActiveWindow();
					}
					break;
					case 1:
					if ( Root != None )
					{
						Root.WindowEvent(WM_LMouseDown,None,MouseX,MouseY,k);
					}
					break;
					case 2:
					if ( Root != None )
					{
						Root.WindowEvent(WM_RMouseDown,None,MouseX,MouseY,k);
					}
					break;
					case 4:
					if ( Root != None )
					{
						Root.WindowEvent(WM_MMouseDown,None,MouseX,MouseY,k);
					}
					break;
					default:
					if ( Root != None )
					{
						Root.WindowEvent(WM_KeyDown,None,MouseX,MouseY,k);
					}
					break;
				}
				goto JL0344;
				case 4:
				switch (Key)
				{
					case 228:
					MouseX=MouseX + MouseScale * Delta;
					break;
					case 229:
					MouseY=MouseY - MouseScale * Delta;
					break;
					default:
				}
				default:
				goto JL0344;
			}*/
		}
	JL0344:
		return True;
	}

Begin:
}

function ToggleUWindow ()
{
}

function LaunchUWindow ()
{
	if ( bShowLog )
	{
		Log("WindowConsole::LaunchUWindow");
	}
	ViewportOwner.bSuspendPrecaching=True;
	bUWindowActive=True;
	ViewportOwner.bShowWindowsMouse=True;
	if ( Root != None )
	{
		Root.bWindowVisible=True;
	}
	GotoState('UWindow');
}

function CloseUWindow ()
{
	if ( bShowLog )
	{
		Log("WindowConsole::CloseUWindow");
	}
	bUWindowActive=False;
	ViewportOwner.bShowWindowsMouse=False;
	if ( Root != None )
	{
		Root.bWindowVisible=False;
	}
	GotoState('Game');
	ViewportOwner.bSuspendPrecaching=False;
}

function CreateRootWindow (Canvas Canvas)
{
	local int i;

	if ( bShowLog )
	{
		Log("WindowConsole::CreateRootWindow");
	}
	if ( Canvas != None )
	{
		OldClipX=Canvas.ClipX;
		OldClipY=Canvas.ClipY;
	}
	else
	{
		OldClipX=0.00;
		OldClipY=0.00;
	}
	Root=new Class<UWindowRootWindow> (DynamicLoadObject(RootWindow,Class'Class'));
	Root.BeginPlay();
	Root.WinTop=0.00;
	Root.WinLeft=0.00;
	if ( Canvas != None )
	{
		Root.WinWidth=Canvas.ClipX / Root.GUIScale;
		Root.WinHeight=Canvas.ClipY / Root.GUIScale;
		Root.RealWidth=Canvas.ClipX;
		Root.RealHeight=Canvas.ClipY;
	}
	else
	{
		Root.WinWidth=0.00;
		Root.WinHeight=0.00;
		Root.RealWidth=0.00;
		Root.RealHeight=0.00;
	}
	Root.ClippingRegion.X=0;
	Root.ClippingRegion.Y=0;
	Root.ClippingRegion.W=Root.WinWidth;
	Root.ClippingRegion.H=Root.WinHeight;
	Root.Console=self;
	Root.bUWindowActive=bUWindowActive;
	if ( bShowLog )
	{
		Log("CreateRootWindow Setting Root.bUWindowActive=" @ string(Root.bUWindowActive));
	}
	Root.Created();
	bCreatedRoot=True;
	if (  !bShowConsole )
	{
		HideConsole();
	}
}

function RenderUWindow (Canvas Canvas)
{
	local UWindowWindow NewFocusWindow;
	local R6GameOptions pGameOptions;

	if ( bShowLog )
	{
		Log("WindowConsole::RenderUWindow state" @ string(GetStateName()));
	}
	pGameOptions=Class'Actor'.static.GetGameOptions();
	Canvas.bNoSmooth=False;
	Canvas.Z=1.00;
	Canvas.Style=1;
	Canvas.SetDrawColor(255,255,255);
//	MouseScale=Clamp(pGameOptions.MouseSensitivity,10,100) / 32.00;
	if ( ViewportOwner.bWindowsMouseAvailable && (Root != None) )
	{
		MouseX=ViewportOwner.WindowsMouseX / Root.GUIScale;
		MouseY=ViewportOwner.WindowsMouseY / Root.GUIScale;
	}
	if (  !bCreatedRoot )
	{
		CreateRootWindow(Canvas);
	}
	Root.bWindowVisible=True;
	Root.bUWindowActive=bUWindowActive;
	if ( bShowLog )
	{
		Log("RenderUWindow Setting" @ string(Root) @ ".bUWindowActive=" @ string(Root.bUWindowActive));
	}
	if ( (Canvas.ClipX != Canvas.SizeX) || (Canvas.ClipY != Canvas.SizeY) )
	{
		Canvas.ClipX=Canvas.SizeX;
		Canvas.ClipY=Canvas.SizeY;
	}
	if ( (Canvas.ClipX != OldClipX) || (Canvas.ClipY != OldClipY) )
	{
		OldClipX=Canvas.ClipX;
		OldClipY=Canvas.ClipY;
		Root.WinTop=0.00;
		Root.WinLeft=0.00;
		Root.WinWidth=Canvas.ClipX / Root.GUIScale;
		Root.WinHeight=Canvas.ClipY / Root.GUIScale;
		Root.RealWidth=Canvas.ClipX;
		Root.RealHeight=Canvas.ClipY;
		Root.ClippingRegion.X=0;
		Root.ClippingRegion.Y=0;
		Root.ClippingRegion.W=Root.WinWidth;
		Root.ClippingRegion.H=Root.WinHeight;
		Root.Resized();
	}
	if ( MouseX > Canvas.SizeX )
	{
		MouseX=Canvas.SizeX;
	}
	if ( MouseY > Canvas.SizeY )
	{
		MouseY=Canvas.SizeY;
	}
	if ( MouseX < 0 )
	{
		MouseX=0.00;
	}
	if ( MouseY < 0 )
	{
		MouseY=0.00;
	}
	NewFocusWindow=Root.CheckKeyFocusWindow();
	if ( NewFocusWindow != Root.KeyFocusWindow )
	{
		Root.KeyFocusWindow.KeyFocusExit();
		Root.KeyFocusWindow=NewFocusWindow;
		Root.KeyFocusWindow.KeyFocusEnter();
	}
	if ( bShowLog )
	{
		Log("WindowConsole::RenderUWindow root" @ string(Root));
	}
	Root.ApplyResolutionOnWindowsPos(MouseX,MouseY);
	Root.MoveMouse(MouseX,MouseY);
	Root.WindowEvent(WM_Paint,Canvas,MouseX,MouseY,0);
	if ( bUWindowActive && ViewportOwner.bShowWindowsMouse )
	{
		Root.DrawMouse(Canvas);
	}
}

event Message (coerce string Msg, float MsgLife)
{
	Super.Message(Msg,MsgLife);
	if ( ViewportOwner.Actor == None )
	{
		return;
	}
}

function UpdateHistory ()
{
//	History[HistoryCur++  % 16]=TypedStr;
	if ( HistoryCur > HistoryBot )
	{
		HistoryBot++;
	}
	if ( HistoryCur - HistoryTop >= 16 )
	{
		HistoryTop=HistoryCur - 16 + 1;
	}
}

function HistoryUp ()
{
	if ( HistoryCur > HistoryTop )
	{
//		History[HistoryCur % 16]=TypedStr;
//		TypedStr=History[ --HistoryCur % 16];
	}
}

function HistoryDown ()
{
//	History[HistoryCur % 16]=TypedStr;
	if ( HistoryCur < HistoryBot )
	{
//		TypedStr=History[ ++HistoryCur % 16];
	}
	else
	{
		TypedStr="";
	}
}

function NotifyLevelChange ()
{
	if ( bShowLog )
	{
		Log("WindowConsole NotifyLevelChange");
	}
	if ( GetStateName() == 'Typing' )
	{
		if ( TypedStr != "" )
		{
			TypedStr="";
			HistoryCur=HistoryTop;
		}
		GotoState(ConsoleState);
	}
	bLevelChange=True;
	if ( Root != None )
	{
		Root.NotifyBeforeLevelChange();
	}
}

function NotifyAfterLevelChange ()
{
	if ( bShowLog )
	{
		Log("WindowConsole NotifyAfterLevelChange");
	}
	if ( bLevelChange && (Root != None) )
	{
		bLevelChange=False;
		Root.NotifyAfterLevelChange();
	}
}

function MenuLoadProfile (bool _bServerProfile)
{
	Root.MenuLoadProfile(_bServerProfile);
}

defaultproperties
{
    MouseScale=0.60
    RootWindow="UWindow.UWindowRootWindow"
}
