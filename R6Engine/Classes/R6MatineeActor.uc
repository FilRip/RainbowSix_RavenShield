//================================================================================
// R6MatineeActor.
//================================================================================
class R6MatineeActor extends R6Pawn;

simulated event PostBeginPlay ()
{
	Super.PostBeginPlay();
	if ( bActorShadows )
	{
		Shadow=Spawn(Class'ShadowProjector',self,'None',Location);
		ShadowProjector(Shadow).ShadowActor=self;
		ShadowProjector(Shadow).UpdateShadow();
	}
}

defaultproperties
{
    DrawType=1
    m_bAllowLOD=False
    bActorShadows=True
    KParams=KarmaParamsSkel'KarmaParamsSkel24'
}