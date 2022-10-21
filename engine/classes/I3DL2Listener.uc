//================================================================================
// I3DL2Listener.
//================================================================================
class I3DL2Listener extends Object
	Native
	Abstract
//	Export
	EditInLineNew;

var() int Room;
var() int RoomHF;
var() int Reflections;
var() int Reverb;
var() bool bDecayTimeScale;
var() bool bReflectionsScale;
var() bool bReflectionsDelayScale;
var() bool bReverbScale;
var() bool bReverbDelayScale;
var() bool bDecayHFLimit;
var() float EnvironmentSize;
var() float EnvironmentDiffusion;
var() float DecayTime;
var() float DecayHFRatio;
var() float ReflectionsDelay;
var() float ReverbDelay;
var() float RoomRolloffFactor;
var() float AirAbsorptionHF;
var transient int Environment;
var transient int Updated;

defaultproperties
{
    Room=-1000
    RoomHF=-100
    Reflections=-2602
    Reverb=200
    bDecayTimeScale=True
    bReflectionsScale=True
    bReflectionsDelayScale=True
    bReverbScale=True
    bReverbDelayScale=True
    bDecayHFLimit=True
    EnvironmentSize=7.50
    EnvironmentDiffusion=1.00
    DecayTime=1.49
    DecayHFRatio=0.83
    ReflectionsDelay=0.01
    ReverbDelay=0.01
    AirAbsorptionHF=-5.00
}