//================================================================================
// R6WindowTextListRadio.
//================================================================================
class R6WindowTextListRadio extends R6WindowListRadio;

var Color m_SelTextColor;

function Paint (Canvas C, float fMouseX, float fMouseY)
{
	R6WindowLookAndFeel(LookAndFeel).List_DrawBackground(self,C);
	Paint(C,fMouseX,fMouseY);
}

function DrawItem (Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	local float fWidth;
	local float fHeight;
	local float fTextX;
	local float fTextY;
	local UWindowListBoxItem pListBoxItem;

	pListBoxItem=UWindowListBoxItem(Item);
	if ( pListBoxItem.bSelected )
	{
		C.SetDrawColor(m_SelTextColor.R,m_SelTextColor.G,m_SelTextColor.B);
	}
	else
	{
		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);
	}
	C.Font=Root.Fonts[0];
	if ( pListBoxItem.HelpText != "" )
	{
		TextSize(C,pListBoxItem.HelpText,W,H);
		fTextY=(m_fItemHeight - H) / 2;
		switch (Align)
		{
			case TA_Left:
			fTextX=2.00;
			break;
			case TA_Right:
			fTextX=WinWidth - W;
			break;
			case TA_Center:
			fTextX=(WinWidth - W) / 2;
			break;
			default:
		}
		ClipText(C,X + fTextX,Y + fTextY,pListBoxItem.HelpText);
	}
	C.SetDrawColor(255,255,255);
}

defaultproperties
{
    m_SelTextColor=(R=255,G=255,B=255,A=0)
    m_fItemHeight=16.00
    ListClass=Class'UWindow.UWindowListBoxItem'
    Align=2
}
