//================================================================================
// R6MenuActionMenu.
//================================================================================
class R6MenuActionMenu extends R6MenuFramePopup;

function Created ()
{
	Super.Created();
	m_szWindowTitle=Localize("Order","Action","R6Menu");
	m_ButtonList=R6MenuListActionButton(CreateWindow(Class'R6MenuListActionButton',1.00,m_fTitleBarHeight,100.00,100.00,self));
}

function AjustPosition (bool bDisplayUp, bool bDisplayLeft)
{
	m_bDisplayUp=bDisplayUp;
	m_bDisplayLeft=bDisplayLeft;
	if ( m_bDisplayLeft == True )
	{
		WinLeft -= WinWidth + 6;
	}
}

defaultproperties
{
    m_iNbButton=7
}