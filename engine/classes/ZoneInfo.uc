//================================================================================
// ZoneInfo.
//================================================================================
class ZoneInfo extends Info
	Native
	Placeable;

var(ZoneLight) byte AmbientBrightness;
var(ZoneLight) byte AmbientHue;
var(ZoneLight) byte AmbientSaturation;
var(R6Sound) byte m_SoundZone;
var() const bool bFogZone;
var() bool bTerrainZone;
var() bool bDistanceFog;
var() bool bClearToFogColor;
var() bool m_bInDoor;
var bool m_bAlreadyPlayMusic;
var bool m_bAlternateEmittersActive;
var(ZoneLight) float DistanceFogStart;
var(ZoneLight) float DistanceFogEnd;
var(ZoneLight) float TexUPanSpeed;
var(ZoneLight) float TexVPanSpeed;
var SkyZoneInfo SkyZone;
var(ZoneLight) const Texture EnvironmentMap;
var(ZoneSound) editinlineuse I3DL2Listener ZoneEffect;
var(R6Sound) Sound m_SinglePlayerMusic;
var() name ZoneTag;
var const array<TerrainInfo> Terrains;
var(R6Sound) array<Sound> m_StartingSounds;
var(R6Sound) array<Sound> m_EnterSounds;
var(R6Sound) array<Sound> m_ExitSounds;
var(R6Weather) array<Emitter> m_AlternateWeatherEmitters;
var(ZoneLight) Color DistanceFogColor;
var Vector m_vBoundLocation;
var Vector m_vBoundNormal;
var Vector m_vBoundScale;

native(308) final iterator function ZoneActors (Class<Actor> BaseClass, out Actor Actor);

simulated function LinkToSkybox ()
{
	local SkyZoneInfo TempSkyZone;

	foreach AllActors(Class'SkyZoneInfo',TempSkyZone,'None')
	{
		SkyZone=TempSkyZone;
	}
	foreach AllActors(Class'SkyZoneInfo',TempSkyZone,'None')
	{
		if ( TempSkyZone.bHighDetail == Level.bHighDetailMode )
		{
			SkyZone=TempSkyZone;
		}
	}
}

simulated function PreBeginPlay ()
{
	Super.PreBeginPlay();
	LinkToSkybox();
}

simulated function ResetOriginalData ()
{
	if ( m_bResetSystemLog )
	{
		LogResetSystem(False);
	}
	Super.ResetOriginalData();
	m_bAlreadyPlayMusic=False;
}

simulated event ActorEntered (Actor Other)
{
	local int iSoundNb;
	local Controller C;

	if ( Level.m_bPlaySound && (m_EnterSounds.Length != 0) )
	{
		if ( Other.IsA('R6Pawn') )
		{
			C=Pawn(Other).Controller;
		}
		else
		{
			if ( Other.IsA('R6PlayerController') )
			{
				C=Controller(Other);
			}
		}
		if ( C != None )
		{
			C.m_CurrentAmbianceObject=self;
			C.m_bUseExitSounds=False;
			if ( (PlayerController(C) != None) && (Viewport(PlayerController(C).Player) != None) )
			{
				iSoundNb=0;
JL00D7:
				if ( iSoundNb < m_EnterSounds.Length )
				{
					PlaySound(m_EnterSounds[iSoundNb],SLOT_StartingSound);
					iSoundNb++;
					goto JL00D7;
				}
				if ( (Level.NetMode == NM_Standalone) &&  !m_bAlreadyPlayMusic )
				{
					m_bAlreadyPlayMusic=True;
					PlayMusic(m_SinglePlayerMusic);
				}
			}
		}
	}
}

simulated event ActorLeaving (Actor Other)
{
	local int iSoundNb;
	local Controller C;

	if ( Level.m_bPlaySound && (m_ExitSounds.Length != 0) )
	{
		if ( Other.IsA('R6Pawn') )
		{
			C=Pawn(Other).Controller;
		}
		else
		{
			if ( Other.IsA('R6PlayerController') )
			{
				C=Controller(Other);
			}
		}
		if ( C != None )
		{
			C.m_CurrentAmbianceObject=self;
			C.m_bUseExitSounds=True;
			if ( (PlayerController(C) != None) && (Viewport(PlayerController(C).Player) != None) )
			{
				iSoundNb=0;
JL00D7:
				if ( iSoundNb < m_ExitSounds.Length )
				{
					PlaySound(m_ExitSounds[iSoundNb],SLOT_StartingSound);
					iSoundNb++;
					goto JL00D7;
				}
			}
		}
	}
}

defaultproperties
{
    AmbientSaturation=255
    DistanceFogStart=3000.00
    DistanceFogEnd=8000.00
    TexUPanSpeed=1.00
    TexVPanSpeed=1.00
    DistanceFogColor=(R=128,G=128,B=128,A=0)
    bStatic=True
    bNoDelete=True
    m_b3DSound=False
}
/*
    Texture=Texture'S_ZoneInfo'
*/

