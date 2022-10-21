//================================================================================
// UWindowListBox.
//================================================================================
class UWindowListBox extends UWindowListControl;

var bool bCanDrag;
var bool bCanDragExternal;
var bool bDragging;
var float ItemHeight;
var float DragY;
var UWindowVScrollbar VertSB;
var UWindowListBoxItem SelectedItem;
var UWindowListBox DoubleClickList;
var string DefaultHelpText;

function Created ()
{
	Super.Created();
	VertSB=UWindowVScrollbar(CreateWindow(Class'UWindowVScrollbar',WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
}

function BeforePaint (Canvas C, float MouseX, float MouseY)
{
	local UWindowListBoxItem OverItem;
	local string NewHelpText;

	VertSB.SetRange(0.00,Items.CountShown(),WinHeight / ItemHeight);
	NewHelpText=DefaultHelpText;
	if ( SelectedItem != None )
	{
		OverItem=GetItemAt(MouseX,MouseY);
		if ( (OverItem == SelectedItem) && (OverItem.HelpText != "") )
		{
			NewHelpText=OverItem.HelpText;
		}
	}
	if ( NewHelpText != HelpText )
	{
		HelpText=NewHelpText;
		Notify(13);
	}
}

function SetHelpText (string t)
{
	Super.SetHelpText(t);
	DefaultHelpText=t;
}

function Sort ()
{
	Items.Sort();
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;

	CurItem=Items.Next;
	i=0;
JL001B:
	if ( (CurItem != None) && (i < VertSB.pos) )
	{
		if ( CurItem.ShowThisItem() )
		{
			i++;
		}
		CurItem=CurItem.Next;
		goto JL001B;
	}
	Y=0.00;
JL007D:
	if ( (Y < WinHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			DrawItem(C,CurItem,0.00,Y,WinWidth - LookAndFeel.Size_ScrollbarWidth,ItemHeight);
			Y=Y + ItemHeight;
		}
		CurItem=CurItem.Next;
		goto JL007D;
	}
}

function Resized ()
{
	Super.Resized();
	VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
	VertSB.WinTop=0.00;
	VertSB.SetSize(LookAndFeel.Size_ScrollbarWidth,WinHeight);
}

function UWindowListBoxItem GetItemAt (float MouseX, float MouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;

	if ( (MouseX < 0) || (MouseX > WinWidth) )
	{
		return None;
	}
	CurItem=Items.Next;
	i=0;
JL003B:
	if ( (CurItem != None) && (i < VertSB.pos) )
	{
		if ( CurItem.ShowThisItem() )
		{
			i++;
		}
		CurItem=CurItem.Next;
		goto JL003B;
	}
	Y=0.00;
JL009D:
	if ( (Y < WinHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			if ( (MouseY >= Y) && (MouseY <= Y + ItemHeight) )
			{
				return UWindowListBoxItem(CurItem);
			}
			Y=Y + ItemHeight;
		}
		CurItem=CurItem.Next;
		goto JL009D;
	}
	return None;
}

function MakeSelectedVisible ()
{
	local UWindowList CurItem;
	local int i;

	VertSB.SetRange(0.00,Items.CountShown(),WinHeight / ItemHeight);
	if ( SelectedItem == None )
	{
		return;
	}
	i=0;
	CurItem=Items.Next;
JL005D:
	if ( CurItem != None )
	{
		if ( CurItem == SelectedItem )
		{
			goto JL00AA;
		}
		if ( CurItem.ShowThisItem() )
		{
			i++;
		}
		CurItem=CurItem.Next;
		goto JL005D;
	}
JL00AA:
	VertSB.Show(i);
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	if ( (NewSelected != None) && (SelectedItem != NewSelected) )
	{
		if ( SelectedItem != None )
		{
			SelectedItem.bSelected=False;
		}
		SelectedItem=NewSelected;
		if ( SelectedItem != None )
		{
			SelectedItem.bSelected=True;
		}
		Notify(2);
	}
}

function SetSelected (float X, float Y)
{
	local UWindowListBoxItem NewSelected;

	NewSelected=GetItemAt(X,Y);
	if ( NewSelected != SelectedItem )
	{
		ClickTime=0.00;
	}
	SetSelectedItem(NewSelected);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	SetSelected(X,Y);
	if ( bCanDrag || bCanDragExternal )
	{
		bDragging=True;
		Root.CaptureMouse();
		DragY=Y;
	}
}

function DoubleClick (float X, float Y)
{
	Super.DoubleClick(X,Y);
	if ( GetItemAt(X,Y) == SelectedItem )
	{
		DoubleClickItem(SelectedItem);
	}
}

function ReceiveDoubleClickItem (UWindowListBox L, UWindowListBoxItem i)
{
	i.Remove();
	Items.AppendItem(i);
	SetSelectedItem(i);
	L.SelectedItem=None;
	L.Notify(1);
	Notify(1);
}

function DoubleClickItem (UWindowListBoxItem i)
{
	if ( (DoubleClickList != None) && (i != None) )
	{
		DoubleClickList.ReceiveDoubleClickItem(self,i);
	}
}

function MouseMove (float X, float Y)
{
	local UWindowListBoxItem OverItem;

	Super.MouseMove(X,Y);
	if ( bDragging && bMouseDown )
	{
		OverItem=GetItemAt(X,Y);
		if ( bCanDrag && (OverItem != SelectedItem) && (OverItem != None) && (SelectedItem != None) )
		{
			SelectedItem.Remove();
			if ( Y < DragY )
			{
				OverItem.InsertItemBefore(SelectedItem);
			}
			else
			{
				OverItem.InsertItemAfter(SelectedItem,True);
			}
			Notify(1);
			DragY=Y;
		}
		else
		{
			if ( bCanDragExternal && (CheckExternalDrag(X,Y) != None) )
			{
				bDragging=False;
			}
		}
	}
	else
	{
		bDragging=False;
	}
}

function bool ExternalDragOver (UWindowDialogControl ExternalControl, float X, float Y)
{
	local UWindowListBox B;
	local UWindowListBoxItem OverItem;

	B=UWindowListBox(ExternalControl);
	if ( (B != None) && (B.SelectedItem != None) )
	{
		OverItem=GetItemAt(X,Y);
		B.SelectedItem.Remove();
		if ( OverItem != None )
		{
			OverItem.InsertItemBefore(B.SelectedItem);
		}
		else
		{
			Items.AppendItem(B.SelectedItem);
		}
		SetSelectedItem(B.SelectedItem);
		B.SelectedItem=None;
		B.Notify(1);
		Notify(1);
		if ( bCanDrag || bCanDragExternal )
		{
			Root.CancelCapture();
			bDragging=True;
			bMouseDown=True;
			Root.CaptureMouse(self);
			DragY=Y;
		}
		return True;
	}
	return False;
}

defaultproperties
{
    ItemHeight=10.00
}
