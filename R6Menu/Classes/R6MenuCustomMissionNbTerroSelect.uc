//================================================================================
// R6MenuCustomMissionNbTerroSelect.
//================================================================================
class R6MenuCustomMissionNbTerroSelect extends UWindowDialogClientWindow
	Config(User);

var const int c_iNbTerroMax;
var const int c_iNbTerroMin;
var config int CustomMissionNbTerro;
var float m_fLabelHeight;
var R6WindowTextLabel m_TitleNbTerro;
var R6WindowCounter m_TerroCounter;

function Created ()
{
	m_TitleNbTerro=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,m_fLabelHeight,self));
	m_TitleNbTerro.Text=Localize("CustomMission","NbTerro","R6Menu");
	m_TitleNbTerro.Align=TA_Center;
	m_TitleNbTerro.m_Font=Root.Fonts[8];
	m_TitleNbTerro.TextColor=Root.Colors.White;
	m_TitleNbTerro.m_bDrawBorders=False;
	m_TerroCounter=R6WindowCounter(CreateWindow(Class'R6WindowCounter',0.00,m_TitleNbTerro.WinTop + m_TitleNbTerro.WinHeight + 9,WinWidth,15.00,self));
	m_TerroCounter.bAlwaysBehind=True;
	m_TerroCounter.ToolTipString=Localize("Tip","Custom_NbTerro","R6Menu");
//	m_TerroCounter.m_iButtonID=0;
	m_TerroCounter.SetAdviceParent(False);
	m_TerroCounter.CreateButtons(m_TerroCounter.WinWidth / 2 - 30,0.00,60.00);
	m_TerroCounter.SetDefaultValues(c_iNbTerroMin,c_iNbTerroMax,CustomMissionNbTerro);
	m_TerroCounter.SetButtonToolTip(Localize("Tip","Custom_NbTerro","R6Menu"),Localize("Tip","Custom_NbTerro","R6Menu"));
}

function int GetNbTerro ()
{
	if ( m_TerroCounter.m_iCounter != CustomMissionNbTerro )
	{
		CustomMissionNbTerro=m_TerroCounter.m_iCounter;
		SaveConfig();
	}
	return m_TerroCounter.m_iCounter;
}

function Paint (Canvas C, float X, float Y)
{
/*	C.Style=4;
	DrawStretchedTextureSegment(C,m_TitleNbTerro.WinLeft,m_TitleNbTerro.WinTop,m_TitleNbTerro.WinWidth,m_TitleNbTerro.WinHeight,77.00,0.00,4.00,29.00,Texture'Gui_BoxScroll');
	C.Style=5;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTexture(C,0.00,m_TitleNbTerro.WinTop + m_TitleNbTerro.WinHeight,WinWidth,1.00,Texture'WhiteTexture');*/
}

defaultproperties
{
    c_iNbTerroMax=35
    c_iNbTerroMin=5
    CustomMissionNbTerro=20
    m_fLabelHeight=29.00
}
