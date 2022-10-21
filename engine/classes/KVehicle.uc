//================================================================================
// KVehicle.
//================================================================================
class KVehicle extends Pawn
	Native
	Abstract;
//	NoNativeReplication;

var() int CamPosIndex;
var() bool bAutoDrive;
var(KVechile) bool bLookSteer;
var() float Steering;
var() float Throttle;
var() float LookSteerSens;
var Pawn Driver;
var() const Plane CamPos[4];
var() Vector ExitPos;
var() Rotator ExitRot;
var() Vector DrivePos;
var() Rotator DriveRot;

native final function GraphData (string DataName, float DataValue);

function TakeDamage (int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	KAddImpulse(Momentum,HitLocation);
}

event EncroachedBy (Actor Other)
{
	Log("KVehicle(" $ string(self) $ ") Encroached By: " $ string(Other) $ ".");
}

event KVehicleUpdateParams ();

function TryToDrive (Pawn P)
{
	local Controller C;

	C=P.Controller;
	if ( (Driver == None) && (C != None) && C.bIsPlayer &&  !C.IsInState('PlayerDriving') && P.IsHumanControlled() )
	{
		KDriverEnter(P);
	}
}

event KDriverEnter (Pawn P)
{
	local PlayerController PC;

	Log("Entering Vehicle");
	Driver=P;
	PC=PlayerController(P.Controller);
	PC.UnPossess();
	PC.Possess(self);
	PC.GotoState('PlayerDriving');
	Driver.SetCollision(False,False,False);
	Driver.bCollideWorld=False;
	Driver.bPhysicsAnimUpdate=False;
	Driver.Velocity=vect(0.00,0.00,0.00);
	Driver.SetPhysics(PHYS_None);
	Driver.SetBase(self);
}

event KDriverLeave ()
{
	local PlayerController PC;

	Log("Leaving Vehicle");
	if ( Driver == None )
	{
		return;
	}
	PC=PlayerController(Controller);
	PC.UnPossess();
	PC.Possess(Driver);
	Driver.PlayWaiting();
	Driver.bPhysicsAnimUpdate=Driver.Default.bPhysicsAnimUpdate;
	Driver.Acceleration=vect(0.00,0.00,24000.00);
	Driver.SetPhysics(PHYS_Falling);
	Driver.SetBase(None);
	Driver.bCollideWorld=True;
	Driver.SetCollision(True,True,True);
	Driver.SetLocation(Location + (ExitPos >> Rotation));
	Driver=None;
	Throttle=0.00;
	Steering=0.00;
}

defaultproperties
{
    CamPosIndex=2
    bLookSteer=True
    LookSteerSens=0.00
    bCanBeBaseForPawns=True
    Physics=13
    bCollideWorld=False
    bBlockKarma=True
    bEdShouldSnap=True
    CollisionRadius=1.00
    CollisionHeight=1.00
}