//================================================================================
// R6BroadcastHandler.
//================================================================================
class R6BroadcastHandler extends BroadcastHandler;

var bool m_bShowLog;

function bool IsSpectator (R6PlayerController A)
{
	return A.PlayerReplicationInfo.bIsSpectator || (A.PlayerReplicationInfo.TeamID == 0) || (A.PlayerReplicationInfo.TeamID == 4);
}

function bool IsATeamMember (R6PlayerController A)
{
	return (A.m_TeamSelection == 2) || (A.m_TeamSelection == 3);
}

function bool IsSameTeam (R6PlayerController A, R6PlayerController B)
{
	if (  !IsATeamMember(B) )
	{
		return False;
	}
	return A.PlayerReplicationInfo.TeamID == B.PlayerReplicationInfo.TeamID;
}

function bool IsPlayerDead (R6PlayerController A)
{
	return A.PlayerReplicationInfo.m_iHealth > 1;
}

function BroadcastTeam (Actor Sender, coerce string Msg, optional name type)
{
	local R6PlayerController aSender;
	local R6Pawn aSenderPawn;
	local PlayerReplicationInfo SenderPRI;
	local R6PlayerController B;
	local bool bSend;
	local bool bGameTypeMsg;

	if ( Pawn(Sender) != None )
	{
		SenderPRI=Pawn(Sender).PlayerReplicationInfo;
	}
	else
	{
		if ( Controller(Sender) != None )
		{
			SenderPRI=Controller(Sender).PlayerReplicationInfo;
		}
	}
	aSender=R6PlayerController(Sender);
	if ( aSender == None )
	{
		Log("none = R6PlayerController(Sender)");
		return;
	}
	if (  !IsATeamMember(aSender) )
	{
		Log("!IsATeamMember( aSender )");
		return;
	}
	if ( (type != 'Line') &&  !AllowsBroadcast(Sender,Len(Msg)) )
	{
		return;
	}
	aSenderPawn=R6Pawn(aSender.Pawn);
	if ( (aSenderPawn != None) && (aSenderPawn.m_TeamMemberRepInfo != None) )
	{
		aSenderPawn.m_TeamMemberRepInfo.m_BlinkCounter++;
	}
	foreach DynamicActors(Class'R6PlayerController',B)
	{
		bSend=False;
		if ( IsSameTeam(aSender,B) )
		{
			if (  !IsPlayerDead(aSender) )
			{
				bSend=True;
			}
			else
			{
				if ( IsPlayerDead(B) )
				{
					bSend=True;
				}
			}
		}
		if ( bSend )
		{
			BroadcastText(SenderPRI,B,Msg,type);
		}
	}
}

function DebugBroadcaster (R6PlayerController A, bool bSender)
{
	local string szName;

	if ( A.PlayerReplicationInfo != None )
	{
		szName=A.PlayerReplicationInfo.PlayerName;
	}
	Log("Broadcast: " $ szName $ " bSender=" $ string(bSender) $ " spec=" $ string(IsSpectator(A)) $ " dead=" $ string(IsPlayerDead(A)) $ " team=" $ string(IsATeamMember(A)) $ " teamID=" $ string(A.PlayerReplicationInfo.TeamID) $ " health=" $ string(A.PlayerReplicationInfo.m_iHealth));
}

function Broadcast (Actor Sender, coerce string Msg, optional name type)
{
	local R6PlayerController aSender;
	local R6Pawn aSenderPawn;
	local R6PlayerController B;
	local PlayerReplicationInfo PRI;
	local bool bSend;
	local bool bGameTypeMsg;

	if ( type == 'GameMsg' )
	{
		bGameTypeMsg=True;
	}
	else
	{
		if ( type == 'TeamSay' )
		{
			return;
		}
	}
	aSender=R6PlayerController(Sender);
	if (  !bGameTypeMsg )
	{
		if ( (aSender == None) && (type != 'ServerMessage') )
		{
			return;
		}
		if ( (type != 'Line') && (type != 'ServerMessage') &&  !AllowsBroadcast(Sender,Len(Msg)) )
		{
			return;
		}
	}
	if ( Pawn(Sender) != None )
	{
		PRI=Pawn(Sender).PlayerReplicationInfo;
	}
	else
	{
		if ( Controller(Sender) != None )
		{
			PRI=Controller(Sender).PlayerReplicationInfo;
		}
	}
	if ( (type != 'ServerMessage') &&  !bGameTypeMsg )
	{
		if ( m_bShowLog )
		{
			DebugBroadcaster(aSender,True);
		}
	}
	if ( aSender != None )
	{
		aSenderPawn=R6Pawn(aSender.Pawn);
		if ( (aSenderPawn != None) && (aSenderPawn.m_TeamMemberRepInfo != None) )
		{
			aSenderPawn.m_TeamMemberRepInfo.m_BlinkCounter++;
		}
	}
	foreach DynamicActors(Class'R6PlayerController',B)
	{
		bSend=False;
		if ( (type == 'ServerMessage') || bGameTypeMsg )
		{
			bSend=True;
		}
		else
		{
			if ( m_bShowLog )
			{
				DebugBroadcaster(B,False);
			}
			if ( IsSpectator(aSender) )
			{
				if ( IsSpectator(B) || IsPlayerDead(B) )
				{
					bSend=True;
				}
			}
			else
			{
				if ( IsPlayerDead(aSender) )
				{
					if ( IsPlayerDead(B) || IsSpectator(B) )
					{
						bSend=True;
					}
				}
				else
				{
					if (  !IsPlayerDead(aSender) )
					{
						bSend=True;
					}
				}
			}
		}
		if ( bSend )
		{
			BroadcastText(PRI,B,Msg,type);
		}
	}
}