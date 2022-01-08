use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/deb.scad>
use <configuration.scad>
use <proto.scad>
use <utils.scad>

thickness_slot=5;

screw_coords_nano_shift=[35.63,29.08];
screw_coords_nano=
[
	  [[32.95+screw_coords_nano_shift.x,-26.1+screw_coords_nano_shift.y,0]]
	, [[32.7+screw_coords_nano_shift.x,26.85+screw_coords_nano_shift.y,0]]
	, [[-16.6+screw_coords_nano_shift.x,27.05+screw_coords_nano_shift.y,0]]
	, [[-33+screw_coords_nano_shift.x,-26.5+screw_coords_nano_shift.y,0]]
];


////////////
nano_dim=[71.8,58.2];
klipper_nano_offset=[5,11,3];

function klipper_nanobottom_dim()=[nano_dim.x+klipper_nano_offset.x*2
									,nano_dim.y+klipper_nano_offset.y*2+20
									,5];
function klipper_nanobottom_tr()=[vec_add(z_slot_topfront_tr()[0],[
	 nano_dim.x/2+klipper_nano_offset.x
	,-10-klipper_nano_offset[1]+klipper_nano_offset.y+20
	,-10-klipper_nanobottom_dim().z
	]),[0,0,180]];
	
function klipper_nano_tr()=[vec_add(z_slot_topfront_tr()[0],[
	 0
	,-10-klipper_nano_offset[1]-nano_dim.y
	,-10+klipper_nano_offset[2]
	]),[0,0,0]];

function klipper_nanobottom_fixes_tr()=tr_replace (klipper_nano_tr(),2,klipper_nanobottom_tr()[0].z);

function stand_tr(x,y)=[(oled_width/2-2.1-2.5/2)*x,(oled_height/2-2.1)*y-0.3,0];

function klipper_nanotop_thickness()=[2,2,2];
function klipper_nanotop_dim()=[klipper_nanobottom_dim().x
								,klipper_nanobottom_dim().y-20
									,30];
function klipper_nanotop_tr()=[vec_add(klipper_nanobottom_tr()[0],[
	 0
	,-20
	,klipper_nanobottom_dim().z
	]),[0,0,180]];

module klipper_proto_nano()
{
	translate_rotate(klipper_nano_tr())
	translate([-nano_dim.x/2,0,0])
	
	color ("red")
	translate ([53.3,14.5,-5.5])
	rotate ([90,0,0])
		import ("proto/cs_nano.stl");
}

module klipper_nano_fix(op)
{
	up=klipper_nanobottom_dim().z+klipper_nano_offset.z;
	if (op==2 || op==3)
	{
		dd=op==2?m3_screw_diameter():m3_screw_diameter()+3;
		gg=op==2?m3_nut_G():m3_nut_G()+4;
		hh=op==2?m3_nut_h():m3_nut_h()+1;
		offs=op==2?0.01:0;
		for (s=screw_coords_nano)
			translate (s[0])
			translate ([0,0,-offs])
			{
				cylinder (d=dd,h=up+offs*2,$fn=40);
				nut(G=gg,H=hh);
			}
	}
}

module klipper_nano_bottom()
{
	difference()
	{
		union()
		{
			translate_rotate(klipper_nanobottom_tr())
				cube(klipper_nanobottom_dim());
			
			translate_rotate(klipper_nanobottom_fixes_tr())
			translate([-nano_dim.x/2,0,0])
				klipper_nano_fix(op=3);
			
			translate ([0,-10,klipper_nanobottom_dim().z])
			translate_rotate(klipper_nanobottom_tr())
			rotate ([90,0,90])
				slot_groove(height=klipper_nanobottom_dim().x,enabled=true,big=true);
		}
		translate_rotate(klipper_nanobottom_fixes_tr())
		translate([-nano_dim.x/2,0,0])
			klipper_nano_fix(op=2);
		
		m5_offs=10;
		for (x=[-m5_offs,-klipper_nanobottom_dim().x+m5_offs])
			translate ([x,-10,0])
			translate_rotate(klipper_nanobottom_tr())
				m5n_screw_washer(thickness=thickness_slot, diff=2, washer_out=8,tnut=true);
		
		klipper_nanobody_fixes();
	}
}

module klipper_nanobody_fixes()
{
	screw=10;
	offs=[5.15,5];
	translate_rotate(klipper_nanotop_tr())
	{
		tt=klipper_nanotop_dim().z+klipper_nanotop_thickness().z;
		for (c=[
			 [[offs.x,offs.y,-3],[0,0,180]]
			,[[klipper_nanotop_dim().x-offs.x,offs.y,-3],[0,0,180]]
			,[[klipper_nanotop_dim().x-offs.x,klipper_nanotop_dim().y-offs.y,-3],[0,0,180]]
			,[[offs.x,klipper_nanotop_dim().y-offs.y,-3],[0,0,180]]
		
			,[[offs.x,offs.y,tt],[180,0,0]]
			,[[klipper_nanotop_dim().x-offs.x,offs.y,tt],[180,0,0]]
			,[[klipper_nanotop_dim().x-offs.x,klipper_nanotop_dim().y-offs.y,tt],[180,0,0]]
			,[[offs.x,klipper_nanotop_dim().y-offs.y,tt],[180,0,0]]
		])
		translate_rotate (c)
		{
			m3_screw(h=screw+10);
			translate ([0,0,screw-3])
				m3_square_nut(out=20);
		}
	}
}

module klipper_nano_middle()
{
	difference()
	{
		translate_rotate(klipper_nanotop_tr())
		union ()
		{		
			difference()
			{
				cube(klipper_nanotop_dim());
				translate ([klipper_nanotop_thickness().x,klipper_nanotop_thickness().y,-klipper_nanotop_thickness().z])
				cube([
					klipper_nanotop_dim().x-klipper_nanotop_thickness().x*2
					,klipper_nanotop_dim().y-klipper_nanotop_thickness().y*2
					,klipper_nanotop_dim().z+40
				]);
			}
			cubedim=[10,10,klipper_nanotop_dim().z];
			for (c=[
				 [0,0,0]
				,[klipper_nanotop_dim().x-cubedim.x,0,0]
				,[klipper_nanotop_dim().x-cubedim.x,klipper_nanotop_dim().y-cubedim.y,0]
				,[0,klipper_nanotop_dim().y-cubedim.y,0]
				])
				translate(c)
				cube (cubedim);
		}
		
		translate_rotate(klipper_nano_tr())
		translate([nano_dim.x/2,28,12])
			cube ([10,16,12]);
	
		translate_rotate(klipper_nano_tr())
		translate([-nano_dim.x/2,50.3,8.3])
		rotate ([0,-90,0])
		hull()
		{
			for (c=[0,-20])
				translate ([c,0,0])
				cylinder(d=16,h=40,$fn=100);
		}

		translate_rotate(klipper_nanotop_tr())
		difference()
		{
			offs=[20,5,10];
			translate ([offs.x,-0.01,klipper_nanotop_dim().z-offs.z])
			cube([klipper_nanotop_dim().x-offs.x*2
					,offs.y
					,klipper_nanotop_dim().z
			]);
		}
		klipper_nanobody_fixes();
	}
}

module klipper_nano_top()
{
	difference()
	{
		translate([0,0,klipper_nanotop_dim().z])
		translate_rotate(klipper_nanotop_tr())
		union()
		{
			cube([klipper_nanotop_dim().x,klipper_nanotop_dim().y,klipper_nanotop_thickness().z]);
			
			translate ([0,-5,0])
			translate ([klipper_nanotop_dim().x/2,klipper_nanotop_dim().y,0])
			rotate ([0,0,180])
			linear_extrude(klipper_nanotop_thickness().z+1)
				text (text="ucorexy",size=10,font="Free Sans:style=Bold",halign="center");
		}
		klipper_nanobody_fixes();
		
		translate([0,0,0])
		translate([0,0,klipper_nanotop_dim().z])
		translate_rotate(klipper_nanotop_tr())
		{
			offs=[10,12];
			xmax=9;
			ymax=7;
			dd=6;
			diff=dd+1;
			for (x=[0:xmax])
				for (y=[0:2:ymax])
					translate ([offs.x+x*diff,offs.y+y*diff,-1])
						rotate ([0,0,90])
							cylinder(d=6.6,h=10,$fn=6);
			for (x=[0:xmax-1])
				for (y=[1:2:ymax])
					translate ([offs.x+diff/2+x*diff,offs.y+y*diff,-1])
						rotate ([0,0,90])
							cylinder(d=6.6,h=10,$fn=6);
		}
		
	}
}


//proto_front_slots();
//klipper_proto_nano();
//klipper_nano_bottom();
//klipper_nano_middle();
klipper_nano_top();
