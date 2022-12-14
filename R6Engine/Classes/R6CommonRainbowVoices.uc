//================================================================================
// R6CommonRainbowVoices.
//================================================================================
class R6CommonRainbowVoices extends R6Voices;

enum ECommonRainbowVoices {
	CRV_TerroristDown,
	CRV_TakeWound,
	CRV_GoesDown,
	CRV_EntersSmoke,
	CRV_EntersGas
};

enum ESoundSlot {
	SLOT_None,
	SLOT_Ambient,
	SLOT_Guns,
	SLOT_SFX,
	SLOT_GrenadeEffect,
	SLOT_Music,
	SLOT_Talk,
	SLOT_Speak,
	SLOT_HeadSet,
	SLOT_Menu,
	SLOT_Instruction,
	SLOT_StartingSound
};

var Sound m_sndTerroristDown;
var Sound m_sndTakeWound;
var Sound m_sndGoesDown;
var Sound m_sndEntersSmoke;
var Sound m_sndEntersGas;

function PlayCommonRainbowVoices (R6Pawn aPawn, ECommonRainbowVoices eRainbowVoices)
{
	switch (eRainbowVoices)
	{
		case CRV_TerroristDown:
		aPawn.PlayVoices(m_sndTerroristDown,SLOT_HeadSet,10,SSTATUS_SendToMPTeam);
		break;
		case CRV_TakeWound:
		aPawn.PlayVoices(m_sndTakeWound,SLOT_Talk,5,SSTATUS_SendToAll);
		break;
		case CRV_GoesDown:
		aPawn.PlayVoices(m_sndGoesDown,SLOT_Talk,5,SSTATUS_SendToAll);
		break;
		case CRV_EntersSmoke:
		break;
		case CRV_EntersGas:
		aPawn.PlayVoices(m_sndEntersGas,SLOT_Talk,5,SSTATUS_SendToAll);
		break;
		default:
	}
}
