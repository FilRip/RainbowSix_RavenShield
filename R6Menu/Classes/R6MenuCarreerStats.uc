//================================================================================
// R6MenuCarreerStats.
//================================================================================
class R6MenuCarreerStats extends UWindowWindow;

var int m_iPadding;
var int m_iHeight;
var float m_fTitleHeight;
var float m_fYOffSet;
var float m_fXOffSet;
var float m_fLabelHeight;
var float m_fLOpNameX;
var float m_fLOpNameW;
var R6WindowTextLabel m_LTitle;
var R6WindowTextLabel m_LMissionServed;
var R6WindowTextLabel m_LTerroKilled;
var R6WindowTextLabel m_LRoundsFired;
var R6WindowTextLabel m_LRoundsOnTarget;
var R6WindowTextLabel m_LShootPercent;
var R6WindowTextLabel m_LOpName;
var R6WindowTextLabel m_LOpSpecility;
var R6WindowTextLabel m_LOpHealthStatus;
var R6WindowBitMap m_RainBowLogo;
var Texture m_TRainBowLogo;
var R6MenuCarreerOperative m_OperativeFace;
var Region m_RRainBowLogo;

function Created ()
{
	local int YPos;
	local int XPos;

	m_LTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,m_fTitleHeight,self));
//	m_LTitle.SetProperties(Localize("DebriefingMenu","CARREERSTATS","R6Menu"),2,Root.Fonts[8],Root.Colors.BlueLight,False);
	YPos=m_fYOffSet;
	m_LMissionServed=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fXOffSet,YPos,WinWidth - m_fXOffSet,m_fLabelHeight,self));
//	m_LMissionServed.SetProperties("",0,Root.Fonts[5],Root.Colors.BlueLight,False);
	YPos += m_fLabelHeight;
	m_LTerroKilled=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fXOffSet,YPos,WinWidth - m_fXOffSet,m_fLabelHeight,self));
//	m_LTerroKilled.SetProperties("",0,Root.Fonts[5],Root.Colors.BlueLight,False);
	YPos += m_fLabelHeight;
	m_LRoundsFired=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fXOffSet,YPos,WinWidth - m_fXOffSet,m_fLabelHeight,self));
//	m_LRoundsFired.SetProperties("",0,Root.Fonts[5],Root.Colors.BlueLight,False);
	YPos += m_fLabelHeight;
	m_LRoundsOnTarget=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fXOffSet,YPos,WinWidth - m_fXOffSet,m_fLabelHeight,self));
//	m_LRoundsOnTarget.SetProperties("",0,Root.Fonts[5],Root.Colors.BlueLight,False);
	YPos += m_fLabelHeight;
	m_LShootPercent=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fXOffSet,YPos,WinWidth - m_fXOffSet,m_fLabelHeight,self));
//	m_LShootPercent.SetProperties("",0,Root.Fonts[5],Root.Colors.BlueLight,False);
	m_RainBowLogo=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',204.00,31.00,m_RRainBowLogo.W,m_RRainBowLogo.H,self));
	m_RainBowLogo.t=m_TRainBowLogo;
	m_RainBowLogo.R=m_RRainBowLogo;
	m_RainBowLogo.m_iDrawStyle=5;
	m_BorderColor=Root.Colors.GrayLight;
	m_OperativeFace=R6MenuCarreerOperative(CreateWindow(Class'R6MenuCarreerOperative',m_iPadding,138.00,WinWidth - 2 * m_iPadding,m_iHeight,self));
	m_LOpName=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fLOpNameX,m_OperativeFace.WinTop,m_fLOpNameW,m_OperativeFace.WinHeight / 3,self));
	m_LOpName.m_bFixedYPos=True;
	m_LOpName.TextY=16.00;
//	m_LOpName.SetProperties("",1,Root.Fonts[6],Root.Colors.White,False);
	m_LOpName.bAlwaysOnTop=True;
	m_LOpSpecility=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_LOpName.WinLeft,m_LOpName.WinTop + m_LOpName.WinHeight,m_LOpName.WinWidth,m_LOpName.WinHeight,self));
//	m_LOpSpecility.SetProperties("",1,Root.Fonts[6],Root.Colors.White,False);
	m_LOpSpecility.bAlwaysOnTop=True;
	m_LOpHealthStatus=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_LOpName.WinLeft,m_LOpSpecility.WinTop + m_LOpSpecility.WinHeight,m_LOpName.WinWidth,m_OperativeFace.WinHeight - m_LOpName.WinHeight - m_LOpSpecility.WinHeight,self));
	m_LOpHealthStatus.m_bFixedYPos=True;
	m_LOpHealthStatus.TextY=2.00;
//	m_LOpHealthStatus.SetProperties("",1,Root.Fonts[6],Root.Colors.White,False);
	m_LOpHealthStatus.bAlwaysOnTop=True;
}

function UpdateStats (string _MissionServed, string _TerroKilled, string _RoundsShot, string _RoundsOnTarget, string _ShootPercent)
{
	m_LMissionServed.SetNewText(Localize("R6Operative","NbMissions","R6Menu") @ _MissionServed,True);
	m_LTerroKilled.SetNewText(Localize("R6Operative","TerroKilled","R6Menu") @ _TerroKilled,True);
	m_LRoundsFired.SetNewText(Localize("R6Operative","RoundsFired","R6Menu") @ _RoundsShot,True);
	m_LRoundsOnTarget.SetNewText(Localize("R6Operative","RoundsOnTarget","R6Menu") @ _RoundsOnTarget,True);
	m_LShootPercent.SetNewText(Localize("R6Operative","ShootPercent","R6Menu") @ _ShootPercent,True);
}

function UpdateFace (Texture _Face, Region _FaceRegion)
{
	m_OperativeFace.setFace(_Face,_FaceRegion);
}

function UpdateTeam (int _Team)
{
	m_OperativeFace.SetTeam(_Team);
}

function UpdateName (string _szOpName)
{
	m_LOpName.SetNewText(_szOpName,True);
}

function UpdateSpeciality (string _szOpSpeciality)
{
	m_LOpSpecility.SetNewText(_szOpSpeciality,True);
}

function UpdateHealthStatus (string _szHealthStatus)
{
	m_LOpHealthStatus.SetNewText(_szHealthStatus,True);
}

function Paint (Canvas C, float X, float Y)
{
	R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,0.00,m_fTitleHeight,WinWidth,WinHeight - m_fTitleHeight);
	DrawSimpleBorder(C);
	DrawStretchedTextureSegment(C,0.00,m_fTitleHeight,WinWidth,m_BorderTextureRegion.H,m_BorderTextureRegion.X,m_BorderTextureRegion.Y,m_BorderTextureRegion.W,m_BorderTextureRegion.H,m_BorderTexture);
}

defaultproperties
{
    m_iPadding=2
    m_iHeight=85
    m_fTitleHeight=16.00
    m_fYOffSet=21.00
    m_fXOffSet=3.00
    m_fLabelHeight=18.00
    m_fLOpNameX=133.00
    m_fLOpNameW=140.00
    m_RRainBowLogo=(X=11280902,Y=570753024,W=66,H=4727300)
}
/*
    m_TRainBowLogo=Texture'R6MenuTextures.Gui_BoxScroll'
*/

