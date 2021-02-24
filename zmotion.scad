use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/pulleys.scad>
include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>

module belt (l,smooth=false,width_add=[0,0])
{
	belt_h=0.83;
	belt_h_m=belt_h+0.3;
	belt_width=7+width_add[0]+width_add[1];

	translate ([-belt_h_m,-belt_width/2-width_add[0]/2+width_add[1]/2,0])	
	{
		cube ([belt_h_m,belt_width,l]);
		if (smooth)
		{
			hull()
			for (z=[0,l])
				translate ([0,0,z])
				rotate ([-90,0,0])
					cylinder (d=1.1,h=belt_width,$fn=6);
		}
		else
		for (z=[0:2:l])
			translate ([0,0,z])
			rotate ([-90,0,0])
				cylinder (d=1.1,h=belt_width,$fn=6);
	}
}

module zpulley_cut(pulley_type,op=0,angle,screw,up,nut_type="hex",report=false)
{
	if (report) report_pulley(screw);
	offs=[1,1];
	dd=pulley_flange_dia(pulley_type)+offs[0]*2;
	hh=pulley_height(pulley_type)+offs[1]*2;
	if (op==0)
	{
		rotate ([0,0,angle])
		hull()
		{
			cylinder(d=dd
					,h=hh
					,center=true
					,$fn=60);
			translate([0,-25,0])
			cylinder(d=dd+dd
					,h=hh
					,center=true
					,$fn=60);
		}
		pulley_cut(pulley_type=pulley_type,op=2,angle=angle,screw=screw,up=up,nut_type=nut_type);
	}
	if (op==1)
	{
		dd=3+1;
		difference()
		{
			union()
			{
				translate([0,0,hh/2-offs[1]])
					cylinder(d1=dd,d2=dd+offs[1],h=offs[1],$fn=40);
				translate([0,0,-hh/2])
					cylinder(d2=dd,d1=dd+offs[1],h=offs[1],$fn=40);
			}
			pulley_cut(pulley_type=pulley_type,op=2,angle=angle,screw=screw,up=up,nut_type=nut_type);
		}
	}
	if (op==2)
	{
		translate ([0,0,up])
		rotate ([180,0,0])
		{
			m3_screw(h=screw,cap_out=60);
			translate ([0,0,screw-2.6])
			{
				if (nut_type=="hex")
				{
					m3_nut_inner();
					translate ([0,0,m3_nut_h()-0.01])
						m3_nut(20);
				}
				else
				if (nut_type=="square")
				{
					m3_square_nut();
				}
			}
		}
	}
}

module zmotion_bottom_lockcut(op=1,offs=[0,0])
{
	tr=[vec_add(vec_replace(zbottom_pulleyblock_tr()[0],0,zbottom_pulley_tr(z_pulley_count())[0].x)
		,[-pulley_od(z_pulley_type())/2+offs.x,-1,10+offs.y])
			,zbottom_pulleyblock_tr()[1]];
	if (op==1)
		translate_rotate(tr)
			cube(vec_add(zbottom_pulleyblock_dim(),[0,2,100]));
	if (op==2)
		translate_rotate(tr)
		translate ([-0.1,zbottom_pulleyblock_dim().y/2+1,-0.01])
		rotate ([0,90,0])
		{
			belt (l=20,smooth=false,width_add=[0,0]);
		}
}

module zmotion_bottom_mainblock()
{
	dim=zbottom_pulleyblock_dim();
	linear_extrude(dim.z)
		polygon(polyRound([
			 [0,0,0]
			,[dim.x,0,0]
			,[dim.x,dim.y,0]
			,[0,dim.y,4]
		],1));
}

module zmotion_bottom_main(report=false)
{
	fix_offset=14;
	union()
	{
		difference()
		{
			union()
			{
				fillet(r=2,steps=8)
				{
					translate_rotate(zmotor_tr())
					linear_extrude(zmotor_thickness())
						polygon(polyRound([
							 [-NEMA_width(motor_type())/2,-NEMA_width(motor_type())/2,4]
							,[-NEMA_width(motor_type())/2,NEMA_width(motor_type())/2,4]
							,[NEMA_width(motor_type())/2,NEMA_width(motor_type())/2,4]
							,[NEMA_width(motor_type())/2,-NEMA_width(motor_type())/2,4]
						],1));
						
					translate_rotate(zbottom_pulleyblock_tr())
						zmotion_bottom_mainblock();
				}
				fillet(r=4,steps=8)
				{
					translate_rotate(zbottom_pulleyblock_tr())
						zmotion_bottom_mainblock();
					translate_rotate(zbottom_pulleyblock_tr())
					{
						dim=[zbottom_pulleyblock_dim().x+fix_offset,zbottom_pulleyblock_dim().y,5];
						linear_extrude(dim.z)
							polygon(polyRound([
								 [0,0,0]
								,[dim.x,0,4]
								,[dim.x,dim.y,4]
								,[0,dim.y,4]
							],1));
					}
				}
				translate_rotate(zbottom_pulleyblock_tr())
				translate([0,zbottom_pulleyblock_dim().y/2,0])
				rotate ([90,0,90])
					slot_groove(height=zbottom_pulleyblock_dim().x+fix_offset);
			}
			translate_rotate(zmotor_tr())
				nema17_cut(washers=true
						,shaft=false
						,bighole=true
						,shaft_length=60
						,main_cyl=true
						,main_cyl_length=3
						,report=report);
			
			for (i=[1:z_pulley_count()-1])
				translate_rotate (zbottom_pulley_tr(i))
					zpulley_cut(pulley_type=z_pulley_type(),op=0,angle=0,screw=16,up=7,nut_type="hex",report=report);
			
			translate_rotate (zmotor_pulley_tr())
			{
				offs=[1,1];
				hhub=pulley_hub_length(zmotor_pulley_type());
				hpulley=pulley_height(zmotor_pulley_type());
				dd=pulley_flange_dia(zmotor_pulley_type())+offs[0]*2;
				hh=hpulley+offs[1]*2;
				
				rotate ([0,180,0])
				translate ([0,0,-(hpulley-hhub)/2-offs[1]])
					cylinder (d=dd,h=100,$fn=80);
				
				rotate ([0,180,0])
				translate ([0,0,-(hpulley-hhub)/2-offs[1]])
				hull()
				{
					cylinder (d=dd,h=hpulley,$fn=80);
					translate ([0,-10,0])
						cylinder (d=dd+3,h=hpulley,$fn=80);
				}
			}
			
			for (y=[-1,1])
			{
				tr=[vec_add(zbottom_pulleyblock_tr()[0],[
						zbottom_pulleyblock_dim().x-6.5
						,zbottom_pulleyblock_dim().y/2+y*5.5
						,zbottom_pulleyblock_dim().z-4]
					),[180,0,0]];
				translate_rotate(tr)
				{
					screw=12;				
					m3_screw(h=screw);
					m3_washer(out=10);
					translate ([0,0,screw-5])
					rotate ([0,0,90+y*90])
						m3_square_nut();
					
					report_m3_washer_squarenut(screw);
				}
			}
			
			if (report) report_m5_point();
			translate_rotate(zbottom_pulleyblock_tr())
			translate ([7,zbottom_pulleyblock_dim().y/2,5])
			rotate ([180,0,0])
				m5n_screw_washer(thickness=5, diff=1, washer_out=40,washer_side_out=6);
			
			if (report) report_m5_point();
			translate_rotate(zbottom_pulleyblock_tr())
			translate ([zbottom_pulleyblock_dim().x+6,zbottom_pulleyblock_dim().y/2,5])
			rotate ([180,0,0])
				m5n_screw_washer(thickness=5, diff=1, washer_out=40);
		}
		for (i=[1:z_pulley_count()-1])
			translate_rotate (zbottom_pulley_tr(i))
				zpulley_cut(pulley_type=z_pulley_type(),op=1,angle=0,screw=20,up=8,nut_type="hex");
	}
}
module zmotion_bottom()
{
	difference()
	{
		zmotion_bottom_main(report=true);
		zmotion_bottom_lockcut();
	}
}

module zmotion_bottom_lock()
{
	difference()
	{
		intersection()
		{
			zmotion_bottom_main();
			zmotion_bottom_lockcut(offs=[belt_thickness(zbelt_type()),0.2]);
		}
		zmotion_bottom_lockcut(op=2,offs=[belt_thickness(zbelt_type()),0.2]);
	}
}

module zmotion_top_main(report=false)
{
	union()
	{
		difference()
		{
			union()
			fillet(r=4,steps=8)
			{
				translate_rotate(ztop_pulleyblock_tr())
					cube (ztop_pulleyblock_dim());
				translate_rotate(ztop_pulleyblock_tr())
				{
					offs=14;
					dim=[ztop_pulleyblock_dim().x+offs*2,ztop_pulleyblock_dim().y,5];
					translate ([-offs,0,ztop_pulleyblock_dim().z-dim.z])
					linear_extrude(dim.z)
						polygon(polyRound([
							 [0,0,4]
							,[dim.x,0,4]
							,[dim.x,dim.y,4]
							,[0,dim.y,4]
						],1));
				}
			}
			
			for (i=[0:z_pulley_count()-1])
				translate_rotate (ztop_pulley_tr(i))
					zpulley_cut(pulley_type=z_pulley_type(),op=0,angle=180,screw=16,up=7,nut_type="hex",report=report);
			
			for (y=[-1,1])
			{
				tr=[vec_add(ztop_pulleyblock_tr()[0],[
						ztop_pulleyblock_dim().x-5.0
						,ztop_pulleyblock_dim().y/2+y*5.5
						,4]
					),[0,0,0]];
				translate_rotate(tr)
				{				
					screw=12;
					m3_screw(h=screw);
					m3_washer(out=10);
					translate ([0,0,screw-5])
					rotate ([0,0,-90+y*90])
						m3_square_nut();
					
					if (report) report_m3_washer_squarenut(screw);
				}
			}
		
			if (report) report_m5_point();
			translate_rotate(ztop_pulleyblock_tr())
			translate ([ztop_pulleyblock_dim().x+6,ztop_pulleyblock_dim().y/2,ztop_pulleyblock_dim().z-5])
				m5n_screw_washer(thickness=5, diff=1, washer_out=40);
			
			if (report) report_m5_point();
			translate_rotate(ztop_pulleyblock_tr())
			translate ([-6,ztop_pulleyblock_dim().y/2,ztop_pulleyblock_dim().z-5])
				m5n_screw_washer(thickness=5, diff=1, washer_out=40);
		}
		for (i=[0:z_pulley_count()-1])
			translate_rotate (ztop_pulley_tr(i))
				zpulley_cut(pulley_type=z_pulley_type(),op=1,angle=180,screw=20,up=8,nut_type="hex");
	}
}

module zmotion_top_lockcut(op=1,offs=[0,0])
{
	dim=vec_add(ztop_pulleyblock_dim(),[0,2,100]);
	tr=[vec_add(vec_replace(ztop_pulleyblock_tr()[0],0,ztop_pulley_tr(z_pulley_count())[0].x)
		,[-pulley_od(z_pulley_type())/2+offs.x,-1,0-offs.y-dim.z+ztop_pulleyblock_dim().z-10])
			,ztop_pulleyblock_tr()[1]];
	if (op==1)
		translate_rotate(tr)
			cube(dim);
	if (op==2)
		translate_rotate(tr)
		translate ([20-0.1,ztop_pulleyblock_dim().y/2+1,dim.z+0.01])
		rotate ([0,-90,0])
		{
			belt (l=20,smooth=false,width_add=[0,0]);
		}
}

module zmotion_top()
{
	difference()
	{
		zmotion_top_main(report=true);
		zmotion_top_lockcut();
	}
}

module zmotion_top_lock()
{
	difference()
	{
		intersection()
		{
			zmotion_top_main();
			zmotion_top_lockcut(offs=[belt_thickness(zbelt_type()),0.2]);
		}
		zmotion_top_lockcut(op=2,offs=[belt_thickness(zbelt_type()),0.2]);
	}
}

module zmotion_middle_main(zposition)
{
	fix_offs=10;
	bevel=1;
	y_cut=1;
	translate ([0,0,zposition])
	union()
	{
		difference()
		{
			union()
			{
				translate_rotate(tr_add(zmiddle_pulleyblock_tr(),[-fix_offs,0,0]))
				union()
				{
					dim=vec_add(zmiddle_pulleyblock_dim(),[fix_offs*2,-y_cut,0]);
					intersection()
					{
						linear_extrude(dim.z)
							polygon(polyRound([
								 [0,0,0]
								,[0,dim.y,bevel]
								,[dim.x,dim.y,bevel]
								,[dim.x,0,0]
							],1));
						translate ([0,dim.y,0])
						rotate ([90,0,0])
						linear_extrude(dim.y)
							polygon(polyRound([
								 [0,0,bevel]
								,[0,dim.z,bevel]
								,[dim.x,dim.z,bevel]
								,[dim.x,0,bevel]
							],1));
						rotate ([90,0,90])
						linear_extrude(dim.x)
							polygon(polyRound([
								 [0,0,0]
								,[0,dim.z,0]
								,[dim.y,zmiddle_pulleyblock_dim().z,bevel]
								,[dim.y,0,bevel]
							],1));
					}
					translate ([0,0,dim.z/2])
					rotate ([0,90,0])
						slot_groove(height=dim.x,smooth=false,big=true,enabled=true);
				}
			}
			
			for (mid=[-1,1])
				for (i=[0:z_pulley_count()-1])
					translate_rotate (zmiddle_pulley_tr(i,mid,0))
							zpulley_cut(pulley_type=z_pulley_type(),op=0
								,angle=-90+90*mid,screw=20,up=7,nut_type="hex",report=true);
				
			fix_up=5;	
				
			report_m5_point();
			translate_rotate(zmiddle_pulleyblock_tr())
			translate ([zmiddle_pulleyblock_dim().x,fix_up,zmiddle_pulleyblock_dim().z/2])
			rotate ([90,0,0])
			{
				m5n_screw_washer(thickness=fix_up, diff=2, washer_out=40,tnut=true);
				translate ([0,zmiddle_pulleyblock_dim().z/2+0.01,0])
				rotate ([180,0,0])
				{
					dim=[zmiddle_pulleyblock_dim().x
						,zmiddle_pulleyblock_dim().z+0.02
						,zmiddle_pulleyblock_dim().y-fix_up-y_cut+0.01];
					//#cube (dim);
					translate ([0,0,dim.z])
					rotate ([-90,0,0])
					linear_extrude (dim.y)
						polygon(polyRound([
							 [-10,-10,bevel]
							,[-10,0,bevel]
							,[0,0,bevel]
							,[0,dim.z,bevel]
							,[dim.x,dim.z,bevel]
							,[dim.x,0,bevel]
							,[dim.x+10,0,bevel]
							,[dim.x+10,-10,bevel]
						],1));
				}
			}
				
			report_m5_point();
			translate_rotate(zmiddle_pulleyblock_tr())
			translate ([0,fix_up,zmiddle_pulleyblock_dim().z/2])
			rotate ([90,0,0])
			{
				m5n_screw_washer(thickness=fix_up, diff=2, washer_out=40,tnut=true);
				translate ([-zmiddle_pulleyblock_dim().x,zmiddle_pulleyblock_dim().z/2+0.01,0])
				rotate ([180,0,0])
				{
					dim=[zmiddle_pulleyblock_dim().x
						,zmiddle_pulleyblock_dim().z+0.02
						,zmiddle_pulleyblock_dim().y-fix_up-y_cut+0.01];
					//#cube (dim);
					translate ([0,0,dim.z])
					rotate ([-90,0,0])
					linear_extrude (dim.y)
						polygon(polyRound([
							 [-10,-10,bevel]
							,[-10,0,bevel]
							,[0,0,bevel]
							,[0,dim.z,bevel]
							,[dim.x,dim.z,bevel]
							,[dim.x,0,bevel]
							,[dim.x+10,0,bevel]
							,[dim.x+10,-10,bevel]
						],1));
				}
			}
		}
		for (mid=[-1,1])
			for (i=[0:z_pulley_count()-1])
				translate_rotate (zmiddle_pulley_tr(i,mid,0))
					zpulley_cut(pulley_type=z_pulley_type(),op=1,angle=180,screw=20,up=8,nut_type="hex");
	}
}
z=70;
//proto_back_slots();
//proto_other_slots();
//proto_y_right();
//proto_y_left();

//proto_slot_brackets(z);
//proto_heatbed_slots(z);
//proto_z_belt(z);
//proto_heatbed(z);

zmotion_bottom_lock();
		
//zmotion_top_lock();

//zmotion_bottom();
//zmotion_top();
//zmotion_middle_main(z);