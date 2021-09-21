use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>

center_tr=[vec_add(feeder_center_point_tr()[0],[0,0,0]),feeder_center_point_tr()[1]];
y=center_tr[0].y-feeder_stand_tr()[0].y;
z=center_tr[0].z-feeder_stand_tr()[0].z;
cut=40-20;
c=cut+10;
g=sqrt(c*c*2);
corner=1/(180/90);

dim_nema=[NEMA_width(motor_type()),NEMA_width(motor_type()),feeder_nema_plate_thickness()];
nema_corner=3;
nema_diag=sqrt(NEMA_width(motor_type())*NEMA_width(motor_type())*2);
nema_offs=(nema_diag-NEMA_width(motor_type()))/2-2.12;
feeder_nema_trs=[
	[[[0,0,0],[0,0,0]],8]
	,[[[0,nema_offs,0],[0,0,45]],20]
	,[[[0,nema_offs-4,0],[0,0,45]],20]
	];

is_motor_plate_add=false;

function feeder_stand_middle_cut()=37;

module feeder_plate_cut(feeder_nema_index=0,report=false)
{
	feeder_nema_tr=feeder_nema_trs[feeder_nema_index];
	dim=dim_nema;
	translate_rotate(center_tr)
	translate([0,-0.01,-feeder_thickness()/2])
	translate ([0,dim.y/2,0])
	translate_rotate (feeder_nema_tr[0])
	{
		translate ([0,0,dim.z])
		linear_extrude(100)
			polygon(polyRound([
				 [dim.x/2,dim.y/2,nema_corner]
				,[-dim.x/2,dim.y/2,nema_corner]
				,[-dim.x/2,-dim.y/2,nema_corner]
				,[dim.x/2,-dim.y/2,nema_corner]
			],1));
	}
}

module feeder_plate(feeder_nema_index=0,report=false)
{
	feeder_nema_tr=feeder_nema_trs[feeder_nema_index];
	add=is_motor_plate_add?7:0;
	dim=dim_nema;
	difference()
	{
		union()
		fillet (r=feeder_nema_tr[1],steps=$preview?16:32)
		{
			translate_rotate(center_tr)
			translate([0,-0.01,-feeder_thickness()/2])
			translate ([0,dim.y/2,0])
			translate_rotate (feeder_nema_tr[0])
			linear_extrude(dim.z)
				polygon(polyRound([
					 [dim.x/2+add,dim.y/2,nema_corner]
					,[-dim.x/2,dim.y/2,nema_corner]
					,[-dim.x/2,-dim.y/2,nema_corner]
					,[dim.x/2+add,-dim.y/2,nema_corner]
				],1));
			
			translate ([-feeder_thickness()/2,-y+cut,-10])
			translate(center_tr[0])
				cube ([feeder_nema_plate_thickness(),y-cut,20]);		
		}
		if (is_motor_plate_add)
			for (y=[-2:2])
				translate_rotate(center_tr)
				translate ([dim.x/2+add-4,dim.y/2+y*7.5,-feeder_thickness()/2-0.01])
				translate ([0,-1.5,0])
					cube ([2,3,feeder_thickness()+0.02]);
		
		translate_rotate(center_tr)
		translate([0,-0.01,-feeder_thickness()/2])
		translate ([0,dim.y/2,0])
		translate_rotate (feeder_nema_tr[0])
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

module feeder_stand(feeder_nema_index=0,report=false)
{
	difference()
	{
		union()
		{
			translate ([-feeder_thickness()/2,-y+cut,-10])
			translate(center_tr[0])
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
			translate(center_tr[0])
			rotate ([-45,0,0])
				cube ([feeder_thickness(),20,g]);
			
			fillet(r=12,steps=$preview?4:32)
			{
				translate ([-feeder_thickness()/2,-y-10,-z])
				translate(center_tr[0])
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
			feeder_plate(feeder_nema_index=feeder_nema_index,report=report);
			translate_rotate(feeder_stand_tr())
			translate([-feeder_stand_width()/2,0,0])
			rotate ([90,0,90])
				slot_groove(height=feeder_stand_width(),enabled=true,big=true);
		}
			
		diff=16;
		for (xx=[-(feeder_stand_width()-diff)/2,(feeder_stand_width()-diff)/2])
			translate_rotate(feeder_stand_tr())
			translate ([xx,0,5])
			rotate ([180,0,0])
			{
				if (report)
					report_m5_point();
				m5n_screw_washer(thickness=5, diff=2, washer_out=40,tnut=true);
			}
			
		st_dim=[3,4];
		
			
		translate ([-20,-y,-z+feeder_base_thickness()])
		translate(center_tr[0])
			for (iy = [-1,1])
			for (iz = [0:0])
			{
				y=7*iy-st_dim[0]/2;
				translate ([0,y,12+iz*16])
					cube ([40,st_dim[0],st_dim[1]]);
			}
		translate ([-20,-y,-z+feeder_base_thickness()])
		translate(center_tr[0])
			for (iy = [-1,1])
			for (iz = [3:3])
			{
				y=7*iy-st_dim[0]/2;
				translate ([0,y,-2+iz*16])
					cube ([40,st_dim[0],st_dim[1]]);
			}
		translate ([-feeder_thickness()/2,-y-10,-cut])
		translate(center_tr[0])
			rotate ([-45,0,0])
			difference()
			{
				for (iy = [-1,1])
				for (iz = [0:0
					])
				{
					y=7*iy-st_dim[0]/2+10;
					translate ([-1,y,18+4+iz*16])
						cube ([40,st_dim[0],st_dim[1]]);
				}
			}
		feeder_plate_cut(feeder_nema_index=feeder_nema_index,report=report);
	}
}


module cut(zz,diff,op="cut",offs=0,rot=[0,0,0],report=false)
{
	translate ([-feeder_thickness()/2,-y-10-1,-z])
	translate(center_tr[0])
	{
		if (op=="cut")
		{
			translate ([offs,0,0])
			{
				rotate(rot)
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
				rotate(rot)
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
			screw=16;
			rotate(rot)
			translate ([(20-screw+m5_washer_height()+m5_nut_H())/2,10+1,zz])
			rotate ([0,90,0])
			{
				if (report)
				{
					report_m5_screw(screw);
					report_m5_hexnut();
				}
				m5n_screw_washer(thickness=screw,washer_out=10);
				translate ([0,0,screw-m5_nut_H()])
					nut(m5_nut_G(),20);
			}
		}
		if (op=="add")
		{
			rotate(rot)
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

module cut_middle(op="cut",offs=0, report=false)
{
	diff=6;	
	zz=z-60-feeder_stand_middle_cut();
	cut(zz=zz,diff=diff,op=op,offs=offs,report=report);
}

module cut_plate(op="cut",offs=0, report=false)
{
	diff=6;	
	zz=86;
	translate([0,0,2])
	translate(center_tr[0])
		cut(zz=zz,diff=diff,op=op,offs=offs,rot=[-90,0,0],report=report);
	if (op=="cut")
	{
		dim=[100,80,200];
		translate ([center_tr[0].x-dim.x/2,-y-dim.y,center_tr[0].z-dim.z-10])
			cube (dim);
	}
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

module feeder_stand_nobottom(feeder_nema_index=0)
{
	difference()
	{
		difference()
		{
			feeder_stand(feeder_nema_index=feeder_nema_index);
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
				cut_middle(op="cut",offs=-0.1);
		}
		mirror([1,0,0])
			cut_middle(op="diff");
	}
}

module feeder_stand_top()
{
	union()
	{
		intersection()
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
				
				translate ([0,0,-1])
				mirror([1,0,0])
					cut_plate(op="diff",report=true);
			}
			mirror([1,0,0])
				cut_plate(op="cut");
		}
		mirror([1,0,0])
			cut_top(op="add");
	}
}

module feeder_stand_plate(feeder_nema_index=0)
{
	union()
	{
		difference()
		{
			feeder_stand_nobottom(feeder_nema_index=feeder_nema_index);
				
			translate ([0,0,-1])
			mirror([1,0,0])
				cut_plate(op="diff",report=false);
			mirror([1,0,0])
				cut_plate(op="cut",offs=0.1);
		}
		translate ([0,0,-1])
		mirror([1,0,0])
			cut_plate(op="add");
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



//feeder_stand_bottom();
//feeder_stand_middle();
//translate ([0,0,feeder_stand_middle_cut()]) feeder_stand_middle();
//feeder_stand_top();
feeder_stand_plate(feeder_nema_index=2);

//feeder_plate();