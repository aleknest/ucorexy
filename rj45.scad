use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

function rj45_dim()=[50,20,18+2];

rg45_up=2;
rg45_cut_dim=[16.7,16.2,13.1+0.2];
rg45_legs=[12.5/2,5];
rg45_leg2=[-0.3,9];
rg45_pins=[11,4.8];
rg45_pins2=[8,12,1];
fix_offs=7.2+1;

module rj45_cut()
{
	maxh=40;
	translate ([-rg45_cut_dim.x/2,0,0])
		cube (rg45_cut_dim);
	
	translate ([-rg45_cut_dim.x/2+rg45_pins2.z,rg45_pins2.y,0])
		cube ([rg45_cut_dim.x-rg45_pins2.z*2,20,maxh]);
	
	hull()
	for (x=[-1,1])
		translate ([x*rg45_legs.x,rg45_legs.y,0])
			cylinder (d=3.6,h=maxh,$fn=20);
	
	for (x=[-1,1])
		translate ([x*(rg45_cut_dim.x/2+rg45_leg2.x),rg45_leg2.y,0])
			cylinder (d=2.4,h=maxh,$fn=20);
	
	translate ([-rg45_pins.x/2,rg45_pins.y,rg45_cut_dim.z-0.01])
		cube ([rg45_pins.x,rg45_cut_dim.y-rg45_pins.y,maxh-rg45_cut_dim.z]);
	
	for (m=[0,1])
		mirror([m,0,0])
			translate ([rg45_pins2.x/2,rg45_pins2.y,rg45_cut_dim.z-0.01])
				cube ([(rg45_cut_dim.x-rg45_pins2.x)/2,rg45_cut_dim.y-rg45_pins2.y,maxh-rg45_cut_dim.z]);
}

module rj45_split()
{
	translate ([-50,-1,-5])
		cube([100,100,7]);
}

module rj45_to_case(offs=0)
{
	translate ([-rj45_dim().x/2-offs,-offs,-offs])
		cube (vec_add(rj45_dim(),[offs*2,offs*2,offs*2]));
}

module rj45(report=false)
{
	if (report)
		report_rj45();
	union()
	{
		difference()
		{
			translate ([-rj45_dim().x/2,0,0])
			union()
			{
				cube (rj45_dim());
				translate ([0,10,0])
				rotate ([90,0,90])
					slot_groove(height=rj45_dim().x,enabled=true,big=true);
			}
			translate ([0,-0.01,rg45_up])
				rj45_cut();
			
			for (x=[-1,1])
			{
				if (report)
					report_m5_point();
				translate ([(rg45_cut_dim.x/2+fix_offs)*x,10,5])
				rotate ([0,180,0])
					m5n_screw_washer(thickness=5, diff=2, washer_diameter=11.2+0.3, washer_out=40, tnut=true);
			}
		}
		for (x=[-1,1])
		{
			translate ([(rg45_cut_dim.x/2+fix_offs)*x,10,5])
			rotate ([0,180,0])
				m5n_screw_washer_add();
		}
	}
}

module rj45_bottom()
{
	intersection()
	{
		rj45(report=true);
		rj45_split();
	}
}

module rj45_top()
{
	difference()
	{
		rj45();
		translate ([0,0,0.1])
			rj45_split();
	}
}

//rj45_bottom();
//rj45_top();
rj45();
#rj45_to_case(offs=0.2);