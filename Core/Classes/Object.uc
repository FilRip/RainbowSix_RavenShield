//================================================================================
// Object.
//================================================================================
class Object
	Native
	NoExport;

const Pi= 3.1415926535897932;
const MaxInt= 0x7fffffff;

enum ENodeNotify {
	NODEMSG_NewAction,
	NODEMSG_NewMode,
	NODEMSG_NewSpeed,
	NODEMSG_NewNode,
	NODEMSG_GoCodeLaunched,
	NODEMSG_ActionNodeCompleted,
	NODEMSG_WaitingGoCode,
	NODEMSG_NodeReached,
	NODEMSG_PlayerLeft,
	NODEMSG_SnipeUntilGoCode,
	NODEMSG_BreachDoorAtGoCode
};

enum EPlanActionType {
	PACTTYP_Normal,
	PACTTYP_Milestone,
	PACTTYP_GoCodeA,
	PACTTYP_GoCodeB,
	PACTTYP_GoCodeC,
	PACTTYP_Delete
};

enum EPlanAction {
	PACT_None,
	PACT_Frag,
	PACT_Flash,
	PACT_Gas,
	PACT_Smoke,
	PACT_SnipeGoCode,
	PACT_Breach,
	PACT_OpenDoor
};

enum EMovementSpeed {
	SPEED_Blitz,
	SPEED_Normal,
	SPEED_Cautious
};

enum EMovementMode {
	MOVE_Assault,
	MOVE_Infiltrate,
	MOVE_Recon
};

enum EGoCode {
	GOCODE_Alpha,
	GOCODE_Bravo,
	GOCODE_Charlie,
	GOCODE_Zulu,
	GOCODE_None
};

struct Range
{
	var() config float Min;
	var() config float Max;
};

struct Rotator
{
	var() config int Pitch;
	var() config int Yaw;
	var() config int Roll;
};

struct Vector
{
	var() config float X;
	var() config float Y;
	var() config float Z;
};

struct Plane extends Vector
{
	var() config float W;
};

struct CompressedPosition
{
	var Vector Location;
	var Rotator Rotation;
	var Vector Velocity;
};

struct Region
{
	var() int X;
	var() int Y;
	var() int W;
	var() int H;
};

struct InterpCurvePoint
{
	var() float InVal;
	var() float OutVal;
};

struct InterpCurve
{
	var() array<InterpCurvePoint> Points;
};

struct Matrix
{
	var() Plane XPlane;
	var() Plane YPlane;
	var() Plane ZPlane;
	var() Plane WPlane;
};

struct Box
{
	var Vector Min;
	var Vector Max;
	var byte IsValid;
};

struct BoundingVolume extends Box
{
	var Plane Sphere;
};

struct Color
{
	var() config byte B;
	var() config byte G;
	var() config byte R;
	var() config byte A;
};

enum ECamOrientation {
	CAMORIENT_None,
	CAMORIENT_LookAtActor,
	CAMORIENT_FacePath,
	CAMORIENT_Interpolate,
	CAMORIENT_Dolly
};

enum ESheerAxis {
	SHEER_None,
	SHEER_XY,
	SHEER_XZ,
	SHEER_YX,
	SHEER_YZ,
	SHEER_ZX,
	SHEER_ZY
};

struct Scale
{
	var() config Vector Scale;
	var() config float SheerRate;
	var() config ESheerAxis SheerAxis;
};

struct RangeVector
{
	var() config Range X;
	var() config Range Y;
	var() config Range Z;
};

struct Coords
{
	var() config Vector Origin;
	var() config Vector XAxis;
	var() config Vector YAxis;
	var() config Vector ZAxis;
};

struct Guid
{
	var int A;
	var int B;
	var int C;
	var int D;
};

const RF_NotForEdit= 0x00400000;
const RF_NotForServer= 0x00200000;
const RF_NotForClient= 0x00100000;
const RF_Transient= 0x00004000;
const RF_Public= 0x00000004;
const RF_Transactional= 0x00000001;
var const native private int ObjectInternal[6];
var const native Object Outer;
var const native int ObjectFlags;
var() const native editconst name Name;
var const native editconst Class Class;
var const native private int DName;

native(129) static final preoperator bool ! (bool A);

native(242) static final operator(24) bool == (bool A, bool B);

native(243) static final operator(26) bool != (bool A, bool B);

native(130) static final operator(30) bool && (bool A, skip bool B);

native(131) static final operator(30) bool ^^ (bool A, bool B);

native(132) static final operator(32) bool || (bool A, skip bool B);

native(133) static final operator(34) byte *= (out byte A, byte B);

native(134) static final operator(34) byte /= (out byte A, byte B);

native(135) static final operator(34) byte += (out byte A, byte B);

native(136) static final operator(34) byte -= (out byte A, byte B);

native(137) static final preoperator byte ++ (out byte A);

native(138) static final preoperator byte -- (out byte A);

native(139) static final postoperator byte ++ (out byte A);

native(140) static final postoperator byte -- (out byte A);

native(141) static final preoperator int ~ (int A);

native(143) static final preoperator int - (int A);

native(144) static final operator(16) int * (int A, int B);

native(145) static final operator(16) int / (int A, int B);

native(146) static final operator(20) int + (int A, int B);

native(147) static final operator(20) int - (int A, int B);

native(148) static final operator(22) int << (int A, int B);

native(149) static final operator(22) int >> (int A, int B);

native(196) static final operator(22) int >>> (int A, int B);

native(150) static final operator(24) bool < (int A, int B);

native(151) static final operator(24) bool > (int A, int B);

native(152) static final operator(24) bool <= (int A, int B);

native(153) static final operator(24) bool >= (int A, int B);

native(154) static final operator(24) bool == (int A, int B);

native(155) static final operator(26) bool != (int A, int B);

native(156) static final operator(28) int & (int A, int B);

native(157) static final operator(28) int ^ (int A, int B);

native(158) static final operator(28) int | (int A, int B);

native(159) static final operator(34) int *= (out int A, float B);

native(160) static final operator(34) int /= (out int A, float B);

native(161) static final operator(34) int += (out int A, int B);

native(162) static final operator(34) int -= (out int A, int B);

native(163) static final preoperator int ++ (out int A);

native(164) static final preoperator int -- (out int A);

native(165) static final postoperator int ++ (out int A);

native(166) static final postoperator int -- (out int A);

native(167) static final function int Rand (int Max);

native(249) static final function int Min (int A, int B);

native(250) static final function int Max (int A, int B);

native(251) static final function int Clamp (int V, int A, int B);

native(169) static final preoperator float - (float A);

native(170) static final operator(12) float ** (float A, float B);

native(171) static final operator(16) float * (float A, float B);

native(172) static final operator(16) float / (float A, float B);

native(173) static final operator(18) float % (float A, float B);

native(174) static final operator(20) float + (float A, float B);

native(175) static final operator(20) float - (float A, float B);

native(176) static final operator(24) bool < (float A, float B);

native(177) static final operator(24) bool > (float A, float B);

native(178) static final operator(24) bool <= (float A, float B);

native(179) static final operator(24) bool >= (float A, float B);

native(180) static final operator(24) bool == (float A, float B);

native(210) static final operator(24) bool ~= (float A, float B);

native(181) static final operator(26) bool != (float A, float B);

native(182) static final operator(34) float *= (out float A, float B);

native(183) static final operator(34) float /= (out float A, float B);

native(184) static final operator(34) float += (out float A, float B);

native(185) static final operator(34) float -= (out float A, float B);

native(186) static final function float Abs (float A);

native(187) static final function float Sin (float A);

native static final function float Asin (float A);

native(188) static final function float Cos (float A);

native static final function float Acos (float A);

native(189) static final function float Tan (float A);

native(190) static final function float Atan (float A);

native(191) static final function float Exp (float A);

native(192) static final function float Loge (float A);

native(193) static final function float Sqrt (float A);

native(194) static final function float Square (float A);

native(195) static final function float FRand ();

native(244) static final function float FMin (float A, float B);

native(245) static final function float FMax (float A, float B);

native(246) static final function float FClamp (float V, float A, float B);

native(247) static final function float Lerp (float Alpha, float A, float B);

native(248) static final function float Smerp (float Alpha, float A, float B);

native(211) static final preoperator Vector - (Vector A);

native(212) static final operator(16) Vector * (Vector A, float B);

native(213) static final operator(16) Vector * (float A, Vector B);

native(296) static final operator(16) Vector * (Vector A, Vector B);

native(214) static final operator(16) Vector / (Vector A, float B);

native(215) static final operator(20) Vector + (Vector A, Vector B);

native(216) static final operator(20) Vector - (Vector A, Vector B);

native(275) static final operator(22) Vector << (Vector A, Rotator B);

native(276) static final operator(22) Vector >> (Vector A, Rotator B);

native(217) static final operator(24) bool == (Vector A, Vector B);

native(218) static final operator(26) bool != (Vector A, Vector B);

native(219) static final operator(16) float Dot (Vector A, Vector B);

native(220) static final operator(16) Vector Cross (Vector A, Vector B);

native(221) static final operator(34) Vector *= (out Vector A, float B);

native(297) static final operator(34) Vector *= (out Vector A, Vector B);

native(222) static final operator(34) Vector /= (out Vector A, float B);

native(223) static final operator(34) Vector += (out Vector A, Vector B);

native(224) static final operator(34) Vector -= (out Vector A, Vector B);

native(225) static final function float VSize (Vector A);

native(226) static final function Vector Normal (Vector A);

native(227) static final function Invert (out Vector X, out Vector Y, out Vector Z);

native(252) static final function Vector VRand ();

native(300) static final function Vector MirrorVectorByNormal (Vector Vect, Vector Normal);

native(142) static final operator(24) bool == (Rotator A, Rotator B);

native(203) static final operator(26) bool != (Rotator A, Rotator B);

native(287) static final operator(16) Rotator * (Rotator A, float B);

native(288) static final operator(16) Rotator * (float A, Rotator B);

native(289) static final operator(16) Rotator / (Rotator A, float B);

native(290) static final operator(34) Rotator *= (out Rotator A, float B);

native(291) static final operator(34) Rotator /= (out Rotator A, float B);

native(316) static final operator(20) Rotator + (Rotator A, Rotator B);

native(317) static final operator(20) Rotator - (Rotator A, Rotator B);

native(318) static final operator(34) Rotator += (out Rotator A, Rotator B);

native(319) static final operator(34) Rotator -= (out Rotator A, Rotator B);

native(229) static final function GetAxes (Rotator A, out Vector X, out Vector Y, out Vector Z);

native(230) static final function GetUnAxes (Rotator A, out Vector X, out Vector Y, out Vector Z);

native(320) static final function Rotator RotRand (optional bool bRoll);

native static final function Rotator OrthoRotation (Vector X, Vector Y, Vector Z);

native static final function Rotator Normalize (Rotator Rot);

native static final operator(24) bool ClockwiseFrom (int A, int B);

native(1851) static final function int ShortestAngle2D (int iAngle1, int iAngle2);

native(1854) static final function bool GetRegistryKey (string Dir, string Key, out string Value);

native(1855) static final function bool SetRegistryKey (string Dir, string Key, string Value);

native(112) static final operator(40) string $ (coerce string A, coerce string B);

native(168) static final operator(40) string @ (coerce string A, coerce string B);

native(115) static final operator(24) bool < (string A, string B);

native(116) static final operator(24) bool > (string A, string B);

native(120) static final operator(24) bool <= (string A, string B);

native(121) static final operator(24) bool >= (string A, string B);

native(122) static final operator(24) bool == (string A, string B);

native(123) static final operator(26) bool != (string A, string B);

native(124) static final operator(24) bool ~= (string A, string B);

native(125) static final function int Len (coerce string S);

native(126) static final function int InStr (coerce string S, coerce string t);

native(127) static final function string Mid (coerce string S, int i, optional int j);

native(128) static final function string Left (coerce string S, int i);

native(234) static final function string Right (coerce string S, int i);

native(235) static final function string Caps (coerce string S);

native(236) static final function string Chr (int i);

native(237) static final function int Asc (string S);

native(238) static final function string RemoveInvalidChars (string S);

native(1227) static final function string Itoa (int i);

native(1228) static final function int Atoi (coerce string S);

native(1306) static final function int Strnicmp (coerce string A, coerce string B, int iCount);

native(114) static final operator(24) bool == (Object A, Object B);

native(119) static final operator(26) bool != (Object A, Object B);

native(254) static final operator(24) bool == (name A, name B);

native(255) static final operator(26) bool != (name A, name B);

native static final function float InterpCurveEval (InterpCurve curve, float Input);

native(2718) static final function LogSnd (coerce string S, optional name Tag);

native(231) static final function Log (coerce string S, optional name Tag);

native(232) static final function Warn (coerce string S);

native static function string Localize (string SectionName, string KeyName, string PackageName, optional bool bNoDebug, optional bool bMultipleToken, optional bool bForceEnglish);

native(113) final function GotoState (optional name NewState, optional name Label);

native(281) final function bool IsInState (name TestState);

native(284) final function name GetStateName ();

native(258) static final function bool ClassIsChildOf (Class TestClass, Class ParentClass);

native(303) final function bool IsA (name ClassName);

native(117) final function Enable (name ProbeFunc);

native(118) final function Disable (name ProbeFunc);

native final function string GetPropertyText (string PropName);

native final function SetPropertyText (string PropName, string PropValue);

native static final function name GetEnum (Object E, int i);

native static final function Object DynamicLoadObject (string ObjectName, Class ObjectClass, optional bool MayFail);

native static final function Object FindObject (string ObjectName, Class ObjectClass);

native(536) final function SaveConfig (optional string FileName);

native static final function StaticSaveConfig ();

native(1010) final function LoadConfig (optional string FileName);

native static final function ResetConfig (optional string VarNameToReset);

final function float RandRange (float Min, float Max)
{
	return Min + (Max - Min) * FRand();
}

native(1005) static final function Class GetFirstPackageClass (string Package, Class ObjectClass);

native(1006) static final function Class GetNextClass ();

native(1301) static final function Class RewindToFirstClass ();

native(1007) static final function FreePackageObjects ();

native(1850) static final function ClearOuter ();

native(1852) static final function Clock (int iCounter);

native(1853) static final function Unclock (int iCounter);

event BeginState ();

event EndState ();

function InitMod ();
