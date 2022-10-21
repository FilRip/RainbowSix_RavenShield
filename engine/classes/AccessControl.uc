//================================================================================
// AccessControl.
//================================================================================
class AccessControl extends Info
	Config(BanList);

var Class<Admin> AdminClass;
var config array<string> Banned;
var private string AdminPassword;
var private string GamePassword;

function SetAdminPassword (string P)
{
	AdminPassword=P;
}

function SetGamePassword (string P)
{
	GamePassword=P;
}

function string GetGamePassword ()
{
	return GamePassword;
}

function bool GamePasswordNeeded ()
{
	return GamePassword != "";
}

function KickBan (string S)
{
	local Controller _Ctrl;
	local PlayerController P;
	local string ID;
	local int j;
	local int i;

	for (_Ctrl=Level.ControllerList;_Ctrl != None;_Ctrl=_Ctrl.nextController)
	{
		P=PlayerController(_Ctrl);
		if ( (P != None) && (P.PlayerReplicationInfo.PlayerName ~= S) && (NetConnection(P.Player) != None) )
		{
			ID=P.m_szGlobalID;
			if (  !IsGlobalIDBanned(ID) )
			{
				Log("Adding ID Ban for: " $ Caps(ID));
				Banned[Banned.Length]=Caps(ID);
				SaveConfig();
			}
			return;
		}
	}
}

function int RemoveBan (string szBanPrefix)
{
	local int i;
	local int iMatchesFound;
	local int iPosFound;

	iMatchesFound=0;
	i=-1;
SearchBan:
	i++;
	i=NextMatchingID(szBanPrefix,i);
	if ( i > -1 )
	{
		iMatchesFound++;
		iPosFound=i;
	}
	if (!(i == -1)) goto SearchBan;
	if ( iMatchesFound == 1 )
	{
		Banned.Remove (iPosFound,1);
		SaveConfig();
	}
	return iMatchesFound;
}

function int NextMatchingID (string szBanPrefix, int iLastIt)
{
	local int i;

	i=iLastIt;
	while ( i < Banned.Length )
	{
		if ( Strnicmp(Banned[i],szBanPrefix,Len(szBanPrefix)) == 0 )
		{
			return i;
		}
		i++;
	}
	if ( i >= Banned.Length )
	{
		return -1;
	}
}

event PreLogin (string Options, string Address, out string Error, out string FailCode, bool bSpectator)
{
	local string InPassword;
	local string SpectatorClass;
	local PlayerController P;

	Error="";
	InPassword=Level.Game.ParseOption(Options,"Password");
	if ( (Level.NetMode != 0) && Level.Game.AtCapacity(bSpectator) )
	{
		Error="PopUp_Error_ServerFull";
	}
	else
	{
		if ( (GamePassword != "") && (InPassword != GamePassword) && ((AdminPassword == "") || (InPassword != AdminPassword)) )
		{
			Error="PopUp_Error_PassWd";
			FailCode="WRONGPW";
		}
	}
}

event bool IsGlobalIDBanned (string GlobalID)
{
	local int i;
	local string szGlobalID;

	i=0;
	while ( i < Banned.Length )
	{
		if ( Banned[i] ~= GlobalID )
		{
			return True;
		}
		++i;
	}
	return False;
}

defaultproperties
{
    AdminClass=Class'Admin'
}
