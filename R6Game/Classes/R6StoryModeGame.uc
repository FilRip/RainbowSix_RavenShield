//================================================================================
// R6StoryModeGame.
//================================================================================
class R6StoryModeGame extends R6GameInfo;

function InitObjectives ()
{
	InitObjectivesOfStoryMode();
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
		BroadcastMissionObjMsg("","","",m_Player.Level.m_sndMissionComplete);
		BroadcastMissionObjMsg("","","MissionSuccesfulObjectivesCompleted",Level.m_sndPlayMissionExtro);
	}
	else
	{
		obj=m_missionMgr.GetMObjFailed();
		BroadcastMissionObjMsg("","","MissionFailed");
		if ( obj != None )
		{
			BroadcastMissionObjMsg(Level.GetMissionObjLocFile(obj),"",obj.GetDescriptionFailure(),obj.GetSoundFailure());
		}
	}
	Super.EndGame(Winner,Reason);
	if ( m_bUsingPlayerCampaign )
	{
		UpdatePlayerCampaign();
	}
}

function UpdatePlayerCampaign ()
{
	local R6PlayerCampaign MyCampaign;
	local R6MissionRoster oDetailOfTheOperative;
	local R6Operative oOperative;
	local R6Operative oOperativeTmp;
	local array<int> iOperativeInMission;
	local bool bAlreadyUpdate;
	local int i;
	local int j;
	local R6Rainbow aR6Rainbow;
	local R6RainbowTeam aR6Team;
	local R6Console R6Console;

	R6Console=R6Console(m_Player.Player.Console);
	MyCampaign=R6Console.m_PlayerCampaign;
	oDetailOfTheOperative=MyCampaign.m_OperativesMissionDetails;
	if ( bShowLog )
	{
		Log("===== Update operative skills in mission =====");
	}
	i=0;
JL008C:
	if ( i < 3 )
	{
		aR6Team=R6RainbowTeam(GetRainbowTeam(i));
		if ( aR6Team != None )
		{
			if ( bShowLog )
			{
				Log("R6Team " $ string(aR6Team));
			}
			j=0;
JL00DD:
			if ( j < 4 )
			{
				aR6Rainbow=aR6Team.m_Team[j];
				if ( bShowLog )
				{
					Log("R6Rainbow " $ string(aR6Rainbow));
				}
				if ( aR6Rainbow == None )
				{
					goto JL05E6;
				}
				aR6Rainbow.UpdateRainbowSkills();
				if ( bShowLog )
				{
					Log("aR6Rainbow.m_iOperativeID" @ string(aR6Rainbow.m_iOperativeID));
				}
				iOperativeInMission[iOperativeInMission.Length]=aR6Rainbow.m_iOperativeID;
				oOperative=oDetailOfTheOperative.m_MissionOperatives[aR6Rainbow.m_iOperativeID];
				oOperative.m_fAssault=aR6Rainbow.m_fSkillAssault * 100;
				oOperative.m_fDemolitions=aR6Rainbow.m_fSkillDemolitions * 100;
				oOperative.m_fElectronics=aR6Rainbow.m_fSkillElectronics * 100;
				oOperative.m_fSniper=aR6Rainbow.m_fSkillSniper * 100;
				oOperative.m_fStealth=aR6Rainbow.m_fSkillStealth * 100;
				oOperative.m_fSelfControl=aR6Rainbow.m_fSkillSelfControl * 100;
				oOperative.m_fLeadership=aR6Rainbow.m_fSkillLeadership * 100;
				oOperative.m_fObservation=aR6Rainbow.m_fSkillObservation * 100;
				oOperative.m_iHealth=aR6Rainbow.m_eHealth;
				oOperative.m_iNbMissionPlayed++;
				oOperative.m_iTerrokilled += aR6Rainbow.m_iKills;
				oOperative.m_iRoundsfired += aR6Rainbow.m_iBulletsFired;
				oOperative.m_iRoundsOntarget += aR6Rainbow.m_iBulletsHit;
				if ( bShowLog )
				{
					oOperative.DisplayStats();
				}
				if ( oOperative.m_iHealth > 1 )
				{
					switch (aR6Rainbow.m_szSpecialityID)
					{
						case "ID_ASSAULT":
						oOperative=new Class'R6RookieAssault';
						oOperative.m_szOperativeClass="R6RookieAssault";
						break;
						case "ID_SNIPER":
						oOperative=new Class'R6RookieSniper';
						oOperative.m_szOperativeClass="R6RookieSniper";
						break;
						case "ID_DEMOLITIONS":
						oOperative=new Class'R6RookieDemolitions';
						oOperative.m_szOperativeClass="R6RookieDemolitions";
						break;
						case "ID_ELECTRONICS":
						oOperative=new Class'R6RookieElectronics';
						oOperative.m_szOperativeClass="R6RookieElectronics";
						break;
						case "ID_RECON":
						oOperative=new Class'R6RookieRecon';
						oOperative.m_szOperativeClass="R6RookieRecon";
						break;
						default:
					}
					if ( bShowLog )
					{
						Log("aR6Rainbow.m_szSpecialityID: " $ aR6Rainbow.m_szSpecialityID);
					}
					if ( bShowLog )
					{
						Log("oOperative.m_szOperativeClass: " $ oOperative.m_szOperativeClass);
					}
					oOperative.m_iUniqueID=oDetailOfTheOperative.m_MissionOperatives.Length;
					oOperative.m_iRookieID=GetNextRookieIndex(oOperative.m_szOperativeClass);
					iOperativeInMission[iOperativeInMission.Length]=oDetailOfTheOperative.m_MissionOperatives.Length;
					oDetailOfTheOperative.m_MissionOperatives[oDetailOfTheOperative.m_MissionOperatives.Length]=oOperative;
				}
				j++;
				goto JL00DD;
			}
		}
JL05E6:
		i++;
		goto JL008C;
	}
	if ( bShowLog )
	{
		Log("===== Update operative skills in training =====");
	}
	i=0;
JL0633:
	if ( i < MyCampaign.m_OperativesMissionDetails.m_MissionOperatives.Length )
	{
		bAlreadyUpdate=False;
		j=0;
JL0664:
		if ( j < iOperativeInMission.Length )
		{
			if ( i == iOperativeInMission[j] )
			{
				bAlreadyUpdate=True;
			}
			else
			{
				j++;
				goto JL0664;
			}
		}
		if (  !bAlreadyUpdate )
		{
			oOperative=MyCampaign.m_OperativesMissionDetails.m_MissionOperatives[i];
			oOperative.UpdateSkills();
			if ( bShowLog )
			{
				oOperative.DisplayStats();
			}
		}
		i++;
		goto JL0633;
	}
	if ( m_missionMgr.m_eMissionObjectiveStatus == 1 )
	{
		if ( MyCampaign.m_iNoMission < R6Console.m_CurrentCampaign.m_missions.Length - 1 )
		{
			MyCampaign.m_iNoMission++;
			MyCampaign.m_bCampaignCompleted=0;
		}
		else
		{
			MyCampaign.m_bCampaignCompleted=1;
		}
	}
}

function int GetNextRookieIndex (string _szOperativeClass)
{
	local R6PlayerCampaign MyCampaign;
	local R6MissionRoster oDetailOfTheOperative;
	local int i;
	local int iNbOfOperatives;
	local int ITemp;
	local int iRookieIndex;

	MyCampaign=R6Console(m_Player.Player.Console).m_PlayerCampaign;
	oDetailOfTheOperative=MyCampaign.m_OperativesMissionDetails;
	iNbOfOperatives=oDetailOfTheOperative.m_MissionOperatives.Length;
	iRookieIndex=0;
	i=0;
JL0062:
	if ( i < iNbOfOperatives )
	{
		if ( oDetailOfTheOperative.m_MissionOperatives[i].m_szOperativeClass == _szOperativeClass )
		{
			if ( oDetailOfTheOperative.m_MissionOperatives[i].m_iRookieID != -1 )
			{
				iRookieIndex=Max(iRookieIndex,oDetailOfTheOperative.m_MissionOperatives[i].m_iRookieID);
			}
		}
		i++;
		goto JL0062;
	}
	iRookieIndex++;
	return iRookieIndex;
}

function string GetIntelVideoName (R6MissionDescription Desc)
{
	return Desc.m_MapName;
}

defaultproperties
{
    m_bUsingPlayerCampaign=True
    m_bUsingCampaignBriefing=True
    m_szDefaultActionPlan="_MISSION_ACTION"
    m_eGameTypeFlag=RGM_StoryMode
    m_bUseClarkVoice=True
    m_bPlayIntroVideo=True
    m_bPlayOutroVideo=True
}
