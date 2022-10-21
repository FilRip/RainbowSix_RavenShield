//================================================================================
// R6MenuButtonsDefines.
//================================================================================
class R6MenuButtonsDefines extends UWindowWindow;

var float m_fWidth;
var float m_fHeight;
struct STButton
{
	var string szButtonName;
	var string szTip;
	var float fWidth;
	var float fHeight;
	var int iButtonID;
};

enum eButLocalizationExt {
	eBLE_None,
	eBLE_DisableToolTip
};


function SetButtonsSizes (float _fWidth, float _fHeight)
{
	m_fWidth=_fWidth;
	m_fHeight=_fHeight;
}

function string GetButtonLoc (int _iButtonID, optional bool _bTip, optional eButLocalizationExt _eBLE)
{
	local string szName;
	local string szTip;
	local string szExt;

	switch (_iButtonID)
	{
		case 1:
		szName=Localize("MPCreateGame","Options_RoundMatch","R6Menu");
		break;
		case 2:
		szName=Localize("MPCreateGame","Options_Round","R6Menu");
		break;
		case 3:
		szName=Localize("MPCreateGame","Options_NbOfPlayers","R6Menu");
		break;
		case 4:
		szName=Localize("MPCreateGame","Options_BombTimer","R6Menu");
		break;
		case 5:
		szName=Localize("MPCreateGame","Options_Spectator","R6Menu");
		break;
		case 6:
		szName=Localize("MPCreateGame","Options_RoundMission","R6Menu");
		break;
		case 7:
		szName=Localize("MPCreateGame","Options_BetRound","R6Menu");
		break;
		case 8:
		szName=Localize("MPCreateGame","Options_NbOfTerro","R6Menu");
		break;
		case 9:
		szName=Localize("MPCreateGame","Options_ServerLocation","R6Menu");
		szTip=Localize("Tip","Options_ServerLocation","R6Menu");
		break;
		case 10:
		szName=Localize("MPCreateGame","Options_Dedicated","R6Menu");
		szTip=Localize("Tip","Options_Dedicated","R6Menu");
		break;
		case 11:
		szName=Localize("MPCreateGame","Options_Friendly","R6Menu");
		szTip=Localize("Tip","Options_Friendly","R6Menu");
		break;
		case 12:
		szName=Localize("MPCreateGame","Options_AllowTeamNames","R6Menu");
		szTip=Localize("Tip","Options_AllowTeamNames","R6Menu");
		break;
		case 13:
		szName=Localize("MPCreateGame","Options_Auto","R6Menu");
		szTip=Localize("Tip","Options_Auto","R6Menu");
		break;
		case 14:
		szName=Localize("MPCreateGame","Options_TK","R6Menu");
		szTip=Localize("Tip","Options_TK","R6Menu");
		break;
		case 15:
		szName=Localize("MPCreateGame","Options_AllowRadar","R6Menu");
		szTip=Localize("Tip","Options_AllowRadar","R6Menu");
		break;
		case 16:
		szName=Localize("MPCreateGame","Options_RotateMap","R6Menu");
		szTip=Localize("Tip","Options_RotateMap","R6Menu");
		break;
		case 17:
		szName=Localize("MPCreateGame","Options_AIBackup","R6Menu");
		szTip=Localize("Tip","Options_AIBackup","R6Menu");
		break;
		case 18:
		szName=Localize("MPCreateGame","Options_ForceFPersonWp","R6Menu");
		szTip=Localize("Tip","Options_ForceFPersonWp","R6Menu");
		break;
		case 23:
		szName=Localize("MPCreateGame","Options_FirstP","R6Menu");
		szTip=Localize("Tip","Options_FirstP","R6Menu");
		break;
		case 24:
		szName=Localize("MPCreateGame","Options_ThirdP","R6Menu");
		szTip=Localize("Tip","Options_ThirdP","R6Menu");
		break;
		case 25:
		szName=Localize("MPCreateGame","Options_FreeThirdP","R6Menu");
		szTip=Localize("Tip","Options_FreeThirdP","R6Menu");
		break;
		case 26:
		szName=Localize("MPCreateGame","Options_Ghost","R6Menu");
		szTip=Localize("Tip","Options_Ghost","R6Menu");
		break;
		case 27:
		szName=Localize("MPCreateGame","Options_Fade","R6Menu");
		szTip=Localize("Tip","Options_Fade","R6Menu");
		break;
		case 28:
		szName=Localize("MPCreateGame","Options_TeamOnly","R6Menu");
		szTip=Localize("Tip","Options_TeamOnly","R6Menu");
		break;
		case 29:
		szName=Localize("MultiPlayer","ButtonLogIn","R6Menu");
		szTip=Localize("Tip","ButtonLogIn","R6Menu");
		break;
		case 30:
		szName=Localize("MultiPlayer","ButtonLogOut","R6Menu");
		szTip=Localize("Tip","ButtonLogOut","R6Menu");
		break;
		case 31:
		szName=Localize("MultiPlayer","ButtonJoin","R6Menu");
		szTip=Localize("Tip","ButtonJoin","R6Menu");
		break;
		case 32:
		szName=Localize("MultiPlayer","ButtonJoinIP","R6Menu");
		szTip=Localize("Tip","ButtonJoinIP","R6Menu");
		break;
		case 33:
		szName=Localize("MultiPlayer","ButtonRefresh","R6Menu");
		szTip=Localize("Tip","ButtonRefresh","R6Menu");
		break;
		case 34:
		szName=Localize("MultiPlayer","ButtonCreate","R6Menu");
		szTip=Localize("Tip","ButtonCreate","R6Menu");
		break;
		case 22:
		szName=Localize("MPCreateGame","Options_DiffLev","R6Menu");
		szTip=Localize("Tip","Options_DiffLev","R6Menu");
		break;
		case 19:
		szName=Localize("SinglePlayer","Difficulty1","R6Menu");
		szTip=Localize("Tip","Diff_Recruit","R6Menu");
		break;
		case 20:
		szName=Localize("SinglePlayer","Difficulty2","R6Menu");
		szTip=Localize("Tip","Diff_Veteran","R6Menu");
		break;
		case 21:
		szName=Localize("SinglePlayer","Difficulty3","R6Menu");
		szTip=Localize("Tip","Diff_Elite","R6Menu");
		break;
		case 0:
		szName="";
		break;
		default:
		Log("Button not supported");
		break;
	}
	if ( _eBLE != 0 )
	{
		return szExt;
	}
	else
	{
		if ( _bTip )
		{
			return szTip;
		}
		else
		{
			return szName;
		}
	}
}

function GetCounterTipLoc (int _iButtonID, out string _szLeftTip, out string _szRightTip)
{
	switch (_iButtonID)
	{
		case 1:
		_szLeftTip=Localize("Tip","Options_RoundMatch","R6Menu");
		_szRightTip=Localize("Tip","Options_RoundMatch","R6Menu");
		break;
		case 2:
		_szLeftTip=Localize("Tip","Options_RoundMin","R6Menu");
		_szRightTip=Localize("Tip","Options_RoundMax","R6Menu");
		break;
		case 3:
		_szLeftTip=Localize("Tip","Options_NbOfPlayersMin","R6Menu");
		_szRightTip=Localize("Tip","Options_NbOfPlayersMax","R6Menu");
		break;
		case 4:
		_szLeftTip=Localize("Tip","Options_BombTimer","R6Menu");
		_szRightTip=Localize("Tip","Options_BombTimer","R6Menu");
		break;
		case 5:
		_szLeftTip=Localize("Tip","Options_Spectator","R6Menu");
		_szRightTip=Localize("Tip","Options_Spectator","R6Menu");
		break;
		case 6:
		_szLeftTip=Localize("Tip","Options_RoundMission","R6Menu");
		_szRightTip=Localize("Tip","Options_RoundMission","R6Menu");
		break;
		case 7:
		_szLeftTip=Localize("Tip","Options_BetRound","R6Menu");
		_szRightTip=Localize("Tip","Options_BetRound","R6Menu");
		break;
		case 8:
		_szLeftTip=Localize("Tip","Options_NbOfTerro","R6Menu");
		_szRightTip=Localize("Tip","Options_NbOfTerro","R6Menu");
		break;
		default:
		Log("Button not supported");
		break;
	}
}

function AddButtonCombo (int _iButtonID, R6WindowListGeneral _R6WindowListGeneral, optional UWindowWindow _OwnerWindow)
{
	local STButton stButtonTemp;

	if ( m_fWidth == 0 )
	{
		m_fWidth=_R6WindowListGeneral.WinWidth;
	}
	if ( m_fHeight == 0 )
	{
		m_fHeight=_R6WindowListGeneral.WinHeight;
	}
//	stButtonTemp.szButtonName=GetButtonLoc(_iButtonID);
//	stButtonTemp.szTip=GetButtonLoc(_iButtonID,True);
	stButtonTemp.fWidth=m_fWidth;
	stButtonTemp.fHeight=m_fHeight;
	stButtonTemp.iButtonID=_iButtonID;
	AddCombo(stButtonTemp,_R6WindowListGeneral,UWindowDialogClientWindow(_OwnerWindow));
}

function AddCombo (STButton _stButton, R6WindowListGeneral _R6WindowListGeneral, UWindowDialogClientWindow _pParentWindow)
{
	local R6WindowComboControl pR6WindowComboControl;
	local R6WindowListGeneralItem GeneralItem;

	GeneralItem=R6WindowListGeneralItem(_R6WindowListGeneral.Items.Append(_R6WindowListGeneral.ListClass));
	pR6WindowComboControl=R6WindowComboControl(_pParentWindow.CreateControl(Class'R6WindowComboControl',0.00,0.00,_stButton.fWidth,LookAndFeel.Size_ComboHeight,_R6WindowListGeneral));
	pR6WindowComboControl.AdjustTextW(_stButton.szButtonName,0.00,0.00,_stButton.fWidth * 0.50,LookAndFeel.Size_ComboHeight);
	pR6WindowComboControl.AdjustEditBoxW(0.00,120.00,LookAndFeel.Size_ComboHeight);
	pR6WindowComboControl.SetEditBoxTip(_stButton.szTip);
	pR6WindowComboControl.SetValue("","");
	pR6WindowComboControl.SetFont(6);
	pR6WindowComboControl.m_iButtonID=_stButton.iButtonID;
	GeneralItem.m_pR6WindowComboControl=pR6WindowComboControl;
	GeneralItem.m_iItemID=_stButton.iButtonID;
}

function AddItemInComboButton (int _iButtonID, string _NewItem, string _SecondValue, R6WindowListGeneral _pListToUse)
{
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( TempItem.m_pR6WindowComboControl != None )
	{
		if ( TempItem.m_pR6WindowComboControl.m_iButtonID == _iButtonID )
		{
			TempItem.m_pR6WindowComboControl.AddItem(_NewItem,_SecondValue);
		}
	}
}

function ChangeButtonComboValue (int _iButtonID, string _szNewValue, R6WindowListGeneral _pListToUse, optional bool _bDisabled)
{
	local int iTemFind;
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( (TempItem != None) && (TempItem.m_pR6WindowComboControl != None) )
	{
		if ( TempItem.m_pR6WindowComboControl.m_iButtonID == _iButtonID )
		{
			iTemFind=TempItem.m_pR6WindowComboControl.FindItemIndex2(_szNewValue,True);
			if ( iTemFind != -1 )
			{
				TempItem.m_pR6WindowComboControl.SetSelectedIndex(iTemFind);
			}
			TempItem.m_pR6WindowComboControl.SetDisableButton(_bDisabled);
		}
	}
}

function string GetButtonComboValue (int _iButtonID, R6WindowListGeneral _pListToUse)
{
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( (TempItem != None) && (TempItem.m_pR6WindowComboControl != None) )
	{
		if ( TempItem.m_pR6WindowComboControl.m_iButtonID == _iButtonID )
		{
			return TempItem.m_pR6WindowComboControl.GetValue2();
		}
	}
	return "";
}

function AddButtonInt (int _iButtonID, int _iMin, int _iMax, int _iInitialValue, R6WindowListGeneral _R6WindowListGeneral, optional UWindowWindow _OwnerWindow)
{
	local STButton stButtonTemp;

	if ( m_fWidth == 0 )
	{
		m_fWidth=_R6WindowListGeneral.WinWidth;
	}
	if ( m_fHeight == 0 )
	{
		m_fHeight=_R6WindowListGeneral.WinHeight;
	}
//	stButtonTemp.szButtonName=GetButtonLoc(_iButtonID);
//	stButtonTemp.szTip=GetButtonLoc(_iButtonID,True);
	stButtonTemp.fWidth=m_fWidth;
	stButtonTemp.fHeight=m_fHeight;
	stButtonTemp.iButtonID=_iButtonID;
	AddCounterButton(stButtonTemp,_iMin,_iMax,_iInitialValue,_R6WindowListGeneral,_OwnerWindow);
}

function AddCounterButton (STButton _stButton, int _iMinValue, int _iMaxValue, int _iDefaultValue, R6WindowListGeneral _R6WindowListGeneral, UWindowWindow _pParentWindow)
{
	local R6WindowCounter pR6WindowCounter;
	local R6WindowListGeneralItem GeneralItem;
	local string szLeftTip;
	local string szRightTip;

	GeneralItem=R6WindowListGeneralItem(_R6WindowListGeneral.Items.Append(_R6WindowListGeneral.ListClass));
	pR6WindowCounter=R6WindowCounter(_pParentWindow.CreateWindow(Class'R6WindowCounter',0.00,0.00,_stButton.fWidth,_stButton.fHeight,_R6WindowListGeneral));
	pR6WindowCounter.bAlwaysBehind=True;
	pR6WindowCounter.ToolTipString=_stButton.szTip;
	pR6WindowCounter.m_iButtonID=_stButton.iButtonID;
	pR6WindowCounter.SetAdviceParent(True);
	pR6WindowCounter.CreateLabelText(0.00,0.00,_stButton.fWidth,_stButton.fHeight);
	pR6WindowCounter.SetLabelText(_stButton.szButtonName,Root.Fonts[5],Root.Colors.White);
	pR6WindowCounter.CreateButtons(_stButton.fWidth - 53,0.00,53.00);
	pR6WindowCounter.SetDefaultValues(_iMinValue,_iMaxValue,_iDefaultValue);
	GetCounterTipLoc(_stButton.iButtonID,szLeftTip,szRightTip);
	pR6WindowCounter.SetButtonToolTip(szLeftTip,szRightTip);
	GeneralItem.m_pR6WindowCounter=pR6WindowCounter;
	GeneralItem.m_iItemID=_stButton.iButtonID;
}

function ChangeButtonCounterValue (int _iButtonID, int _iNewValue, R6WindowListGeneral _pListToUse, optional bool _bNotAcceptClick)
{
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( (TempItem != None) && (TempItem.m_pR6WindowCounter != None) )
	{
		if ( TempItem.m_pR6WindowCounter.m_iButtonID == _iButtonID )
		{
			TempItem.m_pR6WindowCounter.SetCounterValue(_iNewValue);
			TempItem.m_pR6WindowCounter.m_bNotAcceptClick=_bNotAcceptClick;
		}
	}
}

function int GetButtonCounterValue (int _iButtonID, R6WindowListGeneral _pListToUse)
{
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( (TempItem != None) && (TempItem.m_pR6WindowCounter != None) )
	{
		if ( TempItem.m_pR6WindowCounter.m_iButtonID == _iButtonID )
		{
			return TempItem.m_pR6WindowCounter.m_iCounter;
		}
	}
	return -1;
}

function SetButtonCounterUnlimited (int _iButtonID, bool _bUnlimitedCounterOnZero, R6WindowListGeneral _pListToUse)
{
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( (TempItem != None) && (TempItem.m_pR6WindowCounter != None) )
	{
		if ( TempItem.m_pR6WindowCounter.m_iButtonID == _iButtonID )
		{
			TempItem.m_pR6WindowCounter.m_bUnlimitedCounterOnZero=_bUnlimitedCounterOnZero;
		}
	}
}

function AddButtonBool (int _iButtonID, bool _bInitialValue, R6WindowListGeneral _R6WindowListGeneral, optional UWindowWindow _OwnerWindow)
{
	local STButton stButtonTemp;
	local int iInitialValue;

	if ( m_fWidth == 0 )
	{
		m_fWidth=_R6WindowListGeneral.WinWidth;
	}
	if ( m_fHeight == 0 )
	{
		m_fHeight=_R6WindowListGeneral.WinHeight;
	}
//	stButtonTemp.szButtonName=GetButtonLoc(_iButtonID);
//	stButtonTemp.szTip=GetButtonLoc(_iButtonID,True);
	stButtonTemp.fWidth=m_fWidth;
	stButtonTemp.fHeight=m_fHeight;
	stButtonTemp.iButtonID=_iButtonID;
	AddButtonBox(stButtonTemp,_bInitialValue,_R6WindowListGeneral,UWindowDialogClientWindow(_OwnerWindow));
}

function AddButtonBox (STButton _stButton, bool _bSelected, R6WindowListGeneral _R6WindowListGeneral, UWindowDialogClientWindow _pParentWindow)
{
	local R6WindowButtonBox pR6WindowButtonBox;
	local R6WindowListGeneralItem GeneralItem;

	GeneralItem=R6WindowListGeneralItem(_R6WindowListGeneral.Items.Append(_R6WindowListGeneral.ListClass));
	pR6WindowButtonBox=R6WindowButtonBox(_pParentWindow.CreateControl(Class'R6WindowButtonBox',0.00,0.00,_stButton.fWidth,_stButton.fHeight,_R6WindowListGeneral));
	pR6WindowButtonBox.m_TextFont=Root.Fonts[5];
	pR6WindowButtonBox.m_vTextColor=Root.Colors.White;
	pR6WindowButtonBox.m_vBorder=Root.Colors.White;
	pR6WindowButtonBox.m_bSelected=_bSelected;
	pR6WindowButtonBox.CreateTextAndBox(_stButton.szButtonName,_stButton.szTip,0.00,_stButton.iButtonID);
	GeneralItem.m_pR6WindowButtonBox=pR6WindowButtonBox;
	GeneralItem.m_iItemID=_stButton.iButtonID;
}

function ChangeButtonBoxValue (int _iButtonID, bool _bNewValue, R6WindowListGeneral _pListToUse, optional bool _bDisabled)
{
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( (TempItem != None) && (TempItem.m_pR6WindowButtonBox != None) )
	{
		TempItem.m_pR6WindowButtonBox.m_bSelected=_bNewValue;
		TempItem.m_pR6WindowButtonBox.bDisabled=_bDisabled;
		if ( _bDisabled )
		{
//			TempItem.m_pR6WindowButtonBox.m_szToolTipWhenDisable=GetButtonLoc(_iButtonID,False,1);
		}
	}
}

function bool GetButtonBoxValue (int _iButtonID, R6WindowListGeneral _pListToUse)
{
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( (TempItem != None) && (TempItem.m_pR6WindowButtonBox != None) )
	{
		return TempItem.m_pR6WindowButtonBox.m_bSelected;
	}
	return False;
}

function bool IsButtonBoxDisabled (int _iButtonID, R6WindowListGeneral _pListToUse)
{
	local R6WindowListGeneralItem TempItem;

	TempItem=R6WindowListGeneralItem(FindButtonItem(_iButtonID,_pListToUse));
	if ( (TempItem != None) && (TempItem.m_pR6WindowButtonBox != None) )
	{
		return TempItem.m_pR6WindowButtonBox.bDisabled;
	}
	return False;
}

function UWindowList FindButtonItem (int _iButtonID, R6WindowListGeneral _pListToUse)
{
	local UWindowList ListItem;
	local R6WindowListGeneralItem TempItem;

	if ( _pListToUse != None )
	{
		ListItem=_pListToUse.Items.Next;
JL0028:
		if ( ListItem != None )
		{
			TempItem=R6WindowListGeneralItem(ListItem);
			if ( TempItem.m_iItemID == _iButtonID )
			{
				goto JL0075;
			}
			ListItem=ListItem.Next;
			goto JL0028;
		}
	}
JL0075:
	return ListItem;
}

function AssociateButtons (int _iButtonID1, int _iButtonID2, int _iAssociateButCase, R6WindowListGeneral _R6WindowListGeneral)
{
	local UWindowList ListItem;
	local R6WindowListGeneralItem pItem1;
	local R6WindowListGeneralItem pItem2;
	local R6WindowListGeneralItem TempItem;

	ListItem=_R6WindowListGeneral.Items.Next;
JL001D:
	if ( ListItem != None )
	{
		TempItem=R6WindowListGeneralItem(ListItem);
		if ( TempItem.m_pR6WindowCounter != None )
		{
			if ( TempItem.m_pR6WindowCounter.m_iButtonID == _iButtonID1 )
			{
				pItem1=TempItem;
				if ( pItem2 != None )
				{
					goto JL00D7;
				}
			}
			if ( TempItem.m_pR6WindowCounter.m_iButtonID == _iButtonID2 )
			{
				pItem2=TempItem;
				if ( pItem1 != None )
				{
					goto JL00D7;
				}
			}
		}
		ListItem=ListItem.Next;
		goto JL001D;
	}
JL00D7:
	if ( (pItem1 != None) && (pItem2 != None) )
	{
		pItem1.m_pR6WindowCounter.m_pAssociateButton=pItem2.m_pR6WindowCounter;
		pItem1.m_pR6WindowCounter.m_iAssociateButCase=_iAssociateButCase;
	}
}
