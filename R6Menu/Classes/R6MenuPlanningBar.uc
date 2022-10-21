//================================================================================
// R6MenuPlanningBar.
//================================================================================
class R6MenuPlanningBar extends UWindowWindow;

var R6MenuTeamBar m_TeamBar;
var R6MenuDelNodeBar m_DelNodeBar;
var R6MenuViewCamBar m_ViewCamBar;
var R6MenuTimeLineBar m_TimeLine;
var Color m_iColor;

function Created ()
{
	local int i;
	local float fCurrentW;

	fCurrentW=0.00;
	m_TeamBar=R6MenuTeamBar(CreateWindow(Class'R6MenuTeamBar',fCurrentW,0.00,10.00,25.00,self));
	fCurrentW += m_TeamBar.WinWidth - 1;
	m_DelNodeBar=R6MenuDelNodeBar(CreateWindow(Class'R6MenuDelNodeBar',fCurrentW,0.00,10.00,25.00,self));
	fCurrentW += m_DelNodeBar.WinWidth - 1;
	m_ViewCamBar=R6MenuViewCamBar(CreateWindow(Class'R6MenuViewCamBar',fCurrentW,0.00,10.00,25.00,self));
	fCurrentW += m_ViewCamBar.WinWidth - 1;
	m_TimeLine=R6MenuTimeLineBar(CreateWindow(Class'R6MenuTimeLineBar',fCurrentW,0.00,10.00,25.00,self));
}

function Reset ()
{
	m_TeamBar.Reset();
	m_TimeLine.Reset();
}

function ResetTeams (int iWhatToReset)
{
	m_TeamBar.ResetTeams(iWhatToReset);
}

defaultproperties
{
    m_iColor=(R=238,G=209,B=129,A=0)
}