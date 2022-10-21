//================================================================================
// R6AbstractCorpse.
//================================================================================
class R6AbstractCorpse extends Actor
	Native;
//	NoNativeReplication;

function RenderCorpseBones (Canvas C);

function TakeAHit (int iBone, Vector vMomentum);

native(1802) final function RenderBones (Canvas C);

native(1803) final function FirstInit (R6AbstractPawn pawnOwner);

native(1804) final function AddImpulseToBone (int iTracedBone, Vector vMomentum);

defaultproperties
{
    bHidden=True
}
