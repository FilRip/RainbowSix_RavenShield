//================================================================================
// R6MenuMapList.
//================================================================================
class R6MenuMapList extends UWindowDialogClientWindow;

enum EGameModeInfo {
	GMI_None,
	GMI_SinglePlayer,
	GMI_Cooperative,
	GMI_Adversarial,
	GMI_Squad
};

enum ER6GameType {
	RGM_AllMode,
	RGM_StoryMode,
	RGM_PracticeMode,
	RGM_MissionMode,
	RGM_TerroristHuntMode,
	RGM_TerroristHuntCoopMode,
	RGM_HostageRescueMode,
	RGM_HostageRescueCoopMode,
	RGM_HostageRescueAdvMode,
	RGM_DefendMode,
	RGM_DefendCoopMode,
	RGM_ReconMode,
	RGM_ReconCoopMode,
	RGM_DeathmatchMode,
	RGM_TeamDeathmatchMode,
	RGM_BombAdvMode,
	RGM_EscortAdvMode,
	RGM_LoneWolfMode,
	RGM_SquadDeathmatch,
	RGM_SquadTeamDeathmatch,
	RGM_TerroristHuntAdvMode,
	RGM_ScatteredHuntAdvMode,
	RGM_CaptureTheEnemyAdvMode,
	RGM_CountDownMode,
	RGM_KamikazeMode,
	RGM_NoRulesMode
};

var EGameModeInfo m_eMyGameMode;
var int m_iTextIndex;
var bool m_bFromStartList;
var bool m_bInGame;
var R6WindowTextLabelExt m_pTextInfo;
var R6WindowTextListBox m_pStartMapList;
var R6WindowTextListBox m_pFinalMapList;
var R6WindowComboControl m_pGameTypeCombo;
var Texture m_pButtonTexture;
var UWindowButton m_pSelectButton;
var UWindowButton m_pSubButton;
var UWindowButton m_pPlusButton;
var Region m_RArrowUp;
var Region m_RArrowDown;
var Region m_RArrowDisabled;
var Region m_RArrowOver;
var string m_szLocGameMode;
const C_iMAX_MAPLIST_SIZE= 32;
const C_fY_ButPos= 67;
const C_fX_ButPos= 148;
const C_fHEIGHT_OF_MAPLIST= 115;
const C_fWIDTH_OF_MAPLIST= 135;
const C_fY_START_MAPLIST= 16;
const C_fX_START_MAPLIST= 7;
const C_fX_START_TEXT= 5;

function Created ()
{
	local UWindowListBoxItem CurItem;
	local float fXOffset;
	local float fYOffset;
	local float fWidth;
	local float fXSecondWindow;

	fXSecondWindow=WinWidth - 7 - 135;
	m_pTextInfo=R6WindowTextLabelExt(CreateWindow(Class'R6WindowTextLabelExt',0.00,0.00,WinWidth,WinHeight,self));
	m_pTextInfo.bAlwaysBehind=True;
	m_pTextInfo.SetNoBorder();
	m_pTextInfo.m_Font=Root.Fonts[5];
	m_pTextInfo.m_vTextColor=Root.Colors.White;
	fXOffset=5.00;
	fYOffset=0.00;
	fWidth=135.00;
//	m_pTextInfo.AddTextLabel(Localize("MPCreateGame","Options_Map","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fXOffset=fXSecondWindow;
//	m_pTextInfo.AddTextLabel(Localize("MPCreateGame","Options_MapList","R6Menu"),fXOffset,fYOffset,fWidth,0,False);
	fXOffset=5.00;
	fYOffset=16.00 + 115 + 5;
	m_pTextInfo.m_Font=Root.Fonts[6];
//	m_iTextIndex=m_pTextInfo.AddTextLabel(m_szLocGameMode $ " " $ Localize("MPCreateGame","Options_GameType","R6Menu"),fXOffset,fYOffset,fXSecondWindow - fXOffset,0,False);
	m_pStartMapList=R6WindowTextListBox(CreateControl(Class'R6WindowTextListBox',7.00,16.00,135.00,115.00,self));
	m_pStartMapList.TextColor=Root.Colors.BlueLight;
//	m_pStartMapList.SetCornerType(0);
	m_pStartMapList.SetOverBorderColorEffect(Root.Colors.GrayLight);
	m_pStartMapList.ToolTipString=Localize("Tip","Options_Map","R6Menu");
	m_pFinalMapList=R6WindowTextListBox(CreateControl(Class'R6WindowTextListBox',fXSecondWindow,16.00,135.00,115.00,self));
	m_pFinalMapList.TextColor=Root.Colors.BlueLight;
//	m_pFinalMapList.SetCornerType(0);
	m_pFinalMapList.SetOverBorderColorEffect(Root.Colors.GrayLight);
	m_pFinalMapList.ToolTipString=Localize("Tip","Options_MapList","R6Menu");
	m_pSelectButton=UWindowButton(CreateControl(Class'UWindowButton',148.00,67.00,13.00,13.00,self));
	m_pSelectButton.m_bDrawButtonBorders=True;
	SetButtonRegion(True);
	m_pSelectButton.ToolTipString=Localize("Tip","Options_MapListAddRemove","R6Menu");
	fYOffset=16.00 + 115 + 5;
	m_pGameTypeCombo=R6WindowComboControl(CreateControl(Class'R6WindowComboControl',fXSecondWindow,fYOffset,fWidth,LookAndFeel.Size_ComboHeight));
	m_pGameTypeCombo.SetFont(6);
	m_pGameTypeCombo.SetEditBoxTip(Localize("Tip","Options_MapListGameType","R6Menu"));
	CreateButtons();
}

function CreateButtons ()
{
	local Region RDisableRegion;
	local Region RNormalRegion;
	local Region ROverRegion;
	local float fHeight;
	local float fButtonWidth;
	local float fButtonHeight;

	RNormalRegion.X=0;
	RNormalRegion.Y=0;
	RNormalRegion.W=11;
	RNormalRegion.H=8;
	RDisableRegion.X=0;
	RDisableRegion.Y=16;
	RDisableRegion.W=11;
	RDisableRegion.H=8;
	ROverRegion.X=0;
	ROverRegion.Y=8;
	ROverRegion.W=11;
	ROverRegion.H=8;
	fButtonWidth=13.00;
	fButtonHeight=12.00;
	fHeight=m_pSelectButton.WinTop - fButtonHeight - 10;
	m_pSubButton=UWindowButton(CreateControl(Class'UWindowButton',148.00,fHeight,fButtonWidth,fButtonHeight,self));
	m_pSubButton.m_bDrawButtonBorders=True;
	m_pSubButton.bUseRegion=True;
	m_pSubButton.DownTexture=R6MenuRSLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pSubButton.DownRegion=RDisableRegion;
	m_pSubButton.OverTexture=R6MenuRSLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pSubButton.OverRegion=ROverRegion;
	m_pSubButton.UpTexture=R6MenuRSLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pSubButton.UpRegion=RNormalRegion;
	m_pSubButton.DisabledTexture=R6MenuRSLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pSubButton.DisabledRegion=RDisableRegion;
	m_pSubButton.ImageX=1.00;
	m_pSubButton.ImageY=2.00;
	RNormalRegion.X=0;
	RNormalRegion.Y=8;
	RNormalRegion.W=11;
	RNormalRegion.H=-8;
	RDisableRegion.X=0;
	RDisableRegion.Y=24;
	RDisableRegion.W=11;
	RDisableRegion.H=-8;
	ROverRegion.X=0;
	ROverRegion.Y=16;
	ROverRegion.W=11;
	ROverRegion.H=-8;
	fHeight=m_pSelectButton.WinTop + m_pSelectButton.WinHeight + 10;
	m_pPlusButton=UWindowButton(CreateControl(Class'UWindowButton',148.00,fHeight,fButtonWidth,fButtonHeight,self));
	m_pPlusButton.m_bDrawButtonBorders=True;
	m_pPlusButton.bUseRegion=True;
	m_pPlusButton.DownTexture=R6MenuRSLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pPlusButton.DownRegion=RDisableRegion;
	m_pPlusButton.OverTexture=R6MenuRSLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pPlusButton.OverRegion=ROverRegion;
	m_pPlusButton.UpTexture=R6MenuRSLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pPlusButton.UpRegion=RNormalRegion;
	m_pPlusButton.DisabledTexture=R6MenuRSLookAndFeel(LookAndFeel).m_TButtonBackGround;
	m_pPlusButton.DisabledRegion=RDisableRegion;
	m_pPlusButton.ImageX=1.00;
	m_pPlusButton.ImageY=2.00;
	SetOrderButtons(True);
}

function FillMapListItem ()
{
	local R6WindowListBoxItem NewItem;
	local int i;
	local int j;
	local string szLocMapName;
	local R6Console R6Console;
	local R6MissionDescription mission;
	local LevelInfo pLevel;
	local string szMod;
	local string szRavenShieldMod;
	local bool bLoadMap;

	pLevel=GetLevel();
	R6Console=R6Console(Root.Console);
	m_pStartMapList.Items.Clear();
	szMod=Class'Actor'.static.GetModMgr().m_pCurrentMod.m_szKeyWord;
	szRavenShieldMod=Class'Actor'.static.GetModMgr().m_pRVS.m_szKeyWord;
	i=0;
JL008C:
	if ( i < R6Console.m_aMissionDescriptions.Length )
	{
		mission=R6Console.m_aMissionDescriptions[i];
		if ( mission.m_MapName != "" )
		{
			j=0;
JL00DB:
			if ( j < mission.m_eGameTypes.Length )
			{
				bLoadMap=False;
				if ( szMod ~= mission.mod )
				{
					bLoadMap=True;
				}
				else
				{
					if ( mission.mod ~= szRavenShieldMod )
					{
						bLoadMap=True;
					}
				}
/*				if ( bLoadMap && pLevel.IsGameTypeMultiplayer(mission.m_eGameTypes[j],True) )
				{
					NewItem=R6WindowListBoxItem(m_pStartMapList.Items.Append(m_pStartMapList.ListClass));
					if (  !Root.GetMapNameLocalisation(mission.m_MapName,szLocMapName) )
					{
						szLocMapName=mission.m_MapName;
					}
					NewItem.HelpText=szLocMapName;
					NewItem.m_szMisc=mission.m_MapName;
				}
				else
				{
					j++;
					goto JL00DB;
				}*/
			}
		}
		++i;
		goto JL008C;
	}
	m_pStartMapList.Items.Sort();
}

function string GetNewServerProfileGameMode (optional bool _bInGame)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local string szResult;
	local R6ServerInfo pServerOpt;
	local R6GameReplicationInfo _GRI;

//	szResult=string(GetPlayerOwner().3);
	if ( _bInGame )
	{
		r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
		_GRI=R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo);
		if ( _GRI != None )
		{
//			szResult=GetGameModeFromList(GetLevel().GetER6GameTypeFromClassName(_GRI.m_gameModeArray[0]));
		}
	}
	else
	{
		pServerOpt=Class'Actor'.static.GetServerOptions();
		if ( pServerOpt.m_ServerMapList != None )
		{
//			szResult=GetGameModeFromList(GetLevel().GetER6GameTypeFromClassName(pServerOpt.m_ServerMapList.GameType[0]));
		}
	}
	return szResult;
}

function string GetGameModeFromList (ER6GameType _eGameType)
{
	local string szResult;

//	szResult=string(GetPlayerOwner().3);
/*	if ( GetLevel().IsGameTypeCooperative(_eGameType) )
	{
//		szResult=string(GetPlayerOwner().2);
	}*/
	return szResult;
}

function string FillFinalMapList ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local UWindowListBoxItem NewItem;
	local int i;
	local ER6GameType eGameType;
	local string szResult;
	local string szTemp;
	local R6ServerInfo pServerOpt;
	local LevelInfo pLevel;

	pServerOpt=Class'Actor'.static.GetServerOptions();
	pLevel=GetLevel();
	m_pFinalMapList.Items.Clear();
	if ( pServerOpt.m_ServerMapList == None )
	{
		pServerOpt.m_ServerMapList=GetPlayerOwner().Spawn(Class'R6MapList');
	}
	i=0;
JL0072:
	if ( (i < 32) && (pServerOpt.m_ServerMapList.Maps[i] != "") )
	{
//		eGameType=pLevel.GetER6GameTypeFromClassName(pServerOpt.m_ServerMapList.GameType[i]);
		szTemp=GetGameModeFromList(eGameType);
/*		if ( m_eMyGameMode == GetPlayerOwner().3 )
		{
			if (  !pLevel.IsGameTypeAdversarial(eGameType) )
			{
				if ( szResult == "" )
				{
					szResult=szTemp;
				}
			}
			else
			{
				szResult=szTemp;
				goto JL01A0;
				if ( m_eMyGameMode == GetPlayerOwner().2 )
				{
					if (  !pLevel.IsGameTypeCooperative(eGameType) )
					{
						if ( szResult == "" )
						{
							szResult=szTemp;
						}
					}
					else
					{
						szResult=szTemp;
						goto JL01A0;
						goto JL032A;
JL01A0:
						if (  !Root.GetMapNameLocalisation(pServerOpt.m_ServerMapList.Maps[i],szTemp) )
						{
							if (  !FindMapInStartMapList(pServerOpt.m_ServerMapList.Maps[i]) )
							{
								goto JL032A;
							}
							szTemp=pServerOpt.m_ServerMapList.Maps[i];
						}
						NewItem=UWindowListBoxItem(m_pFinalMapList.Items.Append(m_pFinalMapList.ListClass));
						NewItem.HelpText=szTemp;
						R6WindowListBoxItem(NewItem).m_szMisc=pServerOpt.m_ServerMapList.Maps[i];
						NewItem.m_bUseSubText=True;
						NewItem.m_stSubText.FontSubText=Root.Fonts[10];
						NewItem.m_stSubText.fHeight=10.00;
						NewItem.m_stSubText.fXOffset=10.00;
						NewItem.m_stSubText.szGameTypeSelect=pLevel.GetGameNameLocalization(eGameType);
					}
				}
			}
		}*/
JL032A:
		i++;
		goto JL0072;
	}
	if ( szResult == "" )
	{
		szResult=string(m_eMyGameMode);
	}
	return szResult;
}

function string FillFinalMapListInGame ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local UWindowListBoxItem NewItem;
	local int i;
	local ER6GameType eGameType;
	local string szResult;
	local string szTemp;
	local R6GameReplicationInfo _GRI;
	local LevelInfo pLevel;

	pLevel=GetLevel();
	m_pFinalMapList.Items.Clear();
	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	_GRI=R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo);
	i=0;
JL005D:
/*	if ( (i < _GRI.32) && (_GRI.m_mapArray[i] != "") )
	{
		eGameType=pLevel.GetER6GameTypeFromClassName(_GRI.m_gameModeArray[i]);
		szTemp=GetGameModeFromList(eGameType);
		if ( m_eMyGameMode == GetPlayerOwner().3 )
		{
			if (  !pLevel.IsGameTypeAdversarial(eGameType) )
			{
				if ( szResult == "" )
				{
					szResult=szTemp;
				}
			}
			else
			{
				szResult=szTemp;
				goto JL0182;
				if ( m_eMyGameMode == GetPlayerOwner().2 )
				{
					if (  !pLevel.IsGameTypeCooperative(eGameType) )
					{
						if ( szResult == "" )
						{
							szResult=szTemp;
						}
					}
					else
					{
						szResult=szTemp;
						goto JL0182;
						goto JL0310;
JL0182:
						NewItem=UWindowListBoxItem(m_pFinalMapList.Items.Append(m_pFinalMapList.ListClass));
						if (  !Root.GetMapNameLocalisation(_GRI.m_mapArray[i],NewItem.HelpText) )
						{
							if ( FindMapInStartMapList(_GRI.m_mapArray[i]) )
							{
								NewItem.HelpText=_GRI.m_mapArray[i];
							}
							else
							{
								NewItem.HelpText=Localize("General","None","R6Menu");
							}
						}
						R6WindowListBoxItem(NewItem).m_szMisc=_GRI.m_mapArray[i];
						NewItem.m_bUseSubText=True;
						NewItem.m_stSubText.FontSubText=Root.Fonts[10];
						NewItem.m_stSubText.fHeight=10.00;
						NewItem.m_stSubText.fXOffset=10.00;
						NewItem.m_stSubText.szGameTypeSelect=pLevel.GetGameNameLocalization(eGameType);
					}
				}
			}
		}
JL0310:
		i++;
		goto JL005D;
	}*/
	if ( szResult == "" )
	{
		szResult=string(m_eMyGameMode);
	}
	return szResult;
}

function SetGameModeToDisplay (string _szIndex)
{
	m_pTextInfo.ChangeTextLabel(m_szLocGameMode $ " " $ Localize("MPCreateGame","Options_GameType","R6Menu"),m_iTextIndex);
	m_pGameTypeCombo.Clear();
	InitMode(_szIndex);
}

function InitMode (string _szIndex)
{
/*	local ER6GameType eGameTypeFind;
	local ER6GameType eFirstGameType;
	local int i;
	local bool bFindGameType;
	local bool bFirstValue;
	local LevelInfo pLevel;

	pLevel=GetLevel();
	i=0;
JL0013:
	if ( i < GetPlayerOwner().25 )
	{
		eGameTypeFind=pLevel.ConvertGameTypeIntToEnum(i);
		if ( pLevel.IsGameTypeMultiplayer(eGameTypeFind) )
		{
			switch (_szIndex)
			{
				case string(GetPlayerOwner().3):
				if ( pLevel.IsGameTypeAdversarial(eGameTypeFind) )
				{
					bFindGameType=True;
				}
				break;
				case string(GetPlayerOwner().2):
				if ( pLevel.IsGameTypeCooperative(eGameTypeFind) )
				{
					bFindGameType=True;
				}
				break;
				default:
				Log("GAME MODE NOT DEFINED");
				break;
			}
			if ( bFindGameType )
			{
				bFindGameType=Class'Actor'.static.GetModMgr().IsGameTypeAvailable(eGameTypeFind);
			}
			if ( bFindGameType )
			{
				m_pGameTypeCombo.AddItem(pLevel.GetGameNameLocalization(eGameTypeFind),string(eGameTypeFind));
				if (  !bFirstValue )
				{
					bFirstValue=True;
					eFirstGameType=eGameTypeFind;
				}
			}
			bFindGameType=False;
		}
		i++;
		goto JL0013;
	}
	ManageAvailableGameTypes(m_pStartMapList.GetSelectedItem());
	if ( m_pFinalMapList.GetSelectedItem() == None )
	{
		m_pGameTypeCombo.SetValue(pLevel.GetGameNameLocalization(eFirstGameType),string(eFirstGameType));
	}
	else
	{
		ManageAvailableGameTypes(m_pFinalMapList.GetSelectedItem(),True);
	}*/
}

function ManageAvailableGameTypes (UWindowList _pSelectItem, optional bool _bKeepItemGameType)
{
	local UWindowComboListItem pComboListItem;
	local R6MissionDescription pCurMissionDesc;
	local ER6GameType eGameTypeFind;
	local ER6GameType eFirstGameTypeFound;
	local ER6GameType eItemGameType;
	local R6Console R6Console;
	local string szMapName;
	local string szEditBoxValue;
	local int i;
	local bool bUseSameGameType;
	local LevelInfo pLevel;

	pLevel=GetLevel();
	R6Console=R6Console(Root.Console);
	if ( _pSelectItem == None )
	{
		return;
	}
	szMapName=R6WindowListBoxItem(_pSelectItem).m_szMisc;
//	eItemGameType=pLevel.GetER6GameTypeFromLocName(UWindowListBoxItem(_pSelectItem).m_stSubText.szGameTypeSelect);
	i=0;
JL007F:
	if ( i < R6Console.m_aMissionDescriptions.Length )
	{
		if ( szMapName == R6Console.m_aMissionDescriptions[i].m_MapName )
		{
			pCurMissionDesc=R6Console.m_aMissionDescriptions[i];
		}
		else
		{
			++i;
			goto JL007F;
		}
	}
	if ( pCurMissionDesc != None )
	{
		m_pGameTypeCombo.DisableAllItems();
		szEditBoxValue=m_pGameTypeCombo.GetValue();
//		eFirstGameTypeFound=25;
		i=0;
JL0124:
		if ( i < pCurMissionDesc.m_eGameTypes.Length )
		{
//			eGameTypeFind=pCurMissionDesc.m_eGameTypes[i];
//			pComboListItem=m_pGameTypeCombo.GetItem(pLevel.GetGameNameLocalization(eGameTypeFind));
			if ( pComboListItem != None )
			{
				pComboListItem.bDisabled=False;
				if ( eFirstGameTypeFound == 25 )
				{
					eFirstGameTypeFound=eGameTypeFind;
				}
				if ( _bKeepItemGameType && (eItemGameType == eGameTypeFind) )
				{
					eFirstGameTypeFound=eGameTypeFind;
				}
				else
				{
/*					if ( szEditBoxValue == pLevel.GetGameNameLocalization(eGameTypeFind) )
					{
						bUseSameGameType=True;
					}*/
				}
			}
			i++;
			goto JL0124;
		}
	}
	if (  !bUseSameGameType && (eFirstGameTypeFound != 25) )
	{
//		m_pGameTypeCombo.SetValue(pLevel.GetGameNameLocalization(eFirstGameTypeFound),string(eFirstGameTypeFound));
	}
}

function CopyAndAddItemInList (UWindowListBoxItem _ItemToAdd, UWindowListControl _ListAddItem)
{
	local UWindowListBoxItem NewItem;

	if ( _ListAddItem.Items.Count() < 32 )
	{
		NewItem=UWindowListBoxItem(_ListAddItem.Items.Append(_ListAddItem.ListClass));
		NewItem.HelpText=_ItemToAdd.HelpText;
		R6WindowListBoxItem(NewItem).m_szMisc=R6WindowListBoxItem(_ItemToAdd).m_szMisc;
		NewItem.m_bUseSubText=True;
		NewItem.m_stSubText.FontSubText=Root.Fonts[10];
		NewItem.m_stSubText.fHeight=10.00;
		NewItem.m_stSubText.fXOffset=10.00;
		NewItem.m_stSubText.szGameTypeSelect=m_pGameTypeCombo.GetValue();
	}
}

function bool FindMapInStartMapList (string _szMapName)
{
	local UWindowListBoxItem CurItem;

	CurItem=UWindowListBoxItem(m_pStartMapList.Items.Next);
JL0022:
	if ( CurItem != None )
	{
		if ( R6WindowListBoxItem(CurItem).m_szMisc == _szMapName )
		{
			return True;
		}
		CurItem=UWindowListBoxItem(CurItem.Next);
		goto JL0022;
	}
	return False;
}

function Notify (UWindowDialogControl C, byte E)
{
	if ( m_bInGame )
	{
/*		if (  !R6PlayerController(GetPlayerOwner()).CheckAuthority(R6PlayerController(GetPlayerOwner()).1) )
		{
			return;
		}*/
	}
	if ( C.IsA('R6WindowTextListBox') )
	{
		switch (E)
		{
			case 2:
			if ( C == m_pStartMapList )
			{
				if ( m_pStartMapList.GetSelectedItem() != None )
				{
					ManageAvailableGameTypes(m_pStartMapList.GetSelectedItem());
				}
				m_pFinalMapList.DropSelection();
				SetButtonRegion(True);
			}
			else
			{
				if ( m_pFinalMapList.GetSelectedItem() != None )
				{
					ManageAvailableGameTypes(m_pFinalMapList.GetSelectedItem(),True);
					m_pGameTypeCombo.SetValue(m_pFinalMapList.GetSelectedItem().m_stSubText.szGameTypeSelect);
				}
				m_pStartMapList.DropSelection();
				SetButtonRegion(False);
			}
			break;
			case 11:
			ManageTextListBox();
			break;
			default:
			break;
		}
	}
	else
	{
		if ( C.IsA('R6WindowComboControl') )
		{
			switch (E)
			{
				case 1:
				ManageComboChange();
				break;
				default:
				break;
			}
		}
		else
		{
			if ( C.IsA('UWindowButton') )
			{
				if ( UWindowButton(C).bDisabled || (C != m_pSelectButton) && (m_pFinalMapList.GetSelectedItem() == None) )
				{
					return;
				}
				switch (E)
				{
					case 2:
					if ( C == m_pSelectButton )
					{
						ManageTextListBox();
					}
					else
					{
						m_pFinalMapList.SwapItem(m_pFinalMapList.GetSelectedItem(),C != m_pPlusButton);
					}
					break;
					case 12:
					UWindowButton(C).m_BorderColor=Root.Colors.BlueLight;
					break;
					case 9:
					UWindowButton(C).m_BorderColor=Root.Colors.White;
					break;
					default:
				}
			}
		}
	}
}

function ManageTextListBox ()
{
	local UWindowListBoxItem Item;
	local UWindowListBoxItem NextItem;
	local UWindowListBoxItem PrevItem;

	Item=m_pStartMapList.GetSelectedItem();
	if ( Item != None )
	{
		if ( m_pGameTypeCombo.GetValue() != "" )
		{
			CopyAndAddItemInList(Item,m_pFinalMapList);
		}
	}
	else
	{
		Item=m_pFinalMapList.GetSelectedItem();
		if ( Item != None )
		{
			PrevItem=m_pFinalMapList.CheckForPrevItem(Item);
			NextItem=m_pFinalMapList.CheckForNextItem(Item);
			Item.Remove();
			m_pFinalMapList.DropSelection();
			if ( m_pFinalMapList.Items.Next == None )
			{
				m_pFinalMapList.Items.Clear();
				SetButtonRegion(True);
			}
			else
			{
				if ( NextItem != None )
				{
					Item=NextItem;
				}
				else
				{
					if ( PrevItem != None )
					{
						Item=PrevItem;
					}
				}
				if ( Item != None )
				{
					m_pFinalMapList.SetSelectedItem(Item);
					m_pFinalMapList.MakeSelectedVisible();
				}
				SetButtonRegion(False);
			}
		}
	}
}

function WindowStateChange ()
{
	local UWindowListBoxItem Item;

	Item=m_pFinalMapList.GetSelectedItem();
	if ( Item != None )
	{
		m_bFromStartList=False;
	}
	else
	{
		m_bFromStartList=True;
	}
	SetButtonRegion( !m_bFromStartList);
}

function ManageComboChange ()
{
	local UWindowListBoxItem Item;
	local UWindowComboListItem pComboListItem;

	Item=m_pStartMapList.GetSelectedItem();
	if ( Item != None )
	{
		pComboListItem=m_pGameTypeCombo.GetItem(m_pGameTypeCombo.GetValue());
		if ( pComboListItem != None )
		{
			if (  !pComboListItem.bDisabled )
			{
				Item.m_stSubText.szGameTypeSelect=m_pGameTypeCombo.GetValue();
			}
		}
		return;
	}
	Item=m_pFinalMapList.GetSelectedItem();
	if ( Item != None )
	{
		pComboListItem=m_pGameTypeCombo.GetItem(m_pGameTypeCombo.GetValue());
		if ( pComboListItem != None )
		{
			if (  !pComboListItem.bDisabled )
			{
				Item.m_stSubText.szGameTypeSelect=m_pGameTypeCombo.GetValue();
			}
		}
	}
}

function SetButtonRegion (bool _bInverseTex)
{
	m_pSelectButton.bUseRegion=True;
	if ( _bInverseTex )
	{
		m_pSelectButton.ImageX=1.00;
		m_pSelectButton.ImageY=3.00;
		m_pSelectButton.m_fRotAngleWidth=9.00;
		m_pSelectButton.m_fRotAngleHeight=7.00;
	}
	else
	{
		m_pSelectButton.ImageX=3.00;
		m_pSelectButton.ImageY=3.00;
		m_pSelectButton.m_fRotAngleWidth=9.00;
		m_pSelectButton.m_fRotAngleHeight=7.00;
	}
	m_pSelectButton.UpTexture=m_pButtonTexture;
	m_pSelectButton.DownTexture=m_pButtonTexture;
	m_pSelectButton.OverTexture=m_pButtonTexture;
	m_pSelectButton.DisabledTexture=m_pButtonTexture;
	m_pSelectButton.UpRegion=m_RArrowUp;
	m_pSelectButton.DownRegion=m_RArrowDown;
	m_pSelectButton.OverRegion=m_RArrowOver;
	m_pSelectButton.DisabledRegion=m_RArrowDisabled;
	m_pSelectButton.m_bUseRotAngle=_bInverseTex;
	m_pSelectButton.m_fRotAngle=3.14;
	SetOrderButtons(_bInverseTex);
}

function SetOrderButtons (bool _bDisable)
{
	if ( (m_pSubButton == None) || (m_pPlusButton == None) )
	{
		return;
	}
	if ( _bDisable || (m_pFinalMapList.Items.CountShown() <= 1) )
	{
		m_pSubButton.m_BorderColor=Root.Colors.GrayLight;
		m_pSubButton.bDisabled=True;
		m_pPlusButton.m_BorderColor=Root.Colors.GrayLight;
		m_pPlusButton.bDisabled=True;
	}
	else
	{
		m_pSubButton.m_BorderColor=Root.Colors.White;
		m_pSubButton.bDisabled=False;
		m_pPlusButton.m_BorderColor=Root.Colors.White;
		m_pPlusButton.bDisabled=False;
	}
}

defaultproperties
{
    m_RArrowUp=(X=6169094,Y=570753024,W=47,H=598532)
    m_RArrowDown=(X=6169094,Y=570753024,W=54,H=598532)
    m_RArrowDisabled=(X=6169094,Y=570753024,W=47,H=598532)
    m_RArrowOver=(X=6169094,Y=570753024,W=47,H=598532)
}
/*
    m_pButtonTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

