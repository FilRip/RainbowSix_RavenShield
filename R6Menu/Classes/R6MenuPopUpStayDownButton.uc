//================================================================================
// R6MenuPopUpStayDownButton.
//================================================================================
class R6MenuPopUpStayDownButton extends R6WindowButton;

var bool m_bSubMenu;

function Created ()
{
	bNoKeyboard=True;
}

function Paint (Canvas C, float X, float Y)
{
	if ( LookAndFeel.IsA('R6MenuRSLookAndFeel') )
	{
		C.Font=m_buttonFont;
		if ( bDisabled )
		{
			R6MenuRSLookAndFeel(LookAndFeel).DrawPopupButtonDisable(self,C);
		}
		else
		{
			if ( bMouseDown || m_bSelected )
			{
				R6MenuRSLookAndFeel(LookAndFeel).DrawPopupButtonDown(self,C);
			}
			else
			{
				if ( MouseIsOver() )
				{
					R6MenuRSLookAndFeel(LookAndFeel).DrawPopupButtonOver(self,C);
				}
				else
				{
					R6MenuRSLookAndFeel(LookAndFeel).DrawPopupButtonUp(self,C);
				}
			}
		}
	}
}

function LMouseDown (float X, float Y)
{
	local float fGlobalX;
	local float fGlobalY;

	if (  !bDisabled )
	{
		GetMouseXY(fGlobalX,fGlobalY);
		WindowToGlobal(fGlobalX,fGlobalY,fGlobalX,fGlobalY);
		OwnerWindow.GlobalToWindow(fGlobalX,fGlobalY,fGlobalX,fGlobalY);
		R6WindowListRadio(OwnerWindow).SetSelected(fGlobalX,fGlobalY);
	}
	Super.LMouseDown(X,Y);
}

function Tick (float fDelta)
{
}