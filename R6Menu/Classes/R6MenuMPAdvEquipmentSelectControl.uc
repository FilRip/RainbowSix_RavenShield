//================================================================================
// R6MenuMPAdvEquipmentSelectControl.
//================================================================================
class R6MenuMPAdvEquipmentSelectControl extends R6MenuEquipmentSelectControl;

var bool bShowLog;
var float m_fPrimaryGadgetWindowWidth;

function Created ()
{
	m_DisableColor=Root.Colors.GrayLight;
	m_EnableColor=Root.Colors.White;
	m_2DWeaponPrimary=R6MenuMPAdvGearPrimaryWeapon(CreateControl(Class'R6MenuMPAdvGearPrimaryWeapon',0.00,0.00,WinWidth,m_fPrimaryWindowHeight,self));
	m_2DWeaponSecondary=R6MenuMPAdvGearSecondaryWeapon(CreateControl(Class'R6MenuMPAdvGearSecondaryWeapon',0.00,m_fPrimaryWindowHeight - 1,WinWidth,m_fSecondaryWindowHeight + 1,self));
	m_2DGadgetPrimary=R6MenuMPAdvGearGadget(CreateControl(Class'R6MenuMPAdvGearGadget',0.00,m_fPrimaryWindowHeight + m_fSecondaryWindowHeight - 1,WinWidth / 2,WinHeight - m_fPrimaryWindowHeight - m_fSecondaryWindowHeight + 1,self));
	m_2DGadgetSecondary=R6MenuMPAdvGearGadget(CreateControl(Class'R6MenuMPAdvGearGadget',m_2DGadgetPrimary.WinLeft + m_2DGadgetPrimary.WinWidth - 1,m_2DGadgetPrimary.WinTop,WinWidth - m_2DGadgetPrimary.WinLeft - m_2DGadgetPrimary.WinWidth + 1,m_2DGadgetPrimary.WinHeight,self));
}

function Init ()
{
//	R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(0);
	setHighLight(m_2DWeaponPrimary.m_2DWeapon);
}

function Class<R6PrimaryWeaponDescription> GetCurrentPrimaryWeapon ()
{
	return R6MenuMPAdvGearWidget(OwnerWindow).m_OpFirstWeaponDesc;
}

function Class<R6SecondaryWeaponDescription> GetCurrentSecondaryWeapon ()
{
	return R6MenuMPAdvGearWidget(OwnerWindow).m_OpSecondaryWeaponDesc;
}

function Class<R6WeaponGadgetDescription> GetCurrentWeaponGadget (bool _Primary)
{
	if ( _Primary == True )
	{
		return R6MenuMPAdvGearWidget(OwnerWindow).m_OpFirstWeaponGadgetDesc;
	}
	else
	{
		return R6MenuMPAdvGearWidget(OwnerWindow).m_OpSecondWeaponGadgetDesc;
	}
}

function Class<R6BulletDescription> GetCurrentWeaponBullet (bool _Primary)
{
	if ( _Primary == True )
	{
		return R6MenuMPAdvGearWidget(OwnerWindow).m_OpFirstWeaponBulletDesc;
	}
	else
	{
		return R6MenuMPAdvGearWidget(OwnerWindow).m_OpSecondWeaponBulletDesc;
	}
}

function TexRegion GetCurrentGadgetTex (bool _Primary)
{
	if ( _Primary == True )
	{
		return R6MenuMPAdvGearWidget(OwnerWindow).GetGadgetTexture(R6MenuMPAdvGearWidget(OwnerWindow).m_OpFirstGadgetDesc);
	}
	else
	{
		return R6MenuMPAdvGearWidget(OwnerWindow).GetGadgetTexture(R6MenuMPAdvGearWidget(OwnerWindow).m_OpSecondGadgetDesc);
	}
}

function bool CenterGadgetTexture (bool _Primary)
{
	return True;
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( E == 2 )
	{
		switch (C)
		{
/*			case m_2DWeaponPrimary.m_2DWeapon:
			if ( bShowLog )
			{
				Log("m_2DWeaponPrimary.m_2DWeapon");
			}
			R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(0);
			setHighLight(m_2DWeaponPrimary.m_2DWeapon);
			break;
			case m_2DWeaponPrimary.m_2DBullet:
			if ( bShowLog )
			{
				Log("m_2DWeaponPrimary.m_2DBullet");
			}
			R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(2);
			setHighLight(m_2DWeaponPrimary.m_2DBullet);
			break;
			case m_2DWeaponPrimary.m_2DWeaponGadget:
			if ( bShowLog )
			{
				Log("m_2DWeaponPrimary.m_2DWeaponGadget");
			}
			R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(1);
			setHighLight(m_2DWeaponPrimary.m_2DWeaponGadget);
			break;
			case m_2DWeaponSecondary.m_2DWeapon:
			if ( bShowLog )
			{
				Log("m_2DWeaponSecondary.m_2DWeapon");
			}
			R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(4);
			setHighLight(m_2DWeaponSecondary.m_2DWeapon);
			break;
			case m_2DWeaponSecondary.m_2DBullet:
			if ( bShowLog )
			{
				Log("m_2DWeaponSecondary.m_2DBullet");
			}
			R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(6);
			setHighLight(m_2DWeaponSecondary.m_2DBullet);
			break;
			case m_2DWeaponSecondary.m_2DWeaponGadget:
			if ( bShowLog )
			{
				Log("m_2DWeaponSecondary.m_2DWeaponGadget");
			}
			R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(5);
			setHighLight(m_2DWeaponSecondary.m_2DWeaponGadget);
			break;
			case m_2DGadgetPrimary.m_2DGadget:
			if ( bShowLog )
			{
				Log("m_2DGadgetPrimary.m_2DGadget");
			}
			R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(3);
			setHighLight(m_2DGadgetPrimary.m_2DGadget);
			break;
			case m_2DGadgetSecondary.m_2DGadget:
			if ( bShowLog )
			{
				Log("m_2DGadgetSecondary.m_2DGadget");
			}
			R6MenuMPAdvGearWidget(OwnerWindow).EquipmentSelected(7);
			setHighLight(m_2DGadgetSecondary.m_2DGadget);
			break;
			default:*/
		}
	}
}

defaultproperties
{
    m_fPrimaryWindowHeight=138.00
    m_fSecondaryWindowHeight=84.00
}
