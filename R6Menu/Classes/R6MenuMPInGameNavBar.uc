//================================================================================
// R6MenuMPInGameNavBar.
//================================================================================
class R6MenuMPInGameNavBar extends UWindowDialogClientWindow;

var int m_iXNavBarLoc[4];
var int m_iYNavBarLoc[4];
var float m_fPlayerButWidth;
var R6MenuMPInGameHelpBar m_HelpTextBar;
var R6WindowButton m_SelectTeamButton;
var R6WindowButton m_ServerOptButton;
var R6WindowButton m_KitRestrictionButton;
var R6WindowButton m_GearButton;
var R6WindowButtonBox m_pPlayerReady;
var Texture m_TSelectTeamButton;
var Texture m_TServerOptButton;
var Texture m_TKitRestrictionButton;
var Texture m_TGearButton;
var Region m_RSelectTeamButtonUp;
var Region m_RSelectTeamButtonDown;
var Region m_RSelectTeamButtonDisabled;
var Region m_RSelectTeamButtonOver;
var Region m_RServerOptButtonUp;
var Region m_RServerOptButtonDown;
var Region m_RServerOptButtonDisabled;
var Region m_RServerOptButtonOver;
var Region m_RKitRestrictionButtonUp;
var Region m_RKitRestrictionButtonDown;
var Region m_RKitRestrictionButtonDisabled;
var Region m_RKitRestrictionButtonOver;
var Region m_RGearButtonUp;
var Region m_RGearButtonDown;
var Region m_RGearButtonDisabled;
var Region m_RGearButtonOver;
const C_fHEIGHT_HELPTEXTBAR= 20;

function Created ()
{
	local float fXOffset;
	local float fHeight;

	m_HelpTextBar=R6MenuMPInGameHelpBar(CreateWindow(Class'R6MenuMPInGameHelpBar',1.00,0.00,WinWidth - 2,20.00,self));
	m_HelpTextBar.m_bUseExternSetTip=True;
	m_SelectTeamButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iXNavBarLoc[0],m_iYNavBarLoc[0],m_RSelectTeamButtonUp.W,m_RSelectTeamButtonUp.H,self));
	m_SelectTeamButton.UpTexture=m_TSelectTeamButton;
	m_SelectTeamButton.OverTexture=m_TSelectTeamButton;
	m_SelectTeamButton.DownTexture=m_TSelectTeamButton;
	m_SelectTeamButton.DisabledTexture=m_TSelectTeamButton;
	m_SelectTeamButton.UpRegion=m_RSelectTeamButtonUp;
	m_SelectTeamButton.DownRegion=m_RSelectTeamButtonDown;
	m_SelectTeamButton.DisabledRegion=m_RSelectTeamButtonDisabled;
	m_SelectTeamButton.OverRegion=m_RSelectTeamButtonOver;
	m_SelectTeamButton.bUseRegion=True;
	m_SelectTeamButton.ToolTipString=Localize("MPInGame","SelectTeam","R6Menu");
//	m_SelectTeamButton.m_iDrawStyle=5;
	m_ServerOptButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iXNavBarLoc[1],m_iYNavBarLoc[1],m_RServerOptButtonUp.W,m_RServerOptButtonUp.H,self));
	m_ServerOptButton.UpTexture=m_TServerOptButton;
	m_ServerOptButton.OverTexture=m_TServerOptButton;
	m_ServerOptButton.DownTexture=m_TServerOptButton;
	m_ServerOptButton.DisabledTexture=m_TServerOptButton;
	m_ServerOptButton.UpRegion=m_RServerOptButtonUp;
	m_ServerOptButton.OverRegion=m_RServerOptButtonOver;
	m_ServerOptButton.DownRegion=m_RServerOptButtonDown;
	m_ServerOptButton.DisabledRegion=m_RServerOptButtonDisabled;
	m_ServerOptButton.bUseRegion=True;
	m_ServerOptButton.ToolTipString=Localize("Tip","ServerOpt","R6Menu");
//	m_ServerOptButton.m_iDrawStyle=5;
	m_KitRestrictionButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iXNavBarLoc[2],m_iYNavBarLoc[2],m_RKitRestrictionButtonUp.W,m_RKitRestrictionButtonUp.H,self));
	m_KitRestrictionButton.UpTexture=m_TKitRestrictionButton;
	m_KitRestrictionButton.OverTexture=m_TKitRestrictionButton;
	m_KitRestrictionButton.DownTexture=m_TKitRestrictionButton;
	m_KitRestrictionButton.DisabledTexture=m_TKitRestrictionButton;
	m_KitRestrictionButton.UpRegion=m_RKitRestrictionButtonUp;
	m_KitRestrictionButton.OverRegion=m_RKitRestrictionButtonOver;
	m_KitRestrictionButton.DownRegion=m_RKitRestrictionButtonDown;
	m_KitRestrictionButton.DisabledRegion=m_RKitRestrictionButtonDisabled;
	m_KitRestrictionButton.bUseRegion=True;
	m_KitRestrictionButton.ToolTipString=Localize("Tip","KitRestriction","R6Menu");
//	m_KitRestrictionButton.m_iDrawStyle=5;
	m_GearButton=R6WindowButton(CreateControl(Class'R6WindowButton',m_iXNavBarLoc[3],m_iYNavBarLoc[3],m_RGearButtonUp.W,m_RGearButtonUp.H,self));
	m_GearButton.UpTexture=m_TGearButton;
	m_GearButton.OverTexture=m_TGearButton;
	m_GearButton.DownTexture=m_TGearButton;
	m_GearButton.DisabledTexture=m_TGearButton;
	m_GearButton.UpRegion=m_RGearButtonUp;
	m_GearButton.OverRegion=m_RGearButtonOver;
	m_GearButton.DownRegion=m_RGearButtonDown;
	m_GearButton.DisabledRegion=m_RGearButtonDisabled;
	m_GearButton.bUseRegion=True;
	m_GearButton.ToolTipString=Localize("Tip","Gear","R6Menu");
//	m_GearButton.m_iDrawStyle=5;
	fXOffset=m_iXNavBarLoc[3] + m_RGearButtonUp.W + 30;
	fHeight=15.00;
	m_pPlayerReady=R6WindowButtonBox(CreateControl(Class'R6WindowButtonBox',fXOffset,30.00,80.00,fHeight,self));
	m_pPlayerReady.m_TextFont=Root.Fonts[5];
	m_pPlayerReady.m_vTextColor=Root.Colors.White;
	m_pPlayerReady.m_vBorder=Root.Colors.White;
//	m_pPlayerReady.m_eButtonType=0;
	m_pPlayerReady.CreateTextAndBox(Localize("MPInGame","PlayerReady","R6Menu"),Localize("Tip","PlayerReady","R6Menu"),0.00,0);
	m_pPlayerReady.bDisabled=True;
	m_pPlayerReady.m_bResizeToText=True;
	m_BorderColor=Root.Colors.BlueLight;
	AlignButtons();
}

function BeforePaint (Canvas C, float X, float Y)
{
	if ( m_fPlayerButWidth != m_pPlayerReady.WinWidth )
	{
		if ( m_SelectTeamButton != None )
		{
			m_SelectTeamButton.m_bPreCalculatePos=True;
		}
		if ( m_ServerOptButton != None )
		{
			m_ServerOptButton.m_bPreCalculatePos=True;
		}
		if ( m_KitRestrictionButton != None )
		{
			m_KitRestrictionButton.m_bPreCalculatePos=True;
		}
		if ( m_GearButton != None )
		{
			m_GearButton.m_bPreCalculatePos=True;
		}
		if ( m_pPlayerReady != None )
		{
			m_pPlayerReady.m_bPreCalculatePos=True;
		}
		AlignButtons();
		m_fPlayerButWidth=m_pPlayerReady.WinWidth;
	}
	CheckForNavBarState();
}

function CheckForNavBarState ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if (  !m_pPlayerReady.bDisabled && (r6Root.m_R6GameMenuCom != None) && r6Root.m_R6GameMenuCom.IsInBetweenRoundMenu() )
	{
		SetNavBarState(m_pPlayerReady.m_bSelected,True);
	}
}

function AlignButtons ()
{
	local float fFreeSpace;
	local float fDistanceBetEachBut;

	fFreeSpace=WinWidth - 4;
	fFreeSpace -= m_SelectTeamButton.WinWidth + m_ServerOptButton.WinWidth + m_KitRestrictionButton.WinWidth + m_GearButton.WinWidth + m_pPlayerReady.WinWidth;
	if ( fFreeSpace > WinWidth )
	{
		fFreeSpace=WinWidth;
	}
	fDistanceBetEachBut=fFreeSpace / 6;
	m_SelectTeamButton.WinLeft=fDistanceBetEachBut;
	m_ServerOptButton.WinLeft=m_SelectTeamButton.WinLeft + m_SelectTeamButton.WinWidth + fDistanceBetEachBut;
	m_KitRestrictionButton.WinLeft=m_ServerOptButton.WinLeft + m_ServerOptButton.WinWidth + fDistanceBetEachBut;
	m_GearButton.WinLeft=m_KitRestrictionButton.WinLeft + m_KitRestrictionButton.WinWidth + fDistanceBetEachBut;
	m_pPlayerReady.WinLeft=m_GearButton.WinLeft + m_GearButton.WinWidth + fDistanceBetEachBut;
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	if ( E == 2 )
	{
		r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
		switch (C)
		{
			case m_SelectTeamButton:
			r6Root.m_R6GameMenuCom.SelectTeam();
//			r6Root.ChangeCurrentWidget(23);
			break;
			case m_ServerOptButton:
			if ( r6Root.m_pIntermissionMenuWidget != None )
			{
				r6Root.m_pIntermissionMenuWidget.PopUpServerOptMenu();
			}
			break;
			case m_KitRestrictionButton:
			if ( r6Root.m_pIntermissionMenuWidget != None )
			{
				r6Root.m_pIntermissionMenuWidget.PopUpKitRestMenu();
			}
			break;
			case m_GearButton:
			if ( r6Root.m_pIntermissionMenuWidget != None )
			{
				r6Root.m_pIntermissionMenuWidget.PopUpGearMenu();
			}
			break;
			case m_pPlayerReady:
			if ( R6WindowButtonBox(C).GetSelectStatus() )
			{
				r6Root.m_R6GameMenuCom.SetPlayerReadyStatus( !R6WindowButtonBox(C).m_bSelected);
			}
			break;
			default:
		}
	}
	else
	{
	}
}

function ToolTip (string strTip)
{
	m_HelpTextBar.SetToolTip(strTip);
}

function SetNavBarState (bool _bDisable, optional bool _bDisableAllExceptReadyBut)
{
	m_SelectTeamButton.bDisabled=_bDisable;
	m_ServerOptButton.bDisabled=_bDisable;
	m_KitRestrictionButton.bDisabled=_bDisable;
	m_GearButton.bDisabled=_bDisable;
	if (  !_bDisableAllExceptReadyBut )
	{
		m_pPlayerReady.bDisabled=_bDisable;
	}
}

function SetNavBarButtonsStatus (bool _bDisplay)
{
	if ( _bDisplay )
	{
		m_SelectTeamButton.ShowWindow();
		m_ServerOptButton.ShowWindow();
		m_KitRestrictionButton.ShowWindow();
		m_GearButton.ShowWindow();
		m_pPlayerReady.ShowWindow();
	}
	else
	{
		m_SelectTeamButton.HideWindow();
		m_ServerOptButton.HideWindow();
		m_KitRestrictionButton.HideWindow();
		m_GearButton.HideWindow();
		m_pPlayerReady.HideWindow();
	}
}

defaultproperties
{
    m_iXNavBarLoc(0)=160
    m_iXNavBarLoc(1)=250
    m_iXNavBarLoc(2)=340
    m_iXNavBarLoc(3)=430
    m_iYNavBarLoc(0)=23
    m_iYNavBarLoc(1)=24
    m_iYNavBarLoc(2)=24
    m_iYNavBarLoc(3)=22
    m_RSelectTeamButtonUp=(X=2564614,Y=570687488,W=35,H=1974787)
    m_RSelectTeamButtonDown=(X=2564614,Y=570753024,W=60,H=2302468)
    m_RSelectTeamButtonDisabled=(X=2564614,Y=570753024,W=90,H=2302468)
    m_RSelectTeamButtonOver=(X=2564614,Y=570753024,W=30,H=2302468)
    m_RServerOptButtonUp=(X=12198406,Y=570687488,W=36,H=1974787)
    m_RServerOptButtonDown=(X=12198406,Y=570753024,W=60,H=2368004)
    m_RServerOptButtonDisabled=(X=12198406,Y=570753024,W=90,H=2368004)
    m_RServerOptButtonOver=(X=12198406,Y=570753024,W=30,H=2368004)
    m_RKitRestrictionButtonUp=(X=2499076,Y=570621952,W=30,H=0)
    m_RKitRestrictionButtonDown=(X=3940869,Y=570687488,W=38,H=1974787)
    m_RKitRestrictionButtonDisabled=(X=5906949,Y=570687488,W=38,H=1974787)
    m_RKitRestrictionButtonOver=(X=1974789,Y=570687488,W=38,H=1974787)
    m_RGearButtonUp=(X=14623238,Y=570687488,W=33,H=1974787)
    m_RGearButtonDown=(X=14623238,Y=570753024,W=60,H=2171396)
    m_RGearButtonDisabled=(X=14623238,Y=570753024,W=90,H=2171396)
    m_RGearButtonOver=(X=14623238,Y=570753024,W=30,H=2171396)
}
/*
    m_TSelectTeamButton=Texture'R6MenuTextures.Gui_02'
    m_TServerOptButton=Texture'R6MenuTextures.Gui_01'
    m_TKitRestrictionButton=Texture'R6MenuTextures.Gui_02'
    m_TGearButton=Texture'R6MenuTextures.Gui_01'
*/

