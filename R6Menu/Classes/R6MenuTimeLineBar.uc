//================================================================================
// R6MenuTimeLineBar.
//================================================================================
class R6MenuTimeLineBar extends UWindowWindow;

var R6WindowButton m_Button[6];

function Created ()
{
	local int xPosition;

	xPosition=2;
	m_Button[0]=R6WindowButton(CreateWindow(Class'R6MenuTimeLineGotoFirst',xPosition,1.00,Class'R6MenuTimeLineGotoFirst'.Default.UpRegion.W,23.00,self));
	m_Button[0].ToolTipString=Localize("PlanningMenu","GotoFirst","R6Menu");
	xPosition += Class'R6MenuTimeLineGotoFirst'.Default.UpRegion.W;
	m_Button[1]=R6WindowButton(CreateWindow(Class'R6MenuTimeLinePrevious',xPosition,1.00,Class'R6MenuTimeLinePrevious'.Default.UpRegion.W,23.00,self));
	m_Button[1].ToolTipString=Localize("PlanningMenu","Previous","R6Menu");
	xPosition += Class'R6MenuTimeLinePrevious'.Default.UpRegion.W;
	m_Button[2]=R6WindowButton(CreateWindow(Class'R6MenuTimeLinePlay',xPosition,1.00,Class'R6MenuTimeLinePlay'.Default.UpRegion.W,23.00,self));
	m_Button[2].ToolTipString=Localize("PlanningMenu","PlayStop","R6Menu");
	xPosition += Class'R6MenuTimeLinePlay'.Default.UpRegion.W;
	m_Button[3]=R6WindowButton(CreateWindow(Class'R6MenuTimeLineNext',xPosition,1.00,Class'R6MenuTimeLineNext'.Default.UpRegion.W,23.00,self));
	m_Button[3].ToolTipString=Localize("PlanningMenu","Next","R6Menu");
	xPosition += Class'R6MenuTimeLineNext'.Default.UpRegion.W;
	m_Button[4]=R6WindowButton(CreateWindow(Class'R6MenuTimeLineGotoLast',xPosition,1.00,Class'R6MenuTimeLineGotoLast'.Default.UpRegion.W,23.00,self));
	m_Button[4].ToolTipString=Localize("PlanningMenu","GotoLast","R6Menu");
	xPosition += Class'R6MenuTimeLineGotoLast'.Default.UpRegion.W;
	m_Button[5]=R6WindowButton(CreateWindow(Class'R6MenuTimeLineLock',xPosition,1.00,Class'R6MenuTimeLineLock'.Default.UpRegion.W,23.00,self));
	m_Button[5].ToolTipString=Localize("PlanningMenu","Lock","R6Menu");
	xPosition += Class'R6MenuTimeLineLock'.Default.UpRegion.W;
	WinWidth=xPosition + 1;
	m_BorderColor=Root.Colors.GrayLight;
}

function Reset ()
{
	if ( R6PlanningCtrl(GetPlayerOwner()) != None )
	{
		R6PlanningCtrl(GetPlayerOwner()).m_bPlayMode=False;
		R6PlanningCtrl(GetPlayerOwner()).StopPlayingPlanning();
		StopPlayMode();
	}
	R6MenuTimeLineLock(m_Button[5]).ResetCameraLock();
}

function ActivatePlayMode ()
{
	local R6MenuPlanningBar PlanningBarWindow;

	PlanningBarWindow=R6MenuPlanningBar(OwnerWindow);
	m_Button[0].bDisabled=True;
	m_Button[1].bDisabled=True;
	m_Button[3].bDisabled=True;
	m_Button[4].bDisabled=True;
	PlanningBarWindow.m_ViewCamBar.m_Button[4].bDisabled=True;
	PlanningBarWindow.m_ViewCamBar.m_Button[5].bDisabled=True;
	PlanningBarWindow.m_DelNodeBar.m_Button[0].bDisabled=True;
	PlanningBarWindow.m_DelNodeBar.m_Button[1].bDisabled=True;
	PlanningBarWindow.m_DelNodeBar.m_Button[2].bDisabled=True;
	PlanningBarWindow.m_TeamBar.m_DisplayList[0].bDisabled=True;
	PlanningBarWindow.m_TeamBar.m_ActiveList[0].bDisabled=True;
	PlanningBarWindow.m_TeamBar.m_DisplayList[1].bDisabled=True;
	PlanningBarWindow.m_TeamBar.m_ActiveList[1].bDisabled=True;
	PlanningBarWindow.m_TeamBar.m_DisplayList[2].bDisabled=True;
	PlanningBarWindow.m_TeamBar.m_ActiveList[2].bDisabled=True;
}

function StopPlayMode ()
{
	local R6MenuPlanningBar PlanningBarWindow;

	PlanningBarWindow=R6MenuPlanningBar(OwnerWindow);
	m_Button[0].bDisabled=False;
	m_Button[1].bDisabled=False;
	m_Button[3].bDisabled=False;
	m_Button[4].bDisabled=False;
	PlanningBarWindow.m_ViewCamBar.m_Button[4].bDisabled=False;
	PlanningBarWindow.m_ViewCamBar.m_Button[5].bDisabled=False;
	PlanningBarWindow.m_DelNodeBar.m_Button[0].bDisabled=False;
	PlanningBarWindow.m_DelNodeBar.m_Button[1].bDisabled=False;
	PlanningBarWindow.m_DelNodeBar.m_Button[2].bDisabled=False;
	PlanningBarWindow.m_TeamBar.m_DisplayList[0].bDisabled=False;
	PlanningBarWindow.m_TeamBar.m_ActiveList[0].bDisabled=False;
	PlanningBarWindow.m_TeamBar.m_DisplayList[1].bDisabled=False;
	PlanningBarWindow.m_TeamBar.m_ActiveList[1].bDisabled=False;
	PlanningBarWindow.m_TeamBar.m_DisplayList[2].bDisabled=False;
	PlanningBarWindow.m_TeamBar.m_ActiveList[2].bDisabled=False;
	R6MenuTimeLinePlay(m_Button[2]).m_bPlaying=False;
	if ( R6PlanningCtrl(GetPlayerOwner()) != None )
	{
		R6PlanningCtrl(GetPlayerOwner()).StopPlayingPlanning();
	}
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}