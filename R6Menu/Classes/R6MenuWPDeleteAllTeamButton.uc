//================================================================================
// R6MenuWPDeleteAllTeamButton.
//================================================================================
class R6MenuWPDeleteAllTeamButton extends R6WindowButton;

function Created ()
{
	bNoKeyboard=True;
}

function BeforePaint (Canvas C, float X, float Y)
{
}

function Tick (float fDeltaTime)
{
}

function LMouseDown (float X, float Y)
{
	local R6PlanningCtrl OwnerCtrl;

	OwnerCtrl=R6PlanningCtrl(GetPlayerOwner());
	Super.LMouseDown(X,Y);
	if ( bDisabled )
	{
		return;
	}
	if ( (OwnerCtrl.m_pTeamInfo[0].GetNbActionPoint() != 0) || (OwnerCtrl.m_pTeamInfo[1].GetNbActionPoint() != 0) || (OwnerCtrl.m_pTeamInfo[2].GetNbActionPoint() != 0) )
	{
		R6MenuRootWindow(Root).m_PlanningWidget.Hide3DAndLegend();
//		R6MenuRootWindow(Root).SimplePopUp(Localize("PlanningMenu","WAYPOINTS","R6Menu"),Localize("PlanningMenu","DeleteAllTeam","R6Menu"),40);
	}
}

simulated function Click (float X, float Y)
{
	Super.Click(X,Y);
//	GetPlayerOwner().PlaySound(R6PlanningCtrl(GetPlayerOwner()).m_PlanningBadClickSnd,9);
}

defaultproperties
{
    m_iDrawStyle=5
    bUseRegion=True
    m_bPlayButtonSnd=False
    UpRegion=(X=3678726,Y=570687488,W=28,H=1516035)
    DownRegion=(X=3678726,Y=570753024,W=46,H=1843716)
    DisabledRegion=(X=3678726,Y=570753024,W=69,H=1843716)
    OverRegion=(X=3678726,Y=570753024,W=23,H=1843716)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

