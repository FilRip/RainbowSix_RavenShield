//================================================================================
// ParticleEmitter.
//================================================================================
class ParticleEmitter extends Object
	Native
	Abstract
//	Export
	EditInLineNew;

enum EParticleCollisionSound {
	PTSC_None,
	PTSC_LinearGlobal,
	PTSC_LinearLocal,
	PTSC_Random
};

enum EParticleEffectAxis {
	PTEA_NegativeX,
	PTEA_PositiveZ
};

enum EParticleStartLocationShape {
	PTLS_Box,
	PTLS_Sphere,
	PTLS_Polar
};

enum EParticleVelocityDirection {
	PTVD_None,
	PTVD_StartPositionAndOwner,
	PTVD_OwnerAndStartPosition,
	PTVD_AddRadial
};

enum EParticleRotationSource {
	PTRS_None,
	PTRS_Actor,
	PTRS_Offset,
	PTRS_Normal
};

enum EParticleCoordinateSystem {
	PTCS_Independent,
	PTCS_Relative,
	PTCS_Absolute
};

enum EParticleDrawStyle {
	PTDS_Regular,
	PTDS_AlphaBlend,
	PTDS_Modulated,
	PTDS_Translucent,
	PTDS_AlphaModulate_MightNotFogCorrectly,
	PTDS_Darken,
	PTDS_Brighten
};

enum EBlendMode {
	BM_MODULATE,
	BM_MODULATE2X,
	BM_MODULATE4X,
	BM_ADD,
	BM_ADDSIGNED,
	BM_ADDSIGNED2X,
	BM_SUBTRACT,
	BM_ADDSMOOTH,
	BM_BLENDDIFFUSEALPHA,
	BM_BLENDTEXTUREALPHA,
	BM_BLENDFACTORALPHA,
	BM_BLENDTEXTUREALPHAPM,
	BM_BLENDCURRENTALPHA,
	BM_PREMODULATE,
	BM_MODULATEALPHA_ADDCOLOR,
	BM_MODULATEINVALPHA_ADDCOLOR,
	BM_MODULATEINVCOLOR_ADDALPHA,
	BM_HACK
};

struct ParticleSound
{
	var() Sound Sound;
	var() Range Radius;
	var() Range Pitch;
	var() int Weight;
	var() Range Volume;
	var() Range Probability;
};

struct Particle
{
	var Vector Location;
	var Vector OldLocation;
	var Vector Velocity;
	var Vector StartSize;
	var Vector SpinsPerSecond;
	var Vector StartSpin;
	var Vector Size;
	var Vector StartLocation;
	var Vector ColorMultiplier;
	var Color Color;
	var float Time;
	var float MaxLifetime;
	var float Mass;
	var int HitCount;
	var int Flags;
	var int Subdivision;
	var float m_fMinZ;
};

struct ParticleColorScale
{
	var() float RelativeTime;
	var() Color Color;
};

struct ParticleTimeScale
{
	var() float RelativeTime;
	var() float RelativeSize;
};

var(Collision) EParticleCollisionSound CollisionSound;
var(General) EParticleCoordinateSystem CoordinateSystem;
var(General) EParticleEffectAxis EffectAxis;
var(Location) EParticleStartLocationShape StartLocationShape;
var(Rotation) EParticleRotationSource UseRotationFrom;
var(Texture) EParticleDrawStyle DrawStyle;
var(Velocity) EParticleVelocityDirection GetVelocityDirectionFrom;
var(Collision) int SpawnFromOtherEmitter;
var(Collision) int SpawnAmount;
var(General) const int MaxParticles;
var(Location) int AddLocationFromOtherEmitter;
var(Rendering) int AlphaRef;
var(Texture) int TextureUSubdivisions;
var(Texture) int TextureVSubdivisions;
var(Texture) int SubdivisionStart;
var(Texture) int SubdivisionEnd;
var(Velocity) int AddVelocityFromOtherEmitter;
var(R6Misc) int m_iUseFastZCollision;
var(R6Misc) int m_iPaused;
var(Collision) bool UseCollision;
var(Collision) bool UseCollisionPlanes;
var(Collision) bool UseMaxCollisions;
var(Collision) bool UseSpawnedVelocityScale;
var(Color) bool UseColorScale;
var(Fading) bool FadeOut;
var(Fading) bool FadeIn;
var(Force) bool UseActorForces;
var(General) bool ResetAfterChange;
var(Local) bool RespawnDeadParticles;
var(Local) bool AutoDestroy;
var(Local) bool AutoReset;
var(Local) bool Disabled;
var(Local) bool DisableFogging;
var(Rendering) bool AlphaTest;
var(Rendering) bool AcceptsProjectors;
var(Rendering) bool ZTest;
var(Rendering) bool ZWrite;
var(Rotation) bool SpinParticles;
var(Rotation) bool DampRotation;
var(Size) bool UseSizeScale;
var(Size) bool UseRegularSizeScale;
var(Size) bool UniformSize;
var(Spawning) bool AutomaticInitialSpawning;
var(Texture) bool BlendBetweenSubdivisions;
var(Texture) bool UseSubdivisionScale;
var(Texture) bool UseRandomSubdivision;
var(Color) float ColorScaleRepeats;
var(Fading) float FadeOutStartTime;
var(Fading) float FadeInEndTime;
var(Size) float SizeScaleRepeats;
var(Spawning) float ParticlesPerSecond;
var(Spawning) float InitialParticlesPerSecond;
var(Tick) float SecondsBeforeInactive;
var(Tick) float MinSquaredVelocity;
var(Warmup) float WarmupTicksPerSecond;
var(Warmup) float RelativeWarmupTime;
var(Texture) Texture Texture;
var(Collision) array<Plane> CollisionPlanes;
var(Sound) array<ParticleSound> Sounds;
var(Color) array<ParticleColorScale> ColorScale;
var(Size) array<ParticleTimeScale> SizeScale;
var(Texture) array<float> SubdivisionScale;
var(Acceleration) Vector Acceleration;
var(Collision) Vector ExtentMultiplier;
var(Collision) RangeVector DampingFactorRange;
var(Collision) Range MaxCollisions;
var(Collision) RangeVector SpawnedVelocityScaleRange;
var(Collision) Range CollisionSoundIndex;
var(Collision) Range CollisionSoundProbability;
var(Color) RangeVector ColorMultiplierRange;
var(Fading) Plane FadeOutFactor;
var(Fading) Plane FadeInFactor;
var(Local) Range AutoResetTimeRange;
var(Location) Vector StartLocationOffset;
var(Location) RangeVector StartLocationRange;
var(Location) Range SphereRadiusRange;
var(Location) RangeVector StartLocationPolarRange;
var(Mass) Range StartMassRange;
var(Rotation) Rotator RotationOffset;
var(Rotation) Vector SpinCCWorCW;
var(Rotation) RangeVector SpinsPerSecondRange;
var(Rotation) RangeVector StartSpinRange;
var(Rotation) RangeVector RotationDampingFactorRange;
var(Rotation) Vector RotationNormal;
var(Size) RangeVector StartSizeRange;
var(Time) Range InitialTimeRange;
var(Time) Range LifetimeRange;
var(Time) Range InitialDelayRange;
var(Velocity) RangeVector StartVelocityRange;
var(Velocity) Range StartVelocityRadialRange;
var(Velocity) Vector MaxAbsVelocity;
var(Velocity) RangeVector VelocityLossRange;
var(Velocity) RangeVector AddVelocityMultiplierRange;
var(Local) string Name;
var transient int ParticleIndex;
var transient int ActiveParticles;
var transient int OtherIndex;
var transient int PS2Data;
var transient int MaxActiveParticles;
var transient int CurrentCollisionSoundIndex;
var transient int KillPending;
var transient bool Initialized;
var transient bool Inactive;
var transient bool RealDisableFogging;
var transient bool AllParticlesDead;
var transient bool WarmedUp;
var transient float InactiveTime;
var transient float PPSFraction;
var transient float InitialDelay;
var transient float TimeTillReset;
var transient float MaxSizeScale;
var transient Emitter Owner;
var transient array<Particle> Particles;
var transient Box BoundingBox;
var transient Vector RealExtentMultiplier;
var transient Vector GlobalOffset;

native function SpawnParticle (int Amount);

defaultproperties
{
    DrawStyle=3
    SpawnFromOtherEmitter=-1
    MaxParticles=10
    AddLocationFromOtherEmitter=-1
    AddVelocityFromOtherEmitter=-1
    RespawnDeadParticles=True
    AlphaTest=True
    ZTest=True
    UseRegularSizeScale=True
    AutomaticInitialSpawning=True
    SecondsBeforeInactive=1.00
    ExtentMultiplier=(X=1.00,Y=1.00,Z=1.00)
    DampingFactorRange=(X=(Min=0.00,Max=0.00),Y=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00),Z=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00)(Min=0.00,Max=0.00))
    ColorMultiplierRange=(X=(Min=0.00,Max=0.00),Y=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00),Z=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00)(Min=0.00,Max=0.00))
    FadeOutFactor=(X=0.00,Y=5.5196117033052799E19,Z=0.00,W=0.00)
    FadeInFactor=(X=0.00,Y=5.5196117033052799E19,Z=0.00,W=0.00)
    StartMassRange=(Min=0.00,Max=0.00)
    SpinCCWorCW=(X=0.50,Y=0.50,Z=0.50)
    StartSizeRange=(X=(Min=0.00,Max=0.00),Y=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00),Z=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00)(Min=0.00,Max=0.00))
    LifetimeRange=(Min=0.00,Max=0.00)
    AddVelocityMultiplierRange=(X=(Min=0.00,Max=0.00),Y=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00),Z=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00)(Min=0.00,Max=0.00))
}
/*
    Texture=Texture'S_Emitter'
*/

