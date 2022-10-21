//================================================================================
// StatLog.
//================================================================================
class StatLog extends Info
	Native;

var int Context;
var bool bWorld;
var bool bWorldBatcherError;
var bool bBatchLocal;
var float TimeStamp;
var StatLog LocalLog;
var() string LocalStandard;
var() string WorldStandard;
var() string LogVersion;
var() string LogInfoURL;
var() string GameName;
var() string GameCreator;
var() string GameCreatorURL;
var() string DecoderRingURL;

function BeginPlay ()
{
	SetTimer(30.00,True);
}

function Destroyed ()
{
	if ( LocalLog != None )
	{
		LocalLog.Destroy();
	}
}

function Timer ()
{
	LogPings();
}

function GenerateLogs (bool bLogLocal, bool bLogWorld)
{
	if ( bLogWorld )
	{
		bWorld=True;
		if ( bLogLocal )
		{
			LocalLog=Spawn(Class);
		}
	}
}

function StartLog ()
{
}

function StopLog ()
{
}

function FlushLog ()
{
}

function LogEventString (string EventString)
{
	Log(EventString);
	if ( LocalLog != None )
	{
		LocalLog.Log(EventString);
	}
}

function LogWorldEventString (string EventString)
{
	Log(EventString);
}

native final function ExecuteLocalLogBatcher ();

native final function ExecuteSilentLogBatcher ();

native static final function BatchLocal ();

native final function ExecuteWorldLogBatcher ();

native static function BrowseRelativeLocalURL (string URL);

native final function InitialCheck (GameInfo Game);

native final function LogMutator (Mutator M);

native static function GetPlayerChecksum (PlayerController P, out string Checksum);

native final function string GetGMTRef ();

function string GetAbsoluteTime ()
{
	local string AbsoluteTime;
	local string GMTRef;

	AbsoluteTime=string(Level.Year);
	if ( Level.Month < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Month);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Month);
	}
	if ( Level.Day < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Day);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Day);
	}
	if ( Level.Hour < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Hour);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Hour);
	}
	if ( Level.Minute < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Minute);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Minute);
	}
	if ( Level.Second < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Second);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Second);
	}
	if ( Level.Millisecond < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Millisecond);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Millisecond);
	}
	GMTRef=GetGMTRef();
	AbsoluteTime=AbsoluteTime $ "." $ GMTRef;
	TimeStamp=0.00;
	return AbsoluteTime;
}

function string GetShortAbsoluteTime ()
{
	local string AbsoluteTime;

	AbsoluteTime=string(Level.Year);
	if ( Level.Month < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Month);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Month);
	}
	if ( Level.Day < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Day);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Day);
	}
	if ( Level.Hour < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Hour);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Hour);
	}
	if ( Level.Minute < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Minute);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Minute);
	}
	if ( Level.Second < 10 )
	{
		AbsoluteTime=AbsoluteTime $ ".0" $ string(Level.Second);
	}
	else
	{
		AbsoluteTime=AbsoluteTime $ "." $ string(Level.Second);
	}
	TimeStamp=0.00;
	return AbsoluteTime;
}

function string GetTimeStamp ()
{
	local string Time;
	local int pos;

	Time=string(TimeStamp);
	Time=Left(Time,InStr(Time,".") + 3);
	return Time;
}

event string GetLocalLogFileName ()
{
	return "";
}

function Tick (float Delta)
{
	TimeStamp += Delta;
}

function LogStandardInfo ()
{
	if ( bWorld )
	{
		LogWorldEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Standard" $ Chr(9) $ WorldStandard);
		if ( LocalLog != None )
		{
			LocalLog.LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Standard" $ Chr(9) $ LocalStandard);
		}
	}
	else
	{
		LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Standard" $ Chr(9) $ LocalStandard);
	}
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Version" $ Chr(9) $ LogVersion);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Log_Info_URL" $ Chr(9) $ LogInfoURL);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Name" $ Chr(9) $ GameName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Version" $ Chr(9) $ Level.EngineVersion);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Creator" $ Chr(9) $ GameCreator);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Creator_URL" $ Chr(9) $ GameCreatorURL);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Game_Decoder_Ring_URL" $ Chr(9) $ DecoderRingURL);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Absolute_Time" $ Chr(9) $ GetAbsoluteTime());
	if ( bWorld )
	{
		if ( Level.ConsoleCommand("get UdpServerUplink douplink") ~= string(True) )
		{
			LogWorldEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_Public" $ Chr(9) $ "1");
		}
		else
		{
			LogWorldEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_Public" $ Chr(9) $ "0");
		}
	}
}

function LogServerInfo ()
{
	local string NetworkNumber;

	NetworkNumber=Level.Game.GetNetworkNumber();
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_ServerName" $ Chr(9) $ Level.Game.GameReplicationInfo.ServerName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_AdminName" $ Chr(9) $ Level.Game.GameReplicationInfo.AdminName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_AdminEmail" $ Chr(9) $ Level.Game.GameReplicationInfo.AdminEmail);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_Region" $ Chr(9) $ string(Level.Game.GameReplicationInfo.ServerRegion));
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_MOTDLine1" $ Chr(9) $ Level.Game.GameReplicationInfo.MOTDLine1);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_MOTDLine2" $ Chr(9) $ Level.Game.GameReplicationInfo.MOTDLine2);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_MOTDLine3" $ Chr(9) $ Level.Game.GameReplicationInfo.MOTDLine3);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_MOTDLine4" $ Chr(9) $ Level.Game.GameReplicationInfo.MOTDLine4);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_IP" $ Chr(9) $ NetworkNumber);
	LogEventString(GetTimeStamp() $ Chr(9) $ "info" $ Chr(9) $ "Server_Port" $ Chr(9) $ string(Level.Game.GetServerPort()));
}

final event LogGameSpecial (string SpecialID, string SpecialParam)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ SpecialID $ Chr(9) $ SpecialParam);
}

final event LogGameSpecial2 (string SpecialID, string SpecialParam, string SpecialParam2)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "game" $ Chr(9) $ SpecialID $ Chr(9) $ SpecialParam $ Chr(9) $ SpecialParam2);
}

native final function string GetMapFileName ();

function LogMapParameters ()
{
	local string MapName;

	MapName=GetMapFileName();
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "Name" $ Chr(9) $ MapName);
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "Title" $ Chr(9) $ Level.Title);
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "Author" $ Chr(9) $ Level.Author);
	LogEventString(GetTimeStamp() $ Chr(9) $ "map" $ Chr(9) $ "LevelEnterText" $ Chr(9) $ Level.LevelEnterText);
}

function LogPlayerConnect (Controller Player, optional string Checksum)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Connect" $ Chr(9) $ Player.PlayerReplicationInfo.PlayerName $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.IsA('Admin')));
	LogPlayerInfo(Player);
}

function LogPlayerInfo (Controller Player)
{
	if ( Player.PlayerReplicationInfo.Team != None )
	{
		LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "TeamName" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ Player.PlayerReplicationInfo.Team.TeamName);
		LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Team" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.PlayerReplicationInfo.Team.TeamIndex));
		LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "TeamID" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.PlayerReplicationInfo.TeamID));
	}
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Ping" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.PlayerReplicationInfo.Ping));
}

function LogPlayerDisconnect (Controller Player)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Disconnect" $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID));
}

function LogKill (PlayerReplicationInfo KillerPRI, PlayerReplicationInfo VictimPRI, string KillerWeaponName, string VictimWeaponName, Class<DamageType> DamageType)
{
	local string KillType;

	if ( VictimPRI == None )
	{
		return;
	}
	if ( KillerPRI == VictimPRI )
	{
		LogEventString(GetTimeStamp() $ Chr(9) $ "suicide" $ Chr(9) $ string(KillerPRI.PlayerID) $ Chr(9) $ KillerWeaponName $ Chr(9) $ string(DamageType) $ Chr(9) $ "None");
		return;
	}
	if ( KillerPRI.Team == VictimPRI.Team )
	{
		KillType="teamkill";
	}
	else
	{
		KillType="kill";
	}
	LogEventString(GetTimeStamp() $ Chr(9) $ KillType $ Chr(9) $ string(KillerPRI.PlayerID) $ Chr(9) $ KillerWeaponName $ Chr(9) $ string(VictimPRI.PlayerID) $ Chr(9) $ VictimWeaponName $ Chr(9) $ string(DamageType));
}

function LogNameChange (Controller Other)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Rename" $ Chr(9) $ Other.PlayerReplicationInfo.PlayerName $ Chr(9) $ string(Other.PlayerReplicationInfo.PlayerID));
}

function LogTeamChange (Controller Other)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Teamchange" $ Chr(9) $ string(Other.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Other.PlayerReplicationInfo.Team));
}

function LogTypingEvent (bool bTyping, Controller Other)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "typing" $ Chr(9) $ string(bTyping) $ Chr(9) $ string(Other.PlayerReplicationInfo.PlayerID));
}

function LogSpecialEvent (string EventType, optional coerce string Arg1, optional coerce string Arg2, optional coerce string Arg3, optional coerce string Arg4)
{
	local string Event;

	Event=EventType;
	if ( Arg1 != "" )
	{
		Event=Event $ Chr(9) $ Arg1;
	}
	if ( Arg2 != "" )
	{
		Event=Event $ Chr(9) $ Arg2;
	}
	if ( Arg3 != "" )
	{
		Event=Event $ Chr(9) $ Arg3;
	}
	if ( Arg4 != "" )
	{
		Event=Event $ Chr(9) $ Arg4;
	}
	LogEventString(GetTimeStamp() $ Chr(9) $ Event);
}

function LogPings ()
{
	local PlayerReplicationInfo PRI;

	foreach DynamicActors(Class'PlayerReplicationInfo',PRI)
	{
		LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Ping" $ Chr(9) $ string(PRI.PlayerID) $ Chr(9) $ string(PRI.Ping));
	}
}

function LogGameStart ()
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "game_start");
}

function LogGameEnd (string Reason)
{
	LogEventString(GetTimeStamp() $ Chr(9) $ "game_end" $ Chr(9) $ Reason);
}

defaultproperties
{
    LocalStandard="ngLog"
    WorldStandard="ngLog"
    LogVersion="1.2"
    LogInfoURL="http://www.netgamesusa.com/ngLog/"
    GameName="Unreal"
    GameCreator="Epic MegaGames, Inc."
    GameCreatorURL="http://www.epicgames.com/"
    DecoderRingURL="http://unreal.epicgames.com/Unreal_Log_Decoder_Ring.html"
}