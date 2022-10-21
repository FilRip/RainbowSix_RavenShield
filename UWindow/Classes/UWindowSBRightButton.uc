//================================================================================
// UWindowSBRightButton.
//================================================================================
class UWindowSBRightButton extends UWindowButton;

var bool m_bHideSBWhenDisable;
var float NextClickTime;

function Created ()
{
	bNoKeyboard=True;
	Super.Created();
	LookAndFeel.SB_SetupRightButton(self);
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
	UWindowHScrollbar(ParentWindow).Scroll(UWindowHScrollbar(ParentWindow).ScrollAmount);
	NextClickTime=GetTime() + 0.50;
}

function Tick (float Delta)
{
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()) )
	{
		UWindowHScrollbar(ParentWindow).Scroll(UWindowHScrollbar(ParentWindow).ScrollAmount);
		NextClickTime=GetTime() + 0.10;
	}
	if (  !bMouseDown )
	{
		NextClickTime=0.00;
	}
}

function MouseLeave ()
{
	Super.MouseLeave();
	UWindowHScrollbar(OwnerWindow).MouseLeave();
}

function MouseEnter ()
{
	Super.MouseEnter();
	UWindowHScrollbar(OwnerWindow).MouseEnter();
}
