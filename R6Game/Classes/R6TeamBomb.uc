//================================================================================
// R6TeamBomb.
//================================================================================
class R6TeamBomb extends R6AdversarialTeamGame;

function bool IsBombArmedOrExploded ()
{
	local R6IOBomb ioBomb;

	foreach DynamicActors(Class'R6IOBomb',ioBomb)
	{
		if ( ioBomb.m_bIsActivated || ioBomb.m_bExploded )
		{
			return True;
		}
	}
	return False;
}

function PawnKilled (Pawn killedPawn)
{
	local bool bCheckEndGame;
	local R6IOBomb ioBomb;
	local float fTimeLeft;
	local bool bForceFailNow;
	local float fTimeToExplode;

	if ( m_bGameOver )
	{
		return;
	}
	m_objDeathmatch.Reset();
	Super.PawnKilled(killedPawn);
	if ( m_objDeathmatch.m_bCompleted )
	{
		if (  !IsBombArmedOrExploded() || (m_objDeathmatch.m_iWinningTeam == 3) )
		{
			m_objDeathmatch.m_bIfCompletedMissionIsSuccessfull=True;
			bCheckEndGame=True;
		}
		else
		{
		}
	}
	else
	{
		if ( m_objDeathmatch.m_bFailed )
		{
			if (  !IsBombArmedOrExploded() )
			{
				m_objDeathmatch.m_bIfFailedMissionIsAborted=True;
				bCheckEndGame=True;
			}
			else
			{
				fTimeLeft=m_fEndingTime - Level.TimeSeconds;
				if ( fTimeLeft < 0 )
				{
					bForceFailNow=True;
				}
				else
				{
					bForceFailNow=True;
					fTimeToExplode=3.00;
					foreach DynamicActors(Class'R6IOBomb',ioBomb)
					{
						if ( ioBomb.m_bIsActivated && (ioBomb.m_fTimeLeft <= fTimeLeft) )
						{
							if ( ioBomb.m_fTimeLeft > fTimeToExplode )
							{
								ioBomb.ForceTimeLeft(fTimeToExplode);
							}
							bForceFailNow=False;
						}
					}
				}
				if ( bForceFailNow )
				{
					bCheckEndGame=True;
					m_objDeathmatch.m_bIfFailedMissionIsAborted=True;
				}
			}
		}
	}
	if ( bCheckEndGame )
	{
		if ( CheckEndGame(None,"") )
		{
			EndGame(None,"");
		}
	}
}

function RestartPlayer (Controller aPlayer)
{
	local R6PlayerController PController;

	Super.RestartPlayer(aPlayer);
	PController=R6PlayerController(aPlayer);
	if ( IsPlayerInTeam(PController,c_iAlphaTeam) )
	{
		PController.m_pawn.m_bCanArmBomb=False;
		PController.m_pawn.m_bCanDisarmBomb=True;
	}
	else
	{
		if ( IsPlayerInTeam(PController,c_iBravoTeam) )
		{
			PController.m_pawn.m_bCanArmBomb=True;
			PController.m_pawn.m_bCanDisarmBomb=False;
		}
	}
}

function NotifyMatchStart ()
{
	local R6IOBomb ioBomb;

	Super.NotifyMatchStart();
	m_objDeathmatch.m_bIfCompletedMissionIsSuccessfull=False;
	m_objDeathmatch.m_bIfFailedMissionIsAborted=False;
	foreach DynamicActors(Class'R6IOBomb',ioBomb)
	{
		ioBomb.m_fTimeLeft=m_fBombTime;
		ioBomb.m_fTimeOfExplosion=m_fBombTime;
		if ( ioBomb.m_bIsActivated )
		{
			ioBomb.ArmBomb(None);
		}
	}
}

function InitObjectives ()
{
	local int iLength;
	local bool bBombExist;
	local R6IOBomb ioBomb;
	local R6MObjPreventBombDetonation objBombDetonation;

	iLength=m_missionMgr.m_aMissionObjectives.Length;
	foreach AllActors(Class'R6IOBomb',ioBomb)
	{
		objBombDetonation=new Class'R6MObjPreventBombDetonation';
		objBombDetonation.m_r6IOObject=ioBomb;
		m_missionMgr.m_aMissionObjectives[iLength]=objBombDetonation;
		iLength++;
		objBombDetonation.m_bIfFailedMissionIsAborted=True;
		objBombDetonation.m_bIfDetonateObjectiveIsFailed=True;
		objBombDetonation.m_bIfDeviceIsActivatedObjectiveIsCompleted=False;
		objBombDetonation.m_bIfDeviceIsActivatedObjectiveIsFailed=False;
		objBombDetonation.m_bIfDeviceIsDeactivatedObjectiveIsCompleted=False;
		objBombDetonation.m_bIfDeviceIsDeactivatedObjectiveIsFailed=False;
		objBombDetonation.m_bIfDestroyedObjectiveIsCompleted=False;
		objBombDetonation.m_bIfDestroyedObjectiveIsFailed=False;
		bBombExist=True;
		if ( bShowLog )
		{
			Log("Bomb Added: " $ string(ioBomb) $ " armedMsg" $ ioBomb.m_szMsgArmedID $ " disarmed=" $ ioBomb.m_szMsgDisarmedID);
		}
	}
	if (  !bBombExist && m_missionMgr.m_bEnableCheckForErrors )
	{
		Log("WARNING: there is no bomb in the game type: " $ string(self));
	}
	m_missionMgr.m_bOnSuccessAllObjectivesAreCompleted=False;
	Level.m_bUseDefaultMoralityRules=False;
	Super.InitObjectives();
}

function IObjectInteract (Pawn aPawn, Actor anInteractiveObject)
{
	local R6IOBomb ioBomb;
	local R6GameReplicationInfo gameRepInfo;

	if ( m_bGameOver )
	{
		return;
	}
	Super.IObjectInteract(aPawn,anInteractiveObject);
	ioBomb=R6IOBomb(anInteractiveObject);
	if ( ioBomb.m_bIsActivated )
	{
		if ( bShowLog )
		{
			Log(" R6TeamBomb: " $ Localize("Game",ioBomb.m_szMsgArmedID,ioBomb.GetMissionObjLocFile()));
		}
		BroadcastMissionObjMsg(ioBomb.GetMissionObjLocFile(),"",ioBomb.m_szMsgArmedID);
	}
	else
	{
		if ( bShowLog )
		{
			Log(" R6TeamBomb: " $ Localize("Game",ioBomb.m_szMsgDisarmedID,ioBomb.GetMissionObjLocFile()));
		}
		BroadcastMissionObjMsg(ioBomb.GetMissionObjLocFile(),"",ioBomb.m_szMsgDisarmedID);
	}
	if ( m_objDeathmatch.m_bCompleted )
	{
		if (  !IsBombArmedOrExploded() )
		{
			m_objDeathmatch.m_bIfCompletedMissionIsSuccessfull=True;
			if ( CheckEndGame(None,"") )
			{
				EndGame(None,"");
			}
		}
	}
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6GameReplicationInfo gameRepInfo;
	local R6IOBomb ioBomb;
	local bool bBombExploded;

	if ( m_bGameOver )
	{
		return;
	}
	gameRepInfo=R6GameReplicationInfo(GameReplicationInfo);
	bBombExploded=False;
	foreach AllActors(Class'R6IOBomb',ioBomb)
	{
		if ( ioBomb.m_bExploded )
		{
			bBombExploded=True;
		}
		else
		{
		}
	}
	if ( bBombExploded )
	{
		if ( bShowLog )
		{
			Log("** Game : bravo win: bomb exploded");
		}
		BroadcastGameMsg("","","RedTeamWonRound",m_sndRedTeamWonRound,GetGameMsgLifeTime());
		BroadcastMissionObjMsg(ioBomb.GetMissionObjLocFile(),"","BombHasDetonated",None,GetGameMsgLifeTime());
		AddTeamWonRound(c_iBravoTeam);
	}
	else
	{
		if ( m_objDeathmatch.m_bFailed )
		{
			if ( bShowLog )
			{
				Log("** Game : it's a draw");
			}
			BroadcastGameMsg("","","RoundIsADraw",m_sndRoundIsADraw,GetGameMsgLifeTime());
		}
		else
		{
			if ( m_objDeathmatch.m_bCompleted )
			{
				if ( m_objDeathmatch.m_iWinningTeam == 2 )
				{
					if ( bShowLog )
					{
						Log("** Game : alpha eleminated bravo");
					}
					BroadcastGameMsg("","","GreenTeamWonRound",m_sndGreenTeamWonRound,GetGameMsgLifeTime());
					BroadcastMissionObjMsg("","","GreenNeutralizedRed",None,GetGameMsgLifeTime());
					AddTeamWonRound(c_iAlphaTeam);
				}
				else
				{
					if ( m_objDeathmatch.m_iWinningTeam == 3 )
					{
						if ( bShowLog )
						{
							Log("** Game : bravo eleminated alpha");
						}
						BroadcastGameMsg("","","RedTeamWonRound",m_sndRedTeamWonRound,GetGameMsgLifeTime());
						BroadcastMissionObjMsg("","","RedNeutralizedGreen",None,GetGameMsgLifeTime());
						AddTeamWonRound(c_iBravoTeam);
					}
				}
			}
			else
			{
				if ( bShowLog )
				{
					Log("** Game : alpha prevented bomb detonation");
				}
				BroadcastGameMsg("","","GreenTeamWonRound",m_sndGreenTeamWonRound,GetGameMsgLifeTime());
				BroadcastMissionObjMsg("","","NoBombsDetonated",None,GetGameMsgLifeTime());
				AddTeamWonRound(c_iAlphaTeam);
			}
		}
	}
	Super.EndGame(Winner,Reason);
}

defaultproperties
{
    m_iUbiComGameMode=3
    m_eGameTypeFlag=RGM_BombAdvMode
}
