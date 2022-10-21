//================================================================================
// R6MenuSpeedMenu.
//================================================================================
class R6MenuSpeedMenu extends R6MenuFramePopup;

function Created ()
{
	Super.Created();
	m_szWindowTitle=Localize("Order","Speed","R6Menu");
	m_ButtonList=R6MenuListSpeedButton(CreateWindow(Class'R6MenuListSpeedButton',m_iFrameWidth,m_fTitleBarHeight,100.00,100.00,self));
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
    m_iNbButton=3
}