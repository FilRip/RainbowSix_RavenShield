//================================================================================
// GameRules.
//================================================================================
class GameRules extends Info;

var GameRules NextGameRules;

function AddGameRules (GameRules GR)
{
	if ( NextGameRules == None )
	{
		NextGameRules=GR;
	}
	else
	{
		NextGameRules.AddGameRules(GR);
	}
}

function NavigationPoint FindPlayerStart (Controller Player, optional byte InTeam, optional string incomingName)
{
	if ( NextGameRules != None )
	{
		return NextGameRules.FindPlayerStart(Player,InTeam,incomingName);
	}
	return None;
}

function string GetRules ()
{
	local string ResultSet;

	if ( NextGameRules == None )
	{
		ResultSet=ResultSet $ NextGameRules.GetRules();
	}
	return ResultSet;
}

function bool HandleRestartGame ()
{
	if ( (NextGameRules != None) && NextGameRules.HandleRestartGame() )
	{
		return True;
	}
	return False;
}

function bool CheckEndGame (PlayerReplicationInfo Winner, string Reason)
{
	if ( NextGameRules != None )
	{
		return NextGameRules.CheckEndGame(Winner,Reason);
	}
	return True;
}

function bool CheckScore (PlayerReplicationInfo Scorer)
{
	if ( NextGameRules != None )
	{
		return NextGameRules.CheckScore(Scorer);
	}
	return False;
}

function bool PreventDeath (Pawn Killed, Controller Killer, Class<DamageType> DamageType, Vector HitLocation)
{
	if ( (NextGameRules != None) && NextGameRules.PreventDeath(Killed,Killer,DamageType,HitLocation) )
	{
		return True;
	}
	return False;
}

function ScoreObjective (PlayerReplicationInfo Scorer, int Score)
{
	if ( NextGameRules != None )
	{
		NextGameRules.ScoreObjective(Scorer,Score);
	}
}

function ScoreKill (Controller Killer, Controller Killed)
{
	if ( NextGameRules != None )
	{
		NextGameRules.ScoreKill(Killer,Killed);
	}
}

function int NetDamage (int OriginalDamage, int Damage, Pawn injured, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if ( NextGameRules != None )
	{
		return NextGameRules.NetDamage(OriginalDamage,Damage,injured,instigatedBy,HitLocation,Momentum,DamageType);
	}
	return Damage;
}
