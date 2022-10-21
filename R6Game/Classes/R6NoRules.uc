//================================================================================
// R6NoRules.
//================================================================================
class R6NoRules extends R6MultiPlayerGameInfo;

function PlayerReadySelected (PlayerController _Controller)
{
	return;
}

auto state InMPWaitForPlayersMenu
{
	function BeginState ()
	{
		m_bGameStarted=False;
	}

	function Tick (float DeltaTime)
	{
		local Controller P;

		if ( Level.ControllerList == None )
		{
			return;
		}
		P=Level.ControllerList;
	JL002A:
		if ( P != None )
		{
			if ( P.IsA('PlayerController') && (P.PlayerReplicationInfo != None) && (R6PlayerController(P).m_TeamSelection != 0) && (R6PlayerController(P).m_TeamSelection != 4) )
			{
//				GameReplicationInfo.SetServerState(GameReplicationInfo.1);
				GotoState('InBetweenRoundMenu');
			}
			P=P.nextController;
			goto JL002A;
		}
	}

}

auto state InBetweenRoundMenu
{
	function Tick (float DeltaTime)
	{
		local Controller P;

		P=Level.ControllerList;
	JL0014:
		if ( P != None )
		{
			if ( (P.Pawn == None) &&  !R6PlayerController(P).IsPlayerPassiveSpectator() )
			{
				LetPlayerPopIn(P);
				m_bGameStarted=True;
//				GameReplicationInfo.SetServerState(GameReplicationInfo.3);
			}
			P=P.nextController;
			goto JL0014;
		}
	}

}

function LetPlayerPopIn (Controller aPlayer)
{
	Log("LetPlayerPopIn " $ string(aPlayer));
//	R6PlayerController(aPlayer).m_TeamSelection=2;
	ResetPlayerTeam(aPlayer);
}

function ResetPlayerTeam (Controller aPlayer)
{
	if ( R6Pawn(aPlayer.Pawn) == None )
	{
		RestartPlayer(aPlayer);
		aPlayer.Pawn.PlayerReplicationInfo=aPlayer.PlayerReplicationInfo;
	}
	AcceptInventory(aPlayer.Pawn);
	R6AbstractGameInfo(Level.Game).SetPawnTeamFriendlies(aPlayer.Pawn);
}

event PlayerController Login (string Portal, string Options, out string Error)
{
	if ( m_bGameStarted )
	{
		GotoState('InBetweenRoundMenu');
	}
	return Super.Login(Portal,Options,Error);
}
