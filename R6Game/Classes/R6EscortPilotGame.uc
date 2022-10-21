//================================================================================
// R6EscortPilotGame.
//================================================================================
class R6EscortPilotGame extends R6AdversarialTeamGame;

var config bool EnablePilotPrimaryWeapon;
var config bool EnablePilotSecondaryWeapon;
var config bool EnablePilotTertiaryWeapon;
var R6MObjGoToExtraction m_objGoToExtraction;
var R6PlayerController m_pilotController;
var R6PlayerController m_previousPilot;
var Sound m_sndPilot;
var string m_szPilotSkin;

event PostBeginPlay ()
{
	Super.PostBeginPlay();
	LoadConfig("R6EscortPilotGame.ini");
	if ( bShowLog )
	{
		Log("EnablePilotPrimaryWeapon   =" $ string(EnablePilotPrimaryWeapon));
		Log("EnablePilotSecondaryWeapon =" $ string(EnablePilotSecondaryWeapon));
		Log("EnablePilotTertiaryWeapon  =" $ string(EnablePilotTertiaryWeapon));
	}
}

function InitObjectives ()
{
	local int iLength;

	m_objGoToExtraction=new Class'R6MObjGoToExtraction';
	m_objGoToExtraction.m_bIfCompletedMissionIsSuccessfull=True;
	m_objGoToExtraction.m_bIfFailedMissionIsAborted=True;
	m_objGoToExtraction.SetPawnToExtract(None);
	iLength=m_missionMgr.m_aMissionObjectives.Length;
	m_missionMgr.m_aMissionObjectives[iLength]=m_objGoToExtraction;
	iLength++;
	m_objGoToExtraction.m_szDescriptionInMenu="EscortPilotToExtraction";
	m_missionMgr.m_bOnSuccessAllObjectivesAreCompleted=False;
	Level.m_bUseDefaultMoralityRules=False;
	Super.InitObjectives();
}

function PawnKilled (Pawn killedPawn)
{
	if ( m_bGameOver )
	{
		return;
	}
	if ( R6Pawn(killedPawn) == m_objGoToExtraction.m_pawnToExtract )
	{
		BroadcastMissionObjMsg("","","PilotWasKilled");
	}
	Super.PawnKilled(killedPawn);
}

function UnselectPilot ()
{
	if ( m_pilotController != None )
	{
		m_pilotController.PlayerReplicationInfo.m_bIsEscortedPilot=False;
		m_previousPilot=m_pilotController;
		if ( (m_previousPilot.m_pawn != None) && (m_previousPilot.m_pawn.m_bSuicideType == 1) )
		{
			m_previousPilot=None;
		}
	}
	m_pilotController=None;
}

function EndGame (PlayerReplicationInfo Winner, string Reason)
{
	local R6GameReplicationInfo gameRepInfo;

	if ( m_bGameOver )
	{
		return;
	}
	gameRepInfo=R6GameReplicationInfo(GameReplicationInfo);
	if ( m_objGoToExtraction.m_bCompleted )
	{
		if ( bShowLog )
		{
			Log("** Game : the pilot was extracted");
		}
		BroadcastGameMsg("","","GreenTeamWonRound",m_sndGreenTeamWonRound,GetGameMsgLifeTime());
		BroadcastMissionObjMsg("","","PilotHasEscaped",None,GetGameMsgLifeTime());
		AddTeamWonRound(c_iAlphaTeam);
	}
	else
	{
		if ( m_objGoToExtraction.m_bFailed )
		{
			if ( bShowLog )
			{
				Log("** Game : the pilot was killed ");
			}
			BroadcastGameMsg("","","RedTeamWonRound",m_sndRedTeamWonRound,GetGameMsgLifeTime());
			AddTeamWonRound(c_iBravoTeam);
			UnselectPilot();
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
				UnselectPilot();
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
							UnselectPilot();
						}
					}
				}
				else
				{
					if ( bShowLog )
					{
						Log("** Game : bravo prevented the escape of the pilot ");
					}
					BroadcastGameMsg("","","RedTeamWonRound",m_sndRedTeamWonRound,GetGameMsgLifeTime());
					BroadcastMissionObjMsg("","","PilotHasNotEscaped",None,GetGameMsgLifeTime());
					AddTeamWonRound(c_iBravoTeam);
					UnselectPilot();
				}
			}
		}
	}
	Super.EndGame(Winner,Reason);
}

function bool CanAutoBalancePlayer (R6PlayerController pCtrl)
{
	if ( pCtrl.PlayerReplicationInfo.m_bIsEscortedPilot )
	{
		return False;
	}
	return True;
}

auto state InBetweenRoundMenu
{
	function EndState ()
	{
		local Controller P;
		local int iTeamACount;
		local int iNewGen;
		local int i;
		local int iTotalPilot;

		P=Level.ControllerList;
	JL0014:
		if ( P != None )
		{
			if (  !P.IsA('PlayerController') )
			{
				goto JL00D8;
			}
			if ( (R6PlayerController(P).m_TeamSelection == 2) && P.PlayerReplicationInfo.m_bIsEscortedPilot && (iTotalPilot < 1) )
			{
				if ( R6PlayerController(P).m_bPenaltyBox )
				{
					P.PlayerReplicationInfo.m_bIsEscortedPilot=False;
				}
				else
				{
					iTotalPilot++;
				}
			}
			else
			{
				P.PlayerReplicationInfo.m_bIsEscortedPilot=False;
			}
	JL00D8:
			P=P.nextController;
			goto JL0014;
		}
		ProcessAutoBalanceTeam();
		m_pilotController=None;
		P=Level.ControllerList;
	JL0110:
		if ( P != None )
		{
			if (  !P.IsA('PlayerController') )
			{
				goto JL01E2;
			}
			if ( R6PlayerController(P).m_TeamSelection == 2 )
			{
				if ( (m_pilotController == None) && P.PlayerReplicationInfo.m_bIsEscortedPilot )
				{
					if ( bShowLog )
					{
						Log("InBetweenRoundMenu: still the same pilot");
					}
					m_pilotController=R6PlayerController(P);
				}
				else
				{
					if (  !R6PlayerController(P).m_bPenaltyBox )
					{
						iTeamACount++;
					}
				}
			}
	JL01E2:
			P=P.nextController;
			goto JL0110;
		}
		if ( m_pilotController == None )
		{
			iNewGen=Rand(iTeamACount);
			i=0;
			P=Level.ControllerList;
	JL022C:
			if ( P != None )
			{
				if ( P.IsA('PlayerController') && (R6PlayerController(P).m_TeamSelection == 2) &&  !R6PlayerController(P).m_bPenaltyBox )
				{
					if ( i == iNewGen )
					{
						if ( m_previousPilot == R6PlayerController(P) )
						{
							if ( iTeamACount == 1 )
							{
								m_pilotController=R6PlayerController(P);
							}
							else
							{
	JL02C7:
								if ( iNewGen == i )
								{
									iNewGen=Rand(iTeamACount);
									goto JL02C7;
								}
								i=0;
								P=Level.ControllerList;
								goto JL03BA;
							}
						}
						else
						{
							m_pilotController=R6PlayerController(P);
						}
						if ( m_pilotController != None )
						{
							if ( bShowLog )
							{
								Log("InBetweenRoundMenu: set new pilot");
							}
							P.PawnClass=Class<Pawn>(DynamicLoadObject(m_szPilotSkin,Class'Class'));
							m_pilotController.PlayerReplicationInfo.m_bIsEscortedPilot=True;
						}
						else
						{
							goto JL039B;
							i++;
	JL039B:
							if ( P != None )
							{
								P=P.nextController;
							}
	JL03BA:
							goto JL022C;
						}
					}
				}
			}
		}
		m_previousPilot=None;
		Super.EndState();
	}

}

function R6SetPawnClassInMultiPlayer (Controller PlayerController)
{
	if ( PlayerController == m_pilotController )
	{
		R6PlayerController(PlayerController).PawnClass=Class<Pawn>(DynamicLoadObject(m_szPilotSkin,Class'Class'));
	}
	else
	{
		Super.R6SetPawnClassInMultiPlayer(PlayerController);
	}
}

function RestartPlayer (Controller aPlayer)
{
	Super.RestartPlayer(aPlayer);
	if ( aPlayer == m_pilotController )
	{
		m_objGoToExtraction.SetPawnToExtract(R6Pawn(m_pilotController.Pawn));
	}
}

function bool IsPrimaryWeaponRestrictedToPawn (Pawn aPawn)
{
	if ( m_objGoToExtraction.m_pawnToExtract == aPawn )
	{
		return  !EnablePilotPrimaryWeapon;
	}
	return False;
}

function bool IsSecondaryWeaponRestrictedToPawn (Pawn aPawn)
{
	if ( m_objGoToExtraction.m_pawnToExtract == aPawn )
	{
		return  !EnablePilotSecondaryWeapon;
	}
	return False;
}

function bool IsTertiaryWeaponRestrictedToPawn (Pawn aPawn)
{
	if ( m_objGoToExtraction.m_pawnToExtract == aPawn )
	{
		return  !EnablePilotTertiaryWeapon;
	}
	return False;
}

function BroadcastGameTypeDescription ()
{
	local Controller P;
	local R6PlayerController PlayerController;

	Super.BroadcastGameTypeDescription();
	if ( m_pilotController == None )
	{
		return;
	}
	if ( m_pilotController.PlayerReplicationInfo == None )
	{
		return;
	}
//	m_pilotController.ClientPlaySound(m_sndPilot,7);
	P=Level.ControllerList;
JL0053:
	if ( P != None )
	{
		PlayerController=R6PlayerController(P);
		if ( (PlayerController != None) && (PlayerController.m_TeamSelection == 2) )
		{
			PlayerController.ClientMissionObjMsg("",m_pilotController.PlayerReplicationInfo.PlayerName,"PlayerIsThePilot");
		}
		P=P.nextController;
		goto JL0053;
	}
}

defaultproperties
{
    m_sndPilot=Sound'Voices_Control_Multiplayer.Play_YouAreThePilot'
    m_szPilotSkin="R6Characters.R6RainbowPilot"
    m_iUbiComGameMode=5
    m_eGameTypeFlag=RGM_EscortAdvMode
}
