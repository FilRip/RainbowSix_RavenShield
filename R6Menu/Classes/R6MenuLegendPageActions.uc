//================================================================================
// R6MenuLegendPageActions.
//================================================================================
class R6MenuLegendPageActions extends R6MenuLegendPage;

function Created ()
{
	Super.Created();
	m_szPageTitle=Localize("PlanningLegend","Actions","R6Menu");
	m_ButtonItem[0]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[0]).m_pObjectIcon=Texture'PlanIcon_Frag';
	m_ButtonItem[0].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[0].m_Button.SetText(Localize("PlanningLegend","ActionsFrag","R6Menu"));
	m_ButtonItem[0].m_Button.ToolTipString=Localize("PlanningLegend","ActionsFragTip","R6Menu");
	m_ButtonItem[0].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[0].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[1]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[1]).m_pObjectIcon=Texture'PlanIcon_Flash';
	m_ButtonItem[1].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[1].m_Button.SetText(Localize("PlanningLegend","ActionsFlash","R6Menu"));
	m_ButtonItem[1].m_Button.ToolTipString=Localize("PlanningLegend","ActionsFlashTip","R6Menu");
	m_ButtonItem[1].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[1].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[2]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[2]).m_pObjectIcon=Texture'PlanIcon_Smoke';
	m_ButtonItem[2].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[2].m_Button.SetText(Localize("PlanningLegend","ActionsSmoke","R6Menu"));
	m_ButtonItem[2].m_Button.ToolTipString=Localize("PlanningLegend","ActionsSmokeTip","R6Menu");
	m_ButtonItem[2].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[2].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[3]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[3]).m_pObjectIcon=Texture'PlanIcon_Gas';
	m_ButtonItem[3].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[3].m_Button.SetText(Localize("PlanningLegend","ActionsGas","R6Menu"));
	m_ButtonItem[3].m_Button.ToolTipString=Localize("PlanningLegend","ActionsGasTip","R6Menu");
	m_ButtonItem[3].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[3].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[4]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[4]).m_pObjectIcon=Texture'PlanIcon_Snipe';
	m_ButtonItem[4].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[4].m_Button.SetText(Localize("PlanningLegend","ActionsSnipe","R6Menu"));
	m_ButtonItem[4].m_Button.ToolTipString=Localize("PlanningLegend","ActionsSnipeTip","R6Menu");
	m_ButtonItem[4].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[4].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[5]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[5]).m_pObjectIcon=Texture'PlanIcon_BreachDoor';
	R6MenuLegendItem(m_ButtonItem[5]).m_bOtherTextureHeight=True;
	m_ButtonItem[5].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[5].m_Button.SetText(Localize("PlanningLegend","ActionsBreach","R6Menu"));
	m_ButtonItem[5].m_Button.ToolTipString=Localize("PlanningLegend","ActionsBreachTip","R6Menu");
	m_ButtonItem[5].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[5].m_Button.m_bPlayButtonSnd=False;
}
