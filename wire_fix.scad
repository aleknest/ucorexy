use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
use <ss443a.scad>


module wire_fix_corner_side()
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
module wire_fix_lefttop_corner_side()
{
	translate (y_slot_left_tr()[0])
	translate ([10,-y_slot()/2,-10])
		wire_fix_corner_side();
}
module wire_fix_righttop_corner_side()
{
	translate (y_slot_right_tr()[0])
	translate ([-10,-y_slot()/2,-10])
	mirror([1,0,0])
		wire_fix_corner_side();
}


function replace_3 (arg,a3)=[arg[0],arg[1],a3];
function replace_corners (points,corners)=[for (i=[0:len(points)-1]) [points[i].x,points[i].y,corners[i]]];
module wire_fix_corner_top()
{
	length=10;
	cut=[8,7,7];
	thickness=[0,2,length-cut.y,5];
	rnd=[
		[0,0,0,0]
	];
	top_sub=0.5;
	
	report_m5_point();
	difference()
	{
		translate ([-20,0,0])
		{
			dim=[20+cut.x+thickness[0]+thickness[1],cut.y+thickness[2],20+thickness[3]-top_sub];
			points=[[0,0,0],[dim.x,0,0],[dim.x,dim.y,0],[0,dim.y,0]];
			p1=replace_corners(points,[0,0,20,0]);
			p2=replace_corners(points,[2,0,0,2]);
			intersection()
			{
				linear_extrude(dim.z)
					polygon(polyRound(p1,60));
				linear_extrude(dim.z)
					polygon(polyRound(p2,1));
			}
		}
		
		translate ([-10,-0.01,10])
		rotate ([-90,0,0])
		difference()
		{
			slot_cut(height=100);
			/*
			translate([10,0,thickness[1]])
			rotate ([0,0,90])
				slot_groove(height=100, enabled=true, big=true);
			*/
			translate([0,-10,0])
				slot_groove(height=100, enabled=true, big=true);
		}
		
		translate ([thickness[0]-0.01,-0.01,-1])
		{
			dim=[cut.x,cut.y,40];
			p3=[[0,0,0],[dim.x,0,0],[dim.x,dim.y,cut[2]],[0,dim.y,0]];
			linear_extrude(dim.z)
				polygon(polyRound(p3,60));
			//cube(dim);
		}
		
		translate ([-10,5,20+thickness[3]])
		rotate ([180,0,0])
			m5n_screw_washer(thickness=thickness[3],diff=1.1,tnut=true);
	}
}

module wire_fix_corner_top_left()
{
	translate (y_slot_left_tr()[0])
	translate ([10,-y_slot()/2,-10])
		wire_fix_corner_top();
}

module wire_fix_corner_top_right()
{
	translate (y_slot_right_tr()[0])
	translate ([-10,-y_slot()/2,-10])
	mirror([1,0,0])
		wire_fix_corner_top();
}

//proto_front_slots();

//wire_fix_lefttop_corner_side();
//wire_fix_righttop_corner_side();

wire_fix_corner_top_left();
//wire_fix_corner_top_right();
//#wire_fix_corner_side();