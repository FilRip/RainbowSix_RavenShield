Class ProhibitionMenuMainWidget extends R6MenuMainWidget;

var float m_fButtonXpos;
var float m_fButtonWidth;
var float m_fButtonHeight;
var float m_fFirstButtonYpos;
var float m_fButtonOffset;

var R6WindowButtonMainMenu m_ButtonCustomMission;
var R6WindowButtonMainMenu m_ButtonMultiPlayer;
var R6WindowButtonMainMenu m_ButtonOption;
var R6WindowButtonMainMenu m_ButtonCredits;
var R6WindowButtonMainMenu m_ButtonQuit;
var R6WindowTextLabel m_Version;

function Created()
{
	m_ButtonCustomMission=R6WindowButtonMainMenu(CreateWindow(Class'R6WindowButtonMainMenu',m_fButtonXpos,m_fFirstButtonYpos,m_fButtonWidth,m_fButtonHeight,self));
	m_ButtonCustomMission.ToolTipString=Localize("MainMenu","ButtonCustomMission","R6Menu");
	m_ButtonCustomMission.Text=Localize("MainMenu","ButtonSinglePlayer","Prohibition");
	m_ButtonCustomMission.m_eButton_Action=Button_CustomMission;
	m_ButtonCustomMission.Align=TA_Center;
	m_ButtonCustomMission.m_buttonFont=Root.Fonts[14];
	m_ButtonCustomMission.ResizeToText();
	m_ButtonCustomMission.bDisabled=True;
	m_ButtonMultiPlayer=R6WindowButtonMainMenu(CreateWindow(Class'R6WindowButtonMainMenu',m_fButtonXpos,m_ButtonCustomMission.WinTop + m_fButtonOffset,m_fButtonWidth,m_fButtonHeight,self));
	m_ButtonMultiPlayer.ToolTipString=Localize("MainMenu","ButtonMultiPlayer","R6Menu");
	m_ButtonMultiPlayer.Text=Localize("MainMenu","ButtonMultiPlayer","R6Menu");
	m_ButtonMultiPlayer.m_eButton_Action=Button_Multiplayer;
	m_ButtonMultiPlayer.Align=TA_Center;
	m_ButtonMultiPlayer.m_buttonFont=Root.Fonts[14];
	m_ButtonMultiPlayer.ResizeToText();
	m_ButtonOption=R6WindowButtonMainMenu(CreateWindow(Class'R6WindowButtonMainMenu',m_fButtonXpos,m_ButtonMultiPlayer.WinTop + m_fButtonOffset,m_fButtonWidth,m_fButtonHeight,self));
	m_ButtonOption.ToolTipString=Localize("MainMenu","ButtonOptions","R6Menu");
	m_ButtonOption.Text=Localize("MainMenu","ButtonOptions","R6Menu");
	m_ButtonOption.m_eButton_Action=Button_Options;
	m_ButtonOption.Align=TA_Center;
	m_ButtonOption.m_buttonFont=Root.Fonts[14];
	m_ButtonOption.ResizeToText();
	m_ButtonCredits=R6WindowButtonMainMenu(CreateWindow(Class'R6WindowButtonMainMenu',m_fButtonXpos,m_ButtonOption.WinTop + m_fButtonOffset,m_fButtonWidth,m_fButtonHeight,self));
	m_ButtonCredits.ToolTipString=Localize("MainMenu","ButtonCredits","R6Menu");
	m_ButtonCredits.Text=Localize("MainMenu","ButtonCredits","R6Menu");
	m_ButtonCredits.m_eButton_Action=Button_Credits;
	m_ButtonCredits.Align=TA_Center;
	m_ButtonCredits.m_buttonFont=Root.Fonts[14];
	m_ButtonCredits.ResizeToText();
	m_ButtonQuit=R6WindowButtonMainMenu(CreateWindow(Class'R6WindowButtonMainMenu',m_fButtonXpos,m_ButtonCredits.WinTop + m_fButtonOffset,m_fButtonWidth,m_fButtonHeight,self));
	m_ButtonQuit.ToolTipString=Localize("MainMenu","ButtonQuit","R6Menu");
	m_ButtonQuit.Text=Localize("MainMenu","ButtonQuit","R6Menu");
	m_ButtonQuit.m_eButton_Action=Button_Quit;
	m_ButtonQuit.Align=TA_Center;
	m_ButtonQuit.m_buttonFont=Root.Fonts[14];
	m_ButtonQuit.ResizeToText();
	m_Version=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',421.00,WinHeight - 18,200.00,15.00,self));
	m_Version.SetProperties("IR 1",TA_Center,Root.Fonts[10],Root.Colors.White,False);
}

function Paint (Canvas C, float X, float Y)
{
	Root.PaintBackground(C,self);
}

function ShowWindow ()
{
	Root.SetLoadRandomBackgroundImage("");
	Super.ShowWindow();
}

defaultproperties
{
    m_fButtonXpos=200.00
    m_fButtonWidth=250.00
    m_fButtonHeight=35.00
    m_fFirstButtonYpos=190.00
    m_fButtonOffset=35.00
}
