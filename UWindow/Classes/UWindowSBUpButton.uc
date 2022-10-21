//================================================================================
// UWindowSBUpButton.
//================================================================================
class UWindowSBUpButton extends UWindowButton;

var bool m_bHideSBWhenDisable;
var float NextClickTime;

function Created ()
{
	bNoKeyboard=True;
	Super.Created();
	LookAndFeel.SB_SetupUpButton(self);
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
	UWindowVScrollbar(ParentWindow).Scroll( -UWindowVScrollbar(ParentWindow).ScrollAmount);
	NextClickTime=GetTime() + 0.50;
}

function Tick (float Delta)
{
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()) )
	{
		UWindowVScrollbar(ParentWindow).Scroll( -UWindowVScrollbar(ParentWindow).ScrollAmount);
		NextClickTime=GetTime() + 0.10;
	}
	if (  !bMouseDown )
	{
		NextClickTime=0.00;
	}
}
