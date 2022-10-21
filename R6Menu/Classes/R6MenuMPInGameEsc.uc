//================================================================================
// R6MenuMPInGameEsc.
//================================================================================
class R6MenuMPInGameEsc extends R6MenuWidget;

var bool m_bExitGamePopUp;
var bool m_bEscAvailable;
var float m_fTimeForRefreshObj;
var R6MenuMPInGameEscNavBar m_pEscNavBar;
var R6MenuMPInGameObj m_pInGameObj;
const C_fREFRESH_OBJ= 2;
const C_fNAVBAR_HEIGHT= 55;

function Created ()
{
	local R6MenuInGameMultiPlayerRootWindow r6Root;
	local float fYNavBarPos;

	r6Root=R6MenuInGameMultiPlayerRootWindow(OwnerWindow);
//	m_pEscNavBar=R6MenuMPInGameEscNavBar(CreateWindow(Class'R6MenuMPInGameEscNavBar',r6Root.m_REscPopUp.X,r6Root.m_REscPopUp.Y + r6Root.30 + r6Root.m_REscPopUp.H - 55,r6Root.m_REscPopUp.W,55.00));
//	m_pInGameObj=R6MenuMPInGameObj(CreateWindow(Class'R6MenuMPInGameObj',r6Root.m_REscPopUp.X,r6Root.m_REscPopUp.Y + r6Root.30,r6Root.m_REscPopUp.W,r6Root.m_REscPopUp.H - 55,self));
}

function Tick (float DeltaTime)
{
	if ( m_fTimeForRefreshObj >= 2 )
	{
		m_pInGameObj.UpdateObjectives();
		m_fTimeForRefreshObj=0.00;
	}
	else
	{
		m_fTimeForRefreshObj += DeltaTime;
	}
}

defaultproperties
{
    m_bEscAvailable=True
    m_fTimeForRefreshObj=2.00
}
