//================================================================================
// R6SniperReticule.
//================================================================================
class R6SniperReticule extends R6CrossReticule
	Config(User);

var(Textures) Texture m_FixedPart;

simulated function PostRender (Canvas C)
{
	local float X;
	local float Y;
	local float fScale;

	Super.PostRender(C);
	fScale=C.ClipX / 256;
	X=m_fReticuleOffsetX * 0.25;
	Y=m_fReticuleOffsetY * 0.50 - X;
	C.Style=5;
	C.SetPos(X,Y);
	C.DrawIcon(m_FixedPart,fScale);
}

defaultproperties
{
}
/*
    m_FixedPart=Texture'R6TexturesReticule.SniperReticule'
*/

