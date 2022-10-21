//================================================================================
// R6MenuMPInGameHelpBar.
//================================================================================
class R6MenuMPInGameHelpBar extends R6MenuHelpTextBar;

var bool m_bUseExternSetTip;
var string m_szExternTip;

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	C.Font=Root.Fonts[5];
	if ( m_bUseExternSetTip )
	{
		m_szText=GetToolTip();
		if ( m_szText == "" )
		{
			m_szText=m_szDefaultText;
		}
	}
	else
	{
		m_szText=m_szDefaultText;
		if ( Root.MouseWindow != None )
		{
			if ( Root.MouseWindow.ToolTipString != "" )
			{
				m_szText=Root.MouseWindow.ToolTipString;
			}
		}
	}
	if ( m_szText != "" )
	{
		TextSize(C,m_szText,W,H);
		m_fTextX=(WinWidth - W) / 2;
		m_fTextY=(WinHeight - H) / 2;
		m_fTextY=m_fTextY + 0.50;
	}
}

function Paint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
	C.Style=5;
	C.Font=Root.Fonts[5];
	ClipText(C,m_fTextX,m_fTextY,m_szText);
}

function SetToolTip (string _szToolTip)
{
	m_szExternTip=_szToolTip;
}

function string GetToolTip ()
{
	return m_szExternTip;
}