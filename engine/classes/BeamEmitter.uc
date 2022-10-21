//================================================================================
// BeamEmitter.
//================================================================================
class BeamEmitter extends ParticleEmitter
	Native;

enum EBeamEndPointType {
	PTEP_Velocity,
	PTEP_Distance,
	PTEP_Offset,
	PTEP_Actor,
	PTEP_TraceOffset,
	PTEP_OffsetAsAbsolute
};

struct ParticleBeamScale
{
	var() Vector FrequencyScale;
	var() float RelativeLength;
};

struct ParticleBeamEndPoint
{
	var() name ActorTag;
	var() RangeVector offset;
	var() float Weight;
};

struct ParticleBeamData
{
	var Vector Location;
	var float t;
};

var(Beam) EBeamEndPointType DetermineEndPointBy;
var(Beam) int RotatingSheets;
var(BeamNoise) int LowFrequencyPoints;
var(BeamNoise) int HighFrequencyPoints;
var(BeamBranching) int BranchEmitter;
var(BeamNoise) bool UseHighFrequencyScale;
var(BeamNoise) bool UseLowFrequencyScale;
var(BeamNoise) bool NoiseDeterminesEndPoint;
var(BeamBranching) bool UseBranching;
var(BeamBranching) bool LinkupLifetime;
var(Beam) float BeamTextureUScale;
var(Beam) float BeamTextureVScale;
var(BeamNoise) float LFScaleRepeats;
var(BeamNoise) float HFScaleRepeats;
var(Beam) array<ParticleBeamEndPoint> BeamEndPoints;
var(BeamNoise) array<ParticleBeamScale> LFScaleFactors;
var(BeamNoise) array<ParticleBeamScale> HFScaleFactors;
var(Beam) Range BeamDistanceRange;
var(BeamNoise) RangeVector LowFrequencyNoiseRange;
var(BeamNoise) RangeVector HighFrequencyNoiseRange;
var(BeamBranching) Range BranchProbability;
var(BeamBranching) Range BranchSpawnAmountRange;
var transient int SheetsUsed;
var transient int VerticesPerParticle;
var transient int IndicesPerParticle;
var transient int PrimitivesPerParticle;
var transient float BeamValueSum;
var transient array<ParticleBeamData> HFPoints;
var transient array<Vector> LFPoints;
var transient array<Actor> HitActors;

defaultproperties
{
    LowFrequencyPoints=3
    HighFrequencyPoints=10
    BranchEmitter=-1
    BeamTextureUScale=1.00
    BeamTextureVScale=1.00
}