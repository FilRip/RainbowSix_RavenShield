//================================================================================
// R6WindowTextIconsListBox.
//================================================================================
class R6WindowTextIconsListBox extends R6WindowListBox;

var ERenderStyle m_BGRenderStyle;
var bool bScrollable;
var bool m_IgnoreAllreadySelected;
var float m_fFontSpacing;
var Texture m_BGSelTexture;
var Texture m_HealthIconTexture;
var Font m_Font;
var Font m_FontSeparator;
var Color m_BGSelColor;
var Region m_BGSelRegion;
var Color m_SeparatorTextColor;
var Color m_SelTextColor;
var Color m_DisabledTextColor;
const C_iDISTANCE_BETWEEN_ICON= 4;
const C_iFIRST_ICON_XPOS= 3;

function Created ()
{
	Super.Created();
	m_Font=Root.Fonts[6];
	m_FontSeparator=Root.Fonts[11];
	TextColor=Root.Colors.m_LisBoxNormalTextColor;
	m_SelTextColor=Root.Colors.m_LisBoxSelectedTextColor;
	m_BGSelColor=Root.Colors.m_LisBoxSelectionColor;
	m_DisabledTextColor=Root.Colors.m_LisBoxDisabledTextColor;
	m_SeparatorTextColor=Root.Colors.m_LisBoxSpectatorTextColor;
//	m_BGRenderStyle=5;
}

function BeforePaint (Canvas C, float fMouseX, float fMouseY)
{
	if ( m_VertSB != None )
	{
		m_VertSB.SetBorderColor(m_BorderColor);
	}
	Super.BeforePaint(C,fMouseX,fMouseY);
}

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	R6WindowLookAndFeel(LookAndFeel).R6List_DrawBackground(self,C);
	Super.Paint(C,fMouseX,fMouseY);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local R6WindowListBoxItem pItem;
	local Region RIcon;
	local string szClipText;
	local float tW;
	local float tH;
	local float TextX;
	local float TextY;

	pItem=R6WindowListBoxItem(Item);
	if ( pItem.bSelected )
	{
		if ( m_BGSelTexture != None )
		{
			C.Style=m_BGRenderStyle;
			C.SetDrawColor(m_BGSelColor.R,m_BGSelColor.G,m_BGSelColor.B);
			DrawStretchedTextureSegment(C,X,Y,W,H,m_BGSelRegion.X,m_BGSelRegion.Y,m_BGSelRegion.W,m_BGSelRegion.H,m_BGSelTexture);
		}
	}
	TextX=X;
	if ( pItem.m_Icon != None )
	{
		if ( pItem.m_addedToSubList )
		{
			RIcon=pItem.m_IconRegion;
		}
		else
		{
			RIcon=pItem.m_IconSelectedRegion;
		}
		C.Style=5;
		C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
		TextX += 3;
		DrawStretchedTextureSegment(C,TextX,GetYIconPos(Y,H,RIcon.H),RIcon.W,RIcon.H,RIcon.X,RIcon.Y,RIcon.W,RIcon.H,pItem.m_Icon);
		TextX += 4 + RIcon.W;
		if ( pItem.m_Object.IsA('R6Operative') )
		{
			if ( pItem.m_addedToSubList )
			{
				C.SetDrawColor(m_DisabledTextColor.R,m_DisabledTextColor.G,m_DisabledTextColor.B);
			}
			TextX += 4 + DrawHealthIcon(C,TextX,Y,H,R6Operative(pItem.m_Object).m_iHealth);
		}
	}
	C.Font=m_Font;
	if ( pItem.m_IsSeparator )
	{
		C.Font=m_FontSeparator;
		C.SetDrawColor(m_SeparatorTextColor.R,m_SeparatorTextColor.G,m_SeparatorTextColor.B);
	}
	else
	{
		if ( pItem.m_addedToSubList )
		{
			C.SetDrawColor(m_DisabledTextColor.R,m_DisabledTextColor.G,m_DisabledTextColor.B);
		}
		else
		{
			if ( pItem.bSelected )
			{
				C.SetDrawColor(m_SelTextColor.R,m_SelTextColor.G,m_SelTextColor.B);
			}
			else
			{
				C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
			}
		}
	}
	C.SpaceX=m_fFontSpacing;
	C.Style=5;
	szClipText=TextSize(C,pItem.HelpText,tW,tH,W - TextX,m_fFontSpacing);
	TextY=(H - tH) * 0.50;
	TextY=TextY + 0.50;
	C.SetPos(TextX,Y + TextY);
	C.DrawText(szClipText);
}

function float DrawHealthIcon (Canvas C, float _fX, float _fY, float _fH, int _iHealthStatus)
{
	local Region RHealthIcon;

	RHealthIcon=GetHealthIconRegion(_iHealthStatus);
	DrawStretchedTextureSegment(C,_fX,GetYIconPos(_fY,_fH,RHealthIcon.H),RHealthIcon.W,RHealthIcon.H,RHealthIcon.X,RHealthIcon.Y,RHealthIcon.W,RHealthIcon.H,m_HealthIconTexture);
	return RHealthIcon.W;
}

function float GetYIconPos (float _fYItemPos, float _fItemHeight, float _fIconHeight)
{
	local float fTemp;

	fTemp=(_fItemHeight - _fIconHeight) * 0.50;
	fTemp=fTemp + 0.50 + _fYItemPos;
	return fTemp;
}

function Region GetHealthIconRegion (int _iOperativeHealth)
{
	local Region RTemp;

	RTemp.X=500;
	RTemp.W=8;
	RTemp.H=8;
	switch (_iOperativeHealth)
	{
		case 0:
		RTemp.Y=0;
		break;
		case 1:
		RTemp.Y=8;
		break;
		case 2:
		case 3:
		RTemp.Y=16;
		break;
		default:
	}
	return RTemp;
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	if ( (NewSelected != None) && (R6WindowListBoxItem(NewSelected).m_IsSeparator == False) )
	{
		if ( m_IgnoreAllreadySelected && (m_SelectedItem == NewSelected) )
		{
			return;
		}
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

function SetScrollable (bool newScrollable)
{
	bScrollable=newScrollable;
	if ( newScrollable )
	{
		m_VertSB=R6WindowVScrollbar(CreateWindow(m_SBClass,WinWidth - LookAndFeel.Size_ScrollbarWidth,0.00,LookAndFeel.Size_ScrollbarWidth,WinHeight));
		m_VertSB.bAlwaysOnTop=True;
	}
	else
	{
		if ( m_VertSB != None )
		{
			m_VertSB.Close();
			m_VertSB=None;
		}
	}
}

defaultproperties
{
    m_IgnoreAllreadySelected=True
    m_BGSelColor=(R=128,G=0,B=0,A=0)
    m_BGSelRegion=(X=16589323,Y=571015168,W=2,H=860680)
    m_SeparatorTextColor=(R=255,G=255,B=255,A=0)
    m_SelTextColor=(R=255,G=255,B=255,A=0)
    m_DisabledTextColor=(R=136,G=140,B=141,A=0)
    m_fItemHeight=11.00
    m_fSpaceBetItem=0.00
    ListClass=Class'R6WindowListBoxItem'
    TextColor=(R=255,G=255,B=255,A=0)
}
/*
    m_BGSelTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_HealthIconTexture=Texture'R6HUD.HUDElements'
*/

