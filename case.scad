use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/rails.scad>
use <zmotion.scad>
use <xt90.scad>
use <slot_cover.scad>
use <rj45.scad>
include <../_utils_v2/NopSCADlib/vitamins/fan.scad>
include <../_utils_v2/NopSCADlib/vitamins/fans.scad>

case_top_screw=10;
case_top_in=case_top_screws_offset()-4;
slot_cover_offs=0.6;

is_m5_screw=true;

module case_side(tr,length,screws,c45,report=false)
{
	r=8;
	points1=polyRound([
					 [0,0,0]
					,[case_height(),0,r]
					,[case_height(),20+case_up(),0]
					,[case_height()-case_thickness()[1],20+case_up(),0]
					,[case_height()-case_thickness()[1],case_thickness()[0],r]
					,[case_thickness()[2],case_thickness()[0],0]
					,[case_thickness()[2],20,0]
					,[0,20,0]
				],20);
	points2=polyRound([
					 [0,0,0]
					,[case_height(),0,r]
					,[case_height(),20+case_up(),0]
					,[0,20+case_up(),0]
				],20);

	difference()
	{
		union()
		{
			intersection()
			{
				union()
				{
					translate_rotate (tr)
					rotate ([0,180,0])
						linear_extrude(length)
							polygon (points1);
					case_top_screws_add();
				}
				
				dim=[length,20+case_up(),case_height()];
				translate_rotate (tr)
				translate([-dim.z,0,0])
				rotate ([0,90,0])
				{
					cc1=(c45==1 || c45==3)?case_up()+0.2:0;
					cc2=(c45==2 || c45==3)?case_up()+0.2:0;
					linear_extrude(dim.z)
						polygon(polyRound([
							 [0,0,0]
							,[dim.x,0,0]
							,[dim.x,dim.y,cc1]
							,[0,dim.y,cc2]
						],1));
				}
			}
			
			for (screw=screws)
			{
				intersection()
				{
					translate_rotate (tr)
					translate ([0,10,-screw])
					rotate ([0,-90,0])
					{
						dd=20;
						cylinder(d=dd,h=case_height(),$fn=80);
						translate ([-dd/2,-dd,0])
							cube ([dd,dd,case_height()]);
					}
					
					translate_rotate (tr)
					rotate ([0,180,0])
						linear_extrude(length)
							polygon (points2);
				}
			}
		}
		
		for (screw=screws)
		{
			report_m5_point();

			translate_rotate (tr)
			translate ([-case_thickness()[2],10,-screw])
			rotate ([0,90,0])
				m5n_screw_washer(thickness=case_thickness()[2],diff=2,washer_out=100,tnut=true);		
			
			translate_rotate (tr)
			translate ([-case_thickness()[2],10,-screw])
			rotate ([0,-90,0])
			{
				dd=12;
				cylinder(d=dd,h=case_height(),$fn=80);
				translate ([-dd/2,-dd,0])
					cube ([dd,dd,case_height()]);
			}
		}
		
		for (btr=brackets_tr(2000))
		{
			offs=0.4;
			translate_rotate(btr)
			translate ([0,0,-10-0.01])
				linear_extrude (20+0.02)
				polygon ([
					[-0.01,-0.01]
					,[20+offs,-0.01]
					,[20+offs,4+offs]
					,[4+offs,20+offs]
					,[-0.01,20+offs]
				]);
		}
		case_top_screws_cut(report=report);
	}
}

module case_front(rj45=false)
{
	tr=[vec_add(z_slot_bottomfront_tr()[0],[front_back_slot()/2-case_offset(),-10,10]),[0,90,0]];
	length=front_back_slot()-case_offset()*2;
	screws=[case_screws_offset(),front_back_slot()-case_screws_offset()];
	c45=3;
	
	difference()
	{
		case_side(tr,length,screws,c45,report=true);
		
		translate_rotate(z_slot_rightfront_tr())
		rotate([0,0,-90])
		translate ([0,-10-1,-z_slot()/2])
			slot_cover_cut(h=z_slot(),down=1,offs=slot_cover_offs);
		
		up=6;
		translate_rotate(z_slot_leftfront_tr())
		rotate([0,0,90])
		translate ([0,-10-1,-z_slot()/2])
			slot_cover_cut(h=z_slot(),up=up,down=1,offs=slot_cover_offs);

		if (rj45)
		translate (tr[0])
		translate ([-length/2,0,0])
			rj45_to_case(offs=0.2);
	}
}

module case_right()
{
	tr=[vec_add(y_slot_bottomright_tr()[0],[10,y_slot()/2-case_offset(),10]),[0,90,90]];
	length=y_slot()-case_offset()*2;
	screws=[case_screws_offset(),y_slot()-case_screws_offset()];
	c45=3;
	
	roffs=0.2;
	rw=rail_width(z_rail_type())+roffs*2;
	rh=rail_height(z_rail_type())+roffs;
	
	difference()
	{
		union()
		{
			difference()
			{
				union()
				{
					case_side(tr,length,screws,c45);
					translate_rotate(case_fan_tr())
						case_fan(op="add");
				}
				translate_rotate(case_fan_tr())
					case_fan(op="sub");
			}
			translate_rotate(case_fan_tr())
				case_fan(op="screw_add");
		}
		translate_rotate(case_fan_tr())
			case_fan(op="screw_sub");
		
		translate(z_right_rail_tr()[0])
		translate ([-rw/2,-rh,-z_rail()/2])
			cube ([rw,rh,z_rail()]);
		
		translate_rotate(z_slot_rightfront_tr())
		rotate([0,0,180])
		translate ([0,-10-1,-z_slot()/2])
			slot_cover_cut(h=z_slot(),down=1,offs=slot_cover_offs);
	}
}

module case_left()
{
	tr=[vec_add(y_slot_bottomleft_tr()[0],[-10,-y_slot()/2+case_offset(),10]),[0,90,-90]];
	length=y_slot()-case_offset()*2;
	screws=[case_screws_offset(),y_slot()-case_screws_offset()];
	c45=3;
	
	roffs=0.2;
	rw=rail_width(z_rail_type())+roffs*2;
	rh=rail_height(z_rail_type())+roffs;
	
	difference()
	{
		offs=0.2;
		case_side(tr,length,screws,c45);
		
		translate_rotate(xt90_tr())
		translate ([-xt90_dim().x/2-offs,20-xt90_dim().y-10,0])
			cube ([xt90_dim().x+offs,xt90_dim().y+10*2,xt90_dim().z+offs]);
		
		translate(z_left_rail_tr()[0])
		translate ([-rw/2,-rh,-z_rail()/2])
			cube ([rw,rh,z_rail()]);
		
		translate_rotate(z_slot_leftfront_tr())
		rotate([0,0,180])
		translate ([0,-10-1,-z_slot()/2])
			slot_cover_cut(h=z_slot(),down=1,offs=slot_cover_offs);
	}
}

module case_backleft()
{
	tr=[vec_add(z_slot_bottomback_tr()[0],[-front_back_slot()/2+case_offset(),10,10]),[0,90,180]];
	length=41;
	screws=[30];
	c45=2;
	difference()
	{
		case_side(tr,length,screws,c45);
		
		translate_rotate(z_slot_leftback_tr())
		rotate([0,0,90])
		translate ([0,-10-1,-z_slot()/2])
			slot_cover_cut(h=z_slot(),down=1,offs=slot_cover_offs);
	}
}

module case_backright()
{
	ll=32;
	tr=[vec_add(z_slot_bottomback_tr()[0],[front_back_slot()/2-ll-case_offset(),10,10]),[0,90,180]];
	length=ll;
	screws=[5.2];
	c45=1;
	
	difference()
	{
		case_side(tr,length,screws,c45);
	
		translate_rotate(z_slot_rightback_tr())
		rotate([0,0,-90])
		translate ([0,-10-1,-z_slot()/2])
			slot_cover_cut(h=z_slot(),down=1,offs=slot_cover_offs);
	}
}

module case_top_screws_cut(report=false,offs=[0,0])
{
	translate(case_top_tr())
		for (s=case_top_screws())
		{
			translate (s[0])
			rotate (s[1])
			translate ([0,0,case_top_thickness()-s[2]])
			rotate ([0,180,0])
			{
				if (offs!=[0,0])
				{
					translate ([0,0,-0.01])
					hull()
					{
						dd=is_m5_screw?m5_screw_diameter():m3_screw_diameter();
						translate ([offs[1],0,0])
							cylinder (d=dd+offs[0]*2,h=case_top_screw+1,$fn=60);
						cylinder (d=dd+offs[0]*2,h=case_top_screw+1,$fn=60);
					}
				}
				else
				{
					if (is_m5_screw)
					{
						if (report)
						{
							report_m5_hexnut();
							report_m5_bolt(case_top_screw);
						}
						m5_screw(h=case_top_screw+6,cap_out=20);
					}
					else
					{
						if (report)
							report_m3_washer_squarenut(case_top_screw);
						m3_screw(h=case_top_screw+1,cap_out=20);
					}
				}
				translate ([0,0,case_top_screw-3])
				rotate ([0,0,90])
				{
					if (is_m5_screw)
					{
						hull()
						{
							rotate ([0,0,90])
								m5_nut();
							translate ([0,10,0])
							rotate ([0,0,90])
								m5_nut();
						}
						translate ([0,4.5,0])
						scale ([1.1,1,1])
						hull()
						{
							rotate ([0,0,90])
								m5_nut();
							translate ([0,10,0])
							rotate ([0,0,90])
								m5_nut();
						}
					}
					else
					{
						m3_square_nut();
					}
				}
			}
		}
}

module case_top_screws_add()
{
	cadd=[2,1];
	translate(case_top_tr())
		for (s=case_top_screws())
		{
			dim=[case_top_screws_offset()*2+cadd.x*2,case_top_screws_offset()*2+cadd.y*2,case_top_screw+2+s[2]];
			
			translate (s[0])
			rotate ([0,180,0])
			translate ([-dim.x/2,-dim.y/2,0])
			{
				cube (dim);
			}
		}
}

module case_top()
{
	dd=12;
	dim=vec_add(case_top_dim(),[-case_top_in*2,-case_top_in*2,0]);
	tr=vec_add(case_top_tr(),[case_top_in,case_top_in,0]);
	difference()
	{
		union()
		{	
			translate(tr)
			{
				linear_extrude(dim.z)
					polygon(polyRound([
						 [0,0,dd/2]
						,[dim.x,0,dd/2]
						,[dim.x,dim.y,dd/2]
						,[0,dim.y,dd/2]
					],20));
			}
			translate(case_top_tr())
			translate([16,12,0])
			linear_extrude(case_top_thickness()+0.4)
				text (text="ucorexy",size=10,font="Free Sans:style=Bold");
		}
		case_top_screws_cut(report=false,offs=[0.6,10]);
		
		translate(tr)
		{
			offs=[17.5,26];
			xmax=21;
			ymax=19;
			dd=6;
			diff=dd+1;
			for (x=[0:xmax])
				for (y=[0:2:ymax])
					translate ([offs.x+x*diff,offs.y+y*diff,-1])
						rotate ([0,0,90])
							cylinder(d=6.6,h=10,$fn=6);
			for (x=[0:xmax-1])
				for (y=[1:2:ymax])
					translate ([offs.x+diff/2+x*diff,offs.y+y*diff,-1])
						rotate ([0,0,90])
							cylinder(d=6.6,h=10,$fn=6);
		}
	}
}


function case_fan_points(offs,down=0)=[
		 [-offs-fan_width(case_fan_type())/2+down,-offs-fan_width(case_fan_type())/2,4]
		,[+offs+fan_width(case_fan_type())/2,-offs-fan_width(case_fan_type())/2,4]
		,[+offs+fan_width(case_fan_type())/2,+offs+fan_width(case_fan_type())/2,4]
		,[-offs-fan_width(case_fan_type())/2+down,+offs+fan_width(case_fan_type())/2,4]
	];
module case_fan(op="add")
{
	offs=0.4;
	thickness=4;
	cut=thickness-1;
	down=fan_width(case_fan_type())-case_height()-case_fan_up()+4;//+thickness*2;
	if (op=="add")
	{
		translate([0,0,-case_fan_depth()-fan_depth(case_fan_type())/2])
		difference()
		{
			sequental_hull()
			{
				linear_extrude(0.1)
					polygon(polyRound(case_fan_points(thickness,down=down),20));
				translate([0,0,case_fan_depth()-thickness])
				linear_extrude(0.1)
					polygon(polyRound(case_fan_points(thickness),20));
				translate([0,0,case_fan_depth()+fan_depth(case_fan_type())-0.1])
				linear_extrude(0.1)
					polygon(polyRound(case_fan_points(thickness),20));
			}
			translate ([fan_width(case_fan_type())/2+thickness-cut
					,-fan_width(case_fan_type())/2-thickness-1
					,-50])
				cube ([cut+1,fan_width(case_fan_type())+thickness*2+2,100]);
		}
	}
	if (op=="sub")
	{
		translate([0,0,-case_fan_depth()-fan_depth(case_fan_type())/2])
		sequental_hull()
		{
			translate([0,0,-0.01])
			linear_extrude(0.1)
				polygon(polyRound(case_fan_points(offs,down=down),20));
			translate([0,0,case_fan_depth()-thickness])
			linear_extrude(0.1)
				polygon(polyRound(case_fan_points(offs),20));
			translate([0,0,case_fan_depth()+fan_depth(case_fan_type())+0.1])
			linear_extrude(0.1)
				polygon(polyRound(case_fan_points(offs),20));
		}
	}
	
	screw=16;
	screws=[
		 [[-fan_hole_pitch(case_fan_type()),-fan_hole_pitch(case_fan_type()),fan_depth(case_fan_type())/2],180]
		,[[fan_hole_pitch(case_fan_type()),-fan_hole_pitch(case_fan_type()),fan_depth(case_fan_type())/2],270]
		,[[fan_hole_pitch(case_fan_type()),fan_hole_pitch(case_fan_type()),fan_depth(case_fan_type())/2],0]
		,[[-fan_hole_pitch(case_fan_type()),fan_hole_pitch(case_fan_type()),fan_depth(case_fan_type())/2],90]
	];
	hh=screw+1;
	if (op=="screw_add")
	{
		dd=6;
		for (s=screws)
		{
			translate (s[0])
			translate([0,0,-hh])
			{
				cylinder(d=dd,h=hh-fan_depth(case_fan_type()),$fn=60);
				sphere(d=dd,$fn=60);
			}
		}
		intersection()
		{
			case_fan(op="add");
			for (s=screws)
			{
				hull()
				for (x=[10,0])
				for (y=[10,0])
					translate (s[0])
					rotate([0,0,s[1]])
					translate([x,y,-hh-dd])
						cylinder(d=dd,h=hh-fan_depth(case_fan_type())+dd,$fn=60);
			}
		}
	}
	if (op=="screw_sub")
	{
		dd=6;
		for (s=screws)
			translate (s[0])
			translate([0,0,-hh+0.1])
			{
				report_m3(screw);
				cylinder(d=3,h=hh,$fn=60);
			}
	}
}

module m5_cap()
{
	hhex=3.65;
	up=0.8;
	rays=10;
	angle=360/rays;
	
	difference()
	{
		for (a=[0:rays-1])
			rotate ([0,0,angle*a])
			fillet(r=0.4,steps=4)
			{
				dd=10;
				cylinder (d=dd,h=hhex+up,$fn=80);
				translate ([dd/2,0,0])
					cylinder (d=2,h=hhex+up,$fn=80);
			}
		translate ([0,0,up])
			cylinder (d=8.79+0.2,h=hhex+0.1,$fn=6);
		translate ([0,0,-0.1])
			cylinder(d=5.2,h=hhex,$fn=80);
	}
}

/*
translate_rotate(case_fan_tr())
{
	translate([0,0,0.1]) fan(case_fan_type());
	difference()
	{
		union()
		{
			difference()
			{
				case_fan(op="add");
				case_fan(op="sub");
			}
			case_fan(op="screw_add");
		}
		case_fan(op="screw_sub");
	}
}
*/

//proto_slot_brackets();
//proto_front_slots();
//proto_other_slots();

//proto_back_slots();

//proto_z_belt_motor();
//zmotion_bottom();

//xt90();

//case_front(rj45=true);
//case_left();
//case_right();

//case_backleft();
//case_backright();

case_top();

//m5_cap();