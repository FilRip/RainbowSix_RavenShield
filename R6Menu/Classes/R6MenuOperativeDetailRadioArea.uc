//================================================================================
// R6MenuOperativeDetailRadioArea.
//================================================================================
class R6MenuOperativeDetailRadioArea extends UWindowDialogClientWindow;

var float m_fButtonTabWidth;
var float m_fButtonTabHeight;
var float m_fFirstButtonOffset;
var float m_fBetweenButtonOffset;
var R6WindowStayDownButton m_OperativeHistoryButton;
var R6WindowStayDownButton m_OperativeSkillsButton;
var R6WindowStayDownButton m_OperativeBioButton;
var R6WindowStayDownButton m_OperativeStatsButton;
var R6WindowStayDownButton m_CurrentSelectedButton;
var Region m_RHistoryUp;
var Region m_RHistoryOver;
var Region m_RHistoryDown;
var Region m_RSkillsUp;
var Region m_RSkillsOver;
var Region m_RSkillsDown;
var Region m_RBioUp;
var Region m_RBioOver;
var Region m_RBioDown;
var Region m_RStatsUp;
var Region m_RStatsOver;
var Region m_RStatsDown;

function Created ()
{
	local Texture ButtonTexture;
	local int YPos;

	ButtonTexture=Texture(DynamicLoadObject("R6MenuTextures.Tab_Icon00",Class'Texture'));
	YPos=WinHeight - m_fButtonTabHeight;
	m_OperativeHistoryButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',m_fFirstButtonOffset,YPos,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_OperativeHistoryButton.ToolTipString=Localize("Tip","GearRoomButHistory","R6Menu");
	m_OperativeHistoryButton.UpRegion=m_RHistoryUp;
	m_OperativeHistoryButton.OverRegion=m_RHistoryOver;
	m_OperativeHistoryButton.DownRegion=m_RHistoryDown;
	m_OperativeHistoryButton.UpTexture=ButtonTexture;
	m_OperativeHistoryButton.OverTexture=ButtonTexture;
	m_OperativeHistoryButton.DownTexture=ButtonTexture;
	m_OperativeHistoryButton.m_iDrawStyle=5;
	m_OperativeHistoryButton.m_iButtonID=1;
	m_OperativeHistoryButton.m_bCanBeUnselected=False;
	m_OperativeHistoryButton.bUseRegion=True;
	m_OperativeSkillsButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',m_OperativeHistoryButton.WinLeft + m_OperativeHistoryButton.WinWidth + m_fBetweenButtonOffset,YPos,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_OperativeSkillsButton.ToolTipString=Localize("Tip","GearRoomButSkills","R6Menu");
	m_OperativeSkillsButton.UpRegion=m_RSkillsUp;
	m_OperativeSkillsButton.OverRegion=m_RSkillsOver;
	m_OperativeSkillsButton.DownRegion=m_RSkillsDown;
	m_OperativeSkillsButton.UpTexture=ButtonTexture;
	m_OperativeSkillsButton.OverTexture=ButtonTexture;
	m_OperativeSkillsButton.DownTexture=ButtonTexture;
	m_OperativeSkillsButton.m_iDrawStyle=5;
	m_OperativeSkillsButton.m_iButtonID=2;
	m_OperativeSkillsButton.m_bCanBeUnselected=False;
	m_OperativeSkillsButton.bUseRegion=True;
	m_OperativeBioButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',m_OperativeSkillsButton.WinLeft + m_OperativeSkillsButton.WinWidth + m_fBetweenButtonOffset,YPos,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_OperativeBioButton.ToolTipString=Localize("Tip","GearRoomButMedic","R6Menu");
	m_OperativeBioButton.UpRegion=m_RBioUp;
	m_OperativeBioButton.OverRegion=m_RBioOver;
	m_OperativeBioButton.DownRegion=m_RBioDown;
	m_OperativeBioButton.UpTexture=ButtonTexture;
	m_OperativeBioButton.OverTexture=ButtonTexture;
	m_OperativeBioButton.DownTexture=ButtonTexture;
	m_OperativeBioButton.m_iDrawStyle=5;
	m_OperativeBioButton.m_iButtonID=3;
	m_OperativeBioButton.m_bCanBeUnselected=False;
	m_OperativeBioButton.bUseRegion=True;
	m_OperativeStatsButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',m_OperativeBioButton.WinLeft + m_OperativeBioButton.WinWidth + m_fBetweenButtonOffset,YPos,m_fButtonTabWidth,m_fButtonTabHeight,self));
	m_OperativeStatsButton.ToolTipString=Localize("Tip","GearRoomButCampStats","R6Menu");
	m_OperativeStatsButton.UpRegion=m_RStatsUp;
	m_OperativeStatsButton.OverRegion=m_RStatsOver;
	m_OperativeStatsButton.DownRegion=m_RStatsDown;
	m_OperativeStatsButton.UpTexture=ButtonTexture;
	m_OperativeStatsButton.OverTexture=ButtonTexture;
	m_OperativeStatsButton.DownTexture=ButtonTexture;
	m_OperativeStatsButton.m_iDrawStyle=5;
	m_OperativeStatsButton.m_iButtonID=4;
	m_OperativeStatsButton.m_bCanBeUnselected=False;
	m_OperativeStatsButton.bUseRegion=True;
	m_CurrentSelectedButton=m_OperativeSkillsButton;
	m_CurrentSelectedButton.m_bSelected=True;
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
			if ( R6MenuOperativeDetailControl(OwnerWindow) != None )
			{
				R6MenuOperativeDetailControl(OwnerWindow).ChangePage(m_CurrentSelectedButton.m_iButtonID);
			}
		}
	}
}

defaultproperties
{
    m_fButtonTabWidth=37.00
    m_fButtonTabHeight=20.00
    m_fFirstButtonOffset=2.00
    m_RHistoryUp=(X=12460550,Y=570687488,W=37,H=1319427)
    m_RHistoryOver=(X=12460550,Y=570753024,W=21,H=2433540)
    m_RHistoryDown=(X=12460550,Y=570753024,W=42,H=2433540)
    m_RSkillsUp=(X=4137477,Y=570687488,W=37,H=1319427)
    m_RSkillsOver=(X=5513733,Y=570687488,W=37,H=1319427)
    m_RSkillsDown=(X=6889989,Y=570687488,W=37,H=1319427)
    m_RBioUp=(X=2499078,Y=570753024,W=63,H=2433540)
    m_RBioOver=(X=2499078,Y=570753024,W=84,H=2433540)
    m_RBioDown=(X=2499078,Y=570753024,W=105,H=2433540)
    m_RStatsUp=(X=4989446,Y=570753024,W=63,H=2433540)
    m_RStatsOver=(X=4989446,Y=570753024,W=84,H=2433540)
    m_RStatsDown=(X=4989446,Y=570753024,W=105,H=2433540)
}