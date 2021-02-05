use <utils.scad>
include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/rails.scad>
include <../_utils_v2/NopSCADlib/vitamins/hot_end.scad>
include <../_utils_v2/NopSCADlib/vitamins/hot_ends.scad>
include <../_utils_v2/NopSCADlib/vitamins/blower.scad>
include <../_utils_v2/NopSCADlib/vitamins/blowers.scad>
include <../_utils_v2/NopSCADlib/vitamins/fan.scad>
include <../_utils_v2/NopSCADlib/vitamins/fans.scad>
include <../_utils_v2/NopSCADlib/vitamins/pulleys.scad>
include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>

//                 L     L1    W   H   H1   C   B
MGN9C_carriage  = [ 28.9, 18.9, 20, 10, 2,   10, 15, M3_cap_screw ];
function MGN9C() = [ "MGN9",  9,  6,   7.5, 20, 6.0, 3.5, 3.5, M3_cap_screw, MGN9C_carriage, M3_cs_cap_screw ];
MGN9H_carriage  = [ 39.9, 29.9, 20, 10, 2,   16, 15, M3_cap_screw ];
function MGN9H() = [ "MGN9H",  9,  6,   7.5, 20, 6.0, 3.5, 3.5, M3_cap_screw,    MGN9H_carriage, M3_cs_cap_screw ];

function x_slot()=184-6;
function x_slot_tr()=[[0,0,carriage_height(rail_carriage(y_rail_type()))],[0,90,0]];

function x_rail_type()=MGN9C();
function x_rail()=150;
function x_rail_tr()=[vec_add(x_slot_tr()[0],[0,-10,0]),[90,0,0]];

function e3d_type()=E3Dv6;
function e3d_tr(position=0)=[vec_add([
	 position
	,-10-hot_end_insulator_diameter(e3d_type())/2-carriage_height(rail_carriage(x_rail_type()))
	,x_rail_tr()[0].z],[0,-6,-4])
	,[0,0,0]];

function e3d_fan_type()=fan40x11;
function e3d_fan_tr(position)=[vec_add(e3d_tr(position)[0],[0,42.5,-31.8]),[-90,0,0]];

function e3d_blower_type()=BL40x10;
function e3d_blower_offset()=[18,-11.5,-52];
function e3d_blower_left_tr(position)=[
	vec_add(e3d_tr(position)[0],[-e3d_blower_offset().x,40+e3d_blower_offset().y,e3d_blower_offset().z])
	,[90,0,-90]];
function e3d_blower_right_tr(position)=[
	vec_add(e3d_tr(position)[0],[e3d_blower_offset().x,e3d_blower_offset().y,e3d_blower_offset().z])
	,[90,0,90]];
	
function xcarriage_thickness()=[36,26,4,4.9+0.8];
function xcarriage_dim()=[28,20+xcarriage_thickness()[0]+xcarriage_thickness()[2],20+xcarriage_thickness()[1]+xcarriage_thickness()[3]];	
function xcarriage_tr() = [vec_add(x_slot_tr()[0]
	,[-xcarriage_dim().x/2,-10-xcarriage_thickness()[0],x_slot_tr()[0].z-20-xcarriage_thickness()[3]])
	,[0,0,0]];

function y_slot()=180;
function y_slot_offset()=1;
function y_slot_left_tr()=[[-x_slot()/2-y_slot_offset()-10
						,0,0],[0,90,90]];
function y_slot_right_tr()=[[x_slot()/2+y_slot_offset()+10
						,0,0],[0,90,-90]];

function y_rail_type()=MGN9H();
function y_rail()=150;
function y_rail_y()=15;
function y_rail_left_tr()=[vec_add(y_slot_left_tr()[0],[0,y_rail_y(),10]),[0,0,90]];
function y_rail_right_tr()=[vec_add(y_slot_right_tr()[0],[0,y_rail_y(),10]),[0,0,-90]];

function y_carriage_thickness()=30;
function y_carriage_sidethickness()=4;
function y_carriage_slot_crawl()=10;

function z_slot()=230;
function z_slot_fronty()=y_slot_left_tr()[0].y-y_slot()/2-10;
function z_slot_backy()=y_slot_left_tr()[0].y+y_slot()/2+10;
function z_slot_leftfront_tr()=[[y_slot_left_tr()[0].x,z_slot_fronty(),-z_slot()/2+10],[0,0,0]];
function z_slot_leftback_tr()=[[y_slot_left_tr()[0].x,z_slot_backy(),-z_slot()/2+10],[0,0,0]];
function z_slot_rightfront_tr()=[[y_slot_right_tr()[0].x,z_slot_fronty(),-z_slot()/2+10],[0,0,0]];
function z_slot_rightback_tr()=[[y_slot_right_tr()[0].x,z_slot_backy(),-z_slot()/2+10],[0,0,0]];

function front_back_slot()=z_slot_rightback_tr()[0].x-z_slot_leftback_tr()[0].x-20;
function z_slot_topback_tr()=[[0,z_slot_backy(),0],[0,90,0]];
function z_slot_bottomback_tr()=[[0,z_slot_backy(),-z_slot()+20],[0,90,0]];
function z_slot_topfront_tr()=[[0,z_slot_fronty(),0],[0,90,0]];
function z_slot_bottomfront_tr()=[[0,z_slot_fronty(),-z_slot()+20],[0,90,0]];

function y_slot_bottomleft_tr()=tr_replace(y_slot_left_tr(),2,z_slot_bottomback_tr()[0].z);
function y_slot_bottomright_tr()=tr_replace(y_slot_right_tr(),2,z_slot_bottomback_tr()[0].z);

function y_pulley_type()=GT2x16_plain_idler;
function y_pulley_xoffset_add()=4;
function y_pulley_offsets()=[
	 19+y_pulley_xoffset_add()
	,(pulley_od(y_pulley_type())+belt_thickness(xybelt_type())/2)/2
	,carriage_height(rail_carriage(y_rail_type()))+pulley_height(y_pulley_type())/2+6
	];
function y_bottompulley_offsets()=[0,0,pulley_height(y_pulley_type())+1];

function y_leftfront_pulley_tr()=[vec_add(y_rail_left_tr()[0]
	,[y_pulley_offsets().x,-y_pulley_offsets().y,y_pulley_offsets().z])
	,[0,0,0]];
function y_leftback_pulley_tr()=[vec_add(vec_add(y_rail_left_tr()[0]
	,[y_pulley_offsets().x,y_pulley_offsets().y,y_pulley_offsets().z])
	,y_bottompulley_offsets())
	,[0,0,0]];
function y_rightfront_pulley_tr()=[vec_add(vec_add(y_rail_right_tr()[0]
	,[-y_pulley_offsets().x,-y_pulley_offsets().y,y_pulley_offsets().z])
	,y_bottompulley_offsets())
	,[0,0,0]];
function y_rightback_pulley_tr()=[vec_add(y_rail_right_tr()[0]
	,[-y_pulley_offsets().x,y_pulley_offsets().y,y_pulley_offsets().z])
	,[0,0,0]];
	
function xybelt_type()=GT2x6;

//                          corner  body    boss    boss          shaft
//                          side, length, radius, radius, radius, depth, shaft, length,      holes, cap heights
NEMA17ali  = ["NEMA17ali",   42.3, 38.3,     53.6/2, 25,     11,     2,     5,     24,          31,    [11.5,  9]];
NEMA17titan  = ["NEMA17titan",   42.3, 23.5,     53.6/2, 25,     11,     2,     5,     24,          31,    [11.5,  9]];

function motor_pulley_type()=T2p5x16_pulley;
function motor_type()=NEMA17ali;
function motor_pulley_xshift()=pulley_od(y_pulley_type())/2+pulley_od(motor_pulley_type())/2+belt_thickness(xybelt_type())/2;
function left_motorpulley_tr()=[vec_add(vec_replace(y_leftfront_pulley_tr()[0],1
	,z_slot_topfront_tr()[0].y+(NEMA_width(motor_type())-20)/2)
	,[-motor_pulley_xshift(),0,0]),[180,0,0]];
function right_motorpulley_tr()=[vec_add(vec_replace(y_rightfront_pulley_tr()[0],1
	,z_slot_topfront_tr()[0].y+(NEMA_width(motor_type())-20)/2)
	,[motor_pulley_xshift(),0,0]),[180,0,0]];
function motor_z_offset()=15;
function left_motor_tr()=[vec_add(left_motorpulley_tr()[0],[0,0,motor_z_offset()]),[180,0,0]];
function right_motor_tr()=[vec_add(right_motorpulley_tr()[0],[0,0,motor_z_offset()]),[180,0,0]];

function backpulley_y()=z_slot_topback_tr()[0].y;
function left_top_backpulley() =[[left_motorpulley_tr()[0].x,backpulley_y(),y_leftfront_pulley_tr()[0].z],[0,0,0]];
function left_bottom_backpulley() =tr_add([[left_motorpulley_tr()[0].x,backpulley_y(),y_leftback_pulley_tr()[0].z]
	,[0,0,0]],[motor_pulley_xshift(),0,0]);
function right_top_backpulley() =[[y_rightfront_pulley_tr()[0].x,backpulley_y(),y_rightback_pulley_tr()[0].z],[0,0,0]];
function right_bottom_backpulley() =tr_add([[y_rightback_pulley_tr()[0].x,backpulley_y(),y_rightfront_pulley_tr()[0].z]
	,[0,0,0]],[motor_pulley_xshift(),0,0]);

function back_block_dim()=[34+y_pulley_xoffset_add(),20,carriage_height(rail_carriage(y_rail_type()))+y_carriage_thickness()];
function leftback_block_tr()=[[
	 y_slot_left_tr()[0].x-10
	,z_slot_topback_tr()[0].y-10
	,y_slot_left_tr()[0].z+10
	],[0,0,0]];
function rightback_block_tr()=[[
	 y_slot_right_tr()[0].x+10
	,z_slot_topback_tr()[0].y+10
	,y_slot_right_tr()[0].z+10
	],[0,0,180]];
	
function leftfront_motorblock_dim()=[NEMA_width(motor_type())
									,NEMA_width(motor_type())
									,left_motor_tr()[0].z-(y_slot_left_tr()[0].z+10)];
function leftfront_motorblock_tr()=[[
	 left_motor_tr()[0].x-NEMA_width(motor_type())/2
	,z_slot_topfront_tr()[0].y-10
	,y_slot_left_tr()[0].z+10
	],[0,0,0]];
function leftfront_motorblock_thickness()=[6+4,5,5,5];
	
function rightfront_motorblock_dim()=[NEMA_width(motor_type())
									,NEMA_width(motor_type())
									,right_motor_tr()[0].z-(y_slot_right_tr()[0].z+10)];
function rightfront_motorblock_tr()=[[
	 right_motor_tr()[0].x+NEMA_width(motor_type())/2
	,z_slot_topfront_tr()[0].y+rightfront_motorblock_dim().y-10
	,y_slot_right_tr()[0].z+10
	],[0,0,180]];
	
function lrz_xymotor_diff() =abs(left_motor_tr()[0].z-right_motor_tr()[0].z);
function rightfront_motorblock_thickness()=[leftfront_motorblock_thickness()[0]+lrz_xymotor_diff()
										,leftfront_motorblock_thickness()[1]
										,leftfront_motorblock_thickness()[2]
										,leftfront_motorblock_thickness()[3]
										];

function zbelt_type()=GT2x6;
function zmotor_pulley_type()=T2p5x16_pulley;
function zmotor_type()=NEMA17ali;
function z_pulley_type()=GT2x16_plain_idler;
function z_pulley_count()=3;
function z_pulley_offset()=(pulley_od(z_pulley_type())+belt_thickness(zbelt_type())/2);
function zmotor_thickness()=8;
function z_pulley2slot_offset()=11;
function z_middlepulley_offset()=16;
function zmotor_pulley_tr()=[vec_add(z_slot_bottomback_tr()[0],[-30,0,10+z_pulley2slot_offset()])
	,[-90,0,0]];
function zmotor_tr()=[vec_add(zmotor_pulley_tr()[0],[0,-10-zmotor_thickness(),0]),zmotor_pulley_tr()[1]];
function zbottom_pulley_tr(i)=tr_add(zmotor_pulley_tr(),[z_pulley_offset()*i*2,0,0]);
function zmiddle_pulley_tr(i,mid,zposition)=tr_replace(tr_add(zmotor_pulley_tr(),[z_pulley_offset()*(i*2+1),0,0]),2,backheatbed_slot_tr()[0].z+zposition+z_middlepulley_offset()/2*mid);
function ztop_pulley_tr(i)=tr_replace(tr_add(zmotor_pulley_tr(),[z_pulley_offset()*i*2,0,0]),2
	,z_slot_topback_tr()[0].z-10-z_pulley2slot_offset());
	
function zbottom_pulleyblock_dim()=[
	NEMA_width(motor_type())/2+abs(zbottom_pulley_tr(z_pulley_count())[0].x-zbottom_pulley_tr(0)[0].x)+pulley_flange_dia(z_pulley_type())/2+4
	,20,z_pulley2slot_offset()+6];
function zbottom_pulleyblock_tr()=[[zbottom_pulley_tr(0)[0].x-NEMA_width(motor_type())/2
									,z_slot_bottomback_tr()[0].y-10
									,z_slot_bottomback_tr()[0].z+10
									],[0,0,0]];

function ztop_pulleyblock_dim()=[
	abs(ztop_pulley_tr(z_pulley_count())[0].x-ztop_pulley_tr(0)[0].x)+pulley_flange_dia(z_pulley_type())+6
	,20,z_pulley2slot_offset()+6];
function ztop_pulleyblock_tr()=[[ztop_pulley_tr(0)[0].x-pulley_flange_dia(z_pulley_type())/2-6
									,z_slot_topback_tr()[0].y-10
									,z_slot_topback_tr()[0].z-ztop_pulleyblock_dim().z-10
									],[0,0,0]];
function zmiddle_pulleyblock_height()=28;
function zmiddle_pulleyblock_tr()=[[zmiddle_pulley_tr(0,0,0)[0].x-pulley_flange_dia(z_pulley_type())/2-6
									,backheatbed_slot_tr()[0].y+10
									,backheatbed_slot_tr()[0].z-zmiddle_pulleyblock_height()/2
									],[0,0,0]];
function zmiddle_pulleyblock_dim()=[
	abs(zmiddle_pulley_tr(z_pulley_count()-1,0,0)[0].x-zmiddle_pulley_tr(0,0,0)[0].x)+pulley_flange_dia(z_pulley_type())+6*2
	,abs(backheatbed_slot_tr()[0].y-z_slot_topback_tr()[0].y),zmiddle_pulleyblock_height()];

function bed_screws_offset()=[3,3];
function bed_dim()=[120,120,3];
function bed_plate_tr()=[[0,-20,backheatbed_slotz()+10],[0,0,0]];

function leftrightheatbed_slot() = 190;//180+10;
function leftrightheatbed_slot_xoffset() = 5;
function leftrightheatbed_slot_x() = leftrightheatbed_slot_xoffset()+bed_dim().x/2+10;
function leftheatbed_slot_tr() = [
	 [-leftrightheatbed_slot_x()
	 	,z_slot_bottomback_tr()[0].y-leftrightheatbed_slot()/2//-10
		,backheatbed_slot_tr()[0].z]
	,[0,90,90]];
function rightheatbed_slot_tr() = [
	 [leftrightheatbed_slot_x()
	 	,z_slot_bottomback_tr()[0].y-leftrightheatbed_slot()/2//-10
		,backheatbed_slot_tr()[0].z]
	,[0,90,90]];
	
function backheatbed_slot() = leftrightheatbed_slot_x()*2-20;
function backheatbed_slotyoffset() = 10;
function backheatbed_slotzoffset() = 35;
function backheatbed_slotz()=-z_slot()+40+backheatbed_slotzoffset();
function backheatbed_slot_tr() = [
	 [0,z_slot_bottomback_tr()[0].y-20-backheatbed_slotyoffset(),backheatbed_slotz()]
	,[0,90,0]];

function z_rail_type()=MGN9H();
function z_rail()=150;
function z_rail_up()=z_rail()/2-carriage_length(rail_carriage(z_rail_type()))/2-5;
function z_rail_carriage_zero()=z_rail_up();
function z_left_rail_tr()=[[
	 z_slot_leftback_tr()[0].x
	,z_slot_leftback_tr()[0].y-10
	,backheatbed_slot_tr()[0].z+z_rail_up()
	],[0,-90,90]];
function z_right_rail_tr()=[[
	 z_slot_rightback_tr()[0].x
	,z_slot_rightback_tr()[0].y-10
	,backheatbed_slot_tr()[0].z+z_rail_up()
	],[0,-90,90]];

function z_carriage_dim()=[abs(z_slot_leftback_tr()[0].x-leftheatbed_slot_tr()[0].x)+20-0.01
	,45
	,carriage_length(rail_carriage(z_rail_type()))-0.02
	];
function z_carriage_left_tr(zposition)=[[
	 z_slot_leftback_tr()[0].x-10
	,z_slot_leftback_tr()[0].y-10-z_carriage_dim().y
	,leftheatbed_slot_tr()[0].z-z_carriage_dim().z/2
],[0,0,0]];
function z_carriage_right_tr(zposition)=[[
	 z_slot_rightback_tr()[0].x+10
	,z_slot_rightback_tr()[0].y-10-z_carriage_dim().y
	,rightheatbed_slot_tr()[0].z-z_carriage_dim().z/2
],[0,0,0]];

function y_endstop_tr()=[[y_slot_right_tr()[0].x
						,rightfront_motorblock_tr()[0].y
						,y_slot_right_tr()[0].z+20+4]
						,[0,-90,180]];
function y_SS443A_cut()=[[30,10,40],[-26,0,-20]];
function y_magnet_d()=2;
function y_magnet_h()=2;

function x_endstop_block_dim()=[20,20,8];
function x_endstop_block_tr()=[[rightfront_motorblock_tr()[0].x-rightfront_motorblock_dim().x-x_endstop_block_dim().x-5
						,z_slot_topfront_tr()[0].y-10
						,z_slot_topfront_tr()[0].z+10]
						,[0,0,0]];
						
function x_endstop_tr()=[vec_add(x_endstop_block_tr()[0],[11,20,4])
						,[0,90,180]];
function x_SS443A_cut()=[[30,10,40],[-26,0,-20]];
function x_magnet_d()=2;
function x_magnet_h()=2;

function z_endstop_screw()=8;
function z_endstop_block_dim()=[35,13,10];
function z_endstop_block_tr()=[[z_slot_rightback_tr()[0].x-10
						,z_slot_rightback_tr()[0].y-z_endstop_block_dim().x+10
						,z_slot_topback_tr()[0].z-z_endstop_block_dim().z-21
						],[-90,0,90]];
function z_endstop_tr()=[vec_add(z_endstop_block_tr()[0],[-z_endstop_block_dim().z/2,11,-z_endstop_block_dim().y])
						,[90,0,0]];
function z_SS443A_cut()=[[30,10,40],[-26,0,-9]];
function z_magnet_d()=2;
function z_magnet_h()=2;
function z_endstop_magnet_tr()=[[z_endstop_tr()[0].x
			,z_endstop_tr()[0].y
			,z_carriage_right_tr(0)[0].z+z_carriage_dim().z+0.01
			],[180,0,0]];

function enclosure_holes_offset()=6;
function enclosure_holes_count()=[24+10,24+10];
function enclosure_holes_interval()=[
		 (enclosure_dim().x-enclosure_holes_offset()*2)/(enclosure_holes_count().x-1)
		,(enclosure_dim().y-enclosure_holes_offset()*2)/(enclosure_holes_count().y-1)
	];

function enclosure_offsets()=[0.2,0.2,2.5];
function enclosure_dim()=[front_back_slot()-enclosure_offsets().x*2,y_slot()-enclosure_offsets().y*2,3];
function enclosure_tr()=[[
	 z_slot_leftfront_tr()[0].x+enclosure_offsets().x+10
	,z_slot_rightfront_tr()[0].y+enclosure_offsets().y+10
	,y_slot_bottomleft_tr()[0].z+enclosure_offsets().z-10
],[0,0,0]];

function feeder_up()=80;
function feeder_stand_tr()=[vec_add(z_slot_topfront_tr()[0],[0,0,10]),[0,0,0]];
function feeder_center_point_tr() = [[e3d_tr(0)[0].x
									 ,e3d_tr(0)[0].y
									 ,feeder_stand_tr()[0].z+feeder_up()]
									 ,[0,90,0]];
function feeder_thickness()=6;
function feeder_base_thickness()=6;
function feeder_border_cut()=10; 
function feeder_stand_width()=50;
function feeder_nema_plate_thickness()=2;

function xt90_dim()=[60,17.65,17.4];
function xt90_tr()=[vec_add(y_slot_bottomright_tr()[0],[-10,y_slot()/2-xt90_dim().x/2-40,10]),[0,0,-90]];

function wago_tr()=[vec_add(enclosure_tr()[0],[41.5,19.5,enclosure_dim().z]),[0,0,0]];
