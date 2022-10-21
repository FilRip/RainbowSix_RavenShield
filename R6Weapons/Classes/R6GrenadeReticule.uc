//================================================================================
// R6GrenadeReticule.
//================================================================================
class R6GrenadeReticule extends R6Reticule
	Config(User);

var(Textures) Texture m_Circle;
var(Textures) Texture m_Dot;

simulated function PostRender (Canvas C)
{
	local int X;
	local int Y;
	local float fScale;

	C.UseVirtualSize(True,640.00,480.00);
	SetReticuleInfo(C);
	X=C.HalfClipX;
	Y=C.HalfClipY;
	C.Style=5;
	fScale=64.00 / m_Circle.VSize * m_fZoomScale;
	C.SetPos(X - m_Circle.USize * fScale / 2 + 1,Y - m_Circle.VSize * fScale / 2 + 1);
	C.DrawIcon(m_Circle,fScale);
	fScale=16.00 / m_Dot.VSize * m_fZoomScale;
	C.SetPos(X - m_Dot.USize * fScale / 2 + 1,Y - m_Dot.VSize * fScale / 2 + 1);
	C.DrawIcon(m_Dot,fScale);
}

defaultproperties
{
}
/*
    m_Circle=Texture'R6TexturesReticule.Small_Cercle'
    m_Dot=Texture'R6TexturesReticule.Dot'
*/

