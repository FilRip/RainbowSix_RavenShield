//================================================================================
// R6TerroristVoices.
//================================================================================
class R6TerroristVoices extends R6Voices;

enum ETerroristVoices {
	TV_Wounded,
	TV_Taunt,
	TV_Surrender,
	TV_SeesTearGas,
	TV_RunAway,
	TV_Grenade,
	TV_CoughsSmoke,
	TV_CoughsGas,
	TV_Backup,
	TV_SeesSurrenderedHostage,
	TV_SeesRainbow_LowAlert,
	TV_SeesRainbow_HighAlert,
	TV_SeesFreeHostage,
	TV_HearsNoize
};

var Sound m_sndWounded;
var Sound m_sndTaunt;
var Sound m_sndSurrender;
var Sound m_sndSeesTearGas;
var Sound m_sndRunAway;
var Sound m_sndGrenade;
var Sound m_sndCoughsSmoke;
var Sound m_sndCoughsGas;
var Sound m_sndBackup;
var Sound m_sndSeesSurrenderedHostage;
var Sound m_sndSeesRainbow_LowAlert;
var Sound m_sndSeesRainbow_HighAlert;
var Sound m_sndSeesFreeHostage;
var Sound m_sndHearsNoize;

function PlayTerroristVoices (R6Pawn aPawn, ETerroristVoices eTerroSound)
{
	if ( aPawn != None )
	{
		switch (eTerroSound)
		{
/*			case 0:
//			aPawn.PlayVoices(m_sndWounded,6,5,2);
			break;
			case 1:
//			aPawn.PlayVoices(m_sndTaunt,6,10);
			break;
			case 2:
//			aPawn.PlayVoices(m_sndSurrender,6,10);
			break;
			case 3:
//			aPawn.PlayVoices(m_sndSeesTearGas,6,10);
			break;
			case 4:
//			aPawn.PlayVoices(m_sndRunAway,6,10);
			break;
			case 5:
//			aPawn.PlayVoices(m_sndGrenade,6,10);
			break;
			case 6:
			break;
			case 7:
//			aPawn.PlayVoices(m_sndCoughsGas,6,10,2);
			break;
			case 8:
//			aPawn.PlayVoices(m_sndBackup,6,10);
			break;
			case 9:
//			aPawn.PlayVoices(m_sndSeesSurrenderedHostage,6,10);
			break;
			case 10:
//			aPawn.PlayVoices(m_sndSeesRainbow_LowAlert,6,10);
			break;
			case 11:
//			aPawn.PlayVoices(m_sndSeesRainbow_HighAlert,6,10);
			break;
			case 12:
//			aPawn.PlayVoices(m_sndSeesFreeHostage,6,10);
			break;
			case 13:
//			aPawn.PlayVoices(m_sndHearsNoize,6,10);
			break;
			default:    */
		}
	}
}
