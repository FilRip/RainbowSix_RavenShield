Class RSNight extends Mutator;

function bool CheckReplacement (Actor Other,out byte bSuperRelevant)
{
	if (Other.IsA('Light'))
	{
		Light(Other).LightRadius=0;
		Light(Other).LightType=LT_None;
	}
	if (Other.IsA('ZoneInfo'))
	{
		ZoneInfo(Other).AmbientBrightness=0;
		ZoneInfo(Other).AmbientHue=0;
		ZoneInfo(Other).AmbientSaturation=0;
	}
	return True;
}

defaultproperties
{
}
