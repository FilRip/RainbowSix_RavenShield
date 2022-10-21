//================================================================================
// R6MatineePawn.
//================================================================================
class R6MatineePawn extends R6Pawn;

function PostBeginPlay ()
{
	bPhysicsAnimUpdate=True;
	StopAnimating();
}

function Tick (float DeltaTime)
{
}

defaultproperties
{
    DrawType=1
    m_bAllowLOD=False
    bActorShadows=True
    bObsolete=True
    KParams=KarmaParamsSkel'KarmaParamsSkel25'
}