//================================================================================
// MaterialFactory.
//================================================================================
class MaterialFactory extends Object
	Native
	Abstract;
//	Export;

const RF_Standalone= 0x00080000;
const RF_Public= 0x0000004;
var string Description;

event Material CreateMaterial (Object InOuter, string InPackage, string InGroup, string InName);

native function ConsoleCommand (string Cmd);
