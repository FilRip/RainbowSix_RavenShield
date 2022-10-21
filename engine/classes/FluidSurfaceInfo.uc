//================================================================================
// FluidSurfaceInfo.
//================================================================================
class FluidSurfaceInfo extends Info
	Native
	NoExport
	Placeable
	ShowCategories(Movement,Collision,Lighting,LightColor,Karma,Force);

enum EFluidGridType {
	FGT_Square,
	FGT_Hexagonal
};

var() EFluidGridType FluidGridType;
var() float FluidGridSpacing;
var() int FluidXSize;
var() int FluidYSize;
var() float FluidHeightScale;
var() float FluidSpeed;
var() float FluidDamping;
var() float FluidNoiseFrequency;
var() Range FluidNoiseStrength;
var() bool TestRipple;
var() float TestRippleSpeed;
var() float TestRippleStrength;
var() float TestRippleRadius;
var() float UTiles;
var() float UOffset;
var() float VTiles;
var() float VOffset;
var() float AlphaCurveScale;
var() float AlphaHeightScale;
var() byte AlphaMax;
var() float ShootStrength;
var() float RippleVelocityFactor;
var() float TouchStrength;
var() Class<Effects> ShootEffect;
var() bool OrientShootEffect;
var() Class<Effects> TouchEffect;
var() bool OrientTouchEffect;
var const array<int> ClampBitmap;
var() TerrainInfo ClampTerrain;
var() bool bShowBoundingBox;
var() float WarmUpTime;
var() float UpdateRate;
var const transient array<float> Verts0;
var const transient array<float> Verts1;
var const transient array<byte> VertAlpha;
var const transient int LatestVerts;
var const transient Box FluidBoundingBox;
var const transient Vector FluidOrigin;
var const transient float TimeRollover;
var const transient float TestRippleAng;
var const transient FluidSurfacePrimitive Primitive;
var const transient array<FluidSurfaceOscillator> Oscillators;
var const transient bool bHasWarmedUp;

native final function Pling (Vector Position, float Strength, optional float Radius);

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	Pling(HitLocation,ShootStrength,0.00);
	if ( ShootEffect != None )
	{
		if ( OrientShootEffect )
		{
			Spawn(ShootEffect,self,,HitLocation,rotator(Momentum));
		}
		else
		{
			Spawn(ShootEffect,self,,HitLocation);
		}
	}
}

function Touch (Actor Other)
{
	local Vector touchLocation;

	Super.Touch(Other);
	if ( Other.bDisturbFluidSurface == False )
	{
		return;
	}
	touchLocation=Other.Location;
	touchLocation.Z=Location.Z;
	Pling(touchLocation,TouchStrength,Other.CollisionRadius);
	if ( ShootEffect != None )
	{
		if ( OrientTouchEffect )
		{
			Spawn(TouchEffect,self,,touchLocation,rotator(Other.Velocity));
		}
		else
		{
			Spawn(TouchEffect,self,,touchLocation);
		}
	}
}

defaultproperties
{
    FluidGridType=1
    FluidGridSpacing=32.00
    FluidXSize=32
    FluidYSize=32
    FluidHeightScale=1.00
    FluidSpeed=150.00
    FluidDamping=0.30
    FluidNoiseStrength=(Min=0.00,Max=0.00)
    TestRippleSpeed=6000.00
    TestRippleStrength=-300.00
    TestRippleRadius=34.00
    UTiles=1.00
    VTiles=1.00
    AlphaHeightScale=10.00
    AlphaMax=128
    ShootStrength=-300.00
    RippleVelocityFactor=-0.04
    TouchStrength=-200.00
    WarmUpTime=2.00
    UpdateRate=30.00
    DrawType=12
    bHidden=False
    bCollideActors=True
    bProjTarget=True
}
/*
    Texture=Texture'S_TerrainInfo'
*/

