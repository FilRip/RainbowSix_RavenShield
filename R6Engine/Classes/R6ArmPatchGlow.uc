//================================================================================
// R6ArmPatchGlow.
//================================================================================
class R6ArmPatchGlow extends R6GlowLight;

var float m_fMatrixMul;
var name m_AttachedBoneName;

function Tick (float fDeltaTime)
{
	local Pawn OwnerPawn;
	local Pawn ViewPawn;
	local PlayerController ViewActor;
	local Coords TempCoord;
	local Vector temp;
	local Rotator TempRot;

	bCorona=False;
	bHidden=True;
	if ( Level.m_bNightVisionActive == False )
	{
		return;
	}
	ViewActor=GetCanvas().Viewport.Actor;
	if ( ViewActor == None )
	{
		return;
	}
	OwnerPawn=Pawn(m_pOwnerNightVision);
	ViewPawn=ViewActor.Pawn;
	if ( (ViewPawn != None) && (OwnerPawn.m_iTeam == ViewPawn.m_iTeam) )
	{
		TempCoord=OwnerPawn.GetBoneCoords(m_AttachedBoneName,True);
		temp=TempCoord.Origin;
		temp += TempCoord.XAxis * 14.00;
		temp -= TempCoord.YAxis * 2.00;
		temp += TempCoord.ZAxis * 8.00 * m_fMatrixMul;
		SetLocation(temp);
		TempRot=OrthoRotation(TempCoord.ZAxis * m_fMatrixMul,TempCoord.YAxis * m_fMatrixMul,TempCoord.XAxis * m_fMatrixMul);
		SetRotation(TempRot);
		bCorona=True;
		bHidden=False;
	}
}

defaultproperties
{
    m_fMatrixMul=1.00
    m_AttachedBoneName='
    m_bInverseScale=True
    RemoteRole=ROLE_None
    LightHue=255
    bNoDelete=False
    bCanTeleport=True
    bMovable=True
    DrawScale=0.60
    LightBrightness=255.00
    LightRadius=96.00
    Texture=None
}
/*
    Skins=[0]=Texture'Inventory_t.ArmPatches.ArmPatchFlare'
*/

