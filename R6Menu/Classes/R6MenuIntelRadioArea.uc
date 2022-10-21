//================================================================================
// R6MenuIntelRadioArea.
//================================================================================
class R6MenuIntelRadioArea extends UWindowDialogClientWindow;

var R6WindowStayDownButton m_ControlButton;
var R6WindowStayDownButton m_ClarkButton;
var R6WindowStayDownButton m_SweenyButton;
var R6WindowStayDownButton m_NewsButton;
var R6WindowStayDownButton m_MissionButton;
var R6WindowStayDownButton m_CurrentSelectedButton;

function Created ()
{
	local Color cFontColor;
	local Font ButtonFont;
	local Texture BGSelecTexture;
	local Region BGRegion;
	local float fXOffset;
	local float fYOffset;
	local float fStepBetweenControl;

	BGSelecTexture=Texture(DynamicLoadObject("R6MenuTextures.Gui_BoxScroll",Class'Texture'));
	ButtonFont=Root.Fonts[16];
	cFontColor=Root.Colors.BlueLight;
	BGRegion.X=132;
	BGRegion.Y=24;
	BGRegion.W=2;
	BGRegion.H=19;
	fXOffset=5.00;
	fYOffset=8.00;
	fStepBetweenControl=20.00;
	m_ControlButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',fXOffset,fYOffset,WinWidth,20.00));
	m_ControlButton.ToolTipString=Localize("Tip","Speaker1","R6Menu");
	m_ControlButton.Text=Localize("Briefing","Speaker1","R6Menu");
	m_ControlButton.Align=TA_Left;
	m_ControlButton.m_buttonFont=ButtonFont;
	m_ControlButton.m_BGSelecTexture=BGSelecTexture;
	m_ControlButton.DownRegion=BGRegion;
//	m_ControlButton.m_iButtonID=R6MenuIntelWidget(OwnerWindow).0;
	m_ControlButton.m_bUseOnlyNotifyMsg=True;
	fYOffset += fStepBetweenControl;
	m_ClarkButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',fXOffset,fYOffset,WinWidth,20.00));
	m_ClarkButton.ToolTipString=Localize("Tip","Speaker2","R6Menu");
	m_ClarkButton.Text=Localize("Briefing","Speaker2","R6Menu");
	m_ClarkButton.Align=TA_Left;
	m_ClarkButton.m_buttonFont=ButtonFont;
	m_ClarkButton.m_BGSelecTexture=BGSelecTexture;
	m_ClarkButton.DownRegion=BGRegion;
//	m_ClarkButton.m_iButtonID=R6MenuIntelWidget(OwnerWindow).1;
	m_ClarkButton.m_bUseOnlyNotifyMsg=True;
	fYOffset += fStepBetweenControl;
	m_SweenyButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',fXOffset,fYOffset,WinWidth,20.00));
	m_SweenyButton.ToolTipString=Localize("Tip","Speaker3","R6Menu");
	m_SweenyButton.Text=Localize("Briefing","Speaker3","R6Menu");
	m_SweenyButton.Align=TA_Left;
	m_SweenyButton.m_buttonFont=ButtonFont;
	m_SweenyButton.DownRegion=BGRegion;
//	m_SweenyButton.m_iButtonID=R6MenuIntelWidget(OwnerWindow).2;
	m_SweenyButton.m_bUseOnlyNotifyMsg=True;
	fYOffset += fStepBetweenControl;
	m_NewsButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',fXOffset,fYOffset,WinWidth,20.00));
	m_NewsButton.ToolTipString=Localize("Tip","Speaker4","R6Menu");
	m_NewsButton.Text=Localize("Briefing","Speaker4","R6Menu");
	m_NewsButton.Align=TA_Left;
	m_NewsButton.m_buttonFont=ButtonFont;
	m_NewsButton.m_BGSelecTexture=BGSelecTexture;
	m_NewsButton.DownRegion=BGRegion;
//	m_NewsButton.m_iButtonID=R6MenuIntelWidget(OwnerWindow).3;
	m_NewsButton.m_bUseOnlyNotifyMsg=True;
	fYOffset += fStepBetweenControl;
	m_MissionButton=R6WindowStayDownButton(CreateControl(Class'R6WindowStayDownButton',fXOffset,fYOffset,WinWidth,20.00));
	m_MissionButton.ToolTipString=Localize("Tip","Speaker5","R6Menu");
	m_MissionButton.Text=Localize("Briefing","Speaker5","R6Menu");
	m_MissionButton.Align=TA_Left;
	m_MissionButton.m_buttonFont=ButtonFont;
	m_MissionButton.m_BGSelecTexture=BGSelecTexture;
	m_MissionButton.DownRegion=BGRegion;
//	m_MissionButton.m_iButtonID=R6MenuIntelWidget(OwnerWindow).4;
	m_MissionButton.m_bUseOnlyNotifyMsg=True;
	m_CurrentSelectedButton=m_ControlButton;
	m_CurrentSelectedButton.m_bSelected=True;
}

function Reset ()
{
	m_CurrentSelectedButton.m_bSelected=False;
	m_CurrentSelectedButton=m_ControlButton;
	m_CurrentSelectedButton.m_bSelected=True;
}

function AssociateButtons ()
{
	AssociateTextWithButton(m_ControlButton,"ID_CONTROL");
	AssociateTextWithButton(m_ClarkButton,"ID_CLARK");
	AssociateTextWithButton(m_SweenyButton,"ID_SWEENY");
	AssociateTextWithButton(m_NewsButton,"ID_NEWSWIRE");
	AssociateTextWithButton(m_MissionButton,"ID_MISSION_ORDER");
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6WindowStayDownButton tmpButton;

	if ( E == 2 )
	{
		tmpButton=R6WindowStayDownButton(C);
		if ( tmpButton != None )
		{
			if ( (tmpButton != m_CurrentSelectedButton) &&  !tmpButton.bDisabled )
			{
				m_CurrentSelectedButton.m_bSelected=False;
				m_CurrentSelectedButton=tmpButton;
				m_CurrentSelectedButton.m_bSelected=True;
				if ( R6MenuIntelWidget(OwnerWindow) != None )
				{
					R6MenuIntelWidget(OwnerWindow).ManageButtonSelection(m_CurrentSelectedButton.m_iButtonID);
				}
			}
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}

function AssociateTextWithButton (R6WindowStayDownButton _R6Button, string _szTextToFind)
{
	local bool bHaveTextForButton;

	bHaveTextForButton=R6MenuIntelWidget(OwnerWindow).SetMissionText(_szTextToFind);
	if (  !bHaveTextForButton )
	{
		_R6Button.bDisabled=True;
	}
	else
	{
		_R6Button.bDisabled=False;
	}
}
