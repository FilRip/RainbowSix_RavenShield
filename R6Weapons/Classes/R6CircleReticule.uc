//================================================================================
// R6CircleReticule.
//================================================================================
class R6CircleReticule extends R6CrossReticule
	Config(User);

var(temp) float m_fBaseReticuleHeight;
var(Textures) Texture m_Circle;

simulated function PostRender (Canvas C)
{
	local float X;
	local float Y;
	local float fScale;

	Super.PostRender(C);
	fScale=64.00 / m_Circle.VSize * m_fZoomScale;
	X=m_fReticuleOffsetX - m_Circle.USize * 0.50 * fScale;
	Y=m_fReticuleOffsetY - m_Circle.VSize * 0.50 * fScale;
	C.Style=5;
	C.SetPos(X,Y);
	C.DrawIcon(m_Circle,fScale);
}

defaultproperties
{
    m_fBaseReticuleHeight=5.00
}
/*
    m_Circle=Texture'R6TexturesReticule.Small_Cercle'
*/

