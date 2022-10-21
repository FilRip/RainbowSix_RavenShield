//================================================================================
// R6MenuEquipmentSelectControl.
//================================================================================
class R6MenuEquipmentSelectControl extends UWindowDialogClientWindow;

var bool m_bDisableControls;
var bool bShowLog;
var float m_fArmorWindowWidth;
var float m_fPrimaryWindowHeight;
var float m_fSecondaryWindowHeight;
var float m_fPrimaryGadgetWindowHeight;
var R6MenuGearPrimaryWeapon m_2DWeaponPrimary;
var R6MenuGearSecondaryWeapon m_2DWeaponSecondary;
var R6MenuGearGadget m_2DGadgetPrimary;
var R6MenuGearGadget m_2DGadgetSecondary;
var R6MenuGearArmor m_2DArmor;
var R6MenuAssignAllButton m_AssignAllToAllButton;
var Texture m_TAssignAllToAllButton;
var R6WindowButtonGear m_HighlightedButton;
var Region m_RAssignAllToAllUp;
var Region m_RAssignAllToAllOver;
var Region m_RAssignAllToAllDown;
var Region m_RAssignAllToAllDisable;
var Color m_DisableColor;
var Color m_EnableColor;

function Created ()
{
	m_DisableColor=Root.Colors.GrayLight;
	m_EnableColor=Root.Colors.White;
	m_2DWeaponPrimary=R6MenuGearPrimaryWeapon(CreateControl(Class'R6MenuGearPrimaryWeapon',0.00,0.00,WinWidth,m_fPrimaryWindowHeight,self));
	m_2DWeaponSecondary=R6MenuGearSecondaryWeapon(CreateControl(Class'R6MenuGearSecondaryWeapon',m_fArmorWindowWidth - 1,m_fPrimaryWindowHeight - 1,WinWidth - m_fArmorWindowWidth + 1,m_fSecondaryWindowHeight,self));
	m_2DGadgetPrimary=R6MenuGearGadget(CreateControl(Class'R6MenuGearGadget',m_fArmorWindowWidth - 1,m_2DWeaponSecondary.WinTop + m_2DWeaponSecondary.WinHeight - 1,m_2DWeaponSecondary.WinWidth,m_fPrimaryGadgetWindowHeight,self));
	m_2DGadgetSecondary=R6MenuGearGadget(CreateControl(Class'R6MenuGearGadget',m_fArmorWindowWidth - 1,m_2DGadgetPrimary.WinTop + m_2DGadgetPrimary.WinHeight - 1,m_2DWeaponSecondary.WinWidth,m_fPrimaryGadgetWindowHeight,self));
	m_2DArmor=R6MenuGearArmor(CreateControl(Class'R6MenuGearArmor',0.00,m_2DWeaponPrimary.WinHeight - 1,m_fArmorWindowWidth,247.00,self));
	m_AssignAllToAllButton=R6MenuAssignAllButton(CreateControl(Class'R6MenuAssignAllButton',0.00,WinHeight - 12,WinWidth,12.00,self));
	m_AssignAllToAllButton.bAlwaysOnTop=True;
	m_AssignAllToAllButton.ToolTipString=Localize("GearRoom","AssignAllToAll","R6Menu");
	m_AssignAllToAllButton.m_iDrawStyle=5;
	m_AssignAllToAllButton.SetCompleteAssignAllButton();
}

function DisableControls (bool _Disable)
{
	m_AssignAllToAllButton.SetButtonStatus(_Disable);
	m_2DWeaponPrimary.SetButtonsStatus(_Disable);
	m_2DWeaponSecondary.SetButtonsStatus(_Disable);
	m_2DGadgetPrimary.SetButtonsStatus(_Disable);
	m_2DGadgetSecondary.SetButtonsStatus(_Disable);
	m_2DArmor.SetButtonsStatus(_Disable);
	m_bDisableControls=_Disable;
	if ( (_Disable == True) && (m_HighlightedButton != None) )
	{
		m_HighlightedButton.m_HighLight=False;
		m_HighlightedButton.OwnerWindow.SetBorderColor(m_DisableColor);
		m_HighlightedButton=None;
	}
}

function setHighLight (R6WindowButtonGear newButton)
{
	if ( m_HighlightedButton != None )
	{
		m_HighlightedButton.m_HighLight=False;
		m_HighlightedButton.OwnerWindow.SetBorderColor(m_DisableColor);
	}
	if ( newButton != None )
	{
		m_HighlightedButton=newButton;
		m_HighlightedButton.m_HighLight=True;
		m_HighlightedButton.OwnerWindow.SetBorderColor(m_EnableColor);
		m_HighlightedButton.OwnerWindow.BringToFront();
	}
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( m_bDisableControls )
	{
		return;
	}
	if ( E == 12 )
	{
		switch (C.OwnerWindow)
		{
			case self:
			if ( C == m_AssignAllToAllButton )
			{
				m_2DWeaponPrimary.ForceMouseOver(True);
				m_2DWeaponSecondary.ForceMouseOver(True);
				m_2DGadgetPrimary.ForceMouseOver(True);
				m_2DGadgetSecondary.ForceMouseOver(True);
				m_2DArmor.ForceMouseOver(True);
			}
			break;
			case m_2DWeaponPrimary:
			m_2DWeaponPrimary.ForceMouseOver(C == m_2DWeaponPrimary.m_AssignAll);
			break;
			case m_2DWeaponSecondary:
			m_2DWeaponSecondary.ForceMouseOver(C == m_2DWeaponSecondary.m_AssignAll);
			break;
			case m_2DGadgetPrimary:
			m_2DGadgetPrimary.ForceMouseOver(C == m_2DGadgetPrimary.m_AssignAll);
			break;
			case m_2DGadgetSecondary:
			m_2DGadgetSecondary.ForceMouseOver(C == m_2DGadgetSecondary.m_AssignAll);
			break;
			case m_2DArmor:
			m_2DArmor.ForceMouseOver(C == m_2DArmor.m_AssignAll);
			break;
			default:
		}
	}
	else
	{
		if ( E == 9 )
		{
			m_2DWeaponPrimary.ForceMouseOver(False);
			m_2DWeaponSecondary.ForceMouseOver(False);
			m_2DGadgetPrimary.ForceMouseOver(False);
			m_2DGadgetSecondary.ForceMouseOver(False);
			m_2DArmor.ForceMouseOver(False);
		}
		else
		{
			if ( E == 2 )
			{
				switch (C)
				{
/*					case m_AssignAllToAllButton:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(14);
					break;
					case m_2DWeaponPrimary.m_AssignAll:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(9);
					break;
					case m_2DWeaponPrimary.m_2DWeapon:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(0);
					setHighLight(m_2DWeaponPrimary.m_2DWeapon);
					break;
					case m_2DWeaponPrimary.m_2DBullet:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(2);
					setHighLight(m_2DWeaponPrimary.m_2DBullet);
					break;
					case m_2DWeaponPrimary.m_2DWeaponGadget:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(1);
					setHighLight(m_2DWeaponPrimary.m_2DWeaponGadget);
					break;
					case m_2DWeaponSecondary.m_AssignAll:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(10);
					break;
					case m_2DWeaponSecondary.m_2DWeapon:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(4);
					setHighLight(m_2DWeaponSecondary.m_2DWeapon);
					break;
					case m_2DWeaponSecondary.m_2DBullet:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(6);
					setHighLight(m_2DWeaponSecondary.m_2DBullet);
					break;
					case m_2DWeaponSecondary.m_2DWeaponGadget:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(5);
					setHighLight(m_2DWeaponSecondary.m_2DWeaponGadget);
					break;
					case m_2DGadgetPrimary.m_AssignAll:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(11);
					break;
					case m_2DGadgetPrimary.m_2DGadget:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(3);
					setHighLight(m_2DGadgetPrimary.m_2DGadget);
					break;
					case m_2DGadgetSecondary.m_AssignAll:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(12);
					break;
					case m_2DGadgetSecondary.m_2DGadget:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(7);
					setHighLight(m_2DGadgetSecondary.m_2DGadget);
					break;
					case m_2DArmor.m_AssignAll:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(13);
					break;
					case m_2DArmor.m_2DArmor:
					R6MenuGearWidget(OwnerWindow).EquipmentSelected(8);
					setHighLight(m_2DArmor.m_2DArmor);
					break;
					default:  */
				}
			}
		}
	}
}

function Class<R6PrimaryWeaponDescription> GetCurrentPrimaryWeapon ()
{
	return R6MenuGearWidget(OwnerWindow).m_OpFirstWeaponDesc;
}

function Class<R6SecondaryWeaponDescription> GetCurrentSecondaryWeapon ()
{
	return R6MenuGearWidget(OwnerWindow).m_OpSecondaryWeaponDesc;
}

function Class<R6WeaponGadgetDescription> GetCurrentWeaponGadget (bool _Primary)
{
	if ( _Primary == True )
	{
		return R6MenuGearWidget(OwnerWindow).m_OpFirstWeaponGadgetDesc;
	}
	else
	{
		return R6MenuGearWidget(OwnerWindow).m_OpSecondWeaponGadgetDesc;
	}
}

function Class<R6BulletDescription> GetCurrentWeaponBullet (bool _Primary)
{
	if ( _Primary == True )
	{
		return R6MenuGearWidget(OwnerWindow).m_OpFirstWeaponBulletDesc;
	}
	else
	{
		return R6MenuGearWidget(OwnerWindow).m_OpSecondWeaponBulletDesc;
	}
}

function TexRegion GetCurrentGadgetTex (bool _Primary)
{
	if ( _Primary == True )
	{
		return R6MenuGearWidget(OwnerWindow).GetGadgetTexture(R6MenuGearWidget(OwnerWindow).m_OpFirstGadgetDesc);
	}
	else
	{
		return R6MenuGearWidget(OwnerWindow).GetGadgetTexture(R6MenuGearWidget(OwnerWindow).m_OpSecondGadgetDesc);
	}
}

function bool CenterGadgetTexture (bool _Primary)
{
	local bool Result;
	local R6MenuGearWidget GearRoom;

	GearRoom=R6MenuGearWidget(OwnerWindow);
	if ( _Primary == True )
	{
		if ( Class'R6DescPrimaryMags' == GearRoom.m_OpFirstGadgetDesc )
		{
			if ( GearRoom.m_OpFirstWeaponGadgetDesc.Default.m_NameTag == "CMAG" )
			{
				Result=True;
			}
		}
	}
	else
	{
		if ( Class'R6DescSecondaryMags' == GearRoom.m_OpSecondGadgetDesc )
		{
			if ( GearRoom.m_OpSecondWeaponGadgetDesc.Default.m_NameTag == "CMAG" )
			{
				Result=True;
			}
		}
	}
	return Result;
}

function Class<R6ArmorDescription> GetCurrentArmor ()
{
	return R6MenuGearWidget(OwnerWindow).m_OpArmorDesc;
}

function UpdateDetails ()
{
	local TexRegion TR;

	m_2DWeaponPrimary.SetWeaponTexture(GetCurrentPrimaryWeapon().Default.m_2DMenuTexture,GetCurrentPrimaryWeapon().Default.m_2dMenuRegion);
	m_2DWeaponPrimary.SetWeaponGadgetTexture(GetCurrentWeaponGadget(True).Default.m_2DMenuTexture,GetCurrentWeaponGadget(True).Default.m_2dMenuRegion);
	m_2DWeaponPrimary.SetBulletTexture(GetCurrentWeaponBullet(True).Default.m_2DMenuTexture,GetCurrentWeaponBullet(True).Default.m_2dMenuRegion);
	m_2DWeaponSecondary.SetWeaponTexture(GetCurrentSecondaryWeapon().Default.m_2DMenuTexture,GetCurrentSecondaryWeapon().Default.m_2dMenuRegion);
	m_2DWeaponSecondary.SetWeaponGadgetTexture(GetCurrentWeaponGadget(False).Default.m_2DMenuTexture,GetCurrentWeaponGadget(False).Default.m_2dMenuRegion);
	m_2DWeaponSecondary.SetBulletTexture(GetCurrentWeaponBullet(False).Default.m_2DMenuTexture,GetCurrentWeaponBullet(False).Default.m_2dMenuRegion);
	TR=GetCurrentGadgetTex(True);
	m_2DGadgetPrimary.m_bCenterTexture=CenterGadgetTexture(True);
	m_2DGadgetPrimary.SetGadgetTexture(TR.t,GetRegion(TR));
	TR=GetCurrentGadgetTex(False);
	m_2DGadgetPrimary.m_bCenterTexture=CenterGadgetTexture(False);
	m_2DGadgetSecondary.SetGadgetTexture(TR.t,GetRegion(TR));
	if ( m_2DArmor != None )
	{
		m_2DArmor.SetArmorTexture(GetCurrentArmor().Default.m_2DMenuTexture,GetCurrentArmor().Default.m_2dMenuRegion);
	}
}

defaultproperties
{
    m_fArmorWindowWidth=131.00
    m_fPrimaryWindowHeight=79.00
    m_fSecondaryWindowHeight=133.00
    m_fPrimaryGadgetWindowHeight=58.00
}
