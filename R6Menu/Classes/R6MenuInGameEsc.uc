//================================================================================
// R6MenuInGameEsc.
//================================================================================
class R6MenuInGameEsc extends R6MenuWidget;

var float m_fLabelHeight;
var float m_fNavBarHeight;
var float m_fRainbowStatsHeight;
var R6WindowTextLabel m_CodeName;
var R6WindowTextLabel m_DateTime;
var R6WindowTextLabel m_Location;
var R6MenuInGameEscSinglePlayerNavBar m_pInGameNavBar;
var R6MenuSingleTeamBar m_pR6RainbowTeamBar;
var R6MenuEscObjectives m_EscObj;

function Created ()
{
	if ( R6MenuInGameRootWindow(Root).m_bInTraining )
	{
		InitTrainingEsc();
	}
	else
	{
		InitInGameEsc();
	}
}

function InitInGameEsc ()
{
	local float labelWidth;
	local R6MenuInGameRootWindow r6Root;

	r6Root=R6MenuInGameRootWindow(Root);
	labelWidth=r6Root.m_REscMenuWidget.W / 3;
	m_CodeName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',r6Root.m_REscMenuWidget.X,r6Root.m_REscMenuWidget.Y + r6Root.m_fTopLabelHeight,labelWidth,m_fLabelHeight,self));
	m_DateTime=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_CodeName.WinLeft + m_CodeName.WinWidth,m_CodeName.WinTop,labelWidth,m_fLabelHeight,self));
	m_Location=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_DateTime.WinLeft + m_DateTime.WinWidth,m_CodeName.WinTop,m_DateTime.WinWidth,m_fLabelHeight,self));
	m_pInGameNavBar=R6MenuInGameEscSinglePlayerNavBar(CreateWindow(Class'R6MenuInGameEscSinglePlayerNavBar',r6Root.m_REscMenuWidget.X,r6Root.m_REscMenuWidget.Y + r6Root.m_fTopLabelHeight + r6Root.m_REscMenuWidget.H - m_fNavBarHeight,r6Root.m_REscMenuWidget.W,m_fNavBarHeight,self));
	m_BorderColor=Root.Colors.Red;
	m_pR6RainbowTeamBar=R6MenuSingleTeamBar(CreateWindow(Class'R6MenuSingleTeamBar',m_CodeName.WinLeft,m_CodeName.WinTop + m_CodeName.WinHeight,r6Root.m_REscMenuWidget.W,m_fRainbowStatsHeight,self));
	m_pR6RainbowTeamBar.m_IGPlayerInfoListBox.m_bIgnoreUserClicks=True;
	m_EscObj=R6MenuEscObjectives(CreateWindow(Class'R6MenuEscObjectives',m_pR6RainbowTeamBar.WinLeft,m_pR6RainbowTeamBar.WinTop + m_pR6RainbowTeamBar.WinHeight,m_pR6RainbowTeamBar.WinWidth,m_pInGameNavBar.WinTop - m_pR6RainbowTeamBar.WinTop - m_pR6RainbowTeamBar.WinHeight));
}

function InitTrainingEsc ()
{
	local R6MenuInGameRootWindow r6Root;

	r6Root=R6MenuInGameRootWindow(Root);
	m_pInGameNavBar=R6MenuInGameEscSinglePlayerNavBar(CreateWindow(Class'R6MenuInGameEscSinglePlayerNavBar',r6Root.m_REscTraining.X,r6Root.m_REscTraining.Y + r6Root.m_fTopLabelHeight + r6Root.m_REscTraining.H - m_fNavBarHeight,r6Root.m_REscTraining.W,m_fNavBarHeight,self));
	m_pInGameNavBar.SetTrainingNavbar();
}

function ShowWindow ()
{
	local R6MissionDescription CurrentMission;
	local R6MenuInGameRootWindow r6Root;

	Super.ShowWindow();
	r6Root=R6MenuInGameRootWindow(Root);
	if (  !r6Root.m_bInEscMenu )
	{
		GetPlayerOwner().SetPause(True);
		GetPlayerOwner().SaveCurrentFadeValue();
		R6PlayerController(GetPlayerOwner()).ClientFadeCommonSound(0.50,0);
		GetPlayerOwner().FadeSound(0.50,0,SLOT_Music);
		GetPlayerOwner().FadeSound(0.50,0,SLOT_Speak);
	}
	if ( r6Root.m_bInTraining )
	{
		return;
	}
	CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
/*	m_CodeName.SetProperties(Localize(CurrentMission.m_MapName,"ID_CODENAME",CurrentMission.LocalizationFile),2,Root.Fonts[0],Root.Colors.White,False);
	m_DateTime.SetProperties(Localize(CurrentMission.m_MapName,"ID_DATETIME",CurrentMission.LocalizationFile),2,Root.Fonts[0],Root.Colors.White,False);
	m_Location.SetProperties(Localize(CurrentMission.m_MapName,"ID_LOCATION",CurrentMission.LocalizationFile),2,Root.Fonts[0],Root.Colors.White,False);*/
	m_pR6RainbowTeamBar.RefreshTeamBarInfo();
	m_EscObj.UpdateObjectives();
}

function HideWindow ()
{
	local R6MenuInGameRootWindow r6Root;

	Super.HideWindow();
	r6Root=R6MenuInGameRootWindow(Root);
	if (  !r6Root.m_bInEscMenu )
	{
		GetPlayerOwner().SetPause(False);
		GetPlayerOwner().ReturnSavedFadeValue(0.50);
	}
}

defaultproperties
{
    m_fLabelHeight=18.00
    m_fNavBarHeight=55.00
    m_fRainbowStatsHeight=166.00
}
