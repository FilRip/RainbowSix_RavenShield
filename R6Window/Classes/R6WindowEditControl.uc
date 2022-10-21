//================================================================================
// R6WindowEditControl.
//================================================================================
class R6WindowEditControl extends UWindowEditControl;

var bool m_bUseSpecialPaint;
var bool m_bDisabled;
var R6WindowTextLabel m_pTextLabel;

function Created ()
{
	if (  !bNoKeyboard )
	{
		SetAcceptsFocus();
	}
	EditBox=UWindowEditBox(CreateWindow(Class'R6WindowEditBox',0.00,0.00,WinWidth,WinHeight));
	EditBox.NotifyOwner=self;
	EditBoxWidth=WinWidth;
	SetEditTextColor(Root.Colors.BlueLight);
}

function BeforePaint (Canvas C, float X, float Y)
{
	if (  !m_bUseSpecialPaint )
	{
		Super.BeforePaint(C,X,Y);
	}
}

function Paint (Canvas C, float X, float Y)
{
	local Texture t;

	if ( m_bUseSpecialPaint )
	{
		if ( m_bDisabled )
		{
			return;
		}
		if ( m_pTextLabel != None )
		{
			if ( EditBox.m_bMouseOn )
			{
				m_pTextLabel.TextColor=Root.Colors.ButtonTextColor[2];
				ParentWindow.MouseEnter();
			}
			else
			{
				if ( m_pTextLabel.TextColor!=Root.Colors.White )
				{
					m_pTextLabel.TextColor=Root.Colors.White;
					ParentWindow.MouseLeave();
				}
			}
		}
	}
	else
	{
		Super.Paint(C,X,Y);
	}
}

function ForceCaps (bool choice)
{
	if ( R6WindowEditBox(EditBox) != None )
	{
		R6WindowEditBox(EditBox).bCaps=choice;
	}
}

function ModifyEditBoxW (float _fX, float _fY, float _fWidth, float _fHeight)
{
	EditBox.WinLeft=_fX;
	EditBox.WinTop=_fY;
	EditBox.WinWidth=_fWidth;
	EditBox.WinHeight=_fHeight;
	EditBox.Font=5;
	EditBoxWidth=EditBox.WinWidth;
	m_bUseSpecialPaint=True;
}

function CreateTextLabel (string _szTitle, float _fX, float _fY, float _fWidth, float _fHeight)
{
//	m_pTextLabel=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',_fX,_fY,_fWidth,_fHeight,self));
//	m_pTextLabel.SetProperties(_szTitle,0,Root.Fonts[5],Root.Colors.White,False);
}

function SetEditControlStatus (bool _bDisable)
{
	m_bDisabled=_bDisable;
	EditBox.bCanEdit= !_bDisable;
	if ( _bDisable )
	{
		m_pTextLabel.TextColor=Root.Colors.ButtonTextColor[1];
	}
	else
	{
		m_pTextLabel.TextColor=Root.Colors.ButtonTextColor[0];
	}
}

function SetEditBoxTip (string _szToolTip)
{
	EditBox.ToolTipString=_szToolTip;
}

defaultproperties
{
    m_bUseSpecialPaint=True
}
