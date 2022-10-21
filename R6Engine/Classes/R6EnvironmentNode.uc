//================================================================================
// R6EnvironmentNode.
//================================================================================
class R6EnvironmentNode extends Actor
	Native
//	NoNativeReplication
	Placeable;

var Vector m_vLookDir;

function PostBeginPlay ()
{
	Super.PostBeginPlay();
	m_vLookDir=vector(Rotation);
	m_vLookDir=Normal(m_vLookDir);
}

function Touch (Actor Other)
{
}

function UnTouch (Actor Other)
{
}

defaultproperties
{
    bCollideActors=True
    bDirectional=True
}
