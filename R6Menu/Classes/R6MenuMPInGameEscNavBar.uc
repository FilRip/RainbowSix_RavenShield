//================================================================================
// R6MenuMPInGameEscNavBar.
//================================================================================
class R6MenuMPInGameEscNavBar extends R6MenuInGameEscSinglePlayerNavBar;

var Texture m_TMPContinueButton;
var Region m_RMPContinueButtonUp;
var Region m_RMPContinueButtonDown;
var Region m_RMPContinueButtonDisabled;
var Region m_RMPContinueButtonOver;
var Region m_RPopUp;

function Created ()
{
	Super.Created();
	m_HelpTextBar.m_szDefaultText="";
	m_AbortButton.ToolTipString=Localize("ESCMENUS","ESCABORTMP","R6Menu");
	m_ContinueButton.ToolTipString=Localize("ESCMENUS","ESCCONTINUE","R6Menu");
	m_ContinueButton.UpTexture=m_TMPContinueButton;
	m_ContinueButton.OverTexture=m_TMPContinueButton;
	m_ContinueButton.DownTexture=m_TMPContinueButton;
	m_ContinueButton.DisabledTexture=m_TMPContinueButton;
	m_ContinueButton.UpRegion=m_RMPContinueButtonUp;
	m_ContinueButton.OverRegion=m_RMPContinueButtonOver;
	m_ContinueButton.DownRegion=m_RMPContinueButtonDown;
	m_ContinueButton.DisabledRegion=m_RMPContinueButtonDisabled;
	if ( R6Console(Root.Console).m_bStartedByGSClient )
	{
		m_MainMenuButton.bDisabled=True;
	}
	else
	{
		if ( R6Console(Root.Console).m_bNonUbiMatchMakingHost || R6Console(Root.Console).m_bNonUbiMatchMaking )
		{
			m_MainMenuButton.bDisabled=True;
			m_AbortButton.bDisabled=True;
		}
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if ( E == 2 )
	{
		switch (C)
		{
/*			case m_ExitButton:
			R6MenuMPInGameEsc(OwnerWindow).m_bEscAvailable=False;
			r6Root.m_RSimplePopUp=m_RPopUp;
			r6Root.SimplePopUp(Localize("ESCMENUS","QuitConfirmTitle","R6Menu"),Localize("ESCMENUS","QuitConfirm","R6Menu"),46);
			break;
			case m_MainMenuButton:
			R6MenuMPInGameEsc(OwnerWindow).m_bEscAvailable=False;
			r6Root.m_RSimplePopUp=m_RPopUp;
			r6Root.SimplePopUp(Localize("ESCMENUS","DisconnectConfirmTitle","R6Menu"),Localize("ESCMENUS","DisconnectConfirm","R6Menu"),45);
			break;
			case m_OptionsButton:
//			r6Root.ChangeCurrentWidget(16);
			break;
			case m_AbortButton:
			R6MenuMPInGameEsc(OwnerWindow).m_bEscAvailable=False;
			r6Root.m_RSimplePopUp=m_RPopUp;
			r6Root.SimplePopUp(Localize("ESCMENUS","DisconnectConfirmTitle","R6Menu"),Localize("ESCMENUS","DisconnectConfirm","R6Menu"),29);
			break;
			case m_ContinueButton:
//			r6Root.ChangeCurrentWidget(0);
			break;
			default:  */
		}
	}
}

defaultproperties
{
    m_RMPContinueButtonUp=(X=13312518,Y=570753024,W=120,H=2236932)
    m_RMPContinueButtonDown=(X=13312518,Y=570753024,W=180,H=2236932)
    m_RMPContinueButtonDisabled=(X=13312518,Y=570753024,W=210,H=2236932)
    m_RMPContinueButtonOver=(X=13312518,Y=570753024,W=150,H=2236932)
    m_RPopUp=(X=9839110,Y=570753024,W=283,H=22290948)
    m_RAbortButtonUp=(X=13967878,Y=570687488,W=34,H=1974787)
    m_RAbortButtonDown=(X=13967878,Y=570753024,W=60,H=2236932)
    m_RAbortButtonDisabled=(X=13967878,Y=570753024,W=90,H=2236932)
    m_RAbortButtonOver=(X=13967878,Y=570753024,W=30,H=2236932)
}
/*
    m_TMPContinueButton=Texture'R6MenuTextures.Gui_01'
    m_TAbortButton=Texture'R6MenuTextures.Gui_02'
*/

