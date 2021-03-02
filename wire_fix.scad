use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
use <ss443a.scad>


module wire_fix_corner()
{
	thickness=5;
	cut=9.9;
	thickness_cut=[2,2];
	thickness_screw=3;
	width=26;
	offs=5;
	
	union()
	{
		difference()
		{
			union()
			{
				cube ([thickness,width,20]);
				translate ([0,0,10])
				rotate ([0,90,90])
					slot_groove(height=width-0.1, enabled=true, big=true);
			}
	
			translate ([-10,thickness_cut[0],-1])
				cube ([thickness-thickness_cut[1]+10,width-thickness_cut[0]*2-cut,22]);
		
			translate ([thickness_screw,width-offs,10])
			rotate ([0,-90,0])
			{
				report_m3(screw=8);
				report_m3_hexnut();
				m3n_screw_washer (thickness=thickness_screw,diff=1.1,washer_out=20,cap_only=true,tnut=true);
			}	
		}
		
		translate ([thickness_screw,width-offs,10])
		rotate ([0,-90,0])
			m3_screw_add();
	}
}
module wire_fix_lefttop_corner()
{
	translate (y_slot_left_tr()[0])
	translate ([10,-y_slot()/2,-10])
		wire_fix_corner();
}
module wire_fix_righttop_corner()
{
	translate (y_slot_right_tr()[0])
	translate ([-10,-y_slot()/2,-10])
	mirror([1,0,0])
		wire_fix_corner();
}

module wire_fix_front()
{
	thickness=10;
	cut=16;
	thickness_screw=3;
	width=32;
	offs=9;
	thickness_wall=3;
	
	translate (z_slot_topfront_tr()[0])
	translate ([-58,-10,10])
	{
		difference()
		{
			union()
			{
				cube ([width,20,thickness]);
				translate ([0,10,0])
				rotate ([90,0,90])
					slot_groove(height=width-0.1, enabled=true, big=true);
				translate ([0,10,thickness])
				rotate ([0,90,0])
				difference()
				{
					cylinder (d=20,h=width,$fn=80);
					translate ([0,0,-1])
						cylinder (d=20-thickness_wall,h=width+2,$fn=80);
					translate ([0,-11,-1])
						cube([100,22,width+2]);
					th=3;
					rotate ([0,0,180])
					translate ([0,-th/2,-1])
						cube([100,th,width+2]);
				}
			}
			translate ([width-offs,10,thickness_screw])
			rotate ([180,0,0])
			{
				report_m3(screw=8);
				report_m3_hexnut();
				m3n_screw_washer (thickness=thickness_screw,diff=1.1,washer_out=20,cap_only=true,tnut=true);
			}	
		}
	}
}

yposition=-55;
xposition=-55;

//proto_front_slots();
/*
proto_y_left(yposition=yposition);
proto_y_right(yposition=yposition);
*/

/*
use <ycarriage.scad>
translate ([0,yposition,0]) {y_carriage_left();}

use <xcarriage.scad>
translate ([xposition,y_rail_y()+yposition,0])
{
	proto_x();

	proto_x_blowers();
	x_carriage_fans();
	x_carriage_main();
	x_carriage_front();
}
*/

wire_fix_lefttop_corner();
//wire_fix_righttop_corner();
//wire_fix_front();