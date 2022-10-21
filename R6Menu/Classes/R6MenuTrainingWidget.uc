//================================================================================
// R6MenuTrainingWidget.
//================================================================================
class R6MenuTrainingWidget extends R6MenuWidget;

var bool bShowLog;
var R6WindowButton m_ButtonStart;
var R6WindowButton m_ButtonMainMenu;
var R6WindowButton m_ButtonOptions;
var R6WindowTextLabel m_LMenuTitle;
var R6MenuHelpWindow m_pHelpWindow;
var R6WindowSimpleFramedWindow m_Map;
var Texture m_mapPreviews[9];
var R6WindowButton m_pButBasics;
var R6WindowButton m_pButShooting;
var R6WindowButton m_pButExplosives;
var R6WindowButton m_pButRoomClearing1;
var R6WindowButton m_pButRoomClearing2;
var R6WindowButton m_pButRoomClearing3;
var R6WindowButton m_pButHostageRescue1;
var R6WindowButton m_pButHostageRescue2;
var R6WindowButton m_pButHostageRescue3;
var R6WindowButton m_pButCurrent;
var Font m_LeftButtonFont;
var Font m_LeftDownSizeFont;
var Color m_TitleTextColor;
var string m_mapNames[9];

function Created ()
{
	local Font ButtonFont;
	local int XPos;
	local R6WindowBitMap mapBitmap;

	ButtonFont=Root.Fonts[16];
	m_Map=R6WindowSimpleFramedWindow(CreateWindow(Class'R6WindowSimpleFramedWindow',198.00,72.00,422.00,220.00,self));
	m_Map.CreateClientWindow(Class'R6WindowBitMap');
//	m_Map.m_eCornerType=3;
	mapBitmap=R6WindowBitMap(m_Map.m_ClientArea);
	mapBitmap.R.X=0;
	mapBitmap.R.Y=0;
	mapBitmap.R.W=mapBitmap.WinWidth;
	mapBitmap.R.H=mapBitmap.WinHeight;
//	mapBitmap.m_iDrawStyle=1;
	m_pHelpWindow=R6MenuHelpWindow(CreateWindow(Class'R6MenuHelpWindow',150.00,429.00,340.00,42.00,self));
	m_ButtonMainMenu=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,421.00,250.00,25.00,self));
	m_ButtonMainMenu.ToolTipString=Localize("Tip","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.Text=Localize("SinglePlayer","ButtonMainMenu","R6Menu");
	m_ButtonMainMenu.align=ta_left;
	m_ButtonMainMenu.m_buttonFont=ButtonFont;
	m_ButtonMainMenu.ResizeToText();
	m_ButtonOptions=R6WindowButton(CreateControl(Class'R6WindowButton',10.00,452.00,250.00,25.00,self));
	m_ButtonOptions.ToolTipString=Localize("Tip","ButtonOptions","R6Menu");
	m_ButtonOptions.Text=Localize("SinglePlayer","ButtonOptions","R6Menu");
	m_ButtonOptions.align=ta_left;
	m_ButtonOptions.m_buttonFont=ButtonFont;
	m_ButtonOptions.ResizeToText();
	XPos=m_pHelpWindow.WinLeft + m_pHelpWindow.WinWidth;
	m_ButtonStart=R6WindowButton(CreateControl(Class'R6WindowButton',XPos,452.00,WinWidth - XPos - 20,25.00,self));
	m_ButtonStart.ToolTipString=Localize("Tip","ButtonStart","R6Menu");
	m_ButtonStart.Text=Localize("CustomMission","ButtonStart1","R6Menu");
	m_ButtonStart.align=ta_right;
	m_ButtonStart.m_buttonFont=ButtonFont;
	m_ButtonStart.ResizeToText();
	m_ButtonStart.m_bWaitSoundFinish=True;
	m_TitleTextColor=Root.Colors.White;
	m_LMenuTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,18.00,WinWidth - 20,25.00,self));
	m_LMenuTitle.Text=Localize("Training","Title","R6Menu");
	m_LMenuTitle.align=ta_right;
	m_LMenuTitle.m_Font=Root.Fonts[4];
	m_LMenuTitle.TextColor=m_TitleTextColor;
	m_LMenuTitle.m_BGTexture=None;
	m_LMenuTitle.m_bDrawBorders=False;
}

function ShowWindow ()
{
	Super.ShowWindow();
	Root.SetLoadRandomBackgroundImage("Training");
}

function ToolTip (string strTip)
{
	m_pHelpWindow.ToolTip(strTip);
}

function Paint (Canvas C, float X, float Y)
{
	Root.PaintBackground(C,self);
}

function CurrentSelectedButton (R6WindowButton _IwasPressed)
{
	local R6WindowBitMap mapBitmap;

	if ( m_pButCurrent != None )
	{
		m_pButCurrent.m_bSelected=False;
	}
	_IwasPressed.m_bSelected=True;
	m_pButCurrent=_IwasPressed;
	mapBitmap=R6WindowBitMap(m_Map.m_ClientArea);
	mapBitmap.t=m_mapPreviews[_IwasPressed.m_iButtonID];
}

function SetCurrentMissionInTraining ()
{
	local R6MissionDescription mission;
	local R6Console R6Console;
	local int iMission;
	local string szMapName1;
	local string szMapName2;

	R6Console=R6Console(Root.Console);
	szMapName2=R6Console.Master.m_StartGameInfo.m_MapName;
	szMapName2=Caps(szMapName2);
	iMission=0;
JL0053:
	if ( iMission < R6Console.m_aMissionDescriptions.Length )
	{
		mission=R6Console.m_aMissionDescriptions[iMission];
		szMapName1=mission.m_MapName;
		szMapName1=Caps(szMapName1);
		if ( szMapName1 == szMapName2 )
		{
			R6Console.Master.m_StartGameInfo.m_CurrentMission=mission;
			return;
		}
		iMission++;
		goto JL0053;
	}
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
			case m_ButtonOptions:
//			Root.ChangeCurrentWidget(16);
			break;
			case m_pButBasics:
			case m_pButShooting:
			case m_pButExplosives:
			case m_pButRoomClearing1:
			case m_pButRoomClearing2:
			case m_pButRoomClearing3:
			case m_pButHostageRescue1:
			case m_pButHostageRescue2:
			case m_pButHostageRescue3:
			CurrentSelectedButton(R6WindowButton(C));
			break;
			case m_ButtonStart:
			StartTraining();
			break;
			default:
		}
	}
	if ( E == 11 )
	{
		switch (C)
		{
			case m_pButBasics:
			case m_pButShooting:
			case m_pButExplosives:
			case m_pButRoomClearing1:
			case m_pButRoomClearing2:
			case m_pButRoomClearing3:
			case m_pButHostageRescue1:
			case m_pButHostageRescue2:
			case m_pButHostageRescue3:
			CurrentSelectedButton(R6WindowButton(C));
			StartTraining();
			break;
			default:
		}
	}
}

function StartTraining ()
{
	local R6StartGameInfo StartGameInfo;
	local R6FileManagerPlanning pFileManager;
	local int i;
	local int j;
	local int iNbTeam;
	local string szMapName;
	local string szMenuMapName;
	local string szSaveName;
	local string szLoadErrorMsg;

	StartGameInfo=R6Console(Root.Console).Master.m_StartGameInfo;
	StartGameInfo.m_MapName=m_mapNames[m_pButCurrent.m_iButtonID];
	SetCurrentMissionInTraining();
	StartGameInfo.m_GameMode="R6Game.R6TrainingMgr";
	szMapName=StartGameInfo.m_MapName;
	szMapName=Caps(szMapName);
	if ( (szMapName == "TRAINING_BASICS") || (szMapName == "TRAINING_SHOOTING") || (szMapName == "TRAINING_EXPLOSIVES") )
	{
		StartGameInfo.m_TeamInfo[0].m_iNumberOfMembers=1;
		iNbTeam=1;
		StartGameInfo.m_TeamInfo[0].m_iSpawningPointNumber=1;
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_CharacterName=Localize("Training","ROOKIE","R6Menu");
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_ArmorName="R6Characters.R6RainbowLightBlue";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_szSpecialityID="ID_ASSAULT";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_FaceTexture=Class'R6RookieAssault'.Default.m_TMenuFaceSmall;
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_FaceCoords.X=Class'R6RookieAssault'.Default.m_RMenuFaceSmallX;
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_FaceCoords.Y=Class'R6RookieAssault'.Default.m_RMenuFaceSmallY;
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_FaceCoords.Z=Class'R6RookieAssault'.Default.m_RMenuFaceSmallW;
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_FaceCoords.W=Class'R6RookieAssault'.Default.m_RMenuFaceSmallH;
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_WeaponName[0]="";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_WeaponName[1]="";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_BulletType[0]="";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_BulletType[1]="";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_WeaponGadgetName[0]="";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_WeaponGadgetName[1]="";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_GadgetName[0]="";
		StartGameInfo.m_TeamInfo[0].m_CharacterInTeam[0].m_GadgetName[1]="";
	}
	Root.Console.ViewportOwner.bShowWindowsMouse=False;
	R6Console(Root.Console).LaunchTraining();
	Close();
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
	m_pButBasics=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButBasics.ToolTipString=Localize("Tip","ButtonBasics","R6Menu");
	m_pButBasics.Text=Localize("Training","ButtonBasics","R6Menu");
	m_pButBasics.align=ta_left;
	m_pButBasics.m_buttonFont=m_LeftButtonFont;
	m_pButBasics.m_iButtonID=0;
	m_pButBasics.bIgnoreLDoubleClick=False;
	m_pButBasics.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButBasics.ResizeToText();
	fYPos += fYOffset;
	m_pButShooting=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButShooting.ToolTipString=Localize("Tip","ButtonShooting","R6Menu");
	m_pButShooting.Text=Localize("Training","ButtonShooting","R6Menu");
	m_pButShooting.align=ta_left;
	m_pButShooting.m_buttonFont=m_LeftButtonFont;
	m_pButShooting.m_iButtonID=1;
	m_pButShooting.bIgnoreLDoubleClick=False;
	m_pButShooting.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButShooting.ResizeToText();
	fYPos += fYOffset;
	m_pButExplosives=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButExplosives.ToolTipString=Localize("Tip","ButtonExplosives","R6Menu");
	m_pButExplosives.Text=Localize("Training","ButtonExplosives","R6Menu");
	m_pButExplosives.align=ta_left;
	m_pButExplosives.m_buttonFont=m_LeftButtonFont;
	m_pButExplosives.m_iButtonID=2;
	m_pButExplosives.bIgnoreLDoubleClick=False;
	m_pButExplosives.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButExplosives.ResizeToText();
	fYPos += fYOffset;
	m_pButRoomClearing1=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButRoomClearing1.ToolTipString=Localize("Tip","ButtonClearing1","R6Menu");
	m_pButRoomClearing1.Text=Localize("Training","ButtonClearing1","R6Menu");
	m_pButRoomClearing1.align=ta_left;
	m_pButRoomClearing1.m_buttonFont=m_LeftButtonFont;
	m_pButRoomClearing1.m_iButtonID=3;
	m_pButRoomClearing1.bIgnoreLDoubleClick=False;
	m_pButRoomClearing1.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButRoomClearing1.ResizeToText();
	fYPos += fYOffset;
	m_pButRoomClearing2=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButRoomClearing2.ToolTipString=Localize("Tip","ButtonClearing2","R6Menu");
	m_pButRoomClearing2.Text=Localize("Training","ButtonClearing2","R6Menu");
	m_pButRoomClearing2.align=ta_left;
	m_pButRoomClearing2.m_buttonFont=m_LeftButtonFont;
	m_pButRoomClearing2.m_iButtonID=4;
	m_pButRoomClearing2.bIgnoreLDoubleClick=False;
	m_pButRoomClearing2.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButRoomClearing2.ResizeToText();
	fYPos += fYOffset;
	m_pButRoomClearing3=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButRoomClearing3.ToolTipString=Localize("Tip","ButtonClearing3","R6Menu");
	m_pButRoomClearing3.Text=Localize("Training","ButtonClearing3","R6Menu");
	m_pButRoomClearing3.align=ta_left;
	m_pButRoomClearing3.m_buttonFont=m_LeftButtonFont;
	m_pButRoomClearing3.m_iButtonID=5;
	m_pButRoomClearing3.bIgnoreLDoubleClick=False;
	m_pButRoomClearing3.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButRoomClearing3.ResizeToText();
	fYPos += fYOffset;
	m_pButHostageRescue1=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButHostageRescue1.ToolTipString=Localize("Tip","ButtonHostageRescue1","R6Menu");
	m_pButHostageRescue1.Text=Localize("Training","ButtonHostageRescue1","R6Menu");
	m_pButHostageRescue1.align=ta_left;
	m_pButHostageRescue1.m_buttonFont=m_LeftButtonFont;
	m_pButHostageRescue1.m_iButtonID=6;
	m_pButHostageRescue1.bIgnoreLDoubleClick=False;
	m_pButHostageRescue1.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButHostageRescue1.ResizeToText();
	fYPos += fYOffset;
	m_pButHostageRescue2=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButHostageRescue2.ToolTipString=Localize("Tip","ButtonHostageRescue2","R6Menu");
	m_pButHostageRescue2.Text=Localize("Training","ButtonHostageRescue2","R6Menu");
	m_pButHostageRescue2.align=ta_left;
	m_pButHostageRescue2.m_buttonFont=m_LeftButtonFont;
	m_pButHostageRescue2.m_iButtonID=7;
	m_pButHostageRescue2.bIgnoreLDoubleClick=False;
	m_pButHostageRescue2.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButHostageRescue2.ResizeToText();
	fYPos += fYOffset;
	m_pButHostageRescue3=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButHostageRescue3.ToolTipString=Localize("Tip","ButtonHostageRescue3","R6Menu");
	m_pButHostageRescue3.Text=Localize("Training","ButtonHostageRescue3","R6Menu");
	m_pButHostageRescue3.align=ta_left;
	m_pButHostageRescue3.m_buttonFont=m_LeftButtonFont;
	m_pButHostageRescue3.m_iButtonID=8;
	m_pButHostageRescue3.bIgnoreLDoubleClick=False;
	m_pButHostageRescue3.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButHostageRescue3.ResizeToText();
	CurrentSelectedButton(m_pButBasics);
}

function bool ButtonsUsingDownSizeFont ()
{
	local bool Result;

	if ( m_pButBasics.IsFontDownSizingNeeded() || m_pButShooting.IsFontDownSizingNeeded() || m_pButExplosives.IsFontDownSizingNeeded() || m_pButRoomClearing1.IsFontDownSizingNeeded() || m_pButRoomClearing2.IsFontDownSizingNeeded() || m_pButRoomClearing3.IsFontDownSizingNeeded() || m_pButHostageRescue1.IsFontDownSizingNeeded() || m_pButHostageRescue2.IsFontDownSizingNeeded() || m_pButHostageRescue3.IsFontDownSizingNeeded() )
	{
		Result=True;
	}
	return Result;
}

function ForceFontDownSizing ()
{
	m_pButBasics.m_buttonFont=m_LeftDownSizeFont;
	m_pButShooting.m_buttonFont=m_LeftDownSizeFont;
	m_pButExplosives.m_buttonFont=m_LeftDownSizeFont;
	m_pButRoomClearing1.m_buttonFont=m_LeftDownSizeFont;
	m_pButRoomClearing2.m_buttonFont=m_LeftDownSizeFont;
	m_pButRoomClearing3.m_buttonFont=m_LeftDownSizeFont;
	m_pButHostageRescue1.m_buttonFont=m_LeftDownSizeFont;
	m_pButHostageRescue2.m_buttonFont=m_LeftDownSizeFont;
	m_pButHostageRescue3.m_buttonFont=m_LeftDownSizeFont;
	m_pButBasics.ResizeToText();
	m_pButShooting.ResizeToText();
	m_pButExplosives.ResizeToText();
	m_pButRoomClearing1.ResizeToText();
	m_pButRoomClearing2.ResizeToText();
	m_pButRoomClearing3.ResizeToText();
	m_pButHostageRescue1.ResizeToText();
	m_pButHostageRescue2.ResizeToText();
	m_pButHostageRescue3.ResizeToText();
}

defaultproperties
{
    m_mapNames(0)="Training_basics"
    m_mapNames(1)="Training_shooting"
    m_mapNames(2)="Training_explosives"
    m_mapNames(3)="Training_RoomClear1"
    m_mapNames(4)="Training_RoomClear2"
    m_mapNames(5)="Training_RoomClear3"
    m_mapNames(6)="Training_Hostage1"
    m_mapNames(7)="Training_Hostage2"
    m_mapNames(8)="Training_Hostage3"
}
/*
    m_mapPreviews(0)=Texture'R6MenuBG.TrainingMenu.Training_basics'
    m_mapPreviews(1)=Texture'R6MenuBG.TrainingMenu.Training_shooting'
    m_mapPreviews(2)=Texture'R6MenuBG.TrainingMenu.Training_explosives'
    m_mapPreviews(3)=Texture'R6MenuBG.TrainingMenu.Training_RoomClear1'
    m_mapPreviews(4)=Texture'R6MenuBG.TrainingMenu.Training_RoomClear2'
    m_mapPreviews(5)=Texture'R6MenuBG.TrainingMenu.Training_RoomClear3'
    m_mapPreviews(6)=Texture'R6MenuBG.TrainingMenu.Training_Hostage1'
    m_mapPreviews(7)=Texture'R6MenuBG.TrainingMenu.Training_Hostage2'
    m_mapPreviews(8)=Texture'R6MenuBG.TrainingMenu.Training_Hostage3'
*/

