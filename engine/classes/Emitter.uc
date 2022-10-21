//================================================================================
// Emitter.
//================================================================================
class Emitter extends Actor
	Native
//	NoNativeReplication
	Placeable;

var(Global) bool AutoDestroy;
var(Global) bool AutoReset;
var(Global) bool DisableFogging;
var() export editinlineuse array<ParticleEmitter> Emitters;
var(Global) RangeVector GlobalOffsetRange;
var(Global) Range TimeTillResetRange;
var transient int Initialized;
var transient bool ActorForcesEnabled;
var transient bool UseParticleProjectors;
var transient bool DeleteParticleEmitters;
var transient float EmitterRadius;
var transient float EmitterHeight;
var transient float TimeTillReset;
var transient ParticleMaterial ParticleMaterial;
var transient Box BoundingBox;
var transient Vector GlobalOffset;

native function Kill ();

function Trigger (Actor Other, Pawn EventInstigator)
{
	local int i;

	for (i=0;i < Emitters.Length;i++)
	{
		if ( Emitters[i] != None )
		{
			Emitters[i].Disabled= !Emitters[i].Disabled;
		}
	}
}

defaultproperties
{
    DrawType=10
    Style=6
    bNoDelete=True
    m_bUseR6Availability=True
    bUnlit=True
}
/*
    Texture=Texture'S_Emitter'
*/

