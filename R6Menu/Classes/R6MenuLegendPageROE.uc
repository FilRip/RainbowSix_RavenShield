//================================================================================
// R6MenuLegendPageROE.
//================================================================================
class R6MenuLegendPageROE extends R6MenuLegendPage;

function Created ()
{
	Super.Created();
	m_szPageTitle=Localize("PlanningLegend","ROE","R6Menu");
	m_ButtonItem[0]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[0]).m_pObjectIcon=Texture'PlanIcon_Blitz';
	m_ButtonItem[0].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[0].m_Button.SetText(Localize("PlanningLegend","ROEBlitz","R6Menu"));
	m_ButtonItem[0].m_Button.ToolTipString=Localize("PlanningLegend","ROEBlitzTip","R6Menu");
	m_ButtonItem[0].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[0].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[1]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[1]).m_pObjectIcon=Texture'PlanIcon_Normal';
	m_ButtonItem[1].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[1].m_Button.SetText(Localize("PlanningLegend","ROENormal","R6Menu"));
	m_ButtonItem[1].m_Button.ToolTipString=Localize("PlanningLegend","ROENormalTip","R6Menu");
	m_ButtonItem[1].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[1].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[2]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[2]).m_pObjectIcon=Texture'PlanIcon_Cautious';
	m_ButtonItem[2].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[2].m_Button.SetText(Localize("PlanningLegend","ROECautious","R6Menu"));
	m_ButtonItem[2].m_Button.ToolTipString=Localize("PlanningLegend","ROECautiousTip","R6Menu");
	m_ButtonItem[2].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[2].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[3]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[3]).m_pObjectIcon=Texture'PlanIcon_Assault';
	m_ButtonItem[3].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[3].m_Button.SetText(Localize("PlanningLegend","ROEAssault","R6Menu"));
	m_ButtonItem[3].m_Button.ToolTipString=Localize("PlanningLegend","ROEAssaultTip","R6Menu");
	m_ButtonItem[3].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[3].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[4]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[4]).m_pObjectIcon=Texture'PlanIcon_Infiltrate';
	m_ButtonItem[4].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[4].m_Button.SetText(Localize("PlanningLegend","ROEInfiltrate","R6Menu"));
	m_ButtonItem[4].m_Button.ToolTipString=Localize("PlanningLegend","ROEInfiltrateTip","R6Menu");
	m_ButtonItem[4].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[4].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[5]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[5]).m_pObjectIcon=Texture'PlanIcon_Recon';
	m_ButtonItem[5].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[5].m_Button.SetText(Localize("PlanningLegend","ROERecon","R6Menu"));
	m_ButtonItem[5].m_Button.ToolTipString=Localize("PlanningLegend","ROEReconTip","R6Menu");
	m_ButtonItem[5].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[5].m_Button.m_bPlayButtonSnd=False;
}
