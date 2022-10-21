//================================================================================
// R6MenuOptionsControls.
//================================================================================
class R6MenuOptionsControls extends UWindowDialogControl;

var int m_iLastKeyPressed;
var R6WindowButton m_pCancelButton;

function Created ()
{
	Super.Created();
	m_pCancelButton=R6WindowButton(CreateWindow(Class'R6WindowButton',180.00,225.00,280.00,25.00,self));
	m_pCancelButton.ToolTipString="";
	m_pCancelButton.Text=Localize("MultiPlayer","PopUp_Cancel","R6Menu");
	m_pCancelButton.Align=TA_Center;
	m_pCancelButton.m_fFontSpacing=0.00;
	m_pCancelButton.m_buttonFont=Root.Fonts[5];
	m_pCancelButton.ResizeToText();
}

function Register (UWindowDialogClientWindow W)
{
	Super.Register(W);
	m_pCancelButton.Register(W);
	SetAcceptsFocus();
	m_pCancelButton.CancelAcceptsFocus();
}

function ShowWindow ()
{
	SetAcceptsFocus();
	m_pCancelButton.CancelAcceptsFocus();
	Super.ShowWindow();
}

function HideWindow ()
{
	CancelAcceptsFocus();
	Super.HideWindow();
}

function KeyDown (int Key, float X, float Y)
{
	m_iLastKeyPressed=Key;
	NotifyWindow.Notify(self,2);
}

function LMouseDown (float X, float Y)
{
	Super.LMouseDown(X,Y);
//	m_iLastKeyPressed=GetPlayerOwner().Player.Console.1;
	NotifyWindow.Notify(self,2);
}

function MMouseDown (float X, float Y)
{
	Super.MMouseDown(X,Y);
//	m_iLastKeyPressed=GetPlayerOwner().Player.Console.4;
	NotifyWindow.Notify(self,2);
}

function RMouseDown (float X, float Y)
{
	Super.RMouseDown(X,Y);
//	m_iLastKeyPressed=GetPlayerOwner().Player.Console.2;
	NotifyWindow.Notify(self,2);
}

function MouseWheelDown (float X, float Y)
{
//	m_iLastKeyPressed=GetPlayerOwner().Player.Console.237;
	NotifyWindow.Notify(self,2);
}

function MouseWheelUp (float X, float Y)
{
//	m_iLastKeyPressed=GetPlayerOwner().Player.Console.236;
	NotifyWindow.Notify(self,2);
}
