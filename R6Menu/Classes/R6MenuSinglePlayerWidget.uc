//================================================================================
// R6MenuSinglePlayerWidget.
//================================================================================
class R6MenuSinglePlayerWidget extends R6MenuWidget;

enum ECampaignButID {
	ButtonResumeID,
	ButtonNewID,
	ButtonDeleteID,
	ButtonAccept
};

enum eWidgetID {
	CampaignSelect,
	CampaignCreate
};

var int m_iFont;
var int m_iSelectedButtonID;
var bool bShowLog;
var R6WindowButton m_ButtonMainMenu;
var R6WindowButton m_ButtonOptions;
var R6WindowButton m_ButtonStart;
var R6WindowSimpleFramedWindow m_Map;
var R6WindowTextLabel m_LMenuTitle;
var R6MenuSinglePlayerCampaignSelect m_CampaignSelect;
var R6WindowSimpleCurvedFramedWindow m_CampaignCreate;
var R6MenuHelpWindow m_pHelpWindow;
var R6FileManagerCampaign m_pFileManager;
var R6WindowSimpleFramedWindow m_CampaignDescription;
var R6WindowButton m_pButResumeCampaign;
var R6WindowButton m_pButNewCampaign;
var R6WindowButton m_pButDelCampaign;
var R6WindowButton m_pButCurrent;
var Font m_LeftButtonFont;
var Font m_LeftDownSizeFont;
var Color m_HelpTextColor;
var string m_ButtonStartText[2];
var string m_ButtonStartHelpText[2];

function Created ()
{
	local Font ButtonFont;
	local UWindowWrappedTextArea localHelpZone;
	local int XPos;

	m_pFileManager=new Class'R6FileManagerCampaign';
	ButtonFont=Root.Fonts[15];
	m_ButtonStartText[0]=Localize("CustomMission","ButtonStart1","R6Menu");
	m_ButtonStartText[1]=Localize("CustomMission","ButtonStart2","R6Menu");
	m_ButtonStartHelpText[0]=Localize("Tip","ButtonStart","R6Menu");
	m_ButtonStartHelpText[1]=Localize("Tip","ButtonDelete","R6Menu");
	m_HelpTextColor=Root.Colors.GrayLight;
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
	m_ButtonStart.ToolTipString=m_ButtonStartHelpText[0];
	m_ButtonStart.Text=m_ButtonStartText[0];
	m_ButtonStart.align=ta_right;
	m_ButtonStart.m_buttonFont=ButtonFont;
	m_ButtonStart.ResizeToText();
	m_ButtonStart.m_iButtonID=3;
	m_ButtonStart.m_bWaitSoundFinish=True;
	m_Map=R6WindowSimpleFramedWindow(CreateWindow(Class'R6WindowSimpleFramedWindow',390.00,268.00,230.00,130.00,self));
	m_Map.CreateClientWindow(Class'R6WindowBitMap');
//	m_Map.m_eCornerType=3;
	m_Map.HideWindow();
	m_LMenuTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,18.00,WinWidth - 8,25.00,self));
	m_LMenuTitle.Text=Localize("SinglePlayer","Title","R6Menu");
	m_LMenuTitle.align=ta_right;
	m_LMenuTitle.m_Font=Root.Fonts[4];
	m_LMenuTitle.TextColor=Root.Colors.White;
	m_LMenuTitle.m_BGTexture=None;
	m_LMenuTitle.m_bDrawBorders=False;
	m_CampaignSelect=R6MenuSinglePlayerCampaignSelect(CreateWindow(Class'R6MenuSinglePlayerCampaignSelect',198.00,72.00,156.00,327.00,self));
	m_CampaignSelect.HideWindow();
	m_CampaignCreate=R6WindowSimpleCurvedFramedWindow(CreateWindow(Class'R6WindowSimpleCurvedFramedWindow',m_CampaignSelect.WinLeft,m_CampaignSelect.WinTop,m_CampaignSelect.WinWidth,326.00,self));
	m_CampaignCreate.CreateClientWindow(Class'R6MenuSinglePlayerCampaignCreate');
	m_CampaignCreate.m_Title=Localize("SinglePlayer","TitleCampaign","R6Menu");
	m_CampaignCreate.m_Titlealign=ta_center;
	m_CampaignCreate.m_Font=Root.Fonts[8];
	m_CampaignCreate.m_TextColor=Root.Colors.White;
//	m_CampaignCreate.SetCornerType(3);
	m_CampaignDescription=R6WindowSimpleFramedWindow(CreateWindow(Class'R6WindowSimpleFramedWindow',m_Map.WinLeft,m_CampaignSelect.WinTop,m_Map.WinWidth,122.00,self));
	m_CampaignDescription.CreateClientWindow(Class'R6MenuCampaignDescription');
//	m_CampaignDescription.SetCornerType(3);
}

function ShowWindow ()
{
	Super.ShowWindow();
	m_CampaignSelect.RefreshListBox();
	if ( m_CampaignSelect.m_CampaignListBox.Items.Count() == 0 )
	{
//		switchWidget(1);
//		SetCurrentBut(1);
	}
	else
	{
//		switchWidget(0);
//		SetCurrentBut(0);
	}
}

function HideWindow ()
{
	Super.HideWindow();
	m_CampaignSelect.m_CampaignListBox.Clear();
}

function switchWidget (eWidgetID newWidget)
{
	switch (newWidget)
	{
/*		case 0:
		m_CampaignCreate.HideWindow();
		m_CampaignSelect.ShowWindow();
		m_CampaignDescription.ShowWindow();
		m_Map.ShowWindow();
		break;
		case 1:
		m_CampaignSelect.HideWindow();
		m_CampaignCreate.ShowWindow();
		R6MenuSinglePlayerCampaignCreate(m_CampaignCreate.m_ClientArea).Reset();
		m_ButtonStart.ToolTipString=m_ButtonStartHelpText[0];
		m_ButtonStart.Text=m_ButtonStartText[0];
		m_ButtonStart.ResizeToText();
		m_iSelectedButtonID=1;
		m_CampaignDescription.HideWindow();
		m_Map.HideWindow();
		break;
		default:*/
	}
}

function ButtonClicked (int ButtonID)
{
	if ( ButtonID != m_iSelectedButtonID )
	{
		switch (ButtonID)
		{
			case 0:
			if ( m_CampaignSelect.m_CampaignListBox.Items.Count() == 0 )
			{
				goto JL02A9;
			}
			if ( m_iSelectedButtonID == 1 )
			{
//				switchWidget(0);
			}
			m_ButtonStart.ToolTipString=m_ButtonStartHelpText[0];
			m_ButtonStart.Text=m_ButtonStartText[0];
			m_ButtonStart.ResizeToText();
			m_iSelectedButtonID=ButtonID;
			break;
			case 1:
//			switchWidget(1);
			break;
			case 2:
			if ( m_CampaignSelect.m_CampaignListBox.Items.Count() == 0 )
			{
				goto JL02A9;
			}
			if ( m_iSelectedButtonID == 1 )
			{
//				switchWidget(0);
			}
			m_ButtonStart.ToolTipString=m_ButtonStartHelpText[1];
			m_ButtonStart.Text=m_ButtonStartText[1];
			m_ButtonStart.ResizeToText();
			m_iSelectedButtonID=ButtonID;
			break;
			case 3:
			switch (m_iSelectedButtonID)
			{
				case 0:
				if ( m_CampaignSelect.SetupCampaign() )
				{
					Root.ResetMenus();
//					Root.ChangeCurrentWidget(6);
				}
				break;
				case 1:
				if ( CampaignExists() )
				{
//					R6MenuRootWindow(Root).SimplePopUp(Localize("POPUP","CAMPAIGNEXISTTITLE","R6Menu"),Localize("POPUP","CAMPAIGNEXISTMSG","R6Menu"),38);
				}
				else
				{
					TryCreatingCampaign();
				}
				break;
				case 2:
				if ( m_CampaignSelect.m_CampaignListBox.m_SelectedItem != None )
				{
//					R6MenuRootWindow(Root).SimplePopUp(Localize("SinglePlayer","ButtonDelete","R6Menu"),Localize("POPUP","DELETECAMPAIGN","R6Menu"),37);
				}
				break;
				default:
			}
			break;
			default:
		}
JL02A9:
		SetCurrentBut(m_iSelectedButtonID);
	}
}

function bool CampaignExists ()
{
	local string temp;
	local string szDir;
	local R6MenuSinglePlayerCampaignCreate R6PCC;

	R6PCC=R6MenuSinglePlayerCampaignCreate(m_CampaignCreate.m_ClientArea);
	szDir="..\\save\\campaigns\\" $ Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szCampaignDir $ "\\";
	temp=szDir $ R6PCC.m_CampaignNameEdit.GetValue() $ ".cmp";
	return m_pFileManager.FindFile(temp);
}

function TryCreatingCampaign ()
{
	if ( R6MenuSinglePlayerCampaignCreate(m_CampaignCreate.m_ClientArea).CreateCampaign() )
	{
		Root.ResetMenus();
//		Root.ChangeCurrentWidget(6);
	}
}

function DeleteCurrentSelectedCampaign ()
{
	m_CampaignSelect.DeleteCampaign();
	if ( m_CampaignSelect.m_CampaignListBox.Items.Count() == 0 )
	{
//		switchWidget(1);
//		SetCurrentBut(1);
	}
}

function UpdateSelectedCampaign (R6PlayerCampaign _PlayerCampaign)
{
	local R6MenuCampaignDescription tempVar;
	local R6Campaign CampaignType;
	local R6MissionDescription CurrentMission;
	local R6WindowBitMap mapBitmap;

	tempVar=R6MenuCampaignDescription(m_CampaignDescription.m_ClientArea);
	mapBitmap=R6WindowBitMap(m_Map.m_ClientArea);
	if ( _PlayerCampaign == None )
	{
		tempVar.m_MissionValue.Text="";
		tempVar.m_NameValue.Text="";
		tempVar.m_DifficultyValue.Text="";
		mapBitmap.t=None;
		return;
	}
	CampaignType=new Class'R6Campaign';
	CampaignType.Init(GetLevel(),_PlayerCampaign.m_CampaignFileName,R6Console(Root.Console));
	CurrentMission=CampaignType.m_missions[_PlayerCampaign.m_iNoMission];
	tempVar.m_MissionValue.SetNewText(string(_PlayerCampaign.m_iNoMission + 1),True);
	tempVar.m_NameValue.SetNewText(Localize(CurrentMission.m_MapName,"ID_CODENAME",CurrentMission.LocalizationFile),True);
	tempVar.m_DifficultyValue.SetNewText(Localize("SinglePlayer","Difficulty" $ string(_PlayerCampaign.m_iDifficultyLevel),"R6Menu"),True);
	mapBitmap.R=CurrentMission.m_RMissionOverview;
	mapBitmap.t=CurrentMission.m_TMissionOverview;
}

function KeyDown (int Key, float X, float Y)
{
	Super.KeyDown(Key,X,Y);
/*	if ( Key == Root.Console.13 )
	{
		ButtonClicked(3);
	}*/
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
			default:
		}
		if ( R6WindowButton(C) != None )
		{
			ButtonClicked(R6WindowButton(C).m_iButtonID);
		}
	}
	else
	{
	}
}

function ToolTip (string strTip)
{
	m_pHelpWindow.ToolTip(strTip);
}

function Paint (Canvas C, float X, float Y)
{
	Root.PaintBackground(C,self);
}

function CreateButtons ()
{
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local float fHeight;
	local float fYPos;

	fXOffset=10.00;
	fYPos=64.00;
	fYOffset=26.00;
	fWidth=200.00;
	fHeight=25.00;
	m_pButResumeCampaign=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButResumeCampaign.ToolTipString=Localize("Tip","ButtonResumeCampaign","R6Menu");
	m_pButResumeCampaign.Text=Localize("SinglePlayer","ButtonResume","R6Menu");
	m_pButResumeCampaign.m_iButtonID=0;
	m_pButResumeCampaign.align=ta_left;
	m_pButResumeCampaign.m_buttonFont=m_LeftButtonFont;
	m_pButResumeCampaign.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButResumeCampaign.ResizeToText();
	m_pButResumeCampaign.m_bSelected=True;
	fYPos += fYOffset;
	m_pButNewCampaign=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButNewCampaign.ToolTipString=Localize("Tip","ButtonNewCampaign","R6Menu");
	m_pButNewCampaign.Text=Localize("SinglePlayer","ButtonNew","R6Menu");
	m_pButNewCampaign.m_iButtonID=1;
	m_pButNewCampaign.align=ta_left;
	m_pButNewCampaign.m_buttonFont=m_LeftButtonFont;
	m_pButNewCampaign.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButNewCampaign.ResizeToText();
	fYPos += fYOffset;
	m_pButDelCampaign=R6WindowButton(CreateControl(Class'R6WindowButton',fXOffset,fYPos,fWidth,fHeight,self));
	m_pButDelCampaign.ToolTipString=Localize("Tip","ButtonDeleteCampaign","R6Menu");
	m_pButDelCampaign.Text=Localize("SinglePlayer","ButtonDelete","R6Menu");
	m_pButDelCampaign.m_iButtonID=2;
	m_pButDelCampaign.align=ta_left;
	m_pButDelCampaign.m_buttonFont=m_LeftButtonFont;
	m_pButDelCampaign.CheckToDownSizeFont(m_LeftDownSizeFont,0.00);
	m_pButDelCampaign.ResizeToText();
	m_pButCurrent=m_pButResumeCampaign;
}

function bool ButtonsUsingDownSizeFont ()
{
	local bool Result;

	if ( m_pButResumeCampaign.IsFontDownSizingNeeded() || m_pButNewCampaign.IsFontDownSizingNeeded() || m_pButDelCampaign.IsFontDownSizingNeeded() )
	{
		Result=True;
	}
	return Result;
}

function ForceFontDownSizing ()
{
	m_pButResumeCampaign.m_buttonFont=m_LeftDownSizeFont;
	m_pButNewCampaign.m_buttonFont=m_LeftDownSizeFont;
	m_pButDelCampaign.m_buttonFont=m_LeftDownSizeFont;
	m_pButResumeCampaign.ResizeToText();
	m_pButNewCampaign.ResizeToText();
	m_pButDelCampaign.ResizeToText();
}

function SetCurrentBut (int _iNewCurBut)
{
	m_pButCurrent.m_bSelected=False;
	m_iSelectedButtonID=_iNewCurBut;
	switch (_iNewCurBut)
	{
		case 0:
		m_pButCurrent=m_pButResumeCampaign;
		Root.SetLoadRandomBackgroundImage("CampResume");
		break;
		case 1:
		m_pButCurrent=m_pButNewCampaign;
		Root.SetLoadRandomBackgroundImage("CampNew");
		break;
		case 2:
		m_pButCurrent=m_pButDelCampaign;
		Root.SetLoadRandomBackgroundImage("CampResume");
		break;
		default:
	}
	m_pButCurrent.m_bSelected=True;
}
