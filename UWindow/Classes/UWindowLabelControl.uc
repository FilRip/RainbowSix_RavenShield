//================================================================================
// UWindowLabelControl.
//================================================================================
class UWindowLabelControl extends UWindowDialogControl;

function Created ()
{
	TextX=0.00;
	TextY=0.00;
}

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	Super.BeforePaint(C,X,Y);
	TextSize(C,Text,W,H);
	WinHeight=H + 1;
	TextY=(WinHeight - H) / 2;
	switch (Align)
	{
		case TA_Left:
		break;
		case TA_Center:
		TextX=(WinWidth - W) / 2;
		break;
		case TA_Right:
		TextX=WinWidth - W;
		break;
		default:
	}
}

function Paint (Canvas C, float X, float Y)
{
	if ( Text != "" )
	{
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
		C.Font=Root.Fonts[Font];
		ClipText(C,TextX,TextY,Text);
		C.SetDrawColor(255,255,255);
	}
}
