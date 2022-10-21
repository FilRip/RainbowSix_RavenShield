//================================================================================
// R6WindowListArea.
//================================================================================
class R6WindowListArea extends R6WindowTextListBox;

var Class<R6WindowArea> m_AreaClass;

function BeforePaint (Canvas C, float fMouseX, float fMouseY)
{
	local UWindowListBoxItem OverItem;

	m_VertSB.SetRange(0.00,Items.CountShown(),WinHeight / m_fItemHeight);
	Super.BeforePaint(C,fMouseX,fMouseY);
}

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	local float Y;
	local UWindowList CurItem;
	local int i;

	CurItem=Items.Next;
JL0014:
	if ( (CurItem != None) && (i < m_VertSB.pos) )
	{
		++i;
		R6WindowListAreaItem(CurItem).SetBack();
		CurItem=CurItem.Next;
		goto JL0014;
	}
JL006D:
	if ( (CurItem != None) && (i < m_VertSB.pos + m_VertSB.MaxVisible) )
	{
		DrawItem(C,CurItem,0.00,Y,WinWidth - m_VertSB.WinWidth,m_fItemHeight);
		Y=Y + m_fItemHeight;
		CurItem=CurItem.Next;
		goto JL006D;
	}
}

defaultproperties
{
    m_AreaClass=Class'R6WindowArea'
    m_fItemHeight=50.00
    ListClass=Class'R6WindowListAreaItem'
}