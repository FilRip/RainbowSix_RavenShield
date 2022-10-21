//================================================================================
// R6MenuDynTeamListsControl.
//================================================================================
class R6MenuDynTeamListsControl extends UWindowDialogClientWindow;

var int m_SubListTopHeight;
var int m_iMaxOperativeCount;
var bool bShowLog;
var float m_fButtonTabWidth;
var float m_fButtonTabHeight;
var float m_MinSubListHeight;
var float m_SubListByItemHeight;
var float TotalSublistsHeight;
var float m_fVPadding;
var float m_fFirsButtonOffset;
var float m_fHButtonPadding;
var float m_fHButtonOffset;
var R6WindowListBoxAnchorButton m_ASSAULTButton;
var R6WindowListBoxAnchorButton m_ReconButton;
var R6WindowListBoxAnchorButton m_SNIPERButton;
var R6WindowListBoxAnchorButton m_DemolitionButton;
var R6WindowListBoxAnchorButton m_ElectronicButton;
var Texture m_TButtonTexture;
var R6WindowTextIconsListBox m_listBox;
var R6WindowTextIconsSubListBox m_RedListBox;
var R6WindowTextIconsSubListBox m_GreenListBox;
var R6WindowTextIconsSubListBox m_GoldListBox;
var Texture m_BorderTexture;
var Region m_RASSAULTUp;
var Region m_RASSAULTOver;
var Region m_RASSAULTDown;
var Region m_RAssaultDisabled;
var Region m_RReconUp;
var Region m_RReconOver;
var Region m_RReconDown;
var Region m_RReconDisabled;
var Region m_RSNIPERUp;
var Region m_RSNIPEROver;
var Region m_RSNIPERDown;
var Region m_RSniperDisabled;
var Region m_RDemolitionUp;
var Region m_RDemolitionOver;
var Region m_RDemolitionDown;
var Region m_RDemolitionDisabled;
var Region m_RElectronicUp;
var Region m_RElectronicOver;
var Region m_RElectronicDown;
var Region m_RElectronicDisabled;
var Region RAssault;
var Region RRecon;
var Region RSniper;
var Region RDemo;
var Region RElectro;
var Region RSAssault;
var Region RSRecon;
var Region RSSniper;
var Region RSDemo;
var Region RSElectro;
var Region m_BorderRegion;

function Created ()
{
	m_BorderTexture=Texture(DynamicLoadObject("R6MenuTextures.Gui_BoxScroll",Class'Texture'));
	CreateAnchoredButtons();
	CreateRosterListBox();
}

function Notify (UWindowDialogControl C, byte E)
{
	local int itemPos;
	local R6WindowListBoxItem SelectedItem;
	local R6WindowListBoxItem ListItem;
	local UWindowList UListItem;
	local R6MenuGearWidget gearWidget;
	local R6Operative selectedOperative;
	local R6WindowTextIconsSubListBox tmpSubListBox;

	gearWidget=R6MenuGearWidget(OwnerWindow);
	if ( E == 11 )
	{
		switch (C)
		{
			case m_RedListBox.m_listBox:
			case m_GreenListBox.m_listBox:
			case m_GoldListBox.m_listBox:
			tmpSubListBox=R6WindowTextIconsSubListBox(C.OwnerWindow);
			SelectedItem=R6WindowListBoxItem(tmpSubListBox.m_listBox.m_SelectedItem);
			if ( SelectedItem != None )
			{
				if ( SelectedItem.Next != None )
				{
					ListItem=R6WindowListBoxItem(SelectedItem.Next);
				}
				else
				{
					if ( SelectedItem.Prev != tmpSubListBox.m_listBox.Items )
					{
						ListItem=R6WindowListBoxItem(SelectedItem.Prev);
					}
				}
				RemoveOperativeInSubList(tmpSubListBox);
				if ( ListItem != None )
				{
					tmpSubListBox.m_listBox.SetSelectedItem(ListItem);
				}
				RefreshButtons();
				ResizeSubLists();
			}
			break;
			case m_listBox:
			if ( m_RedListBox.m_listBox.Items.Count() < m_RedListBox.m_maxItemsCount )
			{
				AddOperativeToSubList(m_RedListBox);
			}
			else
			{
				if ( m_GreenListBox.m_listBox.Items.Count() < m_GreenListBox.m_maxItemsCount )
				{
					AddOperativeToSubList(m_GreenListBox);
				}
				else
				{
					AddOperativeToSubList(m_GoldListBox);
				}
			}
			RefreshButtons();
			ResizeSubLists();
			break;
			default:
		}
	}
	else
	{
		if ( E == 2 )
		{
			if ( bShowLog )
			{
				Log("R6MenuDynTeamListsControl Notify DE_Click");
			}
			switch (C)
			{
				case m_ASSAULTButton:
				case m_ReconButton:
				case m_SNIPERButton:
				case m_DemolitionButton:
				case m_ElectronicButton:
				itemPos=R6WindowListBoxItem(m_listBox.Items).FindItemIndex(R6WindowListBoxAnchorButton(C).AnchoredElement);
				if ( itemPos >= 0 )
				{
					m_listBox.m_VertSB.pos=0.00;
					m_listBox.m_VertSB.Scroll(itemPos);
					m_listBox.SetSelectedItem(UWindowListBoxItem(R6WindowListBoxItem(m_listBox.Items).FindEntry(itemPos + 1)));
				}
				break;
				case m_RedListBox.m_listBox:
				selectedOperative=R6Operative(R6WindowListBoxItem(m_RedListBox.m_listBox.m_SelectedItem).m_Object);
				if ( (gearWidget != None) && (selectedOperative != None) )
				{
//					gearWidget.OperativeSelected(selectedOperative,0,m_RedListBox.m_listBox);
				}
				m_GreenListBox.m_listBox.DropSelection();
				m_GoldListBox.m_listBox.DropSelection();
				m_listBox.DropSelection();
				RefreshButtons();
				break;
				case m_GreenListBox.m_listBox:
				selectedOperative=R6Operative(R6WindowListBoxItem(m_GreenListBox.m_listBox.m_SelectedItem).m_Object);
				if ( (gearWidget != None) && (selectedOperative != None) )
				{
//					gearWidget.OperativeSelected(selectedOperative,1,m_GreenListBox.m_listBox);
				}
				m_RedListBox.m_listBox.DropSelection();
				m_GoldListBox.m_listBox.DropSelection();
				m_listBox.DropSelection();
				RefreshButtons();
				break;
				case m_GoldListBox.m_listBox:
				selectedOperative=R6Operative(R6WindowListBoxItem(m_GoldListBox.m_listBox.m_SelectedItem).m_Object);
				if ( (gearWidget != None) && (selectedOperative != None) )
				{
//					gearWidget.OperativeSelected(selectedOperative,2,m_GoldListBox.m_listBox);
				}
				m_GreenListBox.m_listBox.DropSelection();
				m_RedListBox.m_listBox.DropSelection();
				m_listBox.DropSelection();
				RefreshButtons();
				break;
				case m_listBox:
				selectedOperative=R6Operative(R6WindowListBoxItem(m_listBox.m_SelectedItem).m_Object);
				if ( (gearWidget != None) && (selectedOperative != None) )
				{
//					gearWidget.OperativeSelected(selectedOperative,3,m_listBox);
				}
				m_RedListBox.m_listBox.DropSelection();
				m_GreenListBox.m_listBox.DropSelection();
				m_GoldListBox.m_listBox.DropSelection();
				RefreshButtons();
				break;
				case m_RedListBox.m_AddButton:
				case m_GreenListBox.m_AddButton:
				case m_GoldListBox.m_AddButton:
				AddOperativeToSubList(R6WindowTextIconsSubListBox(C.OwnerWindow));
				RefreshButtons();
				ResizeSubLists();
				break;
				case m_RedListBox.m_RemoveButton:
				case m_GreenListBox.m_RemoveButton:
				case m_GoldListBox.m_RemoveButton:
				tmpSubListBox=R6WindowTextIconsSubListBox(C.OwnerWindow);
				SelectedItem=R6WindowListBoxItem(tmpSubListBox.m_listBox.m_SelectedItem);
				if ( SelectedItem.Next != None )
				{
					ListItem=R6WindowListBoxItem(SelectedItem.Next);
				}
				else
				{
					if ( SelectedItem.Prev != tmpSubListBox.m_listBox.Items )
					{
						ListItem=R6WindowListBoxItem(SelectedItem.Prev);
					}
				}
				RemoveOperativeInSubList(tmpSubListBox);
				if ( ListItem != None )
				{
					tmpSubListBox.m_listBox.SetSelectedItem(ListItem);
				}
				RefreshButtons();
				ResizeSubLists();
				break;
				case m_RedListBox.m_UpButton:
				case m_GreenListBox.m_UpButton:
				case m_GoldListBox.m_UpButton:
				SelectedItem=R6WindowListBoxItem(R6WindowTextIconsSubListBox(C.OwnerWindow).m_listBox.m_SelectedItem);
				UListItem=SelectedItem.Prev;
				SelectedItem.Remove();
				UListItem.InsertItemBefore(SelectedItem);
				RefreshButtons();
				break;
				case m_RedListBox.m_DownButton:
				case m_GreenListBox.m_DownButton:
				case m_GoldListBox.m_DownButton:
				SelectedItem=R6WindowListBoxItem(R6WindowTextIconsSubListBox(C.OwnerWindow).m_listBox.m_SelectedItem);
				UListItem=SelectedItem.Next;
				SelectedItem.Remove();
				UListItem.InsertItemAfter(SelectedItem);
				RefreshButtons();
				break;
				default:
			}
		}
	}
}

function RemoveOperativeInSubList (R6WindowTextIconsSubListBox _SubListBox)
{
	local R6WindowListBoxItem SelectedItem;
	local R6Operative selectedOperative;
	local R6MenuGearWidget gearWidget;

	gearWidget=R6MenuGearWidget(OwnerWindow);
	SelectedItem=R6WindowListBoxItem(_SubListBox.m_listBox.m_SelectedItem);
	if ( (SelectedItem != None) && (SelectedItem.m_ParentListItem != None) )
	{
		_SubListBox.m_listBox.DropSelection();
		SelectedItem.m_ParentListItem.m_addedToSubList=False;
		SelectedItem.Remove();
		m_listBox.SetSelectedItem(SelectedItem.m_ParentListItem);
		selectedOperative=R6Operative(SelectedItem.m_Object);
//		gearWidget.OperativeSelected(selectedOperative,3);
	}
}

function AddOperativeToSubList (R6WindowTextIconsSubListBox _SubListBox)
{
	local int totalCount;
	local R6WindowListBoxItem TempItem;
	local R6WindowListBoxItem SelectedItem;
	local R6Operative selectedOperative;
	local R6MenuGearWidget gearWidget;
	local bool bFound;

	gearWidget=R6MenuGearWidget(OwnerWindow);
	if ( gearWidget.m_currentOperativeTeam == 0 )
	{
		RemoveOperativeInSubList(m_RedListBox);
	}
	else
	{
		if ( gearWidget.m_currentOperativeTeam == 1 )
		{
			RemoveOperativeInSubList(m_GreenListBox);
		}
		else
		{
			if ( gearWidget.m_currentOperativeTeam == 2 )
			{
				RemoveOperativeInSubList(m_GoldListBox);
			}
		}
	}
	totalCount=m_RedListBox.m_listBox.Items.Count() + m_GreenListBox.m_listBox.Items.Count() + m_GoldListBox.m_listBox.Items.Count();
	if ( bShowLog )
	{
		Log("m_RedListBox count :" @ string(m_RedListBox.m_listBox.Items.Count()));
		Log("m_GreenListBox count :" @ string(m_GreenListBox.m_listBox.Items.Count()));
		Log("m_GoldListBox count :" @ string(m_GoldListBox.m_listBox.Items.Count()));
		if ( _SubListBox == m_RedListBox )
		{
			Log("m_RedListBox Adding operative");
		}
		if ( _SubListBox == m_GreenListBox )
		{
			Log("m_GreenListBox Adding operative");
		}
		if ( _SubListBox == m_GoldListBox )
		{
			Log("m_GoldListBox Adding Operative");
		}
	}
	SelectedItem=R6WindowListBoxItem(m_listBox.m_SelectedItem);
	if ( (totalCount < m_iMaxOperativeCount) && (SelectedItem != None) && (SelectedItem.m_addedToSubList == False) && (_SubListBox.m_listBox.Items.Count() < _SubListBox.m_maxItemsCount) )
	{
		TempItem=R6WindowListBoxItem(_SubListBox.m_listBox.Items.Append(Class'R6WindowListBoxItem'));
		if ( TempItem != None )
		{
			TempItem.m_Icon=SelectedItem.m_Icon;
			TempItem.m_IconRegion=SelectedItem.m_IconRegion;
			TempItem.m_IconSelectedRegion=SelectedItem.m_IconSelectedRegion;
			TempItem.HelpText=SelectedItem.HelpText;
			TempItem.m_ParentListItem=SelectedItem;
			TempItem.m_Object=SelectedItem.m_Object;
			SelectedItem.m_addedToSubList=True;
			m_listBox.DropSelection();
			_SubListBox.m_listBox.SetSelectedItem(TempItem);
			selectedOperative=R6Operative(SelectedItem.m_Object);
			if ( _SubListBox == m_RedListBox )
			{
//				gearWidget.OperativeSelected(selectedOperative,0);
			}
			else
			{
				if ( _SubListBox == m_GreenListBox )
				{
//					gearWidget.OperativeSelected(selectedOperative,1);
				}
				else
				{
//					gearWidget.OperativeSelected(selectedOperative,2);
				}
			}
		}
	}
	else
	{
		if ( bShowLog )
		{
			Log(string(totalCount) @ "<" @ string(m_iMaxOperativeCount));
		}
	}
	TempItem=SelectedItem;
JL0492:
	if ( (TempItem != None) && (bFound == False) )
	{
		if ( (TempItem.m_IsSeparator == False) && (TempItem.m_addedToSubList == False) )
		{
			m_listBox.SetSelectedItem(TempItem);
			m_listBox.MakeSelectedVisible();
			bFound=True;
		}
		else
		{
			TempItem=R6WindowListBoxItem(TempItem.Next);
		}
		goto JL0492;
	}
}

function RefreshButtons ()
{
	local int iShowAdd;
	local int totalCount;
	local R6WindowListBoxItem SelectedItem;
	local R6MenuGearWidget gearWidget;

	gearWidget=R6MenuGearWidget(OwnerWindow);
	totalCount=m_RedListBox.m_listBox.Items.Count() + m_GreenListBox.m_listBox.Items.Count() + m_GoldListBox.m_listBox.Items.Count();
	switch (gearWidget.m_currentOperativeTeam)
	{
/*		case 3:
		if ( totalCount < m_iMaxOperativeCount )
		{
			iShowAdd=1;
		}
		else
		{
			iShowAdd=0;
		}
		m_RedListBox.UpdateButtons(iShowAdd);
		m_GreenListBox.UpdateButtons(iShowAdd);
		m_GoldListBox.UpdateButtons(iShowAdd);
		break;
		case 0:
		m_RedListBox.UpdateButtons(0);
		m_GreenListBox.UpdateButtons(1);
		m_GoldListBox.UpdateButtons(1);
		break;
		case 1:
		m_RedListBox.UpdateButtons(1);
		m_GreenListBox.UpdateButtons(0);
		m_GoldListBox.UpdateButtons(1);
		break;
		case 2:
		m_RedListBox.UpdateButtons(1);
		m_GreenListBox.UpdateButtons(1);
		m_GoldListBox.UpdateButtons(0);
		break;
		default:*/
	}
}

function CreateRosterListBox ()
{
	local Color co;
	local Font listBoxTitleFont;

	listBoxTitleFont=Root.Fonts[11];
	m_listBox=R6WindowTextIconsListBox(CreateControl(Class'R6WindowTextIconsListBox',0.00,m_ElectronicButton.WinTop + m_ElectronicButton.WinHeight,WinWidth,143.00,self));
	m_listBox.ToolTipString=Localize("Tip","GearRoomOpListBox","R6Menu");
	m_listBox.m_SeparatorTextColor=Root.Colors.BlueLight;
	m_listBox.m_BorderColor=Root.Colors.GrayLight;
	m_listBox.m_IgnoreAllreadySelected=False;
	m_listBox.m_VertSB.SetEffect(True);
	m_RedListBox=R6WindowTextIconsSubListBox(CreateControl(Class'R6WindowTextIconsSubListBox',0.00,m_listBox.WinTop + m_listBox.WinHeight + m_fVPadding,WinWidth,47.00,self));
	m_GreenListBox=R6WindowTextIconsSubListBox(CreateControl(Class'R6WindowTextIconsSubListBox',0.00,m_RedListBox.WinTop + m_RedListBox.WinHeight + m_fVPadding,WinWidth,47.00,self));
	m_GoldListBox=R6WindowTextIconsSubListBox(CreateControl(Class'R6WindowTextIconsSubListBox',0.00,m_GreenListBox.WinTop + m_GreenListBox.WinHeight + m_fVPadding,WinWidth,73.00,self));
	m_RedListBox.m_listBox.SetScrollable(False);
	m_GreenListBox.m_listBox.SetScrollable(False);
	m_GoldListBox.m_listBox.SetScrollable(False);
	m_RedListBox.SetColor(Root.Colors.TeamColor[0]);
	m_GreenListBox.SetColor(Root.Colors.TeamColor[1]);
	m_GoldListBox.SetColor(Root.Colors.TeamColor[2]);
	co=Root.Colors.White;
	m_RedListBox.m_Title.Align=TA_Center;
	m_RedListBox.m_Title.m_Font=listBoxTitleFont;
	m_RedListBox.m_Title.TextColor=co;
	m_RedListBox.m_Title.SetNewText(Localize("GearRoom","team1","R6Menu"),True);
	m_GreenListBox.m_Title.Align=TA_Center;
	m_GreenListBox.m_Title.m_Font=listBoxTitleFont;
	m_GreenListBox.m_Title.TextColor=co;
	m_GreenListBox.m_Title.SetNewText(Localize("GearRoom","team2","R6Menu"),True);
	m_GoldListBox.m_Title.Align=TA_Center;
	m_GoldListBox.m_Title.m_Font=listBoxTitleFont;
	m_GoldListBox.m_Title.TextColor=co;
	m_GoldListBox.m_Title.SetNewText(Localize("GearRoom","team3","R6Menu"),True);
	m_RedListBox.SetTip(Localize("Tip","GearRoomRedListBox","R6Menu"));
	m_GreenListBox.SetTip(Localize("Tip","GearRoomGreenListBox","R6Menu"));
	m_GoldListBox.SetTip(Localize("Tip","GearRoomGoldListBox","R6Menu"));
}

function CreateAnchoredButtons ()
{
	m_ASSAULTButton=R6WindowListBoxAnchorButton(CreateControl(Class'R6WindowListBoxAnchorButton',m_fFirsButtonOffset,m_fHButtonOffset,m_fButtonTabWidth,m_fButtonTabHeight));
	m_ASSAULTButton.ToolTipString=Localize("Tip","GearRoomButAssault","R6Menu");
	m_ASSAULTButton.UpRegion=m_RASSAULTUp;
	m_ASSAULTButton.OverRegion=m_RASSAULTOver;
	m_ASSAULTButton.DownRegion=m_RASSAULTDown;
	m_ASSAULTButton.DisabledRegion=m_RAssaultDisabled;
	m_ASSAULTButton.m_iDrawStyle=5;
	m_ReconButton=R6WindowListBoxAnchorButton(CreateControl(Class'R6WindowListBoxAnchorButton',m_ASSAULTButton.WinLeft + m_ASSAULTButton.WinWidth + m_fHButtonPadding,m_ASSAULTButton.WinTop,m_ASSAULTButton.WinWidth,m_ASSAULTButton.WinHeight));
	m_ReconButton.ToolTipString=Localize("Tip","GearRoomButRecon","R6Menu");
	m_ReconButton.UpRegion=m_RReconUp;
	m_ReconButton.OverRegion=m_RReconOver;
	m_ReconButton.DownRegion=m_RReconDown;
	m_ReconButton.DisabledRegion=m_RReconDisabled;
	m_ReconButton.m_iDrawStyle=5;
	m_SNIPERButton=R6WindowListBoxAnchorButton(CreateControl(Class'R6WindowListBoxAnchorButton',m_ReconButton.WinLeft + m_ReconButton.WinWidth + m_fHButtonPadding,m_ASSAULTButton.WinTop,m_ASSAULTButton.WinWidth,m_ASSAULTButton.WinHeight));
	m_SNIPERButton.ToolTipString=Localize("Tip","GearRoomButSniper","R6Menu");
	m_SNIPERButton.UpRegion=m_RSNIPERUp;
	m_SNIPERButton.OverRegion=m_RSNIPEROver;
	m_SNIPERButton.DownRegion=m_RSNIPERDown;
	m_SNIPERButton.DisabledRegion=m_RSniperDisabled;
	m_SNIPERButton.m_iDrawStyle=5;
	m_DemolitionButton=R6WindowListBoxAnchorButton(CreateControl(Class'R6WindowListBoxAnchorButton',m_SNIPERButton.WinLeft + m_SNIPERButton.WinWidth + m_fHButtonPadding,m_ASSAULTButton.WinTop,m_ASSAULTButton.WinWidth,m_ASSAULTButton.WinHeight));
	m_DemolitionButton.ToolTipString=Localize("Tip","GearRoomButDemol","R6Menu");
	m_DemolitionButton.UpRegion=m_RDemolitionUp;
	m_DemolitionButton.OverRegion=m_RDemolitionOver;
	m_DemolitionButton.DownRegion=m_RDemolitionDown;
	m_DemolitionButton.DisabledRegion=m_RDemolitionDisabled;
	m_DemolitionButton.m_iDrawStyle=5;
	m_ElectronicButton=R6WindowListBoxAnchorButton(CreateControl(Class'R6WindowListBoxAnchorButton',m_DemolitionButton.WinLeft + m_DemolitionButton.WinWidth + m_fHButtonPadding,m_ASSAULTButton.WinTop,m_ASSAULTButton.WinWidth,m_ASSAULTButton.WinHeight));
	m_ElectronicButton.ToolTipString=Localize("Tip","GearRoomButElec","R6Menu");
	m_ElectronicButton.UpRegion=m_RElectronicUp;
	m_ElectronicButton.OverRegion=m_RElectronicOver;
	m_ElectronicButton.DownRegion=m_RElectronicDown;
	m_ElectronicButton.DisabledRegion=m_RElectronicDisabled;
	m_ElectronicButton.m_iDrawStyle=5;
}

function FillRosterList ()
{
	local R6WindowListBoxItem TempItem;
	local Texture ButtonTexture;
	local Region R;
	local Region RS;
	local int i;
	local int SeparatorID;
	local int iUniqueID;
	local R6MenuRootWindow r6Root;
	local R6Operative tmpOperative;
	local R6MenuGearWidget gearWidget;
	local bool Found;

	ButtonTexture=Texture(DynamicLoadObject("R6MenuTextures.Tab_Icon00",Class'Texture'));
	r6Root=R6MenuRootWindow(Root);
	gearWidget=R6MenuGearWidget(OwnerWindow);
	m_iMaxOperativeCount=R6GameInfo(GetLevel().Game).m_iMaxOperatives;
	EmptyRosterList();
	TempItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	TempItem.HelpText=Localize("GearRoom","ButtonAssault","R6Menu");
	TempItem.m_IsSeparator=True;
	TempItem.m_iSeparatorID=1;
	m_ASSAULTButton.AnchoredElement=TempItem;
	TempItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	TempItem.HelpText=Localize("GearRoom","ButtonSniper","R6Menu");
	TempItem.m_IsSeparator=True;
	TempItem.m_iSeparatorID=2;
	m_SNIPERButton.AnchoredElement=TempItem;
	TempItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	TempItem.HelpText=Localize("GearRoom","ButtonDemolition","R6Menu");
	TempItem.m_IsSeparator=True;
	TempItem.m_iSeparatorID=3;
	m_DemolitionButton.AnchoredElement=TempItem;
	TempItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	TempItem.HelpText=Localize("GearRoom","ButtonElectronic","R6Menu");
	TempItem.m_IsSeparator=True;
	TempItem.m_iSeparatorID=4;
	m_ElectronicButton.AnchoredElement=TempItem;
	TempItem=R6WindowListBoxItem(m_listBox.Items.Append(Class'R6WindowListBoxItem'));
	TempItem.HelpText=Localize("GearRoom","ButtonRecon","R6Menu");
	TempItem.m_IsSeparator=True;
	TempItem.m_iSeparatorID=5;
	m_ReconButton.AnchoredElement=TempItem;
	if ( bShowLog )
	{
		Log("R6MenuDynTeamListsControl:FillRosterListBox");
		Log("m_ListBox.Items.Count()" @ string(m_listBox.Items.Count()));
		Log("R6Root.m_GameOperatives.Length" @ string(r6Root.m_GameOperatives.Length));
	}
	iUniqueID=-1;
	i=0;
JL0416:
	if ( i < r6Root.m_GameOperatives.Length )
	{
		tmpOperative=r6Root.m_GameOperatives[i];
		if ( bShowLog )
		{
			Log("tmpOperative" @ string(tmpOperative));
		}
		if ( tmpOperative != None )
		{
			iUniqueID += 1;
			if ( tmpOperative.m_iUniqueID == -1 )
			{
				tmpOperative.m_iUniqueID=iUniqueID;
			}
			if ( tmpOperative.m_szSpecialityID == "ID_ASSAULT" )
			{
				R=RAssault;
				RS=RSAssault;
				SeparatorID=1;
			}
			else
			{
				if ( tmpOperative.m_szSpecialityID == "ID_SNIPER" )
				{
					R=RSniper;
					RS=RSSniper;
					SeparatorID=2;
				}
				else
				{
					if ( tmpOperative.m_szSpecialityID == "ID_DEMOLITIONS" )
					{
						R=RDemo;
						RS=RSDemo;
						SeparatorID=3;
					}
					else
					{
						if ( tmpOperative.m_szSpecialityID == "ID_ELECTRONICS" )
						{
							R=RElectro;
							RS=RSElectro;
							SeparatorID=4;
						}
						else
						{
							if ( tmpOperative.m_szSpecialityID == "ID_RECON" )
							{
								R=RRecon;
								RS=RSRecon;
								SeparatorID=5;
							}
						}
					}
				}
			}
			TempItem=R6WindowListBoxItem(m_listBox.Items).InsertLastAfterSeparator(Class'R6WindowListBoxItem',SeparatorID);
			if ( TempItem != None )
			{
				TempItem.m_Icon=ButtonTexture;
				TempItem.m_IconRegion=R;
				TempItem.m_IconSelectedRegion=RS;
				TempItem.HelpText=tmpOperative.GetName();
				if ( tmpOperative.m_iHealth > 1 )
				{
					TempItem.m_addedToSubList=True;
				}
				TempItem.m_Object=tmpOperative;
				gearWidget.SetupOperative(tmpOperative);
			}
		}
		i++;
		goto JL0416;
	}
	TempItem=R6WindowListBoxItem(m_listBox.Items.Next);
JL06F6:
	if ( (TempItem != None) && (Found == False) )
	{
		if ( TempItem.m_IsSeparator == False )
		{
			m_listBox.SetSelectedItem(TempItem);
			m_listBox.MakeSelectedVisible();
			Found=True;
		}
		else
		{
			TempItem=R6WindowListBoxItem(TempItem.Next);
		}
		goto JL06F6;
	}
}

function EmptyRosterList ()
{
	m_listBox.Items.Clear();
	m_RedListBox.m_listBox.Items.Clear();
	m_GreenListBox.m_listBox.Items.Clear();
	m_GoldListBox.m_listBox.Items.Clear();
}

function Paint (Canvas C, float X, float Y)
{
	R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,m_listBox.WinLeft,m_listBox.WinTop,m_listBox.WinWidth,m_listBox.WinHeight);
	C.Style=5;
	C.SetDrawColor(Root.Colors.GrayLight.R,Root.Colors.GrayLight.G,Root.Colors.GrayLight.B);
	DrawStretchedTextureSegment(C,0.00,0.00,WinWidth,m_BorderRegion.H,m_BorderRegion.X,m_BorderRegion.Y,m_BorderRegion.W,m_BorderRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,0.00,m_ASSAULTButton.WinHeight + m_ASSAULTButton.WinTop,WinWidth,m_BorderRegion.H,m_BorderRegion.X,m_BorderRegion.Y,m_BorderRegion.W,m_BorderRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,0.00,0.00,m_BorderRegion.W,m_ASSAULTButton.WinHeight + m_fHButtonOffset,m_BorderRegion.X,m_BorderRegion.Y,m_BorderRegion.W,m_BorderRegion.H,m_BorderTexture);
	DrawStretchedTextureSegment(C,WinWidth - m_BorderRegion.W,0.00,m_BorderRegion.W,m_ASSAULTButton.WinHeight + m_fHButtonOffset,m_BorderRegion.X,m_BorderRegion.Y,m_BorderRegion.W,m_BorderRegion.H,m_BorderTexture);
}

function ResizeSubLists ()
{
	local int iRedListBoxH;
	local int iGreenListBoxH;
	local int iGoldListBoxH;
	local int iAddSpace;
	local int iMaxListHeigth;
	local int iAvailableSpace;

	iMaxListHeigth=4 * m_SubListByItemHeight + m_SubListTopHeight;
	iRedListBoxH=m_RedListBox.m_listBox.Items.Count() * m_SubListByItemHeight + m_SubListTopHeight;
	iGreenListBoxH=m_GreenListBox.m_listBox.Items.Count() * m_SubListByItemHeight + m_SubListTopHeight;
	iGoldListBoxH=m_GoldListBox.m_listBox.Items.Count() * m_SubListByItemHeight + m_SubListTopHeight;
	iAvailableSpace=TotalSublistsHeight - Min(iRedListBoxH + iGreenListBoxH + iGoldListBoxH,TotalSublistsHeight);
JL00F2:
	if ( iAvailableSpace != 0 )
	{
		iAddSpace=iAvailableSpace / 3;
		iAvailableSpace=iAvailableSpace - 3 * iAddSpace;
		if ( iAddSpace == 0 )
		{
			iAddSpace=iAvailableSpace;
			iAvailableSpace=0;
			iAddSpace=DistributeSpaces(iAddSpace,iRedListBoxH,iMaxListHeigth);
			iAddSpace=DistributeSpaces(iAddSpace,iGreenListBoxH,iMaxListHeigth);
			iAddSpace=DistributeSpaces(iAddSpace,iGoldListBoxH,iMaxListHeigth);
		}
		else
		{
			iAvailableSpace += DistributeSpaces(iAddSpace,iRedListBoxH,iMaxListHeigth);
			iAvailableSpace += DistributeSpaces(iAddSpace,iGreenListBoxH,iMaxListHeigth);
			iAvailableSpace += DistributeSpaces(iAddSpace,iGoldListBoxH,iMaxListHeigth);
		}
		goto JL00F2;
	}
	m_RedListBox.SetSize(m_RedListBox.WinWidth,iRedListBoxH);
	m_GreenListBox.WinTop=m_RedListBox.WinTop + m_RedListBox.WinHeight + m_fVPadding;
	m_GreenListBox.SetSize(m_GreenListBox.WinWidth,iGreenListBoxH);
	m_GoldListBox.WinTop=m_GreenListBox.WinTop + m_GreenListBox.WinHeight + m_fVPadding;
	m_GoldListBox.SetSize(m_GoldListBox.WinWidth,iGoldListBoxH);
	if ( bShowLog )
	{
		Log("//////////////////////////////////////////////////////");
		Log("// R6MenuDynTeamListsControl.ResizeSubLists()");
		Log("//m_RedListBox.WinHeight" @ string(m_RedListBox.WinHeight));
		Log("//m_GoldListBox.WinHeight" @ string(m_GoldListBox.WinHeight));
		Log("//m_GreenListBox.WinHeight" @ string(m_GreenListBox.WinHeight));
		Log("//yo " @ string(WinHeight - TotalSublistsHeight - m_ASSAULTButton.WinHeight + m_fHButtonOffset - m_listBox.WinHeight));
		Log("//////////////////////////////////////////////////////");
	}
}

function int DistributeSpaces (int _iSpaceToAdd, out int _iHList, int _iMaxListHeigth)
{
	local int iSpaceLeft;

	if ( _iHList + _iSpaceToAdd > _iMaxListHeigth )
	{
		iSpaceLeft=_iSpaceToAdd - _iMaxListHeigth - _iHList;
		_iHList=_iMaxListHeigth;
	}
	else
	{
		_iHList += _iSpaceToAdd;
	}
	return iSpaceLeft;
}

defaultproperties
{
    m_SubListTopHeight=20
    m_iMaxOperativeCount=8
    m_fButtonTabWidth=37.00
    m_fButtonTabHeight=20.00
    m_MinSubListHeight=47.00
    m_SubListByItemHeight=13.00
    TotalSublistsHeight=167.00
    m_fVPadding=2.00
    m_fFirsButtonOffset=3.00
    m_fHButtonPadding=2.00
    m_fHButtonOffset=3.00
    m_RASSAULTUp=(X=2433540,Y=570621952,W=20,H=4608)
    m_RASSAULTOver=(X=1384965,Y=570687488,W=37,H=1319427)
    m_RASSAULTDown=(X=2761221,Y=570687488,W=37,H=1319427)
    m_RAssaultDisabled=(X=2761221,Y=570687488,W=37,H=1319427)
    m_RReconUp=(X=7479814,Y=570687488,W=37,H=1319427)
    m_RReconOver=(X=7479814,Y=570753024,W=21,H=2433540)
    m_RReconDown=(X=7479814,Y=570753024,W=42,H=2433540)
    m_RReconDisabled=(X=7479814,Y=570753024,W=42,H=2433540)
    m_RSNIPERUp=(X=9970182,Y=570687488,W=37,H=1319427)
    m_RSNIPEROver=(X=9970182,Y=570753024,W=21,H=2433540)
    m_RSNIPERDown=(X=9970182,Y=570753024,W=42,H=2433540)
    m_RSniperDisabled=(X=9970182,Y=570753024,W=42,H=2433540)
    m_RDemolitionUp=(X=2499078,Y=570687488,W=37,H=1319427)
    m_RDemolitionOver=(X=2499078,Y=570753024,W=21,H=2433540)
    m_RDemolitionDown=(X=2499078,Y=570753024,W=42,H=2433540)
    m_RDemolitionDisabled=(X=2499078,Y=570753024,W=42,H=2433540)
    m_RElectronicUp=(X=4989446,Y=570687488,W=37,H=1319427)
    m_RElectronicOver=(X=4989446,Y=570753024,W=21,H=2433540)
    m_RElectronicDown=(X=4989446,Y=570753024,W=42,H=2433540)
    m_RElectronicDisabled=(X=4989446,Y=570753024,W=42,H=2433540)
    RAssault=(X=15016454,Y=570687488,W=9,H=598531)
    RRecon=(X=15671814,Y=570753024,W=20,H=598532)
    RSniper=(X=15016454,Y=570753024,W=40,H=598532)
    RDemo=(X=15671814,Y=570687488,W=9,H=598531)
    RElectro=(X=15016454,Y=570753024,W=20,H=598532)
    RSAssault=(X=15016454,Y=570753024,W=10,H=598532)
    RSRecon=(X=15671814,Y=570753024,W=30,H=598532)
    RSSniper=(X=15016454,Y=570753024,W=50,H=598532)
    RSDemo=(X=15671814,Y=570753024,W=10,H=598532)
    RSElectro=(X=15016454,Y=570753024,W=30,H=598532)
    m_BorderRegion=(X=4203014,Y=570753024,W=56,H=74244)
}
