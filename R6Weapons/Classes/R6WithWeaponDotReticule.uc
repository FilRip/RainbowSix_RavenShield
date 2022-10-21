//================================================================================
// R6WithWeaponDotReticule.
//================================================================================
class R6WithWeaponDotReticule extends R6WithWeaponReticule
	Config(User);

simulated function PostRender (Canvas C)
{
	local R6PlayerController Player;
	local Pawn pawnOwner;
	local float fCenterOffsetX;
	local float fCenterOffsetY;

	Super.PostRender(C);
	pawnOwner=Pawn(Owner);
	if ( (pawnOwner == None) || (pawnOwner.Controller == None) )
	{
		return;
	}
	Player=R6PlayerController(pawnOwner.Controller);
	if ( (Player != None) && Player.m_bHelmetCameraOn )
	{
		SetReticuleInfo(C);
		C.Style=1;
		fCenterOffsetX=C.SizeX / 640.00;
		fCenterOffsetY=C.SizeY / 480.00;
		C.SetPos(m_fReticuleOffsetX - 1.00 + fCenterOffsetX,m_fReticuleOffsetY - 2.00 + fCenterOffsetY);
		C.DrawRect(m_LineTexture,3.00,1.00);
		C.SetPos(m_fReticuleOffsetX - 2.00 + fCenterOffsetX,m_fReticuleOffsetY - 1.00 + fCenterOffsetY);
		C.DrawRect(m_LineTexture,5.00,3.00);
		C.SetPos(m_fReticuleOffsetX - 1.00 + fCenterOffsetX,m_fReticuleOffsetY + 2.00 + fCenterOffsetY);
		C.DrawRect(m_LineTexture,3.00,1.00);
	}
}