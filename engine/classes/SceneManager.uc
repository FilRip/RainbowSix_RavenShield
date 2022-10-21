//================================================================================
// SceneManager.
//================================================================================
class SceneManager extends Info
	Native
	Placeable;

enum EAffect {
	AFFECT_ViewportCamera,
	AFFECT_Actor
};

struct Interpolator
{
	var() int bDone;
	var() float _value;
	var() float _remainingTime;
	var() float _totalTime;
	var() float _speed;
	var() float _acceleration;
};

struct Orientation
{
	var() ECamOrientation CamOrientation;
	var() Actor LookAt;
	var() float EaseIntime;
	var() int bReversePitch;
	var() int bReverseYaw;
	var() int bReverseRoll;
	var int MA;
	var float PctInStart;
	var float PctInEnd;
	var float PctInDuration;
	var Rotator StartingRotation;
};

var() config EAffect Affect;
var() bool bLooping;
var() bool bCinematicView;
var(R6Scene) bool m_bFixedPosition;
var() Actor AffectedActor;
var() name PlayerScriptTag;
var() name NextSceneTag;
var() export editinlineuse array<MatAction> Actions;
var(R6Scene) string m_Alias;
var transient bool m_bPreviewReplay;
var transient bool bIsRunning;
var transient bool bIsSceneStarted;
var transient float PctSceneComplete;
var transient float SceneSpeed;
var transient float TotalSceneTime;
var transient float CurrentTime;
var transient MatAction m_PreviousAction;
var transient MatAction CurrentAction;
var transient Actor Viewer;
var transient Pawn OldPawn;
var transient array<Vector> SampleLocations;
var transient array<MatSubAction> SubActions;
var transient Orientation CamOrientation;
var transient Orientation PrevOrientation;
var transient Interpolator RotInterpolator;
var transient Vector CameraShake;
var transient Vector DollyOffset;
var transient string m_DisplayString;

native function float GetTotalSceneTime ();

native(2906) final function TerminateAIAction ();

native(2909) final function SceneDestroyed ();

simulated function BeginPlay ()
{
	Super.BeginPlay();
	if ( (Affect == 1) && (AffectedActor == None) )
	{
		Log("SceneManager : Affected actor is NULL!");
	}
	TotalSceneTime=GetTotalSceneTime();
	bIsRunning=False;
	bIsSceneStarted=False;
}

function Trigger (Actor Other, Pawn EventInstigator)
{
	bIsRunning=True;
	bIsSceneStarted=False;
	Disable('Trigger');
}

event SceneStarted ()
{
	local Controller P;
	local AIScript S;

	Viewer=None;
	if ( Affect == 1 )
	{
		Viewer=AffectedActor;
	}
	else
	{
		P=Level.ControllerList;
JL0039:
		if ( P != None )
		{
			Log("for PlayerController");
			if ( P.IsA('PlayerController') && (P.Pawn != None) )
			{
				Log("Is a Player Controller");
				Viewer=P;
				OldPawn=PlayerController(Viewer).Pawn;
				if ( OldPawn != None )
				{
					OldPawn.Velocity=vect(0.00,0.00,0.00);
					OldPawn.Acceleration=vect(0.00,0.00,0.00);
					PlayerController(Viewer).InitMatineeCamera();
					PlayerController(Viewer).UnPossess();
					if ( PlayerScriptTag != 'None' )
					{
						foreach DynamicActors(Class'AIScript',S,PlayerScriptTag)
						{
							goto JL0157;
JL0157:
						}
						if ( S != None )
						{
							S.TakeOver(OldPawn);
						}
					}
				}
				PlayerController(Viewer).StartInterpolation();
				PlayerController(Viewer).myHUD.bHideHUD=True;
			}
			else
			{
				P=P.nextController;
				goto JL0039;
			}
		}
	}
}

event SceneEnded ()
{
	bIsSceneStarted=False;
	if ( Affect == 0 )
	{
		PlayerController(Viewer).EndMatineeCamera();
		if ( PlayerController(Viewer) != None )
		{
			if ( OldPawn != None )
			{
				PlayerController(Viewer).Possess(OldPawn);
			}
			PlayerController(Viewer).myHUD.bHideHUD=False;
		}
	}
	Viewer.FinishedInterpolation();
	Enable('Trigger');
}

event Destroyed ()
{
	Log("SceneManager DESTROYED");
	SceneDestroyed();
}

defaultproperties
{
    m_Alias="SceneManager"
}
/*
    Texture=Texture'S_SceneManager'
*/

