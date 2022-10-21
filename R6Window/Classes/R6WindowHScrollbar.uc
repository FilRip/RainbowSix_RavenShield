//================================================================================
// R6WindowHScrollbar.
//================================================================================
class R6WindowHScrollbar extends UWindowDialogControl;

var R6WindowTextLabelExt m_pSBText;
var UWindowHScrollbar m_pScrollBar;

function CreateSB (int _iScrollBarID, float _fX, float _fY, float _fWidth, float _fHeight, UWindowDialogClientWindow _DialogClientW)
{
	m_pScrollBar=UWindowHScrollbar(CreateWindow(Class'UWindowHScrollbar',WinWidth - _fWidth,_fY,_fWidth,LookAndFeel.Size_ScrollbarWidth,self));
	m_pScrollBar.SetRange(0.00,10.00,2.00);
	m_pScrollBar.Register(_DialogClientW);
	m_pScrollBar.m_iScrollBarID=_iScrollBarID;
}

function SetScrollBarValue (float _fNewValue)
{
	local float fScrollValue;

	if ( m_pScrollBar != None )
	{
		fScrollValue=m_pScrollBar.MaxPos / (m_pScrollBar.MaxPos + m_pScrollBar.MaxVisible);
		fScrollValue *= _fNewValue;
		m_pScrollBar.pos=fScrollValue;
		m_pScrollBar.CheckRange();
	}
}

function SetScrollBarRange (float _fMin, float _fMax, float _fStep)
{
	if ( m_pScrollBar != None )
	{
		m_pScrollBar.SetRange(_fMin,_fMax,_fStep);
	}
}

function float GetScrollBarValue ()
{
	local float fRealValue;

	if ( m_pScrollBar != None )
	{
		fRealValue=(m_pScrollBar.MaxPos + m_pScrollBar.MaxVisible) / m_pScrollBar.MaxPos;
		fRealValue *= m_pScrollBar.pos;
		return fRealValue;
	}
	return 0.00;
}

function CreateSBTextLabel (string _szText, string _szToolTip)
{
	if ( m_pScrollBar != None )
	{
		m_pSBText=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,WinWidth - m_pScrollBar.WinWidth,WinHeight,self));
		m_pSBText.bAlwaysBehind=True;
		m_pSBText.SetNoBorder();
		m_pSBText.m_Font=Root.Fonts[5];
		m_pSBText.m_vTextColor=Root.Colors.White;
//		m_pSBText.AddTextLabel(_szText,0.00,0.00,150.00,0,False);
	}
	ToolTipString=_szToolTip;
}

function MouseEnter ()
{
	Super.MouseEnter();
	if ( m_pSBText != None )
	{
		m_pSBText.ChangeColorLabel(Root.Colors.ButtonTextColor[2],0);
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	if ( m_pSBText != None )
	{
		m_pSBText.ChangeColorLabel(Root.Colors.White,0);
	}
}
