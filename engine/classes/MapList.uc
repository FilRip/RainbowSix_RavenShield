//================================================================================
// MapList.
//================================================================================
class MapList extends Info
	Native
	Abstract;

const K_NextDefaultMap= -2;
var(Maps) config string Maps[32];

function string GetNextMap (int iNextMapNum);
