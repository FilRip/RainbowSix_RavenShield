//================================================================================
// R6SoundVolume.
//================================================================================
class R6SoundVolume extends Volume
	Native;

var(R6Sound) ESoundSlot m_eSoundSlot;
var(R6Sound) array<Sound> m_EntrySound;
var(R6Sound) array<Sound> m_ExitSound;

simulated event Touch (Actor Other)
{
	local int iSoundIndex;
	local Controller C;
	local bool bMissionPack;

	Super.Touch(Other);
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
		C.m_CurrentVolumeSound=self;
		C.m_bUseExitSounds=False;
		if ( (PlayerController(C) != None) && (Viewport(PlayerController(C).Player) != None) )
		{
			bMissionPack=Class'Actor'.static.GetModMgr().IsMissionPack();
			if (  !bMissionPack )
			{
				iSoundIndex=0;
JL00FA:
				if ( iSoundIndex < m_EntrySound.Length )
				{
					PlaySound(m_EntrySound[iSoundIndex],m_eSoundSlot);
					iSoundIndex++;
					goto JL00FA;
				}
			}
			else
			{
				iSoundIndex=0;
JL0131:
				if ( iSoundIndex < m_EntrySound.Length )
				{
					if ( m_bPlayOnlyOnce )
					{
						if (  !m_bSoundWasPlayed )
						{
							PlaySound(m_EntrySound[iSoundIndex],m_eSoundSlot);
							m_bSoundWasPlayed=True;
						}
					}
					else
					{
						PlaySound(m_EntrySound[iSoundIndex],m_eSoundSlot);
					}
					iSoundIndex++;
					goto JL0131;
				}
			}
		}
	}
}

simulated event UnTouch (Actor Other)
{
	local int iSoundIndex;
	local Controller C;

	Super.UnTouch(Other);
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
		C.m_CurrentVolumeSound=self;
		C.m_bUseExitSounds=True;
		if ( (PlayerController(C) != None) && (Viewport(PlayerController(C).Player) != None) )
		{
			iSoundIndex=0;
JL00D2:
			if ( iSoundIndex < m_ExitSound.Length )
			{
				PlaySound(m_ExitSound[iSoundIndex],m_eSoundSlot);
				iSoundIndex++;
				goto JL00D2;
			}
		}
	}
}

defaultproperties
{
    m_eSoundSlot=1
    m_b3DSound=False
    m_bSeeThrough=True
}
