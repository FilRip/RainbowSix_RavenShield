//================================================================================
// R6WindowCounter.
//================================================================================
class R6WindowCounter extends UWindowDialogClientWindow;

enum eAssociateButCase {
	EABC_Down,
	EABC_Up
};

var int m_iAssociateButCase;
var int m_iStepCounter;
var int m_iCounter;
var int m_iMinCounter;
var int m_iMaxCounter;
var int m_iButtonID;
var bool m_bAdviceParent;
var bool m_bNotAcceptClick;
var bool m_bUnlimitedCounterOnZero;
var bool m_bButPressed;
var float m_fTimeCheckBut;
var float m_fTimeToWait;
var R6WindowCounter m_pAssociateButton;
var R6WindowButton m_pSubButton;
var R6WindowButton m_pPlusButton;
var R6WindowTextLabel m_pTextInfo;
var R6WindowTextLabel m_pNbOfCounter;
const C_fBUTTONS_CHECK_TIME= 1;

function CreateLabelText (float _fX, float _fY, float _fWidth, float _fHeight)
{
	m_pTextInfo=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',_fX,_fY,_fWidth,_fHeight,self));
	m_pTextInfo.bAlwaysBehind=True;
}

function SetLabelText (string _szText, Font _TextFont, Color _vTextColor)
{
	if ( m_pTextInfo != None )
	{
		m_pTextInfo.Text=_szText;
		m_pTextInfo.m_Font=_TextFont;
		m_pTextInfo.TextColor=_vTextColor;
		m_pTextInfo.m_bDrawBorders=False;
		m_pTextInfo.Align=TA_Left;
		m_pTextInfo.m_BGTexture=None;
	}
}

function CreateButtons (float _fX, float _fY, float _fSizeOfCounter)
{
	local Region RDisableRegion;
	local Region RNormalRegion;
	local float fHeight;
	local float fButtonWidth;
	local float fButtonHeight;

	RNormalRegion.X=49;
	RNormalRegion.Y=24;
	RNormalRegion.W=10;
	RNormalRegion.H=10;
	RDisableRegion.X=49;
	RDisableRegion.Y=44;
	RDisableRegion.W=10;
	RDisableRegion.H=10;
	fButtonWidth=R6WindowLookAndFeel(LookAndFeel).m_RButtonBackGround.W;
	fButtonHeight=R6WindowLookAndFeel(LookAndFeel).m_RButtonBackGround.H;
	fHeight=(WinHeight - fButtonHeight) / 2;
	fHeight=fHeight + 0.50;
	m_pSubButton=R6WindowButton(CreateControl(Class'R6WindowButton',_fX,_fY,fButtonWidth,fButtonHeight));
	m_pSubButton.SetButtonBorderColor(Root.Colors.White);
	m_pSubButton.m_vButtonColor=Root.Colors.White;
	m_pSubButton.m_bDrawBorders=True;
	m_pSubButton.bUseRegion=True;
	m_pSubButton.DownTexture=R6WindowLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pSubButton.DownRegion=RDisableRegion;
	m_pSubButton.OverTexture=R6WindowLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pSubButton.OverRegion=RNormalRegion;
	m_pSubButton.UpTexture=R6WindowLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pSubButton.UpRegion=RNormalRegion;
	m_pSubButton.ImageX=2.00;
	m_pSubButton.ImageY=2.00;
	m_pSubButton.m_iDrawStyle=5;
//	m_pSubButton.m_eButtonType=1;
	m_pNbOfCounter=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',_fX + fButtonWidth,_fY,_fSizeOfCounter - 2 * fButtonWidth,fButtonHeight));
	m_pNbOfCounter.m_bDrawBorders=False;
	m_pNbOfCounter.m_BGTextureRegion.X=113;
	m_pNbOfCounter.m_BGTextureRegion.Y=47;
	m_pNbOfCounter.m_BGTextureRegion.W=2;
	m_pNbOfCounter.m_BGTextureRegion.H=13;
	m_pNbOfCounter.m_fHBorderHeight=0.00;
	m_pNbOfCounter.Text=string(m_iCounter);
	m_pNbOfCounter.Align=TA_Center;
	m_pNbOfCounter.m_Font=Root.Fonts[5];
	m_pNbOfCounter.TextColor=Root.Colors.BlueLight;
	RNormalRegion.X=59;
	RDisableRegion.X=59;
	m_pPlusButton=R6WindowButton(CreateControl(Class'R6WindowButton',_fX - fButtonWidth + _fSizeOfCounter,_fY,fButtonWidth,fButtonHeight));
	m_pPlusButton.SetButtonBorderColor(Root.Colors.White);
	m_pPlusButton.m_vButtonColor=Root.Colors.White;
	m_pPlusButton.m_bDrawBorders=True;
	m_pPlusButton.bUseRegion=True;
	m_pPlusButton.DownTexture=R6WindowLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pPlusButton.DownRegion=RDisableRegion;
	m_pPlusButton.OverTexture=R6WindowLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pPlusButton.OverRegion=RNormalRegion;
	m_pPlusButton.UpTexture=R6WindowLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pPlusButton.UpRegion=RNormalRegion;
	m_pPlusButton.ImageX=2.00;
	m_pPlusButton.ImageY=2.00;
	m_pPlusButton.m_iDrawStyle=5;
//	m_pPlusButton.m_eButtonType=1;
}

function SetButtonToolTip (string _szLeftToolTip, string _szRightToolTip)
{
	if ( m_pSubButton != None )
	{
		m_pSubButton.ToolTipString=_szLeftToolTip;
	}
	if ( m_pPlusButton != None )
	{
		m_pPlusButton.ToolTipString=_szRightToolTip;
	}
}

function SetDefaultValues (int _iMin, int _iMax, int _iDefaultValue)
{
	m_iMinCounter=_iMin;
	m_iMaxCounter=_iMax;
	if ( CheckValueForUnlimitedCounter(_iDefaultValue,True) )
	{
		return;
	}
	m_iCounter=CheckValue(_iDefaultValue);
	m_pNbOfCounter.Text=string(m_iCounter);
}

function SetCounterValue (int _iNewValue)
{
	if ( CheckValueForUnlimitedCounter(_iNewValue,False) )
	{
		return;
	}
	m_iCounter=CheckValue(_iNewValue);
	m_pNbOfCounter.SetNewText(string(m_iCounter),True);
}

function bool CheckValueForUnlimitedCounter (int _iValue, bool _bDefaultValue)
{
	if ( m_bUnlimitedCounterOnZero )
	{
		if ( (_iValue < m_iMinCounter) && (_iValue == 0) )
		{
			m_iCounter=0;
			if ( _bDefaultValue )
			{
				m_pNbOfCounter.Text="--";
			}
			else
			{
				m_pNbOfCounter.SetNewText("--",True);
			}
			return True;
		}
	}
	return False;
}

function int CheckValue (int _iValue)
{
	if ( _iValue > m_iMaxCounter )
	{
		return m_iMaxCounter;
	}
	else
	{
		if ( _iValue < m_iMinCounter )
		{
			return m_iMinCounter;
		}
		else
		{
			return _iValue;
		}
	}
}

function bool CheckAddButton ()
{
	if ( m_bUnlimitedCounterOnZero )
	{
		if ( m_iCounter == 0 )
		{
			m_iCounter=m_iMinCounter;
			m_pNbOfCounter.SetNewText(string(m_iCounter),True);
			return True;
		}
	}
	if ( m_iCounter + m_iStepCounter <= m_iMaxCounter )
	{
		m_iCounter += m_iStepCounter;
		m_pNbOfCounter.SetNewText(string(m_iCounter),True);
		return True;
	}
	return False;
}

function bool CheckSubButton ()
{
	local float bSubValue;

	bSubValue=m_iCounter - m_iStepCounter;
	if ( m_bUnlimitedCounterOnZero )
	{
		if ( bSubValue < m_iMinCounter )
		{
			m_iCounter=0;
			m_pNbOfCounter.SetNewText("--",True);
			return True;
		}
	}
	if ( bSubValue >= m_iMinCounter )
	{
		m_iCounter -= m_iStepCounter;
		m_pNbOfCounter.SetNewText(string(m_iCounter),True);
		return True;
	}
	return False;
}

function SetAdviceParent (bool _bAdviceParent)
{
	m_bAdviceParent=_bAdviceParent;
}

function Tick (float DeltaTime)
{
	local bool bButPressed;

	m_fTimeCheckBut += DeltaTime * m_fTimeCheckBut;
	if ( m_fTimeCheckBut >= m_fTimeToWait )
	{
		m_fTimeCheckBut=0.50;
		m_fTimeToWait=1.00;
		bButPressed=m_bButPressed;
		m_bButPressed=False;
		m_bButPressed=IsMouseDown(m_pSubButton);
		m_bButPressed=IsMouseDown(m_pPlusButton) || m_bButPressed;
		if ( bButPressed && m_bButPressed )
		{
			m_fTimeToWait *= 0.50;
		}
	}
}

function bool IsMouseDown (UWindowDialogControl _pButton)
{
	if ( _pButton != None )
	{
		if ( _pButton.bMouseDown )
		{
			Notify(_pButton,2);
			return True;
		}
	}
	return False;
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		if ( m_bNotAcceptClick )
		{
			return;
		}
		switch (C)
		{
			case m_pPlusButton:
			if ( CheckAddButton() )
			{
				if ( m_pAssociateButton != None )
				{
					if ( m_iAssociateButCase == 1 )
					{
						if ( m_iCounter > m_pAssociateButton.m_iCounter )
						{
							m_pAssociateButton.m_iCounter=m_iCounter;
							m_pAssociateButton.m_pNbOfCounter.SetNewText(string(m_pAssociateButton.m_iCounter),True);
						}
					}
				}
				if ( m_bAdviceParent )
				{
					UWindowDialogClientWindow(ParentWindow).Notify(C,E);
				}
			}
			if (  !m_bButPressed )
			{
				m_fTimeCheckBut=0.50;
			}
			break;
			case m_pSubButton:
			if ( CheckSubButton() )
			{
				if ( m_pAssociateButton != None )
				{
					if ( m_iAssociateButCase == 0 )
					{
						if ( m_iCounter < m_pAssociateButton.m_iCounter )
						{
							m_pAssociateButton.m_iCounter=m_iCounter;
							m_pAssociateButton.m_pNbOfCounter.SetNewText(string(m_pAssociateButton.m_iCounter),True);
						}
					}
				}
				if ( m_bAdviceParent )
				{
					UWindowDialogClientWindow(ParentWindow).Notify(C,E);
				}
			}
			if (  !m_bButPressed )
			{
				m_fTimeCheckBut=0.50;
			}
			break;
			default:
		}
	}
	else
	{
		if ( E == 12 )
		{
			m_pSubButton.SetButtonBorderColor(Root.Colors.BlueLight);
			m_pSubButton.m_vButtonColor=Root.Colors.BlueLight;
			m_pPlusButton.SetButtonBorderColor(Root.Colors.BlueLight);
			m_pPlusButton.m_vButtonColor=Root.Colors.BlueLight;
			if ( m_pTextInfo != None )
			{
				m_pTextInfo.TextColor=Root.Colors.BlueLight;
			}
			if ( m_bAdviceParent )
			{
				ParentWindow.ToolTip(R6WindowButton(C).ToolTipString);
			}
		}
		else
		{
			if ( E == 9 )
			{
				m_pSubButton.SetButtonBorderColor(Root.Colors.White);
				m_pSubButton.m_vButtonColor=Root.Colors.White;
				m_pPlusButton.SetButtonBorderColor(Root.Colors.White);
				m_pPlusButton.m_vButtonColor=Root.Colors.White;
				if ( m_pTextInfo != None )
				{
					m_pTextInfo.TextColor=Root.Colors.White;
				}
				if ( m_bAdviceParent )
				{
					ParentWindow.ToolTip("");
				}
			}
		}
	}
}

defaultproperties
{
    m_iStepCounter=1
    m_iMaxCounter=99
}
