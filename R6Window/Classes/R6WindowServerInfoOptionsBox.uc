//================================================================================
// R6WindowServerInfoOptionsBox.
//================================================================================
class R6WindowServerInfoOptionsBox extends R6WindowListBox;

var bool m_bDrawBorderAndBkg;
var Font m_Font;
var Color m_SelTextColor;

function Created ()
{
	Super.Created();
	m_VertSB.SetHideWhenDisable(False);
	TextColor=Root.Colors.m_LisBoxNormalTextColor;
	m_SelTextColor=Root.Colors.m_LisBoxSelectedTextColor;
}

function BeforePaint (Canvas C, float fMouseX, float fMouseY)
{
	local float tW;
	local float tH;

	C.Font=m_Font;
	TextSize(C,"TEST",tW,tH);
	m_fItemHeight=tH + 2;
	m_VertSB.SetBorderColor(m_BorderColor);
	Super.BeforePaint(C,fMouseX,fMouseY);
}

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	if ( m_bDrawBorderAndBkg )
	{
		R6WindowLookAndFeel(LookAndFeel).R6List_DrawBackground(self,C);
	}
	Super.Paint(C,fMouseX,fMouseY);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local float TextY;
	local float tW;
	local float tH;
	local string szText;
	local R6WindowListInfoOptionsItem pListInfoOptItem;

	pListInfoOptItem=R6WindowListInfoOptionsItem(Item);
	C.Style=5;
	C.Font=m_Font;
	szText=TextSize(C,pListInfoOptItem.szOptions,tW,tH,W - pListInfoOptItem.fOptionsXOff);
	TextY=(H - tH) / 2;
	TextY=TextY + 0.50;
	X += pListInfoOptItem.fOptionsXOff;
	C.SetPos(X,Y + TextY);
	C.DrawText(szText);
}

defaultproperties
{
    m_SelTextColor=(R=255,G=255,B=255,A=0)
    m_fItemHeight=16.00
    ListClass=Class'R6WindowListInfoOptionsItem'
}