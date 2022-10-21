//================================================================================
// R6WindowButtonSort.
//================================================================================
class R6WindowButtonSort extends UWindowButton;

var bool m_bDrawSimpleBorder;
var bool m_bSetParam;
var bool m_bAscending;
var bool m_bDrawSortIcon;
var bool m_bAbleToDrawSortIcon;
var float m_fLMarge;
var float m_fXSortIconPos;
var float m_fYSortIconPos;
var Texture m_TSortIcon;
var Font m_buttonFont;
var Region m_RSortIcon;

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float fWidth;

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
			fWidth=WinWidth;
			if ( W + m_RSortIcon.W + 5 < WinWidth )
			{
				m_bAbleToDrawSortIcon=True;
				fWidth=WinWidth - m_RSortIcon.W - 5;
				m_fXSortIconPos=WinWidth - m_RSortIcon.W - 4;
				m_fYSortIconPos=(WinHeight - m_RSortIcon.H) / 2;
				m_fYSortIconPos=m_fYSortIconPos + 0.50;
			}
			switch (Align)
			{
				case TA_Left:
				TextX=m_fLMarge;
				break;
				case TA_Right:
				TextX=fWidth - W;
				break;
				case TA_Center:
				TextX=(fWidth - W) / 2 + 0.50;
				break;
				default:
			}
			TextY=(WinHeight - H) / 2;
			TextY=TextY + 0.50;
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	if ( Text != "" )
	{
		C.Style=1;
		C.SpaceX=0.00;
		C.Font=m_buttonFont;
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
		}
	}
	if ( m_bDrawSortIcon )
	{
		if ( m_bAbleToDrawSortIcon )
		{
			C.Style=5;
			if ( m_bAscending )
			{
				DrawStretchedTextureSegmentRot(C,m_fXSortIconPos,m_fYSortIconPos,m_RSortIcon.W,m_RSortIcon.H,m_RSortIcon.X,m_RSortIcon.Y,m_RSortIcon.W,m_RSortIcon.H,m_TSortIcon,-1.57);
			}
			else
			{
				DrawStretchedTextureSegmentRot(C,m_fXSortIconPos,m_fYSortIconPos,m_RSortIcon.W,m_RSortIcon.H,m_RSortIcon.X,m_RSortIcon.Y,m_RSortIcon.W,m_RSortIcon.H,m_TSortIcon,1.57);
			}
		}
	}
	if ( m_bDrawSimpleBorder )
	{
		DrawSimpleBorder(C);
	}
}

defaultproperties
{
    m_bDrawSimpleBorder=True
    m_bSetParam=True
    m_fLMarge=2.00
    m_RSortIcon=(X=5251595,Y=571277312,W=53,H=401929)
    m_iButtonID=-1
}
/*
    m_TSortIcon=Texture'R6MenuTextures.Gui_BoxScroll'
*/

