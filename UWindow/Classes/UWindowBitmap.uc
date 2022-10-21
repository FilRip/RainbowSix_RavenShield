//================================================================================
// UWindowBitmap.
//================================================================================
class UWindowBitmap extends UWindowDialogControl;

var int m_iDrawStyle;
var bool bStretch;
var bool bCenter;
var bool m_bHorizontalFlip;
var bool m_bVerticalFlip;
var float m_ImageX;
var float m_ImageY;
var Texture t;
var Region R;

function Paint (Canvas C, float X, float Y)
{
	local int XAdjust;
	local int YAdjust;
	local int RegW;
	local int RegH;

	if ( t == None )
	{
		return;
	}
	C.Style=m_iDrawStyle;
	RegW=R.W;
	RegH=R.H;
	if ( m_bHorizontalFlip )
	{
		XAdjust=R.W;
		RegW= -R.W;
	}
	if ( m_bVerticalFlip )
	{
		YAdjust=R.H;
		RegH= -R.H;
	}
	if ( bStretch )
	{
		DrawStretchedTextureSegment(C,m_ImageX,m_ImageY,WinWidth,WinHeight,R.X + XAdjust,R.Y + YAdjust,RegW,RegH,t);
	}
	else
	{
		if ( bCenter )
		{
			DrawStretchedTextureSegment(C,(WinWidth - R.W) / 2,(WinHeight - R.H) / 2,R.W,R.H,R.X + XAdjust,R.Y + YAdjust,RegW,RegH,t);
		}
		else
		{
			DrawStretchedTextureSegment(C,m_ImageX,m_ImageY,R.W,R.H,R.X + XAdjust,R.Y + YAdjust,RegW,RegH,t);
		}
	}
}

defaultproperties
{
    m_iDrawStyle=1
}