//================================================================================
// UWindowDialogControl.
//================================================================================
class UWindowDialogControl extends UWindowWindow;

var TextAlign Align;
var int Font;
var bool bHasKeyboardFocus;
var bool bNoKeyboard;
var bool bAcceptExternalDragDrop;
var float TextX;
var float TextY;
var float MinWidth;
var float MinHeight;
var UWindowDialogClientWindow NotifyWindow;
var UWindowDialogControl TabNext;
var UWindowDialogControl TabPrev;
var Color TextColor;
var string Text;
var string HelpText;

function Created ()
{
	if (  !bNoKeyboard )
	{
		SetAcceptsFocus();
	}
}

function KeyFocusEnter ()
{
	bHasKeyboardFocus=True;
}

function KeyFocusExit ()
{
	bHasKeyboardFocus=False;
}

function SetHelpText (string NewHelpText)
{
	HelpText=NewHelpText;
}

function SetText (string NewText)
{
	Text=NewText;
}

function BeforePaint (Canvas C, float X, float Y)
{
	C.Font=Root.Fonts[Font];
	if ( C.Font == None )
	{
		C.Font=Root.Fonts[5];
	}
}

function SetFont (int NewFont)
{
	Font=NewFont;
}

function SetTextColor (Color NewColor)
{
	TextColor=NewColor;
}

function Register (UWindowDialogClientWindow W)
{
	NotifyWindow=W;
	Notify(0);
}

function Notify (byte E)
{
	if ( NotifyWindow != None )
	{
		NotifyWindow.Notify(self,E);
	}
}

function bool ExternalDragOver (UWindowDialogControl ExternalControl, float X, float Y)
{
	return False;
}

function UWindowDialogControl CheckExternalDrag (float X, float Y)
{
	local float RootX;
	local float RootY;
	local float ExtX;
	local float ExtY;
	local UWindowWindow W;
	local UWindowDialogControl C;

	WindowToGlobal(X,Y,RootX,RootY);
	W=Root.FindWindowUnder(RootX,RootY);
	C=UWindowDialogControl(W);
	if ( (W != self) && (C != None) && C.bAcceptExternalDragDrop )
	{
		W.GlobalToWindow(RootX,RootY,ExtX,ExtY);
		if ( C.ExternalDragOver(self,ExtX,ExtY) )
		{
			return C;
		}
	}
	return None;
}

function KeyDown (int Key, float X, float Y)
{
	local PlayerController P;
	local UWindowDialogControl N;

	P=Root.GetPlayerOwner();
	switch (Key)
	{
/*		case P.Player.Console.9:
		if ( TabNext != None )
		{
			N=TabNext;
			while ( (N != self) &&  !N.bWindowVisible )
			{
				N=N.TabNext;
			}
			N.ActivateWindow(0,False);
		}
		break;
		default:
		Super.K*/
	}
}

function MouseMove (float X, float Y)
{
	Super.MouseMove(X,Y);
	Notify(8);
}

function MouseEnter ()
{
	Super.MouseEnter();
	Notify(12);
}

function MouseLeave ()
{
	Super.MouseLeave();
	Notify(9);
}

defaultproperties
{
    bNoKeyboard=True
}