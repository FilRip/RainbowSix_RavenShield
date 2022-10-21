//================================================================================
// MeshEmitter.
//================================================================================
class MeshEmitter extends ParticleEmitter
	Native;

var(Mesh) bool UseMeshBlendMode;
var(Mesh) bool RenderTwoSided;
var(Mesh) bool UseParticleColor;
var(Mesh) StaticMesh StaticMesh;
var transient Vector MeshExtent;

defaultproperties
{
    UseMeshBlendMode=True
    StartSizeRange=(X=(Min=0.00,Max=0.00),Y=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00),Z=(Min=0.00,Max=0.00)(Min=0.00,Max=0.00)(Min=0.00,Max=0.00))
}