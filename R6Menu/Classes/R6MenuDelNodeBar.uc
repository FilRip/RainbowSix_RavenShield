//================================================================================
// R6MenuDelNodeBar.
//================================================================================
class R6MenuDelNodeBar extends UWindowWindow;

const PosX=4;
var R6WindowButton m_Button[3];

function Created ()
{
	local int xPosition;

	xPosition=1;
	m_Button[0]=R6WindowButton(CreateWindow(Class'R6MenuWPDeleteButton',xPosition,1.00,Class'R6MenuWPDeleteButton'.Default.UpRegion.W,23.00,self));
	m_Button[0].ToolTipString=Localize("PlanningMenu","Delete","R6Menu");
	xPosition += m_Button[0].WinWidth - 4;
	m_Button[1]=R6WindowButton(CreateWindow(Class'R6MenuWPDeleteAllButton',xPosition,1.00,Class'R6MenuWPDeleteAllButton'.Default.UpRegion.W,23.00,self));
	m_Button[1].ToolTipString=Localize("PlanningMenu","DeleteAll","R6Menu");
	xPosition += m_Button[1].WinWidth - 4;
	m_Button[2]=R6WindowButton(CreateWindow(Class'R6MenuWPDeleteAllTeamButton',xPosition,1.00,Class'R6MenuWPDeleteAllTeamButton'.Default.UpRegion.W,23.00,self));
	m_Button[2].ToolTipString=Localize("PlanningMenu","DeleteAllTeam","R6Menu");
	xPosition += m_Button[1].WinWidth;
	WinWidth=xPosition;
	m_BorderColor=Root.Colors.GrayLight;
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}