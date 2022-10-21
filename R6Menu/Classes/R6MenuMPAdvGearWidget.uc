//================================================================================
// R6MenuMPAdvGearWidget.
//================================================================================
class R6MenuMPAdvGearWidget extends R6MenuWidget;

enum e2DEquipment {
	Primary_Weapon,
	Primary_WeaponGadget,
	Primary_Bullet,
	Primary_Gadget,
	Secondary_Weapon,
	Secondary_WeaponGadget,
	Secondary_Bullet,
	Secondary_Gadget
};

var e2DEquipment m_e2DCurEquipmentSel;
var int m_iCounter;
var bool bShowLog;
var R6MenuMPAdvEquipmentSelectControl m_Equipment2dSelect;
var R6MenuMPAdvEquipmentDetailControl m_EquipmentDetails;
var R6Operative m_currentOperative;
var Class<R6PrimaryWeaponDescription> m_OpFirstWeaponDesc;
var Class<R6SecondaryWeaponDescription> m_OpSecondaryWeaponDesc;
var Class<R6WeaponGadgetDescription> m_OpFirstWeaponGadgetDesc;
var Class<R6WeaponGadgetDescription> m_OpSecondWeaponGadgetDesc;
var Class<R6BulletDescription> m_OpFirstWeaponBulletDesc;
var Class<R6BulletDescription> m_OpSecondWeaponBulletDesc;
var Class<R6GadgetDescription> m_OpFirstGadgetDesc;
var Class<R6GadgetDescription> m_OpSecondGadgetDesc;
var string PrimaryGadgetDesc;

function Created ()
{
	local int labelWidth;
	local Region R;

	m_currentOperative=new Class'R6Operative';
	m_Equipment2dSelect=R6MenuMPAdvEquipmentSelectControl(CreateWindow(Class'R6MenuMPAdvEquipmentSelectControl',0.00,0.00,241.00,WinHeight,self));
	m_EquipmentDetails=R6MenuMPAdvEquipmentDetailControl(CreateWindow(Class'R6MenuMPAdvEquipmentDetailControl',m_Equipment2dSelect.WinWidth - 1,0.00,WinWidth - m_Equipment2dSelect.WinWidth + 1,WinHeight,self));
	GetMenuComEquipment(True);
	m_Equipment2dSelect.Init();
}

function ShowWindow ()
{
	Super.ShowWindow();
	GetMenuComEquipment(False);
	m_Equipment2dSelect.UpdateDetails();
}

function GetMenuComEquipment (bool _bCkeckEquipment)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if ( _bCkeckEquipment )
	{
		r6Root.m_R6GameMenuCom.m_szPrimaryWeapon=VerifyEquipment(0,r6Root.m_R6GameMenuCom.m_szPrimaryWeapon);
		r6Root.m_R6GameMenuCom.m_szPrimaryWeaponGadget=VerifyEquipment(1,r6Root.m_R6GameMenuCom.m_szPrimaryWeaponGadget);
		r6Root.m_R6GameMenuCom.m_szPrimaryGadget=VerifyEquipment(3,r6Root.m_R6GameMenuCom.m_szPrimaryGadget);
		r6Root.m_R6GameMenuCom.m_szSecondaryWeapon=VerifyEquipment(4,r6Root.m_R6GameMenuCom.m_szSecondaryWeapon);
		r6Root.m_R6GameMenuCom.m_szSecondaryWeaponGadget=VerifyEquipment(5,r6Root.m_R6GameMenuCom.m_szSecondaryWeaponGadget);
		r6Root.m_R6GameMenuCom.m_szSecondaryGadget=VerifyEquipment(7,r6Root.m_R6GameMenuCom.m_szSecondaryGadget);
	}
	m_currentOperative.m_szPrimaryWeapon=r6Root.m_R6GameMenuCom.m_szPrimaryWeapon;
	m_currentOperative.m_szPrimaryWeaponGadget=r6Root.m_R6GameMenuCom.m_szPrimaryWeaponGadget;
	m_currentOperative.m_szPrimaryWeaponBullet=r6Root.m_R6GameMenuCom.m_szPrimaryWeaponBullet;
	m_currentOperative.m_szPrimaryGadget=r6Root.m_R6GameMenuCom.m_szPrimaryGadget;
	m_currentOperative.m_szSecondaryWeapon=r6Root.m_R6GameMenuCom.m_szSecondaryWeapon;
	m_currentOperative.m_szSecondaryWeaponGadget=r6Root.m_R6GameMenuCom.m_szSecondaryWeaponGadget;
	m_currentOperative.m_szSecondaryWeaponBullet=r6Root.m_R6GameMenuCom.m_szSecondaryWeaponBullet;
	m_currentOperative.m_szSecondaryGadget=r6Root.m_R6GameMenuCom.m_szSecondaryGadget;
	m_currentOperative.m_szArmor=r6Root.m_R6GameMenuCom.m_szArmor;
	m_OpFirstWeaponDesc=Class<R6PrimaryWeaponDescription>(DynamicLoadObject(m_currentOperative.m_szPrimaryWeapon,Class'Class'));
	m_OpFirstWeaponGadgetDesc=Class'R6DescriptionManager'.static.GetPrimaryWeaponGadgetDesc(m_OpFirstWeaponDesc,m_currentOperative.m_szPrimaryWeaponGadget);
	m_OpFirstWeaponBulletDesc=Class'R6DescriptionManager'.static.GetPrimaryBulletDesc(m_OpFirstWeaponDesc,m_currentOperative.m_szPrimaryWeaponBullet);
	m_OpSecondaryWeaponDesc=Class<R6SecondaryWeaponDescription>(DynamicLoadObject(m_currentOperative.m_szSecondaryWeapon,Class'Class'));
	m_OpSecondWeaponGadgetDesc=Class'R6DescriptionManager'.static.GetSecondaryWeaponGadgetDesc(m_OpSecondaryWeaponDesc,m_currentOperative.m_szSecondaryWeaponGadget);
	m_OpSecondWeaponBulletDesc=Class'R6DescriptionManager'.static.GetSecondaryBulletDesc(m_OpSecondaryWeaponDesc,m_currentOperative.m_szSecondaryWeaponBullet);
	m_OpFirstGadgetDesc=Class<R6GadgetDescription>(DynamicLoadObject(m_currentOperative.m_szPrimaryGadget,Class'Class'));
	m_OpSecondGadgetDesc=Class<R6GadgetDescription>(DynamicLoadObject(m_currentOperative.m_szSecondaryGadget,Class'Class'));
}

function string VerifyEquipment (int _equipmentType, string _szEquipmentToValid)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local string szEquipmentFind;
	local int i;
	local Class<R6PrimaryWeaponDescription> PriWpnClass;
	local string szClassName;
	local bool bFound;
	local Class<R6GadgetDescription> replacedGadgetClass;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	switch (_equipmentType)
	{
		case 0:
		szEquipmentFind=_szEquipmentToValid;
		bFound=False;
		i=0;
JL0038:
		if ( (i < m_EquipmentDetails.m_APrimaryWeapons.Length) &&  !bFound )
		{
			szClassName="" $ string(m_EquipmentDetails.m_APrimaryWeapons[i]);
			if ( szClassName ~= _szEquipmentToValid )
			{
				bFound=True;
			}
			i++;
			goto JL0038;
		}
		if (  !bFound )
		{
			szEquipmentFind="R6Description.R6DescPrimaryWeaponNone";
		}
		break;
		case 1:
		szEquipmentFind=_szEquipmentToValid;
		bFound=False;
		i=0;
JL00FB:
		if ( (i < m_EquipmentDetails.m_APriWpnGadget.Length) &&  !bFound )
		{
			szClassName="" $ m_EquipmentDetails.m_APriWpnGadget[i];
			if ( szClassName ~= _szEquipmentToValid )
			{
				bFound=True;
			}
			i++;
			goto JL00FB;
		}
		if (  !bFound )
		{
			szEquipmentFind="R6Description.R6DescWeaponGadgetNone";
		}
		break;
		case 3:
		szEquipmentFind=_szEquipmentToValid;
		if ( CheckGadget(szEquipmentFind,self,False,replacedGadgetClass) )
		{
			szEquipmentFind=string(replacedGadgetClass);
		}
		PrimaryGadgetDesc=szEquipmentFind;
		bFound=False;
		i=0;
JL01E8:
		if ( (i < m_EquipmentDetails.m_AGadgets.Length) &&  !bFound )
		{
			szClassName="" $ string(m_EquipmentDetails.m_AGadgets[i]);
			if ( szClassName ~= szEquipmentFind )
			{
				bFound=True;
			}
			i++;
			goto JL01E8;
		}
		if (  !bFound )
		{
			szEquipmentFind="R6Description.R6DescGadgetNone";
		}
		break;
		case 4:
		szEquipmentFind=_szEquipmentToValid;
		bFound=False;
		i=0;
JL02A4:
		if ( (i < m_EquipmentDetails.m_ASecondaryWeapons.Length) &&  !bFound )
		{
			szClassName="" $ string(m_EquipmentDetails.m_ASecondaryWeapons[i]);
			if ( szClassName ~= _szEquipmentToValid )
			{
				bFound=True;
			}
			i++;
			goto JL02A4;
		}
		if (  !bFound )
		{
			szEquipmentFind="R6Description.R6DescPistol92FS";
			r6Root.m_R6GameMenuCom.m_szSecondaryWeaponGadget="R6Description.R6DescGadgetNone";
		}
		break;
		case 5:
		szEquipmentFind=_szEquipmentToValid;
		bFound=False;
		i=0;
JL0398:
		if ( (i < m_EquipmentDetails.m_ASecWpnGadget.Length) &&  !bFound )
		{
			szClassName="" $ m_EquipmentDetails.m_ASecWpnGadget[i];
			if ( szClassName ~= _szEquipmentToValid )
			{
				bFound=True;
			}
			i++;
			goto JL0398;
		}
		if (  !bFound )
		{
			szEquipmentFind="R6Description.R6DescWeaponGadgetNone";
		}
		break;
		case 7:
		szEquipmentFind=_szEquipmentToValid;
		if ( CheckGadget(szEquipmentFind,self,False,replacedGadgetClass,PrimaryGadgetDesc) )
		{
			szEquipmentFind=string(replacedGadgetClass);
		}
		bFound=False;
		i=0;
JL047F:
		if ( (i < m_EquipmentDetails.m_AGadgets.Length) &&  !bFound )
		{
			szClassName="" $ string(m_EquipmentDetails.m_AGadgets[i]);
			if ( szClassName ~= szEquipmentFind )
			{
				bFound=True;
			}
			i++;
			goto JL047F;
		}
		if (  !bFound )
		{
			szEquipmentFind="R6Description.R6DescGadgetNone";
		}
		break;
		default:
		break;
	}
	return szEquipmentFind;
}

function setMenuComEquipment ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	RefreshGearInfo(True);
	r6Root.m_R6GameMenuCom.m_szPrimaryWeapon=m_currentOperative.m_szPrimaryWeapon;
	r6Root.m_R6GameMenuCom.m_szPrimaryWeaponGadget=m_currentOperative.m_szPrimaryWeaponGadget;
	r6Root.m_R6GameMenuCom.m_szPrimaryWeaponBullet=m_currentOperative.m_szPrimaryWeaponBullet;
	r6Root.m_R6GameMenuCom.m_szPrimaryGadget=m_currentOperative.m_szPrimaryGadget;
	r6Root.m_R6GameMenuCom.m_szSecondaryWeapon=m_currentOperative.m_szSecondaryWeapon;
	r6Root.m_R6GameMenuCom.m_szSecondaryWeaponGadget=m_currentOperative.m_szSecondaryWeaponGadget;
	r6Root.m_R6GameMenuCom.m_szSecondaryWeaponBullet=m_currentOperative.m_szSecondaryWeaponBullet;
	r6Root.m_R6GameMenuCom.m_szSecondaryGadget=m_currentOperative.m_szSecondaryGadget;
	r6Root.m_R6GameMenuCom.m_szArmor=m_currentOperative.m_szArmor;
	r6Root.m_R6GameMenuCom.SavePlayerSetupInfo();
}

function PopUpBoxDone (MessageBoxResult Result, EPopUpID _ePopUpID)
{
	if ( Result == 3 )
	{
		setMenuComEquipment();
	}
}

function EquipmentSelected (e2DEquipment EquipmentSelected)
{
	local R6WindowListBoxItem TempItem;

	m_e2DCurEquipmentSel=EquipmentSelected;
	m_EquipmentDetails.ShowWindow();
	m_EquipmentDetails.FillListBox(EquipmentSelected);
}

function EquipmentChanged (int EquipmentSelected, Class<R6Description> DecriptionClass)
{
	local Class<R6Description> inDescriptionClass;

	switch (EquipmentSelected)
	{
		case 0:
		inDescriptionClass=DecriptionClass;
		if ( m_OpFirstWeaponDesc != Class<R6PrimaryWeaponDescription>(DecriptionClass) )
		{
			m_currentOperative.m_szPrimaryWeapon=string(DecriptionClass);
			m_OpFirstWeaponDesc=Class<R6PrimaryWeaponDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing Primary Weapon for " @ m_currentOperative.m_szPrimaryWeapon);
			}
			DecriptionClass=Class'R6DescWeaponGadgetNone';
			m_currentOperative.m_szPrimaryWeaponGadget=DecriptionClass.Default.m_NameID;
			m_OpFirstWeaponGadgetDesc=Class<R6WeaponGadgetDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing Primary Weapon Gadget for " @ m_currentOperative.m_szPrimaryWeaponGadget);
			}
			DecriptionClass=Class'R6DescriptionManager'.static.findPrimaryDefaultAmmo(Class<R6PrimaryWeaponDescription>(inDescriptionClass));
			m_currentOperative.m_szPrimaryWeaponBullet=DecriptionClass.Default.m_NameTag;
			m_OpFirstWeaponBulletDesc=Class<R6BulletDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing Primary Weapon Bullets for " @ m_currentOperative.m_szPrimaryWeaponBullet);
			}
		}
		break;
		case 1:
		m_currentOperative.m_szPrimaryWeaponGadget=DecriptionClass.Default.m_NameID;
		m_OpFirstWeaponGadgetDesc=Class<R6WeaponGadgetDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing Primary Weapon Gadget for " @ m_currentOperative.m_szPrimaryWeaponGadget);
		}
		break;
		case 2:
		m_currentOperative.m_szPrimaryWeaponBullet=DecriptionClass.Default.m_NameTag;
		m_OpFirstWeaponBulletDesc=Class<R6BulletDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing Primary Weapon Bullets for " @ m_currentOperative.m_szPrimaryWeaponBullet);
		}
		break;
		case 3:
		m_currentOperative.m_szPrimaryGadget=string(DecriptionClass);
		m_OpFirstGadgetDesc=Class<R6GadgetDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing Primary Gadget for " @ m_currentOperative.m_szPrimaryWeapon);
		}
		break;
		case 4:
		inDescriptionClass=DecriptionClass;
		if ( m_OpSecondaryWeaponDesc != Class<R6SecondaryWeaponDescription>(DecriptionClass) )
		{
			m_currentOperative.m_szSecondaryWeapon=string(DecriptionClass);
			m_OpSecondaryWeaponDesc=Class<R6SecondaryWeaponDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing Secondary Weapon for " @ m_currentOperative.m_szSecondaryWeapon);
			}
			DecriptionClass=Class'R6DescWeaponGadgetNone';
			m_currentOperative.m_szSecondaryWeaponGadget=DecriptionClass.Default.m_NameID;
			m_OpSecondWeaponGadgetDesc=Class<R6WeaponGadgetDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing Secondary Weapon Gadget for " @ m_currentOperative.m_szSecondaryWeaponGadget);
			}
			DecriptionClass=Class'R6DescriptionManager'.static.findSecondaryDefaultAmmo(Class<R6SecondaryWeaponDescription>(inDescriptionClass));
			m_currentOperative.m_szSecondaryWeaponBullet=DecriptionClass.Default.m_NameTag;
			m_OpSecondWeaponBulletDesc=Class<R6BulletDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing Secondary Weapon Bullets for " @ m_currentOperative.m_szSecondaryWeaponBullet);
			}
		}
		break;
		case 5:
		m_currentOperative.m_szSecondaryWeaponGadget=DecriptionClass.Default.m_NameID;
		m_OpSecondWeaponGadgetDesc=Class<R6WeaponGadgetDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing Secondary Weapon Gadget for " @ m_currentOperative.m_szSecondaryWeaponGadget);
		}
		break;
		case 6:
		m_currentOperative.m_szSecondaryWeaponBullet=DecriptionClass.Default.m_NameTag;
		m_OpSecondWeaponBulletDesc=Class<R6BulletDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing Secondary Weapon Bullets for " @ m_currentOperative.m_szSecondaryWeaponBullet);
		}
		break;
		case 7:
		m_currentOperative.m_szSecondaryGadget=string(DecriptionClass);
		m_OpSecondGadgetDesc=Class<R6GadgetDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing Secondary Gadget for " @ m_currentOperative.m_szSecondaryGadget);
		}
		break;
		default:
	}
	m_Equipment2dSelect.UpdateDetails();
}

function TexRegion GetGadgetTexture (Class<R6GadgetDescription> _CurrentGadget)
{
	local bool bFound;
	local string Tag;
	local int i;
	local TexRegion TR;

	if ( Class'R6DescPrimaryMags' == _CurrentGadget )
	{
		if ( m_OpFirstWeaponGadgetDesc.Default.m_NameTag == "CMAG" )
		{
			bFound=True;
			TR.t=m_OpFirstWeaponGadgetDesc.Default.m_2DMenuTexture;
			TR.X=m_OpFirstWeaponGadgetDesc.Default.m_2dMenuRegion.X;
			TR.Y=m_OpFirstWeaponGadgetDesc.Default.m_2dMenuRegion.Y;
			TR.W=m_OpFirstWeaponGadgetDesc.Default.m_2dMenuRegion.W;
			TR.H=m_OpFirstWeaponGadgetDesc.Default.m_2dMenuRegion.H;
		}
		else
		{
			Tag=m_OpFirstWeaponDesc.Default.m_MagTag;
		}
	}
	else
	{
		if ( Class'R6DescSecondaryMags' == _CurrentGadget )
		{
			if ( m_OpSecondWeaponGadgetDesc.Default.m_NameTag == "CMAG" )
			{
				bFound=True;
				TR.t=m_OpSecondWeaponGadgetDesc.Default.m_2DMenuTexture;
				TR.X=m_OpSecondWeaponGadgetDesc.Default.m_2dMenuRegion.X;
				TR.Y=m_OpSecondWeaponGadgetDesc.Default.m_2dMenuRegion.Y;
				TR.W=m_OpSecondWeaponGadgetDesc.Default.m_2dMenuRegion.W;
				TR.H=m_OpSecondWeaponGadgetDesc.Default.m_2dMenuRegion.H;
			}
			else
			{
				Tag=m_OpSecondaryWeaponDesc.Default.m_MagTag;
			}
		}
	}
	if ( Tag != "" )
	{
		i=0;
JL01C6:
		if ( (i < Class<R6DescPrimaryMags>(_CurrentGadget).Default.m_MagTags.Length) && (bFound == False) )
		{
			if ( Class<R6DescPrimaryMags>(_CurrentGadget).Default.m_MagTags[i] == Tag )
			{
				bFound=True;
//				TR=Class<R6DescPrimaryMags>(_CurrentGadget).Default.m_Mags[i];
			}
			else
			{
				i++;
			}
			goto JL01C6;
		}
	}
	if ( bFound == False )
	{
		TR.t=_CurrentGadget.Default.m_2DMenuTexture;
		TR.X=_CurrentGadget.Default.m_2dMenuRegion.X;
		TR.Y=_CurrentGadget.Default.m_2dMenuRegion.Y;
		TR.W=_CurrentGadget.Default.m_2dMenuRegion.W;
		TR.H=_CurrentGadget.Default.m_2dMenuRegion.H;
	}
	return TR;
}

function RefreshGearInfo (bool _bForceUpdate)
{
	if ( (m_iCounter > 10) || _bForceUpdate )
	{
		m_iCounter=0;
		m_EquipmentDetails.BuildAvailableEquipment();
		m_EquipmentDetails.FillListBox(m_e2DCurEquipmentSel);
		m_currentOperative.m_szPrimaryWeapon=VerifyEquipment(0,m_currentOperative.m_szPrimaryWeapon);
		m_currentOperative.m_szPrimaryWeaponGadget=VerifyEquipment(1,m_currentOperative.m_szPrimaryWeaponGadget);
		m_currentOperative.m_szPrimaryGadget=VerifyEquipment(3,m_currentOperative.m_szPrimaryGadget);
		m_currentOperative.m_szSecondaryWeapon=VerifyEquipment(4,m_currentOperative.m_szSecondaryWeapon);
		m_currentOperative.m_szSecondaryWeaponGadget=VerifyEquipment(5,m_currentOperative.m_szSecondaryWeaponGadget);
		m_currentOperative.m_szSecondaryGadget=VerifyEquipment(7,m_currentOperative.m_szSecondaryGadget);
		m_OpFirstWeaponDesc=Class<R6PrimaryWeaponDescription>(DynamicLoadObject(m_currentOperative.m_szPrimaryWeapon,Class'Class'));
		m_OpFirstWeaponGadgetDesc=Class'R6DescriptionManager'.static.GetPrimaryWeaponGadgetDesc(m_OpFirstWeaponDesc,m_currentOperative.m_szPrimaryWeaponGadget);
		m_OpFirstWeaponBulletDesc=Class'R6DescriptionManager'.static.GetPrimaryBulletDesc(m_OpFirstWeaponDesc,m_currentOperative.m_szPrimaryWeaponBullet);
		m_OpSecondaryWeaponDesc=Class<R6SecondaryWeaponDescription>(DynamicLoadObject(m_currentOperative.m_szSecondaryWeapon,Class'Class'));
		m_OpSecondWeaponGadgetDesc=Class'R6DescriptionManager'.static.GetSecondaryWeaponGadgetDesc(m_OpSecondaryWeaponDesc,m_currentOperative.m_szSecondaryWeaponGadget);
		m_OpSecondWeaponBulletDesc=Class'R6DescriptionManager'.static.GetSecondaryBulletDesc(m_OpSecondaryWeaponDesc,m_currentOperative.m_szSecondaryWeaponBullet);
		m_OpFirstGadgetDesc=Class<R6GadgetDescription>(DynamicLoadObject(m_currentOperative.m_szPrimaryGadget,Class'Class'));
		m_OpSecondGadgetDesc=Class<R6GadgetDescription>(DynamicLoadObject(m_currentOperative.m_szSecondaryGadget,Class'Class'));
		m_Equipment2dSelect.UpdateDetails();
	}
	m_iCounter++;
}

static function bool CheckGadget (string _gadgetDesc, UWindowWindow _caller, bool _isSecondGadget, optional out Class<R6GadgetDescription> _replaceGadgetClass, optional string _otherGadget)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(_caller.Root);
/*	if ( r6Root.m_eCurrentGameType == _caller.GetLevel().22 )
	{
		if ( (_gadgetDesc == "R6Description.R6DescFragGrenadeGadget") || (_gadgetDesc == "R6Description.R6DescBreachingChargeGadget") || (_gadgetDesc == "R6Description.R6DescClaymoreGadget") || (_gadgetDesc == "R6Description.R6DescRemoteChargeGadget") )
		{
			if ( _isSecondGadget )
			{
				if ( _otherGadget == "R6Description.R6DescSmokeGrenadeGadget" )
				{
					_replaceGadgetClass=Class'R6DescFlashBangGadget';
				}
				else
				{
					_replaceGadgetClass=Class'R6DescSmokeGrenadeGadget';
				}
			}
			else
			{
				if ( _otherGadget == "R6Description.R6DescFlashBangGadget" )
				{
					_replaceGadgetClass=Class'R6DescSmokeGrenadeGadget';
				}
				else
				{
					_replaceGadgetClass=Class'R6DescFlashBangGadget';
				}
			}
			return True;
		}
	}*/
	return False;
}
