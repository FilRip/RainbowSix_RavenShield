//================================================================================
// R6MenuDebriefingWidget.
//================================================================================
class R6MenuDebriefingWidget extends R6MenuLaptopWidget;

var int m_iCountFrame;
var bool m_bReadyShowWindow;
var bool m_bMissionVictory;
var float m_fObjHeight;
var float m_fMissionResultTitleHeight;
var float m_fMissionResultTitleWidth;
var float m_fNavAreaY;
var float m_fPaddingBetween;
var float m_fStatsWidth;
var R6WindowTextLabel m_CodeName;
var R6WindowTextLabel m_DateTime;
var R6WindowTextLabel m_Location;
var R6WindowWrappedTextArea m_MissionObjectives;
var R6WindowTextLabel m_MissionResultTitle;
var Texture m_TBGMissionResult;
var R6MenuDebriefNavBar m_DebriefNavBar;
var R6MenuSingleTeamBar m_pR6RainbowTeamBar;
var R6MenuCarreerStats m_RainbowCarreerStats;
var Sound m_sndVictoryMusic;
var Sound m_sndLossMusic;
var array<R6Operative> m_MissionOperatives;
var Region m_RBGMissionResult;
var Region m_RBGExtMissionResult;

function Created ()
{
	local float labelWidth;
	local float NavXPos;
	local float fStatsHeight;
	local float fStatsWidth;

	Super.Created();
	labelWidth=(m_Right.WinLeft - m_Left.WinWidth) / 3;
	m_CodeName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_Left.WinWidth,m_Top.WinHeight,labelWidth,18.00,self));
	m_DateTime=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_CodeName.WinLeft + m_CodeName.WinWidth,m_Top.WinHeight,labelWidth,18.00,self));
	m_Location=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_DateTime.WinLeft + m_DateTime.WinWidth,m_Top.WinHeight,m_DateTime.WinWidth,18.00,self));
	m_MissionResultTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',21.00,52.00,m_fMissionResultTitleWidth,m_fMissionResultTitleHeight,self));
	m_MissionResultTitle.m_bUseBGColor=True;
	m_MissionResultTitle.m_BGTexture=m_TBGMissionResult;
	m_MissionResultTitle.m_BGTextureRegion=m_RBGMissionResult;
	m_MissionResultTitle.m_BGExtRegion=m_RBGExtMissionResult;
//	m_MissionResultTitle.m_DrawStyle=5;
	m_MissionResultTitle.m_BorderColor=Root.Colors.GrayLight;
	m_MissionResultTitle.m_bDrawBorders=True;
	m_MissionResultTitle.m_bDrawBG=True;
	m_MissionResultTitle.m_bUseExtRegion=True;
	m_MissionObjectives=R6WindowWrappedTextArea(CreateWindow(Class'R6WindowWrappedTextArea',m_MissionResultTitle.WinLeft,87.00,m_MissionResultTitle.WinWidth,m_fObjHeight,self));
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
	m_NavBar.HideWindow();
	m_fNavAreaY=m_Bottom.WinTop - 33 - m_fLaptopPadding;
	NavXPos=m_Left.WinWidth + 2;
	m_DebriefNavBar=R6MenuDebriefNavBar(CreateWindow(Class'R6MenuDebriefNavBar',m_NavBar.WinLeft,m_NavBar.WinTop,m_NavBar.WinWidth,m_NavBar.WinHeight,self));
	fStatsHeight=227.00;
	m_pR6RainbowTeamBar=R6MenuSingleTeamBar(CreateControl(Class'R6MenuSingleTeamBar',m_MissionObjectives.WinLeft,m_MissionObjectives.WinTop + m_MissionObjectives.WinHeight + 3,m_fStatsWidth,fStatsHeight,self));
	m_pR6RainbowTeamBar.m_bDrawBorders=True;
	m_pR6RainbowTeamBar.m_bDrawTotalsShading=True;
	m_pR6RainbowTeamBar.m_IFirstItempYOffset=4;
	m_pR6RainbowTeamBar.m_IBorderVOffset=0;
	m_pR6RainbowTeamBar.m_fRainbowWidth=131.00;
	m_pR6RainbowTeamBar.m_fTeamcolorWidth=21.00;
	m_pR6RainbowTeamBar.m_fHealthWidth=23.00;
	m_pR6RainbowTeamBar.m_fSkullWidth=23.00;
	m_pR6RainbowTeamBar.m_fEfficiencyWidth=25.00;
	m_pR6RainbowTeamBar.m_fShotsWidth=39.00;
	m_pR6RainbowTeamBar.m_fHitsWidth=32.00;
	m_pR6RainbowTeamBar.m_fBottomTitleWidth=175.00;
	m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.m_fXItemOffset=1.00;
	m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.m_fXItemRightPadding=1.00;
	m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.m_fItemHeight=18.00;
	m_pR6RainbowTeamBar.Resize();
	m_RainbowCarreerStats=R6MenuCarreerStats(CreateWindow(Class'R6MenuCarreerStats',m_pR6RainbowTeamBar.WinLeft + m_pR6RainbowTeamBar.WinWidth + m_fPaddingBetween,m_pR6RainbowTeamBar.WinTop,301.00,m_pR6RainbowTeamBar.WinHeight,self));
}

function Paint (Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);
	if ( m_bReadyShowWindow )
	{
		if ( m_iCountFrame == 1 )
		{
			m_bReadyShowWindow=False;
			GetPlayerOwner().StopAllMusic();
			R6AbstractHUD(GetPlayerOwner().myHUD).StopFadeToBlack();
			GetPlayerOwner().ResetVolume_TypeSound(SLOT_Music);
			if ( m_bMissionVictory )
			{
//				GetPlayerOwner().PlayMusic(m_sndVictoryMusic);
			}
			else
			{
//				GetPlayerOwner().PlayMusic(m_sndLossMusic);
			}
		}
//		m_iCountFrame=1;
	}
}

function ShowWindow ()
{
	local R6MissionDescription CurrentMission;
	local R6MissionObjectiveMgr moMgr;
	local int i;
	local string szObjectiveDesc;
	local Canvas C;

	C=Class'Actor'.static.GetCanvas();
	C.m_iNewResolutionX=640;
	C.m_iNewResolutionY=480;
	C.m_bChangeResRequested=True;
	GetLevel().m_bAllow3DRendering=False;
	Super.ShowWindow();
	m_DebriefNavBar.m_ContinueButton.bDisabled=False;
	GetPlayerOwner().SetPause(True);
	m_bReadyShowWindow=True;
	m_iCountFrame=0;
	CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
/*	m_CodeName.SetProperties(Localize(CurrentMission.m_MapName,"ID_CODENAME",CurrentMission.LocalizationFile),2,Root.Fonts[9],Root.Colors.White,False);
	m_DateTime.SetProperties(Localize(CurrentMission.m_MapName,"ID_DATETIME",CurrentMission.LocalizationFile),2,Root.Fonts[9],Root.Colors.White,False);
	m_Location.SetProperties(Localize(CurrentMission.m_MapName,"ID_LOCATION",CurrentMission.LocalizationFile),2,Root.Fonts[9],Root.Colors.White,False);
	moMgr=R6AbstractGameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_missionMgr;*/
	m_MissionObjectives.Clear();
	m_MissionObjectives.m_fXOffSet=10.00;
	m_MissionObjectives.m_fYOffSet=5.00;
	m_MissionObjectives.AddText(Localize("Briefing","SUMMARY","R6Menu"),Root.Colors.BlueLight,Root.Fonts[5]);
/*	if ( moMgr.m_eMissionObjectiveStatus == 1 )
	{
		m_bMissionVictory=True;
//		m_MissionResultTitle.SetProperties(Localize("DebriefingMenu","SUCCESS","R6Menu"),2,Root.Fonts[4],Root.Colors.Green,True);
		m_MissionResultTitle.m_BGColor=Root.Colors.Green;
		i=0;
JL0395:
		if ( i < moMgr.m_aMissionObjectives.Length )
		{
			if (  !moMgr.m_aMissionObjectives[i].m_bMoralityObjective && moMgr.m_aMissionObjectives[i].m_bVisibleInMenu )
			{
				szObjectiveDesc=Localize("Game",moMgr.m_aMissionObjectives[i].m_szDescriptionInMenu,moMgr.Level.GetMissionObjLocFile(moMgr.m_aMissionObjectives[i]));
				if ( moMgr.m_aMissionObjectives[i].isCompleted() )
				{
					szObjectiveDesc="-" @ szObjectiveDesc @ ":" @ Localize("OBJECTIVES","SUCCESS","R6Menu");
				}
				else
				{
					szObjectiveDesc="-" @ szObjectiveDesc @ ":" @ Localize("OBJECTIVES","FAILED","R6Menu");
				}
				m_MissionObjectives.AddText(szObjectiveDesc,Root.Colors.White,Root.Fonts[10]);
			}
			++i;
			goto JL0395;
		}
	}
	else
	{
		m_bMissionVictory=False;
//		m_MissionResultTitle.SetProperties(Localize("DebriefingMenu","FAILED","R6Menu"),2,Root.Fonts[4],Root.Colors.Red,True);
		m_MissionResultTitle.m_BGColor=Root.Colors.Red;
		i=0;
JL05C4:
		if ( i < moMgr.m_aMissionObjectives.Length )
		{
			if ( moMgr.m_aMissionObjectives[i].m_bVisibleInMenu )
			{
				szObjectiveDesc="";
				if ( moMgr.m_aMissionObjectives[i].m_bMoralityObjective )
				{
					if ( moMgr.m_aMissionObjectives[i].isFailed() )
					{
						szObjectiveDesc="-" @ Localize("Game",moMgr.m_aMissionObjectives[i].m_szDescriptionFailure,moMgr.Level.GetMissionObjLocFile(moMgr.m_aMissionObjectives[i]));
					}
				}
				else
				{
					if ( moMgr.m_aMissionObjectives[i].isCompleted() )
					{
						szObjectiveDesc=Localize("OBJECTIVES","SUCCESS","R6Menu");
					}
					else
					{
						szObjectiveDesc=Localize("OBJECTIVES","FAILED","R6Menu");
					}
					szObjectiveDesc="-" @ Localize("Game",moMgr.m_aMissionObjectives[i].m_szDescriptionInMenu,moMgr.Level.GetMissionObjLocFile(moMgr.m_aMissionObjectives[i])) @ ":" @ szObjectiveDesc;
				}
				if ( szObjectiveDesc != "" )
				{
					m_MissionObjectives.AddText(szObjectiveDesc,Root.Colors.White,Root.Fonts[10]);
				}
			}
			++i;
			goto JL05C4;
		}
		if ( R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_bUsingPlayerCampaign )
		{
			m_DebriefNavBar.m_ContinueButton.bDisabled=True;
		}
	}
	m_pR6RainbowTeamBar.RefreshTeamBarInfo();
	if (  !R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_bUsingPlayerCampaign )
	{
		BuildMissionOperatives();
	}
	if ( m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.Items.Next != None )
	{
		m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.SetSelectedItem(R6WindowListIGPlayerInfoItem(m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.Items.Next));
		DisplayOperativeStats(R6WindowListIGPlayerInfoItem(m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.m_SelectedItem).m_iOperativeID);
	}
	else
	{
		m_RainbowCarreerStats.UpdateStats("","","","","");
	}*/
}

function HideWindow ()
{
	local Canvas C;

	C=Class'Actor'.static.GetCanvas();
	Super.HideWindow();
	C.m_iNewResolutionX=0;
	C.m_iNewResolutionY=0;
	C.m_bChangeResRequested=True;
	GetLevel().m_bAllow3DRendering=True;
	GetPlayerOwner().SetPause(False);
}

function BuildMissionOperatives ()
{
	local R6Operative tmpOperative;
	local R6WindowListIGPlayerInfoItem tmpItem;

	m_MissionOperatives.Remove (0,m_MissionOperatives.Length);
	tmpItem=R6WindowListIGPlayerInfoItem(m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.Items.Next);
JL0038:
	if ( tmpItem != None )
	{
		tmpOperative=new Class<R6Operative>(DynamicLoadObject(R6Console(Root.Console).m_CurrentCampaign.m_OperativeClassName[tmpItem.m_iOperativeID],Class'Class'));
		tmpItem.m_iOperativeID=m_MissionOperatives.Length;
		m_MissionOperatives[m_MissionOperatives.Length]=tmpOperative;
		tmpOperative.m_iNbMissionPlayed=1;
		tmpOperative.m_iTerrokilled=tmpItem.iKills;
		tmpOperative.m_iRoundsfired=tmpItem.iRoundsFired;
		tmpOperative.m_iRoundsOntarget=tmpItem.iRoundsHit;
		tmpOperative.m_iHealth=tmpItem.eStatus;
		tmpItem=R6WindowListIGPlayerInfoItem(tmpItem.Next);
		goto JL0038;
	}
}

function DisplayOperativeStats (int _OperativeId)
{
	local R6Operative tmpOperative;
	local R6PlayerCampaign MyCampaign;
	local R6MissionRoster PlayerCampaignOperatives;
	local R6WindowListIGPlayerInfoItem SelectedItem;
	local Region R;

	SelectedItem=R6WindowListIGPlayerInfoItem(m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.m_SelectedItem);
	if ( R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_bUsingPlayerCampaign )
	{
		MyCampaign=R6Console(Root.Console).m_PlayerCampaign;
		PlayerCampaignOperatives=MyCampaign.m_OperativesMissionDetails;
		tmpOperative=PlayerCampaignOperatives.m_MissionOperatives[_OperativeId];
	}
	else
	{
		tmpOperative=m_MissionOperatives[_OperativeId];
	}
	m_RainbowCarreerStats.UpdateStats(tmpOperative.GetNbMissionPlayed(),tmpOperative.GetNbTerrokilled(),tmpOperative.GetNbRoundsfired(),tmpOperative.GetNbRoundsOnTarget(),tmpOperative.GetShootPercent());
	R.X=tmpOperative.m_RMenuFaceX;
	R.Y=tmpOperative.m_RMenuFaceY;
	R.W=tmpOperative.m_RMenuFaceW;
	R.H=tmpOperative.m_RMenuFaceH;
	m_RainbowCarreerStats.UpdateFace(tmpOperative.m_TMenuFace,R);
	m_RainbowCarreerStats.UpdateTeam(SelectedItem.m_iRainbowTeam);
	m_RainbowCarreerStats.UpdateName(tmpOperative.GetName());
	m_RainbowCarreerStats.UpdateSpeciality(tmpOperative.GetSpeciality());
	m_RainbowCarreerStats.UpdateHealthStatus(tmpOperative.GetHealthStatus());
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		switch (C)
		{
			case m_pR6RainbowTeamBar.m_IGPlayerInfoListBox:
			if ( m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.m_SelectedItem != None )
			{
				DisplayOperativeStats(R6WindowListIGPlayerInfoItem(m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.m_SelectedItem).m_iOperativeID);
			}
			break;
			default:
		}
	}
}

defaultproperties
{
    m_fObjHeight=72.00
    m_fMissionResultTitleHeight=32.00
    m_fMissionResultTitleWidth=598.00
    m_fPaddingBetween=3.00
    m_fStatsWidth=294.00
    m_RBGMissionResult=(X=8790534,Y=570753024,W=104,H=1843716)
    m_RBGExtMissionResult=(X=7610886,Y=570753024,W=104,H=1057284)
}
/*
    m_TBGMissionResult=Texture'R6MenuTextures.Gui_BoxScroll'
    m_sndVictoryMusic=Sound'Music.Play_theme_MissionVictory'
    m_sndLossMusic=Sound'Music.Play_theme_MissionLoss'
*/

