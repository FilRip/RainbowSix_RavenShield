//================================================================================
// R6MenuMPAdvEquipmentDetailControl.
//================================================================================
class R6MenuMPAdvEquipmentDetailControl extends R6MenuEquipmentDetailControl;

var int m_iLastListIndex;
var array<Class> m_ADefaultPrimaryWeapons;
var array<Class> m_ADefaultSecondaryWeapons;
var array<Class> m_ADefaultGadgets;
var array<string> m_ADefaultWpnGadget;
var array<string> m_APriWpnGadget;
var array<string> m_ASecWpnGadget;

function Created ()
{
	local Color labelFontColor;
	local Color co;
	local Texture BorderTexture;

	labelFontColor=Root.Colors.White;
	m_Title=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,m_fListBoxLabelHeight,self));
	m_Title.align=ta_center;
	m_Title.m_Font=Root.Fonts[6];
	m_Title.TextColor=labelFontColor;
	m_Title.m_BGTexture=None;
	m_listBox=R6WindowTextListBox(CreateControl(Class'R6WindowTextListBox',0.00,m_Title.WinTop + m_Title.WinHeight - 1,WinWidth,m_fListBoxHeight));
	m_listBox.ListClass=Class'R6WindowListBoxItem';
	m_listBox.m_VertSB.SetHideWhenDisable(True);
	m_listBox.m_Font=m_Title.m_Font;
//	m_listBox.SetCornerType(0);
	m_WeaponStats=R6MenuWeaponStats(CreateWindow(Class'R6MenuWeaponStats',0.00,m_listBox.WinTop + m_listBox.WinHeight,WinWidth,WinHeight - m_listBox.WinTop - m_listBox.WinHeight,self));
	m_WeaponStats.m_bDrawBorders=False;
	m_WeaponStats.m_bDrawBG=False;
	m_WeaponStats.HideWindow();
	m_CurrentEquipmentType=-1;
	BuildAvailableEquipment();
	m_AnchorButtons=R6MenuEquipmentAnchorButtons(CreateControl(Class'R6MenuEquipmentAnchorButtons',0.00,0.00,WinWidth,m_fAnchorAreaHeight,self));
	m_AnchorButtons.m_bDrawBorders=False;
	m_AnchorButtons.m_fPrimarWTabOffset=3.00;
	m_AnchorButtons.m_fGrenadesOffset=3.00;
	m_AnchorButtons.m_fPistolOffset=3.00;
	m_AnchorButtons.Resize();
	m_AnchorButtons.HideWindow();
}

function R6Operative GetCurrentOperative ()
{
	return R6MenuMPAdvGearWidget(OwnerWindow).m_currentOperative;
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

function Class<R6GadgetDescription> GetCurrentGadget (bool _Primary)
{
	if ( _Primary == True )
	{
		return R6MenuMPAdvGearWidget(OwnerWindow).m_OpFirstGadgetDesc;
	}
	else
	{
		return R6MenuMPAdvGearWidget(OwnerWindow).m_OpSecondGadgetDesc;
	}
}

function NotifyEquipmentChanged (int EquipmentSelected, Class<R6Description> DecriptionClass)
{
	R6MenuMPAdvGearWidget(OwnerWindow).EquipmentChanged(EquipmentSelected,DecriptionClass);
}

function FillListBox (int _equipmentType)
{
	local Class<R6PrimaryWeaponDescription> PrimaryWeaponClass;
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;
	local Class<R6BulletDescription> WeaponBulletDescriptionClass;
	local Class<R6GadgetDescription> GadgetClass;
	local Class<R6WeaponGadgetDescription> WeaponGadgetDescriptionClass;
	local UWindowList FindItem;
	local R6WindowListBoxItem NewItem;
	local R6WindowListBoxItem SelectedItem;
	local R6WindowListBoxItem FirstInsertedItem;
	local R6WindowListBoxItem OldSelectedItem;
	local R6Operative currentOperative;
	local int i;
	local int j;
	local int OldVertSBPos;
	local bool bRestricted;
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local R6ModMgr pModManager;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	currentOperative=GetCurrentOperative();
	SelectedItem=None;
	if ( m_listBox.m_SelectedItem != None )
	{
		if ( m_iLastListIndex == _equipmentType )
		{
			OldSelectedItem=R6WindowListBoxItem(m_listBox.m_SelectedItem);
		}
	}
	OldVertSBPos=m_listBox.m_VertSB.pos;
	pModManager=Class'Actor'.static.GetModMgr();
	switch (_equipmentType)
	{
		case 0:
		Super.FillListBox(0);
		break;
		case 1:
		m_Title.SetNewText(Localize("GearRoom","PrimaryWeaponGadget","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(3);
		PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(DynamicLoadObject(currentOperative.m_szPrimaryWeapon,Class'Class'));
		i=0;
JL0128:
		if ( i < PrimaryWeaponClass.Default.m_MyGadgets.Length )
		{
			WeaponGadgetDescriptionClass=Class<R6WeaponGadgetDescription>(PrimaryWeaponClass.Default.m_MyGadgets[i]);
			bRestricted=False;
			j=0;
JL016F:
			if ( j < 32 )
			{
				if ( R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szGadgPrimaryRes[j] == WeaponGadgetDescriptionClass.Default.m_NameID )
				{
					bRestricted=True;
				}
				j++;
				goto JL016F;
			}
			if ( (WeaponGadgetDescriptionClass != Class'R6DescWeaponGadgetNone') && WeaponGadgetDescriptionClass.Default.m_bPriGadgetWAvailable &&  !bRestricted )
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
			goto JL0128;
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
		if ( SelectedItem != None )
		{
			m_listBox.SetSelectedItem(SelectedItem);
			m_listBox.MakeSelectedVisible();
		}
		break;
		case 2:
		Super.FillListBox(2);
		break;
		case 3:
		Super.FillListBox(3);
		break;
		case 4:
		Super.FillListBox(4);
		break;
		case 5:
		m_Title.SetNewText(Localize("GearRoom","SecondaryWeaponGadget","R6Menu"),True);
		m_listBox.Clear();
//		UpdateAnchorButtons(3);
		SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(DynamicLoadObject(currentOperative.m_szSecondaryWeapon,Class'Class'));
		i=0;
JL044B:
		if ( i < SecondaryWeaponClass.Default.m_MyGadgets.Length )
		{
			WeaponGadgetDescriptionClass=Class<R6WeaponGadgetDescription>(SecondaryWeaponClass.Default.m_MyGadgets[i]);
			bRestricted=False;
			j=0;
JL0492:
			if ( j < 32 )
			{
				if ( R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szGadgSecondayRes[j] == WeaponGadgetDescriptionClass.Default.m_NameID )
				{
					bRestricted=True;
				}
				j++;
				goto JL0492;
			}
			if ( (WeaponGadgetDescriptionClass != Class'R6DescWeaponGadgetNone') && WeaponGadgetDescriptionClass.Default.m_bSecGadgetWAvailable &&  !bRestricted )
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
			goto JL044B;
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
		if ( SelectedItem != None )
		{
			m_listBox.SetSelectedItem(SelectedItem);
			m_listBox.MakeSelectedVisible();
		}
		break;
		case 6:
		Super.FillListBox(6);
		break;
		case 7:
		Super.FillListBox(7);
		break;
		case 8:
		break;
		default:
	}
	if ( m_listBox.m_SelectedItem != None )
	{
		if ( R6WindowListBoxItem(m_listBox.m_SelectedItem) != OldSelectedItem )
		{
			if ( OldSelectedItem != None )
			{
				FindItem=m_listBox.FindItemWithName(OldSelectedItem.HelpText);
				if ( FindItem != None )
				{
					SelectedItem=R6WindowListBoxItem(FindItem);
				}
			}
		}
	}
	if ( SelectedItem != None )
	{
		m_listBox.SetSelectedItem(SelectedItem);
		m_listBox.m_VertSB.pos=OldVertSBPos;
	}
	m_listBox.ShowWindow();
	m_iLastListIndex=_equipmentType;
}

function enableWeaponStats (bool _enable)
{
	if ( _enable )
	{
		m_WeaponStats.ShowWindow();
		m_listBox.SetSize(m_listBox.WinWidth,WinHeight - m_listBox.WinTop - m_WeaponStats.WinHeight);
	}
	else
	{
		m_WeaponStats.HideWindow();
		m_listBox.SetSize(m_listBox.WinWidth,WinHeight - m_listBox.WinTop);
	}
}

function UpdateAnchorButtons (eAnchorEquipmentType _AEType)
{
	if ( _AEType == 3 )
	{
		m_AnchorButtons.HideWindow();
		m_Title.WinTop=0.00;
		m_Title.m_bDrawBorders=False;
		m_listBox.WinTop=m_Title.WinTop + m_Title.WinHeight - 1;
		m_listBox.SetSize(m_listBox.WinWidth,m_fListBoxHeight);
	}
	else
	{
		m_AnchorButtons.ShowWindow();
//		m_AnchorButtons.DisplayButtons(_AEType);
		m_Title.WinTop=m_AnchorButtons.WinTop + m_AnchorButtons.WinHeight;
		m_Title.m_bDrawBorders=True;
		m_listBox.WinTop=m_Title.WinTop + m_Title.WinHeight - 1;
		m_listBox.SetSize(m_listBox.WinWidth,m_fListBoxHeight - m_AnchorButtons.WinHeight);
	}
}

function BuildAvailableEquipment ()
{
	local Class<R6PrimaryWeaponDescription> PrimaryWeaponClass;
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;
	local Class<R6GadgetDescription> GadgetClass;
	local Class<R6WeaponGadgetDescription> WeaponGadgetClass;
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local int i;
	local int j;
	local int k;
	local bool bFound;
	local bool bEquipValid;
	local R6Mod pCurrentMod;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if ( (r6Root.m_R6GameMenuCom == None) || (r6Root.m_R6GameMenuCom.m_GameRepInfo == None) )
	{
		return;
	}
	m_APrimaryWeapons.Remove (0,m_APrimaryWeapons.Length);
	m_ASecondaryWeapons.Remove (0,m_ASecondaryWeapons.Length);
	m_AGadgets.Remove (0,m_AGadgets.Length);
	m_APriWpnGadget.Remove (0,m_APriWpnGadget.Length);
	m_ASecWpnGadget.Remove (0,m_ASecWpnGadget.Length);
	GetAllPrimaryWeapon();
	CompareGearItemsWithServerRest(R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szSubMachineGunsRes,m_APrimaryWeapons);
	CompareGearItemsWithServerRest(R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szShotGunRes,m_APrimaryWeapons);
	CompareGearItemsWithServerRest(R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szAssRifleRes,m_APrimaryWeapons);
	CompareGearItemsWithServerRest(R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szMachGunRes,m_APrimaryWeapons);
	CompareGearItemsWithServerRest(R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szSnipRifleRes,m_APrimaryWeapons);
	SortDescriptions(True,m_APrimaryWeapons,"R6Weapons");
	GetAllWeaponGadget();
	i=0;
JL01A0:
	if ( i < 32 )
	{
		j=0;
JL01B3:
		if ( j < m_APriWpnGadget.Length )
		{
			if ( R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szGadgPrimaryRes[i] == m_APriWpnGadget[j] )
			{
				m_APriWpnGadget.Remove (j,1);
			}
			j++;
			goto JL01B3;
		}
		i++;
		goto JL01A0;
	}
	GetAllGadgets();
	CompareGearItemsWithServerRest(R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szGadgMiscRes,m_AGadgets);
	SortDescriptions(True,m_AGadgets,"R6Gadgets");
	GetAllSecondaryWeapon();
	CompareGearItemsWithServerRest(R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szPistolRes,m_ASecondaryWeapons);
	CompareGearItemsWithServerRest(R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szMachPistolRes,m_ASecondaryWeapons);
	SortDescriptions(True,m_ASecondaryWeapons,"R6Weapons");
	i=0;
JL02EF:
	if ( i < 32 )
	{
		j=0;
JL0302:
		if ( j < m_ASecWpnGadget.Length )
		{
			if ( R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).m_szGadgSecondayRes[i] == m_ASecWpnGadget[j] )
			{
				m_ASecWpnGadget.Remove (j,1);
			}
			j++;
			goto JL0302;
		}
		i++;
		goto JL02EF;
	}
}

function CompareGearItemsWithServerRest (string _AServerRest[32], out array<Class> _AGearItems)
{
	local int i;
	local int j;
	local int iSizeOfServRestArray;
	local bool bFound;

	iSizeOfServRestArray=32;
	i=0;
JL000F:
	if ( i < iSizeOfServRestArray )
	{
		bFound=False;
		j=0;
JL002D:
		if ( (j < _AGearItems.Length) &&  !bFound )
		{
			if ( _AServerRest[i] == Class<R6Description>(_AGearItems[j]).Default.m_NameID )
			{
				bFound=True;
				_AGearItems.Remove (j,1);
			}
			j++;
			goto JL002D;
		}
		i++;
		goto JL000F;
	}
}

function GetAllPrimaryWeapon ()
{
	local Class<R6PrimaryWeaponDescription> PrimaryWeaponClass;
	local int i;
	local bool bEquipValid;
	local int j;
	local R6Mod pCurrentMod;

	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	if ( m_ADefaultPrimaryWeapons.Length == 0 )
	{
		i=0;
		j=0;
JL0035:
		if ( j < pCurrentMod.m_aDescriptionPackage.Length )
		{
			PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[j] $ ".u",Class'R6PrimaryWeaponDescription'));
JL007B:
			if ( PrimaryWeaponClass != None )
			{
				bEquipValid=PrimaryWeaponClass.Default.m_NameID != "NONE";
				if ( bEquipValid )
				{
					m_APrimaryWeapons[i]=PrimaryWeaponClass;
					m_ADefaultPrimaryWeapons[i]=PrimaryWeaponClass;
					i++;
				}
				PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(GetNextClass());
				goto JL007B;
			}
			FreePackageObjects();
			j++;
			goto JL0035;
		}
	}
	else
	{
		i=0;
JL00FD:
		if ( i < m_ADefaultPrimaryWeapons.Length )
		{
			m_APrimaryWeapons[i]=m_ADefaultPrimaryWeapons[i];
			i++;
			goto JL00FD;
		}
	}
}

function GetAllSecondaryWeapon ()
{
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;
	local int i;
	local bool bEquipValid;
	local int j;
	local R6Mod pCurrentMod;

	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	if ( m_ADefaultSecondaryWeapons.Length == 0 )
	{
		i=0;
		j=0;
JL0035:
		if ( j < pCurrentMod.m_aDescriptionPackage.Length )
		{
			SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[j] $ ".u",Class'R6SecondaryWeaponDescription'));
JL007B:
			if ( SecondaryWeaponClass != None )
			{
				bEquipValid=SecondaryWeaponClass.Default.m_NameID != "NONE";
				if ( bEquipValid )
				{
					m_ASecondaryWeapons[i]=SecondaryWeaponClass;
					m_ADefaultSecondaryWeapons[i]=SecondaryWeaponClass;
					i++;
				}
				SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(GetNextClass());
				goto JL007B;
			}
			FreePackageObjects();
			j++;
			goto JL0035;
		}
	}
	else
	{
		i=0;
JL00FD:
		if ( i < m_ADefaultSecondaryWeapons.Length )
		{
			m_ASecondaryWeapons[i]=m_ADefaultSecondaryWeapons[i];
			i++;
			goto JL00FD;
		}
	}
}

function GetAllGadgets ()
{
	local Class<R6GadgetDescription> GadgetClass;
	local int i;
	local bool bEquipValid;
	local int j;
	local R6Mod pCurrentMod;

	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	if ( m_ADefaultGadgets.Length == 0 )
	{
		i=0;
		j=0;
JL0035:
		if ( j < pCurrentMod.m_aDescriptionPackage.Length )
		{
			GadgetClass=Class<R6GadgetDescription>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[j] $ ".u",Class'R6GadgetDescription'));
JL007B:
			if ( GadgetClass != None )
			{
				bEquipValid=GadgetClass.Default.m_NameID != "NONE";
				if ( bEquipValid )
				{
					m_AGadgets[i]=GadgetClass;
					m_ADefaultGadgets[i]=GadgetClass;
					i++;
				}
				GadgetClass=Class<R6GadgetDescription>(GetNextClass());
				goto JL007B;
			}
			FreePackageObjects();
			j++;
			goto JL0035;
		}
	}
	else
	{
		i=0;
JL00FD:
		if ( i < m_ADefaultGadgets.Length )
		{
			m_AGadgets[i]=m_ADefaultGadgets[i];
			i++;
			goto JL00FD;
		}
	}
}

function GetAllWeaponGadget ()
{
	local Class<R6WeaponGadgetDescription> WeaponGadgetClass;
	local array<string> ATemp;
	local int i;
	local int k;
	local bool bEquipValid;
	local bool bFound;
	local int j;
	local R6Mod pCurrentMod;

	pCurrentMod=Class'Actor'.static.GetModMgr().m_pCurrentMod;
	if ( m_ADefaultWpnGadget.Length == 0 )
	{
		WeaponGadgetClass=Class'R6DescWeaponGadgetNone';
		m_APriWpnGadget[0]=WeaponGadgetClass.Default.m_NameID;
		m_ASecWpnGadget[0]=WeaponGadgetClass.Default.m_NameID;
		m_ADefaultWpnGadget[0]=m_APriWpnGadget[0];
		i=1;
		j=0;
JL007B:
		if ( j < pCurrentMod.m_aDescriptionPackage.Length )
		{
			WeaponGadgetClass=Class<R6WeaponGadgetDescription>(GetFirstPackageClass(pCurrentMod.m_aDescriptionPackage[j] $ ".u",Class'R6WeaponGadgetDescription'));
JL00C1:
			if ( WeaponGadgetClass != None )
			{
				bEquipValid=(WeaponGadgetClass.Default.m_NameID != "NONE") && WeaponGadgetClass.Default.m_bPriGadgetWAvailable;
				if ( bEquipValid )
				{
					bFound=False;
					k=0;
JL0115:
					if ( (k < m_APriWpnGadget.Length) &&  !bFound )
					{
						if ( WeaponGadgetClass.Default.m_NameID == m_APriWpnGadget[k] )
						{
							bFound=True;
						}
						k++;
						goto JL0115;
					}
					if (  !bFound )
					{
						m_APriWpnGadget[i]=WeaponGadgetClass.Default.m_NameID;
						m_ASecWpnGadget[i]=WeaponGadgetClass.Default.m_NameID;
						m_ADefaultWpnGadget[i]=WeaponGadgetClass.Default.m_NameID;
						i++;
					}
				}
				WeaponGadgetClass=Class<R6WeaponGadgetDescription>(GetNextClass());
				goto JL00C1;
			}
			FreePackageObjects();
			j++;
			goto JL007B;
		}
	}
	else
	{
		i=0;
JL01EA:
		if ( i < m_ADefaultWpnGadget.Length )
		{
			m_APriWpnGadget[i]=m_ADefaultWpnGadget[i];
			m_ASecWpnGadget[i]=m_ADefaultWpnGadget[i];
			i++;
			goto JL01EA;
		}
	}
}

defaultproperties
{
    m_iLastListIndex=-1
    m_bDrawListBg=False
}
