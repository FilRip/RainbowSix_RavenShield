//================================================================================
// UWindowMessageBoxCW.
//================================================================================
class UWindowMessageBoxCW extends UWindowDialogClientWindow;

var MessageBoxButtons Buttons;
var MessageBoxResult EnterResult;
var UWindowSmallButton YesButton;
var UWindowSmallButton NoButton;
var UWindowSmallButton OKButton;
var UWindowSmallButton CancelButton;
var UWindowMessageBoxArea MessageArea;
var localized string YesText;
var localized string NoText;
var localized string OKText;
var localized string CancelText;

function Created ()
{
	Super.Created();
	SetAcceptsFocus();
	MessageArea=UWindowMessageBoxArea(CreateWindow(Class'UWindowMessageBoxArea',10.00,10.00,WinWidth - 20,WinHeight - 44));
}

function KeyDown (int Key, float X, float Y)
{
	local UWindowMessageBox P;

	P=UWindowMessageBox(ParentWindow);
/*	if ( (Key == GetPlayerOwner().Player.Console.13) && (EnterResult != 0) )
	{
		P=UWindowMessageBox(ParentWindow);
		P.Result=EnterResult;
		P.Close();
	}*/
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	MessageArea.SetSize(WinWidth - 20,WinHeight - 44);
	switch (Buttons)
	{
		case MB_YesNoCancel:
		CancelButton.WinLeft=WinWidth - 52;
		CancelButton.WinTop=WinHeight - 20;
		NoButton.WinLeft=WinWidth - 104;
		NoButton.WinTop=WinHeight - 20;
		YesButton.WinLeft=WinWidth - 156;
		YesButton.WinTop=WinHeight - 20;
		break;
		case MB_YesNo:
		NoButton.WinLeft=WinWidth - 52;
		NoButton.WinTop=WinHeight - 20;
		YesButton.WinLeft=WinWidth - 104;
		YesButton.WinTop=WinHeight - 20;
		break;
		case MB_OKCancel:
		CancelButton.WinLeft=WinWidth - 52;
		CancelButton.WinTop=WinHeight - 20;
		OKButton.WinLeft=WinWidth - 104;
		OKButton.WinTop=WinHeight - 20;
		break;
		case MB_OK:
		OKButton.WinLeft=WinWidth - 52;
		OKButton.WinTop=WinHeight - 20;
		break;
		default:
	}
}

function Resized ()
{
	Super.Resized();
	MessageArea.SetSize(WinWidth - 20,WinHeight - 44);
}

function float GetHeight (Canvas C)
{
	return 44.00 + MessageArea.GetHeight(C);
}

function Paint (Canvas C, float X, float Y)
{
	local Texture t;

	Super.Paint(C,X,Y);
	t=GetLookAndFeelTexture();
	DrawUpBevel(C,0.00,WinHeight - 24,WinWidth,24.00,t);
}

function SetupMessageBoxClient (string InMessage, MessageBoxButtons InButtons, MessageBoxResult InEnterResult)
{
	MessageArea.Message=InMessage;
	Buttons=InButtons;
	EnterResult=InEnterResult;
	switch (Buttons)
	{
		case MB_YesNoCancel:
		CancelButton=UWindowSmallButton(CreateControl(Class'UWindowSmallButton',WinWidth - 52,WinHeight - 20,48.00,16.00));
		CancelButton.SetText(CancelText);
		if ( EnterResult == 4 )
		{
			CancelButton.SetFont(1);
		}
		else
		{
			CancelButton.SetFont(0);
		}
		NoButton=UWindowSmallButton(CreateControl(Class'UWindowSmallButton',WinWidth - 104,WinHeight - 20,48.00,16.00));
		NoButton.SetText(NoText);
		if ( EnterResult == 2 )
		{
			NoButton.SetFont(1);
		}
		else
		{
			NoButton.SetFont(0);
		}
		YesButton=UWindowSmallButton(CreateControl(Class'UWindowSmallButton',WinWidth - 156,WinHeight - 20,48.00,16.00));
		YesButton.SetText(YesText);
		if ( EnterResult == 1 )
		{
			YesButton.SetFont(1);
		}
		else
		{
			YesButton.SetFont(0);
		}
		break;
		case MB_YesNo:
		NoButton=UWindowSmallButton(CreateControl(Class'UWindowSmallButton',WinWidth - 52,WinHeight - 20,48.00,16.00));
		NoButton.SetText(NoText);
		if ( EnterResult == 2 )
		{
			NoButton.SetFont(1);
		}
		else
		{
			NoButton.SetFont(0);
		}
		YesButton=UWindowSmallButton(CreateControl(Class'UWindowSmallButton',WinWidth - 104,WinHeight - 20,48.00,16.00));
		YesButton.SetText(YesText);
		if ( EnterResult == 1 )
		{
			YesButton.SetFont(1);
		}
		else
		{
			YesButton.SetFont(0);
		}
		break;
		case MB_OKCancel:
		CancelButton=UWindowSmallButton(CreateControl(Class'UWindowSmallButton',WinWidth - 52,WinHeight - 20,48.00,16.00));
		CancelButton.SetText(CancelText);
		if ( EnterResult == 4 )
		{
			CancelButton.SetFont(1);
		}
		else
		{
			CancelButton.SetFont(0);
		}
		OKButton=UWindowSmallButton(CreateControl(Class'UWindowSmallButton',WinWidth - 104,WinHeight - 20,48.00,16.00));
		OKButton.SetText(OKText);
		if ( EnterResult == 3 )
		{
			OKButton.SetFont(1);
		}
		else
		{
			OKButton.SetFont(0);
		}
		break;
		case MB_OK:
		OKButton=UWindowSmallButton(CreateControl(Class'UWindowSmallButton',WinWidth - 52,WinHeight - 20,48.00,16.00));
		OKButton.SetText(OKText);
		if ( EnterResult == 3 )
		{
			OKButton.SetFont(1);
		}
		else
		{
			OKButton.SetFont(0);
		}
		break;
		default:
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	local UWindowMessageBox P;

	P=UWindowMessageBox(ParentWindow);
	if ( E == 2 )
	{
		switch (C)
		{
/*			case YesButton:
			P.Result=1;
			P.Close();
			break;
			case NoButton:
			P.Result=2;
			P.Close();
			break;
			case OKButton:
			P.Result=3;
			P.Close();
			break;
			case CancelButton:
			P.Result=4;
			P.Close();
			break;
			default:*/
		}
	}
}

defaultproperties
{
    YesText="YES"
    NoText="NO"
    OKText="OK"
    CancelText="CANCEL"
}
