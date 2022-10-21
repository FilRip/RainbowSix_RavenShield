//================================================================================
// R6MissionGame.
//================================================================================
class R6MissionGame extends R6CoOpMode;

function InitObjectives ()
{
	InitObjectivesOfStoryMode();
	Super.InitObjectives();
}

defaultproperties
{
    m_eGameTypeFlag=RGM_MissionMode
}