//================================================================================
// R6MenuDebriefNavBar.
//================================================================================
class R6MenuDebriefNavBar extends UWindowDialogClientWindow;

var float m_fButtonsYPos;
var float m_fMainMenuXPos;
var float m_fOptionsXPos;
var float m_fActionXPos;
var float m_fPlanningXPos;
var float m_fContinueXPos;
var R6WindowButton m_MainMenuButton;
var R6WindowButton m_OptionsButton;
var R6WindowButton m_ActionButton;
var R6WindowButton m_PlanningButton;
var R6WindowButton m_ContinueButton;
var Texture m_TMainMenuButton;
var Texture m_TOptionsButton;
var Texture m_TActionButton;
var Texture m_TPlanningButton;
var Texture m_TContinueButton;
var Region m_RMainMenuButtonUp;
var Region m_RMainMenuButtonDown;
var Region m_RMainMenuButtonDisabled;
var Region m_RMainMenuButtonOver;
var Region m_ROptionsButtonUp;
var Region m_ROptionsButtonDown;
var Region m_ROptionsButtonDisabled;
var Region m_ROptionsButtonOver;
var Region m_RActionButtonUp;
var Region m_RActionButtonDown;
var Region m_RActionButtonDisabled;
var Region m_RActionButtonOver;
var Region m_RPlanningButtonUp;
var Region m_RPlanningButtonDown;
var Region m_RPlanningButtonDisabled;
var Region m_RPlanningButtonOver;
var Region m_RContinueButtonUp;
var Region m_RContinueButtonDown;
var Region m_RContinueButtonDisabled;
var Region m_RContinueButtonOver;

function Created ()
{
	m_MainMenuButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fMainMenuXPos,m_fButtonsYPos,m_RMainMenuButtonUp.W,m_RMainMenuButtonUp.H,self));
	m_MainMenuButton.UpTexture=m_TMainMenuButton;
	m_MainMenuButton.OverTexture=m_TMainMenuButton;
	m_MainMenuButton.DownTexture=m_TMainMenuButton;
	m_MainMenuButton.DisabledTexture=m_TMainMenuButton;
	m_MainMenuButton.UpRegion=m_RMainMenuButtonUp;
	m_MainMenuButton.OverRegion=m_RMainMenuButtonOver;
	m_MainMenuButton.DownRegion=m_RMainMenuButtonDown;
	m_MainMenuButton.DisabledRegion=m_RMainMenuButtonDisabled;
	m_MainMenuButton.bUseRegion=True;
	m_MainMenuButton.ToolTipString=Localize("ESCMENUS","MAIN","R6Menu");
//	m_MainMenuButton.m_iDrawStyle=5;
	m_MainMenuButton.m_bWaitSoundFinish=True;
	m_OptionsButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fOptionsXPos,m_fButtonsYPos,m_ROptionsButtonUp.W,m_ROptionsButtonUp.H,self));
	m_OptionsButton.UpTexture=m_TOptionsButton;
	m_OptionsButton.OverTexture=m_TOptionsButton;
	m_OptionsButton.DownTexture=m_TOptionsButton;
	m_OptionsButton.DisabledTexture=m_TOptionsButton;
	m_OptionsButton.UpRegion=m_ROptionsButtonUp;
	m_OptionsButton.DownRegion=m_ROptionsButtonDown;
	m_OptionsButton.DisabledRegion=m_ROptionsButtonDisabled;
	m_OptionsButton.OverRegion=m_ROptionsButtonOver;
	m_OptionsButton.bUseRegion=True;
	m_OptionsButton.ToolTipString=Localize("ESCMENUS","ESCOPTIONS","R6Menu");
//	m_OptionsButton.m_iDrawStyle=5;
	m_OptionsButton.m_bWaitSoundFinish=True;
	m_ActionButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fActionXPos,m_fButtonsYPos,m_RActionButtonUp.W,m_RActionButtonUp.H,self));
	m_ActionButton.UpTexture=m_TActionButton;
	m_ActionButton.OverTexture=m_TActionButton;
	m_ActionButton.DownTexture=m_TActionButton;
	m_ActionButton.DisabledTexture=m_TActionButton;
	m_ActionButton.UpRegion=m_RActionButtonUp;
	m_ActionButton.OverRegion=m_RActionButtonOver;
	m_ActionButton.DownRegion=m_RActionButtonDown;
	m_ActionButton.DisabledRegion=m_RActionButtonDisabled;
	m_ActionButton.bUseRegion=True;
	m_ActionButton.ToolTipString=Localize("DebriefingMenu","ACTION","R6Menu");
//	m_ActionButton.m_iDrawStyle=5;
	m_ActionButton.m_bWaitSoundFinish=True;
	m_PlanningButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fPlanningXPos,m_fButtonsYPos,m_RPlanningButtonUp.W,m_RPlanningButtonUp.H,self));
	m_PlanningButton.UpTexture=m_TPlanningButton;
	m_PlanningButton.OverTexture=m_TPlanningButton;
	m_PlanningButton.DownTexture=m_TPlanningButton;
	m_PlanningButton.DisabledTexture=m_TPlanningButton;
	m_PlanningButton.UpRegion=m_RPlanningButtonUp;
	m_PlanningButton.OverRegion=m_RPlanningButtonOver;
	m_PlanningButton.DownRegion=m_RPlanningButtonDown;
	m_PlanningButton.DisabledRegion=m_RPlanningButtonDisabled;
	m_PlanningButton.bUseRegion=True;
	m_PlanningButton.ToolTipString=Localize("DebriefingMenu","PLAN","R6Menu");
//	m_PlanningButton.m_iDrawStyle=5;
	m_PlanningButton.m_bWaitSoundFinish=True;
	m_ContinueButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fContinueXPos,m_fButtonsYPos,m_RContinueButtonUp.W,m_RContinueButtonUp.H,self));
	m_ContinueButton.UpTexture=m_TContinueButton;
	m_ContinueButton.OverTexture=m_TContinueButton;
	m_ContinueButton.DownTexture=m_TContinueButton;
	m_ContinueButton.DisabledTexture=m_TContinueButton;
	m_ContinueButton.UpRegion=m_RContinueButtonUp;
	m_ContinueButton.OverRegion=m_RContinueButtonOver;
	m_ContinueButton.DownRegion=m_RContinueButtonDown;
	m_ContinueButton.DisabledRegion=m_RContinueButtonDisabled;
	m_ContinueButton.bUseRegion=True;
	m_ContinueButton.ToolTipString=Localize("DebriefingMenu","CONTINUE","R6Menu");
//	m_ContinueButton.m_iDrawStyle=5;
	m_ContinueButton.m_bWaitSoundFinish=True;
	m_BorderColor=Root.Colors.BlueLight;
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6GameInfo GameInfo;
	local R6PlayerCampaign MyCampaign;
	local R6FileManagerCampaign pFileManager;

	GameInfo=R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game);
	if ( E == 2 )
	{
		switch (C)
		{
			case m_MainMenuButton:
//			R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","PopUpTitle_QuitToMain","R6Menu"),Localize("ESCMENUS","MAINCONFIRM","R6Menu"),45);
			break;
			case m_OptionsButton:
//			Root.ChangeCurrentWidget(16);
			break;
			case m_ActionButton:
			if ( GameInfo.m_bUsingPlayerCampaign )
			{
				DenyMissionOutcome();
			}
			Root.Console.Master.m_StartGameInfo.m_SkipPlanningPhase=True;
			Root.Console.Master.m_StartGameInfo.m_ReloadPlanning=True;
			Root.Console.Master.m_StartGameInfo.m_ReloadActionPointOnly=True;
			R6Console(Root.Console).ResetR6Game();
			break;
			case m_PlanningButton:
			Root.Console.Master.m_StartGameInfo.m_SkipPlanningPhase=False;
			Root.Console.Master.m_StartGameInfo.m_ReloadPlanning=True;
			Root.Console.Master.m_StartGameInfo.m_ReloadActionPointOnly=False;
			if ( GameInfo.m_bUsingPlayerCampaign )
			{
				DenyMissionOutcome();
//				R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).6);
			}
			else
			{
//				R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).4);
			}
			break;
			case m_ContinueButton:
			Root.Console.Master.m_StartGameInfo.m_SkipPlanningPhase=False;
			Root.Console.Master.m_StartGameInfo.m_ReloadPlanning=False;
			Root.Console.Master.m_StartGameInfo.m_ReloadActionPointOnly=False;
			if ( GameInfo.m_bUsingPlayerCampaign )
			{
				if ( AcceptMissionOutcome() == True )
				{
//					R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).1);
				}
			}
			else
			{
//				R6Console(Root.Console).LeaveR6Game(R6Console(Root.Console).5);
			}
			break;
			default:
		}
	}
}

function DenyMissionOutcome ()
{
	local R6FileManagerCampaign FileManager;
	local R6PlayerCampaign MyCampaign;

	FileManager=new Class'R6FileManagerCampaign';
	MyCampaign=R6Console(Root.Console).m_PlayerCampaign;
	MyCampaign.m_OperativesMissionDetails=None;
	MyCampaign.m_OperativesMissionDetails=new Class'R6MissionRoster';
	FileManager.LoadCampaign(MyCampaign);
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
	C.Style=5;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
//	DrawStretchedTextureSegment(C,120.00,0.00,1.00,33.00,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

function bool AcceptMissionOutcome ()
{
	local R6PlayerCampaign MyCampaign;
	local R6FileManagerCampaign pFileManager;
	local R6Console R6Console;

	R6Console=R6Console(Root.Console);
	MyCampaign=R6Console.m_PlayerCampaign;
	pFileManager=new Class'R6FileManagerCampaign';
	if ( pFileManager.SaveCampaign(MyCampaign) == False )
	{
		R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","FILEERROR","R6Menu"),MyCampaign.m_FileName @ ":" @ Localize("POPUP","FILEERRORPROBLEM","R6Menu"),EPopUpID_FileWriteError,2);
		return False;
	}
	pFileManager.LoadCustomMissionAvailable(R6Console.m_playerCustomMission);
	if ( R6Console.UpdateCurrentMapAvailable(MyCampaign) )
	{
		if ( pFileManager.SaveCustomMissionAvailable(R6Console.m_playerCustomMission) == False )
		{
			R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","FILEERROR","R6Menu"),Class'Actor'.static.GetModMgr().GetPlayerCustomMission() @ ":" @ Localize("POPUP","FILEERRORPROBLEM","R6Menu"),EPopUpID_FileWriteError,2);
			return False;
		}
	}
	return True;
}

defaultproperties
{
    m_fButtonsYPos=1.00
    m_fMainMenuXPos=22.00
    m_fOptionsXPos=74.00
    m_fActionXPos=217.00
    m_fPlanningXPos=344.00
    m_fContinueXPos=467.00
    m_RMainMenuButtonUp=(X=7414278,Y=570753024,W=120,H=1909252)
    m_RMainMenuButtonDown=(X=7414278,Y=570753024,W=180,H=1909252)
    m_RMainMenuButtonDisabled=(X=7414278,Y=570753024,W=210,H=1909252)
    m_RMainMenuButtonOver=(X=7414278,Y=570753024,W=150,H=1909252)
    m_ROptionsButtonUp=(X=5710342,Y=570753024,W=120,H=1647108)
    m_ROptionsButtonDown=(X=5710342,Y=570753024,W=180,H=1647108)
    m_ROptionsButtonDisabled=(X=5710342,Y=570753024,W=210,H=1647108)
    m_ROptionsButtonOver=(X=5710342,Y=570753024,W=150,H=1647108)
    m_RActionButtonUp=(X=6103558,Y=570687488,W=32,H=1974787)
    m_RActionButtonDown=(X=6103558,Y=570753024,W=60,H=2105860)
    m_RActionButtonDisabled=(X=6103558,Y=570753024,W=90,H=2105860)
    m_RActionButtonOver=(X=6103558,Y=570753024,W=30,H=2105860)
    m_RPlanningButtonUp=(X=8200710,Y=570687488,W=30,H=1974787)
    m_RPlanningButtonDown=(X=8200710,Y=570753024,W=60,H=1974788)
    m_RPlanningButtonDisabled=(X=8200710,Y=570753024,W=90,H=1974788)
    m_RPlanningButtonOver=(X=8200710,Y=570753024,W=30,H=1974788)
    m_RContinueButtonUp=(X=7873029,Y=570687488,W=25,H=1974787)
    m_RContinueButtonDown=(X=11805189,Y=570687488,W=25,H=1974787)
    m_RContinueButtonDisabled=(X=13771269,Y=570687488,W=25,H=1974787)
    m_RContinueButtonOver=(X=9839109,Y=570687488,W=25,H=1974787)
}
/*
    m_TMainMenuButton=Texture'R6MenuTextures.Gui_01'
    m_TOptionsButton=Texture'R6MenuTextures.Gui_01'
    m_TActionButton=Texture'R6MenuTextures.Gui_01'
    m_TPlanningButton=Texture'R6MenuTextures.Gui_01'
    m_TContinueButton=Texture'R6MenuTextures.Gui_01'
*/

