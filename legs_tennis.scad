use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>

thickness=3;

ball_diameter=64;
ball_diameter_outer=ball_diameter+thickness*2;

ball_cut=1/5;
ballcap_cut=1/3;

rays=[2,30,ball_diameter/2+ball_diameter*ball_cut+thickness];

module proto_ball()
{
	color ("#00FF00")
	translate ([0,0,-ball_diameter_outer/2])
		sphere(d=ball_diameter,$fn=40);
}

module base(add=0,fn=200)
{
	sphere(d=ball_diameter_outer+add*2,$fn=fn);
}

module tbase(add=0,fn=200)
{
	translate ([0,0,-ball_diameter_outer/2])
		base(add=add,fn=fn);
}

module base_sphere()
{
	difference()
	{
		base();
		sphere(d=ball_diameter,$fn=200);
		translate ([-ball_diameter,ball_diameter,-ball_diameter*ball_cut])
		rotate ([180,0,0])
			cube ([ball_diameter*2,ball_diameter*2,ball_diameter]);
	}
}

module ray ()
{
	intersection()
	{
		translate ([0,0,-ball_diameter_outer/2])
			base_sphere();
		translate ([-rays[1]/2,0,-rays[2]])
		{
			dim=[rays[1],100,rays[2]];
			//cube (dim);
			translate ([0,0,dim.z])
			rotate ([-90,0,0])
			linear_extrude(dim.y)
				polygon(polyRound([
					 [0,0,0]
					,[dim.x,0,0]
					,[dim.x,dim.z,dim.x/2]
					,[0,dim.z,dim.x/2]
				],20));
		}
	}
}

module rays_array ()
{
	angle=360/rays[0];
	for (a=[0:rays[0]-1])
		rotate ([0,0,a*angle])
			ray ();
}

module cap ()
{
	intersection()
	{
		translate ([0,0,-ball_diameter_outer/2])
			base_sphere();
		translate ([-ball_diameter,-ball_diameter,-ballcap_cut*ball_diameter])
		{
			cube ([ball_diameter*2,ball_diameter*2,ball_diameter]);
		}
	}
}

module bottom()
{
	union()
	{
		rays_array ();
		cap();
	}
}

module tennis_leg()
{
	h=12;
	th=6;
	add=10;
	difference()
	{
		union()
		{
			difference()
			{
				//union()
				fillet (r=8,steps=$preview?8:16)
				{
					translate ([0,0,h-thickness])
					translate ([-10,-10,-h-add])
						cube ([20,20,h+add]);
					tbase(add=-0.01,fn=80);
				}
				tbase();
			}
			bottom();
		}
		translate ([0,0,h-thickness])
		translate([0,0,-th])
			m6n_screw_washer(thickness=th,diff=2, washer_out=20);
	}
}

//proto_ball();
tennis_leg();
