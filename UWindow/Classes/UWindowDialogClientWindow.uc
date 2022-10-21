//================================================================================
// UWindowDialogClientWindow.
//================================================================================
class UWindowDialogClientWindow extends UWindowClientWindow;

var float DesiredWidth;
var float DesiredHeight;
var UWindowDialogControl TabLast;

function OKPressed ()
{
}

function Notify (UWindowDialogControl C, byte E)
{
}

function UWindowDialogControl CreateControl (Class<UWindowDialogControl> ControlClass, float X, float Y, float W, float H, optional UWindowWindow OwnerWindow, optional bool _bNotTabRegister)
{
	local UWindowDialogControl C;

	C=UWindowDialogControl(CreateWindow(ControlClass,X,Y,W,H,OwnerWindow));
	C.Register(self);
//	C.Notify(C.0);
	if (  !_bNotTabRegister )
	{
		if ( TabLast == None )
		{
			TabLast=C;
			C.TabNext=C;
			C.TabPrev=C;
		}
		else
		{
			C.TabNext=TabLast.TabNext;
			C.TabPrev=TabLast;
			TabLast.TabNext.TabPrev=C;
			TabLast.TabNext=C;
			TabLast=C;
		}
	}
	return C;
}

function GetDesiredDimensions (out float W, out float H)
{
	W=DesiredWidth;
	H=DesiredHeight;
}
