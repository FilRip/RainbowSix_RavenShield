//================================================================================
// R6WindowButtonMPInGame.
//================================================================================
class R6WindowButtonMPInGame extends R6WindowButton;

enum eButInGameActionType {
	Button_AlphaTeam,
	Button_BravoTeam,
	Button_AutoTeam,
	Button_Spectator,
	Button_Play
};

var eButInGameActionType m_eButInGame_Action;
var Texture m_TOverButton;
var Region m_ROverButtonFade;
var Region m_ROverButton;

simulated function Click (float X, float Y)
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;

	Super.Click(X,Y);
	r6Root=R6MenuInGameMultiPlayerRootWindow(Root);
	if ( bDisabled )
	{
		return;
	}
	switch (m_eButInGame_Action)
	{
/*		case Button_Play:
		case Button_AlphaTeam:
		r6Root.m_R6GameMenuCom.PlayerSelection(r6Root.m_R6GameMenuCom.2);
		break;
		case Button_BravoTeam:
		r6Root.m_R6GameMenuCom.PlayerSelection(r6Root.m_R6GameMenuCom.3);
		break;
		case Button_AutoTeam:
		r6Root.m_R6GameMenuCom.PlayerSelection(r6Root.m_R6GameMenuCom.1);
		break;
		case Button_Spectator:
		r6Root.m_R6GameMenuCom.PlayerSelection(r6Root.m_R6GameMenuCom.4);
		break;
		default:
		break;*/
	}
}

defaultproperties
{
    m_ROverButtonFade=(X=16261638,Y=570687488,W=6,H=860675)
    m_ROverButton=(X=16589318,Y=570687488,W=2,H=860675)
    bStretched=True
}
/*
    m_TOverButton=Texture'R6MenuTextures.Gui_BoxScroll'
*/

