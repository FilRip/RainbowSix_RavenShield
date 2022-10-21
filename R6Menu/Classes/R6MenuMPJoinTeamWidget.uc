//================================================================================
// R6MenuMPJoinTeamWidget.
//================================================================================
class R6MenuMPJoinTeamWidget extends R6MenuWidget;

enum ER6GameType {
	RGM_AllMode,
	RGM_StoryMode,
	RGM_PracticeMode,
	RGM_MissionMode,
	RGM_TerroristHuntMode,
	RGM_TerroristHuntCoopMode,
	RGM_HostageRescueMode,
	RGM_HostageRescueCoopMode,
	RGM_HostageRescueAdvMode,
	RGM_DefendMode,
	RGM_DefendCoopMode,
	RGM_ReconMode,
	RGM_ReconCoopMode,
	RGM_DeathmatchMode,
	RGM_TeamDeathmatchMode,
	RGM_BombAdvMode,
	RGM_EscortAdvMode,
	RGM_LoneWolfMode,
	RGM_SquadDeathmatch,
	RGM_SquadTeamDeathmatch,
	RGM_TerroristHuntAdvMode,
	RGM_ScatteredHuntAdvMode,
	RGM_CaptureTheEnemyAdvMode,
	RGM_CountDownMode,
	RGM_KamikazeMode,
	RGM_NoRulesMode
};

var int m_iYBetweenButtonPadding;
var int m_iButtonHeight;
var int m_iButtonWidth;
var int m_iSingleCharXPos;
var int m_iSingleCharYPos;
var int m_iLeftCharXPos;
var int m_iLeftCharYPos;
var int m_iRightCharXPos;
var int m_iRightCharYPos;
var int m_iBetweenCharXPos;
var int m_iBetweenCharYPos;
var bool m_bIsTeamGame;
var float m_fTimeForRefresh;
var float m_fTimeAutoTeam;
var R6WindowButtonMPInGame m_pButAlphaTeam;
var R6WindowButtonMPInGame m_pButBravoTeam;
var R6WindowButtonMPInGame m_pButAutoTeam;
var R6WindowButtonMPInGame m_pButSpectator;
var R6WindowButtonMPInGame m_pButCurrentSelected;
var R6WindowTextLabelExt m_pInfoText;
var R6MenuHelpWindow m_pHelpTextWindow;
var R6WindowBitMap m_SingleChar;
var R6WindowBitMap m_LeftChar;
var R6WindowBitMap m_RightChar;
var R6WindowBitMap m_BetweenCharIcon;
var Texture m_TBetweenChar;
var Texture m_TSpectatorChar;
var Texture m_TAlphaChar;
var Texture m_TBetaChar;
var array<Class> m_AArmorDescriptions;
var Region m_pHelpReg;
var Region m_RBetweenChar;
var Region m_RSpectatorChar;
var Region m_RAlphaChar;
var Region m_RBetaChar;
var string m_szMenuGreenTeamPawnClass;
var string m_szMenuRedTeamPawnClass;
const C_iMIN_TIME_FOR_WELCOME_SCREEN= 10;

function Created ()
{
	FillDescriptionArray();
	CreateTextLabels();
	CreateButtons();
	CreateBitmaps();
	m_pHelpTextWindow=R6MenuHelpWindow(CreateWindow(Class'R6MenuHelpWindow',m_pHelpReg.X,m_pHelpReg.Y,m_pHelpReg.W,m_pHelpReg.H,self));
}

function FillDescriptionArray ()
{
	local Class<R6ArmorDescription> DescriptionClass;
	local int i;
	local R6Mod pCurrentMod;

	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	i=0;
JL0022:
	if ( i < pCurrentMod.m_aDescriptionPackage.Length )
	{
		DescriptionClass=Class<R6ArmorDescription>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[i] $ ".u",Class'R6ArmorDescription'));
JL0068:
		if ( DescriptionClass != None )
		{
			m_AArmorDescriptions[m_AArmorDescriptions.Length]=DescriptionClass;
			DescriptionClass=Class<R6ArmorDescription>(GetNextClass());
			goto JL0068;
		}
		FreePackageObjects();
		i++;
		goto JL0022;
	}
}

function Tick (float DeltaTime)
{
	local string szAutoSelection;

	if ( (m_szMenuGreenTeamPawnClass != GetLevel().GreenTeamPawnClass) || (m_szMenuRedTeamPawnClass != GetLevel().RedTeamPawnClass) && m_bIsTeamGame )
	{
		RefreshBitmaps();
	}
	if ( m_bIsTeamGame )
	{
		if ( m_fTimeForRefresh >= 4.00 )
		{
			RefreshButtonsStatus();
			m_fTimeForRefresh=0.00;
		}
		else
		{
			m_fTimeForRefresh += DeltaTime;
		}
	}
	if ( m_fTimeAutoTeam > 10 )
	{
		szAutoSelection=Class'Actor'.static.GetGameOptions().MPAutoSelection;
		if ( szAutoSelection ~= "GREEN" )
		{
			m_pButAlphaTeam.Click(0.00,0.00);
			Class'Actor'.static.GetGameOptions().SaveConfig();
		}
		else
		{
			if ( szAutoSelection ~= "SPECTATOR" )
			{
				m_pButSpectator.Click(0.00,0.00);
				Class'Actor'.static.GetGameOptions().SaveConfig();
			}
			else
			{
				if ( m_bIsTeamGame )
				{
					if ( szAutoSelection ~= "RED" )
					{
						m_pButBravoTeam.Click(0.00,0.00);
						Class'Actor'.static.GetGameOptions().SaveConfig();
					}
					else
					{
						if ( szAutoSelection ~= "AUTOTEAM" )
						{
							m_pButAutoTeam.Click(0.00,0.00);
							Class'Actor'.static.GetGameOptions().SaveConfig();
						}
					}
				}
			}
		}
		m_fTimeAutoTeam=0.00;
	}
	else
	{
		m_fTimeAutoTeam += DeltaTime;
	}
}

function SetMenuToDisplay (ER6GameType _eCurrentGameType)
{
//	m_bIsTeamGame=GetLevel().IsGameTypeTeamAdversarial(_eCurrentGameType);
	RefreshServerInfo();
	RefreshButtons(_eCurrentGameType);
	RefreshBitmaps();
	if ( m_bIsTeamGame )
	{
		RefreshButtonsStatus();
	}
	m_fTimeAutoTeam=0.00;
}

function RefreshServerInfo ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if ( r6Root.m_R6GameMenuCom.m_GameRepInfo != None )
	{
		m_pInfoText.ChangeTextLabel(Localize("MPInGame","ServerName","R6Menu") $ " " $ r6Root.m_R6GameMenuCom.m_GameRepInfo.ServerName,0);
		m_pInfoText.ChangeTextLabel(Localize("MPInGame","GameVersion","R6Menu") $ " " $ Class'Actor'.static.GetGameVersion(True),1);
		m_pInfoText.ChangeTextLabel(r6Root.m_R6GameMenuCom.m_GameRepInfo.MOTDLine1,3);
	}
}

function CreateButtons ()
{
	local Font ButtonFont;
	local float fXOffset;
	local float fYOffset;

	fXOffset=R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RJoinWidget.X + 100;
	fYOffset=R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RJoinWidget.Y + 100;
	ButtonFont=Root.Fonts[16];
	m_pButAlphaTeam=R6WindowButtonMPInGame(CreateControl(Class'R6WindowButtonMPInGame',fXOffset,fYOffset,m_iButtonWidth,m_iButtonHeight,self));
	m_pButAlphaTeam.Text=Localize("MPInGame","AlphaTeam","R6Menu");
//	m_pButAlphaTeam.m_eButInGame_Action=0;
	m_pButAlphaTeam.align=ta_left;
	m_pButAlphaTeam.m_fFontSpacing=2.00;
	m_pButAlphaTeam.m_buttonFont=ButtonFont;
	m_pButAlphaTeam.ResizeToText();
	fYOffset += m_iButtonHeight + m_iYBetweenButtonPadding;
	m_pButBravoTeam=R6WindowButtonMPInGame(CreateControl(Class'R6WindowButtonMPInGame',fXOffset,fYOffset,m_iButtonWidth,m_iButtonHeight,self));
	m_pButBravoTeam.Text=Localize("MPInGame","BravoTeam","R6Menu");
//	m_pButBravoTeam.m_eButInGame_Action=1;
	m_pButBravoTeam.align=ta_left;
	m_pButBravoTeam.m_fFontSpacing=2.00;
	m_pButBravoTeam.m_buttonFont=ButtonFont;
	m_pButBravoTeam.ResizeToText();
	fYOffset += m_iButtonHeight + m_iYBetweenButtonPadding;
	m_pButAutoTeam=R6WindowButtonMPInGame(CreateControl(Class'R6WindowButtonMPInGame',fXOffset,fYOffset,m_iButtonWidth,m_iButtonHeight,self));
	m_pButAutoTeam.ToolTipString=Localize("Tip","AutoTeam","R6Menu");
	m_pButAutoTeam.Text=Localize("MPInGame","AutoTeam","R6Menu");
//	m_pButAutoTeam.m_eButInGame_Action=2;
	m_pButAutoTeam.align=ta_left;
	m_pButAutoTeam.m_fFontSpacing=2.00;
	m_pButAutoTeam.m_buttonFont=ButtonFont;
	m_pButAutoTeam.ResizeToText();
	fYOffset += m_iButtonHeight + m_iYBetweenButtonPadding;
	m_pButSpectator=R6WindowButtonMPInGame(CreateControl(Class'R6WindowButtonMPInGame',fXOffset,fYOffset,m_iButtonWidth,m_iButtonHeight,self));
	m_pButSpectator.ToolTipString=Localize("Tip","Spectator","R6Menu");
	m_pButSpectator.Text=Localize("MPInGame","Spectator","R6Menu");
//	m_pButSpectator.m_eButInGame_Action=3;
	m_pButSpectator.align=ta_left;
	m_pButSpectator.m_fFontSpacing=2.00;
	m_pButSpectator.m_buttonFont=ButtonFont;
	m_pButSpectator.ResizeToText();
}

function RefreshButtons (ER6GameType _eCurrentGameType)
{
	local float fSpectatorYPos;

	if (  !m_bIsTeamGame )
	{
//		m_pButAlphaTeam.ToolTipString=GetLevel().GetGreenTeamObjective(_eCurrentGameType);
		m_pButAlphaTeam.Text=Localize("MPInGame","Play","R6Menu");
//		m_pButAlphaTeam.m_eButInGame_Action=4;
		m_pButAlphaTeam.ResizeToText();
		m_pButBravoTeam.HideWindow();
		m_pButAutoTeam.HideWindow();
		fSpectatorYPos=m_pButAlphaTeam.WinTop + m_pButAlphaTeam.WinHeight + m_iYBetweenButtonPadding;
	}
	else
	{
//		m_pButAlphaTeam.ToolTipString=GetLevel().GetGreenTeamObjective(_eCurrentGameType);
		m_pButAlphaTeam.Text=Localize("MPInGame","AlphaTeam","R6Menu");
//		m_pButAlphaTeam.m_eButInGame_Action=0;
		m_pButAlphaTeam.ResizeToText();
		m_pButBravoTeam.ShowWindow();
//		m_pButBravoTeam.ToolTipString=GetLevel().GetRedTeamObjective(_eCurrentGameType);
		m_pButAutoTeam.ShowWindow();
		fSpectatorYPos=m_pButAutoTeam.WinTop + m_pButAutoTeam.WinHeight + m_iYBetweenButtonPadding;
	}
	m_pButSpectator.WinTop=fSpectatorYPos;
}

function RefreshButtonsStatus ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	m_pButAlphaTeam.bDisabled=False;
	m_pButBravoTeam.bDisabled=False;
	if ( r6Root.m_R6GameMenuCom.GetNbOfTeamPlayer(True) >= 8 )
	{
		m_pButAlphaTeam.bDisabled=True;
	}
	if ( r6Root.m_R6GameMenuCom.GetNbOfTeamPlayer(False) >= 8 )
	{
		m_pButBravoTeam.bDisabled=True;
	}
}

function CreateTextLabels ()
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local float fTemp;
	local float fSizeOfCounter;

	fXOffset=R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RJoinWidget.X;
	fYOffset=R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RJoinWidget.Y;
	fWidth=R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RJoinWidget.W;
	fHeight=R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RJoinWidget.H;
	m_pInfoText=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pInfoText.bAlwaysBehind=True;
	m_pInfoText.SetNoBorder();
	m_pInfoText.m_Font=Root.Fonts[6];
	m_pInfoText.m_vTextColor=Root.Colors.White;
	fXOffset=4.00;
	fYOffset=R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize() + 3;
	fWidth=fWidth * 0.50;
//	m_pInfoText.AddTextLabel(Localize("MPInGame","ServerName","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fXOffset=fWidth + 4;
	fYOffset=R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize() + 3;
//	m_pInfoText.AddTextLabel(Localize("MPInGame","GameVersion","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fXOffset=4.00;
	fYOffset=fHeight - 40;
	fWidth=fWidth;
	m_pInfoText.m_Font=Root.Fonts[5];
//	m_pInfoText.AddTextLabel(Localize("MPInGame","PleaseNote","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	m_pInfoText.m_Font=Root.Fonts[6];
	fXOffset=4.00;
	fYOffset=fHeight - 20;
	fWidth=fWidth;
//	m_pInfoText.AddTextLabel("",fXOffset,fYOffset,fWidth,0,False);
}

function CreateBitmaps ()
{
	m_SingleChar=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_iSingleCharXPos,m_iSingleCharYPos,m_RSpectatorChar.W,m_RSpectatorChar.H,self));
	m_SingleChar.m_iDrawStyle=5;
	m_SingleChar.HideWindow();
	m_LeftChar=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_iLeftCharXPos,m_iLeftCharYPos,m_RSpectatorChar.W,m_RSpectatorChar.H,self));
	m_LeftChar.m_iDrawStyle=5;
	m_LeftChar.HideWindow();
	m_LeftChar.m_bHorizontalFlip=True;
	m_RightChar=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_iRightCharXPos,m_iRightCharYPos,m_RSpectatorChar.W,m_RSpectatorChar.H,self));
	m_RightChar.m_iDrawStyle=5;
	m_RightChar.HideWindow();
	m_BetweenCharIcon=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_iBetweenCharXPos,m_iBetweenCharYPos,m_RBetweenChar.W,m_RBetweenChar.H,self));
	m_BetweenCharIcon.m_iDrawStyle=5;
	m_BetweenCharIcon.HideWindow();
	m_BetweenCharIcon.t=m_TBetweenChar;
	m_BetweenCharIcon.R=m_RBetweenChar;
}

function RefreshBitmaps ()
{
	local int i;
	local int AlphaId;
	local int BetaId;
	local bool bAplhaTeamFound;
	local bool bBetaTeamFound;
	local Class<R6ArmorDescription> DescriptionClass;

	i=0;
	bAplhaTeamFound=False;
	bBetaTeamFound=False;
	AlphaId=-1;
	BetaId=-1;
JL002D:
	if ( (i < m_AArmorDescriptions.Length) &&  !bAplhaTeamFound && bBetaTeamFound )
	{
		DescriptionClass=Class<R6ArmorDescription>(m_AArmorDescriptions[i]);
		if ( DescriptionClass.Default.m_ClassName == GetLevel().GreenTeamPawnClass )
		{
			m_szMenuGreenTeamPawnClass=GetLevel().GreenTeamPawnClass;
			bAplhaTeamFound=True;
			m_TAlphaChar=DescriptionClass.Default.m_2DMenuTexture;
			m_RAlphaChar=DescriptionClass.Default.m_2dMenuRegion;
			AlphaId=i;
		}
		if ( DescriptionClass.Default.m_ClassName == GetLevel().RedTeamPawnClass )
		{
			m_szMenuRedTeamPawnClass=GetLevel().RedTeamPawnClass;
			bBetaTeamFound=True;
			m_TBetaChar=DescriptionClass.Default.m_2DMenuTexture;
			m_RBetaChar=DescriptionClass.Default.m_2dMenuRegion;
			BetaId=i;
		}
		i++;
		goto JL002D;
	}
	if (  !bAplhaTeamFound )
	{
		if ( BetaId != 0 )
		{
			DescriptionClass=Class<R6ArmorDescription>(m_AArmorDescriptions[0]);
			AlphaId=0;
		}
		else
		{
			DescriptionClass=Class<R6ArmorDescription>(m_AArmorDescriptions[1]);
			AlphaId=1;
		}
		m_TAlphaChar=DescriptionClass.Default.m_2DMenuTexture;
		m_RAlphaChar=DescriptionClass.Default.m_2dMenuRegion;
	}
	if (  !bBetaTeamFound )
	{
		if ( AlphaId != 0 )
		{
			DescriptionClass=Class<R6ArmorDescription>(m_AArmorDescriptions[0]);
			BetaId=0;
		}
		else
		{
			DescriptionClass=Class<R6ArmorDescription>(m_AArmorDescriptions[1]);
			BetaId=1;
		}
		m_TBetaChar=DescriptionClass.Default.m_2DMenuTexture;
		m_RBetaChar=DescriptionClass.Default.m_2dMenuRegion;
	}
	m_LeftChar.t=m_TAlphaChar;
	m_LeftChar.R=m_RAlphaChar;
	m_RightChar.t=m_TBetaChar;
	m_RightChar.R=m_RBetaChar;
	m_SingleChar.HideWindow();
	m_LeftChar.HideWindow();
	m_RightChar.HideWindow();
	m_BetweenCharIcon.HideWindow();
	if ( m_pButCurrentSelected != None )
	{
		Notify(m_pButCurrentSelected,12);
	}
}

function ToolTip (string strTip)
{
	m_pHelpTextWindow.ToolTip(strTip);
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 12 )
	{
		if ( R6WindowButtonMPInGame(C).bDisabled )
		{
			return;
		}
		switch (C)
		{
			case m_pButAlphaTeam:
			m_SingleChar.ShowWindow();
			m_SingleChar.t=m_TAlphaChar;
			m_SingleChar.R=m_RAlphaChar;
			m_pButCurrentSelected=m_pButAlphaTeam;
			break;
			case m_pButBravoTeam:
			m_SingleChar.ShowWindow();
			m_SingleChar.t=m_TBetaChar;
			m_SingleChar.R=m_RBetaChar;
			m_pButCurrentSelected=m_pButBravoTeam;
			break;
			case m_pButAutoTeam:
			m_LeftChar.ShowWindow();
			m_RightChar.ShowWindow();
			m_BetweenCharIcon.ShowWindow();
			m_pButCurrentSelected=m_pButAutoTeam;
			break;
			case m_pButSpectator:
			m_SingleChar.ShowWindow();
			m_SingleChar.t=m_TSpectatorChar;
			m_SingleChar.R=m_RSpectatorChar;
			m_pButCurrentSelected=m_pButSpectator;
			break;
			default:
		}
	}
	else
	{
		if ( E == 9 )
		{
			if ( R6WindowButtonMPInGame(C).bDisabled )
			{
				return;
			}
			switch (C)
			{
				case m_pButAlphaTeam:
				case m_pButBravoTeam:
				case m_pButSpectator:
				m_SingleChar.HideWindow();
				m_pButCurrentSelected=None;
				break;
				case m_pButAutoTeam:
				m_LeftChar.HideWindow();
				m_RightChar.HideWindow();
				m_BetweenCharIcon.HideWindow();
				m_pButCurrentSelected=None;
				break;
				default:
			}
		}
	}
}

function HideWindow ()
{
	Super.HideWindow();
	m_pButCurrentSelected=None;
}

defaultproperties
{
    m_iYBetweenButtonPadding=20
    m_iButtonHeight=25
    m_iButtonWidth=220
    m_iSingleCharXPos=420
    m_iSingleCharYPos=120
    m_iLeftCharXPos=340
    m_iLeftCharYPos=120
    m_iRightCharXPos=491
    m_iRightCharYPos=120
    m_iBetweenCharXPos=453
    m_iBetweenCharYPos=170
    m_pHelpReg=(X=2957830,Y=570753024,W=326,H=19603972)
    m_RBetweenChar=(X=12329478,Y=570753024,W=396,H=3809796)
    m_RSpectatorChar=(X=7348742,Y=570753024,W=145,H=8724996)
}
/*
    m_TBetweenChar=Texture'R6MenuTextures.Gui_BoxScroll'
    m_TSpectatorChar=Texture'R6MenuTextures.Gui_BoxScroll'
*/

