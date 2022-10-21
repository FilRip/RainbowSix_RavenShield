//================================================================================
// R6WindowListRadioButton.
//================================================================================
class R6WindowListRadioButton extends R6WindowTextListRadio;

var bool m_bCanBeUnselected;
var float m_fItemWidth;
var float m_fItemVPadding;

function Created ()
{
	Super.Created();
}

function ChangeItemsSize (float iNewSize);

function Paint (Canvas C, float MouseX, float MouseY)
{
	local float X;
	local float Y;
	local UWindowList CurItem;

	if ( m_fItemWidth == 0 )
	{
		m_fItemWidth=WinWidth;
	}
	X=(WinWidth - m_fItemWidth) / 2;
	CurItem=Items.Next;
JL0044:
	if ( CurItem != None )
	{
		DrawItem(C,CurItem,X,Y,m_fItemWidth,m_fItemHeight);
		Y += m_fItemHeight + m_fItemVPadding;
		if ( Y >= WinHeight )
		{
			Y=0.00;
			X += WinWidth;
		}
		CurItem=CurItem.Next;
		goto JL0044;
	}
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local R6WindowListButtonItem pListButtonItem;

	pListButtonItem=R6WindowListButtonItem(Item);
	if ( pListButtonItem.m_Button != None )
	{
		pListButtonItem.m_Button.WinLeft=X;
		pListButtonItem.m_Button.WinTop=Y;
		pListButtonItem.m_Button.WinHeight=H;
	}
}

function UWindowListBoxItem GetItemAt (float fMouseX, float fMouseY)
{
	local float X;
	local float Y;
	local UWindowList CurItem;
	local int i;
	local int j;

	if ( (fMouseX < 0) || (fMouseX > WinWidth) )
	{
		return None;
	}
	if ( Items == None )
	{
		return None;
	}
	CurItem=Items.Next;
	X=0.00;
JL004C:
	if ( (X < WinWidth) && (CurItem != None) )
	{
		if ( (fMouseX >= X) && (fMouseX <= X + WinWidth) )
		{
			Y=0.00;
JL009A:
			if ( (Y < WinHeight) && (CurItem != None) )
			{
				if ( CurItem.ShowThisItem() )
				{
					if ( (fMouseY >= Y) && (fMouseY <= Y + m_fItemHeight) )
					{
						return UWindowListBoxItem(CurItem);
					}
				}
				if ( CurItem != None )
				{
					CurItem=CurItem.Next;
				}
				Y += m_fItemHeight + m_fItemVPadding;
				goto JL009A;
			}
		}
		else
		{
			j=0;
JL0139:
			if ( (CurItem != None) && (j < WinHeight / (m_fItemHeight + m_fItemVPadding)) )
			{
				if ( CurItem != None )
				{
					CurItem=CurItem.Next;
				}
				j++;
				goto JL0139;
			}
		}
		X += WinWidth;
		goto JL004C;
	}
	return None;
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	local UWindowListBoxItem CurSelected;

	CurSelected=m_SelectedItem;
	if ( m_SelectedItem != None )
	{
		R6WindowListButtonItem(m_SelectedItem).m_Button.m_bSelected=False;
	}
	Super.SetSelectedItem(NewSelected);
	if ( m_bCanBeUnselected )
	{
		if ( CurSelected == m_SelectedItem )
		{
			m_SelectedItem.bSelected=False;
			m_SelectedItem=None;
		}
	}
	if ( m_SelectedItem != None )
	{
		R6WindowListButtonItem(m_SelectedItem).m_Button.m_bSelected=True;
	}
}

function SetDefaultButton (UWindowList Item)
{
	if ( Item != None )
	{
		if ( m_SelectedItem == None )
		{
			SetSelectedItem(UWindowListBoxItem(Item));
		}
	}
}

function UWindowListBoxItem GetElement (int ButtonID)
{
	local UWindowList CurItem;
	local bool Found;
	local int i;

	if ( ButtonID < 0 )
	{
		return None;
	}
	if ( Items == None )
	{
		return None;
	}
	CurItem=Items.Next;
	i=0;
JL0035:
	if ( (i < Items.Count()) && (Found == False) )
	{
		if ( R6WindowListButtonItem(CurItem).m_Button.m_iButtonID == ButtonID )
		{
			Found=True;
		}
		else
		{
			CurItem=CurItem.Next;
		}
		i++;
		goto JL0035;
	}
	if ( Found )
	{
		return UWindowListBoxItem(CurItem);
	}
	else
	{
		return None;
	}
}

defaultproperties
{
    m_fItemHeight=50.00
    ListClass=Class'R6WindowListButtonItem'
}