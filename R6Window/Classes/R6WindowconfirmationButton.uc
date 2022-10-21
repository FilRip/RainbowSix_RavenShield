//================================================================================
// R6WindowconfirmationButton.
//================================================================================
class R6WindowconfirmationButton extends R6WindowButton;

function Paint (Canvas C, float X, float Y)
{
	if ( m_buttonFont != None )
	{
		C.Font=m_buttonFont;
	}
	else
	{
		C.Font=Root.Fonts[Font];
	}
	Super.Paint(C,X,Y);
	C.Style=1;
	R6WindowLookAndFeel(LookAndFeel).DrawButtonBorder(self,C);
}