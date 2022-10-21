//================================================================================
// R6WindowTextLabelExt.
//================================================================================
class R6WindowTextLabelExt extends R6WindowSimpleFramedWindowExt;

struct TextLabel
{
	var Font TextFont;
	var Color TextColorFont;
	var string m_szTextLabel;
	var float X;
	var float XTextPos;
	var float Y;
	var float fWidth;
	var float fHeight;
	var float fXLine;
	var TextAlign Align;
	var bool bDrawLineAtEnd;
	var bool bUpDownBG;
	var bool bResizeToText;
};

var TextAlign Align;
var int m_TextDrawstyle;
var int m_DrawStyle;
var int m_iNumberOfLabel;
var bool m_bRefresh;
var bool m_bCheckToDrawLine;
var bool m_bTextCenterToWindow;
var bool m_bUpDownBG;
var float m_fTextX;
var float m_fTextY;
var float m_fFontSpacing;
var float m_fLMarge;
var float m_fYLineOffset;
var Font m_Font;
var Texture m_BGTexture;
var Color m_vTextColor;
var Color m_vLineColor;
var TextLabel m_sTextLabelArray[20];
var string Text;

const C_iMAX_SIZE_OF_TEXT_LABEL= 596;
const iNumberOfLabelMax= 20;

function Created ()
{
	Super.Created();
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float fWinWidth;
	local float fRelativeX;
	local float fXTemp;
	local int i;

	if ( m_bRefresh )
	{
		m_bRefresh=False;
		fXTemp=0.00;
		m_bCheckToDrawLine=False;
		i=0;
JL002B:
		if ( i < m_iNumberOfLabel )
		{
			C.Font=m_sTextLabelArray[i].TextFont;
			fWinWidth=m_sTextLabelArray[i].fWidth;
			if ( m_sTextLabelArray[i].bResizeToText )
			{
				TextSize(C,m_sTextLabelArray[i].m_szTextLabel,W,H);
				if ( W > WinWidth )
				{
					if ( W > 596 )
					{
						m_sTextLabelArray[i].m_szTextLabel=TextSize(C,m_sTextLabelArray[i].m_szTextLabel,W,H,596);
					}
					m_sTextLabelArray[i].XTextPos=4.00;
					WinWidth=W + 2 * 4;
					m_sTextLabelArray[i].fWidth=WinWidth;
					fWinWidth=m_sTextLabelArray[i].fWidth;
					if ( (OwnerWindow != None) && OwnerWindow.IsA('R6WindowPopUpBox') )
					{
						R6WindowPopUpBox(OwnerWindow).ResizePopUp(WinWidth);
					}
				}
			}
			else
			{
				m_sTextLabelArray[i].m_szTextLabel=TextSize(C,m_sTextLabelArray[i].m_szTextLabel,W,H,fWinWidth);
			}
			switch (m_sTextLabelArray[i].Align)
			{
/*				case 0:
				fXTemp=m_fLMarge;
				break;
				case 1:
				fXTemp=fWinWidth - W - Len(m_sTextLabelArray[i].m_szTextLabel) * m_fFontSpacing - m_fVBorderWidth;
				break;
				case 2:
				fXTemp=(fWinWidth - W) / 2;
				break;
				default:*/
			}
			if ( m_sTextLabelArray[i].bDrawLineAtEnd )
			{
				m_sTextLabelArray[i].fXLine=m_sTextLabelArray[i].X + fWinWidth;
				m_bCheckToDrawLine=True;
			}
			m_sTextLabelArray[i].XTextPos=m_sTextLabelArray[i].X + fXTemp;
			if ( m_bTextCenterToWindow )
			{
				m_sTextLabelArray[i].Y=(WinHeight - H) / 2;
				m_sTextLabelArray[i].Y=m_sTextLabelArray[i].Y + 0.50;
			}
			i++;
			goto JL002B;
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	local float tempSpace;
	local int i;
	local Texture t;

	if (  !GetActivateBorder() )
	{
		Super.Paint(C,X,Y);
	}
	if ( m_bCheckToDrawLine )
	{
		C.Style=m_DrawStyle;
		C.SetDrawColor(m_vLineColor.R,m_vLineColor.G,m_vLineColor.B);
		i=0;
JL0070:
		if ( i < m_iNumberOfLabel - 1 )
		{
			if ( m_sTextLabelArray[i].bDrawLineAtEnd )
			{
				DrawStretchedTextureSegment(C,m_sTextLabelArray[i].fXLine,m_fYLineOffset,1.00,WinHeight - m_fYLineOffset,m_VBorderTextureRegion.X,m_VBorderTextureRegion.Y,m_VBorderTextureRegion.W,m_VBorderTextureRegion.H,m_VBorderTexture);
			}
			i++;
			goto JL0070;
		}
	}
	if ( m_sTextLabelArray[0].m_szTextLabel != "" )
	{
		tempSpace=C.SpaceX;
		C.Font=m_Font;
		C.SpaceX=m_fFontSpacing;
		m_vTextColor=m_sTextLabelArray[0].TextColorFont;
		C.SetDrawColor(m_vTextColor.R,m_vTextColor.G,m_vTextColor.B);
		C.Style=m_TextDrawstyle;
		i=0;
JL01AE:
		if ( i < m_iNumberOfLabel )
		{
			if ( m_sTextLabelArray[i].TextFont != m_Font )
			{
				m_Font=m_sTextLabelArray[i].TextFont;
				C.Font=m_sTextLabelArray[i].TextFont;
			}
			if ( m_sTextLabelArray[i].TextColorFont!=m_vTextColor )
			{
				m_vTextColor=m_sTextLabelArray[i].TextColorFont;
				C.SetDrawColor(m_vTextColor.R,m_vTextColor.G,m_vTextColor.B);
			}
			if ( m_sTextLabelArray[i].bUpDownBG )
			{
				DrawUpDownBG(C,m_sTextLabelArray[i].X,m_sTextLabelArray[i].Y,m_sTextLabelArray[i].fWidth,m_sTextLabelArray[i].fHeight);
				C.Style=m_TextDrawstyle;
				C.SetDrawColor(m_vTextColor.R,m_vTextColor.G,m_vTextColor.B);
			}
			ClipText(C,m_sTextLabelArray[i].XTextPos,m_sTextLabelArray[i].Y,m_sTextLabelArray[i].m_szTextLabel,True);
			i++;
			goto JL01AE;
		}
		C.SpaceX=tempSpace;
	}
}

function DrawUpDownBG (Canvas C, float _fX, float _fY, float _fW, float _fH)
{
	local Texture BGTexture;
	local Region RTexture;

//	BGTexture=Texture'Gui_BoxScroll';
	RTexture.X=114;
	RTexture.Y=47;
	RTexture.W=2;
	RTexture.H=13;
	C.Style=5;
	C.SetDrawColor(Root.Colors.White.R,Root.Colors.White.G,Root.Colors.White.B);
	DrawStretchedTextureSegment(C,_fX,_fY,_fW,_fH,RTexture.X,RTexture.Y,RTexture.W,RTexture.H,BGTexture);
}

function int AddTextLabel (string _szTextToAdd, float _X, float _Y, float _fWidth, TextAlign _Align, bool _bDrawLineAtEnd, optional float _fHeight, optional bool _bResizeToText)
{
	local int iIndex;

	iIndex=0;
	if ( m_iNumberOfLabel < 20 )
	{
		m_sTextLabelArray[m_iNumberOfLabel].m_szTextLabel=_szTextToAdd;
		m_sTextLabelArray[m_iNumberOfLabel].X=_X;
		m_sTextLabelArray[m_iNumberOfLabel].XTextPos=_X;
		m_sTextLabelArray[m_iNumberOfLabel].Y=_Y;
		m_sTextLabelArray[m_iNumberOfLabel].fWidth=_fWidth;
		if ( _fHeight == 0 )
		{
			m_sTextLabelArray[m_iNumberOfLabel].fHeight=15.00;
		}
		else
		{
			m_sTextLabelArray[m_iNumberOfLabel].fHeight=_fHeight;
		}
		m_sTextLabelArray[m_iNumberOfLabel].Align=_Align;
		m_sTextLabelArray[m_iNumberOfLabel].bDrawLineAtEnd=_bDrawLineAtEnd;
		m_sTextLabelArray[m_iNumberOfLabel].bResizeToText=_bResizeToText;
		m_sTextLabelArray[m_iNumberOfLabel].TextFont=m_Font;
		m_sTextLabelArray[m_iNumberOfLabel].TextColorFont=m_vTextColor;
		m_sTextLabelArray[m_iNumberOfLabel].bUpDownBG=m_bUpDownBG;
		iIndex=m_iNumberOfLabel;
		m_bRefresh=True;
		m_iNumberOfLabel += 1;
	}
	return iIndex;
}

function ChangeTextLabel (string _szNewStringLabel, int _iIndex)
{
	m_sTextLabelArray[_iIndex].m_szTextLabel=_szNewStringLabel;
	m_bRefresh=True;
}

function ChangeColorLabel (Color _vNewColorText, int _iIndex)
{
	m_sTextLabelArray[_iIndex].TextColorFont=_vNewColorText;
	m_bRefresh=True;
}

function string GetTextLabel (int _iIndex)
{
	return m_sTextLabelArray[_iIndex].m_szTextLabel;
}

function Color GetTextColor (int _iIndex)
{
	return m_sTextLabelArray[_iIndex].TextColorFont;
}

function Clear ()
{
	local int i;

	i=0;
JL0007:
	if ( i < m_iNumberOfLabel )
	{
		m_sTextLabelArray[i].m_szTextLabel="";
		i++;
		goto JL0007;
	}
	m_iNumberOfLabel=0;
	m_bRefresh=True;
}

defaultproperties
{
    m_TextDrawstyle=5
    m_DrawStyle=5
    m_bRefresh=True
    m_fLMarge=2.00
    m_fYLineOffset=1.00
}
