use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>
use <xcarriage.scad>
use <ycarriage.scad>
use <zcarriage.scad>
use <backcorners.scad>
use <xymotorblock.scad>
use <zmotion.scad>
use <hotbed.scad>
use <enclosure.scad>
use <feeder_stand.scad>
use <xt90.scad>
use <wago.scad>
use <slot_cover.scad>
use <legs.scad>
use <case.scad>
use <wire_fix.scad>
use <nozzles.scad>
use <e3dv6_ptfe_fix.scad>
use <oled_encoder.scad>

cmd="";

module list(s)
{
	echo(str("list:",s));
}

if (cmd=="list")
{
	list("x_carriage/e3dv6_throat_bore4p1_ptfefix");
	list("x_carriage/e3dv6_throat_bore4p1_ptfefixnut");
	
	list("feeder_stand/feeder_stand_top");
	list("feeder_stand/feeder_stand_middle");
	list("feeder_stand/feeder_stand_bottom");
	list("feeder_stand/feeder_test_case");
	
	list("x_endstop/x_endstop");
	list("x_endstop/x_endstop_lock");
	
	list("x_carriage/x_carriage_main");
	list("x_carriage/x_carriage_fans_m3");
	list("x_carriage/x_carriage_fans_m2p5");
	list("x_carriage/x_carriage_front");
	list("x_carriage/x_carriage_back");
	list("x_carriage/x_carriage_belt_fixer_left");
	list("x_carriage/x_carriage_belt_fixer_right");	

	list("y_carriage/y_carriage_left");
	list("y_carriage/y_carriage_right");
	list("y_carriage/y_carriage_right_flag");
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
	list("slot_cover/slot_cover_1mm");
	list("slot_cover/slot_bigcover_1mm");

	list("case/case_top");
	list("case/case_front");
	list("case/case_right");
	list("case/case_left");
	list("case/case_backleft");
	list("case/case_backright");
		
	list("nozzles/blower_nozzle_left");
	list("nozzles/blower_nozzle_right");
		
	list("wire_fix/wire_fix_lefttop_corner");
	list("wire_fix/wire_fix_righttop_corner");
	list("wire_fix/wire_fix_front");
	
	list("oled_encoder/oled_encoder_top");
	list("oled_encoder/oled_encoder_bottom");
	list("oled_encoder/encoder_knob");
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
	rotate ([90,0,0])
	leftfront_motorblock();
}
if (cmd=="motor_blocks/right_motor_block")
{
	rotate ([90,0,0])
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
	rotate ([0,-90,0])
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
if (cmd=="feeder_stand/feeder_test_case")
{
	rotate ([0,-90,0])
		feeder_plate();
}

//////////////////////////////////////////////////////////////

if (cmd=="legs/leg")
{
	rotate ([0,180,0])
	leg();
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
if (cmd=="x_carriage/e3dv6_throat_bore4p1_ptfefixnut")
{
	rotate ([0,180,0])
		e3d_fitting_nut();
}

//////////////////////////////////////////////////////////////

if (cmd=="x_carriage/x_carriage_main")
{
	rotate ([-90,0,0])
	x_carriage_main();
}
if (cmd=="x_carriage/x_carriage_fans")
{
	rotate ([-90,0,0])
	x_carriage_fans();
}
if (cmd=="x_carriage/x_carriage_fans_m3")
{
	rotate ([-90,0,0])
	x_carriage_fans(blower_screw_diameter=2.9);
}                    
if (cmd=="x_carriage/x_carriage_fans_m2p5")
{
	rotate ([-90,0,0])
	x_carriage_fans(blower_screw_diameter=2.4);
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

//////////////////////////////////////////////////////////////

if (cmd=="wire_fix/wire_fix_lefttop_corner")
{
	rotate ([0,90,0])
	wire_fix_lefttop_corner();
}
if (cmd=="wire_fix/wire_fix_righttop_corner")
{
	rotate ([0,-90,0])
	wire_fix_righttop_corner();
}
if (cmd=="wire_fix/wire_fix_front")
{
	rotate ([0,-90,0])
	wire_fix_front();
}

//////////////////////////////////////////////////////////////

if (cmd=="nozzles/blower_nozzle_left")
{
	rotate ([0,-90,0])
	blower_nozzle_left();
}
if (cmd=="nozzles/blower_nozzle_right")
{
	rotate ([0,90,0])
	blower_nozzle_right();
}

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
