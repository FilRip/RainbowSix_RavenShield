//================================================================================
// NavigationPoint.
//================================================================================
class NavigationPoint extends Actor
	Native
//	NoNativeReplication
	HideCategories(Lighting,LightColor,Karma,Force);

var int visitedWeight;
var const int bestPathWeight;
var int cost;
var() int ExtraCost;
var bool taken;
var() bool bBlocked;
var() bool bPropagatesSound;
var() bool bOneWayPath;
var() bool bNeverUseStrafing;
var() bool bAlwaysUseStrafing;
var const bool bForceNoStrafing;
var const bool bAutoBuilt;
var bool bSpecialMove;
var bool bNoAutoConnect;
var const bool bNotBased;
var const bool bPathsChanged;
var bool bDestinationOnly;
var bool bSourceOnly;
var bool bSpecialForced;
var bool bMustBeReachable;
var const bool m_bExactMove;
var const NavigationPoint nextNavigationPoint;
var const NavigationPoint nextOrdered;
var const NavigationPoint prevOrdered;
var const NavigationPoint previousPath;
var() name ProscribedPaths[4];
var() name ForcedPaths[4];
var const array<ReachSpec> PathList;
var transient bool bEndPoint;

event int SpecialCost (Pawn Seeker, ReachSpec Path);

event bool Accept (Actor Incoming, Actor Source)
{
	taken=Incoming.SetLocation(Location);
	if ( taken )
	{
		Incoming.Velocity=vect(0.00,0.00,0.00);
		Incoming.SetRotation(Rotation);
	}
	Incoming.PlayTeleportEffect(True,False);
	TriggerEvent(Event,self,Pawn(Incoming));
	return taken;
}

event bool SuggestMovePreparation (Pawn Other)
{
	return False;
}

function bool ProceedWithMove (Pawn Other)
{
	return True;
}

function MoverOpened ();

function MoverClosed ();

defaultproperties
{
    bPropagatesSound=True
    bStatic=True
    bHidden=True
    bNoDelete=True
    bCollideWhenPlacing=True
    CollisionRadius=80.00
    CollisionHeight=100.00
}
/*
    Texture=Texture'S_NavP'
*/

