//================================================================================
// R6MenuSimpleWindow.
//================================================================================
class R6MenuSimpleWindow extends UWindowWindow;

var bool m_bDrawSimpleBorder;
var UWindowWindow pAdviceParent;

function Paint (Canvas C, float X, float Y)
{
	if ( m_bDrawSimpleBorder )
	{
		DrawSimpleBorder(C);
	}
}

function MouseWheelDown (float X, float Y)
{
	if ( pAdviceParent != None )
	{
		pAdviceParent.MouseWheelDown(X,Y);
	}
}

function MouseWheelUp (float X, float Y)
{
	if ( pAdviceParent != None )
	{
		pAdviceParent.MouseWheelUp(X,Y);
	}
}

defaultproperties
{
    m_bDrawSimpleBorder=True
}