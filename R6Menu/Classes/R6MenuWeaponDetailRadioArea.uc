//================================================================================
// R6MenuWeaponDetailRadioArea.
//================================================================================
class R6MenuWeaponDetailRadioArea extends UWindowDialogClientWindow;

var float m_fButtonTabWidth;
var float m_fButtonTabHeight;
var float m_fFirstButtonOffset;
var float m_fBetweenButtonOffset;
var R6WindowStayDownButton m_WeaponHistoryButton;
var R6WindowStayDownButton m_WeaponStatsButton;
var R6WindowStayDownButton m_CurrentSelectedButton;
var Region m_RHistoryUp;
var Region m_RHistoryOver;
var Region m_RHistoryDown;
var Region m_RStatsUp;
var Region m_RStatsOver;
var Region m_RStatsDown;

function Created ()
{
	local Texture ButtonTexture;
	local float fYPos;

	ButtonTexture=Texture(DynamicLoadObject("R6MenuTextures.Tab_Icon00",Class'Texture'));
	fYPos=WinHeight - m_RHistoryUp.H;
	m_WeaponHistoryButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',m_fFirstButtonOffset,fYPos,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_WeaponHistoryButton.UpRegion=m_RHistoryUp;
	m_WeaponHistoryButton.OverRegion=m_RHistoryOver;
	m_WeaponHistoryButton.DownRegion=m_RHistoryDown;
	m_WeaponHistoryButton.UpTexture=ButtonTexture;
	m_WeaponHistoryButton.OverTexture=ButtonTexture;
	m_WeaponHistoryButton.DownTexture=ButtonTexture;
	m_WeaponHistoryButton.m_iDrawStyle=5;
	m_WeaponHistoryButton.m_iButtonID=0;
	m_WeaponHistoryButton.ToolTipString=Localize("GearRoom","WEAPONDESC","R6Menu");
	m_WeaponHistoryButton.m_bCanBeUnselected=False;
	m_WeaponHistoryButton.bUseRegion=True;
	m_CurrentSelectedButton=m_WeaponHistoryButton;
	m_CurrentSelectedButton.m_bSelected=True;
	m_WeaponStatsButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',m_WeaponHistoryButton.WinLeft + m_WeaponHistoryButton.WinWidth + m_fBetweenButtonOffset,fYPos,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_WeaponStatsButton.UpRegion=m_RStatsUp;
	m_WeaponStatsButton.OverRegion=m_RStatsOver;
	m_WeaponStatsButton.DownRegion=m_RStatsDown;
	m_WeaponStatsButton.UpTexture=ButtonTexture;
	m_WeaponStatsButton.OverTexture=ButtonTexture;
	m_WeaponStatsButton.DownTexture=ButtonTexture;
	m_WeaponStatsButton.m_iDrawStyle=5;
	m_WeaponStatsButton.m_iButtonID=1;
	m_WeaponStatsButton.ToolTipString=Localize("GearRoom","WEAPONSTATS","R6Menu");
	m_WeaponStatsButton.m_bCanBeUnselected=False;
	m_WeaponStatsButton.bUseRegion=True;
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		if ( (R6WindowStayDownButton(C) != None) && (R6WindowStayDownButton(C) != m_CurrentSelectedButton) )
		{
			m_CurrentSelectedButton.m_bSelected=False;
			m_CurrentSelectedButton=R6WindowStayDownButton(C);
			m_CurrentSelectedButton.m_bSelected=True;
			if ( R6MenuEquipmentDetailControl(OwnerWindow) != None )
			{
				R6MenuEquipmentDetailControl(OwnerWindow).ChangePage(m_CurrentSelectedButton.m_iButtonID);
			}
		}
	}
}

function AfterPaint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}

function ShowWindow ()
{
	Super.ShowWindow();
	m_CurrentSelectedButton.m_bSelected=False;
	m_CurrentSelectedButton=m_WeaponStatsButton;
	m_CurrentSelectedButton.m_bSelected=True;
}

defaultproperties
{
    m_fButtonTabWidth=37.00
    m_fButtonTabHeight=20.00
    m_fFirstButtonOffset=2.00
    m_RHistoryUp=(X=7479814,Y=570753024,W=189,H=2433540)
    m_RHistoryOver=(X=7479814,Y=570753024,W=210,H=2433540)
    m_RHistoryDown=(X=7479814,Y=570753024,W=231,H=2433540)
    m_RStatsUp=(X=4137477,Y=570687488,W=37,H=1319427)
    m_RStatsOver=(X=5513733,Y=570687488,W=37,H=1319427)
    m_RStatsDown=(X=6889989,Y=570687488,W=37,H=1319427)
}