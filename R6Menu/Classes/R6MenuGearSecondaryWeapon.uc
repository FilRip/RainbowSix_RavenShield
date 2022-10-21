//================================================================================
// R6MenuGearSecondaryWeapon.
//================================================================================
class R6MenuGearSecondaryWeapon extends UWindowDialogControl;

var bool m_bAssignAllButton;
var bool m_bCenterTexture;
var float m_2DWeaponWidth;
var float m_2DWeaponHeight;
var float m_2DBulletHeight;
var R6MenuAssignAllButton m_AssignAll;
var R6WindowButtonGear m_2DWeapon;
var R6WindowButtonGear m_2DBullet;
var R6WindowButtonGear m_2DWeaponGadget;
var Texture m_LinesTexture;
var Region m_LinesRegion;
var Color m_InsideLinesColor;

function Created ()
{
	local float m_2DWeaponGadgetHeight;

	m_InsideLinesColor=Root.Colors.GrayLight;
	m_BorderColor=Root.Colors.GrayLight;
	if ( m_bAssignAllButton == True )
	{
		m_AssignAll=R6MenuAssignAllButton(CreateWindow(Class'R6MenuAssignAllButton',WinWidth - Class'R6MenuAssignAllButton'.Default.UpRegion.W - 1,0.00,Class'R6MenuAssignAllButton'.Default.UpRegion.W,WinHeight,self));
		m_AssignAll.ToolTipString=Localize("Tip","GearRoomAssign","R6Menu");
		m_AssignAll.ImageX=0.00;
		m_AssignAll.ImageY=(WinHeight - Class'R6MenuAssignAllButton'.Default.UpRegion.H) / 2;
	}
	m_2DWeapon=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',0.00,0.00,m_2DWeaponWidth,m_2DWeaponHeight,self));
	m_2DWeapon.ToolTipString=Localize("Tip","GearRoomSecWeapon","R6Menu");
	m_2DWeapon.bUseRegion=True;
	m_2DWeapon.m_iDrawStyle=5;
	m_2DBullet=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',0.00,m_2DWeapon.WinTop + m_2DWeapon.WinHeight,m_2DWeaponWidth,m_2DBulletHeight,self));
	m_2DBullet.ToolTipString=Localize("Tip","GearRoomAmmo","R6Menu");
	m_2DBullet.bUseRegion=True;
	m_2DBullet.m_iDrawStyle=5;
	m_2DWeaponGadgetHeight=WinHeight - m_2DWeapon.WinHeight - m_2DBullet.WinHeight;
	m_2DWeaponGadget=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',0.00,m_2DBullet.WinTop + m_2DBullet.WinHeight,m_2DWeaponWidth,m_2DWeaponGadgetHeight,self));
	m_2DWeaponGadget.ToolTipString=Localize("Tip","GearRoomAttach","R6Menu");
	m_2DWeaponGadget.bUseRegion=True;
	m_2DWeaponGadget.m_iDrawStyle=5;
}

function Register (UWindowDialogClientWindow W)
{
	Super.Register(W);
	if ( m_bAssignAllButton == True )
	{
		m_AssignAll.Register(W);
	}
	m_2DWeapon.Register(W);
	m_2DBullet.Register(W);
	m_2DWeaponGadget.Register(W);
}

function SetWeaponTexture (Texture t, Region R)
{
	m_2DWeapon.DisabledTexture=t;
	m_2DWeapon.DisabledRegion=R;
	m_2DWeapon.DownTexture=t;
	m_2DWeapon.DownRegion=R;
	m_2DWeapon.OverTexture=t;
	m_2DWeapon.OverRegion=R;
	m_2DWeapon.UpTexture=t;
	m_2DWeapon.UpRegion=R;
	if ( m_bCenterTexture )
	{
		m_2DWeapon.ImageX=(m_2DWeapon.WinWidth - m_2DWeapon.UpRegion.W) / 2;
		m_2DWeapon.ImageY=(m_2DWeapon.WinHeight - m_2DWeapon.UpRegion.H) / 2;
	}
}

function SetWeaponGadgetTexture (Texture t, Region R)
{
	m_2DWeaponGadget.DisabledTexture=t;
	m_2DWeaponGadget.DisabledRegion=R;
	m_2DWeaponGadget.DownTexture=t;
	m_2DWeaponGadget.DownRegion=R;
	m_2DWeaponGadget.OverTexture=t;
	m_2DWeaponGadget.OverRegion=R;
	m_2DWeaponGadget.UpTexture=t;
	m_2DWeaponGadget.UpRegion=R;
	if ( m_bCenterTexture )
	{
		m_2DWeaponGadget.ImageX=(m_2DWeaponGadget.WinWidth - m_2DWeaponGadget.UpRegion.W) / 2;
		m_2DWeaponGadget.ImageY=(m_2DWeaponGadget.WinHeight - m_2DWeaponGadget.UpRegion.H) / 2;
	}
}

function SetBulletTexture (Texture t, Region R)
{
	m_2DBullet.DisabledTexture=t;
	m_2DBullet.DisabledRegion=R;
	m_2DBullet.DownTexture=t;
	m_2DBullet.DownRegion=R;
	m_2DBullet.OverTexture=t;
	m_2DBullet.OverRegion=R;
	m_2DBullet.UpTexture=t;
	m_2DBullet.UpRegion=R;
	if ( m_bCenterTexture )
	{
		m_2DBullet.ImageX=(m_2DBullet.WinWidth - m_2DBullet.UpRegion.W) / 2;
		m_2DBullet.ImageY=(m_2DBullet.WinHeight - m_2DBullet.UpRegion.H) / 2;
	}
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=5;
	C.SetDrawColor(m_InsideLinesColor.R,m_InsideLinesColor.G,m_InsideLinesColor.B);
	DrawStretchedTextureSegment(C,0.00,m_2DBullet.WinTop,m_2DWeaponWidth,m_LinesRegion.H,m_LinesRegion.X,m_LinesRegion.Y,m_LinesRegion.W,m_LinesRegion.H,m_LinesTexture);
	DrawStretchedTextureSegment(C,0.00,m_2DWeaponGadget.WinTop,m_2DWeaponWidth,m_LinesRegion.H,m_LinesRegion.X,m_LinesRegion.Y,m_LinesRegion.W,m_LinesRegion.H,m_LinesTexture);
	DrawSimpleBorder(C);
}

function SetButtonsStatus (bool _bDisable)
{
	m_AssignAll.SetButtonStatus(_bDisable);
	m_2DWeapon.bDisabled=_bDisable;
	m_2DBullet.bDisabled=_bDisable;
	m_2DWeaponGadget.bDisabled=_bDisable;
}

function SetBorderColor (Color _NewColor)
{
	m_AssignAll.SetBorderColor(_NewColor);
	m_BorderColor=_NewColor;
}

function ForceMouseOver (bool _bForceMouseOver)
{
	m_2DWeapon.ForceMouseOver(_bForceMouseOver);
	m_2DBullet.ForceMouseOver(_bForceMouseOver);
	m_2DWeaponGadget.ForceMouseOver(_bForceMouseOver);
}

defaultproperties
{
    m_bAssignAllButton=True
    m_2DWeaponWidth=66.00
    m_2DWeaponHeight=54.00
    m_2DBulletHeight=35.00
    m_LinesRegion=(X=4203014,Y=570753024,W=59,H=74244)
}
/*
    m_LinesTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

