//================================================================================
// FluidSurfaceOscillator.
//================================================================================
class FluidSurfaceOscillator extends Actor
	Native
//	NoNativeReplication
	Placeable;

var() byte Phase;
var() float Frequency;
var() float Strength;
var() float Radius;
var() FluidSurfaceInfo FluidInfo;
var const transient float OscTime;

defaultproperties
{
    Frequency=1.00
    Strength=10.00
    bHidden=True
}