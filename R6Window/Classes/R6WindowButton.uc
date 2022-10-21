//================================================================================
// R6WindowButton.
//================================================================================
class R6WindowButton extends UWindowButton;

enum eButtonType {
	eNormalButton,
	eCounterButton
};

var eButtonType m_eButtonType;
var int m_iDrawStyle;
var bool m_bResizeToText;
var bool m_bDrawBorders;
var bool m_bDrawSimpleBorder;
var bool m_bDrawSpecialBorder;
var bool m_bSetParam;
var bool m_bDefineBorderColor;
var bool m_bCheckForDownSizeFont;
var float m_fLMarge;
var float m_fRMarge;
var float m_fFontSpacing;
var float m_fDownSizeFontSpacing;
var float m_textSize;
var float m_fTotalButtonsSize;
var float m_fMaxWinWidth;
var float m_fOrgWinLeft;
var R6WindowButton m_pRefButtonPos;
var R6WindowButton m_pPreviousButtonPos;
var Font m_buttonFont;
var Font m_DownSizeFont;
var Texture m_BGSelecTexture;
var Color m_vButtonColor;

function Created ()
{
	Super.Created();
	m_fMaxWinWidth=WinWidth;
	m_fOrgWinLeft=WinLeft;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float TextWidth;

	if ( m_bSetParam )
	{
		m_bSetParam=False;
		if ( Text != "" )
		{
			if ( m_buttonFont != None )
			{
				C.Font=m_buttonFont;
			}
			else
			{
				C.Font=Root.Fonts[Font];
			}
			TextSize(C,Text,W,H);
			TextWidth=W + Len(Text) * m_fFontSpacing;
			switch (Align)
			{
				case TA_Left:
				TextX=m_fLMarge;
				break;
				case TA_Right:
				TextX=WinWidth - m_fRMarge - TextWidth;
				break;
				case TA_Center:
				TextX=(WinWidth - TextWidth) / 2;
				break;
				default:
			}
			TextY=(WinHeight - H) / 2;
			TextY=TextY + 0.50;
			if ( m_bCheckForDownSizeFont )
			{
				m_bCheckForDownSizeFont=False;
				if ( (m_DownSizeFont != None) && (TextX + TextWidth > WinWidth) )
				{
					m_buttonFont=m_DownSizeFont;
					m_fFontSpacing=m_fDownSizeFontSpacing;
				}
				m_bSetParam=m_bResizeToText;
			}
			else
			{
				if ( m_bResizeToText )
				{
					m_textSize=TextWidth;
					WinWidth=FMin(m_textSize + m_fLMarge + m_fRMarge,m_fMaxWinWidth);
					if ( Align != 0 )
					{
						WinLeft=m_fOrgWinLeft;
						WinLeft += TextX - m_fLMarge;
					}
					TextX=m_fLMarge;
					m_bResizeToText=False;
				}
			}
			m_fTotalButtonsSize=WinWidth;
			if ( m_pRefButtonPos != None )
			{
				m_pRefButtonPos.m_fTotalButtonsSize += WinWidth;
			}
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	local float tempSpace;
	local Color vBorderColor;

	C.Style=m_iDrawStyle;
	C.SetDrawColor(m_vButtonColor.R,m_vButtonColor.G,m_vButtonColor.B);
	if ( bDisabled )
	{
		if ( DisabledTexture != None )
		{
			if ( bUseRegion && bStretched )
			{
				DrawStretchedTextureSegment(C,ImageX,ImageY,DisabledRegion.W * RegionScale,DisabledRegion.H * RegionScale,DisabledRegion.X,DisabledRegion.Y,DisabledRegion.W,DisabledRegion.H,DisabledTexture);
			}
			else
			{
				if ( bUseRegion )
				{
					DrawStretchedTextureSegment(C,ImageX,ImageY,DisabledRegion.W * RegionScale,DisabledRegion.H * RegionScale,DisabledRegion.X,DisabledRegion.Y,DisabledRegion.W,DisabledRegion.H,DisabledTexture);
				}
				else
				{
					if ( bStretched )
					{
						DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,DisabledTexture);
					}
					else
					{
						DrawClippedTexture(C,ImageX,ImageY,DisabledTexture);
					}
				}
			}
		}
	}
	else
	{
		if ( bMouseDown )
		{
			if ( DownTexture != None )
			{
				if ( bUseRegion && bStretched )
				{
					DrawStretchedTextureSegment(C,ImageX,ImageY,WinWidth,WinHeight,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
				}
				else
				{
					if ( bUseRegion )
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,DownRegion.W * RegionScale,DownRegion.H * RegionScale,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
					}
					else
					{
						if ( bStretched )
						{
							DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,DownTexture);
						}
						else
						{
							DrawClippedTexture(C,ImageX,ImageY,DownTexture);
						}
					}
				}
			}
		}
		else
		{
			if ( MouseIsOver() )
			{
				if ( OverTexture != None )
				{
					if ( bUseRegion && bStretched )
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,WinWidth,WinHeight,OverRegion.X,OverRegion.Y,OverRegion.W,OverRegion.H,OverTexture);
					}
					else
					{
						if ( bUseRegion )
						{
							DrawStretchedTextureSegment(C,ImageX,ImageY,OverRegion.W * RegionScale,OverRegion.H * RegionScale,OverRegion.X,OverRegion.Y,OverRegion.W,OverRegion.H,OverTexture);
						}
						else
						{
							if ( bStretched )
							{
								DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,OverTexture);
							}
							else
							{
								DrawClippedTexture(C,ImageX,ImageY,OverTexture);
							}
						}
					}
				}
			}
			else
			{
				if ( UpTexture != None )
				{
					if ( bUseRegion && bStretched )
					{
						DrawStretchedTextureSegment(C,ImageX,ImageY,WinWidth,WinHeight,UpRegion.X,UpRegion.Y,UpRegion.W,UpRegion.H,UpTexture);
					}
					else
					{
						if ( bUseRegion )
						{
							DrawStretchedTextureSegment(C,ImageX,ImageY,UpRegion.W * RegionScale,UpRegion.H * RegionScale,UpRegion.X,UpRegion.Y,UpRegion.W,UpRegion.H,UpTexture);
						}
						else
						{
							if ( bStretched )
							{
								DrawStretchedTexture(C,ImageX,ImageY,WinWidth,WinHeight,UpTexture);
							}
							else
							{
								DrawClippedTexture(C,ImageX,ImageY,UpTexture);
							}
						}
					}
				}
			}
		}
	}
	if ( Text != "" )
	{
		if ( m_buttonFont != None )
		{
			C.Font=m_buttonFont;
		}
		else
		{
			C.Font=Root.Fonts[Font];
		}
		C.Style=1;
		tempSpace=C.SpaceX;
		C.SpaceX=m_fFontSpacing;
		if ( Text != "" )
		{
			if ( bDisabled )
			{
				C.SetDrawColor(m_DisabledTextColor.R,m_DisabledTextColor.G,m_DisabledTextColor.B);
				m_BorderColor=m_DisabledTextColor;
			}
			else
			{
				if ( m_bSelected )
				{
					C.SetDrawColor(m_SelectedTextColor.R,m_SelectedTextColor.G,m_SelectedTextColor.B);
					m_BorderColor=m_SelectedTextColor;
				}
				else
				{
					if ( MouseIsOver() )
					{
						C.SetDrawColor(m_OverTextColor.R,m_OverTextColor.G,m_OverTextColor.B);
						m_BorderColor=m_OverTextColor;
					}
					else
					{
						C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
						m_BorderColor=TextColor;
					}
				}
			}
			ClipText(C,TextX,TextY,Text,True);
			C.SpaceX=tempSpace;
		}
	}
	if ( m_bDrawBorders )
	{
		if ( m_bDrawSpecialBorder )
		{
			R6WindowLookAndFeel(LookAndFeel).DrawSpecialButtonBorder(self,C,X,Y);
		}
		else
		{
			if ( m_bDrawSimpleBorder )
			{
				DrawSimpleBorder(C);
			}
			else
			{
				R6WindowLookAndFeel(LookAndFeel).DrawButtonBorder(self,C,m_bDefineBorderColor);
			}
		}
	}
}

function CheckToDownSizeFont (Font _FallBackFont, float _FallBackFontSpacing)
{
	m_DownSizeFont=_FallBackFont;
	m_fDownSizeFontSpacing=_FallBackFontSpacing;
	m_bCheckForDownSizeFont=True;
	m_bSetParam=True;
}

function bool IsFontDownSizingNeeded ()
{
	local float W;
	local float H;
	local float TextWidth;
	local float TextXPos;
	local Canvas C;

	C=Class'Actor'.static.GetCanvas();
	if ( m_buttonFont != None )
	{
		C.Font=m_buttonFont;
	}
	else
	{
		C.Font=Root.Fonts[Font];
	}
	TextSize(C,Text,W,H);
	TextWidth=W + Len(Text) * m_fFontSpacing;
	switch (Align)
	{
		case TA_Left:
		TextXPos=m_fLMarge;
		break;
		case TA_Right:
		TextXPos=WinWidth - m_fRMarge - TextWidth;
		break;
		case TA_Center:
		TextXPos=(WinWidth - TextWidth) / 2;
		break;
		default:
	}
	return TextXPos + TextWidth > WinWidth;
}

function ResizeToText ()
{
	WinWidth=m_fMaxWinWidth;
	m_bResizeToText=True;
	m_bSetParam=True;
}

function SetButtonBorderColor (Color _vButtonBorderColor)
{
	m_bDefineBorderColor=True;
	m_BorderColor=_vButtonBorderColor;
}

function int GetButtonType ()
{
	return m_eButtonType;
}

defaultproperties
{
    m_iDrawStyle=1
    m_bSetParam=True
    m_fLMarge=2.00
    m_vButtonColor=(R=255,G=255,B=255,A=0)
    m_iButtonID=-1
}
