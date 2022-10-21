//================================================================================
// R6WindowTextListBox.
//================================================================================
class R6WindowTextListBox extends R6WindowListBox;

var ERenderStyle m_BGRenderStyle;
var float m_fFontSpacing;
var Texture m_BGSelTexture;
var Font m_Font;
var Font m_FontSeparator;
var Color m_BGSelColor;
var Region m_BGSelRegion;
var Color m_SelTextColor;
var Color m_SeparatorTextColor;
var Color m_DisableTextColor;
const C_iSEL_BORDER_WIDTH= 2;

function Created ()
{
	Super.Created();
	m_Font=Root.Fonts[6];
	m_FontSeparator=Root.Fonts[11];
	TextColor=Root.Colors.m_LisBoxNormalTextColor;
	m_SelTextColor=Root.Colors.m_LisBoxSelectedTextColor;
	m_BGSelColor=Root.Colors.m_LisBoxSelectionColor;
	m_SeparatorTextColor=Root.Colors.m_LisBoxSeparatorTextColor;
	m_DisableTextColor=Root.Colors.m_LisBoxDisabledTextColor;
//	m_BGRenderStyle=5;
	m_VertSB.SetHideWhenDisable(True);
}

function BeforePaint (Canvas C, float fMouseX, float fMouseY)
{
	m_VertSB.SetBorderColor(m_BorderColor);
}

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	if (  !m_bSkipDrawBorders )
	{
		R6WindowLookAndFeel(LookAndFeel).R6List_DrawBackground(self,C);
	}
	Super.Paint(C,fMouseX,fMouseY);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local string szToDisplay;
	local float TextY;
	local float tW;
	local float tH;
	local float fTemp;
	local UWindowListBoxItem pListBoxItem;

	pListBoxItem=UWindowListBoxItem(Item);
	if ( pListBoxItem.HelpText != "" )
	{
		C.Font=m_Font;
		C.SpaceX=m_fFontSpacing;
		if ( m_bForceCaps )
		{
			szToDisplay=TextSize(C,Caps(pListBoxItem.HelpText),tW,tH,W);
		}
		else
		{
			szToDisplay=TextSize(C,pListBoxItem.HelpText,tW,tH,W);
		}
		if ( pListBoxItem.bSelected )
		{
			if ( m_BGSelTexture != None )
			{
				C.Style=m_BGRenderStyle;
				C.SetDrawColor(m_BGSelColor.R,m_BGSelColor.G,m_BGSelColor.B);
				DrawStretchedTextureSegment(C,X,Y,W,H - m_fSpaceBetItem,m_BGSelRegion.X,m_BGSelRegion.Y,m_BGSelRegion.W,m_BGSelRegion.H,m_BGSelTexture);
			}
			C.SetDrawColor(m_SelTextColor.R,m_SelTextColor.G,m_SelTextColor.B);
		}
		else
		{
			if ( pListBoxItem.m_bDisabled )
			{
				C.SetDrawColor(m_DisableTextColor.R,m_DisableTextColor.G,m_DisableTextColor.B);
			}
			else
			{
				if ( (R6WindowListBoxItem(Item) != None) && R6WindowListBoxItem(Item).m_IsSeparator )
				{
					C.Font=m_FontSeparator;
					C.SetDrawColor(m_SeparatorTextColor.R,m_SeparatorTextColor.G,m_SeparatorTextColor.B);
				}
				else
				{
					C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
				}
			}
		}
		C.Style=5;
		ClipText(C,X,Y,szToDisplay,True);
		if ( pListBoxItem.m_bUseSubText )
		{
			fTemp=Y + tH;
			C.Font=pListBoxItem.m_stSubText.FontSubText;
			TextSize(C,pListBoxItem.m_stSubText.szGameTypeSelect,tW,tH);
			TextY=(pListBoxItem.m_stSubText.fHeight - tH) / 2;
			TextY=TextY + 0.50;
			ClipTextWidth(C,X + pListBoxItem.m_stSubText.fXOffset,fTemp + TextY,pListBoxItem.m_stSubText.szGameTypeSelect,W - 12);
		}
	}
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
			}
			m_SelectedItem=NewSelected;
			if ( m_SelectedItem != None )
			{
				m_SelectedItem.bSelected=True;
			}
			Notify(2);
		}
	}
}

function UWindowList FindItemWithName (string _ItemName)
{
	local UWindowList CurItem;

	if ( _ItemName == "" )
	{
		return None;
	}
	CurItem=Items.Next;
JL0022:
	if ( CurItem != None )
	{
		if (  !R6WindowListBoxItem(CurItem).m_IsSeparator )
		{
			if ( R6WindowListBoxItem(CurItem).HelpText == _ItemName )
			{
				goto JL007D;
			}
		}
		CurItem=CurItem.Next;
		goto JL0022;
	}
JL007D:
	return CurItem;
}

defaultproperties
{
    m_BGSelColor=(R=128,G=0,B=0,A=0)
    m_BGSelRegion=(X=16589323,Y=571015168,W=2,H=860680)
    m_SelTextColor=(R=255,G=255,B=255,A=0)
    m_SeparatorTextColor=(R=255,G=255,B=255,A=0)
    m_fItemHeight=12.00
    m_fXItemOffset=5.00
    ListClass=Class'R6WindowListBoxItem'
    TextColor=(R=255,G=255,B=255,A=0)
}
/*
    m_BGSelTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

