//================================================================================
// R6AbstractPawn.
//================================================================================
class R6AbstractPawn extends Pawn
	Native
	Abstract;
//	NoNativeReplication;

var(Debug) bool bShowLog;
enum ESkills {
	SKILL_Assault,
	SKILL_Demolitions,
	SKILL_Electronics,
	SKILL_Sniper,
	SKILL_Stealth,
	SKILL_SelfControl,
	SKILL_Leadership,
	SKILL_Observation
};


replication
{
	unreliable if ( Role == Role_Authority )
		ClientGetWeapon;
}

event float GetSkill (ESkills eSkillName);

function GetWeapon (R6AbstractWeapon NewWeapon)
{
	if ( bShowLog )
	{
		Log("ak: GetWeapon " $ string(NewWeapon));
	}
}

function ClientGetWeapon (R6EngineWeapon NewWeapon)
{
	if ( (Level.NetMode == NM_Standalone) || (Level.NetMode == NM_ListenServer) )
	{
		return;
	}
	if ( bShowLog )
	{
		Log("IN: ClientGetWeapon() " $ string(NewWeapon));
	}
	GetWeapon(R6AbstractWeapon(NewWeapon));
	if ( bShowLog )
	{
		Log("OUT: ClientGetWeapon() " $ string(NewWeapon));
	}
}
