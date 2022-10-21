//================================================================================
// R6MapList.
//================================================================================
class R6MapList extends MapList
	Native;

var bool m_bInit;
var config string GameType[32];

event PreBeginPlay ()
{
	local string serverIni;

	Super.PreBeginPlay();
	if (  !m_bInit )
	{
		serverIni=Class'Actor'.static.GetModMgr().GetServerIni();
		LoadConfig(serverIni $ ".ini");
		m_bInit=True;
	}
}

function int GetNextMapIndex (int iNextMapNum)
{
	local int iNextNum;

	if ( iNextMapNum < -1 )
	{
		iNextNum=Level.Game.GetCurrentMapNum() + 1;
	}
	else
	{
		iNextNum=iNextMapNum - 1;
	}
	if ( iNextNum > 32 - 1 )
	{
		return 0;
	}
	if ( iNextNum < 0 )
	{
		iNextNum=0;
		while ( Maps[iNextNum + 1] != "" )
		{
			iNextNum++;
		}
	}
	if ( Maps[iNextNum] == "" )
	{
		return 0;
	}
	return iNextNum;
}

function string CheckNextMap ()
{
	return Maps[GetNextMapIndex(-2)];
}

function string CheckNextMapIndex (int iMapIndex)
{
	return Maps[GetNextMapIndex(iMapIndex + 1)];
}

function string CheckNextGameType ()
{
	return GameType[GetNextMapIndex(-2)];
}

function string CheckNextGameTypeIndex (int iMapIndex)
{
	return GameType[GetNextMapIndex(iMapIndex + 1)];
}

function string CheckCurrentMap ()
{
	return Maps[Level.Game.GetCurrentMapNum()];
}

function string CheckCurrentGameType ()
{
	return GameType[Level.Game.GetCurrentMapNum()];
}

function string GetNextMap (int iNextMapNum)
{
	local int _iMapNum;

	_iMapNum=GetNextMapIndex(iNextMapNum);
	Level.Game.SetCurrentMapNum(_iMapNum);
	return Maps[_iMapNum];
}
