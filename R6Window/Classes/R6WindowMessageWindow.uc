//================================================================================
// R6WindowMessageWindow.
//================================================================================
class R6WindowMessageWindow extends R6WindowFramedWindow;

var TextAlign m_MessageAlign;
var TextAlign m_MessageAlignY;
var float m_fMessageX;
var float m_fMessageY;
var float m_fMessageTab;
var Color m_MessageColor;
var string m_szMessage;

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	Super.BeforePaint(C,X,Y);
	if ( m_szMessage != "" )
	{
		C.Font=Root.Fonts[0];
		TextSize(C,m_szMessage,W,H);
		if ( m_MessageAlignY == 2 )
		{
			m_fMessageY=LookAndFeel.FrameT.H + (WinHeight - LookAndFeel.FrameT.H - LookAndFeel.FrameB.H - H) / 2;
		}
		else
		{
			m_fMessageY=LookAndFeel.FrameT.H;
		}
		switch (m_MessageAlign)
		{
/*			case 0:
			m_fMessageX=LookAndFeel.FrameL.W + m_fMessageTab;
			break;
			case 1:
			m_fMessageX=WinWidth - W - LookAndFeel.FrameL.W;
			break;
			case 2:
			m_fMessageX=(WinWidth - W) / 2;
			break;
			default:*/
		}
	}
}

function Paint (Canvas C, float X, float Y)
{
	Super.Paint(C,X,Y);
	if ( m_szMessage != "" )
	{
		C.SetDrawColor(m_MessageColor.R,m_MessageColor.G,m_MessageColor.B);
		ClipText(C,m_fMessageX,m_fMessageY,m_szMessage,True);
		C.SetDrawColor(255,255,255);
	}
}

defaultproperties
{
    m_MessageColor=(R=255,G=255,B=255,A=0)
}
