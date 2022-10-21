//================================================================================
// SparkEmitter.
//================================================================================
class SparkEmitter extends ParticleEmitter
	Native;

struct ParticleSparkData
{
	var float TimeBeforeVisible;
	var float TimeBetweenSegments;
	var Vector StartLocation;
	var Vector StartVelocity;
};

var(Spark) Range LineSegmentsRange;
var(Spark) Range TimeBeforeVisibleRange;
var(Spark) Range TimeBetweenSegmentsRange;
var transient int NumSegments;
var transient int VerticesPerParticle;
var transient int IndicesPerParticle;
var transient int PrimitivesPerParticle;
var transient VertexBuffer VertexBuffer;
var transient IndexBuffer IndexBuffer;
var transient array<ParticleSparkData> SparkData;

defaultproperties
{
    LineSegmentsRange=(Min=0.00,Max=0.00)
}