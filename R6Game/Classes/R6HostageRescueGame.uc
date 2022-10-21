//================================================================================
// R6HostageRescueGame.
//================================================================================
class R6HostageRescueGame extends R6CoOpMode;

function InitObjectives ()
{
	local int Index;
	local R6MObjNeutralizeTerrorist missionObjTerro;
	local R6MObjGroupMission groupMission;
	local R6MObjRescueHostage objRescueHostage;

	m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjGroupMission';
	groupMission=R6MObjGroupMission(m_missionMgr.m_aMissionObjectives[Index]);
	groupMission.m_bIfCompletedMissionIsSuccessfull=True;
	groupMission.m_szDescription="Rescue all hostage to the extraction zone or neutralize all terrorist";
	missionObjTerro=new Class'R6MObjNeutralizeTerrorist';
	groupMission.m_bIfCompletedMissionIsSuccessfull=True;
	missionObjTerro.m_bVisibleInMenu=False;
	missionObjTerro.m_szFeedbackOnCompletion="AllTerroristHaveBeenNeutralized";
	groupMission.m_aSubMissionObjectives[Index]=missionObjTerro;
	Index++;
	objRescueHostage=new Class'R6MObjRescueHostage';
	objRescueHostage.m_bIfCompletedMissionIsSuccessfull=True;
	objRescueHostage.m_bVisibleInMenu=True;
	objRescueHostage.m_szFeedbackOnCompletion="AllHostagesHaveBeenRescued";
	groupMission.m_aSubMissionObjectives[Index]=objRescueHostage;
	Index++;
	groupMission.m_szDescriptionInMenu=objRescueHostage.GetDescriptionBasedOnNbOfHostages(Level);
	Super.InitObjectives();
}

defaultproperties
{
    m_szDefaultActionPlan="_HOSTAGE_ACTION"
    m_eGameTypeFlag=RGM_HostageRescueMode
}
