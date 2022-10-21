//================================================================================
// R6MenuOperativeBio.
//================================================================================
class R6MenuOperativeBio extends UWindowWindow;

var bool bShowLog;
var float m_fHSidePadding;
var float m_fTileLabelWidth;
var float m_fTopYPadding;
var float m_fTitleHeight;
var float m_fValueLabelWidth;
var float m_fYPaddingBetweenElements;
var float m_fHealthHeight;
var R6MenuOperativeSkillsLabel m_TDateBirth;
var R6MenuOperativeSkillsLabel m_THeight;
var R6MenuOperativeSkillsLabel m_TWeight;
var R6MenuOperativeSkillsLabel m_THair;
var R6MenuOperativeSkillsLabel m_TEyes;
var R6MenuOperativeSkillsLabel m_TGender;
var R6WindowTextLabel m_TStatus;
var R6MenuOperativeSkillsLabel m_NDateBirth;
var R6MenuOperativeSkillsLabel m_NHeight;
var R6MenuOperativeSkillsLabel m_NWeight;
var R6MenuOperativeSkillsLabel m_NHair;
var R6MenuOperativeSkillsLabel m_NEyes;
var R6MenuOperativeSkillsLabel m_NGender;

function Created ()
{
	local float Y;
	local float X;
	local float TitlesHeight;
	local float ValuesHeight;

	TitlesHeight=m_fTitleHeight + m_fYPaddingBetweenElements;
	ValuesHeight=Class'R6MenuOperativeSkillsLabel'.Default.m_BGTextureRegion.H;
	m_TDateBirth=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,m_fTopYPadding,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TDateBirth.Text=Localize("R6Operative","DateBirth","R6Menu");
	m_TDateBirth.m_BGTexture=None;
	Y=m_TDateBirth.WinTop + TitlesHeight;
	m_THeight=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_THeight.Text=Localize("R6Operative","Height","R6Menu");
	m_THeight.m_BGTexture=None;
	Y=m_THeight.WinTop + TitlesHeight;
	m_TWeight=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TWeight.Text=Localize("R6Operative","Weight","R6Menu");
	m_TWeight.m_BGTexture=None;
	Y=m_TWeight.WinTop + TitlesHeight;
	m_THair=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_THair.Text=Localize("R6Operative","Hair","R6Menu");
	m_THair.m_BGTexture=None;
	Y=m_THair.WinTop + TitlesHeight;
	m_TEyes=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TEyes.Text=Localize("R6Operative","Eyes","R6Menu");
	m_TEyes.m_BGTexture=None;
	Y=m_TEyes.WinTop + TitlesHeight;
	m_TGender=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',m_fHSidePadding,Y,m_fTileLabelWidth,m_fTitleHeight,self));
	m_TGender.Text=Localize("R6Operative","Gender","R6Menu");
	m_TGender.m_BGTexture=None;
	X=WinWidth - m_fValueLabelWidth - m_fHSidePadding;
	Y=m_TDateBirth.WinTop;
	m_NDateBirth=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NDateBirth.align=ta_left;
	Y=m_THeight.WinTop;
	m_NHeight=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NHeight.align=ta_left;
	Y=m_TWeight.WinTop;
	m_NWeight=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NWeight.align=ta_left;
	Y=m_THair.WinTop;
	m_NHair=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NHair.align=ta_left;
	Y=m_TEyes.WinTop;
	m_NEyes=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NEyes.align=ta_left;
	Y=m_TGender.WinTop;
	m_NGender=R6MenuOperativeSkillsLabel(CreateWindow(Class'R6MenuOperativeSkillsLabel',X,Y,m_fValueLabelWidth,ValuesHeight,self));
	m_NGender.align=ta_left;
	m_TStatus=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,WinHeight - m_fHealthHeight,WinWidth,m_fHealthHeight,self));
	m_TStatus.m_bDrawBorders=True;
	m_TStatus.m_BGTexture=None;
	m_TStatus.align=ta_center;
	m_TStatus.m_Font=Root.Fonts[5];
	m_TStatus.m_BorderColor=m_BorderColor;
	m_TStatus.TextColor=Root.Colors.White;
}

function SetBorderColor (Color _NewColor)
{
	m_BorderColor=_NewColor;
	m_TStatus.m_BorderColor=_NewColor;
}

function SetBirthDate (string _szBirthDate)
{
	m_NDateBirth.Text=_szBirthDate;
}

function SetHeight (string _szHeight)
{
	m_NHeight.Text=_szHeight;
}

function SetWeight (string _szWeight)
{
	m_NWeight.Text=_szWeight;
}

function SetHairColor (string _szHair)
{
	m_NHair.Text=_szHair;
}

function SetEyesColor (string _szEyes)
{
	m_NEyes.Text=_szEyes;
}

function SetGender (string _szGender)
{
	m_NGender.Text=_szGender;
}

function SetHealthStatus (string _Health)
{
	m_TStatus.SetNewText(_Health,True);
}

function Paint (Canvas C, float X, float Y)
{
	R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,0.00,0.00,WinWidth,WinHeight);
}

defaultproperties
{
    m_fHSidePadding=5.00
    m_fTileLabelWidth=90.00
    m_fTopYPadding=7.00
    m_fTitleHeight=12.00
    m_fValueLabelWidth=84.00
    m_fYPaddingBetweenElements=3.00
    m_fHealthHeight=20.00
}