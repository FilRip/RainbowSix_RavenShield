//================================================================================
// R6WindowListRadio.
//================================================================================
class R6WindowListRadio extends UWindowListControl;

var float m_fItemHeight;
var UWindowListBoxItem m_SelectedItem;
var R6WindowListRadio m_DoubleClickList;
var string m_szDefaultHelpText;

function BeforePaint (Canvas C, float fMouseX, float fMouseY)
{
	local UWindowListBoxItem OverItem;
	local string szNewHelpText;

	szNewHelpText=m_szDefaultHelpText;
	if ( m_SelectedItem != None )
	{
		OverItem=GetItemAt(fMouseX,fMouseY);
		if ( (OverItem == m_SelectedItem) && (OverItem.HelpText != "") )
		{
			szNewHelpText=OverItem.HelpText;
		}
	}
	if ( szNewHelpText != HelpText )
	{
		HelpText=szNewHelpText;
		Notify(13);
	}
}

function SetHelpText (string t)
{
	Super.SetHelpText(t);
	m_szDefaultHelpText=t;
}

function Sort ()
{
	Items.Sort();
}

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;

	CurItem=Items.Next;
	Y=0.00;
JL001F:
	if ( (Y < WinHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			DrawItem(C,CurItem,0.00,Y,WinWidth,m_fItemHeight);
			Y=Y + m_fItemHeight;
		}
		CurItem=CurItem.Next;
		goto JL001F;
	}
}

function UWindowListBoxItem GetItemAt (float fMouseX, float fMouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;

	if ( (fMouseX < 0) || (fMouseX > WinWidth) )
	{
		return None;
	}
	CurItem=Items.Next;
	Y=0.00;
JL003F:
	if ( (Y < WinHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			if ( (fMouseY >= Y) && (fMouseY <= Y + m_fItemHeight) )
			{
				return UWindowListBoxItem(CurItem);
			}
			Y=Y + m_fItemHeight;
		}
		CurItem=CurItem.Next;
		goto JL003F;
	}
	return None;
}

function MakeSelectedVisible ()
{
	local UWindowList CurItem;
	local int i;

	if ( m_SelectedItem == None )
	{
		return;
	}
	CurItem=Items.Next;
JL0021:
	if ( CurItem != None )
	{
		if ( CurItem == m_SelectedItem )
		{
			goto JL006E;
		}
		if ( CurItem.ShowThisItem() )
		{
			i++;
		}
		CurItem=CurItem.Next;
		goto JL0021;
	}
JL006E:
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	if ( (NewSelected != None) && (m_SelectedItem != NewSelected) )
	{
		if ( m_SelectedItem != None )
		{
			m_SelectedItem.bSelected=False;
		}
		m_SelectedItem=NewSelected;
		if ( m_SelectedItem != None )
		{
			m_SelectedItem.bSelected=True;
		}
		Notify(2);
	}
}

function SetSelected (float X, float Y)
{
	local UWindowListBoxItem NewSelected;

	NewSelected=GetItemAt(X,Y);
	SetSelectedItem(NewSelected);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	SetSelected(X,Y);
}

function DoubleClick (float X, float Y)
{
	Super.DoubleClick(X,Y);
	if ( GetItemAt(X,Y) == m_SelectedItem )
	{
		DoubleClickItem(m_SelectedItem);
	}
}

function ReceiveDoubleClickItem (R6WindowListRadio L, UWindowListBoxItem i)
{
	i.Remove();
	Items.AppendItem(i);
	SetSelectedItem(i);
	L.m_SelectedItem=None;
	L.Notify(1);
	Notify(1);
}

function DoubleClickItem (UWindowListBoxItem i)
{
	if ( (m_DoubleClickList != None) && (i != None) )
	{
		m_DoubleClickList.ReceiveDoubleClickItem(self,i);
	}
}

defaultproperties
{
    m_fItemHeight=10.00
}