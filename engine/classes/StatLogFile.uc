//================================================================================
// StatLogFile.
//================================================================================
class StatLogFile extends StatLog
	Native;

var int LogAr;
var bool bWatermark;
var string StatLogFile;
var string StatLogFinal;

native final function OpenLog ();

native final function CloseLog ();

native final function Watermark (string EventString);

native final function GetChecksum (out string Checksum);

native final function FileFlush ();

native final function FileLog (string EventString);

function StartLog ()
{
}

function StopLog ()
{
	FileFlush();
	CloseLog();
	if ( bBatchLocal )
	{
		ExecuteSilentLogBatcher();
	}
	if ( LocalLog != None )
	{
		LocalLog.StopLog();
	}
}

function FlushLog ()
{
	FileFlush();
	if ( LocalLog != None )
	{
		LocalLog.FlushLog();
	}
}

function LogEventString (string EventString)
{
	if ( bWatermark )
	{
		Watermark(EventString);
	}
	FileLog(EventString);
	FileFlush();
	if ( LocalLog != None )
	{
		LocalLog.LogEventString(EventString);
	}
}

function LogWorldEventString (string EventString)
{
	if ( bWatermark )
	{
		Watermark(EventString);
	}
	FileLog(EventString);
	FileFlush();
}

event string GetLocalLogFileName ()
{
	if ( bWorld )
	{
		if ( StatLogFile(LocalLog) != None )
		{
			return StatLogFile(LocalLog).StatLogFinal;
		}
		else
		{
			return "";
		}
	}
	return StatLogFinal;
}

function LogPlayerConnect (Controller Player, optional string Checksum)
{
	if ( bWorld )
	{
		LogEventString(GetTimeStamp() $ Chr(9) $ "player" $ Chr(9) $ "Connect" $ Chr(9) $ Player.PlayerReplicationInfo.PlayerName $ Chr(9) $ string(Player.PlayerReplicationInfo.PlayerID) $ Chr(9) $ string(Player.IsA('Admin')) $ Chr(9) $ Checksum);
		LogPlayerInfo(Player);
	}
	else
	{
		Super.LogPlayerConnect(Player,Checksum);
	}
}

function LogGameEnd (string Reason)
{
	local string Checksum;

	if ( bWorld )
	{
		bWatermark=False;
		GetChecksum(Checksum);
		LogEventString(GetTimeStamp() $ Chr(9) $ "game_end" $ Chr(9) $ Reason $ Chr(9) $ Checksum $ "");
	}
	else
	{
		Super.LogGameEnd(Reason);
	}
}

defaultproperties
{
    StatLogFile="../Logs/unreal.ngStats.Unknown.log"
}