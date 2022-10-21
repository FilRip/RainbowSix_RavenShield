//================================================================================
// R6ColorPicker.
//================================================================================
class R6ColorPicker extends UWindowDialogControl;

var int m_iSelectedColorIndex;
var Color m_aColorChoice[5];
const PICKHEIGHT= 20;
const PICKWIDTH= 40;
const NUM_COLOR= 5;

function Paint (Canvas C, float X, float Y)
{
	local int i;

	for (i=0;i < 5;i++)
	{
		C.SetPos(0.00,i * 20);
		C.SetDrawColor(m_aColorChoice[i].R,m_aColorChoice[i].G,m_aColorChoice[i].B);
//		C.DrawRect(Texture'White',40.00,20.00);
	}
	C.SetDrawColor(m_aColorChoice[m_iSelectedColorIndex].R,m_aColorChoice[m_iSelectedColorIndex].G,m_aColorChoice[m_iSelectedColorIndex].B);
	C.SetPos(1.00,m_iSelectedColorIndex * 20 + 1);
//	C.DrawRect(Texture'Black',40.00 - 2,20.00 - 2);
	C.SetPos(4.00,m_iSelectedColorIndex * 20 + 4);
//	C.DrawRect(Texture'White',40.00 - 8,20.00 - 8);
}

function Color GetSelectedColor ()
{
	return m_aColorChoice[m_iSelectedColorIndex];
}

function LMouseDown (float X, float Y)
{
	local int iSelectedColorIndex;

	Super.LMouseDown(X,Y);
	iSelectedColorIndex=Y / 20;
	if ( (iSelectedColorIndex >= 0) && (iSelectedColorIndex < 5) )
	{
		m_iSelectedColorIndex=iSelectedColorIndex;
	}
}

defaultproperties
{
    m_aColorChoice(0)=(R=0,G=255,B=0,A=255)
    m_aColorChoice(1)=(R=255,G=255,B=255,A=255)
    m_aColorChoice(2)=(R=0,G=0,B=255,A=255)
    m_aColorChoice(3)=(R=255,G=0,B=0,A=255)
    m_aColorChoice(4)=(R=0,G=255,B=255,A=255)
    bIgnoreLDoubleClick=True
    bIgnoreMDoubleClick=True
    bIgnoreRDoubleClick=True
}
