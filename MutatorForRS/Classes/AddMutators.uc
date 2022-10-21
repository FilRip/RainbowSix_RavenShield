Class AddMutators extends Info;

var() config string MutatorName[10];

function BeginPlay()
{
    local int i;
    local class<Mutator> mutClass;
    local Mutator mut;

	Log("Starting MutatorForRS");
    Super.PostBeginPlay();
    for (i=0;i<10;i++)
        if (MutatorName[i]!="")
        {
		log("Trying to add this mutator : "$MutatorName[i]);
            mutClass=class<Mutator>(DynamicLoadObject(MutatorName[i],class'Class'));

            if (mutClass==None)
                return;

            mut=Spawn(mutClass);
        	if (mut==None)
                return;

            if (Level.Game.BaseMutator==None)
                Level.Game.BaseMutator=mut;
            else
                Level.Game.BaseMutator.AddMutator(mut);
        }
	Log("End MutatorForRS");

//    Destroy();
}

defaultproperties
{
}

