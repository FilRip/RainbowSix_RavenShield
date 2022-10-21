//================================================================================
// R6MenuPopupListButton.
//================================================================================
class R6MenuPopupListButton extends R6WindowListRadioButton;

var const int m_iNbButton;
var bool bInitialized;
var R6WindowListButtonItem m_ButtonItem[10];
var Texture m_SeperatorLineTexture;
var Font m_FontForButtons;
var Region m_SeperatorLineRegion;

function BeforePaint (Canvas C, float MouseX, float MouseY)
{
	local int i;
	local int iCurrentNbButton;
	local float fWidth;
	local float fHeight;
	local float fMaxWidth;
	local float fMaxHeight;
	local bool bNeedRisize;

	if ( bInitialized == False )
	{
		bInitialized=True;
		C.Font=Root.Fonts[0];
		i=0;
JL003A:
		if ( i < m_iNbButton )
		{
			if ( (m_ButtonItem[i] != None) && (m_ButtonItem[i].m_Button != None) )
			{
				TextSize(C,m_ButtonItem[i].m_Button.Text,fWidth,fHeight);
				if ( R6MenuPopUpStayDownButton(m_ButtonItem[i].m_Button).m_bSubMenu == True )
				{
					fWidth += 6;
				}
				if ( fWidth > fMaxWidth )
				{
					fMaxWidth=fWidth;
				}
				if ( fHeight > fMaxHeight )
				{
					fMaxHeight=fHeight;
				}
			}
			i++;
			goto JL003A;
		}
		WinWidth=fMaxWidth + 12;
		m_fItemHeight=fMaxHeight + 6;
		iCurrentNbButton=0;
		i=0;
JL014B:
		if ( i < m_iNbButton )
		{
			if ( (m_ButtonItem[i] != None) && (m_ButtonItem[i].m_Button != None) )
			{
				m_ButtonItem[i].m_Button.WinWidth=WinWidth;
				m_ButtonItem[i].m_Button.WinHeight=m_fItemHeight;
				iCurrentNbButton++;
			}
			i++;
			goto JL014B;
		}
		WinHeight=m_fItemHeight * iCurrentNbButton + iCurrentNbButton - 1;
		ParentWindow.Resized();
	}
}

function Paint (Canvas C, float MouseX, float MouseY)
{
	local float X;
	local float Y;
	local UWindowList CurItem;
	local Color lcolor;

	lcolor=Root.Colors.TeamColor[R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam];
	C.SetDrawColor(lcolor.R,lcolor.G,lcolor.B,Root.Colors.PopUpAlphaFactor);
	if ( m_fItemWidth == 0 )
	{
		m_fItemWidth=WinWidth;
	}
	X=(WinWidth - m_fItemWidth) / 2;
	CurItem=Items.Next;
JL00B9:
	if ( CurItem != None )
	{
		R6WindowListButtonItem(CurItem).m_Button.ShowWindow();
		DrawItem(C,CurItem,X,Y,m_fItemWidth,m_fItemHeight);
		Y += m_fItemHeight;
		if ( Y < WinHeight )
		{
//			C.Style=GetPlayerOwner().5;
			DrawStretchedTextureSegment(C,X,Y,m_SeperatorLineRegion.W,m_SeperatorLineRegion.H,m_SeperatorLineRegion.X,m_SeperatorLineRegion.Y,m_SeperatorLineRegion.W,m_SeperatorLineRegion.H,m_SeperatorLineTexture);
//			C.Style=GetPlayerOwner().1;
			Y += m_SeperatorLineRegion.H;
		}
		if ( Y >= WinHeight )
		{
			Y=0.00;
			X += WinWidth;
		}
		CurItem=CurItem.Next;
		goto JL00B9;
	}
	C.SetDrawColor(255,255,255);
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

function ChangeItemsSize (float fNewWidth)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_iNbButton )
	{
		if ( (m_ButtonItem[i] != None) && (m_ButtonItem[i].m_Button != None) )
		{
			m_ButtonItem[i].m_Button.WinWidth=fNewWidth;
		}
		i++;
		goto JL0007;
	}
}

defaultproperties
{
    m_SeperatorLineRegion=(X=5251590,Y=570753024,W=62,H=2368004)
}
/*
    m_SeperatorLineTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

