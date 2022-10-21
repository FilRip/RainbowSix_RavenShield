//================================================================================
// R6WindowTeamPlanningSummary.
//================================================================================
class R6WindowTeamPlanningSummary extends UWindowWindow;

var byte m_BTopAlpha;
var byte m_BBottomAlpha;
var float m_fTopBGHeight;
var float m_fLabelXOffset;
var float m_fVlabelWidth;
var R6WindowTextLabel m_Team;
var R6WindowTextLabel m_GoCode;
var R6WindowTextLabel m_Waypoint;
var R6WindowTextLabel m_GoCodeVal;
var R6WindowTextLabel m_WayPointVal;
var Texture m_TTopBG;
var Region m_RTopBG;
var Color m_CDarkTeamColor;

function Created ()
{
	local float labelWidth;
	local float RightLabelXPos;
	local float fLabelHeight;

	labelWidth=WinWidth - 2 * m_fLabelXOffset - m_fVlabelWidth;
	RightLabelXPos=WinWidth - m_fVlabelWidth;
	fLabelHeight=(WinHeight - m_fTopBGHeight) / 2;
	m_Team=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,m_fTopBGHeight,self));
	m_Team.m_bDrawBorders=False;
	m_Team.Align=TA_Center;
	m_Team.TextColor=Root.Colors.White;
	m_Team.m_Font=Root.Fonts[15];
	m_Team.m_BGTexture=None;
	m_Team.m_bFixedYPos=True;
	m_Team.TextY=2.00;
	m_GoCode=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fLabelXOffset,m_fTopBGHeight,labelWidth,fLabelHeight,self));
	m_GoCode.m_bDrawBorders=False;
	m_GoCode.Align=TA_Left;
	m_GoCode.TextColor=Root.Colors.White;
	m_GoCode.m_Font=Root.Fonts[5];
	m_GoCode.m_BGTexture=None;
	m_GoCode.Text=Localize("ExecuteMenu","GOCODE","R6Menu");
	m_GoCode.m_fLMarge=2.00;
	m_Waypoint=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_fLabelXOffset,m_GoCode.WinTop + m_GoCode.WinHeight,labelWidth,fLabelHeight,self));
	m_Waypoint.m_bDrawBorders=False;
	m_Waypoint.Align=TA_Left;
	m_Waypoint.TextColor=Root.Colors.White;
	m_Waypoint.m_Font=Root.Fonts[5];
	m_Waypoint.m_BGTexture=None;
	m_Waypoint.Text=Localize("ExecuteMenu","WAYPOINT","R6Menu");
	m_Waypoint.m_fLMarge=m_GoCode.m_fLMarge;
	m_GoCodeVal=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',RightLabelXPos,m_GoCode.WinTop,m_fVlabelWidth,fLabelHeight,self));
	m_GoCodeVal.m_bDrawBorders=False;
	m_GoCodeVal.Align=TA_Center;
	m_GoCodeVal.TextColor=Root.Colors.White;
	m_GoCodeVal.m_Font=Root.Fonts[5];
	m_GoCodeVal.m_BGTexture=None;
	m_WayPointVal=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',RightLabelXPos,m_Waypoint.WinTop,m_fVlabelWidth,fLabelHeight,self));
	m_WayPointVal.m_bDrawBorders=False;
	m_WayPointVal.Align=TA_Center;
	m_WayPointVal.TextColor=Root.Colors.White;
	m_WayPointVal.m_Font=Root.Fonts[5];
	m_WayPointVal.m_BGTexture=None;
}

function SetTeamColor (Color _c, Color _DarkColor)
{
	m_Team.TextColor=_c;
	m_GoCode.TextColor=_c;
	m_Waypoint.TextColor=_c;
	m_GoCodeVal.TextColor=_c;
	m_WayPointVal.TextColor=_c;
	m_BorderColor=_c;
	m_CDarkTeamColor=_DarkColor;
}

function SetPlanningValues (string szWayPoint, string szGoCode)
{
	m_WayPointVal.SetNewText(szWayPoint,True);
	m_GoCodeVal.SetNewText(szGoCode,True);
}

function SetTeamName (string szTeamName)
{
	m_Team.SetNewText(szTeamName,True);
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=5;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B,m_BTopAlpha);
	DrawStretchedTexture(C,0.00,0.00,WinWidth,m_fTopBGHeight,m_TTopBG);
	C.SetDrawColor(m_CDarkTeamColor.R,m_CDarkTeamColor.G,m_CDarkTeamColor.B,m_BBottomAlpha);
	DrawStretchedTexture(C,0.00,m_fTopBGHeight,WinWidth,WinHeight - m_fTopBGHeight,m_TTopBG);
	C.Style=1;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B,m_BorderColor.A);
	DrawStretchedTexture(C,0.00,m_fTopBGHeight,WinWidth,1.00,m_TTopBG);
	DrawSimpleBorder(C);
}

defaultproperties
{
    m_BTopAlpha=51
    m_BBottomAlpha=128
    m_fTopBGHeight=18.00
    m_fLabelXOffset=2.00
    m_fVlabelWidth=35.00
    m_RTopBG=(X=664073,Y=570949632,W=10,H=0)
}
/*
    m_TTopBG=Texture'UWindow.WhiteTexture'
*/

