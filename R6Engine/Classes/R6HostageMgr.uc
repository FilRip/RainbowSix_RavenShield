//================================================================================
// R6HostageMgr.
//================================================================================
class R6HostageMgr extends R6AbstractHostageMgr;

struct ThreatInfo
{
	var int m_id;
	var int m_iThreatLevel;
	var Pawn m_pawn;
	var Actor m_actorExt;
	var int m_bornTime;
	var Vector m_originalLocation;
	var name m_state;
};

enum ENoiseType {
	NOISE_None,
	NOISE_Investigate,
	NOISE_Threat,
	NOISE_Grenade,
	NOISE_Dead
};

enum EThreatType {
	THREAT_none,
	THREAT_friend,
	THREAT_sound,
	THREAT_surrender,
	THREAT_enemy,
	THREAT_underFire,
	THREAT_neutral,
	THREAT_misc
};

struct ThreatDefinition
{
	var name m_groupName;
	var string m_szName;
	var EThreatType m_eThreatType;
	var ENoiseType m_eNoiseType;
	var int m_iThreatLevel;
	var int m_iCaringDistance;
	var name m_considerThreat;
};

enum EHostagePersonality {
	HPERSO_Coward,
	HPERSO_Normal,
	HPERSO_Brave,
	HPERSO_Bait,
	HPERSO_None
};

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

struct AnimTransInfo
{
	var name m_AIState;
	var name m_pawnState;
	var name m_sourceAnimName;
	var int m_iSourceAnim;
	var name m_targetAnimName;
	var int m_iTargetAnim;
	var float m_fTime;
	var float m_fTargetAnimRate;
};

enum EAnimTransType {
	eAnimTrans_none,
	eAnimTrans_animTransInfo,
	eAnimTrans_groupTransition,
	eAnimTrans_manual
};

enum EGroupAnimType {
	eGroupAnim_none,
	eGroupAnim_transition,
	eGroupAnim_wait,
	eGroupAnim_reaction
};

enum EPlayAnimType {
	ePlayType_Default,
	ePlayType_Random
};

struct AnimInfo
{
	var name m_name;
	var int m_id;
	var float m_fRate;
	var EPlayAnimType m_ePlayType;
	var EGroupAnimType m_eGroupAnim;
};

struct HstSndEventInfo
{
	var int m_iHstSndEvent;
	var EHostagePersonality m_ePerso;
	var EHostageVoices m_eVoice;
};

const HSTSNDEvent_Max= 11;
const HSTSNDEvent_InjuredByRainbow= 10;
const HSTSNDEvent_AskedToStayPut= 9;
const HSTSNDEvent_FollowRainbow= 8;
const HSTSNDEvent_GoFoetal= 7;
const HSTSNDEvent_SeeRainbowBaitOrGoFrozen= 6;
const HSTSNDEvent_HstRunTowardRainbow= 5;
const HSTSNDEvent_CivRunTowardRainbow= 4;
const HSTSNDEvent_RunForCover= 3;
const HSTSNDEvent_CivSurrender= 2;
const HSTSNDEvent_HearShooting= 1;
const HSTSNDEvent_None= 0;
struct ReactionInfo
{
	var name m_groupName;
	var int m_iThreatLevel;
	var int m_iChance;
	var name m_gotoState;
};

var const int c_iSurrenderRadius;
var const int c_iDetectUnderFireRadius;
var const int c_iDetectThreatSound;
var const int c_iDetectGrenadeRadius;
var const int c_ThreatLevel_Surrender;
var int ANIM_eBlinded;
var int ANIM_eCrouchToProne;
var int ANIM_eCrouchToScaredStand;
var int ANIM_eCrouchWait01;
var int ANIM_eCrouchWait02;
var int ANIM_eCrouchWalkBack;
var int ANIM_eFoetusToCrouch;
var int ANIM_eFoetusToKneel;
var int ANIM_eFoetusToProne;
var int ANIM_eFoetusToStand;
var int ANIM_eFoetusWait01;
var int ANIM_eFoetusWait02;
var int ANIM_eFoetus_nt;
var int ANIM_eGazed;
var int ANIM_eKneelFreeze;
var int ANIM_eKneelReact01;
var int ANIM_eKneelReact02;
var int ANIM_eKneelReact03;
var int ANIM_eKneelToCrouch;
var int ANIM_eKneelToFoetus;
var int ANIM_eKneelToProne;
var int ANIM_eKneelToStand;
var int ANIM_eKneelWait01;
var int ANIM_eKneelWait02;
var int ANIM_eKneelWait03;
var int ANIM_eKneel_nt;
var int ANIM_eScaredStandWait01;
var int ANIM_eScaredStandWait02;
var int ANIM_eScaredStand_nt;
var int ANIM_eStandHandUpFreeze;
var int ANIM_eStandHandUpReact01;
var int ANIM_eStandHandUpReact02;
var int ANIM_eStandHandUpReact03;
var int ANIM_eStandHandUpToDown;
var int ANIM_eStandHandDownToUp;
var int ANIM_eStandHandUpWait01;
var int ANIM_eStandToFoetus;
var int ANIM_eStandToKneel;
var int ANIM_eStandWaitCough;
var int ANIM_eStandWaitShiftWeight;
var int ANIM_eProneToCrouch;
var int ANIM_eProneWaitBreathe;
var int ANIM_eMAX;
var int m_iThreatDefinitionIndex;
var int m_iReactionIndex;
var int m_iAnimTransIndex;
var bool bShowLog;
var const name c_ThreatGroup_Civ;
var const name c_ThreatGroup_HstFreed;
var const name c_ThreatGroup_HstGuarded;
var const name c_ThreatGroup_HstBait;
var const name c_ThreatGroup_HstEscorted;
var name m_noReactionName;
var HstSndEventInfo m_aHstSndEventInfo[24];
var AnimInfo m_aAnimInfo[40];
var ThreatDefinition m_aThreatDefinition[26];
var ReactionInfo m_aReactions[24];
var AnimTransInfo m_aAnimTransInfo[32];

function logX (string szText, optional int iSource)
{
	local string szSource;
	local string Time;

	Time=string(Level.TimeSeconds);
	Time=Left(Time,InStr(Time,".") + 3);
	szSource="(" $ Time $ ":X) ";
	Log(szSource $ string(Name) $ "" $ szText);
}

function InsertAnimTransInfo (int iSourceAnim, int iTargetAnim, name pawnState, float fTime)
{
	if ( m_iAnimTransIndex >= 32 )
	{
		assert (False);
	}
	m_aAnimTransInfo[m_iAnimTransIndex].m_fTime=fTime;
	m_aAnimTransInfo[m_iAnimTransIndex].m_pawnState=pawnState;
	m_aAnimTransInfo[m_iAnimTransIndex].m_iSourceAnim=iSourceAnim;
	m_aAnimTransInfo[m_iAnimTransIndex].m_sourceAnimName=GetAnimInfo(iSourceAnim).m_name;
	m_aAnimTransInfo[m_iAnimTransIndex].m_iTargetAnim=iTargetAnim;
	m_aAnimTransInfo[m_iAnimTransIndex].m_targetAnimName=GetAnimInfo(iTargetAnim).m_name;
	m_aAnimTransInfo[m_iAnimTransIndex].m_fTargetAnimRate=GetAnimInfo(iTargetAnim).m_fRate;
	m_iAnimTransIndex++;
}

function string GetAnimTransInfoLog (AnimTransInfo Info, optional EAnimTransType eType)
{
	local string szLog;
	local string szType;

	if ( eType == 1 )
	{
		szType="data";
	}
	else
	{
		if ( eType == 2 )
		{
			szType="group";
		}
		else
		{
			if ( eType == 3 )
			{
				szType="manual";
			}
			else
			{
				szType="none";
			}
		}
	}
	szLog="AnimTransType: " $ szType $ " src: " $ string(Info.m_sourceAnimName) $ " target: " $ string(Info.m_targetAnimName) $ " time: " $ string(Info.m_fTime) $ " rate: " $ string(Info.m_fTargetAnimRate) $ " toAIstate: " $ string(Info.m_AIState) $ " toPawnState: " $ string(Info.m_pawnState);
	return szLog;
}

function bool GetAnimTransInfo (name sourceAnimName, int iTargetAnim, out AnimTransInfo Info)
{
	local int i;

	i=0;
JL0007:
	if ( i < m_iAnimTransIndex )
	{
		if ( (sourceAnimName == m_aAnimTransInfo[i].m_sourceAnimName) && (iTargetAnim == m_aAnimTransInfo[i].m_iTargetAnim) )
		{
			Info=m_aAnimTransInfo[i];
			return True;
		}
		i++;
		goto JL0007;
	}
	return False;
}

function AnimInfo GetAnimInfo (int ID)
{
	return m_aAnimInfo[ID];
}

function int GetAnimIndex (name animName)
{
	local int i;

	i=0;
JL0007:
	if ( i < 40 )
	{
		if ( m_aAnimInfo[i].m_name == animName )
		{
			return i;
		}
		i++;
		goto JL0007;
	}
	return 0;
}

function int GetAnimInfoSize ()
{
	return 40;
}

function InsertAnimInfo (name aName, out int ID, optional EGroupAnimType eGroupAnim, optional EPlayAnimType ePlayType, optional float fRate)
{
	ID=ANIM_eMAX;
	ANIM_eMAX++;
	if ( fRate == 0 )
	{
		fRate=1.00;
	}
	if ( m_aAnimInfo[ID].m_name != 'None' )
	{
		Log("ScriptWarning: Hostage anim " @ string(aName) @ " was not inserted. Conflict with " @ string(m_aAnimInfo[ID].m_name) @ " at index " $ string(ID));
		return;
	}
	m_aAnimInfo[ID].m_id=ID;
	m_aAnimInfo[ID].m_name=aName;
	m_aAnimInfo[ID].m_fRate=fRate;
	m_aAnimInfo[ID].m_ePlayType=ePlayType;
	m_aAnimInfo[ID].m_eGroupAnim=eGroupAnim;
}

function ValidAnimInfo ()
{
	local int i;
	local int j;
	local string playType;

	if ( 40 != ANIM_eMAX )
	{
		Log("ScriptWarning: m_aAnimInfo wrong size. Array size is " @ string(40) @ " and ANIM_eMAX is " $ string(ANIM_eMAX));
	}
	i=0;
JL0071:
	if ( i < 40 )
	{
		if ( m_aAnimInfo[i].m_name == 'None' )
		{
			Log("ScriptWarning: missing anim index: " $ string(i));
		}
		else
		{
			if ( m_aAnimInfo[i].m_ePlayType == 1 )
			{
				playType="random";
			}
			else
			{
				playType="default";
			}
		}
		i++;
		goto JL0071;
	}
	i=0;
JL0116:
	if ( i < 40 )
	{
		if ( m_aAnimInfo[i].m_name == 'None' )
		{
			goto JL01FF;
		}
		j=0;
JL0146:
		if ( j < 40 )
		{
			if ( i == j )
			{
				goto JL01F5;
			}
			if ( m_aAnimInfo[i].m_name == m_aAnimInfo[j].m_name )
			{
				if ( m_aAnimInfo[i].m_fRate == m_aAnimInfo[j].m_fRate )
				{
					Log("ScriptWarning: identical anim at index: " @ string(i) @ " and " $ string(j));
				}
			}
JL01F5:
			j++;
			goto JL0146;
		}
JL01FF:
		i++;
		goto JL0116;
	}
}

function PostBeginPlay ()
{
	m_noReactionName='HostageMgrNone';
	InitSndEventInfo();
	InitThreatDefinition();
	InitReaction();
	InsertAnimInfo('Blinded',ANIM_eBlinded);
/*	InsertAnimInfo('CrouchToProne',ANIM_eCrouchToProne,1);
	InsertAnimInfo('CrouchToScaredStand',ANIM_eCrouchToScaredStand,1);
	InsertAnimInfo('CrouchWait01',ANIM_eCrouchWait01,2,1);
	InsertAnimInfo('CrouchWait02',ANIM_eCrouchWait02,2);
	InsertAnimInfo('FoetusToCrouch',ANIM_eFoetusToCrouch,1);
	InsertAnimInfo('FoetusToKneel',ANIM_eFoetusToKneel,1);
	InsertAnimInfo('FoetusToProne',ANIM_eFoetusToProne,1);
	InsertAnimInfo('FoetusToStand',ANIM_eFoetusToStand,1);
	InsertAnimInfo('FoetusWait01',ANIM_eFoetusWait01,2,1);
	InsertAnimInfo('FoetusWait02',ANIM_eFoetusWait02,2,1);
	InsertAnimInfo('Foetus_nt',ANIM_eFoetus_nt);
	InsertAnimInfo('Gazed',ANIM_eGazed);
	InsertAnimInfo('KneelFreeze',ANIM_eKneelFreeze,,1);
	InsertAnimInfo('KneelReact01',ANIM_eKneelReact01,3,1);
	InsertAnimInfo('KneelReact02',ANIM_eKneelReact02,3,1);
	InsertAnimInfo('KneelReact03',ANIM_eKneelReact03,3,1);
	InsertAnimInfo('KneelToCrouch',ANIM_eKneelToCrouch,1);
	InsertAnimInfo('KneelToFoetus',ANIM_eKneelToFoetus,1);
	InsertAnimInfo('KneelToProne',ANIM_eKneelToProne,1);
	InsertAnimInfo('KneelToStand',ANIM_eKneelToStand,1);
	InsertAnimInfo('KneelWait01',ANIM_eKneelWait01,2,1);
	InsertAnimInfo('KneelWait02',ANIM_eKneelWait02,2,1);
	InsertAnimInfo('KneelWait03',ANIM_eKneelWait03,2,1);
	InsertAnimInfo('Kneel_nt',ANIM_eKneel_nt);
	InsertAnimInfo('ScaredStandWait01',ANIM_eScaredStandWait01,2,1);
	InsertAnimInfo('ScaredStandWait02',ANIM_eScaredStandWait02,2,1);
	InsertAnimInfo('StandHandUpFreeze',ANIM_eStandHandUpFreeze,,1);
	InsertAnimInfo('StandHandUpReact01',ANIM_eStandHandUpReact01,3,1);
	InsertAnimInfo('StandHandUpReact02',ANIM_eStandHandUpReact02,3,1);
	InsertAnimInfo('StandHandUpReact03',ANIM_eStandHandUpReact03,3,1);
	InsertAnimInfo('StandHandUpToDown',ANIM_eStandHandUpToDown,1);
	InsertAnimInfo('StandHandDownToUp',ANIM_eStandHandDownToUp,1);
	InsertAnimInfo('StandHandUpWait01',ANIM_eStandHandUpWait01,2,1);
	InsertAnimInfo('StandToFoetus',ANIM_eStandToFoetus,1);
	InsertAnimInfo('StandToKneel',ANIM_eStandToKneel,1);
	InsertAnimInfo('StandWaitCough',ANIM_eStandWaitCough,2);
	InsertAnimInfo('StandWaitShiftWeight',ANIM_eStandWaitShiftWeight,2,1);
	InsertAnimInfo('ProneToCrouch',ANIM_eProneToCrouch,1);
	InsertAnimInfo('ProneWaitBreathe',ANIM_eProneWaitBreathe,2); */
	ValidAnimInfo();
}

function InsertThreatDefinition (name GroupName, string szName, EThreatType EThreatType, ENoiseType ENoiseType, int iThreatLevel, int iCaringDistance, optional name considerThreat)
{
	assert (m_iThreatDefinitionIndex < 26);
	if ( m_iThreatDefinitionIndex > 1 )
	{
		if ( (m_aThreatDefinition[m_iThreatDefinitionIndex - 1].m_iThreatLevel < iThreatLevel) && (m_aThreatDefinition[m_iThreatDefinitionIndex - 1].m_groupName == GroupName) )
		{
			Log("ScriptWarning: InsertThreatDefinition wrong ThreatLevel for " $ szName);
		}
	}
	m_aThreatDefinition[m_iThreatDefinitionIndex].m_groupName=GroupName;
	m_aThreatDefinition[m_iThreatDefinitionIndex].m_szName=szName;
	m_aThreatDefinition[m_iThreatDefinitionIndex].m_eThreatType=EThreatType;
	m_aThreatDefinition[m_iThreatDefinitionIndex].m_eNoiseType=ENoiseType;
	m_aThreatDefinition[m_iThreatDefinitionIndex].m_iThreatLevel=iThreatLevel;
	m_aThreatDefinition[m_iThreatDefinitionIndex].m_iCaringDistance=iCaringDistance;
	m_aThreatDefinition[m_iThreatDefinitionIndex].m_considerThreat=considerThreat;
	m_iThreatDefinitionIndex++;
}

function string GetThreatInfoLog (ThreatInfo Info)
{
	local string szOutput;
	local name pawnName;
	local name ActorName;
	local int Index;

	Index=Clamp(Info.m_id,0,Info.m_id);
	if ( Info.m_pawn == None )
	{
		pawnName=' ';
	}
	else
	{
		pawnName=Info.m_pawn.Name;
	}
	if ( Info.m_actorExt == None )
	{
		ActorName=' ';
	}
	else
	{
		ActorName=Info.m_actorExt.Name;
	}
	szOutput="" $ string(m_aThreatDefinition[Index].m_groupName) $ ": " $ GetThreatName(Index) $ ", a:" $ string(ActorName) $ " " $ string(Info.m_iThreatLevel) $ "s:" $ string(Info.m_state) $ " a2:" $ string(ActorName);
	return szOutput;
}

function GetThreatDefinition (int Index, out ThreatDefinition oDefinition)
{
	oDefinition=m_aThreatDefinition[Index];
}

function ThreatInfo getDefaulThreatInfo ()
{
	local ThreatInfo Info;

	Info.m_bornTime=0;
	Info.m_id=0;
	Info.m_originalLocation=vect(0.00,0.00,0.00);
	Info.m_pawn=None;
	Info.m_iThreatLevel=0;
	Info.m_state='None';
	return Info;
}

function string GetThreatName (int Index)
{
	return m_aThreatDefinition[Index].m_szName;
}

function bool GetThreatInfoFromThreat (name threatGroupName, R6Hostage hostage, Actor threat, ENoiseType eType, out ThreatInfo oThreatInfo)
{
	local bool bRealThreat;
	local int i;
	local Vector vDistance;
	local name threatClass;
	local bool bCheckDistance;
	local R6Pawn aPawn;

	bRealThreat=False;
	if ( eType != 0 )
	{
		aPawn=R6Pawn(threat.Instigator);
	}
	else
	{
		aPawn=R6Pawn(threat);
	}
	i=1;
JL004B:
	if ( i < 26 )
	{
		bCheckDistance=False;
		if ( m_aThreatDefinition[i].m_groupName != threatGroupName )
		{
			goto JL028D;
		}
		else
		{
			if ( eType != 0 )
			{
				if ( m_aThreatDefinition[i].m_eNoiseType == eType )
				{
					bCheckDistance=True;
				}
			}
			else
			{
				if ( aPawn != None )
				{
					if ( m_aThreatDefinition[i].m_eThreatType == 4 )
					{
						if ( hostage.IsEnemy(aPawn) && aPawn.IsAlive() &&  !aPawn.m_bIsKneeling )
						{
							bCheckDistance=True;
						}
					}
					else
					{
						if ( m_aThreatDefinition[i].m_eThreatType == 1 )
						{
							if ( hostage.IsFriend(aPawn) && aPawn.IsAlive() )
							{
								bCheckDistance=True;
							}
						}
						else
						{
							if ( m_aThreatDefinition[i].m_eThreatType == 6 )
							{
								if ( hostage.IsNeutral(aPawn) && aPawn.IsAlive() )
								{
									bCheckDistance=True;
								}
							}
						}
					}
				}
			}
		}
		if ( bCheckDistance )
		{
			if ( (m_aThreatDefinition[i].m_iCaringDistance == 2147483647) || (VSize(hostage.Location - threat.Location) <= m_aThreatDefinition[i].m_iCaringDistance) )
			{
				if ( m_aThreatDefinition[i].m_considerThreat != 'None' )
				{
					if ( hostage.m_controller.CanConsiderThreat(aPawn,threat,m_aThreatDefinition[i].m_considerThreat) )
					{
						bRealThreat=True;
					}
					else
					{
						goto JL028D;
						bRealThreat=True;
						goto JL0297;
JL028D:
						++i;
						goto JL004B;
					}
				}
			}
		}
	}
JL0297:
	if ( bRealThreat )
	{
		oThreatInfo.m_id=i;
		oThreatInfo.m_bornTime=Level.TimeSeconds;
		oThreatInfo.m_originalLocation=threat.Location;
		oThreatInfo.m_iThreatLevel=m_aThreatDefinition[i].m_iThreatLevel;
		if ( eType != 0 )
		{
			oThreatInfo.m_pawn=aPawn;
			if ( m_aThreatDefinition[i].m_eNoiseType == 3 )
			{
				oThreatInfo.m_actorExt=threat;
			}
		}
		else
		{
			oThreatInfo.m_pawn=aPawn;
		}
	}
	else
	{
		oThreatInfo.m_id=0;
	}
	return bRealThreat;
}

function GetThreatInfoFromThreatSurrender (Pawn threat, out ThreatInfo oThreatInfo)
{
	oThreatInfo.m_id=-1;
	oThreatInfo.m_bornTime=Level.TimeSeconds;
	oThreatInfo.m_originalLocation=threat.Location;
	oThreatInfo.m_iThreatLevel=c_ThreatLevel_Surrender;
	oThreatInfo.m_pawn=threat;
	oThreatInfo.m_actorExt=None;
	oThreatInfo.m_state='None';
}

function InsertReaction (name GroupName, int iLevel, int iRoll, name stateName)
{
	assert (m_iReactionIndex < 24);
	m_aReactions[m_iReactionIndex].m_groupName=GroupName;
	m_aReactions[m_iReactionIndex].m_iThreatLevel=iLevel;
	m_aReactions[m_iReactionIndex].m_iChance=iRoll;
	m_aReactions[m_iReactionIndex].m_gotoState=stateName;
	m_iReactionIndex++;
}

function InitThreatDefinition ()
{
	local string szName;
	local EThreatType EThreatType;
	local name GroupName;
	local int i;
	local int iNoiseType;
	local int iCaringDistance;
	local int iThreatLevel;

/*	InsertThreatDefinition(c_ThreatGroup_Civ,"no threat",0,0,0,0);
	InsertThreatDefinition(c_ThreatGroup_Civ,"2m of enemy",4,0,6,c_iSurrenderRadius);
	InsertThreatDefinition(c_ThreatGroup_Civ,"surrender",3,0,c_ThreatLevel_Surrender,0);
	InsertThreatDefinition(c_ThreatGroup_Civ,"near grenade",5,3,4,c_iDetectGrenadeRadius);
	InsertThreatDefinition(c_ThreatGroup_Civ,"under fire",5,2,4,c_iDetectUnderFireRadius);
	InsertThreatDefinition(c_ThreatGroup_Civ,"see enemy",4,0,3,2147483647);
	InsertThreatDefinition(c_ThreatGroup_Civ,"see friend",1,0,2,2147483647);
	InsertThreatDefinition(c_ThreatGroup_Civ,"hear sound",2,2,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_Civ,"hear sound",2,3,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstEscorted,"hear sound",2,2,1,2147483647,'IsEnemySound');
	InsertThreatDefinition(c_ThreatGroup_HstEscorted,"hear sound",2,3,1,2147483647,'IsEnemySound');
	InsertThreatDefinition(c_ThreatGroup_HstEscorted,"hear sound",2,4,1,2147483647,'IsEnemySound');
	InsertThreatDefinition(c_ThreatGroup_HstFreed,"near grenade",5,3,4,c_iDetectGrenadeRadius);
	InsertThreatDefinition(c_ThreatGroup_HstFreed,"see enemy",4,0,3,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstFreed,"see friend",1,0,2,2147483647,'CanSeeFriend');
	InsertThreatDefinition(c_ThreatGroup_HstFreed,"hear sound",2,2,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstFreed,"hear sound",2,3,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstFreed,"hear sound",2,4,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstGuarded,"near grenade",5,3,3,c_iDetectGrenadeRadius);
	InsertThreatDefinition(c_ThreatGroup_HstGuarded,"see friend",1,0,2,2147483647,'CanSeeFriend');
	InsertThreatDefinition(c_ThreatGroup_HstGuarded,"hear sound",2,4,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstGuarded,"hear sound",2,2,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstBait,"near grenade",5,3,2,c_iDetectGrenadeRadius);
	InsertThreatDefinition(c_ThreatGroup_HstBait,"see friend",1,0,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstBait,"hear sound",2,2,1,2147483647);
	InsertThreatDefinition(c_ThreatGroup_HstBait,"hear sound",2,4,1,2147483647);
	assert (m_aThreatDefinition[0].m_iThreatLevel == 0);
	assert (m_iThreatDefinitionIndex == 26);  */
}

function InitReaction ()
{
	local R6Hostage hostageDbg;
	local R6HostageAI hostageAIDbg;
	local int i;

	InsertReaction(c_ThreatGroup_Civ,1,33,'CivRunForCover');
	InsertReaction(c_ThreatGroup_Civ,1,66,'GoCivScareToDeath');
	InsertReaction(c_ThreatGroup_Civ,1,100,m_noReactionName);
	InsertReaction(c_ThreatGroup_Civ,2,25,'CivRunForCover');
	InsertReaction(c_ThreatGroup_Civ,2,50,'GoCivScareToDeath');
	InsertReaction(c_ThreatGroup_Civ,2,100,'CivRunTowardRainbow');
	InsertReaction(c_ThreatGroup_Civ,3,50,'GoCivScareToDeath');
	InsertReaction(c_ThreatGroup_Civ,3,100,'CivRunForCover');
	InsertReaction(c_ThreatGroup_Civ,4,100,'CivRunForCover');
	InsertReaction(c_ThreatGroup_Civ,c_ThreatLevel_Surrender,50,'CivSurrender');
	InsertReaction(c_ThreatGroup_Civ,c_ThreatLevel_Surrender,100,'CivRunForCover');
	InsertReaction(c_ThreatGroup_Civ,6,100,'CivSurrender');
	InsertReaction(c_ThreatGroup_HstGuarded,1,100,'GuardedPlayReaction');
	InsertReaction(c_ThreatGroup_HstGuarded,2,40,'GoGuarded_Foetus');
	InsertReaction(c_ThreatGroup_HstGuarded,2,60,'GoGuarded_frozen');
	InsertReaction(c_ThreatGroup_HstGuarded,2,100,'GoHstRunTowardRainbow');
	InsertReaction(c_ThreatGroup_HstGuarded,3,100,'GoHstRunForCover');
	InsertReaction(c_ThreatGroup_HstEscorted,1,100,'HearShootingReaction');
	InsertReaction(c_ThreatGroup_HstFreed,1,100,'GoHstRunForCover');
	InsertReaction(c_ThreatGroup_HstFreed,2,100,'GoHstRunTowardRainbow');
	InsertReaction(c_ThreatGroup_HstFreed,3,100,'GoHstFreedButSeeEnemy');
	InsertReaction(c_ThreatGroup_HstFreed,4,100,'GoHstRunForCover');
	InsertReaction(c_ThreatGroup_HstBait,1,100,'BaitPlayReaction');
	InsertReaction(c_ThreatGroup_HstBait,2,100,'GoHstRunForCover');
	assert (m_iReactionIndex == 24);
}

function name GetReaction (name GroupName, int iLevel, int iRoll)
{
	local int i;
	local bool bFound;
	local name stateName;

	bFound=False;
	i=0;
JL000F:
	if ( i < 24 )
	{
		if ( m_aReactions[i].m_groupName == GroupName )
		{
			if ( m_aReactions[i].m_iThreatLevel == iLevel )
			{
				if ( iRoll <= m_aReactions[i].m_iChance )
				{
					bFound=True;
				}
				else
				{
					goto JL0094;
					if ( m_aReactions[i].m_iThreatLevel > iLevel )
					{
						goto JL009E;
					}
JL0094:
					i++;
					goto JL000F;
				}
			}
		}
	}
JL009E:
	if ( bFound )
	{
		stateName=m_aReactions[i].m_gotoState;
	}
	else
	{
		stateName=m_noReactionName;
	}
	return stateName;
}

function ValidMgr (R6HostageAI AI)
{
}

function EHostageVoices GetHostageVoices (int Index)
{
	return m_aHstSndEventInfo[Index].m_eVoice;
}

function int GetHostageSndEvent (int iSndEvent, R6Hostage H)
{
	local EHostagePersonality ePerso;
	local int i;
	local bool bFound;

//	ePerso=H.m_ePersonality;
	if ( ePerso == 3 )
	{
//		ePerso=0;
	}
	i=0;
JL0033:
	if ( i < 24 )
	{
		if ( m_aHstSndEventInfo[i].m_iHstSndEvent == iSndEvent )
		{
			bFound=True;
		}
		else
		{
			i++;
			goto JL0033;
		}
	}
	if (  !bFound )
	{
		return 0;
	}
	return i;
}

function InsertSndEventInfo (int Index, int iSndEvent, EHostagePersonality ePerso, EHostageVoices eVoice)
{
	local name A;

	m_aHstSndEventInfo[Index].m_iHstSndEvent=iSndEvent;
	m_aHstSndEventInfo[Index].m_ePerso=ePerso;
	m_aHstSndEventInfo[Index].m_eVoice=eVoice;
}

function InitSndEventInfo ()
{
	local int Index;

	InsertSndEventInfo(Index++ ,1,HPERSO_None,HV_Hears_Shooting);
	InsertSndEventInfo(Index++ ,6,HPERSO_None,HV_Frozen);
	InsertSndEventInfo(Index++ ,5,HPERSO_None,HV_Run);
	InsertSndEventInfo(Index++ ,7,HPERSO_None,HV_Foetal);
	InsertSndEventInfo(Index++ ,8,HPERSO_None,HV_RnbFollow);
	InsertSndEventInfo(Index++ ,9,HPERSO_None,HV_RndStayPut);
	InsertSndEventInfo(Index++ ,10,HPERSO_Brave,HV_RnbHurt);
}

defaultproperties
{
    c_iSurrenderRadius=200
    c_iDetectUnderFireRadius=500
    c_iDetectThreatSound=1000
    c_iDetectGrenadeRadius=1000
    c_ThreatLevel_Surrender=5
    c_ThreatGroup_Civ=Civ
    c_ThreatGroup_HstFreed=Freed
    c_ThreatGroup_HstGuarded=Guarded
    c_ThreatGroup_HstBait=Bait
    c_ThreatGroup_HstEscorted=Escorted
    RemoteRole=ROLE_None
    bHidden=True
}
