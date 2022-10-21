//================================================================================
// R6MenuMPManageTab.
//================================================================================
class R6MenuMPManageTab extends UWindowDialogClientWindow;

var R6WindowTabControl m_pMainTabControl;

function Created ()
{
	m_pMainTabControl=R6WindowTabControl(CreateControl(Class'R6WindowTabControl',0.00,0.00,WinWidth,WinHeight));
	m_pMainTabControl.SetFont(7);
	LookAndFeel.Size_TabXOffset=0.00;
	LookAndFeel.Size_TabAreaHeight=WinHeight - LookAndFeel.Size_TabAreaOverhangHeight;
}

function AddTabInControl (string _Caption, string _TabToolTip, int _ItemID)
{
	local UWindowTabControlItem pItem;

	if ( m_pMainTabControl != None )
	{
		pItem=m_pMainTabControl.AddTab(_Caption,_ItemID);
		pItem.HelpText=_TabToolTip;
		pItem.SetItemColor(Root.Colors.White,Root.Colors.GrayLight);
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	local R6LanServers pLanServers;
	local R6GSServers pGameService;

	if ( E == 2 )
	{
		if ( R6MenuMultiPlayerWidget(OwnerWindow) != None )
		{
			R6MenuMultiPlayerWidget(OwnerWindow).ManageTabSelection(m_pMainTabControl.GetSelectedTabID());
		}
		else
		{
			R6MenuMPCreateGameWidget(OwnerWindow).ManageTabSelection(m_pMainTabControl.GetSelectedTabID());
		}
	}
	if ( (E == 6) && C.IsA('R6WindowServerListBox') )
	{
		if ( R6MenuMultiPlayerWidget(OwnerWindow) != None )
		{
			R6MenuMultiPlayerWidget(OwnerWindow).DisplayRightClickMenu();
		}
	}
	if ( (E == 11) && C.IsA('R6WindowServerListBox') )
	{
		R6MenuMultiPlayerWidget(OwnerWindow).JoinSelectedServerRequested();
	}
	if ( (E == 3) && C.IsA('R6WindowRightClickMenu') )
	{
		if ( R6MenuMultiPlayerWidget(OwnerWindow) != None )
		{
			R6MenuMultiPlayerWidget(OwnerWindow).UpdateFavorites();
		}
	}
}