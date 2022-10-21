class RSStickLight extends Actor placeable;

var float TimeToLive;
var Rotator rRot;

#exec OBJ LOAD FILE=..\StaticMeshes\mod_rvs.usx

replication
{
	reliable if (Role == ROLE_Authority)
		TimeToLive;
}

/*simulated function Tick (float Delta)
{
	TimeToLive-=Delta;

	if ( vsize(Velocity) > 8 && !Region.Zone.bWaterZone )
	{
		rRot.Pitch+=98304*Delta;
		rRot.Yaw-=49152*Delta;
	}
	else
	{
		rRot.Pitch=16384;
	}

	SetRotation(rRot);

	if ( TimeToLive < 30 )
	{
		LightBrightness=255 * TimeToLive/30 ;
	}
	
	if ( TimeToLive < 0 )Destroy();
}*/

simulated function HitWall (Vector HitNormal, Actor HitWall)
{
	Velocity=0.13 * MirrorVectorByNormal(Velocity,HitNormal);
}

/*
    bNetTemporary=True
    RemoteRole=ROLE_SimulatedProxy
    bBounce=True
*/

defaultproperties
{
    TimeToLive=90.00
    Physics=PHYS_None
    DrawType=DT_Mesh
    Texture=Texture'mod_rvs.fumi'
    Mesh=Mesh'mod_rvs.fumi'
    DrawScale=1
    AmbientGlow=255
    bUnlit=True
    CollisionRadius=1.00
    CollisionHeight=5.10
    bCollideWorld=True
    LightType=1
    LightEffect=3
    LightBrightness=255
    LightHue=170
    LightSaturation=127
    LightRadius=10
	bHidden=false
}
