//================================================================================
// UWindowComboList.
//================================================================================
class UWindowComboList extends UWindowListControl;

var int ItemHeight;
var int VBorder;
var int HBorder;
var int TextBorder;
var int MaxVisible;
var UWindowComboControl Owner;
var UWindowVScrollbar VertSB;
var UWindowComboListItem Selected;

function Sort ()
{
	Items.Sort();
}

function WindowShown ()
{
	Super.WindowShown();
	FocusWindow();
}

function Clear ()
{
	Items.Clear();
}

function Texture GetLookAndFeelTexture ()
{
	return LookAndFeel.Active;
}

function Setup ()
{
	VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
}

function Created ()
{
	ListClass=Class'UWindowComboListItem';
	bAlwaysOnTop=True;
	bTransient=True;
	Super.Created();
	ItemHeight=15;
	VBorder=3;
	HBorder=3;
	TextBorder=9;
	Super.Created();
}

function int FindItemIndex (string Value, optional bool bIgnoreCase)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( bIgnoreCase && (i.Value ~= Value) )
		{
			return Count;
		}
		if ( i.Value == Value )
		{
			return Count;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return -1;
}

function int FindItemIndex2 (string Value2, optional bool bIgnoreCase)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( bIgnoreCase && (i.Value2 ~= Value2) )
		{
			return Count;
		}
		if ( i.Value2 == Value2 )
		{
			return Count;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return -1;
}

function string GetItemValue (int Index)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( Count == Index )
		{
			return i.Value;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return "";
}

function RemoveItem (int Index)
{
	local UWindowComboListItem i;
	local int Count;

	if ( Index == -1 )
	{
		return;
	}
	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0031:
	if ( i != None )
	{
		if ( Count == Index )
		{
			i.Remove();
			return;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0031;
	}
}

function string GetItemValue2 (int Index)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( Count == Index )
		{
			return i.Value2;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return "";
}

function AddItem (string Value, optional string Value2, optional int SortWeight)
{
	local UWindowComboListItem i;

	i=UWindowComboListItem(Items.Append(Class'UWindowComboListItem'));
	i.Value=Value;
	i.Value2=Value2;
	i.SortWeight=SortWeight;
}

function InsertItem (string Value, optional string Value2, optional int SortWeight)
{
	local UWindowComboListItem i;

	i=UWindowComboListItem(Items.Insert(Class'UWindowComboListItem'));
	i.Value=Value;
	i.Value2=Value2;
	i.SortWeight=SortWeight;
}

function SetSelected (float X, float Y)
{
	local UWindowComboListItem NewSelected;
	local UWindowComboListItem Item;
	local int i;
	local int Count;

	Count=0;
	Item=UWindowComboListItem(Items.Next);
JL0020:
	if ( Item != None )
	{
		Count++;
		Item=UWindowComboListItem(Item.Next);
		goto JL0020;
	}
	i=Y - VBorder / ItemHeight + VertSB.pos;
	if ( i < 0 )
	{
		i=0;
	}
	if ( i >= VertSB.pos + Min(Count,MaxVisible) )
	{
		i=VertSB.pos + Min(Count,MaxVisible) - 1;
	}
	NewSelected=UWindowComboListItem(Items.FindEntry(i));
	if ( NewSelected != Selected )
	{
		if ( NewSelected == None )
		{
			Selected=None;
		}
		else
		{
			if (  !NewSelected.bDisabled )
			{
				Selected=NewSelected;
			}
		}
	}
}

function UWindowComboListItem GetItem (string Value)
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		if ( i.Value == Value )
		{
			return i;
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
	return None;
}

function DisableAllItems ()
{
	local UWindowComboListItem i;
	local int Count;

	i=UWindowComboListItem(Items.Next);
	Count=0;
JL0020:
	if ( i != None )
	{
		i.bDisabled=True;
		i=UWindowComboListItem(i.Next);
		goto JL0020;
	}
}

function MouseMove (float X, float Y)
{
	Super.MouseMove(X,Y);
	if ( Y > WinHeight )
	{
		VertSB.Scroll(1.00);
	}
	if ( Y < 0 )
	{
		VertSB.Scroll(-1.00);
	}
	SetSelected(X,Y);
	FocusWindow();
}

function LMouseUp (float X, float Y)
{
	if ( (Y >= 0) && (Y <= WinHeight) && (Selected != None) )
	{
		ExecuteItem(Selected);
	}
	Super.LMouseUp(X,Y);
}

function LMouseDown (float X, float Y)
{
	Root.CaptureMouse();
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float MaxWidth;
	local int Count;
	local UWindowComboListItem i;
	local float ListX;
	local float ListY;
	local float ExtraWidth;

	C.Font=Root.Fonts[Font];
	C.SetPos(0.00,0.00);
	MaxWidth=Owner.EditBoxWidth;
	ExtraWidth=(HBorder + TextBorder) * 2;
	Count=Items.Count();
	if ( Count > MaxVisible )
	{
		ExtraWidth += LookAndFeel.Size_ScrollbarWidth;
		WinHeight=ItemHeight * MaxVisible + VBorder * 2;
	}
	else
	{
		VertSB.pos=0.00;
		WinHeight=ItemHeight * Count + VBorder * 2;
	}
	i=UWindowComboListItem(Items.Next);
JL0112:
	if ( i != None )
	{
		TextSize(C,RemoveAmpersand(i.Value),W,H);
		if ( W + ExtraWidth > MaxWidth )
		{
			MaxWidth=W + ExtraWidth;
		}
		i=UWindowComboListItem(i.Next);
		goto JL0112;
	}
	WinWidth=MaxWidth;
	ListX=Owner.EditAreaDrawX + Owner.EditBoxWidth - WinWidth;
	ListY=Owner.Button.WinTop + Owner.Button.WinHeight;
	if ( Count > MaxVisible )
	{
		VertSB.ShowWindow();
		VertSB.SetRange(0.00,Count,MaxVisible);
		VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
		VertSB.WinTop=0.00;
		VertSB.SetSize(LookAndFeel.Size_ScrollbarWidth,WinHeight);
	}
	else
	{
		VertSB.HideWindow();
	}
	Owner.WindowToGlobal(ListX,ListY,WinLeft,WinTop);
}

function Paint (Canvas C, float X, float Y)
{
	local int Count;
	local UWindowComboListItem i;

	DrawMenuBackground(C);
	Count=0;
	i=UWindowComboListItem(Items.Next);
JL002B:
	if ( i != None )
	{
		if ( VertSB.bWindowVisible )
		{
			if ( Count >= VertSB.pos )
			{
				DrawItem(C,i,HBorder,VBorder + ItemHeight * (Count - VertSB.pos),WinWidth - 2 * HBorder - VertSB.WinWidth,ItemHeight);
			}
		}
		else
		{
			DrawItem(C,i,HBorder,VBorder + ItemHeight * Count,WinWidth - 2 * HBorder,ItemHeight);
		}
		Count++;
		i=UWindowComboListItem(i.Next);
		goto JL002B;
	}
}

function DrawMenuBackground (Canvas C)
{
	LookAndFeel.ComboList_DrawBackground(self,C);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	LookAndFeel.ComboList_DrawItem(self,C,X,Y,W,H,UWindowComboListItem(Item).Value,Selected == Item);
}

function ExecuteItem (UWindowComboListItem i)
{
	Owner.m_bSelectedByUser=True;
	Owner.SetValue(i.Value,i.Value2);
	Owner.m_bSelectedByUser=False;
	CloseUp();
}

function CloseUp ()
{
	Owner.CloseUp();
}

function FocusOtherWindow (UWindowWindow W)
{
	Super.FocusOtherWindow(W);
	if ( bWindowVisible && (W.ParentWindow.ParentWindow != self) && (W.ParentWindow != self) && (W.ParentWindow != Owner) )
	{
		CloseUp();
	}
}

function SetBorderColor (Color _NewColor)
{
	m_BorderColor=_NewColor;
	if ( VertSB != None )
	{
		VertSB.SetBorderColor(m_BorderColor);
	}
}

function MouseWheelDown (float X, float Y)
{
	if ( VertSB != None )
	{
		VertSB.MouseWheelDown(X,Y);
	}
}

function MouseWheelUp (float X, float Y)
{
	if ( VertSB != None )
	{
		VertSB.MouseWheelUp(X,Y);
	}
}

function KeyDown (int Key, float X, float Y)
{
/*	if ( Key == Root.Console.27 )
	{
		CloseUp();
	}*/
}

defaultproperties
{
    MaxVisible=10
}
