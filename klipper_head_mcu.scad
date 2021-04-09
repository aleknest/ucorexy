use <../_utils_v2/m3-m8.scad>
use <../_utils_v2/fillet.scad>
use <../_utils_v2/_round/polyround.scad>
use <../_utils_v2/deb.scad>
use <configuration.scad>
use <proto.scad>
use <utils.scad>

part="";

oled_width=27.3;
oled_height=27.75;
screen_width=23;
screen_height=13.5;
thickness_slot=5;
back_shift=1;
a_angle=90-k_oled_encoder_angle();
zup=k_oled_encoder_dim().z-k_oled_encoder_dim().y/tan(k_oled_encoder_angle());
zreal=k_oled_encoder_dim().z-k_oled_encoder_cut();
ycut=tan(k_oled_encoder_angle())*k_oled_encoder_cut();
oe_tr=[[0,0,zup],[a_angle,0,0]];
oled_ptr=[oled_width/2+10,oled_height/2+12,-k_oled_encoder_thickness()];
encoder_ptr=[oled_ptr.x+35,oled_ptr.y,0];
slot_ptr=[0
			,k_oled_encoder_dim().y
			,zreal-thickness_slot-k_oled_encoder_wire_cut().y-k_oled_encoder_thickness()-20];
screw_offset=m3_cap_diameter()/2+1;
screw=16;
screw_coords=[
	 [[screw_offset,screw_offset,0],false,90]
	,[[k_oled_encoder_dim().x-screw_offset,screw_offset,0],false,-90]
	,[[k_oled_encoder_dim().x-screw_offset,k_oled_encoder_dim().y-screw_offset+20,0],true,0]
	,[[screw_offset,k_oled_encoder_dim().y-screw_offset+20,0],true,0]
];

screw_coords_nano_shift=[35.63,29.08];
screw_coords_nano=
[
	  [[32.95+screw_coords_nano_shift.x,-26.1+screw_coords_nano_shift.y,0]]
	, [[32.7+screw_coords_nano_shift.x,26.85+screw_coords_nano_shift.y,0]]
	, [[-16.6+screw_coords_nano_shift.x,27.05+screw_coords_nano_shift.y,0]]
	, [[-33+screw_coords_nano_shift.x,-26.5+screw_coords_nano_shift.y,0]]
];

function stand_tr(x,y)=[(oled_width/2-2.1-2.5/2)*x,(oled_height/2-2.1)*y-0.3,0];

module oled(op,thickness=3)
{
	screw=10;
	oled_screw_d=2.5+0.2;
	oled_stand=1.3+0.5;
	if (op==1)
	{
		translate ([-oled_width/2,-oled_height/2,0])
			cube ([oled_width,oled_height,thickness]);
		for (x=[-1,1])
			for (y=[-1,1])
				translate ([0,0,-oled_stand+0.01])
				translate (stand_tr(x,y))
					cylinder (d=oled_screw_d+0.8*2,h=oled_stand+0.02,$fn=40);
	}
	
	if (op==2)
	{
		translate ([0,1.5-0.5,0])
		translate ([-screen_width/2,-screen_height/2,0])
		{
			zz=2;
			out=3;
			translate ([0,0,-0.1])
				cube ([screen_width,screen_height,zz+0.2]);
			hull()
			{
				translate ([0,0,zz])
					cube ([screen_width,screen_height,0.01]);
				translate ([-out,-out,zz+out])
					cube ([screen_width+out*2,screen_height+out*2,0.01]);
			}
		}

		wire_width=14;
		wire_height=3;
		translate ([0,10,0])
		translate ([-wire_width/2,0,0])
		{
			translate ([0,0,-0.1])
				cube ([wire_width,wire_height,1.0]);
		}
	
		screw=10;
		for (x=[-1,1])
			for (y=[-1,1])
				translate (stand_tr(x,y))
				{
					translate ([0,0,-oled_stand])
						cylinder (d=oled_screw_d,h=screw+10,$fn=20);
					out=1.8;
					translate ([0,0,thickness-out])
						cylinder (d1=oled_screw_d,d2=oled_screw_d+out*2,h=out+0.01,$fn=20);
				}
	}
}

module encoder(op)
{
	hh=8-2;
	if (op==1)
	{
		dd=17;
		hull()
		{
			cylinder (d=dd,h=hh,$fn=80);
			translate ([-dd/2,dd/2,0])
				cube ([dd,0.1,hh]);
		}
	}
	translate ([0,0,-2])
	if (op==3)
	{
		translate ([0,0,4])
			cylinder (d=15,h=0.4,$fn=80);
	}
	if (op==2)
	{
		translate ([0,0,-0.1])
			cylinder (d=15,h=4.1,$fn=80);
		cylinder (d=7.5,h=10,$fn=80);
		
		cut=[2.5,1.01,1.1];
		rotate ([0,0,90])
		translate ([-cut.x/2,5.5,hh-cut.z+0.1])
			cube (cut);
	}
}

module base(offs=0,down=0)
{
	points=polyRound([
			 [0,-down,0]
			,[k_oled_encoder_dim().y+20,-down,0]
			,[k_oled_encoder_dim().y+20,slot_ptr.z+k_oled_encoder_thickness(),0]
			,[k_oled_encoder_dim().y-back_shift,slot_ptr.z+k_oled_encoder_thickness(),0]
			,[k_oled_encoder_dim().y-back_shift,zreal,0]
			,[k_oled_encoder_dim().y-ycut,zreal,0]
			,[0,zup,0]
		],20);
	translate ([offs,0,0])
	rotate ([90,0,90])
	{
		linear_extrude (k_oled_encoder_dim().x-offs*2)
		offset (delta=-offs)
			polygon (points);
	}		
}

module oled_encoder(report=false,bottom=false)
{
	if (report)
	{
		for (i=[0:3])
		{
			report_m2p5_screw_din (8,"DIN965");
			report_m2p5_hexnut ();
		}
		for (i=[0:3])
			report_m3(screw=6);
		deb(str("0.96 oled screen"));
		deb(str("Encoder module"));
	}
	
	difference()
	{
		union()
		{
			difference()
			{
				base();
				base(offs=k_oled_encoder_thickness(),down=0);
			}
			
			nano(op=3);
			
			translate (slot_ptr)
			{
				translate ([0,-back_shift,0])
					cube ([k_oled_encoder_dim().x,20+back_shift,thickness_slot]);
				translate ([0,10,thickness_slot])
				rotate ([90,0,90])
					slot_groove(height=k_oled_encoder_dim().x,enabled=true,big=true);
			}
			
			for (c=screw_coords)
				intersection()
				{
					dd=bottom?m3_cap_diameter()+1:m3_cap_diameter()+2;
					translate (c[0])
					translate ([-dd/2,-dd/2,0])
						cube ([dd,dd,k_oled_encoder_dim().z-0.01]);
					base();
				}
	
			translate_rotate (oe_tr)
			translate (oled_ptr)
				oled(op=1,thickness=k_oled_encoder_thickness());
			
			translate_rotate (oe_tr)
			translate (encoder_ptr)
			rotate ([0,180,0])
				encoder(op=1);
		}
		
		for (xx=[12,k_oled_encoder_dim().x-12])
		translate (slot_ptr)
		translate ([xx,0,0])
		{
			translate ([0,10,0])
			{
				if (report)
					report_m5_point();
				m5n_screw_washer(thickness=thickness_slot, diff=2, washer_out=8,tnut=true);
			}
		}
		
		for (c=screw_coords)
			translate (c[0])
			translate ([0,0,slot_ptr.z-screw+thickness_slot+0.01])
			{
				dd=3;
				sscrew=screw+1;
				translate ([0,0,-1])
					m3_screw(h=screw,cap_out=100);
				if (c[1])
				{
					add=0.5;
					translate ([0,0,screw-m3_nut_h()-add])
						m3_nut_inner(h=m3_nut_h()+add);
				}
				else
				{
					translate ([0,0,screw-m3_nut_h()])
					rotate ([0,0,c[2]])
						m3_square_nut();
				}
			}
	
		translate_rotate (oe_tr)
		translate (oled_ptr)
			oled(op=2,thickness=k_oled_encoder_thickness());
		translate_rotate (oe_tr)
		translate (encoder_ptr)
		rotate ([0,180,0])
			encoder(op=2);
		
		translate ([(k_oled_encoder_dim().x-k_oled_encoder_wire_cut().x)/2
					,k_oled_encoder_dim().y-k_oled_encoder_thickness()-1-0.1
					,zreal-k_oled_encoder_thickness()-k_oled_encoder_wire_cut().y-k_oled_encoder_wire_cut().z])	
			cube ([k_oled_encoder_wire_cut().x
					,k_oled_encoder_thickness()+0.2
					,k_oled_encoder_wire_cut().y+k_oled_encoder_wire_cut().z]);
		nano(op=2);
		if (bottom)
			nano(op=4);
	}
}
module oled_encoder_cut(offs)
{
	translate ([-1,-1+0.01,-1+offs])
		cube ([k_oled_encoder_dim().x+2
			,k_oled_encoder_dim().y+20+1
			,zreal-k_oled_encoder_wire_cut().y-20-thickness_slot-k_oled_encoder_thickness()+1]);
}
module k_oled_encoder_top()
{
	translate_rotate(k_oled_encoder_tr())
	difference()
	{
		oled_encoder(report=true,bottom=false);
		oled_encoder_cut(offs=0);
	}
}
module k_oled_encoder_bottom()
{
	translate_rotate(k_oled_encoder_tr())
	intersection()
	{
		oled_encoder(bottom=true);
		oled_encoder_cut(offs=-0.05);
	}
}

module nano(op)
{
	nano_dim=[71.8,58.2];
	nano_tr=[0,10,0];
	{
		if (op==1)
		{
			translate_rotate(k_oled_encoder_tr())
			translate (nano_tr)
			translate ([(k_oled_encoder_dim().x-nano_dim.x)/2,(k_oled_encoder_dim().y-nano_dim.y)/2,0])
			translate ([nano_dim.x,nano_dim.y,0])
			rotate ([0,0,180])
			color ("red")
			translate ([53.3,14.5,0])
			rotate ([90,0,0])
				import ("proto/cs_nano.stl");
		}
		up=3;
		if (op==2 || op==3)
		{
			dd=op==2?m3_screw_diameter():m3_screw_diameter()+3;
			gg=op==2?m3_nut_G():m3_nut_G()+4;
			hh=op==2?m3_nut_h():m3_nut_h()+1;
			offs=op==2?0.01:0;
			translate (nano_tr)
			translate ([(k_oled_encoder_dim().x-nano_dim.x)/2,(k_oled_encoder_dim().y-nano_dim.y)/2,0])
			translate ([nano_dim.x,nano_dim.y,0])
			rotate ([0,0,180])
			for (s=screw_coords_nano)
				translate (s[0])
				translate ([0,0,-offs])
				{
					cylinder (d=dd,h=k_oled_encoder_thickness()+up+offs*2,$fn=40);
					nut(G=gg,H=hh);
				}
		}
		if (op==4)
		{
			translate (nano_tr)
			translate ([(k_oled_encoder_dim().x-nano_dim.x)/2,(k_oled_encoder_dim().y-nano_dim.y)/2,0])
			translate ([nano_dim.x,nano_dim.y,0])
			rotate ([0,0,180])
				translate (screw_coords_nano[2][0])
				translate ([0,-5,14])
				rotate ([0,-90,0])
					cylinder (d=14,h=100,$fn=80);
			translate (nano_tr)
			translate ([(k_oled_encoder_dim().x-nano_dim.x)/2,(k_oled_encoder_dim().y-nano_dim.y)/2,0])
			translate ([nano_dim.x,nano_dim.y,0])
			rotate ([0,0,180])
				translate (screw_coords_nano[0][0])
				translate ([0,25,18])
					cube ([20,16,100]);
		}
	}
}

module k_proto_nano()
{
	nano(op=1);
}

//proto_front_slots();
//k_proto_nano();

k_oled_encoder_top();
//k_oled_encoder_bottom();