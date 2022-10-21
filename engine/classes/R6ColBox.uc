//================================================================================
// R6ColBox.
//================================================================================
class R6ColBox extends Actor
	Native;
//	NoNativeReplication;

var bool m_bActive;
var bool m_bCheckForEdges;
var bool m_bCanStepUp;
var bool m_bCollisionDetected;
var float m_fFeetColBoxRadius;

replication
{
	reliable if ( bNetOwner && (Role < Role_Authority) ||  !bNetOwner && (Role == Role_Authority) )
		m_bActive;
	reliable if ( Role == Role_Authority )
		m_fFeetColBoxRadius;
}

native(1503) final function EnableCollision (bool bEnable, optional bool bCheckForEdges, optional bool bCanStepUp);

function logC (string S)
{
	local string Time;
	local name baseName;

	if ( Base != None )
	{
		baseName=Base.Name;
	}
	Time=string(Level.TimeSeconds);
	Time=Left(Time,InStr(Time,".") + 3);
	Log("[" $ Time $ "] COL BOX (" $ string(baseName) $ "): " $ S);
}

event Trigger (Actor Other, Pawn EventInstigator)
{
	Base.Trigger(Other,EventInstigator);
}

event UnTrigger (Actor Other, Pawn EventInstigator)
{
	Base.UnTrigger(Other,EventInstigator);
}

event HitWall (Vector HitNormal, Actor HitWall)
{
	if ( Pawn(Base) != None )
	{
		Pawn(Base).Controller.HitWall(HitNormal,HitWall);
	}
}

event Touch (Actor Other)
{
	if ( Base != None )
	{
		Base.Touch(Other);
	}
}

event PostTouch (Actor Other)
{
	Base.PostTouch(Other);
}

event UnTouch (Actor Other)
{
	if ( Base != None )
	{
		Base.UnTouch(Other);
	}
}

event Bump (Actor Other)
{
	if ( Pawn(Base) != None )
	{
		Pawn(Base).Controller.NotifyBump(Other);
	}
}

event bool EncroachingOn (Actor Other)
{
	return Base.EncroachingOn(Other);
}

event EncroachedBy (Actor Other)
{
	Base.EncroachedBy(Other);
}

event BaseChange ()
{
}

function int R6TakeDamage (int iKillValue, int iStunValue, Pawn instigatedBy, Vector vHitLocation, Vector vMomentum, int iBulletToArmorModifier, optional int iBulletGoup)
{
	return Base.R6TakeDamage(iKillValue,iStunValue,instigatedBy,vHitLocation,vMomentum,iBulletToArmorModifier,iBulletGoup);
}

event R6QueryCircumstantialAction (float fDistance, out R6AbstractCircumstantialActionQuery Query, PlayerController PlayerController)
{
	Query.aQueryTarget=Base;
	Base.R6QueryCircumstantialAction(fDistance,Query,PlayerController);
}

simulated event Destroyed ()
{
	EnableCollision(False);
	Super.Destroyed();
}

simulated event bool GetReticuleInfo (Pawn ownerReticule, out string szName)
{
	return Base.GetReticuleInfo(ownerReticule,szName);
}

defaultproperties
{
    DrawType=0
    bHidden=True
    m_bReticuleInfo=True
    bBlockActors=True
    bBlockPlayers=True
    CollisionRadius=10.00
    CollisionHeight=10.00
}