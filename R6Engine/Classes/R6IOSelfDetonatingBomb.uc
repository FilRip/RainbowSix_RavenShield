//================================================================================
// R6IOSelfDetonatingBomb.
//================================================================================
class R6IOSelfDetonatingBomb extends R6IOBomb;

var(R6ActionObject) float m_fSelfDetonationTime;
var float m_fDefusedTimeMessage;

function StartTimer ()
{
	if ( m_fSelfDetonationTime > 0 )
	{
		m_fTimeLeft=m_fSelfDetonationTime;
		m_fTimeOfExplosion=m_fSelfDetonationTime;
		m_bIsActivated=False;
		ArmBomb(None);
	}
}

simulated function Timer ()
{
	if ( (R6AbstractGameInfo(Level.Game).m_missionMgr.m_eMissionObjectiveStatus != 1) && (R6AbstractGameInfo(Level.Game).m_missionMgr.m_eMissionObjectiveStatus != 2) )
	{
		Super.Timer();
	}
}

simulated function PostRender (Canvas C)
{
	local float fStrSizeX;
	local float fStrSizeY;
	local int X;
	local int Y;
	local string sTime;
	local int iTimeLeft;

	iTimeLeft=m_fTimeLeft;
	Log("LevelTimeSeconds=" $ string(Level.TimeSeconds) $ " ,m_fDefusedTimeMessage=" $ string(m_fDefusedTimeMessage));
	if ( m_bIsActivated )
	{
		sTime=Localize("Game","TimeLeft","R6GameInfo") $ " ";
		sTime=sTime $ ConvertIntTimeToString(iTimeLeft,True);
		C.UseVirtualSize(True,640.00,480.00);
		X=C.HalfClipX;
		Y=C.HalfClipY / 16;
//		C.Font=Font'Rainbow6_14pt';
		if ( iTimeLeft > 20 )
		{
			C.SetDrawColor(255,255,255);
		}
		else
		{
			if ( iTimeLeft > 10 )
			{
				C.SetDrawColor(255,255,0);
			}
			else
			{
				C.SetDrawColor(255,0,0);
			}
		}
		C.StrLen(sTime,fStrSizeX,fStrSizeY);
		C.SetPos(X - fStrSizeX / 2,Y + 24);
		C.DrawText(sTime);
	}
}

simulated function PostRender2 (Canvas C)
{
	local float fStrSizeX;
	local float fStrSizeY;
	local int X;
	local int Y;
	local string sTime;

	if ( m_bIsActivated )
	{
		m_fDefusedTimeMessage=Level.TimeSeconds;
	}
	if (  !m_bIsActivated )
	{
		Log("LevelTimeSeconds=" $ string(Level.TimeSeconds) $ " ,m_fDefusedTimeMessage=" $ string(m_fDefusedTimeMessage));
		if ( Level.TimeSeconds - m_fDefusedTimeMessage < 3 )
		{
			sTime=Localize("Game","BombDefused","R6GameInfo") $ " ";
			C.UseVirtualSize(True,640.00,480.00);
			X=C.HalfClipX;
			Y=C.HalfClipY / 16;
//			C.Font=Font'Rainbow6_14pt';
			C.SetDrawColor(255,255,255);
			C.StrLen(sTime,fStrSizeX,fStrSizeY);
			C.SetPos(X - fStrSizeX / 2,Y + 48);
			C.DrawText(sTime);
		}
	}
}
