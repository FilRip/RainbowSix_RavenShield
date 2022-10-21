//================================================================================
// UWindowControlFrame.
//================================================================================
class UWindowControlFrame extends UWindowWindow;

var UWindowWindow Framed;

function SetFrame (UWindowWindow W)
{
	Framed=W;
	W.SetParent(self);
}

function BeforePaint (Canvas C, float X, float Y)
{
	if ( Framed != None )
	{
		LookAndFeel.ControlFrame_SetupSizes(self,C);
	}
}

function Paint (Canvas C, float X, float Y)
{
	LookAndFeel.ControlFrame_Draw(self,C);
}
