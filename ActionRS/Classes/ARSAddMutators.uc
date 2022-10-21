Class ARSAddMutators extends Info;

var() config string MutatorName[10];

function PostBeginPlay()
{
    local int i;
    local class<Mutator> mutClass;
    local Mutator mut;

    Super.PostBeginPlay();
    for (i=0;i<10;i++)
        if (MutatorName[i]!="")
        {
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

    Destroy();
}

defaultproperties
{
}

