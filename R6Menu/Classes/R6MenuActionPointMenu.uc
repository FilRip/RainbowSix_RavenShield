//================================================================================
// R6MenuActionPointMenu.
//================================================================================
class R6MenuActionPointMenu extends R6MenuFramePopup;

function Created ()
{
	Super.Created();
	m_szWindowTitle=Localize("Order","Type","R6Menu");
	m_ButtonList=R6MenuListActionTypeButton(CreateWindow(Class'R6MenuListActionTypeButton',m_iFrameWidth,m_fTitleBarHeight,100.00,100.00,self));
}

function HideWindow ()
{
	Super.HideWindow();
	R6MenuListActionTypeButton(m_ButtonList).HidePopup();
}

defaultproperties
{
    m_iNbButton=6
}