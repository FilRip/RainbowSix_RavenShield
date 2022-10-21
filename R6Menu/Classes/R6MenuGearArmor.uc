//================================================================================
// R6MenuGearArmor.
//================================================================================
class R6MenuGearArmor extends UWindowDialogControl;

var R6WindowButtonGear m_2DArmor;
var R6MenuAssignAllButton m_AssignAll;

function Created ()
{
	m_BorderColor=Root.Colors.GrayLight;
	m_AssignAll=R6MenuAssignAllButton(CreateWindow(Class'R6MenuAssignAllButton',WinWidth - Class'R6MenuAssignAllButton'.Default.UpRegion.W - 1,0.00,Class'R6MenuAssignAllButton'.Default.UpRegion.W,WinHeight,self));
	m_AssignAll.ToolTipString=Localize("Tip","GearRoomArmorAll","R6Menu");
	m_AssignAll.ImageX=0.00;
	m_AssignAll.ImageY=(WinHeight - Class'R6MenuAssignAllButton'.Default.UpRegion.H) / 2;
	m_2DArmor=R6WindowButtonGear(CreateWindow(Class'R6WindowButtonGear',0.00,0.00,WinWidth - m_AssignAll.WinWidth,WinHeight,self));
	m_2DArmor.ToolTipString=Localize("Tip","GearRoomArmor","R6Menu");
	m_2DArmor.bUseRegion=True;
	m_2DArmor.m_iDrawStyle=5;
}

function Register (UWindowDialogClientWindow W)
{
	Super.Register(W);
	m_AssignAll.Register(W);
	m_2DArmor.Register(W);
}

function SetArmorTexture (Texture t, Region R)
{
	m_2DArmor.DisabledTexture=t;
	m_2DArmor.DisabledRegion=R;
	m_2DArmor.DownTexture=t;
	m_2DArmor.DownRegion=R;
	m_2DArmor.OverTexture=t;
	m_2DArmor.OverRegion=R;
	m_2DArmor.UpTexture=t;
	m_2DArmor.UpRegion=R;
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
}

function SetButtonsStatus (bool _bDisable)
{
	m_AssignAll.SetButtonStatus(_bDisable);
	m_2DArmor.bDisabled=_bDisable;
}

function SetBorderColor (Color _NewColor)
{
	m_AssignAll.SetBorderColor(_NewColor);
	m_BorderColor=_NewColor;
}

function ForceMouseOver (bool _bForceMouseOver)
{
	m_2DArmor.ForceMouseOver(_bForceMouseOver);
}