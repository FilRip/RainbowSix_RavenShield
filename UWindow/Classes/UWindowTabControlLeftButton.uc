//================================================================================
// UWindowTabControlLeftButton.
//================================================================================
class UWindowTabControlLeftButton extends UWindowButton;

function BeforePaint (Canvas C, float X, float Y)
{
	LookAndFeel.Tab_SetupLeftButton(self);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if (  !bDisabled )
	{
		UWindowTabControl(ParentWindow).TabArea.TabOffset--;
	}
}
