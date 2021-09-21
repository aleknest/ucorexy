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

include <../_utils_v2/NopSCADlib/vitamins/stepper_motors.scad>

e3d_v6_fan_screw=16;
e3d_v6_fan_border=5;
e3d_v6_cut_offset=0.2;
e3d_v6_cylinder_thickness=1.2;
e3d_cyl_corr=0.2;
e3d_v6_dim=[
	 [22.3,26-e3d_cyl_corr]
	,[16,42.7-3.7-6-26+e3d_cyl_corr]
	,[12,6]
	,[16,3.7]
	,[12,16]
];
e3d_v6_up=-39;
function e3d_v6_seq_(i) = i==0?e3d_v6_dim[i].y:e3d_v6_dim[i].y+e3d_v6_seq_(i-1);
function e3d_v6_seq(i) = i==0?0:e3d_v6_seq_(i-1);

x_cube_cut=[31.4,22];

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

module e3d_v6_cut(maxc=len(e3d_v6_dim)-1,maxc_diameter=0,out=0)
{
	dim=e3d_v6_dim[0];
	translate ([0,0,e3d_v6_up-e3d_v6_cut_offset-10])
	translate_rotate (e3d_tr(0))
		cylinder(d=dim.x+e3d_v6_cut_offset*2,h=dim.y+e3d_v6_cut_offset*2,$fn=80);
	for (i=[0:maxc])
	{
		dim=e3d_v6_dim[i];
		dd=(maxc_diameter>0 && i==maxc)?maxc_diameter:dim.x+e3d_v6_cut_offset*2;
		translate ([0,0,e3d_v6_seq(i)+e3d_v6_up-e3d_v6_cut_offset])
		translate_rotate (e3d_tr(0))
		hull()
		{
			cylinder(d=dd,h=dim.y+e3d_v6_cut_offset*2,$fn=80);
			translate ([0,-out,0])
				cylinder(d=dd,h=dim.y+e3d_v6_cut_offset*2,$fn=80);
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
				cylinder (d=2.9,h=e3d_v6_fan_screw+0.5,$fn=40);
				m3_screw(h=e3d_v6_fan_screw+0.1);
				
				yy=sign(y);
				xx=sign(x);
				//a=xx<0?0:180;
				a=xx<0?90:-90;
				translate ([0,0,e3d_v6_fan_screw-4])
				rotate ([0,0,a])
				hull()
				{
					report_m3_washer_squarenut(e3d_v6_fan_screw);
					m3_square_nut();
					/*
					report_m3_washer_hexnut(e3d_v6_fan_screw);
					m3_nut();
					translate ([-10,0,0])
						m3_nut();
					*/
				}
			}
}

module e3d_v6_fan_face(up=0)
{
	w=fan_width(e3d_fan_type());
	linear_extrude(0.1)
	polygon(polyRound([
		 [-w/2,-20,0]
		,[-w/2,20-up,0]
		,[w/2,20-up,0]
		,[w/2,-20,0]
	],20));
}

module e3d_v6_fan_air_hull(addy=0,addx=0)
{
	dim=e3d_v6_dim[0];
	dd=dim.x+e3d_v6_cut_offset*2;
	ddw=xcarriage_dim().x;
	//fillet(r=4,steps=16)
	{
		sequental_hull()
		{	
			translate_rotate (e3d_fan_tr(0))
			translate ([0,0,-5.5])
				e3d_v6_fan_face();
			
			translate_rotate (e3d_fan_tr(0))
			translate ([0,0,-5.5-e3d_v6_fan_border])
				e3d_v6_fan_face();

			translate_rotate (e3d_fan_tr(0))
			translate ([0,0,-19-e3d_v6_fan_border])
				e3d_v6_fan_face(up=13);
		}
		
		translate ([0,-e3d_fan_gr_in,e3d_v6_up])
		translate_rotate (e3d_tr(0))
		translate ([-ddw/2-addx,-dd/2-addy,0])
		intersection()
		{
			dim=[ddw+addx*2,dd+e3d_fan_gr+e3d_fan_gr_in+addy,dim.y+e3d_v6_cylinder_thickness+e3d_cyl_corr];
			cube (dim);
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
	offs=0.4;
	translate_rotate (x_rail_tr())
	{
		translate ([-x_rail()/2,-x_rail_type()[1]/2-offs,0])
			cube ([x_rail(),x_rail_type()[1]+offs*2,x_rail_type()[2]+offs]);
	}
	translate_rotate (x2_rail_tr())
	{
		translate ([-x_rail()/2,-x_rail_type()[1]/2-offs,0])
			cube ([x_rail(),x_rail_type()[1]+offs*2,x_rail_type()[2]+offs]);
	}
}

module x_cube(dim,addy)
{
	back_fan_fix=[4.5,1,1];
	back_fan_fix_up=2;
	front_fan_fix_up=2;
	
	translate ([dim.x,0,0])
	rotate ([0,-90,0])
	linear_extrude(dim.x)
		polygon (polyRound([
			[0,-e3d_tr_ycorr(),0]
			,[x_cube_cut[0],-e3d_tr_ycorr(),4]
	
			,[x_cube_cut[0],x_cube_cut[1],3.5]
			,[dim.z,x_cube_cut[1],4]
			,[dim.z,dim.y+addy,is_x2_rail()?15:2]
	
			,[0,dim.y+addy,0]
		],1));
}

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
		union()
		{
			difference()
			{
				union()
				{
					fillet(r=2,steps=8)
					{
						ioffs2=op==0?0-0.1:0;
	
						translate (tr)
						translate ([0,ioffs2,0])
						intersection()
						{
							translate([0,dim.y,0])
							rotate([90,0,0])
							linear_extrude(dim.y+ioffs2*2)
							polygon(polyRound([
								 [0,0,0]
								,[dim.x,0,1]
								,[dim.x,dim.z,1]
								,[0,dim.z,0]
							],20));
							linear_extrude(dim.z)
							polygon(polyRound([
								 [0,-ioffs2*2,0]
								,[dim.x,-ioffs2*2,1]
								,[dim.x,dim.y,1]
								,[0,dim.y,0]
							],20));
						}
						
						//8888888888
						ioffs=op==0?0:0.1;
						hull()
						{
							translate (vec_sub(tr2,[0,ioffs,ioffs2]))
								cube(vec_add(dim2,[0,ioffs*2,ioffs2*2]));
							translate (vec_sub(tr,[0,ioffs2,ioffs]))
								cube([dim2.x,dim.y+ioffs2*2,dim.z+ioffs*2]);
						}
					}
					if (op==0)
					{
						out_fix=[0.2,4,1,1.6];
						translate (tr)
						{
							for (z=[0,dim.z-out_fix[1]])
							translate ([0,0,z])
							linear_extrude(out_fix[1])
							polygon(polyRound([
								 [dim.x-out_fix[2]-out_fix[3]*2,0,0]
								,[dim.x-out_fix[2]-out_fix[3],-out_fix[0],0]
								,[dim.x-out_fix[2],0,0]
								,[dim.x-out_fix[2],dim.y,0]
								,[dim.x-out_fix[2]-out_fix[3],dim.y+out_fix[0],0]
								,[dim.x-out_fix[2]-out_fix[3]*2,dim.y,0]
							],20));					
						}
					}
				}
				if (op==0)
				{
					x_carriage_belt_fixer(op=2);
					
					trb=[-xcarriage_dim().x/2-offs,0,left_top_backpulley()[0].z];
					trt=[-xcarriage_dim().x/2-offs,0,left_bottom_backpulley()[0].z];
					//88888888
					belt_teeth=1.3;	
					
					translate (trb)
					translate ([-0.01,-0.5,0])
					rotate ([-90,0,-90])
					union()
					{
						difference()
						{
							belt(l=10,width_add=[0,10]);
							translate ([belt_teeth,0,0])
								belt(l=10,width_add=[0,10]);
						}
						
						translate ([-5.85,3,-1])
						{
							linear_extrude(20)
							polygon([
								 [5,0]
								,[10,6]
								,[0,6]
							]);
						}
					}
					translate (trt)
					translate ([-0.01,-0.5,0])
					rotate ([-90,0,-90])
					union()
					{
						difference()
						{
							belt(l=10,width_add=[10,0]);
							translate ([belt_teeth,0,0])
								belt(l=10,width_add=[10,0]);
						}
						translate ([-5.85,-3,-1])
						{
							linear_extrude(20)
							polygon([
								 [5,0]
								,[10,-6]
								,[0,-6]
							]);
						}
					}
				}
			}
			if (op==0)
			{
				x_carriage_belt_fixer(op=3);
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
	if (op==3)
	{
		translate (tr2)
		{
			offs=7;
			for (y=[-1,1])
				translate ([0,dim2.y/2+offs*y,dim2.z/2])
				rotate ([0,90,0])
				{
					translate ([0,0,m3_washer_thickness()])
						cylinder (d=m3_washer_diameter(),h=0.2,$fn=40);
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
	screw1=16+4;
	iz1=len(e3d_v6_dim)-3;
	zz1=[
		 e3d_v6_seq(iz1)+e3d_v6_up+e3d_v6_dim[iz1].y/2-1
		,e3d_v6_seq(iz1+2)+e3d_v6_up+e3d_v6_dim[iz1].y/2-1
	];
	screw_y=-6;
	mtr=[[xcarriage_tr()[0].x+xcarriage_dim().x/2-2
		,xcarriage_tr()[0].y-x_magnet_out()-e3d_tr_ycorr()
		,x_endstop_tr()[0].z]
		,[-90,0,0]];
	
	difference()
	{
		union()
		{
			fillet(r=0.6,steps=16)
			{
				addy=part=="back"?xcarriage_thickness()[4]:xcarriage_thickness()[5];
				translate_rotate (xcarriage_tr())
					x_cube(xcarriage_dim(),addy);
			
				translate_rotate(mtr)
					cylinder(d=x_magnet_d()+4,h=10);
			}
		
			for (z1=zz1)
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
		
		dd=10;
		sdim=[3,4];
		coord=[
			// [0,6+12.5,x_cube_cut[0]-sdim.y-6]
			//,[xcarriage_dim().x,6+12.5,x_cube_cut[0]-sdim.y-6]
			[xcarriage_dim().x-6,x_cube_cut[1],xcarriage_dim().z-19+2]
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
				cube ([20+1.4,20.6+add,200],true);
		}
		trs=[x_rail_tr(),x2_rail_tr()];
		for (tr=trs)
		translate_rotate (tr)
		{
			dim=[carriage_length(rail_carriage(x_rail_type()))+0.4
				,carriage_width(rail_carriage(x_rail_type()))+0.4
				,carriage_height(rail_carriage(x_rail_type()))+0.2];
			translate ([-dim.x/2,-dim.y/2,0])
				cube(dim);
			if (part=="main" || part=="back")
			{
				//screw=6+2;screw_in=3;
				screw=6;screw_in=2;

				for (x=[-1,1])
				for (y=[-1,1])
					translate ([carriage_pitch_x(rail_carriage(x_rail_type()))/2*x
						,carriage_pitch_y(rail_carriage(x_rail_type()))/2*y
						,carriage_height(rail_carriage(x_rail_type()))+screw-screw_in])
					rotate ([180,0,0])
					{
						report_m3_washer(screw);
						m3_screw(h=screw,cap_out=100);
						rotate ([180,0,0])
							cylinder (d=7+0.2*2,h=20,$fn=60);
					}
			}
		}
		for (z1=zz1)
		for (x=[-1,1])
			translate ([10.5*x,screw_y,z1])
			translate_rotate (e3d_tr(0))
			rotate ([-90,0,0])
			{
				report_m3_washer_squarenut(screw1);
				m3_screw(h=screw1);
				m3_washer(out=40);
				
				translate ([0,0,screw1-2-4])
				rotate ([0,0,-90*x])
					m3_square_nut();
			}
		
		screw2=[[16,is_x2_rail()?9:0],[8,is_x2_rail()?8:0]];
		zz=[xcarriage_thickness()[3]-2.8,xcarriage_thickness()[3]+23.4];
		for (z=[0,1])
		for (x=[-1,1])
			translate ([(xcarriage_dim().x/2-5)*x,-0.2+screw2[z][1],0])
			translate ([xcarriage_dim().x/2,xcarriage_dim().y,zz[z]])
			translate_rotate (xcarriage_tr())
			rotate ([90,0,0])
			{
				if (z==0)
				{
					cso=10;
					rotate ([0,0,-90])
						m3_screw(h=screw2[z][0]+screw2[z][1],cap_side_out=cso,cap_out=50);
					report_m3_washer_hexnut(screw2[z][0]+screw2[z][1]);
					
					translate ([0,-0.2,screw2[z][0]+screw2[z][1]-3])
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
					m3_screw(h=screw2[z][0]+screw2[z][1],cap_out=50);
					report_m3_washer_squarenut(screw2[z][0]+screw2[z][1]);
					
					translate ([0,0,screw2[z][0]+screw2[z][1]-3])
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
	//888888
	down=6;
	back=is_x2_rail()?5-5:0;
	dim=[70,xcarriage_thickness()[2]+xcarriage_thickness()[4]-0.1+1,xcarriage_thickness()[3]+28+down-offs];
	translate([-dim.x/2,xcarriage_dim().y-dim.y+xcarriage_thickness()[4]+offs+1,-1-down])
	translate_rotate (xcarriage_tr())
	{
		//cube (dim);
		translate ([0,0,dim.z])
		rotate ([0,90,0])
		linear_extrude(dim.x)
		polygon([
			 [0,back]
			,[dim.z/2,back]
			,[dim.z/2,0]
			,[dim.z,0]
			,[dim.z,dim.y]
			,[0,dim.y]
		]);
	}
}

module x_carriage_main_()
{
	difference()
	{
		x_carriage(part="main",report=true);
		xcarriage_cut();
		xcarriage_back_cut();
		adxl345(op=10+1);
	}
}

module x_carriage_back()
{
	intersection()
	{
		x_carriage(part="back");
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

module x_carriage_fan_spacer(blower_screw_diameter=2.9)
{
	dim=5-0.2;
	dimcut=0.95;
	offs=0.46;
	fan_points=polyRound([
		 [-offs+dimcut,-offs+dimcut,0]
		,[dim,-offs+dimcut,0]
		,[dim,dim,1.6]
		,[-offs+dimcut,dim,0]
	],20);
	bsh=blower_screw_holes(e3d_blower_type());
	blower_corner_coords=[
		 [[0,0,-1],[0,0,0]]
		,[[40,0,-1],[0,0,90]]
		,[[40,40,-1],[0,0,180]]
		,[[0,40,-1],[0,0,-90]]
	];

	cc=0;
	c=bsh[cc];
	
	difference()
	{
		translate (blower_corner_coords[cc][0])
		rotate (blower_corner_coords[cc][1])
		linear_extrude(3)
			polygon(fan_points);
		translate ([c.x,c.y,-10])
			cylinder (d=blower_screw_diameter+0.4,h=20);
	}
}

module x_carriage_fans(blower_screw_diameter=2.9)
{
	fix_th=2-0;
	fix_offs=0.1+0.1;
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
	fan_points=polyRound([
		 [-offs+dimcut,-offs+dimcut,0]
		,[dim,-offs+dimcut,0]
		,[dim,dim,1.6]
		,[-offs+dimcut,dim,0]
	],20);
	
	difference()
	{
		union()
		{
			e3d_v6_fan_air_hull(addy=fix_th,addx=1.2);
			tt=[e3d_blower_left_tr(0),e3d_blower_right_tr(0)];
			for (i=[0,1])
			{
				t=tt[i];
				for (cc=[2,3])
				{
					c=bsh[cc];
					translate_rotate (t)
					translate ([c.x,c.y,-hh])
					{
						down=22.8;
						out=4;
						dd=4.4;
						x=cc%2==0?-fix_th:-out;
						translate ([-dd/2+x,dd/2-down-dd,0])
							cube ([dd+out+fix_th,down+dd,hh]);
					}
					translate_rotate (t)
					translate (blower_corner_coords[cc][0])
					rotate (blower_corner_coords[cc][1])
					linear_extrude(3)
						polygon(fan_points);
					
					fix_z=-5;
					fix=2;
					fix_points=[
						[-2.2-fix_offs,-20]
						,[-2.2-fix_offs,10+fix_offs]
						,[fix-fix_th,10+fix_offs]
						,[fix-fix_th,10+fix_th]
						,[-2.2-fix_th,10+fix_th]
						,[-2.2-fix_th,-20]
					];
					translate_rotate (t)
					translate ([c.x,c.y+fix_z,-0.01])
					mirror([cc==3?1:0,0,0])
					rotate ([90,0,0])
					linear_extrude(25+fix_z)
						polygon(fix_points);
				}
			}
		}
		
		e3d_v6_fan_cut(screws=true);
		e3d_v6_cut(maxc=2,maxc_diameter=11+1,out=50);
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

module x_carriage_main()
{
	union()
	{
		translate ([0,0,0.1+0.01])
			x_carriage_fans(blower_screw_diameter=2.4);
		x_carriage_main_();
	}
}

module x_carriage_topbottomfix(report=false)
{
	screw=6;
	for (c=[[0,-17],[-9,-25],[9,-25]])
			translate ([c.x,c.y,20-1])
			translate_rotate (e3d_fan_tr(0))
			rotate ([90,0,0])
			{
				if (report)
					report_m3_washer_hexnut(screw);
				m3_screw(screw);
				m3_washer();
				translate ([0,0,screw-m3_nut_h()])
				rotate([0,0,90])
					m3_nut(h=m3_nut_h()+1);
			}
}

module x_carriage_top()
{
	difference()
	{
		x_carriage_main_();
		x_carriage_topbottomfix();
	}
}

module x_carriage_bottom()
{
	translate ([0,0,0.1+0.01])
	{
		difference()
		{
			x_carriage_fans(blower_screw_diameter=2.4);
			x_carriage_topbottomfix(report=true);
		}
	}
}

module adxl345(op=1)
{
	tr=[-24,-33+4,1.3];
	if (op==0)
	{
		color ("red") import ("proto/adxl345.stl");
	}
	if (op==1)
	{
		translate (tr)
		translate ([xcarriage_dim().x,xcarriage_dim().y,xcarriage_dim().z])
		translate_rotate (xcarriage_tr())
			adxl345(op=0);
	}


	screw=10;	
	c1=1.65+0.5;
	c2=19.8-c1;
	coord=[
		 [[c1,1.69,0],[0,0,0]]
		,[[c2,1.69,0],[0,0,0]]
		,[[c1+(c2-c1)/2,16.69+1-0.2-0.2,0],[0,0,0]]
	];
	
	if (op==5)
	{
		translate (tr)
		translate ([xcarriage_dim().x,xcarriage_dim().y,xcarriage_dim().z])
		translate_rotate (xcarriage_tr())
		for (c=coord)
			translate_rotate(c)
				rotate ([180,0,0])
				{
					m3_screw(h=screw+2);
					m3_washer(out=10);
				}
	}
	
	if (op==10)
	{
		report_adxl345();
		for (c=coord)
			translate_rotate(c)
				rotate ([180,0,0])
				{
					report_m3_washer(screw);
					report_m3_washer_squarenut(e3d_v6_fan_screw);
					
					m3_screw(h=screw+2);
					translate ([0,0,screw-2])
						m3_square_nut(out=50);
				}
		plate_h=1.25;
		translate ([0,0,-plate_h])
			cube ([20,15,plate_h]);
		cut_h=3;
		cut_w=2;
		cut_y=0.5;
		cut_x=0.0;
		translate ([0+cut_x,15-cut_w-cut_y,-cut_h])
			cube ([20-cut_x*2,cut_w,cut_h]);

	}
	if (op==11)
	{
		translate (tr)
		translate ([xcarriage_dim().x,xcarriage_dim().y,xcarriage_dim().z])
		translate_rotate (xcarriage_tr())
			adxl345(op=10);
	}
}

module proto_adxl345()
{
	adxl345(op=0+1);
}

ditan_motorplate_tr=[-10,-7.5,90-14.7];
ditan_tr=[ditan_motorplate_tr.x,ditan_motorplate_tr.y-13.0,ditan_motorplate_tr.z];
module ditan_plate()
{
	base_dim = [28,32,6];
	dim_nema=[NEMA_width(motor_type()),NEMA_width(motor_type()),feeder_nema_plate_thickness()];
	difference()
	{
		union()
		//fillet(r=3,steps=8)
		{
			translate ([xcarriage_dim().x,xcarriage_dim().y,xcarriage_dim().z])
			translate_rotate (xcarriage_tr())
			translate ([-base_dim.x,-base_dim.y-2,0])
				cube(base_dim);
			addy=ditan_motorplate_tr.z-69.15-4;
			translate (ditan_motorplate_tr)
			rotate ([-90,0,0])
			linear_extrude(dim_nema.z)
				polygon(polyRound([
					 [dim_nema.x/2,dim_nema.y/2+addy,0]
					,[-dim_nema.x/2,dim_nema.y/2+addy,3]
					,[-dim_nema.x/2,-dim_nema.y/2,3]
					,[dim_nema.x/2,-dim_nema.y/2,3]
				],1));
		}
	
		translate([0,0,1])
			adxl345(op=5);
		
		translate (ditan_motorplate_tr)
		translate ([0,dim_nema.z,0])
		rotate ([90,0,0])
			nema17_cut(washers=true
					,shaft=false
					,bighole=true
					,shaft_length=60
					,main_cyl=true
					,main_cyl_length=100
					,report=false
					,report_pulley=false);
	}	
}

yposition=-55;
xposition=55;


//proto_x();
//translate ([0,-y_rail_y(),0]) proto_xybelts(xposition=0,yposition=0);
//proto_x_blowers();
//x_carriage_fans();
//x_carriage_fan_spacer();
//proto_front_slots();
//proto_adxl345();

//proto_x_slot();

//translate ([xposition,y_rail_y()+yposition,0])
{
	//x_carriage_top();
	//x_carriage_bottom();
	//x_carriage_main();//obsolete

	//x_carriage_front();
	//x_carriage_back();

	include <../ucorexy_feeder/ditan/assembled.scad>
	translate (ditan_tr)
	rotate ([90,0,0])
	{
		//ditan("/home/aleknest/clouds/Dropbox/aleknest/3DPrinter/Modelling/ucorexy_feeder/ditan/");
	}
	//ditan_plate();
	
	x_carriage_belt_fixer_left();
	//x_carriage_belt_fixer_right();
}
//x_endstop();
//x_endstop_lock();

//adxl345(op=10+1);
