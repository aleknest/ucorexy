use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

include <../_utils_v2/NopSCADlib/core.scad>

knob_height=6;

module hotbed_support(zposition,tr,xpos,ypos,double=true)
{
	main_cyl_d=16;
	width=40;
	thickness=5;
	slot_tr=tr;
	upcut=4;
	fixscrew_offset=13.4;
	dd=double?width:width/2+main_cyl_d/2;
	translate ([0,0,zposition])
	{
		tr_detail=[slot_tr[0].x-10*xpos-thickness*((xpos+1)/2)
				,bed_plate_tr()[0].y+(bed_dim().x/2-bed_screws_offset().y)*ypos
				,slot_tr[0].z-10];
		cyl_tr=[bed_plate_tr()[0].x,bed_plate_tr()[0].y,slot_tr[0].z+10];

		difference()
		{		
			union()
			{
				fillet(r=2,steps=8)
				{
					hull()
					{
						translate (cyl_tr)
						translate ([(bed_dim().x/2-bed_screws_offset().x)*xpos
									,(bed_dim().x/2-bed_screws_offset().y)*ypos
									,-upcut])
						rotate ([180,0,0])
							cylinder (d=main_cyl_d,h=20-upcut,$fn=80);
						
						translate ([0,-main_cyl_d/2,0])
						translate (tr_detail)
						{
							dim=[thickness,main_cyl_d,20-upcut];
							cube (dim);
						}
					}
					
					translate ([0,width-dd,0])
					translate ([0,-width/2,0])
					translate (tr_detail)
					intersection()
					{
						dim=[thickness,dd,20];
						//#cube (dim);
						
						rotate ([90,0,90])
						linear_extrude(dim.x)
						polygon(polyRound([
							 [0,0,4]
							,[dim.y,0,4]
							,[dim.y,dim.z,4]
							,[0,dim.z,4]
						],1));
						
						translate ([0,dim.y,0])
						rotate ([90,0,0])
						linear_extrude(dim.y)
						polygon(polyRound([
							 [0,0,0]
							,[dim.x,0,0]
							,[dim.x,dim.z,3]
							,[0,dim.z,0]
						],1));
					}
				}
				xx=xpos==1?thickness:0;
				translate (tr_detail)
				translate ([xx,width/2,10])
				rotate ([90,90,0])
					slot_groove(height=dd,big=true,smooth=true,enabled=true);
			}
			
			translate_rotate (bed_plate_tr())
			translate ([(bed_dim().x/2-bed_screws_offset().x)*xpos
						,(bed_dim().y/2-bed_screws_offset().y)*ypos,0.01])
			rotate ([180,0,0])
			{
				cylinder (d=10,h=12,$fn=30);
				cylinder (d=4.0,h=40,$fn=30);
			}
			
			xx=xpos<0?thickness:0;
			yy=double?[-1,1]:[1];
			for (y=yy)
			{
				report_m5_point();
				translate ([xx,fixscrew_offset*y,10])
				translate (tr_detail)
				rotate ([0,90*xpos,0])
					m5n_screw_washer(thickness=thickness,diff=2,washer_out=40,tnut=true);
			}
		}
	}
}

module left_front_hotbed_support(zposition)
{
	hotbed_support(zposition,leftheatbed_slot_tr(),-1,-1,double=false);
}
module right_front_hotbed_support(zposition)
{
	hotbed_support(zposition,rightheatbed_slot_tr(),1,-1,double=false);
}
module left_back_hotbed_support(zposition)
{
	hotbed_support(zposition,leftheatbed_slot_tr(),-1,1);
}
module right_back_hotbed_support(zposition)
{
	hotbed_support(zposition,rightheatbed_slot_tr(),1,1);
}

module hotbed_knob()
{
	h=knob_height;
	rays=10;
	angle=360/rays;
	out=12-3;
	knob_d=5-1;
	color ("silver")
	difference()
	{
		union()
		{
			translate ([0,0,-h])
			{
				for (a=[0:rays-1])
				fillet (r=1,steps=4)
				{
					rotate ([0,0,a*angle])
					translate ([out,0,0])
						cylinder (d=knob_d,h=h,$fn=60);
					cylinder (d=out*2,h=h,$fn=60);
				}
			}
		}
		
		translate ([0,0,-1])
		rotate ([0,180,0])
		{
			report_m3_hexnut();
			translate ([0,0,-20+0.01])
				m3_nut(h=20);
			m3_nut_inner(diff=0.2);
			cylinder (d=3.6,h=20,$fn=20);
		}
	}
}

module hotbed_knobs(zposition)
{
	tr=[bed_plate_tr()[0].x,bed_plate_tr()[0].y,leftheatbed_slot_tr()[0].z-10+zposition];
	translate (tr)
	{
		for (x=[-1,1])
		for (y=[-1,1])
			translate ([(bed_dim().x/2-bed_screws_offset().x)*x
						,(bed_dim().y/2-bed_screws_offset().y)*y,-knob_height])
		rotate ([180,0,0])
			hotbed_knob();
	}
}

module spring_spacer(height)
{
	difference()
	{
		union()
		{
			dd=9;
			spring_table=[2,2];
			cylinder (d=dd,h=height,$fn=50);
			cylinder (d=dd+spring_table[0],h=spring_table[1],$fn=50);
			translate ([0,0,spring_table[1]])
				cylinder (d1=dd+spring_table[0],d2=dd,h=spring_table[0]/2,$fn=50);
		}
		translate ([0,0,-1])
			cylinder (d=3.5,h=height+2,$fn=50);
	}
}

z=0;

//proto_heatbed_slots(z);
//proto_slot_brackets();

//proto_heatbed(z);
left_front_hotbed_support(z);
//right_front_hotbed_support(z);
//left_back_hotbed_support(z);
/*
right_back_hotbed_support(z);
hotbed_knobs(z);
*/

//spring_spacer(height=12+10);
//hotbed_knob();