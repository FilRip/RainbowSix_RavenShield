//================================================================================
// R6MenuVideo.
//================================================================================
class R6MenuVideo extends UWindowWindow;

var int m_iCentered;
var int m_iXStartPos;
var int m_iYStartPos;
var bool m_bAlreadyStart;
var bool m_bPlayVideo;
var bool bShowLog;
var string m_szVideoFilename;

function PlayVideo (int _iXStartPos, int _iYStartPos, string _szVideoFileName)
{
	m_szVideoFilename=_szVideoFileName;
	if ( m_szVideoFilename != "" )
	{
		m_bPlayVideo=True;
		m_iXStartPos=_iXStartPos;
		m_iYStartPos=_iYStartPos;
	}
	if ( bShowLog )
	{
		Log("PlayVideo");
		Log("m_szVideoFilename" @ m_szVideoFilename @ "m_bPlayVideo" @ string(m_bPlayVideo));
	}
}

function StopVideo ()
{
	local Canvas C;

	if ( bShowLog )
	{
		Log("StopVideo");
		Log("m_bPlayVideo" @ string(m_bPlayVideo));
	}
	if ( m_bPlayVideo )
	{
		C=Class'Actor'.static.GetCanvas();
		m_bPlayVideo=False;
		m_bAlreadyStart=False;
		C.VideoStop();
	}
	if ( bShowLog )
	{
		Log("m_bPlayVideo" @ string(m_bPlayVideo));
		Log("m_bAlreadyStart" @ string(m_bAlreadyStart));
	}
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_bPlayVideo )
	{
		if (  !m_bAlreadyStart )
		{
			if ( bShowLog )
			{
				Log("Paint m_bPlayVideo = true m_bAlreadyStart = false");
			}
			C.VideoOpen(m_szVideoFilename,0);
			m_bAlreadyStart=True;
			C.VideoPlay(m_iXStartPos,m_iYStartPos,m_iCentered);
		}
	}
	DrawSimpleBorder(C);
}
