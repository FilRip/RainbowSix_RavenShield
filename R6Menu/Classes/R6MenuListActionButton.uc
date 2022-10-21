//================================================================================
// R6MenuListActionButton.
//================================================================================
class R6MenuListActionButton extends R6MenuPopupListButton;

var bool m_bAutoSelect;

function Created ()
{
	Super.Created();
	m_FontForButtons=Root.Fonts[12];
	m_fItemHeight=R6MenuRSLookAndFeel(LookAndFeel).m_BLTitleL.Up.H;
	m_ButtonItem[0]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionButtonItem(m_ButtonItem[0]).m_eAction=0;
	m_ButtonItem[0].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[0].m_Button.SetText(Localize("Order","Action_None","R6Menu"));
	m_ButtonItem[0].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[1]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionButtonItem(m_ButtonItem[1]).m_eAction=1;
	m_ButtonItem[1].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[1].m_Button.SetText(Localize("Order","Action_FragRoom","R6Menu"));
	m_ButtonItem[1].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[2]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionButtonItem(m_ButtonItem[2]).m_eAction=2;
	m_ButtonItem[2].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[2].m_Button.SetText(Localize("Order","Action_FlashRoom","R6Menu"));
	m_ButtonItem[2].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[3]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionButtonItem(m_ButtonItem[3]).m_eAction=3;
	m_ButtonItem[3].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[3].m_Button.SetText(Localize("Order","Action_Gas","R6Menu"));
	m_ButtonItem[3].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[4]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionButtonItem(m_ButtonItem[4]).m_eAction=4;
	m_ButtonItem[4].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[4].m_Button.SetText(Localize("Order","Action_Smoke","R6Menu"));
	m_ButtonItem[4].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[5]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionButtonItem(m_ButtonItem[5]).m_eAction=5;
	m_ButtonItem[5].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[5].m_Button.SetText(Localize("Order","Action_Snipe","R6Menu"));
	R6MenuActionButtonItem(m_ButtonItem[5]).m_Button.bDisabled=True;
	m_ButtonItem[5].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[6]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionButtonItem(m_ButtonItem[6]).m_eAction=6;
	m_ButtonItem[6].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[6].m_Button.SetText(Localize("Order","Action_BreachDoor","R6Menu"));
	R6MenuActionButtonItem(m_ButtonItem[6]).m_Button.bDisabled=True;
	m_ButtonItem[6].m_Button.m_buttonFont=m_FontForButtons;
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	local R6PlanningInfo Planning;
	local R6PlanningCtrl OwnerCtrl;
	local R6MenuActionButtonItem SelectedItem;

	Super.SetSelectedItem(NewSelected);
	OwnerCtrl=R6PlanningCtrl(GetPlayerOwner());
	SelectedItem=R6MenuActionButtonItem(m_SelectedItem);
	if ( m_SelectedItem == None )
	{
		Log("NoSelected Item in action button menu? that's weird!");
		return;
	}
	Planning=OwnerCtrl.m_pTeamInfo[OwnerCtrl.m_iCurrentTeam];
	if (  !m_bAutoSelect )
	{
		Planning.SetCurrentPointAction(SelectedItem.m_eAction);
		if ( (SelectedItem.m_eAction == 1) || (SelectedItem.m_eAction == 2) || (SelectedItem.m_eAction == 3) || (SelectedItem.m_eAction == 4) )
		{
			OwnerCtrl.m_bClickToFindLocation=True;
			OwnerCtrl.m_bClickedOnRange=False;
			R6MenuRootWindow(Root).m_bUseAimIcon=True;
		}
		if ( SelectedItem.m_eAction == 5 )
		{
			OwnerCtrl.m_bSetSnipeDirection=True;
			R6MenuRootWindow(Root).m_bUseAimIcon=True;
		}
		R6MenuRootWindow(Root).m_PlanningWidget.m_bClosePopup=True;
	}
}

function DisplaySnipeButton (bool bDoIDisplay)
{
	R6MenuActionButtonItem(m_ButtonItem[5]).m_Button.bDisabled= !bDoIDisplay;
}

function DisplayBreachDoor (bool bDoIDisplay)
{
	R6MenuActionButtonItem(m_ButtonItem[6]).m_Button.bDisabled= !bDoIDisplay;
}

function ShowWindow ()
{
	local EPlanAction eAction;

	Super.ShowWindow();
//	eAction=R6PlanningCtrl(GetPlayerOwner()).m_pTeamInfo[R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam].GetAction();
	m_bAutoSelect=True;
	if ( m_ButtonItem[eAction] != m_SelectedItem )
	{
		SetSelectedItem(m_ButtonItem[eAction]);
	}
	m_bAutoSelect=False;
}

defaultproperties
{
    m_iNbButton=7
    ListClass=Class'R6MenuActionButtonItem'
}
