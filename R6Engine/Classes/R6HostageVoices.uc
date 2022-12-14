//================================================================================
// R6HostageVoices.
//================================================================================
class R6HostageVoices extends R6Voices;

enum EHostageVoices {
	HV_Run,
	HV_Frozen,
	HV_Foetal,
	HV_Hears_Shooting,
	HV_RnbFollow,
	HV_RndStayPut,
	HV_RnbHurt,
	HV_EntersSmoke,
	HV_EntersGas,
	HV_ClarkReprimand
};

var Sound m_sndRun;
var Sound m_sndFrozen;
var Sound m_sndFoetal;
var Sound m_sndHears_Shooting;
var Sound m_sndRnbFollow;
var Sound m_sndRndStayPut;
var Sound m_sndRnbHurt;
var Sound m_sndEntersGas;
var Sound m_sndEntersSmoke;
var Sound m_sndClarkReprimand;

function Init (Actor aActor)
{
	Super.Init(aActor);
	aActor.AddSoundBankName("Voices_Clark_Common");
}

function PlayHostageVoices (R6Pawn aPawn, EHostageVoices EHostageVoices)
{
	if ( aPawn != None )
	{
		switch (EHostageVoices)
		{
			case HV_Run:
			aPawn.PlayVoices(m_sndRun,SLOT_Talk,15);
			break;
			case HV_Frozen:
			aPawn.PlayVoices(m_sndFrozen,SLOT_Talk,15);
			break;
			case HV_Foetal:
			aPawn.PlayVoices(m_sndFoetal,SLOT_Talk,15);
			break;
			case HV_Hears_Shooting:
			aPawn.PlayVoices(m_sndHears_Shooting,SLOT_Talk,15);
			break;
			case HV_RnbFollow:
			aPawn.PlayVoices(m_sndRnbFollow,SLOT_Talk,15);
			break;
			case HV_RndStayPut:
			aPawn.PlayVoices(m_sndRndStayPut,SLOT_Talk,15);
			break;
			case HV_RnbHurt:
			aPawn.PlayVoices(m_sndRnbHurt,SLOT_Talk,15);
			break;
			case HV_EntersGas:
			aPawn.PlayVoices(m_sndEntersGas,SLOT_Talk,15,SSTATUS_SendToAll);
			break;
			case HV_EntersSmoke:
			break;
			case HV_ClarkReprimand:
			aPawn.PlayVoices(m_sndClarkReprimand,SLOT_HeadSet,15);
			break;
			default:
		}
	}
}

defaultproperties
{
    m_sndClarkReprimand=Sound'Voices_Clark_Common.Play_Hostage_Reprimand'
}
