//================================================================================
// UWindowMenuBar.
//================================================================================
class UWindowMenuBar extends UWindowListControl;

var int Spacing;
var bool bAltDown;
var UWindowMenuBarItem Selected;
var UWindowMenuBarItem Over;

function Created ()
{
	ListClass=Class'UWindowMenuBarItem';
	SetAcceptsHotKeys(True);
	Super.Created();
	Spacing=10;
}

function UWindowMenuBarItem AddHelpItem (string Caption)
{
	local UWindowMenuBarItem i;

	i=AddItem(Caption);
	i.SetHelp(True);
	return i;
}

function UWindowMenuBarItem AddItem (string Caption)
{
	local UWindowMenuBarItem i;

	i=UWindowMenuBarItem(Items.Append(Class'UWindowMenuBarItem'));
	i.Owner=self;
	i.SetCaption(Caption);
	return i;
}

function ResolutionChanged (float W, float H)
{
	local UWindowMenuBarItem i;

	i=UWindowMenuBarItem(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( i.Menu != None )
		{
			i.Menu.ResolutionChanged(W,H);
		}
		i=UWindowMenuBarItem(i.Next);
		goto JL0019;
	}
	Super.ResolutionChanged(W,H);
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	local float X;
	local float W;
	local float H;
	local UWindowMenuBarItem i;

	DrawMenuBar(C);
	i=UWindowMenuBarItem(Items.Next);
JL0024:
	if ( i != None )
	{
		C.Font=Root.Fonts[0];
		TextSize(C,RemoveAmpersand(i.Caption),W,H);
		if ( i.bHelp )
		{
			DrawItem(C,i,WinWidth - W + Spacing,1.00,W + Spacing,14.00);
		}
		else
		{
			DrawItem(C,i,X,1.00,W + Spacing,14.00);
			X=X + W + Spacing;
		}
		i=UWindowMenuBarItem(i.Next);
		goto JL0024;
	}
}

function MouseMove (float X, float Y)
{
	local UWindowMenuBarItem i;

	Super.MouseMove(X,Y);
	Over=None;
	i=UWindowMenuBarItem(Items.Next);
JL0030:
	if ( i != None )
	{
		if ( (X >= i.ItemLeft) && (X <= i.ItemLeft + i.ItemWidth) )
		{
			if ( Selected != None )
			{
				if ( Selected != i )
				{
					Selected.DeSelect();
					Selected=i;
					Selected.Select();
					Select(Selected);
				}
			}
			else
			{
				Over=i;
			}
		}
		i=UWindowMenuBarItem(i.Next);
		goto JL0030;
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	Over=None;
}

function Select (UWindowMenuBarItem i)
{
}

function LMouseDown (float X, float Y)
{
	local UWindowMenuBarItem i;

	i=UWindowMenuBarItem(Items.Next);
JL0019:
	if ( i != None )
	{
		if ( (X >= i.ItemLeft) && (X <= i.ItemLeft + i.ItemWidth) )
		{
			if ( Selected != None )
			{
				Selected.DeSelect();
			}
			if ( Selected == i )
			{
				Selected=None;
				Over=i;
			}
			else
			{
				Selected=i;
				Selected.Select();
			}
			Select(Selected);
			return;
		}
		i=UWindowMenuBarItem(i.Next);
		goto JL0019;
	}
	if ( Selected != None )
	{
		Selected.DeSelect();
	}
	Selected=None;
	Select(Selected);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local string Text;
	local string Underline;
	local UWindowMenuBarItem pMenuBarItem;

	pMenuBarItem=UWindowMenuBarItem(Item);
	C.SetDrawColor(255,255,255);
	pMenuBarItem.ItemLeft=X;
	pMenuBarItem.ItemWidth=W;
	LookAndFeel.Menu_DrawMenuBarItem(self,pMenuBarItem,X,Y,W,H,C);
}

function DrawMenuBar (Canvas C)
{
//	DrawStretchedTexture(C,0.00,0.00,WinWidth,16.00,Texture'MenuBar');
}

function CloseUp ()
{
	if ( Selected != None )
	{
		Selected.DeSelect();
		Selected=None;
	}
}

function Close (optional bool bByParent)
{
	Root.Console.CloseUWindow();
}

function UWindowMenuBar GetMenuBar ()
{
	return self;
}

function bool HotKeyDown (int Key, float X, float Y)
{
	local UWindowMenuBarItem i;

	if ( Key == 18 )
	{
		bAltDown=True;
	}
	if ( bAltDown )
	{
		i=UWindowMenuBarItem(Items.Next);
JL0036:
		if ( i != None )
		{
			if ( Key == i.HotKey )
			{
				if ( Selected != None )
				{
					Selected.DeSelect();
				}
				Selected=i;
				Selected.Select();
				Select(Selected);
				bAltDown=False;
				return True;
			}
			i=UWindowMenuBarItem(i.Next);
			goto JL0036;
		}
	}
	return False;
}

function bool HotKeyUp (int Key, float X, float Y)
{
	if ( Key == 18 )
	{
		bAltDown=False;
	}
	return False;
}

function KeyDown (int Key, float X, float Y)
{
	local UWindowMenuBarItem i;

	switch (Key)
	{
		case 37:
		i=UWindowMenuBarItem(Selected.Prev);
		if ( (i == None) || (i == Items) )
		{
			i=UWindowMenuBarItem(Items.Last);
		}
		if ( Selected != None )
		{
			Selected.DeSelect();
		}
		Selected=i;
		Selected.Select();
		Select(Selected);
		break;
		case 39:
		i=UWindowMenuBarItem(Selected.Next);
		if ( i == None )
		{
			i=UWindowMenuBarItem(Items.Next);
		}
		if ( Selected != None )
		{
			Selected.DeSelect();
		}
		Selected=i;
		Selected.Select();
		Select(Selected);
		break;
		default:
	}
}

function MenuCmd (int Menu, int Item)
{
	local UWindowMenuBarItem i;
	local int j;

	j=0;
	i=UWindowMenuBarItem(Items.Next);
JL0020:
	if ( i != None )
	{
		if ( (j == Menu) && (i.Menu != None) )
		{
			if ( Selected != None )
			{
				Selected.DeSelect();
			}
			Selected=i;
			Selected.Select();
			Select(Selected);
			i.Menu.MenuCmd(Item);
			return;
		}
		j++;
		i=UWindowMenuBarItem(i.Next);
		goto JL0020;
	}
}
