//================================================================================
// R6RifleReticule.
//================================================================================
class R6RifleReticule extends R6CrossReticule
	Config(User);

var(temp) float m_fBaseReticuleHeight;
var(Textures) Texture m_FixedPart;

simulated function PostRender (Canvas C)
{
	local float X;
	local float Y;
	local float fScale;

	Super.PostRender(C);
	fScale=32.00 / m_FixedPart.VSize * m_fZoomScale;
	X=m_fReticuleOffsetX - m_FixedPart.USize / 2 * fScale;
	Y=m_fReticuleOffsetY;
	C.Style=5;
	C.SetPos(X,Y + 2);
	C.DrawIcon(m_FixedPart,fScale);
}

defaultproperties
{
    m_fBaseReticuleHeight=5.00
}
/*
    m_FixedPart=Texture'R6TexturesReticule.Rifle_Gun'
*/

