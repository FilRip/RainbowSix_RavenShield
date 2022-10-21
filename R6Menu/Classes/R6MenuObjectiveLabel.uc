//================================================================================
// R6MenuObjectiveLabel.
//================================================================================
class R6MenuObjectiveLabel extends UWindowWindow;

var bool m_bObjectiveCompleted;
var float m_fYPaddingBetweenElements;
var R6WindowTextLabel m_Objective;
var R6WindowTextLabel m_ObjectiveFailed;
var Texture m_TCheckBoxBorder;
var Texture m_TCheckBoxMark;
var Region m_RCheckBoxBorder;
var Region m_RCheckBoxMark;

function Created ()
{
	m_Objective=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',m_RCheckBoxBorder.W + m_fYPaddingBetweenElements,0.00,WinWidth - m_RCheckBoxBorder.W - m_fYPaddingBetweenElements,WinHeight,self));
//	m_Objective.SetProperties("",0,Root.Fonts[0],Root.Colors.White,False);
	m_Objective.m_bResizeToText=True;
	m_ObjectiveFailed=R6WindowTextLabel(CreateWindow(Class'R6WindowTextLabel',0.00,0.00,10.00,WinHeight,self));
//	m_ObjectiveFailed.SetProperties("",0,Root.Fonts[0],Root.Colors.Red,False);
}

function SetProperties (string _Objective, bool _completed, optional string _szFailed)
{
	m_Objective.m_bResizeToText=True;
	m_Objective.SetNewText(_Objective,True);
	m_bObjectiveCompleted=_completed;
	m_ObjectiveFailed.WinLeft=m_Objective.WinLeft + m_Objective.WinWidth;
	m_ObjectiveFailed.m_bResizeToText=True;
	m_ObjectiveFailed.SetNewText(_szFailed,True);
}

function SetNewLabelWindowSizes (float _X, float _Y, float _W, float _H)
{
	m_Objective.WinWidth=_W;
}

function Paint (Canvas C, float X, float Y)
{
	C.Style=5;
	if ( m_bObjectiveCompleted )
	{
		DrawStretchedTextureSegment(C,2.00,2.00,m_RCheckBoxMark.W,m_RCheckBoxMark.H,m_RCheckBoxMark.X,m_RCheckBoxMark.Y,m_RCheckBoxMark.W,m_RCheckBoxMark.H,m_TCheckBoxMark);
	}
	DrawStretchedTextureSegment(C,0.00,0.00,m_RCheckBoxBorder.W,m_RCheckBoxBorder.H,m_RCheckBoxBorder.X,m_RCheckBoxBorder.Y,m_RCheckBoxBorder.W,m_RCheckBoxBorder.H,m_TCheckBoxBorder);
}

defaultproperties
{
    m_fYPaddingBetweenElements=2.00
    m_RCheckBoxBorder=(X=795142,Y=570753024,W=40,H=926212)
    m_RCheckBoxMark=(X=3416581,Y=570687488,W=10,H=664067)
}
/*
    m_TCheckBoxBorder=Texture'R6MenuTextures.Gui_BoxScroll'
    m_TCheckBoxMark=Texture'R6MenuTextures.Gui_BoxScroll'
*/

