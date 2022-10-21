//================================================================================
// R6MenuGearWidget.
//================================================================================
class R6MenuGearWidget extends R6MenuLaptopWidget;

enum eOperativeTeam {
	Red_Team,
	Green_Team,
	Gold_Team,
	No_Team
};

enum e2DEquipment {
	Primary_Weapon,
	Primary_WeaponGadget,
	Primary_Bullet,
	Primary_Gadget,
	Secondary_Weapon,
	Secondary_WeaponGadget,
	Secondary_Bullet,
	Secondary_Gadget,
	Armor,
	All_Primary,
	All_Secondary,
	All_PrimaryGadget,
	All_SecondaryGadget,
	All_Armor,
	All_ToAll
};

var eOperativeTeam m_currentOperativeTeam;
var int m_IRosterListLeftPad;
var bool bShowLog;
var float m_fPaddingBetweenElements;
var R6WindowTextLabel m_CodeName;
var R6WindowTextLabel m_DateTime;
var R6WindowTextLabel m_Location;
var Font m_labelFont;
var R6MenuDynTeamListsControl m_RosterListCtrl;
var R6MenuOperativeDetailControl m_OperativeDetails;
var R6MenuEquipmentSelectControl m_Equipment2dSelect;
var R6MenuEquipmentDetailControl m_EquipmentDetails;
var R6Operative m_currentOperative;
var Class<R6PrimaryWeaponDescription> m_OpFirstWeaponDesc;
var Class<R6SecondaryWeaponDescription> m_OpSecondaryWeaponDesc;
var Class<R6WeaponGadgetDescription> m_OpFirstWeaponGadgetDesc;
var Class<R6WeaponGadgetDescription> m_OpSecondWeaponGadgetDesc;
var Class<R6BulletDescription> m_OpFirstWeaponBulletDesc;
var Class<R6BulletDescription> m_OpSecondWeaponBulletDesc;
var Class<R6GadgetDescription> m_OpFirstGadgetDesc;
var Class<R6GadgetDescription> m_OpSecondGadgetDesc;
var Class<R6ArmorDescription> m_OpArmorDesc;

function Created ()
{
	local int labelWidth;
	local Region R;

	Super.Created();
	m_labelFont=Root.Fonts[9];
	labelWidth=(m_Right.WinLeft - m_Left.WinWidth) / 3;
	labelWidth=(m_Right.WinLeft - m_Left.WinWidth) / 3;
	m_CodeName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_Left.WinWidth,m_Top.WinHeight,labelWidth,18.00,self));
	m_DateTime=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_CodeName.WinLeft + m_CodeName.WinWidth,m_Top.WinHeight,labelWidth,18.00,self));
	m_Location=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_DateTime.WinLeft + m_DateTime.WinWidth,m_Top.WinHeight,m_DateTime.WinWidth,18.00,self));
	m_RosterListCtrl=R6MenuDynTeamListsControl(CreateWindow(Class'R6MenuDynTeamListsControl',m_Left.WinWidth + m_IRosterListLeftPad,m_CodeName.WinTop + m_CodeName.WinHeight,199.00,m_HelpTextBar.WinTop - m_CodeName.WinTop + m_CodeName.WinHeight - 2,self));
	m_OperativeDetails=R6MenuOperativeDetailControl(CreateWindow(Class'R6MenuOperativeDetailControl',430.00,m_RosterListCtrl.WinTop,189.00,339.00,self));
	m_OperativeDetails.HideWindow();
	m_EquipmentDetails=R6MenuEquipmentDetailControl(CreateWindow(Class'R6MenuEquipmentDetailControl',430.00,m_RosterListCtrl.WinTop,189.00,339.00,self));
	m_EquipmentDetails.HideWindow();
	m_Equipment2dSelect=R6MenuEquipmentSelectControl(CreateWindow(Class'R6MenuEquipmentSelectControl',222.00,m_RosterListCtrl.WinTop,206.00,339.00,self));
	m_NavBar.m_GearButton.bDisabled=True;
}

function ShowWindow ()
{
	local R6GameOptions pGameOptions;

	Super.ShowWindow();
	if ( R6MenuRootWindow(Root).m_bPlayerPlanInitialized == False )
	{
		pGameOptions=Class'Actor'.static.GetGameOptions();
		if ( pGameOptions.PopUpLoadPlan == True )
		{
//			R6MenuRootWindow(Root).m_ePopUpID=43;
			R6MenuRootWindow(Root).PopUpMenu(True);
		}
	}
}

function Reset ()
{
	local R6MissionDescription CurrentMission;

	CurrentMission=R6MissionDescription(R6Console(Root.Console).Master.m_StartGameInfo.m_CurrentMission);
/*	m_CodeName.SetProperties(Localize(CurrentMission.m_MapName,"ID_CODENAME",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);
	m_DateTime.SetProperties(Localize(CurrentMission.m_MapName,"ID_DATETIME",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);
	m_Location.SetProperties(Localize(CurrentMission.m_MapName,"ID_LOCATION",CurrentMission.LocalizationFile),2,m_labelFont,Root.Colors.White,False);*/
	m_EquipmentDetails.BuildAvailableMissionArmors();
	m_RosterListCtrl.FillRosterList();
}

function OperativeSelected (R6Operative selectedOperative, eOperativeTeam _selectedTeam, optional UWindowWindow _pActiveWindow)
{
	m_EquipmentDetails.HideWindow();
	m_currentOperative=selectedOperative;
	m_OpFirstWeaponDesc=Class<R6PrimaryWeaponDescription>(DynamicLoadObject(m_currentOperative.m_szPrimaryWeapon,Class'Class'));
	m_OpFirstWeaponGadgetDesc=Class'R6DescriptionManager'.static.GetPrimaryWeaponGadgetDesc(m_OpFirstWeaponDesc,m_currentOperative.m_szPrimaryWeaponGadget);
	m_OpFirstWeaponBulletDesc=Class'R6DescriptionManager'.static.GetPrimaryBulletDesc(m_OpFirstWeaponDesc,m_currentOperative.m_szPrimaryWeaponBullet);
	m_OpSecondaryWeaponDesc=Class<R6SecondaryWeaponDescription>(DynamicLoadObject(m_currentOperative.m_szSecondaryWeapon,Class'Class'));
	m_OpSecondWeaponGadgetDesc=Class'R6DescriptionManager'.static.GetSecondaryWeaponGadgetDesc(m_OpSecondaryWeaponDesc,m_currentOperative.m_szSecondaryWeaponGadget);
	m_OpSecondWeaponBulletDesc=Class'R6DescriptionManager'.static.GetSecondaryBulletDesc(m_OpSecondaryWeaponDesc,m_currentOperative.m_szSecondaryWeaponBullet);
	m_OpFirstGadgetDesc=Class<R6GadgetDescription>(DynamicLoadObject(m_currentOperative.m_szPrimaryGadget,Class'Class'));
	m_OpSecondGadgetDesc=Class<R6GadgetDescription>(DynamicLoadObject(m_currentOperative.m_szSecondaryGadget,Class'Class'));
	m_OpArmorDesc=Class<R6ArmorDescription>(DynamicLoadObject(m_currentOperative.m_szArmor,Class'Class'));
	m_OperativeDetails.ShowWindow();
	m_OperativeDetails.UpdateDetails();
	m_Equipment2dSelect.UpdateDetails();
	m_currentOperativeTeam=_selectedTeam;
	m_Equipment2dSelect.DisableControls(m_currentOperativeTeam == 3);
	if ( bWindowVisible && (_pActiveWindow != None) )
	{
		_pActiveWindow.ActivateWindow(0,False);
	}
}

function SetupOperative (out R6Operative OpToChek)
{
	local Class<R6ArmorDescription> currentArmor;

	currentArmor=Class<R6ArmorDescription>(DynamicLoadObject(OpToChek.m_szArmor,Class'Class'));
	if ( m_EquipmentDetails.IsAmorAvailable(currentArmor,OpToChek) == False )
	{
		OpToChek.m_szArmor=string(m_EquipmentDetails.GetDefaultArmor());
	}
}

function EquipmentSelected (e2DEquipment EquipmentSelected)
{
	local R6WindowTextIconsListBox listboxes[3];
	local R6Operative tmpOperative;
	local R6WindowListBoxItem tmpItem;
	local int i;

	listboxes[0]=m_RosterListCtrl.m_RedListBox.m_listBox;
	listboxes[1]=m_RosterListCtrl.m_GreenListBox.m_listBox;
	listboxes[2]=m_RosterListCtrl.m_GoldListBox.m_listBox;
	switch (EquipmentSelected)
	{
/*		case 9:
		tmpItem=R6WindowListBoxItem(listboxes[m_currentOperativeTeam].Items.Next);
JL0094:
		if ( tmpItem != None )
		{
			tmpOperative=R6Operative(tmpItem.m_Object);
			if ( tmpOperative != None )
			{
				tmpOperative.m_szPrimaryWeapon=m_currentOperative.m_szPrimaryWeapon;
				tmpOperative.m_szPrimaryWeaponBullet=m_currentOperative.m_szPrimaryWeaponBullet;
				tmpOperative.m_szPrimaryWeaponGadget=m_currentOperative.m_szPrimaryWeaponGadget;
			}
			tmpItem=R6WindowListBoxItem(tmpItem.Next);
			goto JL0094;
		}
		break;
		case 10:
		tmpItem=R6WindowListBoxItem(listboxes[m_currentOperativeTeam].Items.Next);
JL0168:
		if ( tmpItem != None )
		{
			tmpOperative=R6Operative(tmpItem.m_Object);
			if ( tmpOperative != None )
			{
				tmpOperative.m_szSecondaryWeapon=m_currentOperative.m_szSecondaryWeapon;
				tmpOperative.m_szSecondaryWeaponBullet=m_currentOperative.m_szSecondaryWeaponBullet;
				tmpOperative.m_szSecondaryWeaponGadget=m_currentOperative.m_szSecondaryWeaponGadget;
			}
			tmpItem=R6WindowListBoxItem(tmpItem.Next);
			goto JL0168;
		}
		break;
		case 11:
		tmpItem=R6WindowListBoxItem(listboxes[m_currentOperativeTeam].Items.Next);
JL023C:
		if ( tmpItem != None )
		{
			tmpOperative=R6Operative(tmpItem.m_Object);
			if ( tmpOperative != None )
			{
				tmpOperative.m_szPrimaryGadget=m_currentOperative.m_szPrimaryGadget;
			}
			tmpItem=R6WindowListBoxItem(tmpItem.Next);
			goto JL023C;
		}
		break;
		case 12:
		tmpItem=R6WindowListBoxItem(listboxes[m_currentOperativeTeam].Items.Next);
JL02D6:
		if ( tmpItem != None )
		{
			tmpOperative=R6Operative(tmpItem.m_Object);
			if ( tmpOperative != None )
			{
				tmpOperative.m_szSecondaryGadget=m_currentOperative.m_szSecondaryGadget;
			}
			tmpItem=R6WindowListBoxItem(tmpItem.Next);
			goto JL02D6;
		}
		break;
		case 13:
		tmpItem=R6WindowListBoxItem(listboxes[m_currentOperativeTeam].Items.Next);
JL0370:
		if ( tmpItem != None )
		{
			tmpOperative=R6Operative(tmpItem.m_Object);
			if ( tmpOperative != None )
			{
				tmpOperative.m_szArmor=m_currentOperative.m_szArmor;
			}
			tmpItem=R6WindowListBoxItem(tmpItem.Next);
			goto JL0370;
		}
		break;
		case 14:
		i=0;
JL03E7:
		if ( i < 3 )
		{
			tmpItem=R6WindowListBoxItem(listboxes[i].Items.Next);
JL041B:
			if ( tmpItem != None )
			{
				tmpOperative=R6Operative(tmpItem.m_Object);
				if ( tmpOperative != None )
				{
					tmpOperative.m_szPrimaryWeapon=m_currentOperative.m_szPrimaryWeapon;
					tmpOperative.m_szPrimaryWeaponBullet=m_currentOperative.m_szPrimaryWeaponBullet;
					tmpOperative.m_szPrimaryWeaponGadget=m_currentOperative.m_szPrimaryWeaponGadget;
					tmpOperative.m_szSecondaryWeapon=m_currentOperative.m_szSecondaryWeapon;
					tmpOperative.m_szSecondaryWeaponBullet=m_currentOperative.m_szSecondaryWeaponBullet;
					tmpOperative.m_szSecondaryWeaponGadget=m_currentOperative.m_szSecondaryWeaponGadget;
					tmpOperative.m_szPrimaryGadget=m_currentOperative.m_szPrimaryGadget;
					tmpOperative.m_szSecondaryGadget=m_currentOperative.m_szSecondaryGadget;
					tmpOperative.m_szArmor=m_currentOperative.m_szArmor;
				}
				tmpItem=R6WindowListBoxItem(tmpItem.Next);
				goto JL041B;
			}
			i++;
			goto JL03E7;
		}
		break;
		default:
		m_OperativeDetails.HideWindow();
		m_EquipmentDetails.ShowWindow();
		m_EquipmentDetails.FillListBox(EquipmentSelected);
		break; */
	}
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
				Log("Changing" @ string(m_currentOperative.Class) @ " Primary Weapon for " @ m_currentOperative.m_szPrimaryWeapon);
			}
			DecriptionClass=Class'R6DescWeaponGadgetNone';
			m_currentOperative.m_szPrimaryWeaponGadget=DecriptionClass.Default.m_NameID;
			m_OpFirstWeaponGadgetDesc=Class<R6WeaponGadgetDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing" @ string(m_currentOperative.Class) @ " Primary Weapon Gadget for " @ m_currentOperative.m_szPrimaryWeaponGadget);
			}
			DecriptionClass=Class'R6DescriptionManager'.static.findPrimaryDefaultAmmo(Class<R6PrimaryWeaponDescription>(inDescriptionClass));
			m_currentOperative.m_szPrimaryWeaponBullet=DecriptionClass.Default.m_NameTag;
			m_OpFirstWeaponBulletDesc=Class<R6BulletDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing" @ string(m_currentOperative.Class) @ " Primary Weapon Bullets for " @ m_currentOperative.m_szPrimaryWeaponBullet);
			}
		}
		break;
		case 1:
		m_currentOperative.m_szPrimaryWeaponGadget=DecriptionClass.Default.m_NameID;
		m_OpFirstWeaponGadgetDesc=Class<R6WeaponGadgetDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing" @ string(m_currentOperative.Class) @ " Primary Weapon Gadget for " @ m_currentOperative.m_szPrimaryWeaponGadget);
		}
		break;
		case 2:
		m_currentOperative.m_szPrimaryWeaponBullet=DecriptionClass.Default.m_NameTag;
		m_OpFirstWeaponBulletDesc=Class<R6BulletDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing" @ string(m_currentOperative.Class) @ " Primary Weapon Bullets for " @ m_currentOperative.m_szPrimaryWeaponBullet);
		}
		break;
		case 3:
		m_currentOperative.m_szPrimaryGadget=string(DecriptionClass);
		m_OpFirstGadgetDesc=Class<R6GadgetDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing" @ string(m_currentOperative.Class) @ " Primary Gadget for " @ m_currentOperative.m_szPrimaryWeapon);
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
				Log("Changing" @ string(m_currentOperative.Class) @ " Secondary Weapon for " @ m_currentOperative.m_szSecondaryWeapon);
			}
			DecriptionClass=Class'R6DescWeaponGadgetNone';
			m_currentOperative.m_szSecondaryWeaponGadget=DecriptionClass.Default.m_NameID;
			m_OpSecondWeaponGadgetDesc=Class<R6WeaponGadgetDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing" @ string(m_currentOperative.Class) @ " Secondary Weapon Gadget for " @ m_currentOperative.m_szSecondaryWeaponGadget);
			}
			DecriptionClass=Class'R6DescriptionManager'.static.findSecondaryDefaultAmmo(Class<R6SecondaryWeaponDescription>(inDescriptionClass));
			m_currentOperative.m_szSecondaryWeaponBullet=DecriptionClass.Default.m_NameTag;
			m_OpSecondWeaponBulletDesc=Class<R6BulletDescription>(DecriptionClass);
			if ( bShowLog )
			{
				Log("Changing" @ string(m_currentOperative.Class) @ " Secondary Weapon Bullets for " @ m_currentOperative.m_szSecondaryWeaponBullet);
			}
		}
		break;
		case 5:
		m_currentOperative.m_szSecondaryWeaponGadget=DecriptionClass.Default.m_NameID;
		m_OpSecondWeaponGadgetDesc=Class<R6WeaponGadgetDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing" @ string(m_currentOperative.Class) @ " Secondary Weapon Gadget for " @ m_currentOperative.m_szSecondaryWeaponGadget);
		}
		break;
		case 6:
		m_currentOperative.m_szSecondaryWeaponBullet=DecriptionClass.Default.m_NameTag;
		m_OpSecondWeaponBulletDesc=Class<R6BulletDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing" @ string(m_currentOperative.Class) @ " Secondary Weapon Bullets for " @ m_currentOperative.m_szSecondaryWeaponBullet);
		}
		break;
		case 7:
		m_currentOperative.m_szSecondaryGadget=string(DecriptionClass);
		m_OpSecondGadgetDesc=Class<R6GadgetDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing" @ string(m_currentOperative.Class) @ " Secondary Gadget for " @ m_currentOperative.m_szSecondaryGadget);
		}
		break;
		case 8:
		m_currentOperative.m_szArmor=string(DecriptionClass);
		m_OpArmorDesc=Class<R6ArmorDescription>(DecriptionClass);
		if ( bShowLog )
		{
			Log("Changing" @ string(m_currentOperative.Class) @ " Armor for " @ m_currentOperative.m_szArmor);
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

function SetStartTeamInfo ()
{
	local R6StartGameInfo StartGameInfo;
	local int i;
	local int j;
	local int k;
	local int rainbowAdded;
	local R6WindowTextIconsListBox tmpListBox[3];
	local R6WindowTextIconsListBox currentListBox;
	local R6Operative tmpOperative;
	local R6WindowListBoxItem tmpItem;
	local string Tag;
	local Class<R6PrimaryWeaponDescription> PrimaryWeaponClass;
	local Class<R6SecondaryWeaponDescription> SecondaryWeaponClass;
	local Class<R6BulletDescription> PrimaryWeaponBulletClass;
	local Class<R6BulletDescription> SecondaryWeaponBulletClass;
	local Class<R6GadgetDescription> PrimaryGadgetClass;
	local Class<R6GadgetDescription> SecondaryGadgetClass;
	local Class<R6WeaponGadgetDescription> PrimaryWeaponGadgetClass;
	local Class<R6WeaponGadgetDescription> SecondaryWeaponGadgetClass;
	local Class<R6ArmorDescription> ArmorDescriptionClass;
	local bool Found;

	StartGameInfo=R6Console(Root.Console).Master.m_StartGameInfo;
	tmpListBox[0]=m_RosterListCtrl.m_RedListBox.m_listBox;
	tmpListBox[1]=m_RosterListCtrl.m_GreenListBox.m_listBox;
	tmpListBox[2]=m_RosterListCtrl.m_GoldListBox.m_listBox;
	j=0;
JL0090:
	if ( j < 3 )
	{
		currentListBox=tmpListBox[j];
		tmpItem=R6WindowListBoxItem(currentListBox.Items.Next);
		rainbowAdded=0;
		i=0;
JL00DD:
		if ( i < currentListBox.Items.Count() )
		{
			tmpOperative=R6Operative(tmpItem.m_Object);
			if ( tmpOperative != None )
			{
				PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(DynamicLoadObject(tmpOperative.m_szPrimaryWeapon,Class'Class'));
				PrimaryWeaponBulletClass=Class'R6DescriptionManager'.static.GetPrimaryBulletDesc(PrimaryWeaponClass,tmpOperative.m_szPrimaryWeaponBullet);
				PrimaryWeaponGadgetClass=Class'R6DescriptionManager'.static.GetPrimaryWeaponGadgetDesc(PrimaryWeaponClass,tmpOperative.m_szPrimaryWeaponGadget);
				SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(DynamicLoadObject(tmpOperative.m_szSecondaryWeapon,Class'Class'));
				SecondaryWeaponBulletClass=Class'R6DescriptionManager'.static.GetSecondaryBulletDesc(SecondaryWeaponClass,tmpOperative.m_szSecondaryWeaponBullet);
				SecondaryWeaponGadgetClass=Class'R6DescriptionManager'.static.GetSecondaryWeaponGadgetDesc(SecondaryWeaponClass,tmpOperative.m_szSecondaryWeaponGadget);
				PrimaryGadgetClass=Class<R6GadgetDescription>(DynamicLoadObject(tmpOperative.m_szPrimaryGadget,Class'Class'));
				SecondaryGadgetClass=Class<R6GadgetDescription>(DynamicLoadObject(tmpOperative.m_szSecondaryGadget,Class'Class'));
				ArmorDescriptionClass=Class<R6ArmorDescription>(DynamicLoadObject(tmpOperative.m_szArmor,Class'Class'));
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_CharacterName=tmpOperative.GetShortName();
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_ArmorName=ArmorDescriptionClass.Default.m_ClassName;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponGadgetName[0]=PrimaryWeaponGadgetClass.Default.m_ClassName;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponGadgetName[1]=SecondaryWeaponGadgetClass.Default.m_ClassName;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_GadgetName[0]=PrimaryGadgetClass.Default.m_ClassName;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_GadgetName[1]=SecondaryGadgetClass.Default.m_ClassName;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_iHealth=tmpOperative.m_iHealth;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_iOperativeID=tmpOperative.m_iUniqueID;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_FaceTexture=tmpOperative.m_TMenuFaceSmall;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_FaceCoords.X=tmpOperative.m_RMenuFaceSmallX;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_FaceCoords.Y=tmpOperative.m_RMenuFaceSmallY;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_FaceCoords.Z=tmpOperative.m_RMenuFaceSmallW;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_FaceCoords.W=tmpOperative.m_RMenuFaceSmallH;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_szSpecialityID=tmpOperative.m_szSpecialityID;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_fSkillAssault=tmpOperative.m_fAssault * 0.01;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_fSkillDemolitions=tmpOperative.m_fDemolitions * 0.01;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_fSkillElectronics=tmpOperative.m_fElectronics * 0.01;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_fSkillSniper=tmpOperative.m_fSniper * 0.01;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_fSkillStealth=tmpOperative.m_fStealth * 0.01;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_fSkillSelfControl=tmpOperative.m_fSelfControl * 0.01;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_fSkillLeadership=tmpOperative.m_fLeadership * 0.01;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_fSkillObservation=tmpOperative.m_fObservation * 0.01;
				if ( tmpOperative.m_szGender == "M" )
				{
					StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_bIsMale=True;
				}
				else
				{
					StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_bIsMale=False;
				}
				Found=False;
				k=0;
JL086C:
				if ( (k < PrimaryWeaponClass.Default.m_WeaponTags.Length) && (Found == False) )
				{
					if ( PrimaryWeaponClass.Default.m_WeaponTags[k] == PrimaryWeaponGadgetClass.Default.m_NameTag )
					{
						Found=True;
						StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[0]=PrimaryWeaponClass.Default.m_WeaponClasses[k];
						Tag=PrimaryWeaponClass.Default.m_WeaponTags[k];
					}
					else
					{
						if ( PrimaryWeaponClass.Default.m_WeaponTags[k] == PrimaryWeaponBulletClass.Default.m_NameTag )
						{
							Found=True;
							StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[0]=PrimaryWeaponClass.Default.m_WeaponClasses[k];
							Tag=PrimaryWeaponClass.Default.m_WeaponTags[k];
						}
					}
					k++;
					goto JL086C;
				}
				if ( Found == False )
				{
					StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[0]=PrimaryWeaponClass.Default.m_WeaponClasses[0];
					Tag=PrimaryWeaponClass.Default.m_WeaponTags[0];
				}
				if ( Tag == "SILENCED" )
				{
					StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_BulletType[0]=PrimaryWeaponBulletClass.Default.m_SubsonicClassName;
				}
				else
				{
					StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_BulletType[0]=PrimaryWeaponBulletClass.Default.m_ClassName;
				}
				Found=False;
				k=0;
JL0AB9:
				if ( (k < SecondaryWeaponClass.Default.m_WeaponTags.Length) && (Found == False) )
				{
					if ( SecondaryWeaponClass.Default.m_WeaponTags[k] == SecondaryWeaponGadgetClass.Default.m_NameTag )
					{
						Found=True;
						StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[1]=SecondaryWeaponClass.Default.m_WeaponClasses[k];
						Tag=SecondaryWeaponClass.Default.m_WeaponTags[k];
					}
					else
					{
						if ( SecondaryWeaponClass.Default.m_WeaponTags[k] == SecondaryWeaponBulletClass.Default.m_NameTag )
						{
							Found=True;
							StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[1]=SecondaryWeaponClass.Default.m_WeaponClasses[k];
							Tag=SecondaryWeaponClass.Default.m_WeaponTags[k];
						}
					}
					k++;
					goto JL0AB9;
				}
				if ( Found == False )
				{
					StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[1]=SecondaryWeaponClass.Default.m_WeaponClasses[0];
					Tag=SecondaryWeaponClass.Default.m_WeaponTags[0];
				}
				if ( Tag == "SILENCED" )
				{
					StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_BulletType[1]=SecondaryWeaponBulletClass.Default.m_SubsonicClassName;
				}
				else
				{
					StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_BulletType[1]=SecondaryWeaponBulletClass.Default.m_ClassName;
				}
				tmpItem=R6WindowListBoxItem(tmpItem.Next);
				rainbowAdded++;
			}
			i++;
			goto JL00DD;
		}
		StartGameInfo.m_TeamInfo[j].m_iNumberOfMembers=rainbowAdded;
		j++;
		goto JL0090;
	}
}

function SetStartTeamInfoForSaving ()
{
	local R6StartGameInfo StartGameInfo;
	local int i;
	local int j;
	local int k;
	local R6WindowTextIconsListBox tmpListBox[3];
	local R6WindowTextIconsListBox currentListBox;
	local R6Operative tmpOperative;
	local R6WindowListBoxItem tmpItem;
	local bool Found;

	StartGameInfo=R6Console(Root.Console).Master.m_StartGameInfo;
	tmpListBox[0]=m_RosterListCtrl.m_RedListBox.m_listBox;
	tmpListBox[1]=m_RosterListCtrl.m_GreenListBox.m_listBox;
	tmpListBox[2]=m_RosterListCtrl.m_GoldListBox.m_listBox;
	j=0;
JL0090:
	if ( j < 3 )
	{
		currentListBox=tmpListBox[j];
		tmpItem=R6WindowListBoxItem(currentListBox.Items.Next);
		StartGameInfo.m_TeamInfo[j].m_iNumberOfMembers=0;
		i=0;
JL00F5:
		if ( i < currentListBox.Items.Count() )
		{
			tmpOperative=R6Operative(tmpItem.m_Object);
			if ( tmpOperative != None )
			{
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_ArmorName=tmpOperative.m_szArmor;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[0]=tmpOperative.m_szPrimaryWeapon;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[1]=tmpOperative.m_szSecondaryWeapon;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_BulletType[0]=tmpOperative.m_szPrimaryWeaponBullet;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_BulletType[1]=tmpOperative.m_szSecondaryWeaponBullet;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponGadgetName[0]=tmpOperative.m_szPrimaryWeaponGadget;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponGadgetName[1]=tmpOperative.m_szSecondaryWeaponGadget;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_GadgetName[0]=tmpOperative.m_szPrimaryGadget;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_GadgetName[1]=tmpOperative.m_szSecondaryGadget;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_iOperativeID=tmpOperative.m_iUniqueID;
				StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_szSpecialityID=tmpOperative.m_szSpecialityID;
				StartGameInfo.m_TeamInfo[j].m_iNumberOfMembers++;
			}
			tmpItem=R6WindowListBoxItem(tmpItem.Next);
			i++;
			goto JL00F5;
		}
		j++;
		goto JL0090;
	}
}

function LoadRosterFromStartInfo ()
{
	local R6StartGameInfo StartGameInfo;
	local int i;
	local int j;
	local int k;
	local int L;
	local int TeamIDs[8];
	local R6WindowTextIconsSubListBox tmpListBox[3];
	local R6WindowTextIconsSubListBox currentListBox;
	local bool Found;
	local bool bOperativeIsNotReady;
	local bool bRookieCase;
	local bool bIDMatch;
	local R6WindowListBoxItem TempItem;
	local R6WindowListBoxItem SelectedItem;
	local R6WindowListBoxItem bkpValidItem;
	local R6Operative tmpOperative;
	local R6WindowListBoxItem selectedOperativeItem;
	local int selectedOperativeTeamId;

	StartGameInfo=R6Console(Root.Console).Master.m_StartGameInfo;
	tmpListBox[0]=m_RosterListCtrl.m_RedListBox;
	tmpListBox[1]=m_RosterListCtrl.m_GreenListBox;
	tmpListBox[2]=m_RosterListCtrl.m_GoldListBox;
	Reset();
	k=0;
	j=0;
JL0082:
	if ( j < 3 )
	{
		i=0;
JL0095:
		if ( i < StartGameInfo.m_TeamInfo[j].m_iNumberOfMembers )
		{
			TeamIDs[k]=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_iOperativeID;
			k++;
			i++;
			goto JL0095;
		}
		j++;
		goto JL0082;
	}
	j=0;
JL0116:
	if ( j < 3 )
	{
		currentListBox=tmpListBox[j];
		i=0;
JL013A:
		if ( i < StartGameInfo.m_TeamInfo[j].m_iNumberOfMembers )
		{
			k=0;
			Found=False;
			bOperativeIsNotReady=False;
			bRookieCase=False;
			bIDMatch=False;
			bkpValidItem=None;
			SelectedItem=R6WindowListBoxItem(m_RosterListCtrl.m_listBox.Items.Next);
			if ( StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_iOperativeID > m_RosterListCtrl.m_listBox.Items.Count() - 5 )
			{
				bRookieCase=True;
			}
JL0218:
			if ( (Found == False) && (k < m_RosterListCtrl.m_listBox.Items.Count()) )
			{
				tmpOperative=R6Operative(SelectedItem.m_Object);
				if ( tmpOperative != None )
				{
					bIDMatch=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_iOperativeID == tmpOperative.m_iUniqueID;
					if ( bIDMatch )
					{
						if ( tmpOperative.m_iRookieID != -1 )
						{
/*							if (  !StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_szSpecialityID ~= tmpOperative.m_szSpecialityID )
							{
								bRookieCase=True;
							}*/
						}
					}
					if ( bIDMatch &&  !bRookieCase )
					{
						if (  !tmpOperative.IsOperativeReady() || SelectedItem.m_addedToSubList )
						{
							bOperativeIsNotReady=True;
						}
						else
						{
							Found=True;
						}
					}
					else
					{
						if ( StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_szSpecialityID ~= tmpOperative.m_szSpecialityID )
						{
							if ( (bkpValidItem == None) && tmpOperative.IsOperativeReady() &&  !SelectedItem.m_addedToSubList )
							{
								bkpValidItem=SelectedItem;
								L=0;
JL03FC:
								if ( L < 8 )
								{
									if ( TeamIDs[L] == tmpOperative.m_iUniqueID )
									{
										bkpValidItem=None;
									}
									else
									{
										L++;
										goto JL03FC;
									}
								}
							}
						}
					}
					if ( bOperativeIsNotReady || bRookieCase )
					{
						if ( bkpValidItem != None )
						{
							SelectedItem=bkpValidItem;
							tmpOperative=R6Operative(SelectedItem.m_Object);
							Found=True;
						}
					}
				}
				if ( Found )
				{
					tmpOperative.m_szArmor=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_ArmorName;
					tmpOperative.m_szPrimaryWeapon=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[0];
					tmpOperative.m_szSecondaryWeapon=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponName[1];
					tmpOperative.m_szPrimaryWeaponBullet=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_BulletType[0];
					tmpOperative.m_szSecondaryWeaponBullet=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_BulletType[1];
					tmpOperative.m_szPrimaryWeaponGadget=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponGadgetName[0];
					tmpOperative.m_szSecondaryWeaponGadget=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_WeaponGadgetName[1];
					tmpOperative.m_szPrimaryGadget=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_GadgetName[0];
					tmpOperative.m_szSecondaryGadget=StartGameInfo.m_TeamInfo[j].m_CharacterInTeam[i].m_GadgetName[1];
					SetupOperative(tmpOperative);
					TempItem=R6WindowListBoxItem(currentListBox.m_listBox.Items.Append(Class'R6WindowListBoxItem'));
					if ( TempItem != None )
					{
						TempItem.m_Icon=SelectedItem.m_Icon;
						TempItem.m_IconRegion=SelectedItem.m_IconRegion;
						TempItem.m_IconSelectedRegion=SelectedItem.m_IconSelectedRegion;
						TempItem.HelpText=SelectedItem.HelpText;
						TempItem.m_ParentListItem=SelectedItem;
						TempItem.m_Object=SelectedItem.m_Object;
						SelectedItem.m_addedToSubList=True;
					}
					if ( selectedOperativeItem == None )
					{
						selectedOperativeItem=TempItem;
						selectedOperativeTeamId=j;
					}
				}
				else
				{
					k++;
					SelectedItem=R6WindowListBoxItem(SelectedItem.Next);
				}
				goto JL0218;
			}
			i++;
			goto JL013A;
		}
		j++;
		goto JL0116;
	}
	m_RosterListCtrl.RefreshButtons();
	m_RosterListCtrl.ResizeSubLists();
	if ( selectedOperativeItem != None )
	{
		tmpListBox[selectedOperativeTeamId].m_listBox.SetSelectedItem(selectedOperativeItem);
	}
	else
	{
		OperativeSelected(m_currentOperative,m_currentOperativeTeam,m_RosterListCtrl.m_listBox);
	}
}

function bool IsTeamConfigValid ()
{
	if ( m_RosterListCtrl == None )
	{
		return False;
	}
	if ( m_RosterListCtrl.m_RedListBox.m_listBox.Items.Count() + m_RosterListCtrl.m_GreenListBox.m_listBox.Items.Count() + m_RosterListCtrl.m_GoldListBox.m_listBox.Items.Count() <= 0 )
	{
		return False;
	}
	else
	{
		return True;
	}
}

defaultproperties
{
    m_currentOperativeTeam=3
    m_IRosterListLeftPad=1
    m_fPaddingBetweenElements=3.00
}
