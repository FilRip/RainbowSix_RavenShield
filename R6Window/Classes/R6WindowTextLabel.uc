//================================================================================
// R6WindowTextLabel.
//================================================================================
class R6WindowTextLabel extends UWindowWindow;

var TextAlign Align;
var int m_TextDrawstyle;
var int m_DrawStyle;
var bool m_bDrawBorders;
var bool m_bRefresh;
var bool m_bUseBGColor;
var bool m_bDrawBG;
var bool m_bUseExtRegion;
var bool m_bResizeToText;
var bool m_bFixedYPos;
var float TextX;
var float TextY;
var float m_fFontSpacing;
var float m_fLMarge;
var float m_fHBorderHeight;
var float m_fVBorderWidth;
var float m_fHBorderPadding;
var float m_fVBorderPadding;
var Font m_Font;
var Texture m_BGTexture;
var Texture m_HBorderTexture;
var Texture m_VBorderTexture;
var Region m_BGTextureRegion;
var Region m_HBorderTextureRegion;
var Region m_VBorderTextureRegion;
var Region m_BGExtRegion;
var Color TextColor;
var Color m_BGColor;
var string Text;

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	if ( m_bRefresh )
	{
		m_bRefresh=False;
		if ( Text != "" )
		{
			C.Font=m_Font;
			TextSize(C,Text,W,H);
			switch (Align)
			{
				case TA_Left:
				TextX=m_fLMarge;
				break;
				case TA_Right:
				TextX=WinWidth - W - Len(Text) * m_fFontSpacing - m_fVBorderWidth;
				break;
				case TA_Center:
				TextX=(WinWidth - W) / 2;
				break;
				default:
			}
			if (  !m_bFixedYPos )
			{
				TextY=(WinHeight - H) / 2;
				TextY=TextY + 0.50;
			}
			if ( m_bResizeToText )
			{
				WinWidth=W + Len(Text) * m_fFontSpacing + m_fLMarge;
				if ( Align != 0 )
				{
					WinLeft += TextX - m_fLMarge;
				}
				TextX=m_fLMarge;
				Align=TA_Left;
				m_bResizeToText=False;
			}
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	local Region RTemp;
	local float tempSpace;

	C.Style=m_DrawStyle;
	if ( (m_BGTexture != None) && m_bDrawBG )
	{
		if ( m_bUseBGColor )
		{
			C.SetDrawColor(m_BGColor.R,m_BGColor.G,m_BGColor.B,m_BGColor.A);
		}
		if ( m_bUseExtRegion )
		{
			RTemp.X=m_fVBorderWidth;
			RTemp.Y=m_fHBorderHeight;
			RTemp.W=m_BGExtRegion.W;
			RTemp.H=WinHeight - 2 * m_fHBorderHeight;
			DrawStretchedTextureSegment(C,RTemp.X,RTemp.Y,RTemp.W,RTemp.H,m_BGExtRegion.X,m_BGExtRegion.Y,m_BGExtRegion.W,m_BGExtRegion.H,m_BGTexture);
			RTemp.X += RTemp.W;
			RTemp.W=WinWidth - 2 * RTemp.X;
			DrawStretchedTextureSegment(C,RTemp.X,RTemp.Y,RTemp.W,RTemp.H,m_BGTextureRegion.X,m_BGTextureRegion.Y,m_BGTextureRegion.W,m_BGTextureRegion.H,m_BGTexture);
			RTemp.X += RTemp.W;
			RTemp.W=m_BGExtRegion.W;
			DrawStretchedTextureSegment(C,RTemp.X,RTemp.Y,RTemp.W,RTemp.H,m_BGExtRegion.X + m_BGExtRegion.W,m_BGExtRegion.Y, -m_BGExtRegion.W,m_BGExtRegion.H,m_BGTexture);
		}
		else
		{
			DrawStretchedTextureSegment(C,m_fVBorderWidth,m_fHBorderHeight,WinWidth - 2 * m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight,m_BGTextureRegion.X,m_BGTextureRegion.Y,m_BGTextureRegion.W,m_BGTextureRegion.H,m_BGTexture);
		}
	}
	if ( m_bDrawBorders )
	{
		C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
		if ( m_HBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,m_fHBorderPadding,0.00,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
			DrawStretchedTextureSegment(C,m_fHBorderPadding,WinHeight - m_fHBorderHeight,WinWidth - 2 * m_fHBorderPadding,m_fHBorderHeight,m_HBorderTextureRegion.X,m_HBorderTextureRegion.Y,m_HBorderTextureRegion.W,m_HBorderTextureRegion.H,m_HBorderTexture);
		}
		if ( m_VBorderTexture != None )
		{
			DrawStretchedTextureSegment(C,0.00,m_fHBorderHeight + m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight - 2 * m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
			DrawStretchedTextureSegment(C,WinWidth - m_fVBorderWidth,m_fHBorderHeight + m_fVBorderPadding,m_fVBorderWidth,WinHeight - 2 * m_fHBorderHeight - 2 * m_fVBorderPadding,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
		}
	}
	if ( Text != "" )
	{
		tempSpace=C.SpaceX;
		C.Font=m_Font;
		C.SpaceX=m_fFontSpacing;
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
		C.Style=m_TextDrawstyle;
		ClipText(C,TextX,TextY,Text,True);
	}
}

function SetProperties (string _text, TextAlign _Align, Font _TypeOfFont, Color _TextColor, bool _bDrawBorders)
{
	Text=_text;
	Align=_Align;
	m_Font=_TypeOfFont;
	TextColor=_TextColor;
	m_bDrawBorders=_bDrawBorders;
	m_bRefresh=True;
}

function SetNewText (string _szNewText, bool _bRefresh)
{
	Text=_szNewText;
	m_bRefresh=_bRefresh;
}

defaultproperties
{
    m_TextDrawstyle=3
    m_DrawStyle=5
    m_bDrawBorders=True
    m_bRefresh=True
    m_fLMarge=2.00
    m_fHBorderHeight=1.00
    m_fVBorderWidth=1.00
    m_BGTextureRegion=(X=6365707,Y=571015168,W=33,H=1516040)
    m_HBorderTextureRegion=(X=4203019,Y=571277312,W=56,H=74249)
    m_VBorderTextureRegion=(X=4203019,Y=571277312,W=56,H=74249)
    TextColor=(R=255,G=255,B=255,A=0)
    m_BGColor=(R=255,G=255,B=255,A=0)
}
/*
    m_BGTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_HBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_VBorderTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

