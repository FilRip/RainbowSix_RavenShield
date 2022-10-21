//================================================================================
// R6MObjNeutralizeTerrorist.
//================================================================================
class R6MObjNeutralizeTerrorist extends R6MissionObjectiveBase;

var() int m_iNeutralizePercentage;
var() bool m_bMustSecureTerroInDepZone;
var() R6DeploymentZone m_depZone;

function Init ()
{
	local int iTotal;
	local R6Terrorist aTerrorist;

	if ( R6MissionObjectiveMgr(m_mgr).m_bEnableCheckForErrors )
	{
		if ( m_depZone != None )
		{
			if ( m_depZone.m_aTerrorist.Length == 0 )
			{
				logMObj("there is no terrorist in " $ string(m_depZone.Name));
			}
		}
		else
		{
			if ( m_bMustSecureTerroInDepZone )
			{
				logMObj("m_bMustSecureTerroInDepZone was enabled but without a deployment zone");
			}
			R6GameInfo(m_mgr.Level.Game).CheckForTerrorist(self,1);
		}
	}
}

function PawnKilled (Pawn Killed)
{
	PawnSecure(Killed);
}

function PawnSecure (Pawn secured)
{
	local float fNeutralized;
	local int iTotal;
	local R6Terrorist aTerrorist;
	local int i;
	local int iResult;

	if ( secured.m_ePawnType != 2 )
	{
		return;
	}
	if ( m_depZone != None )
	{
		aTerrorist=R6Terrorist(secured);
		if ( m_depZone != aTerrorist.m_DZone )
		{
			return;
		}
		i=0;
JL0057:
		if ( i < m_depZone.m_aTerrorist.Length )
		{
			aTerrorist=m_depZone.m_aTerrorist[i];
			if ( m_bMustSecureTerroInDepZone )
			{
				if (  !aTerrorist.IsAlive() )
				{
					R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
					if ( m_bShowLog )
					{
						logX("PawnKilled failed=" $ string(m_bFailed) $ " should have been secured");
					}
					return;
				}
				if ( aTerrorist.m_bIsKneeling || aTerrorist.m_bIsUnderArrest )
				{
					fNeutralized += 1;
				}
			}
			else
			{
				if (  !aTerrorist.IsAlive() || aTerrorist.m_bIsKneeling || aTerrorist.m_bIsUnderArrest )
				{
					fNeutralized += 1;
				}
			}
			++iTotal;
			++i;
			goto JL0057;
		}
	}
	else
	{
		fNeutralized=R6GameInfo(m_mgr.Level.Game).GetNbTerroNeutralized();
		foreach m_mgr.DynamicActors(Class'R6Terrorist',aTerrorist)
		{
			++iTotal;
		}
	}
	if ( iTotal > 0 )
	{
		iResult=fNeutralized / iTotal * 100.00;
		if ( iResult >= m_iNeutralizePercentage )
		{
			R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
		}
	}
	if ( m_bShowLog )
	{
		logX("PawnSecured/Killed. completed=" $ string(m_bCompleted) $ " neutralized=" $ string(secured.Name) $ " " $ string(iResult) $ "/" $ string(m_iNeutralizePercentage) $ "%");
	}
}

defaultproperties
{
    m_iNeutralizePercentage=100
    m_bIfCompletedMissionIsSuccessfull=True
    m_szDescription="Neutralize all terrorist"
    m_szDescriptionInMenu="NeutralizeAllTerrorist"
}