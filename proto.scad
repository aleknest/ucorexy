use <../_utils_v2/_round/polyround.scad>

include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/rails.scad>
include <../_utils_v2/NopSCADlib/vitamins/hot_end.scad>
include <../_utils_v2/NopSCADlib/vitamins/hot_ends.scad>
include <../_utils_v2/NopSCADlib/vitamins/blower.scad>
include <../_utils_v2/NopSCADlib/vitamins/blowers.scad>
include <../_utils_v2/NopSCADlib/vitamins/fan.scad>
include <../_utils_v2/NopSCADlib/vitamins/fans.scad>
include <../_utils_v2/NopSCADlib/vitamins/pulleys.scad>
include <../_utils_v2/NopSCADlib/vitamins/belts.scad>
include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>
include <../_utils_v2/NopSCADlib/vitamins/extrusion_brackets.scad>

use <../_utils_v2/NopSCADlib/vitamins/insert.scad>
use <../_utils_v2/NopSCADlib/utils/layout.scad>
use <../_utils_v2/deb.scad>
use <../_utils_v2/rods.scad>
use <ss443a.scad>
use <configuration.scad>
use <utils.scad>

module proto_slot2020_cr(length)
{
	color ("#668866")
	translate ([0,0,0])
	scale ([1,1,length/100])
	translate ([0,0,-50])
		import ("proto/slot2020.stl");
	
	report_slot(length);
}

module proto_x_blowers(xposition=0)
{
	report_blower();
	translate_rotate (e3d_blower_left_tr(xposition))
		blower(e3d_blower_type());
	
	report_blower();
	translate_rotate (e3d_blower_right_tr(xposition))
		blower(e3d_blower_type());
	
	report_fan();
	translate_rotate (e3d_fan_tr(xposition))
		fan(e3d_fan_type());
}

module proto_x_slot(xposition=0)
{
	translate_rotate (x_slot_tr())
		proto_slot2020_cr(length=x_slot());
	report_rail("C",x_rail());
	translate_rotate (x_rail_tr())
		rail_assembly(x_rail_type(), x_rail(), xposition);
}

module proto_x(xposition=0)
{
	report_hotend();
	translate_rotate (e3d_tr(xposition))
		hot_end(e3d_type(), 1.75, naked = true, resistor_wire_rotate = [0,0,0], bowden = true);
}

module proto_back_left()
{
	translate_rotate (left_top_backpulley())
		pulley_assembly(y_pulley_type());
	translate_rotate (left_bottom_backpulley())
		pulley_assembly(y_pulley_type());
}

module proto_y_left(yposition=0, slot_only=false)
{
	translate_rotate (y_slot_left_tr())
		proto_slot2020_cr(length=y_slot());
	
	if (!slot_only)
	{
		report_rail("H",y_rail());
		translate_rotate (y_rail_left_tr())
			rail_assembly(y_rail_type(), y_rail(), yposition);
		
		translate ([0,yposition,0])
		translate_rotate (y_leftfront_pulley_tr())
			pulley_assembly(y_pulley_type());
		translate ([0,yposition,0])
		translate_rotate (y_leftback_pulley_tr())
			pulley_assembly(y_pulley_type());
	}
}

module proto_back_right()
{
	translate_rotate (right_top_backpulley())
		pulley_assembly(y_pulley_type());
	translate_rotate (right_bottom_backpulley())
		pulley_assembly(y_pulley_type());
}

module proto_y_right(yposition=0, slot_only=false)
{
	translate_rotate (y_slot_right_tr())
		proto_slot2020_cr(length=y_slot());
	
	if (!slot_only)
	{
		report_rail("H",y_rail());
		translate_rotate (y_rail_right_tr())
			rail_assembly(y_rail_type(), y_rail(), -yposition);
		
		translate ([0,yposition,0])
		translate_rotate (y_rightfront_pulley_tr())
			pulley_assembly(y_pulley_type());
		translate ([0,yposition,0])
		translate_rotate (y_rightback_pulley_tr())
			pulley_assembly(y_pulley_type());
	}
}

module proto_xymotors()
{
	translate_rotate (left_motorpulley_tr())
		pulley_assembly(motor_pulley_type());
	translate_rotate (left_motor_tr())
		NEMA(motor_type(), shaft_angle = 0, jst_connector = false);
	
	translate_rotate (right_motorpulley_tr())
		pulley_assembly(motor_pulley_type());
	translate_rotate (right_motor_tr())
		NEMA(motor_type(), shaft_angle = 0, jst_connector = false);
}

module proto_front_slots()
{
	translate_rotate (z_slot_leftfront_tr())
		proto_slot2020_cr(length=z_slot());
	translate_rotate (z_slot_rightfront_tr())
		proto_slot2020_cr(length=z_slot());
	translate_rotate (z_slot_topfront_tr())
		proto_slot2020_cr(length=front_back_slot());
	translate_rotate (z_slot_bottomfront_tr())
		proto_slot2020_cr(length=front_back_slot());
}

module proto_back_slots()
{
	translate_rotate (z_slot_topback_tr())
		proto_slot2020_cr(length=front_back_slot());
	translate_rotate (z_slot_bottomback_tr())
		proto_slot2020_cr(length=front_back_slot());
	translate_rotate (z_slot_leftback_tr())
		proto_slot2020_cr(length=z_slot());
	translate_rotate (z_slot_rightback_tr())
		proto_slot2020_cr(length=z_slot());
}

module proto_other_slots()
{	
	translate_rotate (y_slot_bottomleft_tr())
		proto_slot2020_cr(length=y_slot());
	translate_rotate (y_slot_bottomright_tr())
		proto_slot2020_cr(length=y_slot());
}

module proto_xybelts(xposition=0,yposition=55)
{
	path_top=[
         [y_rightback_pulley_tr()[0].x,y_rightback_pulley_tr()[0].y+yposition, pulley_pr(y_pulley_type())]
        ,[y_leftfront_pulley_tr()[0].x,y_leftfront_pulley_tr()[0].y+yposition, -pulley_pr(y_pulley_type())]
		,[left_motorpulley_tr()[0].x,left_motorpulley_tr()[0].y,pulley_pr(motor_pulley_type())]
		,[left_top_backpulley()[0].x,left_top_backpulley()[0].y, pulley_pr(y_pulley_type())]
		,[right_top_backpulley()[0].x,right_top_backpulley()[0].y, pulley_pr(y_pulley_type())]
		];	
	path_bottom=[
         [y_leftback_pulley_tr()[0].x,y_leftback_pulley_tr()[0].y+yposition, pulley_pr(y_pulley_type())]
		,[left_bottom_backpulley()[0].x,left_bottom_backpulley()[0].y, pulley_pr(y_pulley_type())]
		,[right_bottom_backpulley()[0].x,right_bottom_backpulley()[0].y, pulley_pr(y_pulley_type())]
		,[right_motorpulley_tr()[0].x,right_motorpulley_tr()[0].y,pulley_pr(motor_pulley_type())]
        ,[y_rightfront_pulley_tr()[0].x,y_rightfront_pulley_tr()[0].y+yposition, -pulley_pr(y_pulley_type())]
	];	
	translate ([0,0,left_motorpulley_tr()[0].z])
		belt(type=xybelt_type(),points=path_top,gap=xcarriage_dim().x,gap_pos=[xposition,yposition,90]);
	translate ([0,0,right_motorpulley_tr()[0].z])
		belt(type=xybelt_type(),points=path_bottom,gap=xcarriage_dim().x,gap_pos=[xposition,yposition,90]);
}

module proto_z_belt_motor()
{
	translate_rotate (zmotor_tr())
		NEMA(zmotor_type(), shaft_angle = 0, jst_connector = false);
}

module proto_z_belt(zposition=0)
{
	translate_rotate (zmotor_pulley_tr())
		pulley_assembly(zmotor_pulley_type());
	proto_z_belt_motor();
	
	for (i=[1:z_pulley_count()-1])
		translate_rotate (zbottom_pulley_tr(i))
			pulley_assembly(z_pulley_type());
	for (mid=[-1,1])
		for (i=[0:z_pulley_count()-1])
			translate_rotate (zmiddle_pulley_tr(i,mid,zposition))
				pulley_assembly(z_pulley_type());
	for (i=[0:z_pulley_count()-1])
		translate_rotate (ztop_pulley_tr(i))
			pulley_assembly(z_pulley_type());
}

module proto_heatbed(zposition)
{
	report_heatbed(bed_dim());
	color ("gray")
	translate ([0,0,zposition])
	translate_rotate (bed_plate_tr())
	{
		difference()
		{
			linear_extrude(bed_dim().z)
			polygon(polyRound([
				 [-bed_dim().x/2,-bed_dim().y/2,2]
				,[bed_dim().x/2,-bed_dim().y/2,2]
				,[bed_dim().x/2,bed_dim().y/2,2]
				,[-bed_dim().x/2,bed_dim().y/2,2]
			],20));
			for (x=[-1,1])
			for (y=[-1,1])
				translate ([(bed_dim().x/2-bed_screws_offset().x)*x
							,(bed_dim().y/2-bed_screws_offset().y)*y,-1])
					cylinder (d=3.4,h=bed_dim().z+2,$fn=20);
		}
	}
}

module proto_heatbed_slots(zposition=0)
{
	translate ([0,0,zposition])
	{
		translate_rotate (backheatbed_slot_tr())
			proto_slot2020_cr(length=backheatbed_slot());
		translate_rotate (leftheatbed_slot_tr())
			proto_slot2020_cr(length=leftrightheatbed_slot());
		translate_rotate (rightheatbed_slot_tr())
			proto_slot2020_cr(length=leftrightheatbed_slot());
	}
}

module proto_z_rails(zposition=0)
{
	report_rail("H",z_rail());
	report_rail("H",z_rail());
	translate_rotate (z_left_rail_tr())
		rail_assembly(z_rail_type(), z_rail(), zposition-z_rail_carriage_zero());
	translate_rotate (z_right_rail_tr())
		rail_assembly(z_rail_type(), z_rail(), zposition-z_rail_carriage_zero());
}

module proto_slot_brackets(zposition=0)
{
	color ("gray")
	for (tr=brackets_tr(zposition))
	{
		report_corner_bracket();
		
		translate_rotate(tr)
		translate ([0,0,-10])
			linear_extrude (20)
			polygon ([
				[0,0]
				,[20,0]
				,[20,4]
				,[4,20]
				,[0,20]
			]);
	}
}

module proto_magnet(d,h)
{
	color("HotPink")
		cylinder (d=d,h=h,$fn=20);
}

module proto_z_endstop()
{
	translate_rotate (z_endstop_tr())
		protoSS443A();
	
	report_magnet(z_magnet_d(),z_magnet_h())
	translate_rotate (z_endstop_magnet_tr())
		proto_magnet(d=z_magnet_d(),h=z_magnet_h(),$fn=16);
}

use <./utils/arduino.scad>
module proto_approx_electronics()
{
	//ramps
	translate ([-80,-68,-220])
		arduino(5);
	
	//PS150-W1V12
	translate ([-6,-68,-220])
		cube ([99,159,50]);
}

z=0;

//translate ([0,y_rail_y(),0]) proto_x(xposition=0);
//proto_y_left(yposition=0);
//proto_y_right(yposition=0);
//proto_other_slots();
//proto_xybelts(0,0);
//proto_xymotors();
//proto_z_belt(z);

//proto_front_slots();
//proto_back_slots();
//proto_heatbed_slots(z);
//proto_heatbed(z);

//proto_z_rails(z);

proto_slot_brackets(0);

// fysetc s6
//translate ([-0,-68,-220])
//	cube ([87,117,30]);
	
//proto_approx_electronics();

//proto_z_endstop();
