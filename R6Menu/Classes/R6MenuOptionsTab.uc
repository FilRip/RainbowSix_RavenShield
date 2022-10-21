//================================================================================
// R6MenuOptionsTab.
//================================================================================
class R6MenuOptionsTab extends UWindowDialogClientWindow;

enum eGeneralButUse {
	eGBU_ResetToDefault,
	eGBU_Activate
};

enum ePageOptions {
	ePO_Game,
	ePO_Sound,
	ePO_Graphics,
	ePO_Hud,
	ePO_MP,
	ePO_Controls,
	ePO_MODS
};

var ePageOptions m_ePageOptID;
var int m_iRefMouseSens;
var int m_iRefAmbientVolume;
var int m_iRefVoicesVolume;
var int m_iRefMusicVolume;
var int m_iKeyToAssign;
var bool m_bDrawLineOverButton;
var bool m_bInitComplete;
var bool m_bEAXNotSupported;
var R6WindowButton m_pGeneralButUse;
var R6WindowButtonBox m_pOptionAlwaysRun;
var R6WindowButtonBox m_pOptionInvertMouse;
var R6WindowButtonBox m_pPopUpLoadPlan;
var R6WindowButtonBox m_pPopUpQuickPlay;
var R6WindowTextureBrowser m_pAutoAim;
var Texture m_pAutoAimTexture;
var R6WindowHScrollbar m_pOptionMouseSens;
var R6WindowHScrollbar m_pAmbientVolume;
var R6WindowHScrollbar m_pVoicesVolume;
var R6WindowHScrollbar m_pMusicVolume;
var R6WindowComboControl m_pSndQuality;
var R6WindowComboControl m_pAudioVirtual;
var R6WindowButtonBox m_pSndHardware;
var R6WindowButtonBox m_pEAX;
var R6WindowBitMap m_EaxLogo;
var Texture m_EaxTexture;
var R6WindowComboControl m_pVideoRes;
var R6WindowComboControl m_pTextureDetail;
var R6WindowComboControl m_pLightmapDetail;
var R6WindowComboControl m_pRainbowsDetail;
var R6WindowComboControl m_pHostagesDetail;
var R6WindowComboControl m_pTerrosDetail;
var R6WindowComboControl m_pRainbowsShadowLevel;
var R6WindowComboControl m_pHostagesShadowLevel;
var R6WindowComboControl m_pTerrosShadowLevel;
var R6WindowComboControl m_pGoreLevel;
var R6WindowComboControl m_pDecalsDetail;
var R6WindowButtonBox m_pAnimGeometry;
var R6WindowButtonBox m_pHideDeadBodies;
var R6WindowButtonBox m_pLowDetailSmoke;
var R6WindowButtonBox m_pHudWeaponName;
var R6WindowButtonBox m_pHudShowFPWeapon;
var R6WindowButtonBox m_pHudOtherTInfo;
var R6WindowButtonBox m_pHudCurTInfo;
var R6WindowButtonBox m_pHudCircumIcon;
var R6WindowButtonBox m_pHudWpInfo;
var R6WindowButtonBox m_pHudReticule;
var R6WindowButtonBox m_pHudShowTNames;
var R6WindowButtonBox m_pHudCharInfo;
var R6WindowButtonBox m_pHudShowRadar;
var R6WindowBitMap m_pHudBGTex;
var R6WindowBitMap m_pHudWeaponNameTex;
var R6WindowBitMap m_pHudShowFPWeaponTex;
var R6WindowBitMap m_pHudOtherTInfoTex;
var R6WindowBitMap m_pHudCurTInfoTex;
var R6WindowBitMap m_pHudCircumIconTex;
var R6WindowBitMap m_pHudWpInfoTex;
var R6WindowBitMap m_pHudReticuleTex;
var R6WindowBitMap m_pHudCharInfoTex;
var R6WindowBitMap m_pHudShowTNamesTex;
var R6WindowBitMap m_pHudShowRadarTex;
var R6WindowEditControl m_pOptionPlayerName;
var R6WindowComboControl m_pSpeedConnection;
var R6WindowButtonExt m_pOptionGender;
var R6MenuArmpatchSelect m_pArmpatchChooser;
var R6WindowListControls m_pListControls;
var UWindowListBoxItem m_pCurItem;
var R6MenuOptionsControls m_pOptControls;
var R6WindowPopUpBox m_pPopUpKeyBG;
var R6WindowPopUpBox m_pKeyMenuReAssignPopUp;
var R6WindowListMODS m_pListOfMODS;
var UWindowInfo m_pInfo;
var Region SimpleBorderRegion;
var Region m_pAutoAimTextReg[4];
var Region m_EaxTextureReg;
var Region m_RArmpatchBitmapPos;
var Region m_RArmpatchListPos;
var string m_pComboLevel[4];
var string m_pSndLocEnum[3];
var string m_pConnectionSpeed[5];
var string m_szOldActionKey;
const C_iALL_ITEMS= 0x0F;
const C_iSHADOW_ITEMS= 0x0B;
const C_iGORE_ITEMS= 0x0A;
const C_iITEM_HIGH= 0x08;
const C_iITEM_MEDIUM= 0x04;
const C_iITEM_LOW= 0x02;
const C_iITEM_NONE= 0x01;
const C_szEGameOptionsEffectLevel= "EGameOptionsEffectLevel";
const C_szEGameOptionsGraphicLevel= "EGameOptionsGraphicLevel";
const C_ICOMBOCONTROL_WIDTH= 140;
const C_fXPOS_COMBOCONTROL= 250;
const C_fXPOS_SCROLLBAR= 250;
const C_fSCROLLBAR_HEIGHT= 14;
const C_fSCROLLBAR_WIDTH= 140;

function Created ()
{
	m_pComboLevel[0]=Localize("Options","Level_None","R6Menu");
	m_pComboLevel[1]=Localize("Options","Level_Low","R6Menu");
	m_pComboLevel[2]=Localize("Options","Level_Medium","R6Menu");
	m_pComboLevel[3]=Localize("Options","Level_Hi","R6Menu");
	m_pSndLocEnum[0]=Localize("Options","Opt_SndVirtualHigh","R6Menu");
	m_pSndLocEnum[1]=Localize("Options","Opt_SndVirtualLow","R6Menu");
	m_pSndLocEnum[2]=Localize("Options","Opt_SndVirtualOff","R6Menu");
	m_pConnectionSpeed[0]=Localize("Options","Opt_NetSpeedT1","R6Menu");
	m_pConnectionSpeed[1]=Localize("Options","Opt_NetSpeedT3","R6Menu");
	m_pConnectionSpeed[2]=Localize("Options","Opt_NetSpeedCable","R6Menu");
	m_pConnectionSpeed[3]=Localize("Options","Opt_NetSpeedADSL","R6Menu");
	m_pConnectionSpeed[4]=Localize("Options","Opt_NetSpeedModem","R6Menu");
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_bDrawLineOverButton )
	{
		C.SetDrawColor(255,255,255);
		DrawStretchedTextureSegment(C,0.00,WinHeight - 15,WinWidth,SimpleBorderRegion.H,SimpleBorderRegion.X,SimpleBorderRegion.Y,SimpleBorderRegion.W,SimpleBorderRegion.H,R6MenuRSLookAndFeel(LookAndFeel).m_R6ScrollTexture);
	}
}

function InitResetButton ()
{
	m_bDrawLineOverButton=True;
	m_pGeneralButUse=R6WindowButton(CreateControl(Class'R6WindowButton',0.00,WinHeight - 15,WinWidth,15.00,self));
	m_pGeneralButUse.Text=Localize("Options","ResetToDefault","R6Menu");
	m_pGeneralButUse.ToolTipString=Localize("Tip","ResetToDefault","R6Menu");
	m_pGeneralButUse.Align=TA_Center;
	m_pGeneralButUse.m_iButtonID=0;
}

function InitActivateButton ()
{
	m_bDrawLineOverButton=True;
	m_pGeneralButUse=R6WindowButton(CreateControl(Class'R6WindowButton',0.00,WinHeight - 15,WinWidth,15.00,self));
	m_pGeneralButUse.Text="ACTIVATE";
	m_pGeneralButUse.ToolTipString=Localize("Tip","ResetToDefault","R6Menu");
	m_pGeneralButUse.Align=TA_Center;
	m_pGeneralButUse.m_iButtonID=1;
}

function InitOptionGame ()
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local float fTemp;
	local float fSizeOfCounter;
	local float fXRightOffset;
	local Font ButtonFont;
	local int iAutoAimBitmapHeight;
	local int iAutoAimVPadding;
	local int iSBButtonWidth;

	ButtonFont=Root.Fonts[5];
//	m_ePageOptID=0;
	fXOffset=5.00;
	fXRightOffset=26.00;
	fYOffset=5.00;
	fWidth=WinWidth - fXOffset - 40;
	fHeight=15.00;
	fYStep=27.00;
	iSBButtonWidth=14;
	iAutoAimBitmapHeight=73;
	iAutoAimVPadding=5;
	m_pOptionAlwaysRun=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pOptionAlwaysRun.SetButtonBox(False);
	m_pOptionAlwaysRun.CreateTextAndBox(Localize("Options","Opt_GameAlways","R6Menu"),Localize("Tip","Opt_GameAlways","R6Menu"),0.00,2);
	fYOffset += fYStep;
	m_pOptionInvertMouse=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pOptionInvertMouse.SetButtonBox(False);
	m_pOptionInvertMouse.CreateTextAndBox(Localize("Options","Opt_GameInvertM","R6Menu"),Localize("Tip","Opt_GameInvertM","R6Menu"),0.00,3);
	fYOffset += fYStep;
	m_pOptionMouseSens=R6WindowHScrollbar(CreateControl(Class'R6WindowHScrollbar',fXOffset,fYOffset,WinWidth - fXOffset - fXRightOffset,14.00,self));
	m_pOptionMouseSens.CreateSB(0,250.00,0.00,140.00,14.00,self);
	m_pOptionMouseSens.CreateSBTextLabel(Localize("Options","Opt_GameMouseSens","R6Menu"),Localize("Tip","Opt_GameMouseSens","R6Menu"));
	m_pOptionMouseSens.SetScrollBarRange(0.00,120.00,20.00);
	fYOffset += fYStep;
	m_pPopUpLoadPlan=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pPopUpLoadPlan.SetButtonBox(False);
	m_pPopUpLoadPlan.CreateTextAndBox(Localize("Options","Opt_GamePopUpLoadPlan","R6Menu"),Localize("Tip","Opt_GamePopUpLoadPlan","R6Menu"),0.00,5);
	fYOffset += fYStep;
	m_pPopUpQuickPlay=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pPopUpQuickPlay.SetButtonBox(False);
	m_pPopUpQuickPlay.CreateTextAndBox(Localize("Options","Opt_GamePopUpQuickPlay","R6Menu"),Localize("Tip","Opt_GamePopUpQuickPlay","R6Menu"),0.00,5);
	fYOffset += fYStep;
	m_pAutoAim=R6WindowTextureBrowser(CreateWindow(Class'R6WindowTextureBrowser',fXOffset,fYOffset,WinWidth - fXOffset,14.00 + iAutoAimBitmapHeight + iAutoAimVPadding,self));
	m_pAutoAim.CreateSB(250,m_pAutoAim.WinHeight - 14,140,14);
	m_pAutoAim.CreateBitmap(250 + iSBButtonWidth,0,140 - 2 * iSBButtonWidth,iAutoAimBitmapHeight);
	m_pAutoAim.SetBitmapProperties(False,True,5,False);
	m_pAutoAim.SetBitmapBorder(True,Root.Colors.White);
	m_pAutoAim.CreateTextLabel(0,0,m_pAutoAim.WinWidth - m_pAutoAim.m_CurrentSelection.WinLeft,m_pAutoAim.WinHeight,Localize("Options","Opt_AutoTarget","R6Menu"),Localize("Tip","Opt_AutoTarget","R6Menu"));
	m_pAutoAim.AddTexture(m_pAutoAimTexture,m_pAutoAimTextReg[0]);
	m_pAutoAim.AddTexture(m_pAutoAimTexture,m_pAutoAimTextReg[1]);
	m_pAutoAim.AddTexture(m_pAutoAimTexture,m_pAutoAimTextReg[2]);
	m_pAutoAim.AddTexture(m_pAutoAimTexture,m_pAutoAimTextReg[3]);
	InitResetButton();
	SetMenuGameValues();
	m_bInitComplete=True;
}

function SetGameValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	pGameOptions.AlwaysRun=m_pOptionAlwaysRun.m_bSelected;
	pGameOptions.InvertMouse=m_pOptionInvertMouse.m_bSelected;
	pGameOptions.PopUpLoadPlan=m_pPopUpLoadPlan.m_bSelected;
	pGameOptions.PopUpQuickPlay=m_pPopUpQuickPlay.m_bSelected;
	pGameOptions.AutoTargetSlider=m_pAutoAim.GetCurrentTextureIndex();
	pGameOptions.MouseSensitivity=m_pOptionMouseSens.GetScrollBarValue();
}

function SetMenuGameValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	m_pOptionAlwaysRun.SetButtonBox(pGameOptions.AlwaysRun);
	m_pOptionInvertMouse.SetButtonBox(pGameOptions.InvertMouse);
	m_pPopUpLoadPlan.SetButtonBox(pGameOptions.PopUpLoadPlan);
	m_pPopUpQuickPlay.SetButtonBox(pGameOptions.PopUpQuickPlay);
	m_pAutoAim.SetCurrentTextureFromIndex(pGameOptions.AutoTargetSlider);
	m_pOptionMouseSens.SetScrollBarValue(pGameOptions.MouseSensitivity);
}

function InitOptionSound (bool _bInGameOptions)
{
	local Region rRegionW;
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local float fTemp;
	local float fSizeOfCounter;
	local float fXRightOffset;
	local Font ButtonFont;

	ButtonFont=Root.Fonts[5];
//	m_ePageOptID=1;
	fXOffset=5.00;
	fXRightOffset=26.00;
	fYOffset=5.00;
	fWidth=WinWidth - fXOffset - 40;
	fHeight=14.00;
	fYStep=27.00;
	m_pAmbientVolume=R6WindowHScrollbar(CreateControl(Class'R6WindowHScrollbar',fXOffset,fYOffset,WinWidth - fXOffset - fXRightOffset,14.00,self));
//	m_pAmbientVolume.CreateSB(GetPlayerOwner().1,250.00,0.00,140.00,14.00,self);
	m_pAmbientVolume.CreateSBTextLabel(Localize("Options","Opt_SndAmbient","R6Menu"),Localize("Tip","Opt_SndAmbient","R6Menu"));
	m_pAmbientVolume.SetScrollBarRange(0.00,100.00,20.00);
	fYOffset += fYStep;
	m_pVoicesVolume=R6WindowHScrollbar(CreateControl(Class'R6WindowHScrollbar',fXOffset,fYOffset,WinWidth - fXOffset - fXRightOffset,14.00,self));
//	m_pVoicesVolume.CreateSB(GetPlayerOwner().6,250.00,0.00,140.00,14.00,self);
	m_pVoicesVolume.CreateSBTextLabel(Localize("Options","Opt_SndVoices","R6Menu"),Localize("Tip","Opt_SndVoices","R6Menu"));
	m_pVoicesVolume.SetScrollBarRange(0.00,100.00,20.00);
	fYOffset += fYStep;
	m_pMusicVolume=R6WindowHScrollbar(CreateControl(Class'R6WindowHScrollbar',fXOffset,fYOffset,WinWidth - fXOffset - fXRightOffset,14.00,self));
//	m_pMusicVolume.CreateSB(GetPlayerOwner().5,250.00,0.00,140.00,14.00,self);
	m_pMusicVolume.CreateSBTextLabel(Localize("Options","Opt_SndMusic","R6Menu"),Localize("Tip","Opt_SndMusic","R6Menu"));
	m_pMusicVolume.SetScrollBarRange(0.00,100.00,20.00);
	fYOffset += fYStep;
	rRegionW.X=fXOffset;
	rRegionW.Y=fYOffset;
	rRegionW.W=fWidth + 20;
	rRegionW.H=fHeight;
	m_pSndQuality=SetComboControlButton(rRegionW,Localize("Options","Opt_SndQuality","R6Menu"),Localize("Tip","Opt_SndQuality","R6Menu"));
	m_pSndQuality.AddItem(m_pComboLevel[1],"");
	m_pSndQuality.AddItem(m_pComboLevel[3],"");
	m_pSndQuality.SetDisableButton(_bInGameOptions);
	fYOffset += fYStep;
	rRegionW.Y=fYOffset;
	m_pAudioVirtual=SetComboControlButton(rRegionW,Localize("Options","Opt_SndVirtual","R6Menu"),Localize("Tip","Opt_SndVirtual","R6Menu"));
	m_pAudioVirtual.AddItem(m_pSndLocEnum[2],"");
	m_pAudioVirtual.AddItem(m_pSndLocEnum[1],"");
	m_pAudioVirtual.AddItem(m_pSndLocEnum[0],"");
	fYOffset += fYStep;
	m_pSndHardware=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pSndHardware.SetButtonBox(False);
	m_pSndHardware.CreateTextAndBox(Localize("Options","Opt_SndHardware","R6Menu"),Localize("Tip","Opt_SndHardware","R6Menu"),0.00,0);
	fYOffset += fYStep;
	m_pEAX=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pEAX.SetButtonBox(False);
	m_pEAX.CreateTextAndBox(Localize("Options","Opt_SndEAX","R6Menu"),Localize("Tip","Opt_SndEAX","R6Menu"),0.00,1);
	fYOffset += fYStep;
	m_EaxLogo=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',0.00,fYOffset,WinWidth,m_EaxTextureReg.H,self));
	m_EaxLogo.bCenter=True;
	m_EaxLogo.m_iDrawStyle=5;
	m_EaxLogo.t=m_EaxTexture;
	m_EaxLogo.R=m_EaxTextureReg;
	m_EaxLogo.m_bUseColor=True;
	m_EaxLogo.m_TextureColor=Root.Colors.GrayLight;
	InitResetButton();
	SetMenuSoundValues();
	m_bInitComplete=True;
}

function SetSoundValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	pGameOptions.AmbientVolume=m_pAmbientVolume.GetScrollBarValue();
	pGameOptions.VoicesVolume=m_pVoicesVolume.GetScrollBarValue();
	pGameOptions.MusicVolume=m_pMusicVolume.GetScrollBarValue();
	pGameOptions.SndHardware=m_pSndHardware.m_bSelected;
	pGameOptions.EAX=m_pEAX.m_bSelected;
	pGameOptions.SndQuality=ConvertToSndQuality(m_pSndQuality.GetValue());
//	pGameOptions.AudioVirtual=ConvertToAVEnum(m_pAudioVirtual.GetValue());
}

function SetMenuSoundValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	m_pAmbientVolume.SetScrollBarValue(pGameOptions.AmbientVolume);
	m_pVoicesVolume.SetScrollBarValue(pGameOptions.VoicesVolume);
	m_pMusicVolume.SetScrollBarValue(pGameOptions.MusicVolume);
	m_iRefAmbientVolume=m_pAmbientVolume.GetScrollBarValue();
	m_iRefVoicesVolume=m_pVoicesVolume.GetScrollBarValue();
	m_iRefMusicVolume=m_pMusicVolume.GetScrollBarValue();
	m_pSndHardware.SetButtonBox(pGameOptions.SndHardware);
	if ( pGameOptions.EAXCompatible )
	{
		m_pEAX.SetButtonBox(pGameOptions.EAX);
	}
	else
	{
		m_bEAXNotSupported=True;
		m_pEAX.bDisabled=True;
		m_pEAX.SetButtonBox(False);
	}
	ManageNotifyForSound(m_pSndHardware,1);
	ManageNotifyForSound(m_pEAX,1);
	m_pAudioVirtual.SetValue(ConvertToAudioString(pGameOptions.AudioVirtual));
	m_pSndQuality.SetValue(ConvertToSndQualityString(pGameOptions.SndQuality));
}

function int ConvertToSndQuality (string _szValue)
{
	if ( _szValue == m_pComboLevel[3] )
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

function string ConvertToSndQualityString (int _iValue)
{
	if ( _iValue == 1 )
	{
		return m_pComboLevel[3];
	}
	else
	{
		return m_pComboLevel[1];
	}
}

/*function EGameOptionsAudioVirtual ConvertToAVEnum (string _szValueToConvert)
{
	local EGameOptionsAudioVirtual eAVResult;

	switch (_szValueToConvert)
	{
		case m_pSndLocEnum[0]:
		eAVResult=0;
		break;
		case m_pSndLocEnum[1]:
		eAVResult=1;
		break;
		case m_pSndLocEnum[2]:
		eAVResult=2;
		break;
		default:
		break;
	}
	return eAVResult;
}*/

function string ConvertToAudioString (int _iValueToConvert)
{
	local string szResult;

	switch (_iValueToConvert)
	{
		case 0:
		szResult=m_pSndLocEnum[0];
		break;
		case 1:
		szResult=m_pSndLocEnum[1];
		break;
		case 2:
		szResult=m_pSndLocEnum[2];
		break;
		default:
		break;
	}
	return szResult;
}

function InitOptionGraphic (bool _bInGameOptions)
{
	local Region rRegionW;
	local float fYStep;
	local Font ButtonFont;
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	ButtonFont=Root.Fonts[5];
//	m_ePageOptID=2;
	rRegionW.X=5;
	rRegionW.Y=5;
	rRegionW.W=WinWidth - rRegionW.X - 20;
	rRegionW.H=14;
	fYStep=19.00;
	m_pVideoRes=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapVideoRes","R6Menu"),Localize("Tip","Opt_GrapVideoRes","R6Menu"));
	AddVideoResolution(m_pVideoRes);
	if ( _bInGameOptions )
	{
		m_pVideoRes.SetDisableButton( !pGameOptions.AllowChangeResInGame);
	}
	rRegionW.Y += fYStep;
	m_pTextureDetail=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapTexDetail","R6Menu"),Localize("Tip","Opt_GrapTexDetail","R6Menu"));
	AddGraphComboControlItem(15,m_pTextureDetail,"EGameOptionsGraphicLevel");
	rRegionW.Y += fYStep;
	m_pLightmapDetail=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapLightMap","R6Menu"),Localize("Tip","Opt_GrapLightMap","R6Menu"));
	AddGraphComboControlItem(15,m_pLightmapDetail,"EGameOptionsGraphicLevel",True);
	rRegionW.Y += fYStep;
	m_pRainbowsDetail=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapRainbowDetail","R6Menu"),Localize("Tip","Opt_GrapRainbowDetail","R6Menu"));
	AddGraphComboControlItem(15,m_pRainbowsDetail,"EGameOptionsGraphicLevel");
	rRegionW.Y += fYStep;
	m_pHostagesDetail=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapHostDetail","R6Menu"),Localize("Tip","Opt_GrapHostDetail","R6Menu"));
	AddGraphComboControlItem(15,m_pHostagesDetail,"EGameOptionsGraphicLevel");
	rRegionW.Y += fYStep;
	m_pTerrosDetail=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapTerroDetail","R6Menu"),Localize("Tip","Opt_GrapTerroDetail","R6Menu"));
	AddGraphComboControlItem(15,m_pTerrosDetail,"EGameOptionsGraphicLevel");
	rRegionW.Y += fYStep;
	m_pRainbowsShadowLevel=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapRainbowShadow","R6Menu"),Localize("Tip","Opt_GrapRainbowShadow","R6Menu"));
	AddGraphComboControlItem(11,m_pRainbowsShadowLevel,"EGameOptionsEffectLevel",True);
	m_pRainbowsShadowLevel.SetDisableButton(_bInGameOptions);
	rRegionW.Y += fYStep;
	m_pHostagesShadowLevel=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapHostShadow","R6Menu"),Localize("Tip","Opt_GrapHostShadow","R6Menu"));
	AddGraphComboControlItem(11,m_pHostagesShadowLevel,"EGameOptionsEffectLevel",True);
	m_pHostagesShadowLevel.SetDisableButton(_bInGameOptions);
	rRegionW.Y += fYStep;
	m_pTerrosShadowLevel=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapTerroShadow","R6Menu"),Localize("Tip","Opt_GrapTerroShadow","R6Menu"));
	AddGraphComboControlItem(11,m_pTerrosShadowLevel,"EGameOptionsEffectLevel",True);
	m_pTerrosShadowLevel.SetDisableButton(_bInGameOptions);
	if (  !pGameOptions.SplashScreen )
	{
		rRegionW.Y += fYStep;
		m_pGoreLevel=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapGoreLevel","R6Menu"),Localize("Tip","Opt_GrapGoreLevel","R6Menu"));
		AddGraphComboControlItem(10,m_pGoreLevel,"EGameOptionsGraphicLevel");
		m_pGoreLevel.SetDisableButton(_bInGameOptions);
	}
	rRegionW.Y += fYStep;
	m_pDecalsDetail=SetComboControlButton(rRegionW,Localize("Options","Opt_GrapDecalsDetail","R6Menu"),Localize("Tip","Opt_GrapDecalsDetail","R6Menu"));
	AddGraphComboControlItem(15,m_pDecalsDetail,"EGameOptionsEffectLevel");
	m_pDecalsDetail.SetDisableButton(_bInGameOptions);
	rRegionW.Y += fYStep;
	rRegionW.W -= 20;
	m_pAnimGeometry=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',rRegionW.X,rRegionW.Y,rRegionW.W,rRegionW.H,self));
	m_pAnimGeometry.SetButtonBox(True);
	m_pAnimGeometry.CreateTextAndBox(Localize("Options","Opt_GrapAnimGeometry","R6Menu"),Localize("Tip","Opt_GrapAnimGeometry","R6Menu"),0.00,0);
	if (  !pGameOptions.SplashScreen )
	{
		rRegionW.Y += fYStep;
		m_pHideDeadBodies=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',rRegionW.X,rRegionW.Y,rRegionW.W,rRegionW.H,self));
		m_pHideDeadBodies.SetButtonBox(True);
		m_pHideDeadBodies.CreateTextAndBox(Localize("Options","Opt_GrapHideDeadBodies","R6Menu"),Localize("Tip","Opt_GrapHideDeadBodies","R6Menu"),0.00,0);
	}
	rRegionW.Y += fYStep;
	m_pLowDetailSmoke=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',rRegionW.X,rRegionW.Y,rRegionW.W,rRegionW.H,self));
	m_pLowDetailSmoke.SetButtonBox(False);
	m_pLowDetailSmoke.CreateTextAndBox(Localize("Options","Opt_GrapLowDetailSmoke","R6Menu"),Localize("Tip","Opt_GrapLowDetailSmoke","R6Menu"),0.00,0);
	InitResetButton();
	SetMenuGraphicValues();
	m_bInitComplete=True;
}

function SetGraphicValues (optional bool _bUpdateFileOnly)
{
/*	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	GetResolutionXY(pGameOptions.R6ScreenSizeX,pGameOptions.R6ScreenSizeY,pGameOptions.R6ScreenRefreshRate);
	pGameOptions.TextureDetail=ConvertToGLEnum(m_pTextureDetail.GetValue());
	pGameOptions.LightmapDetail=ConvertToGLEnum(m_pLightmapDetail.GetValue());
	pGameOptions.RainbowsDetail=ConvertToGLEnum(m_pRainbowsDetail.GetValue());
	pGameOptions.RainbowsShadowLevel=ConvertToELEnum(m_pRainbowsShadowLevel.GetValue());
	pGameOptions.HostagesDetail=ConvertToGLEnum(m_pHostagesDetail.GetValue());
	pGameOptions.TerrosDetail=ConvertToGLEnum(m_pTerrosDetail.GetValue());
	pGameOptions.HostagesShadowLevel=ConvertToELEnum(m_pHostagesShadowLevel.GetValue());
	pGameOptions.TerrosShadowLevel=ConvertToELEnum(m_pTerrosShadowLevel.GetValue());
	if ( pGameOptions.SplashScreen )
	{
		pGameOptions.GoreLevel=pGameOptions.0;
	}
	else
	{
		pGameOptions.GoreLevel=ConvertToELEnum(m_pGoreLevel.GetValue());
	}
	pGameOptions.DecalsDetail=ConvertToELEnum(m_pDecalsDetail.GetValue());
	pGameOptions.AnimatedGeometry=m_pAnimGeometry.m_bSelected;
	if ( pGameOptions.SplashScreen )
	{
		pGameOptions.HideDeadBodies=True;
	}
	else
	{
		pGameOptions.HideDeadBodies=m_pHideDeadBodies.m_bSelected;
	}
	pGameOptions.LowDetailSmoke=m_pLowDetailSmoke.m_bSelected;
	if ( R6MenuOptionsWidget(OwnerWindow).m_bInGame &&  !_bUpdateFileOnly )
	{
		Class'Actor'.static.UpdateGraphicOptions();
	}*/
}

function SetMenuGraphicValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	if ( pGameOptions.ShowRefreshRates && (pGameOptions.R6ScreenRefreshRate != -1) )
	{
		m_pVideoRes.SetValue(string(pGameOptions.R6ScreenSizeX) $ "x" $ string(pGameOptions.R6ScreenSizeY) $ "@" $ string(pGameOptions.R6ScreenRefreshRate));
	}
	else
	{
		m_pVideoRes.SetValue(string(pGameOptions.R6ScreenSizeX) $ "x" $ string(pGameOptions.R6ScreenSizeY));
	}
	m_pTextureDetail.SetValue(ConvertToGraphicString(15,pGameOptions.TextureDetail,"EGameOptionsGraphicLevel"));
	m_pLightmapDetail.SetValue(ConvertToGraphicString(15,pGameOptions.LightmapDetail,"EGameOptionsGraphicLevel",True));
	m_pRainbowsDetail.SetValue(ConvertToGraphicString(15,pGameOptions.RainbowsDetail,"EGameOptionsGraphicLevel"));
	m_pRainbowsShadowLevel.SetValue(ConvertToGraphicString(11,pGameOptions.RainbowsShadowLevel,"EGameOptionsEffectLevel",True));
	m_pHostagesDetail.SetValue(ConvertToGraphicString(15,pGameOptions.HostagesDetail,"EGameOptionsGraphicLevel"));
	m_pTerrosDetail.SetValue(ConvertToGraphicString(15,pGameOptions.TerrosDetail,"EGameOptionsGraphicLevel"));
	m_pHostagesShadowLevel.SetValue(ConvertToGraphicString(11,pGameOptions.HostagesShadowLevel,"EGameOptionsEffectLevel",True));
	m_pTerrosShadowLevel.SetValue(ConvertToGraphicString(11,pGameOptions.TerrosShadowLevel,"EGameOptionsEffectLevel",True));
	if (  !pGameOptions.SplashScreen )
	{
		m_pGoreLevel.SetValue(ConvertToGraphicString(10,pGameOptions.GoreLevel,"EGameOptionsEffectLevel"));
	}
	m_pDecalsDetail.SetValue(ConvertToGraphicString(15,pGameOptions.DecalsDetail,"EGameOptionsEffectLevel"));
	m_pAnimGeometry.SetButtonBox(pGameOptions.AnimatedGeometry);
	if (  !pGameOptions.SplashScreen )
	{
		m_pHideDeadBodies.SetButtonBox(pGameOptions.HideDeadBodies);
	}
	m_pLowDetailSmoke.SetButtonBox(pGameOptions.LowDetailSmoke);
}

/*function EGameOptionsGraphicLevel ConvertToGLEnum (string _szValueToConvert)
{
	local EGameOptionsGraphicLevel eGLResult;

	switch (_szValueToConvert)
	{
		case m_pComboLevel[1]:
		eGLResult=0;
		break;
		case m_pComboLevel[2]:
		eGLResult=1;
		break;
		case m_pComboLevel[3]:
		eGLResult=2;
		break;
		default:
		break;
	}
	return eGLResult;
}*/

/*function EGameOptionsEffectLevel ConvertToELEnum (string _szValueToConvert)
{
	local EGameOptionsEffectLevel eELResult;

	switch (_szValueToConvert)
	{
		case m_pComboLevel[0]:
		eELResult=0;
		break;
		case m_pComboLevel[1]:
		eELResult=1;
		break;
		case m_pComboLevel[2]:
		eELResult=2;
		break;
		case m_pComboLevel[3]:
		eELResult=3;
		break;
		default:
		break;
	}
	return eELResult;
} */

function string ConvertToGraphicString (int _iAddItemMask, int _iValueToConvert, string _szGraphicsEnumName, optional bool _bCheckFor32MegVideoCard)
{
	local string szResult;

	if ( _szGraphicsEnumName == "EGameOptionsGraphicLevel" )
	{
		switch (_iValueToConvert)
		{
			case 0:
			if ( (_iAddItemMask & 2) > 0 )
			{
				szResult=m_pComboLevel[1];
			}
			break;
			case 1:
			if ( (_iAddItemMask & 4) > 0 )
			{
				szResult=m_pComboLevel[2];
			}
			else
			{
				szResult=ConvertToGraphicString(_iAddItemMask,0,_szGraphicsEnumName,_bCheckFor32MegVideoCard);
			}
			break;
			case 2:
			if ( (_iAddItemMask & 8) > 0 )
			{
				szResult=m_pComboLevel[3];
			}
			else
			{
				szResult=ConvertToGraphicString(_iAddItemMask,1,_szGraphicsEnumName,_bCheckFor32MegVideoCard);
			}
			break;
			default:
			szResult=m_pComboLevel[1];
			break;
		}
	}
	else
	{
		switch (_iValueToConvert)
		{
			case 0:
			if ( (_iAddItemMask & 1) > 0 )
			{
				szResult=m_pComboLevel[0];
			}
			break;
			case 1:
			if ( (_iAddItemMask & 2) > 0 )
			{
				szResult=m_pComboLevel[1];
			}
			else
			{
				szResult=ConvertToGraphicString(_iAddItemMask,0,_szGraphicsEnumName,_bCheckFor32MegVideoCard);
			}
			break;
			case 2:
			if ( (_iAddItemMask & 4) > 0 )
			{
				szResult=m_pComboLevel[2];
			}
			else
			{
				szResult=ConvertToGraphicString(_iAddItemMask,1,_szGraphicsEnumName,_bCheckFor32MegVideoCard);
			}
			break;
			case 3:
			if ( (_iAddItemMask & 8) > 0 )
			{
				szResult=m_pComboLevel[3];
			}
			else
			{
				szResult=ConvertToGraphicString(_iAddItemMask,2,_szGraphicsEnumName,_bCheckFor32MegVideoCard);
			}
			break;
			default:
		}
		szResult=m_pComboLevel[0];
		goto JL01F7;
	}
JL01F7:
	if ( _bCheckFor32MegVideoCard )
	{
		if (  !Class'Actor'.static.IsVideoHardwareAtLeast64M() )
		{
			if ( _szGraphicsEnumName == "EGameOptionsGraphicLevel" )
			{
				if ( szResult == m_pComboLevel[3] )
				{
					szResult=ConvertToGraphicString(_iAddItemMask,1,_szGraphicsEnumName,_bCheckFor32MegVideoCard);
				}
			}
			else
			{
				if ( szResult == m_pComboLevel[3] )
				{
					szResult=ConvertToGraphicString(_iAddItemMask,2,_szGraphicsEnumName,_bCheckFor32MegVideoCard);
				}
			}
		}
	}
	return szResult;
}

function AddGraphComboControlItem (int _iAddItemMask, R6WindowComboControl _pR6WindowComboControl, string _szGraphicsEnumName, optional bool _bCheckFor32MegVideoCard)
{
	local bool bAddHiItem;

	bAddHiItem=True;
	if ( _szGraphicsEnumName == "EGameOptionsEffectLevel" )
	{
		if ( (_iAddItemMask & 1) > 0 )
		{
			_pR6WindowComboControl.AddItem(m_pComboLevel[0],"");
		}
	}
	if ( (_iAddItemMask & 2) > 0 )
	{
		_pR6WindowComboControl.AddItem(m_pComboLevel[1],"");
	}
	if ( (_iAddItemMask & 4) > 0 )
	{
		_pR6WindowComboControl.AddItem(m_pComboLevel[2],"");
	}
	if ( _bCheckFor32MegVideoCard )
	{
		if (  !Class'Actor'.static.IsVideoHardwareAtLeast64M() )
		{
			bAddHiItem=False;
		}
	}
	if ( bAddHiItem && ((_iAddItemMask & 8) > 0) )
	{
		_pR6WindowComboControl.AddItem(m_pComboLevel[3],"");
	}
}

function AddVideoResolution (R6WindowComboControl _pR6WindowComboControl)
{
	local int i;
	local int j;
	local int iWidth;
	local int iHeight;
	local int iRefreshRate;
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	i=Class'Actor'.static.GetNbAvailableResolutions();
	j=0;
JL002B:
	if ( j < i )
	{
		Class'Actor'.static.GetAvailableResolution(j,iWidth,iHeight,iRefreshRate);
		if ( pGameOptions.ShowRefreshRates )
		{
			_pR6WindowComboControl.AddItem(string(iWidth) $ "x" $ string(iHeight) $ "@" $ string(iRefreshRate),"");
		}
		else
		{
			_pR6WindowComboControl.AddItem(string(iWidth) $ "x" $ string(iHeight),"");
		}
		j++;
		goto JL002B;
	}
}

function GetResolutionXY (out int iSX, out int iSY, out int iRR)
{
	local int iX;
	local string szTemp;
	local string szTemp2;
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	szTemp=m_pVideoRes.GetValue();
	iX=InStr(szTemp,"x");
	szTemp2=Left(szTemp,iX);
	iSX=int(szTemp2);
	szTemp=Right(szTemp,Len(szTemp) - iX - 1);
	if ( pGameOptions.ShowRefreshRates )
	{
		iX=InStr(szTemp,"@");
		szTemp2=Left(szTemp,iX);
		iSY=int(szTemp2);
		szTemp=Right(szTemp,Len(szTemp) - iX - 1);
		iRR=int(szTemp);
	}
	else
	{
		iSY=int(szTemp);
		iRR=-1;
	}
}

function InitOptionHud ()
{
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local float fTemp;
	local float fSizeOfCounter;
	local Font ButtonFont;

	ButtonFont=Root.Fonts[5];
//	m_ePageOptID=3;
	fXOffset=5.00;
	fYOffset=5.00;
	fWidth=WinWidth * 0.50 - 2 * fXOffset;
	fHeight=15.00;
	fYStep=17.00;
	m_pHudWeaponName=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudWeaponName.SetButtonBox(True);
	m_pHudWeaponName.CreateTextAndBox(Localize("Options","Opt_HudWeapon","R6Menu"),Localize("Tip","Opt_HudWeapon","R6Menu"),0.00,0);
	fYOffset += fYStep;
	m_pHudShowFPWeapon=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudShowFPWeapon.SetButtonBox(False);
	m_pHudShowFPWeapon.CreateTextAndBox(Localize("Options","Opt_HudShowFPWeapon","R6Menu"),Localize("Tip","Opt_HudShowFPWeapon","R6Menu"),0.00,1);
	fYOffset += fYStep;
	m_pHudOtherTInfo=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudOtherTInfo.SetButtonBox(True);
	m_pHudOtherTInfo.CreateTextAndBox(Localize("Options","Opt_HudOtherTInfo","R6Menu"),Localize("Tip","Opt_HudOtherTInfo","R6Menu"),0.00,2);
	fYOffset += fYStep;
	m_pHudCurTInfo=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudCurTInfo.SetButtonBox(True);
	m_pHudCurTInfo.CreateTextAndBox(Localize("Options","Opt_HudCurTInfo","R6Menu"),Localize("Tip","Opt_HudCurTInfo","R6Menu"),0.00,3);
	fYOffset += fYStep;
	m_pHudCircumIcon=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudCircumIcon.SetButtonBox(True);
	m_pHudCircumIcon.CreateTextAndBox(Localize("Options","Opt_HudCircumIcon","R6Menu"),Localize("Tip","Opt_HudCircumIcon","R6Menu"),0.00,4);
	fXOffset=WinWidth * 0.50 + fXOffset;
	fYOffset=5.00;
	m_pHudWpInfo=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudWpInfo.SetButtonBox(True);
	m_pHudWpInfo.CreateTextAndBox(Localize("Options","Opt_HudWPInfo","R6Menu"),Localize("Tip","Opt_HudWPInfo","R6Menu"),0.00,5);
	fYOffset += fYStep;
	m_pHudReticule=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudReticule.SetButtonBox(True);
	m_pHudReticule.CreateTextAndBox(Localize("Options","Opt_HudCrossHair","R6Menu"),Localize("Tip","Opt_HudCrossHair","R6Menu"),0.00,6);
	fYOffset += fYStep;
	m_pHudShowTNames=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudShowTNames.SetButtonBox(True);
	m_pHudShowTNames.CreateTextAndBox(Localize("Options","Opt_HudShowTNames","R6Menu"),Localize("Tip","Opt_HudShowTNames","R6Menu"),0.00,7);
	fYOffset += fYStep;
	m_pHudCharInfo=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudCharInfo.SetButtonBox(True);
	m_pHudCharInfo.CreateTextAndBox(Localize("Options","Opt_HudCharInfo","R6Menu"),Localize("Tip","Opt_HudCharInfo","R6Menu"),0.00,8);
	fYOffset += fYStep;
	m_pHudShowRadar=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pHudShowRadar.SetButtonBox(True);
	m_pHudShowRadar.CreateTextAndBox(Localize("Options","Opt_HudShowRadar","R6Menu"),Localize("Tip","Opt_HudShowRadar","R6Menu"),0.00,9);
	CreateHudOptionsTex();
	InitResetButton();
	SetMenuHudValues();
	m_bInitComplete=True;
}

function SetHudValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	pGameOptions.HUDShowWeaponInfo=m_pHudWeaponName.m_bSelected;
	pGameOptions.HUDShowFPWeapon=m_pHudShowFPWeapon.m_bSelected;
	pGameOptions.HUDShowOtherTeamInfo=m_pHudOtherTInfo.m_bSelected;
	pGameOptions.HUDShowCurrentTeamInfo=m_pHudCurTInfo.m_bSelected;
	pGameOptions.HUDShowActionIcon=m_pHudCircumIcon.m_bSelected;
	pGameOptions.HUDShowWaypointInfo=m_pHudWpInfo.m_bSelected;
	pGameOptions.HUDShowReticule=m_pHudReticule.m_bSelected;
	pGameOptions.HUDShowCharacterInfo=m_pHudCharInfo.m_bSelected;
	pGameOptions.HUDShowPlayersName=m_pHudShowTNames.m_bSelected;
	pGameOptions.ShowRadar=m_pHudShowRadar.m_bSelected;
	UpdateHudOptionsTex();
}

function SetMenuHudValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	m_pHudWeaponName.SetButtonBox(pGameOptions.HUDShowWeaponInfo);
	m_pHudShowFPWeapon.SetButtonBox(pGameOptions.HUDShowFPWeapon);
	m_pHudOtherTInfo.SetButtonBox(pGameOptions.HUDShowOtherTeamInfo);
	m_pHudCurTInfo.SetButtonBox(pGameOptions.HUDShowCurrentTeamInfo);
	m_pHudCircumIcon.SetButtonBox(pGameOptions.HUDShowActionIcon);
	m_pHudWpInfo.SetButtonBox(pGameOptions.HUDShowWaypointInfo);
	m_pHudReticule.SetButtonBox(pGameOptions.HUDShowReticule);
	m_pHudCharInfo.SetButtonBox(pGameOptions.HUDShowCharacterInfo);
	m_pHudShowTNames.SetButtonBox(pGameOptions.HUDShowPlayersName);
	m_pHudShowRadar.SetButtonBox(pGameOptions.ShowRadar);
	UpdateHudOptionsTex();
}

function CreateHudOptionsTex ()
{
//	m_pHudBGTex=CreateHudBitmapWindow(Texture'DisplayBackground',True);
	m_pHudBGTex.bAlwaysBehind=True;
	m_pHudBGTex.m_BorderColor=Root.Colors.White;
/*	m_pHudWeaponNameTex=CreateHudBitmapWindow(Texture'DisplayWeaponInfo');
	m_pHudShowFPWeaponTex=CreateHudBitmapWindow(Texture'Display1stPersonWeapon');
	m_pHudOtherTInfoTex=CreateHudBitmapWindow(Texture'DisplayOtherTeamInfo');
	m_pHudCurTInfoTex=CreateHudBitmapWindow(Texture'DisplayCurrentTeamInfo');
	m_pHudCircumIconTex=CreateHudBitmapWindow(Texture'DisplayActionIcon');
	m_pHudWpInfoTex=CreateHudBitmapWindow(Texture'DisplayWaypointInfo');
	m_pHudReticuleTex=CreateHudBitmapWindow(Texture'DisplayReticule');
	m_pHudCharInfoTex=CreateHudBitmapWindow(Texture'DisplayCharacterInfo');
	m_pHudShowTNamesTex=CreateHudBitmapWindow(Texture'DisplayTeammateNames');
	m_pHudShowRadarTex=CreateHudBitmapWindow(Texture'DisplayMPRadar');*/
}

function R6WindowBitMap CreateHudBitmapWindow (Texture _Tex, optional bool _bDrawSimpleBorder)
{
	local R6WindowBitMap _NewR6WindowBitMap;

	_NewR6WindowBitMap=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',77.00,96.00,262.00,198.00,self));
	_NewR6WindowBitMap.t=_Tex;
	_NewR6WindowBitMap.R=NewRegion(0.00,0.00,260.00,196.00);
	_NewR6WindowBitMap.m_iDrawStyle=5;
	_NewR6WindowBitMap.m_bDrawBorder=_bDrawSimpleBorder;
	_NewR6WindowBitMap.m_ImageX=1.00;
	_NewR6WindowBitMap.m_ImageY=1.00;
	return _NewR6WindowBitMap;
}

function UpdateHudOptionsTex ()
{
	m_pHudWeaponNameTex.HideWindow();
	m_pHudShowFPWeaponTex.HideWindow();
	m_pHudOtherTInfoTex.HideWindow();
	m_pHudCurTInfoTex.HideWindow();
	m_pHudCircumIconTex.HideWindow();
	m_pHudWpInfoTex.HideWindow();
	m_pHudReticuleTex.HideWindow();
	m_pHudCharInfoTex.HideWindow();
	m_pHudShowTNamesTex.HideWindow();
	m_pHudShowRadarTex.HideWindow();
	if ( m_pHudWeaponName.m_bSelected )
	{
		m_pHudWeaponNameTex.ShowWindow();
	}
	if ( m_pHudShowTNames.m_bSelected )
	{
		m_pHudShowTNamesTex.ShowWindow();
	}
	if ( m_pHudShowFPWeapon.m_bSelected )
	{
		m_pHudShowFPWeaponTex.ShowWindow();
	}
	if ( m_pHudOtherTInfo.m_bSelected )
	{
		m_pHudOtherTInfoTex.ShowWindow();
	}
	if ( m_pHudCurTInfo.m_bSelected )
	{
		m_pHudCurTInfoTex.ShowWindow();
	}
	if ( m_pHudCircumIcon.m_bSelected )
	{
		m_pHudCircumIconTex.ShowWindow();
	}
	if ( m_pHudWpInfo.m_bSelected )
	{
		m_pHudWpInfoTex.ShowWindow();
	}
	if ( m_pHudReticule.m_bSelected )
	{
		m_pHudReticuleTex.ShowWindow();
	}
	if ( m_pHudCharInfo.m_bSelected )
	{
		m_pHudCharInfoTex.ShowWindow();
	}
	if ( m_pHudShowRadar.m_bSelected )
	{
		m_pHudShowRadarTex.ShowWindow();
	}
}

function InitOptionMulti (bool _bInGameOptions)
{
	local Region rRegionW;
	local float fXOffset;
	local float fYOffset;
	local float fYStep;
	local float fWidth;
	local float fHeight;
	local float fTemp;
	local float fSizeOfCounter;
	local Font ButtonFont;

	ButtonFont=Root.Fonts[5];
//	m_ePageOptID=4;
	fXOffset=5.00;
	fYOffset=5.00;
	fWidth=WinWidth - fXOffset - 20;
	fHeight=15.00;
	fYStep=27.00;
	m_pOptionPlayerName=R6WindowEditControl(CreateWindow(Class'R6WindowEditControl',fXOffset,fYOffset,fWidth,fHeight,self));
	m_pOptionPlayerName.SetValue("");
	m_pOptionPlayerName.CreateTextLabel(Localize("Options","Opt_NetPlayerName","R6Menu"),0.00,0.00,fWidth * 0.50,fHeight);
	m_pOptionPlayerName.SetEditBoxTip(Localize("Tip","Opt_NetPlayerName","R6Menu"));
	m_pOptionPlayerName.ModifyEditBoxW(250.00,0.00,135.00,fHeight);
	m_pOptionPlayerName.EditBox.MaxLength=15;
	fYOffset += fYStep;
	rRegionW.X=fXOffset;
	rRegionW.Y=fYOffset;
	rRegionW.W=fWidth;
	rRegionW.H=fHeight;
	m_pSpeedConnection=SetComboControlButton(rRegionW,Localize("Options","Opt_NetConnecSpeed","R6Menu"),Localize("Tip","Opt_NetConnecSpeed","R6Menu"));
	m_pSpeedConnection.AddItem(m_pConnectionSpeed[0],"");
	m_pSpeedConnection.AddItem(m_pConnectionSpeed[1],"");
	m_pSpeedConnection.AddItem(m_pConnectionSpeed[2],"");
	m_pSpeedConnection.AddItem(m_pConnectionSpeed[3],"");
	m_pSpeedConnection.AddItem(m_pConnectionSpeed[4],"");
	fYOffset += fYStep;
	fWidth -= 20;
	m_pOptionGender=R6WindowButtonExt(CreateControl(Class'R6WindowButtonExt',fXOffset,fYOffset,WinWidth - fXOffset,fHeight,self));
	m_pOptionGender.CreateTextAndBox(Localize("Options","Opt_NetGender","R6Menu"),Localize("Tip","Opt_NetGender","R6Menu"),0.00,0,2);
	m_pOptionGender.SetCheckBox(Localize("Options","Opt_NetGenderMale","R6Menu"),250.00,True,0);
	m_pOptionGender.SetCheckBox(Localize("Options","Opt_NetGenderFemale","R6Menu"),356.00,False,1);
	fYOffset += fYStep;
	m_pArmpatchChooser=R6MenuArmpatchSelect(CreateWindow(Class'R6MenuArmpatchSelect',fXOffset,fYOffset,WinWidth - fXOffset,m_RArmpatchListPos.H,self));
	m_pArmpatchChooser.CreateTextLabel(0,0,m_RArmpatchListPos.X,m_pArmpatchChooser.WinHeight,Localize("Options","Opt_NetUArmP","R6Menu"),Localize("Tip","Opt_NetUArmP","R6Menu"));
	m_pArmpatchChooser.CreateListBox(m_RArmpatchListPos.X,m_RArmpatchListPos.Y,m_RArmpatchListPos.W,m_RArmpatchListPos.H);
	m_pArmpatchChooser.CreateArmPatchBitmap(m_RArmpatchBitmapPos.X,m_RArmpatchBitmapPos.Y,m_RArmpatchBitmapPos.W,m_RArmpatchBitmapPos.H);
	m_pArmpatchChooser.RefreshListBox();
	m_pArmpatchChooser.SetToolTip(Localize("Tip","Opt_NetUArmP","R6Menu"));
	InitResetButton();
	SetMenuMultiValues();
	m_bInitComplete=True;
}

function SetMultiValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	if ( m_pOptionPlayerName.GetValue() != m_pOptionPlayerName.GetValue2() )
	{
		GetPlayerOwner().Name(m_pOptionPlayerName.GetValue());
		m_pOptionPlayerName.SetValue(m_pOptionPlayerName.GetValue(),m_pOptionPlayerName.GetValue());
	}
//	pGameOptions.NetSpeed=ConvertToNSEnum(m_pSpeedConnection.GetValue());
	switch (pGameOptions.NetSpeed)
	{
/*		case 0:
		Root.Console.ConsoleCommand("NETSPEED 20000");
		break;
		case 1:
		Root.Console.ConsoleCommand("NETSPEED 20000");
		break;
		case 2:
		Root.Console.ConsoleCommand("NETSPEED 4000");
		break;
		case 3:
		Root.Console.ConsoleCommand("NETSPEED 5000");
		break;
		case 4:
		Root.Console.ConsoleCommand("NETSPEED 1500");
		break;
		default:
		Root.Console.ConsoleCommand("NETSPEED 5000");
		break;    */
	}
	pGameOptions.Gender=m_pOptionGender.GetCheckBoxStatus();
	pGameOptions.ArmPatchTexture=m_pArmpatchChooser.GetSelectedArmpatch();
}

function SetMenuMultiValues ()
{
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	if (  !m_bInitComplete )
	{
		m_pOptionPlayerName.SetValue(pGameOptions.characterName,pGameOptions.characterName);
	}
	else
	{
		m_pOptionPlayerName.SetValue(pGameOptions.characterName,m_pOptionPlayerName.GetValue2());
	}
	m_pOptionPlayerName.EditBox.MoveHome();
	m_pSpeedConnection.SetValue(ConvertToNetSpeedString(pGameOptions.NetSpeed));
	m_pOptionGender.SetCheckBoxStatus(pGameOptions.Gender);
	m_pArmpatchChooser.SetDesiredSelectedArmpatch(pGameOptions.ArmPatchTexture);
}

/*function EGameOptionsNetSpeed ConvertToNSEnum (string _szValueToConvert)
{
	local EGameOptionsNetSpeed eNSResult;

	switch (_szValueToConvert)
	{
		case m_pConnectionSpeed[0]:
		eNSResult=0;
		break;
		case m_pConnectionSpeed[1]:
		eNSResult=1;
		break;
		case m_pConnectionSpeed[2]:
		eNSResult=2;
		break;
		case m_pConnectionSpeed[3]:
		eNSResult=3;
		break;
		case m_pConnectionSpeed[4]:
		eNSResult=4;
		break;
		default:
		eNSResult=0;
		break;
	}
	return eNSResult;
} */

function string ConvertToNetSpeedString (int _iValueToConvert)
{
	local string szResult;

	switch (_iValueToConvert)
	{
		case 0:
		szResult=m_pConnectionSpeed[0];
		break;
		case 1:
		szResult=m_pConnectionSpeed[1];
		break;
		case 2:
		szResult=m_pConnectionSpeed[2];
		break;
		case 3:
		szResult=m_pConnectionSpeed[3];
		break;
		case 4:
		szResult=m_pConnectionSpeed[4];
		break;
		default:
		szResult=m_pConnectionSpeed[0];
		break;
	}
	return szResult;
}

function InitOptionControls ()
{
	local float fXOffset;
	local float fYOffset;

//	m_ePageOptID=5;
	fXOffset=0.00;
	fYOffset=0.00;
	m_pListControls=R6WindowListControls(CreateControl(Class'R6WindowListControls',fXOffset,fYOffset,WinWidth - fXOffset,WinHeight - 14 - fYOffset,self));
	m_pListControls.m_fItemHeight=15.00;
	m_pListControls.m_fXOffSet=5.00;
	CreateKeyPopUp();
	AddTitleItem("",m_pListControls);
	AddTitleItem(Localize("Keys","Title_Move","R6Menu"),m_pListControls);
	AddKeyItem(Localize("Keys","K_MoveForward","R6Menu"),Localize("Keys","K_MoveForward","R6Menu"),"MoveForward",m_pListControls);
	AddKeyItem(Localize("Keys","K_MoveBackward","R6Menu"),Localize("Keys","K_MoveBackward","R6Menu"),"MoveBackward",m_pListControls);
	AddKeyItem(Localize("Keys","K_StrafeLeft","R6Menu"),Localize("Keys","K_StrafeLeft","R6Menu"),"StrafeLeft",m_pListControls);
	AddKeyItem(Localize("Keys","K_StrafeRight","R6Menu"),Localize("Keys","K_StrafeRight","R6Menu"),"StrafeRight",m_pListControls);
	AddKeyItem(Localize("Keys","K_PeekLeft","R6Menu"),Localize("Keys","K_PeekLeft","R6Menu"),"PeekLeft",m_pListControls);
	AddKeyItem(Localize("Keys","K_PeekRight","R6Menu"),Localize("Keys","K_PeekRight","R6Menu"),"PeekRight",m_pListControls);
	AddKeyItem(Localize("Keys","K_RaisePosture","R6Menu"),Localize("Keys","K_RaisePosture","R6Menu"),"RaisePosture",m_pListControls);
	AddKeyItem(Localize("Keys","K_LowerPosture","R6Menu"),Localize("Keys","K_LowerPosture","R6Menu"),"LowerPosture",m_pListControls);
	AddKeyItem(Localize("Keys","K_Run","R6Menu"),Localize("Keys","K_Run","R6Menu"),"Run",m_pListControls);
	AddKeyItem(Localize("Keys","K_FluidPosture","R6Menu"),Localize("Keys","K_FluidPosture","R6Menu"),"FluidPosture",m_pListControls);
	AddLineItem(m_pListControls);
	AddTitleItem(Localize("Keys","Title_Weapon","R6Menu"),m_pListControls);
	AddKeyItem(Localize("Keys","K_Reload","R6Menu"),Localize("Keys","K_Reload","R6Menu"),"Reload",m_pListControls);
	AddKeyItem(Localize("Keys","K_PrimaryWeapon","R6Menu"),Localize("Keys","K_PrimaryWeapon","R6Menu"),"PrimaryWeapon",m_pListControls);
	AddKeyItem(Localize("Keys","K_SecondaryWeapon","R6Menu"),Localize("Keys","K_SecondaryWeapon","R6Menu"),"SecondaryWeapon",m_pListControls);
	AddKeyItem(Localize("Keys","K_GadgetOne","R6Menu"),Localize("Keys","K_GadgetOne","R6Menu"),"GadgetOne",m_pListControls);
	AddKeyItem(Localize("Keys","K_GadgetTwo","R6Menu"),Localize("Keys","K_GadgetTwo","R6Menu"),"GadgetTwo",m_pListControls);
	AddKeyItem(Localize("Keys","K_ChangeRateOfFire","R6Menu"),Localize("Keys","K_ChangeRateOfFire","R6Menu"),"ChangeRateOfFire",m_pListControls);
	AddKeyItem(Localize("Keys","K_PrimaryFire","R6Menu"),Localize("Keys","K_PrimaryFire","R6Menu"),"PrimaryFire",m_pListControls);
	AddKeyItem(Localize("Keys","K_SecondaryFire","R6Menu"),Localize("Keys","K_SecondaryFire","R6Menu"),"SecondaryFire",m_pListControls);
	AddKeyItem(Localize("Keys","K_Zoom","R6Menu"),Localize("Keys","K_Zoom","R6Menu"),"Zoom",m_pListControls);
	AddKeyItem(Localize("Keys","K_InventoryMenu","R6Menu"),Localize("Keys","K_InventoryMenu","R6Menu"),"InventoryMenu",m_pListControls);
	AddLineItem(m_pListControls);
	AddTitleItem(Localize("Keys","Title_Orders","R6Menu"),m_pListControls);
	AddKeyItem(Localize("Keys","K_GoCodeAlpha","R6Menu"),Localize("Keys","K_GoCodeAlpha","R6Menu"),"GoCodeAlpha",m_pListControls);
	AddKeyItem(Localize("Keys","K_GoCodeBravo","R6Menu"),Localize("Keys","K_GoCodeBravo","R6Menu"),"GoCodeBravo",m_pListControls);
	AddKeyItem(Localize("Keys","K_GoCodeCharlie","R6Menu"),Localize("Keys","K_GoCodeCharlie","R6Menu"),"GoCodeCharlie",m_pListControls);
	AddKeyItem(Localize("Keys","K_GoCodeZulu","R6Menu"),Localize("Keys","K_GoCodeZulu","R6Menu"),"GoCodeZulu",m_pListControls);
	AddKeyItem(Localize("Keys","K_RulesOfEngagement","R6Menu"),Localize("Keys","K_RulesOfEngagement","R6Menu"),"RulesOfEngagement",m_pListControls);
	AddKeyItem(Localize("Keys","K_SkipDestination","R6Menu"),Localize("Keys","K_SkipDestination","R6Menu"),"SkipDestination",m_pListControls);
	AddKeyItem(Localize("Keys","K_ToggleAllTeamsHold","R6Menu"),Localize("Keys","K_ToggleAllTeamsHold","R6Menu"),"ToggleAllTeamsHold",m_pListControls);
	AddKeyItem(Localize("Keys","K_ToggleTeamHold","R6Menu"),Localize("Keys","K_ToggleTeamHold","R6Menu"),"ToggleTeamHold",m_pListControls);
	AddKeyItem(Localize("Keys","K_ToggleSniperControl","R6Menu"),Localize("Keys","K_ToggleSniperControl","R6Menu"),"ToggleSniperControl",m_pListControls);
	AddLineItem(m_pListControls);
	AddTitleItem(Localize("Keys","Title_Actions","R6Menu"),m_pListControls);
	AddKeyItem(Localize("Keys","K_GraduallyOpenDoor","R6Menu"),Localize("Keys","K_GraduallyOpenDoor","R6Menu"),"GraduallyOpenDoor",m_pListControls);
	AddKeyItem(Localize("Keys","K_GraduallyCloseDoor","R6Menu"),Localize("Keys","K_GraduallyCloseDoor","R6Menu"),"GraduallyCloseDoor",m_pListControls);
	AddKeyItem(Localize("Keys","K_SpeedUpDoor","R6Menu"),Localize("Keys","K_SpeedUpDoor","R6Menu"),"SpeedUpDoor",m_pListControls);
	AddKeyItem(Localize("Keys","K_Action","R6Menu"),Localize("Keys","K_Action","R6Menu"),"Action",m_pListControls);
	AddKeyItem(Localize("Keys","K_ToggleNightVision","R6Menu"),Localize("Keys","K_ToggleNightVision","R6Menu"),"ToggleNightVision",m_pListControls);
	AddKeyItem(Localize("Keys","K_NextTeam","R6Menu"),Localize("Keys","K_NextTeam","R6Menu"),"NextTeam",m_pListControls);
	AddKeyItem(Localize("Keys","K_PreviousTeam","R6Menu"),Localize("Keys","K_PreviousTeam","R6Menu"),"PreviousTeam",m_pListControls);
	AddKeyItem(Localize("Keys","K_NextMember","R6Menu"),Localize("Keys","K_NextMember","R6Menu"),"NextMember",m_pListControls);
	AddKeyItem(Localize("Keys","K_PreviousMember","R6Menu"),Localize("Keys","K_PreviousMember","R6Menu"),"PreviousMember",m_pListControls);
	AddKeyItem(Localize("Keys","K_ToggleMap","R6Menu"),Localize("Keys","K_ToggleMap","R6Menu"),"ToggleMap",m_pListControls);
	AddKeyItem(Localize("Keys","K_MapZoomIn","R6Menu"),Localize("Keys","K_MapZoomIn","R6Menu"),"MapZoomIn",m_pListControls);
	AddKeyItem(Localize("Keys","K_MapZoomOut","R6Menu"),Localize("Keys","K_MapZoomOut","R6Menu"),"MapZoomOut",m_pListControls);
	AddKeyItem(Localize("Keys","K_OperativeSelector","R6Menu"),Localize("Keys","K_OperativeSelector","R6Menu"),"OperativeSelector",m_pListControls);
	AddLineItem(m_pListControls);
	AddTitleItem(Localize("Keys","Title_MP","R6Menu"),m_pListControls);
	AddKeyItem(Localize("Keys","K_ToggleGameStats","R6Menu"),Localize("Keys","K_ToggleGameStats","R6Menu"),"ToggleGameStats",m_pListControls);
	AddKeyItem(Localize("Keys","K_Talk","R6Menu"),Localize("Keys","K_Talk","R6Menu"),"Talk",m_pListControls);
	AddKeyItem(Localize("Keys","K_TeamTalk","R6Menu"),Localize("Keys","K_TeamTalk","R6Menu"),"TeamTalk",m_pListControls);
	AddKeyItem(Localize("Keys","K_DrawingTool","R6Menu"),Localize("Keys","K_DrawingTool","R6Menu"),"DrawingTool",m_pListControls);
	AddKeyItem(Localize("Keys","K_PreRecMessages","R6Menu"),Localize("Keys","K_PreRecMessages","R6Menu"),"PreRecMessages",m_pListControls);
	AddKeyItem(Localize("Keys","K_VotingMenu","R6Menu"),Localize("Keys","K_VotingMenu","R6Menu"),"VotingMenu",m_pListControls);
	AddLineItem(m_pListControls);
	AddTitleItem(Localize("Keys","Title_Others","R6Menu"),m_pListControls);
	AddKeyItem(Localize("Keys","K_Console","R6Menu"),Localize("Keys","K_Console","R6Menu"),"Console",m_pListControls);
	AddKeyItem(Localize("Keys","K_ToggleAutoAim","R6Menu"),Localize("Keys","K_ToggleAutoAim","R6Menu"),"ToggleAutoAim",m_pListControls);
	AddKeyItem(Localize("Keys","K_Shot","R6Menu"),Localize("Keys","K_Shot","R6Menu"),"Shot",m_pListControls);
	AddKeyItem(Localize("Keys","K_ShowCompleteHud","R6Menu"),Localize("Keys","K_ShowCompleteHud","R6Menu"),"ShowCompleteHud",m_pListControls);
	AddLineItem(m_pListControls);
	AddTitleItem(Localize("Keys","Title_Planning","R6Menu"),m_pListControls);
	AddKeyItem(Localize("Keys","K_MoveUp","R6Menu"),Localize("Keys","K_MoveUp","R6Menu"),"MoveUp",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_MoveDown","R6Menu"),Localize("Keys","K_MoveDown","R6Menu"),"MoveDown",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_MoveLeft","R6Menu"),Localize("Keys","K_MoveLeft","R6Menu"),"MoveLeft",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_MoveRight","R6Menu"),Localize("Keys","K_MoveRight","R6Menu"),"MoveRight",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_ZoomIn","R6Menu"),Localize("Keys","K_ZoomIn","R6Menu"),"ZoomIn",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_ZoomOut","R6Menu"),Localize("Keys","K_ZoomOut","R6Menu"),"ZoomOut",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_LevelUp","R6Menu"),Localize("Keys","K_LevelUp","R6Menu"),"LevelUp",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_LevelDown","R6Menu"),Localize("Keys","K_LevelDown","R6Menu"),"LevelDown",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_RotateClockWise","R6Menu"),Localize("Keys","K_RotateClockWise","R6Menu"),"RotateClockWise",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_RotateCounterClockWise","R6Menu"),Localize("Keys","K_RotateCounterClockWise","R6Menu"),"RotateCounterClockWise",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_DeleteWaypoint","R6Menu"),Localize("Keys","K_DeleteWaypoint","R6Menu"),"DeleteWaypoint",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_NextWaypoint","R6Menu"),Localize("Keys","K_NextWaypoint","R6Menu"),"NextWaypoint",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_PrevWaypoint","R6Menu"),Localize("Keys","K_PrevWaypoint","R6Menu"),"PrevWaypoint",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_FirstWaypoint","R6Menu"),Localize("Keys","K_FirstWaypoint","R6Menu"),"FirstWaypoint",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_LastWaypoint","R6Menu"),Localize("Keys","K_LastWaypoint","R6Menu"),"LastWaypoint",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_AngleUp","R6Menu"),Localize("Keys","K_AngleUp","R6Menu"),"AngleUp",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_AngleDown","R6Menu"),Localize("Keys","K_AngleDown","R6Menu"),"AngleDown",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_RedTeam","R6Menu"),Localize("Keys","K_RedTeam","R6Menu"),"SwitchToRedTeam",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_GreenTeam","R6Menu"),Localize("Keys","K_GreenTeam","R6Menu"),"SwitchToGreenTeam",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_GoldTeam","R6Menu"),Localize("Keys","K_GoldTeam","R6Menu"),"SwitchToGoldTeam",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_ViewRed","R6Menu"),Localize("Keys","K_ViewRed","R6Menu"),"ViewRedTeam",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_ViewGreen","R6Menu"),Localize("Keys","K_ViewGreen","R6Menu"),"ViewGreenTeam",m_pListControls,True);
	AddKeyItem(Localize("Keys","K_ViewGold","R6Menu"),Localize("Keys","K_ViewGold","R6Menu"),"ViewGoldTeam",m_pListControls,True);
	InitResetButton();
	m_bInitComplete=True;
}

function AddLineItem (R6WindowListControls _pR6WindowListControls)
{
	local UWindowListBoxItem NewItem;

	NewItem=UWindowListBoxItem(_pR6WindowListControls.Items.Append(_pR6WindowListControls.ListClass));
	NewItem.HelpText="";
	NewItem.m_bImALine=True;
	NewItem.m_vItemColor=Root.Colors.White;
	NewItem.m_bNotAffectByNotify=True;
}

function AddTitleItem (string _szTitle, R6WindowListControls _pR6WindowListControls)
{
	local UWindowListBoxItem NewItem;

	NewItem=UWindowListBoxItem(_pR6WindowListControls.Items.Append(_pR6WindowListControls.ListClass));
	NewItem.HelpText=_szTitle;
	NewItem.m_vItemColor=Root.Colors.White;
	NewItem.m_bNotAffectByNotify=True;
}

function AddKeyItem (string _szTitle, string _szToolTip, string _szActionKey, R6WindowListControls _pR6WindowListControls, optional bool _bPlanningInput)
{
	local UWindowListBoxItem NewItem;

	NewItem=UWindowListBoxItem(_pR6WindowListControls.Items.Append(_pR6WindowListControls.ListClass));
	NewItem.HelpText=_szTitle;
	NewItem.m_szToolTip=_szToolTip;
	NewItem.m_vItemColor=Root.Colors.White;
	NewItem.m_szActionKey=_szActionKey;
	NewItem.m_szFakeEditBoxValue=GetLocKeyNameByActionKey(_szActionKey,_bPlanningInput);
	NewItem.m_fXFakeEditBox=220.00;
	NewItem.m_fWFakeEditBox=WinWidth - NewItem.m_fXFakeEditBox - 40;
	if ( _bPlanningInput )
	{
		NewItem.m_iItemID=1;
	}
	else
	{
		NewItem.m_iItemID=0;
	}
}

function RefreshKeyList ()
{
	local UWindowList ListItem;
	local string szTemp;

	ListItem=m_pListControls.Items.Next;
JL001D:
	if ( ListItem != None )
	{
		if (  !UWindowListBoxItem(ListItem).m_bNotAffectByNotify )
		{
			if ( UWindowListBoxItem(ListItem).m_iItemID == 0 )
			{
				UWindowListBoxItem(ListItem).m_szFakeEditBoxValue=GetLocKeyNameByActionKey(UWindowListBoxItem(ListItem).m_szActionKey,False);
			}
			else
			{
				UWindowListBoxItem(ListItem).m_szFakeEditBoxValue=GetLocKeyNameByActionKey(UWindowListBoxItem(ListItem).m_szActionKey,True);
			}
		}
		ListItem=ListItem.Next;
		goto JL001D;
	}
}

function string GetLocKeyNameByActionKey (string _szActionKey, optional bool _bPlanningInput)
{
	local string szTemp;
	local byte Key;

	Key=GetPlayerOwner().GetKey(_szActionKey,_bPlanningInput);
	szTemp=GetPlayerOwner().GetEnumName(Key,_bPlanningInput);
	szTemp=GetPlayerOwner().Player.Console.ConvertKeyToLocalisation(Key,szTemp);
	return szTemp;
}

function CreateKeyPopUp ()
{
	local R6WindowTextLabelExt pR6TextLabelExt;
	local float fPopUpWidth;

	fPopUpWidth=380.00;
	m_pPopUpKeyBG=R6WindowPopUpBox(OwnerWindow.CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,OwnerWindow.WinWidth,OwnerWindow.WinHeight,self));
	m_pPopUpKeyBG.CreatePopUpFrameWindow(Localize("Options","Opt_ControlsMapKey","R6Menu"),30.00,130.00,150.00,fPopUpWidth,70.00);
	m_pPopUpKeyBG.CreateClientWindow(Class'R6WindowTextLabelExt');
	m_pPopUpKeyBG.m_bForceButtonLine=True;
	pR6TextLabelExt=R6WindowTextLabelExt(m_pPopUpKeyBG.m_ClientArea);
	pR6TextLabelExt.SetNoBorder();
	pR6TextLabelExt.m_Font=Root.Fonts[5];
	pR6TextLabelExt.m_vTextColor=Root.Colors.White;
//	pR6TextLabelExt.AddTextLabel("",0.00,3.00,fPopUpWidth,2,False);
//	pR6TextLabelExt.AddTextLabel("",0.00,15.00,fPopUpWidth,2,False);
//	pR6TextLabelExt.AddTextLabel(Localize("Options","Key_Map","R6Menu"),0.00,27.00,fPopUpWidth,2,False);
	m_pPopUpKeyBG.Close();
	m_pKeyMenuReAssignPopUp=R6WindowPopUpBox(OwnerWindow.CreateWindow(Class'R6WindowPopUpBox',0.00,0.00,OwnerWindow.WinWidth,OwnerWindow.WinHeight,self));
	m_pKeyMenuReAssignPopUp.CreatePopUpFrameWindow(Localize("Options","Opt_ControlsReMapKey","R6Menu"),30.00,140.00,150.00,fPopUpWidth,70.00);
	m_pKeyMenuReAssignPopUp.CreateClientWindow(Class'R6WindowTextLabelExt');
	m_pKeyMenuReAssignPopUp.m_bForceButtonLine=True;
	pR6TextLabelExt=R6WindowTextLabelExt(m_pKeyMenuReAssignPopUp.m_ClientArea);
	pR6TextLabelExt.SetNoBorder();
	pR6TextLabelExt.m_Font=Root.Fonts[5];
	pR6TextLabelExt.m_vTextColor=Root.Colors.White;
//	pR6TextLabelExt.AddTextLabel("",0.00,3.00,fPopUpWidth,2,False);
//	pR6TextLabelExt.AddTextLabel(Localize("Options","Key_Press","R6Menu"),0.00,27.00,fPopUpWidth,2,False);
	m_pKeyMenuReAssignPopUp.Close();
}

function ManagePopUpKey (UWindowDialogControl C)
{
	local R6WindowTextLabelExt pR6TextLabelExt;

	m_pCurItem=R6WindowListControls(C).GetSelectedItem();
	if (  !m_pCurItem.m_bNotAffectByNotify )
	{
		pR6TextLabelExt=R6WindowTextLabelExt(m_pPopUpKeyBG.m_ClientArea);
		if ( GetCurKeyName() == "" )
		{
			pR6TextLabelExt.ChangeTextLabel(m_pCurItem.HelpText $ " " $ Localize("Options","Key_Advice","R6Menu") $ " " $ Localize("Options","Key_Nothing","R6Menu"),0);
			pR6TextLabelExt.ChangeTextLabel(" ",1);
		}
		else
		{
			pR6TextLabelExt.ChangeTextLabel(m_pCurItem.HelpText $ " " $ Localize("Options","Key_Advice","R6Menu"),0);
			pR6TextLabelExt.ChangeTextLabel(GetCurKeyName(),1);
		}
		m_pPopUpKeyBG.ShowWindow();
		m_pOptControls=R6MenuOptionsControls(OwnerWindow.CreateWindow(Class'R6MenuOptionsControls',0.00,0.00,OwnerWindow.WinWidth,OwnerWindow.WinHeight,self,True));
		m_pOptControls.Register(self);
	}
}

function CloseAllKeyPopUp (optional bool _bCloseKeyControlTo)
{
	if ( m_pPopUpKeyBG.bWindowVisible )
	{
		m_pPopUpKeyBG.Close();
	}
	else
	{
		if ( m_pKeyMenuReAssignPopUp.bWindowVisible )
		{
			m_pKeyMenuReAssignPopUp.Close();
		}
	}
	if ( _bCloseKeyControlTo )
	{
		m_pOptControls.HideWindow();
	}
}

function UWindowListBoxItem GetCurrentKeyItem ()
{
	return m_pCurItem;
}

function string GetCurActionKey ()
{
	return GetCurrentKeyItem().m_szActionKey;
}

function string GetCurKeyName ()
{
	return GetCurrentKeyItem().m_szFakeEditBoxValue;
}

function int GetCurKeyInputClass ()
{
	return GetCurrentKeyItem().m_iItemID;
}

function RefreshKeyItem (string _szNewKeyValue)
{
	local UWindowListBoxItem pItem;

	pItem=m_pListControls.GetSelectedItem();
	if ( pItem != None )
	{
		pItem.m_szFakeEditBoxValue=_szNewKeyValue;
	}
}

function KeyPressed (int Key)
{
	local R6WindowTextLabelExt pR6TextLabelExt;
	local string szTemp;
	local string szKeyName;
	local bool bUpdate;
	local bool bPlanningInput;

	if ( GetCurKeyInputClass() == 1 )
	{
		bPlanningInput=True;
	}
	if ( m_iKeyToAssign != -1 )
	{
		bUpdate=True;
	}
	else
	{
		if (  !IsKeyValid(Key) )
		{
			CloseAllKeyPopUp(True);
//			R6MenuOptionsWidget(OwnerWindow).SimplePopUp(Localize("Options","Key_Invalid_Title","R6Menu"),Localize("Options","Key_Invalid","R6Menu"),0,2);
			return;
		}
		m_szOldActionKey=GetPlayerOwner().GetActionKey(Key,bPlanningInput);
		szTemp=Localize("Keys","K_" $ m_szOldActionKey,"R6Menu",True);
		m_iKeyToAssign=Key;
		if ( (m_szOldActionKey != "") && (szTemp != "") )
		{
			szKeyName=GetPlayerOwner().Player.Console.ConvertKeyToLocalisation(m_iKeyToAssign,GetPlayerOwner().GetEnumName(m_iKeyToAssign,bPlanningInput));
			pR6TextLabelExt=R6WindowTextLabelExt(m_pKeyMenuReAssignPopUp.m_ClientArea);
			pR6TextLabelExt.ChangeTextLabel(szKeyName $ " " $ Localize("Options","Key_Assign","R6Menu") $ " " $ Localize("Keys","K_" $ m_szOldActionKey,"R6Menu"),0);
			m_pKeyMenuReAssignPopUp.ShowWindow();
			m_pOptControls.ShowWindow();
		}
		else
		{
			bUpdate=True;
		}
	}
	if ( bUpdate )
	{
		szTemp="INPUT";
		if ( bPlanningInput )
		{
			szTemp="INPUTPLANNING";
		}
		szKeyName=GetPlayerOwner().GetEnumName(m_iKeyToAssign,bPlanningInput);
		GetPlayerOwner().SetKey(szTemp @ szKeyName @ GetCurActionKey());
		RefreshKeyList();
		m_szOldActionKey="";
		m_iKeyToAssign=-1;
	}
}

function bool IsKeyValid (int _Key)
{
	local bool bValidKey;

	bValidKey=True;
	switch (_Key)
	{
/*		case Root.Console.91:
		case Root.Console.92:
		case Root.Console.93:
		bValidKey=False;
		break;
		case Root.Console.1:
		if ( GetCurKeyInputClass() != 1 )
		{
			if ( GetCurActionKey() == "Console" )
			{
				bValidKey=False;
			}
		}
		break;
		case Root.Console.237:
		case Root.Console.236:
		if ( GetCurKeyInputClass() == 1 )
		{
			switch (GetCurActionKey())
			{
				case "MoveUp":
				case "MoveDown":
				case "MoveLeft":
				case "MoveRight":
				case "ZoomIn":
				case "ZoomOut":
				case "LevelUp":
				case "LevelDown":
				case "RotateClockWise":
				case "RotateCounterClockWise":
				case "AngleUp":
				case "AngleDown":
				bValidKey=False;
				break;
				default:
			}
		}
		else
		{
			switch (GetCurActionKey())
			{
				case "PrimaryFire":
				case "SecondaryFire":
				case "Reload":
				case "Run":
				case "SpeedUpDoor":
				case "FluidPosture":
				case "PeekLeft":
				case "PeekRight":
				case "MoveForward":
				case "RunForward":
				case "MoveBackward":
				case "StrafeLeft":
				case "StrafeRight":
				case "TurningX":
				case "TurningY":
				bValidKey=False;
				break;
				default:
			}
		}
		break;
		default:
		bValidKey=True;
		break;  */
	}
	return bValidKey;
}

function InitOptionMODS ()
{
	local float fXOffset;
	local float fYOffset;

//	m_ePageOptID=6;
	m_pInfo=new Class'UWindowInfo';
	m_pInfo.LoadConfig();
	m_pListOfMODS=R6WindowListMODS(CreateWindow(Class'R6WindowListMODS',0.00,0.00,WinWidth,WinHeight - 14));
	m_pListOfMODS.ListClass=Class'R6WindowListBoxItem';
	m_pListOfMODS.m_Font=Root.Fonts[6];
	m_pListOfMODS.Register(self);
	m_pListOfMODS.m_DoubleClickClient=OwnerWindow;
	m_pListOfMODS.m_bSkipDrawBorders=True;
	m_pListOfMODS.m_fItemHeight=14.00;
	InitActivateButton();
	SetMenuMODS();
	m_bInitComplete=True;
}

function SetMenuMODS ()
{
	local R6WindowListBoxItem NewItem;
	local int i;
	local R6ModMgr pModManager;
	local R6Mod pTempMod;
	local string szInstallStatus;

	pModManager=Class'Actor'.static.GetModMgr();
	m_pListOfMODS.Items.Clear();
	i=0;
JL0031:
	if ( i < m_pInfo.m_AModsInfo.Length )
	{
		NewItem=R6WindowListBoxItem(m_pListOfMODS.Items.Append(m_pListOfMODS.ListClass));
//		NewItem.SetItemParameters(0,Localize(m_pInfo.m_AModsInfo[i],"ModName","R6Mod",True),Root.Fonts[5],5.00,2.00,WinWidth,15.00,0,0);
		szInstallStatus=Localize("MISC","NotInstalled","R6Mod");
//		m_pListOfMODS.SetItemState(NewItem,m_pListOfMODS.1,True);
//		NewItem.SetItemParameters(1,szInstallStatus,Root.Fonts[5],WinWidth - 5,2.00,WinWidth,15.00,0,1);
//		NewItem.SetItemParameters(2,Localize(m_pInfo.m_AModsInfo[i],"ModInfo","R6Mod",True),Root.Fonts[5],5.00,0.00,WinWidth,15.00,1,0);
		NewItem.HelpText=m_pInfo.m_AModsInfo[i];
		i++;
		goto JL0031;
	}
	i=0;
JL0200:
	if ( i < pModManager.GetNbMods() )
	{
		pTempMod=pModManager.m_aMods[i];
		NewItem=R6WindowListBoxItem(m_pListOfMODS.FindItemWithName(pTempMod.m_szKeyWord));
		if ( NewItem == None )
		{
			NewItem=R6WindowListBoxItem(m_pListOfMODS.Items.Append(m_pListOfMODS.ListClass));
		}
//		NewItem.SetItemParameters(0,pTempMod.m_szName,Root.Fonts[5],5.00,2.00,WinWidth,15.00,0,0);
		if ( pTempMod.m_bInstalled == True )
		{
			szInstallStatus=Localize("MISC","Installed","R6Mod");
			if ( pTempMod == pModManager.m_pCurrentMod )
			{
//				m_pListOfMODS.SetItemState(NewItem,m_pListOfMODS.3,True);
			}
			else
			{
//				m_pListOfMODS.SetItemState(NewItem,m_pListOfMODS.0,True);
			}
		}
		else
		{
			szInstallStatus=Localize("MISC","NotInstalled","R6Mod");
//			m_pListOfMODS.SetItemState(NewItem,m_pListOfMODS.1,True);
		}
//		NewItem.SetItemParameters(1,szInstallStatus,Root.Fonts[5],WinWidth - 5,2.00,WinWidth,15.00,0,1);
//		NewItem.SetItemParameters(2,pTempMod.m_szModInfo,Root.Fonts[5],5.00,0.00,WinWidth,15.00,1,0);
		NewItem.HelpText=pTempMod.m_szKeyWord;
		i++;
		goto JL0200;
	}
}

function RestoreDefaultValue (bool _bInGame)
{
	local R6GameOptions pGameOptions;
	local R6MenuOptionsWidget OptionsWidget;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	OptionsWidget=R6MenuOptionsWidget(OwnerWindow);
	if ( OptionsWidget.m_pOptionsGame.bWindowVisible )
	{
		pGameOptions.ResetGameToDefault();
		SetMenuGameValues();
	}
	else
	{
		if ( OptionsWidget.m_pOptionsSound.bWindowVisible )
		{
			pGameOptions.ResetSoundToDefault(_bInGame);
			SetMenuSoundValues();
		}
		else
		{
			if ( OptionsWidget.m_pOptionsGraphic.bWindowVisible )
			{
				pGameOptions.ResetGraphicsToDefault(_bInGame);
				SetMenuGraphicValues();
			}
			else
			{
				if ( OptionsWidget.m_pOptionsHud.bWindowVisible )
				{
					pGameOptions.ResetHudToDefault();
					SetMenuHudValues();
				}
				else
				{
					if ( OptionsWidget.m_pOptionsMulti.bWindowVisible )
					{
						pGameOptions.ResetMultiToDefault();
						SetMenuMultiValues();
					}
					else
					{
						if ( OptionsWidget.m_pOptionsControls.bWindowVisible )
						{
							GetPlayerOwner().ResetKeyboard();
							RefreshKeyList();
						}
					}
				}
			}
		}
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6MenuOptionsWidget OptionsWidget;
	local bool bUpdateGameOptions;
	local R6GameOptions pGameOptions;

	pGameOptions=Class'Actor'.static.GetGameOptions();
	OptionsWidget=R6MenuOptionsWidget(OwnerWindow);
	if ( E == 2 )
	{
		if ( C.IsA('R6WindowButtonBox') )
		{
			if ( R6WindowButtonBox(C).GetSelectStatus() )
			{
				R6WindowButtonBox(C).m_bSelected= !R6WindowButtonBox(C).m_bSelected;
				bUpdateGameOptions=True;
			}
			if ( (OptionsWidget.m_pOptionsSound != None) && OptionsWidget.m_pOptionsSound.bWindowVisible )
			{
				ManageNotifyForSound(C,E);
			}
		}
		else
		{
			if ( C.IsA('R6WindowButtonExt') )
			{
				if ( R6WindowButtonExt(C).GetSelectStatus() )
				{
					R6WindowButtonExt(C).ChangeCheckBoxStatus();
					bUpdateGameOptions=True;
				}
			}
			else
			{
				if ( C.IsA('R6WindowButton') )
				{
					if ( C == m_pGeneralButUse )
					{
						if ( m_pGeneralButUse.m_iButtonID == 0 )
						{
//							OptionsWidget.SimplePopUp(Localize("Options","ResetToDefault","R6Menu"),Localize("Options","ResetToDefaultConfirm","R6Menu"),50);
						}
						else
						{
							if ( m_pGeneralButUse.m_iButtonID == 1 )
							{
								m_pListOfMODS.ActivateMOD();
							}
						}
					}
					else
					{
						m_iKeyToAssign=-1;
						CloseAllKeyPopUp(True);
					}
				}
				else
				{
					if ( C.IsA('R6WindowListControls') )
					{
						ManagePopUpKey(C);
					}
					else
					{
						if ( C.IsA('R6MenuOptionsControls') )
						{
							CloseAllKeyPopUp(True);
/*							if ( m_pOptControls.m_iLastKeyPressed == GetPlayerOwner().Player.Console.27 )
							{
								m_iKeyToAssign=-1;
							}
							else
							{
								KeyPressed(m_pOptControls.m_iLastKeyPressed);
							}*/
						}
					}
				}
			}
		}
	}
	else
	{
		if ( C.IsA('UWindowHScrollbar') )
		{
			if ( m_ePageOptID == 1 )
			{
				switch (UWindowHScrollbar(C).m_iScrollBarID)
				{
/*					case GetPlayerOwner().1:
					if ( E == 9 )
					{
						if ( m_iRefAmbientVolume != m_pAmbientVolume.GetScrollBarValue() )
						{
							m_iRefAmbientVolume=m_pAmbientVolume.GetScrollBarValue();
							bUpdateGameOptions=True;
						}
					}
					else
					{
						if ( (E == 1) && m_bInitComplete )
						{
							GetPlayerOwner().ChangeVolumeTypeLinear(GetPlayerOwner().1,m_pAmbientVolume.GetScrollBarValue());
						}
					}
					break;
					case GetPlayerOwner().5:
					if ( E == 9 )
					{
						if ( m_iRefMusicVolume != m_pMusicVolume.GetScrollBarValue() )
						{
							m_iRefMusicVolume=m_pMusicVolume.GetScrollBarValue();
							bUpdateGameOptions=True;
						}
					}
					else
					{
						if ( (E == 1) && m_bInitComplete )
						{
							GetPlayerOwner().ChangeVolumeTypeLinear(GetPlayerOwner().5,m_pMusicVolume.GetScrollBarValue());
						}
					}
					break;
					case GetPlayerOwner().6:
					if ( E == 9 )
					{
						if ( m_iRefVoicesVolume != m_pVoicesVolume.GetScrollBarValue() )
						{
							m_iRefVoicesVolume=m_pVoicesVolume.GetScrollBarValue();
							bUpdateGameOptions=True;
						}
					}
					else
					{
						if ( (E == 1) && m_bInitComplete )
						{
							GetPlayerOwner().ChangeVolumeTypeLinear(GetPlayerOwner().6,m_pVoicesVolume.GetScrollBarValue());
						}
					}
					break;
					default:
					bUpdateGameOptions=False;
					break;*/
				}
			}
			else
			{
				if ( m_ePageOptID == 0 )
				{
					if ( E == 9 )
					{
						if ( m_iRefMouseSens != m_pOptionMouseSens.GetScrollBarValue() )
						{
							m_iRefMouseSens=m_pOptionMouseSens.GetScrollBarValue();
							bUpdateGameOptions=True;
						}
					}
					else
					{
						if ( (E == 1) && m_bInitComplete )
						{
							pGameOptions.MouseSensitivity=m_pOptionMouseSens.GetScrollBarValue();
						}
					}
				}
			}
		}
		else
		{
			if ( C.IsA('R6WindowComboControl') )
			{
				if ( E == 1 )
				{
					if ( m_bInitComplete && R6WindowComboControl(C).m_bSelectedByUser )
					{
						bUpdateGameOptions=True;
					}
				}
			}
			else
			{
				if ( E == 11 )
				{
					if ( C == m_pListOfMODS )
					{
						m_pListOfMODS.ActivateMOD();
					}
				}
			}
		}
	}
	if ( bUpdateGameOptions )
	{
		switch (m_ePageOptID)
		{
/*			case 0:
			SetGameValues();
			break;
			case 1:
			SetSoundValues();
			break;
			case 2:
			SetGraphicValues(True);
			break;
			case 3:
			SetHudValues();
			break;
			case 4:
			SetMultiValues();
			break;
			case 5:
			break;
			default:
			bUpdateGameOptions=False;
			break;    */
		}
		if ( bUpdateGameOptions )
		{
			pGameOptions.SaveConfig();
		}
	}
}

function ManageNotifyForSound (UWindowDialogControl C, byte E)
{
	if ( C == m_pSndHardware )
	{
		if (  !m_bEAXNotSupported )
		{
			if ( R6WindowButtonBox(C).m_bSelected )
			{
				m_pEAX.bDisabled=False;
			}
			else
			{
				m_pEAX.bDisabled=True;
				m_pEAX.m_bSelected=False;
			}
			m_EaxLogo.m_bUseColor= !m_pEAX.m_bSelected;
		}
	}
	else
	{
		if ( C == m_pEAX )
		{
			m_EaxLogo.m_bUseColor= !m_pEAX.m_bSelected;
		}
	}
}

function R6WindowComboControl SetComboControlButton (Region _RDefaultW, string _szTitle, string _szTip)
{
	local R6WindowComboControl _pR6WindowComboControl;

	_pR6WindowComboControl=R6WindowComboControl(CreateControl(Class'R6WindowComboControl',_RDefaultW.X,_RDefaultW.Y,_RDefaultW.W,LookAndFeel.Size_ComboHeight,self));
	_pR6WindowComboControl.AdjustTextW(_szTitle,0.00,0.00,_RDefaultW.W * 0.50,LookAndFeel.Size_ComboHeight);
	_pR6WindowComboControl.AdjustEditBoxW(0.00,140.00,LookAndFeel.Size_ComboHeight);
	_pR6WindowComboControl.SetEditBoxTip(_szTip);
	return _pR6WindowComboControl;
}

defaultproperties
{
    m_iKeyToAssign=-1
    SimpleBorderRegion=(X=4203014,Y=570753024,W=56,H=74244)
    m_pAutoAimTextReg(0)=(X=6824453,Y=570687488,W=111,H=4792835)
    m_pAutoAimTextReg(1)=(X=11608581,Y=570687488,W=111,H=4792835)
    m_pAutoAimTextReg(2)=(X=16392709,Y=570687488,W=111,H=4792835)
    m_pAutoAimTextReg(3)=(X=21176837,Y=570687488,W=111,H=4792835)
    m_EaxTextureReg=(X=25960965,Y=570687488,W=188,H=5513731)
    m_RArmpatchBitmapPos=(X=3613190,Y=570753024,W=38,H=4203012)
    m_RArmpatchListPos=(X=15081990,Y=570687488,W=156,H=9839107)
}
/*
    m_pAutoAimTexture=Texture'R6MenuTextures.Gui_BoxScroll'
    m_EaxTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

