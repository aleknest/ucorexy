use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
use <xcarriage_alt.scad>
use <ycarriage.scad>
use <zcarriage.scad>
use <backcorners.scad>
use <xymotorblock_alt.scad>
use <zmotion.scad>
use <hotbed.scad>
use <enclosure.scad>
use <feeder_stand.scad>
use <xt90.scad>
use <wago.scad>
use <slot_cover.scad>
use <legs.scad>
use <legs_tennis.scad>
use <case.scad>
use <wire_fix.scad>
//use <nozzles.scad>
use <e3dv6_ptfe_fix.scad>
use <oled_encoder.scad>
use <klipper_head_mcu.scad>
use <klipper_head_mcu_alt.scad>
use <filament_runout_sensor.scad>
use <rpi_camera.scad>
use <rj45.scad>

cmd="legs/leg_tennis_ball";

module list(s)
{
	echo(str("list:",s));
}

if (cmd=="list")
{
	list("x_carriage/x_carriage_blower_nozzle");
	list("x_carriage/x_carriage_bottom");
	list("x_carriage/x_carriage_front");
	list("x_carriage/x_carriage_back");
	list("x_carriage/x_carriage_top");
	list("x_carriage/x_carriage_motor_plate");
	list("x_carriage/xcarriage_slot_wire_holder");
	list("x_carriage/x_carriage_blower_fixer_left");
	list("x_carriage/x_carriage_blower_fixer_right");
	
	list("x_carriage/x_carriage_belt_fixer_left");
	list("x_carriage/x_carriage_belt_fixer_right");	
	list("x_carriage/e3dv6_throat_bore4p1_ptfefix");
	list("x_carriage/e3dv6_throat_bore4p1_ptfefix2");
	list("x_carriage/e3dv6_throat_bore4p1_ptfefixnut");
	
	list("klipper_head_mcu/bottom");
	list("klipper_head_mcu/middle");
	list("klipper_head_mcu/top");
	list("klipper_head_mcu/top_oled");
	list("klipper_head_mcu/side");
		
	list("rj45/rj45_top");
	list("rj45/rj45_bottom");
	/*
	list("nozzles/blower_nozzle_left");
	list("nozzles/blower_nozzle_right");
	*/
	list("rpi_camera/rpi_camera_bottom");
	list("rpi_camera/rpi_camera_top");
	list("rpi_camera/rpi_cable_fix");
		
	list("filament_runout_sensor/filament_runout_sensor_top");
	list("filament_runout_sensor/filament_runout_sensor_bottom");
	list("filament_runout_sensor/filament_runout_sensor_stand");
	list("filament_runout_sensor/filament_runout_sensor_stand0");
	
	list("feeder_stand/feeder_stand_top");
	list("feeder_stand/feeder_stand_middle");
	list("feeder_stand/feeder_stand_bottom");
	list("feeder_stand/feeder_stand_plate");
	list("feeder_stand/feeder_stand_plate45");
	
	list("x_endstop/x_endstop");
	list("x_endstop/x_endstop_lock");
	
	list("y_carriage/y_carriage_left");
	list("y_carriage/y_carriage_right");
	list("y_carriage/y_carriage_right_flag");
	list("y_carriage/y_carriage_right_flag_alt");
	list("y_carriage/mgn9_y_stopper");
	
	list("z_carriage/z_endstop");
	list("z_carriage/z_endstop_lock");
	list("z_carriage/z_carriage_left");
	list("z_carriage/z_carriage_right");
	
	list("z_axis/z_bottom");
	list("z_axis/z_bottom_lock");
	list("z_axis/z_middle");
	list("z_axis/z_top");
	list("z_axis/z_top_lock");
	
	list("motor_blocks/left_motor_block");
	list("motor_blocks/right_motor_block");
	list("motor_blocks/y_endstop_lock");
	list("motor_blocks/m6_screw_driver");
	
	list("back_blocks/leftback_block");
	list("back_blocks/rightback_block");
	list("hotbed/support_back");
	list("hotbed/support_frontright");
	list("hotbed/support_frontleft");
	list("hotbed/knob");
	list("hotbed/spring_spacer_12mm_half_spring");
	
	list("enclosure/enclosure_floor");
	list("enclosure/enclosure_floor_fix");
	list("enclosure/enclosure_spacer_raspberrypi");
	list("enclosure/enclosure_spacer_ramps");
	
	list("xt90/xt90");
	list("wago/wago");
	list("legs/leg");
	list("legs/leg_tennis_ball");
	list("slot_cover/slot_cover_1mm");
	list("slot_cover/slot_bigcover_1mm");

	list("case/case_top");
	list("case/case_front");
	list("case/case_front_rj45");
	list("case/case_right");
	list("case/case_left");
	list("case/case_backleft");
	list("case/case_backright");
	list("case/m5_cap");
			
	list("wire_fix/wire_fix_corner_top_left");
	list("wire_fix/wire_fix_corner_top_right");
		
	list("oled_encoder/oled_encoder_top");
	list("oled_encoder/oled_encoder_bottom");
	list("oled_encoder/encoder_knob");
}

//////////////////////////////////////////////////////////////

if (cmd=="rj45/rj45_top")
{
	rotate ([0,180,0])
		rj45_top();
}
if (cmd=="rj45/rj45_bottom")
{
	rotate ([0,180,0])
		rj45_bottom();
}

//////////////////////////////////////////////////////////////

if (cmd=="rpi_camera/rpi_camera_bottom")
{
	rpi_camera_bottom();
}
if (cmd=="rpi_camera/rpi_camera_top")
{
	rotate ([0,180,0])
		rpi_camera_top();
}
if (cmd=="rpi_camera/rpi_cable_fix")
{
	rotate ([90,0,0])
		rpi_cable_fix();
}

//////////////////////////////////////////////////////////////

if (cmd=="filament_runout_sensor/filament_runout_sensor_top")
{
	filament_runout_sensor_top();
}
if (cmd=="filament_runout_sensor/filament_runout_sensor_bottom")
{
	filament_runout_sensor_bottom();
}
if (cmd=="filament_runout_sensor/filament_runout_sensor_stand")
{
	filament_runout_sensor_stand();
}
if (cmd=="filament_runout_sensor/filament_runout_sensor_stand0")
{
	filament_runout_sensor_stand0();
}

//////////////////////////////////////////////////////////////

if (cmd=="klipper_head_mcu/side")
{
	klipper_oled_encoder_side();
}
if (cmd=="klipper_head_mcu/top")
{
	klipper_nano_top();
}
if (cmd=="klipper_head_mcu/top_oled")
{
	rotate([0,0,0])
	klipper_nano_top_oled();
}
if (cmd=="klipper_head_mcu/middle")
{
	klipper_nano_middle();
}
if (cmd=="klipper_head_mcu/bottom")
{
	klipper_nano_bottom();
}
//////////////////////////////////////////////////////////////

if (cmd=="x_endstop/x_endstop")
{
	rotate ([0,180,0])
	x_endstop();
}
if (cmd=="x_endstop/x_endstop_lock")
{
	rotate ([-90,0,0])
	x_endstop_lock();
}

//////////////////////////////////////////////////////////////

if (cmd=="z_carriage/z_endstop")
{
	rotate ([0,180,0])
	z_endstop();
}
if (cmd=="z_carriage/z_endstop_lock")
{
	z_endstop_lock();
}
if (cmd=="z_carriage/z_carriage_left")
{
	echo (printer());
	rotate ([0,90,0])
	z_carriage_left();
}
if (cmd=="z_carriage/z_carriage_right")
{
	rotate ([0,-90,0])
	z_carriage_right();
}

//////////////////////////////////////////////////////////////

if (cmd=="z_axis/z_bottom")
{
	rotate ([0,0,0])
	zmotion_bottom();
}
if (cmd=="z_axis/z_bottom_lock")
{
	rotate ([0,-90,0])
	zmotion_bottom_lock();
}
if (cmd=="z_axis/z_middle")
{
	zmotion_middle_main(0);
}
if (cmd=="z_axis/z_top")
{
	rotate ([180,0,0])
	zmotion_top();
}
if (cmd=="z_axis/z_top_lock")
{
	rotate ([0,90,0])
	zmotion_top_lock();
}

//////////////////////////////////////////////////////////////

if (cmd=="motor_blocks/left_motor_block")
{
	rotate ([-90,0,0])
	leftfront_motorblock();
}
if (cmd=="motor_blocks/right_motor_block")
{
	rotate ([-90,0,0])
	rightfront_motorblock();
}
if (cmd=="motor_blocks/y_endstop_lock")
{
	rotate ([-90,0,0])
	y_endstop_lock();
}
if (cmd=="motor_blocks/m6_screw_driver")
{
	m6_screw_driver();
}

//////////////////////////////////////////////////////////////

if (cmd=="back_blocks/leftback_block")
{
	rotate ([-90,0,0])
	leftback_block();
}
if (cmd=="back_blocks/rightback_block")
{
	rotate ([-90,0,0])
	rightback_block();
}
//////////////////////////////////////////////////////////////

if (cmd=="hotbed/support_back")
{
	left_back_hotbed_support();
}
if (cmd=="hotbed/support_frontleft")
{
	left_front_hotbed_support();
}
if (cmd=="hotbed/support_frontright")
{
	right_front_hotbed_support();
}
if (cmd=="hotbed/knob")
{
	hotbed_knob();
}
if (cmd=="hotbed/spring_spacer_12mm_half_spring")
{
	spring_spacer(height=12);
}

//////////////////////////////////////////////////////////////

if (cmd=="y_carriage/y_carriage_left")
{
	rotate ([0,90,0])
	y_carriage_left();
}
if (cmd=="y_carriage/y_carriage_right")
{
	rotate ([0,-90,0])
	y_carriage_right();
}
if (cmd=="y_carriage/y_carriage_right_flag")
{
	rotate ([-90,0,0])
	y_carriage_right_flag();
}
if (cmd=="y_carriage/y_carriage_right_flag_alt")
{
	rotate ([-90,0,0])
	y_carriage_right_flag_alt();
}
if (cmd=="y_carriage/mgn9_y_stopper")
{
	rotate ([0,0,0])
	mgn9_y_stopper();
}
	

//////////////////////////////////////////////////////////////

if (cmd=="enclosure/enclosure_floor")
{
	rotate ([180,0,0])
	enclosure_floor(printable=true);
}
if (cmd=="enclosure/enclosure_floor_fix")
{
	rotate ([0,0,0])
	enclosure_floor_fix();
}
if (cmd=="enclosure/enclosure_spacer_raspberrypi")
{
	enclosure_spacer_raspberrypi();
}
if (cmd=="enclosure/enclosure_spacer_ramps")
{
	enclosure_spacer_ramps();
}

//////////////////////////////////////////////////////////////

if (cmd=="feeder_stand/feeder_stand_top")
{
	rotate ([90+45,0,0])
		feeder_stand_top();
}
if (cmd=="feeder_stand/feeder_stand_middle")
{
	rotate ([90,0,0])
		feeder_stand_middle();
}
if (cmd=="feeder_stand/feeder_stand_bottom")
{
	rotate ([90,0,0])
		feeder_stand_bottom();
}
if (cmd=="feeder_stand/feeder_stand_plate")
{
	rotate ([0,-90,0])
		feeder_stand_plate();
}

if (cmd=="feeder_stand/feeder_stand_plate45")
{
	rotate ([0,-90,0])
		feeder_stand_plate(feeder_nema_index=1);
}

//////////////////////////////////////////////////////////////

if (cmd=="legs/leg")
{
	rotate ([0,180,0])
	leg();
}

if (cmd=="legs/leg_tennis_ball")
{
	rotate ([0,180,0])
	tennis_leg();
}

//////////////////////////////////////////////////////////////

if (cmd=="xt90/xt90")
{
	rotate ([0,90,0])
		xt90();
}

//////////////////////////////////////////////////////////////

if (cmd=="wago/wago")
{
	wago();
}

//////////////////////////////////////////////////////////////

if (cmd=="slot_cover/slot_cover_1mm")
{
	rotate ([90,0,0])
		slot_cover(h=1,down=1);
}
if (cmd=="slot_cover/slot_bigcover_1mm")
{
	rotate ([0,0,0])
		slot_cover(h=1,down=1,up=5,cut_up=4.8,rounded=[2,1],fit_to_slot=true);
}

//////////////////////////////////////////////////////////////

if (cmd=="x_carriage/e3dv6_throat_bore4p1_ptfefix")
{
	e3d_fitting();
}
if (cmd=="x_carriage/e3dv6_throat_bore4p1_ptfefix2")
{
	e3d_fitting2();
}
if (cmd=="x_carriage/e3dv6_throat_bore4p1_ptfefixnut")
{
	rotate ([0,180,0])
		e3d_fitting_nut();
}

//////////////////////////////////////////////////////////////

if (cmd=="x_carriage/x_carriage_blower_nozzle")
{
	rotate ([90,0,0])
	blower_nozzle();
}
if (cmd=="x_carriage/x_carriage_top")
{
	rotate ([-90,0,0])
	x_carriage_top();
}
if (cmd=="x_carriage/x_carriage_bottom")
{
	rotate ([-90,0,0])
	x_carriage_bottom();
}
/*
if (cmd=="x_carriage/x_carriage_main")
{
	rotate ([-90,0,0])
	x_carriage_main();
}
*/
if (cmd=="x_carriage/x_carriage_blower_fixer_left")
{
	rotate ([90,0,0])
	blower_up_fix(m=false);
}                    
if (cmd=="x_carriage/x_carriage_blower_fixer_right")
{
	rotate ([-90,0,0])
	blower_up_fix(m=true);
}                    
if (cmd=="x_carriage/xcarriage_slot_wire_holder")
{
	rotate ([-90,0,0])
		xcarriage_slot_wire_holder();
}
if (cmd=="x_carriage/x_carriage_motor_plate")
{
	rotate ([-90,0,0])
		xcarriage_motor_plate();
}
if (cmd=="x_carriage/x_carriage_front")
{
	rotate ([0,0,0])
	x_carriage_front();
}
if (cmd=="x_carriage/x_carriage_back")
{
	rotate ([90,0,0])
	x_carriage_back();
}
if (cmd=="x_carriage/x_carriage_belt_fixer_left")
{
	rotate ([0,-90,0])
	x_carriage_belt_fixer_left();
}
if (cmd=="x_carriage/x_carriage_belt_fixer_right")
{
	rotate ([0,90,0])
	x_carriage_belt_fixer_right();
}

//////////////////////////////////////////////////////////////

if (cmd=="case/case_top")
{
	case_top();
}
if (cmd=="case/case_front")
{
	case_front();
}
if (cmd=="case/case_front_rj45")
{
	case_front(rj45=true);
}
if (cmd=="case/case_right")
{
	case_right();
}
if (cmd=="case/case_left")
{
	case_left();
}
if (cmd=="case/case_backleft")
{
	case_backleft();
}
if (cmd=="case/case_backright")
{
	case_backright();
}
if (cmd=="case/m5_cap")
{
	m5_cap();
}

//////////////////////////////////////////////////////////////
/*
if (cmd=="wire_fix/wire_fix_lefttop_corner_side")
{
	rotate ([0,90,0])
	wire_fix_lefttop_corner_side();
}
if (cmd=="wire_fix/wire_fix_righttop_corner_side")
{
	rotate ([0,-90,0])
	wire_fix_righttop_corner_side();
}
*/
if (cmd=="wire_fix/wire_fix_corner_top_left")
{
	rotate ([180,0,0])
		wire_fix_corner_top_left();
}
if (cmd=="wire_fix/wire_fix_corner_top_right")
{
	rotate ([180,0,0])
		wire_fix_corner_top_right();
}

//////////////////////////////////////////////////////////////
/*
if (cmd=="nozzles/blower_nozzle_left")
{
	rotate ([0,0,0])
	blower_nozzle_left();
}
if (cmd=="nozzles/blower_nozzle_right")
{
	rotate ([0,0,0])
	blower_nozzle_right();
}
*/
//////////////////////////////////////////////////////////////

if (cmd=="oled_encoder/oled_encoder_top")
{
	oled_encoder_top();
}
if (cmd=="oled_encoder/oled_encoder_bottom")
{
	oled_encoder_bottom();
}
if (cmd=="oled_encoder/encoder_knob")
{
	encoder_knob();
}

//////////////////////////////////////////////////////////////
