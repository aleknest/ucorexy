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
include <../_utils_v2/NopSCADlib/vitamins/rails.scad>

module z_carriage(tr,rail_tr,bedslot_tr,m)
{
	compl=m==0?1:-1;
	thickness=10;
	offs=0.2;
	screw=10;
	screw_in=3;
	dim=z_carriage_dim();
	
	difference()
	{
		translate_rotate(tr)
		{
			x1=carriage_width(rail_carriage(z_rail_type()));
			y1=carriage_height(rail_carriage(z_rail_type()));
			mirror([m,0,0])
			difference()
			{
				p=polyRound([
						 [x1,0,2]
						,[dim.x,0,6]
						,[dim.x,dim.y,2]
						,[x1+offs,dim.y,2]
						,[x1+offs,dim.y-y1-offs,0]
						,[0,dim.y-y1-offs,0]
						,[0,dim.y-y1-thickness,0]
						,[x1,dim.y-y1-thickness,4]
					],1);
				linear_extrude(dim.z)
					polygon(p);
				r=1;
				for (z=[0,dim.z])
				for (i=[0:len(p)-1])
				{
					p1=p[i];
					p2=i==(len(p)-1)?p[0]:p[i+1];
					hull()
					{
						translate ([p1.x,p1.y,z])
							sphere(r=r,$fn=2);
						translate ([p2.x,p2.y,z])
							sphere(r=r,$fn=2);
					}
				}
			}
		}
		
		grooves=m==0?[0,1,3]:[1,2,3];
		translate_rotate(bedslot_tr)
			slot_cut(height=200,grooves=grooves);
		
		translate ([rail_tr[0].x,tr[0].y,tr[0].z])
		for (x=[-1,1])
		for (y=[-1,1])
			translate ([carriage_pitch_y(rail_carriage(z_rail_type()))/2*y
				,dim.y-carriage_height(rail_carriage(z_rail_type()))-screw+screw_in
				,dim.z/2+carriage_pitch_x(rail_carriage(z_rail_type()))/2*x])
			rotate ([-90,0,0])
			{
				report_m3_washer(screw);
				m3_screw(h=screw);
				hull()
				{
					m3_washer(out=5,sphere=(y==compl));
					if (y*compl==-1)
						translate ([-20*compl,0,0])
							m3_washer(out=12);
					}
			}
			
		screw5_offs=[8,5];
		for (y=[screw5_offs.x,dim.y/2,dim.y-screw5_offs.x])
			translate ([bedslot_tr[0].x,tr[0].y+y,0])
			{
				report_m5_point();
				translate ([0,0,bedslot_tr[0].z-10-screw5_offs.y])
				rotate ([0,0,0])
					m5n_screw_washer(thickness=5,diff=2, washer_out=20);
				
				report_m5_point();
				translate ([0,0,bedslot_tr[0].z+10+screw5_offs.y])
				rotate ([180,0,0])
					m5n_screw_washer(thickness=5,diff=2, washer_out=20);
			}
	}
}

module z_carriage_left(zposition=0)
{
	translate ([0,0,zposition])
		z_carriage(tr=z_carriage_left_tr(0),rail_tr=z_left_rail_tr(),bedslot_tr=leftheatbed_slot_tr(),m=0);
}

module z_carriage_right(zposition=0)
{
	translate ([0,0,zposition])
	difference()
	{
		z_carriage(tr=z_carriage_right_tr(0),rail_tr=z_right_rail_tr(),bedslot_tr=rightheatbed_slot_tr(),m=1);
		translate_rotate (z_endstop_magnet_tr())
			magnet_cut(magnet_d=z_magnet_d(),magnet_h=z_magnet_h());
	}
}

module zz_endstop_block(tr,etr,bdim,m3_screw_height,ss443_out,report=false)
{
	union()
	{
		difference()
		{
			translate_rotate (tr)
			{
				intersection()
				{
					linear_extrude (bdim.z)
						polygon(polyRound([
							 [0,0,0.4]
							,[bdim.x,0,0.4]
							,[bdim.x,bdim.y,0]
							,[0,bdim.y,0.4]
						],1));
					rotate ([90,0,90])
					linear_extrude (bdim.x)
						polygon(polyRound([
							 [0,0,0]
							,[bdim.y,0,0]
							,[bdim.y,bdim.z,0.4]
							,[0,bdim.z,0.4]
						],1));
					
					translate ([0,bdim.y,0])
					rotate ([90,0,0])
					linear_extrude (bdim.y)
						polygon(polyRound([
							 [0,0,0]
							,[bdim.x,0,0]
							,[bdim.x,bdim.z,0.4]
							,[0,bdim.z,0.4]
						],1));
				}
			}
			
			//8888888
			if (report) report_SS443a();
			translate_rotate (etr)
				SS443A(SS443A_out=ss443_out-3-1
					,SS443A_yout=14
					,SS443A_yout2=10
					,SS443A_yout_mirror=true
					,SS443A_yout_addthickness=4.17-1
					,SS443A_yout_sub=0
					,wire_cut=[1,8]
				);
			
			if (report) report_m3_washer_squarenut(m3_screw_height);
			translate_rotate (tr)
			translate ([4,bdim.y-m3_cap_h()-1,bdim.z/2])
			rotate ([90,0,0])
			{
				m3_screw(h=m3_screw_height,cap_out=20);
				translate ([0,0,m3_screw_height-4])
					m3_square_nut();
			}
		}
		translate_rotate (tr)
		translate ([4,bdim.y-m3_cap_h()-1,bdim.z/2])
		rotate ([90,0,0])
		{
			cylinder (d=m3_cap_diameter()+0.2,h=0.4,$fn=16);
		}
	}
}

module z_endstop_block(report=false)
{
	zz_endstop_block(tr=z_endstop_block_tr()
				,etr=z_endstop_tr()
				,bdim=z_endstop_block_dim()
				,m3_screw_height=z_endstop_screw()
				,ss443_out=abs(z_SS443A_cut().y.z)-SS443A_hall()/2+0.03
	            ,report=report
	);
	dim=[14.8,10,5];
	
	translate_rotate (z_endstop_block_tr())
	translate([z_endstop_block_dim().x-10,0,0])
	rotate ([-90,0,0])
		slot_groove(height=z_endstop_block_dim().y+dim.y,smooth=true,enabled=true,big=true);
	
	translate_rotate (z_endstop_block_tr())
	translate([z_endstop_block_dim().x-dim.x,z_endstop_block_dim().y,0])
	fillet (r=4,steps=16)
	{
		cube (dim);
		translate ([0,-1,0])
			cube ([dim.x,1,z_endstop_block_dim().z-0.4]);
	}
}

module z_endstop_cut(offs=[0,0])
{
	translate ([-offs.x,offs.x,-offs.y])
	translate_rotate (z_endstop_tr())
		SS443A_cut2(z_SS443A_cut().x,z_SS443A_cut().y,[1,4,0]);
}

module z_endstop()
{
	difference()
	{
		z_endstop_block(report=true);
		
		translate_rotate (z_endstop_block_tr())
		translate([z_endstop_block_dim().x-10,z_endstop_block_dim().y/2,4])
		rotate ([0,180,0])
		{
			report_m5_point();
			m5n_screw_washer(thickness=4, diff=1, washer_out=40,tnut=true);
		}
		z_endstop_cut(offs=[0.2,0]);
	}
}

module z_endstop_lock()
{
	intersection()
	{
		z_endstop_block();
		z_endstop_cut(offs=[0.01,0.1]);
	}
}

z=90;
//proto_back_slots();

//proto_heatbed_slots(z);
//proto_heatbed(z);
//proto_z_rails(z);
//proto_slot_brackets();

//z_carriage_left(z);
//z_carriage_right(z);

z_endstop();
z_endstop_lock();