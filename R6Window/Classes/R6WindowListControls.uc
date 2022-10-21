//================================================================================
// R6WindowListControls.
//================================================================================
class R6WindowListControls extends R6WindowTextListBox;

var float m_fXOffSet;
var UWindowListBoxItem m_pPreviousItem;
var Texture m_BorderTexture;
var Region m_BorderTextureRegion;

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
		fdrawWidth=WinWidth;
	}
	else
	{
		fdrawWidth=WinWidth - m_VertSB.WinWidth;
	}
	m_iTotItemsDisplayed=0;
	Y=LAF.m_SBHBorder.H;
JL013B:
	if ( (Y + fItemHeight <= fListHeight) && (CurItem != None) )
	{
		if ( CurItem.ShowThisItem() )
		{
			if ( UWindowListBoxItem(CurItem).m_bImALine )
			{
				DrawItem(C,CurItem,m_fXOffSet,Y,fdrawWidth,fItemHeight);
			}
			else
			{
				DrawItem(C,CurItem,m_fXOffSet,Y,fdrawWidth - m_fXOffSet,fItemHeight);
			}
			Y=Y + fItemHeight;
			m_iTotItemsDisplayed++;
		}
		CurItem=CurItem.Next;
		goto JL013B;
	}
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local float fXPos;
	local float fW;
	local float fH;
	local float fTextY;
	local int temp;
	local Texture t;
	local UWindowListBoxItem pListBoxItem;

	pListBoxItem=UWindowListBoxItem(Item);
	C.SetDrawColor(UWindowListBoxItem(Item).m_vItemColor.R,UWindowListBoxItem(Item).m_vItemColor.G,UWindowListBoxItem(Item).m_vItemColor.B);
	if ( pListBoxItem.m_bImALine )
	{
		C.Style=5;
		DrawStretchedTextureSegment(C,1.00,Y + H * 0.50,W - 1,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	}
	else
	{
		if ( pListBoxItem.HelpText != "" )
		{
			C.Style=5;
			C.Font=Root.Fonts[11];
			C.SpaceX=m_fFontSpacing;
			TextSize(C,UWindowListBoxItem(Item).HelpText,fW,fH);
			fTextY=(m_fItemHeight - fH) * 0.50;
			fTextY=TextY + 0.50;
			if ( pListBoxItem.m_szActionKey != "" )
			{
				t=Texture'WhiteTexture';
				C.DrawColor=Root.Colors.Black;
				C.Style=5;
				C.SetDrawColor(C.DrawColor.R,C.DrawColor.G,C.DrawColor.B,50);
				DrawStretchedTexture(C,pListBoxItem.m_fXFakeEditBox,Y + fTextY,pListBoxItem.m_fWFakeEditBox,H,t);
				C.SetDrawColor(pListBoxItem.m_vItemColor.R,pListBoxItem.m_vItemColor.G,pListBoxItem.m_vItemColor.B);
				TextSize(C,pListBoxItem.m_szFakeEditBoxValue,fW,fH);
				fXPos=pListBoxItem.m_fXFakeEditBox + (pListBoxItem.m_fWFakeEditBox - fW) / 2;
				ClipTextWidth(C,fXPos,Y + fTextY,pListBoxItem.m_szFakeEditBoxValue,W);
			}
			ClipTextWidth(C,X + 2,Y + fTextY,pListBoxItem.HelpText,W);
		}
	}
}

function MouseMove (float X, float Y)
{
	Super.MouseMove(X,Y);
	ManageOverEffect(X,Y);
}

function MouseLeave ()
{
	Super.MouseLeave();
	ManageOverEffect(0.00,0.00);
}

function ManageOverEffect (float X, float Y)
{
	local UWindowListBoxItem OverItem;

	OverItem=GetItemAt(X,Y);
	if ( m_pPreviousItem != None )
	{
		m_pPreviousItem.m_vItemColor=Root.Colors.White;
		m_pPreviousItem=None;
		ToolTip("");
	}
	if ( OverItem != None )
	{
		if (  !OverItem.m_bNotAffectByNotify )
		{
			OverItem.m_vItemColor=Root.Colors.BlueLight;
			ToolTip(OverItem.m_szToolTip);
			m_pPreviousItem=OverItem;
		}
	}
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	if ( NewSelected != None )
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
		if ( m_pPreviousItem != None )
		{
			Notify(2);
		}
	}
}

defaultproperties
{
    m_BorderTextureRegion=(X=74249,Y=570949632,W=1,H=0)
    m_fItemHeight=20.00
    m_fSpaceBetItem=0.00
}
/*
    m_BorderTexture=Texture'UWindow.WhiteTexture'
*/

