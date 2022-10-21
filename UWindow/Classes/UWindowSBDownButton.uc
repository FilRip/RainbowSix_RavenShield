//================================================================================
// UWindowSBDownButton.
//================================================================================
class UWindowSBDownButton extends UWindowButton;

var bool m_bHideSBWhenDisable;
var float NextClickTime;

function Created ()
{
	bNoKeyboard=True;
	Super.Created();
	LookAndFeel.SB_SetupDownButton(self);
}

function Paint (Canvas C, float X, float Y)
{
	if ( bDisabled && m_bHideSBWhenDisable )
	{
		return;
	}
	Super.Paint(C,X,Y);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	UWindowVScrollbar(ParentWindow).Scroll(UWindowVScrollbar(ParentWindow).ScrollAmount);
	NextClickTime=Root.GetPlayerOwner().Level.TimeSeconds + 0.50;
}

function Tick (float Delta)
{
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < Root.GetPlayerOwner().Level.TimeSeconds) )
	{
		UWindowVScrollbar(ParentWindow).Scroll(UWindowVScrollbar(ParentWindow).ScrollAmount);
		NextClickTime=Root.GetPlayerOwner().Level.TimeSeconds + 0.10;
	}
	if (  !bMouseDown )
	{
		NextClickTime=0.00;
	}
}
