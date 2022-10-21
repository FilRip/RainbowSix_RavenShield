//================================================================================
// Note.
//================================================================================
class Note extends Actor
	Native
//	NoNativeReplication
	Placeable;

var() string Text;

defaultproperties
{
    bStatic=True
    bHidden=True
    bNoDelete=True
    bMovable=False
}
/*
    Texture=Texture'S_Note'
*/

