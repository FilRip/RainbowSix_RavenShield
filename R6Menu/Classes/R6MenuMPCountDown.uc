//================================================================================
// R6MenuMPCountDown.
//================================================================================
class R6MenuMPCountDown extends UWindowWindow;

var int m_iLastValue;
var int m_iFrameRefresh;
var R6WindowTextLabel m_pCountDownLabel;
var R6WindowTextLabel m_pCountDown;
const C_iWAIT_XFRAMES= 10;

function Created ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	m_pCountDownLabel=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',185.00,180.00,270.00,20.00,self));
//	m_pCountDownLabel.SetProperties(Localize("POPUP","PopUpTitle_CountDown","R6Menu"),2,Root.Fonts[15],Root.Colors.White,False);
	m_pCountDownLabel.m_bResizeToText=True;
	m_pCountDown=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',185.00,200.00,270.00,20.00,self));
//	m_pCountDown.SetProperties("",2,Root.Fonts[15],Root.Colors.White,False);
	m_pCountDown.m_bResizeToText=True;
}

function Paint (Canvas C, float X, float Y)
{
	local int iServerCountDownTime;
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	if ( m_iFrameRefresh > 10 )
	{
		m_iFrameRefresh=0;
		r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
		iServerCountDownTime=Max(1,R6GameReplicationInfo(r6Root.m_R6GameMenuCom.m_GameRepInfo).GetRoundTime());
		if ( iServerCountDownTime != m_iLastValue )
		{
			m_pCountDown.SetNewText(string(iServerCountDownTime),True);
			m_iLastValue=iServerCountDownTime;
		}
	}
	m_iFrameRefresh++;
}

defaultproperties
{
    m_iLastValue=-1
    m_iFrameRefresh=11
}
