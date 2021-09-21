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
fix_out=6;
nozzle_in=2.2+2;
nozzle_out=2;
nozzle_thickness=0.8;
nozzle_offs=[0.6,0.2];

function up2points(arg,upcounter)=[
	for (i=[0:len(arg)-1]) i<upcounter?[arg[i].x,arg[i].y+1]:arg[i]
];
	
module blower_nozzle_cut(cut_nozzle,up_cut_nozzle,height,cut_nozzle_diff=0)
{
	hh=14;
	up=1.9;
	dim=[20,hh,height+2];
	translate ([-10,-hh,-1])
	{
		points=[
				 [up_cut_nozzle,cut_nozzle+cut_nozzle_diff,0]
				,[(dim.y-up)+cut_nozzle_diff,0,0]
				,[dim.y+40,0,0]
				,[dim.y+40,dim.z,0]
				,[up_cut_nozzle,dim.z,0]
			];
		rotate ([90,0,90])
		linear_extrude(dim.x)
			polygon(polyRound(points,1));
	}
}

function blower_nozzle_fix_points(up=0,in=0,r=0,upbody=0)=
			polyRound([
				  [-1,-fix_out+upbody,1]
				, [4.9+in,-fix_out+upbody,r]
				, [4.9+in,4.9+up,1.5]
				, [-1,4.9+up,1]
			],20);

module blower_nozzle(figure1
					,figure2
					,nozzle_cut
					,up_cut_nozzle
					,txt
					,cutboxy=0
					,cutboxz=0
					,cutboxrot=0
					,upcounter=0
					,upbody=0
					,txtmirror=[0,0,0]
		)
{
	nozzle_points=[
		 [5-nozzle_thickness-nozzle_offs.x,-nozzle_thickness-nozzle_offs.y-0.4]
		,[35+nozzle_thickness+nozzle_offs.x,-nozzle_thickness-nozzle_offs.y-0.4]
		,[35+nozzle_thickness+nozzle_offs.x,10+nozzle_thickness]
		,[5-nozzle_thickness-nozzle_offs.x,10+nozzle_thickness]
	];
		
	ee=30+nozzle_thickness*2+nozzle_offs.x*2;
	offs=0.5;
			
	nut_fix=[4,1,2,1.6];
	difference()
	{
		union()
		{
			for (m=[0,1])
				translate ([m==0?-offs:(40+offs)*m,0,0])
				mirror([m,0,0])
				{
					out=4.8;
					out2=5.4;
					translate([0,0,3-out2])
					{
						linear_extrude(fix_thickness+out+out2)
							polygon(blower_nozzle_fix_points(up=0,in=0,r=0,upbody=upbody));
						translate ([0,0,-nut_fix[0]+nut_fix[1]])
						linear_extrude(nut_fix[0])
							polygon(blower_nozzle_fix_points(up=nut_fix[2],in=nut_fix[3],r=1.5,upbody=upbody));
					}
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
						polygon(up2points(arg=figure1,upcounter=upcounter));
					blower_nozzle_cut(
						 cut_nozzle=nozzle_cut
						,up_cut_nozzle=up_cut_nozzle
						,height=ee);
				}
			
				translate ([0,0,-2.4])
				{
					cube ([40,10,18]);
				}
				
				translate ([0,-5,-22.2-cutboxy])
				rotate ([37+cutboxrot,0,0])
				translate ([0,-4,cutboxz])
					cube ([40,14,18]);
			}
		}

		for (m=[0,1])
			translate ([m==0?-offs:(40+offs)*m,0,0])
			mirror([m,0,0])
				translate([2.75,2.75,-2.5-nut_fix[0]+nut_fix[1]])
				{
					report_m2p5_screw(screw=16);
					
					cylinder(d=m2p5_screw_diameter(),h=20,$fn=30);
					translate ([0,0,10])
					rotate ([0,180,0])
						cylinder(d=3.5,h=20,$fn=30);
					m2p5_nut();
				}
		
		translate ([ee+5-nozzle_thickness*2-nozzle_offs.x,0,0])
		rotate ([90,0,-90])
		intersection()
		{
			linear_extrude (ee-nozzle_thickness*2)
			offset(-nozzle_thickness)
				polygon(figure2);
			diff=1;
			blower_nozzle_cut(
				 cut_nozzle=nozzle_cut
				,up_cut_nozzle=up_cut_nozzle
				,height=ee-nozzle_thickness*2
				,cut_nozzle_diff=diff
			);
		}
		
		translate ([14,nozzle_in,0.3])
		rotate ([90,0,0])
		translate ([6,nozzle_points[2].y-0.2,2.7])
			rotate ([-90,0,0])
			linear_extrude(1)
				mirror(txtmirror)
				text(text=txt,font="Arial Black:Bold",size=5,valign="top",halign="center");
		
		translate ([-40,-0.2-0.4,1.8-0.4])
			cube ([100,20,1.2+0.4]);
	}
}

function blower_nozzle_figure(corr=0,add1=9,upbody=0)=
	polyRound([
		  [-2,10+nozzle_thickness,0]
		, [6-upbody,10+nozzle_thickness,0]
		, [-3-upbody+add1,-10,0]
	
		, [-2+add1+corr,-22,0]
		, [-0.1,-nozzle_thickness-nozzle_offs.y*2,0]
		, [-2,-nozzle_thickness,0]
	],20);

module blower_nozzle_(txt="",txtmirror=[0,0,0],upbody=0)
{
	blower_nozzle(figure1=blower_nozzle_figure(upbody=upbody)
				,figure2=blower_nozzle_figure(corr=2,upbody=upbody)
				,nozzle_cut=14-10
				,up_cut_nozzle=5
				,txt=txt
				,cutboxy=-6.8
				,cutboxz=-6
				,cutboxrot=53
				,upcounter=38
				,upbody=upbody
				,txtmirror=txtmirror
		);
}

module blower_nozzle_left()
{
	translate_rotate (e3d_blower_left_tr(0))
	translate ([40,0,0])
	mirror([1,0,0])
		blower_nozzle_(txt="LEFT",txtmirror=[1,0,0]);
}
module blower_nozzle_right()
{
	translate_rotate (e3d_blower_right_tr(0))
		blower_nozzle_(txt="RIGHT",txtmirror=[0,0,0],upbody=0);
}

//proto_x();
//proto_x_blowers();

//use <xcarriage.scad>
//x_carriage_fans();

//blower_nozzle_left();
blower_nozzle_right();

//translate ([-34,0,-60])
//#cube (14);