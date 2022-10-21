//================================================================================
// R6MenuNavigationBar.
//================================================================================
class R6MenuNavigationBar extends UWindowDialogClientWindow;

var int m_iNavBarLocation[9];
var int m_iBigButtonHeight;
var R6WindowButton m_MainMenuButton;
var R6WindowButton m_OptionsButton;
var R6WindowButton m_BriefingButton;
var R6WindowButton m_GearButton;
var R6WindowButton m_PlanningButton;
var R6WindowButton m_PlayButton;
var R6WindowButton m_SaveButton;
var R6WindowButton m_LoadButton;
var R6WindowButton m_QuickPlayButton;
var Texture m_TMainMenuTexture;
var Region m_RMainMenuButtonUp;
var Region m_RMainMenuButtonDown;
var Region m_RMainMenuButtonDisabled;
var Region m_RMainMenuButtonOver;
var Region m_ROptionsButtonUp;
var Region m_ROptionsButtonDown;
var Region m_ROptionsButtonDisabled;
var Region m_ROptionsButtonOver;
var Region m_RBriefingButtonUp;
var Region m_RBriefingButtonDown;
var Region m_RBriefingButtonDisabled;
var Region m_RBriefingButtonOver;
var Region m_RGearButtonUp;
var Region m_RGearButtonDown;
var Region m_RGearButtonDisabled;
var Region m_RGearButtonOver;
var Region m_RPlanningButtonUp;
var Region m_RPlanningButtonDown;
var Region m_RPlanningButtonDisabled;
var Region m_RPlanningButtonOver;
var Region m_RPlayButtonUp;
var Region m_RPlayButtonDown;
var Region m_RPlayButtonDisabled;
var Region m_RPlayButtonOver;
var Region m_RSaveButtonUp;
var Region m_RSaveButtonDown;
var Region m_RSaveButtonDisabled;
var Region m_RSaveButtonOver;
var Region m_RLoadButtonUp;
var Region m_RLoadButtonDown;
var Region m_RLoadButtonDisabled;
var Region m_RLoadButtonOver;
var Region m_RQuickPlayButtonUp;
var Region m_RQuickPlayButtonDown;
var Region m_RQuickPlayButtonDisabled;
var Region m_RQuickPlayButtonOver;

function Created ()
{
	m_MainMenuButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[0],m_iBigButtonHeight,m_RMainMenuButtonUp.W,m_RMainMenuButtonUp.H,self));
	m_MainMenuButton.UpTexture=m_TMainMenuTexture;
	m_MainMenuButton.OverTexture=m_TMainMenuTexture;
	m_MainMenuButton.DownTexture=m_TMainMenuTexture;
	m_MainMenuButton.DisabledTexture=m_TMainMenuTexture;
	m_MainMenuButton.UpRegion=m_RMainMenuButtonUp;
	m_MainMenuButton.OverRegion=m_RMainMenuButtonOver;
	m_MainMenuButton.DownRegion=m_RMainMenuButtonDown;
	m_MainMenuButton.DisabledRegion=m_RMainMenuButtonDisabled;
	m_MainMenuButton.bUseRegion=True;
	m_MainMenuButton.ToolTipString=Localize("PlanningMenu","Home","R6Menu");
	m_MainMenuButton.m_iDrawStyle=5;
	m_OptionsButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[1],m_iBigButtonHeight,m_ROptionsButtonUp.W,m_ROptionsButtonUp.H,self));
	m_OptionsButton.UpTexture=m_TMainMenuTexture;
	m_OptionsButton.OverTexture=m_TMainMenuTexture;
	m_OptionsButton.DownTexture=m_TMainMenuTexture;
	m_OptionsButton.DisabledTexture=m_TMainMenuTexture;
	m_OptionsButton.UpRegion=m_ROptionsButtonUp;
	m_OptionsButton.DownRegion=m_ROptionsButtonDown;
	m_OptionsButton.DisabledRegion=m_ROptionsButtonDisabled;
	m_OptionsButton.OverRegion=m_ROptionsButtonOver;
	m_OptionsButton.bUseRegion=True;
	m_OptionsButton.ToolTipString=Localize("PlanningMenu","Option","R6Menu");
	m_OptionsButton.m_iDrawStyle=5;
	m_BriefingButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[2],m_iBigButtonHeight,m_RBriefingButtonUp.W,m_RBriefingButtonUp.H,self));
	m_BriefingButton.UpTexture=m_TMainMenuTexture;
	m_BriefingButton.OverTexture=m_TMainMenuTexture;
	m_BriefingButton.DownTexture=m_TMainMenuTexture;
	m_BriefingButton.DisabledTexture=m_TMainMenuTexture;
	m_BriefingButton.UpRegion=m_RBriefingButtonUp;
	m_BriefingButton.OverRegion=m_RBriefingButtonOver;
	m_BriefingButton.DownRegion=m_RBriefingButtonDown;
	m_BriefingButton.DisabledRegion=m_RBriefingButtonDisabled;
	m_BriefingButton.bUseRegion=True;
	m_BriefingButton.ToolTipString=Localize("PlanningMenu","Breifing","R6Menu");
	m_BriefingButton.m_iDrawStyle=5;
	m_GearButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[3],m_iBigButtonHeight,m_RGearButtonUp.W,m_RGearButtonUp.H,self));
	m_GearButton.UpTexture=m_TMainMenuTexture;
	m_GearButton.OverTexture=m_TMainMenuTexture;
	m_GearButton.DownTexture=m_TMainMenuTexture;
	m_GearButton.DisabledTexture=m_TMainMenuTexture;
	m_GearButton.UpRegion=m_RGearButtonUp;
	m_GearButton.OverRegion=m_RGearButtonOver;
	m_GearButton.DownRegion=m_RGearButtonDown;
	m_GearButton.DisabledRegion=m_RGearButtonDisabled;
	m_GearButton.bUseRegion=True;
	m_GearButton.ToolTipString=Localize("PlanningMenu","Gear","R6Menu");
	m_GearButton.m_iDrawStyle=5;
	m_PlanningButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[4],m_iBigButtonHeight,m_RPlanningButtonUp.W,m_RPlanningButtonUp.H,self));
	m_PlanningButton.UpTexture=m_TMainMenuTexture;
	m_PlanningButton.OverTexture=m_TMainMenuTexture;
	m_PlanningButton.DownTexture=m_TMainMenuTexture;
	m_PlanningButton.DisabledTexture=m_TMainMenuTexture;
	m_PlanningButton.UpRegion=m_RPlanningButtonUp;
	m_PlanningButton.OverRegion=m_RPlanningButtonOver;
	m_PlanningButton.DownRegion=m_RPlanningButtonDown;
	m_PlanningButton.DisabledRegion=m_RPlanningButtonDisabled;
	m_PlanningButton.bUseRegion=True;
	m_PlanningButton.ToolTipString=Localize("PlanningMenu","Planning","R6Menu");
	m_PlanningButton.m_iDrawStyle=5;
	m_PlayButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[5],m_iBigButtonHeight,m_RPlayButtonUp.W,m_RPlayButtonUp.H,self));
	m_PlayButton.UpTexture=m_TMainMenuTexture;
	m_PlayButton.OverTexture=m_TMainMenuTexture;
	m_PlayButton.DownTexture=m_TMainMenuTexture;
	m_PlayButton.DisabledTexture=m_TMainMenuTexture;
	m_PlayButton.UpRegion=m_RPlayButtonUp;
	m_PlayButton.OverRegion=m_RPlayButtonOver;
	m_PlayButton.DownRegion=m_RPlayButtonDown;
	m_PlayButton.DisabledRegion=m_RPlayButtonDisabled;
	m_PlayButton.bUseRegion=True;
	m_PlayButton.ToolTipString=Localize("PlanningMenu","Play","R6Menu");
	m_PlayButton.m_iDrawStyle=5;
	m_SaveButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[6],m_iBigButtonHeight,m_RSaveButtonUp.W,m_RSaveButtonUp.H,self));
	m_SaveButton.UpTexture=m_TMainMenuTexture;
	m_SaveButton.OverTexture=m_TMainMenuTexture;
	m_SaveButton.DownTexture=m_TMainMenuTexture;
	m_SaveButton.DisabledTexture=m_TMainMenuTexture;
	m_SaveButton.UpRegion=m_RSaveButtonUp;
	m_SaveButton.OverRegion=m_RSaveButtonOver;
	m_SaveButton.DownRegion=m_RSaveButtonDown;
	m_SaveButton.DisabledRegion=m_RSaveButtonDisabled;
	m_SaveButton.bUseRegion=True;
	m_SaveButton.ToolTipString=Localize("PlanningMenu","Save","R6Menu");
	m_SaveButton.m_iDrawStyle=5;
	m_LoadButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[7],m_iBigButtonHeight,m_RSaveButtonUp.W,m_RSaveButtonUp.H,self));
	m_LoadButton.UpTexture=m_TMainMenuTexture;
	m_LoadButton.OverTexture=m_TMainMenuTexture;
	m_LoadButton.DownTexture=m_TMainMenuTexture;
	m_LoadButton.DisabledTexture=m_TMainMenuTexture;
	m_LoadButton.UpRegion=m_RLoadButtonUp;
	m_LoadButton.OverRegion=m_RLoadButtonOver;
	m_LoadButton.DownRegion=m_RLoadButtonDown;
	m_LoadButton.DisabledRegion=m_RLoadButtonDisabled;
	m_LoadButton.bUseRegion=True;
	m_LoadButton.ToolTipString=Localize("PlanningMenu","Load","R6Menu");
	m_LoadButton.m_iDrawStyle=5;
	m_QuickPlayButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iNavBarLocation[8],m_iBigButtonHeight,m_RQuickPlayButtonUp.W,m_RQuickPlayButtonUp.H,self));
	m_QuickPlayButton.UpTexture=m_TMainMenuTexture;
	m_QuickPlayButton.OverTexture=m_TMainMenuTexture;
	m_QuickPlayButton.DownTexture=m_TMainMenuTexture;
	m_QuickPlayButton.DisabledTexture=m_TMainMenuTexture;
	m_QuickPlayButton.UpRegion=m_RQuickPlayButtonUp;
	m_QuickPlayButton.OverRegion=m_RQuickPlayButtonOver;
	m_QuickPlayButton.DownRegion=m_RQuickPlayButtonDown;
	m_QuickPlayButton.DisabledRegion=m_RQuickPlayButtonDisabled;
	m_QuickPlayButton.bUseRegion=True;
	m_QuickPlayButton.ToolTipString=Localize("PlanningMenu","QuickPlay","R6Menu");
	m_QuickPlayButton.m_iDrawStyle=5;
	m_BorderColor=Root.Colors.BlueLight;
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6MenuRootWindow r6Root;
	local R6GameOptions pGameOptions;

	if ( E == 2 )
	{
		r6Root=R6MenuRootWindow(Root);
		switch (C)
		{
			case m_MainMenuButton:
			r6Root.StopPlayMode();
			r6Root.ClosePopups();
//			r6Root.SimplePopUp(Localize("POPUP","PopUpTitle_QuitToMain","R6Menu"),Localize("ESCMENUS","MAINCONFIRM","R6Menu"),41);
			break;
			case m_OptionsButton:
//			r6Root.ChangeCurrentWidget(16);
			break;
			case m_BriefingButton:
//			r6Root.ChangeCurrentWidget(8);
			break;
			case m_GearButton:
//			r6Root.ChangeCurrentWidget(12);
			break;
			case m_PlanningButton:
//			r6Root.ChangeCurrentWidget(9);
			break;
			case m_PlayButton:
			if ( r6Root.m_GearRoomWidget.IsTeamConfigValid() )
			{
				r6Root.m_PlanningWidget.m_PlanningBar.m_TimeLine.Reset();
//				Root.ChangeCurrentWidget(13);
			}
			else
			{
				r6Root.StopPlayMode();
				r6Root.ClosePopups();
//				r6Root.SimplePopUp(Localize("POPUP","INCOMPLETEPLANNING","R6Menu"),Localize("POPUP","INCOMPLETEPLANNINGPROBLEM","R6Menu"),44,2);
			}
			break;
			case m_SaveButton:
			r6Root.StopPlayMode();
			r6Root.ClosePopups();
//			r6Root.m_ePopUpID=42;
			r6Root.PopUpMenu();
			break;
			case m_LoadButton:
			r6Root.StopPlayMode();
			r6Root.ClosePopups();
//			r6Root.m_ePopUpID=43;
			r6Root.PopUpMenu();
			break;
			case m_QuickPlayButton:
			r6Root.ClosePopups();
			pGameOptions=Class'Actor'.static.GetGameOptions();
			if ( (pGameOptions.PopUpQuickPlay == True) && (r6Root.m_GearRoomWidget.IsTeamConfigValid() || (r6Root.IsPlanningEmpty() == False)) )
			{
//				r6Root.SimplePopUp(Localize("POPUP","PopUpTitle_QuiPlay","R6Menu"),Localize("POPUP","PopUpMsg_QuiPlay","R6Menu"),34,0,True);
			}
			else
			{
				r6Root.LaunchQuickPlay();
			}
			break;
			default:
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	R6MenuRSLookAndFeel(LookAndFeel).DrawNavigationBar(self,C);
}

defaultproperties
{
    m_iNavBarLocation(0)=22
    m_iNavBarLocation(1)=74
    m_iNavBarLocation(2)=170
    m_iNavBarLocation(3)=252
    m_iNavBarLocation(4)=338
    m_iNavBarLocation(5)=420
    m_iNavBarLocation(6)=466
    m_iNavBarLocation(7)=510
    m_iNavBarLocation(8)=559
    m_iBigButtonHeight=1
    m_RMainMenuButtonUp=(X=7414278,Y=570753024,W=120,H=1909252)
    m_RMainMenuButtonDown=(X=7414278,Y=570753024,W=180,H=1909252)
    m_RMainMenuButtonDisabled=(X=7414278,Y=570753024,W=210,H=1909252)
    m_RMainMenuButtonOver=(X=7414278,Y=570753024,W=150,H=1909252)
    m_ROptionsButtonUp=(X=5710342,Y=570753024,W=120,H=1647108)
    m_ROptionsButtonDown=(X=5710342,Y=570753024,W=180,H=1647108)
    m_ROptionsButtonDisabled=(X=5710342,Y=570753024,W=210,H=1647108)
    m_ROptionsButtonOver=(X=5710342,Y=570753024,W=150,H=1647108)
    m_RBriefingButtonUp=(X=1974788,Y=570621952,W=30,H=0)
    m_RBriefingButtonDown=(X=3940869,Y=570687488,W=30,H=1974787)
    m_RBriefingButtonDisabled=(X=5906949,Y=570687488,W=30,H=1974787)
    m_RBriefingButtonOver=(X=1974789,Y=570687488,W=30,H=1974787)
    m_RGearButtonUp=(X=1974790,Y=570687488,W=34,H=1974787)
    m_RGearButtonDown=(X=1974790,Y=570753024,W=60,H=2236932)
    m_RGearButtonDisabled=(X=1974790,Y=570753024,W=90,H=2236932)
    m_RGearButtonOver=(X=1974790,Y=570753024,W=30,H=2236932)
    m_RPlanningButtonUp=(X=4203014,Y=570687488,W=29,H=1974787)
    m_RPlanningButtonDown=(X=4203014,Y=570753024,W=60,H=1909252)
    m_RPlanningButtonDisabled=(X=4203014,Y=570753024,W=90,H=1909252)
    m_RPlanningButtonOver=(X=4203014,Y=570753024,W=30,H=1909252)
    m_RPlayButtonUp=(X=7873029,Y=570687488,W=25,H=1974787)
    m_RPlayButtonDown=(X=11805189,Y=570687488,W=25,H=1974787)
    m_RPlayButtonDisabled=(X=13771269,Y=570687488,W=25,H=1974787)
    m_RPlayButtonOver=(X=9839109,Y=570687488,W=25,H=1974787)
    m_RSaveButtonUp=(X=11346438,Y=570753024,W=120,H=1909252)
    m_RSaveButtonDown=(X=11346438,Y=570753024,W=180,H=1909252)
    m_RSaveButtonDisabled=(X=11346438,Y=570753024,W=210,H=1909252)
    m_RSaveButtonOver=(X=11346438,Y=570753024,W=150,H=1909252)
    m_RLoadButtonUp=(X=9380358,Y=570753024,W=120,H=1909252)
    m_RLoadButtonDown=(X=9380358,Y=570753024,W=180,H=1909252)
    m_RLoadButtonDisabled=(X=9380358,Y=570753024,W=210,H=1974788)
    m_RLoadButtonOver=(X=9380358,Y=570753024,W=150,H=1909252)
    m_RQuickPlayButtonUp=(X=3416582,Y=570753024,W=120,H=2236932)
    m_RQuickPlayButtonDown=(X=3416582,Y=570753024,W=180,H=2236932)
    m_RQuickPlayButtonDisabled=(X=3416582,Y=570753024,W=210,H=2236932)
    m_RQuickPlayButtonOver=(X=3416582,Y=570753024,W=150,H=2236932)
}
/*
    m_TMainMenuTexture=Texture'R6MenuTextures.Gui_01'
*/

