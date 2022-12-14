//================================================================================
// R6MenuLegendPageObject.
//================================================================================
class R6MenuLegendPageObject extends R6MenuLegendPage;

function Created ()
{
	Super.Created();
	m_szPageTitle=Localize("PlanningLegend","Object","R6Menu");
	m_ButtonItem[0]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[0]).m_pObjectIcon=Texture'PlanIcon_KnownTerrorist';
	m_ButtonItem[0].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[0].m_Button.SetText(Localize("PlanningLegend","ObjectTerrorist","R6Menu"));
	m_ButtonItem[0].m_Button.ToolTipString=Localize("PlanningLegend","ObjectTerroristTip","R6Menu");
	m_ButtonItem[0].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[0].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[1]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[1]).m_pObjectIcon=Texture'PlanIcon_KnownHostage';
	m_ButtonItem[1].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[1].m_Button.SetText(Localize("PlanningLegend","ObjectHostage","R6Menu"));
	m_ButtonItem[1].m_Button.ToolTipString=Localize("PlanningLegend","ObjectHostageTip","R6Menu");
	m_ButtonItem[1].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[1].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[2]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[2]).m_pObjectIcon=Texture'PlanIcon_Objective';
	m_ButtonItem[2].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[2].m_Button.SetText(Localize("PlanningLegend","ObjectObjective","R6Menu"));
	m_ButtonItem[2].m_Button.ToolTipString=Localize("PlanningLegend","ObjectObjectiveTip","R6Menu");
	m_ButtonItem[2].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[2].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[3]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[3]).m_pObjectIcon=Texture'PlanLegend_ExtractionCircle';
	m_ButtonItem[3].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[3].m_Button.SetText(Localize("PlanningLegend","ObjectExtraction","R6Menu"));
	m_ButtonItem[3].m_Button.ToolTipString=Localize("PlanningLegend","ObjectExtractionTip","R6Menu");
	m_ButtonItem[3].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[3].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[4]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[4]).m_pObjectIcon=Texture'PlanLegend_InsertionCircle';
	m_ButtonItem[4].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[4].m_Button.SetText(Localize("PlanningLegend","ObjectInsertion","R6Menu"));
	m_ButtonItem[4].m_Button.ToolTipString=Localize("PlanningLegend","ObjectInsertionTip","R6Menu");
	m_ButtonItem[4].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[4].m_Button.m_bPlayButtonSnd=False;
	m_ButtonItem[5]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuLegendItem(m_ButtonItem[5]).m_pObjectIcon=Texture'PlanLegend_ObjectCircle';
	m_ButtonItem[5].m_Button=R6WindowButton(CreateWindow(Class'R6WindowButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[5].m_Button.SetText(Localize("PlanningLegend","ObjectStaticMesh","R6Menu"));
	m_ButtonItem[5].m_Button.ToolTipString=Localize("PlanningLegend","ObjectStaticMeshTip","R6Menu");
	m_ButtonItem[5].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[5].m_Button.m_bPlayButtonSnd=False;
}
