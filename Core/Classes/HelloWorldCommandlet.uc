//================================================================================
// HelloWorldCommandlet.
//================================================================================
class HelloWorldCommandlet extends Commandlet;
//	Export;

var int intparm;
var string strparm;

function int Main (string Parms)
{
	Log("Hello, world!");
	if ( Parms != "" )
	{
		Log("Command line parameters=" $ Parms);
	}
	if ( intparm != 0 )
	{
		Log("You specified intparm=" $ string(intparm));
	}
	if ( strparm != "" )
	{
		Log("You specified strparm=" $ strparm);
	}
	return 0;
}

defaultproperties
{
    HelpCmd="HelloWorld"
    HelpOneLiner="Sample 'hello world' commandlet"
    HelpUsage="HelloWorld (no parameters)"
    HelpParm(0)="IntParm"
    HelpParm(1)="StrParm"
    HelpDesc(0)="An integer parameter"
    HelpDesc(1)="A string parameter"
}