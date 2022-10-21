//================================================================================
// R6DefendGame.
//================================================================================
class R6DefendGame extends R6CoOpMode;

function InitObjectives ()
{
	local int Index;
	local R6MObjNeutralizeTerrorist missionObjTerro;
	local R6MObjRescueHostage misionObjVIP;
	local R6Hostage H;
	local R6Hostage huntedPawn;
	local R6TerroristAI terroAI;

	m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjNeutralizeTerrorist';
	m_missionMgr.m_aMissionObjectives[Index].m_bIfCompletedMissionIsSuccessfull=True;
	missionObjTerro=R6MObjNeutralizeTerrorist(m_missionMgr.m_aMissionObjectives[Index]);
	missionObjTerro.m_iNeutralizePercentage=100;
	missionObjTerro.m_bVisibleInMenu=True;
	missionObjTerro.m_szDescription="Neutralize all terro and protect the VIP at all cost";
	missionObjTerro.m_szDescriptionInMenu="NeutralizeTerroAndDefendVIP";
	Index++;
	foreach DynamicActors(Class'R6Hostage',H)
	{
		m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjRescueHostage';
		misionObjVIP=R6MObjRescueHostage(m_missionMgr.m_aMissionObjectives[Index]);
		misionObjVIP.m_bIfFailedMissionIsAborted=True;
		misionObjVIP.m_bVisibleInMenu=False;
		misionObjVIP.m_iRescuePercentage=100;
		misionObjVIP.m_depZone=H.m_DZone;
		if ( huntedPawn != None )
		{
			Log("Warning: there's more than one hostage in the game mode " $ string(self.Name));
		}
		else
		{
			huntedPawn=H;
			Index++;
		}
	}
	if ( (huntedPawn == None) && m_missionMgr.m_bEnableCheckForErrors )
	{
		Log("Warning: there is no hostage in the game mode " $ string(self.Name));
	}
	m_missionMgr.m_aMissionObjectives[Index]=new Class'R6MObjAcceptableRainbowLosses';
	foreach DynamicActors(Class'R6TerroristAI',terroAI)
	{
		terroAI.m_huntedPawn=huntedPawn;
//		R6Terrorist(terroAI.Pawn).m_eStrategy=3;
	}
	Level.m_bUseDefaultMoralityRules=False;
	Super.InitObjectives();
}

function SetPawnTeamFriendlies (Pawn aPawn)
{
	Super.SetPawnTeamFriendlies(aPawn);
	switch (aPawn.m_iTeam)
	{
		case 1:
		aPawn.m_iEnemyTeams += GetTeamNumBit(0);
		break;
		default:
	}
}

defaultproperties
{
    m_eGameTypeFlag=RGM_DefendMode
}
