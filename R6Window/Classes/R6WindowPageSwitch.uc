//================================================================================
// R6WindowPageSwitch.
//================================================================================
class R6WindowPageSwitch extends UWindowDialogClientWindow;

var int m_iTotalPages;
var int m_iCurrentPages;
var int m_iButtonWidth;
var int m_iButtonHeight;
var R6WindowButton m_pNextButton;
var R6WindowButton m_pPreviousButton;
var R6WindowTextLabel m_pPageInfo;

function Created ()
{
	m_iTotalPages=1;
	m_iCurrentPages=1;
	CreateButtons();
	m_pPageInfo=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_pPreviousButton.WinLeft + m_pPreviousButton.WinWidth,0.00,WinWidth - m_pPreviousButton.WinWidth - m_pNextButton.WinWidth,WinHeight,self));
	m_pPageInfo.bAlwaysBehind=True;
	SetTotalPages(m_iTotalPages);
	SetCurrentPage(m_iCurrentPages);
}

function SetLabelText (string _szText, Font _TextFont, Color _vTextColor)
{
	if ( m_pPageInfo != None )
	{
		m_pPageInfo.m_Font=_TextFont;
		m_pPageInfo.TextColor=_vTextColor;
		m_pPageInfo.m_bDrawBorders=False;
		m_pPageInfo.Align=TA_Center;
		m_pPageInfo.m_BGTexture=None;
		m_pPageInfo.SetNewText(_szText,True);
	}
}

function CreateButtons ()
{
	m_pPreviousButton=R6WindowButton(CreateControl(Class'R6WindowButton',0.00,0.00,m_iButtonWidth,m_iButtonHeight));
	m_pPreviousButton.m_bDrawBorders=False;
	m_pPreviousButton.SetButtonBorderColor(Root.Colors.White);
	m_pPreviousButton.TextColor=Root.Colors.White;
	m_pPreviousButton.m_OverTextColor=Root.Colors.BlueLight;
	m_pPreviousButton.m_DisabledTextColor=Root.Colors.Black;
	m_pPreviousButton.Text="<<<";
	m_pPreviousButton.m_buttonFont=Root.Fonts[5];
	m_pNextButton=R6WindowButton(CreateControl(Class'R6WindowButton',WinWidth - m_iButtonWidth,0.00,m_iButtonWidth,m_iButtonHeight));
	m_pNextButton.m_bDrawBorders=False;
	m_pNextButton.SetButtonBorderColor(Root.Colors.White);
	m_pNextButton.TextColor=Root.Colors.White;
	m_pNextButton.m_OverTextColor=Root.Colors.BlueLight;
	m_pNextButton.m_DisabledTextColor=Root.Colors.Black;
	m_pNextButton.Text=">>>";
	m_pNextButton.m_buttonFont=Root.Fonts[5];
}

function SetButtonToolTip (string _szLeftToolTip, string _szRightToolTip)
{
	if ( m_pNextButton != None )
	{
		m_pNextButton.ToolTipString=_szLeftToolTip;
	}
	if ( m_pPreviousButton != None )
	{
		m_pPreviousButton.ToolTipString=_szRightToolTip;
	}
}

function SetTotalPages (int iPage)
{
	m_iTotalPages=iPage;
	UpdatePageNb();
}

function SetCurrentPage (int iPage)
{
	m_iCurrentPages=iPage;
	UpdatePageNb();
}

function UpdatePageNb ()
{
	local string szText;

	if ( m_iCurrentPages <= 1 )
	{
		m_pPreviousButton.bDisabled=True;
		m_iCurrentPages=1;
	}
	else
	{
		if ( m_iCurrentPages >= m_iTotalPages )
		{
			m_pPreviousButton.bDisabled=False;
			m_iCurrentPages=m_iTotalPages;
		}
		else
		{
			m_pPreviousButton.bDisabled=False;
		}
	}
	if ( m_iTotalPages <= 1 )
	{
		m_iTotalPages=1;
		m_pNextButton.bDisabled=True;
	}
	else
	{
		if ( m_iCurrentPages == m_iTotalPages )
		{
			m_pNextButton.bDisabled=True;
		}
		else
		{
			m_pNextButton.bDisabled=False;
		}
	}
	szText=string(m_iCurrentPages) $ " / " $ string(m_iTotalPages);
	SetLabelText(szText,Root.Fonts[5],Root.Colors.White);
}

function NextPage ()
{
	SetCurrentPage(m_iCurrentPages + 1);
}

function PreviousPage ()
{
	SetCurrentPage(m_iCurrentPages - 1);
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		switch (C)
		{
			case m_pNextButton:
			if ( UWindowDialogClientWindow(OwnerWindow) != None )
			{
				UWindowDialogClientWindow(OwnerWindow).Notify(C,E);
			}
			break;
			case m_pPreviousButton:
			if ( UWindowDialogClientWindow(OwnerWindow) != None )
			{
				UWindowDialogClientWindow(OwnerWindow).Notify(C,E);
			}
			break;
			default:
		}
	}
}

defaultproperties
{
    m_iButtonWidth=20
    m_iButtonHeight=25
}
