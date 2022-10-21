//================================================================================
// R6MenuModeMenu.
//================================================================================
class R6MenuModeMenu extends R6MenuFramePopup;

function Created ()
{
	Super.Created();
	m_szWindowTitle=Localize("Order","Mode","R6Menu");
	m_ButtonList=R6MenuListModeButton(CreateWindow(Class'R6MenuListModeButton',m_iFrameWidth,m_fTitleBarHeight,100.00,100.00,self));
}

function HideWindow ()
{
	Super.HideWindow();
	R6MenuListModeButton(m_ButtonList).HidePopup();
}

defaultproperties
{
    m_iNbButton=3
}