//================================================================================
// R6MenuViewCamBar.
//================================================================================
class R6MenuViewCamBar extends UWindowWindow;

const ButtonSize=33;
const XPos=8;
var R6WindowButton m_Button[6];

function Created ()
{
	local int xPosition;

	xPosition=8 + 5;
	m_Button[0]=R6WindowButton(CreateWindow(Class'R6MenuCamTurnCounterClockwiseButton',xPosition,1.00,Class'R6MenuCamTurnCounterClockwiseButton'.Default.UpRegion.W,23.00,self));
	m_Button[0].ToolTipString=Localize("PlanningMenu","RotateCClock","R6Menu");
	xPosition += 33 + 8;
	m_Button[1]=R6WindowButton(CreateWindow(Class'R6MenuCamTurnClockwiseButton',xPosition,1.00,Class'R6MenuCamTurnClockwiseButton'.Default.UpRegion.W,23.00,self));
	m_Button[1].ToolTipString=Localize("PlanningMenu","RotateClock","R6Menu");
	xPosition += 33 + 8;
	m_Button[2]=R6WindowButton(CreateWindow(Class'R6MenuCamZoomInButton',xPosition,1.00,Class'R6MenuCamZoomInButton'.Default.UpRegion.W,23.00,self));
	m_Button[2].ToolTipString=Localize("PlanningMenu","ZoomIn","R6Menu");
	xPosition += 33 + 8;
	m_Button[3]=R6WindowButton(CreateWindow(Class'R6MenuCamZoomOutButton',xPosition,1.00,Class'R6MenuCamZoomOutButton'.Default.UpRegion.W,23.00,self));
	m_Button[3].ToolTipString=Localize("PlanningMenu","ZoomOut","R6Menu");
	xPosition += 33 + 8;
	m_Button[4]=R6WindowButton(CreateWindow(Class'R6MenuCamFloorUpButton',xPosition,1.00,Class'R6MenuCamFloorUpButton'.Default.UpRegion.W,23.00,self));
	m_Button[4].ToolTipString=Localize("PlanningMenu","LevelUp","R6Menu");
	xPosition += 33 + 8;
	m_Button[5]=R6WindowButton(CreateWindow(Class'R6MenuCamFloorDownButton',xPosition,1.00,Class'R6MenuCamFloorDownButton'.Default.UpRegion.W,23.00,self));
	m_Button[5].ToolTipString=Localize("PlanningMenu","LevelDown","R6Menu");
	xPosition += 33 + 2;
	WinWidth=xPosition;
	m_BorderColor=Root.Colors.GrayLight;
}

function KeepActive (int iActive)
{
	m_Button[0].m_bSelected=False;
	m_Button[1].m_bSelected=False;
	m_Button[2].m_bSelected=False;
	if ( (iActive > -1) && (iActive < 3) )
	{
		m_Button[iActive].m_bSelected=True;
	}
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}