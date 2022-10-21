//================================================================================
// R6WindowTabControl.
//================================================================================
class R6WindowTabControl extends UWindowTabControl;

function Created ()
{
	Super.Created();
	m_bNotDisplayBkg=True;
}

function GotoTab (UWindowTabControlItem NewSelected, optional bool bByUser)
{
	local float fGlobalX;
	local float fGlobalY;

	if ( (SelectedTab != NewSelected) && bByUser )
	{
//		LookAndFeel.PlayMenuSound(self,5);
	}
	SelectedTab=NewSelected;
	TabArea.bShowSelected=True;
	Notify(2);
}

function int GetSelectedTabID ()
{
	local UWindowTabControlItem i;

	for (i=UWindowTabControlItem(Items.Next);i != None;i=UWindowTabControlItem(i.Next))
	{
		if ( i == SelectedTab )
		{
			return i.m_iItemID;
		}
	}
	return 0;
}

function ToolTip (string strTip)
{
	ParentWindow.ToolTip(strTip);
}
