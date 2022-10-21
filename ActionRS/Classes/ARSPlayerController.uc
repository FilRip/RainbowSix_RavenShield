Class ARSPlayerController extends R6PlayerController;

replication
{
    reliable if( Role<ROLE_Authority )
        ServerThrowWeapon;
}

exec function ThrowWeapon()
{
	Log("Execute ThrowWeapon of ARSPlayerController class");

    if ((Pawn==None) || (Pawn.EngineWeapon==None))
        return;

    ServerThrowWeapon();
}

function ServerThrowWeapon()
{
    Pawn.EngineWeapon.StartFalling();
}

exec function JumpOne()
{
	Pawn.JumpOutOfWater(vect(100,100,100));
}

exec function JumpTwo()
{
	Pawn.JumpOffPawn();
}

defaultproperties
{
}

