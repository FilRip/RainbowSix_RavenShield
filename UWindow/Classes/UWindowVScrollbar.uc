//================================================================================
// UWindowVScrollbar.
//================================================================================
class UWindowVScrollbar extends UWindowWindow;

var bool bDragging;
var bool bDisabled;
var bool m_bHideSBWhenDisable;
var bool m_bUseSpecialEffect;
var float MinPos;
var float MaxPos;
var float MaxVisible;
var float pos;
var float ThumbStart;
var float ThumbHeight;
var float NextClickTime;
var float DragY;
var float ScrollAmount;
var UWindowSBUpButton UpButton;
var UWindowSBDownButton DownButton;

function Show (float P)
{
	if ( P < 0 )
	{
		return;
	}
	if ( P > MaxPos + MaxVisible )
	{
		return;
	}
JL0027:
	if ( P < pos )
	{
		if (  !Scroll(-1.00) )
		{
			goto JL004C;
		}
		goto JL0027;
	}
JL004C:
	if ( P - pos > MaxVisible - 1 )
	{
		if (  !Scroll(1.00) )
		{
			goto JL007D;
		}
		goto JL004C;
	}
JL007D:
}

function bool Scroll (float Delta)
{
	local float OldPos;

	OldPos=pos;
	pos=pos + Delta;
	CheckRange();
	return pos == OldPos + Delta;
}

function SetRange (float NewMinPos, float NewMaxPos, float NewMaxVisible, optional float NewScrollAmount)
{
	if ( NewScrollAmount == 0 )
	{
		NewScrollAmount=1.00;
	}
	ScrollAmount=NewScrollAmount;
	MaxPos=NewMaxPos - NewMaxVisible;
	MaxVisible=NewMaxVisible;
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
			ThumbStart=WinHeight - LookAndFeel.Size_ScrollbarButtonHeight - ThumbHeight - 1;
		}
		else
		{
			ThumbStart=ThumbStart + LookAndFeel.Size_ScrollbarButtonHeight + 1;
		}
	}
}

function Created ()
{
	UpButton=UWindowSBUpButton(CreateWindow(Class'UWindowSBUpButton',0.00,0.00,LookAndFeel.Size_ScrollbarWidth,LookAndFeel.Size_ScrollbarButtonHeight));
	DownButton=UWindowSBDownButton(CreateWindow(Class'UWindowSBDownButton',0.00,WinHeight - LookAndFeel.Size_ScrollbarButtonHeight,LookAndFeel.Size_ScrollbarWidth,LookAndFeel.Size_ScrollbarButtonHeight));
}

function SetEffect (bool _effect)
{
	m_bUseSpecialEffect=_effect;
	LookAndFeel.SB_SetupUpButton(UpButton);
	LookAndFeel.SB_SetupDownButton(DownButton);
}

function BeforePaint (Canvas C, float X, float Y)
{
	UpButton.WinTop=0.00;
	UpButton.WinLeft=0.00;
	UpButton.WinWidth=LookAndFeel.Size_ScrollbarWidth;
	UpButton.WinHeight=LookAndFeel.Size_ScrollbarButtonHeight;
	DownButton.WinTop=WinHeight - LookAndFeel.Size_ScrollbarButtonHeight;
	DownButton.WinLeft=0.00;
	DownButton.WinWidth=LookAndFeel.Size_ScrollbarWidth;
	DownButton.WinHeight=LookAndFeel.Size_ScrollbarButtonHeight;
	CheckRange();
}

function Paint (Canvas C, float X, float Y)
{
	if ( isHidden() )
	{
		return;
	}
	LookAndFeel.SB_VDraw(self,C);
}

function bool isHidden ()
{
	return bDisabled && m_bHideSBWhenDisable;
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	if ( Y < ThumbStart )
	{
		Scroll( -MaxVisible - 1);
		NextClickTime=GetTime() + 0.50;
		return;
	}
	if ( Y > ThumbStart + ThumbHeight )
	{
		Scroll(MaxVisible - 1);
		NextClickTime=GetTime() + 0.50;
		return;
	}
	if ( (Y >= ThumbStart) && (Y <= ThumbStart + ThumbHeight) )
	{
		DragY=Y - ThumbStart;
		bDragging=True;
		Root.CaptureMouse();
		return;
	}
}

function MouseWheelDown (float X, float Y)
{
	Scroll(2.00);
}

function MouseWheelUp (float X, float Y)
{
	Scroll(-2.00);
}

function Tick (float Delta)
{
	local bool bUp;
	local bool bDown;
	local float X;
	local float Y;

	if ( bDragging )
	{
		return;
	}
	bUp=False;
	bDown=False;
	if ( bMouseDown )
	{
		GetMouseXY(X,Y);
		bUp=Y < ThumbStart;
		bDown=Y > ThumbStart + ThumbHeight;
	}
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()) && bUp )
	{
		Scroll( -MaxVisible - 1);
		NextClickTime=GetTime() + 0.10;
	}
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()) && bDown )
	{
		Scroll(MaxVisible - 1);
		NextClickTime=GetTime() + 0.10;
	}
	if (  !bMouseDown ||  !bUp &&  !bDown )
	{
		NextClickTime=0.00;
	}
}

function MouseMove (float X, float Y)
{
	if ( bDragging && bMouseDown &&  !bDisabled )
	{
JL0021:
		if ( (Y < ThumbStart + DragY) && (pos > MinPos) )
		{
			Scroll(-1.00);
			goto JL0021;
		}
JL0056:
		if ( (Y > ThumbStart + DragY) && (pos < MaxPos) )
		{
			Scroll(1.00);
			goto JL0056;
		}
	}
	else
	{
		bDragging=False;
	}
}

function SetBorderColor (Color C)
{
	m_BorderColor=C;
	UpButton.m_BorderColor=C;
	DownButton.m_BorderColor=C;
}

function SetHideWhenDisable (bool _bHideWhenDisable)
{
	m_bHideSBWhenDisable=_bHideWhenDisable;
	UpButton.m_bHideSBWhenDisable=_bHideWhenDisable;
	DownButton.m_bHideSBWhenDisable=_bHideWhenDisable;
}
