//================================================================================
// R6WindowRightClickMenu.
//================================================================================
class R6WindowRightClickMenu extends R6WindowComboControl;

function CloseUp ()
{
	Super.CloseUp();
	HideWindow();
	if ( GetValue() != "" )
	{
		Notify(3);
	}
}

function DisplayMenuHere (float fXPos, float fYPos)
{
	SetValue("");
	List.Selected=None;
	if ( fXPos + WinWidth > 640 )
	{
		WinLeft=640.00 - WinWidth - 12;
	}
	else
	{
		WinLeft=fXPos;
	}
	WinTop=fYPos;
	ShowWindow();
	BringToFront();
	DropDown();
}

function Created ()
{
	WinHeight=0.00;
	Super.Created();
}