//================================================================================
// R6WindowServerInfoPlayerBox.
//================================================================================
class R6WindowServerInfoPlayerBox extends R6WindowListBox;

var bool m_bDrawBorderAndBkg;
var Font m_Font;
var Color TextColor;
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
	local R6WindowListInfoPlayerItem pListInfoPlayerItem;

	pListInfoPlayerItem=R6WindowListInfoPlayerItem(Item);
	C.Style=5;
	C.Font=m_Font;
	TextSize(C,"TEST",tW,tH);
	TextY=(H - tH) / 2;
	TextY=TextY + 0.50;
	X += pListInfoPlayerItem.fNameXOff;
	C.SetPos(X,Y + TextY);
	ClipTextWidth(C,X,Y + TextY,pListInfoPlayerItem.szPlName,pListInfoPlayerItem.fNameWidth);
	X += pListInfoPlayerItem.fSkillsXOff;
	C.SetPos(X,Y + TextY);
	C.DrawText(string(pListInfoPlayerItem.iSkills));
	X += pListInfoPlayerItem.fTimeXOff;
	C.SetPos(X,Y + TextY);
	C.DrawText(pListInfoPlayerItem.szTime);
	X += pListInfoPlayerItem.fPingXOff;
	C.SetPos(X,Y + TextY);
	C.DrawText(string(pListInfoPlayerItem.iPing));
}

defaultproperties
{
    m_SelTextColor=(R=255,G=255,B=255,A=0)
    m_fItemHeight=16.00
    ListClass=Class'R6WindowListInfoPlayerItem'
}