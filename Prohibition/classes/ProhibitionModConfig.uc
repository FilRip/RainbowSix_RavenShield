Class ProhibitionModConfig extends R6ModConfig;

function AddModSpecificGameModes (LevelInfo pLevelInfo)
{
	pLevelInfo.GameTypeInfoAdd("Pro_TeamDeathmatchMode","Pro_TeamDeathmatchMode",GMI_Adversarial,False,False,False,True,True,"Prohibition","Prohibition.ProhibitionTDMGame","Prohibition Assault","","","","","Pro_TeamDeathmatchMode");
	pLevelInfo.GameTypeInfoAdd("RGM_TeamDeathmatchMode","RGM_TeamDeathmatchMode",GMI_Adversarial,True,True,False,False,False,"R6GameMode","Prohibition.ProhibitionTDMGame",Localize("MultiPlayer","GameType_TeamDeath","R6Menu"),"R6GameMode","R6GameMode","R6GameMode","R6GameMode","Pro_TeamDeathmatchMode");
}

defaultproperties
{
}
