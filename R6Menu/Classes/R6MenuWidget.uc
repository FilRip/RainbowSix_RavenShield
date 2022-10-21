//================================================================================
// R6MenuWidget.
//================================================================================
class R6MenuWidget extends UWindowDialogClientWindow;

var float m_fLeftMouseXClipping;
var float m_fLeftMouseYClipping;
var float m_fRightMouseXClipping;
var float m_fRightMouseYClipping;

function Reset ()
{
}

function SetMousePos (float X, float Y)
{
	Root.Console.MouseX=X;
	Root.Console.MouseY=Y;
}

function KeyDown (int Key, float X, float Y)
{
/*	if ( Key == Root.Console.27 )
	{
		switch (Root.m_eCurWidgetInUse)
		{
			case Root.5:
			case Root.14:
			case Root.4:
			case Root.15:
//			Root.ChangeCurrentWidget(7);
			break;
			case Root.19:
//			Root.ChangeCurrentWidget(15);
			break;
			case Root.16:
			R6MenuOptionsWidget(self).m_ButtonReturn.Click(0.00,0.00);
			break;
			case Root.13:
//			Root.ChangeCurrentWidget(17);
			break;
			case Root.8:
			case Root.12:
			case Root.9:
			R6MenuLaptopWidget(self).m_NavBar.m_MainMenuButton.Click(0.00,0.00);
			break;
			case Root.7:
			default:
		}
	}
	else
	{
	}  */
}

defaultproperties
{
    m_fRightMouseXClipping=640.00
    m_fRightMouseYClipping=480.00
    bAcceptsFocus=True
    bAlwaysAcceptsFocus=True
}
