use <../../_utils_v2/fillet.scad>

d=24;
h=32;
thickness=2;

dd=d+thickness*2;
hh=h+thickness*2;

g_d=9.7+2;
g_h=15;
g_thickness=3;
g_dd=g_d+g_thickness*2;
g_hh=hh+g_h*2;

module rcylinder(d,h,r=3)
{
	cylinder (d=d,h=h,$fn=100);
	minkowski()
	{
		translate ([0,0,r])
			cylinder (d=d-r*2,h=h-r*2,$fn=100);
		sphere (r=r,$fn=100);
	}
}

difference()
{
	union()
	fillet(r=3,steps=8)
	{
		rcylinder (d=dd,h=hh);
		translate ([0,0,-g_h])
			cylinder (d=g_dd,h=g_hh,$fn=100);
	}

	t=3;
	for (z=[
			-g_h+3
			,-g_h+9.5
			,hh+g_h-t-3
			,hh+g_h-t-9.5
			])
	translate ([0,0,z])
	difference()
	{
		cylinder (d=dd+1,h=t,$fn=100);
		cylinder (d=g_dd-3,h=t,$fn=100);
	}

	translate ([0,0,-g_h-1])
		cylinder (d=g_d,h=g_hh+2,$fn=100);
	translate ([0,0,thickness])
		rcylinder (d=d,h=h,r=1);
	translate ([-dd/2-1,0,-g_h-1])
		cube ([dd+2,dd,g_hh+2]);	
}