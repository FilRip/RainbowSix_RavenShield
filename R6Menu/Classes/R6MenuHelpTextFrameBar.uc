//================================================================================
// R6MenuHelpTextFrameBar.
//================================================================================
class R6MenuHelpTextFrameBar extends UWindowWindow;

var R6MenuHelpTextBar m_HelpTextBar;

function Created ()
{
	m_HelpTextBar=R6MenuHelpTextBar(CreateWindow(Class'R6MenuHelpTextBar',0.00,1.00,WinWidth,WinHeight - 2,self));
	m_BorderColor=Root.Colors.BlueLight;
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}