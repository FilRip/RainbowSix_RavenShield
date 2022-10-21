//================================================================================
// R6ActionPointAbstract.
//================================================================================
class R6ActionPointAbstract extends Actor
	Native
	Abstract;
//	NoNativeReplication;

var R6ActionPointAbstract prevActionPoint;
var array<Actor> m_PathToNextPoint;

function ResetPathNode ();

function ResetActionIcon ();
