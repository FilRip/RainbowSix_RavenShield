//================================================================================
// R6MenuOperativeDetailControl.
//================================================================================
class R6MenuOperativeDetailControl extends UWindowDialogClientWindow;

var int m_ITopLineYPos;
var int m_IBottomLineYPos;
var bool m_bUpdateOperativeText;
var R6MenuOperativeDetailRadioArea m_TopButtons;
var R6MenuOperativeHistory m_HistoryPage;
var R6MenuOperativeSkills m_SkillsPage;
var R6MenuOperativeBio m_BioPage;
var R6MenuOperativeStats m_StatsPage;
var R6WindowBitMap m_OperativeFace;
var UWindowWindow m_CurrentPage;

function Created ()
{
	local float fYOffset;
	local float fHeight;

	m_BorderColor=Root.Colors.GrayLight;
	m_TopButtons=R6MenuOperativeDetailRadioArea(CreateWindow(Class'R6MenuOperativeDetailRadioArea',0.00,0.00,WinWidth,23.00,self));
	m_TopButtons.m_BorderColor=m_BorderColor;
	fYOffset=m_TopButtons.WinTop + m_TopButtons.WinHeight;
	m_OperativeFace=R6WindowBitMap(CreateWindow(Class'R6WindowBitMap',0.00,fYOffset,WinWidth,81.00,self));
	m_OperativeFace.m_BorderColor=m_BorderColor;
	m_OperativeFace.m_bDrawBorder=False;
	m_OperativeFace.bCenter=True;
	fYOffset=m_OperativeFace.WinTop + m_OperativeFace.WinHeight;
	fHeight=WinHeight - m_TopButtons.WinHeight + m_OperativeFace.WinHeight;
	m_HistoryPage=R6MenuOperativeHistory(CreateWindow(Class'R6MenuOperativeHistory',0.00,fYOffset,WinWidth,fHeight,self));
	m_HistoryPage.SetBorderColor(m_BorderColor);
	m_HistoryPage.HideWindow();
	m_SkillsPage=R6MenuOperativeSkills(CreateWindow(Class'R6MenuOperativeSkills',0.00,fYOffset,WinWidth,fHeight,self));
	m_SkillsPage.m_BorderColor=m_BorderColor;
	m_SkillsPage.HideWindow();
	m_BioPage=R6MenuOperativeBio(CreateWindow(Class'R6MenuOperativeBio',0.00,fYOffset,WinWidth,fHeight,self));
	m_BioPage.SetBorderColor(m_BorderColor);
	m_BioPage.HideWindow();
	m_StatsPage=R6MenuOperativeStats(CreateWindow(Class'R6MenuOperativeStats',0.00,fYOffset,WinWidth,fHeight,self));
	m_StatsPage.m_BorderColor=m_BorderColor;
	m_StatsPage.HideWindow();
	m_CurrentPage=m_SkillsPage;
	m_CurrentPage.ShowWindow();
	m_ITopLineYPos=m_TopButtons.WinTop + m_TopButtons.WinHeight;
	m_IBottomLineYPos=m_OperativeFace.WinTop + m_OperativeFace.WinHeight - 1;
}

function UpdateDetails ()
{
	local R6Operative currentOperative;
	local Region RMenuFace;

	currentOperative=R6MenuGearWidget(OwnerWindow).m_currentOperative;
	RMenuFace.X=currentOperative.m_RMenuFaceX;
	RMenuFace.Y=currentOperative.m_RMenuFaceY;
	RMenuFace.W=currentOperative.m_RMenuFaceW;
	RMenuFace.H=currentOperative.m_RMenuFaceH;
	setFace(currentOperative.m_TMenuFace,RMenuFace);
	m_bUpdateOperativeText=True;
	m_SkillsPage.m_fAssault=currentOperative.m_fAssault;
	m_SkillsPage.m_fDemolitions=currentOperative.m_fDemolitions;
	m_SkillsPage.m_fElectronics=currentOperative.m_fElectronics;
	m_SkillsPage.m_fSniper=currentOperative.m_fSniper;
	m_SkillsPage.m_fStealth=currentOperative.m_fStealth;
	m_SkillsPage.m_fSelfControl=currentOperative.m_fSelfControl;
	m_SkillsPage.m_fLeadership=currentOperative.m_fLeadership;
	m_SkillsPage.m_fObservation=currentOperative.m_fObservation;
	m_SkillsPage.ResizeCharts(currentOperative);
	m_BioPage.SetBirthDate(currentOperative.GetBirthDate());
	m_BioPage.SetHeight(currentOperative.GetHeight());
	m_BioPage.SetWeight(currentOperative.GetWeight());
	m_BioPage.SetHairColor(currentOperative.GetHairColor());
	m_BioPage.SetEyesColor(currentOperative.GetEyesColor());
	m_BioPage.SetGender(currentOperative.GetGender());
	m_BioPage.SetHealthStatus(currentOperative.GetHealthStatus());
	m_StatsPage.SetNbMissions(currentOperative.GetNbMissionPlayed());
	m_StatsPage.SeTTerroKilled(currentOperative.GetNbTerrokilled());
	m_StatsPage.SetRoundsFired(currentOperative.GetNbRoundsfired());
	m_StatsPage.SetRoundsOnTarget(currentOperative.GetNbRoundsOnTarget());
	m_StatsPage.SetShootPercent(currentOperative.GetShootPercent());
}

function ChangePage (int ButtonID)
{
	m_CurrentPage.HideWindow();
	switch (ButtonID)
	{
		case 1:
		m_CurrentPage=m_HistoryPage;
		break;
		case 2:
		m_CurrentPage=m_SkillsPage;
		break;
		case 3:
		m_CurrentPage=m_BioPage;
		break;
		case 4:
		m_CurrentPage=m_StatsPage;
		break;
		default:
	}
	m_CurrentPage.ShowWindow();
}

function Paint (Canvas C, float X, float Y)
{
	local R6Operative currentOperative;

	currentOperative=R6MenuGearWidget(OwnerWindow).m_currentOperative;
	if ( m_bUpdateOperativeText )
	{
		m_HistoryPage.SetText(C,currentOperative.GetHistory());
		m_bUpdateOperativeText=False;
	}
}

function AfterPaint (Canvas C, float X, float Y)
{
	DrawSimpleBorder(C);
	C.Style=5;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTexture(C,0.00,m_ITopLineYPos,WinWidth,1.00,Texture'WhiteTexture');
	DrawStretchedTexture(C,0.00,m_IBottomLineYPos,WinWidth,1.00,Texture'WhiteTexture');
}

function setFace (Texture newFace, Region _R)
{
	m_OperativeFace.t=newFace;
	m_OperativeFace.R=_R;
}