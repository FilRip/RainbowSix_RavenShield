//================================================================================
// R6MenuMPCreateGameTab.
//================================================================================
class R6MenuMPCreateGameTab extends UWindowDialogClientWindow;

enum EGameModeInfo {
	GMI_None,
	GMI_SinglePlayer,
	GMI_Cooperative,
	GMI_Adversarial,
	GMI_Squad
};

enum eCreateGameWindow_ID {
	eCGW_NotDefine,
	eCGW_Opt,
	eCGW_Camera,
	eCGW_MapList,
	eCGW_Password,
	eCGW_AdminPassword,
	eCGW_LeftAdvOpt,
	eCGW_RightAdvOpt
};

struct stServerGameOpt
{
	var UWindowWindow pGameOptList;
	var EGameModeInfo eGameMode;
	var eCreateGameWindow_ID eCGWindowID;
};

var EGameModeInfo m_eCurrentGameMode;
var bool m_bInitComplete;
var bool m_bNewServerProfile;
var bool m_bInGame;
var R6MenuButtonsDefines m_pButtonsDef;
var array<R6MenuMPCreateGameTab> m_ALinkWindow;
var array<stServerGameOpt> m_AServerGameOpt;
var array<EGameModeInfo> m_ANbOfGameMode;
var array<string> m_ALocGameMode;
const K_HALFWINDOWWIDTH= 310;

function Created ()
{
//	m_ANbOfGameMode[0]=GetPlayerOwner().3;
//	m_ANbOfGameMode[1]=GetPlayerOwner().2;
	m_ALocGameMode[0]=Localize("MultiPlayer","GameMode_Adversarial","R6Menu");
	m_ALocGameMode[1]=Localize("MultiPlayer","GameMode_Cooperative","R6Menu");
	Super.Created();
	m_pButtonsDef=R6MenuButtonsDefines(GetButtonsDefinesUnique(Root.MenuClassDefines.ClassButtonsDefines));
	m_pButtonsDef.SetButtonsSizes(310.00 - 15,15.00);
	Class'Actor'.static.GetModMgr().RegisterObject(self);
}

function InitMod ()
{
}

function CreateListOfButtons (float _fX, float _fY, float _fW, float _fH, EGameModeInfo _eGameMode, eCreateGameWindow_ID _eCGWindowID)
{
	local stServerGameOpt stNewSGOItem;
	local R6WindowListGeneral pTempList;

	pTempList=R6WindowListGeneral(CreateWindow(Class'R6WindowListGeneral',_fX,_fY,_fW,_fH,self));
	pTempList.bAlwaysBehind=True;
	stNewSGOItem.pGameOptList=pTempList;
	stNewSGOItem.eGameMode=_eGameMode;
	stNewSGOItem.eCGWindowID=_eCGWindowID;
	AddWindowInCreateGameArray(stNewSGOItem);
	UpdateButtons(stNewSGOItem.eGameMode,stNewSGOItem.eCGWindowID);
}

function UpdateButtons (EGameModeInfo _eGameMode, eCreateGameWindow_ID _eCGWindowID, optional bool _bUpdateValue)
{
}

function R6WindowButtonAndEditBox CreateButAndEditBox (float _X, float _Y, float _W, float _H, string _szButName, string _szButTip, string _szCheckBoxTip)
{
	local R6WindowButtonAndEditBox pNewBut;

	pNewBut=R6WindowButtonAndEditBox(CreateControl(Class'R6WindowButtonAndEditBox',_X,_Y,_W,_H,self));
	pNewBut.m_TextFont=Root.Fonts[5];
	pNewBut.m_vTextColor=Root.Colors.White;
	pNewBut.m_vBorder=Root.Colors.White;
	pNewBut.m_bSelected=False;
	pNewBut.CreateTextAndBox(_szButName,_szButTip,0.00,1);
	pNewBut.CreateEditBox(310.00 * 0.50 - 36);
	pNewBut.m_pEditBox.EditBox.bPassword=True;
	pNewBut.m_pEditBox.EditBox.MaxLength=16;
	pNewBut.SetEditBoxTip(_szCheckBoxTip);
	return pNewBut;
}

function SetButtonAndEditBox (eCreateGameWindow_ID _eCGW_ID, string _szEditBoxValue, bool _bSelected)
{
	local R6WindowButtonAndEditBox pBut;

	pBut=R6WindowButtonAndEditBox(GetList(GetCurrentGameMode(),_eCGW_ID));
	if ( pBut != None )
	{
		pBut.m_pEditBox.SetValue(_szEditBoxValue);
		pBut.m_bSelected=_bSelected;
	}
}

function AddLinkWindow (R6MenuMPCreateGameTab _pLinkWindow)
{
	m_ALinkWindow[m_ALinkWindow.Length]=_pLinkWindow;
}

function AddWindowInCreateGameArray (stServerGameOpt _NewList)
{
	m_AServerGameOpt[m_AServerGameOpt.Length]=_NewList;
}

function UWindowWindow GetList (EGameModeInfo _eGameMode, eCreateGameWindow_ID _eCGWindowID)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_AServerGameOpt.Length )
	{
		if ( (m_AServerGameOpt[i].eGameMode == _eGameMode) && (m_AServerGameOpt[i].eCGWindowID == _eCGWindowID) )
		{
			return m_AServerGameOpt[i].pGameOptList;
		}
		i++;
		goto JL0007;
	}
	return None;
}

function UpdateMenuOptions (int _iButID, bool _bNewValue, R6WindowListGeneral _pOptionsList, optional bool _bChangeByUserClick)
{
}

function SetCurrentGameMode (EGameModeInfo _eGameMode, optional bool _bAdviceLinkWindow)
{
	local int i;

	if ( _bAdviceLinkWindow )
	{
		i=0;
JL0010:
		if ( i < m_ALinkWindow.Length )
		{
			m_ALinkWindow[i].SetCurrentGameMode(_eGameMode);
			i++;
			goto JL0010;
		}
	}
	i=0;
JL004B:
	if ( i < m_AServerGameOpt.Length )
	{
		if ( m_AServerGameOpt[i].eGameMode != _eGameMode )
		{
			if ( m_AServerGameOpt[i].pGameOptList.IsA('R6WindowListGeneral') )
			{
				R6WindowListGeneral(m_AServerGameOpt[i].pGameOptList).ChangeVisualItems(False);
			}
			m_AServerGameOpt[i].pGameOptList.HideWindow();
		}
		i++;
		goto JL004B;
	}
	i=0;
JL00E3:
	if ( i < m_AServerGameOpt.Length )
	{
		if ( m_AServerGameOpt[i].eGameMode == _eGameMode )
		{
			m_AServerGameOpt[i].pGameOptList.ShowWindow();
			if ( m_AServerGameOpt[i].pGameOptList.IsA('R6WindowListGeneral') )
			{
				R6WindowListGeneral(m_AServerGameOpt[i].pGameOptList).ChangeVisualItems(True);
			}
			m_eCurrentGameMode=_eGameMode;
		}
		i++;
		goto JL00E3;
	}
	RefreshCGButtons();
}

function EGameModeInfo GetCurrentGameMode ()
{
	return m_eCurrentGameMode;
}

function Refresh ()
{
}

function bool SendNewMapSettings (out byte _bMapCount)
{
	return False;
}

function bool SendNewServerSettings ()
{
	return False;
}

function RefreshServerOpt (optional bool _bNewServerProfile)
{
	RefreshCGButtons();
}

function RefreshCGButtons ()
{
	local int i;

	i=0;
JL0007:
	if ( i < m_AServerGameOpt.Length )
	{
		if ( m_AServerGameOpt[i].eGameMode == GetCurrentGameMode() )
		{
			UpdateButtons(m_AServerGameOpt[i].eGameMode,m_AServerGameOpt[i].eCGWindowID,True);
		}
		i++;
		goto JL0007;
	}
}

function SetServerOptions ()
{
}

function Notify (UWindowDialogControl C, byte E)
{
	local bool bProcessNotify;

	if ( E == 2 )
	{
		if ( C.IsA('R6WindowButtonBox') )
		{
			ManageR6ButtonBoxNotify(C);
			bProcessNotify=True;
		}
	}
	if ( bProcessNotify && m_bInitComplete &&  !m_bNewServerProfile )
	{
		SetServerOptions();
	}
}

function ManageR6ButtonNotify (UWindowDialogControl C, byte E)
{
	switch (E)
	{
		case 9:
		R6WindowButton(C).SetButtonBorderColor(Root.Colors.White);
		R6WindowButton(C).TextColor=Root.Colors.White;
		break;
		case 12:
		R6WindowButton(C).SetButtonBorderColor(Root.Colors.BlueLight);
		R6WindowButton(C).TextColor=Root.Colors.BlueLight;
		break;
		default:
	}
}

function ManageR6ButtonBoxNotify (UWindowDialogControl C)
{
	if ( R6WindowButtonBox(C).GetSelectStatus() )
	{
		R6WindowButtonBox(C).m_bSelected= !R6WindowButtonBox(C).m_bSelected;
//		UpdateMenuOptions(R6WindowButtonBox(C).m_iButtonID,R6WindowButtonBox(C).m_bSelected,R6WindowListGeneral(GetList(GetCurrentGameMode(),1)),True);
	}
}

function ManageR6ButtonAndEditBoxNotify (UWindowDialogControl C)
{
	if ( R6WindowButtonAndEditBox(C).GetSelectStatus() )
	{
		R6WindowButtonAndEditBox(C).m_bSelected= !R6WindowButtonAndEditBox(C).m_bSelected;
	}
}
