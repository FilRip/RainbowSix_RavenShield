//================================================================================
// R6MenuLaptopWidget.
//================================================================================
class R6MenuLaptopWidget extends R6MenuWidget;

var float m_fLaptopPadding;
var R6MenuNavigationBar m_NavBar;
var R6MenuHelpTextFrameBar m_HelpTextBar;
var R6MenuSimpleWindow m_EmptyBox1;
var R6MenuSimpleWindow m_EmptyBox2;
var UWindowWindow m_Right;
var UWindowWindow m_Left;
var UWindowWindow m_Bottom;
var UWindowWindow m_Top;
var Texture m_TBackGround;
var Region m_RBackGround;

function Created ()
{
	local R6MenuRSLookAndFeel LAF;
	local Region R;

	LAF=R6MenuRSLookAndFeel(OwnerWindow.LookAndFeel);
	m_Left=CreateWindow(Class'UWindowWindow',0.00,LAF.m_stLapTopFrame.t.H,LAF.m_stLapTopFrame.L.W,LAF.m_stLapTopFrame.L.H + LAF.m_stLapTopFrame.L2.H + LAF.m_stLapTopFrame.L3.H + LAF.m_stLapTopFrame.L4.H,self);
	m_Right=CreateWindow(Class'UWindowWindow',LAF.m_stLapTopFrame.BL.W + LAF.m_stLapTopFrame.B.W + LAF.m_stLapTopFrame.BR.W - LAF.m_stLapTopFrame.R.W,LAF.m_stLapTopFrame.t.H,LAF.m_stLapTopFrame.R.W,LAF.m_stLapTopFrame.R.H + LAF.m_stLapTopFrame.R2.H + LAF.m_stLapTopFrame.R3.H + LAF.m_stLapTopFrame.R4.H,self);
	m_Bottom=CreateWindow(Class'UWindowWindow',0.00,LAF.m_stLapTopFrame.t.H + LAF.m_stLapTopFrame.L.H + LAF.m_stLapTopFrame.L2.H + LAF.m_stLapTopFrame.L3.H + LAF.m_stLapTopFrame.L4.H,LAF.m_stLapTopFrame.BL.W + LAF.m_stLapTopFrame.B.W + LAF.m_stLapTopFrame.BR.W,LAF.m_stLapTopFrame.B.H,self);
	m_Top=CreateWindow(Class'UWindowWindow',0.00,0.00,LAF.m_stLapTopFrame.BL.W + LAF.m_stLapTopFrame.B.W + LAF.m_stLapTopFrame.BR.W,LAF.m_stLapTopFrame.t.H,self);
	m_Left.HideWindow();
	m_Right.HideWindow();
	m_Bottom.HideWindow();
	m_Top.HideWindow();
	R.H=33;
	R.X=LAF.m_stLapTopFrame.L.W + 2;
	R.Y=m_Bottom.WinTop - R.H - m_fLaptopPadding;
	R.W=640 - 2 * R.X;
	m_NavBar=R6MenuNavigationBar(CreateWindow(Class'R6MenuNavigationBar',R.X,R.Y,R.W,R.H,self));
	R.H=16;
	R.Y=m_NavBar.WinTop - R.H - m_fLaptopPadding;
	R.X=m_NavBar.WinLeft;
	R.W=35;
	m_EmptyBox1=R6MenuSimpleWindow(CreateWindow(Class'R6MenuSimpleWindow',R.X,R.Y,R.W,R.H,self));
	m_EmptyBox1.m_BorderColor=Root.Colors.BlueLight;
	R.X=m_NavBar.WinLeft + m_NavBar.WinWidth - R.W;
	m_EmptyBox2=R6MenuSimpleWindow(CreateWindow(Class'R6MenuSimpleWindow',R.X,R.Y,R.W,R.H,self));
	m_EmptyBox2.m_BorderColor=Root.Colors.BlueLight;
	R.H=16;
	R.Y=m_NavBar.WinTop - R.H - m_fLaptopPadding;
	R.X=m_NavBar.WinLeft + R.W + 2;
	R.W=m_NavBar.WinWidth - 2 * R.W - 4;
	m_HelpTextBar=R6MenuHelpTextFrameBar(CreateWindow(Class'R6MenuHelpTextFrameBar',R.X,R.Y,R.W,R.H,self));
	m_fRightMouseXClipping=m_Right.WinLeft;
	m_fRightMouseYClipping=m_Bottom.WinTop;
}

function SetMousePos (float X, float Y)
{
	local float fMouseX;
	local float fMouseY;

	fMouseX=X;
	fMouseY=Y;
	if ( fMouseX < m_Left.WinWidth )
	{
		fMouseX=m_Left.WinWidth;
	}
	else
	{
		if ( fMouseX > m_Right.WinLeft )
		{
			fMouseX=m_Right.WinLeft;
		}
	}
	if ( fMouseY < m_Top.WinHeight )
	{
		fMouseY=m_Top.WinHeight;
	}
	else
	{
		if ( fMouseY > m_Bottom.WinTop )
		{
			fMouseY=m_Bottom.WinTop;
		}
	}
	Root.Console.MouseX=fMouseX;
	Root.Console.MouseY=fMouseY;
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=1;
//	DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,WinHeight,0.00,0.00,WinWidth,WinHeight,m_TBackGround);
	DrawLaptopFrame(C);
}

function DrawLaptopFrame (Canvas C)
{
	C.Style=5;
/*	DrawStretchedTextureSegment(C,0.00,0.00,256.00,480.00,0.00,0.00,256.00,480.00,Texture'Gui_00L');
	DrawStretchedTextureSegment(C,256.00,0.00,128.00,480.00,0.00,0.00,128.00,480.00,Texture'GUI_00C_a00');
	DrawStretchedTextureSegment(C,384.00,0.00,256.00,480.00,0.00,0.00,256.00,480.00,Texture'Gui_00R');*/
}

defaultproperties
{
    m_fLaptopPadding=2.00
    m_RBackGround=(X=15213062,Y=570753024,W=172,H=1450500)
}
/*
    m_TBackGround=Texture'R6MenuTextures.LaptopTileBG'
*/

