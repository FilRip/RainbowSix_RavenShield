//================================================================================
// R6GlowLight.
//================================================================================
class R6GlowLight extends Light
	Native;

var(R6Glow) bool m_bFadeWithDistance;
var(R6Glow) bool m_bInverseScale;
var(R6Glow) float m_fAngle;
var(R6Glow) float m_fFadeValue;
var(R6Glow) float m_fDistanceValue;
var Actor m_pOwnerNightVision;

defaultproperties
{
    m_fAngle=90.00
    m_fFadeValue=3.00
    m_fDistanceValue=1000.00
    LightType=0
    bStatic=False
    bCorona=True
    bDirectional=True
}