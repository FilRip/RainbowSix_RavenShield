//================================================================================
// R6MenuListModeButton.
//================================================================================
class R6MenuListModeButton extends R6MenuPopupListButton;

var bool m_bAutoSelect;
var R6MenuSpeedMenu m_WinSpeed;

function Created ()
{
	Super.Created();
	m_FontForButtons=Root.Fonts[12];
	m_fItemHeight=R6MenuRSLookAndFeel(LookAndFeel).m_BLTitleL.Up.H;
	m_ButtonItem[0]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuModeButtonItem(m_ButtonItem[0]).m_eMode=0;
	m_ButtonItem[0].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[0].m_Button.SetText(Localize("Order","Mode_Assault","R6Menu"));
//	R6MenuPopUpStayDownButton(m_ButtonItem[0].m_Button).m_bSubMenu=True;
	m_ButtonItem[0].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[1]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuModeButtonItem(m_ButtonItem[1]).m_eMode=1;
	m_ButtonItem[1].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[1].m_Button.SetText(Localize("Order","Mode_Infiltrate","R6Menu"));
//	R6MenuPopUpStayDownButton(m_ButtonItem[1].m_Button).m_bSubMenu=True;
	m_ButtonItem[1].m_Button.m_buttonFont=m_FontForButtons;
	m_ButtonItem[2]=R6WindowListButtonItem(Items.Append(ListClass));
//	R6MenuModeButtonItem(m_ButtonItem[2]).m_eMode=2;
	m_ButtonItem[2].m_Button=R6WindowButton(CreateWindow(Class'R6MenuPopUpStayDownButton',0.00,0.00,WinWidth,m_fItemHeight,self));
	m_ButtonItem[2].m_Button.SetText(Localize("Order","Mode_Recon","R6Menu"));
//	R6MenuPopUpStayDownButton(m_ButtonItem[2].m_Button).m_bSubMenu=True;
	m_ButtonItem[2].m_Button.m_buttonFont=m_FontForButtons;
}

function SetSelectedItem (UWindowListBoxItem NewSelected)
{
	local R6PlanningInfo Planning;

	Planning=R6PlanningCtrl(GetPlayerOwner()).m_pTeamInfo[R6PlanningCtrl(GetPlayerOwner()).m_iCurrentTeam];
	HidePopup();
	Super.SetSelectedItem(NewSelected);
	if ( m_bAutoSelect != True )
	{
		Planning.SetMovementMode(R6MenuModeButtonItem(m_SelectedItem).m_eMode);
		ShowPopup();
	}
}

function HidePopup ()
{
	if ( m_WinSpeed != None )
	{
		m_WinSpeed.HideWindow();
	}
}

function ShowWindow ()
{
	local EMovementMode eMode;

	eMode=R6PlanningCtrl(GetPlayerOwner()).GetMovementMode();
	Super.ShowWindow();
	m_bAutoSelect=True;
	if ( m_ButtonItem[eMode] != m_SelectedItem )
	{
		SetSelectedItem(m_ButtonItem[eMode]);
	}
	m_bAutoSelect=False;
}

function ShowPopup ()
{
	local float fGlobalLeft;
	local float fGlobalTop;

	WindowToGlobal(ParentWindow.WinLeft,ParentWindow.WinTop,fGlobalLeft,fGlobalTop);
	fGlobalLeft=ParentWindow.WinLeft + ParentWindow.WinWidth;
	if ( m_WinSpeed == None )
	{
		m_WinSpeed=R6MenuSpeedMenu(R6MenuRootWindow(Root).m_PlanningWidget.CreateWindow(Class'R6MenuSpeedMenu',fGlobalLeft,ParentWindow.WinTop,150.00,100.00,OwnerWindow));
	}
	else
	{
		m_WinSpeed.WinLeft=fGlobalLeft;
		m_WinSpeed.WinTop=ParentWindow.WinTop;
		m_WinSpeed.ShowWindow();
	}
	m_WinSpeed.AjustPosition(R6MenuFramePopup(OwnerWindow).m_bDisplayUp,R6MenuFramePopup(OwnerWindow).m_bDisplayLeft);
	if ( R6MenuFramePopup(ParentWindow).m_bDisplayLeft == True )
	{
		m_WinSpeed.WinLeft -= ParentWindow.WinWidth - 6;
	}
	if ( R6MenuFramePopup(ParentWindow).m_bDisplayUp == True )
	{
		m_WinSpeed.WinTop -= m_WinSpeed.WinHeight - ParentWindow.WinHeight;
	}
}

defaultproperties
{
    m_iNbButton=3
    ListClass=Class'R6MenuModeButtonItem'
}
