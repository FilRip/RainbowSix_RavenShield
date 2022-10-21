//================================================================================
// R6HUD.
//================================================================================
class R6HUD extends R6AbstractHUD
	Native;

enum eTeamState {
	TS_None,
	TS_Waiting,
	TS_Holding,
	TS_Moving,
	TS_Following,
	TS_Regrouping,
	TS_Engaging,
	TS_Sniping,
	TS_LockPicking,
	TS_OpeningDoor,
	TS_ClosingDoor,
	TS_Opening,
	TS_Closing,
	TS_ClearingRoom,
	TS_Grenading,
	TS_DisarmingBomb,
	TS_InteractWithDevice,
	TS_SecuringTerrorist,
	TS_ClimbingLadder,
	TS_WaitingForOrders,
	TS_SettingBreach,
	TS_Retired
};

var EMovementMode m_eLastMovementMode;
var eTeamState m_eLastTeamState;
var eTeamState m_eLastOtherTeamState[2];
var EPlanAction m_eLastPlayerAPAction;
var EGoCode m_eLastGoCode;
var int m_iBulletCount;
var int m_iMaxBulletCount;
var int m_iMagCount;
var int m_iCurrentMag;
var(Debug) bool m_bDrawHUDinScript;
var bool m_bGMIsSinglePlayer;
var bool m_bGMIsCoop;
var bool m_bGMIsTeamAdverserial;
var bool m_bShowCharacterInfo;
var bool m_bShowCurrentTeamInfo;
var bool m_bShowOtherTeamInfo;
var bool m_bShowWeaponInfo;
var bool m_bShowFPWeapon;
var bool m_bShowWaypointInfo;
var bool m_bShowActionIcon;
var bool m_bShowMPRadar;
var bool m_bShowTeamMatesNames;
var bool m_bUpdateHUDInTraining;
var bool m_bDisplayTimeBomb;
var bool m_bDisplayRemainingTime;
var bool m_bNoDeathCamera;
var bool m_bLastSniperHold;
var bool m_bShowPressGoCode;
var bool m_bPressGoCodeCanBlink;
var float m_fPosX;
var float m_fPosY;
var float m_fScaleX;
var float m_fScaleY;
var float m_fScale;
var R6GameReplicationInfo m_GameRepInfo;
var R6PlayerController m_PlayerOwner;
var Texture m_FlashbangFlash;
var Texture m_TexNightVision;
var Texture m_TexHeatVision;
var Material m_TexHeatVisionActor;
var Material m_TexHUDElements;
var Material m_pCurrentMaterial;
var Texture m_HeartBeatMaskMul;
var Texture m_HeartBeatMaskAdd;
var Texture m_Waypoint;
var Texture m_WaypointArrow;
var Texture m_InGamePlanningPawnIcon;
var Texture m_LoadingScreen;
var Texture m_TexNoise;
var Material m_TexProneTrail;
var FinalBlend m_pAlphaBlend;
var Actor m_pNextWayPoint;
var Material m_TexRadarTextures[10];
var R6RainbowTeam m_pLastRainbowTeam;
var array<R6IOBomb> m_aIOBombs;
var Color m_iCurrentTeamColor;
var Color m_CharacterInfoBoxColor;
var Color m_CharacterInfoOutlineColor;
var Color m_WeaponBoxColor;
var Color m_WeaponOutlineColor;
var Color m_TeamBoxColor;
var Color m_TeamBoxOutlineColor;
var Color m_OtherTeamBoxColor;
var Color m_OtherTeamOutlineColor;
var Color m_WPIconBox;
var Color m_WPIconOutlineColor;
var R6HUDState m_HUDElements[16];
var string m_szMovementMode;
var string m_szTeamState;
var string m_szOtherTeamState[2];
var string m_aszOtherTeamName[2];
var string m_szLastPlayerAPAction;
var string m_szPressGoCode;
var string m_szTeam;

native(1605) final function DrawNativeHUD (Canvas C);

native(1609) final function HudStep (int iBox, int iIDStep, optional bool bFlash);

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( Owner == None )
	{
		return;
	}
	m_PlayerOwner=R6PlayerController(Owner);
	if ( Level.NetMode == NM_Standalone )
	{
		m_bDisplayRemainingTime=False;
	}
	m_bUpdateHUDInTraining=True;
	SetTimer(0.25,True);
	StopFadeToBlack();
}

simulated function ResetOriginalData ()
{
	Super.ResetOriginalData();
	m_iCycleHUDLayer=Default.m_iCycleHUDLayer;
	m_bToggleHelmet=Default.m_bToggleHelmet;
	m_bNoDeathCamera=False;
	m_pLastRainbowTeam=None;
	if ( m_bDisplayTimeBomb )
	{
		InitBombTimer(m_bDisplayTimeBomb);
	}
	StopFadeToBlack();
}

function Timer ()
{
	if ( (Level != None) && (m_PlayerOwner != None) && (m_PlayerOwner.GameReplicationInfo != None) && (m_PlayerOwner.GameReplicationInfo.m_bReceivedGameType == 1) )
	{
		m_GameRepInfo=R6GameReplicationInfo(m_PlayerOwner.GameReplicationInfo);
		m_PlayerOwner.HidePlanningActors();
		UpdateHudFilter();
		SetTimer(0.00,False);
	}
}

simulated function InitBombTimer (bool bDisplayTimeBomb)
{
	local R6IOBomb ioBomb;

	m_bDisplayTimeBomb=bDisplayTimeBomb;
	m_aIOBombs.Remove (0,m_aIOBombs.Length);
	if ( m_bDisplayTimeBomb )
	{
		foreach AllActors(Class'R6IOBomb',ioBomb)
		{
			m_aIOBombs[m_aIOBombs.Length]=ioBomb;
		}
	}
}

function UpdateHudFilter ()
{
	local R6GameOptions GameOptions;
	local int iStepCount;
	local bool bDisplayFPWeapon;

	GameOptions=GetGameOptions();
	m_bGMIsSinglePlayer=True;
	bDisplayFPWeapon=GameOptions.HUDShowFPWeapon;
	if ( Level.IsGameTypeMultiplayer(m_PlayerOwner.GameReplicationInfo.m_eGameTypeFlag) )
	{
		m_bGMIsSinglePlayer=False;
		bDisplayFPWeapon=bDisplayFPWeapon || R6GameReplicationInfo(m_PlayerOwner.GameReplicationInfo).m_bFFPWeapon;
	}
	m_bGMIsCoop=Level.IsGameTypeCooperative(m_PlayerOwner.GameReplicationInfo.m_eGameTypeFlag);
	m_bGMIsTeamAdverserial=Level.IsGameTypeTeamAdversarial(m_PlayerOwner.GameReplicationInfo.m_eGameTypeFlag);
	if ( (Level.Game == None) || (Level.Game != None) && (R6GameInfo(Level.Game).GetTrainingMgr(R6Pawn(m_PlayerOwner.Pawn)) == None) )
	{
		m_bShowCharacterInfo=GameOptions.HUDShowCharacterInfo;
		m_bShowCurrentTeamInfo=(m_bGMIsSinglePlayer || m_bGMIsCoop) && GameOptions.HUDShowCurrentTeamInfo;
		m_bShowOtherTeamInfo=m_bGMIsSinglePlayer && GameOptions.HUDShowOtherTeamInfo;
		m_bShowWeaponInfo=GameOptions.HUDShowWeaponInfo;
		m_bShowWaypointInfo=m_bGMIsSinglePlayer && GameOptions.HUDShowWaypointInfo;
		m_PlayerOwner.Set1stWeaponDisplay(bDisplayFPWeapon);
		m_bShowActionIcon=GameOptions.HUDShowActionIcon;
		if ( (m_GameRepInfo.m_iDiffLevel == 1) && (Level.Game != None) )
		{
			if ( (Level.Game.m_eGameTypeFlag == RGM_PracticeMode) || (Level.Game.m_eGameTypeFlag == RGM_StoryMode) )
			{
				m_bShowPressGoCode=True;
				m_bPressGoCodeCanBlink=False;
			}
		}
	}
	else
	{
		m_bShowPressGoCode=True;
		m_bPressGoCodeCanBlink=True;
		if ( m_bUpdateHUDInTraining )
		{
			m_bShowCharacterInfo=True;
			m_bShowCurrentTeamInfo=True;
			m_bShowOtherTeamInfo=True;
			m_bShowWeaponInfo=True;
			m_bShowWaypointInfo=True;
			m_PlayerOwner.Set1stWeaponDisplay(True);
			m_PlayerOwner.m_bHideReticule=False;
			m_bShowActionIcon=True;
			m_bUpdateHUDInTraining=True;
		}
	}
	if ( Level.NetMode == NM_Standalone )
	{
		m_PlayerOwner.m_wAutoAim=GameOptions.AutoTargetSlider;
	}
	else
	{
		m_PlayerOwner.m_wAutoAim=0;
	}
	if ( Level.IsGameTypeDisplayBombTimer(m_PlayerOwner.GameReplicationInfo.m_eGameTypeFlag) )
	{
		InitBombTimer(True);
	}
}

simulated function Tick (float fDelta)
{
	Super.Tick(fDelta);
	m_PlayerOwner=R6PlayerController(Owner);
	if ( (m_PlayerOwner == None) || (m_PlayerOwner.GameReplicationInfo == None) )
	{
		return;
	}
	m_GameRepInfo=R6GameReplicationInfo(m_PlayerOwner.GameReplicationInfo);
}

simulated event PostRender (Canvas C)
{
	if ( m_bDrawHUDinScript )
	{
		C.UseVirtualSize(True);
		Super.PostRender(C);
		if ( m_PlayerOwner != None )
		{
			m_PlayerOwner.PostRender(C);
		}
		C.UseVirtualSize(False);
	}
	else
	{
		Super.PostRender(C);
		if ( m_PlayerOwner != None )
		{
			m_PlayerOwner.PostRender(C);
		}
	}
}

function DrawHUD (Canvas C)
{
	local Vector viewLocation;
	local Rotator ViewRotation;
	local int flashBangCoefficient;
	local R6Pawn aPlayerPawn;

	if ( Level.m_bInGamePlanningActive == True )
	{
		return;
	}
	if ( m_PlayerOwner != None )
	{
		aPlayerPawn=R6Pawn(m_PlayerOwner.Pawn);
	}
	if ( (m_PlayerOwner != None) && (m_PlayerOwner.m_TeamManager != None) )
	{
		if ( R6PlanningInfo(m_PlayerOwner.m_TeamManager.m_TeamPlanning) != None )
		{
			m_pNextWayPoint=R6PlanningInfo(m_PlayerOwner.m_TeamManager.m_TeamPlanning).GetNextActionPoint();
		}
	}
	DrawNativeHUD(C);
	if ( m_PlayerOwner != None )
	{
		if ( m_PlayerOwner.m_InteractionCA != None )
		{
			m_PlayerOwner.m_InteractionCA.m_color=m_iCurrentTeamColor;
		}
		if ( m_PlayerOwner.m_InteractionInventory != None )
		{
			m_PlayerOwner.m_InteractionInventory.m_color=m_iCurrentTeamColor;
		}
	}
	if ( m_bDisplayTimeBomb )
	{
		DisplayBombTimer(C);
	}
}

simulated event PostFadeRender (Canvas Canvas)
{
	if ( m_bDisplayRemainingTime )
	{
		DisplayRemainingTime(Canvas);
	}
	if ( m_bNoDeathCamera )
	{
		DisplayNoDeathCamera(Canvas);
	}
}

function ActivateNoDeathCameraMsg (bool bToggleOn)
{
	m_bNoDeathCamera=bToggleOn;
}

function DisplayNoDeathCamera (Canvas C)
{
	local string szText;
	local float W;
	local float H;
	local float f;

	if ( Level.NetMode == NM_Standalone )
	{
		return;
	}
	if ( (m_GameRepInfo == None) || (m_PlayerOwner == None) )
	{
		return;
	}
/*	if ( m_GameRepInfo.m_eCurrectServerState != m_GameRepInfo.3 )
	{
		return;
	}*/
	if ( (m_GameRepInfo.m_MenuCommunication != None) &&  !m_GameRepInfo.m_MenuCommunication.IsInGame() )
	{
		return;
	}
	C.UseVirtualSize(True,640.00,480.00);
	C.Style=5;
	C.Font=m_FontRainbow6_17pt;
	C.SetDrawColor(255,255,255);
	szText=Localize("Game","NoDeathCamera","R6GameInfo");
	C.TextSize(szText,W,H);
	f=(640.00 - W) / 2;
	if ( f < 0 )
	{
		f=0.00;
	}
	C.SetClip(640.00,480.00);
	C.SetPos(0.00,0.00);
	C.SetPos(f,220.00);
	C.DrawText(szText);
	C.UseVirtualSize(False);
}

function DisplayRemainingTime (Canvas C)
{
	local float fBkpOrigX;
	local float fBkpOrigY;
	local float fPosX;
	local float fPosY;
	local float W;
	local float H;
	local float fDefaultNamePosX;
	local string szTime;

	if ( (m_GameRepInfo == None) || (m_PlayerOwner == None) )
	{
		return;
	}
/*	if (  !m_PlayerOwner.bOnlySpectator || (m_GameRepInfo.m_eCurrectServerState != m_GameRepInfo.3) || m_GameRepInfo.m_bInPostBetweenRoundTime )
	{
		return;
	}*/
	if ( (m_GameRepInfo.m_MenuCommunication != None) &&  !m_GameRepInfo.m_MenuCommunication.IsInGame() )
	{
		return;
	}
	fBkpOrigX=C.OrgX;
	fBkpOrigY=C.OrgY;
	C.OrgX=0.00;
	C.OrgY=0.00;
	C.UseVirtualSize(True,640.00,480.00);
	fDefaultNamePosX=600.00;
	fPosY=394.00;
	C.Style=5;
	C.Font=m_FontRainbow6_14pt;
	C.SetDrawColor(255,255,255);
	szTime=Localize("MPInGame","Round","R6Menu") $ " ";
	C.TextSize(szTime,W,H);
	C.SetPos(fDefaultNamePosX - W,fPosY);
	C.DrawText(szTime);
	C.SetPos(fDefaultNamePosX,fPosY);
	C.DrawText(ConvertIntTimeToString(m_GameRepInfo.GetRoundTime(),True));
	C.UseVirtualSize(False);
	C.SetPos(fBkpOrigX,fBkpOrigY);
}

function DisplayBombTimer (Canvas C)
{
	local int i;
	local int j;
	local float fPosX;
	local float fPosY;
	local float fPosYDelta;
	local float W;
	local float H;
	local float fDefaultNamePosX;
	local string szTime;
	local string szBomb;
	local R6IOBomb pBomb;

	C.UseVirtualSize(True,640.00,480.00);
	fDefaultNamePosX=600.00;
	fPosYDelta=16.00;
	fPosY=380.00;
	C.Style=5;
	C.Font=m_FontRainbow6_14pt;
	i=0;
JL0064:
	if ( i < m_aIOBombs.Length - 1 )
	{
		if ( m_aIOBombs[i].m_bIsActivated )
		{
			j=0;
JL0096:
			if ( j < m_aIOBombs.Length )
			{
				if ( m_aIOBombs[j].m_bIsActivated && (m_aIOBombs[j].GetTimeLeft() < m_aIOBombs[i].GetTimeLeft()) )
				{
					pBomb=m_aIOBombs[i];
					m_aIOBombs[i]=m_aIOBombs[j];
					m_aIOBombs[j]=pBomb;
				}
				++j;
				goto JL0096;
			}
		}
		++i;
		goto JL0064;
	}
	i=m_aIOBombs.Length - 1;
JL014B:
	if ( i >= 0 )
	{
		if ( m_aIOBombs[i].m_bIsActivated )
		{
			if ( m_aIOBombs[i].GetTimeLeft() > 20 )
			{
				C.SetDrawColor(255,255,255);
			}
			else
			{
				if ( m_aIOBombs[i].GetTimeLeft() > 10 )
				{
					C.SetDrawColor(255,255,0);
				}
				else
				{
					C.SetDrawColor(255,0,0);
				}
			}
			szBomb=m_aIOBombs[i].m_szIdentity $ " ";
			C.TextSize(szBomb,W,H);
			C.SetPos(fDefaultNamePosX - W,fPosY);
			C.DrawText(szBomb);
			C.SetPos(fDefaultNamePosX,fPosY);
			C.DrawText(ConvertIntTimeToString(m_aIOBombs[i].GetTimeLeft(),True));
			fPosY -= fPosYDelta;
		}
		--i;
		goto JL014B;
	}
	C.UseVirtualSize(False);
}

function StartFadeToBlack (int iSec, int iPercentageOfBlack)
{
	local Canvas C;
	local int iBlack;
	local float fAlpha;

	C=Class'Actor'.static.GetCanvas();
	if ( C.m_bFading )
	{
		fAlpha=C.m_fFadeCurrentTime / C.m_fFadeTotalTime;
		fAlpha=Clamp(fAlpha,0,1);
		C.m_FadeStartColor.R=C.m_FadeEndColor.R * fAlpha + C.m_FadeStartColor.R * (1.00 - fAlpha);
		C.m_FadeStartColor.G=C.m_FadeEndColor.G * fAlpha + C.m_FadeStartColor.G * (1.00 - fAlpha);
		C.m_FadeStartColor.B=C.m_FadeEndColor.B * fAlpha + C.m_FadeStartColor.B * (1.00 - fAlpha);
	}
	else
	{
		C.m_FadeStartColor=C.MakeColor(255,255,255);
	}
	iBlack=255 * (100 - iPercentageOfBlack) / 100;
	C.m_bFading=True;
	C.m_fFadeCurrentTime=0.00;
	C.m_fFadeTotalTime=iSec;
	C.m_FadeEndColor=C.MakeColor(iBlack,iBlack,iBlack);
	C.m_bFadeAutoStop=False;
}

function StopFadeToBlack ()
{
	local Canvas C;

	C=Class'Actor'.static.GetCanvas();
	C.m_bFading=True;
	C.m_fFadeCurrentTime=0.00;
	C.m_fFadeTotalTime=0.00;
	C.m_FadeStartColor=C.MakeColor(0,0,0);
	C.m_FadeEndColor=C.MakeColor(255,255,255);
	C.m_bFadeAutoStop=True;
}

simulated function Message (PlayerReplicationInfo PRI, coerce string Msg, name MsgType)
{
	if ( (MsgType == 'Console') && (("SAY" == Caps(Left(Msg,Len("Say")))) || ("TEAMSAY" == Caps(Left(Msg,Len("TeamSay"))))) )
	{
		return;
	}
	Super.Message(PRI,Msg,MsgType);
}

simulated function DisplayMessages (Canvas C)
{
	C.SetDrawColor(m_iCurrentTeamColor.R,m_iCurrentTeamColor.G,m_iCurrentTeamColor.B,m_iCurrentTeamColor.A);
	C.Style=5;
	C.Font=m_FontRainbow6_14pt;
	Super.DisplayMessages(C);
}

function SetDefaultFontSettings (Canvas C)
{
	C.SetDrawColor(m_iCurrentTeamColor.R,m_iCurrentTeamColor.G,m_iCurrentTeamColor.B,m_iCurrentTeamColor.A);
	C.Style=5;
	C.Font=m_FontRainbow6_22pt;
}

defaultproperties
{
    m_bDisplayRemainingTime=True
    m_bToggleHelmet=True
}
/*
    m_FlashbangFlash=Texture'Inventory_t.Flash.Flash'
    m_TexNightVision=Texture'Inventory_t.NightVision.NightVisionTex'
    m_TexHeatVision=Texture'Inventory_t.HeatVision.HeatVision'
    m_TexHeatVisionActor=FinalBlend'Inventory_t.HeatVision.HeatVisionActorMat'
    m_TexHUDElements=Texture'R6HUD.HUDElements'
    m_HeartBeatMaskMul=Texture'Inventory_t.HeartBeat.HeartBeatMaskMul'
    m_HeartBeatMaskAdd=Texture'Inventory_t.HeartBeat.HeartBeatMaskAdd'
    m_Waypoint=Texture'R6HUD.WayPoint'
    m_WaypointArrow=Texture'R6HUD.WayPointArrow'
    m_InGamePlanningPawnIcon=Texture'R6Planning.InGamePlanning.PawnIcon'
    m_TexNoise=Texture'Inventory_t.Misc.Noise'
    m_TexRadarTextures(0)=Texture'Inventory_t.Radar.RadarBack'
    m_TexRadarTextures(1)=Texture'Inventory_t.Radar.RadarTop'
    m_TexRadarTextures(2)=Texture'Inventory_t.Radar.RadarOutline'
    m_TexRadarTextures(3)=Texture'Inventory_t.Radar.RadarDead'
    m_TexRadarTextures(4)=Texture'Inventory_t.Radar.RadarSameFloor'
    m_TexRadarTextures(5)=Texture'Inventory_t.Radar.RadarHigherFloor'
    m_TexRadarTextures(6)=Texture'Inventory_t.Radar.RadarLowerFloor'
    m_TexRadarTextures(7)=Texture'Inventory_t.Radar.RadarPilotSameFloor'
    m_TexRadarTextures(8)=Texture'Inventory_t.Radar.RadarPilotHigherFloor'
    m_TexRadarTextures(9)=Texture'Inventory_t.Radar.RadarPilotLowerFloor'
    m_ConsoleBackground=Texture'Inventory_t.Console.ConsoleBack'
*/

