//================================================================================
// R6MenuLegendPageWPDesc.
//================================================================================
class R6MenuLegendPageWPDesc extends R6MenuLegendPage;

function Created ()
{
	Super.Created();
	m_szPageTitle=Localize("PlanningLegend","WP","R6Menu");
	m_ButtonItem[0]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[0]).m_pObjectIcon=Texture'PlanIcon_Alpha';
	m_ButtonItem[0].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[0].m_Button.SetText(Localize("PlanningLegend","WPAlpha","R6Menu"));
	m_ButtonItem[0].m_Button.ToolTipString=Localize("PlanningLegend","WPAlphaTip","R6Menu");
	m_ButtonItem[0].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[0].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[1]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[1]).m_pObjectIcon=Texture'PlanIcon_Bravo';
	m_ButtonItem[1].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[1].m_Button.SetText(Localize("PlanningLegend","WPBravo","R6Menu"));
	m_ButtonItem[1].m_Button.ToolTipString=Localize("PlanningLegend","WPBravoTip","R6Menu");
	m_ButtonItem[1].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[1].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[2]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[2]).m_pObjectIcon=Texture'PlanIcon_Charlie';
	m_ButtonItem[2].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[2].m_Button.SetText(Localize("PlanningLegend","WPCharlie","R6Menu"));
	m_ButtonItem[2].m_Button.ToolTipString=Localize("PlanningLegend","WPCharlieTip","R6Menu");
	m_ButtonItem[2].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[2].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[3]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[3]).m_pObjectIcon=Texture'PlanIcon_Milestone19';
	m_ButtonItem[3].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[3].m_Button.SetText(Localize("PlanningLegend","WPMilestone","R6Menu"));
	m_ButtonItem[3].m_Button.ToolTipString=Localize("PlanningLegend","WPMilestoneTip","R6Menu");
	m_ButtonItem[3].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[3].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[4]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[4]).m_pObjectIcon=Texture'PlanIcon_ActionPoint';
	m_ButtonItem[4].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[4].m_Button.SetText(Localize("PlanningLegend","WPWaypoint","R6Menu"));
	m_ButtonItem[4].m_Button.ToolTipString=Localize("PlanningLegend","WPWaypointTip","R6Menu");
	m_ButtonItem[4].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[4].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[5]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[5]).m_pObjectIcon=Texture'PlanIcon_SelectedPoint';
	m_ButtonItem[5].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[5].m_Button.SetText(Localize("PlanningLegend","WPSelectedWaypoint","R6Menu"));
	m_ButtonItem[5].m_Button.ToolTipString=Localize("PlanningLegend","WPSelectedWaypointTip","R6Menu");
	m_ButtonItem[5].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[5].m_Button.m_bPlayButtonSnd=False;
}
