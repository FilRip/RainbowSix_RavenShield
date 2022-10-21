//================================================================================
// R6InteractiveObjectAction.
//================================================================================
class R6InteractiveObjectAction extends Object
	Abstract
//	Export
	EditInLineNew;

enum EActionType {
	ET_Goto,
	ET_PlayAnim,
	ET_LookAt,
	ET_LoopAnim,
	ET_LoopRandomAnim,
	ET_ToggleDevice
};

var EActionType m_eType;
var(Sound) Sound m_eSoundToPlay;
var(Sound) Sound m_eSoundToPlayStop;
var(Sound) Range m_SoundRange;

defaultproperties
{
    m_SoundRange=(Min=0.00,Max=2.513396198084515E35)
}
