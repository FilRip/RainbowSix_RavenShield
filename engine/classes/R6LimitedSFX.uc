//================================================================================
// R6LimitedSFX.
//================================================================================
class R6LimitedSFX extends R6SFX
	Abstract;

simulated function PostBeginPlay ()
{
	if ( Level.m_aLimitedSFX[Level.m_iLimitedSFXCount] != None )
	{
		Level.m_aLimitedSFX[Level.m_iLimitedSFXCount].Kill();
	}
	Level.m_aLimitedSFX[Level.m_iLimitedSFXCount]=self;
	Level.m_iLimitedSFXCount++;
	if ( Level.m_iLimitedSFXCount == 6 )
	{
		Level.m_iLimitedSFXCount=0;
	}
}
