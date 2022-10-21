//================================================================================
// R6MenuInGameEscSinglePlayerNavBar.
//================================================================================
class R6MenuInGameEscSinglePlayerNavBar extends UWindowDialogClientWindow;

var bool m_bInTraining;
var float m_fHelpTextHeight;
var float m_fButtonsYPos;
var float m_fExitXPos;
var float m_fMainMenuXPos;
var float m_fOptionsXPos;
var float m_fAbortXPos;
var float m_fContinueXPos;
var R6MenuMPInGameHelpBar m_HelpTextBar;
var R6WindowButton m_ExitButton;
var R6WindowButton m_MainMenuButton;
var R6WindowButton m_OptionsButton;
var R6WindowButton m_AbortButton;
var R6WindowButton m_ContinueButton;
var Texture m_TExitButton;
var Texture m_TMainMenuButton;
var Texture m_TOptionsButton;
var Texture m_TAbortButton;
var Texture m_TContinueButton;
var Texture m_TRetryTrainingButton;
var Region m_RExitButtonUp;
var Region m_RExitButtonDown;
var Region m_RExitButtonDisabled;
var Region m_RExitButtonOver;
var Region m_RMainMenuButtonUp;
var Region m_RMainMenuButtonDown;
var Region m_RMainMenuButtonDisabled;
var Region m_RMainMenuButtonOver;
var Region m_ROptionsButtonUp;
var Region m_ROptionsButtonDown;
var Region m_ROptionsButtonDisabled;
var Region m_ROptionsButtonOver;
var Region m_RAbortButtonUp;
var Region m_RAbortButtonDown;
var Region m_RAbortButtonDisabled;
var Region m_RAbortButtonOver;
var Region m_RContinueButtonUp;
var Region m_RContinueButtonDown;
var Region m_RContinueButtonDisabled;
var Region m_RContinueButtonOver;
var Region m_RRetryTrainingButtonUp;
var Region m_RRetryTrainingButtonDown;
var Region m_RRetryTrainingButtonDisabled;
var Region m_RRetryTrainingButtonOver;

function Created ()
{
//	m_HelpTextBar=R6MenuMPInGameHelpBar(CreateWindow(Class'R6MenuMPInGameHelpBar',1.00,0.00,WinWidth - 2,m_fHelpTextHeight,self));
	m_HelpTextBar.m_szDefaultText=Localize("ESCMENUS","ESCRESUME","R6Menu");
	m_ExitButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fExitXPos,m_fButtonsYPos,m_RExitButtonUp.W,m_RExitButtonUp.H,self));
	m_ExitButton.UpTexture=m_TExitButton;
	m_ExitButton.OverTexture=m_TExitButton;
	m_ExitButton.DownTexture=m_TExitButton;
	m_ExitButton.DisabledTexture=m_TExitButton;
	m_ExitButton.UpRegion=m_RExitButtonUp;
	m_ExitButton.OverRegion=m_RExitButtonOver;
	m_ExitButton.DownRegion=m_RExitButtonDown;
	m_ExitButton.DisabledRegion=m_RExitButtonDisabled;
	m_ExitButton.bUseRegion=True;
	m_ExitButton.ToolTipString=Localize("ESCMENUS","QUIT","R6Menu");
	m_ExitButton.m_iDrawStyle=5;
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
	m_MainMenuButton.m_iDrawStyle=5;
	m_OptionsButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fOptionsXPos,m_fButtonsYPos,m_ROptionsButtonUp.W,m_ROptionsButtonUp.H,self));
	m_OptionsButton.UpTexture=m_TOptionsButton;
	m_OptionsButton.OverTexture=m_TOptionsButton;
	m_OptionsButton.DownTexture=m_TOptionsButton;
	m_OptionsButton.DisabledTexture=m_TOptionsButton;
	m_OptionsButton.UpRegion=m_ROptionsButtonUp;
	m_OptionsButton.OverRegion=m_ROptionsButtonOver;
	m_OptionsButton.DownRegion=m_ROptionsButtonDown;
	m_OptionsButton.DisabledRegion=m_ROptionsButtonDisabled;
	m_OptionsButton.bUseRegion=True;
	m_OptionsButton.ToolTipString=Localize("ESCMENUS","ESCOPTIONS","R6Menu");
	m_OptionsButton.m_iDrawStyle=5;
	m_AbortButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_fAbortXPos,m_fButtonsYPos,m_RAbortButtonUp.W,m_RAbortButtonUp.H,self));
	m_AbortButton.UpTexture=m_TAbortButton;
	m_AbortButton.OverTexture=m_TAbortButton;
	m_AbortButton.DownTexture=m_TAbortButton;
	m_AbortButton.DisabledTexture=m_TAbortButton;
	m_AbortButton.UpRegion=m_RAbortButtonUp;
	m_AbortButton.OverRegion=m_RAbortButtonOver;
	m_AbortButton.DownRegion=m_RAbortButtonDown;
	m_AbortButton.DisabledRegion=m_RAbortButtonDisabled;
	m_AbortButton.bUseRegion=True;
	m_AbortButton.ToolTipString=Localize("ESCMENUS","ESCABORT_ACTION","R6Menu");
	m_AbortButton.m_iDrawStyle=5;
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
	m_ContinueButton.ToolTipString=Localize("ESCMENUS","ESCABORT_PLANNING","R6Menu");
	m_ContinueButton.m_iDrawStyle=5;
}

function SetTrainingNavbar ()
{
	m_bInTraining=True;
	m_ContinueButton.UpTexture=m_TRetryTrainingButton;
	m_ContinueButton.OverTexture=m_TRetryTrainingButton;
	m_ContinueButton.DownTexture=m_TRetryTrainingButton;
	m_ContinueButton.DisabledTexture=m_TRetryTrainingButton;
	m_ContinueButton.UpRegion=m_RRetryTrainingButtonUp;
	m_ContinueButton.OverRegion=m_RRetryTrainingButtonOver;
	m_ContinueButton.DownRegion=m_RRetryTrainingButtonDown;
	m_ContinueButton.DisabledRegion=m_RRetryTrainingButtonDisabled;
	m_ContinueButton.ToolTipString=Localize("ESCMENUS","ESCQUIT_TRAINING","R6Menu");
	m_ContinueButton.SetSize(m_RRetryTrainingButtonUp.W,m_RRetryTrainingButtonUp.H);
	m_AbortButton.ToolTipString=Localize("ESCMENUS","ESCABORT_TRAINING","R6Menu");
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		switch (C)
		{
/*			case m_ExitButton:
			R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","PopUpTitle_QUIT","R6Menu"),Localize("ESCMENUS","QuitConfirm","R6Menu"),46);
			break;
			case m_MainMenuButton:
			R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","PopUpTitle_QuitToMain","R6Menu"),Localize("ESCMENUS","MAINCONFIRM","R6Menu"),45);
			break;
			case m_OptionsButton:
//			Root.ChangeCurrentWidget(16);
			break;
			case m_AbortButton:
			if ( m_bInTraining )
			{
				R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","PopUpTitle_ESCABORT_TRAINING","R6Menu"),Localize("ESCMENUS","ABORTCONFIRM_TRAINING","R6Menu"),47);
			}
			else
			{
				R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","PopUpTitle_ESCABORT_ACTION","R6Menu"),Localize("ESCMENUS","ABORTCONFIRM_ACTION","R6Menu"),47);
			}
			break;
			case m_ContinueButton:
			if ( m_bInTraining )
			{
				R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","PopUpTitle_ESCQUIT_TRAINING","R6Menu"),Localize("ESCMENUS","QUITCONFIRM_TRAINING","R6Menu"),49);
			}
			else
			{
				R6MenuInGameRootWindow(Root).SimplePopUp(Localize("POPUP","PopUpTitle_ESCABORT_PLANNING","R6Menu"),Localize("ESCMENUS","ABORTCONFIRM_PLAN","R6Menu"),48);
			}
			break;
			default:  */
		}
	}
}

defaultproperties
{
    m_fHelpTextHeight=20.00
    m_fButtonsYPos=22.00
    m_fExitXPos=32.00
    m_fMainMenuXPos=110.00
    m_fOptionsXPos=194.00
    m_fAbortXPos=267.00
    m_fContinueXPos=346.00
    m_RExitButtonUp=(X=4923910,Y=570687488,W=35,H=1974787)
    m_RExitButtonDown=(X=4923910,Y=570753024,W=60,H=2302468)
    m_RExitButtonDisabled=(X=4923910,Y=570753024,W=90,H=2302468)
    m_RExitButtonOver=(X=4923910,Y=570753024,W=30,H=2302468)
    m_RMainMenuButtonUp=(X=7283206,Y=570687488,W=36,H=1974787)
    m_RMainMenuButtonDown=(X=7283206,Y=570753024,W=60,H=2368004)
    m_RMainMenuButtonDisabled=(X=7283206,Y=570753024,W=90,H=2368004)
    m_RMainMenuButtonOver=(X=7283206,Y=570753024,W=30,H=2368004)
    m_ROptionsButtonUp=(X=9708038,Y=570687488,W=30,H=1974787)
    m_ROptionsButtonDown=(X=9708038,Y=570753024,W=60,H=1974788)
    m_ROptionsButtonDisabled=(X=9708038,Y=570753024,W=90,H=1974788)
    m_ROptionsButtonOver=(X=9708038,Y=570753024,W=30,H=1974788)
    m_RAbortButtonUp=(X=6103558,Y=570687488,W=32,H=1974787)
    m_RAbortButtonDown=(X=6103558,Y=570753024,W=60,H=2105860)
    m_RAbortButtonDisabled=(X=6103558,Y=570753024,W=90,H=2105860)
    m_RAbortButtonOver=(X=6103558,Y=570753024,W=30,H=2105860)
    m_RContinueButtonUp=(X=8200710,Y=570687488,W=30,H=1974787)
    m_RContinueButtonDown=(X=8200710,Y=570753024,W=60,H=1974788)
    m_RContinueButtonDisabled=(X=8200710,Y=570753024,W=90,H=1974788)
    m_RContinueButtonOver=(X=8200710,Y=570753024,W=30,H=1974788)
    m_RRetryTrainingButtonUp=(X=7873029,Y=570687488,W=33,H=1974787)
    m_RRetryTrainingButtonDown=(X=11805189,Y=570687488,W=33,H=1974787)
    m_RRetryTrainingButtonDisabled=(X=13771269,Y=570687488,W=33,H=1974787)
    m_RRetryTrainingButtonOver=(X=9839109,Y=570687488,W=33,H=1974787)
}
/*
    m_TExitButton=Texture'R6MenuTextures.Gui_02'
    m_TMainMenuButton=Texture'R6MenuTextures.Gui_02'
    m_TOptionsButton=Texture'R6MenuTextures.Gui_02'
    m_TAbortButton=Texture'R6MenuTextures.Gui_01'
    m_TContinueButton=Texture'R6MenuTextures.Gui_01'
    m_TRetryTrainingButton=Texture'R6MenuTextures.Gui_02'
*/

