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

cmd="motor_blocks/m6_screw_driver";

module list(s)
{
	echo(str("list:",s));
}

if (cmd=="list")
{
	list("x_endstop/x_endstop");
	list("x_endstop/x_endstop_lock");
	
	list("y_carriage/y_carriage_left");
	list("y_carriage/y_carriage_right");
	list("y_carriage/y_carriage_right_flag");
	
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
	list("hotbed/spring_spacer_15mm");
	
	list("enclosure/enclosure_floor");
	list("enclosure/enclosure_floor_fix");
	list("enclosure/enclosure_spacer_raspberrypi");
	list("enclosure/enclosure_spacer_ramps");
	
	list("feeder_stand/feeder_stand");
	
	list("xt90/xt90");
		
	list("x_carriage/x_carriage_main");
	list("x_carriage/x_carriage_fans");
	list("x_carriage/x_carriage_front");
	list("x_carriage/x_carriage_back");
	list("x_carriage/x_carriage_belt_fixer_left");
	list("x_carriage/x_carriage_belt_fixer_right");
}

//////////////////////////////////////////////////////////////

if (cmd=="x_endstop/x_endstop")
{
	rotate ([0,180,0])
	x_endstop();
}
if (cmd=="x_endstop/x_endstop_lock")
{
	x_endstop_lock();
}
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
if (cmd=="hotbed/spring_spacer_15mm")
{
	spring_spacer(height=15);
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

if (cmd=="feeder_stand/feeder_stand")
{
	rotate ([0,-90,0])
		feeder_stand();
}

//////////////////////////////////////////////////////////////

if (cmd=="xt90/xt90")
{
	rotate ([0,90,0])
		xt90();
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

/*
deb("Other:");

translate ([xposition,y_rail_y()+yposition,0])
{
	x_carriage_back();
	x_carriage_front();
	x_carriage_belt_fixer_left();
	x_carriage_belt_fixer_right();
	x_carriage_fans();
}

*/