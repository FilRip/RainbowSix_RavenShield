//================================================================================
// R6CircleDotLineReticule.
//================================================================================
class R6CircleDotLineReticule extends R6CircleDotReticule
	Config(User);

simulated function PostRender (Canvas C)
{
	Super.PostRender(C);
	C.Style=5;
	C.SetPos(m_fReticuleOffsetX - 1.00,m_fReticuleOffsetY + 1.00);
	C.DrawRect(m_LineTexture,c_iLineWidth * m_fZoomScale,c_iLineHeight * m_fZoomScale);
}