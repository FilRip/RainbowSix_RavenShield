//================================================================================
// R6PlayAnim.
//================================================================================
class R6PlayAnim extends Object
	Native
//	Export
	EditInLineNew;

var() int m_MaxPlayTime;
var int m_PlayedTime;
var int m_iFrameNumber;
var() bool m_bLoopAnim;
var bool m_bStarted;
var bool m_bFirstTime;
var() float m_Rate;
var() float m_TweenTime;
var float m_fBeginPct;
var float m_fEndPct;
var(R6Attach) Actor m_AttachActor;
var() name m_Sequence;
var(R6Attach) name m_PawnTag;
var(R6Attach) string m_StaticMeshTag;

event AnimFinished ();

defaultproperties
{
    m_MaxPlayTime=1
    m_bLoopAnim=True
    m_bFirstTime=True
    m_Rate=1.00
}
