class ProhibitionTDMGame extends R6TeamDeathMatchGame;

function PreBeginPlay()
{
    bShowLog=true;
    super.PreBeginPlay();
    Log("DEBUG:ProhibitionTDMGame initialized");
}

defaultproperties
{
}

