//================================================================================
// R6CircleDotReticule.
//================================================================================
class R6CircleDotReticule extends R6CircleReticule
	Config(User);

var(Textures) Texture m_Dot;

simulated function PostRender (Canvas C)
{
	local float fScale;

	Super.PostRender(C);
	C.Style=5;
	fScale=16.00 / m_Dot.VSize * m_fZoomScale;
	C.SetPos(m_fReticuleOffsetX - m_Dot.USize * fScale * 0.50,m_fReticuleOffsetY - m_Dot.VSize * fScale * 0.50);
	C.DrawIcon(m_Dot,fScale);
}

defaultproperties
{
}
/*
    m_Dot=Texture'R6TexturesReticule.Dot'
*/

