//================================================================================
// R6MuzzleLight.
//================================================================================
class R6MuzzleLight extends Light;

const LightExistence=0.04;
var float m_fExistForHowlong;

simulated function Tick (float fDeltaTime)
{
	Super.Tick(fDeltaTime);
	m_fExistForHowlong += fDeltaTime;
	if ( m_fExistForHowlong > 0.04 )
	{
		Destroy();
	}
}

defaultproperties
{
    DrawType=0
    LightHue=33
    LightSaturation=209
    bStatic=False
    bNoDelete=False
    bDynamicLight=True
    LightBrightness=232.00
    LightRadius=40.00
}