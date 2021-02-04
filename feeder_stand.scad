use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>

module ellipse(w,h,th)
{
	translate([0,0,-th/2])
	scale ([1,w/h,1])
	linear_extrude (th,$fn=400)
		circle (r=h);
}

module border(w,h,th,bcut)
{
	wo=w+bcut/2;
	ho=h+bcut/2;
	wi=w-bcut/2;
	hi=h-bcut/2;
	cut=[h+10+1,w+10+1,th+2];
	
	translate([0,0,-th/2])
	{
		intersection()
		{
			difference()
			{
				scale ([1,wo/ho,1])
				linear_extrude (th,$fn=400)
					circle (r=ho);
			
				translate ([0,0,-1])
				scale ([1,wi/hi,1])
				linear_extrude (th+2,$fn=400)
					circle (r=hi);
				
				rays=30;
				angle=360/rays;
				start_angle=3;
				scale ([1,wi/hi,1])
				for (a=[0:angle:360])
					rotate ([0,0,a+start_angle])
					translate ([0,-bcut/4,-1])
						cube ([ho+10,bcut/2,th+2]);
			}
			translate ([-cut.x-bcut/2,-cut.y-bcut/2,-1])
				cube (cut);
		}
	}
}

y=feeder_center_point_tr()[0].y-feeder_stand_tr()[0].y;
z=feeder_center_point_tr()[0].z-feeder_stand_tr()[0].z;
cut=[z+10+1,y+10+1,feeder_thickness()+2];

module feeder_stand_base(th)
{
	intersection()
	{
		difference()
		{
			ellipse(y+10,z+10,th);
			ellipse(y-10,z-10,th+2);
		}
		translate ([-cut.x,-cut.y,-cut.z/2])
			cube (cut);
	}
}

module feeder_stand()
{
	difference()
	{
		union()
		{
			fillet(r=24,steps=32)
			{
				translate([0,0,-z])
				translate_rotate(feeder_center_point_tr())
					feeder_stand_base(feeder_thickness());
				
				translate_rotate(feeder_stand_tr())
				translate ([-feeder_thickness()/2,-10,0])
				{
					dim=[feeder_stand_width(),20,feeder_base_thickness()];
					linear_extrude(dim.z)
						polygon(polyRound([
							 [0,0,0]
							,[dim.x,0,4]
							,[dim.x,dim.y,4]
							,[0,dim.y,0]
						],1));
				}
			}
			
			dim=[NEMA_width(motor_type()),NEMA_width(motor_type()),feeder_nema_plate_thickness()];
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
					
					translate([0,0,-z])
					translate_rotate(feeder_center_point_tr())
					translate ([0,0,-(feeder_thickness()-feeder_nema_plate_thickness())/2])
						feeder_stand_base(feeder_nema_plate_thickness());
				}
				
				translate_rotate(feeder_center_point_tr())
				translate([0,-0.01,-feeder_thickness()/2])
				translate ([0,dim.y/2,0])
				nema17_cut(washers=true
						,shaft=false
						,bighole=true
						,shaft_length=60
						,main_cyl=true
						,main_cyl_length=3
						,report=true);
			}			
			translate([0,0,-z])
			translate_rotate(feeder_center_point_tr())
				border(y+10,z+10,feeder_thickness(),feeder_border_cut());
			
			translate_rotate(feeder_stand_tr())
			translate([-feeder_thickness()/2,0,0])
			rotate ([90,0,90])
				slot_groove(height=feeder_stand_width(),enabled=true,big=true);
		}
		translate([0,0,-z])
		translate_rotate(feeder_center_point_tr())
			border(y,z,feeder_thickness()+100,feeder_border_cut());
		
		for (xx=[-12,-34])
			translate_rotate(feeder_stand_tr())
			translate ([feeder_stand_width()+xx,0,5])
			rotate ([180,0,0])
			{
				report_m5_point();
				m5n_screw_washer(thickness=5, diff=2, washer_out=40,tnut=true);
			}
	}
}

/*
proto_front_slots();
proto_back_slots();
proto_y_right(slot_only=true);
proto_y_left(slot_only=true);

*/
/*
yposition=0;
xposition=0;
translate ([0,y_rail_y()+yposition,0])
	proto_x(xposition=xposition);
use <xcarriage.scad>
translate ([xposition,y_rail_y()+yposition,0])
{
	//x_carriage_main();
}
*/
feeder_stand();