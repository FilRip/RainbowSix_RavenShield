//================================================================================
// TeamInfo.
//================================================================================
class TeamInfo extends ReplicationInfo
	Native
	NativeReplication;
//	Localized;

var int Size;
var int TeamIndex;
var float Score;
var Texture TeamIcon;
var Actor Flag;
var() Class<Pawn> DefaultPlayerClass;
var Color TeamColor;
var Color AltTeamColor;
var string TeamName;
var localized string ColorNames[4];

replication
{
	reliable if ( bNetInitial && (Role == Role_Authority) )
		TeamIndex,TeamIcon,TeamColor,AltTeamColor,TeamName;
	reliable if ( bNetDirty && (Role == Role_Authority) )
		Score,Flag;
}

function bool BelongsOnTeam (Class<Pawn> PawnClass)
{
	return True;
}

simulated function string GetHumanReadableName ()
{
	if ( TeamName == Default.TeamName )
	{
		if ( TeamIndex < 4 )
		{
			return ColorNames[TeamIndex];
		}
		return TeamName @ string(TeamIndex);
	}
	return TeamName;
}

function bool AddToTeam (Controller Other)
{
	local Controller P;
	local bool bSuccess;

	if ( Other == None )
	{
		Log("Added none to team!!!");
		return False;
	}
	Size++;
	Other.PlayerReplicationInfo.Team=self;
	if ( Level.Game.StatLog != None )
	{
		Level.Game.StatLog.LogTeamChange(Other);
	}
	bSuccess=False;
	if ( Other.IsA('PlayerController') )
	{
		Other.PlayerReplicationInfo.TeamID=0;
	}
	else
	{
		Other.PlayerReplicationInfo.TeamID=1;
	}
JL00DA:
	if (  !bSuccess )
	{
		bSuccess=True;
		P=Level.ControllerList;
JL0101:
		if ( P != None )
		{
			if ( P.bIsPlayer && (P != Other) && (P.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team) && (P.PlayerReplicationInfo.TeamID == Other.PlayerReplicationInfo.TeamID) )
			{
				bSuccess=False;
			}
			P=P.nextController;
			goto JL0101;
		}
		if (  !bSuccess )
		{
			Other.PlayerReplicationInfo.TeamID=Other.PlayerReplicationInfo.TeamID + 1;
		}
		goto JL00DA;
	}
	return True;
}

function RemoveFromTeam (Controller Other)
{
	Size--;
}

defaultproperties
{
    TeamColor=(R=0,G=0,B=255,A=255)
    AltTeamColor=(R=0,G=0,B=200,A=255)
    TeamName="Team"
    ColorNames(0)="Blue"
    ColorNames(1)="Red"
    ColorNames(2)="Green"
    ColorNames(3)="Gold"
}
/*
    TeamIcon=Texture'S_Actor'
*/

