//================================================================================
// R6DotReticule.
//================================================================================
class R6DotReticule extends R6Reticule
	Config(User);

var(Textures) Texture m_Dot;

simulated function PostRender (Canvas C)
{
	local int X;
	local int Y;
	local float fScale;

	C.UseVirtualSize(True,640.00,480.00);
	SetReticuleInfo(C);
	X=320;
	Y=240;
	C.Style=5;
	fScale=16.00 / m_Dot.VSize * m_fZoomScale;
	C.SetPos(X - m_Dot.USize * fScale / 2 + 1,Y - m_Dot.VSize * fScale / 2 + 1);
	C.DrawIcon(m_Dot,fScale);
	C.UseVirtualSize(False);
}

defaultproperties
{
}
/*
    m_Dot=Texture'R6TexturesReticule.Dot'
*/

