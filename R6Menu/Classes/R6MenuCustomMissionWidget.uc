//================================================================================
// R6MenuCustomMissionWidget.
//================================================================================
class R6MenuCustomMissionWidget extends R6MenuWidget
	Config(User);

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

var config int CustomMissionGameType;
var bool bShowLog;
var R6WindowButton m_ButtonStart;
var R6WindowButton m_ButtonMainMenu;
var R6WindowButton m_ButtonOptions;
var R6WindowSimpleFramedWindow m_Map;
var R6WindowTextLabel m_LMenuTitle;
var R6WindowTextLabelCurved m_LGameLevelTitle;
var R6WindowTextListBox m_GameLevelBox;
var R6WindowSimpleCurvedFramedWindow m_DifficultyArea;
var R6FileManagerCampaign m_pFileManager;
var R6MenuHelpWindow m_pHelpWindow;
var R6WindowButton m_pButPraticeMission;
var R6WindowButton m_pButLoneWolf;
var R6WindowButton m_pButTerroHunt;
var R6WindowButton m_pButHostageRescue;
var R6WindowButton m_pButCurrent;
var R6WindowSimpleFramedWindow m_TerroArea;
var Font m_LeftButtonFont;
var Font m_LeftDownSizeFont;
var Color m_TitleTextColor;
var string m_LastMapPlayed;
var config string CustomMissionMap;

function Created ()
{
	local Font ButtonFont;
	local Color co;
	local Color TitleTextColor;
	local int iFiles;
	local int i;
	local string szFileName;
	local bool bFileChange;
	local bool bInTab;
	local R6WindowListBoxItem NewItem;
	local R6MenuRootWindow r6Root;
	local int XPos;

	r6Root=R6MenuRootWindow(Root);
	ButtonFont=Root.Fonts[16];
	m_pHelpWindow=R6MenuHelpWindow(CreateWindow(Class'R6MenuHelpWindow',150.00,429.00,340.00,42.00,self));
	m_ButtonMainMenu=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,421.00,250.00,25.00,self));
	m_ButtonMainMenu.ToolTipString=Localize("Tip","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.Text=Localize("SinglePlayer","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.Align=TA_Left;
	m_ButtonMainMenu.m_buttonFont=ButtonFont;
	m_ButtonMainMenu.ResizeToText();
	m_ButtonOptions=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,452.00,250.00,25.00,self));
	m_ButtonOptions.ToolTipString=Localize("Tip","ButtonOptions","R6Menu");
	m_ButtonOptions.Text=Localize("SinglePlayer","ButtonOptions","R6Menu");
	m_ButtonOptions.Align=TA_Left;
	m_ButtonOptions.m_buttonFont=ButtonFont;
	m_ButtonOptions.ResizeToText();
	XPos=m_pHelpWindow.WinLeft + m_pHelpWindow.WinWidth;
	m_ButtonStart=R6WindowButton(CreateControl(Class'R6WindowButton',XPos,452.00,WinWidth - XPos - 20,25.00,self));
	m_ButtonStart.ToolTipString=Localize("Tip","ButtonStart","R6Menu");
	m_ButtonStart.Text=Localize("CustomMission","ButtonStart1","R6Menu");
	m_ButtonStart.Align=TA_Right;
	m_ButtonStart.m_buttonFont=ButtonFont;
	m_ButtonStart.ResizeToText();
	m_ButtonStart.m_bWaitSoundFinish=True;
	m_Map=R6WindowSimpleFramedWindow(CreateWindow(Class'R6WindowSimpleFramedWindow',390.00,268.00,230.00,130.00,self));
	m_Map.CreateClientWindow(Class'R6WindowBitMap');
//	m_Map.m_eCornerType=3;
	m_TitleTextColor=Root.Colors.White;
	m_LMenuTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,18.00,WinWidth - 8,25.00,self));
	m_LMenuTitle.Text=Localize("CustomMission","Title","R6Menu");
	m_LMenuTitle.Align=TA_Right;
	m_LMenuTitle.m_Font=Root.Fonts[4];
	m_LMenuTitle.TextColor=m_TitleTextColor;
	m_LMenuTitle.m_BGTexture=None;
	m_LMenuTitle.m_bDrawBorders=False;
	m_GameLevelBox=R6WindowTextListBox(CreateControl(Class'R6WindowTextListBox',198.00,102.00,156.00,296.00,self));
	m_GameLevelBox.ListClass=Class'R6WindowListBoxItem';
//	m_GameLevelBox.SetCornerType(3);
	m_GameLevelBox.ToolTipString=Localize("Tip","CustomMListBox","R6Menu");
	m_LGameLevelTitle=R6WindowTextLabelCurved(CreateWindow(Class'R6WindowTextLabelCurved',198.00,72.00,156.00,31.00,self));
	m_LGameLevelTitle.Text=Localize("CustomMission","TitleGameLevel","R6Menu");
	m_LGameLevelTitle.Align=TA_Center;
	m_LGameLevelTitle.m_Font=Root.Fonts[8];
	m_LGameLevelTitle.TextColor=m_TitleTextColor;
	m_DifficultyArea=R6WindowSimpleCurvedFramedWindow(CreateWindow(Class'R6WindowSimpleCurvedFramedWindow',390.00,72.00,m_Map.WinWidth,122.00,self));
	m_DifficultyArea.CreateClientWindow(Class'R6MenuDiffCustomMissionSelect');
	m_DifficultyArea.m_Title=Localize("SinglePlayer","Difficulty","R6Menu");
	m_DifficultyArea.m_TitleAlign=TA_Center;
	m_DifficultyArea.m_Font=Root.Fonts[8];
	m_DifficultyArea.m_TextColor=m_TitleTextColor;
	m_DifficultyArea.m_BorderColor=Root.Colors.White;
//	m_DifficultyArea.SetCornerType(3);
	m_TerroArea=R6WindowSimpleFramedWindow(CreateWindow(Class'R6WindowSimpleFramedWindow',390.00,m_DifficultyArea.WinTop + m_DifficultyArea.WinHeight - 1,m_DifficultyArea.WinWidth,63.00,self));
	m_TerroArea.CreateClientWindow(Class'R6MenuCustomMissionNbTerroSelect');
//	m_TerroArea.SetCornerType(2);
	m_TerroArea.HideWindow();
	if ( r6Root.m_pFileManager == None )
	{
		Log("R6MenuRootWindow(Root).m_pFileManager == NONE");
	}
	m_pFileManager=new Class'R6FileManagerCampaign';
	InitCustomMission();
}

function bool ValidateBeforePlanning ()
{
	local R6MenuRootWindow r6Root;

	r6Root=R6MenuRootWindow(Root);
	if ( r6Root == None )
	{
		if ( bShowLog )
		{
			Log("ValidateBeforePlanning: R6Root == None");
		}
		return False;
	}
	if ( m_GameLevelBox.m_SelectedItem == None )
	{
		if ( bShowLog )
		{
			Log("ValidateBeforePlanning: m_GameLevelBox.m_SelectedItem == NONE");
		}
		return False;
	}
	if ( m_GameLevelBox.m_SelectedItem.HelpText == "" )
	{
		if ( bShowLog )
		{
//			Log("ValidateBeforePlanning: m_GameLevelBox.m_SelectedItem.HelpText == """);
		}
		return False;
	}
	r6Root.ResetCustomMissionOperatives();
	if ( r6Root.m_GameOperatives.Length <= 0 )
	{
		if ( bShowLog )
		{
			Log("R6Root.m_GameOperatives.Length <= 0");
		}
		return False;
	}
	else
	{
		if ( bShowLog )
		{
			Log("ValidateBeforePlanning: return true");
		}
		return True;
	}
}

function GotoPlanning ()
{
	local R6MenuRootWindow r6Root;
	local R6MissionDescription CurrentMission;
	local R6WindowListBoxItem SelectedItem;
	local R6Console R6Console;

	r6Root=R6MenuRootWindow(Root);
	SelectedItem=R6WindowListBoxItem(m_GameLevelBox.m_SelectedItem);
	CurrentMission=R6MissionDescription(SelectedItem.m_Object);
	R6Console=R6Console(Root.Console);
	R6Console.Master.m_StartGameInfo.m_CurrentMission=CurrentMission;
	R6Console.Master.m_StartGameInfo.m_MapName=CurrentMission.m_MapName;
	R6Console.Master.m_StartGameInfo.m_DifficultyLevel=R6MenuDiffCustomMissionSelect(m_DifficultyArea.m_ClientArea).GetDifficulty();
	R6Console.Master.m_StartGameInfo.m_iNbTerro=R6MenuCustomMissionNbTerroSelect(m_TerroArea.m_ClientArea).GetNbTerro();
	R6Console.Master.m_StartGameInfo.m_GameMode=GetLevel().GetGameTypeClassName(GetLevel().ConvertGameTypeIntToEnum(m_pButCurrent.m_iButtonID));
	CustomMissionMap=CurrentMission.m_MapName;
	CustomMissionGameType=m_pButCurrent.m_iButtonID;
	SaveConfig();
	Root.ResetMenus();
	r6Root.m_bLoadingPlanning=True;
	R6Console.PreloadMapForPlanning();
}

function ShowWindow ()
{
	RefreshList();
	Super.ShowWindow();
}

function RefreshList ()
{
	local int i;
	local int iCampaign;
	local int iMission;
	local R6Console R6Console;
	local string szMapName;
	local R6WindowListBoxItem NewItem;
	local R6WindowListBoxItem ItemToSelect;
	local ER6GameType eGameType;
	local R6MissionDescription mission;
	local string szMod;
	local string szRavenShieldMod;

	R6Console=R6Console(Root.Console);
//	eGameType=GetLevel().ConvertGameTypeIntToEnum(m_pButCurrent.m_iButtonID);
	m_GameLevelBox.Clear();
	szMod=Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szKeyWord;
	szRavenShieldMod=Class'Actor'.static.GetModMgr().m_pRVS.m_szKeyWord;
	iCampaign=0;
JL0098:
	if ( iCampaign < R6Console.m_aCampaigns.Length )
	{
		iMission=0;
JL00B8:
		if ( iMission < R6Console.m_aCampaigns[iCampaign].m_missions.Length )
		{
			mission=R6Console.m_aCampaigns[iCampaign].m_missions[iMission];
/*			if ( mission.IsAvailableInGameType(eGameType) && (mission.m_MapName != "") && ((szMod ~= mission.mod) || (mission.mod ~= szRavenShieldMod)) )
			{
				szMapName=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
				if ( szMapName == "" )
				{
					szMapName=mission.m_MapName;
				}
				NewItem=R6WindowListBoxItem(m_GameLevelBox.Items.Append(m_GameLevelBox.ListClass));
				NewItem.HelpText=szMapName;
				NewItem.m_Object=mission;
				if ( mission.m_bIsLocked )
				{
					NewItem.m_bDisabled=True;
				}
				else
				{
					if ( (mission.m_MapName == m_LastMapPlayed) && (ItemToSelect == None) )
					{
						ItemToSelect=NewItem;
					}
				}
			}*/
			++iMission;
			goto JL00B8;
		}
		++iCampaign;
		goto JL0098;
	}
	iMission=0;
JL028B:
	if ( iMission < R6Console.m_aMissionDescriptions.Length )
	{
		mission=R6Console.m_aMissionDescriptions[iMission];
/*		if (  !mission.m_bCampaignMission && mission.IsAvailableInGameType(eGameType) && (mission.m_MapName != "") && ((szMod ~= mission.mod) || (mission.mod ~= szRavenShieldMod)) )
		{
			szMapName=Localize(mission.m_MapName,"ID_MENUNAME",mission.LocalizationFile,True);
			if ( szMapName == "" )
			{
				szMapName=mission.m_MapName;
			}
			NewItem=R6WindowListBoxItem(m_GameLevelBox.Items.Append(m_GameLevelBox.ListClass));
			NewItem.HelpText=szMapName;
			NewItem.m_Object=mission;
			if ( mission.m_bIsLocked )
			{
				NewItem.m_bDisabled=True;
			}
			else
			{
				if ( (mission.m_MapName == m_LastMapPlayed) && (ItemToSelect == None) )
				{
					ItemToSelect=NewItem;
				}
			}
		}*/
		++iMission;
		goto JL028B;
	}
	if ( m_GameLevelBox.Items.Count() > 0 )
	{
		if ( ItemToSelect != None )
		{
			m_GameLevelBox.SetSelectedItem(ItemToSelect);
		}
		else
		{
			m_GameLevelBox.SetSelectedItem(R6WindowListBoxItem(m_GameLevelBox.Items.Next));
		}
		m_GameLevelBox.MakeSelectedVisible();
	}
	UpdateBackground();
	m_LastMapPlayed="";
}

function InitCustomMission ()
{
	local bool bFileChange;
	local bool bCheckedRvSDir;
	local bool bCheckCampaignMission;
	local string szDir;
	local int i;
	local int iFiles;
	local R6MenuRootWindow r6Root;
	local R6PlayerCampaign MyCampaign;
	local R6Console R6Console;

	r6Root=R6MenuRootWindow(Root);
	R6Console=R6Console(Root.Console);
	m_pFileManager.LoadCustomMissionAvailable(R6Console.m_playerCustomMission);
	MyCampaign=new Class'R6PlayerCampaign';
	bFileChange=False;
	bCheckedRvSDir=False;
	szDir="..\\save\\campaigns\\" $ Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szCampaignDir $ "\\";
JL00A1:
	if ( szDir != "" )
	{
		iFiles=r6Root.m_pFileManager.GetNbFile(szDir,"cmp");
		i=0;
JL00D9:
		if ( i < iFiles )
		{
			r6Root.m_pFileManager.GetFileName(i,MyCampaign.m_FileName);
			MyCampaign.m_FileName=Left(MyCampaign.m_FileName,InStr(MyCampaign.m_FileName,"."));
			MyCampaign.m_OperativesMissionDetails=None;
			MyCampaign.m_OperativesMissionDetails=new Class'R6MissionRoster';
			m_pFileManager.LoadCampaign(MyCampaign);
			bCheckCampaignMission=False;
			if ( i == 0 )
			{
				bCheckCampaignMission=True;
			}
			if ( R6Console.UpdateCurrentMapAvailable(MyCampaign,bCheckCampaignMission) )
			{
				bFileChange=True;
			}
			i++;
			goto JL00D9;
		}
		if ( (bCheckedRvSDir == False) &&  !Class'Actor'.static.GetModMgr().IsRavenShield() )
		{
			bCheckedRvSDir=True;
			szDir="..\\save\\campaigns\\";
		}
		else
		{
			szDir="";
		}
		goto JL00A1;
	}
	if ( bFileChange )
	{
		m_pFileManager.SaveCustomMissionAvailable(R6Console.m_playerCustomMission);
	}
	m_LastMapPlayed=CustomMissionMap;
	R6Console.UnlockMissions();
}

function ToolTip (string strTip)
{
	m_pHelpWindow.ToolTip(strTip);
}

function UpdateBackground ()
{
/*	if ( GetLevel().GameTypeUseNbOfTerroristToSpawn(GetLevel().ConvertGameTypeIntToEnum(m_pButCurrent.m_iButtonID)) )
	{
		m_DifficultyArea.SetCornerType(1);
		m_TerroArea.ShowWindow();
		Root.SetLoadRandomBackgroundImage("OtherMission");
	}
	else
	{
		m_DifficultyArea.SetCornerType(3);
		m_TerroArea.HideWindow();
		Root.SetLoadRandomBackgroundImage("PracticeMission");
	}*/
}

function Paint (Canvas C, float X, float Y)
{
	Root.PaintBackground(C,self);
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6WindowListBoxItem SelectedItem;
	local R6MissionDescription CurrentMission;
	local R6WindowBitMap mapBitmap;

	if ( E == 2 )
	{
		switch (C)
		{
			case m_ButtonMainMenu:
//			Root.ChangeCurrentWidget(7);
			break;
			case m_ButtonOptions:
//			Root.ChangeCurrentWidget(16);
			break;
			case m_ButtonStart:
			if ( ValidateBeforePlanning() )
			{
				GotoPlanning();
			}
			break;
			case m_pButPraticeMission:
			case m_pButLoneWolf:
			case m_pButTerroHunt:
			case m_pButHostageRescue:
			case m_pButCurrent:
			m_pButCurrent.m_bSelected=False;
			R6WindowButton(C).m_bSelected=True;
			m_pButCurrent=R6WindowButton(C);
			RefreshList();
			break;
			case m_GameLevelBox:
			mapBitmap=R6WindowBitMap(m_Map.m_ClientArea);
			SelectedItem=R6WindowListBoxItem(m_GameLevelBox.m_SelectedItem);
			if ( SelectedItem == None )
			{
				mapBitmap.t=None;
			}
			else
			{
				if ( SelectedItem.m_Object == None )
				{
					goto JL01A8;
				}
				CurrentMission=R6MissionDescription(SelectedItem.m_Object);
				if ( CurrentMission == None )
				{
					goto JL01A8;
				}
				mapBitmap.R=CurrentMission.m_RMissionOverview;
				mapBitmap.t=CurrentMission.m_TMissionOverview;
				goto JL01A8;
				default:
				goto JL01A8;
			}
		}
JL01A8:
	}
	else
	{
		if ( E == 11 )
		{
			if ( C == m_GameLevelBox )
			{
				if ( ValidateBeforePlanning() )
				{
					GotoPlanning();
				}
			}
		}
	}
}

function CreateButtons ()
{
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local float fHeight;
	local float fYPos;

	fXOffset=10.00;
	fYOffset=26.00;
	fWidth=200.00;
	fHeight=25.00;
	fYPos=64.00;
	m_pButPraticeMission=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButPraticeMission.ToolTipString=Localize("Tip","GameType_Practice","R6Menu");
	m_pButPraticeMission.Text=Localize("CustomMission","ButtonPractice","R6Menu");
//	m_pButPraticeMission.m_iButtonID=GetLevel().2;
	m_pButPraticeMission.Align=TA_Left;
	m_pButPraticeMission.m_buttonFont=m_LeftButtonFont;
	m_pButPraticeMission.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButPraticeMission.ResizeToText();
	fYPos += fYOffset;
	m_pButLoneWolf=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButLoneWolf.ToolTipString=Localize("Tip","GameType_LoneWolf","R6Menu");
	m_pButLoneWolf.Text=Localize("CustomMission","ButtonLoneWolf","R6Menu");
//	m_pButLoneWolf.m_iButtonID=GetLevel().17;
	m_pButLoneWolf.Align=TA_Left;
	m_pButLoneWolf.m_buttonFont=m_LeftButtonFont;
	m_pButLoneWolf.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButLoneWolf.ResizeToText();
	fYPos += fYOffset;
	m_pButTerroHunt=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButTerroHunt.ToolTipString=Localize("Tip","GameType_TerroristHunt","R6Menu");
	m_pButTerroHunt.Text=Localize("CustomMission","ButtonTerroHunt","R6Menu");
//	m_pButTerroHunt.m_iButtonID=GetLevel().4;
	m_pButTerroHunt.Align=TA_Left;
	m_pButTerroHunt.m_buttonFont=m_LeftButtonFont;
	m_pButTerroHunt.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButTerroHunt.ResizeToText();
	fYPos += fYOffset;
	m_pButHostageRescue=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButHostageRescue.ToolTipString=Localize("Tip","GameType_HostageRescue","R6Menu");
	m_pButHostageRescue.Text=Localize("CustomMission","ButtonHostageRescue","R6Menu");
//	m_pButHostageRescue.m_iButtonID=GetLevel().6;
	m_pButHostageRescue.Align=TA_Left;
	m_pButHostageRescue.m_buttonFont=m_LeftButtonFont;
	m_pButHostageRescue.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButHostageRescue.ResizeToText();
	switch (CustomMissionGameType)
	{
/*		case m_pButPraticeMission.m_iButtonID:
		m_pButCurrent=m_pButPraticeMission;
		break;
		case m_pButLoneWolf.m_iButtonID:
		m_pButCurrent=m_pButLoneWolf;
		break;
		case m_pButTerroHunt.m_iButtonID:
		m_pButCurrent=m_pButTerroHunt;
		break;
		case m_pButHostageRescue.m_iButtonID:
		m_pButCurrent=m_pButHostageRescue;
		break;
		default:
		m_pButCurrent=m_pButPraticeMission;*/
	}
	m_pButCurrent.m_bSelected=True;
}

function bool ButtonsUsingDownSizeFont ()
{
	local bool Result;

	if ( m_pButPraticeMission.IsFontDownSizingNeeded() || m_pButLoneWolf.IsFontDownSizingNeeded() || m_pButTerroHunt.IsFontDownSizingNeeded() || m_pButHostageRescue.IsFontDownSizingNeeded() )
	{
		Result=True;
	}
	return Result;
}

function ForceFontDownSizing ()
{
	m_pButPraticeMission.m_buttonFont=m_LeftDownSizeFont;
	m_pButLoneWolf.m_buttonFont=m_LeftDownSizeFont;
	m_pButTerroHunt.m_buttonFont=m_LeftDownSizeFont;
	m_pButHostageRescue.m_buttonFont=m_LeftDownSizeFont;
	m_pButPraticeMission.ResizeToText();
	m_pButLoneWolf.ResizeToText();
	m_pButTerroHunt.ResizeToText();
	m_pButHostageRescue.ResizeToText();
}

defaultproperties
{
    CustomMissionGameType=2
    CustomMissionMap="Oil_Refinery"
}
