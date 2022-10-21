//================================================================================
// R6IActionObject.
//================================================================================
class R6IActionObject extends R6InteractiveObject
	Native
	Abstract;

var float m_fMinMouseMove;
var float m_fMaxMouseMove;
var Actor m_ActionInstigator;

function bool startAction (float deltaMouse, Actor actionInstigator);

function bool updateAction (float deltaMouse, Actor actionInstigator);

function endAction ();

defaultproperties
{
    m_fMinMouseMove=1.00
    m_fMaxMouseMove=250.00
    m_bBlockCoronas=True
    Physics=5
    m_bHandleRelativeProjectors=True
    bSkipActorPropertyReplication=False
}