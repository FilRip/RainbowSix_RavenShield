Class ARSHUD extends R6HUD;

simulated function PostRender(Canvas C)
{
    DrawNbInTeam(C);
    DrawHealth(C);
    Super.PostRender(C);
}

simulated function DrawHealth(Canvas C)
{
    if ((PlayerOwner.PlayerReplicationInfo==None) || (PlayerOwner.Pawn==None)) return;
    if ((PlayerOwner.PlayerReplicationInfo.bIsSpectator) || (PlayerOwner.PlayerReplicationInfo.TeamID==0) || (PlayerOwner.PlayerReplicationInfo.TeamID==4))
        return;

    C.Font=C.MedFont;
    C.SetPos(C.ClipX-80,C.ClipY*0.25);
    C.SetDrawColor(255,255,255);
    C.DrawText("Health:"$string(PlayerOwner.Pawn.Health));
}

simulated function DrawNbInTeam(Canvas C)
{
    local PlayerReplicationInfo PRI;
    local int r,t,h;

    if (PlayerOwner.PlayerReplicationInfo==None) return;
    if ((PlayerOwner.PlayerReplicationInfo.bIsSpectator) || (PlayerOwner.PlayerReplicationInfo.TeamID==0) || (PlayerOwner.PlayerReplicationInfo.TeamID==4))
        return;

    foreach AllActors(class'PlayerReplicationInfo',PRI)
    {
        if (PRI.m_iHealth<2)
        {
            if (PRI.TeamID==1) t++;
            if (PRI.TeamID==2) r++;
            if (PRI.TeamID==3) h++;
        }
    }

    C.Font=C.MedFont;
    C.SetPos(C.ClipX-100,C.ClipY*0.66);
    C.SetDrawColor(0,0,255);
    C.DrawText("Rainbows : "$string(r));
    C.SetPos(C.ClipX-100,C.ClipY*0.68);
    C.SetDrawColor(255,0,0);
    C.DrawText("Terrorists : "$string(t));
    C.SetPos(C.ClipX-100,C.ClipY*0.7);
    C.SetDrawColor(0,255,0);
    C.DrawText("Hostages : "$string(h));
}

defaultproperties
{
}

