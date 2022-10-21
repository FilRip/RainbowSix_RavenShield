//================================================================================
// R6WeatherVolume.
//================================================================================
class R6WeatherVolume extends R6SoundVolume;

event Touch (Actor Other)
{
	Other.m_bInWeatherVolume++;
}

event UnTouch (Actor Other)
{
	Other.m_bInWeatherVolume--;
}