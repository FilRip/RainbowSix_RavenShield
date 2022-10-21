//================================================================================
// UWindowMessageBoxArea.
//================================================================================
class UWindowMessageBoxArea extends UWindowWindow;

var string Message;

function float GetHeight (Canvas C)
{
	local float tW;
	local float tH;
	local float H;
	local int L;
	local float OldWinHeight;

	OldWinHeight=WinHeight;
	WinHeight=1000.00;
	C.Font=Root.Fonts[0];
	TextSize(C,"A",tW,tH);
	L=WrapClipText(C,0.00,0.00,Message,,,,True);
	H=tH * L;
	WinHeight=OldWinHeight;
	return H;
}

function Paint (Canvas C, float X, float Y)
{
	C.Font=Root.Fonts[0];
	C.SetDrawColor(0,0,0);
	WrapClipText(C,0.00,0.00,Message);
	C.SetDrawColor(255,255,255);
}
