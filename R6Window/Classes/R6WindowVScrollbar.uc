//================================================================================
// R6WindowVScrollbar.
//================================================================================
class R6WindowVScrollbar extends UWindowVScrollbar;

var Class<UWindowSBUpButton> m_UpButtonClass;
var Class<UWindowSBDownButton> m_DownButtonClass;

function SetRange (float NewMinPos, float NewMaxPos, float NewMaxVisible, optional float NewScrollAmount)
{
	if ( NewScrollAmount == 0 )
	{
		NewScrollAmount=1.00;
	}
	ScrollAmount=NewScrollAmount;
	MaxPos=NewMaxPos - NewMaxVisible;
	MaxVisible=NewMaxVisible;
	MinPos=NewMinPos;
	CheckRange();
}

function CheckRange ()
{
	if ( pos < MinPos )
	{
		pos=MinPos;
	}
	else
	{
		if ( pos > MaxPos )
		{
			pos=MaxPos;
		}
	}
	bDisabled=MaxPos <= MinPos;
	DownButton.bDisabled=bDisabled;
	UpButton.bDisabled=bDisabled;
	if ( bDisabled )
	{
		pos=0.00;
		ThumbStart=0.00;
		ThumbHeight=0.00;
	}
	else
	{
		ThumbStart=(pos - MinPos) * (WinHeight - 2 * LookAndFeel.Size_ScrollbarButtonHeight + 2) / (MaxPos + MaxVisible - MinPos);
		ThumbHeight=MaxVisible * (WinHeight - 2 * LookAndFeel.Size_ScrollbarButtonHeight + 2) / (MaxPos + MaxVisible - MinPos);
		if ( ThumbHeight < LookAndFeel.Size_MinScrollbarHeight )
		{
			ThumbHeight=LookAndFeel.Size_MinScrollbarHeight;
		}
		if ( ThumbHeight + ThumbStart > WinHeight - LookAndFeel.Size_ScrollbarButtonHeight - 1 )
		{
			ThumbStart=WinHeight - LookAndFeel.Size_ScrollbarButtonHeight - 1 - ThumbHeight;
		}
		else
		{
			ThumbStart=ThumbStart + LookAndFeel.Size_ScrollbarButtonHeight + 1;
		}
	}
}