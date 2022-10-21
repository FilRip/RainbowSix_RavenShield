//================================================================================
// TetrahedronBuilder.
//================================================================================
class TetrahedronBuilder extends BrushBuilder;

var() int SphereExtrapolation;
var() float Radius;
var() name GroupName;

function Extrapolate (int A, int B, int C, int Count, float Radius)
{
	local int ab;
	local int bc;
	local int ca;

	if ( Count > 1 )
	{
		ab=Vertexv(Radius * Normal(GetVertex(A) + GetVertex(B)));
		bc=Vertexv(Radius * Normal(GetVertex(B) + GetVertex(C)));
		ca=Vertexv(Radius * Normal(GetVertex(C) + GetVertex(A)));
		Extrapolate(A,ab,ca,Count - 1,Radius);
		Extrapolate(B,bc,ab,Count - 1,Radius);
		Extrapolate(C,ca,bc,Count - 1,Radius);
		Extrapolate(ab,bc,ca,Count - 1,Radius);
	}
	else
	{
		Poly3i(1,A,B,C);
	}
}

function BuildTetrahedron (float R, int SphereExtrapolation)
{
	Vertex3f(R,0.00,0.00);
	Vertex3f( -R,0.00,0.00);
	Vertex3f(0.00,R,0.00);
	Vertex3f(0.00, -R,0.00);
	Vertex3f(0.00,0.00,R);
	Vertex3f(0.00,0.00, -R);
	Extrapolate(2,1,4,SphereExtrapolation,Radius);
	Extrapolate(1,3,4,SphereExtrapolation,Radius);
	Extrapolate(3,0,4,SphereExtrapolation,Radius);
	Extrapolate(0,2,4,SphereExtrapolation,Radius);
	Extrapolate(1,2,5,SphereExtrapolation,Radius);
	Extrapolate(3,1,5,SphereExtrapolation,Radius);
	Extrapolate(0,3,5,SphereExtrapolation,Radius);
	Extrapolate(2,0,5,SphereExtrapolation,Radius);
}

event bool Build ()
{
	if ( (Radius <= 0) || (SphereExtrapolation <= 0) )
	{
		return BadParameters();
	}
	BeginBrush(False,GroupName);
	BuildTetrahedron(Radius,SphereExtrapolation);
	return EndBrush();
}

defaultproperties
{
    SphereExtrapolation=1
    Radius=256.00
    GroupName=Tetrahedron
    BitmapFilename="BBSphere"
    ToolTip="Tetrahedron (Sphere)"
}