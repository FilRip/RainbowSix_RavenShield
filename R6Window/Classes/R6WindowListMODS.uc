//================================================================================
// R6WindowListMODS.
//================================================================================
class R6WindowListMODS extends R6WindowTextListBox;

enum eItemState {
	eIS_Normal,
	eIS_Disable,
	eIS_Selected,
	eIS_CurrentChoice
};

struct stItemProperties
{
	var string szText;
	var Font TextFont;
	var float fXPos;
	var float fYPos;
	var float fWidth;
	var float fHeigth;
	var int iLineNumber;
	var TextAlign eAlignment;
};

var Color m_CurrentChoiceColor;

function Created ()
{
	Super.Created();
	m_CurrentChoiceColor=Root.Colors.Yellow;
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
		fdrawWidth=WinWidth - 2 * m_fXItemOffset;
	}
	else
	{
		fdrawWidth=WinWidth - m_VertSB.WinWidth - 2 * m_fXItemOffset;
	}
	m_iTotItemsDisplayed=0;
	Y=0.00;
JL0145:
	if ( (Y + fItemHeight <= fListHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			DrawItem(C,CurItem,m_fXItemOffset,Y,fdrawWidth,fItemHeight);
			Y=Y + fItemHeight;
			m_iTotItemsDisplayed++;
		}
		CurItem=CurItem.Next;
		goto JL0145;
	}
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local UWindowListBoxItem pIt;
	local string szToDisplay;
	local float tW;
	local float tH;
	local float fYPos;
	local int i;
	local int j;
	local stItemProperties pCurrentItem;

	pIt=UWindowListBoxItem(Item);
	if ( (pIt != None) && (pIt.m_AItemProperties.Length == 0) )
	{
		return;
	}
	if ( pIt.bSelected )
	{
		if ( m_BGSelTexture != None )
		{
			C.Style=m_BGRenderStyle;
			C.SetDrawColor(m_BGSelColor.R,m_BGSelColor.G,m_BGSelColor.B);
			DrawStretchedTextureSegment(C,X,Y,W,H,m_BGSelRegion.X,m_BGSelRegion.Y,m_BGSelRegion.W,m_BGSelRegion.H,m_BGSelTexture);
		}
	}
	i=0;
JL00EA:
	if ( i < pIt.m_AItemProperties.Length )
	{
//		pCurrentItem=pIt.m_AItemProperties[i];
		C.Font=pCurrentItem.TextFont;
		C.SpaceX=m_fFontSpacing;
		if ( m_bForceCaps )
		{
			szToDisplay=TextSize(C,Caps(pCurrentItem.szText),tW,tH,pCurrentItem.fWidth);
		}
		else
		{
			szToDisplay=TextSize(C,pCurrentItem.szText,tW,tH,pCurrentItem.fWidth);
		}
		if ( pIt.m_bDisabled )
		{
			C.SetDrawColor(m_DisableTextColor.R,m_DisableTextColor.G,m_DisableTextColor.B);
		}
		else
		{
			if ( pIt.m_iItemID == 3 )
			{
				C.SetDrawColor(m_CurrentChoiceColor.R,m_CurrentChoiceColor.G,m_CurrentChoiceColor.B);
			}
			else
			{
				C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
			}
		}
		fYPos=(pCurrentItem.fHeigth - tH) / 2;
		fYPos=fYPos + 0.50;
		fYPos += pCurrentItem.fYPos;
		if ( pCurrentItem.iLineNumber != 0 )
		{
			j=0;
JL02C2:
			if ( j < pCurrentItem.iLineNumber )
			{
				fYPos += pCurrentItem.fHeigth;
				j++;
				goto JL02C2;
			}
		}
		switch (pCurrentItem.eAlignment)
		{
			case TA_Right:
			C.SetPos(pCurrentItem.fXPos - tW,Y + fYPos);
			break;
			case TA_Left:
			C.SetPos(pCurrentItem.fXPos,Y + fYPos);
			break;
			case TA_Center:
			C.SetPos(pCurrentItem.fXPos - tW / 2.00,Y + fYPos);
			break;
			default:
		}
		C.DrawText(szToDisplay);
		i++;
		goto JL00EA;
	}
}

function float GetSizeOfAnItem (UWindowList _pItem)
{
	local float fTotalHeight;
	local int i;
	local int iLineNumber;

	iLineNumber=0;
	i=0;
JL000E:
	if ( i < UWindowListBoxItem(_pItem).m_AItemProperties.Length )
	{
		if ( UWindowListBoxItem(_pItem).m_AItemProperties[i].iLineNumber == iLineNumber )
		{
			iLineNumber++;
			fTotalHeight += UWindowListBoxItem(_pItem).m_AItemProperties[i].fHeigth;
		}
		i++;
		goto JL000E;
	}
	return fTotalHeight;
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	local bool bNotify;

	if ( (NewSelected != None) && (m_SelectedItem != NewSelected) )
	{
		if ( NewSelected.m_bDisabled )
		{
			return;
		}
		bNotify=True;
		if ( R6WindowListBoxItem(NewSelected) != None )
		{
			bNotify= !R6WindowListBoxItem(NewSelected).m_IsSeparator;
		}
		if ( bNotify )
		{
			if ( m_SelectedItem != None )
			{
				m_SelectedItem.bSelected=False;
				if ( m_SelectedItem.m_iItemID != 3 )
				{
					m_SelectedItem.m_iItemID=0;
				}
			}
			m_SelectedItem=NewSelected;
			if ( m_SelectedItem != None )
			{
				m_SelectedItem.bSelected=True;
				if ( m_SelectedItem.m_iItemID != 3 )
				{
					m_SelectedItem.m_iItemID=2;
				}
			}
			Notify(2);
		}
	}
}

function bool SetItemState (UWindowListBoxItem _NewItem, eItemState _eISState, optional bool _bForceSelection)
{
	if ( _NewItem == None )
	{
		return False;
	}
	_NewItem.m_bDisabled=False;
	switch (_eISState)
	{
/*		case 0:
		_NewItem.m_iItemID=0;
		break;
		case 1:
		_NewItem.m_iItemID=1;
		_NewItem.m_bDisabled=True;
		break;
		case 2:
		_NewItem.m_iItemID=2;
		_NewItem.bSelected=True;
		m_SelectedItem=_NewItem;
		break;
		case 3:
		_NewItem.m_iItemID=3;
		if ( _bForceSelection )
		{
			_NewItem.bSelected=True;
			m_SelectedItem=_NewItem;
		}
		break;
		default:*/
	}
	return True;
}

function ActivateMOD ()
{
	local UWindowListBoxItem pListBoxItem;

	pListBoxItem=UWindowListBoxItem(FindCurrentMOD());
	if ( pListBoxItem != None )
	{
		if ( pListBoxItem == m_SelectedItem )
		{
			return;
		}
		pListBoxItem.m_iItemID=0;
		if ( m_SelectedItem != None )
		{
			m_SelectedItem.m_iItemID=3;
			Class'Actor'.static.GetModMgr().SetCurrentMod(m_SelectedItem.HelpText,True,Root.Console,GetPlayerOwner().XLevel);
//			R6Console(Root.Console).m_eLastPreviousWID=Root.m_ePrevWidgetInUse;
//			R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).9);
		}
	}
}

function UWindowList FindCurrentMOD ()
{
	local UWindowList CurItem;

	CurItem=Items.Next;
JL0014:
	if ( CurItem != None )
	{
		if (  !R6WindowListBoxItem(CurItem).m_IsSeparator )
		{
			if ( R6WindowListBoxItem(CurItem).m_iItemID == 3 )
			{
				goto JL006E;
			}
		}
		CurItem=CurItem.Next;
		goto JL0014;
	}
JL006E:
	return CurItem;
}

defaultproperties
{
    m_fXItemOffset=2.00
    ListClass=Class'UWindow.UWindowListBoxItem'
}
