use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/rails.scad>
use <zmotion.scad>
use <xt90.scad>
use <slot_cover.scad>

case_top_screw=8;
case_top_in=case_top_screws_offset()-4;
slot_cover_offs=0.6;

module case_side(tr,length,screws,c45)
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
					//#cube(dim);
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
		case_top_screws_cut();
	}
}

module case_front()
{
	tr=[vec_add(z_slot_bottomfront_tr()[0],[front_back_slot()/2-case_offset(),-10,10]),[0,90,0]];
	length=front_back_slot()-case_offset()*2;
	screws=[case_screws_offset(),front_back_slot()-case_screws_offset()];
	c45=3;
	
	difference()
	{
		case_side(tr,length,screws,c45);
		
		translate_rotate(z_slot_rightfront_tr())
		rotate([0,0,-90])
		translate ([0,-10-1,-z_slot()/2])
			slot_cover_cut(h=z_slot(),down=1,offs=slot_cover_offs);
		
		up=6;
		translate_rotate(z_slot_leftfront_tr())
		rotate([0,0,90])
		translate ([0,-10-1,-z_slot()/2])
			slot_cover_cut(h=z_slot(),up=up,down=1,offs=slot_cover_offs);
	}
}
module case_right()
{
	tr=[vec_add(y_slot_bottomright_tr()[0],[10,y_slot()/2-case_offset(),10]),[0,90,90]];
	echo(tr);
	length=y_slot()-case_offset()*2;
	screws=[case_screws_offset(),y_slot()-case_screws_offset()];
	c45=3;
	
	roffs=0.2;
	rw=rail_width(z_rail_type())+roffs*2;
	rh=rail_height(z_rail_type())+roffs;
	
	difference()
	{
		case_side(tr,length,screws,c45);
		
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
						translate ([offs[1],0,0])
							cylinder (d=m3_screw_diameter()+offs[0]*2,h=case_top_screw+1,$fn=60);
						cylinder (d=m3_screw_diameter()+offs[0]*2,h=case_top_screw+1,$fn=60);
					}
				}
				else
				{
					if (report)
						report_m3_washer_squarenut(case_top_screw);
					m3_screw(h=case_top_screw+1,cap_out=20);
				}
				translate ([0,0,case_top_screw-3])
				rotate ([0,0,90])
					m3_square_nut();
			}
		}
}

module case_top_screws_add()
{
	cadd=[2,1];
	translate(case_top_tr())
		for (s=case_top_screws())
		{
			dim=[case_top_screws_offset()*2+cadd.x*2,case_top_screws_offset()*2+cadd.y*2,8+s[2]];
			
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
		case_top_screws_cut(report=true,offs=[0.6,10]);
	}
}


//proto_slot_brackets();
//proto_front_slots();
//proto_other_slots();

//proto_back_slots();

//proto_z_belt_motor();
//zmotion_bottom();

//xt90();

//case_front();
//case_right();
//case_left();
//case_backleft();
//case_backright();

case_top();