use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>

y=feeder_center_point_tr()[0].y-feeder_stand_tr()[0].y;
z=feeder_center_point_tr()[0].z-feeder_stand_tr()[0].z;
cut=40;
c=cut+10;
g=sqrt(c*c*2);
corner=1/(180/90);

dim_nema=[NEMA_width(motor_type()),NEMA_width(motor_type()),feeder_nema_plate_thickness()];

module feeder_plate(report=false)
{
	dim=dim_nema;
	difference()
	{
		fillet (r=8,steps=16)
		{
			translate_rotate(feeder_center_point_tr())
			translate([0,-0.01,-feeder_thickness()/2])
			translate ([0,dim.y/2,0])
			linear_extrude(dim.z)
				polygon(polyRound([
					 [dim.x/2,dim.y/2,3]
					,[-dim.x/2,dim.y/2,3]
					,[-dim.x/2,-dim.y/2,3]
					,[dim.x/2,-dim.y/2,3]
				],1));
			
			translate ([-feeder_thickness()/2,-y+cut,-10])
			translate(feeder_center_point_tr()[0])
				cube ([feeder_nema_plate_thickness(),y-cut,20]);
		}
		
		translate_rotate(feeder_center_point_tr())
		translate([0,-0.01,-feeder_thickness()/2])
		translate ([0,dim.y/2,0])
		nema17_cut(washers=true
				,shaft=false
				,bighole=true
				,shaft_length=60
				,main_cyl=true
				,main_cyl_length=100
				,report=report
				,report_pulley=false);
	}			
}

module feeder_stand(report=false)
{
	difference()
	{
		union()
		{
			translate ([-feeder_thickness()/2,-y+cut,-10])
			translate(feeder_center_point_tr()[0])
			{
				dim=[feeder_thickness(),y-cut,20];
				//#cube (dim);
				translate ([0,0,dim.z])
				rotate ([0,90,0])
				linear_extrude(dim.x)
					polygon(polyRound([
						 [0,0,0]
						,[dim.z,0,0]
						,[dim.z,dim.y,4]
						,[0,dim.y,4]
					],20));
			}
			
			translate ([-feeder_thickness()/2,-y-10,-cut])
			translate(feeder_center_point_tr()[0])
				rotate ([-45,0,0])
				cube ([feeder_thickness(),20,g]);
			
			fillet(r=12,steps=32)
			{
				translate ([-feeder_thickness()/2,-y-10,-z])
				translate(feeder_center_point_tr()[0])
					cube ([feeder_thickness(),20,z-cut]);
				
				translate_rotate(feeder_stand_tr())
				translate ([-feeder_stand_width()/2,-10,0])
				{
					dim=[feeder_stand_width(),20,feeder_base_thickness()];
					linear_extrude(dim.z)
						polygon(polyRound([
							 [0,0,4]
							,[dim.x,0,4]
							,[dim.x,dim.y,4]
							,[0,dim.y,4]
						],1));
				}
			}
			feeder_plate(report=report);
			/*
			dim=dim_nema;
			difference()
			{
				fillet (r=8,steps=16)
				{
					translate_rotate(feeder_center_point_tr())
					translate([0,-0.01,-feeder_thickness()/2])
					translate ([0,dim.y/2,0])
					linear_extrude(dim.z)
						polygon(polyRound([
							 [dim.x/2,dim.y/2,3]
							,[-dim.x/2,dim.y/2,3]
							,[-dim.x/2,-dim.y/2,3]
							,[dim.x/2,-dim.y/2,3]
						],1));
					
					translate ([-feeder_thickness()/2,-y+cut,-10])
					translate(feeder_center_point_tr()[0])
						cube ([feeder_nema_plate_thickness(),y-cut,20]);
				}
				
				translate_rotate(feeder_center_point_tr())
				translate([0,-0.01,-feeder_thickness()/2])
				translate ([0,dim.y/2,0])
				nema17_cut(washers=true
						,shaft=false
						,bighole=true
						,shaft_length=60
						,main_cyl=true
						,main_cyl_length=100
						,report=report
						,report_pulley=false);
			}			
			*/
			
			translate_rotate(feeder_stand_tr())
			translate([-feeder_stand_width()/2,0,0])
			rotate ([90,0,90])
				slot_groove(height=feeder_stand_width(),enabled=true,big=true);
		}
			
		for (xx=[-15,15])
			translate_rotate(feeder_stand_tr())
			translate ([xx,0,5])
			rotate ([180,0,0])
			{
				if (report)
					report_m5_point();
				m5n_screw_washer(thickness=5, diff=2, washer_out=40,tnut=true);
			}
			
		translate ([-feeder_thickness()/2,-y+cut,-10])
		translate(feeder_center_point_tr()[0])
		{
			for (iy = [-1,1])
			for (iz = [0:1])
				translate ([-feeder_thickness(),8+iz*11,10-1+7*iy])
					cube ([40,3,2]);
		}
		
		translate ([-20,-y,-z+feeder_base_thickness()])
		translate(feeder_center_point_tr()[0])
			for (iy = [-1,1])
			for (iz = [0:4])
			{
				if (iz!=1)
					translate ([0,-1+7*iy,12+iz*16])
						cube ([40,2,3]);
			}
		translate ([-feeder_thickness()/2,-y-10,-cut])
		translate(feeder_center_point_tr()[0])
			rotate ([-45,0,0])
			difference()
			{
				for (iy = [-1,1])
				for (iz = [0:2])
					translate ([-1,10-1+7*iy,18+iz*16])
						cube ([40,2,3]);
			}
	}
}


module cut(zz,diff,op="cut",offs=0,report=false)
{
	translate ([-feeder_thickness()/2,-y-10-1,-z])
	translate(feeder_center_point_tr()[0])
	{
		if (op=="cut")
		{
			translate ([offs,0,0])
			{
				translate ([-10,0,0])
				{
					dim=[feeder_thickness()/2+10,22,zz+diff+offs];
					//#cube (dim);
					translate ([dim.x,0,0])
					rotate ([0,-90,0])
					linear_extrude(dim.x)
						polygon(polyRound([
							 [0,0,0]
							,[dim.z,0,0]
							,[dim.z+dim.y*corner,dim.y/2,0]
							,[dim.z,dim.y,0]
							,[0,dim.y,0]
						],1));
				}
				translate ([-50,0,-10])
				{
					dim=[100,22,zz-diff+10+offs];
					//#cube (dim);
					translate ([dim.x,0,0])
					rotate ([0,-90,0])
					linear_extrude(dim.x)
						polygon(polyRound([
							 [0,0,0]
							,[dim.z,0,0]
							,[dim.z-dim.y*corner,dim.y/2,0]
							,[dim.z,dim.y,0]
							,[0,dim.y,0]
						],1));
				}
			}
		}
		if (op=="diff")
		{
			translate ([0,11,zz])
			rotate ([0,90,0])
			{
				if (report)
				{
					report_m5_screw(12);
					report_m5_hexnut();
				}
				m5n_screw_washer(thickness=feeder_thickness(),washer_out=10);
				translate ([0,0,feeder_thickness()/4*3])
					nut(m5_nut_G(),m5_nut_H());
			}
		}
		if (op=="add")
		{
			translate ([0,11,zz])
			rotate ([0,90,0])
			{
				translate ([0,0,feeder_thickness()/4*3-0.2])
					nut(m8_nut_G()+0.4,0.2);
			}
		}
	}
}

module cut_bottom(op="cut",offs=0, report=false)
{
	diff=6;	
	zz=36;
	cut(zz=zz,diff=diff,op=op,offs=offs,report=report);
}

module cut_top(op="cut",offs=0, report=false)
{
	diff=6;	
	zz=z-60;
	cut(zz=zz,diff=diff,op=op,offs=offs,report=report);
}

module feeder_stand_bottom()
{
	difference()
	{
		intersection()
		{
			feeder_stand(report=true);
			mirror([1,0,0])
				cut_bottom(op="cut",offs=-0.1);
		}
		mirror([1,0,0])
			cut_bottom(op="diff",report=true);
	}
}

module feeder_stand_nobottom()
{
	difference()
	{
		difference()
		{
			feeder_stand();
			mirror([1,0,0])
				cut_bottom(op="cut",offs=0.1);
		}
		mirror([1,0,0])
			cut_bottom(op="diff");
	}
}

module feeder_stand_middle()
{
	difference()
	{
		intersection()
		{
			feeder_stand_nobottom();
			mirror([1,0,0])
				cut_top(op="cut",offs=-0.1);
		}
		mirror([1,0,0])
			cut_top(op="diff");
	}
}

module feeder_stand_top()
{
	union()
	{
		difference()
		{
			difference()
			{
				feeder_stand_nobottom();
				mirror([1,0,0])
					cut_top(op="cut",offs=0.1);
			}
			mirror([1,0,0])
				cut_top(op="diff",report=true);
		}
		mirror([1,0,0])
			cut_top(op="add");
	}
}

//proto_front_slots();

//translate ([-50,-110,10])
//cube ([40,20,10]);
/*
proto_back_slots();
proto_y_right(slot_only=true);
proto_y_left(slot_only=true);

*/

//use <xymotorblock.scad>
//leftfront_motorblock();



feeder_stand();
//feeder_stand_bottom();
//feeder_stand_middle();
//feeder_stand_top();

//feeder_plate();