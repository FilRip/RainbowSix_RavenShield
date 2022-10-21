//================================================================================
// R6MenuListSpeedButton.
//================================================================================
class R6MenuListSpeedButton extends R6MenuPopupListButton;

var bool m_bAutoSelect;

function Created ()
{
	Super.Created();
	m_FontForButtons=Root.Fonts[12];
	m_fItemHeight=R6MenuRSLookAndFeel(LookAndFeel).m_BLTitleL.Up.H;
	m_ButtonItem[0]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuSpeedButtonItem(m_ButtonItem[0]).m_eSpeed=0;
	m_ButtonItem[0].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[0].m_Button.SetText(Localize("Order","Speed_Blitz","R6Menu"));
	m_ButtonItem[0].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[1]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuSpeedButtonItem(m_ButtonItem[1]).m_eSpeed=1;
	m_ButtonItem[1].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[1].m_Button.SetText(Localize("Order","Speed_Normal","R6Menu"));
	m_ButtonItem[1].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[2]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuSpeedButtonItem(m_ButtonItem[2]).m_eSpeed=2;
	m_ButtonItem[2].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[2].m_Button.SetText(Localize("Order","Speed_Cautious","R6Menu"));
	m_ButtonItem[2].m_Button.m_buttonFont=m_FontForButtons;
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	local R6PlanningInfo Planning;

	Super.SetSelectedItem(NewSelected);
	if ( m_SelectedItem == None )
	{
		Log("NoSelected Item in action button menu? that's weird!");
		return;
	}
	Planning=R6PlanningCtrl(GetPlayerOwner()).m_pTeamInfo[R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam];
	if (  !m_bAutoSelect )
	{
		Planning.SetMovementSpeed(R6MenuSpeedButtonItem(m_SelectedItem).m_eSpeed);
		R6MenuRootWindow(Root).m_PlanningWidget.m_bClosePopup=True;
	}
}

function ShowWindow ()
{
	local EMovementSpeed eSpeed;

	Super.ShowWindow();
//	eSpeed=R6PlanningCtrl(GetPlayerOwner()).m_pTeamInfo[R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam].GetMovementSpeed();
	m_bAutoSelect=True;
	if ( m_ButtonItem[eSpeed] != m_SelectedItem )
	{
		SetSelectedItem(m_ButtonItem[eSpeed]);
	}
	m_bAutoSelect=False;
}

defaultproperties
{
    m_iNbButton=3
    ListClass=Class'R6MenuSpeedButtonItem'
}
