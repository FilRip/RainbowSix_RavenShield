//================================================================================
// R6ReconGame.
//================================================================================
class R6ReconGame extends R6CoOpMode;

function InitObjectives ()
{
	local int Index;
	local R6MObjNeutralizeTerrorist missionObjTerro;
	local R6MObjGroupMission groupMission;
	local R6MObjRecon reconObj;

	m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjGroupMission';
	groupMission=R6MObjGroupMission(m_missionMgr.m_aMissionObjectives[Index]);
	groupMission.m_bIfCompletedMissionIsSuccessfull=True;
	groupMission.m_szDescription="Go to extraction zone and don't get caugh";
	groupMission.m_szDescriptionInMenu="GotoExtractionInReconMode";
	groupMission.m_aSubMissionObjectives[Index]=new Class'R6MObjRecon';
	groupMission.m_aSubMissionObjectives[Index].m_bIfCompletedMissionIsSuccessfull=True;
	reconObj=R6MObjRecon(groupMission.m_aSubMissionObjectives[Index]);
	reconObj.m_bVisibleInMenu=False;
	Index++;
	groupMission.m_aSubMissionObjectives[Index]=new Class'R6MObjCompleteAllAndGoToExtraction';
	groupMission.m_aSubMissionObjectives[Index].m_bIfCompletedMissionIsSuccessfull=True;
	missionObjTerro.m_bVisibleInMenu=False;
	Index++;
	Super.InitObjectives();
}

defaultproperties
{
    m_eGameTypeFlag=RGM_ReconMode
}
