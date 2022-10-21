//================================================================================
// R6ActorSound.
//================================================================================
class R6ActorSound extends Actor;
//	NoNativeReplication;

var ESoundSlot m_eTypeSound;
var float m_fExplosionDelay;
var Sound m_ImpactSound;
var Sound m_ImpactSoundStop;

replication
{
	reliable if ( Role == Role_Authority )
		m_eTypeSound,m_fExplosionDelay,m_ImpactSound,m_ImpactSoundStop;
}

simulated function Timer ()
{
	if ( m_ImpactSoundStop != None )
	{
		PlaySound(m_ImpactSoundStop,m_eTypeSound);
		m_ImpactSound=m_ImpactSoundStop;
		m_ImpactSoundStop=None;
	}
	else
	{
		if ( IsPlayingSound(self,m_ImpactSound) )
		{
			SetTimer(2.00,False);
		}
		else
		{
			SetTimer(0.00,False);
		}
	}
}

simulated function SpawnSound ()
{
	PlaySound(m_ImpactSound,m_eTypeSound);
	SetTimer(m_fExplosionDelay,False);
}

auto state Startup
{
	simulated function Tick (float DeltaTime)
	{
		if ( Level.NetMode != 1 )
		{
			SpawnSound();
		}
		LifeSpan=m_fExplosionDelay + 10;
		Disable('Tick');
	}
	
}

simulated function FirstPassReset ()
{
	Destroy();
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    DrawType=0
    bHidden=True
    bNetOptional=True
    bAlwaysRelevant=True
    m_bDeleteOnReset=True
    m_fSoundRadiusActivation=5600.00
    Texture=None
}