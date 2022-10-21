//================================================================================
// R6WindowBitMap.
//================================================================================
class R6WindowBitMap extends UWindowBitmap;

var bool m_bUseColor;
var bool m_bDrawBorder;
var Color m_TextureColor;

function Paint (Canvas C, float X, float Y)
{
	if ( m_bUseColor )
	{
		C.SetDrawColor(m_TextureColor.R,m_TextureColor.G,m_TextureColor.B);
	}
	Super.Paint(C,X,Y);
	if ( m_bDrawBorder )
	{
		DrawSimpleBorder(C);
	}
}