use <../_utils_v2/deb.scad>
use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <ss443a.scad>
use <configuration.scad>

include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/pulleys.scad>

function vec_add (v1,v2)=[v1.x+v2.x,v1.y+v2.y,v1.z+v2.z];
function vec_sub (v1,v2)=[v1.x-v2.x,v1.y-v2.y,v1.z-v2.z];
function vec_replace (v,index,value)=[for (i=[0:2]) index==i?value:v[i]];
function tr_add (vc,v2)=[vec_add (vc[0],v2),vc[1]];
function tr_sub (vc,v2)=[vec_sub (vc[0],v2),vc[1]];
function tr_replace (vc,index,value)=[vec_replace(vc[0],index,value),vc[1]];
module translate_rotate(tr) 
{
	for (i=[0:$children-1]) 
		translate (tr[0])
		rotate(tr[1])
			children(i);
}

module report_wago()
{
	deb(str("WAGO 222-415, 5 pins"));
}

module report_xt90()
{
	deb(str("XT90 jack"));
}

module report_hotend()
{
	deb(str("E3D v6 hotend"));
}

module report_fan()
{
	deb(str("4010 fan"));
}

module report_blower()
{
	deb(str("4010 blower fan"));
}

module report_heatbed(dim)
{
	deb(str("Heated bed ",dim.x,"x",dim.y,"mm"));
	for (i=[0:3])
	{
		report_m3_hexnut();
		deb(str("bed spring (10-20mm)"));
	}
	deb(str("M3x",35," DIN965"));
}

module report_corner_bracket()
{
	deb("2020 slot corner bracket");
	for (i=[0:1])
	{
		deb(str("M5x8 DIN967"));
		deb(str("M5 t-slot nut"));
	}
}
module report_slot(h)
{
	deb(str("2020 t-slot: ",h,"mm"));
}

module report_rail(carriage,h)
{
	deb(str("MGN9 rail with MGN9",carriage," carriage: ",h,"mm"));
	for (i=[0:7])
	{
		deb(str("M3 t-slot nut"));
		report_m3(8);
	}
}

module report_magnet(d,h)
{
	deb(str("Magnet: diameter=",d,"mm, length=",h,"mm"));
}

module report_m5_hexnut()
{
	deb(str("M5 nut (hex)"));
}

module report_m5_screw(screw)
{
	deb(str("M5x",screw," DIN912"));
	deb(str("M5 washer"));
}

module report_m5_point()
{
	report_m5_screw(10);
	deb(str("M5 t-slot nut"));
}

module report_m3_hexnut()
{
	deb(str("M3 nut (hex)"));
}

module report_m3_squarenut()
{
	deb(str("M3 nut (thin square)"));
}

module report_m3(screw)
{
	deb(str("M3x",screw," DIN912"));
}

module report_m6(screw)
{
	deb(str("M6x",screw," DIN912"));
}

module report_m3_washer(screw)
{
	report_m3(screw);
	deb(str("M3 washer"));
}

module report_m6_washer(screw)
{
	report_m6(screw);
	deb(str("M6 washer"));
}

module report_m3_washer_hexnut(screw)
{
	report_m3_washer(screw);
	report_m3_hexnut();
}

module report_m3_washer_squarenut(screw)
{
	report_m3_washer(screw);
	report_m3_squarenut();
}

module report_m2p5_screw(screw)
{
	deb(str("M2.5x",screw));
}

module report_m2p5_screw_din(screw,din)
{
	deb(str("M2.5x",screw," ",din));
}
module report_m2p5_hexnut(screw)
{
	deb(str("M2.5 nut (hex)"));
}


module report_pulley(screw)
{
	deb(str("GT2 pulley 16 teeth"));
	deb(str("DIN912 M3x",screw));
	deb(str("M3 washer"));
	report_m3_hexnut();
}

module report_SS443a()
{
	deb(str("SS443A Hall-effect sensor"));
}

module endstop_block(tr,etr,bdim,m3_screw_height,ss443_out,report=false)
{
	union()
	{
		difference()
		{
			translate_rotate (tr)
			{
				intersection()
				{
					linear_extrude (bdim.z)
						polygon(polyRound([
							 [0,0,0.4]
							,[bdim.x,0,0.4]
							,[bdim.x,bdim.y,0.4]
							,[0,bdim.y,0.4]
						],1));
					rotate ([90,0,90])
					linear_extrude (bdim.x)
						polygon(polyRound([
							 [0,0,0]
							,[bdim.y,0,0]
							,[bdim.y,bdim.z,0.4]
							,[0,bdim.z,0.4]
						],1));
					
					translate ([0,bdim.y,0])
					rotate ([90,0,0])
					linear_extrude (bdim.y)
						polygon(polyRound([
							 [0,0,0]
							,[bdim.x,0,0]
							,[bdim.x,bdim.z,0.4]
							,[0,bdim.z,0.4]
						],1));
				}
			}
			
			if (report) report_SS443a();
			translate_rotate (etr)
				SS443A(SS443A_out=ss443_out,SS443A_yout=10);
			
			if (report) report_m3_washer_squarenut(m3_screw_height);
			translate_rotate (tr)
			translate ([4,bdim.y-m3_cap_h()-1,bdim.z/2])
			rotate ([90,0,0])
			{
				m3_screw(h=m3_screw_height,cap_out=20);
				translate ([0,0,m3_screw_height-4])
					m3_square_nut();
			}
		}
		translate_rotate (tr)
		translate ([4,bdim.y-m3_cap_h()-1,bdim.z/2])
		rotate ([90,0,0])
		{
			cylinder (d=m3_cap_diameter()+0.2,h=0.4,$fn=16);
		}
	}
}

module magnet_cut(magnet_d,magnet_h,getter=0)
{
	offs=[0.1,0.2];
	cc=[0.2,0.1];
	cylinder(d=magnet_d-cc[1]*2+offs.x*2,h=magnet_h+offs.y,$fn=40);
	cylinder(d1=magnet_d+offs.x*2,d2=0.1,h=magnet_h+offs.y,$fn=40);
	cylinder (d=magnet_d-0.3*2,h=magnet_h+getter,$fn=40);
	rays=20;
	for (a=[0:360/rays:360])
		rotate ([0,0,a])
		translate ([-cc.x/2,0,0])
			cube ([cc.x,magnet_d/2+offs.x,magnet_h+offs.y]);
}

module nema17_cut(add=false
				,shaft=true
				,fix=true
				,main_cyl=false
				,main_cyl_length=24
				,main=true
				,washers=false
				,washers_sphere=false
				,bighole=false
				,shaft_offset=0
				,shaft_length=40
				,screw_length=8
				,hull_body=[[0,0,0]]
				,nema17_cut=true
				,report=false
				,report_pulley=true
	)
{
	nema17_dim=42.3+0.2;
	screw=screw_length-4;
	if (add)
	{
		for (x=[-1:2:1])
			for (y=[-1:2:1])
				translate ([31/2*x,31/2*y,-0.01+screw-0.4])
				{
					cylinder (d=m3_washer_diameter(),h=0.4,$fn=20);
				}
	}
	else
	{
		if (report)
		{
			deb(str("Nema 17 motor"));
			if (report_pulley)
				deb(str("GT2 motor pulley 16 teeth"));
		}

		if (main)
		{
			cut=nema17_cut?3:0;
			
			for (h=hull_body)
			hull()
			translate(h)
			rotate ([0,180,0])
			linear_extrude(80)
				polygon(polyRound([
					 [-nema17_dim/2,-nema17_dim/2,cut]
					,[-nema17_dim/2,nema17_dim/2,cut]
					,[nema17_dim/2,nema17_dim/2,cut]
					,[nema17_dim/2,-nema17_dim/2,cut]
				],1));
			translate ([0,0,-0.1])
				cylinder (d=22+0.6,h=2.2,$fn=60);
		}
		
		if (main_cyl)
			translate ([0,0,-0.1])
				cylinder (d=24,h=main_cyl_length,$fn=60);
		
		difference()
		{
			cylinder (d=(bighole?5.4:5.2)+shaft_offset*2,h=shaft_length,$fn=60);
			if (shaft)
				translate ([-10,2.1,10])
					cube ([20,20,60]);
		}
		
		if (fix)
			for (x=[-1:2:1])
				for (y=[-1:2:1])
					translate ([31/2*x,31/2*y,-0.01])
					{
						if (report)	report_m3_washer(screw_length);
						cylinder (d=m3_screw_diameter(),h=screw,$fn=20);
						translate ([0,0,screw-0.01])
						{
							hh=10;
							cylinder (d=washers?m3_washer_diameter():m3_cap_diameter(),h=hh,$fn=40);
							if (washers_sphere)
								translate ([0,0,hh])
									sphere (d=washers?m3_washer_diameter():m3_cap_diameter(),$fn=40);
						}
					}
	}
}

module slot_cut(height,grooves=[0,1,2,3])
{
	offs=0.2;
	difference()
	{
		linear_extrude(height)
		polygon (polyRound([
			 [-10-offs,-10-offs,0.4]
			,[-10-offs,10+offs,0.4]
			,[10+offs,10+offs,0.4]
			,[10+offs,-10-offs,0.4]
		],20));
		
		/*
		dim=[6,0.4];
		for (a=grooves)
			rotate ([0,0,90*a])
			translate ([0,10,height/2])
				cube ([dim[0]-offs*2,dim[1]*2,height],true);
		*/
	}
}

module slot_groove(height,smooth=false,big=false,enabled=false)
{
	offs=0.2;
	dimc=big?[6.2,1]:[6.2,0.4];
	dim=[dimc[0]-offs*2,dimc[1]*2,height];
	if (enabled)
	translate ([-dim.x/2,-dim.y/2,0])
	{
		cut=smooth?0.3:0;
		//cube (dim);
		linear_extrude(dim.z)
			polygon(polyRound([
				 [0,0,cut]
				,[dim.x,0,cut]
				,[dim.x,dim.y,cut]
				,[0,dim.y,cut]
			],20));
	}
}

module pulley_cut(pulley_type,op=0,angle,screw,up,nut_type="hex",out=[0,0],report=false)
{
	offs=[1,1];
	dd=pulley_flange_dia(pulley_type)+offs[0]*2;
	hh=pulley_height(pulley_type)+offs[1]*2;
	if (op==0)
	{
		if (report) report_pulley(screw);
		rotate ([0,0,angle])
		{
			hull()
			{
				cylinder(d=dd
						,h=hh
						,center=true
						,$fn=60);
				
				rotate ([0,0,out[0]])
				translate ([out[1],0,0])
				cylinder(d=dd
						,h=hh
						,center=true
						,$fn=60);
			}
			diff=pulley_flange_dia(pulley_type)-pulley_od(pulley_type)+1;
			translate ([-dd/2,0,-hh/2])
				cube ([diff,100,hh]);
			translate ([0,-dd/2,-hh/2])
				cube ([100,diff,hh]);
		}
		pulley_cut(pulley_type=pulley_type,op=2,angle=angle,screw=screw,up=up,out=out,nut_type=nut_type);
	}
	if (op==1)
	{
		dd=3+1;
		difference()
		{
			union()
			{
				translate([0,0,hh/2-offs[1]])
					cylinder(d1=dd,d2=dd+offs[1],h=offs[1],$fn=40);
				translate([0,0,-hh/2])
					cylinder(d2=dd,d1=dd+offs[1],h=offs[1],$fn=40);
			}
			pulley_cut(pulley_type=pulley_type,op=2,angle=angle,screw=screw,up=up,nut_type=nut_type,out=out);
		}
	}
	if (op==2)
	{
		translate ([0,0,up])
		rotate ([180,0,0])
		{
			if (nut_type=="hex")
			{
				translate ([0,0,2])
					m3_screw(h=screw,cap_out=60);
				translate ([0,0,screw-2.6])
				{
					m3_nut_inner();
					translate ([0,0,m3_nut_h()-0.01])
						m3_nut(20);
				}
			}
			else
			if (nut_type=="square")
			{
				m3_screw(h=screw,cap_out=60);
				translate ([0,0,screw-2.6])
					m3_square_nut();
			}
		}
	}
}

//slot_groove(height=100,smooth=false);