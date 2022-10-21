//================================================================================
// R6MenuIntelWidget.
//================================================================================
class R6MenuIntelWidget extends R6MenuLaptopWidget;

var int m_iCurrentSpeaker;
var bool m_bAddText;
var bool bShowLog;
var float m_fLaptopPadding;
var float m_fPaddingBetweenElements;
var float m_fVideoLeft;
var float m_fVideoRight;
var float m_fVideoTop;
var float m_fVideoBottom;
var float m_fLabelHeight;
var float m_fSpeakerWidgetWidth;
var float m_fSpeakerWidgetHeight;
var float m_fRightTileModulo;
var float m_fLeftTileModulo;
var float m_fBottomTileModulo;
var float m_fRightBGWidth;
var float m_fUpBGWidth;
var float m_fBottomHeight;
var R6WindowWrappedTextArea m_SrcrollingTextArea;
var R6WindowWrappedTextArea m_MissionObjectives;
var R6MenuVideo m_MissionDesc;
var R6WindowBitMap m_2DSpeaker;
var Texture m_TSpeaker;
var R6MenuIntelRadioArea m_SpeakerControls;
var R6WindowTextLabel m_CodeName;
var R6WindowTextLabel m_DateTime;
var R6WindowTextLabel m_Location;
var Texture m_Texture;
var Font m_labelFont;
var Font m_R6Font14;
var Sound m_sndPlayEvent;
var Region m_RControl;
var Region m_RClark;
var Region m_RSweeney;
var Region m_RNewsWire;
var Region m_RMissionOrder;
var string m_szScrollingText;
const K_fVideoHeight= 230;
const K_fVideoWidth= 438;
const szScrollTextArraySize= 10;
enum EMenuIntelButtonID {
	ButtonControlID,
	ButtonClarkID,
	ButtonSweenyID,
	ButtonNewsID,
	ButtonMissionID
};


function Created ()
{
	local int labelWidth;

	Super.Created();
	m_Texture=Texture(DynamicLoadObject("R6MenuTextures.Gui_BoxScroll",Class'Texture'));
	m_labelFont=Root.Fonts[9];
	m_R6Font14=Root.Fonts[5];
	labelWidth=(m_Right.WinLeft - m_Left.WinWidth) / 3;
	m_CodeName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_Left.WinWidth,m_Top.WinHeight,labelWidth,m_fLabelHeight,self));
	m_DateTime=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_CodeName.WinLeft + m_CodeName.WinWidth,m_Top.WinHeight,labelWidth,m_fLabelHeight,self));
	m_Location=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_DateTime.WinLeft + m_DateTime.WinWidth,m_Top.WinHeight,m_DateTime.WinWidth,m_fLabelHeight,self));
	m_2DSpeaker=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',m_Left.WinWidth + m_fLaptopPadding,m_CodeName.WinTop + m_fLabelHeight,m_fSpeakerWidgetWidth,m_fSpeakerWidgetHeight,self));
	m_2DSpeaker.m_bDrawBorder=True;
	m_2DSpeaker.m_BorderColor=Root.Colors.GrayLight;
	m_2DSpeaker.t=m_TSpeaker;
	m_SpeakerControls=R6MenuIntelRadioArea(CreateWindow(Class'R6MenuIntelRadioArea',m_2DSpeaker.WinLeft,m_2DSpeaker.WinTop + m_2DSpeaker.WinHeight,m_2DSpeaker.WinWidth,230.00 - m_2DSpeaker.WinHeight,self));
	m_SpeakerControls.m_BorderColor=Root.Colors.GrayLight;
	m_iCurrentSpeaker=-1;
	m_fVideoTop=m_2DSpeaker.WinTop;
	m_fVideoLeft=m_Right.WinLeft - 438 - m_fLaptopPadding;
	m_fVideoRight=m_Right.WinLeft - m_fLaptopPadding;
	m_fVideoBottom=m_fVideoTop + 230;
	m_fRightTileModulo=m_fVideoRight % m_TBackGround.USize;
	m_fLeftTileModulo=m_fVideoLeft % m_TBackGround.USize;
	m_fBottomTileModulo=m_fVideoBottom % m_TBackGround.VSize;
	m_fRightBGWidth=WinWidth - m_fVideoRight;
	m_fUpBGWidth=m_fVideoRight - m_fVideoLeft;
	m_fBottomHeight=WinHeight - m_fVideoBottom;
	m_MissionDesc=R6MenuVideo(CreateWindow(Class'R6MenuVideo',m_fVideoLeft,m_fVideoTop,438.00,230.00,self));
	m_MissionDesc.m_BorderColor=Root.Colors.GrayLight;
	m_SrcrollingTextArea=R6WindowWrappedTextArea(CreateWindow(Class'R6WindowWrappedTextArea',m_fVideoLeft,m_fVideoBottom + m_fPaddingBetweenElements,438.00,m_HelpTextBar.WinTop - m_fPaddingBetweenElements - m_fVideoBottom - m_fPaddingBetweenElements,self));
	m_SrcrollingTextArea.m_BorderColor=Root.Colors.GrayLight;
	m_SrcrollingTextArea.SetScrollable(True);
	m_SrcrollingTextArea.VertSB.SetBorderColor(Root.Colors.GrayLight);
	m_SrcrollingTextArea.VertSB.SetHideWhenDisable(True);
	m_SrcrollingTextArea.VertSB.SetEffect(True);
	m_MissionObjectives=R6WindowWrappedTextArea(CreateWindow(Class'R6WindowWrappedTextArea',m_2DSpeaker.WinLeft,m_SrcrollingTextArea.WinTop,m_2DSpeaker.WinWidth,m_SrcrollingTextArea.WinHeight,self));
	m_MissionObjectives.m_BorderColor=Root.Colors.GrayLight;
	m_MissionObjectives.SetScrollable(True);
	m_MissionObjectives.VertSB.SetBorderColor(Root.Colors.GrayLight);
	m_MissionObjectives.VertSB.SetHideWhenDisable(True);
	m_MissionObjectives.VertSB.SetEffect(True);
	m_MissionObjectives.m_BorderStyle=1;
	GetLevel().m_bPlaySound=False;
	m_NavBar.m_BriefingButton.bDisabled=True;
}

function Reset ()
{
	m_iCurrentSpeaker=-1;
	m_SpeakerControls.Reset();
}

function HideWindow ()
{
	Super.HideWindow();
	StopIntelWidgetSound();
	GetPlayerOwner().FadeSound(3.00,100,SLOT_Music);
}

function ShowWindow ()
{
	local int itempSpeaker;
	local int i;
	local R6MissionDescription CurrentMission;
	local R6MissionObjectiveMgr moMgr;

	Super.ShowWindow();
	GetLevel().m_bPlaySound=False;
	if ( bShowLog )
	{
		Log("R6MenuIntelWidget::Show()");
	}
	CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
/*	m_CodeName.SetProperties(Localize(CurrentMission.m_MapName,"ID_CODENAME",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);
	m_DateTime.SetProperties(Localize(CurrentMission.m_MapName,"ID_DATETIME",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);
	m_Location.SetProperties(Localize(CurrentMission.m_MapName,"ID_LOCATION",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);*/
	m_SpeakerControls.AssociateButtons();
	m_MissionDesc.PlayVideo(m_Right.WinLeft - 438 - m_fLaptopPadding,m_SrcrollingTextArea.WinTop - 230 - m_fPaddingBetweenElements,R6AbstractGameInfo(Root.Console.ViewportOwner.Actor.Level.Game).GetIntelVideoName(CurrentMission) $ ".bik");
	m_MissionObjectives.Clear();
	GetPlayerOwner().AddSoundBank(CurrentMission.m_AudioBankName,LBS_Gun);
	GetLevel().FinalizeLoading();
	GetLevel().SetBankSound(BANK_UnloadGun);
	m_MissionObjectives.Clear();
	m_MissionObjectives.m_fXOffSet=10.00;
	m_MissionObjectives.m_fYOffSet=5.00;
	m_MissionObjectives.AddText(Localize("Briefing","Objectives","R6Menu"),Root.Colors.BlueLight,Root.Fonts[5]);
	moMgr=R6AbstractGameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_missionMgr;
	for (i=0;i < moMgr.m_aMissionObjectives.Length;++i)
	{
		if (  !moMgr.m_aMissionObjectives[i].m_bMoralityObjective && moMgr.m_aMissionObjectives[i].m_bVisibleInMenu )
		{
			m_MissionObjectives.AddText(Localize("Game",moMgr.m_aMissionObjectives[i].m_szDescriptionInMenu,moMgr.Level.GetMissionObjLocFile(moMgr.m_aMissionObjectives[i])),Root.Colors.White,Root.Fonts[10]);
			m_MissionObjectives.AddText(" ",Root.Colors.White,Root.Fonts[10]);
		}
	}
	itempSpeaker=m_iCurrentSpeaker;
	m_iCurrentSpeaker=-1;
	if ( bShowLog )
	{
		Log("itempSpeaker" @ string(itempSpeaker));
	}
	if (  !m_SpeakerControls.m_ControlButton.bDisabled )
	{
		if ( itempSpeaker == -1 )
		{
			ManageButtonSelection(0);
		}
		else
		{
			ManageButtonSelection(itempSpeaker);
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	DrawStretchedTextureSegment(C,0.00,0.00,m_fVideoLeft,WinHeight,0.00,0.00,m_fVideoLeft,WinHeight,m_TBackGround);
	DrawStretchedTextureSegment(C,m_fVideoRight,0.00,m_fRightBGWidth,WinHeight,m_fRightTileModulo,0.00,m_fRightBGWidth,WinHeight,m_TBackGround);
	DrawStretchedTextureSegment(C,m_fVideoLeft,0.00,m_fUpBGWidth,m_fVideoTop,m_fLeftTileModulo,0.00,m_fUpBGWidth,m_fVideoTop,m_TBackGround);
	DrawStretchedTextureSegment(C,m_fVideoLeft,m_fVideoBottom,m_fUpBGWidth,m_fBottomHeight,m_fLeftTileModulo,m_fBottomTileModulo,m_fUpBGWidth,m_fBottomHeight,m_TBackGround);
	DrawLaptopFrame(C);
}

function DisplayText (float _X, float _Y, Font _TextFont, Color _Color, R6WindowWrappedTextArea _R6WindowWrappedTextArea)
{
	_R6WindowWrappedTextArea.m_fXOffSet=_X;
	_R6WindowWrappedTextArea.m_fYOffSet=_Y;
	_R6WindowWrappedTextArea.AddText(m_szScrollingText,_Color,_TextFont);
}

function bool SetMissionText (string _szOriginal)
{
	local string szTemp;
	local int i;
	local bool bFindText;
	local R6MissionDescription CurrentMission;

	m_szScrollingText="";
	if ( R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_bUsingCampaignBriefing == True )
	{
		CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
		m_szScrollingText=Localize(CurrentMission.m_MapName,_szOriginal,CurrentMission.LocalizationFile,True,True);
	}
	else
	{
		m_szScrollingText=Localize(GetLevel().GameTypeToString(GetLevel().Game.m_eGameTypeFlag),_szOriginal,GetLevel().GameTypeLocalizationFile(GetLevel().Game.m_eGameTypeFlag),True,True);
	}
	return m_szScrollingText != "";
}

function ManageButtonSelection (int _eButtonSelection)
{
	local bool bChangeText;
	local R6MissionDescription CurrentMission;

	if ( bShowLog )
	{
		Log("ManageButtonSelection" @ string(m_iCurrentSpeaker) @ string(_eButtonSelection));
	}
	if ( m_iCurrentSpeaker == _eButtonSelection )
	{
		if ( bShowLog )
		{
			Log("Nothing To Do!");
		}
		return;
	}
	m_iCurrentSpeaker=_eButtonSelection;
	CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
	if ( m_sndPlayEvent != None )
	{
		GetPlayerOwner().StopSound(m_sndPlayEvent);
	}
	m_sndPlayEvent=None;
	switch (_eButtonSelection)
	{
		case 0:
		SetMissionText("ID_CONTROL");
		if ( R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_bUsingCampaignBriefing == True )
		{
			m_sndPlayEvent=CurrentMission.m_PlayEventControl;
		}
		m_2DSpeaker.R=m_RControl;
		break;
		case 1:
		SetMissionText("ID_CLARK");
		if ( R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_bUsingCampaignBriefing == True )
		{
			m_sndPlayEvent=CurrentMission.m_PlayEventClark;
		}
		m_2DSpeaker.R=m_RClark;
		break;
		case 2:
		SetMissionText("ID_SWEENY");
		if ( R6GameInfo(Root.Console.ViewportOwner.Actor.Level.Game).m_bUsingCampaignBriefing == True )
		{
			m_sndPlayEvent=CurrentMission.m_PlayEventSweeney;
		}
		m_2DSpeaker.R=m_RSweeney;
		break;
		case 3:
		SetMissionText("ID_NEWSWIRE");
		m_2DSpeaker.R=m_RNewsWire;
		break;
		case 4:
		SetMissionText("ID_MISSION_ORDER");
		m_2DSpeaker.R=m_RMissionOrder;
		break;
		default:
		break;
	}
	if ( m_sndPlayEvent != None )
	{
		GetPlayerOwner().PlaySound(m_sndPlayEvent,SLOT_Speak);
		GetPlayerOwner().FadeSound(3.00,15,SLOT_Music);
	}
	m_SrcrollingTextArea.Clear();
	DisplayText(10.00,4.00,Root.Fonts[10],Root.Colors.White,m_SrcrollingTextArea);
}

function StopIntelWidgetSound ()
{
	m_MissionDesc.StopVideo();
	GetPlayerOwner().StopSound(m_sndPlayEvent);
	m_sndPlayEvent=None;
}

defaultproperties
{
    m_bAddText=True
    m_fLaptopPadding=2.00
    m_fPaddingBetweenElements=3.00
    m_fLabelHeight=18.00
    m_fSpeakerWidgetWidth=156.00
    m_fSpeakerWidgetHeight=117.00
    m_RControl=(X=10166788,Y=570621952,W=116,H=0)
    m_RClark=(X=7676421,Y=570687488,W=155,H=7610883)
    m_RSweeney=(X=10232326,Y=570687488,W=155,H=7610883)
    m_RNewsWire=(X=10232326,Y=570753024,W=117,H=10166788)
    m_RMissionOrder=(X=20455942,Y=570687488,W=155,H=7610883)
}
/*
    m_TSpeaker=Texture'R6MenuTextures.Gui_04_a00'
*/

