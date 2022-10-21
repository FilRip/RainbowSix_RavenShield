//================================================================================
// R6AbstractBulletManager.
//================================================================================
class R6AbstractBulletManager extends Actor;
//	NoNativeReplication;

function SetBulletParameter (R6EngineWeapon AWeapon);

function InitBulletMgr (Pawn TheInstigator);

function bool AffectActor (int BulletGroup, Actor ActorAffected);

function SpawnBullet (Vector VPosition, Rotator rRotation, float fBulletSpeed, bool bFirstInShell);
