//================================================================================
// R6WindowButtonBox.
//================================================================================
class R6WindowButtonBox extends UWindowButton;

enum eButtonBoxType {
	BBT_Normal,
	BBT_DeathCam,
	BBT_ResKit
};

var eButtonBoxType m_eButtonType;
var bool m_bRefresh;
var bool m_bMouseIsOver;
var bool m_bMouseOnButton;
var bool m_bSelected;
var bool m_bResizeToText;
var float m_fYTextPos;
var float m_fXText;
var float m_fXBox;
var float m_fYBox;
var float m_fXMsgBoxText;
var float m_fHMsgBoxText;
var Texture m_TButtonBG;
var Texture m_TDownTexture;
var Font m_TextFont;
var UWindowWindow m_AdviceWindow;
var Region m_RButtonBG;
var Color m_vBorder;
var Color m_vTextColor;
var string m_szMsgBoxText;
var string m_szMiscText;
var string m_szToolTipWhenDisable;
const C_fWIDTH_OF_MSG_BOX= 90;

function BeforePaint (Canvas C, float X, float Y)
{
	local int i;

	if ( m_bRefresh )
	{
		m_bRefresh=False;
		if ( m_szMsgBoxText != "" )
		{
//			m_fXMsgBoxText=AlignText(C,m_fXBox,90.00,m_szMsgBoxText,2);
		}
		if ( Text != "" )
		{
//			m_fXText=AlignText(C,0.00,WinWidth - m_RButtonBG.W,Text,0);
		}
	}
}

function float AlignText (Canvas C, float _fXStartPos, float _fWidth, out string _szTextToAlign, TextAlign _eTextAlign)
{
	local string szTmpText;
	local float W;
	local float H;
	local float fXTemp;
	local float fLMarge;
	local float fDistBetBoxAndText;

	fXTemp=0.00;
	fLMarge=2.00;
	fDistBetBoxAndText=4.00;
	C.Font=m_TextFont;
	szTmpText=TextSize(C,_szTextToAlign,W,H,_fWidth);
	TextSize(C,_szTextToAlign,W,H);
	if ( _szTextToAlign == m_szMsgBoxText )
	{
		m_fHMsgBoxText=H;
	}
	switch (_eTextAlign)
	{
		case TA_Left:
		if ( m_fXBox == 0 )
		{
			fXTemp=m_RButtonBG.W + _fXStartPos + fLMarge;
		}
		else
		{
			fXTemp=_fXStartPos + fLMarge;
		}
		break;
		case TA_Center:
		fXTemp=_fXStartPos + (_fWidth - W) / 2;
		break;
		default:
	}
	m_fYTextPos=(WinHeight - H) / 2;
	m_fYTextPos=m_fYTextPos + 0.50;
	if ( m_bResizeToText )
	{
		WinWidth=m_RButtonBG.W + _fXStartPos + fLMarge + W + fDistBetBoxAndText;
		if ( m_fXBox != 0 )
		{
			m_fXBox=WinWidth - m_RButtonBG.W;
		}
	}
	else
	{
		_szTextToAlign=szTmpText;
	}
	return fXTemp;
}

function Paint (Canvas C, float X, float Y)
{
	local Color vTempColor;

	if (  !bDisabled || (m_szToolTipWhenDisable != "") )
	{
		m_bMouseIsOver=MouseIsOver();
		if ( m_bMouseOnButton )
		{
			if ( bDisabled )
			{
				ToolTipString=m_szToolTipWhenDisable;
			}
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
	if ( m_eButtonType == 0 )
	{
		DrawCheckBox(C,m_fXBox,m_fYBox,m_bMouseIsOver);
	}
	else
	{
		if ( m_eButtonType == 2 )
		{
			DrawResKitBotton(C,m_fXBox,m_fYBox,m_bMouseIsOver);
		}
	}
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
	}
}

function DrawCheckBox (Canvas C, float _fXBox, float _fYBox, bool _bMouseOverButton)
{
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
	DrawStretchedTextureSegment(C,_fXBox,_fYBox,m_RButtonBG.W,m_RButtonBG.H,m_RButtonBG.X,m_RButtonBG.Y,m_RButtonBG.W,m_RButtonBG.H,m_TButtonBG);
	if ( m_bSelected )
	{
		DrawStretchedTextureSegment(C,2.00 + _fXBox,2.00 + _fYBox,DownRegion.W,DownRegion.H,DownRegion.X,DownRegion.Y,DownRegion.W,DownRegion.H,DownTexture);
	}
}

function DrawResKitBotton (Canvas C, float _fXBox, float _fYBox, bool _bMouseOverButton)
{
	local float fYLineTop;
	local float fYLineBottom;

	C.Style=5;
	C.Font=m_TextFont;
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
	fYLineTop=m_fYTextPos;
	fYLineBottom=m_fYTextPos + m_fHMsgBoxText - 2;
	DrawStretchedTextureSegment(C,_fXBox,fYLineTop,WinWidth - _fXBox,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,_fXBox,fYLineBottom,WinWidth - _fXBox,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,_fXBox,fYLineTop,m_BorderTextureRegion.W,m_fHMsgBoxText - 2,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,_fXBox + 90 - m_BorderTextureRegion.W,fYLineTop,m_BorderTextureRegion.W,m_fHMsgBoxText - 2,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
	ClipText(C,m_fXMsgBoxText,m_fYTextPos,m_szMsgBoxText,True);
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
	local float FMin;
	local float FMax;

	GetMouseXY(fX,fY);
	FMin=m_fXBox;
	if ( m_eButtonType == 0 )
	{
		FMax=m_fXBox + m_RButtonBG.W;
	}
	else
	{
		if ( m_eButtonType == 2 )
		{
			FMax=m_fXBox + 90;
		}
	}
	if ( InRange(fX,m_fXBox,FMax) )
	{
		return True;
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

function CreateTextAndBox (string _szText, string _szToolTip, float _fXText, int _iButtonID, optional bool _bTextAfterBox)
{
	Text=_szText;
	ToolTipString=_szToolTip;
	m_fXText=_fXText;
	m_iButtonID=_iButtonID;
	if ( _bTextAfterBox )
	{
		m_fXBox=0.00;
	}
	else
	{
		m_fXBox=WinWidth - m_RButtonBG.W;
	}
	m_fYBox=(WinHeight - m_RButtonBG.H) / 2;
	m_fYBox=m_fYBox + 0.50;
}

function CreateTextAndMsgBox (string _szText, string _szToolTip, string _szTextBox, float _fXText, int _iButtonID)
{
	Text=_szText;
	ToolTipString=_szToolTip;
	m_fXText=_fXText;
	m_iButtonID=_iButtonID;
	m_fXBox=WinWidth - 90;
	ModifyMsgBox(_szTextBox);
	m_fYBox=0.00;
}

function ModifyMsgBox (string _szTextBox)
{
	m_szMsgBoxText=_szTextBox;
	m_bRefresh=True;
}

function SetButtonBox (bool _bSelected)
{
	m_TextFont=Root.Fonts[5];
	m_vTextColor=Root.Colors.White;
	m_vBorder=Root.Colors.White;
	m_bSelected=_bSelected;
}

function SetNewWidth (float _fWidth)
{
	WinWidth=_fWidth;
	m_fXBox=_fWidth - m_RButtonBG.W;
	m_bRefresh=True;
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

simulated function Click (float X, float Y)
{
	if ( bDisabled )
	{
		return;
	}
	if ( GetSelectStatus() )
	{
		if ( m_bPlayButtonSnd && (DownSound != None) )
		{
//			GetPlayerOwner().PlaySound(DownSound,9);
			if ( m_bWaitSoundFinish )
			{
				m_bSoundStart=True;
				return;
			}
		}
		Notify(2);
	}
}

function MouseWheelDown (float X, float Y)
{
	if ( m_AdviceWindow != None )
	{
		m_AdviceWindow.MouseWheelDown(X,Y);
	}
}

function MouseWheelUp (float X, float Y)
{
	if ( m_AdviceWindow != None )
	{
		m_AdviceWindow.MouseWheelUp(X,Y);
	}
}

defaultproperties
{
    m_bRefresh=True
    m_RButtonBG=(X=795147,Y=571277312,W=40,H=926217)
    m_vBorder=(R=176,G=136,B=15,A=0)
    m_vTextColor=(R=255,G=255,B=255,A=0)
    DownRegion=(X=3416589,Y=571015168,W=10,H=664072)
}
/*
    DownTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_TButtonBG=Texture'R6MenuTextures.Gui_BoxScroll'
*/

