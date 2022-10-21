//================================================================================
// R6MenuMPAdvGearPrimaryWeapon.
//================================================================================
class R6MenuMPAdvGearPrimaryWeapon extends R6MenuGearPrimaryWeapon;

function Created ()
{
	m_2DWeapon=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',0.00,0.00,m_2DWeaponWidth,WinHeight,self));
	m_2DWeapon.bUseRegion=True;
	m_2DWeapon.m_iDrawStyle=5;
	m_2DBullet=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',m_2DWeaponWidth,0.00,WinWidth - m_2DWeaponWidth,WinHeight / 2,self));
	m_2DBullet.bUseRegion=True;
	m_2DBullet.m_iDrawStyle=5;
	m_2DWeaponGadget=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',m_2DWeaponWidth,m_2DBullet.WinTop + m_2DBullet.WinHeight,m_2DBullet.WinWidth,WinHeight / 2,self));
	m_2DWeaponGadget.bUseRegion=True;
	m_2DWeaponGadget.m_iDrawStyle=5;
	m_BorderColor=Root.Colors.GrayLight;
	m_InsideLinesColor=Root.Colors.GrayLight;
}

function SetBorderColor (Color _NewColor)
{
	m_BorderColor=_NewColor;
}

defaultproperties
{
    m_bAssignAllButton=False
    m_bCenterTexture=True
}