//================================================================================
// R6MenuGearGadget.
//================================================================================
class R6MenuGearGadget extends UWindowDialogControl;

var bool m_bAssignAllButton;
var bool m_bCenterTexture;
var float m_2DGadgetWidth;
var R6MenuAssignAllButton m_AssignAll;
var R6WindowButtonGear m_2DGadget;

function Created ()
{
	m_BorderColor=Root.Colors.GrayLight;
	if ( m_bAssignAllButton == True )
	{
		m_AssignAll=R6MenuAssignAllButton(CreateWindow(Class'R6MenuAssignAllButton',WinWidth - Class'R6MenuAssignAllButton'.Default.UpRegion.W - 1,0.00,Class'R6MenuAssignAllButton'.Default.UpRegion.W,WinHeight,self));
		m_AssignAll.ToolTipString=Localize("Tip","GearRoomItemAll","R6Menu");
		m_AssignAll.ImageX=0.00;
		m_AssignAll.ImageY=(WinHeight - Class'R6MenuAssignAllButton'.Default.UpRegion.H) / 2;
	}
	m_2DGadget=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',0.00,0.00,m_2DGadgetWidth,WinHeight,self));
	m_2DGadget.ToolTipString=Localize("Tip","GearRoomItem","R6Menu");
	m_2DGadget.bUseRegion=True;
	m_2DGadget.m_iDrawStyle=5;
}

function Register (UWindowDialogClientWindow W)
{
	Super.Register(W);
	if ( m_bAssignAllButton == True )
	{
		m_AssignAll.Register(W);
	}
	m_2DGadget.Register(W);
}

function SetGadgetTexture (Texture t, Region R)
{
	m_2DGadget.DisabledTexture=t;
	m_2DGadget.DisabledRegion=R;
	m_2DGadget.DownTexture=t;
	m_2DGadget.DownRegion=R;
	m_2DGadget.OverTexture=t;
	m_2DGadget.OverRegion=R;
	m_2DGadget.UpTexture=t;
	m_2DGadget.UpRegion=R;
	if ( m_bCenterTexture )
	{
		m_2DGadget.ImageX=(m_2DGadget.WinWidth - m_2DGadget.UpRegion.W) / 2;
		m_2DGadget.ImageY=(m_2DGadget.WinHeight - m_2DGadget.UpRegion.H) / 2;
	}
	else
	{
		m_2DGadget.ImageX=m_2DGadget.Default.ImageX;
		m_2DGadget.ImageY=m_2DGadget.Default.ImageY;
	}
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}

function SetButtonsStatus (bool _bDisable)
{
	m_AssignAll.SetButtonStatus(_bDisable);
	m_2DGadget.bDisabled=_bDisable;
}

function SetBorderColor (Color _NewColor)
{
	m_AssignAll.SetBorderColor(_NewColor);
	m_BorderColor=_NewColor;
}

function ForceMouseOver (bool _bForceMouseOver)
{
	m_2DGadget.ForceMouseOver(_bForceMouseOver);
}

defaultproperties
{
    m_bAssignAllButton=True
    m_2DGadgetWidth=66.00
}