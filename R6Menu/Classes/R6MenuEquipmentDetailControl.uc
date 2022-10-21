//================================================================================
// R6MenuEquipmentDetailControl.
//================================================================================
class R6MenuEquipmentDetailControl extends UWindowDialogClientWindow;

enum eAnchorEquipmentType {
	AET_Primary,
	AET_Secondary,
	AET_Gadget,
	AET_None
};

var int m_CurrentEquipmentType;
var bool m_bDrawListBg;
var float m_fListBoxLabelHeight;
var float m_fListBoxHeight;
var float m_fAnchorAreaHeight;
var R6WindowTextLabel m_Title;
var R6WindowTextListBox m_listBox;
var R6WindowWrappedTextArea m_EquipmentText;
var Font m_DescriptionTextFont;
var R6MenuEquipmentAnchorButtons m_AnchorButtons;
var R6MenuWeaponStats m_WeaponStats;
var R6MenuWeaponDetailRadioArea m_Buttons;
var array<Class> m_APrimaryWeapons;
var array<Class> m_ASecondaryWeapons;
var array<Class> m_AGadgets;
var array<Class> m_AArmors;
var Color m_DescriptionTextColor;

function Created ()
{
	local Color labelFontColor;
	local Color co;
	local Texture BorderTexture;

	m_BorderColor=Root.Colors.GrayLight;
	labelFontColor=Root.Colors.White;
	m_Title=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,m_fListBoxLabelHeight,self));
	m_Title.align=ta_center;
	m_Title.m_Font=Root.Fonts[6];
	m_Title.TextColor=labelFontColor;
	m_Title.m_BGTexture=None;
	m_Title.m_BorderColor=m_BorderColor;
	m_listBox=R6WindowTextListBox(CreateControl(Class'R6WindowTextListBox',0.00,m_fListBoxLabelHeight - 1,WinWidth,m_fListBoxHeight,self));
	m_listBox.ListClass=Class'R6WindowListBoxItem';
	m_listBox.m_VertSB.SetHideWhenDisable(True);
	m_listBox.m_Font=m_Title.m_Font;
//	m_listBox.SetCornerType(0);
	m_listBox.m_BorderColor=m_BorderColor;
	m_listBox.m_fSpaceBetItem=0.00;
	m_listBox.m_VertSB.SetEffect(True);
	m_EquipmentText=R6WindowWrappedTextArea(CreateWindow(Class'R6WindowWrappedTextArea',0.00,m_listBox.WinTop + m_listBox.WinHeight - 1,WinWidth,WinHeight - m_Title.WinHeight - m_listBox.WinHeight + 1,self));
	m_EquipmentText.m_HBorderTexture=m_Title.m_HBorderTexture;
	m_EquipmentText.m_VBorderTexture=m_Title.m_VBorderTexture;
	m_EquipmentText.m_HBorderTextureRegion=m_Title.m_HBorderTextureRegion;
	m_EquipmentText.m_VBorderTextureRegion=m_Title.m_VBorderTextureRegion;
	m_EquipmentText.m_fHBorderHeight=m_Title.m_fHBorderHeight;
	m_EquipmentText.m_fVBorderWidth=m_Title.m_fVBorderWidth;
	m_EquipmentText.m_BorderColor=m_BorderColor;
	m_EquipmentText.SetScrollable(True);
	m_EquipmentText.m_fXOffSet=5.00;
	m_EquipmentText.m_fYOffSet=5.00;
	m_EquipmentText.VertSB.SetEffect(True);
	m_EquipmentText.m_bUseBGTexture=True;
	m_EquipmentText.m_BGTexture=Texture'WhiteTexture';
	m_EquipmentText.m_BGRegion.X=0;
	m_EquipmentText.m_BGRegion.Y=0;
	m_EquipmentText.m_BGRegion.W=m_EquipmentText.m_BGTexture.USize;
	m_EquipmentText.m_BGRegion.H=m_EquipmentText.m_BGTexture.VSize;
	m_EquipmentText.m_bUseBGColor=True;
	m_EquipmentText.m_BGColor=Root.Colors.Black;
	m_EquipmentText.m_BGColor.A=Root.Colors.DarkBGAlpha;
	m_DescriptionTextColor=Root.Colors.White;
	m_DescriptionTextFont=Root.Fonts[6];
	m_CurrentEquipmentType=-1;
	BuildAvailableEquipment();
	m_AnchorButtons=R6MenuEquipmentAnchorButtons(CreateControl(Class'R6MenuEquipmentAnchorButtons',0.00,0.00,WinWidth,m_fAnchorAreaHeight,self));
	m_AnchorButtons.m_BorderColor=m_BorderColor;
	m_AnchorButtons.HideWindow();
	m_Buttons=R6MenuWeaponDetailRadioArea(CreateWindow(Class'R6MenuWeaponDetailRadioArea',0.00,m_listBox.WinTop + m_listBox.WinHeight - 1,WinWidth,m_fAnchorAreaHeight,self));
	m_Buttons.m_BorderColor=m_BorderColor;
	m_Buttons.HideWindow();
	m_WeaponStats=R6MenuWeaponStats(CreateWindow(Class'R6MenuWeaponStats',0.00,m_Buttons.WinTop + m_Buttons.WinHeight - 1,WinWidth,WinHeight - m_Buttons.WinTop - m_Buttons.WinHeight + 1,self));
	m_WeaponStats.m_BorderColor=m_BorderColor;
	m_WeaponStats.HideWindow();
	Class'Actor'.static.GetModMgr().RegisterObject(self);
}

function InitMod ()
{
	BuildAvailableEquipment();
	BuildAvailableMissionArmors();
}

function R6Operative GetCurrentOperative ()
{
	return R6MenuGearWidget(OwnerWindow).m_currentOperative;
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

function Class<R6GadgetDescription> GetCurrentGadget (bool _Primary)
{
	if ( _Primary == True )
	{
		return R6MenuGearWidget(OwnerWindow).m_OpFirstGadgetDesc;
	}
	else
	{
		return R6MenuGearWidget(OwnerWindow).m_OpSecondGadgetDesc;
	}
}

function Class<R6ArmorDescription> GetCurrentArmor ()
{
	return R6MenuGearWidget(OwnerWindow).m_OpArmorDesc;
}

function NotifyEquipmentChanged (int EquipmentSelected, Class<R6Description> DecriptionClass)
{
	R6MenuGearWidget(OwnerWindow).EquipmentChanged(EquipmentSelected,DecriptionClass);
}

function FillListBox (int _equipmentType)
{
	local Class<R6PrimaryWeaponDescription> PrimaryWeaponClass;
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;
	local Class<R6BulletDescription> WeaponBulletDescriptionClass;
	local Class<R6GadgetDescription> GadgetClass;
	local Class<R6WeaponGadgetDescription> WeaponGadgetDescriptionClass;
	local Class<R6ArmorDescription> ArmorDescriptionClass;
	local R6ArmorDescription ArmorForAvailabilityTest;
	local R6WindowListBoxItem NewItem;
	local R6WindowListBoxItem SelectedItem;
	local R6WindowListBoxItem FirstInsertedItem;
	local R6Operative currentOperative;
	local int i;
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	currentOperative=GetCurrentOperative();
	SelectedItem=None;
	switch (_equipmentType)
	{
		case 0:
		m_Title.SetNewText(Localize("GearRoom","PrimaryWeapon","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(0);
		PrimaryWeaponClass=Class'R6DescPrimaryWeaponNone';
		NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
		NewItem.HelpText=Localize(PrimaryWeaponClass.Default.m_NameID,"ID_NAME","R6Weapons");
		NewItem.m_Object=PrimaryWeaponClass;
		if ( GetCurrentPrimaryWeapon() == PrimaryWeaponClass )
		{
			SelectedItem=NewItem;
		}
		FirstInsertedItem=CreatePrimaryWeaponsSeparators();
		i=0;
JL012A:
		if ( i < m_APrimaryWeapons.Length )
		{
			PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(m_APrimaryWeapons[i]);
			if ( Class<R6SubGunDescription>(PrimaryWeaponClass) != None )
			{
				NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',1);
			}
			else
			{
				if ( Class<R6AssaultDescription>(PrimaryWeaponClass) != None )
				{
					NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',2);
				}
				else
				{
					if ( Class<R6ShotgunDescription>(PrimaryWeaponClass) != None )
					{
						NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',3);
					}
					else
					{
						if ( Class<R6SniperDescription>(PrimaryWeaponClass) != None )
						{
							NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',4);
						}
						else
						{
							if ( Class<R6LMGDescription>(PrimaryWeaponClass) != None )
							{
								NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',5);
							}
							else
							{
								NewItem=R6WindowListBoxItem(FirstInsertedItem.InsertBefore(Class'R6WindowListBoxItem'));
							}
						}
					}
				}
			}
			NewItem.HelpText=Localize(PrimaryWeaponClass.Default.m_NameID,"ID_NAME","R6Weapons");
			NewItem.m_Object=PrimaryWeaponClass;
			if ( GetCurrentPrimaryWeapon() == PrimaryWeaponClass )
			{
				SelectedItem=NewItem;
			}
			i++;
			goto JL012A;
		}
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(True);
		break;
		case 1:
		m_Title.SetNewText(Localize("GearRoom","PrimaryWeaponGadget","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(3);
		PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(DynamicLoadObject(currentOperative.m_szPrimaryWeapon,Class'Class'));
		i=0;
JL03A7:
		if ( i < PrimaryWeaponClass.Default.m_MyGadgets.Length )
		{
			WeaponGadgetDescriptionClass=Class<R6WeaponGadgetDescription>(PrimaryWeaponClass.Default.m_MyGadgets[i]);
			if ( WeaponGadgetDescriptionClass != Class'R6DescWeaponGadgetNone' )
			{
				NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
				NewItem.HelpText=Localize(WeaponGadgetDescriptionClass.Default.m_NameID,"ID_NAME","R6WeaponGadgets");
				NewItem.m_Object=WeaponGadgetDescriptionClass;
				if ( GetCurrentWeaponGadget(True) == WeaponGadgetDescriptionClass )
				{
					SelectedItem=NewItem;
				}
			}
			i++;
			goto JL03A7;
		}
		m_listBox.Items.Sort();
		WeaponGadgetDescriptionClass=Class'R6DescWeaponGadgetNone';
		NewItem=R6WindowListBoxItem(m_listBox.Items.InsertAfter(Class'R6WindowListBoxItem'));
		NewItem.HelpText=Localize(WeaponGadgetDescriptionClass.Default.m_NameID,"ID_NAME","R6WeaponGadgets");
		NewItem.m_Object=WeaponGadgetDescriptionClass;
		if ( GetCurrentWeaponGadget(True) == WeaponGadgetDescriptionClass )
		{
			SelectedItem=NewItem;
		}
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(False);
		break;
		case 2:
		m_Title.SetNewText(Localize("GearRoom","PrimaryAmmo","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(3);
		PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(DynamicLoadObject(currentOperative.m_szPrimaryWeapon,Class'Class'));
		i=0;
JL05D6:
		if ( i < PrimaryWeaponClass.Default.m_Bullets.Length )
		{
			WeaponBulletDescriptionClass=Class<R6BulletDescription>(PrimaryWeaponClass.Default.m_Bullets[i]);
			if ( WeaponBulletDescriptionClass != Class'R6DescBulletNone' )
			{
				NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
				NewItem.HelpText=Localize(WeaponBulletDescriptionClass.Default.m_NameID,"ID_NAME","R6Ammo");
				NewItem.m_Object=WeaponBulletDescriptionClass;
				if ( GetCurrentWeaponBullet(True) == WeaponBulletDescriptionClass )
				{
					SelectedItem=NewItem;
				}
			}
			i++;
			goto JL05D6;
		}
		m_listBox.Items.Sort();
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(False);
		break;
		case 3:
		m_Title.SetNewText(Localize("GearRoom","PrimaryGadget","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(2);
		GadgetClass=Class'R6DescGadgetNone';
		NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
		NewItem.HelpText=Localize(GadgetClass.Default.m_NameID,"ID_NAME","R6Gadgets");
		NewItem.m_Object=GadgetClass;
		if ( GetCurrentGadget(True) == GadgetClass )
		{
			SelectedItem=NewItem;
		}
		FirstInsertedItem=CreateGadgetsSeparators();
		i=0;
JL07E0:
		if ( i < m_AGadgets.Length )
		{
			GadgetClass=Class<R6GadgetDescription>(m_AGadgets[i]);
			if (  !Class'R6MenuMPAdvGearWidget'.static.CheckGadget(string(GadgetClass),self,False) )
			{
				if ( Class<R6GrenadeDescription>(GadgetClass) != None )
				{
					NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',1);
				}
				else
				{
					if ( Class<R6ExplosiveDescription>(GadgetClass) != None )
					{
						NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',2);
					}
					else
					{
						if ( Class<R6HBDeviceDescription>(GadgetClass) != None )
						{
							NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',3);
						}
						else
						{
							if ( Class<R6KitDescription>(GadgetClass) != None )
							{
								NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',4);
							}
							else
							{
								NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',5);
							}
						}
					}
				}
			}
			NewItem.HelpText=Localize(GadgetClass.Default.m_NameID,"ID_NAME","R6Gadgets");
			NewItem.m_Object=GadgetClass;
			if ( GetCurrentGadget(True) == GadgetClass )
			{
				SelectedItem=NewItem;
			}
			i++;
			goto JL07E0;
		}
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(False);
		break;
		case 4:
		m_Title.SetNewText(Localize("GearRoom","SecondaryWeapon","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(1);
		FirstInsertedItem=CreateSecondaryWeaponsSeparators();
		i=0;
JL0A2E:
		if ( i < m_ASecondaryWeapons.Length )
		{
			SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(m_ASecondaryWeapons[i]);
			if ( Class<R6PistolsDescription>(SecondaryWeaponClass) != None )
			{
				NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',1);
			}
			else
			{
				if ( Class<R6MachinePistolsDescription>(SecondaryWeaponClass) != None )
				{
					NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',2);
				}
				else
				{
					NewItem=R6WindowListBoxItem(FirstInsertedItem.InsertBefore(Class'R6WindowListBoxItem'));
				}
			}
			if ( NewItem != None )
			{
				NewItem.HelpText=Localize(SecondaryWeaponClass.Default.m_NameID,"ID_NAME","R6Weapons");
				NewItem.m_Object=SecondaryWeaponClass;
				if ( GetCurrentSecondaryWeapon() == SecondaryWeaponClass )
				{
					SelectedItem=NewItem;
				}
			}
			i++;
			goto JL0A2E;
		}
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(True);
		break;
		case 5:
		m_Title.SetNewText(Localize("GearRoom","SecondaryWeaponGadget","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(3);
		SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(DynamicLoadObject(currentOperative.m_szSecondaryWeapon,Class'Class'));
		i=0;
JL0C02:
		if ( i < SecondaryWeaponClass.Default.m_MyGadgets.Length )
		{
			WeaponGadgetDescriptionClass=Class<R6WeaponGadgetDescription>(SecondaryWeaponClass.Default.m_MyGadgets[i]);
			if ( WeaponGadgetDescriptionClass != Class'R6DescWeaponGadgetNone' )
			{
				NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
				NewItem.HelpText=Localize(WeaponGadgetDescriptionClass.Default.m_NameID,"ID_NAME","R6WeaponGadgets");
				NewItem.m_Object=WeaponGadgetDescriptionClass;
				if ( GetCurrentWeaponGadget(False) == WeaponGadgetDescriptionClass )
				{
					SelectedItem=NewItem;
				}
			}
			i++;
			goto JL0C02;
		}
		m_listBox.Items.Sort();
		WeaponGadgetDescriptionClass=Class'R6DescWeaponGadgetNone';
		NewItem=R6WindowListBoxItem(m_listBox.Items.InsertAfter(Class'R6WindowListBoxItem'));
		NewItem.HelpText=Localize(WeaponGadgetDescriptionClass.Default.m_NameID,"ID_NAME","R6WeaponGadgets");
		NewItem.m_Object=WeaponGadgetDescriptionClass;
		if ( GetCurrentWeaponGadget(False) == WeaponGadgetDescriptionClass )
		{
			SelectedItem=NewItem;
		}
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(False);
		break;
		case 6:
		m_Title.SetNewText(Localize("GearRoom","SecondaryAmmo","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(3);
		SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(DynamicLoadObject(currentOperative.m_szSecondaryWeapon,Class'Class'));
		i=0;
JL0E33:
		if ( i < SecondaryWeaponClass.Default.m_Bullets.Length )
		{
			WeaponBulletDescriptionClass=Class<R6BulletDescription>(SecondaryWeaponClass.Default.m_Bullets[i]);
			if ( WeaponBulletDescriptionClass != Class'R6DescBulletNone' )
			{
				NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
				NewItem.HelpText=Localize(WeaponBulletDescriptionClass.Default.m_NameID,"ID_NAME","R6Ammo");
				NewItem.m_Object=WeaponBulletDescriptionClass;
				if ( GetCurrentWeaponBullet(False) == WeaponBulletDescriptionClass )
				{
					SelectedItem=NewItem;
				}
			}
			i++;
			goto JL0E33;
		}
		m_listBox.Items.Sort();
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(False);
		break;
		case 7:
		m_Title.SetNewText(Localize("GearRoom","SecondaryGadget","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(2);
		GadgetClass=Class'R6DescGadgetNone';
		NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
		NewItem.HelpText=Localize(GadgetClass.Default.m_NameID,"ID_NAME","R6Gadgets");
		NewItem.m_Object=GadgetClass;
		if ( GetCurrentGadget(False) == GadgetClass )
		{
			SelectedItem=NewItem;
		}
		FirstInsertedItem=CreateGadgetsSeparators();
		i=0;
JL103F:
		if ( i < m_AGadgets.Length )
		{
			GadgetClass=Class<R6GadgetDescription>(m_AGadgets[i]);
			if (  !Class'R6MenuMPAdvGearWidget'.static.CheckGadget(string(GadgetClass),self,False) )
			{
				if ( Class<R6GrenadeDescription>(GadgetClass) != None )
				{
					NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',1);
				}
				else
				{
					if ( Class<R6ExplosiveDescription>(GadgetClass) != None )
					{
						NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',2);
					}
					else
					{
						if ( Class<R6HBDeviceDescription>(GadgetClass) != None )
						{
							NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',3);
						}
						else
						{
							if ( Class<R6KitDescription>(GadgetClass) != None )
							{
								NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',4);
							}
							else
							{
								NewItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',5);
							}
						}
					}
				}
			}
			NewItem.HelpText=Localize(GadgetClass.Default.m_NameID,"ID_NAME","R6Gadgets");
			NewItem.m_Object=GadgetClass;
			if ( GetCurrentGadget(False) == GadgetClass )
			{
				SelectedItem=NewItem;
			}
			i++;
			goto JL103F;
		}
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(False);
		break;
		case 8:
		m_Title.SetNewText(Localize("GearRoom","Armor","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(3);
		i=0;
JL1277:
		if ( i < m_AArmors.Length )
		{
			ArmorDescriptionClass=Class<R6ArmorDescription>(m_AArmors[i]);
			ArmorForAvailabilityTest=new ArmorDescriptionClass;
			if ( (ArmorDescriptionClass.Default.m_bHideFromMenu == False) && GetCurrentOperative().IsA(ArmorDescriptionClass.Default.m_LimitedToClass) && ArmorForAvailabilityTest.IsA(GetCurrentOperative().m_CanUseArmorType) )
			{
				NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
				NewItem.HelpText=Localize(ArmorDescriptionClass.Default.m_NameID,"ID_NAME","R6Armor");
				NewItem.m_Object=ArmorDescriptionClass;
				if ( GetCurrentArmor() == ArmorDescriptionClass )
				{
					SelectedItem=NewItem;
				}
			}
			i++;
			goto JL1277;
		}
		m_CurrentEquipmentType=_equipmentType;
		enableWeaponStats(False);
		break;
		default:
	}
	if ( SelectedItem != None )
	{
		m_listBox.SetSelectedItem(SelectedItem);
		m_listBox.MakeSelectedVisible();
	}
}

function UpdateAnchorButtons (eAnchorEquipmentType _AEType)
{
	if ( _AEType == 3 )
	{
		m_AnchorButtons.HideWindow();
		m_Title.WinTop=0.00;
		m_listBox.WinTop=m_Title.WinTop + m_Title.WinHeight - 1;
		m_listBox.SetSize(m_listBox.WinWidth,m_fListBoxHeight);
	}
	else
	{
		m_AnchorButtons.ShowWindow();
//		m_AnchorButtons.DisplayButtons(_AEType);
		m_Title.WinTop=m_AnchorButtons.WinTop + m_AnchorButtons.WinHeight - 1;
		m_listBox.WinTop=m_Title.WinTop + m_Title.WinHeight - 1;
		m_listBox.SetSize(m_listBox.WinWidth,m_fListBoxHeight - m_AnchorButtons.WinHeight + 1);
	}
}

function BuildAvailableEquipment ()
{
	local Class<R6PrimaryWeaponDescription> PrimaryWeaponClass;
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;
	local Class<R6GadgetDescription> GadgetClass;
	local int i;
	local R6Mod pCurrentMod;
	local int j;

	m_APrimaryWeapons.Remove (0,m_APrimaryWeapons.Length);
	m_ASecondaryWeapons.Remove (0,m_ASecondaryWeapons.Length);
	m_AGadgets.Remove (0,m_AGadgets.Length);
	i=0;
	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	j=0;
JL0050:
	if ( j < pCurrentMod.m_aDescriptionPackage.Length )
	{
		PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[j] $ ".u",Class'R6PrimaryWeaponDescription'));
JL0096:
		if ( PrimaryWeaponClass != None )
		{
			if ( PrimaryWeaponClass.Default.m_NameID != "NONE" )
			{
				m_APrimaryWeapons[i]=PrimaryWeaponClass;
				i++;
			}
			PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(GetNextClass());
			goto JL0096;
		}
		FreePackageObjects();
		j++;
		goto JL0050;
	}
	SortDescriptions(True,m_APrimaryWeapons,"R6Weapons");
	i=0;
	j=0;
JL0115:
	if ( j < pCurrentMod.m_aDescriptionPackage.Length )
	{
		GadgetClass=Class<R6GadgetDescription>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[j] $ ".u",Class'R6GadgetDescription'));
JL015B:
		if ( GadgetClass != None )
		{
			if ( GadgetClass.Default.m_NameID != "NONE" )
			{
				m_AGadgets[i]=GadgetClass;
				i++;
			}
			GadgetClass=Class<R6GadgetDescription>(GetNextClass());
			goto JL015B;
		}
		FreePackageObjects();
		j++;
		goto JL0115;
	}
	SortDescriptions(True,m_AGadgets,"R6Gadgets");
	i=0;
	j=0;
JL01DA:
	if ( j < pCurrentMod.m_aDescriptionPackage.Length )
	{
		SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[j] $ ".u",Class'R6SecondaryWeaponDescription'));
JL0220:
		if ( SecondaryWeaponClass != None )
		{
			if ( SecondaryWeaponClass.Default.m_NameID != "NONE" )
			{
				m_ASecondaryWeapons[i]=SecondaryWeaponClass;
				i++;
			}
			SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(GetNextClass());
			goto JL0220;
		}
		FreePackageObjects();
		j++;
		goto JL01DA;
	}
	SortDescriptions(True,m_ASecondaryWeapons,"R6Weapons");
}

function R6WindowListBoxItem CreatePrimaryWeaponsSeparators ()
{
	local R6WindowListBoxItem NewItem;
	local R6WindowListBoxItem FirstInsertedItem;
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	FirstInsertedItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	FirstInsertedItem.HelpText=Caps(Localize("SUBGUN","ID_NAME","R6Weapons"));
	FirstInsertedItem.m_IsSeparator=True;
	FirstInsertedItem.m_iSeparatorID=1;
	m_AnchorButtons.m_SUBGUNButton.AnchoredElement=FirstInsertedItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("ASSAULT","ID_NAME","R6Weapons"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=2;
	m_AnchorButtons.m_ASSAULTButton.AnchoredElement=NewItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("SHOTGUN","ID_NAME","R6Weapons"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=3;
	m_AnchorButtons.m_SHOTGUNButton.AnchoredElement=NewItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("SNIPER","ID_NAME","R6Weapons"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=4;
	m_AnchorButtons.m_SNIPERButton.AnchoredElement=NewItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("LMG","ID_NAME","R6Weapons"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=5;
	m_AnchorButtons.m_LMGButton.AnchoredElement=NewItem;
	return FirstInsertedItem;
}

function R6WindowListBoxItem CreateSecondaryWeaponsSeparators ()
{
	local R6WindowListBoxItem NewItem;
	local R6WindowListBoxItem FirstInsertedItem;
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	FirstInsertedItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	FirstInsertedItem.HelpText=Caps(Localize("PISTOLS","ID_NAME","R6Weapons"));
	FirstInsertedItem.m_IsSeparator=True;
	FirstInsertedItem.m_iSeparatorID=1;
	m_AnchorButtons.m_PISTOLSButton.AnchoredElement=FirstInsertedItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("MACHINEPISTOLS","ID_NAME","R6Weapons"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=2;
	m_AnchorButtons.m_MACHINEPISTOLSButton.AnchoredElement=NewItem;
	return FirstInsertedItem;
}

function R6WindowListBoxItem CreateGadgetsSeparators ()
{
	local R6WindowListBoxItem NewItem;
	local R6WindowListBoxItem FirstInsertedItem;
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	FirstInsertedItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	FirstInsertedItem.HelpText=Caps(Localize("CATEGORIES","GRENADES","R6Gadgets"));
	FirstInsertedItem.m_IsSeparator=True;
	FirstInsertedItem.m_iSeparatorID=1;
	m_AnchorButtons.m_GRENADESButton.AnchoredElement=FirstInsertedItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("CATEGORIES","EXPLOSIVES","R6Gadgets"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=2;
	m_AnchorButtons.m_EXPLOSIVESButton.AnchoredElement=NewItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("CATEGORIES","HBDEVICE","R6Gadgets"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=3;
	m_AnchorButtons.m_HBDEVICEButton.AnchoredElement=NewItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("CATEGORIES","KITS","R6Gadgets"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=4;
	m_AnchorButtons.m_KITSButton.AnchoredElement=NewItem;
	NewItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	NewItem.HelpText=Caps(Localize("CATEGORIES","GENERAL","R6Gadgets"));
	NewItem.m_IsSeparator=True;
	NewItem.m_iSeparatorID=5;
	m_AnchorButtons.m_GENERALButton.AnchoredElement=NewItem;
	return FirstInsertedItem;
}

function BuildAvailableMissionArmors ()
{
	local Class<R6ArmorDescription> ArmorDescriptionClass;
	local int i;
	local int nbArmor;
	local R6MissionDescription CurrentMission;
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	m_AArmors.Remove (0,m_AArmors.Length);
	CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
	if ( CurrentMission == None )
	{
		return;
	}
	nbArmor=0;
	i=0;
JL0073:
	if ( i < CurrentMission.m_MissionArmorTypes.Length )
	{
		ArmorDescriptionClass=Class<R6ArmorDescription>(CurrentMission.m_MissionArmorTypes[i]);
		if ( ArmorDescriptionClass.Default.m_NameID != "NONE" )
		{
			m_AArmors[nbArmor]=ArmorDescriptionClass;
			nbArmor++;
		}
		i++;
		goto JL0073;
	}
	SortDescriptions(True,m_AArmors,"R6Armor",True);
	i=0;
JL0103:
	if ( i < pModManager.GetPackageMgr().GetNbPackage() )
	{
		ArmorDescriptionClass=Class<R6ArmorDescription>(pModManager.GetPackageMgr().GetFirstClassFromPackage(i,Class'R6ArmorDescription'));
JL0154:
		if ( (ArmorDescriptionClass != None) && (ArmorDescriptionClass.Default.m_bHideFromMenu == False) )
		{
			m_AArmors[nbArmor]=ArmorDescriptionClass;
			nbArmor++;
			ArmorDescriptionClass=Class<R6ArmorDescription>(pModManager.GetPackageMgr().GetNextClassFromPackage());
			goto JL0154;
		}
		i++;
		goto JL0103;
	}
}

function Class<R6ArmorDescription> GetDefaultArmor ()
{
	if ( m_AArmors.Length > 0 )
	{
		return Class<R6ArmorDescription>(m_AArmors[0]);
	}
	else
	{
		return None;
	}
}

function bool IsAmorAvailable (Class<R6ArmorDescription> lookedUpArmor, R6Operative currentOperative)
{
	local int i;
	local bool bArmorIsAvailble;

	bArmorIsAvailble=False;
	i=0;
	if (  !currentOperative.IsA(lookedUpArmor.Default.m_LimitedToClass) )
	{
		return False;
	}
JL0030:
	if ( (bArmorIsAvailble == False) && (i < m_AArmors.Length) )
	{
		if ( lookedUpArmor == Class<R6ArmorDescription>(m_AArmors[i]) )
		{
			bArmorIsAvailble=True;
		}
		i++;
		goto JL0030;
	}
	return bArmorIsAvailble;
}

function Notify (UWindowDialogControl C, byte E)
{
	local Class<R6PrimaryWeaponDescription> PrimaryWeaponClass;
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;
	local Class<R6WeaponGadgetDescription> WeaponGadgetDescriptionClass;
	local Class<R6BulletDescription> WeaponBulletDescriptionClass;
	local Class<R6ArmorDescription> ArmorDescriptionClass;
	local Class<R6GadgetDescription> GadgetDescriptionClass;
	local R6WindowListBoxItem SelectedItem;
	local string NewString;
	local int itemPos;
	local int i;
	local R6ModMgr pModManager;

	pModManager=Class'Actor'.static.GetModMgr();
	if ( E == 2 )
	{
		switch (C)
		{
			case m_listBox:
			switch (m_CurrentEquipmentType)
			{
				case 0:
				SelectedItem=R6WindowListBoxItem(m_listBox.m_SelectedItem);
				PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(SelectedItem.m_Object);
				NewString=Localize(PrimaryWeaponClass.Default.m_NameID,"ID_Description","R6Weapons",False,True);
				NotifyEquipmentChanged(m_CurrentEquipmentType,PrimaryWeaponClass);
				m_WeaponStats.m_fInitRangePercent=PrimaryWeaponClass.Default.m_ARangePercent[0];
				m_WeaponStats.m_fInitDamagePercent=PrimaryWeaponClass.Default.m_ADamagePercent[0];
				m_WeaponStats.m_fInitAccuracyPercent=PrimaryWeaponClass.Default.m_AAccuracyPercent[0];
				m_WeaponStats.m_fInitRecoilPercent=PrimaryWeaponClass.Default.m_ARecoilPercent[0];
				m_WeaponStats.m_fInitRecoveryPercent=PrimaryWeaponClass.Default.m_ARecoveryPercent[0];
				m_WeaponStats.m_fRangePercent=m_WeaponStats.m_fInitRangePercent;
				m_WeaponStats.m_fDamagePercent=m_WeaponStats.m_fInitDamagePercent;
				m_WeaponStats.m_fAccuracyPercent=m_WeaponStats.m_fInitAccuracyPercent;
				m_WeaponStats.m_fRecoilPercent=m_WeaponStats.m_fInitRecoilPercent;
				m_WeaponStats.m_fRecoveryPercent=m_WeaponStats.m_fInitRecoveryPercent;
				WeaponGadgetDescriptionClass=GetCurrentWeaponGadget(True);
				if ( WeaponGadgetDescriptionClass != Class'R6DescWeaponGadgetNone' )
				{
					i=0;
JL020C:
					if ( i < PrimaryWeaponClass.Default.m_WeaponTags.Length )
					{
						if ( PrimaryWeaponClass.Default.m_WeaponTags[i] == WeaponGadgetDescriptionClass.Default.m_NameTag )
						{
							m_WeaponStats.m_fRangePercent=PrimaryWeaponClass.Default.m_ARangePercent[i];
							m_WeaponStats.m_fDamagePercent=PrimaryWeaponClass.Default.m_ADamagePercent[i];
							m_WeaponStats.m_fAccuracyPercent=PrimaryWeaponClass.Default.m_AAccuracyPercent[i];
							m_WeaponStats.m_fRecoilPercent=PrimaryWeaponClass.Default.m_ARecoilPercent[i];
							m_WeaponStats.m_fRecoveryPercent=PrimaryWeaponClass.Default.m_ARecoveryPercent[i];
						}
						else
						{
							i++;
							goto JL020C;
						}
					}
				}
				m_WeaponStats.ResizeCharts();
				break;
				case 1:
				case 5:
				SelectedItem=R6WindowListBoxItem(m_listBox.m_SelectedItem);
				WeaponGadgetDescriptionClass=Class<R6WeaponGadgetDescription>(SelectedItem.m_Object);
				NewString=Localize(WeaponGadgetDescriptionClass.Default.m_NameID,"ID_Description","R6WeaponGadgets",False,True);
				NotifyEquipmentChanged(m_CurrentEquipmentType,WeaponGadgetDescriptionClass);
				break;
				case 2:
				case 6:
				SelectedItem=R6WindowListBoxItem(m_listBox.m_SelectedItem);
				WeaponBulletDescriptionClass=Class<R6BulletDescription>(SelectedItem.m_Object);
				NewString=Localize(WeaponBulletDescriptionClass.Default.m_NameID,"ID_Description","R6Ammo",False,True);
				NotifyEquipmentChanged(m_CurrentEquipmentType,WeaponBulletDescriptionClass);
				break;
				case 3:
				case 7:
				SelectedItem=R6WindowListBoxItem(m_listBox.m_SelectedItem);
				GadgetDescriptionClass=Class<R6GadgetDescription>(SelectedItem.m_Object);
				NewString=Localize(GadgetDescriptionClass.Default.m_NameID,"ID_Description","R6Gadgets",False,True);
				NotifyEquipmentChanged(m_CurrentEquipmentType,GadgetDescriptionClass);
				break;
				case 4:
				SelectedItem=R6WindowListBoxItem(m_listBox.m_SelectedItem);
				SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(SelectedItem.m_Object);
				NewString=Localize(SecondaryWeaponClass.Default.m_NameID,"ID_Description","R6Weapons",False,True);
				NotifyEquipmentChanged(m_CurrentEquipmentType,SecondaryWeaponClass);
				m_WeaponStats.m_fInitRangePercent=SecondaryWeaponClass.Default.m_ARangePercent[0];
				m_WeaponStats.m_fInitDamagePercent=SecondaryWeaponClass.Default.m_ADamagePercent[0];
				m_WeaponStats.m_fInitAccuracyPercent=SecondaryWeaponClass.Default.m_AAccuracyPercent[0];
				m_WeaponStats.m_fInitRecoilPercent=SecondaryWeaponClass.Default.m_ARecoilPercent[0];
				m_WeaponStats.m_fInitRecoveryPercent=SecondaryWeaponClass.Default.m_ARecoveryPercent[0];
				m_WeaponStats.m_fRangePercent=m_WeaponStats.m_fInitRangePercent;
				m_WeaponStats.m_fDamagePercent=m_WeaponStats.m_fInitDamagePercent;
				m_WeaponStats.m_fAccuracyPercent=m_WeaponStats.m_fInitAccuracyPercent;
				m_WeaponStats.m_fRecoilPercent=m_WeaponStats.m_fInitRecoilPercent;
				m_WeaponStats.m_fRecoveryPercent=m_WeaponStats.m_fInitRecoveryPercent;
				WeaponGadgetDescriptionClass=GetCurrentWeaponGadget(False);
				if ( WeaponGadgetDescriptionClass != Class'R6DescWeaponGadgetNone' )
				{
					i=0;
JL068F:
					if ( i < SecondaryWeaponClass.Default.m_WeaponTags.Length )
					{
						if ( SecondaryWeaponClass.Default.m_WeaponTags[i] == WeaponGadgetDescriptionClass.Default.m_NameTag )
						{
							m_WeaponStats.m_fRangePercent=SecondaryWeaponClass.Default.m_ARangePercent[i];
							m_WeaponStats.m_fDamagePercent=SecondaryWeaponClass.Default.m_ADamagePercent[i];
							m_WeaponStats.m_fAccuracyPercent=SecondaryWeaponClass.Default.m_AAccuracyPercent[i];
							m_WeaponStats.m_fRecoilPercent=SecondaryWeaponClass.Default.m_ARecoilPercent[i];
							m_WeaponStats.m_fRecoveryPercent=SecondaryWeaponClass.Default.m_ARecoveryPercent[i];
						}
						else
						{
							i++;
							goto JL068F;
						}
					}
				}
				m_WeaponStats.ResizeCharts();
				break;
				case 8:
				SelectedItem=R6WindowListBoxItem(m_listBox.m_SelectedItem);
				ArmorDescriptionClass=Class<R6ArmorDescription>(SelectedItem.m_Object);
				NewString=Localize(ArmorDescriptionClass.Default.m_NameID,"ID_Description","R6Armor",False,True);
				NotifyEquipmentChanged(m_CurrentEquipmentType,ArmorDescriptionClass);
				break;
				default:
			}
			break;
			case m_AnchorButtons.m_ASSAULTButton:
			case m_AnchorButtons.m_LMGButton:
			case m_AnchorButtons.m_SHOTGUNButton:
			case m_AnchorButtons.m_SNIPERButton:
			case m_AnchorButtons.m_SUBGUNButton:
			case m_AnchorButtons.m_PISTOLSButton:
			case m_AnchorButtons.m_MACHINEPISTOLSButton:
			case m_AnchorButtons.m_GRENADESButton:
			case m_AnchorButtons.m_EXPLOSIVESButton:
			case m_AnchorButtons.m_HBDEVICEButton:
			case m_AnchorButtons.m_KITSButton:
			case m_AnchorButtons.m_GENERALButton:
			itemPos=R6WindowListBoxItem(m_listBox.Items).FindItemIndex(R6WindowListBoxAnchorButton(C).AnchoredElement);
			if ( itemPos >= 0 )
			{
				m_listBox.m_VertSB.pos=0.00;
				m_listBox.m_VertSB.Scroll(itemPos);
			}
			break;
			default:
		}
	}
	if ( (m_EquipmentText != None) && (NewString != "") )
	{
		m_EquipmentText.Clear(True,True);
		m_EquipmentText.AddText(NewString,m_DescriptionTextColor,m_DescriptionTextFont);
	}
}

function enableWeaponStats (bool _enable)
{
	if ( _enable )
	{
		m_Buttons.ShowWindow();
		m_EquipmentText.WinTop=m_WeaponStats.WinTop;
		m_EquipmentText.WinHeight=m_WeaponStats.WinHeight;
		m_EquipmentText.Resize();
		ChangePage(1);
	}
	else
	{
		m_WeaponStats.HideWindow();
		m_EquipmentText.WinTop=m_listBox.WinTop + m_listBox.WinHeight - 1;
		m_EquipmentText.WinHeight=WinHeight - m_EquipmentText.WinTop;
		m_EquipmentText.Resize();
		m_EquipmentText.ShowWindow();
		m_Buttons.HideWindow();
	}
}

function ChangePage (int _Page)
{
	switch (_Page)
	{
		case 0:
		m_WeaponStats.HideWindow();
		m_EquipmentText.ShowWindow();
		break;
		case 1:
		m_WeaponStats.ShowWindow();
		m_EquipmentText.HideWindow();
		break;
		default:
		m_WeaponStats.HideWindow();
		m_EquipmentText.ShowWindow();
	}
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_bDrawListBg )
	{
		R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,m_listBox.WinLeft,m_listBox.WinTop,m_listBox.WinWidth,m_listBox.WinHeight);
	}
}

function SortDescriptions (bool _bAscending, out array<Class> Descriptions, string LocalizationFile, optional bool bUseTags)
{
	local int i;
	local int j;
	local Class temp;
	local bool bSwap;

	i=0;
JL0007:
	if ( i < Descriptions.Length - 1 )
	{
		j=0;
JL0021:
		if ( j < Descriptions.Length - 1 - i )
		{
			if ( bUseTags )
			{
				if ( _bAscending )
				{
					bSwap=Caps(Class<R6Description>(Descriptions[j]).Default.m_NameTag) > Caps(Class<R6Description>(Descriptions[j + 1]).Default.m_NameTag);
				}
				else
				{
					bSwap=Caps(Class<R6Description>(Descriptions[j]).Default.m_NameTag) < Caps(Class<R6Description>(Descriptions[j + 1]).Default.m_NameTag);
				}
			}
			else
			{
				if ( _bAscending )
				{
					bSwap=Caps(Localize(Class<R6Description>(Descriptions[j]).Default.m_NameID,"ID_NAME",LocalizationFile)) > Caps(Localize(Class<R6Description>(Descriptions[j + 1]).Default.m_NameID,"ID_NAME",LocalizationFile));
				}
				else
				{
					bSwap=Caps(Localize(Class<R6Description>(Descriptions[j]).Default.m_NameID,"ID_NAME",LocalizationFile)) < Caps(Localize(Class<R6Description>(Descriptions[j + 1]).Default.m_NameID,"ID_NAME",LocalizationFile));
				}
			}
			if ( bSwap )
			{
				temp=Descriptions[j];
				Descriptions[j]=Descriptions[j + 1];
				Descriptions[j + 1]=temp;
			}
			j++;
			goto JL0021;
		}
		i++;
		goto JL0007;
	}
}

function ShowWindow ()
{
	m_listBox.SetAcceptsFocus();
	Super.ShowWindow();
}

defaultproperties
{
    m_bDrawListBg=True
    m_fListBoxLabelHeight=17.00
    m_fListBoxHeight=136.00
    m_fAnchorAreaHeight=23.00
}
