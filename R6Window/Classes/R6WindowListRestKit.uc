//================================================================================
// R6WindowListRestKit.
//================================================================================
class R6WindowListRestKit extends UWindowListControl;

var float m_fItemHeight;
var float m_fSpaceBetItem;
var float m_fXItemOffset;
var float m_fYOffSet;
var R6WindowVScrollbar m_VertSB;
var Class<R6WindowVScrollbar> m_SBClass;

function Created ()
{
	Super.Created();
	m_VertSB=R6WindowVScrollbar(CreateWindow(m_SBClass,WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
	m_VertSB.SetHideWhenDisable(True);
}

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	local UWindowList CurItem;
	local R6WindowLookAndFeel LAF;
	local float fItemHeight;
	local float fListHeight;
	local float fdrawWidth;
	local float Y;
	local int i;

	LAF=R6WindowLookAndFeel(LookAndFeel);
	CurItem=Items.Next;
	if ( CurItem == None )
	{
		return;
	}
	fItemHeight=GetSizeOfAnItem();
	fListHeight=WinHeight - 2 * LAF.m_SBHBorder.H - m_fYOffSet;
	fdrawWidth=WinWidth - 2 * m_fXItemOffset;
	if ( m_VertSB != None )
	{
		m_VertSB.SetRange(0.00,Items.CountShown(),fListHeight / fItemHeight);
		if (  !m_VertSB.isHidden() )
		{
			fdrawWidth -= m_VertSB.WinWidth;
		}
JL00EB:
		if ( (CurItem != None) && (i < m_VertSB.pos) )
		{
			R6WindowListGeneralItem(CurItem).m_pR6WindowButtonBox.HideWindow();
			if ( CurItem.ShowThisItem() )
			{
				i++;
			}
			CurItem=CurItem.Next;
			goto JL00EB;
		}
	}
	Y=LAF.m_SBHBorder.H + m_fYOffSet;
JL0181:
	if ( (Y + fItemHeight <= fListHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			DrawItem(C,CurItem,m_fXItemOffset,Y,fdrawWidth,fItemHeight);
			Y=Y + fItemHeight;
		}
		CurItem=CurItem.Next;
		goto JL0181;
	}
JL0203:
	if ( CurItem != None )
	{
		R6WindowListGeneralItem(CurItem).m_pR6WindowButtonBox.HideWindow();
		CurItem=CurItem.Next;
		goto JL0203;
	}
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local R6WindowListGeneralItem pListGenItem;

	pListGenItem=R6WindowListGeneralItem(Item);
	pListGenItem.m_pR6WindowButtonBox.WinTop=WinTop + Y;
	if ( pListGenItem.m_pR6WindowButtonBox.WinWidth != W )
	{
		pListGenItem.m_pR6WindowButtonBox.WinLeft=WinLeft + X;
		pListGenItem.m_pR6WindowButtonBox.WinHeight=H;
		pListGenItem.m_pR6WindowButtonBox.SetNewWidth(W);
	}
	pListGenItem.m_pR6WindowButtonBox.ShowWindow();
}

function float GetSizeOfAnItem ()
{
	local float fTotalItemHeigth;

	fTotalItemHeigth=m_fItemHeight + m_fSpaceBetItem;
	return fTotalItemHeigth;
}

function MouseWheelDown (float X, float Y)
{
	if ( m_VertSB != None )
	{
		m_VertSB.MouseWheelDown(X,Y);
	}
}

function MouseWheelUp (float X, float Y)
{
	if ( m_VertSB != None )
	{
		m_VertSB.MouseWheelUp(X,Y);
	}
}

defaultproperties
{
    m_fItemHeight=16.00
    m_fSpaceBetItem=2.00
    m_fYOffSet=2.00
    m_SBClass=Class'R6WindowVScrollbar'
    ListClass=Class'R6WindowListGeneralItem'
}