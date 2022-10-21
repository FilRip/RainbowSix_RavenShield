//================================================================================
// R6WindowListBox.
//================================================================================
class R6WindowListBox extends UWindowListControl;

enum eCornerType {
	No_Corners,
	No_Borders,
	Top_Corners,
	Bottom_Corners,
	All_Corners
};

var eCornerType m_eCornerType;
var int m_iTotItemsDisplayed;
var bool m_bDragging;
var bool m_bCanDrag;
var bool m_bCanDragExternal;
var bool m_bActiveOverEffect;
var bool m_bIgnoreUserClicks;
var bool m_bForceCaps;
var bool m_bSkipDrawBorders;
var float m_fItemHeight;
var float m_fSpaceBetItem;
var float m_fDragY;
var float m_fXItemOffset;
var float m_fXItemRightPadding;
var R6WindowVScrollbar m_VertSB;
var UWindowListBoxItem m_SelectedItem;
var Texture m_TIcon;
var R6WindowListBox m_DoubleClickList;
var UWindowWindow m_DoubleClickClient;
var Class<R6WindowVScrollbar> m_SBClass;
var Color m_vMouseOverWindow;
var Color m_vInitBorderColor;
var string m_szDefaultHelpText;

function Created ()
{
	Super.Created();
	m_VertSB=R6WindowVScrollbar(CreateWindow(m_SBClass,WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
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
	local R6WindowLookAndFeel LAF;
	local UWindowList CurItem;
	local float Y;
	local float fdrawWidth;
	local float fListHeight;
	local float fItemHeight;
	local int i;

	LAF=R6WindowLookAndFeel(LookAndFeel);
	CurItem=Items.Next;
	if ( CurItem != None )
	{
		fItemHeight=GetSizeOfAnItem(CurItem);
	}
	fListHeight=GetSizeOfList();
	if ( m_VertSB != None )
	{
		m_VertSB.SetRange(0.00,Items.CountShown(),fListHeight / fItemHeight);
JL008C:
		if ( (CurItem != None) && (i < m_VertSB.pos) )
		{
			i++;
			CurItem=CurItem.Next;
			goto JL008C;
		}
	}
	if ( (m_VertSB == None) || m_VertSB.isHidden() )
	{
		fdrawWidth=WinWidth - m_fXItemRightPadding - m_fXItemOffset;
	}
	else
	{
		fdrawWidth=WinWidth - m_VertSB.WinWidth - m_fXItemRightPadding - m_fXItemOffset;
	}
	m_iTotItemsDisplayed=0;
	Y=LAF.m_SBHBorder.H;
JL0157:
	if ( (Y + fItemHeight <= fListHeight + LAF.m_SBHBorder.H) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			DrawItem(C,CurItem,m_fXItemOffset,Y,fdrawWidth,fItemHeight);
			Y=Y + fItemHeight;
			m_iTotItemsDisplayed++;
		}
		CurItem=CurItem.Next;
		goto JL0157;
	}
}

function float GetSizeOfAnItem (UWindowList _pItem)
{
	local float fTotalItemHeigth;

	fTotalItemHeigth=m_fItemHeight + m_fSpaceBetItem;
	if ( UWindowListBoxItem(_pItem).m_bUseSubText )
	{
		fTotalItemHeigth += UWindowListBoxItem(_pItem).m_stSubText.fHeight;
	}
	return fTotalItemHeigth;
}

function float GetSizeOfList ()
{
	return WinHeight - 2 * R6WindowLookAndFeel(LookAndFeel).m_SBHBorder.H;
}

function Resized ()
{
	Super.Resized();
	if ( m_VertSB != None )
	{
		switch (m_eCornerType)
		{
/*			case 0:
			case 1:
			m_VertSB.WinLeft=WinWidth - LookAndFeel.Size_ScrollbarWidth;
			break;
			case 2:
			case 3:
			case 4:
			m_VertSB.WinLeft=WinWidth - m_VertSB.WinWidth - R6WindowLookAndFeel(LookAndFeel).m_iListVPadding;
			break;
			default:*/
		}
		m_VertSB.WinTop=0.00;
		m_VertSB.SetSize(LookAndFeel.Size_ScrollbarWidth,WinHeight);
	}
}

function SetCornerType (eCornerType _NewCornerType)
{
	m_eCornerType=_NewCornerType;
	Resized();
}

function UWindowListBoxItem GetItemAt (float fMouseX, float fMouseY)
{
	local R6WindowLookAndFeel LAF;
	local UWindowList CurItem;
	local float Y;
	local float fdrawWidth;
	local float fListHeight;
	local float fItemHeight;
	local int i;

	LAF=R6WindowLookAndFeel(LookAndFeel);
	if ( (m_VertSB == None) || m_VertSB.isHidden() )
	{
		fdrawWidth=WinWidth;
	}
	else
	{
		fdrawWidth=WinWidth - m_VertSB.WinWidth;
	}
	if ( (fMouseX < 0) || (fMouseX > fdrawWidth) )
	{
		return None;
	}
	CurItem=Items.Next;
	if ( CurItem != None )
	{
		fItemHeight=GetSizeOfAnItem(CurItem);
	}
	fListHeight=GetSizeOfList();
	if ( m_VertSB != None )
	{
JL00BF:
		if ( (CurItem != None) && (i < m_VertSB.pos) )
		{
			if ( CurItem.ShowThisItem() )
			{
				i++;
			}
			CurItem=CurItem.Next;
			goto JL00BF;
		}
	}
	Y=LAF.m_SBHBorder.H;
JL0131:
	if ( (Y + fItemHeight <= fListHeight + LAF.m_SBHBorder.H) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			if ( (fMouseY >= Y) && (fMouseY <= Y + fItemHeight - m_fSpaceBetItem) )
			{
				return UWindowListBoxItem(CurItem);
			}
			Y=Y + fItemHeight;
		}
		CurItem=CurItem.Next;
		goto JL0131;
	}
	return None;
}

function MakeSelectedVisible ()
{
	local UWindowList CurItem;
	local int i;

	if ( m_VertSB == None )
	{
		return;
	}
	m_VertSB.SetRange(0.00,Items.CountShown(),GetSizeOfList() / GetSizeOfAnItem(Items.Next));
	if ( m_SelectedItem == None )
	{
		return;
	}
	CurItem=Items.Next;
JL0073:
	if ( CurItem != None )
	{
		if ( CurItem == m_SelectedItem )
		{
			goto JL00C0;
		}
		if ( CurItem.ShowThisItem() )
		{
			i++;
		}
		CurItem=CurItem.Next;
		goto JL0073;
	}
JL00C0:
	m_VertSB.Show(i);
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
	if ( NewSelected != m_SelectedItem )
	{
		ClickTime=0.00;
	}
	SetSelectedItem(NewSelected);
}

function LMouseDown (float X, float Y)
{
	if ( m_bIgnoreUserClicks )
	{
		return;
	}
	Super.LMouseDown(X,Y);
	SetAcceptsFocus();
	SetSelected(X,Y);
	if ( m_bCanDrag || m_bCanDragExternal )
	{
		m_bDragging=True;
		Root.CaptureMouse();
		m_fDragY=Y;
	}
}

function DoubleClick (float X, float Y)
{
	if ( m_bIgnoreUserClicks || (m_SelectedItem == None) )
	{
		return;
	}
	if ( GetItemAt(X,Y) == m_SelectedItem )
	{
		DoubleClickItem(m_SelectedItem);
	}
}

function ReceiveDoubleClickItem (R6WindowListBox L, UWindowListBoxItem i)
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
	if ( m_bIgnoreUserClicks )
	{
		return;
	}
	Notify(11);
	if ( m_DoubleClickClient != None )
	{
		m_DoubleClickClient.NotifyWindow(self,11);
	}
	if ( (m_DoubleClickList != None) && (i != None) )
	{
		m_DoubleClickList.ReceiveDoubleClickItem(self,i);
	}
}

function MouseEnter ()
{
	Super.MouseEnter();
	if ( m_bActiveOverEffect )
	{
		m_BorderColor=m_vMouseOverWindow;
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	if ( m_bActiveOverEffect )
	{
		m_BorderColor=m_vInitBorderColor;
	}
}

function MouseMove (float X, float Y)
{
	local UWindowListBoxItem OverItem;

	Super.MouseMove(X,Y);
	if ( m_bDragging && bMouseDown )
	{
		OverItem=GetItemAt(X,Y);
		if ( m_bCanDrag && (OverItem != m_SelectedItem) && (OverItem != None) && (m_SelectedItem != None) )
		{
			m_SelectedItem.Remove();
			if ( Y < m_fDragY )
			{
				OverItem.InsertItemBefore(m_SelectedItem);
			}
			else
			{
				OverItem.InsertItemAfter(m_SelectedItem,True);
			}
			Notify(1);
			m_fDragY=Y;
		}
		else
		{
			if ( m_bCanDragExternal && (CheckExternalDrag(X,Y) != None) )
			{
				m_bDragging=False;
			}
		}
	}
	else
	{
		m_bDragging=False;
	}
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

function bool ExternalDragOver (UWindowDialogControl ExternalControl, float X, float Y)
{
	local R6WindowListBox B;
	local UWindowListBoxItem OverItem;

	B=R6WindowListBox(ExternalControl);
	if ( (B != None) && (B.m_SelectedItem != None) )
	{
		OverItem=GetItemAt(X,Y);
		B.m_SelectedItem.Remove();
		if ( OverItem != None )
		{
			OverItem.InsertItemBefore(B.m_SelectedItem);
		}
		else
		{
			Items.AppendItem(B.m_SelectedItem);
		}
		SetSelectedItem(B.m_SelectedItem);
		B.m_SelectedItem=None;
		B.Notify(1);
		Notify(1);
		if ( m_bCanDrag || m_bCanDragExternal )
		{
			Root.CancelCapture();
			m_bDragging=True;
			bMouseDown=True;
			Root.CaptureMouse(self);
			m_fDragY=Y;
		}
		return True;
	}
	return False;
}

function DropSelection ()
{
	if ( m_SelectedItem != None )
	{
		m_SelectedItem.bSelected=False;
	}
	m_SelectedItem=None;
}

function UWindowListBoxItem GetSelectedItem ()
{
	return m_SelectedItem;
}

function SetOverBorderColorEffect (Color _vBorderColor)
{
	m_BorderColor=_vBorderColor;
	m_vInitBorderColor=_vBorderColor;
	m_bActiveOverEffect=True;
}

function Region CenterIconInBox (float _fX, float _fY, float _fWidth, float _fHeight, Region _RIconRegion)
{
	local Region RTemp;
	local float fTemp;

	fTemp=(_fWidth - _RIconRegion.W) / 2;
	RTemp.X=_fX + fTemp + 0.50;
	fTemp=(_fHeight - _RIconRegion.H) / 2;
	RTemp.Y=fTemp + 0.50;
	RTemp.Y += _fY;
	return RTemp;
}

function int GetCenterXPos (float _fTagWidth, float _fTextWidth)
{
	return (_fTagWidth - _fTextWidth) * 0.50 + 0.50;
}

function Clear ()
{
	m_VertSB.pos=0.00;
	m_SelectedItem=None;
	Items.Clear();
}

function KeyDown (int Key, float X, float Y)
{
	local UWindowListBoxItem TempItem;
	local UWindowListBoxItem OldSelection;

	if ( m_SelectedItem == None )
	{
		if ( Items.Count() > 0 )
		{
			TempItem=CheckForNextItem(UWindowListBoxItem(Items.Next));
			if ( TempItem != None )
			{
				SetSelectedItem(TempItem);
			}
		}
		return;
	}
	OldSelection=m_SelectedItem;
	switch (Key)
	{
/*		case Root.Console.38:
		TempItem=CheckForPrevItem(m_SelectedItem);
		if ( TempItem != None )
		{
			SetSelectedItem(TempItem);
		}
		break;
		case Root.Console.40:
		TempItem=CheckForNextItem(m_SelectedItem);
		if ( TempItem != None )
		{
			SetSelectedItem(TempItem);
		}
		break;
		case Root.Console.36:
		TempItem=CheckForNextItem(UWindowListBoxItem(Items));
		if ( TempItem != None )
		{
			SetSelectedItem(TempItem);
		}
		break;
		case Root.Console.35:
		TempItem=CheckForLastItem(UWindowListBoxItem(Items.Last));
		if ( TempItem != None )
		{
			SetSelectedItem(TempItem);
		}
		break;
		case Root.Console.13:
		if (  !m_bIgnoreUserClicks )
		{
			DoubleClickItem(m_SelectedItem);
		}
		break;
		case Root.Console.34:
		TempItem=CheckForPageDown(m_SelectedItem);
		if ( TempItem != None )
		{
			SetSelectedItem(TempItem);
		}
		break;
		case Root.Console.33:
		TempItem=CheckForPageUp(m_SelectedItem);
		if ( TempItem != None )
		{
			SetSelectedItem(TempItem);
		}
		break;
		case Root.Console.27:
		CancelAcceptsFocus();
		break;
		default:
		break;*/
	}
	if ( OldSelection != m_SelectedItem )
	{
		MakeSelectedVisible();
	}
	Super.KeyDown(Key,X,Y);
}

function UWindowListBoxItem CheckForNextItem (UWindowListBoxItem _StartItem)
{
	local UWindowListBoxItem TempItem;
	local bool bIsASeparator;

	if ( _StartItem == None )
	{
		return None;
	}
	TempItem=UWindowListBoxItem(_StartItem.Next);
	if ( TempItem == None )
	{
		return None;
	}
	if ( IsASeparatorItem() )
	{
		bIsASeparator=R6WindowListBoxItem(TempItem).m_IsSeparator;
	}
JL0057:
	if ( TempItem.m_bDisabled || bIsASeparator )
	{
		TempItem=UWindowListBoxItem(TempItem.Next);
		if ( TempItem == None )
		{
			return None;
		}
		if ( IsASeparatorItem() )
		{
			bIsASeparator=R6WindowListBoxItem(TempItem).m_IsSeparator;
		}
		goto JL0057;
	}
	return TempItem;
}

function UWindowListBoxItem CheckForPrevItem (UWindowListBoxItem _StartItem)
{
	local UWindowListBoxItem TempItem;
	local bool bIsASeparator;

	if ( _StartItem == None )
	{
		return None;
	}
	TempItem=UWindowListBoxItem(_StartItem.Prev);
	if ( (TempItem == Items.Sentinel) || (TempItem == None) )
	{
		return None;
	}
	if ( IsASeparatorItem() )
	{
		bIsASeparator=R6WindowListBoxItem(TempItem).m_IsSeparator;
	}
JL0071:
	if ( TempItem.m_bDisabled || bIsASeparator )
	{
		TempItem=UWindowListBoxItem(TempItem.Prev);
		if ( (TempItem == None) || (TempItem == UWindowListBoxItem(Items)) )
		{
			return None;
		}
		if ( IsASeparatorItem() )
		{
			bIsASeparator=R6WindowListBoxItem(TempItem).m_IsSeparator;
		}
		goto JL0071;
	}
	return TempItem;
}

function UWindowListBoxItem CheckForLastItem (UWindowListBoxItem _LastItem)
{
	local bool bIsASeparator;

	if ( _LastItem == None )
	{
		return None;
	}
	if ( IsASeparatorItem() )
	{
		bIsASeparator=R6WindowListBoxItem(_LastItem).m_IsSeparator;
	}
	if ( _LastItem.m_bDisabled || bIsASeparator )
	{
		return CheckForPrevItem(_LastItem);
	}
	return _LastItem;
}

function UWindowListBoxItem CheckForPageDown (UWindowListBoxItem _StartItem)
{
	local UWindowListBoxItem TempItem;
	local UWindowListBoxItem ValidItem;
	local int i;
	local int iMaxItemsDisplayed;
	local bool bIsASeparator;

	if ( _StartItem == None )
	{
		return None;
	}
	TempItem=_StartItem;
	i=1;
	ValidItem=TempItem;
	iMaxItemsDisplayed=GetSizeOfList() / GetSizeOfAnItem(TempItem);
JL0045:
	if ( i < iMaxItemsDisplayed )
	{
		TempItem=UWindowListBoxItem(TempItem.Next);
		if ( (TempItem == None) || (i == m_iTotItemsDisplayed) )
		{
			return ValidItem;
		}
		if ( TempItem.ShowThisItem() )
		{
			i++;
			ValidItem=TempItem;
		}
		goto JL0045;
	}
	return CheckForNextItem(TempItem);
}

function UWindowListBoxItem CheckForPageUp (UWindowListBoxItem _StartItem)
{
	local UWindowListBoxItem TempItem;
	local UWindowListBoxItem ValidItem;
	local int i;
	local int iMaxItemsDisplayed;
	local bool bIsASeparator;

	if ( _StartItem == None )
	{
		return None;
	}
	TempItem=_StartItem;
	i=1;
	ValidItem=TempItem;
	iMaxItemsDisplayed=GetSizeOfList() / GetSizeOfAnItem(TempItem);
JL0045:
	if ( i < iMaxItemsDisplayed )
	{
		TempItem=UWindowListBoxItem(TempItem.Prev);
		if ( (TempItem == None) || (i == m_iTotItemsDisplayed) || (TempItem == UWindowListBoxItem(Items)) )
		{
			return ValidItem;
		}
		if ( TempItem.ShowThisItem() )
		{
			i++;
			ValidItem=TempItem;
		}
		goto JL0045;
	}
	return CheckForPrevItem(TempItem);
}

function bool SwapItem (UWindowListBoxItem _pItem, bool _bUp)
{
	local UWindowListBoxItem TempItem;
	local UWindowListBoxItem BkpItem;

	if ( _pItem == None )
	{
		return False;
	}
	TempItem=_pItem;
	if ( _bUp )
	{
		TempItem=UWindowListBoxItem(TempItem.Prev);
		if ( (TempItem == None) || (TempItem == UWindowListBoxItem(Items)) )
		{
			return False;
		}
		BkpItem=_pItem;
		_pItem.Remove();
		TempItem.InsertItemBefore(BkpItem);
	}
	else
	{
		TempItem=UWindowListBoxItem(TempItem.Next);
		if ( TempItem == None )
		{
			return False;
		}
		BkpItem=_pItem;
		_pItem.Remove();
		TempItem.InsertItemAfter(BkpItem);
	}
	MakeSelectedVisible();
	return True;
}

function bool IsASeparatorItem ()
{
	return ListClass == Class'R6WindowListBoxItem';
}

function KeyFocusEnter ()
{
	SetAcceptsFocus();
}

function KeyFocusExit ()
{
	CancelAcceptsFocus();
}

defaultproperties
{
    m_fItemHeight=10.00
    m_fSpaceBetItem=4.00
    m_fXItemOffset=2.00
    m_SBClass=Class'R6WindowVScrollbar'
    m_vMouseOverWindow=(R=239,G=209,B=129,A=0)
    ListClass=Class'UWindow.UWindowListBoxItem'
}
/*
    m_TIcon=Texture'R6MenuTextures.TeamBarIcon'
*/

