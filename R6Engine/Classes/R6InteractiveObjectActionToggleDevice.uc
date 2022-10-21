//================================================================================
// R6InteractiveObjectActionToggleDevice.
//================================================================================
class R6InteractiveObjectActionToggleDevice extends R6InteractiveObjectAction;

var(ToggleDevice) R6IODevice m_iodevice;
var(ToggleDevice) editinlineuse array<R6IOBomb> m_aIOBombs;

defaultproperties
{
    m_eType=5
}