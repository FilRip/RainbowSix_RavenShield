//================================================================================
// R6WindowButtonAndEditBox.
//================================================================================
class R6WindowButtonAndEditBox extends R6WindowButtonBox;

var R6WindowEditControl m_pEditBox;
var string m_szEditTextHistory;

function Paint (Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);
	if ( m_pEditBox != None )
	{
		if ( m_szEditTextHistory != m_pEditBox.GetValue() )
		{
			m_szEditTextHistory=m_pEditBox.GetValue();
			Notify(1);
		}
		if ( m_pEditBox.EditBox.m_CurrentlyEditing )
		{
			m_bSelected=m_pEditBox.GetValue() != "";
		}
	}
}

function CreateEditBox (float fWidth)
{
	local int fXPos;

	fXPos=m_fXBox - fWidth - 3;
	m_pEditBox=R6WindowEditControl(CreateWindow(Class'R6WindowEditControl',fXPos,0.00,fWidth,WinHeight,self));
	m_pEditBox.SetValue("");
}

function SetDisableButtonAndEditBox (bool _bDisable)
{
	m_pEditBox.EditBox.bCanEdit= !_bDisable;
	bDisabled=_bDisable;
	if ( _bDisable )
	{
		m_pEditBox.m_BorderColor=Root.Colors.ButtonTextColor[1];
	}
	else
	{
		m_pEditBox.m_BorderColor=Root.Colors.ButtonTextColor[0];
	}
}

function SetEditBoxTip (string _szToolTip)
{
	if ( m_pEditBox != None )
	{
		m_pEditBox.SetEditBoxTip(_szToolTip);
	}
}