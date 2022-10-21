//================================================================================
// R6InstructionSoundVolume.
//================================================================================
class R6InstructionSoundVolume extends R6SoundVolume
	Native;

const TimeBetweenStep= 15;
var(R6Sound) int m_iBoxNumber;
var int m_iSoundIndex;
var int m_iHudStep;
var int m_IDHudStep;
var int m_fTimerStep;
var bool m_bSoundIsPlaying;
var float m_fTime;
var float m_fTimerSound;
var float m_fTimeHud;
var(R6Sound) Sound m_sndIntructionSoundStop;
var R6TrainingMgr m_TrainingMgr;

native(2732) final function bool UseSound ();

simulated function ResetOriginalData ()
{
	m_bSoundIsPlaying=False;
	m_iSoundIndex=0;
	m_fTime=0.00;
	m_fTimerStep=0;
}

simulated event Touch (Actor Other)
{
	local Controller C;

	if ( Other.IsA('R6Pawn') )
	{
		Other.m_CurrentVolumeSound=self;
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
		if (  !m_bSoundIsPlaying && (PlayerController(C) != None) && (Viewport(PlayerController(C).Player) != None) )
		{
			m_iSoundIndex=0;
			m_TrainingMgr=R6GameInfo(C.Level.Game).GetTrainingMgr(R6Pawn(C.Pawn));
			if (  !R6Console(m_TrainingMgr.m_Player.Player.Console).m_bStartR6GameInProgress )
			{
				R6HUD(m_TrainingMgr.m_Player.myHUD).HudStep(m_iBoxNumber,0);
				ChangeTextAndSound();
			}
		}
	}
}

simulated event UnTouch (Actor Other)
{
	local Controller C;

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
	}
}

function SkipToNextInstruction ()
{
//	PlaySound(m_sndIntructionSoundStop,10);
	for (m_iHudStep=0;m_iHudStep < 4;m_iHudStep++)
	{
		SetHudStep();
		if ( m_IDHudStep != 0 )
		{
			R6HUD(m_TrainingMgr.m_Player.myHUD).HudStep(m_iBoxNumber,m_IDHudStep,False);
		}
	}
	m_iSoundIndex++;
	ChangeTextAndSound();
}

function StopInstruction ()
{
//	PlaySound(m_sndIntructionSoundStop,10);
	R6Console(m_TrainingMgr.m_Player.Player.Console).LaunchInstructionMenu(self,False,0,0);
	m_iSoundIndex=m_EntrySound.Length;
	m_bSoundIsPlaying=False;
}

function ChangeTextAndSound ()
{
	if (  !m_TrainingMgr.CanChangeText(m_iBoxNumber) )
	{
		return;
	}
	if ( m_ExitSound.Length > m_iSoundIndex )
	{
		m_sndIntructionSoundStop=m_ExitSound[m_iSoundIndex];
		if ( m_sndIntructionSoundStop != None )
		{
			m_bUseExitSounds=True;
//			PlaySound(m_sndIntructionSoundStop,10);
		}
	}
	if ( m_EntrySound.Length > m_iSoundIndex )
	{
		m_bUseExitSounds=False;
		m_bSoundIsPlaying=True;
		m_fTimerSound=0.00;
		m_iHudStep=0;
		SetHudStep();
		R6PlayerController(m_TrainingMgr.m_Player).m_bDisplayMessage=True;
//		PlaySound(m_EntrySound[m_iSoundIndex],10);
		R6Console(m_TrainingMgr.m_Player.Player.Console).LaunchInstructionMenu(self,True,m_iBoxNumber,m_iSoundIndex);
		m_TrainingMgr.LaunchAction(m_iBoxNumber,m_iSoundIndex);
	}
	else
	{
		R6PlayerController(m_TrainingMgr.m_Player).m_bDisplayMessage=False;
		R6Console(m_TrainingMgr.m_Player.Player.Console).LaunchInstructionMenu(self,False,0,0);
	}
}

function Tick (float DeltaTime)
{
	Super.Tick(DeltaTime);
	if ( m_bSoundIsPlaying )
	{
		if ( m_fTimeHud > 0 )
		{
			m_fTimerSound += DeltaTime;
			if ( m_fTimerSound > m_fTimeHud )
			{
				R6HUD(m_TrainingMgr.m_Player.myHUD).HudStep(m_iBoxNumber,m_IDHudStep);
				m_iHudStep++;
				SetHudStep();
			}
		}
		m_fTime += DeltaTime;
		if ( m_fTime > 1.00 )
		{
			if ( m_iSoundIndex < m_EntrySound.Length )
			{
				if (  !UseSound() || (m_EntrySound[m_iSoundIndex] == None) )
				{
					if ( m_fTimerStep < 15 )
					{
						m_fTimerStep += 1;
					}
					else
					{
						m_fTimerStep=0;
						ReadyToChangeText();
					}
				}
				else
				{
					if (  !IsPlayingSound(self,m_EntrySound[m_iSoundIndex]) )
					{
						ReadyToChangeText();
					}
				} 
			}
			else
			{
				ReadyToChangeText();
			}
			m_fTime=m_fTime - 1.00;
		}
	}
}

function ReadyToChangeText ()
{
	m_bSoundIsPlaying=False;
	if ( m_TrainingMgr.m_Player.m_CurrentVolumeSound == self )
	{
		m_iSoundIndex++;
		ChangeTextAndSound();
	}
}

function SetHudStep ()
{
	m_fTimeHud=0.00;
	m_IDHudStep=0;
	switch (m_iBoxNumber)
	{
		case 1:
		if ( (m_iSoundIndex == 0) && (m_iHudStep == 0) )
		{
			m_fTimeHud=float(Localize("BasicAreaBox1","HUDStep0","R6Training"));
			m_IDHudStep=1;
		}
		break;
		case 2:
		if ( (m_iSoundIndex == 0) && (m_iHudStep == 0) )
		{
			m_fTimeHud=float(Localize("BasicAreaBox2","HUDStep0","R6Training"));
			m_IDHudStep=2;
		}
		break;
		case 3:
		if ( (m_iSoundIndex == 0) && (m_iHudStep == 0) )
		{
			m_fTimeHud=float(Localize("BasicAreaBox3","HUDStep0","R6Training"));
			m_IDHudStep=3;
		}
		break;
		case 8:
		switch (m_iSoundIndex)
		{
			case 0:
			switch (m_iHudStep)
			{
				case 0:
				m_fTimeHud=float(Localize("ShootingAreaBox1","HUDStep0","R6Training"));
				m_IDHudStep=4;
				break;
				case 1:
				m_fTimeHud=float(Localize("ShootingAreaBox1","HUDStep1","R6Training"));
				m_IDHudStep=5;
				break;
				default:
			}
			break;
			case 1:
			switch (m_iHudStep)
			{
				case 0:
				m_fTimeHud=float(Localize("ShootingAreaBox1","HUDStep2","R6Training"));
				m_IDHudStep=6;
				break;
				case 1:
				m_fTimeHud=float(Localize("ShootingAreaBox1","HUDStep3","R6Training"));
				m_IDHudStep=7;
				break;
				case 2:
				m_fTimeHud=float(Localize("ShootingAreaBox1","HUDStep4","R6Training"));
				m_IDHudStep=8;
				break;
				default:
			}
			break;
			default:
		}
		break;
		case 21:
		if ( m_iSoundIndex == 0 )
		{
			switch (m_iHudStep)
			{
				case 0:
				m_fTimeHud=float(Localize("RoomClearing1Box1","HUDStep0","R6Training"));
				m_IDHudStep=9;
				break;
				case 1:
				m_fTimeHud=float(Localize("RoomClearing1Box1","HUDStep1","R6Training"));
				m_IDHudStep=10;
				break;
				default:
			}
		}
		break;
		case 22:
		switch (m_iSoundIndex)
		{
			case 0:
			switch (m_iHudStep)
			{
				case 0:
				m_fTimeHud=float(Localize("RoomClearing1Box2","HUDStep0","R6Training"));
				m_IDHudStep=11;
				break;
				default:
			}
			break;
			case 1:
			switch (m_iHudStep)
			{
				case 0:
				m_fTimeHud=float(Localize("RoomClearing1Box2","HUDStep1","R6Training"));
				m_IDHudStep=12;
				break;
				case 1:
				m_fTimeHud=float(Localize("RoomClearing1Box2","HUDStep2","R6Training"));
				m_IDHudStep=13;
				break;
				case 2:
				m_fTimeHud=float(Localize("RoomClearing1Box2","HUDStep3","R6Training"));
				m_IDHudStep=14;
				break;
				default:
			}
			break;
			default:
		}
		break;
		case 24:
		if ( (m_iSoundIndex == 0) && (m_iHudStep == 0) )
		{
			m_fTimeHud=float(Localize("RoomClearing2Box1","HUDStep0","R6Training"));
			m_IDHudStep=15;
		}
		break;
		default:
		break;
	}
}

defaultproperties
{
    m_eSoundSlot=10
    bStatic=False
    bNoDelete=False
}
