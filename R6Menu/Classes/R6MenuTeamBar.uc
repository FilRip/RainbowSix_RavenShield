//================================================================================
// R6MenuTeamBar.
//================================================================================
class R6MenuTeamBar extends UWindowWindow;

const SmallWidth=14;
const ButtonWidth=28;
const PosX2=2;
var R6MenuTeamDisplayButton m_DisplayList[3];
var R6MenuTeamButton m_ActiveList[3];

function Created ()
{
	local int i;
	local int xPosition;

	xPosition=4;
	i=0;
JL000F:
	if ( i < 3 )
	{
		m_ActiveList[i]=R6MenuTeamButton(CreateWindow(Class'R6MenuTeamButton',xPosition,1.00,Class'R6MenuTeamButton'.Default.UpRegion.W,23.00,self));
		m_ActiveList[i].m_iTeamColor=i;
		m_ActiveList[i].ToolTipString=Localize("PlanningMenu","TeamActive","R6Menu");
		m_ActiveList[i].m_vButtonColor=Root.Colors.TeamColorLight[i];
		xPosition += 14;
		i++;
		goto JL000F;
	}
	i=0;
JL0101:
	if ( i < 3 )
	{
		m_DisplayList[i]=R6MenuTeamDisplayButton(CreateWindow(Class'R6MenuTeamDisplayButton',xPosition,1.00,Class'R6MenuTeamDisplayButton'.Default.UpRegion.W,23.00,self));
		m_DisplayList[i].m_iTeamColor=i;
		m_DisplayList[i].m_vButtonColor=Root.Colors.TeamColorLight[i];
		m_DisplayList[i].ToolTipString=Localize("PlanningMenu","TeamDisplay","R6Menu");
		xPosition += 28 - 2;
		i++;
		goto JL0101;
	}
	WinWidth=xPosition + 4;
	SetTeamActive(0);
	m_BorderColor=Root.Colors.GrayLight;
}

function Reset ()
{
	local R6PlanningCtrl OwnerCtrl;

	OwnerCtrl=R6PlanningCtrl(GetPlayerOwner());
	m_ActiveList[0].m_bSelected=True;
	m_ActiveList[1].m_bSelected=False;
	m_ActiveList[2].m_bSelected=False;
	m_DisplayList[0].m_bSelected=True;
	m_DisplayList[1].m_bSelected=True;
	m_DisplayList[2].m_bSelected=True;
	if ( OwnerCtrl != None )
	{
		OwnerCtrl.m_pTeamInfo[0].SetPathDisplay(True);
		OwnerCtrl.m_pTeamInfo[1].SetPathDisplay(True);
		OwnerCtrl.m_pTeamInfo[2].SetPathDisplay(True);
	}
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}

function EscClose ()
{
}

function SetTeamActive (int iActive)
{
	local R6PlanningCtrl OwnerCtrl;

	OwnerCtrl=R6PlanningCtrl(GetPlayerOwner());
	m_ActiveList[0].m_bSelected=False;
	m_ActiveList[1].m_bSelected=False;
	m_ActiveList[2].m_bSelected=False;
	m_ActiveList[iActive].m_bSelected=True;
	if ( OwnerCtrl != None )
	{
		switch (iActive)
		{
			case 0:
			OwnerCtrl.SwitchToRedTeam(True);
			m_DisplayList[0].m_bSelected=True;
			break;
			case 1:
			OwnerCtrl.SwitchToGreenTeam(True);
			m_DisplayList[1].m_bSelected=True;
			break;
			case 2:
			OwnerCtrl.SwitchToGoldTeam(True);
			m_DisplayList[2].m_bSelected=True;
			break;
			default:
		}
	}
}

function ResetTeams (int iWhatToReset)
{
	local R6PlanningCtrl OwnerCtrl;

	OwnerCtrl=R6PlanningCtrl(GetPlayerOwner());
	if ( (iWhatToReset < 3) && (m_ActiveList[OwnerCtrl.m_iCurrentTeam].m_bSelected != True) )
	{
		m_ActiveList[0].m_bSelected=False;
		m_ActiveList[1].m_bSelected=False;
		m_ActiveList[2].m_bSelected=False;
		m_ActiveList[OwnerCtrl.m_iCurrentTeam].m_bSelected=True;
		if (  !m_DisplayList[OwnerCtrl.m_iCurrentTeam].m_bSelected )
		{
			m_DisplayList[OwnerCtrl.m_iCurrentTeam].m_bSelected=True;
		}
	}
	else
	{
		if ( iWhatToReset > 2 )
		{
			m_DisplayList[iWhatToReset - 3].m_bSelected= !m_DisplayList[iWhatToReset - 3].m_bSelected;
		}
	}
}