//================================================================================
// R6MenuMPInterWidget.
//================================================================================
class R6MenuMPInterWidget extends R6MenuWidget;

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

var ER6GameType m_eCurGameType;
var EPopUpID m_InGameOptionsChange;
var int m_Counter;
var bool m_bDisplayNavBar;
var bool m_bRefreshRestKit;
var bool m_bForceRefreshOfGear;
var bool m_bNavBarActive;
var float m_fYStartTeamBarPos;
var R6MenuMPInterHeader m_pMPInterHeader;
var R6MenuMPTeamBar m_pR6AlphaTeam;
var R6MenuMPTeamBar m_pR6BravoTeam;
var R6MenuMPTeamBar m_pR6MissionObj;
var R6MenuMPInGameNavBar m_pInGameNavBar;
var R6WindowPopUpBox m_pPopUpBoxCurrent;
var R6WindowPopUpBox m_pPopUpGearRoom;
var R6WindowPopUpBox m_pPopUpServerOption;
var R6WindowPopUpBox m_pPopUpKitRest;

function Created ()
{
	m_fYStartTeamBarPos=R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RInterWidget.Y + R6MenuRSLookAndFeel(LookAndFeel).GetTextHeaderSize();
	m_pMPInterHeader=R6MenuMPInterHeader(CreateWindow(Class'R6MenuMPInterHeader',R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RInterWidget.X,m_fYStartTeamBarPos,R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RInterWidget.W,66.00,self));
	m_fYStartTeamBarPos += m_pMPInterHeader.WinHeight;
	m_pR6AlphaTeam=R6MenuMPTeamBar(CreateWindow(Class'R6MenuMPTeamBar',0.00,0.00,10.00,10.00,self));
	m_pR6AlphaTeam.m_vTeamColor=Root.Colors.TeamColorLight[1];
	m_pR6AlphaTeam.m_szTeamName=Localize("MPInGame","AlphaTeam","R6Menu");
	m_pR6BravoTeam=R6MenuMPTeamBar(CreateWindow(Class'R6MenuMPTeamBar',0.00,0.00,10.00,10.00,self));
	m_pR6BravoTeam.m_vTeamColor=Root.Colors.TeamColorLight[0];
	m_pR6BravoTeam.m_szTeamName=Localize("MPInGame","BravoTeam","R6Menu");
	m_pR6MissionObj=R6MenuMPTeamBar(CreateWindow(Class'R6MenuMPTeamBar',0.00,0.00,10.00,10.00,self));
	m_pR6MissionObj.m_bDisplayObj=True;
	m_pInGameNavBar=R6MenuMPInGameNavBar(CreateWindow(Class'R6MenuMPInGameNavBar',R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RInterWidget.X,0.00,R6MenuInGameMultiPlayerRootWindow(OwnerWindow).m_RInterWidget.W,m_pMPInterHeader.WinHeight));
	m_Counter=0;
	m_pR6AlphaTeam.InitTeamBar();
	m_pR6BravoTeam.InitTeamBar();
	m_pR6MissionObj.InitMissionWindows();
}

function Tick (float Delta)
{
	m_Counter++;
	if ( m_bForceRefreshOfGear )
	{
		m_bForceRefreshOfGear=False;
		RefreshGearMenu(True);
	}
	if ( m_Counter > 10 )
	{
		RefreshServerInfo();
	}
}

function SetInterWidgetMenu (ER6GameType _eCurrentGameType, bool _bActiveMenuBar)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local float fXPos;
	local float fWidth;
	local float fAvailableSpace;
	local bool bActiveMenuBar;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	fXPos=r6Root.m_RInterWidget.X;
	fWidth=r6Root.m_RInterWidget.W;
	fAvailableSpace=r6Root.m_RInterWidget.H - m_pMPInterHeader.WinHeight;
	m_pR6BravoTeam.HideWindow();
	m_pR6MissionObj.HideWindow();
	m_bDisplayNavBar=_bActiveMenuBar;
	m_pInGameNavBar.SetNavBarButtonsStatus(_bActiveMenuBar);
	bActiveMenuBar=True;
	if ( m_eCurGameType != _eCurrentGameType )
	{
		m_pMPInterHeader.ResetDisplayInfo();
		m_eCurGameType=_eCurrentGameType;
	}
	m_pMPInterHeader.Reset();
/*	if ( GetLevel().IsGameTypeTeamAdversarial(_eCurrentGameType) )
	{
		m_pMPInterHeader.m_bDisplayTotVictory=True;
		m_pR6AlphaTeam.InitMenuLayout(1);
		m_pR6BravoTeam.InitMenuLayout(1);
		if ( bActiveMenuBar )
		{
			fAvailableSpace -= m_pInGameNavBar.WinHeight;
			m_pR6AlphaTeam.SetWindowSize(fXPos,m_fYStartTeamBarPos,fWidth,fAvailableSpace * 0.50);
			m_pR6BravoTeam.SetWindowSize(fXPos,m_fYStartTeamBarPos + fAvailableSpace * 0.50,fWidth,fAvailableSpace * 0.50);
			m_pR6BravoTeam.ShowWindow();
			SetWindowSize(m_pInGameNavBar,fXPos,m_fYStartTeamBarPos + fAvailableSpace,fWidth,m_pInGameNavBar.WinHeight);
			m_pInGameNavBar.ShowWindow();
		}
		else
		{
			m_pR6AlphaTeam.SetWindowSize(fXPos,m_fYStartTeamBarPos,fWidth,fAvailableSpace * 0.50);
			m_pR6BravoTeam.SetWindowSize(fXPos,m_fYStartTeamBarPos + fAvailableSpace * 0.50,fWidth,fAvailableSpace * 0.50);
			m_pR6BravoTeam.ShowWindow();
		}
	}
	else
	{
		if ( GetLevel().IsGameTypeAdversarial(_eCurrentGameType) )
		{
			m_pR6AlphaTeam.InitMenuLayout(0);
			if ( bActiveMenuBar )
			{
				fAvailableSpace -= m_pInGameNavBar.WinHeight;
				m_pR6AlphaTeam.SetWindowSize(fXPos,m_fYStartTeamBarPos,fWidth,fAvailableSpace);
				SetWindowSize(m_pInGameNavBar,fXPos,m_fYStartTeamBarPos + fAvailableSpace,fWidth,m_pInGameNavBar.WinHeight);
				m_pInGameNavBar.ShowWindow();
			}
			else
			{
				m_pR6AlphaTeam.SetWindowSize(fXPos,m_fYStartTeamBarPos,fWidth,fAvailableSpace);
			}
		}
		else
		{
			if ( GetLevel().IsGameTypeCooperative(_eCurrentGameType) )
			{
				m_pMPInterHeader.m_bDisplayCoopStatus=True;
				m_pR6AlphaTeam.InitMenuLayout(1);
				if ( bActiveMenuBar )
				{
					fAvailableSpace -= m_pInGameNavBar.WinHeight;
					m_pR6AlphaTeam.SetWindowSize(fXPos,m_fYStartTeamBarPos,fWidth,fAvailableSpace * 0.50);
					SetWindowSize(m_pInGameNavBar,fXPos,m_fYStartTeamBarPos + fAvailableSpace,fWidth,m_pInGameNavBar.WinHeight);
					m_pInGameNavBar.ShowWindow();
					m_pR6MissionObj.SetWindowSize(fXPos,m_fYStartTeamBarPos + fAvailableSpace * 0.50,fWidth,fAvailableSpace * 0.50);
					m_pR6MissionObj.ShowWindow();
				}
				else
				{
					m_pR6AlphaTeam.SetWindowSize(fXPos,m_fYStartTeamBarPos,fWidth,fAvailableSpace * 0.50);
					m_pR6MissionObj.SetWindowSize(fXPos,m_fYStartTeamBarPos + fAvailableSpace * 0.50,fWidth,fAvailableSpace * 0.50);
					m_pR6MissionObj.ShowWindow();
				}
			}
		}
	} */
	RefreshServerInfo();
	if ( _bActiveMenuBar )
	{
		m_bForceRefreshOfGear=True;
	}
}

function PopUpGearMenu ()
{
	if ( m_pPopUpGearRoom == None )
	{
		m_pPopUpGearRoom=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
		m_pPopUpGearRoom.CreateStdPopUpWindow(Localize("MPInGame","Gear","R6Menu"),32.00,103.00,70.00,434.00,340.00);
		m_pPopUpGearRoom.CreateClientWindow(Class'R6MenuMPAdvGearWidget');
//		m_pPopUpGearRoom.m_ePopUpID=9;
		m_pPopUpGearRoom.bAlwaysOnTop=True;
		m_pPopUpGearRoom.m_bBGFullScreen=True;
		m_pPopUpGearRoom.Close();
	}
	else
	{
		m_pPopUpGearRoom.ShowWindow();
		RefreshGearMenu(True);
		m_pPopUpBoxCurrent=m_pPopUpGearRoom;
	}
}

function PopUpServerOptMenu ()
{
	if ( m_pPopUpServerOption == None )
	{
		m_pPopUpServerOption=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
		m_pPopUpServerOption.CreateStdPopUpWindow(Localize("MPInGame","ServerOpt","R6Menu"),32.00,10.00,80.00,620.00,325.00);
		m_pPopUpServerOption.CreateClientWindow(Root.MenuClassDefines.ClassMPServerOption);
//		m_pPopUpServerOption.m_ePopUpID=7;
		m_pPopUpServerOption.bAlwaysOnTop=True;
		m_pPopUpServerOption.m_bBGFullScreen=True;
	}
	m_pPopUpServerOption.ShowWindow();
	R6PlayerController(GetPlayerOwner()).ServerPausePreGameRoundTime();
	m_pPopUpBoxCurrent=m_pPopUpServerOption;
	R6MenuMPCreateGameTab(m_pPopUpServerOption.m_ClientArea).RefreshServerOpt();
}

function PopUpKitRestMenu ()
{
	local R6MenuMPRestKitMain pR6MenuMPRestKitMain;

	if ( m_pPopUpKitRest == None )
	{
		m_pPopUpKitRest=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
		m_pPopUpKitRest.CreateStdPopUpWindow(Localize("MPInGame","KitRestriction","R6Menu"),32.00,10.00,70.00,620.00,332.00);
		m_pPopUpKitRest.CreateClientWindow(Class'R6MenuMPRestKitMain');
//		m_pPopUpKitRest.m_ePopUpID=8;
		m_pPopUpKitRest.bAlwaysOnTop=True;
		m_pPopUpKitRest.m_bBGFullScreen=True;
		pR6MenuMPRestKitMain=R6MenuMPRestKitMain(m_pPopUpKitRest.m_ClientArea);
		pR6MenuMPRestKitMain.CreateKitRestriction();
	}
	m_pPopUpKitRest.ShowWindow();
	R6PlayerController(GetPlayerOwner()).ServerPausePreGameRoundTime();
	m_pPopUpBoxCurrent=m_pPopUpKitRest;
	R6MenuMPRestKitMain(m_pPopUpKitRest.m_ClientArea).RefreshKitRest();
}

function ForceClosePopUp ()
{
	if ( m_pPopUpGearRoom != None )
	{
		if ( m_bDisplayNavBar )
		{
//			R6MenuMPAdvGearWidget(m_pPopUpGearRoom.m_ClientArea).PopUpBoxDone(3,m_pPopUpGearRoom.m_ePopUpID);
		}
	}
	if ( m_pPopUpBoxCurrent != None )
	{
		if ( m_pPopUpBoxCurrent.bWindowVisible )
		{
			m_pPopUpBoxCurrent.Close();
		}
	}
}

function HideWindow ()
{
	ForceClosePopUp();
	Super.HideWindow();
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	if ( Result == 3 )
	{
		m_InGameOptionsChange=_ePopUpID;
		switch (_ePopUpID)
		{
/*			case 7:
			R6PlayerController(GetPlayerOwner()).ServerStartChangingInfo();
			break;
			case 8:
			R6PlayerController(GetPlayerOwner()).ServerStartChangingInfo();
			break;
			default:*/
		}
	}
	R6PlayerController(GetPlayerOwner()).ServerUnPausePreGameRoundTime();
}

function SetClientServerSettings (bool _bChange)
{
	local R6MenuMPCreateGameTab pServerOpt;
	local R6MenuMPRestKitMain pKitRest;
	local bool bSetNewSettings;
	local byte _bMapCount;

	if ( _bChange )
	{
		switch (m_InGameOptionsChange)
		{
/*			case 7:
			pServerOpt=R6MenuMPCreateGameTab(m_pPopUpServerOption.m_ClientArea);
			bSetNewSettings=pServerOpt.SendNewServerSettings();
			bSetNewSettings=pServerOpt.SendNewMapSettings(_bMapCount) || bSetNewSettings;
			if ( (bSetNewSettings == True) && (_bMapCount == 0) )
			{
				R6PlayerController(GetPlayerOwner()).SendSettingsAndRestartServer(False,False);
			}
			else
			{
				SetNavBarInActive(bSetNewSettings);
				R6PlayerController(GetPlayerOwner()).SendSettingsAndRestartServer(False,bSetNewSettings);
			}
			break;
			case 8:
			pKitRest=R6MenuMPRestKitMain(m_pPopUpKitRest.m_ClientArea);
			bSetNewSettings=pKitRest.SendNewRestrictionsKit();
			R6PlayerController(GetPlayerOwner()).SendSettingsAndRestartServer(True,bSetNewSettings);
			break;
			default:*/
		}
	}
}

function RefreshServerInfo ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	m_Counter=0;
	if (  !r6Root.m_bPreventMenuSwitch )
	{
		if ( r6Root.m_R6GameMenuCom != None )
		{
			r6Root.m_R6GameMenuCom.RefreshMPlayerInfo();
			m_pMPInterHeader.RefreshInterHeaderInfo();
//			m_pR6AlphaTeam.RefreshTeamBarInfo(r6Root.m_R6GameMenuCom.2);
			if ( m_pR6BravoTeam.bWindowVisible )
			{
//				m_pR6BravoTeam.RefreshTeamBarInfo(r6Root.m_R6GameMenuCom.3);
			}
			if ( m_pR6MissionObj.bWindowVisible )
			{
				m_pR6MissionObj.m_pMissionObj.UpdateObjectives();
			}
		}
	}
	if ( m_pPopUpBoxCurrent != None )
	{
		if ( m_pPopUpBoxCurrent.bWindowVisible )
		{
			if ( m_pPopUpBoxCurrent.m_ePopUpID == 8 )
			{
				if ( m_bRefreshRestKit )
				{
					m_bRefreshRestKit=False;
					R6MenuMPRestKitMain(m_pPopUpKitRest.m_ClientArea).RefreshKitRest();
				}
				R6MenuMPRestKitMain(m_pPopUpKitRest.m_ClientArea).Refresh();
			}
			else
			{
				if ( m_pPopUpBoxCurrent.m_ePopUpID == 7 )
				{
					R6MenuMPCreateGameTab(m_pPopUpServerOption.m_ClientArea).Refresh();
				}
				else
				{
					if ( m_pPopUpBoxCurrent.m_ePopUpID == 9 )
					{
						RefreshGearMenu();
					}
				}
			}
		}
		else
		{
			m_bRefreshRestKit=True;
		}
	}
}

function RefreshGearMenu (optional bool _bForceUpdate)
{
	local bool bForceUpdate;

	bForceUpdate=_bForceUpdate;
	if ( m_pPopUpGearRoom == None )
	{
		PopUpGearMenu();
		bForceUpdate=True;
	}
	R6MenuMPAdvGearWidget(m_pPopUpGearRoom.m_ClientArea).RefreshGearInfo(bForceUpdate);
}

function SetWindowSize (UWindowWindow _W, float _fX, float _fY, float _fW, float _fH)
{
	_W.WinTop=_fY;
	_W.WinLeft=_fX;
	_W.WinWidth=_fW;
	_W.WinHeight=_fH;
}

function SetNavBarInActive (bool _bDisable, optional bool _bError)
{
	if ( _bError )
	{
		if ( m_bNavBarActive )
		{
			return;
		}
		else
		{
			m_bNavBarActive=_bDisable;
		}
	}
	else
	{
		m_bNavBarActive=_bDisable;
	}
	m_pInGameNavBar.SetNavBarState(m_bNavBarActive);
}

function bool IsMissionInProgress ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	return r6Root.m_R6GameMenuCom.m_GameRepInfo.m_bRepMObjInProgress == 1;
}

function byte GetLastMissionSuccess ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	return r6Root.m_R6GameMenuCom.m_GameRepInfo.m_bRepLastRoundSuccess;
}

function bool IsMissionSuccess ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	return r6Root.m_R6GameMenuCom.m_GameRepInfo.m_bRepMObjSuccess == 1;
}
