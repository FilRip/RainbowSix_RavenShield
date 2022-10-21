//================================================================================
// R6LoneWolfGame.
//================================================================================
class R6LoneWolfGame extends R6GameInfo;

var Sound m_sndTeamWipedOut;

function InitObjectives ()
{
	local int Index;
	local R6MObjNeutralizeTerrorist missionObjTerro;
	local R6MObjGroupMission groupMission;
	local R6MObjGoToExtraction missionObjGotoExtraction;
	local R6Rainbow aRainbow;

	m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjGroupMission';
	groupMission=R6MObjGroupMission(m_missionMgr.m_aMissionObjectives[Index]);
	groupMission.m_bIfCompletedMissionIsSuccessfull=True;
	groupMission.m_szDescription="Get to the extraction zone or neutralize all terrorist";
	groupMission.m_szDescriptionInMenu="GetToExtractionZone";
	groupMission.m_aSubMissionObjectives[Index]=new Class'R6MObjNeutralizeTerrorist';
	groupMission.m_aSubMissionObjectives[Index].m_bIfCompletedMissionIsSuccessfull=True;
	missionObjTerro=R6MObjNeutralizeTerrorist(groupMission.m_aSubMissionObjectives[Index]);
	missionObjTerro.m_iNeutralizePercentage=100;
	missionObjTerro.m_bVisibleInMenu=False;
	missionObjTerro.m_szFeedbackOnCompletion="AllTerroristHaveBeenNeutralized";
	Index++;
	missionObjGotoExtraction=new Class'R6MObjGoToExtraction';
	groupMission.m_aSubMissionObjectives[Index]=missionObjGotoExtraction;
	groupMission.m_aSubMissionObjectives[Index].m_bIfCompletedMissionIsSuccessfull=True;
	missionObjGotoExtraction.m_sndSoundFailure=m_sndTeamWipedOut;
	missionObjGotoExtraction.m_bVisibleInMenu=False;
	foreach DynamicActors(Class'R6Rainbow',aRainbow)
	{
		missionObjGotoExtraction.SetPawnToExtract(aRainbow);
/*		goto JL0205;
JL0205:*/
	}
	Index++;
	Super.InitObjectives();
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
		BroadcastMissionObjMsg("","","MissionSuccesfulObjectivesCompleted",Level.m_sndMissionComplete);
	}
	else
	{
		obj=m_missionMgr.GetMObjFailed();
		BroadcastMissionObjMsg("","","MissionFailed");
		if ( obj != None )
		{
			BroadcastMissionObjMsg(Level.GetMissionObjLocFile(obj),"",obj.GetDescriptionFailure(),obj.GetSoundFailure(),GetGameMsgLifeTime());
		}
	}
	Super.EndGame(Winner,Reason);
}

defaultproperties
{
    m_sndTeamWipedOut=Sound'Voices_Control_MissionFailed.Play_TeamWipedOut'
    m_iMaxOperatives=1
    m_szDefaultActionPlan="_LONE_ACTION"
    m_eGameTypeFlag=RGM_LoneWolfMode
}
