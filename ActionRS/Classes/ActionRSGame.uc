class ActionRSGame extends R6TeamDeathMatchGame;

event PostLogin (PlayerController NewPlayer)
{
    Super.PostLogin(NewPlayer);
	if ( Level.NetMode != 0 )
	{
		NewPlayer.ClientSetHUD(Class'ARSHUD',None);
	} 
}

/*event PlayerController Login (string Portal, string Options, out string Error)
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
		return super(R6GameInfo).Login(Portal,Options,Error);
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
//	_iPBEnabled=GetIntOption(Options,"iPB",0);
	iSpawnPointNum=GetSpawnPointNum(Options);
	Log("Login:" @ InName);
//	CamSpot=Level.GetCamSpot(m_szGameTypeFlag);
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
	PlayerControllerClass=Class<PlayerController>(DynamicLoadObject(PlayerControllerClassName,Class'Class'));
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
}   */

defaultproperties
{
    HUDType="ActionRS.ARSPlanningHUD"
    DefaultPlayerClassName="ActionRS.ARSPlanningPawn"
    GameName="ActionRS"
    PlayerControllerClassName="ActionRS.ARSPlayerController"
}

