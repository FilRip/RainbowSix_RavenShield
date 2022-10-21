//================================================================================
// R6MenuOperativeStats.
//================================================================================
class R6MenuOperativeStats extends UWindowWindow;

var bool bShowLog;
var float m_fHSidePadding;
var float m_fTileLabelWidth;
var float m_fTopYPadding;
var float m_fTitleHeight;
var float m_fValueLabelWidth;
var float m_fYPaddingBetweenElements;
var R6MenuOperativeSkillsLabel m_TNbMissions;
var R6MenuOperativeSkillsLabel m_TTerroKilled;
var R6MenuOperativeSkillsLabel m_TRoundsFired;
var R6MenuOperativeSkillsLabel m_TRoundsOnTarget;
var R6MenuOperativeSkillsLabel m_TShootPercent;
var R6MenuOperativeSkillsLabel m_TGender;
var R6MenuOperativeSkillsLabel m_NNbMissions;
var R6MenuOperativeSkillsLabel m_NTerroKilled;
var R6MenuOperativeSkillsLabel m_NRoundsFired;
var R6MenuOperativeSkillsLabel m_NRoundsOnTarget;
var R6MenuOperativeSkillsLabel m_NShootPercent;
var R6MenuOperativeSkillsLabel m_NGender;

function Created ()
{
	local float Y;
	local float X;
	local float TitlesHeight;
	local float ValuesHeight;

	TitlesHeight=m_fTitleHeight + m_fYPaddingBetweenElements;
	ValuesHeight=Class'R6MenuOperativeSkillsLabel'.Default.m_BGTextureRegion.H;
	m_TNbMissions=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,m_fTopYPadding,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TNbMissions.Text=Localize("R6Operative","NbMissions","R6Menu");
	m_TNbMissions.m_BGTexture=None;
	Y=m_TNbMissions.WinTop + TitlesHeight;
	m_TTerroKilled=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TTerroKilled.Text=Localize("R6Operative","TerroKilled","R6Menu");
	m_TTerroKilled.m_BGTexture=None;
	Y=m_TTerroKilled.WinTop + TitlesHeight;
	m_TRoundsFired=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TRoundsFired.Text=Localize("R6Operative","RoundsFired","R6Menu");
	m_TRoundsFired.m_BGTexture=None;
	Y=m_TRoundsFired.WinTop + TitlesHeight;
	m_TRoundsOnTarget=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TRoundsOnTarget.Text=Localize("R6Operative","RoundsOnTarget","R6Menu");
	m_TRoundsOnTarget.m_BGTexture=None;
	Y=m_TRoundsOnTarget.WinTop + TitlesHeight;
	m_TShootPercent=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TShootPercent.Text=Localize("R6Operative","ShootPercent","R6Menu");
	m_TShootPercent.m_BGTexture=None;
	X=WinWidth - m_fValueLabelWidth - m_fHSidePadding;
	Y=m_TNbMissions.WinTop;
	m_NNbMissions=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NNbMissions.align=ta_right;
	Y=m_TTerroKilled.WinTop;
	m_NTerroKilled=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NTerroKilled.align=ta_right;
	Y=m_TRoundsFired.WinTop;
	m_NRoundsFired=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NRoundsFired.align=ta_right;
	Y=m_TRoundsOnTarget.WinTop;
	m_NRoundsOnTarget=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NRoundsOnTarget.align=ta_right;
	Y=m_TShootPercent.WinTop;
	m_NShootPercent=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NShootPercent.align=ta_right;
}

function SetNbMissions (string _szNbMissions)
{
	m_NNbMissions.SetNewText(_szNbMissions,True);
}

function SeTTerroKilled (string _szTerroKilled)
{
	m_NTerroKilled.SetNewText(_szTerroKilled,True);
}

function SetRoundsFired (string _szRoundsFired)
{
	m_NRoundsFired.SetNewText(_szRoundsFired,True);
}

function SetRoundsOnTarget (string _szRoundsOnTarget)
{
	m_NRoundsOnTarget.SetNewText(_szRoundsOnTarget,True);
}

function SetShootPercent (string _szShootPercent)
{
	m_NShootPercent.SetNewText(_szShootPercent,True);
}

function Paint (Canvas C, float X, float Y)
{
	R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,0.00,0.00,WinWidth,WinHeight);
}

defaultproperties
{
    m_fHSidePadding=5.00
    m_fTileLabelWidth=148.00
    m_fTopYPadding=7.00
    m_fTitleHeight=12.00
    m_fValueLabelWidth=32.00
    m_fYPaddingBetweenElements=3.00
}