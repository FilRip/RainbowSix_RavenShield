//================================================================================
// UWindowTabControlTabArea.
//================================================================================
class UWindowTabControlTabArea extends UWindowWindow;

enum eTabCase {
	eTab_Left,
	eTab_Middle,
	eTab_Right,
	eTab_Left_RightCut,
	eTab_Middle_RightCut
};

var eTabCase m_eTabCase;
var int TabOffset;
var int TabRows;
var int m_iTotalTab;
var globalconfig bool bArrangeRowsLikeTimHates;
var bool bShowSelected;
var bool bDragging;
var bool bFlashShown;
var bool m_bDisplayToolTip;
var float UnFlashTime;
var UWindowTabControlItem FirstShown;
var UWindowTabControlItem DragTab;
var Color m_vEffectColor;

function Created ()
{
	TabOffset=0;
}

function SizeTabsSingleLine (Canvas C)
{
	local UWindowTabControlItem i;
	local UWindowTabControlItem Selected;
	local UWindowTabControlItem LastHidden;
	local int Count;
	local int TabCount;
	local float ItemX;
	local float W;
	local float H;
	local float fTotalTabsWidth;
	local bool bHaveMore;

	ItemX=LookAndFeel.Size_TabXOffset;
	TabCount=0;
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL0042:
	if ( i != None )
	{
		LookAndFeel.Tab_GetTabSize(self,C,RemoveAmpersand(i.Caption),W,H);
		i.TabWidth=W;
		if ( i.m_fFixWidth != 0 )
		{
			i.TabWidth=i.m_fFixWidth;
		}
		fTotalTabsWidth += i.TabWidth;
		if ( fTotalTabsWidth > WinWidth )
		{
			i.TabWidth -= fTotalTabsWidth - WinWidth;
			fTotalTabsWidth=WinWidth;
		}
		i.TabHeight=H + 1;
		i.TabTop=0.00;
		i.RowNumber=0;
		TabCount++;
		i=UWindowTabControlItem(i.Next);
		goto JL0042;
	}
	m_iTotalTab=TabCount;
	Selected=UWindowTabControl(ParentWindow).SelectedTab;
JL0196:
	if ( True )
	{
		ItemX=LookAndFeel.Size_TabXOffset;
		Count=0;
		LastHidden=None;
		FirstShown=None;
		i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL01EA:
		if ( i != None )
		{
			if ( Count < TabOffset )
			{
				i.TabLeft=-1.00;
				LastHidden=i;
			}
			else
			{
				if ( FirstShown == None )
				{
					FirstShown=i;
				}
				i.TabLeft=ItemX;
				if ( i.TabLeft + i.TabWidth >= WinWidth + 5 )
				{
					bHaveMore=True;
				}
				ItemX += i.TabWidth;
				ItemX -= 15;
			}
			Count++;
			i=UWindowTabControlItem(i.Next);
			goto JL01EA;
		}
		if ( (TabOffset > 0) && (LastHidden != None) && (LastHidden.TabWidth + 5 < WinWidth - ItemX) )
		{
			TabOffset--;
		}
		else
		{
			if ( bShowSelected && (TabOffset < TabCount - 1) && (Selected != None) && (Selected != FirstShown) && (Selected.TabLeft + Selected.TabWidth > WinWidth - 5) )
			{
				TabOffset++;
			}
			else
			{
				goto JL038D;
			}
		}
		goto JL0196;
	}
JL038D:
	bShowSelected=False;
	if ( UWindowTabControl(ParentWindow).m_bTabButton )
	{
		UWindowTabControl(ParentWindow).LeftButton.bDisabled=TabOffset <= 0;
		UWindowTabControl(ParentWindow).RightButton.bDisabled= !bHaveMore;
	}
	TabRows=1;
}

function SizeTabsMultiLine (Canvas C)
{
	local UWindowTabControlItem i;
	local UWindowTabControlItem Selected;
	local float W;
	local float H;
	local int MinRow;
	local float RowWidths[10];
	local int TabCounts[10];
	local int j;
	local bool bTryAnotherRow;

	TabOffset=0;
	FirstShown=None;
	TabRows=1;
	bTryAnotherRow=True;
JL001D:
	if ( bTryAnotherRow && (TabRows <= 10) )
	{
		bTryAnotherRow=False;
		j=0;
JL0043:
		if ( j < TabRows )
		{
			RowWidths[j]=0.00;
			TabCounts[j]=0;
			j++;
			goto JL0043;
		}
		i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL00A1:
		if ( i != None )
		{
			LookAndFeel.Tab_GetTabSize(self,C,RemoveAmpersand(i.Caption),W,H);
			i.TabWidth=W;
			i.TabHeight=H;
			MinRow=0;
			j=1;
JL0115:
			if ( j < TabRows )
			{
				if ( RowWidths[j] < RowWidths[MinRow] )
				{
					MinRow=j;
				}
				j++;
				goto JL0115;
			}
			if ( RowWidths[MinRow] + W > WinWidth )
			{
				TabRows++;
				bTryAnotherRow=True;
				goto JL01D4;
			}
			else
			{
				RowWidths[MinRow] += W;
				TabCounts[MinRow]++;
				i.RowNumber=MinRow;
			}
			i=UWindowTabControlItem(i.Next);
			goto JL00A1;
		}
JL01D4:
		goto JL001D;
	}
	Selected=UWindowTabControl(ParentWindow).SelectedTab;
	if ( TabRows > 1 )
	{
		i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL0222:
		if ( i != None )
		{
			i.TabWidth += (WinWidth - RowWidths[i.RowNumber]) / TabCounts[i.RowNumber];
			i=UWindowTabControlItem(i.Next);
			goto JL0222;
		}
	}
	j=0;
JL0293:
	if ( j < TabRows )
	{
		RowWidths[j]=0.00;
		j++;
		goto JL0293;
	}
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL02E4:
	if ( i != None )
	{
		i.TabLeft=RowWidths[i.RowNumber];
		if ( bArrangeRowsLikeTimHates )
		{
			i.TabTop=((i.RowNumber + TabRows - 1 - Selected.RowNumber) % TabRows) * i.TabHeight;
		}
		else
		{
			i.TabTop=i.RowNumber * i.TabHeight;
		}
		RowWidths[i.RowNumber] += i.TabWidth;
		i=UWindowTabControlItem(i.Next);
		goto JL02E4;
	}
}

function LayoutTabs (Canvas C)
{
	if ( UWindowTabControl(ParentWindow).bMultiLine )
	{
		SizeTabsMultiLine(C);
	}
	else
	{
		SizeTabsSingleLine(C);
	}
}

function Paint (Canvas C, float X, float Y)
{
	local UWindowTabControlItem i;
	local UWindowTabControlItem ITemp;
	local int Count;
	local int Row;
	local int iTabNumber;
	local float t;
	local bool bNextTabSelected;
	local bool bPrevTabSelected;

	t=GetEntryLevel().TimeSeconds;
	if ( UnFlashTime < t )
	{
		bFlashShown= !bFlashShown;
		if ( bFlashShown )
		{
			UnFlashTime=t + 0.50;
		}
		else
		{
			UnFlashTime=t + 0.30;
		}
	}
	Row=0;
JL006A:
	if ( Row < TabRows )
	{
		Count=0;
		iTabNumber=0;
		m_eTabCase=eTab_Left;
		i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL00B6:
		if ( i != None )
		{
			if ( Count < TabOffset )
			{
				Count++;
			}
			else
			{
				if ( i.RowNumber == Row )
				{
					bNextTabSelected=False;
					if ( UWindowTabControlItem(i.Next) == UWindowTabControl(ParentWindow).SelectedTab )
					{
						bNextTabSelected=True;
					}
					if ( UWindowTabControlItem(i.Prev) == UWindowTabControl(ParentWindow).SelectedTab )
					{
						bPrevTabSelected=True;
					}
					if ( iTabNumber > 0 )
					{
						if ( iTabNumber == m_iTotalTab - 1 )
						{
							m_eTabCase=eTab_Right;
						}
						else
						{
							m_eTabCase=eTab_Middle;
							if ( bNextTabSelected )
							{
								m_eTabCase=eTab_Middle_RightCut;
							}
						}
					}
					else
					{
						if ( bNextTabSelected )
						{
							m_eTabCase=eTab_Left_RightCut;
						}
					}
					DrawItem(C,i,i.TabLeft,i.TabTop,i.TabWidth,i.TabHeight, !i.bFlash || bFlashShown);
					iTabNumber++;
				}
			}
			i=UWindowTabControlItem(i.Next);
			goto JL00B6;
		}
		Row++;
		goto JL006A;
	}
}

function LMouseDown (float X, float Y)
{
	local UWindowTabControlItem i;
	local int Count;

	Super.LMouseDown(X,Y);
	Count=0;
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL003E:
	if ( i != None )
	{
		if ( Count < TabOffset )
		{
			Count++;
		}
		else
		{
			if ( (X >= i.TabLeft) && (X <= i.TabLeft + i.TabWidth) && ((TabRows == 1) || (Y >= i.TabTop) && (Y <= i.TabTop + i.TabHeight)) )
			{
				if (  !UWindowTabControl(ParentWindow).bMultiLine )
				{
					bDragging=True;
					DragTab=i;
					Root.CaptureMouse();
				}
				UWindowTabControl(ParentWindow).GotoTab(i,True);
			}
		}
		i=UWindowTabControlItem(i.Next);
		goto JL003E;
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	ResetMouseOverOnItem();
}

function MouseMove (float X, float Y)
{
	CheckToolTip(X,Y);
	if ( bDragging && bMouseDown )
	{
		if ( X < DragTab.TabLeft )
		{
			TabOffset++;
		}
		if ( (X > DragTab.TabLeft + DragTab.TabWidth) && (TabOffset > 0) )
		{
			TabOffset--;
		}
	}
	else
	{
		bDragging=False;
	}
}

function RMouseDown (float X, float Y)
{
	local UWindowTabControlItem i;
	local int Count;

	LMouseDown(X,Y);
	Count=0;
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL003E:
	if ( i != None )
	{
		if ( Count < TabOffset )
		{
			Count++;
		}
		else
		{
			if ( (X >= i.TabLeft) && (X <= i.TabLeft + i.TabWidth) )
			{
				i.RightClickTab();
			}
		}
		i=UWindowTabControlItem(i.Next);
		goto JL003E;
	}
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H, bool bShowText)
{
	local UWindowTabControlItem pTabControlItem;

	pTabControlItem=UWindowTabControlItem(Item);
	m_bDisplayToolTip=pTabControlItem.m_bMouseOverItem;
	if ( Item == UWindowTabControl(ParentWindow).SelectedTab )
	{
		m_vEffectColor=pTabControlItem.m_vSelectedColor;
		LookAndFeel.Tab_DrawTab(self,C,True,FirstShown == Item,X,Y,W,H,pTabControlItem.Caption,bShowText);
	}
	else
	{
		m_vEffectColor=pTabControlItem.m_vNormalColor;
		LookAndFeel.Tab_DrawTab(self,C,False,FirstShown == Item,X,Y,W,H,pTabControlItem.Caption,bShowText);
	}
}

function bool CheckMousePassThrough (float X, float Y)
{
	return Y >= LookAndFeel.Size_TabAreaHeight * TabRows;
}

function UWindowTabControlItem CheckMouseOverOnItem (float _fX, float _fY)
{
	local UWindowTabControlItem i;
	local UWindowTabControlItem ItemTemp;
	local int Count;
	local float fXMin;
	local float fXMax;

	ItemTemp=None;
	Count=0;
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL0035:
	if ( i != None )
	{
		if ( Count < TabOffset )
		{
			Count++;
		}
		else
		{
			fXMin=i.TabLeft + 10;
			fXMax=i.TabLeft + i.TabWidth - 18;
			if ( (_fX >= fXMin) && (_fX <= fXMax) && ((TabRows == 1) || (_fY >= i.TabTop) && (_fY <= i.TabTop + i.TabHeight)) )
			{
				ItemTemp=i;
				i.m_bMouseOverItem=True;
			}
			else
			{
				i.m_bMouseOverItem=False;
			}
		}
		i=UWindowTabControlItem(i.Next);
		goto JL0035;
	}
	return ItemTemp;
}

function ResetMouseOverOnItem ()
{
	local UWindowTabControlItem i;
	local int Count;

	Count=0;
	i=UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
JL002E:
	if ( i != None )
	{
		if ( Count < TabOffset )
		{
			Count++;
		}
		else
		{
			i.m_bMouseOverItem=False;
		}
		i=UWindowTabControlItem(i.Next);
		goto JL002E;
	}
	ParentWindow.ToolTip("");
}

function CheckToolTip (float _fX, float _fY)
{
	local UWindowTabControlItem Item;

	Item=CheckMouseOverOnItem(_fX,_fY);
	if ( Item != None )
	{
		if ( Item.m_bMouseOverItem && (Item.HelpText != "") )
		{
			ParentWindow.ToolTip(Item.HelpText);
		}
	}
	else
	{
		ParentWindow.ToolTip("");
	}
}
