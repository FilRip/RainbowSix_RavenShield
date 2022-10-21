//================================================================================
// UWindowConsoleClientWindow.
//================================================================================
class UWindowConsoleClientWindow extends UWindowDialogClientWindow;

var UWindowConsoleTextAreaControl TextArea;
var UWindowEditControl EditControl;

function Created ()
{
	TextArea=UWindowConsoleTextAreaControl(CreateWindow(Class'UWindowConsoleTextAreaControl',0.00,0.00,WinWidth,WinHeight));
	EditControl=UWindowEditControl(CreateControl(Class'UWindowEditControl',0.00,WinHeight - 16,WinWidth,16.00));
	EditControl.SetFont(0);
	EditControl.SetNumericOnly(False);
	EditControl.SetMaxLength(400);
	EditControl.SetHistory(True);
}

function Notify (UWindowDialogControl C, byte E)
{
	local string S;

	Super.Notify(C,E);
	switch (E)
	{
		case 7:
		switch (C)
		{
			case EditControl:
			if ( EditControl.GetValue() != "" )
			{
				S=EditControl.GetValue();
				Root.Console.Message("> " $ S,6.00);
				EditControl.Clear();
				if (  !Root.Console.ConsoleCommand(S) )
				{
					Root.Console.Message(Localize("Errors","Exec","R6Engine"),6.00);
				}
			}
			break;
			default:
		}
		break;
		case 14:
		switch (C)
		{
			case EditControl:
			TextArea.VertSB.Scroll(-1.00);
			break;
			default:
		}
		break;
		case 15:
		switch (C)
		{
			case EditControl:
			TextArea.VertSB.Scroll(1.00);
			break;
			default:
		}
		break;
		default:
	}
}

function BeforePaint (Canvas C, float X, float Y)
{
	Super.BeforePaint(C,X,Y);
	EditControl.SetSize(WinWidth,17.00);
	EditControl.WinLeft=0.00;
	EditControl.WinTop=WinHeight - EditControl.WinHeight;
	EditControl.EditBoxWidth=WinWidth;
	TextArea.SetSize(WinWidth,WinHeight - EditControl.WinHeight);
}

function Paint (Canvas C, float X, float Y)
{
//	DrawStretchedTexture(C,0.00,0.00,WinWidth,WinHeight,Texture'BlackTexture');
}
