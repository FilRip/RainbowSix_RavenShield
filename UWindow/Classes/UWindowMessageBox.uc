//================================================================================
// UWindowMessageBox.
//================================================================================
class UWindowMessageBox extends UWindowFramedWindow;

var MessageBoxResult Result;
var int TimeOut;
var int FrameCount;
var bool bSetupSize;
var float TimeOutTime;

function SetupMessageBox (string Title, string Message, MessageBoxButtons Buttons, MessageBoxResult InESCResult, optional MessageBoxResult InEnterResult, optional int InTimeOut)
{
	WindowTitle=Title;
	UWindowMessageBoxCW(ClientArea).SetupMessageBoxClient(Message,Buttons,InEnterResult);
	Result=InESCResult;
	TimeOutTime=0.00;
	TimeOut=InTimeOut;
	FrameCount=0;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local Region R;

	if (  !bSetupSize )
	{
		SetSize(200.00,WinHeight);
		R=LookAndFeel.FW_GetClientArea(self);
		SetSize(200.00,WinHeight - R.H + UWindowMessageBoxCW(ClientArea).GetHeight(C));
		WinLeft=(Root.WinWidth - WinWidth) / 2;
		WinTop=(Root.WinHeight - WinHeight) / 2;
		bSetupSize=True;
	}
	Super.BeforePaint(C,X,Y);
}

function AfterPaint (Canvas C, float X, float Y)
{
	Super.AfterPaint(C,X,Y);
	if ( TimeOut != 0 )
	{
		FrameCount++;
		if ( FrameCount >= 5 )
		{
			TimeOutTime=GetEntryLevel().TimeSeconds + TimeOut;
			TimeOut=0;
		}
	}
	if ( (TimeOutTime != 0) && (GetEntryLevel().TimeSeconds > TimeOutTime) )
	{
		TimeOutTime=0.00;
		Close();
	}
}

function Close (optional bool bByParent)
{
	Super.Close(bByParent);
	OwnerWindow.MessageBoxDone(self,Result);
}

defaultproperties
{
    ClientClass=Class'UWindowMessageBoxCW'
}
