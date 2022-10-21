//================================================================================
// R6MenuQuit.
//================================================================================
class R6MenuQuit extends R6MenuWidget;

var R6WindowButton m_ButtonMainMenu;
var R6WindowButton m_ButtonQuit;
var R6MenuVideo m_QuitVideo;

function Created ()
{
	local Font ButtonFont;

	ButtonFont=Root.Fonts[16];
	m_ButtonMainMenu=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,425.00,250.00,25.00,self));
	m_ButtonMainMenu.ToolTipString=Localize("Tip","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.Text=Localize("SinglePlayer","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.align=ta_left;
	m_ButtonMainMenu.m_buttonFont=ButtonFont;
	m_ButtonMainMenu.ResizeToText();
	if ( Root.Console.m_bStartedByGSClient || Root.Console.m_bNonUbiMatchMakingHost )
	{
		m_ButtonMainMenu.bDisabled=True;
	}
	m_ButtonQuit=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,450.00,250.00,25.00,self));
	m_ButtonQuit.ToolTipString=Localize("MainMenu","ButtonQuit","R6Menu");
	m_ButtonQuit.Text=Localize("MainMenu","ButtonQuit","R6Menu");
	m_ButtonQuit.align=ta_left;
	m_ButtonQuit.m_buttonFont=ButtonFont;
	m_ButtonQuit.ResizeToText();
}

function HideWindow ()
{
	Super.HideWindow();
}

function ShowWindow ()
{
	Super.ShowWindow();
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		switch (C)
		{
			case m_ButtonMainMenu:
//			Root.ChangeCurrentWidget(7);
			break;
			case m_ButtonQuit:
			Root.DoQuitGame();
			break;
			default:
		}
	}
}
