use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/rails.scad>
include <../_utils_v2/NopSCADlib/vitamins/pulleys.scad>

module back_block(part)
{
	tr=part=="left"?leftback_block_tr():rightback_block_tr();
	pulleys=part=="left"?
	[
		 [left_top_backpulley(),270,25,15,[180,30]]
		,[left_bottom_backpulley(),270,25,8,[90,30]]
	]:[
		 [right_bottom_backpulley(),180,25,8,[-90,30]]
		,[right_top_backpulley(),180,25,15,[0,30]]
	];
	screw_offs=8;
	screw_add=16;
	fixes=part=="left"?[
		 [[y_slot_left_tr()[0].x,z_slot_topback_tr()[0].y,y_slot_left_tr()[0].z+10+4],12+40,0,180,false]
		,[[y_slot_left_tr()[0].x+back_block_dim().x-10+screw_offs,z_slot_topback_tr()[0].y,y_slot_left_tr()[0].z+10+4],40,0,180,true]
	]:[
		 [[y_slot_right_tr()[0].x,z_slot_topback_tr()[0].y,y_slot_right_tr()[0].z+10+4],12+40,0,0,false]
		,[[y_slot_right_tr()[0].x-back_block_dim().x+10-screw_offs,z_slot_topback_tr()[0].y,y_slot_right_tr()[0].z+10+4],40,0,0,true]
	];
	union()
	{
		difference()
		{
			translate_rotate(tr)
			union()
			{
				fillet(r=6,steps=8)
				{
					dim=back_block_dim();
					//#cube (dim);
					translate ([0,dim.y,0])
					rotate ([90,0,0])
					linear_extrude(dim.y)
						polygon(polyRound([
							 [0,0,0]
							,[dim.x,0,0]
							,[dim.x,dim.z,0]
							,[0,dim.z,12]
						],1));
					cube ([back_block_dim().x+screw_add,back_block_dim().y,8]);
				}
				translate ([20.2,10,0])
				rotate ([90,0,90])
					slot_groove(height=back_block_dim().x+screw_add-20.2,enabled=true,big=true);
			}
			
			for (p=pulleys)		
				translate_rotate(p[0])
					pulley_cut(pulley_type=y_pulley_type()
							,op=0
							,angle=p[1]
							,screw=p[2]
							,up=p[3]
							,nut_type="square"
							,out=p[4]
							,report=true);
			
			for (f=fixes)
			{
				translate(f[0])
				rotate ([180,0,f[3]])		
				{
					if (f[4])
					{
						report_m5_point();
						m5n_screw_washer(thickness=4,diff=2, washer_out=f[1],washer_side_out=f[2],washer_side_out_add=10,tnut=true);
					}
					else
					{
						report_m6_washer(16);
						m6n_screw_washer(thickness=4,diff=2, washer_out=f[1],washer_side_out=f[2],washer_side_out_add=10);
					}
				}
			}
		}
		for (p=pulleys)		
			translate_rotate(p[0])
				pulley_cut(pulley_type=y_pulley_type(),op=1,angle=p[1],screw=p[2],up=p[3]);
	}
}
module leftback_block()
{
	back_block(part="left");
}
module rightback_block()
{
	back_block(part="right");
}

/*
proto_back_left();
proto_y_left(yposition=0);
proto_back_slots();
proto_xybelts();
*/
//proto_other_slots();
rightback_block();
//leftback_block();

//use <ycarriage.scad>
//yposition=-55-1;
//proto_y_right(yposition=yposition);
//translate ([0,yposition,0])
//	y_carriage_right();
