//================================================================================
// R6MenuCampaignDescription.
//================================================================================
class R6MenuCampaignDescription extends UWindowWindow;

var int m_DrawStyle;
var float m_HPadding;
var float m_VPadding;
var float m_VSpaceBetweenElements;
var float m_LabelHeight;
var R6WindowTextLabel m_MissionTitle;
var R6WindowTextLabel m_NameTitle;
var R6WindowTextLabel m_DifficultyTitle;
var R6WindowTextLabel m_MissionValue;
var R6WindowTextLabel m_NameValue;
var R6WindowTextLabel m_DifficultyValue;
var Texture m_BGTexture;
var Region m_BGTextureRegion;
var Color m_vBGColor;

function Created ()
{
	local float labelWidth;
	local float RightLabelX;
	local float DifficultyWidth;
	local float NameWidth;

	labelWidth=WinWidth / 2 - m_HPadding;
	RightLabelX=WinWidth - labelWidth - m_HPadding;
	DifficultyWidth=135.00;
	NameWidth=75.00;
	m_MissionTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_HPadding,m_VPadding,labelWidth,m_LabelHeight,self));
	m_MissionTitle.m_bDrawBorders=False;
	m_MissionTitle.align=ta_left;
	m_MissionTitle.TextColor=Root.Colors.White;
	m_MissionTitle.m_Font=Root.Fonts[5];
	m_MissionTitle.Text=Localize("SinglePlayer","Mission","R6Menu");
	m_MissionTitle.m_BGTexture=None;
	m_NameTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_HPadding,m_MissionTitle.WinTop + m_MissionTitle.WinHeight + m_VSpaceBetweenElements,NameWidth,m_LabelHeight,self));
	m_NameTitle.m_bDrawBorders=False;
	m_NameTitle.align=ta_left;
	m_NameTitle.TextColor=Root.Colors.White;
	m_NameTitle.m_Font=Root.Fonts[5];
	m_NameTitle.Text=Localize("SinglePlayer","Name","R6Menu");
	m_NameTitle.m_BGTexture=None;
	m_DifficultyTitle=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_HPadding,m_NameTitle.WinTop + m_NameTitle.WinHeight + m_VSpaceBetweenElements,DifficultyWidth,m_LabelHeight,self));
	m_DifficultyTitle.m_bDrawBorders=False;
	m_DifficultyTitle.align=ta_left;
	m_DifficultyTitle.TextColor=Root.Colors.White;
	m_DifficultyTitle.m_Font=Root.Fonts[5];
	m_DifficultyTitle.Text=Localize("SinglePlayer","Difficulty","R6Menu");
	m_DifficultyTitle.m_BGTexture=None;
	m_MissionValue=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',RightLabelX,m_VPadding,labelWidth,m_LabelHeight,self));
	m_MissionValue.m_bDrawBorders=False;
	m_MissionValue.align=ta_right;
	m_MissionValue.TextColor=Root.Colors.White;
	m_MissionValue.m_Font=Root.Fonts[5];
	m_MissionValue.m_BGTexture=None;
	m_NameValue=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_NameTitle.WinLeft + m_NameTitle.WinWidth,m_MissionTitle.WinTop + m_MissionTitle.WinHeight + m_VSpaceBetweenElements,labelWidth * 2 - m_NameTitle.WinWidth,m_LabelHeight,self));
	m_NameValue.m_bDrawBorders=False;
	m_NameValue.align=ta_right;
	m_NameValue.TextColor=Root.Colors.White;
	m_NameValue.m_Font=Root.Fonts[5];
	m_NameValue.m_BGTexture=None;
	m_DifficultyValue=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_DifficultyTitle.WinLeft + m_DifficultyTitle.WinWidth,m_NameTitle.WinTop + m_NameTitle.WinHeight + m_VSpaceBetweenElements,labelWidth * 2 - m_DifficultyTitle.WinWidth,m_LabelHeight,self));
	m_DifficultyValue.m_bDrawBorders=False;
	m_DifficultyValue.align=ta_right;
	m_DifficultyValue.TextColor=Root.Colors.White;
	m_DifficultyValue.m_Font=Root.Fonts[5];
	m_DifficultyValue.m_BGTexture=None;
	m_vBGColor=Root.Colors.Black;
}

defaultproperties
{
    m_DrawStyle=5
    m_HPadding=12.00
    m_VPadding=18.00
    m_VSpaceBetweenElements=25.00
    m_LabelHeight=12.00
    m_BGTextureRegion=(X=6365702,Y=570687488,W=33,H=1516035)
}
/*
    m_BGTexture=Texture'R6MenuTextures.Gui_BoxScroll'
*/

