//================================================================================
// UWindowHScrollbar.
//================================================================================
class UWindowHScrollbar extends UWindowDialogControl;

var int m_iScrollBarID;
var bool bDisabled;
var bool bDragging;
var bool m_bHideSBWhenDisable;
var float MinPos;
var float MaxPos;
var float MaxVisible;
var float pos;
var float ThumbStart;
var float ThumbWidth;
var float NextClickTime;
var float DragX;
var float ScrollAmount;
var UWindowSBLeftButton LeftButton;
var UWindowSBRightButton RightButton;
var Color m_SelectedColor;
var Color m_NormalColor;

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
	if ( P > pos )
	{
		if (  !Scroll(1.00) )
		{
			goto JL0071;
		}
		goto JL004C;
	}
JL0071:
}

function bool Scroll (float Delta)
{
	local float OldPos;

	OldPos=pos;
	pos=pos + Delta;
	CheckRange();
	Notify(1);
	return pos == OldPos + Delta;
}

function SetRange (float NewMinPos, float NewMaxPos, float NewMaxVisible, optional float NewScrollAmount)
{
	if ( NewScrollAmount == 0 )
	{
		NewScrollAmount=1.00;
	}
	ScrollAmount=NewScrollAmount;
	MinPos=NewMinPos;
	MaxPos=NewMaxPos - NewMaxVisible;
	MaxVisible=NewMaxVisible;
	CheckRange();
	Notify(1);
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
	LeftButton.bDisabled=bDisabled;
	RightButton.bDisabled=bDisabled;
	if ( bDisabled )
	{
		pos=0.00;
	}
	else
	{
		ThumbStart=(pos - MinPos) * (WinWidth - 2 * LookAndFeel.Size_ScrollbarButtonHeight + 2) / (MaxPos + MaxVisible - MinPos);
		ThumbWidth=MaxVisible * (WinWidth - 2 * LookAndFeel.Size_ScrollbarButtonHeight + 2) / (MaxPos + MaxVisible - MinPos);
		if ( ThumbWidth < LookAndFeel.Size_MinScrollbarHeight )
		{
			ThumbWidth=LookAndFeel.Size_MinScrollbarHeight;
		}
		if ( ThumbWidth + ThumbStart > WinWidth - LookAndFeel.Size_ScrollbarButtonHeight - 1 )
		{
			ThumbStart=WinWidth - LookAndFeel.Size_ScrollbarButtonHeight - 1 - ThumbWidth;
		}
		else
		{
			ThumbStart=ThumbStart + LookAndFeel.Size_ScrollbarButtonHeight + 1;
		}
	}
}

function Created ()
{
	m_SelectedColor=Root.Colors.ButtonTextColor[2];
	m_NormalColor=Root.Colors.White;
	LeftButton=UWindowSBLeftButton(CreateWindow(Class'UWindowSBLeftButton',0.00,0.00,LookAndFeel.Size_ScrollbarButtonHeight,LookAndFeel.Size_ScrollbarWidth));
	RightButton=UWindowSBRightButton(CreateWindow(Class'UWindowSBRightButton',WinWidth - LookAndFeel.Size_ScrollbarButtonHeight,0.00,LookAndFeel.Size_ScrollbarButtonHeight,LookAndFeel.Size_ScrollbarWidth));
}

function Register (UWindowDialogClientWindow W)
{
	Super.Register(W);
	LeftButton.Register(W);
	RightButton.Register(W);
}

function BeforePaint (Canvas C, float X, float Y)
{
	CheckRange();
}

function Paint (Canvas C, float X, float Y)
{
	if ( bDisabled && m_bHideSBWhenDisable )
	{
		return;
	}
	if ( MouseIsOver() || LeftButton.MouseIsOver() || RightButton.MouseIsOver() )
	{
		SetBorderColor(m_SelectedColor);
		AdviceParent(True);
	}
	else
	{
		if ( m_BorderColor!=m_NormalColor )
		{
			SetBorderColor(m_NormalColor);
			AdviceParent(False);
		}
	}
	LookAndFeel.SB_HDraw(self,C);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	if ( X < ThumbStart )
	{
		Scroll( -MaxVisible - 1);
		NextClickTime=GetTime() + 0.50;
		return;
	}
	if ( X > ThumbStart + ThumbWidth )
	{
		Scroll(MaxVisible - 1);
		NextClickTime=GetTime() + 0.50;
		return;
	}
	if ( (X >= ThumbStart) && (X <= ThumbStart + ThumbWidth) )
	{
		DragX=X - ThumbStart;
		bDragging=True;
		Root.CaptureMouse();
		return;
	}
}

function Tick (float Delta)
{
	local bool bLeft;
	local bool bRight;
	local float X;
	local float Y;

	if ( bDragging )
	{
		return;
	}
	bLeft=False;
	bRight=False;
	if ( bMouseDown )
	{
		GetMouseXY(X,Y);
		bLeft=X < ThumbStart;
		bRight=X > ThumbStart + ThumbWidth;
	}
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()) && bLeft )
	{
		Scroll( -MaxVisible - 1);
		NextClickTime=GetTime() + 0.10;
	}
	if ( bMouseDown && (NextClickTime > 0) && (NextClickTime < GetTime()) && bRight )
	{
		Scroll(MaxVisible - 1);
		NextClickTime=GetTime() + 0.10;
	}
	if (  !bMouseDown ||  !bLeft &&  !bRight )
	{
		NextClickTime=0.00;
	}
}

function MouseMove (float X, float Y)
{
	if ( bDragging && bMouseDown &&  !bDisabled )
	{
JL0021:
		if ( (X < ThumbStart + DragX) && (pos > MinPos) )
		{
			Scroll(-1.00);
			goto JL0021;
		}
JL0056:
		if ( (X > ThumbStart + DragX) && (pos < MaxPos) )
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

function MouseEnter ()
{
	Super.MouseEnter();
	AdviceParent(True);
}

function MouseLeave ()
{
	Super.MouseLeave();
	AdviceParent(False);
}

function AdviceParent (bool _bMouseEnter)
{
	if ( _bMouseEnter )
	{
		OwnerWindow.MouseEnter();
	}
	else
	{
		OwnerWindow.MouseLeave();
	}
}

function SetHideWhenDisable (bool _bHideWhenDisable)
{
	m_bHideSBWhenDisable=_bHideWhenDisable;
	LeftButton.m_bHideSBWhenDisable=_bHideWhenDisable;
	RightButton.m_bHideSBWhenDisable=_bHideWhenDisable;
}

function SetBorderColor (Color C)
{
	m_BorderColor=C;
	LeftButton.m_BorderColor=C;
	RightButton.m_BorderColor=C;
}
