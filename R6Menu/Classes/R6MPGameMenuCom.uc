//================================================================================
// R6MPGameMenuCom.
//================================================================================
class R6MPGameMenuCom extends R6GameMenuCom;

struct PlayerMenuInfo
{
	var string szPlayerName;
	var string szKilledBy;
	var int iKills;
	var int iEfficiency;
	var int iRoundsFired;
	var int iRoundsHit;
	var int iPingTime;
	var int iHealth;
	var int iTeamSelection;
	var int iRoundsPlayed;
	var int iRoundsWon;
	var int iDeathCount;
	var bool bOwnPlayer;
	var bool bSpectator;
	var bool bPlayerReady;
	var bool bJoinedTeamLate;
};

var R6MenuInGameMultiPlayerRootWindow m_pCurrentRoot;

simulated function SelectTeam ()
{
	if ( bShowLog )
	{
		Log("SelectTeam: currently m_TeamSelection=" $ string(m_PlayerController.m_TeamSelection) $ " m_PlayerController = " $ string(m_PlayerController));
	}
	if ( (m_PlayerController.m_TeamSelection == 0) || (GetGameType() != m_ePreviousGameType) || (m_iOldMapIndex != m_GameRepInfo.m_iMapIndex) )
	{
		m_iOldMapIndex=m_GameRepInfo.m_iMapIndex;
//		m_PlayerController.m_TeamSelection=0;
		SetStatMenuState(CMS_Initial);
	}
}

function PlayerSelection (ePlayerTeamSelection newTeam)
{
	m_pCurrentRoot.m_bPlayerDidASelection=True;
	Super.PlayerSelection(newTeam);
}

function ePlayerTeamSelection GetPlayerSelection ()
{
	if ( m_PlayerController != None )
	{
//		return m_PlayerController.m_TeamSelection;
	}
//	return 0;

// A enlever
    return PTS_UnSelected;
}

function bool IsAPlayerSelection ()
{
	return (GetPlayerSelection() == 2) || (GetPlayerSelection() == 3);
}

function SetStatMenuState (eClientMenuState _eNewClientMenuState)
{
	local bool bCloseSimplePopUpBox;

	bCloseSimplePopUpBox=True;
	m_pCurrentRoot.m_bActiveBar=False;
	if (  !m_pCurrentRoot.m_bPlayerDidASelection )
	{
		if ( _eNewClientMenuState == 0 )
		{
/*			if ( m_pCurrentRoot.m_eCurWidgetInUse == m_pCurrentRoot.23 )
			{
				return;
			}*/
		}
		else
		{
			return;
		}
	}
	switch (_eNewClientMenuState)
	{
/*		case 0:
		m_pCurrentRoot.m_bPreventMenuSwitch=False;
		m_pCurrentRoot.ChangeCurrentWidget(23);
		break;
		case 5:
		if ( m_pCurrentRoot.m_pSimplePopUp != None )
		{
			if ( m_pCurrentRoot.m_pSimplePopUp.bWindowVisible )
			{
				if ( m_pCurrentRoot.m_pSimplePopUp.m_ePopUpID == 28 )
				{
					m_pCurrentRoot.m_iWidgetKA=m_pCurrentRoot.0;
					return;
				}
			}
		}
		m_pCurrentRoot.m_pIntermissionMenuWidget.m_pInGameNavBar.SetNavBarState(False,True);
		if ( m_eStatMenuState == 4 )
		{
			return;
		}
		case 1:
		m_pCurrentRoot.m_bActiveBar=True;
		m_pCurrentRoot.m_pIntermissionMenuWidget.m_pInGameNavBar.SetNavBarState(False,True);
		m_pCurrentRoot.ChangeWidget(0,False,True);
		break;
		case 2:
		m_pCurrentRoot.m_bActiveBar=True;
		m_pCurrentRoot.GetLevel().SetBankSound(BANK_UnloadGun);
		if ( m_GameRepInfo.IsInAGameState() )
		{
			m_pCurrentRoot.ChangeCurrentWidget(24);
			_eNewClientMenuState=1;
		}
		else
		{
			m_pCurrentRoot.ChangeCurrentWidget(25);
			bCloseSimplePopUpBox=False;
		}
		break;
		case 3:
		break;
		case 4:
		if ( (m_PlayerController.m_TeamSelection == 2) || (m_PlayerController.m_TeamSelection == 3) )
		{
			SetReadyButton(False);
		}
		m_pCurrentRoot.ChangeCurrentWidget(25);
		m_pCurrentRoot.GetLevel().SetBankSound(BANK_UnloadGun);
		break;
		case 6:
		m_pCurrentRoot.ChangeCurrentWidget(25);
		m_pCurrentRoot.m_bPreventMenuSwitch=True;
		Class'Actor'.static.EnableLoadingScreen(False);
		m_pCurrentRoot.GetLevel().SetBankSound(BANK_UnloadGun);
		m_pCurrentRoot.m_pIntermissionMenuWidget.m_pInGameNavBar.SetNavBarState(True);
		break;
		case 7:
		m_pCurrentRoot.m_pIntermissionMenuWidget.ForceClosePopUp();
		break;
		default:
		bCloseSimplePopUpBox=False;
		break;*/
	}
	if ( bCloseSimplePopUpBox )
	{
		m_pCurrentRoot.CloseSimplePopUpBox();
	}
	m_eStatMenuState=_eNewClientMenuState;
}

function SetupPlayerPrefs ()
{
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
	local int k;
	local Class<R6GadgetDescription> replaceGadgetClass;

	PrimaryWeaponClass=Class<R6PrimaryWeaponDescription>(DynamicLoadObject(m_szPrimaryWeapon,Class'Class'));
	PrimaryWeaponBulletClass=Class'R6DescriptionManager'.static.GetPrimaryBulletDesc(PrimaryWeaponClass,m_szPrimaryWeaponBullet);
	PrimaryWeaponGadgetClass=Class'R6DescriptionManager'.static.GetPrimaryWeaponGadgetDesc(PrimaryWeaponClass,m_szPrimaryWeaponGadget);
	SecondaryWeaponClass=Class<R6SecondaryWeaponDescription>(DynamicLoadObject(m_szSecondaryWeapon,Class'Class'));
	SecondaryWeaponBulletClass=Class'R6DescriptionManager'.static.GetSecondaryBulletDesc(SecondaryWeaponClass,m_szSecondaryWeaponBullet);
	SecondaryWeaponGadgetClass=Class'R6DescriptionManager'.static.GetSecondaryWeaponGadgetDesc(SecondaryWeaponClass,m_szSecondaryWeaponGadget);
	PrimaryGadgetClass=Class<R6GadgetDescription>(DynamicLoadObject(m_szPrimaryGadget,Class'Class'));
	SecondaryGadgetClass=Class<R6GadgetDescription>(DynamicLoadObject(m_szSecondaryGadget,Class'Class'));
	if ( Class'R6MenuMPAdvGearWidget'.static.CheckGadget(string(PrimaryGadgetClass),m_pCurrentRoot,False,replaceGadgetClass) )
	{
		PrimaryGadgetClass=replaceGadgetClass;
	}
	if ( Class'R6MenuMPAdvGearWidget'.static.CheckGadget(string(SecondaryGadgetClass),m_pCurrentRoot,False,replaceGadgetClass,string(PrimaryGadgetClass)) )
	{
		SecondaryGadgetClass=replaceGadgetClass;
	}
	ArmorDescriptionClass=Class<R6ArmorDescription>(DynamicLoadObject(m_szArmor,Class'Class'));
	m_PlayerPrefInfo.m_ArmorName=ArmorDescriptionClass.Default.m_ClassName;
	m_PlayerPrefInfo.m_WeaponGadgetName[0]=PrimaryWeaponGadgetClass.Default.m_ClassName;
	m_PlayerPrefInfo.m_WeaponGadgetName[1]=SecondaryWeaponGadgetClass.Default.m_ClassName;
	m_PlayerPrefInfo.m_GadgetName[0]=PrimaryGadgetClass.Default.m_ClassName;
	m_PlayerPrefInfo.m_GadgetName[1]=SecondaryGadgetClass.Default.m_ClassName;
	Found=False;
	k=0;
JL01FC:
	if ( (k < PrimaryWeaponClass.Default.m_WeaponTags.Length) && (Found == False) )
	{
		if ( PrimaryWeaponClass.Default.m_WeaponTags[k] == PrimaryWeaponGadgetClass.Default.m_NameTag )
		{
			Found=True;
			m_PlayerPrefInfo.m_WeaponName[0]=PrimaryWeaponClass.Default.m_WeaponClasses[k];
			Tag=PrimaryWeaponClass.Default.m_WeaponTags[k];
		}
		else
		{
			if ( PrimaryWeaponClass.Default.m_WeaponTags[k] == PrimaryWeaponBulletClass.Default.m_NameTag )
			{
				Found=True;
				m_PlayerPrefInfo.m_WeaponName[0]=PrimaryWeaponClass.Default.m_WeaponClasses[k];
				Tag=PrimaryWeaponClass.Default.m_WeaponTags[k];
			}
		}
		k++;
		goto JL01FC;
	}
	if ( Found == False )
	{
		if ( PrimaryWeaponClass == Class'R6DescPrimaryWeaponNone' )
		{
			m_PlayerPrefInfo.m_WeaponName[0]="R6Description.R6DescPrimaryWeaponNone";
			Tag="NONE";
		}
		else
		{
			m_PlayerPrefInfo.m_WeaponName[0]=PrimaryWeaponClass.Default.m_WeaponClasses[0];
			Tag=PrimaryWeaponClass.Default.m_WeaponTags[0];
		}
	}
	if ( Tag == "SILENCED" )
	{
		m_PlayerPrefInfo.m_BulletType[0]=PrimaryWeaponBulletClass.Default.m_SubsonicClassName;
	}
	else
	{
		m_PlayerPrefInfo.m_BulletType[0]=PrimaryWeaponBulletClass.Default.m_ClassName;
	}
	Found=False;
	k=0;
JL03F1:
	if ( (k < SecondaryWeaponClass.Default.m_WeaponTags.Length) && (Found == False) )
	{
		if ( SecondaryWeaponClass.Default.m_WeaponTags[k] == SecondaryWeaponGadgetClass.Default.m_NameTag )
		{
			Found=True;
			m_PlayerPrefInfo.m_WeaponName[1]=SecondaryWeaponClass.Default.m_WeaponClasses[k];
			Tag=SecondaryWeaponClass.Default.m_WeaponTags[k];
		}
		else
		{
			if ( SecondaryWeaponClass.Default.m_WeaponTags[k] == SecondaryWeaponBulletClass.Default.m_NameTag )
			{
				Found=True;
				m_PlayerPrefInfo.m_WeaponName[1]=SecondaryWeaponClass.Default.m_WeaponClasses[k];
				Tag=SecondaryWeaponClass.Default.m_WeaponTags[k];
			}
		}
		k++;
		goto JL03F1;
	}
	if ( Found == False )
	{
		m_PlayerPrefInfo.m_WeaponName[1]=SecondaryWeaponClass.Default.m_WeaponClasses[0];
		Tag=SecondaryWeaponClass.Default.m_WeaponTags[0];
	}
	if ( Tag == "SILENCED" )
	{
		m_PlayerPrefInfo.m_BulletType[1]=SecondaryWeaponBulletClass.Default.m_SubsonicClassName;
	}
	else
	{
		m_PlayerPrefInfo.m_BulletType[1]=SecondaryWeaponBulletClass.Default.m_ClassName;
	}
}

function DisconnectClient (LevelInfo _Level)
{
	local UdpBeacon aBeacon;

	m_bImCurrentlyDisconnect=True;
	if ( _Level.NetMode == NM_ListenServer )
	{
		R6MultiPlayerGameInfo(_Level.Game).m_GameService.LogOutServer(R6GameReplicationInfo(m_GameRepInfo));
		R6GameInfo(_Level.Game).DestroyBeacon();
	}
}

function SetPlayerReadyStatus (bool _bPlayerReady)
{
	Super.SetPlayerReadyStatus(_bPlayerReady);
	if ( m_pCurrentRoot != None )
	{
		m_pCurrentRoot.m_pIntermissionMenuWidget.m_pInGameNavBar.m_pPlayerReady.m_bSelected=_bPlayerReady;
	}
}

function RefreshReadyButtonStatus ()
{
/*	if ( (m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.1) || (m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.0) )
	{
		if ( m_PlayerController.IsPlayerPassiveSpectator() || m_PlayerController.bOnlySpectator )
		{
			SetReadyButton(True);
		}
		else
		{
			SetReadyButton(False);
		}
	}
	else
	{
		if ( (m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.2) || (m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.3) || (m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.4) )
		{
			SetReadyButton(True);
		}
	}*/
}

function SetReadyButton (bool _bDisable)
{
	if ( m_pCurrentRoot != None )
	{
		if ( _bDisable )
		{
			m_pCurrentRoot.m_pIntermissionMenuWidget.m_pInGameNavBar.m_pPlayerReady.bDisabled=True;
		}
		else
		{
			m_pCurrentRoot.m_pIntermissionMenuWidget.m_pInGameNavBar.m_pPlayerReady.bDisabled=False;
		}
	}
}

function bool IsInBetweenRoundMenu (optional bool _bIncludeCMSInit)
{
	if ( _bIncludeCMSInit )
	{
		if ( m_eStatMenuState == 0 )
		{
			return True;
		}
	}
	if ( m_GameRepInfo == None )
	{
		return False;
	}
/*	if ( m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.1 )
	{
		return True;
	}*/
	return False;
}

function int GeTTeamSelection (int _iIndex)
{
	local PlayerMenuInfo _PlayerMenuInfo;

	if ( GetGameType() == 13 )
	{
//		return PTSToInt(2);
	}
	else
	{
//		m_pCurrentRoot.GetLevel().GetFPlayerMenuInfo(_iIndex,_PlayerMenuInfo);
		if ( (IntToPTS(_PlayerMenuInfo.iTeamSelection) == 2) || (IntToPTS(_PlayerMenuInfo.iTeamSelection) == 3) )
		{
			return _PlayerMenuInfo.iTeamSelection;
		}
		else
		{
//			return PTSToInt(4);
		}
	}
}

simulated function SavePlayerSetupInfo ()
{
	if ( m_PlayerController == None )
	{
		return;
	}
	m_pCurrentRoot.GetLevel().SetPlayerSetupInfo(m_PlayerPrefInfo.m_CharacterName,m_szArmor,m_szPrimaryWeapon,m_szPrimaryWeaponGadget,m_szPrimaryWeaponBullet,m_szSecondaryWeapon,m_szSecondaryWeaponGadget,m_szSecondaryWeaponBullet,m_szPrimaryGadget,m_szSecondaryGadget);
	SetupPlayerPrefs();
	m_PlayerController.m_PlayerPrefs.m_CharacterName=m_PlayerPrefInfo.m_CharacterName;
	m_PlayerController.m_PlayerPrefs.m_ArmorName=m_PlayerPrefInfo.m_ArmorName;
	m_PlayerController.m_PlayerPrefs.m_WeaponName1=m_PlayerPrefInfo.m_WeaponName[0];
	m_PlayerController.m_PlayerPrefs.m_WeaponGadgetName1=m_PlayerPrefInfo.m_WeaponGadgetName[0];
	m_PlayerController.m_PlayerPrefs.m_BulletType1=m_PlayerPrefInfo.m_BulletType[0];
	m_PlayerController.m_PlayerPrefs.m_WeaponName2=m_PlayerPrefInfo.m_WeaponName[1];
	m_PlayerController.m_PlayerPrefs.m_WeaponGadgetName2=m_PlayerPrefInfo.m_WeaponGadgetName[1];
	m_PlayerController.m_PlayerPrefs.m_BulletType2=m_PlayerPrefInfo.m_BulletType[1];
	m_PlayerController.m_PlayerPrefs.m_GadgetName1=m_PlayerPrefInfo.m_GadgetName[0];
	m_PlayerController.m_PlayerPrefs.m_GadgetName2=m_PlayerPrefInfo.m_GadgetName[1];
	m_PlayerController.ServerPlayerPref(m_PlayerController.m_PlayerPrefs);
}

simulated function InitialisePlayerSetupInfo ()
{
	if ( bShowLog )
	{
		Log("In " $ string(self) $ "::InitialisePlayerSetupInfo()");
	}
	m_pCurrentRoot.GetLevel().GetPlayerSetupInfo(m_PlayerPrefInfo.m_CharacterName,m_szArmor,m_szPrimaryWeapon,m_szPrimaryWeaponGadget,m_szPrimaryWeaponBullet,m_szSecondaryWeapon,m_szSecondaryWeaponGadget,m_szSecondaryWeaponBullet,m_szPrimaryGadget,m_szSecondaryGadget);
	SetupPlayerPrefs();
}

simulated function ER6GameType GetGameType ()
{
	if ( m_GameRepInfo == None )
	{
//		return m_pCurrentRoot.GetLevel().25;
	}
	else
	{
//		return m_GameRepInfo.m_eGameTypeFlag;
	}

// A enlever
	return RGM_AllMode;
}

function TKPopUpBox (string _KillerName)
{
	if ( R6PlayerController(m_PlayerController).m_bAlreadyPoppedTKPopUpBox == False )
	{
		if (  !m_pCurrentRoot.Console.IsInState('Game') )
		{
			m_pCurrentRoot.Console.GotoState('Game');
		}
//		m_pCurrentRoot.SimplePopUp(Localize("MPMiscMessages","TKPopUpBoxTitle","R6GameInfo"),_KillerName @ Localize("MPMiscMessages","DoYouWantToPenalize","R6GameInfo"),28);
		R6PlayerController(m_PlayerController).m_bAlreadyPoppedTKPopUpBox=True;
	}
}

function TKPopUpDone (bool _bApplyTeamKillerPenalty)
{
	m_PlayerController.ServerTKPopUpDone(_bApplyTeamKillerPenalty);
	R6PlayerController(m_PlayerController).m_bProcessingRequestTKPopUp=False;
}

event CountDownPopUpBox ()
{
	m_pCurrentRoot.Console.ViewportOwner.u8WaitLaunchStatingSound=0;
	if ( (m_PlayerController.m_TeamSelection == 2) || (m_PlayerController.m_TeamSelection == 3) )
	{
//		m_pCurrentRoot.ChangeCurrentWidget(33);
	}
}

function CountDownPopUpBoxDone ()
{
/*	if ( m_pCurrentRoot.m_eCurWidgetInUse != m_pCurrentRoot.33 )
	{
		if ( (m_pCurrentRoot.GetPlayerOwner().Pawn != None) && m_pCurrentRoot.GetPlayerOwner().Pawn.IsAlive() )
		{
			goto JL006C;
		}
		return;
	}
JL006C:
	m_pCurrentRoot.ChangeWidget(0,False,True);*/
}

function ActiveVoteMenu (bool _bActiveMenu, optional string _szPlayerNameToKick)
{
	m_pCurrentRoot.VoteMenu(_szPlayerNameToKick,_bActiveMenu);
}

function SetVoteResult (bool _bKickPlayer)
{
	if ( _bKickPlayer )
	{
		R6PlayerController(m_PlayerController).Vote(1);
		Log("KICK PLAYER YES");
	}
	else
	{
		R6PlayerController(m_PlayerController).Vote(2);
		Log("KICK PLAYER NO");
	}
}

function NewServerState ()
{
	local R6PlayerController _localPlayer;

	if ( m_GameRepInfo == None )
	{
		return;
	}
	Super.NewServerState();
/*	if ( m_GameRepInfo.m_eCurrectServerState == m_GameRepInfo.4 )
	{
		m_pCurrentRoot.m_pIntermissionMenuWidget.m_pMPInterHeader.RefreshRoundInfo();
	}*/
}

function SetClientServerSettings (bool _bCanChangeOptions)
{
	m_pCurrentRoot.m_pIntermissionMenuWidget.SetClientServerSettings(_bCanChangeOptions);
}

function int GetNbOfTeamPlayer (bool _bGreenTeam)
{
	local int i;
	local int iGreenTeam;
	local int iRedTeam;
	local int iNbOfPlayer;
	local int iIndex;

	RefreshMPlayerInfo();
	iGreenTeam=2;
	iRedTeam=3;
	iNbOfPlayer=0;
	i=0;
JL0028:
	if ( i < m_iLastValidIndex )
	{
		iIndex=GeTTeamSelection(i);
		if ( _bGreenTeam )
		{
			if ( iIndex == iGreenTeam )
			{
				iNbOfPlayer += 1;
			}
		}
		else
		{
			if ( iIndex == iRedTeam )
			{
				iNbOfPlayer += 1;
			}
		}
		i++;
		goto JL0028;
	}
	return Min(iNbOfPlayer,8);
}

simulated function bool IsInGame ()
{
	return m_pCurrentRoot.m_eCurWidgetInUse == 0;
}

function bool GetPlayerDidASelection ()
{
	return m_pCurrentRoot.m_bPlayerDidASelection;
}
