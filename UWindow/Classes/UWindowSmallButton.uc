//================================================================================
// UWindowSmallButton.
//================================================================================
class UWindowSmallButton extends UWindowButton;

function Created ()
{
	bNoKeyboard=True;
	Super.Created();
	ToolTipString="";
	SetText("");
	SetFont(0);
	WinHeight=16.00;
}

function AutoWidth (Canvas C)
{
	local float W;
	local float H;

	C.Font=Root.Fonts[Font];
	TextSize(C,RemoveAmpersand(Text),W,H);
	if ( WinWidth < W + 10 )
	{
		WinWidth=W + 10;
	}
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	C.Font=Root.Fonts[Font];
	TextSize(C,RemoveAmpersand(Text),W,H);
	TextX=(WinWidth - W) / 2;
	TextY=(WinHeight - H) / 2;
	if ( bMouseDown )
	{
		TextX += 1;
		TextY += 1;
	}
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.Button_DrawSmallButton(self,C);
	Super.Paint(C,X,Y);
}
