//================================================================================
// R6WindowFramedWindow.
//================================================================================
class R6WindowFramedWindow extends UWindowWindow;
//	Localized;

var TextAlign m_TitleAlign;
var bool m_bTLSizing;
var bool m_bTSizing;
var bool m_bTRSizing;
var bool m_bLSizing;
var bool m_bRSizing;
var bool m_bBLSizing;
var bool m_bBSizing;
var bool m_bBRSizing;
var bool m_bMoving;
var bool m_bSizable;
var bool m_bMovable;
var bool m_bDisplayClose;
var float m_fMoveX;
var float m_fMoveY;
var float m_fMinWinWidth;
var float m_fMinWinHeight;
var float m_fTitleOffSet;
var UWindowWindow m_ClientArea;
var UWindowButton m_CloseBoxButton;
var Class<UWindowWindow> m_ClientClass;
var localized string m_szWindowTitle;
var string m_szStatusBarText;

function Created ()
{
	m_ClientArea=CreateWindow(m_ClientClass,LookAndFeel.FrameL.W,LookAndFeel.FrameT.H,WinWidth - LookAndFeel.FrameL.W + LookAndFeel.FrameR.W,WinHeight - LookAndFeel.FrameB.H + LookAndFeel.FrameT.H,OwnerWindow);
	if ( m_bDisplayClose )
	{
		m_CloseBoxButton=UWindowFrameCloseBox(CreateWindow(Class'UWindowFrameCloseBox',WinWidth - LookAndFeel.FrameTL.W - R6WindowLookAndFeel(LookAndFeel).m_CloseBoxUp.W - 1,1.00,R6WindowLookAndFeel(LookAndFeel).m_CloseBoxUp.W,R6WindowLookAndFeel(LookAndFeel).m_CloseBoxUp.H,self));
	}
}

function Texture GetLookAndFeelTexture ()
{
	return R6WindowLookAndFeel(LookAndFeel).R6GetTexture(self);
}

function bool IsActive ()
{
	return ParentWindow.ActiveWindow == self;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	Super.BeforePaint(C,X,Y);
	if ( m_bSizable )
	{
		Resized();
	}
	if ( m_CloseBoxButton != None )
	{
		R6WindowLookAndFeel(LookAndFeel).R6FW_SetupFrameButtons(self,C);
	}
	if ( m_szWindowTitle != "" )
	{
		C.Font=Root.Fonts[8];
		TextSize(C,m_szWindowTitle,W,H);
		switch (m_TitleAlign)
		{
/*			case 0:
			m_fTitleOffSet=LookAndFeel.FrameTL.W;
			break;
			case 1:
			m_fTitleOffSet=WinWidth - W - LookAndFeel.FrameTL.W;
			break;
			case 2:
			m_fTitleOffSet=(WinWidth - W) / 2;
			break;
			default:*/
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	R6WindowLookAndFeel(LookAndFeel).R6FW_DrawWindowFrame(self,C);
}

function LMouseDown (float X, float Y)
{
	local FrameHitTest H;

	Super.LMouseDown(X,Y);
	H=R6WindowLookAndFeel(LookAndFeel).R6FW_HitTest(self,X,Y);
	if ( m_bMovable )
	{
		if ( H == 8 )
		{
			m_fMoveX=X;
			m_fMoveY=Y;
			m_bMoving=True;
			Root.CaptureMouse();
			return;
		}
	}
	if ( m_bSizable )
	{
		switch (H)
		{
/*			case 0:
			m_bTLSizing=True;
			Root.CaptureMouse();
			return;
			case 2:
			m_bTRSizing=True;
			Root.CaptureMouse();
			return;
			case 5:
			m_bBLSizing=True;
			Root.CaptureMouse();
			return;
			case 7:
			m_bBRSizing=True;
			Root.CaptureMouse();
			return;
			case 1:
			m_bTSizing=True;
			Root.CaptureMouse();
			return;
			case 6:
			m_bBSizing=True;
			Root.CaptureMouse();
			return;
			case 3:
			m_bLSizing=True;
			Root.CaptureMouse();
			return;
			case 4:
			m_bRSizing=True;
			Root.CaptureMouse();
			return;
			default:*/
		}
	}
}

function Resized ()
{
	local Region R;

	if ( m_ClientArea == None )
	{
		return;
	}
	R=R6WindowLookAndFeel(LookAndFeel).R6FW_GetClientArea(self);
	m_ClientArea.WinLeft=R.X;
	m_ClientArea.WinTop=R.Y;
	if ( (R.W != m_ClientArea.WinWidth) || (R.H != m_ClientArea.WinHeight) )
	{
		m_ClientArea.SetSize(R.W,R.H);
	}
}

function MouseMove (float X, float Y)
{
	local float fOldW;
	local float fOldH;
	local FrameHitTest H;

	H=R6WindowLookAndFeel(LookAndFeel).R6FW_HitTest(self,X,Y);
	if ( m_bMovable )
	{
		if ( m_bMoving && bMouseDown )
		{
			WinLeft=WinLeft + X - m_fMoveX;
			WinTop=WinTop + Y - m_fMoveY;
		}
		else
		{
			m_bMoving=False;
		}
	}
	Cursor=Root.NormalCursor;
	if ( m_bSizable &&  !m_bMoving )
	{
		switch (H)
		{
/*			case 0:
			case 7:
			Cursor=Root.DiagCursor1;
			break;
			case 2:
			case 5:
			Cursor=Root.DiagCursor2;
			break;
			case 3:
			case 4:
			Cursor=Root.WECursor;
			break;
			case 1:
			case 6:
			Cursor=Root.NSCursor;
			break;
			default:*/
		}
	}
	if ( bMouseDown )
	{
		if ( m_bTLSizing )
		{
			Cursor=Root.DiagCursor1;
			fOldW=WinWidth;
			fOldH=WinHeight;
			SetSize(Max(m_fMinWinWidth,WinWidth - X),Max(m_fMinWinHeight,WinHeight - Y));
			WinLeft=WinLeft + fOldW - WinWidth;
			WinTop=WinTop + fOldH - WinHeight;
		}
		if ( m_bTSizing )
		{
			Cursor=Root.NSCursor;
			fOldH=WinHeight;
			SetSize(WinWidth,Max(m_fMinWinHeight,WinHeight - Y));
			WinTop=WinTop + fOldH - WinHeight;
		}
		if ( m_bTRSizing )
		{
			Cursor=Root.DiagCursor2;
			fOldH=WinHeight;
			SetSize(Max(m_fMinWinWidth,X),Max(m_fMinWinHeight,WinHeight - Y));
			WinTop=WinTop + fOldH - WinHeight;
		}
		if ( m_bLSizing )
		{
			Cursor=Root.WECursor;
			fOldW=WinWidth;
			SetSize(Max(m_fMinWinWidth,WinWidth - X),WinHeight);
			WinLeft=WinLeft + fOldW - WinWidth;
		}
		if ( m_bRSizing )
		{
			Cursor=Root.WECursor;
			SetSize(Max(m_fMinWinWidth,X),WinHeight);
		}
		if ( m_bBLSizing )
		{
			Cursor=Root.DiagCursor2;
			fOldW=WinWidth;
			SetSize(Max(m_fMinWinWidth,WinWidth - X),Max(m_fMinWinHeight,Y));
			WinLeft=WinLeft + fOldW - WinWidth;
		}
		if ( m_bBSizing )
		{
			Cursor=Root.NSCursor;
			SetSize(WinWidth,Max(m_fMinWinHeight,Y));
		}
		if ( m_bBRSizing )
		{
			Cursor=Root.DiagCursor1;
			SetSize(Max(m_fMinWinWidth,X),Max(m_fMinWinHeight,Y));
		}
	}
	else
	{
		m_bTLSizing=False;
		m_bTSizing=False;
		m_bTRSizing=False;
		m_bLSizing=False;
		m_bRSizing=False;
		m_bBLSizing=False;
		m_bBSizing=False;
		m_bBRSizing=False;
	}
}

function ToolTip (string strTip)
{
	m_szStatusBarText=strTip;
}

function WindowEvent (WinMessage Msg, Canvas C, float X, float Y, int iKey)
{
	if ( (Msg == 11) ||  !WaitModal() )
	{
		Super.WindowEvent(Msg,C,X,Y,iKey);
	}
	else
	{
		if ( WaitModal() )
		{
			ModalWindow.WindowEvent(Msg,C,X - ModalWindow.WinLeft,Y - ModalWindow.WinTop,iKey);
		}
	}
}

function WindowHidden ()
{
	Super.WindowHidden();
//	LookAndFeel.PlayMenuSound(self,4);
}

function SetDisplayClose (bool bNewDisplay)
{
	m_bDisplayClose=bNewDisplay;
	if ( m_bDisplayClose )
	{
		if ( m_CloseBoxButton == None )
		{
			m_CloseBoxButton=UWindowFrameCloseBox(CreateWindow(Class'UWindowFrameCloseBox',WinWidth - LookAndFeel.FrameTL.W - R6WindowLookAndFeel(LookAndFeel).m_CloseBoxUp.W - 1,1.00,R6WindowLookAndFeel(LookAndFeel).m_CloseBoxUp.W,R6WindowLookAndFeel(LookAndFeel).m_CloseBoxUp.H,self));
			m_CloseBoxButton.ShowWindow();
		}
	}
	else
	{
		if ( m_CloseBoxButton != None )
		{
			m_CloseBoxButton.Close();
		}
	}
}

defaultproperties
{
    m_bDisplayClose=True
    m_fMinWinWidth=20.00
    m_fMinWinHeight=20.00
    m_ClientClass=Class'UWindow.UWindowClientWindow'
}
