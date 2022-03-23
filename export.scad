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

cmd="";

module list(s)
{
	echo(str("list:",s));
}

if (cmd=="list")
{
	list(str(printer_dir(),"/x_carriage/x_carriage_blower_nozzle"));
	list(str(printer_dir(),"/x_carriage/x_carriage_bottom"));
	list(str(printer_dir(),"/x_carriage/x_carriage_front"));
	list(str(printer_dir(),"/x_carriage/x_carriage_back"));
	list(str(printer_dir(),"/x_carriage/x_carriage_top"));
	list(str(printer_dir(),"/x_carriage/x_carriage_motor_plate"));
	list(str(printer_dir(),"/x_carriage/xcarriage_slot_wire_holder"));
	list(str(printer_dir(),"/x_carriage/x_carriage_blower_fixer_left"));
	list(str(printer_dir(),"/x_carriage/x_carriage_blower_fixer_right"));
	
	list(str(printer_dir(),"/x_carriage/x_carriage_belt_fixer_left"));
	list(str(printer_dir(),"/x_carriage/x_carriage_belt_fixer_right"));	
	list(str(printer_dir(),"/x_carriage/e3dv6_throat_bore4p1_ptfefix"));
	list(str(printer_dir(),"/x_carriage/e3dv6_throat_bore4p1_ptfefixnut"));
	
	list(str(printer_dir(),"/klipper_head_mcu/bottom"));
	list(str(printer_dir(),"/klipper_head_mcu/middle"));
	list(str(printer_dir(),"/klipper_head_mcu/top"));
	list(str(printer_dir(),"/klipper_head_mcu/top_oled"));
	list(str(printer_dir(),"/klipper_head_mcu/side"));
		
	list(str(printer_dir(),"/rj45/rj45_top"));
	list(str(printer_dir(),"/rj45/rj45_bottom"));
	list(str(printer_dir(),"/rpi_camera/rpi_camera_bottom"));
	list(str(printer_dir(),"/rpi_camera/rpi_camera_top"));
	list(str(printer_dir(),"/rpi_camera/rpi_cable_fix"));
		
	list(str(printer_dir(),"/filament_runout_sensor/filament_runout_sensor_top"));
	list(str(printer_dir(),"/filament_runout_sensor/filament_runout_sensor_bottom"));
	list(str(printer_dir(),"/filament_runout_sensor/filament_runout_sensor_stand"));
	list(str(printer_dir(),"/filament_runout_sensor/filament_runout_sensor_stand0"));
	
	list(str(printer_dir(),"/feeder_stand/feeder_stand_top"));
	list(str(printer_dir(),"/feeder_stand/feeder_stand_middle"));
	list(str(printer_dir(),"/feeder_stand/feeder_stand_bottom"));
	list(str(printer_dir(),"/feeder_stand/feeder_stand_plate"));
	list(str(printer_dir(),"/feeder_stand/feeder_stand_plate45"));
	
	list(str(printer_dir(),"/x_endstop/x_endstop"));
	list(str(printer_dir(),"/x_endstop/x_endstop_lock"));
	
	list(str(printer_dir(),"/y_carriage/y_carriage_left"));
	list(str(printer_dir(),"/y_carriage/y_carriage_right"));
	list(str(printer_dir(),"/y_carriage/y_carriage_right_flag"));
	list(str(printer_dir(),"/y_carriage/y_carriage_right_flag_alt"));
	list(str(printer_dir(),"/y_carriage/mgn9_y_stopper"));
	
	list(str(printer_dir(),"/z_carriage/z_endstop"));
	list(str(printer_dir(),"/z_carriage/z_endstop_lock"));
	list(str(printer_dir(),"/z_carriage/z_carriage_left"));
	list(str(printer_dir(),"/z_carriage/z_carriage_right"));
	
	list(str(printer_dir(),"/z_axis/z_bottom"));
	list(str(printer_dir(),"/z_axis/z_bottom_lock"));
	list(str(printer_dir(),"/z_axis/z_middle"));
	list(str(printer_dir(),"/z_axis/z_top"));
	list(str(printer_dir(),"/z_axis/z_top_lock"));
	
	list(str(printer_dir(),"/motor_blocks/left_motor_block"));
	list(str(printer_dir(),"/motor_blocks/right_motor_block"));
	list(str(printer_dir(),"/motor_blocks/y_endstop_lock"));
	list(str(printer_dir(),"/motor_blocks/m6_screw_driver"));
	
	list(str(printer_dir(),"/back_blocks/leftback_block"));
	list(str(printer_dir(),"/back_blocks/rightback_block"));
	list(str(printer_dir(),"/hotbed/support_back"));
	list(str(printer_dir(),"/hotbed/support_frontright"));
	list(str(printer_dir(),"/hotbed/support_frontleft"));
	list(str(printer_dir(),"/hotbed/knob"));
	list(str(printer_dir(),"/hotbed/spring_spacer_12mm_half_spring"));
	
	list(str(printer_dir(),"/enclosure/enclosure_floor"));
	list(str(printer_dir(),"/enclosure/enclosure_floor_fix"));
	list(str(printer_dir(),"/enclosure/enclosure_spacer_raspberrypi"));
	list(str(printer_dir(),"/enclosure/enclosure_spacer_ramps"));
	
	list(str(printer_dir(),"/case/case_top"));
	list(str(printer_dir(),"/case/case_front"));
	list(str(printer_dir(),"/case/case_front_rj45"));
	list(str(printer_dir(),"/case/case_right"));
	list(str(printer_dir(),"/case/case_left"));
	list(str(printer_dir(),"/case/case_backleft"));
	list(str(printer_dir(),"/case/case_backright"));
	list(str(printer_dir(),"/case/m5_cap"));
			
	list(str(printer_dir(),"/wire_fix/wire_fix_corner_top_left"));
	list(str(printer_dir(),"/wire_fix/wire_fix_corner_top_right"));
		
	list(str(printer_dir(),"/oled_encoder/oled_encoder_top"));
	list(str(printer_dir(),"/oled_encoder/oled_encoder_bottom"));
	list(str(printer_dir(),"/oled_encoder/encoder_knob"));

	list(str(printer_dir(),"/xt90/xt90"));
	list(str(printer_dir(),"/wago/wago"));
	list(str(printer_dir(),"/slot_cover/slot_cover_1mm"));
	list(str(printer_dir(),"/slot_cover/slot_bigcover_1mm"));
	list(str(printer_dir(),"/legs/leg"));
	list(str(printer_dir(),"/legs/leg_tennis_ball"));
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/rj45/rj45_top"))
{
	rotate ([0,180,0])
		rj45_top();
}
if (cmd==str(printer_dir(),"/rj45/rj45_bottom"))
{
	rotate ([0,180,0])
		rj45_bottom();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/rpi_camera/rpi_camera_bottom"))
{
	rpi_camera_bottom();
}
if (cmd==str(printer_dir(),"/rpi_camera/rpi_camera_top"))
{
	rotate ([0,180,0])
		rpi_camera_top();
}
if (cmd==str(printer_dir(),"/rpi_camera/rpi_cable_fix"))
{
	rotate ([90,0,0])
		rpi_cable_fix();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/filament_runout_sensor/filament_runout_sensor_top"))
{
	filament_runout_sensor_top();
}
if (cmd==str(printer_dir(),"/filament_runout_sensor/filament_runout_sensor_bottom"))
{
	filament_runout_sensor_bottom();
}
if (cmd==str(printer_dir(),"/filament_runout_sensor/filament_runout_sensor_stand"))
{
	filament_runout_sensor_stand();
}
if (cmd==str(printer_dir(),"/filament_runout_sensor/filament_runout_sensor_stand0"))
{
	filament_runout_sensor_stand0();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/klipper_head_mcu/side"))
{
	klipper_oled_encoder_side();
}
if (cmd==str(printer_dir(),"/klipper_head_mcu/top"))
{
	klipper_nano_top();
}
if (cmd==str(printer_dir(),"/klipper_head_mcu/top_oled"))
{
	rotate([0,0,0])
	klipper_nano_top_oled();
}
if (cmd==str(printer_dir(),"/klipper_head_mcu/middle"))
{
	klipper_nano_middle();
}
if (cmd==str(printer_dir(),"/klipper_head_mcu/bottom"))
{
	klipper_nano_bottom();
}
//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/x_endstop/x_endstop"))
{
	rotate ([0,180,0])
	x_endstop();
}
if (cmd==str(printer_dir(),"/x_endstop/x_endstop_lock"))
{
	rotate ([-90,0,0])
	x_endstop_lock();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/z_carriage/z_endstop"))
{
	rotate ([0,180,0])
	z_endstop();
}
if (cmd==str(printer_dir(),"/z_carriage/z_endstop_lock"))
{
	z_endstop_lock();
}
if (cmd==str(printer_dir(),"/z_carriage/z_carriage_left"))
{
	echo (printer());
	rotate ([0,90,0])
	z_carriage_left();
}
if (cmd==str(printer_dir(),"/z_carriage/z_carriage_right"))
{
	rotate ([0,-90,0])
	z_carriage_right();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/z_axis/z_bottom"))
{
	rotate ([0,0,0])
	zmotion_bottom();
}
if (cmd==str(printer_dir(),"/z_axis/z_bottom_lock"))
{
	rotate ([0,-90,0])
	zmotion_bottom_lock();
}
if (cmd==str(printer_dir(),"/z_axis/z_middle"))
{
	zmotion_middle_main(0);
}
if (cmd==str(printer_dir(),"/z_axis/z_top"))
{
	rotate ([180,0,0])
	zmotion_top();
}
if (cmd==str(printer_dir(),"/z_axis/z_top_lock"))
{
	rotate ([0,90,0])
	zmotion_top_lock();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/motor_blocks/left_motor_block"))
{
	rotate ([-90,0,0])
	leftfront_motorblock();
}
if (cmd==str(printer_dir(),"/motor_blocks/right_motor_block"))
{
	rotate ([-90,0,0])
	rightfront_motorblock();
}
if (cmd==str(printer_dir(),"/motor_blocks/y_endstop_lock"))
{
	rotate ([-90,0,0])
	y_endstop_lock();
}
if (cmd==str(printer_dir(),"/motor_blocks/m6_screw_driver"))
{
	m6_screw_driver();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/back_blocks/leftback_block"))
{
	rotate ([-90,0,0])
	leftback_block();
}
if (cmd==str(printer_dir(),"/back_blocks/rightback_block"))
{
	rotate ([-90,0,0])
	rightback_block();
}
//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/hotbed/support_back"))
{
	left_back_hotbed_support();
}
if (cmd==str(printer_dir(),"/hotbed/support_frontleft"))
{
	left_front_hotbed_support();
}
if (cmd==str(printer_dir(),"/hotbed/support_frontright"))
{
	right_front_hotbed_support();
}
if (cmd==str(printer_dir(),"/hotbed/knob"))
{
	hotbed_knob();
}
if (cmd==str(printer_dir(),"/hotbed/spring_spacer_12mm_half_spring"))
{
	spring_spacer(height=12);
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/y_carriage/y_carriage_left"))
{
	rotate ([0,90,0])
	y_carriage_left();
}
if (cmd==str(printer_dir(),"/y_carriage/y_carriage_right"))
{
	rotate ([0,-90,0])
	y_carriage_right();
}
if (cmd==str(printer_dir(),"/y_carriage/y_carriage_right_flag"))
{
	rotate ([-90,0,0])
	y_carriage_right_flag();
}
if (cmd==str(printer_dir(),"/y_carriage/y_carriage_right_flag_alt"))
{
	rotate ([-90,0,0])
	y_carriage_right_flag_alt();
}
if (cmd==str(printer_dir(),"/y_carriage/mgn9_y_stopper"))
{
	rotate ([0,0,0])
	mgn9_y_stopper();
}
	

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/enclosure/enclosure_floor"))
{
	rotate ([180,0,0])
	enclosure_floor(printable=true);
}
if (cmd==str(printer_dir(),"/enclosure/enclosure_floor_fix"))
{
	rotate ([0,0,0])
	enclosure_floor_fix();
}
if (cmd==str(printer_dir(),"/enclosure/enclosure_spacer_raspberrypi"))
{
	enclosure_spacer_raspberrypi();
}
if (cmd==str(printer_dir(),"/enclosure/enclosure_spacer_ramps"))
{
	enclosure_spacer_ramps();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/feeder_stand/feeder_stand_top"))
{
	rotate ([90+45,0,0])
		feeder_stand_top();
}
if (cmd==str(printer_dir(),"/feeder_stand/feeder_stand_middle"))
{
	rotate ([90,0,0])
		feeder_stand_middle();
}
if (cmd==str(printer_dir(),"/feeder_stand/feeder_stand_bottom"))
{
	rotate ([90,0,0])
		feeder_stand_bottom();
}
if (cmd==str(printer_dir(),"/feeder_stand/feeder_stand_plate"))
{
	rotate ([0,-90,0])
		feeder_stand_plate();
}

if (cmd==str(printer_dir(),"/feeder_stand/feeder_stand_plate45"))
{
	rotate ([0,-90,0])
		feeder_stand_plate(feeder_nema_index=1);
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/legs/leg"))
{
	rotate ([0,180,0])
	leg();
}

if (cmd==str(printer_dir(),"/legs/leg_tennis_ball"))
{
	rotate ([0,180,0])
	tennis_leg();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/xt90/xt90"))
{
	rotate ([0,90,0])
		xt90();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/wago/wago"))
{
	wago();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/slot_cover/slot_cover_1mm"))
{
	rotate ([90,0,0])
		slot_cover(h=1,down=1);
}
if (cmd==str(printer_dir(),"/slot_cover/slot_bigcover_1mm"))
{
	rotate ([0,0,0])
		slot_cover(h=1,down=1,up=5,cut_up=4.8,rounded=[2,1],fit_to_slot=true);
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/x_carriage/e3dv6_throat_bore4p1_ptfefix"))
{
	e3d_fitting2();
}
if (cmd==str(printer_dir(),"/x_carriage/e3dv6_throat_bore4p1_ptfefixnut"))
{
	rotate ([0,180,0])
		e3d_fitting_nut();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/x_carriage/x_carriage_blower_nozzle"))
{
	rotate ([90,0,0])
	blower_nozzle();
}
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_top"))
{
	rotate ([-90,0,0])
	x_carriage_top();
}
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_bottom"))
{
	rotate ([-90,0,0])
	x_carriage_bottom();
}
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_blower_fixer_left"))
{
	rotate ([90,0,0])
	blower_up_fix(m=false);
}                    
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_blower_fixer_right"))
{
	rotate ([-90,0,0])
	blower_up_fix(m=true);
}                    
if (cmd==str(printer_dir(),"/x_carriage/xcarriage_slot_wire_holder"))
{
	rotate ([-90,0,0])
		xcarriage_slot_wire_holder();
}
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_motor_plate"))
{
	rotate ([-90,0,0])
		xcarriage_motor_plate();
}
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_front"))
{
	rotate ([0,0,0])
	x_carriage_front();
}
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_back"))
{
	rotate ([90,0,0])
	x_carriage_back();
}
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_belt_fixer_left"))
{
	rotate ([0,-90,0])
	x_carriage_belt_fixer_left();
}
if (cmd==str(printer_dir(),"/x_carriage/x_carriage_belt_fixer_right"))
{
	rotate ([0,90,0])
	x_carriage_belt_fixer_right();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/case/case_top"))
{
	case_top();
}
if (cmd==str(printer_dir(),"/case/case_front"))
{
	case_front();
}
if (cmd==str(printer_dir(),"/case/case_front_rj45"))
{
	case_front(rj45=true);
}
if (cmd==str(printer_dir(),"/case/case_right"))
{
	case_right();
}
if (cmd==str(printer_dir(),"/case/case_left"))
{
	case_left();
}
if (cmd==str(printer_dir(),"/case/case_backleft"))
{
	case_backleft();
}
if (cmd==str(printer_dir(),"/case/case_backright"))
{
	case_backright();
}
if (cmd==str(printer_dir(),"/case/m5_cap"))
{
	m5_cap();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/wire_fix/wire_fix_corner_top_left"))
{
	rotate ([180,0,0])
		wire_fix_corner_top_left();
}
if (cmd==str(printer_dir(),"/wire_fix/wire_fix_corner_top_right"))
{
	rotate ([180,0,0])
		wire_fix_corner_top_right();
}

//////////////////////////////////////////////////////////////

if (cmd==str(printer_dir(),"/oled_encoder/oled_encoder_top"))
{
	oled_encoder_top();
}
if (cmd==str(printer_dir(),"/oled_encoder/oled_encoder_bottom"))
{
	oled_encoder_bottom();
}
if (cmd==str(printer_dir(),"/oled_encoder/encoder_knob"))
{
	encoder_knob();
}

//////////////////////////////////////////////////////////////
