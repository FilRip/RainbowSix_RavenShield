//================================================================================
// TestInfo.
//================================================================================
class TestInfo extends Info;

struct STest
{
	var bool b1;
	var int i;
	var bool b2;
	var bool b3;
};

const Lotus=vect(1,2,3);
const Str="Tim";
const Pie=3.14;
var() int xnum;
var int MyArray[2];
var() bool bTrue1;
var() bool bFalse1;
var() bool bTrue2;
var() bool bFalse2;
var bool bBool1;
var bool bBool2;
var float ppp;
var Vector v1;
var Vector v2;
var STest ST;
var string sxx;
var string TestRepStr;

function TestQ ()
{
	local Vector V;

	V.X=2.00;
	V.Y=3.00;
	V.Z=4.00;
	assert (V == vect(2.00,3.00,4.00));
	assert (V.Z == 4);
	assert (V.Y == 3);
	assert (V.X == 2);
}

static function test ()
{
	Class'TestInfo'.Default.v1=vect(1.00,2.00,3.00);
}

function PostBeginPlay ()
{
	local Object o;
	local Actor TempActor;

	Log("!!BEGIN");
	Default.v1=vect(5.00,4.00,3.00);
	assert (Default.v1 == vect(5.00,4.00,3.00));
	test();
	assert (Default.v1 == vect(1.00,2.00,3.00));
	assert (IsA('Actor'));
	assert (IsA('TestInfo'));
	assert (IsA('Info'));
	assert ( !IsA('LevelInfo'));
	assert ( !IsA('Texture'));
	Log("!!END");
}

function TestStructBools ()
{
	assert (ST.b1 == False);
	assert (ST.b2 == False);
	assert (ST.b3 == False);
	ST.b1=True;
	assert (ST.b1 == True);
	assert (ST.b2 == False);
	assert (ST.b3 == False);
	ST.b2=True;
	assert (ST.b1 == True);
	assert (ST.b2 == True);
	assert (ST.b3 == False);
	ST.b3=True;
	assert (ST.b1 == True);
	assert (ST.b2 == True);
	assert (ST.b3 == True);
	ST.b1=False;
	ST.b2=False;
	ST.b3=False;
}

function BeginPlay ()
{
	local TestObj to;
	local Object oo;

	to=new Class'TestObj';
	to=new Class'TestObj';
	to=new Class'TestObj';
	to=new Class'TestObj';
	to=new Class'TestObj';
	to.test();
	TestStructBools();
}

function TestX (bool bResource)
{
	local int N;

}

function bool RecurseTest ()
{
	bBool1=True;
	return False;
}

function TestLimitor (Class C)
{
	local Class<Actor> NewClass;

	NewClass=Class<Actor>(C);
}

static function int OtherStatic (int i)
{
	assert (i == 246);
	assert (Default.xnum == 777);
	return 555;
}

static function int TestStatic (int i)
{
	assert (i == 123);
	assert (Default.xnum == 777);
	assert (OtherStatic(i * 2) == 555);
	return i;
}

function TestContinueFor ()
{
	local int i;

	Log("TestContinue");
	i=0;
JL0017:
	if ( i < 20 )
	{
		Log("iteration " $ string(i));
		if ( (i == 7) || (i == 9) || (i == 19) )
		{
			goto JL006C;
		}
		Log("...");
JL006C:
		i++;
		goto JL0017;
	}
	Log("DoneContinue");
}

function TestContinueWhile ()
{
	local int i;

	Log("TestContinue");
JL0010:
	if (  ++i <= 20 )
	{
		Log("iteration " $ string(i));
		if ( (i == 7) || (i == 9) )
		{
			goto JL0059;
		}
		Log("...");
JL0059:
		goto JL0010;
	}
	Log("DoneContinue");
}

function TestContinueDoUntil ()
{
	local int i;

	Log("TestContinue");
JL0010:
	i++;
	Log("iteration " $ string(i));
	if ( (i == 7) || (i == 9) || (i > 18) )
	{
		goto JL0060;
	}
	Log("...");
JL0060:
	if (!(i > 20)) goto JL0010;
	Log("DoneContinue");
}

function TestContinueForEach ()
{
	local Actor A;

	Log("TestContinue");
	foreach AllActors(Class'Actor',A)
	{
		Log("actor " $ string(A));
		if ( Light(A) == None )
		{
			continue;
		}
		else
		{
			Log("...");
		}
	}
	Log("DoneContinue");
}

function SubTestOptionalOut (optional out int A, optional out int B, optional out int C)
{
	A *= 2;
	B=B * 2;
	C += C;
}

function TestOptionalOut ()
{
	local int A;
	local int B;
	local int C;

	A=1;
	B=2;
	C=3;
	SubTestOptionalOut(A,B,C);
	assert (A == 2);
	assert (B == 4);
	assert (C == 6);
	SubTestOptionalOut(A,B);
	assert (A == 4);
	assert (B == 8);
	assert (C == 6);
	SubTestOptionalOut(,B,C);
	assert (A == 4);
	assert (B == 16);
	assert (C == 12);
	SubTestOptionalOut();
	assert (A == 4);
	assert (B == 16);
	assert (C == 12);
	SubTestOptionalOut(A,B,C);
	assert (A == 8);
	assert (B == 32);
	assert (C == 24);
	Log("TestOptionalOut ok!");
}

function TestNullContext (Actor A)
{
	bHidden=A.bHidden;
	A.bHidden=bHidden;
}

function TestSwitch ()
{
	local string S;
	local int i;
	local bool B;

	S="Tim";
	i=2;
	switch (i)
	{
		case 0:
		assert (False);
		break;
		case 2:
		B=True;
		break;
		default:
		assert (False);
		break;
	}
	assert (B);
	switch (S)
	{
		case "":
		assert (False);
		break;
		case "xyzzy":
		assert (False);
		break;
		default:
		B=False;
		break;
	}
	assert ( !B);
	Log("testswitch succeeded");
}

function Tick (float DeltaTime)
{
	local Class C;
	local Class<TestInfo> TC;
	local Actor A;

	Log("time=" $ string(Level.TimeSeconds));
	TestOptionalOut();
	TestNullContext(self);
	TestNullContext(None);
	TestSwitch();
	v1=vect(1.00,2.00,3.00);
	v2=vect(2.00,4.00,6.00);
	assert (v1 != v2);
	assert ( !(v1 == v2));
	assert (v1 == vect(1.00,2.00,3.00));
	assert (v2 == vect(2.00,4.00,6.00));
	assert (vect(1.00,2.00,5.00) != v1);
	assert (v1 * 2 == v2);
	assert (v1 == v2 / 2);
	assert (3.14 == 3.14);
	assert (3.14 != 2);
	assert ("Tim" == "Tim");
	assert ("Tim" != "Bob");
	assert (vect(1.00,2.00,3.00) == vect(1.00,2.00,3.00));
	assert (GetPropertyText("sxx") == "Tim");
	assert (GetPropertyText("ppp") != "123");
	assert (GetPropertyText("bogus") == "");
	xnum=345;
	assert (GetPropertyText("xnum") == "345");
	SetPropertyText("xnum","999");
	assert (xnum == 999);
	assert (xnum != 666);
	assert (bTrue1 == True);
	assert (bFalse1 == False);
	assert (bTrue2 == True);
	assert (bFalse2 == False);
	assert (Default.bTrue1 == True);
	assert (Default.bFalse1 == False);
	assert (Default.bTrue2 == True);
	assert (Default.bFalse2 == False);
	assert (Class'TestInfo'.Default.bTrue1 == True);
	assert (Class'TestInfo'.Default.bFalse1 == False);
	assert (Class'TestInfo'.Default.bTrue2 == True);
	assert (Class'TestInfo'.Default.bFalse2 == False);
	TC=Class;
	assert (TC.Default.bTrue1 == True);
	assert (TC.Default.bFalse1 == False);
	assert (TC.Default.bTrue2 == True);
	assert (TC.Default.bFalse2 == False);
	C=Class;
	assert (Class<TestInfo>(C).Default.bTrue1 == True);
	assert (Class<TestInfo>(C).Default.bFalse1 == False);
	assert (Class<TestInfo>(C).Default.bTrue2 == True);
	assert (Class<TestInfo>(C).Default.bFalse2 == False);
	assert (Default.xnum == 777);
	TestStatic(123);
	TC.Static.TestStatic(123);
	Class<TestInfo>(C).static.TestStatic(123);
	bBool2=RecurseTest();
	assert (bBool2 == False);
	TestStructBools();
	TestQ();
	Log("All tests passed");
}

function f ();

function temp ()
{
	local int i;
	local PlayerController PlayerOwner;
	local name LeftList[20];

	temp();
}

state AA
{
	ignores  f;
	
}

state BB
{
	ignores  f;
	
}

state CCAA extends AA
{
	ignores  f;
	
}

state DDAA extends AA
{
	ignores  f;
	
}

state EEDDAA extends DDAA
{
	ignores  f;
	
}

defaultproperties
{
    xnum=777
    bTrue1=True
    bTrue2=True
    ppp=3.14
    sxx="Tim"
    RemoteRole=ROLE_SimulatedProxy
    bHidden=False
    bAlwaysRelevant=True
}