//================================================================================
// R6MenuEquipmentAnchorButtons.
//================================================================================
class R6MenuEquipmentAnchorButtons extends UWindowDialogControl;

enum eAnchorEquipmentType {
	AET_Primary,
	AET_Secondary,
	AET_Gadget,
	AET_None
};

var bool m_bDrawBorders;
var float m_fButtonTabWidth;
var float m_fButtonTabHeight;
var float m_fPrimarWTabOffset;
var float m_fPistolOffset;
var float m_fGrenadesOffset;
var float m_fPrimaryBetweenButtonOffset;
var float m_fSecondaryBetweenButtonOffset;
var float m_fGadgetsBetweenButtonOffset;
var float m_fYTopOffset;
var R6WindowListBoxAnchorButton m_ASSAULTButton;
var R6WindowListBoxAnchorButton m_LMGButton;
var R6WindowListBoxAnchorButton m_SHOTGUNButton;
var R6WindowListBoxAnchorButton m_SNIPERButton;
var R6WindowListBoxAnchorButton m_SUBGUNButton;
var R6WindowListBoxAnchorButton m_PISTOLSButton;
var R6WindowListBoxAnchorButton m_MACHINEPISTOLSButton;
var R6WindowListBoxAnchorButton m_GRENADESButton;
var R6WindowListBoxAnchorButton m_EXPLOSIVESButton;
var R6WindowListBoxAnchorButton m_HBDEVICEButton;
var R6WindowListBoxAnchorButton m_KITSButton;
var R6WindowListBoxAnchorButton m_GENERALButton;
var Region m_RASSAULTUp;
var Region m_RASSAULTOver;
var Region m_RASSAULTDown;
var Region m_RLMGUp;
var Region m_RLMGOver;
var Region m_RLMGDown;
var Region m_RSHOTGUNUp;
var Region m_RSHOTGUNOver;
var Region m_RSHOTGUNDown;
var Region m_RSNIPERUp;
var Region m_RSNIPEROver;
var Region m_RSNIPERDown;
var Region m_RSUBGUNUp;
var Region m_RSUBGUNOver;
var Region m_RSUBGUNDown;
var Region m_RPISTOLSUp;
var Region m_RPISTOLSOver;
var Region m_RPISTOLSDown;
var Region m_RMACHINEPISTOLSUp;
var Region m_RMACHINEPISTOLSOver;
var Region m_RMACHINEPISTOLSDown;
var Region m_RGRENADESUp;
var Region m_RGRENADESOver;
var Region m_RGRENADESDown;
var Region m_REXPLOSIVESUp;
var Region m_REXPLOSIVESOver;
var Region m_REXPLOSIVESDown;
var Region m_RHBDEVICEUp;
var Region m_RHBDEVICEOver;
var Region m_RHBDEVICEDown;
var Region m_RKITSUp;
var Region m_RKITSOver;
var Region m_RKITSDown;
var Region m_GENERALUp;
var Region m_GENERALOver;
var Region m_GENERALDown;

function Created ()
{
	m_fYTopOffset=WinHeight - m_fButtonTabHeight;
	m_SUBGUNButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_fPrimarWTabOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_ASSAULTButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_SUBGUNButton.WinLeft + m_SUBGUNButton.WinWidth + m_fPrimaryBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_SHOTGUNButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_ASSAULTButton.WinLeft + m_ASSAULTButton.WinWidth + m_fPrimaryBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_SNIPERButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_SHOTGUNButton.WinLeft + m_SHOTGUNButton.WinWidth + m_fPrimaryBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_LMGButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_SNIPERButton.WinLeft + m_SNIPERButton.WinWidth + m_fPrimaryBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_PISTOLSButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_fPistolOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_MACHINEPISTOLSButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_PISTOLSButton.WinLeft + m_PISTOLSButton.WinWidth + m_fSecondaryBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_GRENADESButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_fGrenadesOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_EXPLOSIVESButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_GRENADESButton.WinLeft + m_GRENADESButton.WinWidth + m_fGadgetsBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_HBDEVICEButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_EXPLOSIVESButton.WinLeft + m_EXPLOSIVESButton.WinWidth + m_fGadgetsBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_KITSButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_HBDEVICEButton.WinLeft + m_HBDEVICEButton.WinWidth + m_fGadgetsBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_GENERALButton=R6WindowListBoxAnchorButton(CreateWindow(Class'R6WindowListBoxAnchorButton',m_KITSButton.WinLeft + m_KITSButton.WinWidth + m_fGadgetsBetweenButtonOffset,m_fYTopOffset,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_ASSAULTButton.ToolTipString=Localize("Tip","GearRoomButAssaultRif","R6Menu");
	m_LMGButton.ToolTipString=Localize("Tip","GearRoomButLightMach","R6Menu");
	m_SHOTGUNButton.ToolTipString=Localize("Tip","GearRoomButShotGun","R6Menu");
	m_SNIPERButton.ToolTipString=Localize("Tip","GearRoomButSniperRif","R6Menu");
	m_SUBGUNButton.ToolTipString=Localize("Tip","GearRoomButSubMach","R6Menu");
	m_PISTOLSButton.ToolTipString=Localize("Tip","GearRoomButPistols","R6Menu");
	m_MACHINEPISTOLSButton.ToolTipString=Localize("Tip","GearRoomButMPistols","R6Menu");
	m_GRENADESButton.ToolTipString=Localize("Tip","GearRoomButGrenade","R6Menu");
	m_EXPLOSIVESButton.ToolTipString=Localize("Tip","GearRoomButExplosive","R6Menu");
	m_HBDEVICEButton.ToolTipString=Localize("Tip","GearRoomButHeartB","R6Menu");
	m_KITSButton.ToolTipString=Localize("Tip","GearRoomButKits","R6Menu");
	m_GENERALButton.ToolTipString=Localize("Tip","GearRoomButOthers","R6Menu");
	m_ASSAULTButton.UpRegion=m_RASSAULTUp;
	m_ASSAULTButton.OverRegion=m_RASSAULTOver;
	m_ASSAULTButton.DownRegion=m_RASSAULTDown;
	m_LMGButton.UpRegion=m_RLMGUp;
	m_LMGButton.OverRegion=m_RLMGOver;
	m_LMGButton.DownRegion=m_RLMGDown;
	m_SHOTGUNButton.UpRegion=m_RSHOTGUNUp;
	m_SHOTGUNButton.OverRegion=m_RSHOTGUNOver;
	m_SHOTGUNButton.DownRegion=m_RSHOTGUNDown;
	m_SNIPERButton.UpRegion=m_RSNIPERUp;
	m_SNIPERButton.OverRegion=m_RSNIPEROver;
	m_SNIPERButton.DownRegion=m_RSNIPERDown;
	m_SUBGUNButton.UpRegion=m_RSUBGUNUp;
	m_SUBGUNButton.OverRegion=m_RSUBGUNOver;
	m_SUBGUNButton.DownRegion=m_RSUBGUNDown;
	m_PISTOLSButton.UpRegion=m_RPISTOLSUp;
	m_PISTOLSButton.OverRegion=m_RPISTOLSOver;
	m_PISTOLSButton.DownRegion=m_RPISTOLSDown;
	m_MACHINEPISTOLSButton.UpRegion=m_RMACHINEPISTOLSUp;
	m_MACHINEPISTOLSButton.OverRegion=m_RMACHINEPISTOLSOver;
	m_MACHINEPISTOLSButton.DownRegion=m_RMACHINEPISTOLSDown;
	m_GRENADESButton.UpRegion=m_RGRENADESUp;
	m_GRENADESButton.OverRegion=m_RGRENADESOver;
	m_GRENADESButton.DownRegion=m_RGRENADESDown;
	m_EXPLOSIVESButton.UpRegion=m_REXPLOSIVESUp;
	m_EXPLOSIVESButton.OverRegion=m_REXPLOSIVESOver;
	m_EXPLOSIVESButton.DownRegion=m_REXPLOSIVESDown;
	m_HBDEVICEButton.UpRegion=m_RHBDEVICEUp;
	m_HBDEVICEButton.OverRegion=m_RHBDEVICEOver;
	m_HBDEVICEButton.DownRegion=m_RHBDEVICEDown;
	m_KITSButton.UpRegion=m_RKITSUp;
	m_KITSButton.OverRegion=m_RKITSOver;
	m_KITSButton.DownRegion=m_RKITSDown;
	m_GENERALButton.UpRegion=m_GENERALUp;
	m_GENERALButton.OverRegion=m_GENERALOver;
	m_GENERALButton.DownRegion=m_GENERALDown;
	m_ASSAULTButton.m_iDrawStyle=5;
	m_LMGButton.m_iDrawStyle=5;
	m_SHOTGUNButton.m_iDrawStyle=5;
	m_SNIPERButton.m_iDrawStyle=5;
	m_SUBGUNButton.m_iDrawStyle=5;
	m_PISTOLSButton.m_iDrawStyle=5;
	m_MACHINEPISTOLSButton.m_iDrawStyle=5;
	m_GRENADESButton.m_iDrawStyle=5;
	m_EXPLOSIVESButton.m_iDrawStyle=5;
	m_HBDEVICEButton.m_iDrawStyle=5;
	m_KITSButton.m_iDrawStyle=5;
	m_GENERALButton.m_iDrawStyle=5;
//	DisplayButtons(0);
	m_BorderColor=Root.Colors.White;
}

function DisplayButtons (eAnchorEquipmentType _Equipment)
{
	switch (_Equipment)
	{
/*		case 0:
		m_ASSAULTButton.ShowWindow();
		m_LMGButton.ShowWindow();
		m_SHOTGUNButton.ShowWindow();
		m_SNIPERButton.ShowWindow();
		m_SUBGUNButton.ShowWindow();
		m_PISTOLSButton.HideWindow();
		m_MACHINEPISTOLSButton.HideWindow();
		m_GRENADESButton.HideWindow();
		m_EXPLOSIVESButton.HideWindow();
		m_HBDEVICEButton.HideWindow();
		m_KITSButton.HideWindow();
		m_GENERALButton.HideWindow();
		break;
		case 1:
		m_ASSAULTButton.HideWindow();
		m_LMGButton.HideWindow();
		m_SHOTGUNButton.HideWindow();
		m_SNIPERButton.HideWindow();
		m_SUBGUNButton.HideWindow();
		m_PISTOLSButton.ShowWindow();
		m_MACHINEPISTOLSButton.ShowWindow();
		m_GRENADESButton.HideWindow();
		m_EXPLOSIVESButton.HideWindow();
		m_HBDEVICEButton.HideWindow();
		m_KITSButton.HideWindow();
		m_GENERALButton.HideWindow();
		break;
		case 2:
		m_ASSAULTButton.HideWindow();
		m_LMGButton.HideWindow();
		m_SHOTGUNButton.HideWindow();
		m_SNIPERButton.HideWindow();
		m_SUBGUNButton.HideWindow();
		m_PISTOLSButton.HideWindow();
		m_MACHINEPISTOLSButton.HideWindow();
		m_GRENADESButton.ShowWindow();
		m_EXPLOSIVESButton.ShowWindow();
		m_HBDEVICEButton.ShowWindow();
		m_KITSButton.ShowWindow();
		m_GENERALButton.ShowWindow();
		break;
		default:*/
	}
}

function Register (UWindowDialogClientWindow W)
{
	Super.Register(W);
	m_ASSAULTButton.Register(W);
	m_LMGButton.Register(W);
	m_SHOTGUNButton.Register(W);
	m_SNIPERButton.Register(W);
	m_SUBGUNButton.Register(W);
	m_PISTOLSButton.Register(W);
	m_MACHINEPISTOLSButton.Register(W);
	m_GRENADESButton.Register(W);
	m_EXPLOSIVESButton.Register(W);
	m_HBDEVICEButton.Register(W);
	m_KITSButton.Register(W);
	m_GENERALButton.Register(W);
}

function Resize ()
{
	m_fYTopOffset=WinHeight - m_fButtonTabHeight;
	m_SUBGUNButton.WinLeft=m_fPrimarWTabOffset;
	m_SUBGUNButton.WinTop=m_fYTopOffset;
	m_SUBGUNButton.WinWidth=m_fButtonTabWidth;
	m_SUBGUNButton.WinHeight=m_fButtonTabHeight;
	m_ASSAULTButton.WinLeft=m_SUBGUNButton.WinLeft + m_SUBGUNButton.WinWidth + m_fPrimaryBetweenButtonOffset;
	m_ASSAULTButton.WinTop=m_fYTopOffset;
	m_ASSAULTButton.WinWidth=m_fButtonTabWidth;
	m_ASSAULTButton.WinHeight=m_fButtonTabHeight;
	m_SHOTGUNButton.WinLeft=m_ASSAULTButton.WinLeft + m_ASSAULTButton.WinWidth + m_fPrimaryBetweenButtonOffset;
	m_SHOTGUNButton.WinTop=m_fYTopOffset;
	m_SHOTGUNButton.WinWidth=m_fButtonTabWidth;
	m_SHOTGUNButton.WinHeight=m_fButtonTabHeight;
	m_SNIPERButton.WinLeft=m_SHOTGUNButton.WinLeft + m_SHOTGUNButton.WinWidth + m_fPrimaryBetweenButtonOffset;
	m_SNIPERButton.WinTop=m_fYTopOffset;
	m_SNIPERButton.WinWidth=m_fButtonTabWidth;
	m_SNIPERButton.WinHeight=m_fButtonTabHeight;
	m_LMGButton.WinLeft=m_SNIPERButton.WinLeft + m_SNIPERButton.WinWidth + m_fPrimaryBetweenButtonOffset;
	m_LMGButton.WinTop=m_fYTopOffset;
	m_LMGButton.WinWidth=m_fButtonTabWidth;
	m_LMGButton.WinHeight=m_fButtonTabHeight;
	m_PISTOLSButton.WinLeft=m_fPistolOffset;
	m_PISTOLSButton.WinTop=m_fYTopOffset;
	m_PISTOLSButton.WinWidth=m_fButtonTabWidth;
	m_PISTOLSButton.WinHeight=m_fButtonTabHeight;
	m_MACHINEPISTOLSButton.WinLeft=m_PISTOLSButton.WinLeft + m_PISTOLSButton.WinWidth + m_fSecondaryBetweenButtonOffset;
	m_MACHINEPISTOLSButton.WinTop=m_fYTopOffset;
	m_MACHINEPISTOLSButton.WinWidth=m_fButtonTabWidth;
	m_MACHINEPISTOLSButton.WinHeight=m_fButtonTabHeight;
	m_GRENADESButton.WinLeft=m_fGrenadesOffset;
	m_GRENADESButton.WinTop=m_fYTopOffset;
	m_GRENADESButton.WinWidth=m_fButtonTabWidth;
	m_GRENADESButton.WinHeight=m_fButtonTabHeight;
	m_EXPLOSIVESButton.WinLeft=m_GRENADESButton.WinLeft + m_GRENADESButton.WinWidth + m_fGadgetsBetweenButtonOffset;
	m_EXPLOSIVESButton.WinTop=m_fYTopOffset;
	m_EXPLOSIVESButton.WinWidth=m_fButtonTabWidth;
	m_EXPLOSIVESButton.WinHeight=m_fButtonTabHeight;
	m_HBDEVICEButton.WinLeft=m_EXPLOSIVESButton.WinLeft + m_EXPLOSIVESButton.WinWidth + m_fGadgetsBetweenButtonOffset;
	m_HBDEVICEButton.WinTop=m_fYTopOffset;
	m_HBDEVICEButton.WinWidth=m_fButtonTabWidth;
	m_HBDEVICEButton.WinHeight=m_fButtonTabHeight;
	m_KITSButton.WinLeft=m_HBDEVICEButton.WinLeft + m_HBDEVICEButton.WinWidth + m_fGadgetsBetweenButtonOffset;
	m_KITSButton.WinTop=m_fYTopOffset;
	m_KITSButton.WinWidth=m_fButtonTabWidth;
	m_KITSButton.WinHeight=m_fButtonTabHeight;
	m_GENERALButton.WinLeft=m_KITSButton.WinLeft + m_KITSButton.WinWidth + m_fGadgetsBetweenButtonOffset;
	m_GENERALButton.WinTop=m_fYTopOffset;
	m_GENERALButton.WinWidth=m_fButtonTabWidth;
	m_GENERALButton.WinHeight=m_fButtonTabHeight;
}

function AfterPaint (Canvas C, float X, float Y)
{
	if ( m_bDrawBorders )
	{
		DrawSimpleBorder(C);
	}
}

defaultproperties
{
    m_bDrawBorders=True
    m_fButtonTabWidth=37.00
    m_fButtonTabHeight=20.00
    m_fPrimarWTabOffset=2.00
    m_fPistolOffset=2.00
    m_fGrenadesOffset=2.00
    m_RASSAULTUp=(X=7479814,Y=570753024,W=63,H=2433540)
    m_RASSAULTOver=(X=7479814,Y=570753024,W=84,H=2433540)
    m_RASSAULTDown=(X=7479814,Y=570753024,W=105,H=2433540)
    m_RLMGUp=(X=9970182,Y=570753024,W=63,H=2433540)
    m_RLMGOver=(X=9970182,Y=570753024,W=84,H=2433540)
    m_RLMGDown=(X=9970182,Y=570753024,W=105,H=2433540)
    m_RSHOTGUNUp=(X=8266245,Y=570687488,W=37,H=1319427)
    m_RSHOTGUNOver=(X=9642501,Y=570687488,W=37,H=1319427)
    m_RSHOTGUNDown=(X=11018757,Y=570687488,W=37,H=1319427)
    m_RSNIPERUp=(X=2499078,Y=570753024,W=126,H=2433540)
    m_RSNIPEROver=(X=2499078,Y=570753024,W=147,H=2433540)
    m_RSNIPERDown=(X=2499078,Y=570753024,W=168,H=2433540)
    m_RSUBGUNUp=(X=4989446,Y=570753024,W=126,H=2433540)
    m_RSUBGUNOver=(X=4989446,Y=570753024,W=147,H=2433540)
    m_RSUBGUNDown=(X=4989446,Y=570753024,W=168,H=2433540)
    m_RPISTOLSUp=(X=12460550,Y=570753024,W=63,H=2433540)
    m_RPISTOLSOver=(X=12460550,Y=570753024,W=84,H=2433540)
    m_RPISTOLSDown=(X=12460550,Y=570753024,W=105,H=2433540)
    m_RMACHINEPISTOLSUp=(X=7479814,Y=570753024,W=126,H=2433540)
    m_RMACHINEPISTOLSOver=(X=7479814,Y=570753024,W=147,H=2433540)
    m_RMACHINEPISTOLSDown=(X=7479814,Y=570753024,W=168,H=2433540)
    m_RGRENADESUp=(X=9970182,Y=570753024,W=126,H=2433540)
    m_RGRENADESOver=(X=9970182,Y=570753024,W=147,H=2433540)
    m_RGRENADESDown=(X=9970182,Y=570753024,W=168,H=2433540)
    m_REXPLOSIVESUp=(X=12460550,Y=570753024,W=126,H=2433540)
    m_REXPLOSIVESOver=(X=12460550,Y=570753024,W=147,H=2433540)
    m_REXPLOSIVESDown=(X=12460550,Y=570753024,W=168,H=2433540)
    m_RHBDEVICEUp=(X=12395013,Y=570687488,W=37,H=1319427)
    m_RHBDEVICEOver=(X=13771269,Y=570687488,W=37,H=1319427)
    m_RHBDEVICEDown=(X=15147525,Y=570687488,W=37,H=1319427)
    m_RKITSUp=(X=2499078,Y=570753024,W=189,H=2433540)
    m_RKITSOver=(X=2499078,Y=570753024,W=210,H=2433540)
    m_RKITSDown=(X=2499078,Y=570753024,W=231,H=2433540)
    m_GENERALUp=(X=4989446,Y=570753024,W=189,H=2433540)
    m_GENERALOver=(X=4989446,Y=570753024,W=210,H=2433540)
    m_GENERALDown=(X=4989446,Y=570753024,W=231,H=2433540)
}
