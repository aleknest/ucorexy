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
include <../_utils_v2/NopSCADlib/vitamins/pulleys.scad>

module y_carriage_flag(part="",y_magnet_out=5.5)
{
	offs=0.2;
	y_magnet_outd=4;
	y_magnet_fixdiff=6;
	y_magnet_fixd=6.5;
	y_magnet_thickness=2;
	screw=8;
	if (part=="cut")
	{
		translate ([0,0,-y_magnet_thickness-offs+0.01])
		hull()
		for (x=[-y_magnet_fixdiff,y_magnet_fixdiff])
			translate([0,x,0])
				cylinder(d=y_magnet_fixd+offs*2,h=y_magnet_thickness+offs,$fn=60);
		y_carriage_flag(part="fix");
	}
	if (part=="detail")
	{
		difference()
		{
			union()
			{
				fillet(r=1,steps=1)
				{
					translate ([0,0,-y_magnet_thickness+0.01])
					hull()
					for (x=[-y_magnet_fixdiff,y_magnet_fixdiff])
						translate([0,x,0])
							cylinder(d=y_magnet_fixd,h=y_magnet_thickness,$fn=60);
					cylinder(d=y_magnet_outd,h=y_magnet_out,$fn=60);
				}
			}
			report_magnet(y_magnet_d(),y_magnet_h());
			translate ([0,0,y_magnet_out+0.02])
			rotate ([180,0,0])
			{
				magnet_cut(magnet_d=y_magnet_d(),magnet_h=y_magnet_h());
				cylinder (d=1.6,h=100,$fn=20);
			}
			y_carriage_flag(part="fix");
		}
	}
	if (part=="fix")
	{
		for (x=[-y_magnet_fixdiff,y_magnet_fixdiff])
			translate([0,x,0])
			rotate ([0,180,0])
			{
				report_m3_washer_squarenut(screw);
				
				m3_screw(h=screw,cap_out=20);
				translate ([0,0,screw-3])
				rotate ([0,0,90])
					m3_square_nut();
			}
	}
}

module y_carriage(part)
{
	tr=part=="left"?y_rail_left_tr():y_rail_right_tr();
	up=2;
	dim_plate=[carriage_length(rail_carriage(y_rail_type()))
		,carriage_width(rail_carriage(y_rail_type()))+y_carriage_sidethickness()
		,carriage_height(rail_carriage(y_rail_type()))-up+y_carriage_thickness()];
	ttr=tr_add(tr,[0,0
		,-(carriage_height(rail_carriage(y_rail_type()))-up-carriage_height(rail_carriage(y_rail_type())))]);
	
	diff=1;
	dim_slot=[y_carriage_slot_crawl()+y_carriage_sidethickness()+y_pulley_xoffset_add()-diff
			,dim_plate.x
			,20+y_carriage_sidethickness()+y_carriage_thickness()];
	ttr_slot=part=="left"?
		[[tr[0].x+10+diff,tr[0].y,x_slot_tr()[0].z-10-y_carriage_sidethickness()],[0,0,0]]
		:
		[[tr[0].x-10-diff,tr[0].y,x_slot_tr()[0].z-10-y_carriage_sidethickness()],[0,0,180]];
	
	etr=[[y_endstop_tr()[0].x,ttr[0].y-dim_plate.x/2,y_endstop_tr()[0].z],[0,90,ttr[1].z]];
	
	screw=10;
	screw2=part=="left"?6:screw;
	screw_in=3;
	
	pulleys=part=="left"?
	[
		 [y_leftfront_pulley_tr(),270,25,15]
		,[y_leftback_pulley_tr(),0,25,8]
	]:[
		 [y_rightback_pulley_tr(),90,25,15]
		,[y_rightfront_pulley_tr(),180,25,8]
	];
	
	belt_cut=part=="left"?[
		y_leftfront_pulley_tr()[0].x-pulley_od(y_pulley_type())/2-pulley_od(motor_pulley_type())
		,0,y_leftfront_pulley_tr()[0].z
		]:[
		y_rightfront_pulley_tr()[0].x+pulley_od(y_pulley_type())/2+pulley_od(motor_pulley_type())
		,0,y_rightfront_pulley_tr()[0].z
		];
		
	if (part=="flag")
	{
		translate_rotate (etr)
			y_carriage_flag(part="detail");
	}
	else
	{
		union()
		{
			difference()
			{
				union()
				{
					fillet (r=4,steps=10)
					{
						{
							translate_rotate (ttr)
							translate ([-dim_plate.x/2,-dim_plate.y/2-y_carriage_sidethickness()/2,0])
							{
								//#cube (dim_plate);
								translate ([dim_plate.x,0,0])
								rotate ([0,-90,0])
								linear_extrude(dim_plate.x)
									polygon(polyRound([
										 [0,0,0]
										,[dim_plate.z,0,0]
										,[dim_plate.z,dim_plate.y,12]
										,[0,dim_plate.y,0]
									],1));
							}
							
							translate_rotate (ttr_slot)
							translate ([0,-dim_slot.y/2,0])
								cube (dim_slot);
						}
					}
				}
				roffs=0.2;
				rw=rail_width(x_rail_type())+roffs*2;
				rh=100;
				translate(x_slot_tr()[0])
				translate ([-x_rail()/2-roffs,10-rh,-rw/2])
					cube ([x_rail()+roffs*2,rh,rw]);
				
				offs=0.1;
				translate_rotate (tr)
				translate ([-carriage_length(rail_carriage(y_rail_type()))/2-1
					,-carriage_width(rail_carriage(y_rail_type()))/2-offs
					,0])
						cube ([carriage_length(rail_carriage(y_rail_type()))+2
							,carriage_width(rail_carriage(y_rail_type()))+offs*2
							,carriage_height(rail_carriage(y_rail_type()))]);
				
				translate_rotate (tr)
				for (x=[-1,1])
				for (y=[-1,1])
					translate ([carriage_pitch_x(rail_carriage(y_rail_type()))/2*x
						,carriage_pitch_y(rail_carriage(y_rail_type()))/2*y
						,carriage_height(rail_carriage(y_rail_type()))+screw-screw_in])
					rotate ([180,0,0])
					{
						scr=y==-1?screw2:screw;
						down=screw-scr;
						translate ([0,0,down])
						{
							report_m3_washer(scr);
							m3_screw(h=scr);
							hull()
							{
								m3_washer(out=60);
								if (y==1)
									translate ([0,-20,0])
										m3_washer(out=60);
							}
						}
					}
					
				translate_rotate (ttr_slot)
				translate([-1,0,10+y_carriage_sidethickness()])
				rotate ([0,90,0])
					slot_cut(height=dim_slot.x+2);			
					
				screw_offset=7;
				for (a=[0,90,180])
				{
					report_m5_point();
					translate_rotate (ttr_slot)
					translate ([0,0,10+y_carriage_sidethickness()])
					rotate ([a,0,0])
					translate ([screw_offset,-10-4,0])
					rotate ([-90,0,0])
						m5n_screw_washer(thickness=4,diff=2, washer_out=20);
				}
		
				for (p=pulleys)		
					translate_rotate(p[0])
						pulley_cut(pulley_type=y_pulley_type(),op=0,angle=p[1],screw=p[2],up=p[3],report=true);
				
				translate (belt_cut)
					cube ([1.52+2,100,6+2],true);
				
				if (part=="right")
				{
					translate_rotate (etr)
						y_carriage_flag(part="cut");
				}
			}
			for (p=pulleys)		
				translate_rotate(p[0])
					pulley_cut(pulley_type=y_pulley_type(),op=1,angle=p[1],screw=p[2],up=p[3]);
		}
	}
}

module y_carriage_left()
{
	y_carriage(part="left");
}

module y_carriage_right()
{
	y_carriage(part="right");
}

module y_carriage_right_flag()
{
	y_carriage(part="flag");
}

//proto_y_left(yposition=0);
//translate ([0,y_rail_y(),0]) proto_x(xposition=-55);
//proto_y_right(yposition=0);
//y_carriage_left();
y_carriage_right();
//y_carriage_right_flag();
