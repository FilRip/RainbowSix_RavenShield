//================================================================================
// R6MenuListActionTypeButton.
//================================================================================
class R6MenuListActionTypeButton extends R6MenuPopupListButton;

var bool m_bAutoSelect;
var R6MenuActionMenu m_WinAction;

function Created ()
{
	Super.Created();
	m_FontForButtons=Root.Fonts[12];
	m_fItemHeight=R6MenuRSLookAndFeel(LookAndFeel).m_BLTitleL.Up.H;
	m_ButtonItem[0]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionTypeButtonItem(m_ButtonItem[0]).m_eActionType=0;
	m_ButtonItem[0].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[0].m_Button.SetText(Localize("Order","Type_Normal","R6Menu"));
//	R6MenuPopUpStayDownButton(m_ButtonItem[0].m_Button).m_bSubMenu=True;
	m_ButtonItem[0].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[1]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionTypeButtonItem(m_ButtonItem[1]).m_eActionType=1;
	m_ButtonItem[1].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[1].m_Button.SetText(Localize("Order","Type_Milestone","R6Menu"));
//	R6MenuPopUpStayDownButton(m_ButtonItem[1].m_Button).m_bSubMenu=True;
	m_ButtonItem[1].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[2]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionTypeButtonItem(m_ButtonItem[2]).m_eActionType=2;
	m_ButtonItem[2].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[2].m_Button.SetText(Localize("Order","Type_GoCode_Alpha","R6Menu"));
//	R6MenuPopUpStayDownButton(m_ButtonItem[2].m_Button).m_bSubMenu=True;
	m_ButtonItem[2].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[3]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionTypeButtonItem(m_ButtonItem[3]).m_eActionType=3;
	m_ButtonItem[3].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[3].m_Button.SetText(Localize("Order","Type_GoCode_Bravo","R6Menu"));
//	R6MenuPopUpStayDownButton(m_ButtonItem[3].m_Button).m_bSubMenu=True;
	m_ButtonItem[3].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[4]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionTypeButtonItem(m_ButtonItem[4]).m_eActionType=4;
	m_ButtonItem[4].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[4].m_Button.SetText(Localize("Order","Type_GoCode_Charlie","R6Menu"));
//	R6MenuPopUpStayDownButton(m_ButtonItem[4].m_Button).m_bSubMenu=True;
	m_ButtonItem[4].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[5]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuActionTypeButtonItem(m_ButtonItem[5]).m_eActionType=5;
	m_ButtonItem[5].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[5].m_Button.SetText(Localize("Order","Type_Delete","R6Menu"));
	m_ButtonItem[5].m_Button.m_buttonFont=m_FontForButtons;
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	local R6PlanningInfo Planning;

	Planning=R6PlanningCtrl(GetPlayerOwner()).m_pTeamInfo[R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam];
	HidePopup();
	Super.SetSelectedItem(NewSelected);
	if ( m_bAutoSelect != True )
	{
		if ( R6MenuActionTypeButtonItem(m_SelectedItem).m_eActionType == 5 )
		{
			Planning.DeleteNode();
			R6MenuRootWindow(Root).m_PlanningWidget.m_bClosePopup=True;
		}
		else
		{
			Planning.SetActionType(R6MenuActionTypeButtonItem(m_SelectedItem).m_eActionType);
			ShowPopup();
		}
	}
}

function DisplayMilestoneButton ()
{
	local bool bDoIDisplay;

	bDoIDisplay=R6PlanningCtrl(GetPlayerOwner()).m_pTeamInfo[R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam].m_iNbMilestone < 9;
	R6MenuActionTypeButtonItem(m_ButtonItem[1]).m_Button.bDisabled= !bDoIDisplay;
}

function HidePopup ()
{
	if ( m_WinAction != None )
	{
		m_WinAction.HideWindow();
	}
}

function ShowWindow ()
{
	local EPlanActionType eType;

	eType=R6PlanningCtrl(GetPlayerOwner()).GetCurrentActionType();
	Super.ShowWindow();
	m_bAutoSelect=True;
	if ( m_ButtonItem[eType] != m_SelectedItem )
	{
		SetSelectedItem(m_ButtonItem[eType]);
	}
	m_bAutoSelect=False;
}

function ShowPopup ()
{
	local float fGlobalLeft;
	local float fGlobalTop;

	WindowToGlobal(ParentWindow.WinLeft,ParentWindow.WinTop,fGlobalLeft,fGlobalTop);
	fGlobalLeft=ParentWindow.WinLeft + ParentWindow.WinWidth;
	if ( m_WinAction == None )
	{
		m_WinAction=R6MenuActionMenu(R6MenuRootWindow(Root).m_PlanningWidget.CreateWindow(Class'R6MenuActionMenu',fGlobalLeft,ParentWindow.WinTop,150.00,100.00,OwnerWindow));
	}
	else
	{
		m_WinAction.WinLeft=fGlobalLeft;
		m_WinAction.WinTop=ParentWindow.WinTop;
		m_WinAction.ShowWindow();
	}
	R6MenuListActionButton(m_WinAction.m_ButtonList).DisplaySnipeButton(R6MenuActionTypeButtonItem(m_SelectedItem).m_eActionType > 1);
	R6MenuListActionButton(m_WinAction.m_ButtonList).DisplayBreachDoor(R6PlanningCtrl(GetPlayerOwner()).GetCurrentPoint().m_bDoorInRange);
	m_WinAction.AjustPosition(R6MenuFramePopup(OwnerWindow).m_bDisplayUp,R6MenuFramePopup(OwnerWindow).m_bDisplayLeft);
	if ( R6MenuFramePopup(ParentWindow).m_bDisplayLeft == True )
	{
		m_WinAction.WinLeft -= ParentWindow.WinWidth - 6;
	}
	if ( R6MenuFramePopup(ParentWindow).m_bDisplayUp == True )
	{
		m_WinAction.WinTop -= m_WinAction.WinHeight - ParentWindow.WinHeight;
	}
}

defaultproperties
{
    m_iNbButton=6
    ListClass=Class'R6MenuActionTypeButtonItem'
}
