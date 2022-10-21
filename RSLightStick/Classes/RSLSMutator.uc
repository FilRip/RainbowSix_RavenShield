class RSLSMutator extends Mutator;

function PreBeginPlay()
{
	local PathNode pn;
	local RSStickLight newone;

	Log("Initialising mutator");

	foreach AllActors(class'PathNode',pn)
	{
		Log("Spawning a new StickLight");
		newone=Spawn(Class'RSStickLight',,,pn.Location);
//		newone.Velocity=vector(pn.ViewRotation) * 1500 + pn.Velocity;
	}
}

defaultproperties
{
}
