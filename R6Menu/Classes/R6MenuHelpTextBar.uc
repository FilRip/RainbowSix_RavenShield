//================================================================================
// R6MenuHelpTextBar.
//================================================================================
class R6MenuHelpTextBar extends UWindowWindow;

var float m_fTextX;
var float m_fTextY;
var string m_szText;
var string m_szDefaultText;

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	C.Font=Root.Fonts[5];
	m_szText=m_szDefaultText;
	if ( Root.MouseWindow != None )
	{
		if ( Root.MouseWindow.ToolTipString != "" )
		{
			m_szText=Root.MouseWindow.ToolTipString;
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
	C.Font=Root.Fonts[5];
	ClipText(C,m_fTextX,m_fTextY,m_szText);
}