//================================================================================
// R6WindowHSplitter.
//================================================================================
class R6WindowHSplitter extends UWindowLabelControl;

enum ESplitterType {
	ST_TopWin,
	ST_SplitterTop,
	ST_SplitterBottom
};

var ESplitterType m_eSplitterType;

function BeforePaint (Canvas C, float X, float Y)
{
	local float W;
	local float H;

	C.Font=Root.Fonts[Font];
	TextSize(C,Text,W,H);
	TextY=(WinHeight - H) / 2;
	switch (Align)
	{
		case TA_Left:
		break;
		case TA_Center:
		TextX=(WinWidth - W) / 2;
		break;
		case TA_Right:
		TextX=WinWidth - W;
		break;
		default:
	}
}

function Paint (Canvas C, float X, float Y)
{
	switch (m_eSplitterType)
	{
		case ST_TopWin:
		R6WindowLookAndFeel(LookAndFeel).DrawWinTop(self,C);
		break;
		case ST_SplitterTop:
		R6WindowLookAndFeel(LookAndFeel).DrawHSplitterT(self,C);
		break;
		case ST_SplitterBottom:
		R6WindowLookAndFeel(LookAndFeel).DrawHSplitterB(self,C);
		default:
	}
	Super.Paint(C,X,Y);
}
