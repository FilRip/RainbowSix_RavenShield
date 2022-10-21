//================================================================================
// R6MultiPlayerGameInfo.
//================================================================================
class R6MultiPlayerGameInfo extends R6GameInfo
	Native;

var int m_iUbiComGameMode;
var bool m_bMSCLientActive;
var bool m_bDoLadderInit;
var bool m_TeamSelectionLocked;
const K_InGamePauseTime= 5;
var float m_fNextCheckPlayerReadyTime;
var float m_fLastUpdateTime;
var float m_fInGameStartTime;
var R6MObjTimer m_missionObjTimer;
var Sound m_sndSoundTimeFailure;
const K_RefreshCheckPlayerReadyFreq= 1;
const K_UpdateUbiDotCom= 30.0;
const K_KickVoteTime= 90;

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( (m_GameService.NativeGetGroupID() != 0) && (m_GameService.NativeGetLobbyID() != 0) )
	{
		m_GameService.m_eMenuLoginRegServer=EMENU_REQ_SUCCESS;
		m_GameService.m_eRegServerLoginRequest=EGSREQ_NONE;
	}
}

function int GetSpawnPointNum (string Options);

function int GetRainbowTeamColourIndex (int eTeamName);

function InitObjectives ()
{
	local int Index;

	if ( Level.NetMode != 0 )
	{
		Index=m_missionMgr.m_aMissionObjectives.Length;
		m_missionObjTimer=new Class'R6MObjTimer';
		m_missionObjTimer.m_bVisibleInMenu=False;
		m_missionObjTimer.m_bMoralityObjective=True;
		m_missionMgr.m_aMissionObjectives[Index]=m_missionObjTimer;
	}
	Super.InitObjectives();
}

function bool AtCapacity (bool bSpectator)
{
	if ( Level.NetMode == NM_Standalone )
	{
		return False;
	}
	return NumPlayers >= MaxPlayers;
}

event PlayerController Login (string Portal, string Options, out string Error)
{
	local R6AbstractInsertionZone StartSpot;
	local Actor CamSpot;
	local Vector CamLoc;
	local Rotator CamRot;
	local PlayerController NewPlayer;
	local R6PlayerController P;
	local string InClass;
	local string InName;
	local string InPassword;
	local string InChecksum;
	local byte InTeam;
	local int iSpawnPointNum;
	local string szJoinMessage;

	if ( Level.NetMode == NM_Standalone )
	{
		return Super.Login(Portal,Options,Error);
	}
	Log("Login: received string: " $ Options);
	if ( AtCapacity(False) )
	{
		Error=Localize("MPMiscMessages","ServerIsFull","R6GameInfo");
		return None;
	}
	m_GameService.m_bUpdateServer=True;
	InName=Left(ParseOption(Options,"Name"),20);
	ReplaceText(InName," ","_");
	ReplaceText(InName,"~","_");
	ReplaceText(InName,"?","_");
	ReplaceText(InName,",","_");
	ReplaceText(InName,"#","_");
	ReplaceText(InName,"/","_");
	InName=RemoveInvalidChars(InName);
	if ( InName == "UbiPlayer" )
	{
		InName=Left(ParseOption(Options,"UserName"),20);
	}
	foreach DynamicActors(Class'R6PlayerController',P)
	{
		P.ClientMPMiscMessage("PlayerJoinedServer",InName);
	}
	InTeam=GetIntOption(Options,"Team",255);
	InPassword=ParseOption(Options,"Password");
	InChecksum=ParseOption(Options,"Checksum");
	iSpawnPointNum=GetSpawnPointNum(Options);
	Log("Login:" @ InName);
	CamSpot=Level.GetCamSpot(m_eGameTypeFlag);
	if ( CamSpot == None )
	{
		StartSpot=GetAStartSpot();
		if ( StartSpot == None )
		{
			Error=Localize("MPMiscMessages","FailedPlaceMessage","R6GameInfo");
			return None;
		}
		else
		{
			CamLoc=StartSpot.Location;
			CamRot=StartSpot.Rotation;
			CamRot.Roll=0;
		}
	}
	else
	{
		CamLoc=CamSpot.Location;
		CamRot=CamSpot.Rotation;
	}
	bDelayedStart=True;
	PlayerControllerClass=Class<PlayerController>(DynamicLoadObject("R6Engine.R6PlayerController",Class'Class'));
	if ( PlayerControllerClass != None )
	{
		NewPlayer=Spawn(PlayerControllerClass,,,CamLoc,CamRot);
		NewPlayer.ClientSetLocation(CamLoc,CamRot);
		NewPlayer.StartSpot=StartSpot;
		NewPlayer.m_fLoginTime=Level.TimeSeconds;
	}
	if ( NewPlayer == None )
	{
		Log("Couldn't spawn player controller of class " $ string(PlayerControllerClass));
		Error=Localize("MPMiscMessages","FailedSpawnMessage","R6GameInfo");
		return None;
	}
	if ( InName == "" )
	{
		InName=DefaultPlayerName;
	}
	if ( (Level.NetMode != 0) || (NewPlayer.PlayerReplicationInfo != None) && (NewPlayer.PlayerReplicationInfo.PlayerName == DefaultPlayerName) )
	{
		ChangeName(NewPlayer,InName,False,True);
	}
	NewPlayer.GameReplicationInfo=GameReplicationInfo;
	if ( IsBetweenRoundTimeOver() && (m_eGameTypeFlag != 25) )
	{
		if ( bShowLog )
		{
			Log("In login for " $ string(NewPlayer) $ " m_bGameStarted==true sending it to dead state");
			R6PlayerController(NewPlayer).LogSpecialValues();
		}
		NewPlayer.GotoState('Dead');
	}
	if ( StatLog != None )
	{
		StatLog.LogPlayerConnect(NewPlayer);
	}
	NewPlayer.ReceivedSecretChecksum= !(InChecksum ~= "NoChecksum");
	NumPlayers++;
	if ( (Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer) )
	{
		BroadcastLocalizedMessage(GameMessageClass,1,NewPlayer.PlayerReplicationInfo);
	}
	if ( (Level.NetMode != 0) && (InClass == "") )
	{
		InClass=ParseOption(Options,"Class");
	}
	if ( InClass != "" )
	{
		NewPlayer.PawnClass=Class<Pawn>(DynamicLoadObject(InClass,Class'Class'));
	}
	return NewPlayer;
}

function bool IsBetweenRoundTimeOver ()
{
	return (m_bGameStarted == True) || IsInState('PostBetweenRoundTime');
}

event PostLogin (PlayerController NewPlayer)
{
	local R6PlayerController _NewPlayer;

	Super.PostLogin(NewPlayer);
	if ( Level.NetMode == NM_Standalone )
	{
		return;
	}
	_NewPlayer=R6PlayerController(NewPlayer);
	if ( _NewPlayer == None )
	{
		return;
	}
	if ( (Viewport(_NewPlayer.Player) != None) && (_NewPlayer.Player.Console != None) && (_NewPlayer.m_GameService == None) )
	{
		_NewPlayer.m_GameService=R6GSServers(_NewPlayer.Player.Console.SetGameServiceLinks(NewPlayer));
		_NewPlayer.ServerSetUbiID(_NewPlayer.m_GameService.m_szUserID);
	}
	if ( m_PlayerKick != None )
	{
//		_NewPlayer.m_iVoteResult=_NewPlayer.3;
		_NewPlayer.ClientKickVoteMessage(m_PlayerKick.PlayerReplicationInfo,m_KickersName);
	}
}

function ResetPlayerTeam (Controller aPlayer)
{
	if ( R6Pawn(aPlayer.Pawn) == None )
	{
		RestartPlayer(aPlayer);
		aPlayer.Pawn.PlayerReplicationInfo=aPlayer.PlayerReplicationInfo;
	}
	if ( PlayerController(aPlayer) != None )
	{
		DeployRainbowTeam(PlayerController(aPlayer));
	}
	AcceptInventory(aPlayer.Pawn);
}

function bool CanAutoBalancePlayer (R6PlayerController pCtrl)
{
	return True;
}

function ProcessAutoBalanceTeam ()
{
	local int iAlphaNb;
	local int iBravoNb;
	local bool _gameTypeTeamAdversarial;
	local Controller P;

	_gameTypeTeamAdversarial=Level.IsGameTypeTeamAdversarial(m_eGameTypeFlag);
	if ( m_bAutoBalance && _gameTypeTeamAdversarial )
	{
		GetNbHumanPlayerInTeam(iAlphaNb,iBravoNb);
		if ( iAlphaNb > iBravoNb + 1 )
		{
			if ( bShowLog )
			{
				Log("AutoBalance: Green to Red Team");
			}
			P=Level.ControllerList;
JL0090:
			if ( (P != None) && (iAlphaNb > iBravoNb + 1) )
			{
				if ( P.IsA('R6PlayerController') && (R6PlayerController(P).m_TeamSelection == 2) && CanAutoBalancePlayer(R6PlayerController(P)) )
				{
					if ( bShowLog )
					{
						Log("AutoBalance: " $ P.PlayerReplicationInfo.PlayerName $ " to Red Team");
					}
					iAlphaNb--;
					iBravoNb++;
//					R6PlayerController(P).ServerTeamRequested(3,True);
				}
				P=P.nextController;
				goto JL0090;
			}
		}
		else
		{
			if ( iBravoNb > iAlphaNb + 1 )
			{
				if ( bShowLog )
				{
					Log("AutoBalance: Red to Green Team");
				}
				P=Level.ControllerList;
JL01CB:
				if ( (P != None) && (iBravoNb > iAlphaNb + 1) )
				{
					if ( P.IsA('R6PlayerController') && (R6PlayerController(P).m_TeamSelection == 3) )
					{
						if ( bShowLog )
						{
							Log("AutoBalance: " $ P.PlayerReplicationInfo.PlayerName $ " to Green Team");
						}
						iAlphaNb++;
						iBravoNb--;
//						R6PlayerController(P).ServerTeamRequested(2,True);
					}
					P=P.nextController;
					goto JL01CB;
				}
			}
		}
	}
}

function SetLockOnTeamSelection (bool _bLocked)
{
	m_TeamSelectionLocked=_bLocked;
}

function bool IsTeamSelectionLocked ()
{
	return m_TeamSelectionLocked;
}

auto state InBetweenRoundMenu
{
	function BeginState ()
	{
		local Controller P;
		local Actor CamSpot;
		local R6PlayerController PC;

		m_bGameStarted=False;
		if ( Level.NetMode == NM_Standalone )
		{
			GotoState('None');
		}
		else
		{
			Level.PBNotifyServerTravel();
			if ( m_bAIBkp && Level.IsGameTypeCooperative(m_eGameTypeFlag) )
			{
				CreateBackupRainbowAI();
			}
//			GameReplicationInfo.SetServerState(GameReplicationInfo.0);
			SpawnAIandInitGoInGame();
		}
		MasterServerManager();
		HandleKickVotesTick();
		if ( m_fTimeBetRounds > 0 )
		{
			m_fRoundStartTime=Level.TimeSeconds + m_fTimeBetRounds;
			R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime=m_fRoundStartTime - Level.TimeSeconds;
			R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTime=R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime;
		}
		else
		{
			m_fRoundStartTime=0.00;
			R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimeUnlimited=True;
			R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime=0;
			R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTime=0.00;
		}
		m_fNextCheckPlayerReadyTime=Level.TimeSeconds + 1;
		if ( bShowLog )
		{
			Log("GameInfo: begin InBetweenRoundMenu");
		}
		CamSpot=Level.GetCamSpot(m_eGameTypeFlag);
		if ( CamSpot != None )
		{
			P=Level.ControllerList;
	JL01DA:
			if ( P != None )
			{
				PC=R6PlayerController(P);
				if ( PC != None )
				{
					PC.SetLocation(CamSpot.Location);
					PC.ClientSetLocation(CamSpot.Location,CamSpot.Rotation);
					PC.ClientStopFadeToBlack();
				}
				P=P.nextController;
				goto JL01DA;
			}
		}
	}

	function bool UnlimitedTBRPassed ()
	{
		return m_fRoundStartTime != 0;
	}

	function Tick (float DeltaTime)
	{
		local bool _bAllActivePlayersReady;
		local Controller _playerController;

		MasterServerManager();
		HandleKickVotesTick();
		_bAllActivePlayersReady=False;
		if ( (m_fNextCheckPlayerReadyTime < Level.TimeSeconds) && ((Level.TimeSeconds < m_fRoundStartTime) ||  !UnlimitedTBRPassed()) )
		{
			_bAllActivePlayersReady=ProcessPlayerReadyStatus();
			m_fNextCheckPlayerReadyTime=Level.TimeSeconds + 1;
			if ( _bAllActivePlayersReady )
			{
				SetLockOnTeamSelection(True);
				m_fRoundStartTime=Level.TimeSeconds;
			}
		}
		if (  !R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimePaused && ( !R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimeUnlimited || _bAllActivePlayersReady || (m_fRoundStartTime > 0)) )
		{
			R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime=m_fRoundStartTime - Level.TimeSeconds;
			R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTime=R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime;
			if ( Level.TimeSeconds < m_fRoundStartTime )
			{
//				GameReplicationInfo.SetServerState(GameReplicationInfo.1);
			}
			else
			{
				if ( Level.TimeSeconds < m_fRoundStartTime + 1 )
				{
//					GameReplicationInfo.SetServerState(GameReplicationInfo.2);
				}
				else
				{
					GotoState('PostBetweenRoundTime');
					_playerController=Level.ControllerList;
	JL01C9:
					if ( _playerController != None )
					{
						if ( _playerController.IsA('R6PlayerController') &&  !R6PlayerController(_playerController).IsPlayerPassiveSpectator() )
						{
							R6PlayerController(_playerController).GotoState('PauseController');
							R6PlayerController(_playerController).ClientGotoState('PauseController','None');
						}
						_playerController=_playerController.nextController;
						goto JL01C9;
					}
				}
			}
		}
		else
		{
//			GameReplicationInfo.SetServerState(GameReplicationInfo.1);
		}
	}

	function PauseCountDown ()
	{
		if ( R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimePaused == True )
		{
			return;
		}
		m_fPausedAtTime=Level.TimeSeconds;
		R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimePaused=True;
	}

	function UnPauseCountDown ()
	{
		local Controller _Player;

		if ( R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimePaused == False )
		{
			return;
		}
		_Player=Level.ControllerList;
	JL0030:
		if ( _Player != None )
		{
			if ( _Player.IsA('R6PlayerController') && (R6PlayerController(_Player).m_bInAnOptionsPage == True) )
			{
				return;
			}
			_Player=_Player.nextController;
			goto JL0030;
		}
		if (  !R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimeUnlimited )
		{
			m_fRoundStartTime=R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime + Level.TimeSeconds;
			R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTime=R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime;
		}
		R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimePaused=False;
		m_fPausedAtTime=0.00;
	}

	function EndState ()
	{
		local int iAlphaNb;
		local int iBravoNb;
		local int i;
		local int j;
		local Controller P;
		local bool _gameTypeTeamAdversarial;
		local array<R6PlayerController> R6PlayerControllerList;
		local array<R6TerroristAI> R6TerroristAIList;
		local array<R6RainbowAI> R6RainbowAIList;
		local R6Rainbow aRainbow;
		local R6Terrorist aTerrorist;
		local ZoneInfo aZoneInfo;

		_gameTypeTeamAdversarial=Level.IsGameTypeTeamAdversarial(m_eGameTypeFlag);
		if ( bShowLog )
		{
			Log("GameInfo: EndState InBetweenRoundMenu m_GameService = " $ string(m_GameService) $ " m_iUbiComGameMode = " $ string(m_iUbiComGameMode));
		}
		R6GameReplicationInfo(GameReplicationInfo).m_bRepMenuCountDownTimeUnlimited=False;
		ProcessAutoBalanceTeam();
		P=Level.ControllerList;
	JL00B9:
		if ( P != None )
		{
			if ( P.IsA('R6PlayerController') )
			{
				if (  !R6PlayerController(P).IsPlayerPassiveSpectator() )
				{
					R6PlayerController(P).bOnlySpectator=False;
					ResetPlayerTeam(P);
					R6PlayerController(P).m_TeamManager.SetTeamColor(GetRainbowTeamColourIndex(R6Pawn(P.Pawn).m_iTeam));
					if ( R6PlayerController(P).m_TeamManager != None )
					{
						R6PlayerController(P).m_TeamManager.SetMemberTeamID(R6Pawn(P.Pawn).m_iTeam);
					}
					else
					{
						R6AbstractGameInfo(Level.Game).SetPawnTeamFriendlies(P.Pawn);
					}
					P.PlayerReplicationInfo.SetWaitingPlayer(False);
				}
				else
				{
					if ( bShowLog )
					{
						Log("In InBetweenRoundMenu::EndState() sending PlayerController " $ string(P) $ " to dead state");
						R6PlayerController(P).LogSpecialValues();
					}
					P.GotoState('Dead');
				}
				if ( P.Pawn != None )
				{
					P.m_PawnRepInfo.m_PawnType=P.Pawn.m_ePawnType;
					P.m_PawnRepInfo.m_bSex=P.Pawn.bIsFemale;
				}
				P.PlayerReplicationInfo.m_szKillersName="";
				P.PlayerReplicationInfo.m_bJoinedTeamLate=False;
			}
			P=P.nextController;
			goto JL00B9;
		}
		P=Level.ControllerList;
	JL0347:
		if ( P != None )
		{
			if ( P.IsA('R6PlayerController') )
			{
				R6PlayerControllerList[R6PlayerControllerList.Length]=R6PlayerController(P);
			}
			else
			{
				if ( P.IsA('R6RainbowAI') )
				{
					R6RainbowAIList[R6RainbowAIList.Length]=R6RainbowAI(P);
				}
				else
				{
					if ( P.IsA('R6TerroristAI') )
					{
						R6TerroristAIList[R6TerroristAIList.Length]=R6TerroristAI(P);
					}
				}
			}
			P=P.nextController;
			goto JL0347;
		}
		i=0;
	JL03F7:
		if ( i < R6PlayerControllerList.Length )
		{
			if ( bShowLog )
			{
				Log("Nb Terrorist =" @ string(R6TerroristAIList.Length) @ "Nb RainbowAI =" @ string(R6RainbowAIList.Length) @ "Nb R6PlayerController =" @ string(R6PlayerControllerList.Length));
			}
			j=0;
	JL0474:
			if ( j < R6TerroristAIList.Length )
			{
				aTerrorist=R6Terrorist(R6TerroristAIList[j].Pawn);
				if ( aTerrorist != None )
				{
					R6PlayerControllerList[i].SetWeaponSound(R6TerroristAIList[j].m_PawnRepInfo,aTerrorist.m_szPrimaryWeapon,0);
					R6PlayerControllerList[i].SetWeaponSound(R6TerroristAIList[j].m_PawnRepInfo,aTerrorist.m_szGrenadeWeapon,2);
				}
				j++;
				goto JL0474;
			}
			j=0;
	JL0531:
			if ( j < R6RainbowAIList.Length )
			{
				aRainbow=R6Rainbow(R6RainbowAIList[j].Pawn);
				if ( aRainbow != None )
				{
					R6PlayerControllerList[i].SetWeaponSound(R6RainbowAIList[j].m_PawnRepInfo,aRainbow.m_szPrimaryWeapon,0);
					R6PlayerControllerList[i].SetWeaponSound(R6RainbowAIList[j].m_PawnRepInfo,aRainbow.m_szSecondaryWeapon,1);
					R6PlayerControllerList[i].SetWeaponSound(R6RainbowAIList[j].m_PawnRepInfo,aRainbow.m_szPrimaryItem,2);
					R6PlayerControllerList[i].SetWeaponSound(R6RainbowAIList[j].m_PawnRepInfo,aRainbow.m_szSecondaryItem,3);
				}
				j++;
				goto JL0531;
			}
			j=0;
	JL0660:
			if ( j < R6PlayerControllerList.Length )
			{
				aRainbow=R6Rainbow(R6PlayerControllerList[j].Pawn);
				if ( aRainbow != None )
				{
					R6PlayerControllerList[i].SetWeaponSound(R6PlayerControllerList[j].m_PawnRepInfo,aRainbow.m_szPrimaryWeapon,0);
					R6PlayerControllerList[i].SetWeaponSound(R6PlayerControllerList[j].m_PawnRepInfo,aRainbow.m_szSecondaryWeapon,1);
					R6PlayerControllerList[i].SetWeaponSound(R6PlayerControllerList[j].m_PawnRepInfo,aRainbow.m_szPrimaryItem,2);
					R6PlayerControllerList[i].SetWeaponSound(R6PlayerControllerList[j].m_PawnRepInfo,aRainbow.m_szSecondaryItem,3);
				}
				j++;
				goto JL0660;
			}
			if ( R6PlayerControllerList[i].Pawn != None )
			{
				aZoneInfo=R6PlayerControllerList[i].Pawn.Region.Zone;
			}
			else
			{
				aZoneInfo=R6PlayerControllerList[i].Region.Zone;
			}
			R6PlayerControllerList[i].ClientFinalizeLoading(aZoneInfo);
			i++;
			goto JL03F7;
		}
		NotifyMatchStart();
		Level.NotifyMatchStart();
		GetNbHumanPlayerInTeam(iAlphaNb,iBravoNb);
		if ( Level.IsGameTypeCooperative(m_eGameTypeFlag) )
		{
			SetCompilingStats(iAlphaNb > 0);
			SetRoundRestartedByJoinFlag(iAlphaNb < 1);
		}
		else
		{
			if ( _gameTypeTeamAdversarial )
			{
				SetCompilingStats((iAlphaNb > 0) && (iBravoNb > 0));
				SetRoundRestartedByJoinFlag((iAlphaNb == 0) || (iBravoNb == 0));
			}
			else
			{
				SetCompilingStats(iAlphaNb > 1);
				SetRoundRestartedByJoinFlag(iAlphaNb < 2);
			}
		}
/*		if ( m_bDoLadderInit && (NativeStartedByGSClient() || m_PersistantGameService.NativeGetServerRegistered()) && m_bCompilingStats )
		{
			m_PersistantGameService.4(m_iUbiComGameMode);
			if ( bShowLog )
			{
				Log(string(self) $ " We need to wait for score submission synchro, going to state GSClientWaitForRoundStart");
			}
		}*/
		IncrementRoundsPlayed();
		SetGameTypeInLocal();
		BroadcastGameTypeDescription();
	}

}

state PostBetweenRoundTime
{
	function BeginState ()
	{
		local Controller P;

		SetLockOnTeamSelection(False);
		if ( Level.IsGameTypeCooperative(m_eGameTypeFlag) )
		{
			ResetMatchStat();
		}
		m_fInGameStartTime=Level.TimeSeconds + 5;
		P=Level.ControllerList;
	JL0052:
		if ( P != None )
		{
			if ( P.IsA('R6PlayerController') )
			{
				R6PlayerController(P).CountDownPopUpBox();
			}
			P=P.nextController;
			goto JL0052;
		}
		R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime=5;
		R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTime=5.00;
		GameReplicationInfo.m_bInPostBetweenRoundTime=True;
	}

	function Tick (float DeltaTime)
	{
		local Controller P;

		MasterServerManager();
		HandleKickVotesTick();
		R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime=m_fInGameStartTime - Level.TimeSeconds;
		R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTime=R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime;
		if ( m_bDoLadderInit && (NativeStartedByGSClient() || m_PersistantGameService.NativeGetServerRegistered()) && m_bCompilingStats )
		{
			if ( m_PersistantGameService.m_bServerWaitMatchStartReply == False )
			{
				m_bLadderStats=True;
				m_bDoLadderInit=False;
				P=Level.ControllerList;
	JL00C6:
				if ( P != None )
				{
					if ( P.IsA('R6PlayerController') &&  !R6PlayerController(P).IsPlayerPassiveSpectator() )
					{
						R6PlayerController(P).PlayerReplicationInfo.m_bClientWillSubmitResult=True;
						R6PlayerController(P).ClientNotifySendStartMatch();
					}
					P=P.nextController;
					goto JL00C6;
				}
			}
			else
			{
				if ( Level.TimeSeconds < m_fInGameStartTime + 5 )
				{
					return;
				}
			}
		}
		if ( Level.TimeSeconds >= m_fInGameStartTime - 1 )
		{
			PostBetweenRoundTimeDone();
		}
	}

	function PostBetweenRoundTimeDone ()
	{
		local Controller P;

		m_bGameStarted=True;
//		GameReplicationInfo.SetServerState(GameReplicationInfo.3);
		P=Level.ControllerList;
	JL0036:
		if ( P != None )
		{
			if ( P.IsA('R6PlayerController') &&  !PlayerController(P).bOnlySpectator &&  !R6PlayerController(P).IsPlayerPassiveSpectator() )
			{
				if ( R6PlayerController(P).m_bPenaltyBox )
				{
					R6PlayerController(P).GotoState('PenaltyBox');
					R6PlayerController(P).ClientGotoState('PenaltyBox','None');
				}
				else
				{
					R6PlayerController(P).GotoState('PlayerWalking');
					R6PlayerController(P).ClientGotoState('PlayerWalking','None');
				}
			}
			P=P.nextController;
			goto JL0036;
		}
		if ( m_RainbowAIBackup.Length > 0 )
		{
			m_RainbowAIBackup.Remove (0,m_RainbowAIBackup.Length);
		}
		GotoState('None');
	}

	function EndState ()
	{
		local Controller P;

		GameReplicationInfo.m_bInPostBetweenRoundTime=False;
		m_fEndingTime=Level.TimeSeconds + Level.m_fTimeLimit;
		R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime=Level.m_fTimeLimit;
		R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTime=Level.m_fTimeLimit;
		P=Level.ControllerList;
	JL008F:
		if ( P != None )
		{
			if ( P.IsA('R6PlayerController') )
			{
				R6PlayerController(P).CountDownPopUpBoxDone();
			}
			P=P.nextController;
			goto JL008F;
		}
	}

}

function SetCompilingStats (bool bStatsSetting)
{
	Super.SetCompilingStats(bStatsSetting);
	if ( (Level.NetMode != 0) && m_bInternetSvr && bStatsSetting && (Level.IsGameTypeAdversarial(m_eGameTypeFlag) || Level.IsGameTypeTeamAdversarial(m_eGameTypeFlag)) )
	{
		m_bDoLadderInit=True;
	}
}

function Logout (Controller Exiting)
{
	local int iIdx;

	if ( Level.NetMode != 0 )
	{
		UnPauseCountDown();
		if ( (PlayerController(Exiting) != None) &&  !m_bPendingLevelExists )
		{
			m_GameService.NativeCDKeyDisconnecUser(PlayerController(Exiting).m_szAuthorizationID);
		}
	}
	Super.Logout(Exiting);
}

function Tick (float Delta)
{
	local R6PlayerController PlayerController;
	local Controller C;

	Super.Tick(Delta);
	if ( IsInState('InBetweenRoundMenu') )
	{
		return;
	}
	if ( Level.NetMode != 0 )
	{
		MasterServerManager();
		HandleKickVotesTick();
		R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime=R6GameInfo(Level.Game).m_fEndingTime - Level.TimeSeconds;
		R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTimeLastUpdate += Delta;
		if ( R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTimeLastUpdate >= 10 )
		{
			R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTimeLastUpdate=0.00;
			R6GameReplicationInfo(GameReplicationInfo).m_fRepMenuCountDownTime=R6GameReplicationInfo(GameReplicationInfo).m_iMenuCountDownTime;
		}
	}
	if ( (m_missionObjTimer != None) && (m_fEndingTime > 0) && (Level.m_fTimeLimit > 0) && (Level.TimeSeconds > m_fEndingTime) )
	{
		if (  !m_missionObjTimer.m_bFailed )
		{
			C=Level.ControllerList;
JL016B:
			if ( C != None )
			{
				PlayerController=R6PlayerController(C);
				if ( PlayerController != None )
				{
//					PlayerController.ClientPlayVoices(None,m_sndSoundTimeFailure,7,5,True,1.00);
				}
				C=C.nextController;
				goto JL016B;
			}
			m_missionObjTimer.TimerCallback(0.00);
			TimerCountdown();
		}
	}
}

event InitGame (string Options, out string Error)
{
	local int iPort;

	Super.InitGame(Options,Error);
	if (  !m_GameService.NativeGetRegServerIntialized() )
	{
		m_GameService.SetGameServiceRequestState(ERSREQ_INIT);
	}
	m_GameService.m_bInitGame=True;
	iPort=int(Mid(Level.GetAddressURL(),InStr(Level.GetAddressURL(),":") + 1));
//	m_GameService.1(iPort);
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	ResetPlayerReady();
	Super.EndGame(Winner,Reason);
}

function ResetPlayerReady ()
{
	local Controller P;

	P=Level.ControllerList;
JL0014:
	if ( P != None )
	{
		if ( R6PlayerController(P) != None )
		{
			R6PlayerController(P).PlayerReplicationInfo.m_bPlayerReady=False;
		}
		P=P.nextController;
		goto JL0014;
	}
}

function MasterServerManager ()
{
	if ( Level.NetMode != 0 )
	{
		m_GameService.MasterServerManager(self,Level);
	}
}

function GetNbHumanPlayerInTeam (out int iAlphaNb, out int iBravoNb)
{
	local Controller P;

	iAlphaNb=0;
	iBravoNb=0;
	P=Level.ControllerList;
JL0022:
	if ( P != None )
	{
		if ( R6PlayerController(P) != None )
		{
			if ( R6PlayerController(P).m_TeamSelection == 2 )
			{
				++iAlphaNb;
			}
			if ( R6PlayerController(P).m_TeamSelection == 3 )
			{
				++iBravoNb;
			}
		}
		P=P.nextController;
		goto JL0022;
	}
}

function IncrementRoundsPlayed ()
{
	local Controller P;
	local R6PlayerController _aPlayerController;

	P=Level.ControllerList;
JL0014:
	if ( P != None )
	{
		_aPlayerController=R6PlayerController(P);
		if ( (_aPlayerController != None) && ((_aPlayerController.m_TeamSelection == 2) || (_aPlayerController.m_TeamSelection == 3)) )
		{
			if ( m_bCompilingStats )
			{
				_aPlayerController.PlayerReplicationInfo.m_iRoundsPlayed++;
			}
			_aPlayerController.ServerSetPlayerReadyStatus(True);
			_aPlayerController.PlayerReplicationInfo.bIsSpectator=False;
		}
		P=P.nextController;
		goto JL0014;
	}
}

function bool ProcessKickVote (PlayerController _KickPlayer, string KickersName)
{
	local Controller _itController;
	local R6PlayerController _playerController;

	if ( m_fEndKickVoteTime != 0 )
	{
		return False;
	}
	m_PlayerKick=_KickPlayer;
	m_KickersName=KickersName;
	_itController=Level.ControllerList;
JL0039:
	if ( _itController != None )
	{
		_playerController=R6PlayerController(_itController);
		if ( _playerController != None )
		{
//			_playerController.m_iVoteResult=R6PlayerController(_itController).3;
			_playerController.ClientKickVoteMessage(m_PlayerKick.PlayerReplicationInfo,KickersName);
		}
		_itController=_itController.nextController;
		goto JL0039;
	}
	m_fEndKickVoteTime=Level.TimeSeconds + 90;
	return True;
}

function HandleKickVotesTick ()
{
	local int _iForKickVotes;
	local int _iAgainstKickVotes;
	local Controller _itController;
	local R6PlayerController _playerController;
	local string szResultString;
	local string szPlayerName;
	local bool _bResult;

	if ( (m_fEndKickVoteTime == 0) || (m_fEndKickVoteTime > Level.TimeSeconds) || (NumPlayers == 0) )
	{
		return;
	}
	m_fEndKickVoteTime=0.00;
	_iForKickVotes=0;
	_iAgainstKickVotes=0;
	_itController=Level.ControllerList;
JL0063:
	if ( _itController != None )
	{
		_playerController=R6PlayerController(_itController);
		if ( _playerController != None )
		{
			switch (_playerController.m_iVoteResult)
			{
/*				case _playerController.1:
				_iForKickVotes++;
				break;
				case _playerController.3:
				case _playerController.2:
				_iAgainstKickVotes++;
				break;
				default:*/
			}
			return;
		}
		_itController=_itController.nextController;
		goto JL0063;
	}
	if ( _iForKickVotes > (_iForKickVotes + _iAgainstKickVotes) / 2 )
	{
		_bResult=True;
		if ( bShowLog )
		{
			Log("<<KICK>> HandleKickVotesTick " $ string(_iForKickVotes) $ " voted yes " $ string(_iAgainstKickVotes) $ " considered as voted no -- VOTE PASSES");
		}
		R6PlayerController(m_PlayerKick).ClientKickedOut();
		m_PlayerKick.SpecialDestroy();
	}
	else
	{
		_bResult=False;
		if ( bShowLog )
		{
			Log("<<KICK>> HandleKickVotesTick " $ string(_iForKickVotes) $ " voted yes " $ string(_iAgainstKickVotes) $ " considered as voted no -- VOTE FAILS");
		}
	}
	szPlayerName=m_PlayerKick.PlayerReplicationInfo.PlayerName;
	_itController=Level.ControllerList;
JL0259:
	if ( _itController != None )
	{
		if ( _itController.IsA('R6PlayerController') )
		{
			R6PlayerController(_itController).ClientVoteResult(_bResult,szPlayerName);
		}
		_itController=_itController.nextController;
		goto JL0259;
	}
	m_PlayerKick=None;
	m_KickersName="";
}

function LogVoteInfo ()
{
}

defaultproperties
{
    m_bCompilingStats=False
}
