//================================================================================
// R6WindowButtonExt.
//================================================================================
class R6WindowButtonExt extends UWindowButton;

struct CheckBox
{
	var string szText;
	var float fXBoxPos;
	var bool bSelected;
	var int iIndex;
};

var int m_iNumberOfCheckBox;
var int m_iCurSelectedBox;
var int m_iCheckBoxOver;
var bool m_bOneTime;
var bool m_bMouseIsOver;
var bool m_bMouseOnButton;
var bool m_bSelected;
var float m_fTextWidth;
var float m_fYTextPos;
var float m_fXText;
var float m_fYBox;
var Texture m_TButtonBG;
var Texture m_TDownTexture;
var Font m_TextFont;
var Region m_RButtonBG;
var Color m_vBorder;
var Color m_vTextColor;
var CheckBox m_stCheckBox[3];

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;
	local float fWinWidth;
	local int i;

	if ( m_bOneTime )
	{
		m_bOneTime=False;
		if ( Text != "" )
		{
			C.Font=m_TextFont;
			TextSize(C,Text,W,H);
			m_fXText += 2;
			m_fYTextPos=(WinHeight - H) / 2;
			m_fYTextPos=m_fYTextPos + 0.50;
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	local Color vTempColor;
	local int i;

	if (  !bDisabled )
	{
		m_bMouseIsOver=MouseIsOver();
		if ( m_bMouseIsOver )
		{
			m_bMouseIsOver=CheckText_Box_Region();
		}
		if ( m_bMouseOnButton )
		{
			if ( ToolTipString != "" )
			{
				if ( m_bMouseIsOver )
				{
					ToolTip(ToolTipString);
				}
				else
				{
					ToolTip("");
				}
			}
		}
	}
	DrawCheckBox(C,m_bMouseIsOver);
	if ( Text != "" )
	{
		C.Font=m_TextFont;
		C.SpaceX=0.00;
		vTempColor=m_vTextColor;
		if ( bDisabled )
		{
			C.SetDrawColor(m_DisabledTextColor.R,m_DisabledTextColor.G,m_DisabledTextColor.B);
		}
		else
		{
			if ( m_bMouseIsOver )
			{
				vTempColor=m_OverTextColor;
				C.SetDrawColor(m_OverTextColor.R,m_OverTextColor.G,m_OverTextColor.B);
			}
			else
			{
				if ( vTempColor!=m_vTextColor )
				{
					vTempColor=m_vTextColor;
					C.SetDrawColor(m_vTextColor.R,m_vTextColor.G,m_vTextColor.B);
				}
			}
		}
		ClipText(C,m_fXText,m_fYTextPos,Text,True);
		i=0;
JL0192:
		if ( i < m_iNumberOfCheckBox )
		{
			ClipText(C,m_stCheckBox[i].fXBoxPos + m_RButtonBG.W + 2,m_fYTextPos,m_stCheckBox[i].szText,True);
			i++;
			goto JL0192;
		}
	}
}

function DrawCheckBox (Canvas C, bool _bMouseOverButton)
{
	local int i;

	C.Style=5;
	if ( bDisabled )
	{
		C.SetDrawColor(m_DisabledTextColor.R,m_DisabledTextColor.G,m_DisabledTextColor.B);
	}
	else
	{
		if ( _bMouseOverButton )
		{
			C.SetDrawColor(m_OverTextColor.R,m_OverTextColor.G,m_OverTextColor.B);
		}
		else
		{
			C.SetDrawColor(m_vBorder.R,m_vBorder.G,m_vBorder.B);
		}
	}
	i=0;
JL00AE:
	if ( i < m_iNumberOfCheckBox )
	{
		DrawStretchedTextureSegment(C,m_stCheckBox[i].fXBoxPos,m_fYBox,m_RButtonBG.W,m_RButtonBG.H,m_RButtonBG.X,m_RButtonBG.Y,m_RButtonBG.W,m_RButtonBG.H,m_TButtonBG);
		if ( m_stCheckBox[i].bSelected )
		{
			DrawStretchedTextureSegment(C,2.00 + m_stCheckBox[i].fXBoxPos,2.00 + m_fYBox,DownRegion.W,DownRegion.H,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
		}
		i++;
		goto JL00AE;
	}
}

function MouseEnter ()
{
	m_bMouseOnButton=True;
}

function MouseLeave ()
{
	Super.MouseLeave();
	m_bMouseOnButton=False;
}

function bool CheckText_Box_Region ()
{
	local int i;
	local float fX;
	local float fY;

	GetMouseXY(fX,fY);
	i=0;
JL0017:
	if ( i < m_iNumberOfCheckBox )
	{
		if ( InRange(fX,m_stCheckBox[i].fXBoxPos,m_stCheckBox[i].fXBoxPos + m_RButtonBG.W) )
		{
			m_iCheckBoxOver=i;
			return True;
		}
		i++;
		goto JL0017;
	}
	return False;
}

function bool InRange (float _fTestValue, float _fMin, float _fMax)
{
	if ( _fTestValue > _fMin )
	{
		if ( _fTestValue < _fMax )
		{
			return True;
		}
	}
	return False;
}

function CreateTextAndBox (string _szText, string _szToolTip, float _fXText, int _iButtonID, int _iNumberOfCheckBox)
{
	Text=_szText;
	ToolTipString=_szToolTip;
	m_fXText=_fXText;
	m_iButtonID=_iButtonID;
	m_iNumberOfCheckBox=_iNumberOfCheckBox;
	m_fYBox=(WinHeight - m_RButtonBG.H) / 2;
	m_fYBox=m_fYTextPos + 0.50;
}

function SetCheckBox (string _szText, float _fXBoxPos, bool _bSelected, int _iIndex)
{
	m_stCheckBox[_iIndex].szText=_szText;
	m_stCheckBox[_iIndex].fXBoxPos=_fXBoxPos;
	m_stCheckBox[_iIndex].bSelected=_bSelected;
	if ( _bSelected )
	{
		m_iCurSelectedBox=_iIndex;
	}
	m_TextFont=Root.Fonts[5];
	m_vTextColor=Root.Colors.White;
	m_vBorder=Root.Colors.White;
}

function bool GetSelectStatus ()
{
	if ( bDisabled )
	{
		return False;
	}
	if ( m_bMouseOnButton && m_bMouseIsOver )
	{
		return True;
	}
	return False;
}

function ChangeCheckBoxStatus ()
{
	if ( m_iCurSelectedBox != m_iCheckBoxOver )
	{
		m_stCheckBox[m_iCurSelectedBox].bSelected=False;
		m_stCheckBox[m_iCheckBoxOver].bSelected=True;
		m_iCurSelectedBox=m_iCheckBoxOver;
	}
}

function SetCheckBoxStatus (int _iSelected)
{
	m_iCurSelectedBox=_iSelected;
	switch (_iSelected)
	{
		case 0:
		m_stCheckBox[0].bSelected=True;
		m_stCheckBox[1].bSelected=False;
		m_stCheckBox[2].bSelected=False;
		break;
		case 1:
		m_stCheckBox[0].bSelected=False;
		m_stCheckBox[1].bSelected=True;
		m_stCheckBox[2].bSelected=False;
		break;
		case 2:
		m_stCheckBox[0].bSelected=False;
		m_stCheckBox[1].bSelected=False;
		m_stCheckBox[2].bSelected=True;
		break;
		default:
		break;
	}
}

function int GetCheckBoxStatus ()
{
	if ( m_stCheckBox[0].bSelected )
	{
		return 0;
	}
	else
	{
		if ( m_stCheckBox[1].bSelected )
		{
			return 1;
		}
		else
		{
			if ( m_stCheckBox[2].bSelected )
			{
				return 2;
			}
		}
	}
}

defaultproperties
{
    m_bOneTime=True
    m_RButtonBG=(X=795147,Y=571277312,W=40,H=926217)
    m_vBorder=(R=176,G=136,B=15,A=0)
    m_vTextColor=(R=255,G=255,B=255,A=0)
    DownRegion=(X=3416589,Y=571015168,W=10,H=664072)
}
/*
    m_TButtonBG=Texture'R6MenuTextures.Gui_BoxScroll'
    DownTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

