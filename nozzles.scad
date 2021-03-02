use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/sequental_hull.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/deb.scad>
use <utils.scad>
use <proto.scad>
use <configuration.scad>

include <../_utils_v2/NopSCADlib/core.scad>
include <../_utils_v2/NopSCADlib/vitamins/blower.scad>
include <../_utils_v2/NopSCADlib/vitamins/blowers.scad>

fix_thickness=2+2;
fix_out=2;
nozzle_in=2.2+2;
nozzle_out=2;
nozzle_thickness=0.8;
nozzle_offs=[0.6,0.2];

function up2points(arg,upcounter)=[
	for (i=[0:len(arg)-1]) i<upcounter?[arg[i].x,arg[i].y+1]:arg[i]
];
	
module blower_nozzle_cut(is_left,cut_nozzle,up_cut_nozzle,height)
{
	hh=14;
	up=1.4;
	dim=[20,hh,height+2];
	gr1=is_left?up_cut_nozzle:dim.y-up;
	gr2=!is_left?up_cut_nozzle:dim.y-up;
	translate ([-10,-hh,-1])
	{
		rotate ([90,0,90])
		linear_extrude(dim.x)
			polygon(polyRound([
				 [up_cut_nozzle,cut_nozzle,0]
				,[gr1,0,0]
				,[dim.y+40,0,0]
				,[dim.y+40,dim.z,0]
				,[gr2,dim.z,0]
				,[up_cut_nozzle,dim.z-cut_nozzle,0]
			],1));
	}
}

module blower_nozzle(is_left,figure,nozzle_cut,up_cut_nozzle,txt,cutboxy=0,cutboxz=0,cutboxrot=0,upcounter=0)
{
	nozzle_points=[
		 [5-nozzle_thickness-nozzle_offs.x,-nozzle_thickness-nozzle_offs.y-0.4]
		,[35+nozzle_thickness+nozzle_offs.x,-nozzle_thickness-nozzle_offs.y-0.4]
		,[35+nozzle_thickness+nozzle_offs.x,10+nozzle_thickness]
		,[5-nozzle_thickness-nozzle_offs.x,10+nozzle_thickness]
	];
		
	ee=30+nozzle_thickness*2+nozzle_offs.x*2;
	offs=0.5;
			
	difference()
	{
		union()
		{
			fix_points=polyRound([
				  [-1,-fix_out,1]
				, [4.9,-fix_out,0]
				, [4.9,4.9,1.5]
				, [-1,4.9,1]
			],20);
			
			for (m=[0,1])
				translate ([m==0?-offs:(40+offs)*m,0,0])
				mirror([m,0,0])
				{
					out=4.8;
					out2=5.4;
					translate([0,0,3-out2])
					linear_extrude(fix_thickness+out+out2)
						polygon(fix_points);
				}
			
			translate ([0,nozzle_in,0])
			rotate ([90,0,0])
			{
				difference()
				{
					union()
					{
						translate ([0,1,0])
						linear_extrude(nozzle_in+nozzle_out)
							polygon(nozzle_points);
						translate ([0,-1,0])
						linear_extrude(nozzle_in+nozzle_out)
							polygon(nozzle_points);
					}
					
					translate ([0,0,-1])
					linear_extrude(nozzle_in+2)
					offset (-nozzle_thickness)
						polygon(nozzle_points);				
				}
			}
					
			difference()
			{
				translate ([ee+5-nozzle_thickness-nozzle_offs.x,0,0])
				rotate ([90,0,-90])
				intersection()
				{
					linear_extrude (ee)
						polygon(up2points(arg=figure,upcounter=upcounter));
					blower_nozzle_cut(is_left,nozzle_cut,up_cut_nozzle,ee);
				}
			
				translate ([0,0,-2.4])
				{
					cube ([40,10,18]);
				}
				
				translate ([0,-5,-22.2-cutboxy])
				rotate ([37+cutboxrot,0,0])
				translate ([0,0,cutboxz])
					cube ([40,10,18]);
			}
		}

		for (m=[0,1])
			translate ([m==0?-offs:(40+offs)*m,0,0])
			mirror([m,0,0])
				translate([2.75,2.75,-3-0.2])
				{
					cylinder(d=m2p5_screw_diameter(),h=20,$fn=30);
					report_m2p5_screw(screw=16);
				}
		
		translate ([ee+5-nozzle_thickness*2-nozzle_offs.x,0,0])
		rotate ([90,0,-90])
		intersection()
		{
			linear_extrude (ee-nozzle_thickness*2)
			offset(-nozzle_thickness)
				polygon(figure);
			blower_nozzle_cut(is_left,nozzle_cut,up_cut_nozzle,ee-nozzle_thickness*2);
		}
		
		translate ([14,nozzle_in,0.3])
		rotate ([90,0,0])
		translate ([6,nozzle_points[2].y-0.2,0.7])
			rotate ([-90,0,0])
			linear_extrude(1)
				text(text=txt,font="Arial Black:Bold",size=5,valign="top",halign="center");
		
		translate ([-40,-0.2-0.4,1.8-0.4])
			cube ([100,20,1.2+0.4]);
	}
}

module blower_nozzle_(is_left)
{
	add1=8;
	figure=polyRound([
		  [-2,10+nozzle_thickness,0]
		, [2,10+nozzle_thickness,0]
		, [4,8,6]
		, [0+add1,-22,0]
	
		, [-2+add1,-22,0]
		, [-0.1,-nozzle_thickness-nozzle_offs.y*2,0]
		, [-2,-nozzle_thickness,0]
	],20);
	blower_nozzle(is_left=is_left
				,figure=figure
				,nozzle_cut=14
				,up_cut_nozzle=0
				,txt=""
				,cutboxy=-6
				,cutboxz=-10+2
				,cutboxrot=20
				,upcounter=18+20);
}
module blower_nozzle_left()
{
	translate_rotate (e3d_blower_left_tr(0))
		blower_nozzle_(true);
}
module blower_nozzle_right()
{
	translate_rotate (e3d_blower_right_tr(0))
		blower_nozzle_(false);
}

proto_x();
proto_x_blowers();

use <xcarriage.scad>
x_carriage_fans();

blower_nozzle_left();
blower_nozzle_right();

//translate ([-34,0,-60])
//#cube (14);