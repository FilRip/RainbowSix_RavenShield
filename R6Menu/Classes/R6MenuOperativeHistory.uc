//================================================================================
// R6MenuOperativeHistory.
//================================================================================
class R6MenuOperativeHistory extends UWindowWindow;

var R6WindowWrappedTextArea m_OperativeText;
var R6WindowTextLabel m_Title;

function Created ()
{
	m_Title=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,WinWidth,17.00,self));
	m_Title.Text=Localize("GearRoom","History","R6Menu");
	m_Title.align=ta_center;
	m_Title.m_Font=Root.Fonts[6];
	m_Title.m_BGTexture=None;
	m_Title.m_bDrawBorders=False;
	m_OperativeText=R6WindowWrappedTextArea(CreateWindow(Class'R6WindowWrappedTextArea',0.00,m_Title.WinTop + m_Title.WinHeight,WinWidth,WinHeight - m_Title.WinHeight,self));
	m_OperativeText.m_HBorderTexture=None;
	m_OperativeText.m_VBorderTexture=None;
	m_OperativeText.m_fHBorderHeight=0.00;
	m_OperativeText.m_fVBorderWidth=0.00;
	m_OperativeText.SetScrollable(True);
	m_OperativeText.VertSB.SetEffect(True);
}

function SetBorderColor (Color _NewColor)
{
	m_BorderColor=_NewColor;
	m_Title.m_BorderColor=_NewColor;
	m_OperativeText.SetBorderColor(_NewColor);
}

function Paint (Canvas C, float X, float Y)
{
	R6WindowLookAndFeel(LookAndFeel).DrawBGShading(self,C,m_OperativeText.WinLeft,m_OperativeText.WinTop,m_OperativeText.WinWidth,m_OperativeText.WinHeight);
	C.Style=5;
	C.SetDrawColor(m_BorderColor.R,m_BorderColor.G,m_BorderColor.B);
	DrawStretchedTexture(C,0.00,m_OperativeText.WinTop,WinWidth,1.00,Texture'WhiteTexture');
}

function SetText (Canvas C, string NewText)
{
	m_OperativeText.Clear();
	m_OperativeText.AddTextWithCanvas(C,5.00,5.00,NewText,Root.Fonts[6],Root.Colors.White);
}