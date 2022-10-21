//================================================================================
// GameInfo.
//================================================================================
class GameInfo extends Info
	Native;
//	Localized;

var string m_szGameTypeFlag;
var byte Difficulty;
var ER6GameType m_eGameTypeFlag;
var globalconfig int GoreLevel;
var int MaxSpectators;
var int NumSpectators;
var int MaxPlayers;
var int NumPlayers;
var int NumBots;
var int CurrentID;
var int m_iCurrGameType;
var bool bRestartLevel;
var bool bPauseable;
var bool bCanChangeSkin;
var bool bTeamGame;
var bool bGameEnded;
var bool bOverTime;
var localized bool bAlternateMode;
var bool bCanViewOthers;
var bool bDelayedStart;
var bool bWaitingToStartMatch;
var globalconfig bool bChangeLevels;
var bool m_bChangedServerConfig;
var bool bAlreadyChanged;
var globalconfig bool bLocalLog;
var globalconfig bool bWorldLog;
var bool bLoggingGame;
var bool m_bGameStarted;
var bool m_bGameOver;
var bool m_bCompilingStats;
var bool m_bLadderStats;
var bool m_bUseClarkVoice;
var bool m_bPlayIntroVideo;
var bool m_bPlayOutroVideo;
var bool m_bPendingLevelExists;
var globalconfig float GameSpeed;
var float StartTime;
var Mutator BaseMutator;
var AccessControl AccessControl;
var GameRules GameRulesModifiers;
var BroadcastHandler BroadcastHandler;
var GameReplicationInfo GameReplicationInfo;
var StatLog StatLog;
var Class<LocalMessage> DeathMessageClass;
var Class<GameMessage> GameMessageClass;
var Class<PlayerController> PlayerControllerClass;
var() Class<GameReplicationInfo> GameReplicationInfoClass;
var Class<StatLog> StatLogClass;
var array<string> m_BankListToLoad;
var string DefaultPlayerClassName;
var string BotMenuType;
var string RulesMenuType;
var string SettingsMenuType;
var string GameUMenuType;
var string MultiplayerUMenuType;
var string GameOptionsMenuType;
var string HUDType;
var string MapListType;
var string MapPrefix;
var string BeaconName;
var localized string DefaultPlayerName;
var localized string GameName;
var string MutatorClass;
var string AccessControlClass;
var string BroadcastHandlerClass;
var string PlayerControllerClassName;
var string m_szGameOptions;

function SetJumpingMaps (bool _flagSetting, int iNextMapIndex);

function AbortScoreSubmission ();

function RestartGameMgr ();

event PreLogOut (PlayerController ExitingPlayer);

event bool CanPlayIntroVideo ();

event bool CanPlayOutroVideo ();

function R6GameInfoMakeNoise (ESoundType eType, Actor soundsource);

function PreBeginPlay ()
{
	StartTime=0.00;
	SetGameSpeed(GameSpeed);
	GameReplicationInfo=Spawn(GameReplicationInfoClass);
	InitGameReplicationInfo();
}

function PostBeginPlay ()
{
	if ( bAlternateMode )
	{
		GoreLevel=2;
	}
	InitLogging();
	Super.PostBeginPlay();
}

function Reset ()
{
	Super.Reset();
	bGameEnded=False;
	bOverTime=False;
	bWaitingToStartMatch=True;
	InitGameReplicationInfo();
}

function InitLogging ()
{
	local bool bLoggingWorld;

	if (  !bLoggingGame )
	{
		return;
	}
	bLoggingWorld=bWorldLog && ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer));
	if ( bLocalLog || bLoggingWorld )
	{
		StatLog=Spawn(StatLogClass);
		Log("Initiating logging using " $ string(StatLog) $ " class " $ string(StatLogClass));
		StatLog.GenerateLogs(bLocalLog,bLoggingWorld);
		StatLog.StartLog();
		LogGameParameters();
	}
}

function Timer ()
{
	BroadcastHandler.UpdateSentText();
}

event GameEnding ()
{
	EndLogging("serverquit");
}

function InitGameReplicationInfo ()
{
	GameReplicationInfo.bTeamGame=bTeamGame;
	GameReplicationInfo.GameName=GameName;
	GameReplicationInfo.GameClass=string(Class);
}

native function string GetNetworkNumber ();

native(1514) final function ProcessR6Availabilty (ER6GameType eGameType);

native(1280) final function int GetCurrentMapNum ();

native(1281) final function SetCurrentMapNum (int iMapNum);

function SetUdpBeacon (InternetInfo _udpBeacon);

function string GetInfo ()
{
	local string ResultSet;

	if ( StatLog.bWorld &&  !StatLog.bWorldBatcherError )
	{
		ResultSet="\worldlog\true";
	}
	else
	{
		ResultSet="\worldlog\false";
	}
	if ( StatLog.bWorld )
	{
		ResultSet=ResultSet $ "\wantworldlog\true";
	}
	else
	{
		ResultSet=ResultSet $ "\wantworldlog\false";
	}
	return ResultSet;
}

function string GetRules ()
{
	local string ResultSet;
	local Mutator M;
	local string NextMutator;
	local string NextDesc;
	local string EnabledMutators;
	local int Num;
	local int i;

	ResultSet="";
	EnabledMutators="";
	for (M=BaseMutator.NextMutator;M != None;M=M.NextMutator)
	{
		Num=0;
		NextMutator="";
		GetNextIntDesc("Engine.Mutator",0,NextMutator,NextDesc);
		while ( (NextMutator != "") && (Num < 50) )
		{
			if ( NextMutator ~= string(M.Class) )
			{
				i=InStr(NextDesc,",");
				if ( i != -1 )
				{
					NextDesc=Left(NextDesc,i);
				}
				if ( EnabledMutators != "" )
				{
					EnabledMutators=EnabledMutators $ ", ";
				}
				EnabledMutators=EnabledMutators $ NextDesc;
				break;
			}
			else
			{
				Num++;
				GetNextIntDesc("Engine.Mutator",Num,NextMutator,NextDesc);
			}
		}
	}
	if ( EnabledMutators != "" )
	{
		ResultSet=ResultSet $ "\\mutators\\" $ EnabledMutators;
	}
	ResultSet=ResultSet $ "\\listenserver\\" $ string(Level.NetMode == NM_ListenServer);
	ResultSet=ResultSet $ "\\changelevels\\" $ string(bChangeLevels);
	if ( GameRulesModifiers != None )
	{
		ResultSet=ResultSet $ GameRulesModifiers.GetRules();
	}
	return ResultSet;
}

function int GetServerPort ()
{
	local string S;
	local int i;

	S=Level.GetAddressURL();
	i=InStr(S,":");
	assert (i >= 0);
	return int(Mid(S,i + 1));
}

function bool SetPause (bool bPause, PlayerController P)
{
	if ( bPauseable || P.IsA('Admin') || (Level.NetMode == NM_Standalone) )
	{
		if ( bPause )
		{
			Level.Pauser=P.PlayerReplicationInfo;
		}
		else
		{
			Level.Pauser=None;
		}
		return True;
	}
	else
	{
		return False;
	}
}

function LogGameParameters ()
{
	local Mutator M;

	for (M=BaseMutator;M != None;M=M.NextMutator)
	{
		StatLog.LogMutator(M);
	}
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "GameName" $ Chr(9) $ GameName);
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "GameClass" $ Chr(9) $ string(Class));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "GameVersion" $ Chr(9) $ Level.EngineVersion);
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "MinNetVersion" $ Chr(9) $ Level.MinNetVersion);
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "GoreLevel" $ Chr(9) $ string(GoreLevel));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "TeamGame" $ Chr(9) $ string(bTeamGame));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "GameSpeed" $ Chr(9) $ string(GameSpeed * 100));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "MaxSpectators" $ Chr(9) $ string(MaxSpectators));
	StatLog.LogEventString(StatLog.GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ "MaxPlayers" $ Chr(9) $ string(MaxPlayers));
}

function SetGameSpeed (float t)
{
	local float OldSpeed;

	OldSpeed=GameSpeed;
	GameSpeed=FMax(t,0.10);
	Level.TimeDilation=GameSpeed;
	if ( GameSpeed != OldSpeed )
	{
		SaveConfig();
	}
	SetTimer(Level.TimeDilation,True);
}

function SetGamePassword (string szPasswd)
{
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	AccessControl.SetGamePassword(szPasswd);
	pServerOptions.GamePassword=szPasswd;
	pServerOptions.UsePassword= !(szPasswd == "");
	pServerOptions.SaveConfig();
}

event DetailChange ()
{
	local Actor A;
	local ZoneInfo Z;

	if (  !Level.bHighDetailMode )
	{
		foreach DynamicActors(Class'Actor',A)
		{
			if ( A.bHighDetail &&  !A.bGameRelevant )
			{
				A.Destroy();
			}
		}
	}
	foreach AllActors(Class'ZoneInfo',Z)
	{
		Z.LinkToSkybox();
	}
}

function bool GrabOption (out string Options, out string Result)
{
	if ( Left(Options,1) == "?" )
	{
		Result=Mid(Options,1);
		if ( InStr(Result,"?") >= 0 )
		{
			Result=Left(Result,InStr(Result,"?"));
		}
		Options=Mid(Options,1);
		if ( InStr(Options,"?") >= 0 )
		{
			Options=Mid(Options,InStr(Options,"?"));
		}
		else
		{
			Options="";
		}
		return True;
	}
	else
	{
		return False;
	}
}

function GetKeyValue (string Pair, out string Key, out string Value)
{
	if ( InStr(Pair,"=") >= 0 )
	{
		Key=Left(Pair,InStr(Pair,"="));
		Value=Mid(Pair,InStr(Pair,"=") + 1);
	}
	else
	{
		Key=Pair;
		Value="";
	}
}

function string ParseOption (string Options, string InKey)
{
	local string Pair;
	local string Key;
	local string Value;

	while ( GrabOption(Options,Pair) )
	{
		GetKeyValue(Pair,Key,Value);
		if ( Key ~= InKey )
		{
			return Value;
		}
	}
	return "";
}

event InitGame (string Options, out string Error)
{
	local string InOpt;
	local string LeftOpt;
	local int pos;
	local Class<Mutator> MClass;
	local Class<AccessControl> ACClass;
	local Class<GameRules> GRClass;
	local Class<BroadcastHandler> BHClass;

	Log("InitGame:" @ Options);
	MaxPlayers=Min(32,GetIntOption(Options,"MaxPlayers",MaxPlayers));
	Difficulty=GetIntOption(Options,"Difficulty",Difficulty);
	InOpt=ParseOption(Options,"GameSpeed");
	if ( InOpt != "" )
	{
		Log("GameSpeed" @ InOpt);
		SetGameSpeed(float(InOpt));
	}
	MClass=Class<Mutator>(DynamicLoadObject(MutatorClass,Class'Class'));
	BaseMutator=Spawn(MClass);
	Log("### MutatorClass: " $ MutatorClass);
	BHClass=Class<BroadcastHandler>(DynamicLoadObject(BroadcastHandlerClass,Class'Class'));
	BroadcastHandler=Spawn(BHClass);
	InOpt=ParseOption(Options,"AccessControl");
	if ( InOpt != "" )
	{
		ACClass=Class<AccessControl>(DynamicLoadObject(InOpt,Class'Class'));
	}
	if ( ACClass != None )
	{
		AccessControl=Spawn(ACClass);
	}
	else
	{
		ACClass=Class<AccessControl>(DynamicLoadObject(AccessControlClass,Class'Class'));
		AccessControl=Spawn(ACClass);
	}
	InOpt=ParseOption(Options,"AdminPassword");
	if ( InOpt != "" )
	{
		AccessControl.SetAdminPassword(InOpt);
	}
	InOpt=ParseOption(Options,"GameRules");
	if ( InOpt != "" )
	{
		Log("Game Rules" @ InOpt);
		while ( InOpt != "" )
		{
			pos=InStr(InOpt,",");
			if ( pos > 0 )
			{
				LeftOpt=Left(InOpt,pos);
				InOpt=Right(InOpt,Len(InOpt) - pos - 1);
			}
			else
			{
				LeftOpt=InOpt;
				InOpt="";
			}
			Log("Add game rules " $ LeftOpt);
			GRClass=Class<GameRules>(DynamicLoadObject(LeftOpt,Class'Class'));
			if ( GRClass != None )
			{
				if ( GameRulesModifiers == None )
				{
					GameRulesModifiers=Spawn(GRClass);
				}
				else
				{
					GameRulesModifiers.AddGameRules(Spawn(GRClass));
				}
			}
		}
	}
	Log("Base Mutator is " $ string(BaseMutator));
	InOpt=ParseOption(Options,"Mutator");
	if ( InOpt != "" )
	{
		Log("Mutators" @ InOpt);
		while ( InOpt != "" )
		{
			pos=InStr(InOpt,",");
			if ( pos > 0 )
			{
				LeftOpt=Left(InOpt,pos);
				InOpt=Right(InOpt,Len(InOpt) - pos - 1);
			}
			else
			{
				LeftOpt=InOpt;
				InOpt="";
			}
			Log("Add mutator " $ LeftOpt);
			MClass=Class<Mutator>(DynamicLoadObject(LeftOpt,Class'Class'));
			if ( MClass != None )
			{
				BaseMutator.AddMutator(Spawn(MClass));
			}
		}
	}
	InOpt=ParseOption(Options,"GamePassword");
	if ( InOpt != "" )
	{
		AccessControl.SetGamePassword(InOpt);
		Log("GamePassword" @ InOpt);
	}
	InOpt=ParseOption(Options,"LocalLog");
	if ( InOpt ~= "true" )
	{
		bLocalLog=True;
	}
	InOpt=ParseOption(Options,"WorldLog");
	if ( InOpt ~= "true" )
	{
		bWorldLog=True;
	}
}

function DeployCharacters (PlayerController PController)
{
	Log("Wrong Deploy character");
}

event string GetBeaconText ()
{
	return Level.ComputerName @ Left(Level.Title,24) @ BeaconName @ string(NumPlayers) $ "/" $ string(MaxPlayers);
}

function ProcessServerTravel (string URL, bool bItems)
{
	local PlayerController P;
	local PlayerController LocalPlayer;

	EndLogging("mapchange");
	m_bPendingLevelExists=True;
	foreach DynamicActors(Class'PlayerController',P)
	{
		if ( NetConnection(P.Player) != None )
		{
			if ( NetConnection(P.Player) != None )
			{
				P.ClientTravel(URL $ "?Password=" $ AccessControl.GetGamePassword(),TRAVEL_Relative,bItems);
			}
			else
			{
				LocalPlayer=P;
				P.PreClientTravel();
			}
		}
	}
	if ( (Level.NetMode == NM_ListenServer) && (LocalPlayer != None) )
	{
		Level.NextURL=Level.NextURL $ "?Skin=" $ LocalPlayer.GetDefaultURL("Skin") $ "?Face=" $ LocalPlayer.GetDefaultURL("Face") $ "?Team=" $ LocalPlayer.GetDefaultURL("Team") $ "?Name=" $ LocalPlayer.GetDefaultURL("Name") $ "?Class=" $ LocalPlayer.GetDefaultURL("Class") $ "?Password=" $ AccessControl.GetGamePassword();
	}
	if ( (Level.NetMode != 1) && (Level.NetMode != 2) )
	{
		Level.NextSwitchCountdown=0.00;
	}
}

event PreLogin (string Options, string Address, out string Error, out string FailCode)
{
	local bool bSpectator;
	local string spec;

	spec=ParseOption(Options,"SpectatorOnly");
	bSpectator=spec != "";
	AccessControl.PreLogin(Options,Address,Error,FailCode,bSpectator);
}

function int GetIntOption (string Options, string ParseString, int CurrentValue)
{
	local string InOpt;

	InOpt=ParseOption(Options,ParseString);
	if ( InOpt != "" )
	{
		Log(ParseString @ InOpt);
		return int(InOpt);
	}
	return CurrentValue;
}

function bool AtCapacity (bool bSpectator)
{
	if ( Level.NetMode == NM_Standalone )
	{
		return False;
	}
	if ( bSpectator )
	{
		return (NumSpectators >= MaxSpectators) && ((Level.NetMode != 2) || (NumPlayers > 0));
	}
	else
	{
		return (MaxPlayers > 0) && (NumPlayers >= MaxPlayers);
	}
}

event PlayerController Login (string Portal, string Options, out string Error)
{
	local NavigationPoint StartSpot;
	local PlayerController NewPlayer;
	local Class<Pawn> DesiredPawnClass;
	local Pawn TestPawn;
	local string InName;
	local string InPassword;
	local string InChecksum;
	local string InClass;
	local byte InTeam;
	local bool bSpectator;

	bSpectator=ParseOption(Options,"SpectatorOnly") != "";
	if ( AtCapacity(bSpectator) )
	{
		Error=GameMessageClass.Default.MaxedOutMessage;
		return None;
	}
	BaseMutator.ModifyLogin(Portal,Options);
	InName=Left(ParseOption(Options,"Name"),20);
	InTeam=GetIntOption(Options,"Team",255);
	InPassword=ParseOption(Options,"Password");
	InChecksum=ParseOption(Options,"Checksum");
	Log("Login:" @ InName);
	if ( InPassword != "" )
	{
		Log("Password" @ InPassword);
	}
	InTeam=PickTeam(InTeam);
	StartSpot=FindPlayerStart(None,InTeam,Portal);
	if ( StartSpot == None )
	{
		Error=Localize("MPMiscMessages","FailedPlaceMessage","R6GameInfo");
		return None;
	}
	if ( PlayerControllerClass == None )
	{
		PlayerControllerClass=Class<PlayerController>(DynamicLoadObject(PlayerControllerClassName,Class'Class'));
	}
	NewPlayer=Spawn(PlayerControllerClass,,,StartSpot.Location,StartSpot.Rotation);
	if ( NewPlayer == None )
	{
		Log("Couldn't spawn player controller of class " $ string(PlayerControllerClass));
		Error=GameMessageClass.Default.FailedSpawnMessage;
		return None;
	}
	NewPlayer.StartSpot=StartSpot;
	if ( InName == "" )
	{
		InName=DefaultPlayerName;
	}
	if ( NewPlayer.PlayerReplicationInfo != None )
	{
		if ( (Level.NetMode != 0) || (NewPlayer.PlayerReplicationInfo.PlayerName == DefaultPlayerName) )
		{
			ChangeName(NewPlayer,InName,False);
		}
		NewPlayer.GameReplicationInfo=GameReplicationInfo;
	}
	NewPlayer.GotoState('Spectating');
	if ( bSpectator )
	{
		NewPlayer.bOnlySpectator=True;
		NewPlayer.PlayerReplicationInfo.bIsSpectator=True;
		NumSpectators++;
		return NewPlayer;
	}
	if (  !ChangeTeam(NewPlayer,InTeam) )
	{
		Error=GameMessageClass.Default.FailedTeamMessage;
		return None;
	}
	if ( NewPlayer.PlayerReplicationInfo != None )
	{
		NewPlayer.PlayerReplicationInfo.PlayerID=CurrentID++ ;
	}
	InClass=ParseOption(Options,"Class");
	if ( InClass != "" )
	{
		DesiredPawnClass=Class<Pawn>(DynamicLoadObject(InClass,Class'Class'));
		if ( DesiredPawnClass != None )
		{
			NewPlayer.PawnClass=DesiredPawnClass;
		}
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
	if ( bDelayedStart )
	{
		NewPlayer.GotoState('BaseSpectating');
		return NewPlayer;
	}
	foreach DynamicActors(Class'Pawn',TestPawn)
	{
		if ( (TestPawn != None) && (PlayerController(TestPawn.Controller) != None) && (PlayerController(TestPawn.Controller).Player == None) && (TestPawn.Health > 0) && (TestPawn.OwnerName ~= InName) )
		{
			NewPlayer.Destroy();
			TestPawn.SetRotation(TestPawn.Controller.Rotation);
			TestPawn.bInitializeAnimation=False;
			TestPawn.PlayWaiting();
			return PlayerController(TestPawn.Controller);
		}
	}
	return NewPlayer;
}

function StartMatch ()
{
	local Controller P;
	local Actor A;

	if ( StatLog != None )
	{
		StatLog.LogGameStart();
	}
	foreach AllActors(Class'Actor',A)
	{
		A.MatchStarting();
	}
	for (P=Level.ControllerList;P != None;P=P.nextController)
	{
		if ( P.IsA('PlayerController') && (P.Pawn == None) )
		{
			if ( bGameEnded )
			{
				return;
			}
			else
			{
				if (  !PlayerController(P).bOnlySpectator )
				{
					RestartPlayer(P);
				}
			}
			SendStartMessage(PlayerController(P));
		}
	}
}

function RestartPlayer (Controller aPlayer)
{
}

function Class<Pawn> GetDefaultPlayerClass ()
{
	return Class<Pawn>(DynamicLoadObject(DefaultPlayerClassName,Class'Class'));
}

function SendStartMessage (PlayerController P)
{
	P.ClearProgressMessages();
}

event PostLogin (PlayerController NewPlayer)
{
	local Controller P;
	local Class<HUD> H;

	if (  !bDelayedStart )
	{
		bRestartLevel=False;
		if ( bWaitingToStartMatch )
		{
			StartMatch();
		}
		else
		{
			RestartPlayer(NewPlayer);
		}
		bRestartLevel=Default.bRestartLevel;
	}
	NewPlayer.ClientSetMusic(Level.Song,MTRAN_Fade);
	H=Class<HUD>(DynamicLoadObject(HUDType,Class'Class'));
	NewPlayer.ClientSetHUD(H,None);
	if ( NewPlayer.Pawn != None )
	{
		NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);
	}
}

function Logout (Controller Exiting)
{
	local bool bMessage;

	bMessage=True;
	if ( PlayerController(Exiting) != None )
	{
		if ( PlayerController(Exiting).bOnlySpectator )
		{
			bMessage=False;
			if ( Level.NetMode == NM_DedicatedServer )
			{
				NumSpectators--;
			}
		}
		else
		{
			NumPlayers--;
		}
	}
	if ( bMessage && ((Level.NetMode == NM_DedicatedServer) || (Level.NetMode == NM_ListenServer)) )
	{
		BroadcastLocalizedMessage(GameMessageClass,4,Exiting.PlayerReplicationInfo);
	}
	if ( StatLog != None )
	{
		StatLog.LogPlayerDisconnect(Exiting);
	}
}

event AcceptInventory (Pawn PlayerPawn)
{
}

function AddDefaultInventory (Pawn PlayerPawn)
{
}

function SetPlayerDefaults (Pawn PlayerPawn)
{
	PlayerPawn.JumpZ=PlayerPawn.Default.JumpZ;
	PlayerPawn.AirControl=PlayerPawn.Default.AirControl;
	BaseMutator.ModifyPlayer(PlayerPawn);
}

function NotifyKilled (Controller Killer, Controller Killed, Pawn killedPawn)
{
	local Controller C;

	for (C=Level.ControllerList;C != None;C=C.nextController)
	{
		C.NotifyKilled(Killer,Killed,killedPawn);
	}
}

function Killed (Controller Killer, Controller Killed, Pawn killedPawn, Class<DamageType> DamageType)
{
	local string KillerWeapon;
	local string OtherWeapon;

	NotifyKilled(Killer,Killed,killedPawn);
	if ( Killed.bIsPlayer )
	{
		Killed.PlayerReplicationInfo.Deaths += 1;
		BroadcastDeathMessage(Killer,Killed,DamageType);
		if ( (StatLog != None) && (Killer != None) && Killer.bIsPlayer )
		{
			if ( DamageType.Default.DamageWeaponName != "" )
			{
				KillerWeapon=DamageType.Default.DamageWeaponName;
			}
			else
			{
				KillerWeapon="None";
			}
			OtherWeapon="None";
			StatLog.LogKill(Killer.PlayerReplicationInfo,Killed.PlayerReplicationInfo,KillerWeapon,OtherWeapon,DamageType);
		}
	}
	ScoreKill(Killer,Killed);
}

function bool PreventDeath (Pawn Killed, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	if ( GameRulesModifiers == None )
	{
		return False;
	}
	return GameRulesModifiers.PreventDeath(Killed,Killer,DamageType,HitLocation);
}

function BroadcastDeathMessage (Controller Killer, Controller Other, Class<DamageType> DamageType)
{
	if ( (Killer == Other) || (Killer == None) )
	{
		BroadcastLocalizedMessage(DeathMessageClass,1,None,Other.PlayerReplicationInfo,DamageType);
	}
	else
	{
		BroadcastLocalizedMessage(DeathMessageClass,0,Killer.PlayerReplicationInfo,Other.PlayerReplicationInfo,DamageType);
	}
}

native static function string ParseKillMessage (string KillerName, string VictimName, string DeathMessage);

function KickBan (string S)
{
	AccessControl.KickBan(S);
}

function bool IsOnTeam (Controller Other, int TeamNum)
{
	if ( bTeamGame && (Other != None) && (Other.PlayerReplicationInfo.Team != None) && (Other.PlayerReplicationInfo.Team.TeamIndex == TeamNum) )
	{
		return True;
	}
	return False;
}

function bool CanSpectate (PlayerController Viewer, bool bOnlySpectator, Actor ViewTarget)
{
	return True;
}

function int ReduceDamage (int Damage, Pawn injured, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local int OriginalDamage;

	OriginalDamage=Damage;
	if ( injured.PhysicsVolume.bNeutralZone )
	{
		Damage=0;
	}
	else
	{
		if ( injured.InGodMode() )
		{
			return 0;
		}
	}
	if ( GameRulesModifiers != None )
	{
		return GameRulesModifiers.NetDamage(OriginalDamage,Damage,injured,instigatedBy,HitLocation,Momentum,DamageType);
	}
	return Damage;
}

function ChangeName (Controller Other, coerce string S, bool bNameChange, optional bool bDontBroadcastNameChange)
{
	local string szNewNameMessage;
	local string _szNewName;

	_szNewName=TransformName(Other.PlayerReplicationInfo,S);
	if ( _szNewName == "" )
	{
		return;
	}
	if ( Caps(Other.PlayerReplicationInfo.PlayerName) == Caps(_szNewName) )
	{
		bDontBroadcastNameChange=True;
	}
	if ( StatLog != None )
	{
		StatLog.LogNameChange(Other);
	}
	Other.PlayerReplicationInfo.SetPlayerName(_szNewName);
	if ( bNameChange && (PlayerController(Other) != None) )
	{
		BroadcastLocalizedMessage(GameMessageClass,2,Other.PlayerReplicationInfo);
	}
}

function string TransformName (PlayerReplicationInfo PRI, string NameRequested)
{
	local int _index;

	if (  !NameInUse(PRI,NameRequested) )
	{
		return NameRequested;
	}
	else
	{
		_index=1;
		while ( NameInUse(PRI,NameRequested $ "(" $ string(_index) $ ")") )
		{
			_index++;
		}
		return NameRequested $ "(" $ string(_index) $ ")";
	}
}

function bool NameInUse (PlayerReplicationInfo PRI, string NameRequested)
{
	local PlayerReplicationInfo _PRI;

	foreach DynamicActors(Class'PlayerReplicationInfo',_PRI)
	{
		if ( (PRI != _PRI) && (Caps(_PRI.PlayerName) == Caps(NameRequested)) )
		{
			return True;
		}
	}
	return False;
}

function bool ChangeTeam (Controller Other, int N)
{
	return True;
}

function byte PickTeam (byte Current)
{
	return Current;
}

function SendPlayer (PlayerController aPlayer, string URL)
{
	aPlayer.ClientTravel(URL,TRAVEL_Relative,False);
}

function RestartGame ()
{
	local string NextMap;
	local MapList myList;
	local R6ServerInfo pServerOptions;

	pServerOptions=Class'Actor'.static.GetServerOptions();
	if ( (GameRulesModifiers != None) && GameRulesModifiers.HandleRestartGame() )
	{
		return;
	}
	if ( bChangeLevels &&  !bAlreadyChanged )
	{
		bAlreadyChanged=True;
		myList=pServerOptions.m_ServerMapList;
		if ( m_bChangedServerConfig == True )
		{
			NextMap=myList.GetNextMap(1);
		}
		else
		{
//			NextMap=myList.GetNextMap(myList.-2);
		}
		if ( NextMap == "" )
		{
			NextMap=GetMapName(MapPrefix,NextMap,1);
		}
		if ( NextMap != "" )
		{
			Level.ServerTravel(NextMap,False);
			return;
		}
	}
	Level.ServerTravel("?Restart",True);
}

event Broadcast (Actor Sender, coerce string Msg, optional name type)
{
	BroadcastHandler.Broadcast(Sender,Msg,type);
}

function BroadcastTeam (Actor Sender, coerce string Msg, optional name type)
{
	BroadcastHandler.BroadcastTeam(Sender,Msg,type);
}

event BroadcastLocalized (Actor Sender, Class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	BroadcastHandler.AllowBroadcastLocalized(Sender,Message,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

function bool CheckEndGame (PlayerReplicationInfo Winner, string Reason)
{
	local Controller P;

	if ( (GameRulesModifiers != None) &&  !GameRulesModifiers.CheckEndGame(Winner,Reason) )
	{
		return False;
	}
	for (P=Level.ControllerList;P != None;P=P.nextController)
	{
		P.ClientGameEnded();
		P.GotoState('GameEnded');
	}
	return True;
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	if (  !CheckEndGame(Winner,Reason) )
	{
		bOverTime=True;
		return;
	}
	bGameEnded=True;
	TriggerEvent('EndGame',self,None);
	EndLogging(Reason);
}

function EndLogging (string Reason)
{
	if ( StatLog == None )
	{
		return;
	}
	StatLog.LogGameEnd(Reason);
	StatLog.StopLog();
	StatLog.Destroy();
	StatLog=None;
}

function NavigationPoint FindPlayerStart (Controller Player, optional byte InTeam, optional string incomingName)
{
	local NavigationPoint N;
	local NavigationPoint BestStart;
	local Teleporter Tel;
	local float BestRating;
	local float NewRating;
	local byte Team;

	if ( (Player != None) && (Player.StartSpot != None) && (bWaitingToStartMatch || (Player.PlayerReplicationInfo != None) && Player.PlayerReplicationInfo.bWaitingPlayer) )
	{
		return Player.StartSpot;
	}
	if ( GameRulesModifiers != None )
	{
		N=GameRulesModifiers.FindPlayerStart(Player,InTeam,incomingName);
		if ( N != None )
		{
			return N;
		}
	}
	if ( incomingName != "" )
	{
		foreach AllActors(Class'Teleporter',Tel)
		{
			if ( string(Tel.Tag) ~= incomingName )
			{
				return Tel;
			}
		}
	}
	if ( (Player != None) && (Player.PlayerReplicationInfo != None) )
	{
		if ( Player.PlayerReplicationInfo.Team != None )
		{
			Team=Player.PlayerReplicationInfo.Team.TeamIndex;
		}
		else
		{
			Team=0;
		}
	}
	else
	{
		Team=InTeam;
	}
	for (N=Level.NavigationPointList;N != None;N=N.nextNavigationPoint)
	{
		NewRating=RatePlayerStart(N,InTeam,Player);
		if ( NewRating > BestRating )
		{
			BestRating=NewRating;
			BestStart=N;
		}
	}
	if ( BestStart == None )
	{
		Log("Warning - PATHS NOT DEFINED or NO PLAYERSTART");
		foreach AllActors(Class'NavigationPoint',N)
		{
			NewRating=RatePlayerStart(N,0,Player);
			if ( NewRating > BestRating )
			{
				BestRating=NewRating;
				BestStart=N;
			}
		}
	}
	return BestStart;
}

function float RatePlayerStart (NavigationPoint N, byte Team, Controller Player)
{
	local PlayerStart P;

	P=PlayerStart(N);
	if ( P != None )
	{
		if ( P.bSinglePlayerStart )
		{
			if ( P.bEnabled )
			{
				return 1000.00;
			}
			return 20.00;
		}
		return 10.00;
	}
	return 0.00;
}

function ScoreObjective (PlayerReplicationInfo Scorer, int Score)
{
	if ( Scorer != None )
	{
		Scorer.Score += Score;
		if ( Scorer.Team != None )
		{
			Scorer.Team.Score += Score;
		}
	}
	if ( GameRulesModifiers != None )
	{
		GameRulesModifiers.ScoreObjective(Scorer,Score);
	}
	CheckScore(Scorer);
}

function CheckScore (PlayerReplicationInfo Scorer)
{
	if ( (GameRulesModifiers != None) && GameRulesModifiers.CheckScore(Scorer) )
	{
		return;
	}
}

function ScoreKill (Controller Killer, Controller Other)
{
	if ( (Killer == Other) || (Killer == None) )
	{
		Other.PlayerReplicationInfo.Score -= 1;
	}
	else
	{
		if ( Killer.PlayerReplicationInfo != None )
		{
			Killer.PlayerReplicationInfo.Score += 1;
		}
	}
	if ( GameRulesModifiers != None )
	{
		GameRulesModifiers.ScoreKill(Killer,Other);
	}
	CheckScore(Killer.PlayerReplicationInfo);
}

function bool TooManyBots ()
{
	return False;
}

function int MPSelectOperativeFace (bool bIsFemale)
{
	return -1;
}

function SetCompilingStats (bool bStatsSetting)
{
	m_bCompilingStats=bStatsSetting;
}

function SetRoundRestartedByJoinFlag (bool bRestartableByJoin)
{
	GameReplicationInfo.m_bRestartableByJoin=bRestartableByJoin;
}

defaultproperties
{
    Difficulty=3
    MaxSpectators=2
    MaxPlayers=16
    bRestartLevel=True
    bPauseable=True
    bCanChangeSkin=True
    bCanViewOthers=True
    bWaitingToStartMatch=True
    bLocalLog=True
    bWorldLog=True
    m_bCompilingStats=True
    GameSpeed=1.00
    DeathMessageClass=Class'LocalMessage'
    GameMessageClass=Class'GameMessage'
    GameReplicationInfoClass=Class'GameReplicationInfo'
    StatLogClass=Class'StatLogFile'
    HUDType="Engine.HUD"
    DefaultPlayerName="Player"
    GameName="Game"
    MutatorClass="Engine.Mutator"
    AccessControlClass="Engine.AccessControl"
    BroadcastHandlerClass="R6Game.R6BroadcastHandler"
    PlayerControllerClassName="Engine.PlayerController"
}
