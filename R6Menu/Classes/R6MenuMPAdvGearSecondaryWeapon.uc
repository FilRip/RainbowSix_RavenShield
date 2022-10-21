//================================================================================
// R6MenuMPAdvGearSecondaryWeapon.
//================================================================================
class R6MenuMPAdvGearSecondaryWeapon extends R6MenuGearSecondaryWeapon;

var float m_fWeaponWidth;
var float m_fBulletWidth;

function Created ()
{
	m_2DWeapon=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',0.00,0.00,m_fWeaponWidth,WinHeight,self));
	m_2DWeapon.bUseRegion=True;
	m_2DWeapon.m_iDrawStyle=5;
	m_2DBullet=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',m_fWeaponWidth,0.00,m_fBulletWidth,WinHeight,self));
	m_2DBullet.bUseRegion=True;
	m_2DBullet.m_iDrawStyle=5;
	m_2DWeaponGadget=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',m_fWeaponWidth + m_2DBullet.WinWidth,0.00,WinWidth - m_2DBullet.WinWidth - m_2DWeapon.WinWidth,WinHeight,self));
	m_2DWeaponGadget.bUseRegion=True;
	m_2DWeaponGadget.m_iDrawStyle=5;
	m_BorderColor=Root.Colors.GrayLight;
	m_InsideLinesColor=Root.Colors.GrayLight;
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
	C.Style=5;
	C.SetDrawColor(m_InsideLinesColor.R,m_InsideLinesColor.G,m_InsideLinesColor.B);
	DrawStretchedTextureSegment(C,m_2DWeapon.WinWidth,0.00,m_LinesRegion.W,WinHeight,m_LinesRegion.X,m_LinesRegion.Y,m_LinesRegion.W,m_LinesRegion.H,m_LinesTexture);
	DrawStretchedTextureSegment(C,m_2DBullet.WinLeft + m_2DBullet.WinWidth,0.00,m_LinesRegion.W,WinHeight,m_LinesRegion.X,m_LinesRegion.Y,m_LinesRegion.W,m_LinesRegion.H,m_LinesTexture);
}

function SetBorderColor (Color _NewColor)
{
	m_BorderColor=_NewColor;
}

defaultproperties
{
    m_fWeaponWidth=86.00
    m_fBulletWidth=73.00
    m_bAssignAllButton=False
    m_bCenterTexture=True
}