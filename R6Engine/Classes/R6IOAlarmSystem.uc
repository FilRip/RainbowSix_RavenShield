//================================================================================
// R6IOAlarmSystem.
//================================================================================
class R6IOAlarmSystem extends R6IODevice;

var(R6ActionObject) Material m_DisarmedTexture;
var(R6ActionObject) Sound m_DisarmingSound;

simulated function string R6GetCircumstantialActionString (int iAction)
{
	switch (iAction)
	{
/*		case 1:
		return Localize("RDVOrder","Order_DisarmSystem","R6Menu");
		default:    */
	}
	return "";
}

simulated function ToggleDevice (R6Pawn aPawn)
{
	local int iAlarmCount;

	if ( CanToggle() == False )
	{
		return;
	}
	if ( bShowLog )
	{
		Log("Set Device" @ string(self) @ "by pawn" @ string(aPawn) @ "and his controller" @ string(aPawn.Controller));
	}
	m_bIsActivated=False;
	if ( m_DisarmedTexture != None )
	{
		SetSkin(m_DisarmedTexture,0);
	}
//	PlaySound(m_DisarmingSound,3);
	m_bToggleType=False;
	R6AbstractGameInfo(Level.Game).IObjectInteract(aPawn,self);
}
