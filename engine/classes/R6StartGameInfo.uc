//================================================================================
// R6StartGameInfo.
//================================================================================
class R6StartGameInfo extends Actor
	Native;
//	NoNativeReplication;

var int m_DifficultyLevel;
var int m_CurrentMenu;
var int m_iNbTerro;
var int m_iTeamStart;
var bool m_SkipPlanningPhase;
var bool m_ReloadPlanning;
var bool m_ReloadActionPointOnly;
var bool m_bIsPlaying;
var Object m_CurrentMission;
var config R6TeamStartInfo m_TeamInfo[3];
var string m_MapName;
var string m_GameMode;

function Save ()
{
}

function Load ()
{
}

defaultproperties
{
    m_iNbTerro=35
}