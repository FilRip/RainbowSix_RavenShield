//================================================================================
// R6TerroristHuntGame.
//================================================================================
class R6TerroristHuntGame extends R6CoOpMode;

function InitObjectives ()
{
	local R6MObjNeutralizeTerrorist missionObjTerro;

	m_missionMgr.m_aMissionObjectives[0]=new Class'R6MObjNeutralizeTerrorist';
	m_missionMgr.m_aMissionObjectives[0].m_bIfCompletedMissionIsSuccessfull=True;
	missionObjTerro=R6MObjNeutralizeTerrorist(m_missionMgr.m_aMissionObjectives[0]);
	missionObjTerro.m_iNeutralizePercentage=100;
	missionObjTerro.m_bVisibleInMenu=True;
	missionObjTerro.m_szFeedbackOnCompletion="AllTerroristHaveBeenNeutralized";
	Super.InitObjectives();
}

defaultproperties
{
    m_szDefaultActionPlan="_TERRORIST_ACTION"
    m_eGameTypeFlag=RGM_TerroristHuntMode
}
