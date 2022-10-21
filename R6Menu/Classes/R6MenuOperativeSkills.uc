//================================================================================
// R6MenuOperativeSkills.
//================================================================================
class R6MenuOperativeSkills extends UWindowWindow;

var bool bShowLog;
var float m_fAssault;
var float m_fDemolitions;
var float m_fElectronics;
var float m_fSniper;
var float m_fStealth;
var float m_fSelfControl;
var float m_fLeadership;
var float m_fObservation;
var float m_fMaxChartWidth;
var float m_fNLeftPadding;
var float m_fBetweenLabelPadding;
var float m_fTopYPadding;
var float m_fTitleHeight;
var float m_fYPaddingBetweenElements;
var float m_fNumericLabelWidth;
var R6MenuOperativeSkillsLabel m_TAssault;
var R6MenuOperativeSkillsLabel m_TDemolitions;
var R6MenuOperativeSkillsLabel m_TElectronics;
var R6MenuOperativeSkillsLabel m_TSniper;
var R6MenuOperativeSkillsLabel m_TStealth;
var R6MenuOperativeSkillsLabel m_TSelfControl;
var R6MenuOperativeSkillsLabel m_TLeadership;
var R6MenuOperativeSkillsLabel m_TObservation;
var R6MenuOperativeSkillsBitmap m_LCAssault;
var R6MenuOperativeSkillsBitmap m_LCDemolitions;
var R6MenuOperativeSkillsBitmap m_LCElectronics;
var R6MenuOperativeSkillsBitmap m_LCSniper;
var R6MenuOperativeSkillsBitmap m_LCStealth;
var R6MenuOperativeSkillsBitmap m_LCSelfControl;
var R6MenuOperativeSkillsBitmap m_LCLeadership;
var R6MenuOperativeSkillsBitmap m_LCObservation;

function Created ()
{
	local float X;
	local float Y;
	local float W;
	local float H;
	local float TotItemHeight;
	local float offset;

	X=m_fNLeftPadding;
	Y=m_fTopYPadding;
	W=WinWidth - 2 * m_fNLeftPadding;
	H=m_fTitleHeight;
	TotItemHeight=m_fTitleHeight + Class'R6MenuOperativeSkillsBitmap'.Default.R.H + 2 * m_fYPaddingBetweenElements;
	m_TAssault=CreateTitle(X,Y,W,H,"Assault");
	Y += TotItemHeight;
	m_TDemolitions=CreateTitle(X,Y,W,H,"Demolitions");
	Y += TotItemHeight;
	m_TElectronics=CreateTitle(X,Y,W,H,"Electronics");
	Y += TotItemHeight;
	m_TSniper=CreateTitle(X,Y,W,H,"Sniper");
	Y += TotItemHeight;
	m_TStealth=CreateTitle(X,Y,W,H,"Stealth");
	Y += TotItemHeight;
	m_TSelfControl=CreateTitle(X,Y,W,H,"SelfControl");
	Y += TotItemHeight;
	m_TLeadership=CreateTitle(X,Y,W,H,"Leadership");
	Y += TotItemHeight;
	m_TObservation=CreateTitle(X,Y,W,H,"Observation");
	m_fMaxChartWidth=Class'R6MenuOperativeSkillsBitmap'.Default.R.W;
	offset=m_fTitleHeight + m_fYPaddingBetweenElements;
	Y=m_TAssault.WinTop + offset;
	H=Class'R6MenuOperativeSkillsBitmap'.Default.R.H;
	m_LCAssault=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TDemolitions.WinTop + offset;
	m_LCDemolitions=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TElectronics.WinTop + offset;
	m_LCElectronics=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TSniper.WinTop + offset;
	m_LCSniper=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TStealth.WinTop + offset;
	m_LCStealth=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TSelfControl.WinTop + offset;
	m_LCSelfControl=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TLeadership.WinTop + offset;
	m_LCLeadership=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TObservation.WinTop + offset;
	m_LCObservation=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
}

function R6MenuOperativeSkillsLabel CreateTitle (float _fX, float _fY, float _fW, float _fH, string _szTitle)
{
	local R6MenuOperativeSkillsLabel pWSkillLabel;

	pWSkillLabel=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',_fX,_fY,_fW,_fH,self));
	pWSkillLabel.Text=Localize("R6Operative",_szTitle,"R6Menu");
	pWSkillLabel.m_fWidthOfFixArea=60.00;
	pWSkillLabel.m_NumericValueColor=Root.Colors.BlueLight;
	return pWSkillLabel;
}

function ResizeCharts (R6Operative _CurrentOperative)
{
	m_fAssault=FMin(m_fAssault + 0.50,100.00);
	m_fDemolitions=FMin(m_fDemolitions + 0.50,100.00);
	m_fElectronics=FMin(m_fElectronics + 0.50,100.00);
	m_fSniper=FMin(m_fSniper + 0.50,100.00);
	m_fStealth=FMin(m_fStealth + 0.50,100.00);
	m_fSelfControl=FMin(m_fSelfControl + 0.50,100.00);
	m_fLeadership=FMin(m_fLeadership + 0.50,100.00);
	m_fObservation=FMin(m_fObservation + 0.50,100.00);
	m_TAssault.SetNumericValue(_CurrentOperative.Default.m_fAssault + 0.50,m_fAssault);
	m_TDemolitions.SetNumericValue(_CurrentOperative.Default.m_fDemolitions + 0.50,m_fDemolitions);
	m_TElectronics.SetNumericValue(_CurrentOperative.Default.m_fElectronics + 0.50,m_fElectronics);
	m_TSniper.SetNumericValue(_CurrentOperative.Default.m_fSniper + 0.50,m_fSniper);
	m_TStealth.SetNumericValue(_CurrentOperative.Default.m_fStealth + 0.50,m_fStealth);
	m_TSelfControl.SetNumericValue(_CurrentOperative.Default.m_fSelfControl + 0.50,m_fSelfControl);
	m_TLeadership.SetNumericValue(_CurrentOperative.Default.m_fLeadership + 0.50,m_fLeadership);
	m_TObservation.SetNumericValue(_CurrentOperative.Default.m_fObservation + 0.50,m_fObservation);
	m_LCAssault.WinWidth=m_fAssault * m_fMaxChartWidth / 100.00;
	m_LCDemolitions.WinWidth=m_fDemolitions * m_fMaxChartWidth / 100.00;
	m_LCElectronics.WinWidth=m_fElectronics * m_fMaxChartWidth / 100.00;
	m_LCSniper.WinWidth=m_fSniper * m_fMaxChartWidth / 100.00;
	m_LCStealth.WinWidth=m_fStealth * m_fMaxChartWidth / 100.00;
	m_LCSelfControl.WinWidth=m_fSelfControl * m_fMaxChartWidth / 100.00;
	m_LCLeadership.WinWidth=m_fLeadership * m_fMaxChartWidth / 100.00;
	m_LCObservation.WinWidth=m_fObservation * m_fMaxChartWidth / 100.00;
}

function Paint (Canvas C, float X, float Y)
{
	R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,0.00,0.00,WinWidth,WinHeight);
}

defaultproperties
{
    m_fAssault=100.00
    m_fDemolitions=100.00
    m_fElectronics=100.00
    m_fSniper=100.00
    m_fStealth=100.00
    m_fSelfControl=100.00
    m_fLeadership=100.00
    m_fObservation=100.00
    m_fNLeftPadding=7.00
    m_fBetweenLabelPadding=7.00
    m_fTopYPadding=7.00
    m_fTitleHeight=12.00
    m_fYPaddingBetweenElements=6.00
    m_fNumericLabelWidth=30.00
}