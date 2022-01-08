use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
use <ss443a.scad>

include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/pulleys.scad>

module front_motorblock(part,report=false)
{
	fix_offs=[5.1,10];
	
	washer_out=part=="left"?5:5+lrz_xymotor_alt_diff();
	tr=part=="left"?leftfront_motorblock_alt_tr():rightfront_motorblock_alt_tr();
	motor_tr=part=="left"?left_motor_alt_tr():right_motor_alt_tr();
	dim=part=="left"?leftfront_motorblock_alt_dim():rightfront_motorblock_alt_dim();
	thickness=part=="left"?leftfront_motorblock_alt_thickness():rightfront_motorblock_alt_thickness();
	fixes=part=="left"?[
		 [[z_slot_leftfront_tr()[0].x,z_slot_leftfront_tr()[0].y,z_slot_topfront_tr()[0].z+10+5],false]
		,[[leftfront_motorblock_alt_tr()[0].x+leftfront_motorblock_alt_dim().x-leftfront_motorblock_alt_thickness()[3]-fix_offs[0]
			,z_slot_leftfront_tr()[0].y
			,z_slot_topfront_tr()[0].z+10+5],true]
		,[[z_slot_leftfront_tr()[0].x
		,leftfront_motorblock_alt_tr()[0].y+leftfront_motorblock_alt_dim().y-fix_offs[1]
		,z_slot_topfront_tr()[0].z+10+5],true]
	]:[
		 [[z_slot_rightfront_tr()[0].x,z_slot_rightfront_tr()[0].y,z_slot_topfront_tr()[0].z+10+5],false]
		,[[rightfront_motorblock_alt_tr()[0].x-rightfront_motorblock_alt_dim().x+rightfront_motorblock_alt_thickness()[3]+fix_offs[0]
			,z_slot_rightfront_tr()[0].y
			,z_slot_topfront_tr()[0].z+10+5],true]
		,[[z_slot_rightfront_tr()[0].x
		,rightfront_motorblock_alt_tr()[0].y-fix_offs[1]
		,z_slot_topfront_tr()[0].z+10+5],true]
	];
	
	
	difference()
	{
		union()
		{
			translate_rotate(tr)
			{
				linear_extrude (dim.z)
					polygon(polyRound([
						 [0,0,part=="left"?3:0]
						,[0,dim.y,,part=="left"?0:3]
						,[dim.x,dim.y,3]
						,[dim.x,0,3]
					],1));
			}
		
			left_groove_tr=tr_replace(tr_replace(tr,0,z_slot_leftfront_tr()[0].x),1,z_slot_leftfront_tr()[0].y-10);
			right_groove_tr=tr_replace(tr_replace(tr,0,z_slot_rightfront_tr()[0].x),1,z_slot_leftfront_tr()[0].y+dim.y-10);
			if (part=="left")
			{
				translate_rotate(left_groove_tr)
				translate ([10,10,0])
				rotate ([-90,0,-90])
					slot_groove(height=dim.x-(z_slot_leftfront_tr()[0].x-tr[0].x)-10, enabled=true, big=true);
			}
			if (part=="right")
			{
				translate_rotate(right_groove_tr)
				translate ([10,dim.y-10,0])
				rotate ([-90,0,-90])
					slot_groove(height=dim.x-(tr[0].x-z_slot_rightfront_tr()[0].x)-10, enabled=true, big=true);
			}
		}
		
		translate_rotate(tr)
			translate ([0,dim.y+1,0])
			rotate ([90,0,0])
			linear_extrude (dim.y+2)
				polygon(polyRound([
					 [thickness[1],thickness[0],4]
					,[thickness[1],dim.z-thickness[2],4]
					,[dim.x-thickness[3],dim.z-thickness[2],4]
					,[dim.x-thickness[3],thickness[0],4]
				],20));
		
		for (f=fixes)
		{
			translate(f[0])
			rotate ([180,0,0])
			{
				if (f[1])
				{
					if (report) report_m5_point();
					m5n_screw_washer(thickness=5,diff=2, washer_out=washer_out,washer_spere=true,tnut=true);
				}
				else
				{
					if (report) report_m6_washer(12);
					m6n_screw_washer(thickness=5,diff=2, washer_out=washer_out-2,washer_spere=true);
				}
			}
		}
		
		translate_rotate(motor_tr)
			nema17_cut(washers=true,washers_sphere=true,shaft_length=20,main_cyl=true,report=report);
		
		cut_r=14;
		if (part=="left")
		{
			translate_rotate(tr)
			{
				translate ([0,-20,-thickness[2]])
				rotate ([90,0,90])
				{
					linear_extrude(dim.x)
						polygon(polyRound([
							 [0,0,0]
							,[dim.y,0,0]
							,[dim.y,dim.z,cut_r]
							,[0,dim.z,0]
						],20));
				}
			}
		}
		if (part=="right")
		{
			translate_rotate(tr)
			{
				translate ([0,20,-thickness[2]])
				rotate ([90,0,90])
				{
					linear_extrude(dim.x)
						polygon(polyRound([
							 [0,0,0]
							,[dim.y,0,0]
							,[dim.y,dim.z,0]
							,[0,dim.z,cut_r]
						],20));
				}
			}
			
			if (report) report_SS443a();
			translate_rotate (y_endstop_alt_tr())
				SS443A(SS443A_out=4,SS443A_yout=8,SS443A_yout_addthickness=8+4);
			
			yy=7;
			screws_tr=[
				 [[-3.7,-0.2,yy],[-90,90,0]]
				,[[-15.7-9,-0.2,yy],[-90,0,0]]
			];
			screw=6;
			for (s=screws_tr)
			{
				if (report) report_m3_washer_squarenut(screw);
				translate (s.x)
				translate_rotate(tr)
				rotate (s.y)
				{
					m3_screw(h=screw);
					translate ([0,0,screw-2.5])
						m3_square_nut();
				}
			}
		}
	}
}

module y_endstop_cut(offs=[0,0])
{
	translate ([0,offs.x,-offs.y])
	translate_rotate (y_endstop_alt_tr())
		SS443A_cut(y_SS443A_cut().x,y_SS443A_cut().y);
}

module leftfront_motorblock()
{
	front_motorblock(part="left",report=true);
}
module rightfront_motorblock()
{
	difference()
	{
		front_motorblock(part="right",report=true);
		y_endstop_cut();
	}
}

module y_endstop_lock()
{
	intersection()
	{
		front_motorblock(part="right");
		y_endstop_cut(offs=[0.1,0.2]);
	}
}

module nut(G=undef,H,S=undef)
{
    // G,e
	// S,F
    //R = 0.5; A = 0; x = cos(A) * R; y = sin(A) * R;
	
	gg=str(S) != "undef" ? S/cos(30) : G;
	
    nut_points=[
	 [0.5,0]
	,[0.25,0.433013]
	,[-0.25,0.433013]
	,[-0.5,0]
	,[-0.25,-0.433013]
	,[0.25,-0.433013]
    ];

    scale ([gg,gg,1])
    linear_extrude(H)
	polygon (points=nut_points);
}

module m6_screw_driver()
{
	fillet (r=2,steps=12)
	{
		s=4.8;
		h=12;
		cut=0.6;
		hh=3;
		
		nut(H=h-cut,S=s);	
		translate ([0,0,h-cut-0.1])
		hull()
		{
			nut(H=0.1,S=s);
			translate ([0,0,cut])
				nut(H=0.1,S=s-cut*2);
		}
		hull()
		{
			nut(H=2,S=s+2);
			translate ([20,0,0])
				cylinder(h=2,d=s+4);
		}
	}
}

yposition=-55;
xposition=55;

m6_screw_driver();

//proto_front_slots();

//proto_xybelts_alt(yposition=yposition);
//proto_xymotors_alt();

//leftfront_motorblock();
//rightfront_motorblock();
//y_endstop_lock();

//use <ycarriage.scad>
//proto_y_right(yposition=yposition);
//translate ([0,yposition,0]) {y_carriage_right();y_carriage_right_flag();}

//use <xcarriage.scad>
//proto_x();
//translate ([0,-y_rail_y(),0]) proto_xybelts(xposition=0,yposition=0);

//proto_x_blowers();
//x_carriage_fans();

translate ([xposition,y_rail_y()+yposition,0])
{
//	x_carriage_main();
	//x_carriage_front();
}
