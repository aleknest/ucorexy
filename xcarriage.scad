use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <ss443a.scad>
use <configuration.scad>

include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/rails.scad>
include <../_utils_v2/NopSCADlib/vitamins/blower.scad>
include <../_utils_v2/NopSCADlib/vitamins/blowers.scad>

e3d_v6_fan_screw=16;
e3d_v6_fan_border=5;
e3d_v6_cut_offset=0.2;
e3d_v6_cylinder_thickness=1.2;
e3d_v6_dim=[
	 [22.3,26]
	,[16,42.7-3.7-6-26]
	,[12,6]
	,[16,3.7]
	,[12,16]
];
e3d_v6_up=-39;
function e3d_v6_seq_(i) = i==0?e3d_v6_dim[i].y:e3d_v6_dim[i].y+e3d_v6_seq_(i-1);
function e3d_v6_seq(i) = i==0?0:e3d_v6_seq_(i-1);

blower_outer_fix_diameter=4.4;

x_cube_cut=[26.4,22];

module belt (l,smooth=false,width_add=[0,0])
{
	belt_h=0.83;
	belt_h_m=belt_h+0.3;
	belt_width=7+width_add[0]+width_add[1];

	translate ([-belt_h_m,-belt_width/2-width_add[0]/2+width_add[1]/2,0])	
	{
		cube ([belt_h_m,belt_width,l]);
		if (smooth)
		{
			hull()
			for (z=[0,l])
				translate ([0,0,z])
				rotate ([-90,0,0])
					cylinder (d=1.1,h=belt_width,$fn=6);
		}
		else
		for (z=[0:2:l])
			translate ([0,0,z])
			rotate ([-90,0,0])
				cylinder (d=1.1,h=belt_width,$fn=6);
	}
}

module e3d_v6_cut(maxc=len(e3d_v6_dim)-1,out=0)
{
	dim=e3d_v6_dim[0];
	translate ([0,0,e3d_v6_up-e3d_v6_cut_offset-10])
	translate_rotate (e3d_tr(0))
		cylinder(d=dim.x+e3d_v6_cut_offset*2,h=dim.y+e3d_v6_cut_offset*2,$fn=80);
	for (i=[0:maxc])
	{
		dim=e3d_v6_dim[i];
		translate ([0,0,e3d_v6_seq(i)+e3d_v6_up-e3d_v6_cut_offset])
		translate_rotate (e3d_tr(0))
		hull()
		{
			cylinder(d=dim.x+e3d_v6_cut_offset*2,h=dim.y+e3d_v6_cut_offset*2,$fn=80);
			translate ([0,-out,0])
				cylinder(d=dim.x+e3d_v6_cut_offset*2,h=dim.y+e3d_v6_cut_offset*2,$fn=80);
		}
	}
}

e3d_fan_gr=11;
e3d_fan_gr_in=0.35;

module e3d_v6_fan_cut(screws=true)
{
	dim=e3d_v6_dim[0];
	dd=dim.x+e3d_v6_cut_offset*2;
	
	sequental_hull()
	{
		translate_rotate (e3d_fan_tr(0))
		translate ([0,0,-5.5+0.1])
			cylinder (d=38,h=0.1,$fn=80);
			
		translate ([0,e3d_fan_gr,e3d_v6_up+e3d_v6_cylinder_thickness])
		translate_rotate (e3d_tr(0))
		translate ([-dd/2,dd/2-0.1,0])
			cube ([dd,0.1,dim.y-e3d_v6_cylinder_thickness]);		
		
		translate ([0,0,e3d_v6_up+e3d_v6_cylinder_thickness])
		translate_rotate (e3d_tr(0))
		translate ([-dd/2,-dd/2-1,0])
			cube ([dd,0.1,dim.y-e3d_v6_cylinder_thickness]);
	}
	
	if (screws)
		for (x=[-32/2,32/2])
		for (y=[-32/2,32/2])
			translate_rotate (e3d_fan_tr(0))
			translate ([x,y,5])
			rotate ([180,0,0])
			{
				report_m3_washer_hexnut(e3d_v6_fan_screw);
				
				cylinder (d=2.9,h=e3d_v6_fan_screw+0.5,$fn=40);
				m3_screw(h=e3d_v6_fan_screw+0.1);
				
				a=y>0?90:-90;
				translate ([0,0,e3d_v6_fan_screw-4])
				rotate ([0,0,a])
				hull()
				{
					m3_nut();
					translate ([-10,0,0])
						m3_nut();
				}
			}
}

module e3d_v6_fan_face()
{
	w=fan_width(e3d_fan_type());
	linear_extrude(0.1)
	polygon(polyRound([
		 [-w/2,-20,3]
		,[-w/2,20,3]
		,[w/2,20,3]
		,[w/2,-20,3]
	],20));
}

module e3d_v6_fan_air_hull()
{
	dim=e3d_v6_dim[0];
	dd=dim.x+e3d_v6_cut_offset*2;
	ddw=xcarriage_dim().x;
	fillet(r=4,steps=16)
	{
		sequental_hull()
		{	
			translate_rotate (e3d_fan_tr(0))
			translate ([0,0,-5.5])
				e3d_v6_fan_face();
			
			translate_rotate (e3d_fan_tr(0))
			translate ([0,0,-5.5-e3d_v6_fan_border])
				e3d_v6_fan_face();
					
			translate ([0,e3d_fan_gr,0])
			translate ([0,0,e3d_v6_up])
			translate_rotate (e3d_tr(0))
			translate ([-ddw/2,dd/2-0.1,0])
				cube ([ddw,0.1,dim.y+e3d_v6_cylinder_thickness]);
		}
		
		translate ([0,-e3d_fan_gr_in,e3d_v6_up])
		translate_rotate (e3d_tr(0))
		translate ([-ddw/2,-dd/2,0])
		intersection()
		{
			dim=[ddw,dd+e3d_fan_gr+e3d_fan_gr_in,dim.y+e3d_v6_cylinder_thickness];
			//#cube (dim);
			translate ([0,dim.y,0])
			rotate ([90,0,0])
				linear_extrude(dim.y)
				polygon(polyRound([
					 [0,0,1]
					,[dim.x,0,1]
					,[dim.x,dim.z,1]
					,[0,dim.z,1]
				],20));
			
			translate ([0,0,dim.z])
			rotate ([0,90,0])
				linear_extrude(dim.x)
				polygon(polyRound([
					 [0,0,0]
					,[dim.z,0,blower_outer_fix_diameter]
					,[dim.z,dim.y,0]
					,[0,dim.y,0]
				],20));
		}
	}
}

module e3d_v6_fan_air()
{
	e3d_v6_fan_air_hull();
	translate_rotate (e3d_fan_tr(0))
	for (x=[-32/2,32/2])
	for (y=[-32/2,32/2])
	translate ([x,y,-(e3d_v6_fan_screw-10)])
	rotate ([180,0,0])
	{
		dd=5;
		cylinder (d=dd,h=e3d_v6_fan_border,$fn=40);
		translate ([0,0,e3d_v6_fan_border])
			sphere (d=dd,$fn=40);
	}
}

module xcarriage_rail_cut()
{
	translate_rotate (x_rail_tr())
	{
		offs=0.4;
		translate ([-x_rail()/2,-x_rail_type()[1]/2-offs,0])
			cube ([x_rail(),x_rail_type()[1]+offs*2,x_rail_type()[2]+offs]);
	}
}

module x_cube(dim)
{
	fan_fix=[2.5,1,1];
	fan_fix_up=2;
	
	translate ([dim.x,0,0])
	rotate ([0,-90,0])
	linear_extrude(dim.x)
		polygon (polyRound([
			 [0,0,1]
			,[x_cube_cut[0],0,2]//
			,[x_cube_cut[0],x_cube_cut[1],3.5]
			,[dim.z,x_cube_cut[1],6]
			,[dim.z,dim.y,2]
			,[fan_fix_up,dim.y,1]
			,[fan_fix_up,dim.y+fan_fix[1],0]
			,[-fan_fix[0],dim.y+fan_fix[1],0]
			,[-fan_fix[0],dim.y-fan_fix[2],0]
			,[0,dim.y-fan_fix[2],0]
		],1));
}
//translate_rotate (xcarriage_tr()) x_cube([28, 60, 51.7]);

module x_carriage_belt_fixer(op=0,report=false)
{
	offs=op==0?0:0.2;
	out=[10,3,3.4+1];
	out2=[4,11.4];
	dim=[out.x+offs*2
		,out.y*2+offs*2
		,abs(left_bottom_backpulley()[0].z-left_top_backpulley()[0].z)+out.z*2+offs*2
	];
	tr=[-xcarriage_dim().x/2-offs
		,-dim.y/2
		,left_top_backpulley()[0].z-out.z-offs];
	dim2=[out2.x+offs*2
		,out2.y*2+offs*2
		,4+offs*2
	];
	tr2=[-xcarriage_dim().x/2-offs
		,-dim2.y/2
		,tr.z+dim.z/2-dim2.z/2];
	if ((op==0)||(op==1))
	{
		difference()
		{
			union()
			fillet(r=2,steps=8)
			{
				//#translate (tr) cube(dim);
				translate (tr)
				intersection()
				{
					translate([0,dim.y,0])
					rotate([90,0,0])
					linear_extrude(dim.y)
					polygon(polyRound([
						 [0,0,0]
						,[dim.x,0,1]
						,[dim.x,dim.z,1]
						,[0,dim.z,0]
					],20));
					linear_extrude(dim.z)
					polygon(polyRound([
						 [0,0,0]
						,[dim.x,0,1]
						,[dim.x,dim.y,1]
						,[0,dim.y,0]
					],20));
				}
				hull()
				{
					translate (tr2)
						cube(dim2);
					translate (tr)
						cube([dim2.x,dim.y,dim.z]);
				}
			}
			if (op==0)
			{
				x_carriage_belt_fixer(op=2);
				
				trb=[-xcarriage_dim().x/2-offs,0,left_top_backpulley()[0].z];
				translate (trb)
				translate ([-0.01,-0.5,0])
				rotate ([-90,0,-90])
					belt(l=10,width_add=[0,10]);
				trt=[-xcarriage_dim().x/2-offs,0,left_bottom_backpulley()[0].z];
				translate (trt)
				translate ([-0.01,-0.5,0])
				rotate ([-90,0,-90])
					belt(l=10,width_add=[10,0]);
			}
		}
	}
	if (op==2)
	{
		translate (tr2)
		{
			screw=12;
			offs=7;
			for (y=[-1,1])
				translate ([0,dim2.y/2+offs*y,dim2.z/2])
				rotate ([0,90,0])
				{
					report_m3_washer_squarenut(screw);
					m3_screw(h=screw);
					m3_washer();
					translate ([0,0,screw-5])
					rotate ([0,0,90])
						m3_square_nut();
				}
		}
	}
}

module x_carriage_belt_fixer_left()
{
	x_carriage_belt_fixer(report=true);
}

module x_carriage_belt_fixer_right(report=true)
{
	mirror([1,0,0])
		x_carriage_belt_fixer();
}

module x_carriage(part="front",report=false)
{
	screw1=16;
	screw2=[16,8];
	iz1=len(e3d_v6_dim)-3;
	z1=e3d_v6_seq(iz1)+e3d_v6_up+e3d_v6_dim[iz1].y/2-1;
	screw_y=-6;
	mtr=[[xcarriage_tr()[0].x+xcarriage_dim().x/2-2
		,xcarriage_tr()[0].y-x_magnet_out()
		,x_endstop_tr()[0].z]
		,[-90,0,0]];
	
	difference()
	{
		union()
		{
			fillet(r=0.6,steps=16)
			{
				translate_rotate (xcarriage_tr())
					x_cube(xcarriage_dim());
			
				translate_rotate(mtr)
					cylinder(d=x_magnet_d()+4,h=10);
			}
		
			for (x=[-1,1])
				translate ([10.5*x,screw_y,z1])
				translate_rotate (e3d_tr(0))
				rotate ([90,0,0])
				{
					dd=m3_washer_diameter()+1.2*2;
					translate ([0,0,-1.5])
					{
						cylinder (d=dd,h=xcarriage_thickness()[0]+screw_y-22.5,$fn=60);
						sphere (d=dd,$fn=60);
					}
				}
		}
		
		dd=9;
		sdim=[2,3];
		wire_fix_corr=[6];
		coord=[
			 [0,6,x_cube_cut[0]-sdim.y-6]
			,[xcarriage_dim().x,6,x_cube_cut[0]-sdim.y-6]
			//,[6,x_cube_cut[1],xcarriage_dim().z-19]
			//,[6,x_cube_cut[1],xcarriage_dim().z-11]
			,[xcarriage_dim().x-6,x_cube_cut[1],xcarriage_dim().z-19]
			,[xcarriage_dim().x-6,x_cube_cut[1],xcarriage_dim().z-11]
		];
		
		translate_rotate (xcarriage_tr())
		for (i=[0:len(coord)-1])
		{
			translate (coord[i])
			difference()
			{
				cylinder (d=dd,h=sdim.y,$fn=80);
				translate ([0,0,-0.1])
					cylinder (d=dd-sdim.x*2,h=sdim.y+0.2,$fn=80);
			}
		}
			
		e3d_v6_cut();
		xcarriage_rail_cut();
		
		add=1.4;
		translate_rotate (x_slot_tr())
		{
			translate ([0,add/2,0])
				cube ([20.6,20.6+add,200],true);
		}
		translate_rotate (x_rail_tr())
		{
			dim=[carriage_length(rail_carriage(x_rail_type()))+0.4
				,carriage_width(rail_carriage(x_rail_type()))+0.4
				,carriage_height(rail_carriage(x_rail_type()))+0.2];
			translate ([-dim.x/2,-dim.y/2,0])
				cube(dim);
			if (part=="main")
			{
				screw=6;
				screw_in=3;
				for (x=[-1,1])
				for (y=[-1,1])
					translate ([carriage_pitch_x(rail_carriage(x_rail_type()))/2*x
						,carriage_pitch_y(rail_carriage(x_rail_type()))/2*y
						,carriage_height(rail_carriage(x_rail_type()))+screw-screw_in])
					rotate ([180,0,0])
					{
						report_m3_washer(screw);
						m3_screw(h=screw,cap_out=100);
					}
			}
		}
		for (x=[-1,1])
			translate ([10.5*x,screw_y,z1])
			translate_rotate (e3d_tr(0))
			rotate ([-90,0,0])
			{
				report_m3_washer_squarenut(screw1);
				m3_screw(h=screw1);
				m3_washer(out=40);
				
				translate ([0,0,screw1-2])
				rotate ([0,0,-90*x])
					m3_square_nut();
			}
		
		zz=[xcarriage_thickness()[3]-2.5-0.3,xcarriage_thickness()[3]+20+3.4];
		for (z=[0,1])
		for (x=[-1,1])
			translate ([(xcarriage_dim().x/2-5)*x,-0.2,0])
			translate ([xcarriage_dim().x/2,xcarriage_dim().y,zz[z]])
			translate_rotate (xcarriage_tr())
			rotate ([90,0,0])
			{
				if (z==0)
				{
					cso=0;//10;
					rotate ([0,0,-90])
						m3_screw(h=screw2[z],cap_side_out=cso);
					report_m3_washer_hexnut(screw2[z]);
					
					translate ([0,-0.2,screw2[z]-3])
					rotate ([0,0,180*z])
					hull()
					{
						m3_nut();
						translate ([0,10,0])
							m3_nut();
					}
				}
				else
				{
					m3_screw(h=screw2[z]);
					report_m3_washer_squarenut(screw2[z]);
					
					translate ([0,0,screw2[z]-3])
					rotate ([0,0,180*z])
						m3_square_nut(out=10);
				}
			}
			
		for (a=[0,1])	
			mirror ([a,0,0])
			{
				x_carriage_belt_fixer(op=1);
				x_carriage_belt_fixer(op=2);
			}
			
		if (part=="front")
		translate ([0,-0.01,0])
		translate_rotate(mtr)
			magnet_cut(magnet_d=x_magnet_d(),magnet_h=x_magnet_h(),getter=50);
	}
}

module xcarriage_cut(offs=0)
{
	dim=[70,60,200];
	translate([-dim.x/2,-dim.y-offs,-80])
	translate_rotate (e3d_tr(0))
		cube (dim);
}

module xcarriage_back_cut(offs=0)
{
	down=6;
	dim=[70,xcarriage_thickness()[2]-0.1+1,xcarriage_thickness()[3]+28+down-offs];
	translate([-dim.x/2,xcarriage_dim().y-dim.y+offs+1,-1-down])
	translate_rotate (xcarriage_tr())
		cube (dim);
}

module x_carriage_main()
{
	difference()
	{
		x_carriage(part="main",report=true);
		xcarriage_cut();
		xcarriage_back_cut();
	}
}

module x_carriage_back()
{
	intersection()
	{
		x_carriage(part="main");
		xcarriage_back_cut(offs=0.2);
	}
}

module x_carriage_front()
{
	intersection()
	{
		x_carriage(part="front");
		xcarriage_cut(offs=0.2);
	}
}

module x_carriage_fans(blower_screw_diameter=2.9)
{
	hh=20;
	sdiff=17.3*2;
	bsh=blower_screw_holes(e3d_blower_type());
	blower_corner_coords=[
		 [[0,0,-1],[0,0,0]]
		,[[40,0,-1],[0,0,90]]
		,[[40,40,-1],[0,0,180]]
		,[[0,40,-1],[0,0,-90]]
	];
	
	
	dim=5-0.2;
	dimcut=0.95;
	offs=0.46;
	points=polyRound([
		 [-offs+dimcut,-offs+dimcut,0]
		,[dim,-offs+dimcut,0]
		,[dim,dim,1.6]
		,[-offs+dimcut,dim,0]
	],20);
	
	difference()
	{
		union()
		{
			e3d_v6_fan_air_hull();
			tt=[e3d_blower_left_tr(0),e3d_blower_right_tr(0)];
			for (i=[0,1])
			{
				t=tt[i];
				for (cc=[2,3])
				{
					c=bsh[cc];
					translate_rotate (t)
					translate ([c.x,c.y,-hh])
					hull()
					{
						down=22.8;
						out=4;
						dd=blower_outer_fix_diameter;
						cylinder (d=dd,h=hh);
						
						xx=-out*((cc%2)*2-1);
						translate ([xx,0,0])
							cylinder (d=dd,h=hh);
						translate ([0,-down,0])
							cylinder (d=dd,h=hh);
						translate ([xx,-down,0])
							cylinder (d=dd,h=hh);
						translate ([-dd/2,dd/2-0.1,0])
							cube ([dd,0.1,hh]);					
					}
					translate_rotate (t)
					translate (blower_corner_coords[cc][0])
					rotate (blower_corner_coords[cc][1])
					linear_extrude(3)
						polygon(points);
				}
			}
		}
		e3d_v6_fan_cut(screws=true);
		e3d_v6_cut(out=50);
		hull()
		{
			e3d_v6_cut(maxc=0);
			translate ([0,-60,0])
				e3d_v6_cut(maxc=0);
		}
		
		for (t=[e3d_blower_left_tr(0),e3d_blower_right_tr(0)])
		{
			for (cc=[2,3])
			{
				c=bsh[cc];
				translate_rotate (t)
				translate ([c.x,c.y,-hh-1])
				{
					report_m2p5_screw(8);
					cylinder (d=blower_screw_diameter,h=hh+20);
				}
			}
		}
	}
}

module x_endstop_cut(offs=[0,0])
{
	translate ([-offs.x,offs.x,-offs.y])
	translate_rotate (x_endstop_tr())
		SS443A_cut2(x_SS443A_cut().x,x_SS443A_cut().y,[1,4,1]);
}

module x_endstop_block(report=false)
{
	endstop_block(tr=x_endstop_block_tr()
				,etr=x_endstop_tr()
				,bdim=x_endstop_block_dim()
				,m3_screw_height=10
				,ss443_out=20
				,report=report
	);
	translate_rotate (x_endstop_block_tr())
	translate([0,10,0])
	rotate ([90,0,90])
		slot_groove(height=x_endstop_block_dim().x,smooth=true);
}

module x_endstop()
{
	union()
	{
		difference()
		{
			x_endstop_block(report=true);
			x_endstop_cut(offs=[-0.1,0.01]);
		
			report_m5_point();
			translate_rotate (x_endstop_block_tr())
			translate ([x_endstop_block_dim().x-6.5,x_endstop_block_dim().y/2,5])
			rotate ([0,180,0])
				m5n_screw_washer(thickness=4, diff=2, washer_out=40);
		}
		translate_rotate (x_endstop_block_tr())
		translate ([x_endstop_block_dim().x-6.5,x_endstop_block_dim().y/2,5])
		rotate ([0,180,0])
			m5n_screw_washer_add();
	}
}

module x_endstop_lock()
{
	intersection()
	{
		x_endstop_block();
		x_endstop_cut(offs=[0.01,0.1]);
	}
}

yposition=-55;
xposition=55;

//proto_x();
//translate ([0,-y_rail_y(),0]) proto_xybelts(xposition=0,yposition=0);

//proto_x_blowers();
//x_carriage_fans();
//proto_front_slots();

//use <xymotorblock.scad>
//rightfront_motorblock();

//translate ([xposition,y_rail_y()+yposition,0])
{
	x_carriage_main();
	//x_carriage_front();
	
	//x_carriage_back();
	//x_carriage_belt_fixer_left();
	//x_carriage_belt_fixer_right();
}
//x_endstop();
//x_endstop_lock();

