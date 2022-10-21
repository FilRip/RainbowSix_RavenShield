//================================================================================
// R6MenuWeaponStats.
//================================================================================
class R6MenuWeaponStats extends UWindowWindow;

var bool m_bDrawBorders;
var bool m_bDrawBG;
var bool bShowLog;
var float m_fInitRangePercent;
var float m_fInitDamagePercent;
var float m_fInitAccuracyPercent;
var float m_fInitRecoilPercent;
var float m_fInitRecoveryPercent;
var float m_fRangePercent;
var float m_fDamagePercent;
var float m_fAccuracyPercent;
var float m_fRecoilPercent;
var float m_fRecoveryPercent;
var float m_fMaxChartWidth;
var float m_fNLeftPadding;
var float m_fBetweenLabelPadding;
var float m_fTopYPadding;
var float m_fTitleHeight;
var float m_fYPaddingBetweenElements;
var float m_fNumericLabelWidth;
var R6MenuOperativeSkillsLabel m_TRange;
var R6MenuOperativeSkillsLabel m_TDamage;
var R6MenuOperativeSkillsLabel m_TAccuracy;
var R6MenuOperativeSkillsLabel m_TRecoil;
var R6MenuOperativeSkillsLabel m_TRecovery;
var R6MenuOperativeSkillsBitmap m_LCRange;
var R6MenuOperativeSkillsBitmap m_LCDamage;
var R6MenuOperativeSkillsBitmap m_LCAccuracy;
var R6MenuOperativeSkillsBitmap m_LCRecoil;
var R6MenuOperativeSkillsBitmap m_LCRecovery;

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
	m_TRange=CreateTitle(X,Y,W,H,"Range");
	Y += TotItemHeight;
	m_TDamage=CreateTitle(X,Y,W,H,"Damage");
	Y += TotItemHeight;
	m_TAccuracy=CreateTitle(X,Y,W,H,"Accuracy");
	Y += TotItemHeight;
	m_TRecoil=CreateTitle(X,Y,W,H,"Recoil");
	Y += TotItemHeight;
	m_TRecovery=CreateTitle(X,Y,W,H,"Recovery");
	m_fMaxChartWidth=Class'R6MenuOperativeSkillsBitmap'.Default.R.W;
	offset=m_fTitleHeight + m_fYPaddingBetweenElements;
	Y=m_TRange.WinTop + offset;
	H=Class'R6MenuOperativeSkillsBitmap'.Default.R.H;
	m_LCRange=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TDamage.WinTop + offset;
	m_LCDamage=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TAccuracy.WinTop + offset;
	m_LCAccuracy=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TRecoil.WinTop + offset;
	m_LCRecoil=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
	Y=m_TRecovery.WinTop + offset;
	m_LCRecovery=R6MenuOperativeSkillsBitmap(CreateWindow(Class'R6MenuOperativeSkillsBitmap',X,Y,W,H,self));
}

function R6MenuOperativeSkillsLabel CreateTitle (float _fX, float _fY, float _fW, float _fH, string _szTitle)
{
	local R6MenuOperativeSkillsLabel pWSkillLabel;

	pWSkillLabel=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',_fX,_fY,_fW,_fH,self));
	pWSkillLabel.Text=Localize("GearRoom",_szTitle,"R6Menu");
	pWSkillLabel.m_fWidthOfFixArea=60.00;
	pWSkillLabel.m_NumericValueColor=Root.Colors.BlueLight;
	return pWSkillLabel;
}

function ResizeCharts ()
{
	if ( bShowLog )
	{
		Log("////////////////////////////////////////////");
		Log("///////  ResizeCharts() Before Fmin  ///////");
		Log("////////////////////////////////////////////");
		Log("m_fRangePercent" @ string(m_fRangePercent));
		Log("m_fDamagePercent" @ string(m_fDamagePercent));
		Log("m_fAccuracyPercent" @ string(m_fAccuracyPercent));
		Log("m_fRecoilPercent" @ string(m_fRecoilPercent));
		Log("m_fRecoveryPercent" @ string(m_fRecoveryPercent));
		Log("////////////////////////////////////////////");
	}
	m_fRangePercent=FMin(m_fRangePercent,100.00);
	m_fDamagePercent=FMin(m_fDamagePercent,100.00);
	m_fAccuracyPercent=FMin(m_fAccuracyPercent,100.00);
	m_fRecoilPercent=FMin(m_fRecoilPercent,100.00);
	m_fRecoveryPercent=FMin(m_fRecoveryPercent,100.00);
	m_TRange.SetNumericValue(m_fInitRangePercent,m_fRangePercent);
	m_TDamage.SetNumericValue(m_fInitDamagePercent,m_fDamagePercent);
	m_TAccuracy.SetNumericValue(m_fInitAccuracyPercent,m_fAccuracyPercent);
	m_TRecoil.SetNumericValue(m_fInitRecoilPercent,m_fRecoilPercent);
	m_TRecovery.SetNumericValue(m_fInitRecoveryPercent,m_fRecoveryPercent);
	m_LCRange.WinWidth=m_fRangePercent * m_fMaxChartWidth / 100.00;
	m_LCDamage.WinWidth=m_fDamagePercent * m_fMaxChartWidth / 100.00;
	m_LCAccuracy.WinWidth=m_fAccuracyPercent * m_fMaxChartWidth / 100.00;
	m_LCRecoil.WinWidth=m_fRecoilPercent * m_fMaxChartWidth / 100.00;
	m_LCRecovery.WinWidth=m_fRecoveryPercent * m_fMaxChartWidth / 100.00;
}

function Paint (Canvas C, float X, float Y)
{
	if ( m_bDrawBG )
	{
		R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,0.00,0.00,WinWidth,WinHeight);
	}
	if ( m_bDrawBorders )
	{
		DrawSimpleBorder(C);
	}
}

defaultproperties
{
    m_bDrawBorders=True
    m_bDrawBG=True
    m_fRangePercent=100.00
    m_fDamagePercent=100.00
    m_fAccuracyPercent=100.00
    m_fRecoilPercent=100.00
    m_fRecoveryPercent=100.00
    m_fNLeftPadding=7.00
    m_fBetweenLabelPadding=7.00
    m_fTopYPadding=7.00
    m_fTitleHeight=12.00
    m_fYPaddingBetweenElements=6.00
    m_fNumericLabelWidth=30.00
}