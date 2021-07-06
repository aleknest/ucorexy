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
use <oled_encoder.scad>

xposition=0;//-55..55
yposition=55;//-55..55
zposition=10;//0..90

deb(str("#Dimension: x=",front_back_slot()+20*2,", y=",y_slot()+20*2, ", z=",z_slot()));
//echo ($vpt,$vpr,$vpd);

//////////////////////////////////////////////////////////////

deb("*Slots, rails:");
proto_back_left();
proto_back_right();
proto_y_left(yposition=yposition);
proto_y_right(yposition=yposition);
proto_other_slots();
proto_front_slots();
proto_back_slots();
translate ([0,y_rail_y()+yposition,0])
{
	proto_x_slot(xposition=xposition);
}
proto_heatbed_slots(zposition=zposition);
proto_z_rails(zposition=zposition);

//////////////////////////////////////////////////////////////

deb("*Corner brackets:");

proto_slot_brackets(zposition=zposition);

//////////////////////////////////////////////////////////////

deb("*X carriage:");

translate ([0,y_rail_y()+yposition,0])
	proto_x(xposition=xposition);
translate ([xposition,y_rail_y()+yposition,0])
	proto_adxl345();

translate ([xposition,y_rail_y()+yposition,0])
{
	x_carriage_main();
	x_carriage_back();
	x_carriage_front();
	x_carriage_belt_fixer_left();
	x_carriage_belt_fixer_right();
}

//////////////////////////////////////////////////////////////

deb("*Fan nozzles:");

translate ([xposition,y_rail_y()+yposition,0])
{
	blower_nozzle_left();
	blower_nozzle_right();
}

//////////////////////////////////////////////////////////////

deb("*X carriage fans holder:");

translate ([0,y_rail_y()+yposition,0])
{
	proto_x_blowers(xposition=xposition);
}

//////////////////////////////////////////////////////////////

deb("*X endstop:");

x_endstop();
x_endstop_lock();

//////////////////////////////////////////////////////////////

deb("*Y carriage:");

translate ([0,yposition,0])
{
	y_carriage_left();
	y_carriage_right();
	y_carriage_right_flag();
}
translate_rotate(mgn9_y_stopper_tr())
	mgn9_y_stopper();

//////////////////////////////////////////////////////////////

deb("*Z carriage:");

z_carriage_left(zposition=zposition);
z_carriage_right(zposition=zposition);

proto_z_endstop();
z_endstop();
z_endstop_lock();

//////////////////////////////////////////////////////////////

deb("*Z axis motion:");

proto_z_belt(zposition=zposition);

zmotion_bottom();
zmotion_bottom_lock();
		
zmotion_top();
zmotion_top_lock();

zmotion_middle_main(zposition=zposition);

//////////////////////////////////////////////////////////////

deb("*Front blocks:");

proto_xymotors();
proto_xybelts(xposition=xposition,yposition=yposition);

leftfront_motorblock();
rightfront_motorblock();
y_endstop_lock();

//////////////////////////////////////////////////////////////

deb("*Back blocks:");

leftback_block();
rightback_block();

//////////////////////////////////////////////////////////////

deb("*Heated bed:");

proto_heatbed(zposition=zposition);
left_front_hotbed_support(zposition=zposition);
right_front_hotbed_support(zposition=zposition);
left_back_hotbed_support(zposition=zposition);
right_back_hotbed_support(zposition=zposition);
hotbed_knobs(zposition=zposition);

//////////////////////////////////////////////////////////////

deb("*Enclosure:");
enclosure_floor();
enclosure_floor_fix();
rotate ([0,0,90])
	enclosure_floor_fix();
rotate ([0,0,180])
	enclosure_floor_fix();
rotate ([0,0,270])
	enclosure_floor_fix();

//////////////////////////////////////////////////////////////

deb("*Feeder stand:");
feeder_stand_top();
feeder_stand_bottom();
feeder_stand_middle();
translate ([0,0,feeder_stand_middle_cut()]) feeder_stand_middle();
feeder_stand_plate();

//////////////////////////////////////////////////////////////

deb("*XT90:");
xt90();

//////////////////////////////////////////////////////////////
deb("*WAGO:");
wago();

//////////////////////////////////////////////////////////////

deb("*Legs:");
translate ([0,0,-z_slot()/2])
{
	translate_rotate (z_slot_leftfront_tr())
		leg();
	translate_rotate (z_slot_rightfront_tr())
		leg();
	translate_rotate (z_slot_leftback_tr())
		leg();
	translate_rotate (z_slot_rightback_tr())
		leg();
}

//////////////////////////////////////////////////////////////

deb("*Case:");

case_front();
case_right();
case_left();
case_backleft();
case_backright();

case_top();

//////////////////////////////////////////////////////////////

deb("*Wire fix:");
wire_fix_lefttop_corner();
wire_fix_righttop_corner();
wire_fix_front();

//////////////////////////////////////////////////////////////

deb("*oled screen and encoder:");
oled_encoder_top();
oled_encoder_bottom();

//////////////////////////////////////////////////////////////

deb("*Other:");
deb("Power supply 12V");
deb("GT2 belts");
deb("PTFE tube OD=4mm ID=1.9mm, blue");
for (i=[0:3])
{
	deb("M3x40 DIN 965 for hotbed");
	deb("M3 nut for hotbed");
}
