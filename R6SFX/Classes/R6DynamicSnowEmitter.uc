//================================================================================
// R6DynamicSnowEmitter.
//================================================================================
class R6DynamicSnowEmitter extends R6WeatherEmitter;

simulated function PostBeginPlay ()
{
	Emitters[0].m_iUseFastZCollision=1;
	Emitters[0].m_iPaused=1;
}

defaultproperties
{
    Emitters=[0]=SpriteEmitter'SpriteEmitterDynSnowWeather'
    bNoDelete=False
}