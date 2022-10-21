//================================================================================
// PlayerReplicationInfo.
//================================================================================
class PlayerReplicationInfo extends ReplicationInfo
	Native
	NativeReplication;

const m_cPlayTime=4;
const m_cMission=3;
const m_cRatioStat=2;
const m_cDeathStat=1;
const m_cKillStat= 0;
var int Ping;
var int NumLives;
var int PlayerID;
var int TeamID;
var int iOperativeID;
var int StartTime;
var int TimeAcc;
var int m_iKillCount;
var int m_iKillCountForEvent;
var int m_iRoundFired;
var int m_iRoundsHit;
var int m_iRoundsPlayed;
var int m_iRoundsWon;
var int m_iDeathCountForEvent;
var int m_iBackUpKillCount;
var int m_iBackUpRoundFired;
var int m_iBackUpRoundsHit;
var int m_iBackUpRoundsPlayed;
var int m_iBackUpRoundsWon;
var int m_iHealth;
var int m_iRoundKillCount;
var travel int m_iUniqueID;
var bool bIsFemale;
var bool bFeigningDeath;
var bool bIsSpectator;
var bool bWaitingPlayer;
var bool bReadyToPlay;
var bool bOutOfLives;
var bool bBot;
var bool m_bPlayerReady;
var bool m_bJoinedTeamLate;
var travel bool m_bIsEscortedPilot;
var travel bool m_bIsBombMan;
var travel bool m_bAlreadyLoggedIn;
var bool m_bClientWillSubmitResult;
var float Score;
var float Deaths;
var float m_iBackUpDeaths;
var Decoration HasFlag;
var Volume PlayerLocation;
var TeamInfo Team;
var Texture TalkTexture;
var Class<VoicePack> VoiceType;
var string PlayerName;
var string OldName;
var string PreviousName;
var string m_szUbiUserID;
var string m_szKillersName;

replication
{
	reliable if ( bNetDirty && (Role == Role_Authority) )
		Ping,m_bJoinedTeamLate,Score,HasFlag,PlayerLocation;
	reliable if ( bNetDirty && (Role == Role_Authority) )
		PlayerID,TeamID,iOperativeID,bIsFemale,bFeigningDeath,bIsSpectator,bWaitingPlayer,bReadyToPlay,bOutOfLives,m_bPlayerReady,m_bIsEscortedPilot,m_bIsBombMan,Team,TalkTexture,VoiceType,PlayerName,m_szUbiUserID,m_szKillersName;
	reliable if ( bNetInitial && (Role == Role_Authority) )
		StartTime,bBot;
	reliable if ( Role == Role_Authority )
		m_iKillCount,m_iRoundFired,m_iRoundsHit,m_iRoundsPlayed,m_iRoundsWon,m_iBackUpKillCount,m_iBackUpRoundFired,m_iBackUpRoundsHit,m_iBackUpRoundsPlayed,m_iBackUpRoundsWon,m_iHealth,m_iRoundKillCount,Deaths,m_iBackUpDeaths;
	reliable if ( Role == Role_Authority )
		m_bClientWillSubmitResult;
}

function PostBeginPlay ()
{
	StartTime=Level.TimeSeconds;
	Timer();
	SetTimer(2.00,True);
}

function PostNetBeginPlay ()
{
	Super.PostNetBeginPlay();
	if ( Role == Role_Authority )
	{
		PlayerID=Level.Game.CurrentID++ ;
	}
}

simulated function SaveOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(True);
	}
	Super.SaveOriginalData();
}

function AdminResetRound ()
{
	m_iKillCount=m_iBackUpKillCount;
	m_iRoundFired=m_iBackUpRoundFired;
	m_iRoundsHit=m_iBackUpRoundsHit;
	m_iRoundsPlayed=m_iBackUpRoundsPlayed;
	m_iRoundsWon=m_iBackUpRoundsWon;
	Deaths=m_iBackUpDeaths;
}

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	m_iHealth=0;
	m_iRoundKillCount=0;
	m_iBackUpKillCount=m_iKillCount;
	m_iBackUpRoundFired=m_iRoundFired;
	m_iBackUpRoundsHit=m_iRoundsHit;
	m_iBackUpRoundsPlayed=m_iRoundsPlayed;
	m_iBackUpRoundsWon=m_iRoundsWon;
	m_iBackUpDeaths=Deaths;
	m_bPlayerReady=False;
}

function Reset ()
{
	Super.Reset();
	Score=0.00;
	HasFlag=None;
	bReadyToPlay=False;
	NumLives=0;
	bOutOfLives=False;
	m_bPlayerReady=False;
}

simulated function string GetLocationName ()
{
	if ( PlayerLocation != None )
	{
		return PlayerLocation.LocationName;
	}
	else
	{
		return "";
	}
}

simulated function string GetHumanReadableName ()
{
	return PlayerName;
}

function UpdatePlayerLocation ()
{
	local Volume V;

	PlayerLocation=None;
	foreach TouchingActors(Class'Volume',V)
	{
		if ( (V.LocationName != "") && ((PlayerLocation == None) || (V.LocationPriority > PlayerLocation.LocationPriority)) && V.Encompasses(self) )
		{
			PlayerLocation=V;
		}
	}
}

simulated function DisplayDebug (Canvas Canvas, out float YL, out float YPos)
{
	if ( Team != None )
	{
		Canvas.DrawText("     PlayerName " $ PlayerName $ " Team " $ Team.GetHumanReadableName());
	}
	else
	{
		Canvas.DrawText("     PlayerName " $ PlayerName $ " NO Team");
	}
}

function Timer ()
{
	UpdatePlayerLocation();
	if ( FRand() < 0.65 )
	{
		return;
	}
}

function SetPlayerName (string S)
{
	OldName=PlayerName;
	ReplaceText(S," ","_");
	ReplaceText(S,"~","_");
	ReplaceText(S,"?","_");
	ReplaceText(S,",","_");
	ReplaceText(S,"#","_");
	ReplaceText(S,"/","_");
	PlayerName=RemoveInvalidChars(S);
	PlayerName=S;
}

function SetWaitingPlayer (bool B)
{
	bIsSpectator=B;
	bWaitingPlayer=B;
}

defaultproperties
{
    iOperativeID=-1
    bIsSpectator=True
    RemoteRole=ROLE_SimulatedProxy
    bTravel=True
    NetUpdateFrequency=2.00
}