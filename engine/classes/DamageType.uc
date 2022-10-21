//================================================================================
// DamageType.
//================================================================================
class DamageType extends Actor
	Native
	Abstract;
//	NoNativeReplication
//	Localized;

var() int DamageDesc;
var() int DamageThreshold;
var() bool bArmorStops;
var() bool bInstantHit;
var() bool bFastInstantHit;
var() float ViewFlash;
var() float GibModifier;
var() float FlashScale;
var() Class<Effects> DamageEffect;
var() Class<Effects> PawnDamageEffect;
var() Class<Emitter> PawnDamageEmitter;
var() Class<Effects> LowGoreDamageEffect;
var() Class<Emitter> LowGoreDamageEmitter;
var() Class<Effects> LowDetailEffect;
var() Class<Emitter> LowDetailEmitter;
var() array<Sound> PawnDamageSounds;
var() array<Sound> LowGoreDamageSounds;
var() Vector ViewFog;
var() Vector FlashFog;
var() Vector DamageKick;
var() localized string DeathString;
var() localized string FemaleSuicide;
var() localized string MaleSuicide;
var() string DamageWeaponName;
const DAMAGE_ArmorKiller= 64;
const DAMAGE_Energy= 32;
const DAMAGE_Explosive= 16;
const DAMAGE_Fatal= 8;
const DAMAGE_Heavy= 4;
const DAMAGE_Medium= 2;
const DAMAGE_Light= 1;
const DAMAGE_None= 0;

static function string DeathMessage (PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
	return Default.DeathString;
}

static function string SuicideMessage (PlayerReplicationInfo Victim)
{
	if ( Victim.bIsFemale )
	{
		return Default.FemaleSuicide;
	}
	else
	{
		return Default.MaleSuicide;
	}
}

static function Class<Effects> GetPawnDamageEffect (Vector HitLocation, float Damage, Vector Momentum, Pawn Victim, bool bLowDetail)
{
	if ( Class'GameInfo'.Default.GoreLevel > 0 )
	{
		if ( Default.LowGoreDamageEffect != None )
		{
			return Default.LowGoreDamageEffect;
		}
		else
		{
			return Victim.LowGoreBlood;
		}
	}
	else
	{
		if ( bLowDetail )
		{
			if ( Default.LowDetailEffect != None )
			{
				return Default.LowDetailEffect;
			}
			else
			{
				return Victim.LowDetailBlood;
			}
		}
		else
		{
			if ( Default.PawnDamageEffect != None )
			{
				return Default.PawnDamageEffect;
			}
			else
			{
				return Victim.BloodEffect;
			}
		}
	}
}

static function Class<Emitter> GetPawnDamageEmitter (Vector HitLocation, float Damage, Vector Momentum, Pawn Victim, bool bLowDetail)
{
	if ( Class'GameInfo'.Default.GoreLevel > 0 )
	{
		if ( Default.LowGoreDamageEmitter != None )
		{
			return Default.LowGoreDamageEmitter;
		}
		else
		{
			return None;
		}
	}
	else
	{
		if ( bLowDetail )
		{
			if ( Default.LowDetailEffect != None )
			{
				return Default.LowDetailEmitter;
			}
			else
			{
				return None;
			}
		}
		else
		{
			if ( Default.PawnDamageEmitter != None )
			{
				return Default.PawnDamageEmitter;
			}
			else
			{
				return None;
			}
		}
	}
}

static function Sound GetPawnDamageSound ()
{
	if ( Class'GameInfo'.Default.GoreLevel > 0 )
	{
		if ( Default.LowGoreDamageSounds.Length > 0 )
		{
			return Default.LowGoreDamageSounds[Rand(Default.LowGoreDamageSounds.Length)];
		}
		else
		{
			return None;
		}
	}
	else
	{
		if ( Default.PawnDamageSounds.Length > 0 )
		{
			return Default.PawnDamageSounds[Rand(Default.PawnDamageSounds.Length)];
		}
		else
		{
			return None;
		}
	}
}

static function bool IsOfType (int Description)
{
	local int Result;

	Result=Description & Default.DamageDesc;
	return Result == Description;
}

defaultproperties
{
    DamageDesc=1
    bArmorStops=True
    GibModifier=1.00
    FlashScale=-0.02
    FlashFog=(X=26.50,Y=4.50,Z=4.50)
    DeathString="%o was killed by %k."
    FemaleSuicide="%o killed herself."
    MaleSuicide="%o killed himself."
}