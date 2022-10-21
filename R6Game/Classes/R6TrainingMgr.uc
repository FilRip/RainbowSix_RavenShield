//================================================================================
// R6TrainingMgr.
//================================================================================
class R6TrainingMgr extends R6PracticeModeGame;

enum ETrainingWeapons {
	TW_SMG,
	TW_Pistol,
	TW_Sniper,
	TW_HBSensor,
	TW_Assault,
	TW_AssaultSilenced,
	TW_LMG,
	TW_Shotgun,
	TW_Grenades,
	TW_BreachCharge,
	TW_RemoteCharge,
	TW_Claymore,
	TW_MAX
};

var ETrainingWeapons m_eCurrentWeapon;
var int m_WeaponsSlot[12];
var bool m_bInitialized;
var R6EngineWeapon m_Weapons[12];
var string m_WeaponsName[12];
const C_NbWeapons= 12;

function bool IsBasicMap ()
{
	local string szMapName;

	szMapName=Class'Actor'.static.GetCanvas().Viewport.Console.Master.m_StartGameInfo.m_MapName;
	szMapName=Caps(szMapName);
	if ( szMapName == "TRAINING_BASICS" )
	{
		return True;
	}
	return False;
}

function float GetEndGamePauseTime ()
{
	if ( IsBasicMap() )
	{
		return 20.00;
	}
	return Super.GetEndGamePauseTime();
}

function bool CanChangeText (int iBoxNumber)
{
	return True;
}

function R6TrainingMgr GetTrainingMgr (R6Pawn P)
{
	return self;
}

function DeployCharacters (PlayerController ControlledByPlayer)
{
	local R6RainbowAI aRainbowAI;
	local int i;
	local R6PlayerController aPC;
	local R6Pawn pPawn;
	local string szMapName;
	local R6StartGameInfo StartGameInfo;

	Super.DeployCharacters(ControlledByPlayer);
	StartGameInfo=Class'Actor'.static.GetCanvas().Viewport.Console.Master.m_StartGameInfo;
	szMapName=StartGameInfo.m_MapName;
	szMapName=Caps(szMapName);
	if (  !(szMapName == "TRAINING_BASICS") || (szMapName == "TRAINING_SHOOTING") || (szMapName == "TRAINING_EXPLOSIVES") )
	{
		return;
	}
	m_Player.bGodMode=True;
	pPawn=R6Pawn(m_Player.Pawn);
	aPC=R6PlayerController(m_Player);
	i=0;
JL0102:
	if ( i < 12 )
	{
		R6PlayerController(m_Player).SetWeaponSound(m_Player.m_PawnRepInfo,m_WeaponsName[i],0);
		i++;
		goto JL0102;
	}
	R6PlayerController(m_Player).ClientFinalizeLoading(pPawn.Region.Zone);
	LoadWeapons();
}

function LoadWeapons ()
{
	local int i;
	local R6Pawn pPawn;

	pPawn=R6Pawn(m_Player.Pawn);
	i=0;
JL0020:
	if ( i < 12 )
	{
		if ( i == 0 )
		{
			pPawn.ServerGivesWeaponToClient(m_WeaponsName[i],1,"","R6WeaponGadgets.R6MiniScopeGadget");
		}
		else
		{
			if ( i == 2 )
			{
				pPawn.ServerGivesWeaponToClient(m_WeaponsName[i],1,"","R6WeaponGadgets.R6ThermalScopeGadget");
			}
			else
			{
				if ( i == 4 )
				{
					pPawn.ServerGivesWeaponToClient(m_WeaponsName[i],1,"","R6WeaponGadgets.R6MiniScopeGadget");
				}
				else
				{
					if ( i == 5 )
					{
						pPawn.ServerGivesWeaponToClient(m_WeaponsName[i],1,"","R6WeaponGadgets.R6SilencerGadget");
					}
					else
					{
						pPawn.ServerGivesWeaponToClient(m_WeaponsName[i],1,"","");
					}
				}
			}
		}
		m_Weapons[i]=pPawn.m_WeaponsCarried[0];
		pPawn.m_WeaponsCarried[0]=None;
		ShowWeaponAndAttachment(m_Weapons[i],False);
		m_Weapons[i].WeaponInitialization(pPawn);
		m_Weapons[i].LoadFirstPersonWeapon();
		i++;
		goto JL0020;
	}
}

function ResetGunAmmo ()
{
	local int i;

	i=0;
JL0007:
	if ( i < 4 )
	{
		if ( R6Pawn(m_Player.Pawn).m_WeaponsCarried[i] != None )
		{
			R6Pawn(m_Player.Pawn).m_WeaponsCarried[i].FillClips();
		}
		i++;
		goto JL0007;
	}
}

function ShowWeaponAndAttachment (R6EngineWeapon AWeapon, bool bShow)
{
	local R6AbstractWeapon pWeapon;

	pWeapon=R6AbstractWeapon(AWeapon);
	if ( pWeapon == None )
	{
		return;
	}
	pWeapon.bHidden= !bShow;
	if ( pWeapon.m_SelectedWeaponGadget != None )
	{
		pWeapon.m_SelectedWeaponGadget.bHidden= !bShow;
	}
	if ( pWeapon.m_MuzzleGadget != None )
	{
		pWeapon.m_MuzzleGadget.bHidden= !bShow;
	}
	if ( pWeapon.m_ScopeGadget != None )
	{
		pWeapon.m_ScopeGadget.bHidden= !bShow;
	}
	if ( pWeapon.m_BipodGadget != None )
	{
		pWeapon.m_BipodGadget.bHidden= !bShow;
	}
	if ( pWeapon.m_MagazineGadget != None )
	{
		pWeapon.m_MagazineGadget.bHidden= !bShow;
	}
}

function SwitchToWeapon (ETrainingWeapons eWT, bool bSwitch)
{
	local R6Pawn pPawn;
	local R6DemolitionsGadget pGadget;
	local R6EngineWeapon wpn;

	pPawn=R6Pawn(m_Player.Pawn);
	if ( (R6PlayerController(m_Player).m_TeamManager.m_iRainbowTeamName != 0) || (pPawn.m_iPermanentID != 0) )
	{
		return;
	}
	R6PlayerController(m_Player).DoZoom(True);
	if ( eWT >= 8 )
	{
		pGadget=R6DemolitionsGadget(m_Weapons[eWT]);
		if ( (pGadget != None) &&  !pGadget.IsInState('ChargeArmed') )
		{
			pGadget.UpdateHands();
		}
		if (  !m_Weapons[eWT].HasAmmo() )
		{
			pPawn.EngineWeapon.GotoState('RaiseWeapon');
		}
		m_Weapons[eWT].FullAmmo();
	}
	else
	{
		R6AbstractWeapon(m_Weapons[eWT]).m_FPHands.ResetNeutralAnim();
		wpn=R6Pawn(m_Player.Pawn).m_WeaponsCarried[m_WeaponsSlot[eWT]];
		if ( wpn != None )
		{
			wpn.FillClips();
		}
	}
	if ( m_eCurrentWeapon == eWT )
	{
		return;
	}
	ShowWeaponAndAttachment(pPawn.m_WeaponsCarried[m_WeaponsSlot[eWT]],False);
	ShowWeaponAndAttachment(m_Weapons[eWT],True);
	StopAllSoundsActor(pPawn.m_SoundRepInfo);
	pPawn.m_WeaponsCarried[m_WeaponsSlot[eWT]]=m_Weapons[eWT];
	R6PlayerController(m_Player).SetWeaponSound(m_Player.m_PawnRepInfo,m_WeaponsName[eWT],m_WeaponsSlot[eWT]);
	if ( pPawn.m_SoundRepInfo != None )
	{
		pPawn.m_SoundRepInfo.m_CurrentWeapon=m_WeaponsSlot[eWT];
	}
	m_eCurrentWeapon=eWT;
	if ( bSwitch )
	{
		if ( pPawn.EngineWeapon != None )
		{
			pPawn.EngineWeapon.bHidden=True;
			pPawn.EngineWeapon.GotoState('PutWeaponDown');
		}
		pPawn.ServerChangedWeapon(pPawn.EngineWeapon,m_Weapons[eWT]);
		if ( pPawn.EngineWeapon != None )
		{
			pPawn.EngineWeapon.GotoState('RaiseWeapon');
		}
	}
	else
	{
		m_Weapons[eWT].bHidden=True;
	}
}

function LoadPlanningInTraining ()
{
	local R6FileManagerPlanning pFileManager;
	local R6StartGameInfo StartGameInfo;
	local string szLoadErrorMsgMapName;
	local string szLoadErrorMsgGameType;
	local string szMapName;
	local string szGameTypeDirName;
	local string szEnglishGTDirectory;
	local R6MissionDescription missionDescription;
	local int i;
	local int j;

	StartGameInfo=Class'Actor'.static.GetCanvas().Viewport.Console.Master.m_StartGameInfo;
	pFileManager=new Class'R6FileManagerPlanning';
	missionDescription=R6MissionDescription(StartGameInfo.m_CurrentMission);
	szMapName=Localize(missionDescription.m_MapName,"ID_MENUNAME",missionDescription.LocalizationFile,True);
	if ( szMapName == "" )
	{
		szMapName=StartGameInfo.m_MapName;
	}
	Level.GetGameTypeSaveDirectories(szGameTypeDirName,szEnglishGTDirectory);
	if ( pFileManager.LoadPlanning(missionDescription.m_MapName,szMapName,szEnglishGTDirectory,szGameTypeDirName,missionDescription.m_ShortName $ "" $ m_szDefaultActionPlan,StartGameInfo,szLoadErrorMsgMapName,szLoadErrorMsgGameType) )
	{
		Log("LoadPlanningInTraining failed  map=" $ StartGameInfo.m_MapName $ " filename=" $ missionDescription.m_ShortName $ "" $ m_szDefaultActionPlan);
		Log("Planning Was Created for : " $ szLoadErrorMsgMapName $ " : " $ szLoadErrorMsgGameType);
	}
	i=0;
JL01BC:
	if ( i < 3 )
	{
		R6PlanningInfo(StartGameInfo.m_TeamInfo[i].m_pPlanning).InitPlanning(i,None);
		if ( R6PlanningInfo(StartGameInfo.m_TeamInfo[i].m_pPlanning).GetNbActionPoint() > 0 )
		{
			R6PlanningInfo(StartGameInfo.m_TeamInfo[i].m_pPlanning).m_iCurrentNode=0;
		}
		else
		{
			R6PlanningInfo(StartGameInfo.m_TeamInfo[i].m_pPlanning).m_iCurrentNode=-1;
		}
		j=0;
JL0294:
		if ( j < StartGameInfo.m_TeamInfo[i].m_iNumberOfMembers )
		{
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_CharacterName=Localize("Training","ROOKIE","R6Menu",True);
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_FaceTexture=Class'R6RookieAssault'.Default.m_TMenuFaceSmall;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_FaceCoords.X=Class'R6RookieAssault'.Default.m_RMenuFaceSmallX;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_FaceCoords.Y=Class'R6RookieAssault'.Default.m_RMenuFaceSmallY;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_FaceCoords.Z=Class'R6RookieAssault'.Default.m_RMenuFaceSmallW;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_FaceCoords.W=Class'R6RookieAssault'.Default.m_RMenuFaceSmallH;
			if ( (i == 2) && (j == 0) )
			{
				StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_szSpecialityID="ID_SNIPER";
			}
			else
			{
				StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_szSpecialityID="ID_ASSAULT";
			}
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_fSkillAssault=0.85;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_fSkillDemolitions=0.85;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_fSkillElectronics=0.85;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_fSkillSniper=0.85;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_fSkillStealth=0.85;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_fSkillSelfControl=0.85;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_fSkillLeadership=0.85;
			StartGameInfo.m_TeamInfo[i].m_CharacterInTeam[j].m_fSkillObservation=0.85;
			j++;
			goto JL0294;
		}
		i++;
		goto JL01BC;
	}
}

function LaunchAction (int iBoxNb, int iSoundIndex)
{
	local R6GameReplicationInfo aGRI;

	if ( (m_Player == None) || (R6Pawn(m_Player.Pawn) == None) )
	{
		return;
	}
	aGRI=R6GameReplicationInfo(GameReplicationInfo);
	if ( iSoundIndex == 0 )
	{
		switch (iBoxNb)
		{
			case 1:
			break;
			case 8:
/*			SwitchToWeapon(1,False);
			SwitchToWeapon(0,True);*/
			break;
			case 9:
//			SwitchToWeapon(0,True);
			break;
			case 10:
//			SwitchToWeapon(1,True);
			break;
			case 11:
//			SwitchToWeapon(0,True);
			break;
			case 12:
//			SwitchToWeapon(4,True);
			break;
			case 13:
//			SwitchToWeapon(7,True);
			break;
			case 14:
//			SwitchToWeapon(2,True);
			break;
			case 15:
//			SwitchToWeapon(6,True);
			break;
			case 16:
/*			SwitchToWeapon(11,False);
			SwitchToWeapon(8,True);*/
			break;
			case 17:
//			SwitchToWeapon(8,True);
			break;
			case 18:
//			SwitchToWeapon(9,True);
			break;
			case 19:
//			SwitchToWeapon(11,True);
			break;
			case 20:
//			SwitchToWeapon(10,True);
			break;
			case 21:
			case 24:
			case 25:
			case 26:
			case 27:
			case 28:
			break;
			default:
		}
	}
}

function string GetIntelVideoName (R6MissionDescription Desc)
{
	return "";
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	if ( m_bGameOver )
	{
		return;
	}
	Class'Actor'.static.GetCanvas().Viewport.Console.Master.m_StartGameInfo.m_SkipPlanningPhase=False;
	Class'Actor'.static.GetCanvas().Viewport.Console.Master.m_StartGameInfo.m_ReloadPlanning=False;
	Class'Actor'.static.GetCanvas().Viewport.Console.Master.m_StartGameInfo.m_ReloadActionPointOnly=False;
	if ( IsBasicMap() )
	{
		Level.m_sndMissionComplete=None;
	}
	Super.EndGame(Winner,Reason);
}

defaultproperties
{
    m_eCurrentWeapon=12
    m_WeaponsSlot(1)=1
    m_WeaponsSlot(3)=2
    m_WeaponsSlot(8)=2
    m_WeaponsSlot(9)=2
    m_WeaponsSlot(10)=2
    m_WeaponsSlot(11)=3
    m_WeaponsName(0)="R63rdWeapons.NormalSubMP5A4"
    m_WeaponsName(1)="R63rdWeapons.NormalPistolUSP"
    m_WeaponsName(2)="R63rdWeapons.NormalSniperM82A1"
    m_WeaponsName(3)="R6Weapons.R6HBSGadget"
    m_WeaponsName(4)="R63rdWeapons.NormalAssaultM4"
    m_WeaponsName(5)="R63rdWeapons.SilencedAssaultM4"
    m_WeaponsName(6)="R63rdWeapons.NormalLMGM60E4"
    m_WeaponsName(7)="R63rdWeapons.BuckShotgunM1"
    m_WeaponsName(8)="R6Weapons.R6FragGrenadeGadget"
    m_WeaponsName(9)="R6Weapons.R6BreachingChargeGadget"
    m_WeaponsName(10)="R6Weapons.R6RemoteChargeGadget"
    m_WeaponsName(11)="R6Weapons.R6ClaymoreGadget"
    m_bUsingCampaignBriefing=False
    m_szDefaultActionPlan="_MISSION_DEFAULT"
    m_bUseClarkVoice=False
    m_bPlayIntroVideo=False
    m_bPlayOutroVideo=False
}
