//================================================================================
// SimpleCommandlet.
//================================================================================
class SimpleCommandlet extends Commandlet;
//	Export;

var int intparm;

function int TestFunction ()
{
	return 666;
}

function int Main (string Parms)
{
	local int temp;
	local float floattemp;
	local string textstring;
	local string otherstring;

	Log("Simple commandlet says hi.");
	Log("Testing function calling.");
	temp=TestFunction();
	Log("Function call returned" @ string(temp));
	Log("Testing cast to int.");
	floattemp=3.00;
	temp=floattemp;
	Log("Temp is cast from " $ string(floattemp) $ " to " $ string(temp));
	Log("Testing min()");
	temp=Min(32,TestFunction());
	Log("Temp is min(32, 666): " $ string(temp));
	textstring="wookie";
	Log("3 is a " $ Left(textstring,3));
	otherstring="skywalker";
	otherstring=Mid(otherstring,InStr(otherstring,"a"));
	Log("otherstring:" @ otherstring);
	return 0;
}

defaultproperties
{
    HelpCmd="Simple"
    HelpOneLiner="Simple test commandlet"
    HelpUsage="Simple (no parameters)"
}