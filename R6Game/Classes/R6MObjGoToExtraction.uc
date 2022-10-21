//================================================================================
// R6MObjGoToExtraction.
//================================================================================
class R6MObjGoToExtraction extends R6MissionObjectiveBase;

var() bool m_bExtractAtLeastOneRainbow;
var R6Pawn m_pawnToExtract;

function Init ()
{
	if ( R6MissionObjectiveMgr(m_mgr).m_bEnableCheckForErrors )
	{
		R6GameInfo(m_mgr.Level.Game).CheckForExtractionZone(self);
	}
}

function SetPawnToExtract (R6Pawn aPawn)
{
	m_bExtractAtLeastOneRainbow=False;
	m_pawnToExtract=aPawn;
}

function Reset ()
{
	Super.Reset();
	m_pawnToExtract=None;
}

function PawnKilled (Pawn killedPawn)
{
	if ( R6Pawn(killedPawn) != m_pawnToExtract )
	{
		return;
	}
	R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,False,True);
	if ( m_bShowLog )
	{
		Log("PawnKilled: m_pawnToExtract= " $ string(m_pawnToExtract.Name) $ " bFailed=" $ string(m_bFailed));
	}
}

function EnteredExtractionZone (Pawn aPawn)
{
	if ( m_bExtractAtLeastOneRainbow )
	{
		if ( aPawn.m_ePawnType != 1 )
		{
			return;
		}
	}
	else
	{
		if ( R6Pawn(aPawn) != m_pawnToExtract )
		{
			return;
		}
	}
	R6MissionObjectiveMgr(m_mgr).SetMissionObjCompleted(self,True,True);
	if ( m_bShowLog )
	{
		if ( m_pawnToExtract != None )
		{
			Log("EnteredExtractionZone: m_pawnToExtract= " $ string(m_pawnToExtract.Name) $ " bCompleted=" $ string(m_bCompleted));
		}
		else
		{
			Log("EnteredExtractionZone: m_bExtractAtLeastOneRainbow = " $ string(aPawn.Name) $ " bCompleted=" $ string(m_bCompleted));
		}
	}
}

defaultproperties
{
    m_bExtractAtLeastOneRainbow=True
    m_bIfCompletedMissionIsSuccessfull=True
    m_bIfFailedMissionIsAborted=True
    m_szDescription="Go to extraction zone"
}