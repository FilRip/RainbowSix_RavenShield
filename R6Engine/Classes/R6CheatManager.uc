//================================================================================
// R6CheatManager.
//================================================================================
class R6CheatManager extends CheatManager within PlayerController;

struct CommandInfo
{
	var name m_functionName;
	var string m_szDescription;
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

enum eMovementPace {
	PACE_None,
	PACE_Prone,
	PACE_CrouchWalk,
	PACE_CrouchRun,
	PACE_Walk,
	PACE_Run
};

enum EStartingPosition {
	POS_Stand,
	POS_Kneel,
	POS_Prone,
	POS_Foetus,
	POS_Crouch,
	POS_Random
};

const c_iNavPointIndex= 10;
var int m_iHostageTestAnimIndex;
var int m_iGameInfoLevel;
var int m_iCounterLog;
var int m_iCounterLogMax;
var int m_iCurNavPoint;
var int m_iCommandInfoIndex;
var bool m_bRenderGunDirection;
var bool m_bRenderViewDirection;
var bool m_bRenderBoneCorpse;
var bool m_bRenderFOV;
var bool m_bRenderRoute;
var bool m_bRenderNavPoint;
var bool m_bToggleHostageLog;
var bool m_bToggleHostageThreat;
var bool m_bHostageTestAnim;
var bool m_bToggleTerroLog;
var bool m_bRendSpot;
var bool m_bRendPawnState;
var bool m_bRendFocus;
var bool m_bToggleRainbowLog;
var bool m_bPlayerInvisble;
var bool m_bHideAll;
var bool m_bTogglePeek;
var bool m_bTogglePGDebug;
var bool m_bToggleThreatInfo;
var bool m_bToggleGameInfo;
var bool m_bToggleMissionLog;
var bool m_bFirstPersonPlayerView;
var bool m_bTeamGodMode;
var bool m_bSkipTick;
var bool m_bNumberLog;
var bool m_bEnableNavDebug;
var float m_fNavPointDistance;
var R6Pawn m_curPawn;
var R6Hostage m_Hostage;
var array<Vector> m_aNavPointLocation;
var CommandInfo m_aCommandInfo[128];

exec function help ()
{
	local int i;
	local string sz;
	local int iSize;
	local string szDot;

	if ( m_iCommandInfoIndex == 0 )
	{
		AddCommandInfo(' ',"-- on/off function ------");
		AddCommandInfo('BoneCorpse',"diplay bone of Ragdoll");
		AddCommandInfo('GunDirection',"diplay GunDirection of all pawn");
		AddCommandInfo('HideAll',"hide all interface (HUD, weapon, reticule)");
		AddCommandInfo('Route',"diplay RouteCache of all controller");
		AddCommandInfo('NavPoint',"diplay NavPoint");
		AddCommandInfo('RouteAll',"diplay all path nodes (float max distance to player)");
		AddCommandInfo('toggleNav',"toggle the Navigation Point Debug System");
		AddCommandInfo('ToggleRadius',"diplay collision cylinder");
		AddCommandInfo('ShowFOV',"diplay field of view of all pawn");
		AddCommandInfo('dbgPeek',"debug peek system");
		AddCommandInfo('RendPawnState',"display current sate of pawn");
		AddCommandInfo('RendFocus',"toggle display of focus and focal point");
		AddCommandInfo('God',"make you invincible");
		AddCommandInfo('GodAll',"it call godTeam and GodHostage");
		AddCommandInfo('GodTeam',"make you and your team invisible");
		AddCommandInfo('GodHostage',"make all hostage invisible");
		AddCommandInfo('GodTerro',"make all terro invisible");
		AddCommandInfo('ToggleUnlimitedPractice',"mission objectives are updated but the game never ends");
		AddCommandInfo(' ',"----server-------------------");
		AddCommandInfo('SetRoundTime',"set the current time left for this round in X sec");
		AddCommandInfo('SetBetTime',"set the bet time in X sec");
		AddCommandInfo(' ',"-------------------------");
		AddCommandInfo('dbgActor',"all actor debug dump");
		AddCommandInfo('dbgRainbow',"all rainbow debug dump");
		AddCommandInfo('dgbWeapon',"current weapon debug info");
		AddCommandInfo('dbgThis',"debug ouput this actor (pointed by the gun) (false = TraceActor,  true = TraceWorld)");
		AddCommandInfo('dbgEdit',"edit this actor (pointed by the gun)");
		AddCommandInfo('SetPawn',"set the current pawn");
		AddCommandInfo('SetPawnPace',"" $ SetPawnPace(0,True));
		AddCommandInfo('UsePath',"current pawn will walk/run away from the player (int 1=run)");
		AddCommandInfo('SetPState',"set the selected pawn's state");
		AddCommandInfo('SetCState',"set the selected controller's state");
		AddCommandInfo('SeeCurPawn',"check if it can see the current pawn");
		AddCommandInfo('CanWalk',"curPawn: test CanWalkTo to player");
		AddCommandInfo('TestFindPathToMe',"curPawn: test findPathTo and findPathToward");
		AddCommandInfo('KillThemAll',"Kill all non-player pawn");
		AddCommandInfo('KillTerro',"Kill all terrorist");
		AddCommandInfo('KillHostage',"Kill all hostage");
		AddCommandInfo('KillRainbow',"Kill all rainbow");
		AddCommandInfo('Suicide',"Commit a gentle suicide");
		AddCommandInfo('ToggleCollision',"toggle pawn collision");
		AddCommandInfo('TestGetFrame',"test if the skeletal of all pawn have been updated");
		AddCommandInfo('CheckFrienship',"check isEnemy, isFriend and isNeutral");
		AddCommandInfo('LogFriendship',"list all frienship relation with all pawns (option: bCheckIfAlive)");
		AddCommandInfo('LogFriendlyFire',"list all friendly fire bool");
		AddCommandInfo('ShowGameInfo',"Show game mode info (0=debug, 1=Menu 2=Menu with failures msg)");
		AddCommandInfo('LogPawn',"LogPawn on the client and on the server");
		AddCommandInfo('LogThis',"Log pointed actor on the client and on the server");
		AddCommandInfo('ListEscort',"List escorted hostage");
		AddCommandInfo('GetNbTerro',"number of terro");
		AddCommandInfo('GetNbRainbow',"number of rainbow");
		AddCommandInfo('GetNbHostage',"number of hostage");
		AddCommandInfo(' ',"-- hostage --------------");
		AddCommandInfo('hHelp',"display AI Hostage / Civilian debugger");
		AddCommandInfo('DbgHostage',"debug hostage");
		AddCommandInfo('ToggleHostageLog',"toggle hostage log of AI and PAWN");
		AddCommandInfo('ToggleHostageThreat',"toggle hostage threat detection");
		AddCommandInfo('MoveEscort',"order the escort to move there");
		AddCommandInfo('SetHPos',"set the hostage position: 0=Stand, 1=Kneel, 2=Prone, 3=Foetus, 4=Crouch, 5=Random");
		AddCommandInfo('SetHRoll',"set the hostage reaction roll (0 to disable)");
		AddCommandInfo('resetThreat',"reset threat");
		AddCommandInfo('toggleThreatInfo',"show Threat info");
		AddCommandInfo('regroupHostages',"tell hostages to regroup on me");
		AddCommandInfo(' ',"-- hostage anim player --");
		AddCommandInfo('HLA',"Hostage LIST anim");
		AddCommandInfo('HSA',"Hostage SET anim Index (int index) ");
		AddCommandInfo('HP',"Hostage PLAY anim (0: no loop, 1: loop)");
		AddCommandInfo('HNA',"Hostage NEXT anim ");
		AddCommandInfo('HPA',"Hostage PREVIOUS anim ");
		AddCommandInfo(' ',"-- terrorist-------------");
		AddCommandInfo('CallTerro',"Call terro of a group to the location of the player");
		AddCommandInfo('dbgTerro',"all terro debug dump");
		AddCommandInfo('PlayerInvisible',"toggle Player detection by terrorists");
		AddCommandInfo('tNoThreat',"set all terrorist back to no threat state");
		AddCommandInfo('tSurrender',"toggle display of action spot");
		AddCommandInfo('tRunAway',"toggle display of action spot");
		AddCommandInfo('tSprayFire',"toggle display of action spot");
		AddCommandInfo('tAimedFire',"toggle display of action spot");
		AddCommandInfo('ToggleTerroLog',"toggle terroriste log of AI and PAWN");
		AddCommandInfo('RendSpot',"toggle display of action spot");
		AddCommandInfo(' ',"-- Weapon offset---------");
		AddCommandInfo('WOX',"Add the parameter to the X weapon Offset (move weapon +forward or -backward)");
		AddCommandInfo('WOY',"Add the parameter to the Y weapon Offset (move weapon -right or +left");
		AddCommandInfo('WOZ',"Add the parameter to the X weapon Offset (Move weapon +up or -Down");
		AddCommandInfo('ShowWO',"Display the current weapon offset in the log");
		AddCommandInfo(' ',"-- misc -----------------");
		AddCommandInfo('SetShake',"Activate the camera shake when shooting 1 is true and 0 is false");
		AddCommandInfo('DesignJF',"Weapon jump factor 0 is no jump, 0.5 is half 2 is twice");
		AddCommandInfo('DesignSF',"Weapon return speed factor 0 is no return speed, 0.5 is half 2 is twice");
		AddCommandInfo('ForceKillResult',"Force kill to 1=none 2=wounded 3=incapacited 4=kill and 0 is normal");
		AddCommandInfo('ForceStunResult',"Force stun to 1=none 2=stuned 3=Dazed 4=Knocked out and 0 is normal");
		AddCommandInfo('BulletSpeed',"Set the bullet speed for current weapon (cm/s), < 5000 is really slow and > 50000 is to fast");
		AddCommandInfo('HandDown',"Put left hand down");
		AddCommandInfo('HandUp',"Put left hand up");
		AddCommandInfo('HideWeapon',"Hide the weapon in First Person View");
		AddCommandInfo('ShowWeapon',"Show the weapon in First Person View");
		AddCommandInfo('ToggleHitLog',"turn on/off Show all bullet Hit Logs");
		AddCommandInfo('logActReset',"Log Actors reset");
		AddCommandInfo('logAct',"Log Actors(nb to log)");
		AddCommandInfo('SetBombTimer',"Set bomb timer: X sec");
		AddCommandInfo('SetBombInfo',"info: fExpRadius, fKillRadius, iEnergy");
		AddCommandInfo('GetBombInfo',"get info");
		AddCommandInfo('testBomb',"test bomb: god, objective off.. arm bomb and set time to 5 sec");
		AddCommandInfo(' ',"-- mission objective -----------------");
		AddCommandInfo('ToggleMissionLog',"Toggle Mission Objective Mgr log");
		AddCommandInfo('NeutralizeTerro',"Neutralize all terrorist in the level");
		AddCommandInfo('DisarmBombs',"Disarms all the bombs on the level");
		AddCommandInfo('DeactivateIODevice',"Deactivate IODevice like phone, laptop (ie: plant a bug)");
		AddCommandInfo('RescueHostage',"Rescue all hostages");
		AddCommandInfo('DisableMorality',"Disable morality rules");
		AddCommandInfo('ToggleObjectiveMgr',"Toggle mission objective mgr (the mission will not fail or complete)");
		AddCommandInfo('CompleteMission',"Complete the mission");
		AddCommandInfo('AbortMission',"Abort the mission");
		AddCommandInfo('None',"");
	}
	Log("  -- List all registered function ---------------");
	i=0;
JL1570:
	if ( (m_aCommandInfo[i].m_functionName != 'None') && (m_aCommandInfo[i].m_szDescription != "") )
	{
		sz="" $ string(m_aCommandInfo[i].m_functionName);
		if ( Len(sz) > iSize )
		{
			iSize=Len(sz);
		}
		i++;
		goto JL1570;
	}
	i=0;
	szDot=".................................";
JL1617:
	if ( (m_aCommandInfo[i].m_functionName != 'None') && (m_aCommandInfo[i].m_szDescription != "") )
	{
		sz="" $ string(m_aCommandInfo[i].m_functionName);
		if ( m_aCommandInfo[i].m_functionName == ' ' )
		{
			Log(m_aCommandInfo[i].m_szDescription);
		}
		else
		{
			Log("" $ sz $ "" $ Left(szDot,iSize - Len(sz)) $ "..: " $ m_aCommandInfo[i].m_szDescription);
		}
		i++;
		goto JL1617;
	}
}

function AddCommandInfo (name functionName, string szDescription)
{
	local int i;

	assert (m_iCommandInfoIndex < 128);
	m_aCommandInfo[m_iCommandInfoIndex].m_szDescription=szDescription;
	m_aCommandInfo[m_iCommandInfoIndex].m_functionName=functionName;
	m_iCommandInfoIndex++;
}

exec function PhyStat ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.ConsoleCommand("R6STATS TIMERS PHYSICS");
}

exec function ToggleRadius ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.ConsoleCommand("ToggleRadius");
}

exec function BoneCorpse ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bRenderBoneCorpse= !m_bRenderBoneCorpse;
	Outer.Player.Console.Message("BoneCorpse = " $ string(m_bRenderBoneCorpse),6.00);
}

exec function GunDirection ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bRenderGunDirection= !m_bRenderGunDirection;
	Outer.Player.Console.Message("GunDirection = " $ string(m_bRenderGunDirection),6.00);
}

exec function ViewDirection ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bRenderViewDirection= !m_bRenderViewDirection;
	Outer.Player.Console.Message("GunDirection = " $ string(m_bRenderViewDirection),6.00);
}

exec function Route ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bRenderRoute= !m_bRenderRoute;
	Outer.Player.Console.Message("Draw route = " $ string(m_bRenderRoute),6.00);
}

exec function NavPoint ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bRenderNavPoint= !m_bRenderNavPoint;
	Outer.Player.Console.Message("Draw nav point = " $ string(m_bRenderNavPoint),6.00);
}

exec function RouteAll (optional float fDistance)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( fDistance != 0 )
	{
		Outer.Level.m_fDbgNavPointDistance=fDistance;
	}
	Outer.ConsoleCommand("rend paths");
	Outer.Player.Console.Message("RouteAll: " $ string(Outer.Level.m_fDbgNavPointDistance) $ " units",6.00);
}

exec function ShowFOV ()
{
	local R6Pawn P;

	if (  !CanExec() )
	{
		return;
	}
	if ( m_bRenderFOV )
	{
		foreach Outer.AllActors(Class'R6Pawn',P)
		{
			if (  !P.m_bIsPlayer && (P.m_FOV != None) )
			{
				P.DetachFromBone(P.m_FOV);
				P.m_FOV.Destroy();
				P.m_FOV=None;
			}
		}
	}
	else
	{
		foreach Outer.AllActors(Class'R6Pawn',P)
		{
			if (  !P.m_bIsPlayer && P.IsAlive() )
			{
				P.m_FOV=Outer.Spawn(P.m_FOVClass);
				P.AttachToBone(P.m_FOV,'R6 PonyTail2');
			}
		}
	}
	m_bRenderFOV= !m_bRenderFOV;
	Outer.Player.Console.Message("ShowFOV = " $ string(m_bRenderFOV),6.00);
}

exec function ToggleUnlimitedPractice ()
{
	local R6AbstractGameInfo GameInfo;

	if (  !CanExec() )
	{
		return;
	}
	GameInfo=R6AbstractGameInfo(Outer.Level.Game);
	GameInfo.SetUnlimitedPractice( !GameInfo.IsUnlimitedPractice(),True);
}

exec function God ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( R6Pawn(Outer.Pawn) == None )
	{
		return;
	}
	Outer.bGodMode= !Outer.bGodMode;
	R6Pawn(Outer.Pawn).ServerGod(Outer.bGodMode,False,False,Outer.PlayerReplicationInfo.PlayerName,False);
	Outer.Player.Console.Message("God " $ string(Outer.bGodMode),6.00);
}

exec function GodTeam ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( Outer.bOnlySpectator )
	{
		if ( Outer.ViewTarget.IsA('R6Pawn') )
		{
			m_bTeamGodMode= !m_bTeamGodMode;
			Outer.bGodMode=m_bTeamGodMode;
			R6Pawn(Outer.ViewTarget).ServerGod(m_bTeamGodMode,True,False,Outer.PlayerReplicationInfo.PlayerName,False);
			Outer.Player.Console.Message("GodTeam " $ string(Outer.bGodMode),6.00);
		}
	}
	else
	{
		if ( R6Pawn(Outer.Pawn) == None )
		{
			return;
		}
		m_bTeamGodMode= !m_bTeamGodMode;
		R6Pawn(Outer.Pawn).ServerGod(m_bTeamGodMode,True,False,Outer.PlayerReplicationInfo.PlayerName,False);
		Outer.Player.Console.Message("GodTeam " $ string(Outer.bGodMode),6.00);
	}
}

exec function GodTerro ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( R6Pawn(Outer.Pawn) == None )
	{
		return;
	}
	R6Pawn(Outer.Pawn).ServerGod(False,False,False,Outer.PlayerReplicationInfo.PlayerName,True);
	Outer.Player.Console.Message("GodTerro",6.00);
}

exec function GodHostage ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( R6Pawn(Outer.Pawn) == None )
	{
		return;
	}
	R6Pawn(Outer.Pawn).ServerGod(False,False,True,Outer.PlayerReplicationInfo.PlayerName,False);
	Outer.Player.Console.Message("GodHostage",6.00);
}

exec function GodAll ()
{
	if (  !CanExec() )
	{
		return;
	}
	GodTeam();
	GodHostage();
}

exec function PerfectAim ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Pawn.EngineWeapon.PerfectAim();
}

exec function NeutralizeTerro ()
{
	local R6Terrorist t;
	local int i;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Terrorist',t)
	{
		t.ServerForceKillResult(4);
		t.R6TakeDamage(1000,1000,t,t.Location,vect(0.00,0.00,0.00),0);
	}
	Outer.Player.Console.Message("Neutralized terro = " $ string(i),6.00);
}

exec function DisarmBombs ()
{
	local R6IOBomb bomb;
	local int i;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6IOBomb',bomb)
	{
		bomb.DisarmBomb(R6Pawn(Outer.Pawn));
		i++;
	}
	Outer.Player.Console.Message("Bomb disarmed = " $ string(i),6.00);
}

exec function DeactivateIODevice ()
{
	local R6IODevice device;
	local int i;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6IODevice',device)
	{
		device.ToggleDevice(R6Pawn(Outer.Pawn));
		i++;
	}
	Outer.Player.Console.Message("Deactivated IODevice = " $ string(i),6.00);
}

exec function ToggleObjectiveMgr ()
{
	local R6MissionObjectiveMgr moMgr;

	if (  !CanExec() )
	{
		return;
	}
	moMgr=R6AbstractGameInfo(Outer.Level.Game).m_missionMgr;
	moMgr.m_bDontUpdateMgr= !moMgr.m_bDontUpdateMgr;
	Outer.Player.Console.Message("Dont update mission objective manager = " $ string(moMgr.m_bDontUpdateMgr),6.00);
	if (  !moMgr.m_bDontUpdateMgr )
	{
		if ( Outer.Level.Game.CheckEndGame(None,"") )
		{
			Outer.Level.Game.EndGame(None,"");
		}
	}
}

exec function RescueHostage ()
{
	local R6Hostage H;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		if ( H.m_controller != None )
		{
			H.m_controller.SetStateExtracted();
			R6AbstractGameInfo(Outer.Level.Game).EnteredExtractionZone(H);
		}
	}
	Log("All hostages has been rescued");
}

exec function DisableMorality ()
{
	local R6MissionObjectiveMgr moMgr;
	local int i;

	if (  !CanExec() )
	{
		return;
	}
	moMgr=R6AbstractGameInfo(Outer.Level.Game).m_missionMgr;
JL0038:
	if ( i < moMgr.m_aMissionObjectives.Length )
	{
		if ( moMgr.m_aMissionObjectives[i].m_bMoralityObjective )
		{
			moMgr.m_aMissionObjectives.Remove (i,1);
		}
		else
		{
			++i;
		}
		goto JL0038;
	}
	Outer.Player.Console.Message("Morality rules removed",6.00);
}

function DoCompleteMission ()
{
	local R6MissionObjectiveMgr moMgr;

	if (  !CanExec() )
	{
		return;
	}
	R6AbstractGameInfo(Outer.Level.Game).CompleteMission();
	Outer.Player.Console.Message("CompleteMission",6.00);
}

function DoAbortMission ()
{
	local R6MissionObjectiveMgr moMgr;

	if (  !CanExec() )
	{
		return;
	}
	R6AbstractGameInfo(Outer.Level.Game).AbortMission();
	Outer.Player.Console.Message("AbortMission",6.00);
}

exec function KillTerro ()
{
	if (  !CanExec() )
	{
		return;
	}
	KillAllPawns(Class'R6Terrorist');
}

exec function KillHostage ()
{
	if (  !CanExec() )
	{
		return;
	}
	KillAllPawns(Class'R6Hostage');
}

exec function KillRagdoll ()
{
	local R6Pawn P;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.DynamicActors(Class'R6Pawn',P)
	{
		if ( P.Physics == 14 )
		{
			if ( P.Controller != None )
			{
				P.Controller.Destroy();
			}
			P.Destroy();
		}
	}
}

function KillRainbowTeam ()
{
	local R6RainbowTeam Team;
	local int i;
	local bool bHuman;

	foreach Outer.AllActors(Class'R6RainbowTeam',Team)
	{
		bHuman=False;
		i=0;
JL0028:
		if ( i < Team.m_iMemberCount )
		{
			if (  !Team.m_Team[i].m_bIsPlayer )
			{
				Team.m_Team[0]=Team.m_Team[i];
				Team.m_iMemberCount=1;
				bHuman=True;
				goto JL00C6;
			}
			else
			{
				Team.m_Team[i]=None;
			}
			i++;
			goto JL0028;
		}
JL00C6:
		if (  !bHuman )
		{
			Team.m_iMemberCount=0;
		}
	}
}

exec function KillRainbow ()
{
	if (  !CanExec() )
	{
		return;
	}
	KillRainbowTeam();
	KillAllPawns(Class'R6Rainbow');
}

exec function KillPawns ()
{
	if (  !CanExec() )
	{
		return;
	}
	KillRainbowTeam();
	KillAllPawns(Class'Pawn');
}

exec function PlayerInvisible ()
{
	m_bPlayerInvisble= !m_bPlayerInvisble;
	R6PlayerController(Outer.Pawn.Controller).ServerPlayerInvisible(m_bPlayerInvisble);
}

function DoPlayerInvisible (bool bInvisible)
{
	local R6Terrorist t;

	foreach Outer.AllActors(Class'R6Terrorist',t)
	{
		t.m_bDontHearPlayer=bInvisible;
		t.m_bDontSeePlayer=bInvisible;
	}
	Outer.Player.Console.Message("PlayerInvisible = " $ string(bInvisible),6.00);
}

exec function GiveMag (int iNbOfExtraClips)
{
	local int iWeaponIndex;

	if (  !CanExec() )
	{
		return;
	}
	if ( Outer.Level.NetMode != 0 )
	{
		return;
	}
	iWeaponIndex=0;
JL0038:
	if ( iWeaponIndex < 4 )
	{
		Outer.Pawn.m_WeaponsCarried[iWeaponIndex].AddClips(iNbOfExtraClips);
		iWeaponIndex++;
		goto JL0038;
	}
}

exec function HideAll ()
{
	if ( m_bHideAll )
	{
		m_bHideAll=False;
		R6AbstractHUD(PlayerController(Outer.Pawn.Controller).myHUD).m_iCycleHUDLayer=0;
	}
	else
	{
		m_bHideAll=True;
		R6AbstractHUD(PlayerController(Outer.Pawn.Controller).myHUD).m_iCycleHUDLayer=3;
	}
	R6PlayerController(Outer.Pawn.Controller).m_bUseFirstPersonWeapon= !m_bHideAll;
	R6AbstractHUD(PlayerController(Outer.Pawn.Controller).myHUD).m_bToggleHelmet= !m_bHideAll;
	R6PlayerController(Outer.Pawn.Controller).m_bHideReticule=m_bHideAll;
}

exec function ToggleReticule ()
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_bHideReticule= !R6PlayerController(Outer.Pawn.Controller).m_bHideReticule;
}

exec function tNoThreat ()
{
	local R6TerroristAI t;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6TerroristAI',t)
	{
		t.GotoStateNoThreat();
	}
	Outer.Player.Console.Message("Terrorist going back to no threat state",6.00);
}

exec function tSurrender ()
{
	local R6TerroristAI t;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6TerroristAI',t)
	{
//		t.m_eEngageReaction=4;
	}
	Outer.Player.Console.Message("All terrorists will surrender",6.00);
}

exec function tRunAway ()
{
	local R6TerroristAI t;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6TerroristAI',t)
	{
//		t.m_eEngageReaction=3;
	}
	Outer.Player.Console.Message("All terrorists will run away",6.00);
}

exec function tSpeed (float fSpeed)
{
	local R6Terrorist t;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Terrorist',t)
	{
		t.m_fWalkingSpeed=fSpeed;
	}
	Outer.Player.Console.Message("All terrorists walk at " $ string(fSpeed),6.00);
}

exec function tSprayFire ()
{
	local R6TerroristAI t;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6TerroristAI',t)
	{
//		t.m_eEngageReaction=2;
	}
	Outer.Player.Console.Message("All terrorists will spray fire",6.00);
}

exec function tAimedFire ()
{
	local R6TerroristAI t;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6TerroristAI',t)
	{
//		t.m_eEngageReaction=1;
	}
	Outer.Player.Console.Message("All terrorists will aim fire",6.00);
}

exec function tTick (int iTickFrequency)
{
	local R6Terrorist t;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Terrorist',t)
	{
		t.m_wTickFrequency=iTickFrequency;
		t.m_wNbTickSkipped=RandRange(0.00,iTickFrequency);
	}
	Outer.Player.Console.Message("Terrorists tick frequency " $ string(iTickFrequency),6.00);
}

exec function ActorTick (int iTickFrequency)
{
	local Actor A;

	if (  !CanExec() )
	{
		return;
	}
	m_bSkipTick= !m_bSkipTick;
	foreach Outer.AllActors(Class'Actor',A)
	{
		if (  !m_bSkipTick )
		{
			A.m_bSkipTick=False;
			A.m_bTickOnlyWhenVisible=False;
		}
		else
		{
			A.m_bSkipTick=A.Default.m_bSkipTick;
			A.m_bTickOnlyWhenVisible=A.Default.m_bTickOnlyWhenVisible;
		}
	}
	Outer.Player.Console.Message("Actor m_bSkipTick: " $ string(m_bSkipTick),6.00);
}

exec function ToggleHitLog ()
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_bShowHitLogs= !R6PlayerController(Outer.Pawn.Controller).m_bShowHitLogs;
}

exec function CallTerro (optional int iGroup)
{
	local R6TerroristAI AI;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6TerroristAI',AI)
	{
		if ( AI.m_pawn.m_iGroupID == iGroup )
		{
			Log("Calling terrorist " $ string(AI.m_pawn) $ " to " $ string(Outer.Pawn.Location));
//			AI.GotoPointAndSearch(Outer.Pawn.Location,5,False);
		}
	}
}

exec function UseKarma ()
{
	local R6Pawn P;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Pawn',P)
	{
		P.m_bUseKarmaRagdoll= !P.m_bUseKarmaRagdoll;
	}
	Outer.Player.Console.Message("Toggled karma use",6.00);
}

exec function AutoSelect (string _szSelection)
{
	if (  !CanExec() )
	{
		return;
	}
	Class'Actor'.static.GetGameOptions().MPAutoSelection=_szSelection;
}

exec function ToggleWalk ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( (Outer.Pawn == None) || (Outer.Pawn.Controller == None) )
	{
		return;
	}
	if (  !CanExec() )
	{
		return;
	}
	Walk();
	if ( m_bFirstPersonPlayerView )
	{
		R6PlayerController(Outer.Pawn.Controller).BehindView(True);
	}
	m_bFirstPersonPlayerView= !m_bFirstPersonPlayerView;
}

event PostRender (Canvas Canvas)
{
	local R6Pawn P;
	local R6AbstractCorpse corpse;
	local R6AIController C;
	local NavigationPoint np;
	local R6ActionSpot as;
	local Vector vTemp;
	local Controller aController;

	if ( m_bRendSpot )
	{
		foreach Outer.AllActors(Class'R6ActionSpot',as)
		{
			vTemp=as.Location;
			Outer.DrawText3D(vTemp,"ActionSpot " $ string(as.Name));
			if ( as.m_bInvestigate )
			{
				vTemp.Z -= 10;
				Outer.DrawText3D(vTemp,"Investigate");
			}
			if ( as.m_eCover != 0 )
			{
				vTemp.Z -= 10;
				Outer.DrawText3D(vTemp,"Cover");
			}
			if ( as.m_eFire != 0 )
			{
				vTemp.Z -= 10;
				Outer.DrawText3D(vTemp,"Fire");
			}
		}
	}
	if ( m_bRenderViewDirection || m_bRenderGunDirection || m_bRendPawnState || m_bRendFocus )
	{
		foreach Outer.AllActors(Class'R6Pawn',P)
		{
			if ( (P.LastRenderTime == Outer.Level.TimeSeconds) && P.IsAlive() )
			{
				if ( m_bRenderViewDirection )
				{
					P.DrawViewRotation(Canvas);
				}
				if ( m_bRenderGunDirection )
				{
					P.RenderGunDirection(Canvas);
				}
				if ( m_bRendPawnState )
				{
					vTemp=P.Location;
					vTemp.Z += 90;
					Outer.DrawText3D(vTemp,string(P.Name));
					if ( P.GetStateName() != P.Class.Name )
					{
						vTemp.Z -= 15;
						Outer.DrawText3D(vTemp,string(P.GetStateName()));
					}
					if ( P.Controller != None )
					{
						vTemp.Z -= 15;
						Outer.DrawText3D(vTemp,string(P.Controller.GetStateName()));
						if ( (P.m_ePawnType == 2) && (P.Controller.IsInState('MovingTo') || P.Controller.IsInState('Attack')) )
						{
							vTemp.Z -= 15;
							Outer.DrawText3D(vTemp,R6TerroristAI(P.Controller).m_sDebugString);
						}
					}
				}
				if ( m_bRendFocus )
				{
					if ( P.Controller.Focus != None )
					{
						Canvas.Draw3DLine(P.Controller.Focus.Location,P.Location + P.EyePosition(),class'Canvas'.static.MakeColor(255,0,0));
					}
					Canvas.Draw3DLine(P.Controller.FocalPoint,P.Location + P.EyePosition(),class'Canvas'.static.MakeColor(255,150,150));
				}
			}
		}
	}
	if ( m_bRenderBoneCorpse )
	{
		foreach Outer.AllActors(Class'R6AbstractCorpse',corpse)
		{
			corpse.RenderCorpseBones(Canvas);
		}
	}
	if ( m_bRenderRoute )
	{
		aController=Outer.Level.ControllerList;
JL04AA:
		if ( aController != None )
		{
			if ( aController.IsA('R6AIController') && R6AIController(aController).m_r6pawn.IsAlive() )
			{
				DrawRoute(R6AIController(aController),Canvas);
			}
			aController=aController.nextController;
			goto JL04AA;
		}
	}
	if ( m_bRenderNavPoint )
	{
		foreach Outer.RadiusActors(Class'NavigationPoint',np,1000.00,Outer.ViewTarget.Location)
		{
			Outer.DrawText3D(np.Location,string(np.Name));
		}
	}
	if ( m_bEnableNavDebug )
	{
		processNavDebug(Canvas);
	}
	if ( m_bTogglePeek )
	{
		processDebugPeek(Canvas);
	}
	if ( m_bTogglePGDebug )
	{
		processDebugPG(Canvas);
	}
	if ( m_bToggleThreatInfo )
	{
		processThreatInfo(Canvas);
	}
	if ( m_bToggleGameInfo )
	{
		displayGameInfo(Canvas);
	}
}

exec function ToggleHostageThreat ()
{
	local R6Hostage H;

	if (  !CanExec() )
	{
		return;
	}
	m_bToggleHostageThreat= !m_bToggleHostageThreat;
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		R6HostageAI(H.Controller).m_bDbgIgnoreThreat=m_bToggleHostageThreat;
	}
}

exec function ToggleHostageLog ()
{
	local R6Hostage H;

	if (  !CanExec() )
	{
		return;
	}
	m_bToggleHostageLog= !m_bToggleHostageLog;
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		H.bShowLog=m_bToggleHostageLog;
		R6HostageAI(H.Controller).bShowLog=m_bToggleHostageLog;
		R6HostageAI(H.Controller).m_mgr.bShowLog=m_bToggleHostageLog;
	}
}

exec function ToggleTerroLog ()
{
	local R6Terrorist t;

	if (  !CanExec() )
	{
		return;
	}
	m_bToggleTerroLog= !m_bToggleTerroLog;
	foreach Outer.AllActors(Class'R6Terrorist',t)
	{
		t.bShowLog=m_bToggleTerroLog;
		R6TerroristAI(t.Controller).bShowLog=m_bToggleTerroLog;
	}
}

exec function RendSpot ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bRendSpot= !m_bRendSpot;
	Outer.Player.Console.Message("RendSpot " $ string(m_bRendSpot),6.00);
}

exec function TerroInfo ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.ConsoleCommand("RendPawnState");
	Outer.ConsoleCommand("RendFocus");
	Outer.ConsoleCommand("FullAmmo");
}

exec function ToggleRainbowLog ()
{
	local R6Rainbow Rainbow;

	if (  !CanExec() )
	{
		return;
	}
	m_bToggleRainbowLog= !m_bToggleRainbowLog;
	foreach Outer.AllActors(Class'R6Rainbow',Rainbow)
	{
		if (  !Rainbow.m_bIsPlayer )
		{
			R6RainbowAI(Rainbow.Controller).bShowLog=m_bToggleRainbowLog;
			R6RainbowAI(Rainbow.Controller).m_TeamManager.bShowLog=m_bToggleRainbowLog;
		}
	}
}

function name GetNameOfActor (Actor aActor)
{
	if ( aActor == None )
	{
		return 'None';
	}
	else
	{
		return aActor.Name;
	}
}

function Actor GetPointedActor (bool bVerboseLog, bool bTraceActor, optional out Vector vReturnHit, optional bool bForceTrace)
{
	local Actor anActor;
	local string szOutput;
	local string szController;
	local Vector vViewDir;
	local Vector vTraceStart;
	local Vector vTraceEnd;
	local Vector vHit;
	local Vector vHitNormal;

	if ( Outer.ViewTarget != Outer.Pawn )
	{
		anActor=Outer.ViewTarget;
	}
	else
	{
//		vViewDir=R6Pawn(Outer.Pawn).GetFiringRotation();
		vTraceStart=R6Pawn(Outer.Pawn).GetFiringStartPoint();
		vTraceStart += vViewDir * 40;
		vTraceEnd=vTraceStart + 10000 * vViewDir;
		anActor=Outer.Trace(vHit,vHitNormal,vTraceEnd,vTraceStart,bTraceActor);
	}
	if ( (anActor != None) && (Pawn(anActor) != None) && (Pawn(anActor).Controller != None) )
	{
		szController="" $ string(Pawn(anActor).Controller.Name) $ " (" $ string(Pawn(anActor).Controller.GetStateName()) $ ")";
	}
	else
	{
		szController="none";
	}
	szOutput="Actor: " $ string(anActor.Name) $ "  Controller: " $ szController $ " class: " $ string(anActor.Class);
	Log(szOutput);
	if ( bVerboseLog )
	{
		Outer.Player.Console.Message("Controller: " $ szController,6.00);
		Outer.Player.Console.Message("Actor: " $ string(anActor.Name) $ " (" $ string(anActor.GetStateName()) $ ")",6.00);
		Outer.Player.Console.Message("Class: " $ string(anActor.Class),6.00);
	}
	vReturnHit=vHit;
	return anActor;
}

exec event LogThis (optional bool bDontTraceActor, optional Actor anActor)
{
	if (  !bDontTraceActor || (anActor == None) )
	{
		anActor=GetPointedActor(True,True);
	}
	R6PlayerController(Outer.Pawn.Controller).DoDbgLogActor(anActor);
}

exec function dbgThis (optional bool bTraceWorld)
{
	local Actor anActor;

	if (  !CanExec() )
	{
		return;
	}
	anActor=GetPointedActor(True, !bTraceWorld);
	if ( R6Hostage(anActor) != None )
	{
		LogHostage(R6Hostage(anActor));
	}
	else
	{
		if ( R6Terrorist(anActor) != None )
		{
			LogTerro(R6Terrorist(anActor));
		}
		else
		{
			if ( R6Rainbow(anActor) != None )
			{
				LogRainbow(R6Rainbow(anActor));
			}
			else
			{
				if ( R6IOBomb(anActor) != None )
				{
					LogIOBomb(R6IOBomb(anActor));
				}
			}
		}
	}
}

exec function dbgEdit (optional bool bTraceWorld)
{
	local string szCmd;
	local Actor anActor;

	if (  !CanExec() )
	{
		return;
	}
	anActor=GetPointedActor(True, !bTraceWorld);
	szCmd="editactor Actor=" $ string(anActor.Name);
	Outer.ConsoleCommand(szCmd);
}

function LogR6Pawn (R6Pawn P)
{
	local Controller AI;
	local R6AIController r6ai;
	local R6PlayerController PController;
	local name aiName;
	local string szTemp;

	if (  !CanExec() )
	{
		return;
	}
	AI=P.Controller;
	if ( AI != None )
	{
		aiName=AI.Name;
	}
	Log("== " $ string(P.Name) $ " ai: " $ string(aiName) $ " ===============");
	Log("   Location.............: " $ string(P.Location));
	Log("   Pawn state...........: " $ string(P.GetStateName()));
	Log("   Coll. Height, Radius.: " $ string(P.CollisionHeight) $ ", " $ string(P.CollisionRadius));
	switch (P.Physics)
	{
/*		case 0:
		szTemp="None";
		break;
		case 1:
		szTemp="Walking";
		break;
		case 2:
		szTemp="Falling";
		break;
		case 5:
		szTemp="Rotating";
		break;
		case 11:
		szTemp="Ladder";
		break;
		default:
		szTemp="Unknown";
		break;         */
	}
	Log("   Physics..............: " $ szTemp $ " (" $ string(P.Physics) $ ")");
	switch (P.m_eMovementPace)
	{
/*		case 0:
		szTemp="None";
		break;
		case 1:
		szTemp="Prone";
		break;
		case 2:
		szTemp="CrouchWalk";
		break;
		case 3:
		szTemp="CrouchRun";
		break;
		case 4:
		szTemp="Walk";
		break;
		case 5:
		szTemp="Run";
		break;
		default:
		szTemp="Unknown";
		break;       */
	}
	Log("   m_eMovementPace......: " $ szTemp $ " (" $ string(P.m_eMovementPace) $ ")");
	switch (P.m_eHealth)
	{
/*		case 3:
		szTemp="Dead";
		break;
		case 2:
		szTemp="Incapacitated";
		break;
		case 1:
		szTemp="Wounded";
		break;
		case 0:
		szTemp="Healthy";
		break;
		default:
		szTemp="Unknown";
		break;       */
	}
	Log("   Health...............: " $ szTemp $ " (" $ string(P.m_eHealth) $ ")");
	Log("   m_bPostureTransition.: " $ string(P.m_bPostureTransition));
	Log("   bIsWalking...........: " $ Left(string(P.bIsWalking),4));
	Log("   IsPeeking............: " $ string(P.IsPeeking()) $ " left: " $ string(P.IsPeekingLeft()) $ " rate()= " $ string(P.GetPeekingRate()));
	Log("   bIsCrouched..........: " $ Left(string(P.bIsCrouched),4) $ ",   bWantsToCrouch.......: " $ Left(string(P.bWantsToCrouch),4));
	Log("   m_bIsProne...........: " $ Left(string(P.m_bIsProne),4) $ ",   m_bWantsToProne......: " $ Left(string(P.m_bWantsToProne),4));
	Log("   m_bIsClimbingStairs..: " $ Left(string(P.m_bIsClimbingStairs),4) $ ",   m_bIsMovingUpStairs..: " $ Left(string(P.m_bIsMovingUpStairs),4));
	Log("   m_bAutoClimbLadders..: " $ Left(string(P.m_bAutoClimbLadders),4) $ ",   m_bIsClimbingLadder..: " $ Left(string(P.m_bIsClimbingLadder),4));
	Log("   m_bAvoidFacingWalls..: " $ Left(string(P.m_bAvoidFacingWalls),4) $ ",   m_bCanClimbObject....: " $ Left(string(P.m_bCanClimbObject),4));
	Log("   m_bUseRagdoll........: " $ string(P.m_bUseRagdoll) $ " (" $ string(P.m_ragdoll) $ ")");
	Log("   bCanWalkOffLedges....: " $ string(P.bCanWalkOffLedges));
	Log("   m_bCanDisarmBomb.....: " $ Left(string(P.m_bCanDisarmBomb),4) $ ",   m_bCanArmBomb........: " $ Left(string(P.m_bCanArmBomb),4));
	Log("   m_iTeam..............: " $ string(P.m_iTeam));
	Log("   m_ladder.............: " $ string(P.m_Ladder));
	if ( AI != None )
	{
		Log("   ** ai state..........: " $ string(AI.GetStateName()));
		switch (AI.m_eMoveToResult)
		{
/*			case 0:
			szTemp="None";
			break;
			case 1:
			szTemp="Success";
			break;
			case 2:
			szTemp="Failed";
			break;
			default:
			szTemp="Unknown";
			break;      */
		}
		Log("   m_eMoveToResult......: " $ szTemp $ " (" $ string(AI.m_eMoveToResult) $ ")");
		Log("   MoveTarget...........: " $ string(GetNameOfActor(AI.MoveTarget)));
		Log("   Enemy................: " $ string(GetNameOfActor(AI.Enemy)));
		Log("   bRotateToDesired.....: " $ string(P.bRotateToDesired));
		Log("   Focus................: " $ string(GetNameOfActor(AI.Focus)));
		Log("   FocalPoint...........: " $ string(AI.FocalPoint));
		Log("   m_bCrawl.............: " $ string(AI.m_bCrawl));
		Log("   Can reach a navpoint.: " $ string(AI.FindRandomDest(True)));
		r6ai=R6AIController(P.Controller);
		if ( r6ai != None )
		{
			Log("   m_BumpedBy...........: " $ string(GetNameOfActor(r6ai.m_BumpedBy)));
			Log("   m_bIgnoreBackupBump..: " $ string(r6ai.m_bIgnoreBackupBump));
			Log("   m_climbingObject.....: " $ string(GetNameOfActor(r6ai.m_climbingObject)));
			Log("   m_ActorTarget........: " $ string(r6ai.m_ActorTarget));
		}
	}
	else
	{
		Log("    no controller");
	}
	PController=R6PlayerController(P.Controller);
	if ( PController != None )
	{
		Log("   ** PlayerController......: " $ string(PController.GetStateName()));
		if ( P.m_ePeekingMode == 1 )
		{
			Log("   Peeking..............: Full ");
		}
		else
		{
			if ( P.m_ePeekingMode == 2 )
			{
				Log("   Peeking..............: Fluid");
			}
			else
			{
				Log("   Peeking..............: none");
			}
		}
		Log("   m_bPeekingLeft ......: " $ string(P.m_bPeekingLeft));
//		Log("   m_fPeeking...........: " $ string(P.m_fPeeking) $ " / " $ string(P.1000.00));
		Log("   m_fLastValidPeeking..: " $ string(P.m_fLastValidPeeking));
		Log("   m_bPeekingToCenter...: " $ string(P.m_bPeekingReturnToCenter));
		Log("   m_fCrouchBlendRate...: " $ string(P.m_fCrouchBlendRate));
	}
}

function LogHostage (R6Hostage H)
{
	local R6HostageAI AI;
	local int i;
	local name aiName;
	local name lastSeenPawnName;
	local name escortName;
	local name terroristName;
	local Vector vPlayerLoc;
	local bool bFastTrace;
	local name animSeq;
	local float AnimRate;
	local float AnimFrame;

	AI=R6HostageAI(H.Controller);
	if ( AI != None )
	{
		aiName=AI.Name;
		if ( AI.m_terrorist != None )
		{
			terroristName=AI.m_terrorist.Name;
		}
		if ( AI.m_pawnToFollow != None )
		{
			bFastTrace=Outer.FastTrace(AI.m_pawnToFollow.Location,H.Location);
		}
		if ( AI.m_lastSeenPawn != None )
		{
			lastSeenPawnName=AI.m_lastSeenPawn.Name;
		}
		if ( AI.m_escort != None )
		{
			escortName=AI.m_escort.Name;
		}
	}
	if ( (Outer.Pawn != None) && Outer.Pawn.Controller.IsA('R6PlayerController') )
	{
		vPlayerLoc=Outer.Pawn.Location;
	}
	LogR6Pawn(H);
	if ( AI != None )
	{
		Log("   UsedTemplate.........: " @ H.m_szUsedTemplate);
		Log("   Rainbow (following)..: " @ string(GetNameOfActor(H.m_escortedByRainbow)) @ " (" @ string(GetNameOfActor(AI.m_pawnToFollow)) @ ")");
		Log("   ForceToStayHere......: " @ string(AI.m_bForceToStayHere));
		Log("   Distance from human..: " @ string(VSize(vPlayerLoc - H.Location)));
		Log("   FastTrace............: " @ string(bFastTrace));
		Log("   RunningToward........: " @ string(AI.m_bRunningToward));
		Log("   RunToRainbowSuccess..: " @ string(AI.m_bRunToRainbowSuccess));
		Log("   bNeedToRunToCatchUp..: " @ string(AI.m_bNeedToRunToCatchUp));
		Log("   bStopDoTransition....: " @ string(AI.m_bStopDoTransition));
		Log("   Freed................: " @ string(H.m_bFreed));
		Log("   Personality..........: " @ string(H.m_ePersonality));
		Log("   Position.............: " @ string(H.m_ePosition));
		Log("   Start as civilian....: " @ string(H.m_bStartAsCivilian));
		Log("   Hands Up.............: " @ string(H.m_eHandsUpType));
//		Log("   ThreatInfo...........: " @ AI.m_mgr.GetThreatInfoLog(AI.m_threatInfo));
		Log("   LastSeenPawn.........: " @ string(lastSeenPawnName));
		Log("   Escorted.............: " @ string(H.m_bEscorted));
		Log("   Escorted by..........: " @ string(escortName));
		Log("   Escorted by terro....: " @ string(terroristName));
		Log("   dbgIgnoreThreat......: " @ string(AI.m_bDbgIgnoreThreat));
		Log("   m_bSlowedPace........: " @ string(AI.m_bSlowedPace));
		Log("   m_bFollowIncreaseDist: " @ string(AI.m_bFollowIncreaseDistance));
		Log("   m_bExtracted.........: " @ string(H.m_bExtracted));
		Log("   m_bEscorted..........: " @ string(H.m_bEscorted));
		Log("   Number of orders.....: " @ string(AI.m_iNbOrder));
		i=0;
JL066D:
		if ( i < AI.m_iNbOrder )
		{
			Log("                          " @ AI.Order_GetLog(AI.m_aOrderInfo[i]));
			++i;
			goto JL066D;
		}
	}
}

exec function DbgHostage ()
{
	local int Num;
	local R6Hostage H;

	if (  !CanExec() )
	{
		return;
	}
	Log("-- ALL HOSTAGE DUMP --");
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		LogHostage(H);
		++Num;
	}
	Log("   " @ string(Num) @ " hostage(s)");
}

function InitTestHostageAnim ()
{
	local R6Hostage H;

	if (  !m_bHostageTestAnim )
	{
		foreach Outer.AllActors(Class'R6Hostage',H)
		{
			R6HostageAI(H.Controller).GotoState('DbgHostage');
		}
		m_bHostageTestAnim=True;
	}
}

function HostageSetAnimIndex (int increment)
{
	local R6Hostage H;
	local R6HostageAI AI;
	local R6HostageMgr mgr;
	local int i;

	mgr=R6HostageMgr(Outer.Level.GetHostageMgr());
	m_iHostageTestAnimIndex += increment;
	if ( m_iHostageTestAnimIndex == mgr.GetAnimInfoSize() )
	{
		Log("TestHostageAnim: index = 0");
		m_iHostageTestAnimIndex=0;
	}
	HP();
}

exec function HLA ()
{
	local AnimInfo AnimInfo;
	local R6HostageMgr mgr;
	local int i;

	if (  !CanExec() )
	{
		return;
	}
	mgr=R6HostageMgr(Outer.Level.GetHostageMgr());
	i=0;
JL0037:
	if ( i < mgr.GetAnimInfoSize() )
	{
//		AnimInfo=mgr.GetAnimInfo(i);
		Log("" $ string(i) $ ": " $ string(AnimInfo.m_name) $ " rate: " $ string(AnimInfo.m_fRate) $ " play type: " $ string(AnimInfo.m_ePlayType));
		i++;
		goto JL0037;
	}
	Log("  total hostage anim: " $ string(mgr.GetAnimInfoSize()));
}

exec function HP (optional bool bLoop)
{
	local R6Hostage H;
	local R6HostageAI AI;
	local AnimInfo AnimInfo;
	local bool bFound;

	if (  !CanExec() )
	{
		return;
	}
	bFound=False;
	InitTestHostageAnim();
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		AI=R6HostageAI(H.Controller);
		if (  !bFound )
		{
//			AnimInfo=AI.m_mgr.GetAnimInfo(m_iHostageTestAnimIndex);
			Log("play anim: " $ string(AnimInfo.m_name) $ " rate: " $ string(AnimInfo.m_fRate) $ " play type: " $ string(AnimInfo.m_ePlayType) $ " (" $ string(m_iHostageTestAnimIndex) $ "/" $ string(AI.m_mgr.GetAnimInfoSize()) $ ")");
			bFound=True;
		}
		H.R6LoopAnim('None',1.00);
		if ( bLoop )
		{
			H.R6LoopAnim(AnimInfo.m_name,AnimInfo.m_fRate);
		}
		else
		{
			H.R6PlayAnim(AnimInfo.m_name,AnimInfo.m_fRate);
		}
	}
}

exec function HNA ()
{
	if (  !CanExec() )
	{
		return;
	}
	HostageSetAnimIndex(1);
}

exec function HPA ()
{
	if (  !CanExec() )
	{
		return;
	}
	HostageSetAnimIndex(-1);
}

exec function HSA (int Index)
{
	if (  !CanExec() )
	{
		return;
	}
	m_iHostageTestAnimIndex=Index;
	HostageSetAnimIndex(0);
}

exec function dbgActor ()
{
	local Actor A;
	local int Num;

	if (  !CanExec() )
	{
		return;
	}
	Log("-- ALL ACTOR DUMP --");
	foreach Outer.AllActors(Class'Actor',A)
	{
		Log(string(A.Name) $ " current state :  " $ string(A.GetStateName()));
		Log("   position....................: " $ string(A.Location));
		Log("   bCollideActor, bCollideWorld: " $ string(A.bCollideActors) $ ", " $ string(A.bCollideWorld));
		Log("   bBlockActors, bProjTarget...: " $ string(A.bBlockActors) $ ", " $ string(A.bProjTarget));
		Log("   collision radius, height....: " $ string(A.CollisionRadius) $ ", " $ string(A.CollisionHeight));
		Num++;
	}
	Log("   " $ string(Num) $ " actors");
}

function LogRainbow (R6Rainbow rb)
{
	LogR6Pawn(rb);
	Log("   m_bSlideEnd..........: " $ string(rb.m_bSlideEnd));
	Log("   m_bMovingDiagonally..: " $ Left(string(rb.m_bMovingDiagonally),5));
	Log("   m_rRotationOffset....: " $ string(rb.m_rRotationOffset));
	Log("   R6 Bone Rotation.....: " $ string(rb.GetBoneRotation('R6')));
	Log("   Pelvis  Rotation.....: " $ string(rb.GetBoneRotation('R6 Pelvis')));
}

function LogIOBomb (R6IOBomb bomb)
{
	Log("IOBomb: " $ string(bomb));
	Log("  m_bIsActivated..: " $ string(bomb.m_bIsActivated));
	Log("  CanToggle().....: " $ string(bomb.CanToggle()));
	Log("  m_bExploded.....: " $ string(bomb.m_bExploded));
	Log("  m_fTimeLeft.....: " $ string(bomb.m_fTimeLeft));
	Log("  m_fRepTimeLeft..: " $ string(bomb.m_fRepTimeLeft));
	Log("  GetTimeLeft()...: " $ string(bomb.GetTimeLeft()));
}

function LogTerro (R6Terrorist t)
{
	local R6TerroristAI AI;
	local string szTemp;

	AI=R6TerroristAI(t.Controller);
	LogR6Pawn(t);
	Log(" -- Terrorist info --");
	Log("   Used Template........: " $ t.m_szUsedTemplate);
	Log("   m_DZone..............: " $ string(t.m_DZone.Name));
	if ( t.m_HeadAttachment != None )
	{
		Log("   Attachment mesh......: " $ string(t.m_HeadAttachment.StaticMesh.Name));
	}
	else
	{
		Log("   Attachment mesh......: None");
	}
	switch (t.m_ePersonality)
	{
/*		case 0:
		szTemp="PERSO_Coward";
		break;
		case 1:
		szTemp="PERSO_DeskJockey";
		break;
		case 2:
		szTemp="PERSO_Normal";
		break;
		case 3:
		szTemp="PERSO_Hardened";
		break;
		case 4:
		szTemp="PERSO_SuicideBomber";
		break;
		case 5:
		szTemp="PERSO_Sniper";
		break;
		default:
		szTemp="Unknown";
		break;    */
	}
	Log("   Personality..........: " $ szTemp $ " (" $ string(t.m_ePersonality) $ ")");
	Log("   FiringStartPoint.....: " $ string(t.GetFiringStartPoint()));
	Log("   FiringDirection......: " $ string(t.GetFiringRotation()));
	Log("   Group ID.............: " $ string(t.m_iGroupID));
	Log("   Current attack team..: " $ string(AI.m_iCurrentGroupID));
	switch (t.m_ePlayerIsUsingHands)
	{
/*		case 0:
		szTemp="None";
		break;
		case 1:
		szTemp="Right";
		break;
		case 2:
		szTemp="Left";
		break;
		case 3:
		szTemp="Both";
		break;
		default:
		szTemp="Unknown";
		break;     */
	}
	Log("   PlayerIsUsingHands...: " $ szTemp $ " (" $ string(t.m_ePlayerIsUsingHands) $ ")");
	Log("    Assault.............: " $ string(t.m_fSkillAssault * 100) $ ",    Demolitions.........: " $ string(t.m_fSkillDemolitions * 100));
	Log("    Electronics.........: " $ string(t.m_fSkillElectronics * 100) $ ",    SSniper.............: " $ string(t.m_fSkillSniper * 100));
	Log("    Stealth.............: " $ string(t.m_fSkillStealth * 100) $ ",    SelfControl.........: " $ string(t.m_fSkillSelfControl * 100));
	Log("    Leadership..........: " $ string(t.m_fSkillLeadership * 100) $ ",    Observation.........: " $ string(t.m_fSkillObservation * 100));
	Log("     Skills modifier.....: " $ string(t.SkillModifier()));
	Log("   m_bAllowLeave........: " $ Left(string(t.m_bAllowLeave),4) $ ",   m_bHaveAGrenade......: " $ Left(string(t.m_bHaveAGrenade),4));
	if ( AI != None )
	{
		Log("  -See and Hear variable:-");
		switch (AI.m_eReactionStatus)
		{
/*			case 0:
			szTemp="HearAndSeeAll";
			break;
			case 1:
			szTemp="SeeHostage";
			break;
			case 2:
			szTemp="HearBullet";
			break;
			case 3:
			szTemp="SeeRainbow";
			break;
			case 4:
			szTemp="Grenade";
			break;
			case 5:
			szTemp="HearAndSeeNothing";
			break;
			default:
			szTemp="Unknown";
			break;     */
		}
		Log("   ReactionState........: " $ szTemp $ " (" $ string(AI.m_eReactionStatus) $ ")");
		Log("   SeePlayer............: " $ Left(string( !t.m_bDontSeePlayer),4) $ ",   HearPlayer...........: " $ Left(string( !t.m_bDontHearPlayer),4));
		Log("   m_eStateForEvent.....: " $ Left(string(AI.m_eStateForEvent),4));
		Log("   m_bHearInvestigate...: " $ Left(string(AI.m_bHearInvestigate),4) $ ",   m_bSeeHostage........: " $ Left(string(AI.m_bSeeHostage),4));
		Log("   m_bHearThreat........: " $ Left(string(AI.m_bHearThreat),4) $ ",   m_bSeeRainbow........: " $ Left(string(AI.m_bSeeRainbow),4));
		Log("   m_bHearGrenade.......: " $ Left(string(AI.m_bHearGrenade),4));
		Log("   m_eStrategy..........: " $ Left(string(t.m_eStrategy),4));
	}
}

exec function dbgRainbow ()
{
	local R6Rainbow rb;
	local int Num;

	if (  !CanExec() )
	{
		return;
	}
	Log("-- ALL RAINBOW DUMP --");
	foreach Outer.AllActors(Class'R6Rainbow',rb)
	{
		LogRainbow(rb);
		Num++;
	}
	Log("   " $ string(Num) $ " rainbow");
}

exec function dbgTerro ()
{
	local R6Terrorist t;
	local int Num;

	if (  !CanExec() )
	{
		return;
	}
	Log("-- ALL TERRO DUMP --");
	foreach Outer.AllActors(Class'R6Terrorist',t)
	{
		LogTerro(t);
		Num++;
	}
	Log("   " $ string(Num) $ " terrorists");
}

exec function SetPawn ()
{
	local Actor anActor;

	if (  !CanExec() )
	{
		return;
	}
	anActor=GetPointedActor(False,True);
	if ( R6Pawn(anActor) != None )
	{
		m_curPawn=R6Pawn(anActor);
		Outer.Player.Console.Message("ESCORTED: " $ string(m_curPawn.Controller.Name),6.00);
	}
	else
	{
		m_curPawn=None;
	}
}

exec function string SetPawnPace (int i, optional bool bHelp)
{
	local string Text;

	if (  !CanExec() )
	{
		return "";
	}
	if ( bHelp )
	{
		return "Set m_eMovementPace 0=none 1=prone 2=crouchwalk 3=crouchrun 4=walk 5=run";
	}
	if ( m_curPawn == None )
	{
		Outer.Player.Console.Message("no pawn",6.00);
	}
	switch (i)
	{
/*		case 0:
		m_curPawn.m_eMovementPace=m_curPawn.0;
		Text="none";
		break;
		case 1:
		m_curPawn.m_eMovementPace=m_curPawn.1;
		Text="prone";
		break;
		case 2:
		m_curPawn.m_eMovementPace=m_curPawn.2;
		Text="crouchwalk";
		break;
		case 3:
		m_curPawn.m_eMovementPace=m_curPawn.3;
		Text="crouchrun";
		break;
		case 4:
		m_curPawn.m_eMovementPace=m_curPawn.4;
		Text="walk";
		break;
		case 5:
		m_curPawn.m_eMovementPace=m_curPawn.5;
		Text="run";
		break;
		default:   */
	}
	Outer.Player.Console.Message("eMovementPace=" $ Text,6.00);
	return "";
}

exec function SeeCurPawn ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( m_curPawn == None )
	{
		return;
	}
	if ( Outer.CanSee(m_curPawn) )
	{
		Log("SeePawn: success");
	}
	else
	{
		Log("SeePawn: fail");
	}
}

exec function UsePath (int i)
{
	local eMovementPace ePace;

	if (  !CanExec() )
	{
		return;
	}
	if ( m_curPawn == None )
	{
		Outer.Player.Console.Message("no pawn",6.00);
		return;
	}
	Outer.Player.Console.Message("Use path",6.00);
	if ( i == 1 )
	{
		if ( m_curPawn.bIsCrouched )
		{
//			ePace=m_curPawn.3;
		}
		else
		{
//			ePace=m_curPawn.5;
		}
	}
	else
	{
		if ( m_curPawn.bIsCrouched )
		{
//			ePace=m_curPawn.2;
		}
		else
		{
//			ePace=m_curPawn.4;
		}
	}
//	R6AIController(m_curPawn.Controller).SetStateTestMakePath(Outer.Pawn,ePace);
}

exec function CanWalk ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( m_curPawn == None )
	{
		Outer.Player.Console.Message("no pawn",6.00);
		return;
	}
	if ( R6AIController(m_curPawn.Controller).CanWalkTo(Outer.Pawn.Location,True) )
	{
		Outer.Player.Console.Message("CanWalkTo: true",6.00);
		Log("CanWalkTo: true");
	}
	else
	{
		Outer.Player.Console.Message("CanWalkTo: false",6.00);
		Log("CanWalkTo: false");
	}
}

exec function TestFindPathToMe ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( m_curPawn == None )
	{
		Outer.Player.Console.Message("no pawn",6.00);
		return;
	}
	if ( R6AIController(m_curPawn.Controller).FindPathToward(Outer.Pawn,True) == None )
	{
		Outer.Player.Console.Message("FindPathToward: failed",6.00);
	}
	else
	{
		Outer.Player.Console.Message("FindPathToward: ok",6.00);
	}
	if ( R6AIController(m_curPawn.Controller).FindPathTo(Outer.Pawn.Location,True) == None )
	{
		Outer.Player.Console.Message("FindPathTo: failed",6.00);
	}
	else
	{
		Outer.Player.Console.Message("FindPathTo: ok",6.00);
	}
}

exec function MoveEscort ()
{
	local Vector vHit;

	if (  !CanExec() )
	{
		return;
	}
	if ( m_curPawn == None )
	{
		Outer.Player.Console.Message("no pawn",6.00);
		return;
	}
	if ( R6Hostage(m_curPawn) != None )
	{
		GetPointedActor(False,True,vHit);
		vHit.Z += m_curPawn.CollisionHeight / 2;
		R6HostageAI(m_curPawn.Controller).SetStateEscorted(R6Pawn(Outer.Pawn),vHit,False);
		if ( R6Hostage(m_curPawn).m_bEscorted )
		{
			Outer.Player.Console.Message("MOVE ESCORT",6.00);
		}
	}
	Outer.Player.Console.Message("MOVE FAILED",6.00);
}

exec function SetPState (name stateToGo)
{
	if ( m_curPawn == None )
	{
		return;
	}
	if (  !CanExec() )
	{
		return;
	}
	m_curPawn.GotoState(stateToGo);
}

exec function SetCState (name stateToGo)
{
	if ( m_curPawn == None )
	{
		return;
	}
	if (  !CanExec() )
	{
		return;
	}
	m_curPawn.GotoState(stateToGo);
}

exec function SetHPos (int iPos)
{
	local EStartingPosition ePos;

	if (  !CanExec() )
	{
		return;
	}
	if ( R6Hostage(m_curPawn) == None )
	{
		return;
	}
	switch (iPos)
	{
/*		case 1:
		ePos=1;
		break;
		case 2:
		ePos=2;
		break;
		case 3:
		ePos=3;
		break;
		case 4:
		ePos=4;
		break;
		case 5:
		ePos=5;
		break;
		default:
		ePos=0;    */
	}
//	R6HostageAI(m_curPawn.Controller).SetPawnPosition(ePos);
}

exec function SetHRoll (int iRoll)
{
	local R6Hostage H;

	if (  !CanExec() )
	{
		return;
	}
	if ( iRoll == 0 )
	{
		Outer.Player.Console.Message("Roll disable ",6.00);
	}
	else
	{
		Outer.Player.Console.Message("Roll: " $ string(iRoll),6.00);
	}
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		R6HostageAI(H.Controller).m_bDbgRoll=iRoll != 0;
		R6HostageAI(H.Controller).m_iDbgRoll=iRoll;
		Log("SetHRoll:" $ string(R6HostageAI(H.Controller).m_bDbgRoll) $ " iRoll: " $ string(R6HostageAI(H.Controller).m_iDbgRoll));
	}
}

exec function DesignSF (float NewSpeedFactor)
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_fDesignerSpeedFactor=NewSpeedFactor;
}

exec function DesignJF (float NewJumpFactor)
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_fDesignerJumpFactor=NewJumpFactor;
}

exec function SetShake (bool bSet)
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_bShakeActive=bSet;
}

exec function DesignMaxRand (int NewMax)
{
	local R6Pawn CurrentPawn;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Pawn',CurrentPawn)
	{
		CurrentPawn.m_iDesignRandomTweak=NewMax;
	}
}

exec function DesignArmor (int Light, int Medium, int Heavy)
{
	local R6Pawn CurrentPawn;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Pawn',CurrentPawn)
	{
		CurrentPawn.m_iDesignLightTweak=Light;
		CurrentPawn.m_iDesignMediumTweak=Medium;
		CurrentPawn.m_iDesignHeavyTweak=Heavy;
	}
}

exec function DesignToggleLog ()
{
	local R6Pawn CurrentPawn;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Pawn',CurrentPawn)
	{
		CurrentPawn.m_bDesignToggleLog= !CurrentPawn.m_bDesignToggleLog;
	}
}

exec function DesignHBS (float fRange)
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Pawn.EngineWeapon.SetHeartBeatRange(fRange);
}

exec function hHelp ()
{
	if (  !CanExec() )
	{
		return;
	}
	Log("Hostage / Civ Debugger");
	Log("======================");
	Log("  hReset.......: reset current hostage ptr");
	Log("  hLog.........: log hostage");
	Log("  hCiv.........: set to civilian");
	Log("  hHostage.....: set to hostage 0=Stand 1=Kneel");
	Log("  hPos.........: set position: 0=Stand, 1=Kneel, 2=Prone, 3=Foetus, 4=Crouch, 5=Random");
	Log("  hReact.......: react (Civ: 0=CivProne, 1=CivRunTowardRainbow, 2=CivRunForCover");
	Log("  hReact.......: react (hostage: anim index from 0 to 2 ");
	Log("  hFreeze......: go freeze");
	Log("  hHurt........: set health to hurt ");
	Log("  hWalkAnim....: set walk anim: 0=default 1=scared");
	Log("  hGre.........: play grenade reaction anim: 0=reset 1=blinded 2=gas");
}

function hDebugLog (string sz)
{
	Log("hDebug: " $ sz);
}

exec function hReset ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_Hostage=None;
}

exec function hLog ()
{
	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	LogHostage(m_Hostage);
}

exec function bool hInit ()
{
	local int iClosest;
	local R6Hostage H;
	local R6Hostage hostage;

	if (  !CanExec() )
	{
		return False;
	}
	if ( m_Hostage != None )
	{
		return True;
	}
	iClosest=999999;
	hostage=None;
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		if ( VSize(Outer.Pawn.Location - H.Location) < iClosest )
		{
			iClosest=VSize(Outer.Pawn.Location - H.Location);
			hostage=H;
		}
	}
	if ( hostage == None )
	{
		Outer.Player.Console.Message("no hostage found",6.00);
		return False;
	}
	Outer.Player.Console.Message("found: " $ string(hostage.Name),6.00);
	m_Hostage=hostage;
	m_Hostage.m_controller.m_bDbgIgnoreThreat=True;
	m_Hostage.m_controller.m_bDbgIgnoreRainbow=True;
	return True;
}

exec function hCiv ()
{
	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	hDebugLog("CivInit");
	m_Hostage.m_controller.CivInit();
}

exec function hHostage (int iPos)
{
	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	if ( iPos == 1 )
	{
		hDebugLog("Hostage: kneel");
//		m_Hostage.m_controller.SetStateGuarded(1,m_Hostage.m_mgr.9);
	}
	else
	{
		hDebugLog("Hostage: standing");
//		m_Hostage.m_controller.SetStateGuarded(0,m_Hostage.m_mgr.9);
	}
}

exec function hPos (int iPos)
{
	local EStartingPosition ePos;

	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	switch (iPos)
	{
/*		case 1:
		ePos=1;
		hDebugLog("SetPawnPosition: kneeling");
		break;
		case 2:
		ePos=2;
		hDebugLog("SetPawnPosition: prone");
		break;
		case 3:
		ePos=3;
		hDebugLog("SetPawnPosition: foetus");
		break;
		case 4:
		ePos=4;
		hDebugLog("SetPawnPosition: crouch");
		break;
		case 5:
		ePos=5;
		hDebugLog("SetPawnPosition: random");
		break;
		default:
		ePos=0;
		hDebugLog("SetPawnPosition: standing");   */
	}
//	m_Hostage.m_controller.SetPawnPosition(ePos);
}

exec function hGre (int iGrenade)
{
	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	switch (iGrenade)
	{
/*		case 1:
		m_Hostage.PlayBlinded();
		break;
		case 2:
		m_Hostage.PlayCoughing();
		break;
		default:
		m_Hostage.EndOfGrenadeEffect(Outer.Pawn.2);   */
	}
}

exec function hReact (int iReact)
{
	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	if ( m_Hostage.m_controller.IsInState('Civilian') )
	{
		m_Hostage.m_controller.m_threatInfo.m_pawn=Outer.Pawn;
		if ( iReact == 1 )
		{
			hDebugLog("CivRunTowardRainbow");
			m_Hostage.m_controller.GotoState('CivRunTowardRainbow');
		}
		else
		{
			if ( iReact == 2 )
			{
				hDebugLog("CivRunForCover");
				m_Hostage.m_controller.GotoState('CivRunForCover');
			}
			else
			{
				hDebugLog("CivProne");
				m_Hostage.m_controller.GotoState('CivProne');
			}
		}
	}
	else
	{
		if ( m_Hostage.isStandingHandUp() )
		{
			if ( iReact == 1 )
			{
				hDebugLog("ANIM_eStandHandUpReact02");
				m_Hostage.SetAnimInfo(m_Hostage.m_controller.m_mgr.ANIM_eStandHandUpReact02);
			}
			else
			{
				if ( iReact == 2 )
				{
					hDebugLog("ANIM_eStandHandUpReact03");
					m_Hostage.SetAnimInfo(m_Hostage.m_controller.m_mgr.ANIM_eStandHandUpReact03);
				}
				else
				{
					hDebugLog("ANIM_eStandHandUpReact01");
					m_Hostage.SetAnimInfo(m_Hostage.m_controller.m_mgr.ANIM_eStandHandUpReact01);
				}
			}
		}
		else
		{
			if ( m_Hostage.m_ePosition == 1 )
			{
				if ( iReact == 1 )
				{
					hDebugLog("ANIM_eKneelReact02");
					m_Hostage.SetAnimInfo(m_Hostage.m_controller.m_mgr.ANIM_eKneelReact02);
				}
				else
				{
					if ( iReact == 2 )
					{
						hDebugLog("ANIM_eKneelReact03");
						m_Hostage.SetAnimInfo(m_Hostage.m_controller.m_mgr.ANIM_eKneelReact03);
					}
					else
					{
						hDebugLog("ANIM_eKneelReact01");
						m_Hostage.SetAnimInfo(m_Hostage.m_controller.m_mgr.ANIM_eKneelReact01);
					}
				}
			}
			else
			{
				Outer.Player.Console.Message("can't play react",6.00);
			}
		}
	}
}

exec function hFreeze ()
{
	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	if ( m_Hostage.isStandingHandUp() || (m_Hostage.m_ePosition == 1) )
	{
		hDebugLog("State: Guarded_frozen");
		m_Hostage.m_controller.GotoState('Guarded_frozen');
	}
	else
	{
		Outer.Player.Console.Message("can't go freeze",6.00);
	}
}

exec function hHurt ()
{
	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	m_Hostage.m_eHealth=HEALTH_Wounded;
	hWalkAnim(1);
}

exec function hWalkAnim (int i)
{
	if (  !CanExec() )
	{
		return;
	}
	if (  !hInit() )
	{
		return;
	}
	if ( i == 1 )
	{
//		m_Hostage.SetStandWalkingAnim(m_Hostage.1,True);
	}
	else
	{
//		m_Hostage.SetStandWalkingAnim(m_Hostage.0,True);
	}
}

simulated function DrawRoute (R6AIController r6con, Canvas Canvas)
{
	local int i;
	local Vector vTemp;

	if (  !CanExec() )
	{
		return;
	}
	if ( r6con.RouteCache[0] != None )
	{
		i=1;
JL002A:
		if ( (i < 16) && (r6con.RouteCache[i] != None) )
		{
			Canvas.Draw3DLine(r6con.RouteCache[i - 1].Location,r6con.RouteCache[i].Location,Class'Canvas'.static.MakeColor(255,255,0));
			i++;
			goto JL002A;
		}
	}
	if ( r6con.Destination != vect(0.00,0.00,0.00) )
	{
		Canvas.Draw3DLine(r6con.Pawn.Location,r6con.Destination,class'Canvas'.static.MakeColor(255,255,255));
	}
	if ( r6con.Focus != None )
	{
		vTemp=r6con.Focus.Location;
	}
	else
	{
		vTemp=r6con.FocalPoint;
	}
	Canvas.Draw3DLine(r6con.Pawn.Location + r6con.Pawn.EyePosition(),vTemp,class'Canvas'.static.MakeColor(255,0,0));
}

exec function RotateMe (name BoneName, int Pitch, int Yaw, int Roll, float InTime)
{
	local Rotator rOffset;

	if (  !CanExec() )
	{
		return;
	}
	rOffset.Pitch=Pitch;
	rOffset.Yaw=Yaw;
	rOffset.Roll=Roll;
	R6Pawn(Outer.Pawn).SetBoneRotation(BoneName,rOffset,,1.00,InTime);
	Log("RotateMe" $ string(BoneName));
}

exec function ResetMeAll ()
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).ResetBoneRotation();
	R6Pawn(Outer.Pawn).SetBoneRotation('R6 Head',rot(0,0,0),,1.00,0.40);
	R6Pawn(Outer.Pawn).SetBoneRotation('R6 Neck',rot(0,0,0),,1.00,0.40);
	R6Pawn(Outer.Pawn).SetBoneRotation('R6 Spine',rot(0,0,0),,1.00,0.40);
	R6Pawn(Outer.Pawn).SetBoneRotation('R6 Spine1',rot(0,0,0),,1.00,0.40);
	R6Pawn(Outer.Pawn).SetBoneRotation('R6 Pelvis',rot(0,0,0),,1.00,0.40);
}

exec function toggleNav ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bEnableNavDebug= !m_bEnableNavDebug;
	Outer.Player.Console.Message("EnableNavPointDebug = " $ string(m_bEnableNavDebug),6.00);
	if ( m_bEnableNavDebug )
	{
		ToggleRadius();
	}
}

function processNavDebug (Canvas C)
{
	local Actor Path;
	local bool bFound;
	local string szName;
	local int i;
	local Vector vLoc;

	if (  !CanExec() )
	{
		return;
	}
	if ( (Outer.Pawn == None) || (Outer.Pawn.Physics != 1) )
	{
		return;
	}
	Path=Outer.FindRandomDest(True);
	if ( Path == None )
	{
		i=0;
JL006C:
		if ( i < m_aNavPointLocation.Length )
		{
			vLoc=m_aNavPointLocation[i];
			if ( Outer.FastTrace(vLoc,Outer.Pawn.Location) && (VSize(Outer.Pawn.Location - vLoc) < m_fNavPointDistance) )
			{
				bFound=True;
			}
			else
			{
				++i;
				goto JL006C;
			}
		}
		if (  !bFound )
		{
			m_aNavPointLocation[m_iCurNavPoint]=Outer.Pawn.Location;
			szName="Need NavPoint: " $ string(m_iCurNavPoint);
			Outer.Pawn.DbgVectorAdd(Outer.Pawn.Location,vect(40.00,40.00,80.00),10 + m_iCurNavPoint,szName);
			Log(szName);
			Outer.Player.Console.Message("**** " $ szName,10.00);
			m_iCurNavPoint++;
		}
	}
}

exec function KillThemAll ()
{
	local R6Pawn P;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Pawn',P)
	{
		if (  !P.m_bIsPlayer )
		{
			P.ServerForceKillResult(4);
			P.R6TakeDamage(1000,1000,Outer.Pawn,P.Location,vect(0.00,0.00,0.00),0);
		}
	}
}

exec function dbgPeek ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bTogglePeek= !m_bTogglePeek;
	Outer.Player.Console.Message("DbgPeek = " $ string(m_bTogglePeek),6.00);
}

function processDebugPeek (Canvas Canvas)
{
	local int YPos;
	local int YL;
	local R6Pawn P;
	local string szPeek;
	local Rotator rRotator;

	if ( (Outer.Pawn == None) || (Outer.Pawn.Physics != 1) )
	{
		return;
	}
	Canvas.SetDrawColor(0,255,0);
	P=R6Pawn(Outer.ViewTarget);
	YPos=350;
	YL=10;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("IsPeeking:  " $ string(P.IsPeeking()) $ " Left: " $ string(P.IsPeekingLeft()));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_fCrouchBlendRate= " $ string(P.m_fCrouchBlendRate));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   GetPeekingRate()= " $ string(P.GetPeekingRate()));
	YPos += YL;
	if ( P.m_ePeekingMode == 2 )
	{
		szPeek="fluid";
	}
	else
	{
		if ( P.m_ePeekingMode == 1 )
		{
			szPeek="full";
		}
	}
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_ePeekingMode= " $ szPeek);
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_fPeekingGoal= " $ string(P.m_fPeekingGoal));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_fPeeking= " $ string(P.m_fPeeking));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_fLastValidPeeking= " $ string(P.m_fLastValidPeeking));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_bPeekingReturnToCenter= " $ string(P.m_bPeekingReturnToCenter));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   bIsCrouched= " $ string(P.bIsCrouched));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   PrepivotZ= " $ string(P.PrePivot.Z));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   PrePivotProneBackupZ= " $ string(P.m_vPrePivotProneBackup.Z));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	rRotator=P.GetBoneRotation('R6');
	Canvas.DrawText("   r6 bone y= " $ string(rRotator.Yaw) $ " p=" $ string(rRotator.Pitch));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_rRotationOffset= " $ string(P.m_rRotationOffset));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_bPostureTransition= " $ string(P.m_bPostureTransition));
	YPos += YL;
	Canvas.SetPos(4.00,YPos);
	Canvas.DrawText("   m_bPeekLeft= " $ string(R6PlayerController(Outer.Pawn.Controller).m_bPeekLeft) $ " m_bPeekRight=" $ string(R6PlayerController(Outer.Pawn.Controller).m_bPeekRight));
	YPos += YL;
}

exec function resetThreat ()
{
	local R6HostageAI AI;
	local R6Hostage H;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		AI=R6HostageAI(H.Controller);
//		AI.m_threatInfo=AI.m_mgr.getDefaulThreatInfo();
	}
}

exec function toggleThreatInfo ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bToggleThreatInfo= !m_bToggleThreatInfo;
}

function processThreatInfo (Canvas Canvas)
{
	local int YPos;
	local int YL;
	local R6Pawn P;
	local R6HostageAI AI;
	local R6Hostage H;

	Canvas.SetDrawColor(0,255,0);
	YPos=100;
	YL=16;
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		AI=R6HostageAI(H.Controller);
		Canvas.SetPos(4.00,YPos);
//		Canvas.DrawText("" $ string(AI) $ " " $ AI.m_mgr.GetThreatInfoLog(AI.m_threatInfo));
		YPos += YL;
	}
}

function processDebugPG (Canvas Canvas)
{
	local int YPos;
	local int YL;
	local R6Pawn P;
	local R6HostageAI AI;
	local R6Hostage H;

	if ( Outer.Pawn == None )
	{
		return;
	}
	Canvas.SetDrawColor(0,255,0);
	P=R6Pawn(Outer.Pawn);
	YPos=300;
	YL=16;
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		AI=R6HostageAI(H.Controller);
		Canvas.SetPos(4.00,YPos);
//		Canvas.DrawText("" $ string(AI) $ " " $ AI.m_mgr.GetThreatInfoLog(AI.m_threatInfo));
		YPos += YL;
	}
}

exec function sgi (int iLevel)
{
	if (  !CanExec() )
	{
		return;
	}
	ShowGameInfo(iLevel);
}

exec function ShowGameInfo (int iLevel)
{
	if (  !CanExec() )
	{
		return;
	}
	m_bToggleGameInfo= !m_bToggleGameInfo;
	m_iGameInfoLevel=iLevel;
}

function displayMissionObjective (int iVerbose, Canvas C, int YL, int XPos, out int YPos, out int iLine, R6MissionObjectiveBase Mo, out int iSubGroup)
{
	local int i;
	local int iSubLine;
	local string szIndent;
	local string szDesc;
	local string szDescID;
	local bool bDisplay;
	local bool bDisplayFailure;

	if ( iSubGroup > 0 )
	{
		szIndent="   (" $ string(iSubGroup) $ ") ";
	}
	else
	{
		szIndent="   ";
	}
	if ( iVerbose >= 1 )
	{
		if ( Mo.m_bVisibleInMenu )
		{
			bDisplay=True;
			if ( Mo.m_szDescriptionInMenu == "" )
			{
				szDesc="warning: m_szDescriptionInMenu is empty";
			}
			else
			{
				szDesc="" $ Mo.m_szDescriptionInMenu $ "= " $ Localize("Game",Mo.m_szDescriptionInMenu,Outer.Level.GetMissionObjLocFile(Mo));
			}
		}
	}
	else
	{
		bDisplay=True;
		szDesc=Mo.getDescription();
	}
	if ( bDisplay )
	{
		C.SetPos(XPos,YPos);
		if ( Mo.isCompleted() )
		{
			C.SetDrawColor(0,255,0);
			C.DrawText("" $ szIndent $ "" $ string(iLine) $ "- " $ szDesc $ " : completed");
		}
		else
		{
			if ( Mo.isFailed() )
			{
				C.SetDrawColor(255,0,0);
				C.DrawText("" $ szIndent $ "" $ string(iLine) $ "- " $ szDesc $ " : failed");
			}
			else
			{
				C.SetDrawColor(255,255,255);
				C.DrawText("" $ szIndent $ "" $ string(iLine) $ "- " $ szDesc);
			}
		}
		YPos += YL;
	}
	if ( iVerbose >= 2 )
	{
		C.SetPos(XPos,YPos);
		if ( Mo.m_szDescriptionFailure != "" )
		{
			C.SetDrawColor(0,255,0);
			C.DrawText("" $ szIndent $ "" $ string(iLine) $ " (" $ Mo.m_szDescriptionFailure $ "= " $ Localize("Game",Mo.m_szDescriptionFailure,Outer.Level.GetMissionObjLocFile(Mo)) $ ")");
			YPos += YL;
			bDisplay=True;
		}
	}
	if ( bDisplay )
	{
		++iLine;
	}
	if ( Mo.GetNumSubMission() > 0 )
	{
		iSubGroup++;
		i=0;
JL036C:
		if ( i < Mo.GetNumSubMission() )
		{
			iSubLine=i + 1;
			displayMissionObjective(iVerbose,C,YL,XPos,YPos,iSubLine,Mo.GetSubMissionObjective(i),iSubGroup);
			++i;
			goto JL036C;
		}
	}
}

function displayGameInfo (Canvas C)
{
	local int XPos;
	local int YPos;
	local int YL;
	local R6MissionObjectiveMgr moMgr;
	local int i;
	local int iLine;
	local bool bMoralityObj;
	local int iSubGroup;
	local int iDiffLevel;

	YPos=90;
	XPos=10;
	YL=13;
	C.Font=C.MedFont;
	C.SetPos(XPos,YPos);
	C.DrawText("GameMode = " $ Outer.Level.GetGameTypeClassName(R6AbstractGameInfo(Outer.Level.Game).m_eGameTypeFlag) $ " m_bGameOver=" $ string(R6AbstractGameInfo(Outer.Level.Game).m_bGameOver));
	YPos += YL;
	iDiffLevel=-1;
	if ( R6AbstractGameInfo(Outer.Level.Game) != None )
	{
		iDiffLevel=R6AbstractGameInfo(Outer.Level.Game).m_iDiffLevel;
	}
	else
	{
		if ( Outer.GameReplicationInfo != None )
		{
			iDiffLevel=R6GameReplicationInfo(Outer.GameReplicationInfo).m_iDiffLevel;
		}
	}
	if ( iDiffLevel != -1 )
	{
		C.SetPos(XPos,YPos);
		switch (iDiffLevel)
		{
/*			case 1:
			C.DrawText("Diffilculty level: recruit ");
			break;
			case 2:
			C.DrawText("Diffilculty level: veteran ");
			break;
			case 3:
			C.DrawText("Diffilculty level: elite");
			break;
			default:
			C.DrawText("Diffilculty level: unknown");  */
		}
		YPos += YL;
	}
	moMgr=R6AbstractGameInfo(Outer.Level.Game).m_missionMgr;
	if ( moMgr == None )
	{
		return;
	}
	if ( moMgr.m_eMissionObjectiveStatus == 1 )
	{
		C.SetDrawColor(0,255,0);
		C.SetPos(XPos,YPos);
		C.DrawText("-- MISSION OBJECTIVE: COMPLETED");
		YPos += YL;
	}
	else
	{
		if ( moMgr.m_eMissionObjectiveStatus == 2 )
		{
			C.SetDrawColor(255,0,0);
			C.SetPos(XPos,YPos);
			C.DrawText("-- MISSION OBJECTIVE: FAILED");
			YPos += YL;
		}
		else
		{
			C.SetDrawColor(255,255,255);
			C.SetPos(XPos,YPos);
			C.DrawText("-- MISSION OBJECTIVE: in progress ");
			YPos += YL;
		}
	}
	i=0;
JL0425:
	if ( i < moMgr.m_aMissionObjectives.Length )
	{
		if (  !moMgr.m_aMissionObjectives[i].m_bMoralityObjective )
		{
			iSubGroup=0;
			displayMissionObjective(m_iGameInfoLevel,C,YL,XPos,YPos,iLine,moMgr.m_aMissionObjectives[i],iSubGroup);
		}
		else
		{
			bMoralityObj=True;
		}
		++i;
		goto JL0425;
	}
	if ( bMoralityObj )
	{
		C.SetDrawColor(255,255,255);
		C.SetPos(XPos,YPos);
		C.DrawText("-- MISSION OBJECTIVE: morality ");
		YPos += YL;
	}
	iLine=0;
	i=0;
JL053C:
	if ( i < moMgr.m_aMissionObjectives.Length )
	{
		if ( moMgr.m_aMissionObjectives[i].m_bMoralityObjective )
		{
			displayMissionObjective(m_iGameInfoLevel,C,YL,XPos,YPos,iLine,moMgr.m_aMissionObjectives[i],iSubGroup);
		}
		++i;
		goto JL053C;
	}
}

exec function RendPawnState ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bRendPawnState= !m_bRendPawnState;
	Outer.Player.Console.Message("RendPawnState " $ string(m_bRendPawnState),6.00);
}

exec function RendFocus ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bRendFocus= !m_bRendFocus;
	Outer.Player.Console.Message("RendFocus " $ string(m_bRendFocus),6.00);
}

exec function SetRoundTime (int iSec)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( R6Pawn(Outer.Pawn) == None )
	{
		return;
	}
	R6Pawn(Outer.Pawn).ServerSetRoundTime(iSec);
}

exec function SetBetTime (int iSec)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( R6Pawn(Outer.Pawn) == None )
	{
		return;
	}
	R6Pawn(Outer.Pawn).ServerSetBetTime(iSec);
}

exec function ToggleCollision ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("ToggleCollision",6.00);
	R6Pawn(Outer.Pawn).ServerToggleCollision();
}

exec function TestGetFrame ()
{
	local R6Pawn P;

	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("TestGetFrame",6.00);
	Log("*** was skeleton updated *** ");
	foreach Outer.AllActors(Class'R6Pawn',P)
	{
		if ( P.WasSkeletonUpdated() )
		{
			Log(string(P.Name) $ " yes ");
		}
		else
		{
			Log(string(P.Name) $ " no ");
		}
	}
}

exec function CheckFrienship ()
{
	local Pawn p1;
	local Pawn p2;

	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("CheckFrienship",6.00);
	Log(" Check Friend/Enemy and Neutral relationship");
	foreach Outer.AllActors(Class'Pawn',p1)
	{
		foreach Outer.AllActors(Class'Pawn',p2)
		{
			if ( p1 == p2 )
			{
				if ( p1.IsEnemy(p2) )
				{
					Log("warning: " $ string(p1.Name) $ " is enemy with himself   m_iTeam=" $ string(p1.m_iTeam));
				}
				continue;
			}
			else
			{
				if ( p1.IsFriend(p2) && p1.IsEnemy(p2) )
				{
					Log("warning: " $ string(p1.Name) $ " is friend and enemy with " $ string(p2.Name) $ " m_iTeamA=" $ string(p1.m_iTeam) $ " m_iTeamB=" $ string(p2.m_iTeam));
				}
				if ( p1.IsFriend(p2) && p2.IsEnemy(p1) )
				{
					Log("warning: " $ string(p1.Name) $ " is friend with " $ string(p2.Name) $ ", and B consider A enemy    m_iTeamA=" $ string(p1.m_iTeam) $ " m_iTeamB=" $ string(p2.m_iTeam));
				}
			}
		}
	}
}

exec function LogFriendlyFire ()
{
	local R6Pawn p1;
	local bool bAI;

	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("LogFriendlyFire",6.00);
	Log("LOGGING FriendlyFire");
	foreach Outer.AllActors(Class'R6Pawn',p1)
	{
		bAI=p1.Controller.IsA('AIController');
		Log(string(p1.Name) $ " AI Controller=" $ string(bAI));
		Log("    m_bCanFireFriends =" $ string(p1.m_bCanFireFriends));
		Log("    m_bCanFireNeutrals=" $ string(p1.m_bCanFireNeutrals));
	}
}

exec function LogFriendship (optional bool bCheckIfAlive)
{
	local Pawn p1;
	local Pawn p2;
	local int iFriends;
	local int iEnemy;
	local int iNeutrals;

	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("LogFrienship bCheckIfAlive=" $ string(bCheckIfAlive),6.00);
	Log("LOGGING FRIENSHIP bCheckIfAlive=" $ string(bCheckIfAlive));
	foreach Outer.AllActors(Class'Pawn',p1)
	{
		if ( bCheckIfAlive &&  !p1.IsAlive() )
		{
			continue;
		}
		else
		{
			iEnemy=0;
			iFriends=0;
			iNeutrals=0;
			Log("" $ string(p1.Name) $ "(team=" $ string(p1.m_iTeam) $ ") is friend with: ");
			foreach Outer.AllActors(Class'Pawn',p2)
			{
				if ( p1 == p2 )
				{
					continue;
				}
				else
				{
					if ( p1.IsFriend(p2) )
					{
						if (  !bCheckIfAlive || bCheckIfAlive && p2.IsAlive() )
						{
							iFriends++;
							Log("   " $ string(p2.Name) $ "(team=" $ string(p2.m_iTeam) $ ")");
						}
					}
				}
			}
			Log("  is enemy with: ");
			foreach Outer.AllActors(Class'Pawn',p2)
			{
				if ( p1 == p2 )
				{
					continue;
				}
				else
				{
					if ( p1.IsEnemy(p2) )
					{
						if (  !bCheckIfAlive || bCheckIfAlive && p2.IsAlive() )
						{
							iEnemy++;
							Log("   " $ string(p2.Name) $ "(team=" $ string(p2.m_iTeam) $ ")");
						}
					}
				}
			}
			Log("   is neutral with: ");
			foreach Outer.AllActors(Class'Pawn',p2)
			{
				if ( p1 == p2 )
				{
					continue;
				}
				else
				{
					if ( p1.IsNeutral(p2) )
					{
						if (  !bCheckIfAlive || bCheckIfAlive && p2.IsAlive() )
						{
							iNeutrals++;
							Log("   " $ string(p2.Name) $ "(team=" $ string(p2.m_iTeam) $ ")");
						}
					}
				}
			}
			Log("-- Total friends= " $ string(iFriends) $ " Enemy=" $ string(iEnemy) $ " Neutrals=" $ string(iNeutrals));
		}
	}
}

exec function ToggleMissionLog ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_bToggleMissionLog= !m_bToggleMissionLog;
	R6AbstractGameInfo(Outer.Level.Game).m_missionMgr.ToggleLog(m_bToggleMissionLog);
	Outer.Player.Console.Message("ToggleMissionLog =" $ string(m_bToggleMissionLog),6.00);
}

exec function listzone ()
{
	local R6AbstractInsertionZone aZone;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6AbstractInsertionZone',aZone)
	{
		Outer.logX("R6AbstractInsertionZone: " $ string(aZone));
	}
}

function ListActors (Class<Actor> ClassName, optional bool bNumber, optional int iFrom, optional int iMax)
{
	local int i;
	local Actor aActor;

	if ( iMax == 0 )
	{
		iMax=99999;
	}
	foreach Outer.AllActors(ClassName,aActor)
	{
		i++;
		if ( (i >= iFrom) && (i <= iMax) )
		{
			if ( bNumber )
			{
				Log("  " $ string(i) $ "- " $ string(aActor.Name));
			}
			else
			{
				Log("" $ string(aActor.Name));
			}
		}
	}
}

exec function GetNbTerro ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("Number of terro=" $ string(GetActorsNb(Class'R6Terrorist',True)),6.00);
}

exec function GetNbHostage ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("Number of hostage=" $ string(GetActorsNb(Class'R6Hostage',True)),6.00);
}

exec function GetNbRainbow ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("Number of rainbow=" $ string(GetActorsNb(Class'R6Rainbow',True)),6.00);
}

function int GetActorsNb (Class<Actor> ClassName, optional bool bNoLog)
{
	local int i;
	local Actor aActor;

	foreach Outer.AllActors(ClassName,aActor)
	{
		i++;
	}
	if (  !bNoLog )
	{
		Log(" total= " $ string(i));
	}
	return i;
}

exec function logActReset ()
{
	if (  !CanExec() )
	{
		return;
	}
	m_iCounterLog=0;
	m_iCounterLogMax=GetActorsNb(Class'Actor',True);
}

exec function logAct (int iNb, optional bool bNumber)
{
	if (  !CanExec() )
	{
		return;
	}
	ListActors(Class'Actor',bNumber,m_iCounterLog,m_iCounterLog + iNb);
	m_iCounterLog += iNb;
	if ( m_iCounterLog >= m_iCounterLogMax )
	{
		Log(" total= " $ string(GetActorsNb(Class'Actor',True)));
	}
}

exec function ListEscort ()
{
	local R6Rainbow R;
	local int i;
	local name szFollow;

	if (  !CanExec() )
	{
		return;
	}
	Log("List Escorted Hostages");
	Log("======================");
	foreach Outer.AllActors(Class'R6Rainbow',R)
	{
		if ( R.m_aEscortedHostage[0] == None )
		{
			continue;
		}
		else
		{
			Log("Rainbow= " $ string(R.Name));
JL0093:
			if ( (i < 4) && (R.m_aEscortedHostage[i] != None) )
			{
				if ( R.m_aEscortedHostage[i].m_controller.m_pawnToFollow == None )
				{
					szFollow='None';
				}
				else
				{
					szFollow=R.m_aEscortedHostage[i].m_controller.m_pawnToFollow.Name;
				}
				Log("   " $ string(R.m_aEscortedHostage[i].Name) $ " follows " $ string(szFollow));
				if ( R != R.m_aEscortedHostage[i].m_escortedByRainbow )
				{
					Log("    Warning: wrong owner=" $ string(R.m_aEscortedHostage[i].m_escortedByRainbow.Name));
				}
				++i;
				goto JL0093;
			}
		}
	}
}

exec function DbgPlayerStates ()
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.GameReplicationInfo.m_bShowPlayerStates= !Outer.GameReplicationInfo.m_bShowPlayerStates;
	Outer.Player.Console.Message("DbgPlayerStates = " $ string(Outer.GameReplicationInfo.m_bShowPlayerStates),6.00);
}

exec function ForceKillResult (int iKillResult)
{
	if (  !CanExec() )
	{
		return;
	}
	Log("New Force Kill = " $ string(iKillResult));
	R6Pawn(Outer.Pawn).ServerForceKillResult(iKillResult);
}

exec function ForceStunResult (int iStunResult)
{
	if (  !CanExec() )
	{
		return;
	}
	Log("New Force Stun = " $ string(iStunResult));
	R6Pawn(Outer.Pawn).ServerForceStunResult(iStunResult);
}

exec function CallDebug ()
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).UpdateSpectatorReticule();
}

exec function shaketime (float fTime)
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_fShakeTime=fTime;
}

exec function MaxShake (float f)
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_fMaxShake=f;
}

exec function MaxShakeTime (float f)
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_fMaxShakeTime=f;
	R6PlayerController(Outer.Pawn.Controller).m_fCurrentShake=0.00;
}

exec function PlayDare (string SoundName)
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.PlaySound(Sound(DynamicLoadObject(SoundName,Class'Sound')));
}

exec function ResetRainbow ()
{
	if (  !CanExec() )
	{
		return;
	}
	if ( Outer.Pawn.m_ePawnType == 1 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_TeamManager.ResetRainbowTeam();
	}
}

exec function HitValue (int iWhich, float fValue)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( iWhich == 1 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactHit.iBlurIntensity=fValue;
	}
	if ( iWhich == 2 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactHit.fReturnTime=fValue;
	}
	if ( iWhich == 3 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactHit.fRollMax=fValue;
	}
	if ( iWhich == 4 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactHit.fRollSpeed=fValue;
	}
	if ( iWhich == 5 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactHit.fWaveTime=fValue;
	}
	Log("New Hit Value = Blur:" $ string(R6PlayerController(Outer.Pawn.Controller).m_stImpactHit.iBlurIntensity) $ " Return Time:" $ string(R6PlayerController(Outer.Pawn.Controller).m_stImpactHit.fReturnTime));
}

exec function StunValue (int iWhich, float fValue)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( iWhich == 1 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactStun.iBlurIntensity=fValue;
	}
	if ( iWhich == 2 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactStun.fReturnTime=fValue;
	}
	if ( iWhich == 3 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactStun.fRollMax=fValue;
	}
	if ( iWhich == 4 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactStun.fRollSpeed=fValue;
	}
	if ( iWhich == 5 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactStun.fWaveTime=fValue;
	}
	Log("New Stun Value: = Blur:" $ string(R6PlayerController(Outer.Pawn.Controller).m_stImpactStun.iBlurIntensity) $ " Return Time:" $ string(R6PlayerController(Outer.Pawn.Controller).m_stImpactStun.fReturnTime));
}

exec function DazedValue (int iWhich, float fValue)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( iWhich == 1 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactDazed.iBlurIntensity=fValue;
	}
	if ( iWhich == 2 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactDazed.fReturnTime=fValue;
	}
	if ( iWhich == 3 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactDazed.fRollMax=fValue;
	}
	if ( iWhich == 4 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactDazed.fRollSpeed=fValue;
	}
	if ( iWhich == 5 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactDazed.fWaveTime=fValue;
	}
	Log("New Dazed Value: = Blur:" $ string(R6PlayerController(Outer.Pawn.Controller).m_stImpactDazed.iBlurIntensity) $ " Return Time:" $ string(R6PlayerController(Outer.Pawn.Controller).m_stImpactDazed.fReturnTime));
}

exec function KOValue (int iWhich, float fValue)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( iWhich == 1 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactKO.iBlurIntensity=fValue;
	}
	if ( iWhich == 2 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactKO.fReturnTime=fValue;
	}
	if ( iWhich == 3 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactKO.fRollMax=fValue;
	}
	if ( iWhich == 4 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactKO.fRollSpeed=fValue;
	}
	if ( iWhich == 5 )
	{
		R6PlayerController(Outer.Pawn.Controller).m_stImpactKO.fWaveTime=fValue;
	}
	Log("New KO Value: = Blur:" $ string(R6PlayerController(Outer.Pawn.Controller).m_stImpactKO.iBlurIntensity) $ " Return Time:" $ string(R6PlayerController(Outer.Pawn.Controller).m_stImpactKO.fReturnTime));
}

exec function r6walk (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fWalkingSpeed=speed;
}

exec function r6walkbackstrafe (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fWalkingBackwardStrafeSpeed=speed;
}

exec function r6run (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fRunningSpeed=speed;
}

exec function r6runbackstrafe (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fRunningBackwardStrafeSpeed=speed;
}

exec function r6cwalk (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fCrouchedWalkingSpeed=speed;
}

exec function r6cwalkbackstrafe (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fCrouchedWalkingBackwardStrafeSpeed=speed;
}

exec function r6crun (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fCrouchedRunningSpeed=speed;
}

exec function r6crunbackstrafe (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fCrouchedRunningBackwardStrafeSpeed=speed;
}

exec function r6prone (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).m_fProneSpeed=speed;
}

exec function R6Ladder (float speed)
{
	if (  !CanExec() )
	{
		return;
	}
	R6Pawn(Outer.Pawn).LadderSpeed=speed;
}

exec function Armor (int armorType)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( armorType == 0 )
	{
//		R6Pawn(Outer.Pawn).m_eArmorType=1;
		R6Pawn(Outer.Pawn).ClientMessage("Armor Class is now Light");
	}
	else
	{
		if ( armorType == 1 )
		{
//			R6Pawn(Outer.Pawn).m_eArmorType=2;
			R6Pawn(Outer.Pawn).ClientMessage("Armor Class is now Medium");
		}
		else
		{
//			R6Pawn(Outer.Pawn).m_eArmorType=3;
			R6Pawn(Outer.Pawn).ClientMessage("Armor Class is now Heavy");
		}
	}
}

exec function GetNetMode ()
{
	switch (Outer.Level.NetMode)
	{
/*		case 0:
		Log(string(self) $ " is NM_Standalone");
		break;
		case 1:
		Log(string(self) $ " is NM_DedicatedServer");
		break;
		case 2:
		Log(string(self) $ " is NM_ListenServer");
		break;
		case 3:
		Log(string(self) $ " is NM_Client");
		break;
		default:
		Log(string(self) $ " is other");
		break;  */
	}
}

exec function UpdateBones ()
{
	if (  !CanExec() )
	{
		return;
	}
}

exec function R6FixCamera ()
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_bFixCamera=True;
}

exec function R6FreeCamera ()
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).m_bFixCamera=False;
}

exec function LogBandWidth (bool bLogBandWidth)
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Level.m_bLogBandWidth=bLogBandWidth;
	R6PlayerController(Outer.Pawn.Controller).ServerLogBandWidth(bLogBandWidth);
}

exec function NetLogServer ()
{
	local Actor ActorIterator;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'Actor',ActorIterator)
	{
		if ( ActorIterator.m_bLogNetTraffic == True )
		{
			R6PlayerController(Outer.Pawn.Controller).ServerNetLogActor(ActorIterator);
		}
	}
}

exec function LogActors ()
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).DoLogActors();
	if ( Outer.Level.NetMode != 0 )
	{
		R6PlayerController(Outer.Pawn.Controller).ServerLogActors();
	}
}

exec function Gwigre ()
{
	Outer.Player.Console.Message("Quoi?  Le projet est déjà fini?  Marie, je vais avoir congé",10.00);
	Outer.Player.Console.Message("samedi et dimanche!  C'était long, mais c'était bon :)",10.00);
	Outer.Player.Console.Message("Ne soyez pas trop dur avec mes terroristes, c'est la",10.00);
	Outer.Player.Console.Message("faute au game design s'ils sont méchants.",10.00);
	Outer.Player.Console.Message("                     - Gwigre",10.00);
}

exec function Azimut ()
{
	Outer.Player.Console.Message("//*********************************************\\",10.00);
	Outer.Player.Console.Message("Pround [NDG] member, owning with style since 1975",10.00);
	Outer.Player.Console.Message("\\****************** Azimut + Tap *************//",10.00);
}

exec function Arsenic ()
{
	Outer.Player.Console.Message("= Dormir longtemps, se reposer, aller au cinema",10.00);
	Outer.Player.Console.Message("= This is some of the stuff that I didn't have",10.00);
	Outer.Player.Console.Message("= time to do since a while.",10.00);
	Outer.Player.Console.Message("= ",10.00);
	Outer.Player.Console.Message("= Enjoy the game we've been working on for 2 years!",10.00);
	Outer.Player.Console.Message("= At the moment i'm writing those lines, we",10.00);
	Outer.Player.Console.Message("= will have our master very soon",10.00);
	Outer.Player.Console.Message("= Here few stuff that help me to support the",10.00);
	Outer.Player.Console.Message("= last few months rush:",10.00);
	Outer.Player.Console.Message("= Formula Dé board game, HBO Band of Brother,",10.00);
	Outer.Player.Console.Message("= friends, family, Tokyo Bar and Boreale",10.00);
	Outer.Player.Console.Message("= Eric Out! - January 31st, 2003",10.00);
}

function DoWalk (Pawn aPawn)
{
	if (  !CanExec() )
	{
		return;
	}
	R6PlayerController(Outer.Pawn.Controller).bCheatFlying=False;
	aPawn.UnderWaterTime=aPawn.Default.UnderWaterTime;
	aPawn.SetCollision(True,True,True);
	aPawn.SetPhysics(PHYS_Walking);
	aPawn.bCollideWorld=True;
	R6PlayerController(Outer.Pawn.Controller).ClientReStart();
}

function DoGhost (Pawn aPawn)
{
	if (  !CanExec() )
	{
		return;
	}
	aPawn.UnderWaterTime=-1.00;
	R6PlayerController(Outer.Pawn.Controller).ClientMessage("You feel ethereal");
	aPawn.SetCollision(False,False,False);
	aPawn.bCollideWorld=False;
	R6PlayerController(Outer.Pawn.Controller).bCheatFlying=True;
	R6PlayerController(Outer.Pawn.Controller).GotoState('PlayerFlying');
	R6PlayerController(Outer.Pawn.Controller).ClientGotoState('PlayerFlying','None');
}

exec function Ghost ()
{
	R6PlayerController(Outer.Pawn.Controller).ServerGhost(Outer.Pawn);
}

exec function CompleteMission ()
{
	R6PlayerController(Outer.Pawn.Controller).ServerCompleteMission();
}

exec function AbortMission ()
{
	R6PlayerController(Outer.Pawn.Controller).ServerAbortMission();
}

exec function Walk ()
{
	R6PlayerController(Outer.Pawn.Controller).ServerWalk(Outer.Pawn);
}

exec function pago (int i)
{
	local R6TerroristAI terroAI;
	local bool bCanExec;

	bCanExec=CanExec();
	if ( bCanExec )
	{
		Outer.ConsoleCommand("FullAmmo");
		if ( i == 0 )
		{
			i=500;
		}
		foreach Outer.DynamicActors(Class'R6TerroristAI',terroAI)
		{
			terroAI.m_huntedPawn=R6Pawn(Outer.Pawn);
//			R6Terrorist(terroAI.Pawn).m_eStrategy=3;
			if ( terroAI.CanSafelyChangeState() )
			{
				if ( Rand(2) == 1 )
				{
					terroAI.Pawn.Velocity=vect(0.00,0.00,0.00);
					terroAI.Pawn.Velocity.Z=300.00 + Rand(i);
					terroAI.Pawn.Acceleration=vect(0.00,0.00,0.00);
					terroAI.Pawn.SetPhysics(PHYS_Falling);
					terroAI.Pawn.bNoJumpAdjust=True;
					terroAI.Pawn.Controller.SetFall();
				}
				else
				{
					terroAI.GotoStateNoThreat();
				}
			}
		}
		regroupHostages();
	}
	Outer.Player.Console.Message("bonjour, thanks for playing raven shield.",10.00);
	Outer.Player.Console.Message("salutation à ma famille, kathery&martin, caroline, falko, lisa, marianne, marty, nicolas, philippe, thomas",10.00);
	Outer.Player.Console.Message("merci d'exister :-)",10.00);
	Outer.Player.Console.Message(" - patrick garon (janvier 2003)",10.00);
	Outer.Player.Console.Message("[rs was made while listening to radiohead, u2, rem, sigur rós, the strokes, cold play, doves, new order]",10.00);
	if ( bCanExec )
	{
		Outer.Player.Console.Message("now run... you only have one life and one jimbo...",10.00);
	}
}

exec function Alkoliq ()
{
	Outer.Player.Console.Message("Hi there! Hope you like the game and maybe we'll meet on-line",10.00);
	Outer.Player.Console.Message("Aux membres de l'équipe Raven Shield, on a réussit, Vous êtes la meilleure équipe!",10.00);
	Outer.Player.Console.Message("I would like to say thanks to Maggie for her support and patience. I love you!",10.00);
	Outer.Player.Console.Message("Merci aussi à mon chat Kleenex, pour me rappeller que je dois retourner chez moi de temps en temps.",10.00);
	Outer.Player.Console.Message("Special Thanks to An-Hoa for all the cakes she gave us during this project",10.00);
	Outer.Player.Console.Message("   ",10.00);
	Outer.Player.Console.Message("Now go and play!!!  Let The Bodies Hit The Floor!",10.00);
	Outer.Player.Console.Message(" >>>> Joel Tremblay (Alkoliq) Janvier 2003 <<<< ",10.00);
}

exec function RainbowSkill (float fMul)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( fMul <= 0.00 )
	{
		fMul=1.00;
	}
	Outer.Level.m_fRainbowSkillMultiplier=fMul;
	Outer.Player.Console.Message("Rainbow skill multiplier set to " $ string(Outer.Level.m_fRainbowSkillMultiplier),6.00);
}

exec function TerroSkill (float fMul)
{
	if (  !CanExec() )
	{
		return;
	}
	if ( fMul <= 0.00 )
	{
		fMul=1.00;
	}
	Outer.Level.m_fTerroSkillMultiplier=fMul;
	Outer.Player.Console.Message("Terrorist skill multiplier set to " $ string(Outer.Level.m_fTerroSkillMultiplier),6.00);
}

exec function deks ()
{
	Outer.Player.Console.Message("Here's deks daily program:",10.00);
	Outer.Player.Console.Message("    - read www.flipcode.com",10.00);
	Outer.Player.Console.Message("    - listen to nofx, lagwagon, nfaa & nufan",10.00);
	Outer.Player.Console.Message("    - drink around 10 diet pepsi cans",10.00);
	Outer.Player.Console.Message("    - think about Emilie...",10.00);
}

exec function ShowSkill (float fMul)
{
	if (  !CanExec() )
	{
		return;
	}
	Outer.Player.Console.Message("Rainbow skill multiplier set to " $ string(Outer.Level.m_fRainbowSkillMultiplier),6.00);
	Outer.Player.Console.Message("Terrorist skill multiplier set to " $ string(Outer.Level.m_fTerroSkillMultiplier),6.00);
}

exec function regroupHostages ()
{
	local int Num;
	local R6Hostage H;

	if (  !CanExec() )
	{
		return;
	}
	foreach Outer.AllActors(Class'R6Hostage',H)
	{
		if ( H.m_controller != None )
		{
			H.m_controller.Order_GotoExtraction(Outer.Pawn);
			Outer.Player.Console.Message(string(H.Name) $ " is regrouping on me",6.00);
		}
	}
}

exec function Thor ()
{
	Outer.Player.Console.Message("En espérant que vous appréciez... les menus!",10.00);
	Outer.Player.Console.Message("Remerciements à toute l'équipe prog de RS...",10.00);
	Outer.Player.Console.Message("Une pensée pour Valérie, pour ma famille... et oui c'est moi, vous me reconnaissez?",10.00);
	Outer.Player.Console.Message("Thor -- janvier 2003, déjà?!!!",10.00);
	Outer.Player.Console.Message("Pour Azimut : '2 pixels à droite, 2 pixels à droite...' :)",10.00);
}

exec function FullAmmo ()
{
	local int iWeaponIndex;

	if (  !CanExec() )
	{
		return;
	}
	iWeaponIndex=0;
JL0014:
	if ( iWeaponIndex < 4 )
	{
		R6AbstractWeapon(R6Pawn(Outer.Pawn).m_WeaponsCarried[iWeaponIndex]).FullAmmo();
		iWeaponIndex++;
		goto JL0014;
	}
}

defaultproperties
{
    m_bFirstPersonPlayerView=True
    m_fNavPointDistance=1200.00
}
