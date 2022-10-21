//================================================================================
// R6MenuExecuteWidget.
//================================================================================
class R6MenuExecuteWidget extends R6MenuLaptopWidget;

var float m_fObjWidth;
var float m_fObjHeight;
var float m_fMapWidth;
var float m_fTeamSummaryWidth;
var float m_fTeamSummaryYPadding;
var float m_fTeamSummaryXPadding;
var float m_fTeamSummaryMaxHeight;
var float m_fGoPlanningButtonX;
var float m_fGoGameButtonX;
var float m_fObserverButtonX;
var float m_fButtonHeight;
var float m_fButtonAreaY;
var float m_fButtonY;
var R6WindowTextLabel m_CodeName;
var R6WindowTextLabel m_DateTime;
var R6WindowTextLabel m_Location;
var R6WindowWrappedTextArea m_MissionObjectives;
var R6WindowBitMap m_SmallMap;
var R6WindowTeamSummary m_RedSummary;
var R6WindowTeamSummary m_GreenSummary;
var R6WindowTeamSummary m_GoldSummary;
var R6WindowButton m_RedSummaryButton;
var R6WindowButton m_GreenSummaryButton;
var R6WindowButton m_GoldSummaryButton;
var R6WindowButton m_GoPlanningButton;
var R6WindowButton m_GoGameButton;
var R6WindowButton m_ObserverButton;
var Texture m_TObserverButton;
var Texture m_TGoPlanningButton;
var Texture m_TGoGameButton;
var Region m_RGoPlanningButtonUp;
var Region m_RGoPlanningButtonDown;
var Region m_RGoPlanningButtonOver;
var Region m_RGoPlanningButtonDisabled;
var Region m_RGoGameButtonUp;
var Region m_RGoGameButtonDown;
var Region m_RGoGameButtonOver;
var Region m_RGoGameButtonDisabled;
var Region m_RObserverButtonUp;
var Region m_RObserverButtonDown;
var Region m_RObserverButtonOver;
var Region m_RObserverButtonDisabled;

function Created ()
{
	local float labelWidth;
	local float fTeamSummaryYPos;

	Super.Created();
	labelWidth=(m_Right.WinLeft - m_Left.WinWidth) / 3;
	m_CodeName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_Left.WinWidth,m_Top.WinHeight,labelWidth,18.00,self));
	m_DateTime=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_CodeName.WinLeft + m_CodeName.WinWidth,m_Top.WinHeight,labelWidth,18.00,self));
	m_Location=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_DateTime.WinLeft + m_DateTime.WinWidth,m_Top.WinHeight,m_DateTime.WinWidth,18.00,self));
	m_MissionObjectives=R6WindowWrappedTextArea(CreateWindow(Class'R6WindowWrappedTextArea',m_Left.WinWidth + m_fLaptopPadding,m_Location.WinTop + m_Location.WinHeight,m_fObjWidth,m_fObjHeight,self));
	m_MissionObjectives.m_BorderColor=Root.Colors.GrayLight;
	m_MissionObjectives.SetScrollable(True);
	m_MissionObjectives.VertSB.SetBorderColor(Root.Colors.GrayLight);
	m_MissionObjectives.VertSB.SetHideWhenDisable(True);
	m_MissionObjectives.VertSB.SetEffect(True);
//	m_MissionObjectives.m_BorderStyle=1;
	m_MissionObjectives.VertSB.m_BorderStyle=1;
	m_MissionObjectives.m_bUseBGTexture=True;
	m_MissionObjectives.m_BGTexture=Texture'WhiteTexture';
	m_MissionObjectives.m_BGRegion.X=0;
	m_MissionObjectives.m_BGRegion.Y=0;
	m_MissionObjectives.m_BGRegion.W=m_MissionObjectives.m_BGTexture.USize;
	m_MissionObjectives.m_BGRegion.H=m_MissionObjectives.m_BGTexture.VSize;
	m_MissionObjectives.m_bUseBGColor=True;
	m_MissionObjectives.m_BGColor=Root.Colors.Black;
	m_MissionObjectives.m_BGColor.A=Root.Colors.DarkBGAlpha;
	m_SmallMap=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_MissionObjectives.WinLeft + m_MissionObjectives.WinWidth + 4,m_MissionObjectives.WinTop,m_fMapWidth,m_fObjHeight,self));
	m_SmallMap.m_BorderColor=Root.Colors.GrayLight;
//	m_SmallMap.m_BorderStyle=1;
	m_SmallMap.m_bDrawBorder=True;
	m_SmallMap.bStretch=True;
//	m_SmallMap.m_iDrawStyle=5;
	m_NavBar.HideWindow();
	m_fButtonAreaY=m_Bottom.WinTop - 33 - m_fLaptopPadding;
	m_fButtonY=m_fButtonAreaY + 1;
	m_BorderColor=Root.Colors.BlueLight;
	m_GoPlanningButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fGoPlanningButtonX,m_fButtonY,m_RGoPlanningButtonUp.W,m_fButtonHeight,self));
	m_GoPlanningButton.DisabledTexture=m_TGoPlanningButton;
	m_GoPlanningButton.DownTexture=m_TGoPlanningButton;
	m_GoPlanningButton.OverTexture=m_TGoPlanningButton;
	m_GoPlanningButton.UpTexture=m_TGoPlanningButton;
	m_GoPlanningButton.UpRegion=m_RGoPlanningButtonUp;
	m_GoPlanningButton.DownRegion=m_RGoPlanningButtonDown;
	m_GoPlanningButton.DisabledRegion=m_RGoPlanningButtonDisabled;
	m_GoPlanningButton.OverRegion=m_RGoPlanningButtonOver;
	m_GoPlanningButton.bUseRegion=True;
	m_GoPlanningButton.ToolTipString=Localize("ExecuteMenu","GOPLANNING","R6Menu");
//	m_GoPlanningButton.m_iDrawStyle=5;
	m_GoGameButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fGoGameButtonX,m_fButtonY,m_RGoGameButtonUp.W,m_fButtonHeight,self));
	m_GoGameButton.DisabledTexture=m_TGoGameButton;
	m_GoGameButton.DownTexture=m_TGoGameButton;
	m_GoGameButton.OverTexture=m_TGoGameButton;
	m_GoGameButton.UpTexture=m_TGoGameButton;
	m_GoGameButton.UpRegion=m_RGoGameButtonUp;
	m_GoGameButton.DownRegion=m_RGoGameButtonDown;
	m_GoGameButton.DisabledRegion=m_RGoGameButtonDisabled;
	m_GoGameButton.OverRegion=m_RGoGameButtonOver;
	m_GoGameButton.bUseRegion=True;
	m_GoGameButton.ToolTipString=Localize("ExecuteMenu","GOGAME","R6Menu");
//	m_GoGameButton.m_iDrawStyle=5;
	m_ObserverButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fObserverButtonX,m_fButtonY + 1,m_RObserverButtonUp.W,m_fButtonHeight,self));
	m_ObserverButton.DisabledTexture=m_TObserverButton;
	m_ObserverButton.DownTexture=m_TObserverButton;
	m_ObserverButton.OverTexture=m_TObserverButton;
	m_ObserverButton.UpTexture=m_TObserverButton;
	m_ObserverButton.UpRegion=m_RObserverButtonUp;
	m_ObserverButton.DownRegion=m_RObserverButtonDown;
	m_ObserverButton.DisabledRegion=m_RObserverButtonDisabled;
	m_ObserverButton.OverRegion=m_RObserverButtonOver;
	m_ObserverButton.bUseRegion=True;
	m_ObserverButton.ToolTipString=Localize("ExecuteMenu","OBSERVER","R6Menu");
//	m_ObserverButton.m_iDrawStyle=5;
	fTeamSummaryYPos=152.00;
	m_fTeamSummaryMaxHeight=237.00;
	m_RedSummary=R6WindowTeamSummary(CreateWindow(Class'R6WindowTeamSummary',m_MissionObjectives.WinLeft,fTeamSummaryYPos,m_fTeamSummaryWidth,m_fTeamSummaryMaxHeight,self));
	m_RedSummary.SetTeam(0);
	m_RedSummary.bAlwaysBehind=True;
	m_GreenSummary=R6WindowTeamSummary(CreateWindow(Class'R6WindowTeamSummary',m_RedSummary.WinLeft + m_RedSummary.WinWidth + m_fTeamSummaryXPadding,fTeamSummaryYPos,m_fTeamSummaryWidth,m_fTeamSummaryMaxHeight,self));
	m_GreenSummary.SetTeam(1);
	m_GreenSummary.bAlwaysBehind=True;
	m_GoldSummary=R6WindowTeamSummary(CreateWindow(Class'R6WindowTeamSummary',m_GreenSummary.WinLeft + m_GreenSummary.WinWidth + m_fTeamSummaryXPadding,fTeamSummaryYPos,m_fTeamSummaryWidth,m_fTeamSummaryMaxHeight,self));
	m_GoldSummary.SetTeam(2);
	m_GoldSummary.bAlwaysBehind=True;
	m_RedSummaryButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_MissionObjectives.WinLeft,fTeamSummaryYPos,m_fTeamSummaryWidth,m_fTeamSummaryMaxHeight,self));
	m_RedSummaryButton.ToolTipString=Localize("ExecuteMenu","OverATeam","R6Menu");
	m_RedSummaryButton.m_BorderColor=Root.Colors.BlueLight;
	m_RedSummaryButton.m_bDrawSimpleBorder=True;
	m_GreenSummaryButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_RedSummary.WinLeft + m_RedSummary.WinWidth + m_fTeamSummaryXPadding,fTeamSummaryYPos,m_fTeamSummaryWidth,m_fTeamSummaryMaxHeight,self));
	m_GreenSummaryButton.ToolTipString=Localize("ExecuteMenu","OverATeam","R6Menu");
	m_GreenSummaryButton.m_BorderColor=Root.Colors.BlueLight;
	m_GreenSummaryButton.m_bDrawSimpleBorder=True;
	m_GoldSummaryButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_GreenSummary.WinLeft + m_GreenSummary.WinWidth + m_fTeamSummaryXPadding,fTeamSummaryYPos,m_fTeamSummaryWidth,m_fTeamSummaryMaxHeight,self));
	m_GoldSummaryButton.ToolTipString=Localize("ExecuteMenu","OverATeam","R6Menu");
	m_GoldSummaryButton.m_BorderColor=Root.Colors.BlueLight;
	m_GoldSummaryButton.m_bDrawSimpleBorder=True;
}

function ShowWindow ()
{
	local R6MissionObjectiveMgr moMgr;
	local int i;
	local string szDescription;
	local R6GameOptions pGameOptions;
	local R6MissionDescription CurrentMission;

	Super.ShowWindow();
	CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
/*	m_CodeName.SetProperties(Localize(CurrentMission.m_MapName,"ID_CODENAME",CurrentMission.LocalizationFile),2,Root.Fonts[9],Root.Colors.White,False);
	m_DateTime.SetProperties(Localize(CurrentMission.m_MapName,"ID_DATETIME",CurrentMission.LocalizationFile),2,Root.Fonts[9],Root.Colors.White,False);
	m_Location.SetProperties(Localize(CurrentMission.m_MapName,"ID_LOCATION",CurrentMission.LocalizationFile),2,Root.Fonts[9],Root.Colors.White,False);*/
	moMgr=R6AbstractGameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_missionMgr;
	m_MissionObjectives.Clear();
	m_MissionObjectives.m_fXOffSet=10.00;
	m_MissionObjectives.m_fYOffSet=5.00;
	m_MissionObjectives.AddText(Localize("Briefing","Objectives","R6Menu"),Root.Colors.BlueLight,Root.Fonts[5]);
	i=0;
JL0259:
	if ( i < moMgr.m_aMissionObjectives.Length )
	{
		if (  !moMgr.m_aMissionObjectives[i].m_bMoralityObjective && moMgr.m_aMissionObjectives[i].m_bVisibleInMenu )
		{
			szDescription="-" @ Localize("Game",moMgr.m_aMissionObjectives[i].m_szDescriptionInMenu,moMgr.Level.GetMissionObjLocFile(moMgr.m_aMissionObjectives[i]));
			m_MissionObjectives.AddText(szDescription,Root.Colors.White,Root.Fonts[10]);
		}
		++i;
		goto JL0259;
	}
	m_SmallMap.t=CurrentMission.m_TWorldMap;
	m_SmallMap.R=CurrentMission.m_RWorldMap;
	CalculatePlanningDetails();
	UpdateTeamRoster();
	if ( R6MenuRootWindow(Root).m_bPlayerPlanInitialized == False )
	{
		pGameOptions=Class'Actor'.static.GetGameOptions();
		if ( pGameOptions.PopUpLoadPlan == True )
		{
//			R6MenuRootWindow(Root).m_ePopUpID=43;
			R6MenuRootWindow(Root).PopUpMenu(True);
		}
	}
}

function CalculatePlanningDetails ()
{
	local R6PlanningInfo PlanningInfo;
	local int iWaypoint;
	local int iGoCode;
	local int i;
	local int Y;
	local R6WindowTeamSummary TeamSummarys[3];

	TeamSummarys[0]=m_RedSummary;
	TeamSummarys[1]=m_GreenSummary;
	TeamSummarys[2]=m_GoldSummary;
	i=0;
JL002F:
	if ( i < 3 )
	{
		PlanningInfo=R6PlanningInfo(Root.Console.Master.m_StartGameInfo.m_TeamInfo[i].m_pPlanning);
		iWaypoint=0;
		iGoCode=0;
		Y=0;
JL0093:
		if ( Y < PlanningInfo.m_NodeList.Length )
		{
			if ( (R6ActionPoint(PlanningInfo.m_NodeList[Y]).m_eActionType == 2) || (R6ActionPoint(PlanningInfo.m_NodeList[Y]).m_eActionType == 3) || (R6ActionPoint(PlanningInfo.m_NodeList[Y]).m_eActionType == 4) )
			{
				iGoCode++;
			}
			Y++;
			goto JL0093;
		}
		iWaypoint=PlanningInfo.m_NodeList.Length;
		TeamSummarys[i].SetPlanningDetails(string(iWaypoint),string(iGoCode));
		i++;
		goto JL002F;
	}
}

function UpdateTeamRoster ()
{
	local int i;
	local int Y;
	local R6WindowTeamSummary TeamSummarys[3];
	local R6WindowButton TeamSummaryButton[3];
	local R6Operative tmpOperative;
	local R6WindowTextIconsListBox tmpListBox[3];
	local R6WindowTextIconsListBox currentListBox;
	local R6WindowListBoxItem tmpItem;
	local R6MenuRootWindow r6Root;
	local bool bselectedSet;

	TeamSummarys[0]=m_RedSummary;
	TeamSummarys[1]=m_GreenSummary;
	TeamSummarys[2]=m_GoldSummary;
	TeamSummaryButton[0]=m_RedSummaryButton;
	TeamSummaryButton[1]=m_GreenSummaryButton;
	TeamSummaryButton[2]=m_GoldSummaryButton;
	m_RedSummary.SetSelected(False);
	m_GreenSummary.SetSelected(False);
	m_GoldSummary.SetSelected(False);
	m_RedSummaryButton.m_bDrawBorders=False;
	m_GreenSummaryButton.m_bDrawBorders=False;
	m_GoldSummaryButton.m_bDrawBorders=False;
	bselectedSet=False;
	m_RedSummary.Init();
	m_GreenSummary.Init();
	m_GoldSummary.Init();
	r6Root=R6MenuRootWindow(Root);
	tmpListBox[0]=r6Root.m_GearRoomWidget.m_RosterListCtrl.m_RedListBox.m_listBox;
	tmpListBox[1]=r6Root.m_GearRoomWidget.m_RosterListCtrl.m_GreenListBox.m_listBox;
	tmpListBox[2]=r6Root.m_GearRoomWidget.m_RosterListCtrl.m_GoldListBox.m_listBox;
	Y=0;
JL0193:
	if ( Y < 3 )
	{
		currentListBox=tmpListBox[Y];
		tmpItem=R6WindowListBoxItem(currentListBox.Items.Next);
		i=0;
JL01D9:
		if ( i < currentListBox.Items.Count() )
		{
			tmpOperative=R6Operative(tmpItem.m_Object);
			if ( tmpOperative != None )
			{
				TeamSummarys[Y].AddOperative(tmpOperative);
				if ( bselectedSet == False )
				{
					TeamSummaryButton[Y].m_bDrawBorders=True;
					TeamSummarys[Y].SetSelected(True);
					bselectedSet=True;
				}
			}
			tmpItem=R6WindowListBoxItem(tmpItem.Next);
			i++;
			goto JL01D9;
		}
		Y++;
		goto JL0193;
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		switch (C)
		{
			case m_GoPlanningButton:
//			Root.ChangeCurrentWidget(17);
			break;
			case m_GoGameButton:
			R6MenuRootWindow(Root).LeaveForGame(False,GetTeamStart());
			break;
			case m_ObserverButton:
			R6MenuRootWindow(Root).LeaveForGame(True,GetTeamStart());
			break;
			case m_RedSummaryButton:
			if ( m_RedSummary.OperativeCount() > 0 )
			{
				m_RedSummary.SetSelected(True);
				m_GreenSummary.SetSelected(False);
				m_GoldSummary.SetSelected(False);
				m_RedSummaryButton.m_bDrawBorders=True;
				m_GreenSummaryButton.m_bDrawBorders=False;
				m_GoldSummaryButton.m_bDrawBorders=False;
			}
			break;
			case m_GreenSummaryButton:
			if ( m_GreenSummary.OperativeCount() > 0 )
			{
				m_RedSummary.SetSelected(False);
				m_GreenSummary.SetSelected(True);
				m_GoldSummary.SetSelected(False);
				m_RedSummaryButton.m_bDrawBorders=False;
				m_GreenSummaryButton.m_bDrawBorders=True;
				m_GoldSummaryButton.m_bDrawBorders=False;
			}
			break;
			case m_GoldSummaryButton:
			if ( m_GoldSummary.OperativeCount() > 0 )
			{
				m_RedSummary.SetSelected(False);
				m_GreenSummary.SetSelected(False);
				m_GoldSummary.SetSelected(True);
				m_RedSummaryButton.m_bDrawBorders=False;
				m_GreenSummaryButton.m_bDrawBorders=False;
				m_GoldSummaryButton.m_bDrawBorders=True;
			}
			break;
			default:
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	local float boxX;

	Super.Paint(C,X,Y);
	boxX=m_Left.WinWidth + 2;
	R6WindowLookAndFeel(LookAndFeel).DrawBox(self,C,boxX,m_fButtonAreaY,640.00 - 2 * boxX,33.00);
}

function int GetTeamStart ()
{
	if ( m_RedSummary.m_bIsSelected )
	{
		return 0;
	}
	else
	{
		if ( m_GreenSummary.m_bIsSelected )
		{
			return 1;
		}
		else
		{
			if ( m_GoldSummary.m_bIsSelected )
			{
				return 2;
			}
		}
	}
	return 0;
}

defaultproperties
{
    m_fObjWidth=396.00
    m_fObjHeight=98.00
    m_fMapWidth=196.00
    m_fTeamSummaryWidth=196.00
    m_fTeamSummaryYPadding=4.00
    m_fTeamSummaryXPadding=4.00
    m_fGoPlanningButtonX=172.00
    m_fGoGameButtonX=442.00
    m_fObserverButtonX=303.00
    m_fButtonHeight=33.00
    m_RGoPlanningButtonUp=(X=1712646,Y=570753024,W=120,H=1647108)
    m_RGoPlanningButtonDown=(X=1712646,Y=570753024,W=180,H=1647108)
    m_RGoPlanningButtonOver=(X=1712646,Y=570753024,W=150,H=1647108)
    m_RGoPlanningButtonDisabled=(X=1712646,Y=570753024,W=210,H=1647108)
    m_RGoGameButtonUp=(X=7873029,Y=570687488,W=25,H=1974787)
    m_RGoGameButtonDown=(X=11805189,Y=570687488,W=25,H=1974787)
    m_RGoGameButtonOver=(X=9839109,Y=570687488,W=25,H=1974787)
    m_RGoGameButtonDisabled=(X=13771269,Y=570687488,W=25,H=1974787)
    m_RObserverButtonUp=(X=11739654,Y=570687488,W=33,H=1974787)
    m_RObserverButtonDown=(X=11739654,Y=570753024,W=60,H=2171396)
    m_RObserverButtonOver=(X=11739654,Y=570753024,W=30,H=2171396)
    m_RObserverButtonDisabled=(X=11739654,Y=570753024,W=90,H=2171396)
}
/*
    m_TObserverButton=Texture'R6MenuTextures.Gui_02'
    m_TGoPlanningButton=Texture'R6MenuTextures.Gui_01'
    m_TGoGameButton=Texture'R6MenuTextures.Gui_01'
*/

