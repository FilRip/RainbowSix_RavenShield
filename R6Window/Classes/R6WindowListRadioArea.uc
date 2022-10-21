//================================================================================
// R6WindowListRadioArea.
//================================================================================
class R6WindowListRadioArea extends R6WindowTextListRadio;

var Class<R6WindowArea> AreaClass;

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	local float Y;
	local UWindowList CurItem;

	CurItem=Items.Next;
	CurItem=Items.Next;
	while ( CurItem != None )
	{
		DrawItem(C,CurItem,0.00,Y,WinWidth,m_fItemHeight);
		Y=Y + m_fItemHeight;
		CurItem=CurItem.Next;
	}
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	local UWindowListBoxItem CurSelected;

	CurSelected=m_SelectedItem;
	if ( m_SelectedItem != None )
	{
		R6WindowListAreaItem(m_SelectedItem).m_Area.m_bSelected=False;
	}
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
	if ( m_SelectedItem != None )
	{
		R6WindowListAreaItem(m_SelectedItem).m_Area.m_bSelected=True;
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

defaultproperties
{
    m_fItemHeight=50.00
    ListClass=Class'R6WindowListAreaItem'
}