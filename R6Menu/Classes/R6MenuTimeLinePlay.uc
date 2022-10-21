//================================================================================
// R6MenuTimeLinePlay.
//================================================================================
class R6MenuTimeLinePlay extends R6WindowButton;

var bool m_bPlaying;
var Region m_ButtonRegions[8];

function Created ()
{
	bNoKeyboard=True;
}

function BeforePaint (Canvas C, float X, float Y)
{
	if ( m_bPlaying )
	{
		UpRegion=m_ButtonRegions[0];
		OverRegion=m_ButtonRegions[1];
		DownRegion=m_ButtonRegions[2];
		DisabledRegion=m_ButtonRegions[3];
	}
	else
	{
		UpRegion=m_ButtonRegions[4];
		OverRegion=m_ButtonRegions[5];
		DownRegion=m_ButtonRegions[6];
		DisabledRegion=m_ButtonRegions[7];
	}
}

function LMouseDown (float X, float Y)
{
	local R6PlanningCtrl OwnerCtrl;

	OwnerCtrl=R6PlanningCtrl(GetPlayerOwner());
	Super.LMouseDown(X,Y);
	if ( bDisabled || (OwnerCtrl.m_pTeamInfo[OwnerCtrl.m_iCurrentTeam].GetNbActionPoint() <= 1) )
	{
		return;
	}
	if ( m_bPlaying == False )
	{
		if ( OwnerCtrl.m_pTeamInfo[OwnerCtrl.m_iCurrentTeam].GetNbActionPoint() - 1 == OwnerCtrl.m_pTeamInfo[OwnerCtrl.m_iCurrentTeam].m_iCurrentNode )
		{
			OwnerCtrl.GotoFirstNode();
		}
		m_bPlaying=True;
		StartPlaying();
	}
	else
	{
		m_bPlaying=False;
		StopPlaying();
	}
	R6MenuRootWindow(Root).m_PlanningWidget.CloseAllPopup();
}

function StartPlaying ()
{
	R6PlanningCtrl(GetPlayerOwner()).StartPlayingPlanning();
	R6MenuTimeLineBar(OwnerWindow).ActivatePlayMode();
}

function StopPlaying ()
{
	R6PlanningCtrl(GetPlayerOwner()).StopPlayingPlanning();
	R6MenuTimeLineBar(OwnerWindow).StopPlayMode();
}

defaultproperties
{
    m_ButtonRegions(0)=(X=3088902,Y=570753024,W=92,H=1319428)
    m_ButtonRegions(1)=(X=3088902,Y=570753024,W=115,H=1319428)
    m_ButtonRegions(2)=(X=3088902,Y=570753024,W=138,H=1319428)
    m_ButtonRegions(3)=(X=3088902,Y=570753024,W=161,H=1319428)
    m_ButtonRegions(4)=(X=9380358,Y=570753024,W=92,H=1319428)
    m_ButtonRegions(5)=(X=9380358,Y=570753024,W=115,H=1319428)
    m_ButtonRegions(6)=(X=9380358,Y=570753024,W=138,H=1319428)
    m_ButtonRegions(7)=(X=9380358,Y=570753024,W=161,H=1319428)
    m_iDrawStyle=5
    bUseRegion=True
    UpRegion=(X=3088902,Y=570753024,W=92,H=1319428)
    DownRegion=(X=3088902,Y=570753024,W=138,H=1319428)
    DisabledRegion=(X=3088902,Y=570753024,W=161,H=1319428)
    OverRegion=(X=3088902,Y=570753024,W=115,H=1319428)
}
/*
    UpTexture=Texture'R6MenuTextures.Gui_03'
    DownTexture=Texture'R6MenuTextures.Gui_03'
    DisabledTexture=Texture'R6MenuTextures.Gui_03'
    OverTexture=Texture'R6MenuTextures.Gui_03'
*/

