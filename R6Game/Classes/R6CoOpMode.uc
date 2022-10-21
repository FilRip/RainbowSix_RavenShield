//================================================================================
// R6CoOpMode.
//================================================================================
class R6CoOpMode extends R6MultiPlayerGameInfo;

var bool bTerroristLeft;
var bool bRainbowLeft;

function int GetRainbowTeamColourIndex (int eTeamName)
{
	return 1;
}

function int GetSpawnPointNum (string Options)
{
	return 0;
}

function SetPawnTeamFriendlies (Pawn aPawn)
{
	SetDefaultTeamFriendlies(aPawn);
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6GameReplicationInfo gameRepInfo;
	local R6MissionObjectiveBase obj;

	if ( m_bGameOver )
	{
		return;
	}
	gameRepInfo=R6GameReplicationInfo(GameReplicationInfo);
	if ( m_missionMgr.m_eMissionObjectiveStatus == 1 )
	{
		BroadcastMissionObjMsg("","","MissionSuccesfulObjectivesCompleted",Level.m_sndMissionComplete,GetGameMsgLifeTime());
	}
	else
	{
		obj=m_missionMgr.GetMObjFailed();
		BroadcastMissionObjMsg("","","MissionFailed",None,GetGameMsgLifeTime());
		if ( obj != None )
		{
			BroadcastMissionObjMsg(Level.GetMissionObjLocFile(obj),"",obj.GetDescriptionFailure(),obj.GetSoundFailure(),GetGameMsgLifeTime());
		}
	}
	Super.EndGame(Winner,Reason);
}

function PlayerReadySelected (PlayerController _Controller)
{
	local Controller _aController;
	local int iHumanCount;

	if ( (R6PlayerController(_Controller) == None) || IsInState('InBetweenRoundMenu') )
	{
		return;
	}
	for (_aController=Level.ControllerList;_aController != None;_aController=_aController.nextController)
	{
		if ( (R6PlayerController(_aController) != None) && (R6PlayerController(_aController).m_TeamSelection == 2) )
		{
			iHumanCount++;
		}
	}
	if (  !R6PlayerController(_Controller).IsPlayerPassiveSpectator() && (iHumanCount <= 1) )
	{
		ResetRound();
	}
}
