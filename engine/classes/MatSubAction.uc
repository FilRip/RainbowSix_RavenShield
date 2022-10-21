//================================================================================
// MatSubAction.
//================================================================================
class MatSubAction extends MatObject
	Native
	Abstract
	EditInLineNew;
//	Localized;

enum ESAStatus {
	SASTATUS_Waiting,
	SASTATUS_Running,
	SASTATUS_Ending,
	SASTATUS_Expired
};

var ESAStatus Status;
var(Time) float Delay;
var(Time) float Duration;
var Texture Icon;
var SceneManager m_pSceneManager;
var localized string Desc;
var transient float PctStarting;
var transient float PctEnding;
var transient float PctDuration;

event Initialize ();

defaultproperties
{
    Desc="N/A"
}