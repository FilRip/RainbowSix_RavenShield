//================================================================================
// R6Door.
//================================================================================
class R6Door extends NavigationPoint
	Native;

enum eRoomLayout {
	ROOM_OpensCenter,
	ROOM_OpensLeft,
	ROOM_OpensRight,
	ROOM_None
};

var() eRoomLayout m_eRoomLayout;
var bool m_bCloseOnUntouch;
var() R6Door m_CorrespondingDoor;
var() R6IORotatingDoor m_RotatingDoor;
var Vector m_vLookDir;

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	m_vLookDir=vector(Rotation);
	m_vLookDir=Normal(m_vLookDir);
}

function Touch (Actor Other)
{
	local R6Pawn Pawn;
	local Rotator rPawnRot;

	Pawn=R6Pawn(Other);
	if ( Pawn == None )
	{
		return;
	}
	if ( (Pawn.m_ePawnType == 3) || (Pawn.m_ePawnType == 2) )
	{
		return;
	}
	rPawnRot=Pawn.Rotation;
	rPawnRot.Pitch=0;
	Pawn.PotentialOpenDoor(self);
	Super.Touch(Other);
}

function UnTouch (Actor Other)
{
	local R6Pawn Pawn;

	Pawn=R6Pawn(Other);
	if ( Pawn == None )
	{
		return;
	}
	Pawn.RemovePotentialOpenDoor(self);
	Super.UnTouch(Other);
}

defaultproperties
{
    ExtraCost=300
    m_bExactMove=True
    bCollideWhenPlacing=False
    bCollideActors=True
    bDirectional=True
    CollisionRadius=96.00
    CollisionHeight=90.00
}
/*
    Texture=Texture'S_DoorNavP'
*/

