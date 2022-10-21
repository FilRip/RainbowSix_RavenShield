//================================================================================
// R6Window3DButton.
//================================================================================
class R6Window3DButton extends UWindowButton;

var int m_iDrawStyle;
var bool m_bDisplayWindow;
var bool m_bLMouseDown;
var Color m_cButtonColor;

function Created ()
{
	m_cButtonColor=Root.Colors.GrayLight;
	ToolTipString=Localize("PlanningMenu","3DWindow","R6Menu");
}

function BeforePaint (Canvas C, float X, float Y)
{
}

function Paint (Canvas C, float X, float Y)
{
	local float tempSpace;
	local Color vBorderColor;

	C.Style=m_iDrawStyle;
	C.SetDrawColor(m_cButtonColor.R,m_cButtonColor.G,m_cButtonColor.B);
	if ( UpTexture != None )
	{
		DrawStretchedTextureSegment(C,ImageX,ImageY,WinWidth,WinHeight,UpRegion.X,UpRegion.Y,UpRegion.W,UpRegion.H,UpTexture);
	}
}

function MouseLeave ()
{
	if ( m_bLMouseDown == True )
	{
		m_bLMouseDown=False;
		R6PlanningCtrl(GetPlayerOwner()).TurnOff3DMove();
	}
	Super.MouseLeave();
	m_cButtonColor=Root.Colors.GrayLight;
}

function MouseEnter ()
{
	Super.MouseEnter();
	m_cButtonColor=Root.Colors.BlueLight;
}

function MouseMove (float X, float Y)
{
	if ( m_bLMouseDown == True )
	{
		R6PlanningCtrl(GetPlayerOwner()).Ajust3DRotation(WinLeft + X,WinTop + Y);
		R6MenuRootWindow(Root).m_CurrentWidget.SetMousePos(WinLeft + WinWidth * 0.50,WinTop + WinHeight * 0.50);
	}
}

function LMouseDown (float X, float Y)
{
	m_bLMouseDown=True;
	R6MenuRootWindow(Root).m_CurrentWidget.SetMousePos(WinLeft + WinWidth * 0.50,WinTop + WinHeight * 0.50);
	R6PlanningCtrl(GetPlayerOwner()).TurnOn3DMove(WinLeft + WinWidth * 0.50,WinTop + WinHeight * 0.50);
}

function LMouseUp (float X, float Y)
{
	m_bLMouseDown=False;
	R6PlanningCtrl(GetPlayerOwner()).TurnOff3DMove();
}

function Toggle3DWindow ()
{
	m_bDisplayWindow= !m_bDisplayWindow;
	if ( m_bDisplayWindow == True )
	{
		ShowWindow();
	}
	else
	{
		HideWindow();
	}
}

function Close3DWindow ()
{
	m_bDisplayWindow=False;
	HideWindow();
}

function SetButtonColor (Color cButtonColor)
{
	m_cButtonColor=cButtonColor;
}

defaultproperties
{
    m_iDrawStyle=1
    m_cButtonColor=(R=255,G=255,B=255,A=0)
}
/*
    UpTexture=Texture'R6Planning.Icons.PlanIcon_White'
*/

