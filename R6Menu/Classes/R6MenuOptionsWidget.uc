//================================================================================
// R6MenuOptionsWidget.
//================================================================================
class R6MenuOptionsWidget extends R6MenuWidget;

enum eOptionsWindow {
	OW_Game,
	OW_Sound,
	OW_Graphic,
	OW_Hud,
	OW_Multiplayer,
	OW_Controls,
	OW_MOD
};

var bool m_bInGame;
var R6WindowTextLabelCurved m_pOptionsTextLabel;
var R6WindowTextLabel m_LMenuTitle;
var R6WindowSimpleFramedWindowExt m_pOptionsBorder;
var R6MenuHelpWindow m_pHelpWindow;
var R6WindowButtonOptions m_ButtonReturn;
var R6WindowButtonOptions m_ButtonGame;
var R6WindowButtonOptions m_ButtonSound;
var R6WindowButtonOptions m_ButtonGraphic;
var R6WindowButtonOptions m_ButtonHudFilter;
var R6WindowButtonOptions m_ButtonMultiPlayer;
var R6WindowButtonOptions m_ButtonControls;
var R6WindowButtonOptions m_ButtonMODS;
var R6MenuOptionsTab m_pOptionsGame;
var R6MenuOptionsTab m_pOptionsSound;
var R6MenuOptionsTab m_pOptionsGraphic;
var R6MenuOptionsTab m_pOptionsHud;
var R6MenuOptionsTab m_pOptionsMulti;
var R6MenuOptionsTab m_pOptionsControls;
var R6MenuOptionsTab m_pOptionsMODS;
var R6MenuOptionsTab m_pOptionCurrent;
var R6WindowPopUpBox m_pSimplePopUp;
const C_iARBITRARY_COUNTER= 10;
const C_fHEIGHT_OF_LABELW= 30;
const C_fWINDOWHEIGHT= 321;
const C_fWINDOWWIDTH= 422;
const C_fYSTARTPOS= 101;
const C_fXSTARTPOS= 198;

function Created ()
{
	if ( (R6MenuInGameMultiPlayerRootWindow(Root) != None) || (R6MenuInGameRootWindow(Root) != None) )
	{
		m_bInGame=True;
	}
	InitTitle();
	InitOptionsWindow();
	InitOptionsButtons();
	m_pHelpWindow=R6MenuHelpWindow(CreateWindow(Class'R6MenuHelpWindow',150.00,429.00,340.00,42.00,self));
}

function Paint (Canvas C, float X, float Y)
{
	Root.PaintBackground(C,self);
	if ( m_ButtonGraphic.m_bSelected )
	{
//		C.Style=5;
//		DrawStretchedTextureSegment(C,544.00,436.00,64.00,64.00,0.00,0.00,64.00,64.00,Texture'ATI_menus');
	}
}

function ShowWindow ()
{
	Root.SetLoadRandomBackgroundImage("Option");
	if (  !m_bInGame )
	{
		m_ButtonMODS.bDisabled=R6MenuRootWindow(Root).IsInsidePlanning() || R6Console(Root.Console).m_bStartedByGSClient;
		if ( m_ButtonMODS.bDisabled && (m_pOptionCurrent == m_pOptionsMODS) )
		{
			ManageOptionsSelection(0);
		}
	}
	Super.ShowWindow();
}

function HideWindow ()
{
	Super.HideWindow();
	Root.ActivateWindow(0,False);
}

function SimplePopUp (string _szTitle, string _szText, EPopUpID _ePopUpID, optional int _iButtonsType)
{
	local R6WindowWrappedTextArea pTextZone;

	if ( m_pSimplePopUp == None )
	{
		m_pSimplePopUp=R6WindowPopUpBox(CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,640.00,480.00));
		m_pSimplePopUp.bAlwaysOnTop=True;
		m_pSimplePopUp.CreateStdPopUpWindow(_szTitle,25.00,170.00,100.00,300.00,80.00,_iButtonsType);
		m_pSimplePopUp.CreateClientWindow(Class'R6WindowWrappedTextArea');
		m_pSimplePopUp.m_ePopUpID=_ePopUpID;
		pTextZone=R6WindowWrappedTextArea(m_pSimplePopUp.m_ClientArea);
		pTextZone.SetScrollable(True);
		pTextZone.m_fXOffSet=5.00;
		pTextZone.m_fYOffSet=5.00;
		pTextZone.AddText(_szText,Root.Colors.White,Root.Fonts[12]);
		pTextZone.m_bDrawBorders=False;
	}
	else
	{
		pTextZone=R6WindowWrappedTextArea(m_pSimplePopUp.m_ClientArea);
		pTextZone.Clear(True,True);
		pTextZone.AddText(_szText,Root.Colors.White,Root.Fonts[12]);
		m_pSimplePopUp.ModifyPopUpFrameWindow(_szTitle,25.00,170.00,100.00,300.00,80.00,_iButtonsType);
		m_pSimplePopUp.m_ePopUpID=_ePopUpID;
		m_pSimplePopUp.ShowWindow();
	}
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	if ( Result == 3 )
	{
		switch (_ePopUpID)
		{
/*			case 50:
			m_pOptionCurrent.RestoreDefaultValue(m_bInGame);
			break;
			default:*/
		}
	}
}

function ToolTip (string strTip)
{
	m_pHelpWindow.ToolTip(strTip);
}

function ManageOptionsSelection (int _OptionsChoice)
{
	if ( m_pOptionCurrent != None )
	{
		m_pOptionCurrent.HideWindow();
	}
	SetOptionsTitle(_OptionsChoice);
	m_ButtonGame.m_bSelected=False;
	m_ButtonSound.m_bSelected=False;
	m_ButtonGraphic.m_bSelected=False;
	m_ButtonHudFilter.m_bSelected=False;
	m_ButtonMultiPlayer.m_bSelected=False;
	m_ButtonControls.m_bSelected=False;
	m_ButtonMODS.m_bSelected=False;
	switch (_OptionsChoice)
	{
		case 0:
		m_pOptionCurrent=m_pOptionsGame;
		m_ButtonGame.m_bSelected=True;
		break;
		case 1:
		m_pOptionCurrent=m_pOptionsSound;
		m_ButtonSound.m_bSelected=True;
		break;
		case 2:
		m_pOptionCurrent=m_pOptionsGraphic;
		m_ButtonGraphic.m_bSelected=True;
		break;
		case 3:
		m_pOptionCurrent=m_pOptionsHud;
		m_ButtonHudFilter.m_bSelected=True;
		break;
		case 4:
		m_pOptionCurrent=m_pOptionsMulti;
		m_ButtonMultiPlayer.m_bSelected=True;
		break;
		case 5:
		m_pOptionCurrent=m_pOptionsControls;
		m_ButtonControls.m_bSelected=True;
		break;
		case 6:
		m_pOptionCurrent=m_pOptionsMODS;
		m_ButtonMODS.m_bSelected=True;
		break;
		default:
		m_pOptionCurrent=None;
		Log("No options window supported");
		break;
	}
	if ( m_pOptionCurrent != None )
	{
		m_pOptionCurrent.ShowWindow();
	}
}

function SetOptionsTitle (int _OptionsChoice)
{
	local string szTitle;

	switch (_OptionsChoice)
	{
		case 0:
		szTitle=Localize("Options","ButtonGame","R6Menu");
		break;
		case 1:
		szTitle=Localize("Options","ButtonSound","R6Menu");
		break;
		case 2:
		szTitle=Localize("Options","ButtonGraphic","R6Menu");
		break;
		case 3:
		szTitle=Localize("Options","ButtonHud","R6Menu");
		break;
		case 4:
		szTitle=Localize("Options","ButtonMultiPlayer","R6Menu");
		break;
		case 5:
		szTitle=Localize("Options","ButtonControls","R6Menu");
		break;
		case 6:
		szTitle=Localize("Options","ButtonCustomGame","R6Menu");
		break;
		default:
		szTitle="";
		break;
	}
	if ( m_pOptionsTextLabel != None )
	{
		m_pOptionsTextLabel.SetNewText(szTitle,True);
	}
}

function UpdateOptions ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	m_pOptionsGame.SetGameValues();
	m_pOptionsSound.SetSoundValues();
	pGameOptions.m_bChangeResolution=m_bInGame &&  !Root.m_bWidgetResolutionFix;
	m_pOptionsGraphic.SetGraphicValues();
	m_pOptionsHud.SetHudValues();
	m_pOptionsMulti.SetMultiValues();
	pGameOptions.SaveConfig();
	GetPlayerOwner().SetSoundOptions();
	GetPlayerOwner().UpdateOptions();
	if ( m_bInGame )
	{
		R6HUD(GetPlayerOwner().myHUD).UpdateHudFilter();
		if (  !Root.m_bWidgetResolutionFix )
		{
			Root.SetResolution(pGameOptions.R6ScreenSizeX,pGameOptions.R6ScreenSizeY);
		}
	}
}

function RefreshOptions ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	m_pOptionsGame.SetMenuGameValues();
	m_pOptionsSound.SetMenuSoundValues();
	m_pOptionsGraphic.SetMenuGraphicValues();
	m_pOptionsHud.SetMenuHudValues();
	m_pOptionsMulti.SetMenuMultiValues();
	m_pOptionsControls.RefreshKeyList();
}

function MenuOptionsLoadProfile ()
{
	RefreshOptions();
	UpdateOptions();
}

function InitTitle ()
{
	m_LMenuTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,18.00,WinWidth - 8,25.00,self));
	m_LMenuTitle.Text=Localize("Options","Title","R6Menu");
	m_LMenuTitle.align=ta_right;
	m_LMenuTitle.m_Font=Root.Fonts[4];
	m_LMenuTitle.m_BGTexture=None;
	m_LMenuTitle.m_bDrawBorders=False;
}

function InitOptionsWindow ()
{
	Class'Actor'.static.GetGameOptions().m_bChangeResolution=m_bInGame;
	m_pOptionsTextLabel=R6WindowTextLabelCurved(CreateWindow(Class'R6WindowTextLabelCurved',198.00,101.00 - 30 + 1,422.00,30.00,self));
	m_pOptionsTextLabel.bAlwaysBehind=True;
	m_pOptionsTextLabel.align=ta_center;
	m_pOptionsTextLabel.m_Font=Root.Fonts[5];
	SetOptionsTitle(0);
	m_pOptionsBorder=R6WindowSimpleFramedWindowExt(CreateWindow(Class'R6WindowSimpleFramedWindowExt',198.00,101.00,422.00,321.00,self));
	m_pOptionsBorder.bAlwaysBehind=True;
	m_pOptionsBorder.ActiveBorder(0,False);
	m_pOptionsBorder.SetBorderParam(1,7.00,0.00,1.00,Root.Colors.White);
	m_pOptionsBorder.SetBorderParam(2,1.00,1.00,1.00,Root.Colors.White);
	m_pOptionsBorder.SetBorderParam(3,1.00,1.00,1.00,Root.Colors.White);
//	m_pOptionsBorder.m_eCornerType=2;
	m_pOptionsBorder.SetCornerColor(2,Root.Colors.White);
	m_pOptionsBorder.ActiveBackGround(True,Root.Colors.Black);
	m_pOptionsGame=R6MenuOptionsTab(CreateWindow(Class'R6MenuOptionsTab',198.00 + m_pOptionsBorder.m_fVBorderOffset,101.00,422.00 - 2 * m_pOptionsBorder.m_fVBorderOffset,321.00,self));
	m_pOptionsGame.InitOptionGame();
	m_pOptionsSound=R6MenuOptionsTab(CreateWindow(Class'R6MenuOptionsTab',198.00 + m_pOptionsBorder.m_fVBorderOffset,101.00,422.00 - 2 * m_pOptionsBorder.m_fVBorderOffset,321.00,self));
	m_pOptionsSound.InitOptionSound(m_bInGame);
	m_pOptionsSound.HideWindow();
	m_pOptionsGraphic=R6MenuOptionsTab(CreateWindow(Class'R6MenuOptionsTab',198.00 + m_pOptionsBorder.m_fVBorderOffset,101.00,422.00 - 2 * m_pOptionsBorder.m_fVBorderOffset,321.00,self));
	m_pOptionsGraphic.InitOptionGraphic(m_bInGame);
	m_pOptionsGraphic.HideWindow();
	m_pOptionsHud=R6MenuOptionsTab(CreateWindow(Class'R6MenuOptionsTab',198.00 + m_pOptionsBorder.m_fVBorderOffset,101.00,422.00 - 2 * m_pOptionsBorder.m_fVBorderOffset,321.00,self));
	m_pOptionsHud.InitOptionHud();
	m_pOptionsHud.HideWindow();
	m_pOptionsMulti=R6MenuOptionsTab(CreateWindow(Class'R6MenuOptionsTab',198.00 + m_pOptionsBorder.m_fVBorderOffset,101.00,422.00 - 2 * m_pOptionsBorder.m_fVBorderOffset,321.00,self));
	m_pOptionsMulti.InitOptionMulti(m_bInGame);
	m_pOptionsMulti.HideWindow();
	m_pOptionsControls=R6MenuOptionsTab(CreateWindow(Class'R6MenuOptionsTab',198.00 + m_pOptionsBorder.m_fVBorderOffset,101.00,422.00 - 2 * m_pOptionsBorder.m_fVBorderOffset,321.00,self));
	m_pOptionsControls.InitOptionControls();
	m_pOptionsControls.HideWindow();
	m_pOptionsMODS=R6MenuOptionsTab(CreateWindow(Class'R6MenuOptionsTab',198.00 + m_pOptionsBorder.m_fVBorderOffset,101.00,422.00 - 2 * m_pOptionsBorder.m_fVBorderOffset,321.00,self));
	m_pOptionsMODS.InitOptionMODS();
	m_pOptionsMODS.HideWindow();
	m_pOptionCurrent=m_pOptionsGame;
}

function InitOptionsButtons ()
{
	local Font ButtonFont;
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local float fHeight;
	local float fYPos;

	ButtonFont=Root.Fonts[16];
	m_ButtonReturn=R6WindowButtonOptions(CreateWindow(Class'R6WindowButtonOptions',10.00,425.00,250.00,25.00,self));
	m_ButtonReturn.ToolTipString=Localize("Tip","ButtonReturn","R6Menu");
	m_ButtonReturn.Text=Localize("Options","ButtonReturn","R6Menu");
//	m_ButtonReturn.m_eButton_Action=7;
	m_ButtonReturn.align=ta_left;
	m_ButtonReturn.m_buttonFont=ButtonFont;
	m_ButtonReturn.ResizeToText();
	fXOffset=10.00;
	fYPos=64.00;
	fYOffset=26.00;
	fWidth=640.00 - 422;
	fHeight=25.00;
	m_ButtonGame=R6WindowButtonOptions(CreateWindow(Class'R6WindowButtonOptions',fXOffset,fYPos,fWidth,fHeight,self));
	m_ButtonGame.ToolTipString=Localize("Tip","ButtonGame","R6Menu");
	m_ButtonGame.Text=Localize("Options","ButtonGame","R6Menu");
//	m_ButtonGame.m_eButton_Action=0;
	m_ButtonGame.align=ta_left;
	m_ButtonGame.m_buttonFont=ButtonFont;
	m_ButtonGame.ResizeToText();
	m_ButtonGame.m_bSelected=True;
	fYPos += fYOffset;
	m_ButtonSound=R6WindowButtonOptions(CreateWindow(Class'R6WindowButtonOptions',fXOffset,fYPos,fWidth,fHeight,self));
	m_ButtonSound.ToolTipString=Localize("Tip","ButtonSound","R6Menu");
	m_ButtonSound.Text=Localize("Options","ButtonSound","R6Menu");
//	m_ButtonSound.m_eButton_Action=1;
	m_ButtonSound.align=ta_left;
	m_ButtonSound.m_buttonFont=ButtonFont;
	m_ButtonSound.ResizeToText();
	fYPos += fYOffset;
	m_ButtonGraphic=R6WindowButtonOptions(CreateWindow(Class'R6WindowButtonOptions',fXOffset,fYPos,fWidth,fHeight,self));
	m_ButtonGraphic.ToolTipString=Localize("Tip","ButtonGraphic","R6Menu");
	m_ButtonGraphic.Text=Localize("Options","ButtonGraphic","R6Menu");
//	m_ButtonGraphic.m_eButton_Action=2;
	m_ButtonGraphic.align=ta_left;
	m_ButtonGraphic.m_buttonFont=ButtonFont;
	m_ButtonGraphic.ResizeToText();
	fYPos += fYOffset;
	m_ButtonHudFilter=R6WindowButtonOptions(CreateWindow(Class'R6WindowButtonOptions',fXOffset,fYPos,fWidth,fHeight,self));
	m_ButtonHudFilter.ToolTipString=Localize("Tip","ButtonHud","R6Menu");
	m_ButtonHudFilter.Text=Localize("Options","ButtonHud","R6Menu");
//	m_ButtonHudFilter.m_eButton_Action=3;
	m_ButtonHudFilter.align=ta_left;
	m_ButtonHudFilter.m_buttonFont=ButtonFont;
	m_ButtonHudFilter.ResizeToText();
	fYPos += fYOffset;
	m_ButtonMultiPlayer=R6WindowButtonOptions(CreateWindow(Class'R6WindowButtonOptions',fXOffset,fYPos,fWidth,fHeight,self));
	m_ButtonMultiPlayer.ToolTipString=Localize("Tip","ButtonMultiPlayer","R6Menu");
	m_ButtonMultiPlayer.Text=Localize("Options","ButtonMultiPlayer","R6Menu");
//	m_ButtonMultiPlayer.m_eButton_Action=4;
	m_ButtonMultiPlayer.align=ta_left;
	m_ButtonMultiPlayer.m_buttonFont=ButtonFont;
	m_ButtonMultiPlayer.ResizeToText();
	fYPos += fYOffset;
	m_ButtonControls=R6WindowButtonOptions(CreateWindow(Class'R6WindowButtonOptions',fXOffset,fYPos,fWidth,fHeight,self));
	m_ButtonControls.ToolTipString=Localize("Tip","ButtonControls","R6Menu");
	m_ButtonControls.Text=Localize("Options","ButtonControls","R6Menu");
//	m_ButtonControls.m_eButton_Action=5;
	m_ButtonControls.align=ta_left;
	m_ButtonControls.m_buttonFont=ButtonFont;
	m_ButtonControls.ResizeToText();
	fYPos += fYOffset;
	m_ButtonMODS=R6WindowButtonOptions(CreateWindow(Class'R6WindowButtonOptions',fXOffset,fYPos,fWidth,fHeight,self));
	m_ButtonMODS.ToolTipString=Localize("Tip","ButtonCustomGame","R6Menu");
	m_ButtonMODS.Text=Localize("Options","ButtonCustomGame","R6Menu");
//	m_ButtonMODS.m_eButton_Action=6;
	m_ButtonMODS.align=ta_left;
	m_ButtonMODS.m_buttonFont=ButtonFont;
	m_ButtonMODS.ResizeToText();
	m_ButtonMODS.bDisabled=m_bInGame;
}
